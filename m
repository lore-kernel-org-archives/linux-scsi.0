From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] cleanup on stack DECLARE_COMPLETIONs
Date: Tue, 23 Dec 2014 12:19:43 -0600
Message-ID: <20141223181943.GE9147@saruman>
References: <1419356048-22405-1-git-send-email-der.herr@hofr.at>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZaMRJmqxGScZ8Mx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33060 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaLWSUV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2014 13:20:21 -0500
Content-Disposition: inline
In-Reply-To: <1419356048-22405-1-git-send-email-der.herr@hofr.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dimitri Sivanich <sivanich@sgi.com>, "Juergen E. Fischer" <fischer@norbit.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Felipe Balbi <balbi@ti.com>, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

--BZaMRJmqxGScZ8Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2014 at 06:34:08PM +0100, Nicholas Mc Guire wrote:
> fixups for incorrect use of DECLARE_COMPLETION. see also commit
> 6e9a4738 ("completions: lockdep annotate on stack completions")
> The only somewhat special case being
> drivers/misc/sgi-gru/grukservices.c:quicktest2
> which had a static qualifier in the original DECLARE_COMPLETION()
> but that seems to be wrong (why should the completion persisted between
> successive calls ?) so the conversion to DECLARE_COMPLETION_ONSTACK
> was also applied and the static qualifier removed.
>=20
> Not sure if this is suitable in this form or if it should go out as
> 5 seperate patches ?=20
>=20
> This was only code reviewed and compile tested
>=20
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

please split drivers/usb/gadget out of this patch so I can take it
through my tree.

--=20
balbi

--BZaMRJmqxGScZ8Mx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmbI/AAoJEIaOsuA1yqREf+8QAIdzpVKFhFQYdY42VzNlstHv
nn+9CehWPZdcVs3DoY0UGkzaq6gj5+ZBxvXQHowMdxP7ZM+qJdNya8Bo4gkNfX4H
d7nOgVvMhJBcBhALPM+EIIdTS2iGL8/J2NqohSV8NPtfCcBYeXg4uf6gj/IhOobC
bDjpHUttrI7SzzhZ7MPh33Bibx8+IsWUqBnp8K9VnVaBpLvFVP0gKKJj9UmvqxJo
jbeb/aeBi6HcaC+1X06Z5YBK9AhXN1Pp2U3ju0TEHQRLadVfFHMR90dvcH6llo+n
3KMEbnYg5QDN/yIYxS1KfqRBzyE3kiGsHCfIlv1SOw5sShce13teBfL4RsHqox0U
CZWRVS3s9MK/CtT5a115tR73A11cNR0CHGhnZSyibbQRVJoD31elzChSDNWIO7KQ
eFIsvmOOm7txJ+FutzL7vCCCW5ZcATS1aOrmBpfDkji6dEdSflV5PZ36YJlN1cP4
nkzs0oSvc2aiCHElPyyXVGF4/uG5EVXpA+Do2Sa04NlS2YZ9Jwg9BYY0fILH87ZN
xo6UKVlOKx/uodQCiYZ39+oTA6deAJA7RSUoN3aexi71z/pq8dIi95qwCeffZ7Fu
myCQQLShe2d7RXeEBGGCigE3v4/ScIO8szvcEY/UYi885Er6yMeB9AceiFsxDrxC
zj2JwCeV9LfY1n6zoUgs
=7zvw
-----END PGP SIGNATURE-----

--BZaMRJmqxGScZ8Mx--
