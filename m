From: "Jim" <jim999@gmx.net>
Subject: =?ISO-8859-1?Q?Kernel_2.4.26_cannot_umount_CD:_device_or_resource_busy_(n?=
 =?ISO-8859-1?Q?o_fuser)?=
Date: Wed, 20 Jul 2005 01:58:06 +0200 (MEST)
Message-ID: <29775.1121817486@www15.gmx.net>
References: <29450.1121817356@www6.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:24241 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261721AbVGSX6H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2005 19:58:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Symptom: Cannot umount a CD-Rom in my CD-Roaster/Burner/Toaster whatever

Reason to write to ide AND Scsi-List: Its an IDE - Drive, but with
scsi-emulation running. So my 4 questions: WHY is the drive locked? And
HOW to work arround it other than to reboot the system? Can't a forced    
umount be implemented for other cases than just for NFS (as manpage 
sais)? Or is my system just too old and buggy? (because it is, besides from
updates)

And yes: It's more than once this happened:

# umount /mnt/toaster
umount: /mnt/toaster: device is busy
# fuser  -v -m /mnt/toaster/
# mount | grep toaster
/dev/scd0 on /mnt/toaster type iso9660 (ro,noexec,...)
# lsof | grep -e scd0 -e toaster
# umount /mnt/toaster
umount: /mnt/toaster: device is busy
# umount -f /mnt/toaster
umount2: Device or resource busy
umount: /dev/scd0: not mounted
umount: /mnt/toaster: Illegal seek
# umount /dev/scd0 || umount -f /dev/scd0
umount: /mnt/toaster: device is busy
umount2: Device or resource busy
umount: /dev/scd0: not mounted
umount: /mnt/toaster: Illegal seek
# umount -V
umount: mount-2.10m
# fuser -V
fuser from psmisc version 18
#


-- 
Greetings, Jim

-- 
Gruss, Jim
