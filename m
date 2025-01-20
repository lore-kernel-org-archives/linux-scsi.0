Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE781B87EE;
	Mon, 20 Jan 2025 12:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737375152; cv=none; b=o70n0EXbl1mavGMRsIIpujQU7w1sB+hjUnlAj5ZSWh195J+HVGl3vEIbu1PvJAu8bZVcfAxFjFgCLikECUGCL23ud5WjzPs9k0roc5P+2QCTaLivi77NwbFvpnnlJYOgVpC6/TlsuSrfXIKanVg8k8WXkHIVs+EUnLYDw/WdGlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737375152; c=relaxed/simple;
	bh=41VkMK8VvtDRafDLEdPB9mLCBnDWXtUx5sm5XMhUKDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YtxJ4a9Z1w4f8/L0v5hSShYjTtRi47ZwYJe9eW91S1DUBRfMI8hDsoINfaw2cvKmWNmqNnXRnNUk72MeJsay81dhLDDlmKKqhVzTXTKhR4HTYijLKcGWxbSTEIgkytyY8UXdrKvoRLFAN1LI4mxA+Nqw/7G5qdHf0ofEPmHAl90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=RwxPFxBq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="RwxPFxBq"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50K6ZaJ7016302;
	Mon, 20 Jan 2025 12:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jnoF9oZMLCsV0RI0Akyxbco9AXzP/kH5eIaOFP+Dfa4=; b=RwxPFxBqqbEAZVGw
	9byfFxHsh8j/xDbHLxdOQcdgxVn3T9vaojDN1U1auzR9OfDGR0i5g9/9Gru7EDY7
	DnOa3q8rXiDTIGQCoCY23QMMVznInoKE3wbdTxUhiRMeXPmGqfEx2vzYe2uJWk3K
	eu8cjl7jCzArq3iBUQyTKQNnDo6zB86HNkTUNWAzxjQlEJcSta8Dywa2lA8Ozql9
	jxO3wMNi8YxZ4o/BVxCL4PL8a1C4hYudVp0x/omD40rkLocMpaywj7UKF5mPU9EC
	Ug+Z1tIh5B+BKFEODUmg7p6iG4xqJe8UYpnObMI6zmiv+4YA4Bi+Z3I6GkyM8A8y
	oeLsqg==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 449hbw8u1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 12:12:04 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 50KCC4OB019353
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 12:12:04 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 20 Jan
 2025 04:11:59 -0800
Message-ID: <351fce93-dd1c-4220-a141-71077dd38217@quicinc.com>
Date: Mon, 20 Jan 2025 20:11:57 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] scsi: ufs: core: Toggle Write Booster during clock
 scaling base on gear speed
To: Avri Altman <Avri.Altman@wdc.com>,
        "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "mani@kernel.org" <mani@kernel.org>,
        "beanhuo@micron.com"
	<beanhuo@micron.com>,
        "junwoo80.lee@samsung.com" <junwoo80.lee@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar
	<alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        Eric Biggers
	<ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
        open list
	<linux-kernel@vger.kernel.org>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
 <20250116091150.1167739-8-quic_ziqichen@quicinc.com>
 <DM6PR04MB657571E3A0EFA0E0400FD0A4FC1A2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <DM6PR04MB657571E3A0EFA0E0400FD0A4FC1A2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: gi3CTg-YoWifcUY1S74zJAi7RjLedXV1
X-Proofpoint-ORIG-GUID: gi3CTg-YoWifcUY1S74zJAi7RjLedXV1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_02,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200102

Hi  Avri,

Thanks for your comment.

On 1/16/2025 9:27 PM, Avri Altman wrote:
>>
>> From: Can Guo <quic_cang@quicinc.com>
>>
>> During clock scaling, Write Booster is toggled on or off based on whether the
>> clock is scaled up or down. However, with OPP V2 powered multi-level gear
>> scaling, the gear can be scaled amongst multiple gear speeds, e.g., it may
>> scale down from G5 to G4, or from G4 to G2. To provide flexibilities, add a
>> new field for clock scaling such that during clock scaling Write Booster can be
>> enabled or disabled based on gear speeds but not based on scaling up or
>> down.
>>
>> Co-developed-by: Ziqi Chen <quic_ziqichen@quicinc.com>
>> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
>> Signed-off-by: Can Guo <quic_cang@quicinc.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 17 ++++++++++++-----
>>   include/ufs/ufshcd.h      |  3 +++
>>   2 files changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
>> 721bf9d1a356..31ebf267135b 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -1395,13 +1395,17 @@ static int ufshcd_clock_scaling_prepare(struct
>> ufs_hba *hba, u64 timeout_us)
>>          return ret;
>>   }
>>
>> -static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool
>> scale_up)
>> +static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int
>> +err)
>>   {
>>          up_write(&hba->clk_scaling_lock);
>>
>> -       /* Enable Write Booster if we have scaled up else disable it */
>> -       if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
>> -               ufshcd_wb_toggle(hba, scale_up);
>> +       /* Enable Write Booster if current gear requires it else disable it */
>> +       if (ufshcd_enable_wb_if_scaling_up(hba) && !err) {
>> +               bool wb_en;
> Can be initialized?
>

In this code, the wb_en variable does not need to be explicitly 
initialized. This is because within the conditional statement, wb_en is 
assigned a value based on the comparison between hba->pwr_info.gear_rx 
and hba->clk_scaling.wb_gear. Therefore, regardless of the condition, 
wb_en will be assigned either true or false.

However, it is a good practice to ensure that wb_en is correctly 
assigned in all possible code paths.  Thanks for your suggestion, I will 
initialize it as "False" in next version.

>> +
>> +               wb_en = hba->pwr_info.gear_rx >= hba->clk_scaling.wb_gear ? true
>> : false;
> 
> If (wb != hba->dev_info.wb_enabled)
>> +               ufshcd_wb_toggle(hba, wb_en);
>> +       }
> Wouldn't it make sense to move the wb toggling to ufshcd_scale_gear ?
> This way you'll be able to leave the legacy on/off toggling?
>

We don't need legacy wb on/off any more. Regarding the logic of this 
series, even if gear scale go to legacy branch , current wb toggle logic 
can also cover it.

for example, for legacy gear scale , it only has 2 possible gear speed 
mode, scal up to max gear or scale down to G1, we choose G3 as the 
wb_gear toggle gear can cover legacy WB toggle.

Any more , some customer may want the WB keep ON or OFF, they can set 
the wb_gear to G0 or max_gear to meet their requirement.

>>
>>          mutex_unlock(&hba->wb_mutex);
>>
>> @@ -1456,7 +1460,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba
>> *hba, unsigned long freq,
>>          }
>>
>>   out_unprepare:
>> -       ufshcd_clock_scaling_unprepare(hba, ret, scale_up);
>> +       ufshcd_clock_scaling_unprepare(hba, ret);
>>          return ret;
>>   }
>>
>> @@ -1816,6 +1820,9 @@ static void ufshcd_init_clk_scaling(struct ufs_hba
>> *hba)
>>          if (!hba->clk_scaling.min_gear)
>>                  hba->clk_scaling.min_gear = UFS_HS_G1;
>>
>> +       if (!hba->clk_scaling.wb_gear)
>> +               hba->clk_scaling.wb_gear = UFS_HS_G3;
> So you will toggle wb off on init (pwm) and on sporadic writes.
> I guess there is no harm done.
>

No , it won't toggle wb off on init. As per UFS hba probe sequence, the 
timing of devfreq init is very late.  The WB will be turn ON at the 
early init and complete whole init sequence with high gear speed mode.
Not worry about WB would be turn OFF during init.


> Thanks,
> Avri

-Ziqi

> 
>> +
>>          INIT_WORK(&hba->clk_scaling.suspend_work,
>>                    ufshcd_clk_scaling_suspend_work);
>>          INIT_WORK(&hba->clk_scaling.resume_work,
>> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
>> 8c7c497d63d3..8e6c2eb68011 100644
>> --- a/include/ufs/ufshcd.h
>> +++ b/include/ufs/ufshcd.h
>> @@ -448,6 +448,8 @@ struct ufs_clk_gating {
>>    * @resume_work: worker to resume devfreq
>>    * @target_freq: frequency requested by devfreq framework
>>    * @min_gear: lowest HS gear to scale down to
>> + * @wb_gear: enable Write Booster when HS gear scales above or equal to
>> it, else
>> + *             disable Write Booster
>>    * @is_enabled: tracks if scaling is currently enabled or not, controlled by
>>    *             clkscale_enable sysfs node
>>    * @is_allowed: tracks if scaling is currently allowed or not, used to block
>> @@ -468,6 +470,7 @@ struct ufs_clk_scaling {
>>          struct work_struct resume_work;
>>          unsigned long target_freq;
>>          u32 min_gear;
>> +       u32 wb_gear;
>>          bool is_enabled;
>>          bool is_allowed;
>>          bool is_initialized;
>> --
>> 2.34.1
> 
