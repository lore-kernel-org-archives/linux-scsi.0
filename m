From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 03/11] lpfc: Deprecate lpfc_soft_wwn parameter
Date: Tue, 20 Dec 2016 14:36:05 +0100
Message-ID: <c966346c-5c40-c6a2-5edf-eea022932c55@suse.de>
References: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32998 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757965AbcLTNgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:36:07 -0500
In-Reply-To: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 12:07 AM, James Smart wrote:
> 
> Deprecate lpfc_soft_wwn parameter.
> No longer allow override of hw-assigned wwns
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |   4 -
>  drivers/scsi/lpfc/lpfc_attr.c | 216 ------------------------------------------
>  drivers/scsi/lpfc/lpfc_init.c |  16 +---
>  3 files changed, 3 insertions(+), 233 deletions(-)
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
