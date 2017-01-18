From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/17] lpfc: NVME Initiator: Merge into FC discovery
Date: Wed, 18 Jan 2017 08:41:22 +0100
Message-ID: <6a367b18-6566-964a-98c5-04d9bfce79d0@suse.de>
References: <587ec2f3.tTtsqdflq8F2Y4Tt%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48481 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbdARHmS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 02:42:18 -0500
In-Reply-To: <587ec2f3.tTtsqdflq8F2Y4Tt%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Initiator: Merge into FC discovery
> 
> Adds NVME PRLI support and Nameserver registrations and Queries for NVME
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h           |   6 +-
>  drivers/scsi/lpfc/lpfc_ct.c        | 441 +++++++++++++++++++++++--------------
>  drivers/scsi/lpfc/lpfc_disc.h      |  19 +-
>  drivers/scsi/lpfc/lpfc_els.c       | 320 +++++++++++++++++++--------
>  drivers/scsi/lpfc/lpfc_hbadisc.c   | 169 +++++++++++---
>  drivers/scsi/lpfc/lpfc_hw.h        |  77 +++++--
>  drivers/scsi/lpfc/lpfc_hw4.h       |  43 ++++
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 198 +++++++++++++++--
>  8 files changed, 938 insertions(+), 335 deletions(-)
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
