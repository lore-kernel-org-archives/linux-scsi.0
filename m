From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 1/3] scsi_debug: Increase the reported optimal transfer
 length
Date: Thu, 17 Dec 2015 08:18:58 -0500
Message-ID: <1450358338.22151.0.camel@localhost.localdomain>
References: <1450306433-20166-1-git-send-email-martin.petersen@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965081AbbLQNS7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 08:18:59 -0500
In-Reply-To: <1450306433-20166-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On Wed, 2015-12-16 at 17:53 -0500, Martin K. Petersen wrote:
> The OPTIMAL TRANSFER LENGTH reported by scsi_debug is 64 blocks which
> translates to 32KB with the default logical block size. That's much
> lower than what real storage devices typically report (256KB to 1MB).
> 
> Bump the optimal transfer length to 1024 blocks.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/scsi_debug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index d09d60293c27..b80b037f2982 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -129,7 +129,7 @@ static const char *scsi_debug_version_date = "20141022";
>  #define DEF_NO_LUN_0   0
>  #define DEF_NUM_PARTS   0
>  #define DEF_OPTS   0
> -#define DEF_OPT_BLKS 64
> +#define DEF_OPT_BLKS 1024
>  #define DEF_PHYSBLK_EXP 0
>  #define DEF_PTYPE   0
>  #define DEF_REMOVABLE false
> @@ -4140,7 +4140,7 @@ MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
>  MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
>  MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
>  MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
> -MODULE_PARM_DESC(opt_blks, "optimal transfer length in block (def=64)");
> +MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");
>  MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
>  MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
>  MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


