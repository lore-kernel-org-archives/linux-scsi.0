From: Giel van Schijndel <me@mortis.eu>
Subject: Re: [PATCH] Cleanup: snprintf() always NUL-terminates: depend on it
Date: Mon, 5 Jan 2015 00:05:47 +0100
Message-ID: <20150104230547.GK4806@salidar.dom.custoft.eu>
References: <1420394759-20345-1-git-send-email-me@mortis.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBdJBemW82xJqIAr"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1420394759-20345-1-git-send-email-me@mortis.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--gBdJBemW82xJqIAr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 19:05:58 +0100, Giel van Schijndel wrote:
> Especially since one very strange piece of code seems to be written in
> such a way that a NUL needs to be placed where a NUL is present already.
> The author probably meant to fill the last byte of the buffer with a NUL
> instead. But regardless of that: that isn't necessary since snprintf()
> already guarantees NUL termination for buffers sizes > 0 and <=3D INT_MAX.
> ---

Forgot to:
Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
Of course I talk to myself. Sometimes I need expert advice.

--gBdJBemW82xJqIAr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSpx0sACgkQZBYm/87l50IEqQCeI8RjglkvJwyuMp6/CgGZEQsI
/cgAoJVMvS4qTtwy5C5TXqGu7fF97IxH
=UWRP
-----END PGP SIGNATURE-----

--gBdJBemW82xJqIAr--
