From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/2] aic94xx: Supermicro motherboards support
Date: Sun, 15 Oct 2006 12:47:20 -0400
Message-ID: <1160930840.2917.387.camel@fc6.xsintricity.com>
References: <20061015012146.62933.qmail@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IU98b7Sx93ZH1loPnvuU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:61131 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751145AbWJOQrZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 12:47:25 -0400
In-Reply-To: <20061015012146.62933.qmail@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Sergey Kononenko <sergk@sergk.org.ua>, linux-scsi@vger.kernel.org


--=-IU98b7Sx93ZH1loPnvuU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2006-10-14 at 18:21 -0700, Luben Tuikov wrote:

> > As i found this code was commented out in original driver by Luben
> > Tuikov with following comment:
> >=20
> > /*     Early (current?) SuperMicro mainboards, X6DHR-3G2 and X6DH3-G2
> >        have a bug whereby RS104 is missing (not installed) and RS103
> >        is installed, causing FLASHEX to be 0. */
> > /*     if (!(reg & FLASHEX)) { */
> > /*             ASD_DPRINTK("flash doesn't exist\n"); */
> > /*             return -ENOENT; */
> > /*     } */
> >=20
> > May be it is possible to write separate code for checking
> > availability of flash chip especially for supermicro
> > motherboards, but i don't know hot it possible and don't know what is
> > RS104, RS103 and difference between it.
>=20
> RSxyz stands for "resistor xyz" in the schematic diagrams.
> This is a hardware bug in the (early?) SuperMicro mainboards.
> It dates from last year, 20 October 2005.

This wouldn't be the first (or last I'm sure) time a hardware
manufacturer didn't properly set up the external resistors that signal
to the chip whether or not certain options are installed.  In the past
I've done searches of the PCI device space looking for specific
northbridge/southbridge pairs so I would know when to ignore certain
hardware indicators based upon buggy motherboard setups.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-IU98b7Sx93ZH1loPnvuU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFMmYYTzP9PM7pjw8RAiOjAJ0e8vMQPNF7LI8bzPAquqigORfrYgCcD+4T
anwpYxpHxAIvao/9AqHreCk=
=7sV0
-----END PGP SIGNATURE-----

--=-IU98b7Sx93ZH1loPnvuU--

