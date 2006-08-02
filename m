From: Robert Annessi <robert@annessi.at>
Subject: Re: dc395x: Report
Date: Thu, 03 Aug 2006 01:24:08 +0200
Message-ID: <44D13418.2000005@annessi.at>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange> <44D075A2.2080501@annessi.at> <Pine.LNX.4.60.0608021209310.5115@poirot.grange> <44D0BC2F.3030700@annessi.at> <Pine.LNX.4.60.0608022348570.12263@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig741C7F0B85939A169208A2B0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx-01.sil.at ([86.59.12.198]:18148 "EHLO mx-01.sil.at")
	by vger.kernel.org with ESMTP id S932333AbWHBXY1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 19:24:27 -0400
In-Reply-To: <Pine.LNX.4.60.0608022348570.12263@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig741C7F0B85939A169208A2B0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/03/06 00:07, Guennadi Liakhovetski wrote:
> On Wed, 2 Aug 2006, Robert Annessi wrote:
>=20
>> BUG: warning at drivers/scsi/dc395x.c:2329/data_in_phase0()
>>  [<f884c768>] data_in_phase0+0x190/0x244 [dc395x]
>>  [<f884c15e>] dc395x_handle_interrupt+0xf7/0x128 [dc395x]
>>  [<f884c1c0>] dc395x_interrupt+0x31/0x5f [dc395x]
>>  [<c0137975>] handle_IRQ_event+0x21/0x49
>>  [<c0137a2e>] __do_IRQ+0x91/0xef
>>  [<c0104a2f>] do_IRQ+0x43/0x50
>>  [<c01032aa>] common_interrupt+0x1a/0x20
>=20
> Would be interesting to find out what exactly causes these warnings. Co=
uld=20
> you, please, try the patch at the bottom of this email with 2.6.18-rc3 =
and=20
> see if the message it prints appears in dmesg - together with the NO_TA=
GQ=20
> warkaround and without safe=3D1.


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


> Well, this looks much better to me. So, I think, we may say for you the=
=20
> problem is solved. Globally, I think, the reason why other drivers have=
 no=20

For me the problem is definetely solved. Thank you!


> problems with this drive is because they are using results of the gener=
ic=20
> inquiry evaluation code, and it chooses better communication parameters=
=20
> than the dc395x. Would be nice to switch dc395x to do that too.

Unfortunately I don't have the skills for that - as you probably already
noticed. (;

Hopefully someone else is willing to adapt the driver.

Regards,
Robert


--------------enig741C7F0B85939A169208A2B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iEYEARECAAYFAkTRNB0ACgkQVoNfMxmfyFO+vQCeKWVWYNoLt1SApUa5L7LrFlCa
Ar8An2svtgciiGzp2RnRMf6Xige5u05H
=3GKM
-----END PGP SIGNATURE-----

--------------enig741C7F0B85939A169208A2B0--
