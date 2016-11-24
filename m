From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: UFS_MASK macro definition
Date: Thu, 24 Nov 2016 12:58:15 +0800
Message-ID: <CAMj5Bkgu+5FL6Lx5jPJH2CmvteGEqr3+yVVdH=UHtav0_6A50A@mail.gmail.com>
References: <CAMj5Bkgp59xuPRCPq8NGBPjG4ep6qb-DkjzUzPi7cWeVxSJrYg@mail.gmail.com>
 <9df3b5fd8815719f7a8e8f717cc2edb4@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33073 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756652AbcKXE7q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2016 23:59:46 -0500
In-Reply-To: <9df3b5fd8815719f7a8e8f717cc2edb4@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On Thu, Nov 24, 2016 at 12:21 PM, Subhash Jadavani
<subhashj@codeaurora.org> wrote:
> On 2016-11-23 19:23, Zhangfei Gao wrote:
>>
>> Hi, Vinayak
>>
>> Checked 4.9-rc6, and not find UFS_MASK macro definition.
>> Have find this patch from google,
>>
>> http://www.spinics.net/lists/linux-scsi/msg58634.html
>> [PATCH 2/2] [SCSI] ufs: Add missing UFS_MASK macro definition
>>
>> Is this patch has been merged?
>
>
> Good catch. ufshci.h history shows that this was never merged.
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/drivers/scsi/ufs/ufshci.h?id=refs/tags/v4.9-rc6
>
> Zhangfei,
> do you want to take above patch and repost it to linux-scsi mailing list?
> You may keep the original author & signed-off intact and may add your
> signed-off.

Got it, will send the patch.

Thanks
