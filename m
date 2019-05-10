From: Manish Rangankar <mrangankar@marvell.com>
Subject: RE: [PATCH -next] scsi: qedi: remove set but not used variables
 'cdev' and 'udev'
Date: Fri, 10 May 2019 05:28:18 +0000
Message-ID: <BYAPR18MB248596EAD386EC09F380162DD80C0@BYAPR18MB2485.namprd18.prod.outlook.com>
References: <20190424080256.30012-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424080256.30012-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-
> owner@vger.kernel.org> On Behalf Of Yue Haibing
> Sent: Wednesday, April 24, 2019 1:33 PM
> To: QLogic-Storage-Upstream@cavium.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; YueHaibing
> <yuehaibing@huawei.com>
> Subject: [PATCH -next] scsi: qedi: remove set but not used variables 'cde=
v'
> and 'udev'
>=20
> From: YueHaibing <yuehaibing@huawei.com>
>=20
> Fixes gcc '-Wunused-but-set-variable' warning:
>=20
> drivers/scsi/qedi/qedi_iscsi.c: In function 'qedi_ep_connect':
> drivers/scsi/qedi/qedi_iscsi.c:813:23: warning: variable 'udev' set but n=
ot
> used [-Wunused-but-set-variable]
> drivers/scsi/qedi/qedi_iscsi.c:812:18: warning: variable 'cdev' set but n=
ot
> used [-Wunused-but-set-variable]
>=20
> They are never used since introduction.
>=20
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/scsi/qedi/qedi_iscsi.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscs=
i.c
> index e4391ee..688a6d8 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -809,8 +809,6 @@ qedi_ep_connect(struct Scsi_Host *shost, struct
> sockaddr *dst_addr,
>  	struct qedi_endpoint *qedi_ep;
>  	struct sockaddr_in *addr;
>  	struct sockaddr_in6 *addr6;
> -	struct qed_dev *cdev  =3D  NULL;
> -	struct qedi_uio_dev *udev =3D NULL;
>  	struct iscsi_path path_req;
>  	u32 msg_type =3D ISCSI_KEVENT_IF_DOWN;
>  	u32 iscsi_cid =3D QEDI_CID_RESERVED;
> @@ -830,8 +828,6 @@ qedi_ep_connect(struct Scsi_Host *shost, struct
> sockaddr *dst_addr,
>  	}
>=20
>  	qedi =3D iscsi_host_priv(shost);
> -	cdev =3D qedi->cdev;
> -	udev =3D qedi->udev;
>=20
>  	if (test_bit(QEDI_IN_OFFLINE, &qedi->flags) ||
>  	    test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
> --
> 2.7.4
>=20

Thanks,

Acked-by: Manish Rangankar <mrangankar@marvell.com>
