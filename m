From: David Gibson <dgibson@redhat.com>
Subject: Re: [PATCH 2/3] ibmvcsci: display default value for max_id, max_lun
 and max_channel.
Date: Fri, 11 Sep 2015 10:53:39 +1000
Message-ID: <20150911105339.67ab9c5f@voom.fritz.box>
References: <1441876994-16821-1-git-send-email-lvivier@redhat.com>
	<1441876994-16821-2-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/F+Mp8uk3BcyoH3Fkel7IbUv"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441876994-16821-2-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, thuth@redhat.com, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

--Sig_/F+Mp8uk3BcyoH3Fkel7IbUv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Sep 2015 11:23:13 +0200
Laurent Vivier <lvivier@redhat.com> wrote:

> As devices with values greater than that are silently ignored,
> this gives some hints to the sys admin to know why he doesn't see
> his devices...
>=20
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibm=
vscsi.c
> index 3e76490..f9d7ec4 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -106,9 +106,9 @@ MODULE_LICENSE("GPL");
>  MODULE_VERSION(IBMVSCSI_VERSION);
> =20
>  module_param_named(max_id, max_id, int, S_IRUGO);
> -MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
> +MODULE_PARM_DESC(max_id, "Largest ID value for each channel [Default=3D6=
4]");
>  module_param_named(max_channel, max_channel, int, S_IRUGO);
> -MODULE_PARM_DESC(max_channel, "Largest channel value");
> +MODULE_PARM_DESC(max_channel, "Largest channel value [Default=3D3]");
>  module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
>  module_param_named(max_requests, max_requests, int, S_IRUGO);
> @@ -2294,6 +2294,10 @@ static int ibmvscsi_probe(struct vio_dev *vdev, co=
nst struct vio_device_id *id)
>  	host->max_channel =3D max_channel;
>  	host->max_cmd_len =3D 16;
> =20
> +	dev_info(dev,
> +		 "Maximum ID: %d Maximum LUN: %d Maximum Channel: %d\n",
> +		 host->max_id, host->max_lun, host->max_channel);
> +
>  	if (scsi_add_host(hostdata->host, hostdata->dev))
>  		goto add_host_failed;
> =20
> --=20
> 2.1.0
>=20


--=20
David Gibson <dgibson@redhat.com>
Senior Software Engineer, Virtualization, Red Hat

--Sig_/F+Mp8uk3BcyoH3Fkel7IbUv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV8iYTAAoJEGw4ysog2bOStBkQALrE3F2sf29y1XVnphjGv0IZ
8ISDdqAzSMfGRnkWDkCW4/Fwjsd4WZMgbQXBF1BPReqMOhPsEq9vfh9+Z+i5adFZ
AUSIga6panA2oDow9RryxrFT/Mq3Js2C+AnkkQVaLYa+dw1EVLomjlndgM29EjOa
S4UtppUnNRVS2yUgOWK78NPu3cRywJlUESJZPm1yi5eM25O+hvRoHc3kaTNhbycG
tSYQqFp1kwO0jv97KeH47amXcNUehmPhNU05iff02C60EtsU/fRV4NXWr2d6NhAb
8P7xJfZ58NfK4OwcZ4pJ3l5YYG4bX7Dfn5SJUymCzABtWO1PrY0SIOSY8BdYn517
4+JNzA9beUqMR/wk3DBZWYPiZQ8mJ/PXdXhGHJEWZkt8nY6fZ6hFBiPSRMqL2ZhU
3JBcHDTsZlRL8S2vhFxbxAllO+Gt0olh1gvxpBdvV1uk0Xry8gene5sgIA3WUKhE
nNpPLmz98NPqSAUlhQ4QETPo5pUk8q9P1EJ0Zq9fiRv7ZpKT0EjcF+psp49Ml3NT
cjPwBv3LANpQy0XBuDACDRf3X6taNoVRxa87GfSBHL9QIwAwXtSOI88vaIRmC5Fk
4BrQrMbap3pSjDar61T+m7IyIs99evopsdA0bFj7SMUEj/+qa5ONDHCOC9infe9z
G6k9KgknPHGAUsO4rXRo
=rtok
-----END PGP SIGNATURE-----

--Sig_/F+Mp8uk3BcyoH3Fkel7IbUv--
