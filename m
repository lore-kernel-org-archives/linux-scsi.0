From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 01/11] lpfc: Clear the VendorVersion in the PLOGI/PLOGI
 ACC payload
Date: Tue, 20 Dec 2016 14:35:17 +0100
Message-ID: <c6f87ae1-83ef-1f15-9263-53fe2cc5e2db@suse.de>
References: <58586828.M1b42wtxZQTqdEkh%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756717AbcLTNfT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:35:19 -0500
In-Reply-To: <58586828.M1b42wtxZQTqdEkh%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 12:07 AM, James Smart wrote:
> 
> Clear the VendorVersion in the PLOGI/PLOGI ACC payload
> 
> Vendor version info may have been set on fabric login. Before sending
> PLOGI payloads, ensure that it's cleared.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 6 ++++++
>  drivers/scsi/lpfc/lpfc_hw.h  | 6 ++++++
>  2 files changed, 12 insertions(+)
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
