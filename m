Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E22145B14;
	Wed, 22 May 2024 20:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716411117; cv=none; b=tj4j1t2vikohX99eJ1oyDBhvezFlcI2BmcCiib3u2cD6AAtT7aBS1Kn47OTDfSyLopgVQlLj7MPYX8hSzVjXxi1snLA1qW6hZuDsxYGK9XUyj+j4uo5iu98dwt5NhCR2FHl0JCxI6/fVjLq80m9yrihgU7LRD4CJURbVqd1UmSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716411117; c=relaxed/simple;
	bh=2je7tMupQ5J/2scv3Em8zFAbfVCMH/acMAhZJYtTcu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tD7ku+yy2zfD5zLFXquFXvMau6u16rEwFVz3Fo7S0tRDMHvImIZOcuJuCID/5AJ6whltzfq+pevTG/o8EfCM/30w3cdaTjCyrda4i1Mz2a3R4nxCPPNN4WcTEcXLsnMI0yzU7f1JYezu0+GbIHnss2il4FRDjYtMLBGp5zCXEek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Hpyajizz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Hpyajizz"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44M9xmVk022596;
	Wed, 22 May 2024 20:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=KV4WOQsRSDwS8oNT6ukhQoiGlGgCvhowijg8k7/PJdc=; b=Hp
	yajizzZKXo1v+pgG8mfD6QP3u/ryi/w58SHPOZ4JXy+bhFXoor2OCzzX23cgvG5+
	SaDFhQb2af9FhvJaDjosUo6zpyTUaPbqvkYY/EC02x5bSU0xOZcWbO+v3DSlhYDd
	V4L7O26Ux64cjX6tRNvV5zklp2d/4fJ0wYeHUW1lG5PAuYojCOo3ccbOtP61hp4o
	nhmEtSLchc3cWzOGLnrXwObUW+jxJ3K6ZzEOzuY8JHa1qQl2P2d6SwL07KXKarak
	uFqbCh9YoZz0dd6HrWCYgZLfc64oWvW4qVCv9r+GhVJKEwJc3sxxc0Ed+VVf8dc/
	VZWba5i1ntr3D4VO5zyg==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3y6n4pah6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 20:51:24 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44MKpNl1032114
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 20:51:23 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 22 May
 2024 13:51:22 -0700
Message-ID: <d4d7ac49-1055-5305-99b5-af8e1428c746@quicinc.com>
Date: Wed, 22 May 2024 13:51:06 -0700
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
To: Bart Van Assche <bvanassche@acm.org>, <quic_cang@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <avri.altman@wdc.com>,
        <beanhuo@micron.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu
	<stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Manivannan
 Sadhasivam" <manivannan.sadhasivam@linaro.org>,
        Po-Wen Kao
	<powen.kao@mediatek.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        "open
 list" <linux-kernel@vger.kernel.org>
References: <cover.1716359578.git.quic_nguyenb@quicinc.com>
 <292d7702e946ca513af51236ca9e38bf1b1eb269.1716359578.git.quic_nguyenb@quicinc.com>
 <cb05bc3f-5fb0-45aa-961b-bb9edc007407@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <cb05bc3f-5fb0-45aa-961b-bb9edc007407@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 2gOWUQ7L7olf32IfUzWWyAalqyyUdrLW
X-Proofpoint-GUID: 2gOWUQ7L7olf32IfUzWWyAalqyyUdrLW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_11,2024-05-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 spamscore=0
 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405010000 definitions=main-2405220145

On 5/22/2024 11:16 AM, Bart Van Assche wrote:
> On 5/22/24 00:01, Bao D. Nguyen wrote:
>> interrupt starvations happen occasionally because the uart may
>> print long debug messages from different modules in the system.
> 
> I think that's a bug in the UART driver that should be fixed in the
> UART driver.

Thanks Bart.
I am not familiar with the UART drivers. I looked at some UART code and 
it could be interpreted as their choice of implementation.
During product development, the UART may be used. However, when the 
development completes, most likely the UART logging is disabled due to 
performance reason.

This change is to give flexibility to the SoCs to use the UART 
implementation of their choice and to choose the desired UIC command 
timeout without affecting the system stability or the default hardcoded 
UIC timeout value of 500ms that others may be using.

Bao

> 
> Thanks,
> 
> Bart.

