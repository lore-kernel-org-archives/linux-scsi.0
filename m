From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/21] lpfc: Fix the iteration count to match the 30 sec
 comment
Date: Sat, 07 Mar 2015 08:44:10 -0800
Message-ID: <1425746650.2969.3.camel@HansenPartnership.com>
References: <1423164184.7917.25.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41810 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbbCGQoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2015 11:44:12 -0500
In-Reply-To: <1423164184.7917.25.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2015-02-05 at 14:23 -0500, James Smart wrote:
> ---

Could you put the signoffs (and any changelog) above here, please.  You
seem to be using git to generate the patches, so if you just put them in
the git change log the right thing will happen.  If you don't do this,
all your patches have to be hand edited to apply them, which is a royal
pain for a maintainer.

>  drivers/scsi/lpfc/lpfc_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 0b2c53a..2b5b910 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -7953,7 +7953,7 @@ wait:
>  		 * up to 30 seconds. If the port doesn't respond, treat
>  		 * it as an error.
>  		 */
> -		for (rdy_chk = 0; rdy_chk < 3000; rdy_chk++) {
> +		for (rdy_chk = 0; rdy_chk < 1500; rdy_chk++) {
>  			if (lpfc_readl(phba->sli4_hba.u.if_type2.
>  				STATUSregaddr, &reg_data.word0)) {
>  				rc = -ENODEV;
> -- 
> 1.7.11.7
> 
> Signed-off-by: James Smart <james.smart@emulex.com>
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>

I'm not quite understanding this signoff chain.  It reads like Dick
Kennedy is the author, in which case the patch needs a From: <him> at
the top to make this clear.  If it's jointly authored, then
traditionally he'd still be the first signoff because the series of
signoffs represents the transmission chain and you send the patch, so
you should be last signoff.

James


