From: "A. Zimmer" <andrew.zimmer@comcast.net>
Subject: DVD-RAM Mounts Read-Only and Can't Format
Date: Thu, 19 Feb 2009 13:49:55 -0500
Message-ID: <20090219134955.f0578e4c.andrew.zimmer@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:38418 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220AbZBSSt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2009 13:49:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Using the latest kernels, I've been having problems with DVD-RAM
disks being recognized as read-only disks.  When mounting, here
is what happens:

# mount -t udf -o rw,noatime /dev/scd0 /cd
mount: block device /dev/scd0 is write-protected, mounting read-only

When attempting to format, here is what happens:

# mke2fs -v -b 2048 -t ext2 -F /dev/scd0
/dev/scd0: Read-only file system while setting up superblock

Nothing untoward appears in the kernal log:

kernel: cdrom: sr0: mrw address space DMA selected
kernel: cdrom open: mrw_status 'not mrw'

After a search I discover that these problems were supposedly
fixed a long time ago by patching cdrom.c, but apparently the problem
still persists for some CD/DVD drives.

The relevant kernels are at least 2.6.24 and above.  I currently
use 2.6.28.

The DVD drives are Sanyo SH-S203 (SATA) and Plextor PX-750A (IDE).

Please CC to me because I am not subscribed to the list.

Andrew Zimmer

