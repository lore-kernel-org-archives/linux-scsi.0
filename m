From: Kurt Garloff <garloff@suse.de>
Subject: Re: /proc/scsi/map
Date: Sun, 16 Jun 2002 21:41:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020616194111.GA21461@gum01m.etpnet.phys.tue.nl>
References: <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl> <200206151552.g5FFqCT14714@vindaloo.ras.ucalgary.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200206151552.g5FFqCT14714@vindaloo.ras.ucalgary.ca>
List-Id: linux-scsi@vger.kernel.org
To: Richard Gooch <rgooch@ras.ucalgary.ca>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

I was in no way intending to trigger a discussion about devfs.
Some of the things addressed by the scsi/map patch indeed are no issue if
you use devfs; that's why I mentioned devfs at all.
I don't want to bash devfs and I think it's nice that it's in the kernel,=
=20
so users have the choice to use it and the motivation to improve it.

But the problem that I wanted to address IMHO should also be solved
for those people that for one or another reason decided not to use
devfs.=20

And face it: I do not think that all major Linux distributions will
start to use devfs within short future. The example you mentioned
(Mandrake) is certainly not a good one: Look at their update kernel.

Best regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9DOnXxmLh6hyYd04RAmMWAJ9yIpyrrb1Mi9iB2ZVuITQ1gqOjiQCfQYY4
vdrXOtB3kDgr4FmRQU/SuUE=
=3uq0
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
