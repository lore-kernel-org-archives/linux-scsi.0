From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/17] lpfc: NVME Target: Merge into FC discovery
Date: Wed, 18 Jan 2017 09:03:25 +0100
Message-ID: <629d1db3-0e2a-c730-87dd-520275ea1132@suse.de>
References: <587ec2f8.5mEXNd/HV7Rc1N2O%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50298 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751304AbdARID1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 03:03:27 -0500
In-Reply-To: <587ec2f8.5mEXNd/HV7Rc1N2O%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Target: Merge into FC discovery
> 
> Adds NVME PRLI handling and Nameserver registrations for NVME
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_ct.c        |  8 +++++++-
>  drivers/scsi/lpfc/lpfc_els.c       | 34 ++++++++++++++++++++++++++++++----
>  drivers/scsi/lpfc/lpfc_hbadisc.c   | 27 +++++++++++++++++++++++----
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 35 ++++++++++++++++++++++++++++++++---
>  4 files changed, 92 insertions(+), 12 deletions(-)
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
