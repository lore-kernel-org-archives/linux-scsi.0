Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037B1748A;
	Sat, 23 Nov 2024 00:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732322113; cv=none; b=TBHU8+EW0opathVeQaklXHBtVQRfi0RtbehT4/qR61OHs+XJgOwaAlJCjt7HD46+eA7SGPv89dXGIURBZt5cDNYUcs1nbkK0WS1kNTH+SBkV1dICh7fqG5F1uOeeGqaMsD3dqaQ9k8nH26FeZoYM/ANpM1MwTeCEg8FgZ7tn054=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732322113; c=relaxed/simple;
	bh=bd4qGOwzWCMs5thsWeUzHO4b5jM9gr/L5f9rD/V2znc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SQBiA4Wx3T9qhIx/BWbF0mAI+rVIgJIlNXv/dpbMwUy9VcOSsSCCDkopzu51AG3TH909pWuwknydny8UYO+85GXsELuAwzcHA2S+f2XKwtGhoZziXIMv5F0Wk8VOA/f+N/ptLcrX2eIBBq75ka2yDmU1JCb7JJssq/LmDMD0+r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=SHmPsPm2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="SHmPsPm2"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AMF6Ftq019747;
	Sat, 23 Nov 2024 00:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Wm95twQ2bd5ofSQCOY9BH+BC09kgLH4FStSo7Lfg8H8=; b=SHmPsPm2vfvlAEnv
	SHTDe9N5UC7rue+5ZF5KouiVf1o3IVqDeQkrABeCA7Z5H3zFLoPkCasiiumY4M6s
	3gdRAkaaZT8ObXP3Q7MSptq76MRZ+acGzWJRZDTIZZ3QiWS93zlq64nJpHSwBIgj
	cl0bYitp1nj0LoHRP8QlVUs7g8UxY3L7xI5bOTQ/0R0nO1tTcYe7b8LFfwtDYggU
	JegGcOp6AyKi30skGAbtqvgKXy/C7hC94z3y8ka9xS6PjihhuMJBJqoh/1r3+TDt
	yUVz7uy3QGY7Ab/kNzBX7X5BRy4rI2JQV0BQ4iWF9STQBwBh+GCnIrt12whRZwzf
	bhg05Q==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4326atck5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Nov 2024 00:34:48 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 4AN0YmwB025487
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Nov 2024 00:34:48 GMT
Received: from [10.253.32.206] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 22 Nov
 2024 16:34:45 -0800
Message-ID: <bab3f513-9eaa-40ac-9f0a-57bcaffe834b@quicinc.com>
Date: Sat, 23 Nov 2024 08:34:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 26/26] scsi: ufs: Inform the block layer about write
 ordering
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC: <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Christoph
 Hellwig" <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
        Jaegeuk Kim
	<jaegeuk@kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-27-bvanassche@acm.org>
 <37f95f44-ab1d-20db-e0c7-94946cb9d4eb@quicinc.com>
 <82649541-7db9-4b50-a1e1-e38a9078761c@acm.org>
Content-Language: en-US
From: Can Guo <quic_cang@quicinc.com>
In-Reply-To: <82649541-7db9-4b50-a1e1-e38a9078761c@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: rdzWA7GCHrOrimhDodULdaT0EYjzhHHB
X-Proofpoint-GUID: rdzWA7GCHrOrimhDodULdaT0EYjzhHHB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=731 lowpriorityscore=0
 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411230003


On 11/23/2024 2:20 AM, Bart Van Assche wrote:
> On 11/21/24 6:58 PM, Can Guo wrote:
>> So, in MCQ mode, we are re-directing all zoned writes to one HW queue 
>> to preserve the write order, is my understanding correct?
> That's somewhat but not entirely correct. As one can see in patch 20/26,
> the software queue (and hence also the hardware queue) that was selected
> for zoned writes is unselected after all pending zoned writes for a
> given zone have completed:
>
> +    if (refcount_read(&zwplug->ref) == 2)
> +        zwplug->swq_cpu = -1;
>
> So the next time a write bio or write request is submitted a different
> queue may be selected.

Understood, thanks for explaining.

Reviewed-by: Can Guo <quic_cang@quicinc.com>

>
> Thanks,
>
> Bart.
