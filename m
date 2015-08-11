From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 1/3] cxlflash: Base error recovery support
Date: Tue, 11 Aug 2015 20:58:25 +1000
Message-ID: <1439290705.24419.30.camel@axtens.net>
References: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com>
	 <1439274073.24419.25.camel@axtens.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-aMf5Ek2ACvUhV/gx78Wp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33662 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbbHKLAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 07:00:50 -0400
Received: by pdrh1 with SMTP id h1so64510430pdr.0
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 04:00:47 -0700 (PDT)
In-Reply-To: <1439274073.24419.25.camel@axtens.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


--=-aMf5Ek2ACvUhV/gx78Wp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-08-11 at 16:21 +1000, Daniel Axtens wrote:
> Actually, I forgot one thing:
>=20
> > =20
> >  config CXLFLASH
> >  	tristate "Support for IBM CAPI Flash"
> > -	depends on PCI && SCSI && CXL
> > +	depends on PCI && SCSI && CXL && EEH
>=20
> Should you depend on CXL_EEH here, seeing as you use CONFIG_CXL_EEH?
>=20
Actually, never mind, I'm wrong. What you have is good.

> > =20
> > +#ifndef CONFIG_CXL_EEH
> > +#define cxl_perst_reloads_same_image(_a, _b) do { } while (0)
> > +#endif
> > +
> >  #endif /* _CXLFLASH_MAIN_H */
>=20

--=20
Regards,
Daniel

--=-aMf5Ek2ACvUhV/gx78Wp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: GPGTools - https://gpgtools.org

iQIcBAABCgAGBQJVydVRAAoJEPC3R3P2I92FXMMQAI02AnhrhnsqQMkGrjwQwiBj
BCs0qXSo3w/KdGl6bQppWlVg0VxpxQNT+yfT1kyi99A5PfdOLidfeFo8g/KUskIQ
OL158Sf4dqfLisDWoZzi2Xo7HJqHarUWZaZKAxyqgPRZvNE/VhcyvLxiD+Dg7Yqb
JsWExFKp8L0flKf5561RpGGfzwppIBzcBxaDB+p6+hC8oBH0WI43ZsGL3WE90Hlq
NudrJXXjckmjNjCelvDJGob8l79SOuhhAmpNMR+0mSGiVuI1WBcgN6vlA2xOOMgz
UPunG3/0MI4rmIAyqH2ulYy7yYOua/TUfbKB/yWy0s2JBgxguS1eeTpvNrPSws6x
EoBe7fjfx95Dl5IzuFe6xqgoX8Io+BgOQw24oOuGM9FSJn2Bhsdmqu7s80y/9t6f
HKfAv0ICrxGl5ZA8bf8ANs8B0UwMH2dwRtZMy2BDlsBsO+tM8EhZGwvUngKVTkZj
b8s1kmB6C8wlI7p9C6Jq7jdYaksUIvLCPpUAUd4T15/mIplJqNXe4tIjdCZUGcHp
tutzlfzVk1VCj5rVwsyMeHGm742PrtzfwZIB+JzAsa8jiwX1B5O5YynipvTmQSAw
MIMk/7DPPDQx9FMwsxrtAphQDOhrbM7RgAlhgDdP33KoozvbiJ1c8OqEgimqHUZr
X2RUl738s3U54WA09xRW
=M/2m
-----END PGP SIGNATURE-----

--=-aMf5Ek2ACvUhV/gx78Wp--

