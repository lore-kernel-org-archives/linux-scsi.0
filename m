From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v2 3/4] scsi: ufs: add trace events and dump prints for
 debug
Date: Sun, 22 Feb 2015 14:58:34 -0000
Message-ID: <c7bcf021bd1c2cfe9ca02669bf11f5f5.squirrel@codeaurora.org>
References: <1423576735-26267-1-git-send-email-gbroner@codeaurora.org>
    <1423576735-26267-4-git-send-email-gbroner@codeaurora.org>
    <20150212145551.2d234fb1@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20150212145551.2d234fb1@gandalf.local.home>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gilad Broner <gbroner@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>  struct ufs_stats {
>> +#ifdef CONFIG_DEBUG_FS
>>  	bool enabled;
>>  	u64 **tag_stats;
>>  	int q_depth;
>>  	int err_stats[UFS_ERR_MAX];
>> +#endif
>
> Can any of the tracepoint code be called that references these when
> CONFIG_DEBUG_FS is not set? Because soon (possibly even this merge
> window), tracing will no longer depend on DEBUG_FS, because it will
> have its own filesystem.

Thanks for the update about this dependency.
None of these are used for the tracepoints, so I don't expect any problems.

Gilad.

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
