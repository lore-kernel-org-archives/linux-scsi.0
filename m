From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/17] lpfc: NVME Initiator: Base modifications Part D
Date: Wed, 18 Jan 2017 08:21:13 +0100
Message-ID: <4ed90da6-7ae6-a4f4-a036-7a01f1ed8b39@suse.de>
References: <587ec2f0.FOr4W1UKpsGdXJmP%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750830AbdARHfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 02:35:12 -0500
In-Reply-To: <587ec2f0.FOr4W1UKpsGdXJmP%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part D of parts A..F.
> 
> Part D is the 2nd half of the mods to lpfc_init.c. This is the location
> of most of changes for the following:
> - sli3 ring vs sli4 wq splits
> - buffer pools are allocated/freed
> - sgl pools allocated/freed
> - adapter resources split up
> - queue config decided and enacted
> - receive buffer management
> 
> *********
> 
> Refer to Part A for a description of base modifications
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 1088 +++++++++++++++++++++++------------------
>  1 file changed, 616 insertions(+), 472 deletions(-)
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
