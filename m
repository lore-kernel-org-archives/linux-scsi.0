From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [PATCH] scsi: qedi: fix spelling mistake "oflload" -> "offload"
Date: Thu, 18 Apr 2019 11:29:31 +0530
Message-ID: <071b73b2-424d-0bb0-a663-c63ee0a94425@codeaurora.org>
References: <20190417134304.10979-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417134304.10979-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 4/17/2019 7:13 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There are a couple of spelling mistakes in some kernel alert messages.
> Fix these.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh
> ---
>   drivers/scsi/qedi/qedi_iscsi.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 6d6d6013e35b..e4391ee2c27a 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -579,7 +579,7 @@ static int qedi_conn_start(struct iscsi_cls_conn *cls_conn)
>   	rval = qedi_iscsi_update_conn(qedi, qedi_conn);
>   	if (rval) {
>   		iscsi_conn_printk(KERN_ALERT, conn,
> -				  "conn_start: FW oflload conn failed.\n");
> +				  "conn_start: FW offload conn failed.\n");
>   		rval = -EINVAL;
>   		goto start_err;
>   	}
> @@ -590,7 +590,7 @@ static int qedi_conn_start(struct iscsi_cls_conn *cls_conn)
>   	rval = iscsi_conn_start(cls_conn);
>   	if (rval) {
>   		iscsi_conn_printk(KERN_ALERT, conn,
> -				  "iscsi_conn_start: FW oflload conn failed!!\n");
> +				  "iscsi_conn_start: FW offload conn failed!!\n");
>   	}
>   
>   start_err:
