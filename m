From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] Format Unit can take many hours
Date: Tue, 11 May 2004 14:40:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084279242.2688.12.camel@laptop.fenrus.com>
References: <20040511114936.GI4828@tpkurt.garloff.de>
	 <20040511122037.GG1906@suse.de>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UJjM1S0ml6A2WNzHMNvT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45976 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264319AbUEKMku (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2004 08:40:50 -0400
In-Reply-To: <20040511122037.GG1906@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>


--=-UJjM1S0ml6A2WNzHMNvT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-05-11 at 14:20, Jens Axboe wrote:
> On Tue, May 11 2004, Kurt Garloff wrote:
> > Hi,
> block/scsi_ioctl.c should likely receive similar treatment then.

how about sticking these in a shared header between the 2 files ?

--=-UJjM1S0ml6A2WNzHMNvT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAoMnKxULwo51rQBIRAuCoAJ4mydHdT3jGaiTTNOQNrOlrfjYnNgCgqh4L
O8960qzPtmgkmXykz6jr7w8=
=cFc5
-----END PGP SIGNATURE-----

--=-UJjM1S0ml6A2WNzHMNvT--

