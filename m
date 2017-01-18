From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/17] lpfc: NVME Initiator: Base modifications Part F
Date: Wed, 18 Jan 2017 08:35:52 +0100
Message-ID: <96a2c350-8c20-491f-40a8-ec3dee77f597@suse.de>
References: <587ec2f2.fmE2wQTjIBsi69sa%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42624 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752689AbdARKN5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 05:13:57 -0500
In-Reply-To: <587ec2f2.fmE2wQTjIBsi69sa%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part F of parts A..F.
> 
> Part F is limited to lpfc_debugfs.[ch]. It contains the modifications in
> the existing debugfs snippets to work with the base modifications.
> 
> *********
> 
> Refer to Part A for a description of base modifications
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_debugfs.c | 535 +++++++++++++++++++++------------------
>  drivers/scsi/lpfc/lpfc_debugfs.h |  69 ++---
>  2 files changed, 324 insertions(+), 280 deletions(-)
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
