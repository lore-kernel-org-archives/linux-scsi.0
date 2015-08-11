From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 1/3] cxlflash: Base error recovery support
Date: Tue, 11 Aug 2015 16:21:13 +1000
Message-ID: <1439274073.24419.25.camel@axtens.net>
References: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vgVnRI2G1I2Uo5pDr2Tm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34793 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbbHKGXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 02:23:34 -0400
Received: by pawu10 with SMTP id u10so157117147paw.1
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2015 23:23:34 -0700 (PDT)
In-Reply-To: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


--=-vgVnRI2G1I2Uo5pDr2Tm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Actually, I forgot one thing:

> =20
>  config CXLFLASH
>  	tristate "Support for IBM CAPI Flash"
> -	depends on PCI && SCSI && CXL
> +	depends on PCI && SCSI && CXL && EEH

Should you depend on CXL_EEH here, seeing as you use CONFIG_CXL_EEH?

> =20
> +#ifndef CONFIG_CXL_EEH
> +#define cxl_perst_reloads_same_image(_a, _b) do { } while (0)
> +#endif
> +
>  #endif /* _CXLFLASH_MAIN_H */

--=20
Regards,
Daniel

--=-vgVnRI2G1I2Uo5pDr2Tm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: GPGTools - https://gpgtools.org

iQIcBAABCgAGBQJVyZRaAAoJEPC3R3P2I92F4EQP/2avDfl9aCM1XFXB85CR+b5t
ejeI7aGn8w+MkyGu8OO+ryjKIYD1JuNNJhxrjdI8XLiqDUSTwytt2BUpsCwHddZ8
C1Df7d/mh8sgfKVNz61B94S75PUKL1H/Ld8qSHq76dtARjXWKRDWs/1vGkf4xgCe
98wl7klRQD/NSTGmdgtOPvBJ74TqOrujoVjQjPWBBFgidJSTaxRQa60fulHi49SV
GsKKCFyJJCyouD8BnAMjYTzXbBsaDV18LQDyWMDAuO6CEw4DakitXmciQl6ppJnt
7FDMOfe90ULSIcfXHl1RCivTbL6Dw5lKG0ha+IpjP46qOLGtpr29apTZPZlxnvO5
dQ8GbpMIzentkZ0nxJZDBz6q/i9yMyuPwBIApYVmNHwakW4AWhNfyD3RGEdYHlSy
6zDzJBMzmG8PNQxhnMsN5z8aQbhGH7qLXMAkTEVeNopnRkCd6mlTyyuWzTqXz79w
PIgzHHOJ5D2VTat8xT4xY2pv5BoGXtoXy5E1mCwEV2H8baTN1m894xziKngbr9X3
vrTMcChpYkNx/+tKgYgQxrZL6FL3EtWRsi4kL9EeumvD6WhwaSxOPcQHbnNRwEsb
fwayWP3zzns1pyGjky5iXOjWXLgqcSJb8YKCojwoeowXjwfQMoYlYjcTMQWS2GOH
DVBdMWSQTM6Le55GVfl7
=EbO5
-----END PGP SIGNATURE-----

--=-vgVnRI2G1I2Uo5pDr2Tm--

