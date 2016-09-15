From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH -next] scsi: ibmvscsis: Fix error return code in
 ibmvscsis_probe()
Date: Thu, 15 Sep 2016 08:24:36 +0200
Message-ID: <20160915062436.q52ww2atfmdzv7nn@linux-x5ow.site>
References: <1473909923-30014-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36297 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755583AbcIOGYn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Sep 2016 02:24:43 -0400
Content-Disposition: inline
In-Reply-To: <1473909923-30014-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "Bryant G . Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Thu, Sep 15, 2016 at 03:25:23AM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return error code -ENOMEM from the dma mapping error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
