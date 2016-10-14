From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 05/17] lpfc: Make lpfc_prot_xxx params per hba
 parameters
Date: Fri, 14 Oct 2016 12:34:01 +0200
Message-ID: <75ac1986-45e2-fa53-64d2-679da54540b4@suse.de>
References: <5800054e.406rXv3RyaadD2AJ%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46519 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753190AbcJNKxp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 06:53:45 -0400
In-Reply-To: <5800054e.406rXv3RyaadD2AJ%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> Make lpfc_prot_mask and lpfc_prot_guard per hba parameters
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  2 ++
>  drivers/scsi/lpfc/lpfc_attr.c | 23 ++++++++++++++---------
>  drivers/scsi/lpfc/lpfc_crtn.h |  2 --
>  drivers/scsi/lpfc/lpfc_init.c | 28 +++++++++++++++-------------
>  4 files changed, 31 insertions(+), 24 deletions(-)
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
