From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] lpfc: Fix receive PRLI handling
Date: Wed, 13 Dec 2017 15:42:49 +0100
Message-ID: <b894b25f-734b-fdb0-553e-0bcd7a323b34@suse.de>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
 <20171209011811.23421-4-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752995AbdLMOmu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 09:42:50 -0500
In-Reply-To: <20171209011811.23421-4-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 12/09/2017 02:18 AM, James Smart wrote:
> Handling a rcv'ed PRLI incorrectly can cause the ndlp to end up
> in the wrong state or the driver to ACC and PRLI when it should
> send LS_RJT.
> 
> The cause was due to the driver not properly looking at the PRLI
> type and taking the multiple protocol support into consideration.
> 
> Resolved by adding checks in the various PRLI receive points to
> validate PRLI type and reject if not valid for the enabled protocols
> and mode (host vs target).
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c       |  7 -----
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 54 +++++++++++++++++++++++++++++++++-----
>  2 files changed, 47 insertions(+), 14 deletions(-)
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
