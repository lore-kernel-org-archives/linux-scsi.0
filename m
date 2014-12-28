From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] Initialize off value in asd_process_ctrl_a_user()
Date: Sun, 28 Dec 2014 16:12:16 +0100
Message-ID: <1419779536.4705.183.camel@decadent.org.uk>
References: <1417538041-6850-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Sq0PTv2v8yVcNJppV786"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1417538041-6850-1-git-send-email-emunson@akamai.com>
Sender: stable-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-Sq0PTv2v8yVcNJppV786
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-12-02 at 11:34 -0500, Eric B Munson wrote:
> If the asd_find_flash_de() function returns ENOENT the off value will
> be used uninitialized in the call to asd_read_flash_seg().

This is just papering over the problem.  This was my attempt at a proper
fix: http://article.gmane.org/gmane.linux.scsi/91320

Ben.

> Signed-off-by: Eric B Munson <emunson@akamai.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/aic94xx/aic94xx_sds.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/ai=
c94xx_sds.c
> index edb43fd..6f6a5b8 100644
> --- a/drivers/scsi/aic94xx/aic94xx_sds.c
> +++ b/drivers/scsi/aic94xx/aic94xx_sds.c
> @@ -982,7 +982,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_stru=
ct *asd_ha,
>  				   struct asd_flash_dir *flash_dir)
>  {
>  	int err, i;
> -	u32 offs, size;
> +	u32 offs =3D 0, size;
>  	struct asd_ll_el *el;
>  	struct asd_ctrla_phy_settings *ps;
>  	struct asd_ctrla_phy_settings dflt_ps;

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-Sq0PTv2v8yVcNJppV786
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVKAd1ee/yOyVhhEJAQq/WxAAwRRJ3fx+5TKMHki7q+x2Kw/mHL/1hX7d
WYE09pe8uhCbAJnS/Yv2m3GcTVg8VaqiVZ1pXziB0tfEurrxayqDnPyEBXk0BLWk
2pVVZt+tXGBkx0m8R4H9EoTL6cn/xW5+j+w3NtPg8DA6iTMd18P6E8D9ONf3wFft
hD+1hCTQSehkAJ06tiu/uLApkg59Qi0TJFZgTxiQEaakaO7VBaK3dHbaS0xw2CS2
aLfclKYIUtOntr1eC1mPbS0TNbGSLZsxC1b1ADLWWBXUd9xR8bQ611Ksb8HW0WRE
nCIgk8tVFUjtOz+nRrDsErN1HnhUpAZ6v94rMW4J2B6Fsfo1dynkb2fqQp62aEs5
4XoLaOriHlUKdwpvrb7KrctYwJ04yKVtvm6HsVIF394IK8SiYmUIyxDtyvKrhycQ
+xfV/z21R7A7mHHGp7ycFFs2PsTiVi2c3iMuFAAC50zs2F5VmPKtRcyb3BBm7o8X
7zZzV2uUrVUFbIeJd9jWQev3f35st7SrUf6ZpvHvwLE7nLNrFJF6TNym3nhL5L4e
uZndFBTgMo+dA9/enJVrvVQVEpZCXbydWKYRufo3sXHNoCkBL9HM35vEZ2DhS6RQ
q6NU0j3vzNfBi+X0aEZC7kU1aRQa951iq7TzQE6zZCkWmfjkOKKZ+8n8Qmm4JSfM
s7zSwKC0Tvw=
=IrZy
-----END PGP SIGNATURE-----

--=-Sq0PTv2v8yVcNJppV786--
