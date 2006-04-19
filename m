From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: aacraid on Poweredge 2650 ()
Date: Wed, 19 Apr 2006 16:55:18 +0200
Message-ID: <200604191655.43350.avbidder@fortytwo.ch>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1962928.MFVozgZxV1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zbasel.fortytwo.ch ([193.138.215.60]:9198 "EHLO
	zbasel.fortytwo.ch") by vger.kernel.org with ESMTP id S1750828AbWDSO4W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 10:56:22 -0400
Received: from dyn13.mybuehl.ch (62-2-188-106.business.cablecom.ch [62.2.188.106])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by zbasel.fortytwo.ch (Postfix) with ESMTP id 69AAA6B
	for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2006 16:56:03 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--nextPart1962928.MFVozgZxV1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Yo!

Running a Dell Poweredge 2650, I run into a stability problem triggered by=
=20
lots of disk activity (sometimes just tarring the whole filesystem for=20
backup or creating a new chroot would suffice, sometimes hundreds of GB of=
=20
filetransfers were necessary)

This was with Debian stable (2.6.8 kernel), and with what appeared to be a=
=20
half-buggy disk and a (ecc-correctable) faulty memory.   Now, with replaced=
=20
hardware and with the 2.6.15 kernel (aac 1.1-4), things seem to be better. =
=20
(replacing the hardware alone didn't help, so it seemed to be a driver=20
problem.)=20

A quick test, moving a few 100G and a few 1000 files, couldn't reproduce th=
e=20
issue, but still: are there known stability problems with that driver=20
version?  Is there a changelog of the aacraid driver somewhere?

thanks in advance
=2D- vbi

relevant kernel messages afaict:
=3D=3D=3D
Adaptec aacraid driver (1.1-4 Mar  7 2006 02:24:50)
AAC0: kernel 2.7-1[3170]
AAC0: monitor 2.7-1[3170]
AAC0: bios 2.7-1[3170]
AAC0: serial d15810d3
scsi0 : percraid
  Vendor: DELL      Model: 3 discs and HS    Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 142183296 512-byte hdwr sectors (72798 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
SCSI device sda: 142183296 512-byte hdwr sectors (72798 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 0:0:0:0: Attached scsi removable disk sda
=3D=3D=3D

lspci output
=3D=3D=3D
0000:04:08.1 RAID bus controller: Dell PowerEdge Expandable RAID Controller=
=20
3/Di (rev 01)
        Subsystem: Dell: Unknown device 0121
        Flags: bus master, 66MHz, slow devsel, latency 32, IRQ 185
        Memory at f0000000 (32-bit, prefetchable) [size=3D128M]
        Expansion ROM at fcb00000 [disabled] [size=3D64K]
        Capabilities: [80] Power Management version 2

0000:05:06.0 SCSI storage controller: Adaptec RAID subsystem HBA (rev 01)
        Subsystem: Dell PowerEdge 2400,2500,2550,4400
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 7
        BIST result: 00
        I/O ports at cc00 [size=3D256]
        Memory at fccff000 (64-bit, non-prefetchable) [size=3D4K]
        Expansion ROM at fcd00000 [disabled] [size=3D128K]
        Capabilities: [dc] Power Management version 2

0000:05:06.1 SCSI storage controller: Adaptec RAID subsystem HBA (rev 01)
        Subsystem: Dell PowerEdge 2400,2500,2550,4400
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 11
        BIST result: 00
        I/O ports at c800 [size=3D256]
        Memory at fccfe000 (64-bit, non-prefetchable) [size=3D4K]
        Expansion ROM at f8100000 [disabled] [size=3D128K]
        Capabilities: [dc] Power Management version 2
=3D=3D=3D

=2D-=20
Life is fraught with opportunities to keep your mouth shut.

--nextPart1962928.MFVozgZxV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAkRGT29gGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l66YYAoJMS9MTdtZf/7ZnNMSTUwxDz
ZAMmAJ41elrggx1M/avZO66HKOi8F2rboA==
=rL/o
-----END PGP SIGNATURE-----

--nextPart1962928.MFVozgZxV1--
