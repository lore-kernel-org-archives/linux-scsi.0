From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 07/17] lpfc: Code cleanup for lpfc_enable_rrq parameter
Date: Fri, 14 Oct 2016 12:34:43 +0200
Message-ID: <b6b3ec7f-cf1e-b9bf-7224-167bec9c3f13@suse.de>
References: <58000550.mGmznF0pv+Q11PU7%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45697 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753753AbcJNKfW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 06:35:22 -0400
In-Reply-To: <58000550.mGmznF0pv+Q11PU7%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> Code cleanup for lpfc_enable_rrq parameter
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index e5092dc..22a66c7 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2759,18 +2759,14 @@ LPFC_ATTR_R(enable_npiv, 1, 0, 1,
>  LPFC_ATTR_R(fcf_failover_policy, 1, 1, 2,
>  	"FCF Fast failover=1 Priority failover=2");
>  
> -int lpfc_enable_rrq = 2;
> -module_param(lpfc_enable_rrq, int, S_IRUGO);
> -MODULE_PARM_DESC(lpfc_enable_rrq, "Enable RRQ functionality");
> -lpfc_param_show(enable_rrq);
>  /*
>  # lpfc_enable_rrq: Track XRI/OXID reuse after IO failures
>  #	0x0 = disabled, XRI/OXID use not tracked.
>  #	0x1 = XRI/OXID reuse is timed with ratov, RRQ sent.
>  #	0x2 = XRI/OXID reuse is timed with ratov, No RRQ sent.
>  */
> -lpfc_param_init(enable_rrq, 2, 0, 2);
> -static DEVICE_ATTR(lpfc_enable_rrq, S_IRUGO, lpfc_enable_rrq_show, NULL);
> +LPFC_ATTR_R(enable_rrq, 2, 0, 2,
> +	"Enable RRQ functionality");
>  
>  /*
>  # lpfc_suppress_link_up:  Bring link up at initialization
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
