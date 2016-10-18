From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [RESEND PATCH] scsi: ufs: fix race between clock gating and
 devfreq scaling work
Date: Mon, 17 Oct 2016 17:13:56 -0700
Message-ID: <8edb1a0aaa886ffc80564117a020f490@codeaurora.org>
References: <1476227759-22389-1-git-send-email-subhashj@codeaurora.org>
 <yq137jyk68k.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44461 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754236AbcJRAN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 20:13:57 -0400
In-Reply-To: <yq137jyk68k.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 2016-10-14 13:47, Martin K. Petersen wrote:
>>>>>> "Subhash" == Subhash Jadavani <subhashj@codeaurora.org> writes:
> 
> Subhash> UFS devfreq clock scaling work may require clocks to be ON if
> Subhash> it need to execute some UFS commands hence it may request for
> Subhash> clock hold before issuing the command. But if UFS clock gating
> Subhash> work is already running in parallel, ungate work would end up
> Subhash> waiting for the clock gating work to finish and as clock 
> gating
> Subhash> work would also wait for the clock scaling work to finish, we
> Subhash> would enter in deadlock state. Here is the call trace during
> Subhash> this deadlock state:
> 
> Somebody from the UFS camp, please review!

As there was no review so far, i have moved this patch as first patch in 
the new UFS bug fixes patch series ([PATCH v1 00/11] scsi: ufs: bug 
fixes patch series #1) sent by me today.

Thanks,
Subhash

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
