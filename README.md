# dotfiles

### 🚀 Install / Setup

You have two primary ways to initialize your new setup: using the dedicated bootstrap script or directly running Ansible.

#### Method 1: Using Ansible Playbook (Recommended)

> **Prerequisite:** Ensure you have `ansible` installed.

1. Clone the repository:
   ```bash
   git clone https://github.com/rc0j/dotfiles.git ~/.dotfiles
   ```

2. Run the bootstrap playbook with a difference flag (`--diff`) to review changes before applying them:
   ```bash
   ansible-playbook --diff ~/.dotfiles/script/bootstrap.yml
   ```

#### Method 2: Using `bootstrap.sh`

This is the easiest way to get started, as it runs all necessary checks and symlinking logic in a single shell command.

```bash
# 1. Clone the repository
git clone https://github.com/rc0j/dotfiles.git ~/.dotfiles

# 2. Run the setup script
~/.dotfiles/script/bootstrap.sh
```

---

### ⚠️ Information & Warnings

When running either the script or the playbook, please be aware of the following behavior:

**Configuration Overwrite:**
The setup process includes a task that **removes any existing configuration files** before creating new symlinks. This ensures that you are starting with a clean slate defined by these dotfiles.

```yaml
# Example cleanup task executed during setup:
- name: Remove previous conf
  ansible.builtin.file:
    path:
      - ~/.zshrc
      - ~/.tmux.conf
      - ~/.local/bin
    state: absent
```

**🛡️ Backup Warning:**
***Please make sure to back up any manually customized configuration files before running the installation script or playbook.***

---

### 📂 Contents

#### `bin`
No custom scripts added yet.