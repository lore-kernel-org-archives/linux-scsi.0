From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 10/16] lpfc: NVME Target: Base modifications
Date: Mon, 13 Feb 2017 10:03:15 +0100
Message-ID: <f16536c8-2824-d072-4400-b6c4e1d6ce1a@suse.de>
References: <58a0d922./Gplb8MulYx0CHwV%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38973 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751482AbdBMJDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 04:03:17 -0500
In-Reply-To: <58a0d922./Gplb8MulYx0CHwV%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/12/2017 10:52 PM, James Smart wrote:
> 
> NVME Target: Base modifications
> 
> This set of patches adds the base modifications for NVME target support
> 
> The base modifications consist of:
> - Additional module parameters or configuration tuning
> - Enablement of configuration mode for NVME target. Ties into the
>   queueing model put into place by the initiator basemods patches.
> - Target-specific buffer pools, dma pools, sgl pools
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
