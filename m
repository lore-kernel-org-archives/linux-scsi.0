From: eerov@welho.com
Subject: old Vtrack 15100 problems
Date: Thu, 30 Oct 2008 09:40:36 +0200
Message-ID: <20081030094036.yge05ix9sswoosos@webmail.welho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60935 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYJ3Hkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 03:40:37 -0400
Received: from localhost (webmail.welho.com [213.243.153.134])
	by smtp6.pp.htv.fi (Postfix) with ESMTP id 5DDC35BC01B
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 09:40:36 +0200 (EET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I have mysterius problems with old promise Vtrack 15100 sata disk raid array.

Size of array is about 7TB, but I can only access half of it?

System is: Linux linux-o0ze 2.6.25.5-1.1-pae #1 SMP 2008-06-07  
01:55:22 +0200 i686 i686 i386 GNU/Linux (opensuse)


Disk /dev/sdb: 1499.9 GB, 1499985084416 bytes
255 heads, 63 sectors/track, 91181 cylinders
Units = cylinders of 16065 * 1024 = 16450560 bytes
Disk identifier: 0x560654c5

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       91181  1464822702   83  Linux
Note: sector size is 1024 (not 512)

Disk /dev/sdc: 1499.9 GB, 1499985084416 bytes
255 heads, 63 sectors/track, 91181 cylinders
Units = cylinders of 16065 * 1024 = 16450560 bytes
Disk identifier: 0xfef607bd

    Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       91181  1464822702   8e  Linux LVM
Note: sector size is 1024 (not 512)

Disk /dev/sdd: 886.9 GB, 886980476928 bytes
255 heads, 63 sectors/track, 53917 cylinders
Units = cylinders of 16065 * 1024 = 16450560 bytes
Disk identifier: 0x960ffbfc

    Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       53917   866176542   83  Linux
Note: sector size is 1024 (not 512)

Disk /dev/sde: 1499.9 GB, 1499985084416 bytes
255 heads, 63 sectors/track, 91181 cylinders
Units = cylinders of 16065 * 1024 = 16450560 bytes
Disk identifier: 0x560654c5

    Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1       91181  1464822702   83  Linux
Note: sector size is 1024 (not 512)

Disk /dev/sdf: 1499.9 GB, 1499985084416 bytes
255 heads, 63 sectors/track, 91181 cylinders
Units = cylinders of 16065 * 1024 = 16450560 bytes
Disk identifier: 0xfef607bd

    Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1       91181  1464822702   8e  Linux LVM
Note: sector size is 1024 (not 512)

Disk /dev/sdg: 886.9 GB, 886980476928 bytes
255 heads, 63 sectors/track, 53917 cylinders
Units = cylinders of 16065 * 1024 = 16450560 bytes
Disk identifier: 0x960ffbfc

    Device Boot      Start         End      Blocks   Id  System
/dev/sdg1               1       53917   866176542   83  Linux

Fdisk -l shows this and looks like disk are some ways of duplicate,
because there are same disk identified twice.

Anyway, due to 1024 (not 512), I cannot access all of the space?
For example parted says:

Warning: Device /dev/sdb has a logical sector size of 1024.  Not all  
parts of GNU Parted support this at the moment, and the working code  
is HIGHLY EXPERIMENTAL.

GNU Parted 1.8.8
Using /dev/sdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) print
Error: Can't have a partition outside the disk!
(parted)

How I can partition or access the full diskspace? Any clues?

thanks,
Eero




