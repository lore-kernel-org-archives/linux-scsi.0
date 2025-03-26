Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B660E18E34A;
	Wed, 26 Mar 2025 23:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743031717; cv=none; b=FCLYfw7kDFN661UBtimbKaZY97PNgaFODErFerkDoHVdprJNJG3JL2IDnZS5r+teicggTQlRsH+IYN/FB77Xkyd/YS+LHGi8bbBjoDgjbWkubRkN9Tu38lHab4h3AR1xBUX85bXxCqlUsPovoZ1Uzd6DjDHeylRWkPpTWk3lLrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743031717; c=relaxed/simple;
	bh=Wd27f82oIfXSmvxj8AHjIGFFPvH1qM/JrcACsvA9fAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=r6F7HyjZBfs/Xtu6WcsWdt9qXYdQJud2ZYKEgotGu4C7unGSFtEXPRtW9PN8bMqHMJo+CwfGohM8RYAmpk20Q/If5hnyKsQ8nVdOe76T9xUoC/1JYLe5OGZFhdrfuMQU+awFiXInz1wutY9/UtfqwAjEQyX6JjE28IxRmIPXWGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=GwxvVGlY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="GwxvVGlY"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QG9fEU011712;
	Wed, 26 Mar 2025 23:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QqLfVZDYycYImiptPEGj6Hth7FILNcm9IYSk00GmEbU=; b=GwxvVGlYXGDnXoij
	UABE0PEpFwLJLveE6w+p7wVBKKX1znMI1b04NOywySBERwEcJ1qT0IKQxaZerlL1
	Plm+0sC6fbj3BxspejMzW7ZWhwUb92jyRjU3FxdeHT/4cknv/Uubrqw5PRDzT5Np
	wECWlcajwm2rvQ07qIYNEPl6tY5OybQAkGFpuFBxFBl7pTJdMrbHvbt52TRDLBiB
	8b0iRJoiROX/Uq8B8IMHNuusGR/fjPrpspzWmAEtjMpVdy9toggvZyEpqMhdk17a
	pn3GbWtVoYbDLydjX/FG8hBdGvs7RVwP6ERkfxCjuCm1CkY/yx0j6cT9XIiqi/E2
	7kgJZw==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45mmuth2g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Mar 2025 23:28:04 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52QNS3AR000933
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Mar 2025 23:28:03 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 26 Mar
 2025 16:28:02 -0700
Message-ID: <d1989803-9573-0458-c9e3-93d04846f664@quicinc.com>
Date: Wed, 26 Mar 2025 16:28:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
Content-Language: en-US
To: Arthur Simchaev <Arthur.Simchaev@sandisk.com>,
        "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>,
        "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar
	<alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Matthias Brugger
	<matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Ziqi Chen
	<quic_ziqichen@quicinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Gwendal
 Grignou" <gwendal@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        open
 list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
        "moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek"
	<linux-mediatek@lists.infradead.org>
References: <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
 <SA2PR16MB4251229744D717821D3D8353F4A72@SA2PR16MB4251.namprd16.prod.outlook.com>
 <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
 <SA2PR16MB4251343F5F595B101950F5E8F4A62@SA2PR16MB4251.namprd16.prod.outlook.com>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <SA2PR16MB4251343F5F595B101950F5E8F4A62@SA2PR16MB4251.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 7myU5PI7XWG_bYd2tH5vAl8y2P9nS6g6
X-Authority-Analysis: v=2.4 cv=MqlS63ae c=1 sm=1 tr=0 ts=67e48d84 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=Njdu76sE2klYb9CA2QUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 7myU5PI7XWG_bYd2tH5vAl8y2P9nS6g6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503260146

On 3/26/2025 12:30 AM, Arthur Simchaev wrote:
>> Hi Arthur,
>> This is not a flags attribute. This is for a Query Read 64-bit Attribute data. In
>> the existing code, we do not have a read 64-bit attribute, so adding this new
>> code would also allow future re-use.
>>
>> The new "struct utp_upiu_query_response_v4_0" would improve readability
>> because it is formatted exactly as how the jedec standard defines for Attribute
>> Read. We won't need to use type cast to get the 64-bit value.
>> There would be no issue with efficiency because the same machine code
>> would be generated.
>>
>> The existing "struct utp_upiu_query_v4_0" probably has a bug in it. It does
>> not use the  __attribute__((__packed__)) attribute. The compiler is free to add
>> padding in this structure, resulting in the read attribute value being incorrect. I
>> plan to provide a separate patch to fix this issue.
> 
> Hi Bao
> 
> Upiu_query can be used for all device management command (descriptions, attributes, flags)
> See section 10.7.9 UPIU QUERY RESPONSE in the UFS 4.1 specification.
> If "struct utp_upiu_query" was properly defined, according to the UFS specification  (by OSF's),
> we would not need to add additional "struct utp_upiu_query_v4_0" structures.
Section 10.7.9 of the device spec v4.0 and v4.1 define the QUERY 
RESPONSE mostly as OSFs (Opcode Specific Field). If the driver used OSFs 
as defined by section 10.7.9, it would not be very readable. Instead, 
the driver tries its best to map these OSFs to meaningful names 
depending on the type of the QUERY command. In my opinion, there is a 
good reason to introduce "struct utp_upiu_query_v4_0". For example, in 
the spec v4.0, Write Attribute only supports up to 32-bit attribute 
size. However, v4.1 supports up to  64-bit attribute size. The "struct 
utp_upiu_query_v4_0" renamed the "__be16 reserved_osf" to "__u8 osf3" 
and "__u8 osf4" which would be better for code readability.

> If you think the structure should be packaged, you can fix "struct utp_upiu_query" and
> "struct utp_upiu_query_v4_0".
That's a fair request. I would like to fix it in a separate patch if 
that works.

Thanks, Bao
