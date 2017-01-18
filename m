From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/17] lpfc: NVME Initiator: bind to nvme_fc api
Date: Wed, 18 Jan 2017 08:48:55 +0100
Message-ID: <5a3636d5-8147-3918-5978-d751e148f33f@suse.de>
References: <587ec2f4.E7OXGdKOLaTx6anb%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751226AbdARHuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 02:50:25 -0500
In-Reply-To: <587ec2f4.E7OXGdKOLaTx6anb%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Initiator: Tie in to NVME Fabrics nvme_fc LLDD initiator api
> 
> Adds the routines to:
> - register and deregister the FC port as a nvme-fc initiator localport
> - register and deregister remote FC ports as a nvme-fc remoteport.
> - binding of nvme queues to adapter WQs
> - send/perform NVME LS's
> - send/perform NVME FCP initiator io operations
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/Makefile         |    7 +-
>  drivers/scsi/lpfc/lpfc.h           |    5 +
>  drivers/scsi/lpfc/lpfc_crtn.h      |    9 +
>  drivers/scsi/lpfc/lpfc_ct.c        |    2 +-
>  drivers/scsi/lpfc/lpfc_els.c       |    4 +-
>  drivers/scsi/lpfc/lpfc_hbadisc.c   |   15 +-
>  drivers/scsi/lpfc/lpfc_init.c      |   20 +-
>  drivers/scsi/lpfc/lpfc_nportdisc.c |    4 +-
>  drivers/scsi/lpfc/lpfc_nvme.c      | 2249 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_nvme.h      |    6 +
>  drivers/scsi/lpfc/lpfc_sli.c       |   21 +-
>  drivers/scsi/lpfc/lpfc_sli4.h      |    1 +
>  drivers/scsi/lpfc/lpfc_vport.c     |   16 +-
>  13 files changed, 2339 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/scsi/lpfc/lpfc_nvme.c
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
