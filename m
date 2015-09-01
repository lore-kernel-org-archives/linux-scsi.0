From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 06/14] lpfc:Make the function
 lpfc_sli4_mbox_completions_pending static in order to comply with function
 prototype
Date: Tue, 1 Sep 2015 23:32:55 +0200
Message-ID: <20150901233255.00000c8a@localhost>
References: <55e4bd8d.880iZVpjZfJsbEZL%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59445 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbbIAVdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 17:33:08 -0400
In-Reply-To: <55e4bd8d.880iZVpjZfJsbEZL%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> 
> From: Nicholas Krause <xerofoify@gmail.com>
> 
> This makes the function lpfc_sli4_mbox_completion's definition
> static now in order to comply with its prototype being also
> declared as static too.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 4feb931..95d53c7 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -6696,7 +6696,7 @@ lpfc_mbox_timeout(unsigned long ptr)
>   * This function checks if any mailbox completions are present on the mailbox
>   * completion queue.
>   **/
> -bool
> +static bool
>  lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
>  {
>  

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
