From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 06/17] lpfc: Code clean up for lpfc_iocb_cnt parameter
Date: Fri, 14 Oct 2016 12:34:18 +0200
Message-ID: <8fecac40-c209-0f49-a073-b31cd732d6be@suse.de>
References: <5800054f.Ar+cpLMC0lhh/wRC%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752215AbcJNKxp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 06:53:45 -0400
In-Reply-To: <5800054f.Ar+cpLMC0lhh/wRC%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> Code clean up for lpfc_iocb_cnt parameter
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index be81e61..e5092dc 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2827,14 +2827,8 @@ lpfc_txcmplq_hw_show(struct device *dev, struct device_attribute *attr,
>  static DEVICE_ATTR(txcmplq_hw, S_IRUGO,
>  			 lpfc_txcmplq_hw_show, NULL);
>  
> -int lpfc_iocb_cnt = 2;
> -module_param(lpfc_iocb_cnt, int, S_IRUGO);
> -MODULE_PARM_DESC(lpfc_iocb_cnt,
> +LPFC_ATTR_R(iocb_cnt, 2, 1, 5,
>  	"Number of IOCBs alloc for ELS, CT, and ABTS: 1k to 5k IOCBs");
> -lpfc_param_show(iocb_cnt);
> -lpfc_param_init(iocb_cnt, 2, 1, 5);
> -static DEVICE_ATTR(lpfc_iocb_cnt, S_IRUGO,
> -			 lpfc_iocb_cnt_show, NULL);
>  
>  /*
>  # lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
