From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Fri, 30 Jan 2004 09:41:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075473710.4272.2.camel@laptop.fenrus.com>
References: <1073076654.2048.19.camel@opiate>
	 <1073120514.4429.0.camel@laptop.fenrus.com>
	 <1282412704.1073168696@aslan.scsiguy.com>
	 <20040104100448.GA2416@devserv.devel.redhat.com>
	 <2228980000.1075440305@aslan.btc.adaptec.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VKHrYx+e4L0oSWNnUJZb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat-pool-bos.redhat.com ([66.187.230.200]:7526 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S261152AbUA3Ol4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 09:41:56 -0500
In-Reply-To: <2228980000.1075440305@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Eric Kerin <eric@bootseg.com>, linux-scsi@vger.kernel.org


--=-VKHrYx+e4L0oSWNnUJZb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-01-30 at 00:25, Justin T. Gibbs wrote:
> > <snip the rest>
> > -----------------
> >=20
> > There are 2 reasons to work this way, and I would very much prefer the
> > adaptec drivers to behave like this:
> > 1) PCI Hotplugging
> > 2) Adding PCI ID's at runtime
> >=20
> > While you may not care about 1), a lot of IHV/distros care about 2); eg=
 if
> > Adaptec puts out a card that can be driven by aic79xx but with just a n=
ew
> > PCI ID, hardware vendors can just add the ID at runtime and have it wor=
k in
> > the (factory) installer etc but only *if the driver is loaded* ....
>=20
> Well, if you look at the Adaptec drivers, they already attach to all
> possible IDs for the chips that are supported.  They do this by registeri=
ng
> a very generic PCI ID table and filtering all requests through their
> own tables. =20

May I ask why this is done? It sounds not the right thing that needs all
kinds of special cases in the OS userland...

Greetings,
    Arjan van de Ven

--=-VKHrYx+e4L0oSWNnUJZb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAGm0txULwo51rQBIRAtaIAJ0Y8QAlEtR2v3yFvEXIMlllcT6ocACfQcfL
Wj+Jf6WjqI9NEqsfkfyHdwM=
=re0w
-----END PGP SIGNATURE-----

--=-VKHrYx+e4L0oSWNnUJZb--
