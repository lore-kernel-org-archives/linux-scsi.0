From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Subject: Re: External USB3 disk fails with "Invalid field in cdb"
Date: Fri, 27 Jun 2014 14:22:23 +0200
Message-ID: <20140627142223.48c5c18f@wiggum>
References: <20140626205519.314a71ae@wiggum>
 <20140627101540.GB10042@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8DR8cyDMyz.WTorjPUy/GL1"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49584 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbaF0MWa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 08:22:30 -0400
In-Reply-To: <20140627101540.GB10042@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: linux-scsi@vger.kernel.org

--Sig_/8DR8cyDMyz.WTorjPUy/GL1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks for your analysis.

On Fri, 27 Jun 2014 11:15:41 +0100
"Bryn M. Reeves" <bmr@redhat.com> wrote:

> On Thu, Jun 26, 2014 at 08:55:19PM +0200, Michael B=C3=BCsch wrote:
> > Jun 26 20:47:14 wiggum kernel: [156019.870310] sd 22:0:0:0: [sdb] 97677=
3168 512-byte logical blocks: (500 GB/465 GiB)
> > Jun 26 20:47:14 wiggum kernel: [156019.870653] sd 22:0:0:0: [sdb] Write=
 Protect is off
> > Jun 26 20:47:14 wiggum kernel: [156019.870659] sd 22:0:0:0: [sdb] Mode =
Sense: 47 00 10 08
>=20
> The disk says it supports FUA:

Is this the disk reporting that, or the USB->SATA controller?

The disk works perfectly fine, if connected via on board SATA controller.

> Looks like a WRITE(10) with the FUA bit set:
>=20
> > Jun 26 20:47:27 wiggum kernel: [156032.938239] sd 22:0:0:0: [sdb] CDB:
> > Jun 26 20:47:27 wiggum kernel: [156032.938241] Write(10): 2a 08 1d 04 0=
0 3f 00 00 08 00
> >
> > Does somebody have a hint to debug this?
>=20
> I'd guess the device lies about supporting FUA. There seems to be
> another report on the Debian lists of the same problem with a similar
> JMicron enclosure:

Is there a workaround for this problem, or even a quirk-patch that I could =
test?


--=20
Michael.

--Sig_/8DR8cyDMyz.WTorjPUy/GL1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrWH/AAoJEPUyvh2QjYsO1UUP/23ZSEVjOzE0KRBw2VuFZZ2O
uR/+NJqHBWiJT5cSGUpcsVFsBOAmFeqT83H3bt3vUBgWImLLZ0gxR1WZ6qBNsThX
fcTG6bfLlXFkmXsqUc3dqZ1VAymll2OFuwOFO9FB3iltEOkNTq/c5T0OyrCOHrzi
4leNfWWuWSyP9dxm8fIyDBw5oyuULQWYshMwfRRdB7ZxW6xkpooA1fnC305NT6mJ
tJF9tx6KOXhm2weim2105l6KCEv8Mpzcoza1l5unwNbRGB5rgam/JBo+MVrW2ZlZ
J29na8LwtFOBAE3wVRfAdpRpEXPtruwdIWY9yTg91oM7l6j87Z/M22tZPjuB+jCg
B3tyAKeVYaX+BSDUDYQBvHwXoApaff+ZqccnTMBITzGjwSuPRh/dCvbm9y3QHypO
uG8OzgnQyI7BsqRGpbPtrWhYcr0oqvVpKru9+YVgcHSf8sTXsBih+PAuF2IVYaFS
PlU+qynm+wgSM3o+9rz3aVJ/ppBrrxl+9ACIPcnEGmJAqtXLg9mnP605bIv4csme
IWJg5XJ735GCDVVUZW8GcDuUfLJdgaWjYY08N8cmQyq7yrdycM00iCj8hNMwC75Y
Yqsh5ATzENpYVmge3dvkUsYeDjGdsAkqbVdD4VFbUIEFq8Gu4xqW5Na3pkiyOHJV
8gvRlwEPBOFhT6mmG1Oi
=sk08
-----END PGP SIGNATURE-----

--Sig_/8DR8cyDMyz.WTorjPUy/GL1--
