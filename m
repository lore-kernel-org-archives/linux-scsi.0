From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] 2.4.26 scsi_scan.c Blacklist Entries
Date: Sun, 18 Apr 2004 20:30:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418183059.GA4868@tpkurt.garloff.de>
References: <F65B33CAD23A284EAE6E4AE353BF94DC031A44CC@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:63399 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263946AbUDRTEr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:04:47 -0400
Content-Disposition: inline
In-Reply-To: <F65B33CAD23A284EAE6E4AE353BF94DC031A44CC@tayexc13.americas.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: "Czerkowicz, John" <john.czerkowicz@hp.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 16, 2004 at 04:29:50PM -0400, Czerkowicz, John wrote:
> The following HP DAT autoloaders have devices at LUN 1:
>=20
> HP SureStore DAT8x6
> HP SureStore DAT24x6
> HP SureStore DAT40x6
> HP StorageWorks DAT72x6

Why do you need FORCELUN for this?
They should be detected without any blacklist entries.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgsljxmLh6hyYd04RAs2IAJ9mwH5/vfBnVIgq9Ml8YQGux8G1NwCgh833
sgHC+f7cfDNpiSSh8XRjvDQ=
=A50X
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
