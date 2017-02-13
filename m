From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 13/16] lpfc: NVME Target: bind to nvmet_fc api
Date: Mon, 13 Feb 2017 10:17:17 +0100
Message-ID: <9b84947c-e44d-b5b8-e61a-b994e4d9dd80@suse.de>
References: <58a0d925.kcLFILjOKj1r3hVd%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40240 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751480AbdBMJRT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 04:17:19 -0500
In-Reply-To: <58a0d925.kcLFILjOKj1r3hVd%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/12/2017 10:52 PM, James Smart wrote:
> 
> NVME Target: Tie in to NVME Fabrics nvmet_fc LLDD target api
> 
> Adds the routines to:
> - register and deregister the FC port as a nvmet-fc targetport
> - binding of nvme queues to adapter WQs
> - receipt and passing of NVME LS's to transport, sending transport response
> - receipt of NVME FCP CMD IUs, processing FCP target io data transmission
>   commands; transmission of FCP io response
> - Abort operations for tgt io exchanges
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
