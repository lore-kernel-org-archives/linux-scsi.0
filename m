From: Johnnie Peters <JPeters@JNI.com>
Subject: Alternate boot devices
Date: Fri, 27 Jun 2003 12:35:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7A19797C027A6D449D68329C2A094EA0010C06B4@MUSTANG>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [204.118.127.253] ([204.118.127.253]:57016 "EHLO
	mustang.jni.com") by vger.kernel.org with ESMTP id S264689AbTF0TVP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 15:21:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

I have managed to create a Red Hat 9.0 install drivers disk for the JNI
fibre
channel controller.  I have also created rpms for the driver to match each
of the posible
boot kernels that can be installed.

I am able to install with a fibre channel disk as the boot disk if I remove
all other
fibre channel disks from the system.  When the install completes I boot up
the
Red Hat rescue mode.  I then install the associated driver RPMS, create
initrd
images and fix the lilo.conf file the way it needs to be.  This includes
specifying
root=LABEL=/.  I then sent the bios on the JNI controller to boot from the
WWPN on the disk I want.

When I do this I can reattach all the other drives on the fabric and boot.
The system comes up
fine.  As I change the fabric layout during testing and reboot the root and
/boot partitions
migrate (sometimes root is sdc2 sometimes sdd2 and once with many disks I
have seen sdq2).

This all works fine until I want to run lilo again.  If I first remove all
the other drives
so the root disk is the only one in the system and reboot I can change the
lilo
parameters all I want (as long as they are correct) and rerun lilo, reattach
the
other drives and boot again.  Works great.

I have as many modification to the lilo.conf file as I seen to find docs
for.  Nothing
seems to work.  If I change the boot device to what seems to be the current
root
(if root is sdc2 the I set boot=/dev/sdc).  No matter what I try I always
only see the
first L in the LILO line when the system tries to boot from the fibre
channel device.
I do not get the numerical code that normally goes along with this error.

I have tried with and without linear and various other parameter changes.
Any
ideas I should try?

Johnnie

