From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] scsi: qla2xxx: fix typo "CT-PASSTRHU" -> "CT-PASSTHRU"
Date: Mon, 10 Sep 2018 17:49:14 +0000
Message-ID: <1E6E5FDA-33ED-4CBB-8E96-D3086EEE6B88@cavium.com>
References: <20180909222503.8298-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180909222503.8298-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <B4D122E14D73874EA4963BC24ED530EB@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Sep 9, 2018, at 3:25 PM, Colin King <colin.king@canonical.com> wrote:
>=20
> External Email
>=20
> From: Colin Ian King <colin.king@canonical.com>
>=20
> Trivial fix to typo in debug message text.
>=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> drivers/scsi/qla2xxx/qla_gs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.=
c
> index a0038d879b9d..b48ff0095843 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -4289,7 +4289,7 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha=
, struct srb *sp,
>        }
>=20
>        ql_dbg(ql_dbg_disc, vha, 0xfffff,
> -           "%s: FC4Type %x, CT-PASSTRHU %s command ctarg rsp size %d, ct=
arg req size %d\n",
> +           "%s: FC4Type %x, CT-PASSTHRU %s command ctarg rsp size %d, ct=
arg req size %d\n",
>            __func__, fc4_type, sp->name, sp->u.iocb_cmd.u.ctarg.rsp_size,
>             sp->u.iocb_cmd.u.ctarg.req_size);
>=20
> --
> 2.17.1
>=20

Acked-By: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
