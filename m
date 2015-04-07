From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v1 2/2] scsi: ufs: add support to allow non standard
 behaviours (quirks)
Date: Tue, 7 Apr 2015 07:53:16 -0000
Message-ID: <08233ba82c96ccf7d66e06f238f67282.squirrel@www.codeaurora.org>
References: <1427812635-16617-1-git-send-email-ygardi@codeaurora.org>
    <1427812635-16617-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1427812635-16617-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org


> Some implementation of UFS host controller HW might have some non-standard
> behaviours (quirks) when compared to behaviour specified by UFSHCI
> specification. This patch add support to allow specifying all such quirks
> to standard UFS host controller driver so standard driver takes them into
> account.
>
> In this change a UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS is introduced,
> where a minimum delay of 1ms is required before DME commands for
> stability purposes.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 22 +++++++++++++++++-----
>  drivers/scsi/ufs/ufs-qcom.h | 18 ++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c   | 35 +++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h   |  9 +++++++++
>  4 files changed, 79 insertions(+), 5 deletions(-)
>

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
