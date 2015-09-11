From: David Gibson <dgibson@redhat.com>
Subject: Re: [PATCH 3/3] ibmvsci: Allow to configure maximum LUN
Date: Fri, 11 Sep 2015 10:54:30 +1000
Message-ID: <20150911105430.7b0bb2fa@voom.fritz.box>
References: <1441876994-16821-1-git-send-email-lvivier@redhat.com>
	<1441876994-16821-3-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BKwO7a0oVE9vZueQLY6CwTn"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441876994-16821-3-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, thuth@redhat.com, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

--Sig_/BKwO7a0oVE9vZueQLY6CwTn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Sep 2015 11:23:14 +0200
Laurent Vivier <lvivier@redhat.com> wrote:

> QEMU allows until 32 LUNs.
>=20
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibm=
vscsi.c
> index f9d7ec4..e5478b0 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -84,6 +84,7 @@
>   */
>  static int max_id =3D 64;
>  static int max_channel =3D 3;
> +static int max_lun =3D 8;
>  static int init_timeout =3D 300;
>  static int login_timeout =3D 60;
>  static int info_timeout =3D 30;
> @@ -117,6 +118,8 @@ module_param_named(fast_fail, fast_fail, int, S_IRUGO=
 | S_IWUSR);
>  MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=3D1]");
>  module_param_named(client_reserve, client_reserve, int, S_IRUGO );
>  MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/release=
");
> +module_param(max_lun, int, S_IRUGO);
> +MODULE_PARM_DESC(max_lun, "Maximum LUN value [Default=3D8]");
> =20
>  static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>  				struct ibmvscsi_host_data *hostdata);
> @@ -2289,7 +2292,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, con=
st struct vio_device_id *id)
>  		goto init_pool_failed;
>  	}
> =20
> -	host->max_lun =3D 8;
> +	host->max_lun =3D max_lun;
>  	host->max_id =3D max_id;
>  	host->max_channel =3D max_channel;
>  	host->max_cmd_len =3D 16;
> --=20
> 2.1.0
>=20


--=20
David Gibson <dgibson@redhat.com>
Senior Software Engineer, Virtualization, Red Hat

--=20
David Gibson <dgibson@redhat.com>
Senior Software Engineer, Virtualization, Red Hat

--Sig_/BKwO7a0oVE9vZueQLY6CwTn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV8iZGAAoJEGw4ysog2bOShNUQAIH2kf9g3dOoUC76AhMUwlPG
KXqZfurUNa0YeyQAsw9U5EKvSvCrd8PfhH7IBpGbN1l7OMnhS8fOk2OW39X6NxUZ
xQAOeSqn4DvTPCqM9KhAdvh7fMkObQgrEq6QIEVIH2TiE5o0rjTNoQLeRvjjo8Ae
xosSuFW4DmuOh0tLaTxIhBPJ/pVqifeKZYkNJ3Yi9KOppOdBSQsFh1vSrEWtbloC
mFh8pQ7dhAzkm6+tuH6JncO0oIvbPKkVjx3JHzTYESD3J7saUGjThVyTj75haXiI
MQDGcHD+/CGJjA9o4rvgyhc3ampTQhAF9ttyUNgCsk7bsMNqih8/dybkZtsb4eDq
nqmGChhJU5+jYypEg3zXyk8hIP/4Z5G7FA+w9pjs2gIxSYcJtL/gHwkNQAkVKahV
u4HlNFSdcP7bd47llklb5MYAEpUY4Xgn//l++IDEhXrI94oJ+Y8pZ0WSX421usHM
NE9VDGWtm717BCCjedFQdZZ2ZUJHl0Un5jdOt2e6dxmJj8eSQ2gurWw5fgUvXB0l
q//WC/9diukJpL0Kwpi2VIz2aI0aNOBxSOOTJAa34i/KbEdBmEemlUDGS/2FZdCK
FSzsSaNa0393KIt36rZJsAGaRWeK8ZOCktCF+VSM34lyn285i+858cUIsxvT9UTQ
R71s8JEihKnWFUe1b97A
=Xe5N
-----END PGP SIGNATURE-----

--Sig_/BKwO7a0oVE9vZueQLY6CwTn--
