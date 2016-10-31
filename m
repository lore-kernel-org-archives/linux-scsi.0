From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mvsas: fix error return code in mvs_task_prep()
Date: Mon, 31 Oct 2016 10:29:26 -0600
Message-ID: <20161031162926.GB26364@mtj.duckdns.org>
References: <1477926250-10292-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33979 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934237AbcJaQ33 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2016 12:29:29 -0400
Received: by mail-pf0-f195.google.com with SMTP id y68so3275151pfb.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2016 09:29:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1477926250-10292-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wilfried Weissmann <Wilfried.Weissmann@gmx.at>, Luis de Bethencourt <luisbg@osg.samsung.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Baoyou Xie <baoyou.xie@linaro.org>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

On Mon, Oct 31, 2016 at 03:04:10PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied to libata/for-4.9-fixes.

Thanks.

-- 
tejun
