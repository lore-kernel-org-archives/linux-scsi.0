From: Ryan Anderson <ryan@autoweb.net>
Subject: Re: aacraid died on kernel 2.4.27
Date: Fri, 11 Mar 2005 01:04:56 -0500
Message-ID: <20050311060456.GK20923@ryan2>
References: <87sm33kyf5.fsf@tapsellferrier.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xcivb/T/gnJQjo5J"
Received: from mail.autoweb.net ([198.172.237.26]:26382 "EHLO mail.autoweb.net")
	by vger.kernel.org with ESMTP id S263201AbVCKGFt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 01:05:49 -0500
Content-Disposition: inline
In-Reply-To: <87sm33kyf5.fsf@tapsellferrier.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Ferrier <nferrier@tapsellferrier.co.uk>
Cc: linux-scsi@vger.kernel.org


--xcivb/T/gnJQjo5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 10, 2005 at 09:01:50PM +0000, Nic Ferrier wrote:
> I've been trying, without success, to get the aacraid driver to work
> reliably on a Dell 2650 Poweredge.

I've had problems there, too.  With kernel 2.6.8.

I just had another failure, and I got some better logs.

Can you install the "afacli" utility (Dell-branded version of aacli),
and run
diag show history /old
=66rom afacli?

If you can't seem to get the OLD history to show (compare diag show
history /current with diag shot history /old), try diag dump text - you
may find some useful messages there.

The other, standard, suggestion is to go through and open a ticket with
Dell, and do all the hardware diagnostics to try and see if the error
can be traced to hardware problems or not.

Good luck, I hope you find a fix faster than I have (still trying,
unfortunately)

--=20

Ryan Anderson               =20
AutoWeb Communications, Inc.=20
email: ryan@autoweb.net=20


--xcivb/T/gnJQjo5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCMTUIvV/uNaz8d+gRAiTuAJsF2wX6TzRFx541hE3BvspHKFtPywCdGkNd
7uXuLA0YZU3yiAS810V7BDg=
=XzMp
-----END PGP SIGNATURE-----

--xcivb/T/gnJQjo5J--
