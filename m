Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60692F5C4C;
	Thu,  3 Jul 2025 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.28.40.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751566887; cv=none; b=Al0ExIBnDRkPFcybwUQq5xiIQdE722zLZEJIRu2+EwpgPHgItyJZbQlsLUAzi7sCKf7bz+jvvDx8dz1x4176hHhUxvlDhJnZWLtwOJJoE6MVxFE1GDiyM9lMD1WvAdPsvdWW2EhBKNdDym+DfjHlb8ZZNJsDBNRrmaqE1dpbRpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751566887; c=relaxed/simple;
	bh=rW7lsUbbdv45tTpapetNvocz8Ey2KxfxNvy9S+/4ky4=;
	h=Date:From:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IbbijTFY4tKwPvAaFCpkOdMLBbLy+/nmimt+9vZGTX0lx3j8ipVPizA9W2hzfwbWV18/fLImf1NOvP+BigPme5IbxnlbhCnzTyb9y8c+E7I+Ds9CquIEPNrHeBbn50+as/vXvkp0nS4ZJiqAgS4os7zkBMAquBRgywe1YB/84Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz; spf=pass smtp.mailfrom=nabijaczleweli.xyz; dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b=GH3J7u9A; arc=none smtp.client-ip=139.28.40.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b="GH3J7u9A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202505; t=1751566883;
	bh=rW7lsUbbdv45tTpapetNvocz8Ey2KxfxNvy9S+/4ky4=;
	h=Date:From:Cc:Subject:From;
	b=GH3J7u9AYkjLWF3HpCgzrO3zDvfP1w/sYUdLzwSbpkO2/yw4vZv8SDTOHwMCKzJPW
	 gLxNlxcSqpUJ8jZS9fw1etw//LKvUyKz7LwnU0uJCX050+O4uOmnlk3Ny4jDFiAANV
	 bW8RuX5L93TMSlMKFvMtKjR0twxZYFvDse2LWLLtuISZ2p/k4f0+oIbGXb/iC61xBz
	 soF9hFEEbeUYRoWo1cwC8YtJK9ay/byQuTSvAxeP/Pq75PN2P4Av4rtiErlyqqTeqL
	 XB15TxDUsIXG0Grqd5++X0CGvHo20h9V+KVEOj8wcCuIb6LhSNfzstnVnxRqiHn607
	 p6674km4V+OAg==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id A9817436;
	Thu,  3 Jul 2025 20:21:23 +0200 (CEST)
Date: Thu, 3 Jul 2025 20:21:23 +0200
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: Don Brace <don.brace@microchip.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	storagedev@microchip.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: hpsa: global: fix "take a while" typo
Message-ID: <x5n4ozo4ch2awphz74yea5y2qedu7m6zvmbvdfj3r7kxou2ngl@tarta.nabijaczleweli.xyz>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="luymollfbgmcjkdp"
Content-Disposition: inline
User-Agent: NeoMutt/20231221-2-4202cf-dirty


--luymollfbgmcjkdp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
v1: https://lore.kernel.org/lkml/h2ieddqja5jfrnuh3mvlxt6njrvp352t5rfzp2cvnr=
ufop6tch@tarta.nabijaczleweli.xyz/t/#u

 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c73a71ac3c29..0066f15153a7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7795,7 +7795,7 @@ static int hpsa_wait_for_mode_change_ack(struct ctlr_=
info *h)
 	u32 doorbell_value;
 	unsigned long flags;
=20
-	/* under certain very rare conditions, this can take awhile.
+	/* under certain very rare conditions, this can take a while.
 	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
 	 * as we enter this code.)
 	 */
--=20
2.39.5

--luymollfbgmcjkdp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmhmyiMACgkQvP0LAY0m
WPE11xAAjH+4T7ENRV7NeCxhRP0Yff64wq+8Z5cPubInknRQ+gF44iULL97Kf9Ju
K+E1B7pG9zytjIecfVKSiyIPpQVnnq7Dz3wg2NMHLzj8tb8Mbr/TrtylUnkOCErl
JkIvrqtMI9j7an1IAmYAnlNZ2DliSbH+IX4GTWyIP8xelcgkzMRLTsg9vwG5ONFu
kQovd0L7sXkzYsSROnVcKe5ZgK/QeTIxFe8755G9Rk00ojR+MhOsnyNxgM7cqd2q
SlyUsEXKi9LprrSPIgA2P4vU8hrVd6GZJzbMv2vNjVq1bKKbHeugucr9ujCuV/ZZ
UjAgEVoC0cb6GbfCtSa1Fc04+7eUJaGwyQ6oTHlkl01gSNLC7T5H2WcMszzletxS
LX8hkPNVmyihkq/zJ6qjP9mUUFLeNb3W/SfcLVH8IgC+9t8hs4rhu+pCVzAdxcAL
VfFW/ygyj1JRfyiudMcZ3A3PG/Gt96GU8rlyxfPoYHhfFjx4WOs8R7LvmidEBKp8
FRuxNwahyH6Uhj2p6rpt/Bfl2xXW6gvbS0Gk+d5ikGtN3/byAsbejYJ9PghIwVQW
gVSENkrtOmKuKvWHEuyDvyYGsmRDwL24UuqsvFv6LGph+8w4xndVycJkw8WxMr6A
qS1ppfVpu3DMNDWIwyhfWRiBIuTzXk2ADTNuRUsPcn94jaQh0eQ=
=QZvg
-----END PGP SIGNATURE-----

--luymollfbgmcjkdp--
