From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 03/17 v2] lpfc: Fix sg_reset on SCSI device causing
 kernel crash
Date: Thu, 13 Oct 2016 09:51:59 +0200
Message-ID: <20161013075159.sytlbvovdx6i4kfe@linux-x5ow.site>
References: <57fe998e.qbv3PDNFIL0gvh+R%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39963 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbcJMHxe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 03:53:34 -0400
Content-Disposition: inline
In-Reply-To: <57fe998e.qbv3PDNFIL0gvh+R%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 12, 2016 at 01:14:06PM -0700, James Smart wrote:
> 
> Fix sg_reset on SCSI device causing kernel crash
> 
> Driver could reference stale node pointers in task mgmt call.
> Changed to use resetting cmd and look up node pointer in task mgmt
> function.
> 
> Modified per review:
> Revised lpfc_send_taskmgmt() to check rdata
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
