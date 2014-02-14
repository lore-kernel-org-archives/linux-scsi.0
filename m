From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: 3x check of "Caching mode page"
Date: Fri, 14 Feb 2014 17:01:08 +0100
Message-ID: <52FE3DC4.80809@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51310 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaBNQBM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 11:01:12 -0500
Received: from [192.168.178.21] ([85.177.117.64]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0MPUFR-1WACKy4ACX-004mmM for
 <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2014 17:01:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

I'm just wondering why it happens 3 times in a row :


=46eb 14 16:12:53 n22 kernel: usb 1-1.2: new high-speed USB device numb=
er 7 using ehci-pci
=46eb 14 16:12:53 n22 kernel: usb 1-1.2: New USB device found, idVendor=
=3D04b4, idProduct=3D6830
=46eb 14 16:12:53 n22 kernel: usb 1-1.2: New USB device strings: Mfr=3D=
56, Product=3D72, SerialNumber=3D91
=46eb 14 16:12:53 n22 kernel: usb 1-1.2: Product: Lacie Mobile Drive
=46eb 14 16:12:53 n22 kernel: usb 1-1.2: Manufacturer: Lacie Group. SA
=46eb 14 16:12:53 n22 kernel: usb 1-1.2: SerialNumber: DEF10D5E95F5
=46eb 14 16:12:53 n22 kernel: usb-storage 1-1.2:1.0: USB Mass Storage d=
evice detected
=46eb 14 16:12:53 n22 kernel: scsi9 : usb-storage 1-1.2:1.0
=46eb 14 16:12:54 n22 kernel: scsi 9:0:0:0: Direct-Access     SAMSUNG  =
HM160JC          0000 PQ: 0 ANSI: 0
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: Attached scsi generic sg3 typ=
e 0
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] 312581808 512-byte logi=
cal blocks: (160 GB/149 GiB)
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] Write Protect is off
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] Mode Sense: 27 00 00 00
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] No Caching mode page fo=
und
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] Assuming drive cache: w=
rite through
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] No Caching mode page fo=
und
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] Assuming drive cache: w=
rite through
=46eb 14 16:12:54 n22 kernel: sdc: sdc1
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] No Caching mode page fo=
und
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] Assuming drive cache: w=
rite through
=46eb 14 16:12:54 n22 kernel: sd 9:0:0:0: [sdc] Attached SCSI disk

- --=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlL+PcQACgkQxOrN3gB26U43VQD+Lhk1W1u2Mn7ppqI38i5jzFLT
i8NUkgjNx9Kz5EC/oPwA/iNdNIwnh8Gnpixd5E7W1ffXlJ8oWq9Wo1h8DZuNo6vF
=3D6C32
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
