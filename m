From: "Dov Levenglick" <dovl@codeaurora.org>
Subject: Re: [PATCH v7 3/3] scsi: ufs: add trace events and dump prints for
 debug
Date: Wed, 18 Mar 2015 13:20:49 -0000
Message-ID: <3a376180355468208318b10f7516cec8.squirrel@www.codeaurora.org>
References: <1426175700-23152-1-git-send-email-gbroner@codeaurora.org>
    <1426175700-23152-4-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426175700-23152-4-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> Add trace events to driver to allow monitoring and profilig
> of activities such as PM suspend/resume, hibernate enter/exit,
> clock gating and clock scaling up/down.
> In addition, add UFS host controller register dumps to provide
> detailed information in case of errors to assist in analysis
> of issues.
>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Lee Susman <lsusman@codeaurora.org>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c |  53 +++++
>  drivers/scsi/ufs/ufshcd.c   | 511
> +++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/ufs/ufshcd.h   |  49 ++++-
>  drivers/scsi/ufs/ufshci.h   |   1 +
>  include/trace/events/ufs.h  | 213 ++++++++++++++++++
>  5 files changed, 790 insertions(+), 37 deletions(-)
>  create mode 100644 include/trace/events/ufs.h
>

[removed ~1500 lines of code]
Reviewed-by: Dov Levenglick <dovl@codeaurora.org>


> --
> Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
