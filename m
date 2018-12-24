From: Manish Rangankar <mrangankar@marvell.com>
Subject: RE: [EXT] [PATCH -next] scsi: qla4xxx: check return code of
 qla4xxx_copy_from_fwddb_param
Date: Mon, 24 Dec 2018 08:49:49 +0000
Message-ID: <DM5PR18MB21349BAF4AF8E373EE037969D8BB0@DM5PR18MB2134.namprd18.prod.outlook.com>
References: <20181220031607.10588-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181220031607.10588-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: YueHaibing <yuehaibing@huawei.com>
> Sent: Thursday, December 20, 2018 8:46 AM
> To: QLogic-Storage-Upstream@qlogic.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; YueHaibing
> <yuehaibing@huawei.com>
> Subject: [EXT] [PATCH -next] scsi: qla4xxx: check return code of
> qla4xxx_copy_from_fwddb_param
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> External Email
>=20
> The return code should be check while qla4xxx_copy_from_fwddb_param fails=
.
>=20
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c index
> 949e186..1bc4db6 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -7232,6 +7232,8 @@ static int qla4xxx_sysfs_ddb_tgt_create(struct
> scsi_qla_host *ha,
>=20
>         rc =3D qla4xxx_copy_from_fwddb_param(fnode_sess, fnode_conn,
>                                            fw_ddb_entry);
> +       if (rc)
> +               goto free_sess;
>=20
>         ql4_printk(KERN_INFO, ha, "%s: sysfs entry %s created\n",
>                    __func__, fnode_sess->dev.kobj.name);
> --
> 2.7.0
>=20

Thanks
Acked-by: Manish Rangankar <mrangankar@marvell.com>
