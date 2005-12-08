From: "Ian P. Christian" <pookey@pookey.co.uk>
Subject: Strange problems with a Megaraid RAID array on a Dell Poweredge 1850
Date: Thu, 8 Dec 2005 01:18:11 +0000
Message-ID: <200512080118.17001.pookey@pookey.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2885473.HxdF4J0MMU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xian.ncuk.net ([80.249.110.212]:9651 "EHLO xian.ncuk.net")
	by vger.kernel.org with ESMTP id S932143AbVLHBSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2005 20:18:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--nextPart2885473.HxdF4J0MMU
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'm having an odd problem with a poweredge 1850, and it's driving me mad -=
=20
google's not helped me, I've tried a few mailing lists, and I've run out of=
=20
places to look, so any help would be greatly appreciated.

Basically, I can't use fdisk on /dev/sda.  I can however boot off this arra=
y,=20
and everything is working fine - I'm having no issues using this array for=
=20
anything else. A live, and apparently healthy system is running from it.

# fdisk -l
Unable to seek on /dev/sda

# sfdisk /dev/sda --no-reread
Disk /dev/sda: 35669 cylinders, 255 heads, 63 sectors/track
llseek: Bad file descriptor

sfdisk: seek error on /dev/sda - cannot seek to 0
 /dev/sda: unrecognized partition table type
Old situation:
No partitions found

The odd thing is, if I boot off a gentoo liveCD, everything's ok. =20

I've tried various kernel versions of the 2.6 series.=20
I've tried using config's found on google.
I've tried configuing a kernel from scratch countless times.
I've tried repartitioning and reinstalling from scratch.

last bit of juice out of my CPUs or anything silly like that.

make.conf
CHOST=3D"i686-pc-linux-gnu"
CFLAGS=3D"-march=3Dnocona -O2 -fomit-frame-pointer -fforce-addr -ftracer -p=
ipe"

The array is configured as a single RAID 5 array with 3 disks.

No dell software is installed yet.
No dell patches (if there are any?) have been applied to the kernel.
I've tried gentoo-sources, hardened-sources and standard kernel versions.

extra info:
 # zcat /proc/config.gz  | grep MEG
CONFIG_MEGARAID_NEWGEN=3Dy
CONFIG_MEGARAID_MM=3Dy
CONFIG_MEGARAID_MAILBOX=3Dy
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set

 # lspci | grep RAID
02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 4 (r=
ev=20
06)

Kind Regards,
=2D-=20
Ian P. Christian ~ http://pookey.co.uk

--nextPart2885473.HxdF4J0MMU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDl4nY6jsuvK/fgkoRAgHDAKChJB9z8qt/VFcU+kkLkkCT66zYKgCg3Olv
omjKArJOoSm55wUR1IWhaSg=
=tRul
-----END PGP SIGNATURE-----

--nextPart2885473.HxdF4J0MMU--
