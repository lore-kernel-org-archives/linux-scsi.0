From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: aic7xxx strange code
Date: Thu, 1 Jan 2004 17:28:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040101162823.GC18742@devserv.devel.redhat.com>
References: <1072885576.10877.6.camel@laptop.fenrus.com> <960352704.1072895786@aslan.btc.adaptec.com> <20040101100809.GA1053@devserv.devel.redhat.com> <478922704.1072973783@aslan.scsiguy.com> <20040101161731.GB18742@devserv.devel.redhat.com> <482322704.1072974098@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43951 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264545AbUAAQ2d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jan 2004 11:28:33 -0500
Content-Disposition: inline
In-Reply-To: <482322704.1072974098@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 01, 2004 at 09:21:38AM -0700, Justin T. Gibbs wrote:
> >> Unfortunately, fixing 2.4 and 2.6 now doesn't help in supporting older
> >> kernels that are still in production.  You can't change the past no
> >> matter how hard we'd like to try.=20
> >=20
> > But vendors will update those kernels.....
>=20
> Yes, but I can't remove support for these older kernels for quite
> some time.=20

2.6 seems to do the right thing at least so for your 2.6 drivers you can fix
it.


> Are you planning an audit of the other platforms to ensure API compliance?

This is the first time I've seen this bug (thanks again for reporting it)
and it's clearly an API violation of the ONE API in linux which is very well
documented so no other platform will have copied this bad bug... Adaptect
aic7xxx is not the only card which has the "ringbuffer needs to be in 32 bit
dma space" requirements and no other drivers have workarounds like this, a
sign that the bug isn't actually "common".

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/9EqmxULwo51rQBIRAuHFAJ0c2mLZbkS8jHUm804v/YRmS/OuXACfTdss
XTig7Lf7rb2Y2CxbWm+gPlE=
=xnCm
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
