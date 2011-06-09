From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#629865: xen-linux-system-2.6.26-2-xen-amd64 causes system
 crash when using aacraid driver
Date: Thu, 09 Jun 2011 02:02:35 +0100
Message-ID: <1307581355.22348.515.camel@localhost>
References: <20110609001421.31586.45135.reportbug@s5f.fillz.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-iNogjIStJODittZFsCX8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43202 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab1FIBCo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2011 21:02:44 -0400
In-Reply-To: <20110609001421.31586.45135.reportbug@s5f.fillz.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Vaillancourt <tim@elementspace.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: 629865@bugs.debian.org, linux-scsi <linux-scsi@vger.kernel.org>


--=-iNogjIStJODittZFsCX8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-06-08 at 19:14 -0500, Tim Vaillancourt wrote:
> Package: xen-linux-system-2.6.26-2-xen-amd64
> Version: 2.6.26-26lenny1
> Severity: critical
> Justification: breaks the whole system
>=20
>=20
> Similar to: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D596419,
> we have several Debian lenny systems running Xen that crash at the
> aacraid driver ('drivers/scsi/aacraid/aachba.c:2825') when using the
> 2.6.26-26lenny1 version of the kernel. In our situation, this will
> happen every few days, maybe once a week while we run an IO/CPU heavy
> backup using 'duplicity'.
[...]

If this driver is ever unable to set up DMA then it crashes.  This means
it's broken in any system with an IOMMU (including Xen's software
IOMMU).

The same bug exists in mainline Linux today.

Ben.

--=20
Ben Hutchings
Lowery's Law:
             If it jams, force it. If it breaks, it needed replacing anyway=
.

--=-iNogjIStJODittZFsCX8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATfAbque/yOyVhhEJAQpKjBAAq9GL4G3aYFbjHLtti3f70LvRW33Cc6Op
CL+UQMJ/WVSB/si6xLDEoYGcqbV1BQykNtfulGJ1blgQjaWqTm5+QdDv08y964DN
naFX9MvINc6OdQsWa+5yGTNDjI0vLrHmxhj/UC8SeGn2Ep8F8WrLEVfBM4NpgTDl
iICpymM5mMRn/vYgJliEJRMTVIxuRzifguR0lXn3L6xSJPS1bdKith2lWZZl4G0w
VPA1FVprhoCcDdfOJraKUi0sJhQ3StoHCB+gxjIdsCQAT9MV0KqDK/yGswxl6mK+
4WFcH4swBm4COk81sxnTzSLUSeLSPI/lB6MCSna9K13r4ulLUvP9f0d+bPkvymSQ
bZ63UzHRBfKj05lbwwA1i7Asbvb1+ISfP5vE3fmfkbylbVrruhynuKgVhvJYecTd
J8xlsgIsBYZauChAextIgShtUkaM58RJp8LycQpCizsb0tiphytN9gqOqnjG1G+E
qDgWPbe+c1fE6f8CDJQiJ7NjZmR5/fT77f6r+/NcyeKuWps7XK7a904gXWAG02k4
gW6bzkyjvnpF/DmCySP9zjCWWGZ/4Ib6765dTAdZb4wDB0FjFolrXhNEwFIvt4zW
Kj6ewDcDHYTjjf/dYQuLle2WXsw1aASqhdRUQ3vBvpk1ZkCKaXxDHbeORp5QCCAj
kjAT6tdEaBQ=
=Ts0c
-----END PGP SIGNATURE-----

--=-iNogjIStJODittZFsCX8--
