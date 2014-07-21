From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] [SCSI] hpsa: Fix driver support flag initialisation on
 !x86
Date: Mon, 21 Jul 2014 01:43:14 +0100
Message-ID: <1405903394.8631.25.camel@deadeye.wl.decadent.org.uk>
References: <1405901357.8631.24.camel@deadeye.wl.decadent.org.uk>
	 <20140721004202.GA29358@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IqGZ1Rvc334pdQGMYDH2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36725 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbaGUAny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jul 2014 20:43:54 -0400
In-Reply-To: <20140721004202.GA29358@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, linux-scsi <linux-scsi@vger.kernel.org>


--=-IqGZ1Rvc334pdQGMYDH2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2014-07-20 at 17:42 -0700, Christoph Hellwig wrote:
> On Mon, Jul 21, 2014 at 01:09:17AM +0100, Ben Hutchings wrote:
> > On !x86 we currently don't read the existing support flags:
>=20
> Arnd already sent this and I've included it in the for-3.17 queue.

Thanks.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-IqGZ1Rvc334pdQGMYDH2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU8xiJ+e/yOyVhhEJAQrJBA//ZG0zPHBwPndi0DHpI0cG2Q6//PRUijFU
l0Xvb2UfwvHFeibPkZY3RWpLdmzoXPTUaixf2g9y/iFiQDlV4xE1EuqkfEQM2WVD
WnRq32dO//37FbCpopFVfjebcZQMJf8kepjOb4bh9r9dTvy/iYlRsSqMj/+8CQ7E
t8QRFN4Va2JFdOAIXlfWBfJljz/tmUkzcyPvmUbOQoRUzmJS5YsGLV0z+Vr2l/+h
IIhRPurnW1sXnaleV8eWL2vq0hVs5zytopw3/+dSepwxC+aX2gQEzBCrvrKqckjm
M5kEQ2bnS4knNLMtgmpnRoT1cPfeV295Iuld8fRu3XIJMgC+eFmvhJEGHRdQk7oN
Xm1YIt8r8otkbgqmewd/V16rK/9W+fSM6xsd6poCzXxroyzkNFgx2WqaSxOdHR20
/ORuHZF6gLej58uINFa4dZu9vGOTgIRQpkDW81QbvGEYK5zipNOq9qqhVperDWp5
rRGaay3r/5a0tEIl6l354HvjoFiMrqmjkCK11Jgi7CfZD2XTErIIQtnJ0wF2qK4E
Xwu/UJZyt+1XfdS9rD+vOTY20mH9NAMUnFI2p1pQmn93iUwLP6rfrIKE1i409DTR
5I8uD33s2c/ZQ3pxDemJASqnH3lK2fPEQGAK9OpCk6PJr5cjfgHpAXZorC2nQUCI
1cIr8OT7d3g=
=jZ5g
-----END PGP SIGNATURE-----

--=-IqGZ1Rvc334pdQGMYDH2--
