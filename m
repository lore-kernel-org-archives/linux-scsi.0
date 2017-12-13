From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/9] lpfc: Increase SCSI CQ and WQ sizes.
Date: Wed, 13 Dec 2017 15:44:02 +0100
Message-ID: <4743fb1d-d2cb-394d-419c-f99b8caf73e2@suse.de>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
 <20171209011811.23421-5-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60862 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752860AbdLMOoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 09:44:04 -0500
In-Reply-To: <20171209011811.23421-5-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 12/09/2017 02:18 AM, James Smart wrote:
> Increased the sizes of the SCSI WQ's and CQ's so that SCSI operation is
> similar to that used by NVME. However, size increase restricted only to
> those newer adapters that can support the larger WQE size, thus bigger
> queue sizes.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 65 ++++++++++++++++++++++++++++---------------
>  drivers/scsi/lpfc/lpfc_nvme.h |  2 --
>  drivers/scsi/lpfc/lpfc_sli4.h |  6 ++--
>  3 files changed, 46 insertions(+), 27 deletions(-)
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
