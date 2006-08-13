From: Robert Annessi <robert@annessi.at>
Subject: Re: dc395x: Report
Date: Sun, 13 Aug 2006 20:35:00 +0200
Message-ID: <44DF70D4.7030504@annessi.at>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange> <44D075A2.2080501@annessi.at> <Pine.LNX.4.60.0608021209310.5115@poirot.grange> <44D0BC2F.3030700@annessi.at> <Pine.LNX.4.60.0608022348570.12263@poirot.grange> <44D13418.2000005@annessi.at> <Pine.LNX.4.60.0608092315060.3728@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2AED843C48DDE923F6BC9F16"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx-01.sil.at ([86.59.12.198]:27087 "EHLO mx-01.sil.at")
	by vger.kernel.org with ESMTP id S1750719AbWHMSfV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 14:35:21 -0400
In-Reply-To: <Pine.LNX.4.60.0608092315060.3728@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2AED843C48DDE923F6BC9F16
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/12/06 20:06, Guennadi Liakhovetski wrote:
> Great, maybe you still could test the patch below (applied on the top o=
f=20
> all my patches until now)?

Sure.

The warning still occurs (I used 2.6.18-rc4):

dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:02.0
dc395x: Used settings: AdapterID=3D07, Speed=3D0(20.0MHz), dev_mode=3D0x3=
7
dc395x:                AdaptMode=3D0x4e, Tags=3D0(01), DelayReset=3D1s
dc395x: (Wide) Connectors: int68  Termination: Auto Low High
dc395x: Performing initial SCSI bus reset
scsi0 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

dc395x: Target 00: Wide16 Sync: 48ns Offset 15 (41.7 MB/s)
  Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
dc395x: inconsistent counters: FIFOCNT 64, left 16777215, wide
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
dc395x: inconsistent counters: FIFOCNT 64, left 16777215, wide
SCSI device sda: drive cache: write back w/ FUA
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
dc395x: inconsistent counters: FIFOCNT 64, left 16777215, wide
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
dc395x: inconsistent counters: FIFOCNT 64, left 16777215, wide
SCSI device sda: drive cache: write back w/ FUA
 sda: unknown partition table
sd 0:0:0:0: Attached scsi disk sda

Regards,
Robert


--------------enig2AED843C48DDE923F6BC9F16
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iEYEARECAAYFAkTfcNgACgkQVoNfMxmfyFNnFwCdEF/w51CX+ixpi3TM74hGO0BR
MLoAnR1HL3ocgV4QRni2JK3PZs0AR1xt
=f9FT
-----END PGP SIGNATURE-----

--------------enig2AED843C48DDE923F6BC9F16--
