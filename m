From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mvsas: fix error return code in mvs_task_prep()
Date: Tue, 1 Nov 2016 11:36:12 -0600
Message-ID: <20161101173612.GC16704@mtj.duckdns.org>
References: <1477926250-10292-1-git-send-email-weiyj.lk@gmail.com>
 <20161031162926.GB26364@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36464 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753239AbcKARgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 13:36:15 -0400
Received: by mail-pf0-f196.google.com with SMTP id n85so12185661pfi.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Nov 2016 10:36:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20161031162926.GB26364@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wilfried Weissmann <Wilfried.Weissmann@gmx.at>, Luis de Bethencourt <luisbg@osg.samsung.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Baoyou Xie <baoyou.xie@linaro.org>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

On Mon, Oct 31, 2016 at 10:29:26AM -0600, Tejun Heo wrote:
> On Mon, Oct 31, 2016 at 03:04:10PM +0000, Wei Yongjun wrote:
> > From: Wei Yongjun <weiyongjun1@huawei.com>
> > 
> > Fix to return error code -ENOMEM from the error handling
> > case instead of 0, as done elsewhere in this function.
> > 
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Applied to libata/for-4.9-fixes.

I messed up.  This should have gone through scsi, not libata.  Chatted
with Martin and as the patch is a small obvious fix decided to leave
it in libata tree.  My apologies for the confusion.

Thanks.

-- 
tejun
