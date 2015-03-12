From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v5 3/3] scsi: ufs: add trace events and dump prints for
 debug
Date: Thu, 12 Mar 2015 12:28:58 -0000
Message-ID: <e5512089069a6b6f41288806512badb2.squirrel@codeaurora.org>
References: <1425988035-966-1-git-send-email-gbroner@codeaurora.org>
    <1425988035-966-4-git-send-email-gbroner@codeaurora.org>
    <20150310104357.0165cab6@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150310104357.0165cab6@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gilad Broner <gbroner@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> This and the auto_bkops_state is pretty much the same. Can't you use
> the same TP_printk() and just have a DECLARE_EVENT_CLASS? The trace
> point name is printed with the event to see different events.

I agree. will upload the fix in next patchset.

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
