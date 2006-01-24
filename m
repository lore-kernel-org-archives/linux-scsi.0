From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 22:12:23 +0100
Message-ID: <43D69837.8030501@ilsb.tuwien.ac.at>
References: <43D604AD.6050607@ilsb.tuwien.ac.at> <Pine.LNX.4.63.0601242245260.6350@kai.makisara.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5CB2DD08EFB3EFD3CAB18985"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:7572 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S1750721AbWAXVMd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 16:12:33 -0500
In-Reply-To: <Pine.LNX.4.63.0601242245260.6350@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5CB2DD08EFB3EFD3CAB18985
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Kai Makisara schrieb:

>>
> What are the speeds negotiated between the SCSI HBA and the tape drive =
in=20
> these cases?
>=20

I don't have the data for Megaraid and Fusion (both are not very verbose
on startup), for the very old LSI 875 chipset there it comes:


Vendor: HP        Model: Ultrium 3-SCSI    Rev: G24H
Type:   Sequential-Access                  ANSI SCSI revision: 03
target7:0:4: tagged command queuing enabled, command queue depth 16.
target7:0:4: Beginning Domain Validation
target7:0:4: asynchronous.
target7:0:4: Wide Transfers Fail
target7:0:4: asynchronous.
target7:0:4: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 16)
target7:0:4: Ending Domain Validation
Attached scsi generic sg9 at scsi7, channel 0, id 4, lun 0,  type 1

I have to investigate why wide negotiation failed (firmware bug - but
they will laugh at me if I ask..), but 20 MB/s should be enough
for more than 1.5 MB/s transfer speed (there are only the tape drive
and the media changer on the bus)

                                      GS

--=20
Gerhard Schneider
Institute of Lightweight Design and         e-Mail: gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29     http://www.ilsb.tuwien.ac.at/~gs/



--------------enig5CB2DD08EFB3EFD3CAB18985
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFD1pg7E6e53f4wQG4RAkyDAJwL/NxPybA45lbzGDP+qvcP5ETYZgCfXZBr
q0Dkqg7LAnilgDOmkZxJfYE=
=mquX
-----END PGP SIGNATURE-----

--------------enig5CB2DD08EFB3EFD3CAB18985--
