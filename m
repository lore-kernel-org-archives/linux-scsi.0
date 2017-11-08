From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/17] lpfc: Driver fails to detect direct attach storage
 array
Date: Wed, 8 Nov 2017 10:25:49 +0100
Message-ID: <888d8876-bf8e-0fa1-5a23-b0f861528399@suse.de>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-8-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57569 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbdKHJZu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 04:25:50 -0500
In-Reply-To: <20171103225628.24716-8-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/03/2017 11:56 PM, James Smart wrote:
> The driver does not respond to PLOGI from the direct attach target.
> The driver uses incorrect S_ID in CONFIG_LINK, after FLOGI completion
> 
> Correct by issuing CONFIG_LINK with the correct S_ID after receiving
> the PLOGI from the target
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 36 ++++++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 16 deletions(-)
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
