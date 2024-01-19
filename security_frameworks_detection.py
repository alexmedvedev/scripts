#!/usr/bin/env python3
import os

# Check if SELinux is enabled
selinux_config_path = '/etc/selinux/config'
if os.path.isfile(selinux_config_path):
    with open(selinux_config_path) as config_file:
        for line in config_file:
            if line.startswith('SELINUX='):
                selinux_status = line.split('=')[1].strip()
                if selinux_status in ['enforcing', 'permissive']:
                    print(f"SELinux is enabled and set to {selinux_status}.")
                else:
                    print("SELinux is installed but not enforcing or permissive.")
                break
        else:
            print("SELinux is not configured.")
else:
    print("SELinux is not installed or not configured.")

# Check if AppArmor is enabled
apparmor_path = '/sys/kernel/security/apparmor'
if os.path.isdir(apparmor_path):
    print("AppArmor is enabled.")

    # Check for active profiles
    try:
        with open('/proc/self/attr/current') as profile_file:
            apparmor_profile = profile_file.read().strip()
            print(f"Active AppArmor profile: {apparmor_profile}")
    except FileNotFoundError:
        print("No active AppArmor profile.")
else:
    print("AppArmor is not installed or not configured.")

