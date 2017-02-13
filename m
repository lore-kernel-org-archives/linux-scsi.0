From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 08/16] lpfc: NVME Initiator: bind to nvme_fc api
Date: Mon, 13 Feb 2017 09:59:57 +0100
Message-ID: <75bdcb47-789e-7cbe-7c12-b7427c9ee7a4@suse.de>
References: <58a0d920.BHYSqh6Jz9Hoai1s%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdBMJAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 04:00:00 -0500
In-Reply-To: <58a0d920.BHYSqh6Jz9Hoai1s%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/12/2017 10:52 PM, James Smart wrote:
> 
> NVME Initiator: Tie in to NVME Fabrics nvme_fc LLDD initiator api
> 
> Adds the routines to:
> - register and deregister the FC port as a nvme-fc initiator localport
> - register and deregister remote FC ports as a nvme-fc remoteport
> - binding of nvme queues to adapter WQs
> - send/perform NVME LS's
> - send/perform NVME FCP initiator io operations
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
