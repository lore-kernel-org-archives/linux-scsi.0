From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/17] lpfc: NVME Target: Receive buffer updates
Date: Wed, 18 Jan 2017 09:02:02 +0100
Message-ID: <78a1e297-2f89-caf7-d4c2-ef0129420d14@suse.de>
References: <587ec2f7.pbBec53dehsFNPMw%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751157AbdARICE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 03:02:04 -0500
In-Reply-To: <587ec2f7.pbBec53dehsFNPMw%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Target: Receive buffer updates
> 
> Allocates buffer pools and configures adapter interfaces to handle
> receive buffer (asynchronous FCP CMD ius, first burst data)
> from the adapter. Splits by protocol, etc.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |   3 +
>  drivers/scsi/lpfc/lpfc_attr.c |  86 +++++-
>  drivers/scsi/lpfc/lpfc_crtn.h |   1 +
>  drivers/scsi/lpfc/lpfc_hw4.h  | 274 +++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_init.c | 264 +++++++++++++++++-
>  drivers/scsi/lpfc/lpfc_mbox.c |  87 ++++++
>  drivers/scsi/lpfc/lpfc_sli.c  | 608 +++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/lpfc/lpfc_sli4.h |  11 +
>  8 files changed, 1313 insertions(+), 21 deletions(-)
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
