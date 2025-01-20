Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B901B87EE;
	Mon, 20 Jan 2025 11:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374217; cv=none; b=Kj00yW1Sg+OglFnj7Ltayr2/XH8wUw5AYVm2/tTYRRVOot8svlyQ9lkMO8v0xtGKGyIOFm8FKWcWNaeEL4xOX9+hGa2Td8xim2Ey867tu3uaAA6PigYiv+2wyaentYcORz7MrPlxIxNEbutIcH4OhPdH1HaIjmS3smvBvLPBGt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374217; c=relaxed/simple;
	bh=/mfE+fOLEiMsq2Ht/vyqeybVQt7Hj3gidokVufPK0gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XaTRiUF335WrGySBbwgKd75H+xkUOx68LA8ulg7B5+0vT7mtyOTZ0c16pFJmzR5NW25bTzNJ1xzLRsF0zURzf1MaMpoqjhT1GPC4AkW6YBqB8hOyQiMjEubgVYf+jvHrFt34a86Kwc48wEtrhHlNANm1QT4F/EixOYt+wbHuBTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Td4+vyeO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Td4+vyeO"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50K6ZZpV016283;
	Mon, 20 Jan 2025 11:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	w8jWozrajyoXdrHUDtvFyWTxcgM3eBSSjGPuFl38OYM=; b=Td4+vyeOK2kT4qNv
	NJZX4uRLxxcT1BsaifpRyoFEZFB3Hnov/wFDIAQa9Rd7IQIna4eSMhdeiQ130vwv
	zsukZM3I0Y/mxc8fnAEwMAtd4taFrEgusqBPo9uGjE2yqcfM2FU+Ex6y0GU6l9op
	4AeZSSwQjtA9mqtPJTI84ibP3cxNDGC3rixuGmbkka1+fPXUwCsgCsomPHsbRpmo
	aWudT5aVD+zknvuXqHBvdgyhN9k2gm9C4kktaDT5y4Kr96nNLFBD+7gDNdWVLb6Z
	nU/jkV+alT1H5B4orP1l95r1JLbVgb8CMSu2KkhumFaZwPdJbbTIKo7L9mUJZHqR
	/5dNPw==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 449hbw8sxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 11:56:26 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 50KBuP08009230
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 11:56:25 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 20 Jan
 2025 03:56:21 -0800
Message-ID: <ecb6fd1d-da28-498e-96ec-6c909f27f7dc@quicinc.com>
Date: Mon, 20 Jan 2025 19:56:18 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Support Multi-frequency scale for UFS
To: <neil.armstrong@linaro.org>, <quic_cang@quicinc.com>, <bvanassche@acm.org>,
        <mani@kernel.org>, <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <junwoo80.lee@samsung.com>, <martin.petersen@oracle.com>,
        <quic_nguyenb@quicinc.com>, <quic_nitirawa@quicinc.com>,
        <quic_rampraka@quicinc.com>
CC: <linux-scsi@vger.kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        "open
 list:ARM/Mediatek SoC support:Keyword:mediatek"
	<linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
        "moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek"
	<linux-mediatek@lists.infradead.org>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
 <92b2f271-34dc-4560-a96c-bdd372d5e3d6@linaro.org>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <92b2f271-34dc-4560-a96c-bdd372d5e3d6@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: QSlFHbwRqtODDMh-qSkN3UzKUaF01m7H
X-Proofpoint-ORIG-GUID: QSlFHbwRqtODDMh-qSkN3UzKUaF01m7H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_02,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200100

Hi Neil,

Thanks for your comment.

On 1/16/2025 5:28 PM, Neil Armstrong wrote:
> Hi,
> 
> [+linux-arm-msm@vger.kernel.org]
> 
> On 16/01/2025 10:11, Ziqi Chen wrote:
>> With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
>> plans. However, the gear speed is only toggled between min and max during
>> clock scaling. Enable multi-level gear scaling by mapping clock 
>> frequencies
>> to gear speeds, so that when devfreq scales clock frequencies we can put
>> the UFS link at the appropraite gear speeds accordingly.
>>
>> This series has been tested on below platforms -
>> SM8650 + UFS3.1
> 
> Which board did you use ? the MTP ? >

We tested on MTP.

>> SM8750 + UFS4.0
> 
> Did you alse test it on SM8550 ? this platform is also concerned.
> And perhaps SM8450 should be also converted to the OPP table & tested.
>
We didn't test in on SM8550 before, but now we already tested it on 
SM8550 once see you this comment. It works fine on SM8550 as well.
I will update this information in next version.

> Please Cc linux-arm-msm on all patches since we're directly concerned by
> the whole changeset.

Sure , Thank you for reminder, I will CC this group from next version.

> 
> Thanks,
> Neil
>

-Ziqi

>>
>>
>> Can Guo (6):
>>    scsi: ufs: core: Pass target_freq to clk_scale_notify() vops
>>    scsi: ufs: qcom: Pass target_freq to clk scale pre and post change
>>    scsi: ufs: core: Add a vops to map clock frequency to gear speed
>>    scsi: ufs: qcom: Implement the freq_to_gear_speed() vops
>>    scsi: ufs: core: Enable multi-level gear scaling
>>    scsi: ufs: core: Toggle Write Booster during clock scaling base on
>>      gear speed
>>
>> Ziqi Chen (2):
>>    scsi: ufs: core: Check if scaling up is required when disable clkscale
>>    ARM: dts: msm: Use Operation Points V2 for UFS on SM8650
>>
>>   arch/arm64/boot/dts/qcom/sm8650.dtsi | 51 ++++++++++++++++----
>>   drivers/ufs/core/ufshcd-priv.h       | 17 +++++--
>>   drivers/ufs/core/ufshcd.c            | 71 +++++++++++++++++++++-------
>>   drivers/ufs/host/ufs-mediatek.c      |  1 +
>>   drivers/ufs/host/ufs-qcom.c          | 60 ++++++++++++++++++-----
>>   include/ufs/ufshcd.h                 |  8 +++-
>>   6 files changed, 166 insertions(+), 42 deletions(-)
>>
> 
