Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7681DF255;
	Mon, 20 Jan 2025 11:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374315; cv=none; b=fZzYB60bJgd4mBp3NzADf6DkQrZ9aqML/Uve3Dz/hS4Ps2/QjORe5hqf1lX/KuL5jGB0hXOJB69MivMjMWCs/Vl8ae3iiMEy6f4IkSoBHvuxWpHpb4e0Rt6igcQ4z6q9u8Que45phz5Xg3M6q5LYn8+CmdBPqpWCQl7XKIXe6lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374315; c=relaxed/simple;
	bh=AfeQOBr0Y34ixSC89zorgZ5TFOIeL9narT4DuprN99o=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=B1ZxiFmXbQg7y808Gd2Vr1IWhNrj9kwIteiTNo/ypKcoVB78QjUq0lp0O4cZP1R93Po8i9HtLDTCckiyFfJsZYgCGxw3+a233ebak4l+cNjJxQNfH3us+4JiEndtXDa+93zqfESJsVWwePObnUoge0/TCcHoeI69w3oAZUxNStU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=eCmyoic2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="eCmyoic2"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50KAAfT5020728;
	Mon, 20 Jan 2025 11:58:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4PNNl+Yf4kXRCZiUvWLBcmVi34q6bvc8a/VLVrBeW10=; b=eCmyoic2nVv8Imhh
	oRqklrUzGpMm3iCa9hBfXNgzBUOI99H/rU0wYPpJfGyliMyiNJP+oopmLqbt1aHm
	LWGeKDA1R7bdBYJa2ymAcct9lIKFDbKy721gUZ1pDjYI0mr7prZydkAC8uYFc8HX
	/9L1sWUWVK+uL5tmF1FH/XeQQX1LRVFqV3Z9+8kNbnh4LmHGwuUFqXJlkoQwe9cm
	atZHqN+ae5XXcIoLemK4cp4fJeQ6hSTfcCVipDJbyLkTt8+/bqaK4Dbz4I/NB5+H
	4TKO3K0n6bmYdP/dkqOGGL3Op23KpXNhIGNITk8URFSAyo70iHbX0mRE3uXb3SsR
	fmtC8g==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 449mgpg7yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 11:58:09 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 50KBw8J9004599
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 11:58:08 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 20 Jan
 2025 03:58:04 -0800
Message-ID: <1b66aeda-b04f-4502-9e41-e3eeacdb74ed@quicinc.com>
Date: Mon, 20 Jan 2025 19:58:02 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Support Multi-frequency scale for UFS
To: Manivannan Sadhasivam <mani@kernel.org>
CC: <quic_cang@quicinc.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
        <avri.altman@wdc.com>, <junwoo80.lee@samsung.com>,
        <martin.petersen@oracle.com>, <quic_nguyenb@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <quic_rampraka@quicinc.com>,
        <linux-scsi@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
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
 <20250119075736.cyjgpglf4azrmprv@thinkpad>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <20250119075736.cyjgpglf4azrmprv@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: suU-JLrEa2xj2GcdxBeo2r_gDYx-l7NW
X-Proofpoint-GUID: suU-JLrEa2xj2GcdxBeo2r_gDYx-l7NW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_02,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 phishscore=0 priorityscore=1501 mlxlogscore=980
 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200100

Hi Mani,

Thanks for you review~

On 1/19/2025 3:57 PM, Manivannan Sadhasivam wrote:
> On Thu, Jan 16, 2025 at 05:11:41PM +0800, Ziqi Chen wrote:
> 
> You missed CCing linux-arm-msm mailing list to the cover letter.
>
Thank you for reminder, I will cc this group in next patch version.

>> With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
>> plans. However, the gear speed is only toggled between min and max during
>> clock scaling. Enable multi-level gear scaling by mapping clock frequencies
>> to gear speeds, so that when devfreq scales clock frequencies we can put
>> the UFS link at the appropraite gear speeds accordingly.
>>
> 
> But the UFSHC PHY settings are not updated for each gear speed, isn't it? Then
> I'm wondering how much we get out of this 'multi-level gear scaling'.

Per design, we don't need to update any PHY setting for each gear speed 
mode.

> 
> - Mani
> 

-Ziqi

>> This series has been tested on below platforms -
>> SM8650 + UFS3.1
>> SM8750 + UFS4.0
>>
>>
>> Can Guo (6):
>>    scsi: ufs: core: Pass target_freq to clk_scale_notify() vops
>>    scsi: ufs: qcom: Pass target_freq to clk scale pre and post change
>>    scsi: ufs: core: Add a vops to map clock frequency to gear speed
>>    scsi: ufs: qcom: Implement the freq_to_gear_speed() vops
>>    scsi: ufs: core: Enable multi-level gear scaling
>>    scsi: ufs: core: Toggle Write Booster during clock scaling base on
>>      gear speed
>>
>> Ziqi Chen (2):
>>    scsi: ufs: core: Check if scaling up is required when disable clkscale
>>    ARM: dts: msm: Use Operation Points V2 for UFS on SM8650
>>
>>   arch/arm64/boot/dts/qcom/sm8650.dtsi | 51 ++++++++++++++++----
>>   drivers/ufs/core/ufshcd-priv.h       | 17 +++++--
>>   drivers/ufs/core/ufshcd.c            | 71 +++++++++++++++++++++-------
>>   drivers/ufs/host/ufs-mediatek.c      |  1 +
>>   drivers/ufs/host/ufs-qcom.c          | 60 ++++++++++++++++++-----
>>   include/ufs/ufshcd.h                 |  8 +++-
>>   6 files changed, 166 insertions(+), 42 deletions(-)
>>
>> -- 
>> 2.34.1
>>
> 
