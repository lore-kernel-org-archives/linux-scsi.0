Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1466839AF9;
	Thu, 23 May 2024 05:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716442854; cv=none; b=i1SWnaMSDVYNHTBSOYORPDmpT3oQKkYoHVFwKEAx6g6dLECwIL1BEs0DGJByrD9aKI9QT7vVAjqZjM/oz9KF5Z3YPyP9QpUZfWr3B25Cesnax3bpK8a8iieU+LpbkmJFSkQQYRx9W/XQhXro8E5dwVERBLPzEEh/qbuh8H+EsnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716442854; c=relaxed/simple;
	bh=35itlaO+rA9KzU5Ov74PNAWJ7tehcdbePlz7ppMr4pk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DBLc3+8yGbY+2C2sIH65KlpB3Hv5mX3LIUV88tLTbLNfDoD6Rf9INgctduE9/CPadptdi3HZWrYVMmLNXi7pARFiPIDoHaXS5nwc90p7f3CJXTonPa9BNZN06PwU08CX8XMpdKNTI4v69YdbFRctfZk7LO7K2ywxmyxSd+6/9i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=CTHt4raI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="CTHt4raI"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44N4bXYO017108;
	Thu, 23 May 2024 05:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xkmv9iIp8a+RWEQjJtVYBPwA9Bxka1qZ77csRraEb4I=; b=CTHt4raIIFi3Jx5+
	cYf14HlekcakyHu2xDxfXXmRFvk1GKm1vFlxWDwEm+xS5hAi2itsaHiRTGHtO2cL
	RaZcL+2dAPXyu7cMfEEU9ONf4/SUEzeEUAscv9PDtO9eUE50RyrKHuVa9V09zdJn
	/+jJEj7GYSeBNeutN50x+Rw9GgutzYM1QSlrmCpLoViqS9GMMWYTRkenRpLAnQ/7
	lBDAGGSZeOvyUbAEIprJCuxOaB8p27akGGEHlZo+ynIzkAZ53Uz2miK1m7JQocE+
	at+11pNwg4YrZ+KfYeJHBONtVjs1X0N0FhqEmUmeXDpxqjp+cFc2IDSZXM9wVkmb
	DP/VBQ==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3y9xxe037a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 05:40:34 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44N5eXLa013380
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 05:40:34 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 22 May
 2024 22:40:33 -0700
Message-ID: <170203d2-c24e-3154-042d-fd8473767207@quicinc.com>
Date: Wed, 22 May 2024 22:40:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 1/2] scsi: ufs: core: Support Updating UIC Command
 Timeout
Content-Language: en-US
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
CC: Bart Van Assche <bvanassche@acm.org>, <quic_cang@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <avri.altman@wdc.com>,
        <beanhuo@micron.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James
 E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        open list
	<linux-kernel@vger.kernel.org>
References: <cover.1716359578.git.quic_nguyenb@quicinc.com>
 <292d7702e946ca513af51236ca9e38bf1b1eb269.1716359578.git.quic_nguyenb@quicinc.com>
 <cb05bc3f-5fb0-45aa-961b-bb9edc007407@acm.org>
 <d4d7ac49-1055-5305-99b5-af8e1428c746@quicinc.com>
 <20240523043828.GA5758@thinkpad>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240523043828.GA5758@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: _0OjRWfHba2SZIWstTe2Cai5HVM2bFL6
X-Proofpoint-ORIG-GUID: _0OjRWfHba2SZIWstTe2Cai5HVM2bFL6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_02,2024-05-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405010000 definitions=main-2405230036

On 5/22/2024 9:38 PM, Manivannan Sadhasivam wrote:
> On Wed, May 22, 2024 at 01:51:06PM -0700, Bao D. Nguyen wrote:
>> On 5/22/2024 11:16 AM, Bart Van Assche wrote:
>>> On 5/22/24 00:01, Bao D. Nguyen wrote:
>>>> interrupt starvations happen occasionally because the uart may
>>>> print long debug messages from different modules in the system.
>>>
>>> I think that's a bug in the UART driver that should be fixed in the
>>> UART driver.
>>
>> Thanks Bart.
>> I am not familiar with the UART drivers. I looked at some UART code and it
>> could be interpreted as their choice of implementation.
>> During product development, the UART may be used. However, when the
>> development completes, most likely the UART logging is disabled due to
>> performance reason.
>>
>> This change is to give flexibility to the SoCs to use the UART
>> implementation of their choice and to choose the desired UIC command timeout
>> without affecting the system stability or the default hardcoded UIC timeout
>> value of 500ms that others may be using.
>>
> 
> If UART runs in atomic context for 500ms, then it is doomed.
> 
> But for increasing the UIC timeout, I agree that the flexibility is acceptable.
> In that case, please use a user configurable option like cmdline etc... instead
> of hardcoding the value in glue drivers.

Thanks Mani. Bart also suggested something along that line.

Thanks, Bao

> 
> - Mani
> 

