From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 12/22] Fix driver usage of 128B WQEs when WQ_CREATE is
 V1.
Date: Thu, 20 Apr 2017 09:37:41 +0200
Message-ID: <20170420073740.GM6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-13-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48471 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S941328AbdDTHho (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 03:37:44 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-13-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:31PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> There are two versions of a structure for queue creation and setup that the
> driver shares with FW. The driver was only treating as version 0.
> 
> Verify WQ_CREATE with 128B WQEs in V0 and V1.
> 
> Code review of another bug showed the driver passing
> 128B WQEs and 8 pages in WQ CREATE and V0.
> Code inspection/instrumentation showed that the driver
> uses V0 in WQ_CREATE and if the caller passes queue->entry_size
> 128B, the driver sets the hdr_version to V1 so all is good.
> When I tested the V1 WQ_CREATE, the mailbox failed causing
> the driver to unload.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
