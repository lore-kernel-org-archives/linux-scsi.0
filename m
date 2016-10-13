From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 14/17 v2] lpfc: Correct panics with eh_timeout and
 eh_deadline
Date: Thu, 13 Oct 2016 09:54:58 +0200
Message-ID: <20161013075458.cljfevlzax3kn3wv@linux-x5ow.site>
References: <57fe9999.ma9fce/fBLSubNC8%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752107AbcJMIOc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 04:14:32 -0400
Content-Disposition: inline
In-Reply-To: <57fe9999.ma9fce/fBLSubNC8%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 12, 2016 at 01:14:17PM -0700, James Smart wrote:
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
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c |  6 +++---
>  drivers/scsi/lpfc/lpfc_sli.c  | 12 ++++++++----
>  2 files changed, 11 insertions(+), 7 deletions(-)


Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
