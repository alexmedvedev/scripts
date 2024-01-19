#!/bin/bash

# Check if SELinux is enabled
if [ -f /etc/selinux/config ]; then
    selinux_status=$(awk -F= '/^SELINUX=/{print $2}' /etc/selinux/config)
    
    if [ "$selinux_status" == "enforcing" ] || [ "$selinux_status" == "permissive" ]; then
        echo "SELinux is enabled and set to $selinux_status."
    else
        echo "SELinux is installed but not enforcing or permissive."
    fi
else
    echo "SELinux is not installed or not configured."
fi

# Check if AppArmor is enabled
if [ -d /sys/kernel/security/apparmor ]; then
    echo "AppArmor is enabled."

    # Check for active profiles
    if command -v aa-status &> /dev/null; then
        active_profiles=$(sudo aa-status --verbose | awk '/^Profile: /{print $2}')
        if [ -n "$active_profiles" ]; then
            echo "Active AppArmor profiles:"
            echo "$active_profiles"
        else
            echo "No active AppArmor profiles."
        fi
    else
        echo "AppArmor tools (aa-status) not found. Unable to check active profiles."
    fi
else
    echo "AppArmor is not installed or not configured."
fi

