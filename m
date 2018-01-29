From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/19] lpfc: Fix RQ empty firmware trap
Date: Mon, 29 Jan 2018 09:07:57 +0100
Message-ID: <4605d66f-7598-ae29-6f85-afaa9eee183f@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-9-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49396 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeA2KLN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:11:13 -0500
In-Reply-To: <20180124224548.9530-9-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> When nvme target deferred receive logic waits for exchange
> resources, the corresponding receive buffer is not replenished
> with the hardware. This can result in a lack of asynchronous
> receive buffer resources in the hardware, resulting in a
> "2885 Port Status Event: ... error 1=0x52004a01 ..." message.
> 
> Correct by replenishing the buffer whenenver the deferred
> logic kicks in.  Update corresponding debug messages and
> statistics as well.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c  |  6 ++++++
>  drivers/scsi/lpfc/lpfc_mem.c   |  8 ++++++--
>  drivers/scsi/lpfc/lpfc_nvmet.c | 31 +++++++++++++++++++++----------
>  drivers/scsi/lpfc/lpfc_nvmet.h |  7 +++++--
>  drivers/scsi/lpfc/lpfc_sli.c   | 12 ++++++++++++
>  5 files changed, 50 insertions(+), 14 deletions(-)
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
