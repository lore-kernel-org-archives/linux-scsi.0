From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/6] qla2xxx: Update Driver version to 10.00.00.00-k
Date: Thu, 22 Jun 2017 08:33:49 +0200
Message-ID: <a4dad2ab-9e2f-3104-0694-fda3f8368dee@suse.de>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
 <20170621204846.21663-7-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751064AbdFVGdv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 02:33:51 -0400
In-Reply-To: <20170621204846.21663-7-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: darren.trapp@cavium.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, giridhar.malavali@cavium.com

On 06/21/2017 10:48 PM, Madhani, Himanshu wrote:
> From: Himanshu Madhani <himanshu.madhani@cavium.com>
> 
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/qla2xxx/qla_version.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
> index dcbb9bb05e99..005a378f7fab 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -7,9 +7,9 @@
>  /*
>   * Driver version
>   */
> -#define QLA2XXX_VERSION      "9.01.00.00-k"
> +#define QLA2XXX_VERSION      "10.00.00.00-k"
>  
> -#define QLA_DRIVER_MAJOR_VER	9
> -#define QLA_DRIVER_MINOR_VER	1
> +#define QLA_DRIVER_MAJOR_VER	10
> +#define QLA_DRIVER_MINOR_VER	0
>  #define QLA_DRIVER_PATCH_VER	0
>  #define QLA_DRIVER_BETA_VER	0
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
