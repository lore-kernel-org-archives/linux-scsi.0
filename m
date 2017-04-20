From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 10/22] Fix PRLI ACC rsp for NVME
Date: Thu, 20 Apr 2017 09:35:35 +0200
Message-ID: <20170420073535.GK6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-11-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48355 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S939257AbdDTHfj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 03:35:39 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-11-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:29PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> PRLI ACC from target is FCP oriented.
> 
> Word 0 was wrong. This was noticed by another nvmet-fc vendor that
> was testing the lpfc nvme-fc initiator with their target.
> 
> Verified results with analyzer.
> 
> PRLI
> BC B5 56 56  22 61 04 00  00 61 00 00  01 29 00 00  20 00 00 00
> 00 10 FF FF  00 00 00 00  20 14 00 18  28 00 00 00  00 00 00 00
> 00 00 00 00  00 00 00 20  00 00 00 00  9C D8 DA C9  BC 95 75 75
> 
> ACC
> BC B5 56 56  23 61 00 00  00 61 04 00  01 98 00 00  30 00 00 00
> 00 10 00 18  00 00 00 00  02 14 00 18  28 00 01 00  00 00 00 00
> 00 00 00 00  00 00 00 18  00 00 00 00  B0 6B 07 57  BC B5 75 75
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
