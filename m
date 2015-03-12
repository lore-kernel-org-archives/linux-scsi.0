From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v7 3/3] scsi: ufs: add trace events and dump prints for
 debug
Date: Thu, 12 Mar 2015 12:13:14 -0400
Message-ID: <20150312121314.19c40cfd@gandalf.local.home>
References: <1426175700-23152-1-git-send-email-gbroner@codeaurora.org>
	<1426175700-23152-4-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1426175700-23152-4-git-send-email-gbroner@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 12 Mar 2015 17:55:00 +0200
Gilad Broner <gbroner@codeaurora.org> wrote:

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
>  drivers/scsi/ufs/ufshcd.c   | 511 +++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/ufs/ufshcd.h   |  49 ++++-
>  drivers/scsi/ufs/ufshci.h   |   1 +


>  include/trace/events/ufs.h  | 213 ++++++++++++++++++

For the tracing part...

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  5 files changed, 790 insertions(+), 37 deletions(-)
>  create mode 100644 include/trace/events/ufs.h
