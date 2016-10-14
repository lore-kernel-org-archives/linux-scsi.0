From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 14/17] lpfc: Correct panics with eh_timeout and
 eh_deadline
Date: Fri, 14 Oct 2016 12:38:21 +0200
Message-ID: <3363e29d-da1f-05f2-723c-a3a9e565e62a@suse.de>
References: <58000557.XB6b5rUlrmwRw04e%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45843 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751939AbcJNKiZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 06:38:25 -0400
In-Reply-To: <58000557.XB6b5rUlrmwRw04e%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> Correct panics with eh_timeout and eh_deadline
> 
> We were having double completions on our SLI-3 version of adapters.
> Solved by clearing our command pointer before calling scsi_done.
> 
> The eh paths potentially ran simulatenously and would see the non-null
> value and invoke scsi_done again.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c |  6 +++---
>  drivers/scsi/lpfc/lpfc_sli.c  | 12 ++++++++----
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 
I think I've suggested a similar patch some time ago ...

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
