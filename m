From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: 2.6.15 and up: LSI1030 boot problems..
Date: Tue, 24 Jan 2006 08:05:44 +0100
Message-ID: <43D5D1C8.5060403@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC99285222EC2EE9236A802C5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:29328 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S964966AbWAXHFx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 02:05:53 -0500
Received: from [128.130.71.3] (ilfb02.ilsb.tuwien.ac.at [128.130.71.3])
	by gh-gw1.ilsb.tuwien.ac.at (8.13.3/8.13.3/Debian-6) with ESMTP id k0O75o41024340
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 08:05:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC99285222EC2EE9236A802C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


Hardware: Dual AthlonMP
          Onboard LSI 1030 (system running for years w/ various
          kernels..)

Output from a 2.4.29 kernel:

Fusion MPT base driver 2.05.16
Copyright (c) 1999-2004 LSI Logic Corporation
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities={Initiator}
mptbase: 2 MPT adapters found, 2 installed.
Fusion MPT SCSI Host driver 2.05.16
scsi0 : ioc0: LSI53C1030, FwRev=01000000h, Ports=1, MaxQ=255, IRQ=17
scsi1 : ioc1: LSI53C1030, FwRev=01000000h, Ports=1, MaxQ=255, IRQ=18
blk: queue f7bbca18, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
  Vendor: SEAGATE   Model: ULTRIUM06242-XXX  Rev: 1528
  Type:   Sequential-Access                  ANSI SCSI revision: 03
blk: queue f7bbc818, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
  Vendor: SEAGATE   Model: VIPER 2000        Rev: 0125
  Type:   Medium Changer                     ANSI SCSI revision: 02
blk: queue f7bbc618, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
  Vendor: SEAGATE   Model: ST373207LW        Rev: 0003
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7bbc218, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
  Vendor: SEAGATE   Model: ST373207LW        Rev: 0003
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7b3ee18, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
st: Version 20040102, bufsize 32768, max init. bufs 4, s/g segs 16
Attached scsi tape st0 at scsi0, channel 0, id 6, lun 0
Attached scsi generic sg1 at scsi0, channel 0, id 6, lun 1,  type 8
Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
SCSI device sda: 143374744 512-byte hdwr sectors (73408 MB)
Partition check:
 sda: sda1 sda2 sda3
SCSI device sdb: 143374744 512-byte hdwr sectors (73408 MB)
 sdb: sdb1 sdb2

Running up to 2.6.14preXX (didn't test every kernel)

When booting 2.6.15 and 2.6.16pre1 I get: (written down, no logfile)

sd 1:0:0:0
   command: Write (10): 2a 00 01 f8 11 e7 00 00 08 00
mptbase: ioc1: IOCStatus(0x0048): SCSI Task Terminated
mptscsih: ioc1: task abort: SUCCESS (sc=f6c5d8e0)
mptscsih: ioc: attempting task abort! (sc=f6c5e900)

..many times, till I press the reset button.

Any ideas?

                                          GS

P.S.: More info available on request (what?)
-- 
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29     http://www.ilsb.tuwien.ac.at/~gs/

--------------enigC99285222EC2EE9236A802C5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD1dHME6e53f4wQG4RAjv4AJ9O0i/Mghzev2uVYh8jnNz8vEKWIgCeKx0m
5pWv0EzbT0XSguo9MP0+HGE=
=bFNx
-----END PGP SIGNATURE-----

--------------enigC99285222EC2EE9236A802C5--
