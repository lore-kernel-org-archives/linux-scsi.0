From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: MODULE_VERSION for scsi drivers
Date: Tue, 27 Apr 2004 08:10:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427131050.GA17777@lists.us.dell.com>
References: <20040427040923.GA9901@lists.us.dell.com> <32805.4.5.45.142.1083039354.squirrel@www.osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:36770 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S264066AbUD0NMt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 09:12:49 -0400
Content-Disposition: inline
In-Reply-To: <32805.4.5.45.142.1083039354.squirrel@www.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 26, 2004 at 09:15:54PM -0700, Randy.Dunlap wrote:
> > Now that the MODULE_VERSION() macro is in 2.6, I'd love to see all
> > modules implement it.
>=20
> What's the purpose of the
> MODULE_VERSION(""):
> instances?  (e.g.:)

Per include/linux/module.h:
  Using this automatically adds a checksum of the .c files and the
  local headers to the end.  Use MODULE_VERSION("") if you want just
  this.  Macro includes room for this.

So for modules which don't appear to have their own versioning, we use
the "" mechanism to simply generate the checksum for the file.  This
still allows tools (ala DKMS eventually) to note if something in the
module changed even if the version string didn't.

Thanks,
Matt

--=20
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAjlvaIavu95Lw/AkRArshAJ9Cu84sQc0irWlmLH3BxhsHspPGUgCfddHS
rQ7gNm47NBx1BTLxztwHHVY=
=NZGK
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
