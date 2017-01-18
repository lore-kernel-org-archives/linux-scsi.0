From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/17] lpfc: NVME Target: Add debugfs support
Date: Wed, 18 Jan 2017 09:06:49 +0100
Message-ID: <4a226c80-fb83-0559-c6c3-031ad78403e2@suse.de>
References: <587ec2fa.4XfVnWpJuiX/2Gal%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751304AbdARIG7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 03:06:59 -0500
In-Reply-To: <587ec2fa.4XfVnWpJuiX/2Gal%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Target: Add debugfs support
> 
> Adds debugfs snippets to cover the new NVME target functionality
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_debugfs.c | 387 ++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/lpfc/lpfc_nvmet.c   | 279 +++++++++++++++++++++++++++-
>  drivers/scsi/lpfc/lpfc_nvmet.h   |  13 ++
>  3 files changed, 674 insertions(+), 5 deletions(-)
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
