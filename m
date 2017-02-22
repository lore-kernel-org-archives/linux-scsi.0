From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v1 1/1] scsi: ufs-qcom: remove redundant condition check
Date: Wed, 22 Feb 2017 15:24:08 -0800
Message-ID: <0079ddd9bf1e47cdaf2d67fc2aa8f1ef@codeaurora.org>
References: <1487368421-22903-1-git-send-email-subhashj@codeaurora.org>
 <yq1h93o44z2.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47146 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933605AbdBVXZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 18:25:02 -0500
In-Reply-To: <yq1h93o44z2.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2017-02-20 19:06, Martin K. Petersen wrote:
>>>>>> "Subhash" == Subhash Jadavani <subhashj@codeaurora.org> writes:
> 
> Subhash,
> 
> Subhash> Dan Carpenter <dan.carpenter@oracle.com> reported this: --- 
> The
> Subhash> patch 9c46b8676271: "scsi: ufs-qcom: dump additional testbus
> Subhash> registers" from Feb 3, 2017, leads to the following static
> Subhash> checker warning:
> 
> You had used "---" to enclose Dan's email. But that's also the "ignore
> everything beyond this point" delimiter so I ended up with an empty
> commit message.
> 
> I fixed it up. Applied to 4.11/scsi-queue.

Thanks and sorry about that, was skeptical about it.



-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
