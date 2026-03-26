{
  description = "Jonas's Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # CLI Tools
        cliTools = with pkgs; [
          ripgrep
          fzf
          lazygit
          git
          curl
          wget
          unzip
          gcc
          gnumake
          tree-sitter
          nodejs
        ];

        # Alle LSP Server
        lspServers = with pkgs; [
          lua-language-server
          stylua
          rust-analyzer
          rustfmt
          clang-tools
          cmake-language-server
          python312Packages.python-lsp-server
          black
          ruff
          dockerfile-language-server
          nodePackages.bash-language-server
          shfmt
          shellcheck
          nil
          nixd
          nixpkgs-fmt
          gopls
          gofumpt
          texlab
          nodePackages.vscode-langservers-extracted
          marksman
        ];

        allTools = cliTools ++ lspServers;

        myNeovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          viAlias = true;
          vimAlias = true;
          withNodeJs = true;
          withPython3 = true;
          
          configure = {
            customRC = ''
              let g:nix_managed = 1
              set runtimepath^=${./.}
              set runtimepath+=${./.}/after
              
              lua vim.g.nix_managed = true
              lua dofile('${./.}/init.lua')
            '';
            
            # ENTFERNT: Kein Treesitter hier mehr
            # packages.myPlugins = ...
          };
          
          extraMakeWrapperArgs = 
            "--prefix PATH : ${pkgs.lib.makeBinPath allTools} " +
            "--set NVIM_FLAKE 1";
        };

      in {
        packages = {
          default = myNeovim;
          
          minimal = pkgs.wrapNeovim pkgs.neovim-unwrapped {
            viAlias = true;
            vimAlias = true;
            withNodeJs = true;
            withPython3 = true;
            
            configure = {
              customRC = ''
                let g:nix_managed = 1
                set runtimepath^=${./.}
                set runtimepath+=${./.}/after
                
                lua vim.g.nix_managed = true
                lua dofile('${./.}/init.lua')
              '';
            };
            
            extraMakeWrapperArgs = let
              minimalTools = cliTools ++ (with pkgs; [
                lua-language-server stylua
                rust-analyzer rustfmt
                clang-tools cmake-language-server
                python312Packages.python-lsp-server black ruff
                nodePackages.bash-language-server shfmt shellcheck
                nil nixpkgs-fmt
                gopls gofumpt
                nodePackages.vscode-langservers-extracted
                marksman
              ]);
            in
              "--prefix PATH : ${pkgs.lib.makeBinPath minimalTools}";
          };
          nix-only = pkgs.wrapNeovim pkgs.neovim-unwrapped {
            viAlias = true;
            vimAlias = true;
            withNodeJs = true;
            withPython3 = true;
            
            configure = {
              customRC = ''
                let g:nix_managed = 1
                set runtimepath^=${./.}
                set runtimepath+=${./.}/after
                
                lua vim.g.nix_managed = true
                lua dofile('${./.}/init.lua')
              '';
            };
            
            extraMakeWrapperArgs = 
              "--prefix PATH : ${pkgs.lib.makeBinPath (cliTools ++ [pkgs.nil])}";
          };
        };

        apps.default = {
          type = "app";
          program = "${myNeovim}/bin/nvim";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ myNeovim ] ++ allTools;
          
          shellHook = ''
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🚀 Neovim mit Nix-managed LSPs"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "📦 LSP Server verfügbar:"
            echo "  ✓ lua_ls, rust_analyzer, clangd"
            echo "  ✓ pylsp, dockerls, cmake, bashls"
            echo "  ✓ nil (Nix), gopls, texlab"
            echo "  ✓ jsonls, html, marksman"
            echo ""
            echo "🌳 Treesitter: Wird von lazy.nvim verwaltet"
            echo "🔧 Tools: ripgrep, fzf, lazygit"
            echo ""
            echo "Starte: nvim"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          '';
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
