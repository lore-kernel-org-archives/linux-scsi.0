From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/15] lpfc: Added recovery logic for running out of NVMET
 IO context resources
Date: Thu, 11 May 2017 09:24:32 +0200
Message-ID: <68a8269e-2b82-0e5b-a34e-a0b53da9dfe8@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-10-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750917AbdEKHYf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 03:24:35 -0400
In-Reply-To: <20170510190713.30171-10-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:07 PM, James Smart wrote:
> Previous logic would just drop the IO
> 
> Added logic to queue the IO to wait for an IO context resource from an IO
> thats already in progress.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h         |   1 +
>  drivers/scsi/lpfc/lpfc_attr.c    |   6 ++
>  drivers/scsi/lpfc/lpfc_crtn.h    |   2 +
>  drivers/scsi/lpfc/lpfc_debugfs.c |   6 ++
>  drivers/scsi/lpfc/lpfc_init.c    |   2 +
>  drivers/scsi/lpfc/lpfc_nvmet.c   | 138 +++++++++++++++++++++++++++++++++------
>  drivers/scsi/lpfc/lpfc_sli.c     |   7 +-
>  drivers/scsi/lpfc/lpfc_sli4.h    |   6 +-
>  8 files changed, 144 insertions(+), 24 deletions(-)
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
