From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/19] lpfc: Add WQ Full Logic for NVME Target
Date: Mon, 29 Jan 2018 09:00:53 +0100
Message-ID: <4e16e46c-5d96-edf7-de3d-b818c84ccc73@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-6-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52063 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751572AbeA2KX2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:23:28 -0500
In-Reply-To: <20180124224548.9530-6-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> I/O conditions on the nvme target may have the driver submitting
> to a full hardware wq. The hardware wq is a shared resource among
> all nvme controllers. When the driver hit a full wq, it failed the
> io posting back to the nvme-fc transport, which then escalated it
> into errors.
> 
> Correct by maintaining a sideband queue within the driver that is
> added to when the WQ full condition is hit, and drained from as soon
> as new WQ space opens up.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_crtn.h  |   1 +
>  drivers/scsi/lpfc/lpfc_nvmet.c | 116 +++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_nvmet.h |   1 +
>  drivers/scsi/lpfc/lpfc_sli.c   |   3 ++
>  drivers/scsi/lpfc/lpfc_sli4.h  |   5 +-
>  5 files changed, 125 insertions(+), 1 deletion(-)
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
