From: "Juergen E. Fischer" <fischer@linux-buechse.de>
Subject: Re: Problem with module-init-tools-3.0-pre3
Date: Wed, 4 Feb 2004 23:05:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040204220558.GA31361@linux-buechse.de>
References: <16417.24074.807107.128849@ronispc.chem.mcgill.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16417.24074.807107.128849@ronispc.chem.mcgill.ca>
To: david.ronis@mcgill.ca
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, Douglas Gilbert <dougg@torque.net>
List-Id: linux-scsi@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, Feb 04, 2004 at 16:03:06 -0500, David Ronis wrote:
> OK, I applied the patch and rebuilt/reinstalled kernel and modules.
> Problem is still present. =20

Ok. That was just a thought.

Looks like the same problem was also reported twice on linux-kernel

Both while running cdrecord -scanbus with the usb-storage driver, but
not the aha152x driver  (References:
<20040106174755.GA8855@paradigm.rfc822.org>
<1075241217.3851.8.camel@localhost.localdomain>).

Your report and those two all involve sg.  So I guess the problem is in
sg (or an upper layer).


J=FCrgen

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAIWzGc/GhTF5ESHURAhnEAJ9+Y0ftSjGVvbxrxJtdT8K5aiI8UgCfRqNz
b6gjpH24688RYrB2tDSR3J8=
=EQId
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
