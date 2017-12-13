From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/9] lpfc: Beef up stat counters for debug
Date: Wed, 13 Dec 2017 15:54:23 +0100
Message-ID: <ebb47d9f-1052-58c1-108f-60df0568c52d@suse.de>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
 <20171209011811.23421-9-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33543 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbdLMOy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 09:54:29 -0500
In-Reply-To: <20171209011811.23421-9-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 12/09/2017 02:18 AM, James Smart wrote:
> If log verbose in not turned on, its hard to tell when
> certain error paths get hit. Add stats counters and
> corresponding logic to debugfs/sysfs to aid understanding
> what paths were traversed.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c    | 46 ++++++++++++++++++++++++++++++++-----
>  drivers/scsi/lpfc/lpfc_debugfs.c | 49 +++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/lpfc/lpfc_nvme.c    | 43 +++++++++++++++++++++++++++++++----
>  drivers/scsi/lpfc/lpfc_nvme.h    | 13 ++++++++++-
>  drivers/scsi/lpfc/lpfc_nvmet.c   | 34 ++++++++++++++++++++++++----
>  drivers/scsi/lpfc/lpfc_nvmet.h   |  5 ++++
>  6 files changed, 171 insertions(+), 19 deletions(-)
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
