From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 1/1] qed: Add firmware 8.33.1.0
Date: Thu, 23 Nov 2017 01:08:37 +0000
Message-ID: <1511399317.14687.0.camel@decadent.org.uk>
References: <20171011075753.8900-1-rahul.verma@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-JYe2FBNTIQ9tPXUh5T7B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011075753.8900-1-rahul.verma-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rahul Verma <rahul.verma-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, kyle-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-firmware-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ariel.elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--=-JYe2FBNTIQ9tPXUh5T7B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-10-11 at 00:57 -0700, Rahul Verma wrote:
> The new qed firmware contains fixes to firmware and added
> support for new features,
> -Add UFP support and drop action support.
> -DCQCN support for unlimited number of QP
> -Add IP type to GFT filter profile.
> -Added new TCP function counters.
> -Support flow ID in aRFS flow.
>=20
> Signed-off-by: Rahul Verma <rahul.verma-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  WHENCE                                  |   1 +
>  qed/qed_init_values_zipped-8.33.1.0.bin | Bin 0 -> 838612 bytes
>  2 files changed, 1 insertion(+)
>  create mode 100755 qed/qed_init_values_zipped-8.33.1.0.bin
[...]

Applied; sorry for the delay.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson


--=-JYe2FBNTIQ9tPXUh5T7B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAloWH5UACgkQ57/I7JWG
EQnBkQ//fA6tXCzJTONP4w2W2bXxN6uCTkkbHzo/huCA6qCusogxzYYH9frofRrs
CA9+8hQeAFxCHBv1Oh8E5zxEKXZlx3deszbRtzGj/jfN8Ke+SERZ//2pgU5t5NjO
jLYPHiEo9gfRR5pnxp8MSQK/ey3Jn7s+M70275lHJqJqcU1ypU2VGKkXKhWx3PfU
4LcsxiX9ZTKyFZXjBx9V5/vlj8KDbojwHMqTNBSGVDsuFEie6KVJ01mnfCPsfheM
zPzHl/qSYSwIJJAUM3eSICeW6EvZnnlnmexHWBCeyFRoer4bRNi/Vj8Htt/WPch1
csoeFOvJs68tTCUddesYOCbBSIR7pmfLgfR3//11wGBZwmWSS6pdZE32v/VzNXhs
JVywxJ1DaUOJarpqWTk8Q/i7Z4RPPT1cQgh/MvRWY/2AVQaHFZd9aekPbxGcNV33
4hQ0CPMi9siU/JZnrKIZVz57m5FjAG1lqe/yC/Ijv3yli5nJXGmkwrGR2RU5knRn
khm9V0VY1gcKBV2wztF5IzZDFNJ/BwNDCRQcsga6S5q18nyCz4At7AbYg44Q0HZY
qtmPJqUxKrio6lDL2mmCvTNe4UNwzixGXpCQiy/DLtLLYZDnM2AVRulECNqlvJSC
YFXrbwEs/xa5o4WMF9utdAlnj+V/hrvaAT6dwgj2GYyS0o33+Kg=
=KI6S
-----END PGP SIGNATURE-----

--=-JYe2FBNTIQ9tPXUh5T7B--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
