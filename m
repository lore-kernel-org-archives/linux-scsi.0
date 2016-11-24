From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: UFS_MASK macro definition
Date: Wed, 23 Nov 2016 20:21:02 -0800
Message-ID: <9df3b5fd8815719f7a8e8f717cc2edb4@codeaurora.org>
References: <CAMj5Bkgp59xuPRCPq8NGBPjG4ep6qb-DkjzUzPi7cWeVxSJrYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757042AbcKXEVF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2016 23:21:05 -0500
In-Reply-To: <CAMj5Bkgp59xuPRCPq8NGBPjG4ep6qb-DkjzUzPi7cWeVxSJrYg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhangfei Gao <zhangfei.gao@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-11-23 19:23, Zhangfei Gao wrote:
> Hi, Vinayak
> 
> Checked 4.9-rc6, and not find UFS_MASK macro definition.
> Have find this patch from google,
> 
> http://www.spinics.net/lists/linux-scsi/msg58634.html
> [PATCH 2/2] [SCSI] ufs: Add missing UFS_MASK macro definition
> 
> Is this patch has been merged?

Good catch. ufshci.h history shows that this was never merged. 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/drivers/scsi/ufs/ufshci.h?id=refs/tags/v4.9-rc6

Zhangfei,
do you want to take above patch and repost it to linux-scsi mailing 
list?  You may keep the original author & signed-off intact and may add 
your signed-off.

Thanks,
Subhash

> 
> There will be build error if some definition defined by UFS_MASK is 
> used.
> Otherwise it may keep silent.
> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
