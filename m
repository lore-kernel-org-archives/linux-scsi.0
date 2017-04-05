From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [lpfc 04/19] Fix PRLI ACC rsp for NVME
Date: Wed, 5 Apr 2017 09:15:06 +0200
Message-ID: <20170405071506.GD3941@linux-x5ow.site>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
 <1491326232-11255-5-git-send-email-rkennedy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47159 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752282AbdDEHPI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Apr 2017 03:15:08 -0400
Content-Disposition: inline
In-Reply-To: <1491326232-11255-5-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>

On Tue, Apr 04, 2017 at 10:16:57AM -0700, Dick Kennedy wrote:
> From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>
> 
> PRLI ACC from target is FCP oriented
> 
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Please read:
http://lists.infradead.org/pipermail/linux-nvme/2017-March/009035.html

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
