From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] be2iscsi: cleanup a min_t() call
Date: Fri, 18 Nov 2011 17:00:31 +0300
Message-ID: <20111118140031.GG4349@mwanda>
References: <20110926062337.GD11832@elgon.mountain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O8XZ+2Hy8Kj8wLPZ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:58420 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab1KRN7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2011 08:59:19 -0500
Content-Disposition: inline
In-Reply-To: <20110926062337.GD11832@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


--O8XZ+2Hy8Kj8wLPZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 26, 2011 at 09:23:37AM +0300, Dan Carpenter wrote:
> "sense_len" was declared as int type but actually it only stores a
> u16 value that comes from hardware.  The cast to u16 in min_t()
> confuses static analysis because it truncates the int to u16 so I've
> fixed the declaration to reflect that "sense_len" is just a u16.
>=20
> Also there was a call to cpu_to_be16() which I've changed to
> be16_to_cpu().  The functions are equivalent, but obviously the
> hardware is big endian and we're doing the min_t() comparison on CPU
> endian values.
>=20
> This whole patch is just a cleanup and doesn't affect how the code
> works.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Ping.

regards,
dan carpenter


--O8XZ+2Hy8Kj8wLPZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxmT/AAoJEOnZkXI/YHqRhL0P/iakUVR6g8SLZdjATvTKdexr
oWl4jyWDnq935BkNcOjDzkM80m6maFWmArnz8fkZoq7JhTQRYtHJhONi2tzCbVHO
jwolktbGQAc0TsgAbUnqIhlsZ83+F1UMNuhyag96CvNVpVB+ntfxdgvgVjkvu5eH
PZmP/6ORX4F8q0fQn6iYQ4j9lf2vJmr1CoI0sjbfEtN/tpB6v2r8I7P02HOeAF4B
TgA2pCcGmu14eye4bTv2CsePBEH5HYfZpJUuwCvu9V118pZ/WYXoKmU5fUfiqSyz
gGG9OAqiqm1/UznpUE1HNkM3c/QRCaC7/Q1ijScQg/YXMltPwfoF/JF83/0rKlEV
avywkxTiVkQSFi7A7/74oNfZaTR0EoJD89sZnDVKgv5Us6bxoeNerOI636VxJ2if
wlgyJqQXRZLNm1UrDKQa2eXrdAt2au6csXmlMc6tfjxb7ZplvtVmeIdIJwNK+2d4
/5RGjGo5B/wMIkSKomX82nFpG3EvwTbt06uRCrzl8L+WrG2Wq7lNCdnmwsjpj7Wx
FlHu8bfM/QkDGZ28rCtUHJPlK7ZhcFYIgPBMETUTevZCPJ5mrvuAkv/cVDp3VclO
yvB84afWO89BIgO/V5AWqsd83hHdGXFcI6if8tgJegcTJdL1nLMTlDK+Est9E1bC
P8UScMQ1ibgd2czLXZ9q
=szsT
-----END PGP SIGNATURE-----

--O8XZ+2Hy8Kj8wLPZ--
