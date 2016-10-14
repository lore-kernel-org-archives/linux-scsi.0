From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 02/17] lpfc: Correct embedded io wq element size
Date: Fri, 14 Oct 2016 12:32:03 +0200
Message-ID: <254eb1e9-7430-33c9-f996-5d2053c3010e@suse.de>
References: <5800054b.zGLIaeTe8e0VezFn%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45497 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbcJNKcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 06:32:05 -0400
In-Reply-To: <5800054b.zGLIaeTe8e0VezFn%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> Correct embedded io wq element size. Embedded element sizes are
> 128 byte elements
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
> v2 mods:
>  change style of selecting wqesize using local variable
> 
>  drivers/scsi/lpfc/lpfc_init.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
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
