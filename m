From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/17] lpfc: NVME Target: Base modifications
Date: Wed, 18 Jan 2017 08:55:25 +0100
Message-ID: <26f3a4b3-536c-ebb3-33ad-1310738767ca@suse.de>
References: <587ec2f6.uQ99ZJ9QnJjHI5YS%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49928 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751132AbdARHz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 02:55:28 -0500
In-Reply-To: <587ec2f6.uQ99ZJ9QnJjHI5YS%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Target: Base modifications
> 
> This set of patches adds the base modifications for NVME target support
> to the lpfc driver.
> 
> The base modifications consist of:
> - Additional module parameters or configuration tuning
> - Enablement of configuration mode for NVME target. Ties into the
>   queueing model put into place by the initiator basemods patches.
> - Target-specific buffer pools, dma pools, sgl pools
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h         |   6 +
>  drivers/scsi/lpfc/lpfc_attr.c    | 160 ++++++++++++++++++++++-
>  drivers/scsi/lpfc/lpfc_crtn.h    |  10 ++
>  drivers/scsi/lpfc/lpfc_debugfs.c |   7 +-
>  drivers/scsi/lpfc/lpfc_init.c    | 268 ++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/lpfc/lpfc_mem.c     | 167 ++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_nvmet.h   |  97 ++++++++++++++
>  drivers/scsi/lpfc/lpfc_sli.c     | 112 +++++++++++++++-
>  drivers/scsi/lpfc/lpfc_sli.h     |   1 +
>  drivers/scsi/lpfc/lpfc_sli4.h    |   6 +
>  10 files changed, 806 insertions(+), 28 deletions(-)
>  create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.h
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
