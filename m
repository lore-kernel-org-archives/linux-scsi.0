From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: aic7xxx strange code
Date: Thu, 1 Jan 2004 17:17:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040101161731.GB18742@devserv.devel.redhat.com>
References: <1072885576.10877.6.camel@laptop.fenrus.com> <960352704.1072895786@aslan.btc.adaptec.com> <20040101100809.GA1053@devserv.devel.redhat.com> <478922704.1072973783@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43945 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264443AbUAAQRl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jan 2004 11:17:41 -0500
Content-Disposition: inline
In-Reply-To: <478922704.1072973783@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 01, 2004 at 09:16:23AM -0700, Justin T. Gibbs wrote:
> >> I'm more than happy to change the #ifdefs on the hack to exclude 2.6
> >> so long as all platforms the driver operates under behave as expected.
> >> If 2.4 is any guide, however, there may still be some bogus code lurki=
ng
> >> around that uses the "normal" dma mask incorrectly.
> >=20
> > Those platforms break the API and should be fixed as opposed to hacks a=
dded
> > to every single driver in drivers/*
>=20
> Unfortunately, fixing 2.4 and 2.6 now doesn't help in supporting older
> kernels that are still in production.  You can't change the past no
> matter how hard we'd like to try.=20

But vendors will update those kernels.....


--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/9EgbxULwo51rQBIRAmO9AJ91o3w0D5kBdHfnRU8chlb+RK6ZlgCcDp9H
LQ4V8S0npbOXctMDaIlineg=
=5Yve
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
