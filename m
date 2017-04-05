From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH v2] lsscsi: Fix truncation of 128-bit wwn
Date: Wed, 5 Apr 2017 18:26:32 +0800
Message-ID: <20170405102632.GA17863@redhat.com>
References: <20170317120140.22580-1-vaibhav@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753456AbdDEK0i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Apr 2017 06:26:38 -0400
Content-Disposition: inline
In-Reply-To: <20170317120140.22580-1-vaibhav@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vaibhav Jain <vaibhav@linux.vnet.ibm.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Jon Grimm <jon.grimm@canonical.com>, Vipin K Parashar <vipin@linux.vnet.ibm.com>, Ping Tian Han <pthan@cn.ibm.com>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2017 at 05:31:40PM +0530, Vaibhav Jain wrote:
> ---
> Change-log:
>=20
> v2..v1
> - Introduces macro DISK_WWN_MAX_LEN that defines the maximum length of
>   wwn read from devfs. (Gris Ge)
> - Fix the indentation using space instead of '\t' (Gris Ge)
Patch looks good to me and tested:

    Old:
        [12:2:0:0]   disk    0x600605b00a5796201f9744221d0dc  /dev/sdb
    Fix:
        [12:2:0:0]   disk    0x600605b00a5796201f9744221d0dc495  /dev/sdb

--=20
Gris Ge

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8f1XsqXpyNthgIbGbM3lj+QeKP8FAljkxlQACgkQbM3lj+Qe
KP9qLhAAmznAffZc0Mt4BxB0oRC66wrRI3hyGrNsdg0JoxC+ZP/DFmUmTPvAMa/t
kUGxeAJ07tsFqPTqKs7EfbP9OsXeFwiDbMzNK2qiMS5VkdPMBjy08/natJ0Mk3CN
4X1aWh917gp2brLhHRDyrZhq1325B39aTDOlGq+oeE/974Lb0cZFYzD/zLJMQZXu
8+x+en+wfHyuNypa2KisAPon3qsExYruKexT0GirnFGUy5AocQ/IiDb4pOWCu/K5
ZdAr2r0nxMJbkxMlYaJOz65nnhibwV6eNoofu7Lyn6fs2fW89iqpeJ3dByFeLf2B
nrinogwlagn3L8VYptVRRfx8JkPmiCFiFQsFKI1ZlXq055EMqGgnm9PwtyghTkB6
KoLIFpXIqr5qQyCLQYDR1Jal4InSOqxPks+Z4QLPMgjaJct+xF+8DDT+W7dw0qGg
XW9g6BEeAYS4ik/GGqDOI5UK4uUQIj/WSO6NnQI3WyzvQsODjd9uJYb6NhyB3nU9
fGAupBoQ67OrB5fX8kqB6+tRt2sizzLgcUqMhd9n30kgr5NukidI+fyHVALnk3XO
Wms3kSjIaJovtGoU7UXeVbgOybNQp0v5jWp5hv8AT5ySKsdRM4pp2NCVi6N+RY07
UclirH8Z8tYqeIW8L47nTzzK/Ok+o/vMgSrtJZMUR8miERyKSwQ=
=YOAP
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
