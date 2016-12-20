From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 07/11] lpfc: Fix Xlane dynamic LUN set for LUN
 priority.
Date: Tue, 20 Dec 2016 14:38:41 +0100
Message-ID: <8b401a24-0451-5f9f-804f-dce9994eca1b@suse.de>
References: <5858682e.XbXvVCw6F0Td7N4b%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33199 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932415AbcLTNin (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:38:43 -0500
In-Reply-To: <5858682e.XbXvVCw6F0Td7N4b%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 12:07 AM, James Smart wrote:
> 
> Fix Xlane dynamic LUN set for LUN priority. Dynamic changing of the
> priority was not getting reflected on the LUN.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c | 23 +++++++++++++++--------
>  drivers/scsi/lpfc/lpfc_crtn.h |  7 ++++---
>  drivers/scsi/lpfc/lpfc_scsi.c | 18 ++++++++++++------
>  3 files changed, 31 insertions(+), 17 deletions(-)
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
