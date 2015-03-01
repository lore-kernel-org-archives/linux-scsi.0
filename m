From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v3 3/4] scsi: ufs: add trace events and dump prints for
 debug
Date: Sun, 1 Mar 2015 08:33:49 -0000
Message-ID: <0a3014d48540bedb0ca333903934c40e.squirrel@codeaurora.org>
References: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
    <1424678898-3723-4-git-send-email-gbroner@codeaurora.org>
    <20150223121242.08d4c008@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150223121242.08d4c008@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gilad Broner <gbroner@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> If I understand the patch above, you basically have:
>
> 	if (....)
> 		goto out;
> 	else
> 		ret = ufshcd_resume();
> out:
>
> Wouldn't it be better to just reverse the above if condition?
>
> 	if (!...)
> 		ret = ufshcd_resume();
>
> That would be much less confusing.

It gives a logical place to put the comment, but I agree it will be
less confusing the other way.
I will fix this in the next patchset.

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
