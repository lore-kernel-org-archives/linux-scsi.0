From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/17] lpfc: NVME Initiator: Base modifications Part B
Date: Wed, 18 Jan 2017 08:08:53 +0100
Message-ID: <59244b8d-3176-9d50-910c-62e48e411d88@suse.de>
References: <587ec2ee.01djIfQsSlhQj6k1%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46517 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750830AbdARHJv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 02:09:51 -0500
In-Reply-To: <587ec2ee.01djIfQsSlhQj6k1%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part B of parts A..F.
> 
> Part B is limited to lpfc_attr.c: lpfc attribute modifications
> 
> *********
> 
> Refer to Part A for a description of base modifications
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c | 448 ++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 405 insertions(+), 43 deletions(-)
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
