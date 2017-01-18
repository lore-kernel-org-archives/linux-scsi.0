From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/17] lpfc: NVME Target: bind to nvmet_fc api
Date: Wed, 18 Jan 2017 09:04:49 +0100
Message-ID: <6ccefbdc-e08f-5dbc-36dc-b63154a96264@suse.de>
References: <587ec2f9.rOjtCa/pEziRaN+m%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50381 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdARIEv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 03:04:51 -0500
In-Reply-To: <587ec2f9.rOjtCa/pEziRaN+m%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Target: Tie in to NVME Fabrics nvmet_fc LLDD target api
> 
> Adds the routines to:
> - register and deregister the FC port as a nvmet-fc targetport
> - binding of nvme queues to adapter WQs
> - receipt and passing of NVME LS's to transport, sending transport response
> - receipt of NVME FCP CMD IUs, processing FCP target io data transmission
>   commands; transmission of FCP io response.
> - Abort operations for tgt io exchanges.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/Makefile       |    2 +-
>  drivers/scsi/lpfc/lpfc_crtn.h    |    8 +
>  drivers/scsi/lpfc/lpfc_ct.c      |    2 +-
>  drivers/scsi/lpfc/lpfc_els.c     |    5 +-
>  drivers/scsi/lpfc/lpfc_hbadisc.c |   10 +-
>  drivers/scsi/lpfc/lpfc_init.c    |    2 +-
>  drivers/scsi/lpfc/lpfc_nvmet.c   | 1365 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_sli.c     |    8 +-
>  8 files changed, 1390 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.c
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
