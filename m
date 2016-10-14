From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 03/17] lpfc: Fix sg_reset on SCSI device causing kernel
 crash
Date: Fri, 14 Oct 2016 12:32:49 +0200
Message-ID: <5de7a229-73c0-5e6b-3358-52dab9374230@suse.de>
References: <5800054c.g3V3xbXWePOAaN/W%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45537 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbcJNKcv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 06:32:51 -0400
In-Reply-To: <5800054c.g3V3xbXWePOAaN/W%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> Fix sg_reset on SCSI device causing kernel crash
> 
> Driver could reference stale node pointers in task mgmt call.
> Changed to use resetting cmd and look up node pointer in task mgmt
> function.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
> v2 mods:
>  Revised lpfc_send_taskmgmt() to check rdata
> 
>  drivers/scsi/lpfc/lpfc_scsi.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
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
