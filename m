Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5F41CDA26
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 21:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724795988; cv=none; b=Sx9+LK7PSwegYeGCjg3vcNqetEPzDGNdFI8mxFtZ4ufPl2MIqL1yIXSulp8wlUhlRWeNwF8U0Tj38aYmRGRniP2a5vScVVoeB9jzcuJ7ptEjsWFtaH/M4gSqvD5t2jI8a5fEd0HG1tWvOzXjL5f+hptqfEAInbluL7gaWvj2u2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724795988; c=relaxed/simple;
	bh=X7SjHQr0dPlBZWFFfrXrJ+yJtdSc/k3GwcUrdmUWupw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AEifz8bnL7xMke6XsCecWHxig7udWBGtJQo7+6b/JSPYAWdiH/FtFCuCLtljbdtaPHCwVfqw4Ip5FvGxXfGJvpSt8uRHK59anTuE0lr8o3GBQABcSliPv2/IlWF6IHdGsZv7HeMKwij5K7AuC5lmwTsmCVpmbyyw1swaDHKqf8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=n5rO46IX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="n5rO46IX"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47RLbJpA011942;
	Tue, 27 Aug 2024 21:59:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	W55RQtptyvktXfXXmpMqsif6frPUQm6quXjHUa/PDns=; b=n5rO46IXfiIIPWxv
	x1RXS6FD+617Fu62nPOIJq+Fu/Hzqy2ZWwONQYSOQ4Ti34ivxLr/20S04WGKTlBu
	VmKpgoCKTg3GxBfbUhka1yP2QeySuTw98hbYOSSn6dJNg12dnr/f7aO0pvKxTF7Z
	WwlItUtMPpQUr+5aCA+sftZcaha7Usb6COzEe25Lgt43M076yy3DkVT5cOHSpbeD
	c3tAfmukmUni/NxEJsTWWurWlxiSkL8P7l9nnW9BT1k7XRuW31n7wLiHXlj05Fdc
	UvH9z7QXKB/HLzW3GronAr4SPHMQj9Qv3ugZNuzAvdo2SPf/vJ11YxezsoWsi4Cs
	X52uQg==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 419puw00y4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 21:59:21 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47RLxJhJ019801
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 21:59:19 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 27 Aug
 2024 14:59:19 -0700
Message-ID: <03bfe9e7-c2cb-d703-9d0b-7b322ea434a1@quicinc.com>
Date: Tue, 27 Aug 2024 14:59:19 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "ebiggers@google.com" <ebiggers@google.com>,
        "ahalaney@redhat.com"
	<ahalaney@redhat.com>,
        "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "avri.altman@wdc.com"
	<avri.altman@wdc.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
 <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
 <63b82e64-e968-4704-85b8-fad919994432@acm.org>
 <b7b0395a59e275c5e43cb282b827b39416a5b4ad.camel@mediatek.com>
 <082b7053-e7f4-4dd9-9d84-c8d9c7d75faf@acm.org>
 <37fc6433d70483b7a889ff804e56023b1081b7b6.camel@mediatek.com>
 <f7f0ca00-a8ce-4841-8483-5ad886da82ad@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <f7f0ca00-a8ce-4841-8483-5ad886da82ad@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: tubBAYvhLzdsjPMAE3PKuv4WAedHeG-o
X-Proofpoint-GUID: tubBAYvhLzdsjPMAE3PKuv4WAedHeG-o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-27_10,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=797 suspectscore=0
 adultscore=0 spamscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408270160

On 8/27/2024 8:42 AM, Bart Van Assche wrote:
> On 8/26/24 6:39 PM, Peter Wang (王信友) wrote:
>> It is not a new vendor hook, ufshcd_vops_hibern8_notify is exist
>> in current kernel.
> Hi Peter,
> 
> Is something like the untested patch below perhaps what you have in
> mind?

Hi Bart, IMHO even though the patch may work, it makes the existing code 
more complicated with the disable_uic_compl_intr flag being sent to the 
platform driver that has nothing to do with it. It seems the proposal 
makes the code harder to read as well. A new person without any history 
of this issue trying to understand the purpose of this flag would 
probably need to spend some extra time digging the history.

Thanks, Bao
