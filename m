From: David Gibson <dgibson@redhat.com>
Subject: Re: [PATCH 1/3] ibmvsci: make parameters max_id and max_channel
 read-only
Date: Fri, 11 Sep 2015 10:52:51 +1000
Message-ID: <20150911105251.46a12120@voom.fritz.box>
References: <1441876994-16821-1-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/IT2n4JU.YOSd7_6fxpR6r_m"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbbIKAwi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2015 20:52:38 -0400
In-Reply-To: <1441876994-16821-1-git-send-email-lvivier@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, thuth@redhat.com, pbonzini@redhat.com

--Sig_/IT2n4JU.YOSd7_6fxpR6r_m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Sep 2015 11:23:12 +0200
Laurent Vivier <lvivier@redhat.com> wrote:

> The value of the parameter is never re-read by the driver,
> so a new value is ignored. Let know the user he
> can't modify it by removing writable attribute.
>=20
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
> I resend this patch as James was not cc'ed.
>=20
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibm=
vscsi.c
> index 6a41c36..3e76490 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -105,9 +105,9 @@ MODULE_AUTHOR("Dave Boutcher");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(IBMVSCSI_VERSION);
> =20
> -module_param_named(max_id, max_id, int, S_IRUGO | S_IWUSR);
> +module_param_named(max_id, max_id, int, S_IRUGO);
>  MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
> -module_param_named(max_channel, max_channel, int, S_IRUGO | S_IWUSR);
> +module_param_named(max_channel, max_channel, int, S_IRUGO);
>  MODULE_PARM_DESC(max_channel, "Largest channel value");
>  module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
> --=20
> 2.1.0
>=20


--=20
David Gibson <dgibson@redhat.com>
Senior Software Engineer, Virtualization, Red Hat

--Sig_/IT2n4JU.YOSd7_6fxpR6r_m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV8iXjAAoJEGw4ysog2bOSO4MQALaYT1ffC29XbOse1xJJspWm
WNBhDcvj1SmnZX5ue+001bnqy8ErJklXnItomUo7RYx6YF8iNiaqEXICr8WqO2Te
eTQhXCp27x97WWs1hJ5YqHfU8Ahtp5othfV8VprFe0OPyEvF4bZ3/TsXEGAPsX/H
uGoGv0x0tfQrAYiU+gaY5Mc88NCCF27UBjuxzzxt5kyte85Xwrz8M0MDn8+jZYek
0qKMDDeI5Q5rtaNjg3L4Wa25hdAV61VcMgAKAZ2MRs/SdlWW0aAoxxOy2f3lByZr
jE5WoQwRLqFhJf7mqk+wZUFq4d/i3lIG/5LKc1T6sUrGSzpeiwAo9S5+uGwjF+hv
/ogSfmGe91aQADNZ8vuzNMxHSexhKEPRq+KyH6HYeXmH+6N9pjVxy7/HsdzGIyA9
719RDghzX1w5yM076bkz5LmJx+uvjjL72b/NiO5TXct1W8n4jzoMORLi6id2zFg9
hVLwvciFe1Mcj0O3Dqcm49Me2G1Csa9PhlEcjPY5N21/skp2i3VH8GLr+14Kours
7iKv03n9Dasyb6vSVD6MoKLYZuYj8Qpm7McLpk+nDOeAguQR29vio/p/8QLOgvVe
R4+6zKA6+3QjdgJ7L52OCX9h3r3zEDJlRS8r8r6nL9kGrua+e5izys0unVW5Nosy
Qlg/XLZMTb5IFSSOcQIb
=w8G6
-----END PGP SIGNATURE-----

--Sig_/IT2n4JU.YOSd7_6fxpR6r_m--
