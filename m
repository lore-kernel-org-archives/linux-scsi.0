From: Kurt Garloff <garloff@suse.de>
Subject: Re: scsidev-2.30 released
Date: Mon, 11 Aug 2003 10:42:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811084258.GO2543@nbkurt.garloff.de>
References: <20030811005050.GL2543@nbkurt.garloff.de> <20030811081326.A20061@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ccJhwVfaC+fHwTsl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([213.95.15.193]:33545 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S272325AbTHKInA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 04:43:00 -0400
Content-Disposition: inline
In-Reply-To: <20030811081326.A20061@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--ccJhwVfaC+fHwTsl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2003 at 08:13:26AM +0100, Christoph Hellwig wrote:
> On Mon, Aug 11, 2003 at 02:50:50AM +0200, Kurt Garloff wrote:
> > New in 2.30:
> > * HSV devices are detected and HSV_OS_IDs retrieved. They can be used=
=20
> >   to build aliases (Contributed by Evans Felix, PNL).
                                       ^^^^^ Evan actually, sorry!
>=20
> What's HSV devices and HSV_OS_IDs?

Good that you ask, I should have told.
It's an ID you can assign to a volume ("LUN") you export from
a EVA storage array from HP.
http://h18006.www1.hp.com/products/storageworks/eva3000/index.html

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--ccJhwVfaC+fHwTsl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/N1cSxmLh6hyYd04RAviVAKCEqBrmAdln6c6pAXXgjJ5exLZuzACfXNN8
gBjZgZKYamy2hUuXx3SQihc=
=0YkF
-----END PGP SIGNATURE-----

--ccJhwVfaC+fHwTsl--
