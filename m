From: Enver Haase <ehaase@inf.fu-berlin.de>
Subject: Bug in mounting a CDROM
Date: Thu, 31 Oct 2002 12:31:50 +0100 (MEZ)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10210311224220.760-100000@haneman.hacenet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org


Hallo,

as you know the kernel locks a CD-ROM drive's door when mounting it.
Having an unmountable medium still locks the door, so that nobody can ever
get that defective medium out.
I'm using Linux 2.4.19 with EIDE drives and the Pseudo-SCSI layer on top
of that.

$mount /cdrw
mount: Kein Medium gefunden

$umount /cdrw
umount: /cdrw is not mounted (according to mtab)

$mount /cdrw
mount: wrong fs type, bad option, bad superblock on /dev/cdrw,
       or too many mounted file systems

fstab:
/dev/cdrw         /cdrw       iso9660     ro,user 0 2

/dev:
lrwxrwxrwx   1 root     root            3 Aug 26  2000 /dev/cdrw -> sr1

"umount -f" doesn't work, either. And right "umount" is, the mtab
doesn't have a cdrw entry.

Greetings and thanks for your portion of Linux!
Enver


