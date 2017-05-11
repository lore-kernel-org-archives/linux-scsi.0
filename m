From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/15] lpfc: Separate NVMET data buffer pool fir ELS/CT.
Date: Thu, 11 May 2017 08:22:08 +0200
Message-ID: <80a3544a-6bad-e56f-9c0e-1b2f24b509cd@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-8-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41906 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751028AbdEKGWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 02:22:10 -0400
In-Reply-To: <20170510190713.30171-8-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:07 PM, James Smart wrote:
> Using 2048 byte buffer and onle 128 bytes is needed.
> 
> Create nee LFPC_NVMET_DATA_BUF_SIZE define to use
> for NVMET RQ/MRQs.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  1 +
>  drivers/scsi/lpfc/lpfc_crtn.h |  1 +
>  drivers/scsi/lpfc/lpfc_hw4.h  |  1 +
>  drivers/scsi/lpfc/lpfc_init.c |  7 ++++++-
>  drivers/scsi/lpfc/lpfc_mem.c  | 33 ++++++++++++++++++++++++++-------
>  drivers/scsi/lpfc/lpfc_sli.c  | 19 +++++++++++++++----
>  6 files changed, 50 insertions(+), 12 deletions(-)
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
