Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B3D1DA100;
	Thu, 16 Jan 2025 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737045041; cv=none; b=pL85b7GgH7QMfJyxr242FihN78nIcK/5e+FMOzFR+muj4Hw8K/iXjGz0j7t+cVnbyAarL0lRMzh89HprtJyPY9LlbXcwLM0EUq1u6J1VqnevlSot/uIINBf0ee9a5zgFUKt7f1juuyC+gPSEeHl8GQWt0w9Se2o3S33762wev8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737045041; c=relaxed/simple;
	bh=IrxeTCqp/MPKEeS593OcbGDMA0/++DKUOUwgkVQOzTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ibVeZDxv9PdvCOfa8j3eTqYibkdlsxEaGzhuZrJGgGT2ZOHDVdyNOZ0t6HSpYyVNOQeo9+M8Xenwx72s84xESlUQHRqxhX7hl0A+BX0TljB+cHojA6hrF0uMWO8lqLS5t1P4DArNsfaZfd13uH0gIalrcJvJYpJk7IprJUVnt9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=AUuwuyIv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="AUuwuyIv"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GEJdqE005927;
	Thu, 16 Jan 2025 16:30:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	M+kc1IWP1xTI4L7fMxX1zRtcKk9bQJr6mKepph38uKg=; b=AUuwuyIv1fRcWxDq
	jqhFkWas6A+uWYIvhaNOrBogMAnSWk1GPDckynUfRxlaPINBTggKFoGxV7AWzEdO
	DE3t9fG5t9uZRPMqjoCL6d52FQDR7arkweWI+FVSfMLzhnxAnswM/7b6wmgYAZ12
	2h62EJfTj7LtZkv1ljrowjm4PUZCKcKNdV5710/lG1Av/oW41ZODearTjaerRTgW
	fs7Yp1oL+qL8fxWZbhmdUkKxSmqQPVZx6YlYDVLx5mQ3ss3lfRm8uf+vCEw0qDAT
	doCQemhMLG6VHMb3HZKbXSGifVGl2fEyf4IuQ24oMrWwAopqKmXPVO209+fWvEhE
	JGwa9Q==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4473se0anh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 16:30:14 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 50GGUDce004543
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 16:30:13 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 16 Jan
 2025 08:30:12 -0800
Message-ID: <6a49b676-e530-2320-9f53-c05597a56dac@quicinc.com>
Date: Thu, 16 Jan 2025 08:30:12 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] scsi: ufs: core: increase the NOP_OUT command timeout
Content-Language: en-US
To: DooHyun Hwang <dh0421.hwang@samsung.com>,
        'Avri Altman'
	<Avri.Altman@wdc.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <bvanassche@acm.org>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <quic_mnaresh@quicinc.com>
CC: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
        <junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
        <sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
        <sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
References: <CGME20250115022348epcas1p29705c109f51c01e1e91ef227233c7119@epcas1p2.samsung.com>
 <20250115022344.3967-1-dh0421.hwang@samsung.com>
 <DM6PR04MB6575C2833DD66B847572F53CFC1A2@DM6PR04MB6575.namprd04.prod.outlook.com>
 <425301db67fd$5c27ca60$14775f20$@samsung.com>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <425301db67fd$5c27ca60$14775f20$@samsung.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: QMrmOO0jXWtwdqqJPtf4C1TpabYOP4KV
X-Proofpoint-ORIG-GUID: QMrmOO0jXWtwdqqJPtf4C1TpabYOP4KV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160124

On 1/16/2025 1:59 AM, DooHyun Hwang wrote:
>>
>>> It is found that is UFS device may take longer than 500ms(50ms *
>>> 10times) to respond to NOP_OUT command.
>>>
>>> The NOP_OUT command timeout was total 500ms that is from a timeout
>>> value of 50ms(defined by NOP_OUT_TIMEOUT) with 10 retries(defined by
>>> NOP_OUT_RETRIES)
>>>
>>> This change increase the NOP_OUT command timeout to total 1000ms by
>>> changing timeout value to 100ms(NOP_OUT_TIMEOUT)
>>>
>>> Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
>> Why not edit hba->nop_out_timeout in the .init vop?
>> Like some vendors already do.
>>
>> Thanks,
>> Avri
>>
> Thank you for your suggestion.
> I'll fix that in .init vop as you said.
> 
> And I'll reject this patch.
Hi DooHyun Hwang,
Since this is a common issue that multiple platform vendors have to fix 
in their vops, should we fix it in the common code instead?

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
