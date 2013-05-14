From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: RE: [PATCH V1 0/8] ufs patch siries
Date: Tue, 14 May 2013 01:01:45 -0700
Message-ID: <185188a3c2c85814f5484250cf9e91ee.squirrel@www.codeaurora.org>
References: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
    <003b01ce4fd0$219de1b0$64d9a510$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <003b01ce4fd0$219de1b0$64d9a510$%jun@samsung.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: 'Dolev Raviv' <draviv@codeaurora.org>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Yes, apparently I have, and I missed this mail as well until it was
brought to my attention earlier.

I apologise for re sending the patch series with mistakes, I withdraw it
and let Santosh send it as he see fit.

> On Monday, May 13, 2013, Dolev Raviv wrote:
>> This patch series clusters the latest version of all the UFS patches in
>> the
>> SCSI mailing list. It gives a stable functional base line for the UFS
>> driver.
>>
>> It includes the following versions:
>> > [PATCH 1/2] Documentation: devicetree: Add DT bindings for UFS host
>> > controller
>> > [PATCH 2/2] scsi: ufs: Fix the response UPIU length setting
>> > [PATCH v4 1/6] scsi: ufs: wrap the i/o access operations
>> > [PATCH v4 2/6] scsi: ufs: amend interrupt configuration
>> > [PATCH v4 3/6] scsi: ufs: fix interrupt status clears
>> > [PATCH v4 4/6] scsi: ufs: rework link start-up process
>> > [PATCH V5 1/1] scsi: ufs: Add support for sending NOP OUT UPIU
>> > [PATCH V4] scsi: ufs: Set fDeviceInit flag to initiate device
>> > initialization
>>
>> But does not include:
>> > [PATCH v4 5/6] scsi: ufs: add dme configuration primit
>> > [PATCH v4 6/6] scsi: ufs: add dme control primitives
>>
>>
>> Dolev Raviv (8):
>>   Documentation: devicetree: Add DT bindings for UFS host controller
>>   scsi: ufs: Fix the response UPIU length setting
>>   scsi: ufs: wrap the i/o access operations
>>   scsi: ufs: amend interrupt configuration
>>   scsi: ufs: fix interrupt status clears
>>   scsi: ufs: rework link start-up process
>>   scsi: ufs: Add support for sending NOP OUT UPIU
>>   scsi: ufs: Set fDeviceInit flag to initiate device initialization
>
> It seems that you missed my first comment on previous mailing.
>
> RE: [PATCH V1 3/8] scsi: ufs: wrap the i/o access operations
> Could you check the e-mail?
>
> If you intended to sort the patches instead of Santosh,
> you should have identify the author per patch e-mail expect 8/8 which is
> from you.
> 'From: Author name <Author e-mail>' is expected in the head of e-mail.
> I feel that maintainer has this role, though.
>
> And there is need to check the base of tree for ufshcd.
> ' scsi: ufs: add support for query requests' is not merged finally.
> I think we can talk with Santosh for those.
>
> Thanks,
> Seungwon Jeon
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
