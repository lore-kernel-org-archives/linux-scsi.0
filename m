From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 11/17] lpfc: Linux LPFC driver does not process all
 RSCNs
Date: Tue, 21 Nov 2017 09:12:41 +0100
Message-ID: <3eed3ff8-31b1-d79a-721d-90c73cd3e1d6@suse.de>
References: <20171121000044.27702-1-jsmart2021@gmail.com>
 <20171121000044.27702-12-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38337 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751189AbdKUIMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Nov 2017 03:12:43 -0500
In-Reply-To: <20171121000044.27702-12-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/21/2017 01:00 AM, James Smart wrote:
> During RSCN storms, the driver does not rediscover some targets.
> The driver marks some RSCN as to be handled after the ones it's
> working on. The driver missed processing some deferred RSCN.
> 
> Move where the driver checks for deferred RSCNs and initiate
> deferred RSCN handling if the flag was set. Also revise nport state
> within the RSCN confirm routine. Add some state data to a possible
> debug print to aid future debugging.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> ---
> v3:
>   per review, fix weird data element that was a combination of
>   multiple fields. The log print now has each field.
> ---
>  drivers/scsi/lpfc/lpfc_ct.c      | 19 +++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_els.c     |  4 +---
>  drivers/scsi/lpfc/lpfc_hbadisc.c |  7 +++++--
>  3 files changed, 25 insertions(+), 5 deletions(-)
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
