From: Ben Hutchings <ben@decadent.org.uk>
Subject: [stable] SCSI discard fixes
Date: Fri, 22 Apr 2016 08:42:54 +0100
Message-ID: <1461310974.3404.7.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-3l00ARvt1EjMdpq9BVin"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56319 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297AbcDVIBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2016 04:01:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>


--=-3l00ARvt1EjMdpq9BVin
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This commit in 3.19:

commit 7985090aa0201fa7760583f9f8e6ba41a8d4c392
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:=C2=A0=C2=A0=C2=A0Fri Nov 7 00:08:13 2014 -0500

=C2=A0=C2=A0=C2=A0=C2=A0sd: disable discard_zeroes_data for UNMAP

appears to fix a data corruption bug. =C2=A0Should it be backported to olde=
r
stable branches?

Similarly for this one in 4.4:

commit 397737223c59e89dca7305feb6528caef8fbef84
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:=C2=A0=C2=A0=C2=A0Fri Nov 13 16:46:47 2015 -0500

=C2=A0=C2=A0=C2=A0=C2=A0sd: Make discard granularity match logical block si=
ze when LBPRZ=3D1

(along with:
commit f4327a95dd080ed6aecb185478a88ce1ee4fa3c4
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:=C2=A0=C2=A0=C2=A0Sat Mar 5 17:52:02 2016 -0500

=C2=A0=C2=A0=C2=A0=C2=A0sd: Fix discard granularity when LBPRZ=3D1
)

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-3l00ARvt1EjMdpq9BVin
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXGdX+AAoJEOe/yOyVhhEJbBUQAM3WmKe+uV8EJd4qeOCsRP9y
NOLcA/l7j3t+3rFHQpaOh1UyxvLyLKlH4iVLWRkjunewNzfXsi4lGDLiRPbqO4Gb
Ebwr8sdTa4OQRzSeJQggHRDvjQxwqSPnXzn+n36rBZLBdjNeToARjEWY3OPRLrzh
JaAuWMnMdCz6V8FIH1oRBh5342/PMG2EjM7ELafAN/rst4znQl6GUtEvyk1BYBIj
Wz6Se7xx9x9SIKf5P+VyhRwYvRITRIYHgBSheE2mq2ORP8it3FeXTjfONX0Hdfau
FGIaxkduNy3reDwIS6/BmAeIa8c1Qt/kodPec8zHh4J0KiNWn3imt0HQ5B0+Nr8l
APbFInhvt9BwbFcmwqxTl5CI7nUPaIDI9WnUF42M/NISJ12cAfPOqdg4wDt1ZvFf
golsSutP4m+osiEOiV3lSmMW4gemOqcSrfeWyY5IUI6fZ6BeKJEQLOC4LR0SGRfl
3+Wg/ISPdccdg+UozoqM7kIvXOQFxWC2KOL0LZIVT0Fh5WF7/w/85MKEtSXlLxL3
FEhUEmqinBddRQPL5dWthlKenGpwkkF9SOqnRnlbt/H8NQrWVulQ6cgaXIbZeHk2
oNV3a6NyrnDYTiU9NB54Gw66wj5Djd4uZD4iPfMX24VleCcl8FC6UtULA/Y6PbMC
dRG7eb30hIBtijgpqyTe
=NjNU
-----END PGP SIGNATURE-----

--=-3l00ARvt1EjMdpq9BVin--
