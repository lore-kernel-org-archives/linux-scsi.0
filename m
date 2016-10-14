From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 13/17] lpfc: Fix lost target in pt-to-pt connect
Date: Fri, 14 Oct 2016 12:37:12 +0200
Message-ID: <efdc4b87-3ea1-524f-375e-73871bab165d@suse.de>
References: <58000556.iMQkkPWuhx0h/Yw8%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754282AbcJNKhO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 06:37:14 -0400
In-Reply-To: <58000556.iMQkkPWuhx0h/Yw8%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> Fix lost target in pt-to-pt connect
> 
> Change reject code to something that allows a retry
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
