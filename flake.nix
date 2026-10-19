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
          shfmt
          shellcheck
          nil
          bash-language-server
          vscode-langservers-extracted
          nixpkgs-fmt
          gopls
          gofumpt
          texlab
          marksman
        ];

        allTools = cliTools ++ lspServers;

        # Version der Config aus dem Git-Stand der Flake (":ConfigVersion", Startmenü)
        # dirtyShortRev = uncommittete Änderungen, lastModifiedDate = YYYYMMDDHHMMSS
        configRev = self.shortRev or self.dirtyShortRev or "unknown";
        configDate = let d = self.lastModifiedDate or "00000000"; in
          "${builtins.substring 0 4 d}-${builtins.substring 4 2 d}-${builtins.substring 6 2 d}";
        configVersion = "${configRev} ${configDate}";

        # Gemeinsame init für alle Varianten
        rc = ''
          let g:nix_managed = 1
          set runtimepath^=${./.}
          set runtimepath+=${./.}/after

          lua vim.g.nix_managed = true
          lua vim.g.config_version = "${configVersion}"
          lua dofile('${./.}/init.lua')
        '';

        myNeovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          viAlias = true;
          vimAlias = true;
          withPython3 = true;
          
          configure = {
            customRC = rc;
            
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
            withPython3 = true;
            
            configure = {
              customRC = rc;
            };
            
            extraMakeWrapperArgs = let
              minimalTools = cliTools ++ (with pkgs; [
                lua-language-server stylua
                rust-analyzer rustfmt
                clang-tools cmake-language-server
                python312Packages.python-lsp-server black ruff
                nil nixpkgs-fmt
                gopls gofumpt
                marksman
              ]);
            in
              "--prefix PATH : ${pkgs.lib.makeBinPath minimalTools}";
          };
          nix-only = pkgs.wrapNeovim pkgs.neovim-unwrapped {
            viAlias = true;
            vimAlias = true;
            withPython3 = true;
            
            configure = {
              customRC = rc;
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
            echo "🌳 Plugins & Treesitter: vim.pack"
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
