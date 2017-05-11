From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/15] lpfc: Fix used-RPI accounting problem.
Date: Thu, 11 May 2017 08:04:55 +0200
Message-ID: <8727c83e-9064-e53c-34ed-f46edb6dd6c2@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750917AbdEKGE5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 02:04:57 -0400
In-Reply-To: <20170510190713.30171-2-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:06 PM, James Smart wrote:
> With 255 vports created a link trasition can casue a crash.
> 
> When going through discovery after a link bounce the driver is using
> rpis before the cmd FCOE_POST_HDR_TEMPLATES completes. By doing that
> the next rpi bumps the rpi range out of the boundary.
> 
> The fix it to increment the next_rpi only when the FCOE_POST_HDR_TEMPLATE
> succeeds.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c  |  3 ++-
>  drivers/scsi/lpfc/lpfc_init.c | 24 +++++-------------------
>  drivers/scsi/lpfc/lpfc_sli.c  |  8 ++++++++
>  drivers/scsi/lpfc/lpfc_sli4.h |  1 +
>  4 files changed, 16 insertions(+), 20 deletions(-)
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
