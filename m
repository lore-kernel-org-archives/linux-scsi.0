From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH V1 0/8] ufs patch siries
Date: Mon, 13 May 2013 20:50:57 +0900
Message-ID: <003b01ce4fd0$219de1b0$64d9a510$%jun@samsung.com>
References: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-reply-to: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
Content-language: ko
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Dolev Raviv' <draviv@codeaurora.org>, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday, May 13, 2013, Dolev Raviv wrote:
> This patch series clusters the latest version of all the UFS patches in the
> SCSI mailing list. It gives a stable functional base line for the UFS driver.
> 
> It includes the following versions:
> > [PATCH 1/2] Documentation: devicetree: Add DT bindings for UFS host
> > controller
> > [PATCH 2/2] scsi: ufs: Fix the response UPIU length setting
> > [PATCH v4 1/6] scsi: ufs: wrap the i/o access operations
> > [PATCH v4 2/6] scsi: ufs: amend interrupt configuration
> > [PATCH v4 3/6] scsi: ufs: fix interrupt status clears
> > [PATCH v4 4/6] scsi: ufs: rework link start-up process
> > [PATCH V5 1/1] scsi: ufs: Add support for sending NOP OUT UPIU
> > [PATCH V4] scsi: ufs: Set fDeviceInit flag to initiate device
> > initialization
> 
> But does not include:
> > [PATCH v4 5/6] scsi: ufs: add dme configuration primit
> > [PATCH v4 6/6] scsi: ufs: add dme control primitives
> 
> 
> Dolev Raviv (8):
>   Documentation: devicetree: Add DT bindings for UFS host controller
>   scsi: ufs: Fix the response UPIU length setting
>   scsi: ufs: wrap the i/o access operations
>   scsi: ufs: amend interrupt configuration
>   scsi: ufs: fix interrupt status clears
>   scsi: ufs: rework link start-up process
>   scsi: ufs: Add support for sending NOP OUT UPIU
>   scsi: ufs: Set fDeviceInit flag to initiate device initialization

It seems that you missed my first comment on previous mailing.

RE: [PATCH V1 3/8] scsi: ufs: wrap the i/o access operations
Could you check the e-mail?

If you intended to sort the patches instead of Santosh, 
you should have identify the author per patch e-mail expect 8/8 which is from you.
'From: Author name <Author e-mail>' is expected in the head of e-mail.
I feel that maintainer has this role, though.

And there is need to check the base of tree for ufshcd.
' scsi: ufs: add support for query requests' is not merged finally.
I think we can talk with Santosh for those.

Thanks,
Seungwon Jeon
