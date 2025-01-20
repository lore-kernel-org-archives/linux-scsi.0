Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16D11DEFFE;
	Mon, 20 Jan 2025 12:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374917; cv=none; b=VNLl0eKYxS2L3syoxI+aABHC9jL0U47M2uX+uCFLYjtCv/DpXgjIHYmFl23o+c9FkENkL9aXktGAWHl/lwPp4uxSmvrKXrgICrbuRgnpvDiSpf+DHekGdDZKW/5kscNiJu+kYkMYggkrTpf32yWYxDXhQF4mU+koUcjSCN9lbaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374917; c=relaxed/simple;
	bh=VbI7zNQSmxV5g31XMpnURiGgI6MMtLDEgLCVBtnNHAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hE+N+bAAw+ZoPPOnWRFefRRqacYl8kox0NKyRcn6zsPCM54vckUg8CndzYjcuGj8f9R9CiTMw+h1vG9uyJG8R1ddwrZl9ZZv9kKRFJbNdQUt+qdm0pgSEf4QxT495b20vywmhMN4eM9Z5B+//aFFYpVgVn9zWSkakhZlVsvSCeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=PIpwRVH0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="PIpwRVH0"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50KB4DF5010233;
	Mon, 20 Jan 2025 12:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7Z0tYc5iRWgrOOaJ0eMw5FbHUBHMk/J9ZlbtnfrijnM=; b=PIpwRVH0H9HdNr15
	6Vp6rN8TS+dWzDN6q12bCka/dttQkg+LDmQKUR7864KyaryIxr+NzTT0begBXOb4
	bVyug5d0rPZeFnuUfDJuBJStBspovumKPta7CgG6B7mII+VlCi98n5uMDAaeCvgf
	N8BV9EC/4vBGXeTTmMoMyVYpSQAQyTlotHOxpLWJ8eGnEvwlRLzn8GAAaRhxb9vI
	8ixr1txk1n5cTlYB5rghZzw1Cs3iiIDazAdhjM++8LJw6SBsxxfWS7FyypzkU+l2
	QjIW5kP8h/0uf2D/vlNzzCfmVl3fjSDezX4zcAx/74skawnvTz2+iyz4WQ7KjAiQ
	eCXJzQ==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 449n9fg4n7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 12:08:08 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 50KC87ma023484
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 12:08:07 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 20 Jan
 2025 04:08:03 -0800
Message-ID: <226df026-f3c8-4a89-a0a2-66ed3e744109@quicinc.com>
Date: Mon, 20 Jan 2025 20:08:00 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] scsi: ufs: core: Enable multi-level gear scaling
To: Manivannan Sadhasivam <mani@kernel.org>
CC: <quic_cang@quicinc.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
        <avri.altman@wdc.com>, <junwoo80.lee@samsung.com>,
        <martin.petersen@oracle.com>, <quic_nguyenb@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <quic_rampraka@quicinc.com>,
        <linux-scsi@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        open list
	<linux-kernel@vger.kernel.org>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
 <20250116091150.1167739-6-quic_ziqichen@quicinc.com>
 <20250119074823.lnlppdpsfnkz7onx@thinkpad>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <20250119074823.lnlppdpsfnkz7onx@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: lfd7EWcNNapNaItyuEKqOAi0xKcU0Qx1
X-Proofpoint-GUID: lfd7EWcNNapNaItyuEKqOAi0xKcU0Qx1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_02,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200101

Hi Mani,

Thanks for your comment~

On 1/19/2025 3:48 PM, Manivannan Sadhasivam wrote:
> On Thu, Jan 16, 2025 at 05:11:46PM +0800, Ziqi Chen wrote:
>> From: Can Guo <quic_cang@quicinc.com>
>>
>> With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
>> plans. However, the gear speed is only toggled between min and max during
>> clock scaling. Enable multi-level gear scaling by mapping clock frequencies
>> to gear speeds, so that when devfreq scales clock frequencies we can put
>> the UFS link at the appropraite gear speeds accordingly.
>>
>> Co-developed-by: Ziqi Chen <quic_ziqichen@quicinc.com>
>> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
>> Signed-off-by: Can Guo <quic_cang@quicinc.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 46 ++++++++++++++++++++++++++++++---------
>>   1 file changed, 36 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 8d295cc827cc..839bc23aeda0 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -1308,16 +1308,28 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>>   /**
>>    * ufshcd_scale_gear - scale up/down UFS gear
>>    * @hba: per adapter instance
>> + * @target_gear: target gear to scale to
>>    * @scale_up: True for scaling up gear and false for scaling down
>>    *
>>    * Return: 0 for success; -EBUSY if scaling can't happen at this time;
>>    * non-zero for any other errors.
>>    */
>> -static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
>> +static int ufshcd_scale_gear(struct ufs_hba *hba, u32 target_gear, bool scale_up)
>>   {
>>   	int ret = 0;
>>   	struct ufs_pa_layer_attr new_pwr_info;
>>   
>> +	if (target_gear) {
>> +		memcpy(&new_pwr_info, &hba->pwr_info,
>> +		       sizeof(struct ufs_pa_layer_attr));
>> +
>> +		new_pwr_info.gear_tx = target_gear;
>> +		new_pwr_info.gear_rx = target_gear;
>> +
>> +		goto do_pmc;
> 
> goto config_pwr_mode;
>

Ok, Thanks for your suggestion, I will change it in next version.

>> +	}
>> +
>> +	/* Legacy gear scaling, in case vops_freq_to_gear_speed() is not implemented */
>>   	if (scale_up) {
>>   		memcpy(&new_pwr_info, &hba->clk_scaling.saved_pwr_info,
>>   		       sizeof(struct ufs_pa_layer_attr));
>> @@ -1338,6 +1350,7 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
>>   		}
>>   	}
>>   
>> +do_pmc:
>>   	/* check if the power mode needs to be changed or not? */
>>   	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
>>   	if (ret)
>> @@ -1408,15 +1421,19 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool sc
>>   static int ufshcd_devfreq_scale(struct ufs_hba *hba, unsigned long freq,
>>   				bool scale_up)
>>   {
>> +	u32 old_gear = hba->pwr_info.gear_rx;
>> +	u32 new_gear = 0;
>>   	int ret = 0;
>>   
>> +	ufshcd_vops_freq_to_gear_speed(hba, freq, &new_gear);
>> +
>>   	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
>>   	if (ret)
>>   		return ret;
>>   
>>   	/* scale down the gear before scaling down clocks */
>>   	if (!scale_up) {
>> -		ret = ufshcd_scale_gear(hba, false);
>> +		ret = ufshcd_scale_gear(hba, new_gear, false);
>>   		if (ret)
>>   			goto out_unprepare;
>>   	}
>> @@ -1424,13 +1441,13 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, unsigned long freq,
>>   	ret = ufshcd_scale_clks(hba, freq, scale_up);
>>   	if (ret) {
>>   		if (!scale_up)
>> -			ufshcd_scale_gear(hba, true);
>> +			ufshcd_scale_gear(hba, old_gear, true);
>>   		goto out_unprepare;
>>   	}
>>   
>>   	/* scale up the gear after scaling up clocks */
>>   	if (scale_up) {
>> -		ret = ufshcd_scale_gear(hba, true);
>> +		ret = ufshcd_scale_gear(hba, new_gear, true);
>>   		if (ret) {
>>   			ufshcd_scale_clks(hba, hba->devfreq->previous_freq,
>>   					  false);
>> @@ -1723,6 +1740,8 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
>>   		struct device_attribute *attr, const char *buf, size_t count)
>>   {
>>   	struct ufs_hba *hba = dev_get_drvdata(dev);
>> +	struct ufs_clk_info *clki;
>> +	unsigned long freq;
>>   	u32 value;
>>   	int err = 0;
>>   
>> @@ -1746,14 +1765,21 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
>>   
>>   	if (value) {
>>   		ufshcd_resume_clkscaling(hba);
>> -	} else {
>> -		ufshcd_suspend_clkscaling(hba);
>> -		err = ufshcd_devfreq_scale(hba, ULONG_MAX, true);
>> -		if (err)
>> -			dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
>> -					__func__, err);
>> +		goto out_rel;
>>   	}
>>   
>> +	clki = list_first_entry(&hba->clk_list_head, struct ufs_clk_info, list);
>> +	freq = clki->max_freq;
>> +
>> +	ufshcd_suspend_clkscaling(hba);
>> +	err = ufshcd_devfreq_scale(hba, freq, true);
>> +	if (err)
>> +		dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
>> +				__func__, err);
>> +	else
>> +		hba->clk_scaling.target_freq = freq;
>> +
> 
> Just noticed that the 'clkscale_enable', 'clkgate_{delay_ms}/enable' sysfs
> attributes have no ABI documentation. Please add them also in a separate patch.

Ok, I will update it in next version.

>  > - Mani
> 

-Ziqi

