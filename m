From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 2/2] bfa: Fix incorrect de-reference of pointer
Date: Thu, 03 Sep 2015 10:32:03 -0400
Message-ID: <1441290723.23183.323.camel@localhost.localdomain>
References: <1439462512-1911-1-git-send-email-anil.gurumurthy@qlogic.com>
	 <1439462512-1911-3-git-send-email-anil.gurumurthy@qlogic.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbbICOcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2015 10:32:05 -0400
In-Reply-To: <1439462512-1911-3-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com

On Thu, 2015-08-13 at 06:41 -0400, anil.gurumurthy@qlogic.com wrote:
> From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> 
> Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> Tested-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
> ---
>  drivers/scsi/bfa/bfa_ioc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
> index 4e71044..98f7e8c 100644
> --- a/drivers/scsi/bfa/bfa_ioc.c
> +++ b/drivers/scsi/bfa/bfa_ioc.c
> @@ -3878,7 +3878,7 @@ bfa_sfp_show_comp(struct bfa_sfp_s *sfp, struct bfi_mbmsg_s *msg)
>  		bfa_trc(sfp, sfp->data_valid);
>  		if (sfp->data_valid) {
>  			u32	size = sizeof(struct sfp_mem_s);
> -			u8 *des = (u8 *) &(sfp->sfpmem);
> +			u8 *des = (u8 *)(sfp->sfpmem);
>  			memcpy(des, sfp->dbuf_kva, size);
>  		}
>  		/*

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


