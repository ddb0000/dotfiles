# TODO
## active
- [x] Waybar and Hyprland customization (reduce gaps, shortcuts for tiling/floating)

- [x] Add blur to windows

- [ ] Waybar customization (add night mode by default)
- [ ] Add night mode by default (system-wide dark mode)

- [ ] Add media player (ncmcpp, cava, etc.)

- [ ] Clean VM setup

- [ ] System cleanup and maintenance (scheduled garbage collection)

## backlog
- [ ] Review codebase for improvements
- [ ] Use nixpkgs.legacyPackages for explicit package management.
- [ ] Modularize home.nix (Hyprland, Waybar, program configs).
- [ ] Utilize Home Manager options where possible.
- [ ] Implement conditional configuration with lib.mkIf.
- [ ] Define variables for common paths/settings.
- [ ] Add error handling to exec-once commands.
- [ ] Implement secrets management (agenix, sops).
- [ ] Use hyprctl dispatch exec for application toggling.
