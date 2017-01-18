From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/17] lpfc: Use new pci_alloc_irq_vectors() interface
Date: Wed, 18 Jan 2017 07:57:10 +0100
Message-ID: <9773daca-af73-0575-c2b8-a5e44777e1b5@suse.de>
References: <587ec2ec.lHOM16QZ9nmppg4/%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751553AbdARG5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 01:57:22 -0500
In-Reply-To: <587ec2ec.lHOM16QZ9nmppg4/%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> Move to new pci_alloc_irq_vectors() interface for intx/msi/msix
> 
> Note: io channel paradigm remains, for now.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 227 ++++++++++++++++++++++++++++--------------
>  1 file changed, 154 insertions(+), 73 deletions(-)
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
