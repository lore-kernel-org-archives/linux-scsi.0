From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] scsi: qedi: fix another spelling mistake: "alloction" ->
 "allocation"
Date: Mon, 3 Jul 2017 10:30:32 +0000
Message-ID: <D5801A6D.3B20F%manish.rangankar@cavium.com>
References: <20170703102402.12853-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170703102402.12853-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <94BFCDB5EC969C4E8A6B8AD4D6FA8923@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 03/07/17 3:54 PM, "Colin King" <colin.king@canonical.com> wrote:

>From: Colin Ian King <colin.king@canonical.com>
>
>Trivial fix to spelling mistake in QEDF_ERR message.  I should have
>also included this in a previous fix, but I only just spotted this one.
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> drivers/scsi/qedi/qedi_fw.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
>index 19254bd739d9..93d54acd4a22 100644
>--- a/drivers/scsi/qedi/qedi_fw.c
>+++ b/drivers/scsi/qedi/qedi_fw.c
>@@ -1411,7 +1411,7 @@ static void qedi_tmf_work(struct work_struct *work)
>=20
> 	list_work =3D kzalloc(sizeof(*list_work), GFP_ATOMIC);
> 	if (!list_work) {
>-		QEDI_ERR(&qedi->dbg_ctx, "Memory alloction failed\n");
>+		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
> 		goto abort_ret;
> 	}
>=20
>--=20
>2.11.0
>
Thanks

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
