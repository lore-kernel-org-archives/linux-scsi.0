From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>]
 sr_runtime_suspend+0xc/0x20 [sr_mod]
Date: Tue, 09 Feb 2016 20:51:10 +0000
Message-ID: <1455051070.2654.4.camel@decadent.org.uk>
References: <1453222373.3588.3.camel@giantmonkey.de>
	 <Pine.LNX.4.44L0.1601191532210.1312-200000@iolanthe.rowland.org>
	 <CAM79t8GJvQPzOt1oDikxv3wPZ9xgVMez5EUgXmeVH2zKJCeaAw@mail.gmail.com>
	 <1455036420.11996.5.camel@giantmonkey.de>
	 <CAM79t8HzYT+s0BrqzZ0-Cv7khzn6CvpE5bfnJ6H9xYCx4RkS8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-D/PZj2lla8x8xWAUTh9y"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36359 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468AbcBIUv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2016 15:51:26 -0500
In-Reply-To: <CAM79t8HzYT+s0BrqzZ0-Cv7khzn6CvpE5bfnJ6H9xYCx4RkS8g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexandre Rossi <alexandre.rossi@gmail.com>, Paul Menzel <paul.menzel@giantmonkey.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Erich Schubert <erich@debian.org>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org


--=-D/PZj2lla8x8xWAUTh9y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-02-09 at 20:56 +0100, Alexandre Rossi wrote:
> Hi,
>=20
> netconsole does not seem to work so early in the boot process this time.
>=20
> > As this is Linux 4.3 and not 4.4, I guess this is a different problem
> > though. Alexandre, where you able to capture the stack trace? I=E2=80=
=99d submit
> > a new bug report with this.
>=20
> Here is a photo. Please ping me if you need to test some debugging patche=
s.

I'm pretty sure this crash is fixed by commit 4fd41a8552af ("SCSI: Fix NULL
pointer dereference in runtime PM"), which I've now queued up for 4.3
(though it's already in 4.4 which I'll probably upload to unstable soon).

Ben.

--=20
Ben Hutchings
Design a system any fool can use, and only a fool will want to use it.
--=-D/PZj2lla8x8xWAUTh9y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVrpRPue/yOyVhhEJAQqs+hAAtz3ACY5ojRBn5poaKR0ZYyWtIGqtixlg
YdgDK7Qc8YRxRFZQ8GYNS2T0r0O5faC+SmNTIzH+fkx0tjPu/qFSRNb92r+8FKVa
k8+4QNbxnpltxUBx+7zKof/cVKzINaoPvzlnS7toprq8I9TQ+zIpLDOojFbg/hl1
ctOj2oA+NMTgd39PkZypcBVfO0uPtdD0OS1ubBq4ifylG8Obuma5L1DlhfE5dj2G
q7ShrmP1p8+raTOrtpk2BU8naDZ/ei+zk37qm7TzFNPJoMbkxjBv1LjvFSlXjxPe
UaM5yI3REf132o45WLis2Y3N4FIG8ImYFCvvgCKTBSfWpZhhawKqv50+ZOe85EAM
tj/TG6Gg9sq+Iw/VyjsUKhl0zYdyHiylIRlT1KKl0LkQwBxJZp9RnyqYwQxZKRIu
zFLujoDdNCSUUgqyPQIyKYK+SkJu671Sns2CBeQI/yeljM7FnX6KqT3QuAvrnGWm
05Co+F390yaqCbkrCdT1U4gNnSwWmBenooGSdTiuuG+sHnx/E0rde2+x0E+g/uLI
BgwyHkPT1rlkQasYDOzZPWlY/4qNEqkfpaS5XjzrTpcbCZ+Al5OH3XbbFoP3Fbbn
iFijYM6/uTKKLE3myg1TKtz71F+lx2190SkgDh/DgWm+RIcSnyW2MQYJ4C3yc4u3
+hLmXsFNGlQ=
=9/TH
-----END PGP SIGNATURE-----

--=-D/PZj2lla8x8xWAUTh9y--
