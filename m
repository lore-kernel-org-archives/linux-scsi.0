From: Arjan van de Ven <arjanv@redhat.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: Wed, 06 Oct 2004 16:13:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097072016.2812.26.camel@laptop.fenrus.com>
References: <BC3CE0375D29D51199A400508B66CA6C0862AEFD@exc-snake.co.lsil.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SLXwWmFvrHsjTonZ2lIw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:29578 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S269245AbUJFONr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 10:13:47 -0400
In-Reply-To: <BC3CE0375D29D51199A400508B66CA6C0862AEFD@exc-snake.co.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Gibbons, Terry" <Terry.Gibbons@lsil.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Emoore@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-SLXwWmFvrHsjTonZ2lIw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2004-10-06 at 16:00, Gibbons, Terry wrote:
> A change in DV code will result in lost time to LSI, Red Hat, SuSE, and a=
ll
> of LSI's customers as there will be absolutely no choice but to force LSI
> driver patches for DV through Red Hat and SuSE (at a minimum).

I personally object to your terminology here. LSI cannot force any
patches through Red Hat, and I suspect the same holds for SuSE. LSI can
request patch inclusion which Red Hat or SuSE may or may not decide to
do. I can't speak for SuSE but RH seems to not be a great fan of huge
driver patches that deviate from what is available and tested upstream.


> Now, I challenge all of you. Ultra320 SCSI was fully released over two an=
d a
> half years ago. With SAS and SATA being the new technologies, what's the
> benefit in changing a technology that is peaking and soon to be replaced?

If you are unmaintaining the driver just say so. If you're not, please
consider the fact that we have to work with your code, and that we have
to keep making sure your driver works with "our" scsi stack. Previously
the linux scsi layer became a really big mess this way because drivers
just never changed and no real innovation was possible as a result.
Times have changed, the scsi layer now is actively maintained and moving
forward both in code quality, reliability and functionality. Your
statement seems to suggest you want to hold back linux scsi....


--=-SLXwWmFvrHsjTonZ2lIw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBY/2Qpv2rCoFn+CIRAohDAKCNfx/8PEQN0dytsSiarv2jscZvogCfU1hu
oitRf1R/aUIho/tyhGLrdbg=
=CyKL
-----END PGP SIGNATURE-----

--=-SLXwWmFvrHsjTonZ2lIw--

