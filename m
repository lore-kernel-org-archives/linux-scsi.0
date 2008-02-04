From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: LIO Target iSCSI/SE PS3-Linux / FC8 builds
Date: Mon, 04 Feb 2008 06:17:03 -0800
Message-ID: <1202134623.11265.524.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:47806 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751400AbYBDORc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 09:17:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geoff Levand <geoffrey.levand@am.sony.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, CBE-OSS-DEV <cbe-oss-dev@ozlabs.org>, linux-scsi <linux-scsi@vger.kernel.org>, Masaka

Greetings all,

I have updated the wiki at:

http://linux-iscsi.org/index.php/Playstation3/iSCSI

and posted the first LIO target builds on the LIO Cluster:

http://linux-iscsi.org/builds/ps3-linux/

I will adding the documentation for both LIO SE on PS3-Linux, and the
FC8 upgrade process, as the latter can still be a bit challenging for
new users.

Here is the info from the README:

LIO Target iSCSI/SE for PS3-Linux v2.9.0.209 

I) Kernel module package

iscsi-target-module-2.6.24-2.9.0.209-1.powerpc.rpm

This modules are built for ppc64 and built with the toolkit for Fedora Core 8 ppc.
This is gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)

This module has been tested with the latest ps3-linux.git and built against
arch/powerpc/configs/ps3_defconfig.  To use the BD-ROM, your 2.6.24 kernel
must contain ps3rom-use-128-max-sector.diff.  Please see:

http://git.kernel.org/?p=linux/kernel/git/geoff/ps3-linux.git;a=commit;h=e82112af66a39d11bcb484de9cfa45f0d214c97f

This module package should work with kernel-2.6.24-20080131.ppc64.rpm from
CELL-Linux-CL_20080201-ADDON.iso, but the BD-ROM will throw an exception without
ps3rom-use-128-max-sector.diff.  Please see the following link for more
information about the ADDON CD, and watch for an updated kernel package soon..

http://www.kernel.org/pub/linux/kernel/people/geoff/cell/

II) Userspace packages

iscsi-target-tools-2.9.0.209-1.ppc.rpm
sbe-mibs-2.9.0.209-1.ppc.rpm

Note that these are 32-bit and built on Fedora Core 8.

Have fun!

--nab

