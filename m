From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [SCSI] qla2xxx: Remove version.h header file inclusion
Date: Sun, 03 Jun 2012 12:51:27 -0700
Message-ID: <1338753087.4238.26.camel@haakon2.linux-iscsi.org>
References: <1338742621-11044-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1338742621-11044-1-git-send-email-sachin.kamat@linaro.org>
Sender: target-devel-owner@vger.kernel.org
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-driver@qlogic.com, andrew.vasquez@qlogic.com, patches@linaro.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2012-06-03 at 22:27 +0530, Sachin Kamat wrote:
> version.h header file is no longer required.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/scsi/qla2xxx/qla_target.c |    1 -
>  drivers/scsi/qla2xxx/qla_target.h |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
> 

Hi Sachin,

> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 04f80eb..f7a49e4 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -26,7 +26,6 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> -#include <linux/version.h>
>  #include <linux/blkdev.h>
>  #include <linux/interrupt.h>
>  #include <linux/pci.h>
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> index 9ec19bc..9f9ef16 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -919,7 +919,6 @@ struct qla_tgt_srr_ctio {
>  #define QLA_TGT_XMIT_STATUS		2
>  #define QLA_TGT_XMIT_ALL		(QLA_TGT_XMIT_STATUS|QLA_TGT_XMIT_DATA)
>  
> -#include <linux/version.h>
>  
>  extern struct qla_tgt_data qla_target;
>  /*

Looks fine to me..

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
