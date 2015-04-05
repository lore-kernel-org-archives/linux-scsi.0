From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 01/21] lpfc: Fix the iteration count to match the 30 sec
 comment in the routine lpfc_pci_function_reset
Date: Sun, 5 Apr 2015 15:08:21 +0200
Message-ID: <20150405150821.00000f98@localhost>
References: <1428095421.6933.29.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59600 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbbDENIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Apr 2015 09:08:46 -0400
In-Reply-To: <1428095421.6933.29.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> Fix the iteration count to match the 30 sec comment in the routine lpfc_pci_function_reset
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
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

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
