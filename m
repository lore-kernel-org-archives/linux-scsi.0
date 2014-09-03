From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: RE: [PATCH/RFC V2 10/16] scsi: ufs: add UFS power management
 support
Date: Wed, 3 Sep 2014 11:43:29 -0000
Message-ID: <9288387451792e4da08531cc29569a1e.squirrel@www.codeaurora.org>
References: <1408023067-26103-1-git-send-email-draviv@codeaurora.org>
    <1408023067-26103-11-git-send-email-draviv@codeaurora.org>
    <17296D9F8FF2234F831FC3DF505A87A911B24B10@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <17296D9F8FF2234F831FC3DF505A87A911B24B10@shsmsx102.ccr.corp.intel.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Cc: Dolev Raviv <draviv@codeaurora.org>, "James.Bottomley@HansenPartnership.com" <james.bottomley@hansenpartnership.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "santoshsy@gmail.com" <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,
Thanks for reviewing the patches, I'm sorry for the late replay. I was
waiting for some comments before I address all at once and re-send the
series.

>>
>> +static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg
>> *vreg,
>> +				   int ua)
>> +{
>> +	int ret = 0;
>> +	struct regulator *reg = vreg->reg;
>> +	const char *name = vreg->name;
>> +
>> +	BUG_ON(!vreg);
>
> For the UFS host controller driver, which doesn't have the ufs_vreg
> structure for vcc and vccq, this function can cause kernel panic due to
> this BUG_ON(). Any reason to put a BUG_ON here instead of a NULL pointer
> checking?
>
> Thanks
> Chuanxiao
>

Sure, I'll fix this.

Thanks,
Dolev

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
