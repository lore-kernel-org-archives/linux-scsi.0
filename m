From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix comment in MODULE_PARM_DESC in qla2xxx
Date: Wed, 26 Sep 2018 04:21:06 +0000
Message-ID: <E999CEA6-97FA-4E89-A6B5-FF976EC0F0F5@cavium.com>
References: <20180911094811.12681-1-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911094811.12681-1-standby24x7@gmail.com>
Content-Language: en-US
Content-ID: <3D4D58A776993A4FA72CD7DCF699D475@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Sep 11, 2018, at 2:48 AM, Masanari Iida <standby24x7@gmail.com> wrote:
>=20
> External Email
>=20
> Default value of ql2xasynctmfenable for qla2xxx driver was
> set to 1 in commit 043dc1d7e8501.
> But comment in MODULE_PARAM_DESC was not modified.
>=20
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 42b8f0d3e580..fe5404be73c5 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -204,7 +204,7 @@ int ql2xasynctmfenable =3D 1;
> module_param(ql2xasynctmfenable, int, S_IRUGO);
> MODULE_PARM_DESC(ql2xasynctmfenable,
>                "Enables issue of TM IOCBs asynchronously via IOCB mechani=
sm"
> -               "Default is 0 - Issue TM IOCBs via mailbox mechanism.");
> +               "Default is 1 - Issue TM IOCBs via mailbox mechanism.");
>=20
> int ql2xdontresethba;
> module_param(ql2xdontresethba, int, S_IRUGO|S_IWUSR);
> --
> 2.19.0
>=20

Thanks for the patch.=20

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

-Himanshu
