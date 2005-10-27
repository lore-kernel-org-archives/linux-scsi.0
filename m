From: Eric Edgar <rocket@gentoo.org>
Subject: slow external firewire drive
Date: Thu, 27 Oct 2005 01:56:55 +0000
Message-ID: <20051027015655.GC14010@toucan.gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([134.68.220.30]:54252 "EHLO smtp.gentoo.org")
	by vger.kernel.org with ESMTP id S932626AbVJ0B44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Oct 2005 21:56:56 -0400
Received: from rocket by smtp.gentoo.org with local (Exim 4.43)
	id 1EUx0h-00000a-V2
	for linux-scsi@vger.kernel.org; Thu, 27 Oct 2005 01:56:55 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,
  I am having trouble with an external firewire drive.  I have a texas
  instruments based card and a maxtor external enclosure.  Whenever I
  try to do anything with this disk the iowait goes through the roof and
  it can take half an hour or more to untar an 80mb file.  I am not sure
  if its something with my computer or the card or the enclosure.  Any
  help would be greatly appreciated.


hci1394: $Rev: 1313 $ Ben Collins <bcollins@debian.org>
PCI: Enabling device 0000:00:0c.0 (0014 -> 0016)
PCI: Found IRQ 11 for device 0000:00:0c.0
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=3D[11]  MMIO=3D[d9800000-d9800=
7ff]  Max
 Packet=3D[2048]
sbp2: $Rev: 1306 $ Ben Collins <bcollins@debian.org>
ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=3D1)
ieee1394: sbp2: Try serialize_io=3D0 for better performance


ieee1394: sbp2: Logged into SBP-2 device
ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
  Vendor: Maxtor    Model: 1394 storage      Rev: v1.3
  Type:   Direct-Access-RBC                  ANSI SCSI revision: 04
SCSI device sda: 156355584 512-byte hdwr sectors (80054 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 156355584 512-byte hdwr sectors (80054 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: sda1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 14


hdparm -tT /dev/sda

/dev/sda:
 Timing cached reads:   644 MB in  2.01 seconds =3D 320.40 MB/sec
 Timing buffered disk reads:    8 MB in  3.09 seconds =3D   2.59 MB/sec

uname -a=20
2.6.14-rc4
 =20
I dont seem to see any error messages ... just bad performance.

  Thanks in advance,
  Eric

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDYDPnG1H288hHbuMRAoBTAKC2nPgfHEVl7tN3MqoQX7c9d3HHcQCdHYeF
AFTeAgIOp6pgfAa4CZmZ58E=
=tq1u
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
