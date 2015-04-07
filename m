From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v1 1/2] scsi: ufs-qcom: save controller revision info in
 internal structure
Date: Tue, 7 Apr 2015 07:39:31 -0000
Message-ID: <3daa9b797aa544756b9e5bea34465f10.squirrel@www.codeaurora.org>
References: <1427812635-16617-1-git-send-email-ygardi@codeaurora.org>
    <1427812635-16617-2-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427812635-16617-2-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org


> Sometimes, specific information about the UFS controller revision is
> required in order to determine certain operations or execute
> controller dependent quirks.
> In order to avoid reading the controller revision multiple times,
> we simply read it once and save this information in internal structure.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 14 +++++++-------
>  drivers/scsi/ufs/ufs-qcom.h |  8 ++++++++
>  2 files changed, 15 insertions(+), 7 deletions(-)
>

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
