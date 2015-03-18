From: "Dov Levenglick" <dovl@codeaurora.org>
Subject: Re: [PATCH v7 2/3] scsi: ufs: add debugfs for ufs
Date: Wed, 18 Mar 2015 13:19:05 -0000
Message-ID: <36562299c4ed69265f622db26afb976a.squirrel@www.codeaurora.org>
References: <1426175700-23152-1-git-send-email-gbroner@codeaurora.org>
    <1426175700-23152-3-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426175700-23152-3-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

> From: Lee Susman <lsusman@codeaurora.org>
>
> Adding debugfs capability for ufshcd.
>
> debugfs attributes introduced in this patch:
>  - View driver/controller runtime data
>  - Command tag statistics for performance analisis
>  - Dump device descriptor info
>  - Track recoverable errors statistics during runtime
>  - Change UFS power mode during runtime
>      entry a string in the format 'GGLLMM' where:
>          G - selected gear
>          L - number of lanes
>          M - power mode
>              (1=fast mode, 2=slow mode, 4=fast-auto mode,
>               5=slow-auto mode)
>      First letter is for RX, second is for TX.
>  - Get/set DME attributes
>
> Signed-off-by: Lee Susman <lsusman@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> ---
>  drivers/scsi/ufs/Makefile      |   1 +
>  drivers/scsi/ufs/ufs-debugfs.c | 902
> +++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-debugfs.h |  38 ++
>  drivers/scsi/ufs/ufshcd.c      | 229 ++++++++++-
>  drivers/scsi/ufs/ufshcd.h      |  65 +++
>  drivers/scsi/ufs/ufshci.h      |   2 +
>  6 files changed, 1225 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufs-debugfs.c
>  create mode 100644 drivers/scsi/ufs/ufs-debugfs.h
>

[removed ~1600 lines of code]
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
