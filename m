From: Manish Rangankar <mrangankar@marvell.com>
Subject: RE: [PATCH] scsi: bnx2fc: remove unneeded variable
Date: Fri, 29 Mar 2019 04:13:00 +0000
Message-ID: <BYAPR18MB2485B5A8C2997C9075E3454CD85A0@BYAPR18MB2485.namprd18.prod.outlook.com>
References: <1553829852-16525-1-git-send-email-dingxiang@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553829852-16525-1-git-send-email-dingxiang@cmss.chinamobile.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ding Xiang <dingxiang@cmss.chinamobile.com>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Ding Xiang <dingxiang@cmss.chinamobile.com>
> Sent: Friday, March 29, 2019 8:54 AM
> To: QLogic-Storage-Upstream@qlogic.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] scsi: bnx2fc: remove unneeded variable
>=20
> "rc" is unneeded,just return SUCCESS
>=20
> Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
> b/drivers/scsi/bnx2fc/bnx2fc_io.c index bc9f2a2..8def63c 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1083,7 +1083,6 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd
> *sc_cmd)  static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)  {
>  	struct bnx2fc_rport *tgt =3D io_req->tgt;
> -	int rc =3D SUCCESS;
>  	unsigned int time_left;
>=20
>  	io_req->wait_for_comp =3D 1;
> @@ -1110,7 +1109,7 @@ static int bnx2fc_abts_cleanup(struct
> bnx2fc_cmd *io_req)
>  	kref_put(&io_req->refcount, bnx2fc_cmd_release);
>=20
>  	spin_lock_bh(&tgt->tgt_lock);
> -	return rc;
> +	return SUCCESS;
>  }
>=20
>  /**
> --
> 1.9.1
>=20

Thanks,
Acked-by: Manish Rangankar <mrangankar@marvell.com>
