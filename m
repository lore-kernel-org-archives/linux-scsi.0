From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [PATCH][next] scsi: qla2xxx: fix spelling mistake "alredy" ->
 "already"
Date: Tue, 9 Apr 2019 23:26:29 +0530
Message-ID: <f03ae123-abef-9e3d-95df-fec1cb81b6c0@codeaurora.org>
References: <20190408082014.1354-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190408082014.1354-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 4/8/2019 1:50 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a ql_log message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 1ca63e80a7fe..3a6160ca9b4a 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -205,7 +205,7 @@ static void qla_nvme_abort_work(struct work_struct *work)
>   	if (atomic_read(&sp->ref_count) == 0) {
>   		WARN_ON(1);
>   		ql_log(ql_log_info, fcport->vha, 0xffff,
> -			"%s: command alredy aborted on sp: %p\n",
> +			"%s: command already aborted on sp: %p\n",
>   			__func__, sp);
>   		return;
>   	}
