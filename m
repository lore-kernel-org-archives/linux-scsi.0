From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 08/11] lpfc: Deprecate lpfc_prot_sg_seg_cnt parameter
Date: Tue, 20 Dec 2016 14:39:18 +0100
Message-ID: <52e69402-d5cd-5ea6-e54b-b63b9b474053@suse.de>
References: <5858682f.TsrXIb6Mxfa5No7n%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33271 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933675AbcLTNjU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:39:20 -0500
In-Reply-To: <5858682f.TsrXIb6Mxfa5No7n%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 12:07 AM, James Smart wrote:
> 
> Deprecate lpfc_prot_sg_seg_cnt parameter. Eliminates driver from
> unnecessarily limiting DIF s/g list length.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  1 -
>  drivers/scsi/lpfc/lpfc_attr.c | 10 ----------
>  2 files changed, 11 deletions(-)
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
