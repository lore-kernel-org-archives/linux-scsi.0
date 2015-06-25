From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] bnxfc:Make the function bnx2fc_alloc_work static
Date: Thu, 25 Jun 2015 13:38:54 -0400
Message-ID: <alpine.OSX.2.00.1506251338190.1447@administrators-macbook-pro.local>
References: <1435090966-31918-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435090966-31918-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: QLogic-Storage-Upstream@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Make sense.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Tue, 23 Jun 2015, Nicholas Krause wrote:

> This makes the function bnx_2fc_alloc_work static now due
> to this function's only caller being in this particular
> function's definition/declaration file of bnx2fc_hwi.c.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
> drivers/scsi/bnx2fc/bnx2fc_hwi.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> index c6688d7..15eef07 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> @@ -994,7 +994,7 @@ void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
>
> }
>
> -struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
> +static struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
> {
> 	struct bnx2fc_work *work;
> 	work = kzalloc(sizeof(struct bnx2fc_work), GFP_ATOMIC);
>
