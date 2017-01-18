From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/17] lpfc: NVME Initiator: Add debugfs support
Date: Wed, 18 Jan 2017 08:51:43 +0100
Message-ID: <9b0fc106-e073-bc9f-bbbc-93cfc4510c0f@suse.de>
References: <587ec2f5.kNRcfOkEsCi6Fjot%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751226AbdARHwB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 02:52:01 -0500
In-Reply-To: <587ec2f5.kNRcfOkEsCi6Fjot%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Initiator: Add debugfs support
> 
> Adds debugfs snippets to cover the new NVME initiator functionality
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h         |  48 +++
>  drivers/scsi/lpfc/lpfc_ct.c      |  27 +-
>  drivers/scsi/lpfc/lpfc_debugfs.c | 775 ++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/lpfc/lpfc_debugfs.h | 150 +++++++-
>  drivers/scsi/lpfc/lpfc_nvme.c    | 125 +++++++
>  drivers/scsi/lpfc/lpfc_nvme.h    |   7 +
>  drivers/scsi/lpfc/lpfc_sli.c     |   5 +
>  7 files changed, 1128 insertions(+), 9 deletions(-)
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
