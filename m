From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] bnx2i: missing error code in bnx2i_ep_connect()
Date: Fri, 23 Jun 2017 09:13:36 +0200
Message-ID: <20170623071336.GC13014@linux-x5ow.site>
References: <20170623070200.GA7922@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58720 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751149AbdFWHNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 03:13:44 -0400
Content-Disposition: inline
In-Reply-To: <20170623070200.GA7922@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QLogic-Storage-Upstream@qlogic.com, Michael Chan <mchan@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, Jun 23, 2017 at 10:02:00AM +0300, Dan Carpenter wrote:
> If bnx2i_map_ep_dbell_regs() then we accidentally return NULL instead
> of an error pointer.  It results in a NULL dereference in
> iscsi_if_ep_connect().
> 
> Fixes: cf4e6363859d ("[SCSI] bnx2i: Add bnx2i iSCSI driver.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
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
