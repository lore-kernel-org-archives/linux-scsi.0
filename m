From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v1 3/4] scsi: ufs: add trace events and dump prints for
 debug
Date: Wed, 4 Feb 2015 14:00:50 -0000
Message-ID: <064b540160e3c08923ae76e715a46fe1.squirrel@www.codeaurora.org>
References: <1422977841-25036-1-git-send-email-gbroner@codeaurora.org>
    <1422977841-25036-4-git-send-email-gbroner@codeaurora.org>
    <20150203115351.58994f7d@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20150203115351.58994f7d@gandalf.local.home>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gilad Broner <gbroner@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Petr Mladek <pmladek@suse.cz>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Vaibhav Nagarnaik <vnagarnaik@google.com>
List-Id: linux-scsi@vger.kernel.org

> Please use trace_<event>_enabled(), for instance,
> trace_ufshcd_command_enabled().
>
> This also uses jump_labels and is a nop when it is not enabled.

I accept your comment and will fix it.
I'll wait a bit longer with sending v2 in case there are more comments.

Thanks,
Gilad.

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
