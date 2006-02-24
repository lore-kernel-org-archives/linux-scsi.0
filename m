From: "aziro aziroff" <aziro.linux.adm@gmail.com>
Subject: [JNI FCE-3210-C 32-bit PCI-to-Fibre Channel HBA]Driver for linux kernel 2.4 and/or 2.6?
Date: Fri, 24 Feb 2006 11:57:45 +0200
Message-ID: <f30adcc00602240157w7104c598qe7fffa2dcbee6105@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.194]:47157 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932115AbWBXJ5w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 04:57:52 -0500
Received: by nproxy.gmail.com with SMTP id a25so235609nfc
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2006 01:57:46 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Linux Folk,
I looking for linux driver for one old JNI Fibre Channel (FC) host bus =
adapter
model: FCE-3210 "32-bit" PCI-to-Fibre Channel HBA (1999/2000).
I ask google and nothing about driver donload link, just comment and
broken links:)
http://www.exquip.com/products/storage/hostbusadapters.php?view=3D250

I read that Red Hat Linux 6.0, 6.1 support JNI FCE-3210, but no
information about kernels 2.4 and 2.6?!

=46rom manifacturer docs "Installation Guide for FCE-3210":

>Linux Drivers
>Follow the instructions appropriate for your system: single or dual pr=
ocessor.
>Single Processor Systems
>1. Install Linux and shutdown the system.
>2. Add the JNI HBAs and boot the system.
>3. Download the Linux driver jnifc.o file from the JNI Web site (www.j=
ni.com).
>4. Copy the jnifc.o to any Linux directory.
>5. Run insmod jnifc.o then check the messages file /var/log/messages
for map drive
>information.
>Note =96 You must have a good link to storage or a loopback before
running the insmod >command;
>otherwise, the machine will hang.
>6. To mount the device, invoke a mount command.
>7. Before removing the JNI Linux driver, use a umount command to
un-mount the device.
>8. Type the command cat /proc/modules to show all loaded driver
modules, and run rmmod
>jnifc to remove the Linux driver.
>Dual Processor Systems
>1. Install Linux and shut down the system.
>2. Add the JNI HBAs and boot the system.
>3. Download the Linux driver jnifc_smp.o file from the JNI Web site
(www.jni.com).
>4. Copy the jnifc_smp.o to any Linux directory.
>5. Run insmod jnifc_smp.o then check the messages file
/var/log/messages for map drive
>information.
>Note =96 You must have a good link to storage or a loopback before
running the insmod >command;
>otherwise, the machine will hang.
>6. To mount the device, invoke a mount command.
>7. Before removing the JNI Linux driver, use a umount command to
un-mount the device
>8. Type the command cat /proc/modules to show all loaded driver
modules, and run rmmod
>jnifc_smp to remove the Linux driver.
>For more information
>See the readme file on the JNI Web site (www.jni.com) for the latest
information on driver
>configuration.

I ask JNI tech support, but they don't support Linux with this
=46CE-3210 HBA yet. Support is for Solaris, AIX,HP-UX,Windows, but not
Linux!

=46ollk, if You can't help with driver for FCE-3210 kernel 2.4 and/or
2.6 nobody can!

Any help will be very welcome!

George
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
