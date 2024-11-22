Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8714C6C;
	Fri, 22 Nov 2024 02:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732241590; cv=none; b=WFd6vXOvzFlPE05QHcIiS1wKPpneh2cpr1et13S6gLb8c5wLCEjPcp1KF+dx7WugsNUypLqHhqlm6JFonFuMgQ9kymJ4oG8OWjPb4fRkziEzC3xSXp43k5kCg+FM6/OY42mRQG2t7NiRmx1RYiZ8aCoMPTjZCd3wkRYwBXA2FYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732241590; c=relaxed/simple;
	bh=MHGY4ON/QUzDFYppiQMJox3MoRJjNTpgMa7eABlS5EE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HL+pnsW4CFFBxa09xDyyVliHvjpx5VeDzR39uSP/W8DawlCG/a8K8AJnT0yls/MH2W/tdj7Ldw19QaNOrA6uOTo4Gu92DJefCtUCwq+IGliE2yJJorBF2ghYZex8i3vQcwz5s3LcddAhl/uAOUB+cXnj8mNKuBHRy9IgCvgjwrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=FsFB+cBY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="FsFB+cBY"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ALGxhpd015642;
	Fri, 22 Nov 2024 02:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Fm5kITWrW/6aGvNbzM3yam0S05mP6K/ci6WjsOFrOEs=; b=FsFB+cBYDZnJDROi
	FtfXRprDydjrrVOwemKzoQlJ6nMZWo5T9F9otovFwsYZiQAxZd+zWhJ85yjQtCc9
	fj2wEGAh3RkMedvxbi3S4u1WJnugF3kVMhtqHbsFtJm03YlEXFcM8F0PQ9Vr7pom
	yyyqtGMrTJ2pgg2H73/kZ66vQa41D4zL9CRt1E+9DQ4tYT4Mmsp3MTsgZMhLSaQZ
	OkZPf8JhLQ3kGu6Ql8w0JKsfUE2jVvkpCXW6uBalSKkNAZEbqrbPj+y2dGE6SN4j
	ewdcfS2QjTs/EdewBWOBprmzHZZOcUkF4D/flppQXQkbokg4+Cxr7ywKMl3Ny91w
	ZC9nPA==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4320y9jpvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 02:12:52 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 4AM2Cpbk010850
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 02:12:51 GMT
Received: from [10.253.32.110] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 21 Nov
 2024 18:12:49 -0800
Message-ID: <fd764f6f-8486-b4c9-26f9-2ff9d903ac7f@quicinc.com>
Date: Fri, 22 Nov 2024 10:12:46 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] scsi: ufs: core: sysfs: Prevent div by zero
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        Gwendal Grignou
	<gwendal@chromium.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <daejun7.park@samsung.com>
CC: <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>
References: <20241120062522.917157-1-gwendal@chromium.org>
 <a487b02b-72c6-4bee-bfdf-4106cda96f36@acm.org>
From: Can Guo <quic_cang@quicinc.com>
In-Reply-To: <a487b02b-72c6-4bee-bfdf-4106cda96f36@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: B48jzIkl2xz1WDz2u8Yj5wA-JFaiw8xd
X-Proofpoint-ORIG-GUID: B48jzIkl2xz1WDz2u8Yj5wA-JFaiw8xd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=928 spamscore=0 mlxscore=0 malwarescore=0 clxscore=1011
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411220017

Hi Bart,

On 11/22/2024 4:24 AM, Bart Van Assche wrote:
> On 11/19/24 10:25 PM, Gwendal Grignou wrote:
>> Prevent a division by 0 when monitoring is not enabled.
>>
>> Fixes: 1d8613a23f3c ("scsi: ufs: core: Introduce HBA performance 
>> monitor sysfs nodes")
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
>> ---
>>   drivers/ufs/core/ufs-sysfs.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
>> index c95906443d5f9..3692b39b35e78 100644
>> --- a/drivers/ufs/core/ufs-sysfs.c
>> +++ b/drivers/ufs/core/ufs-sysfs.c
>> @@ -485,6 +485,9 @@ static ssize_t read_req_latency_avg_show(struct 
>> device *dev,
>>       struct ufs_hba *hba = dev_get_drvdata(dev);
>>       struct ufs_hba_monitor *m = &hba->monitor;
>>   +    if (!m->nr_req[READ])
>> +        return sysfs_emit(buf, "0\n");
>> +
>>       return sysfs_emit(buf, "%llu\n", 
>> div_u64(ktime_to_us(m->lat_sum[READ]),
>>                            m->nr_req[READ]));
>>   }
>> @@ -552,6 +555,9 @@ static ssize_t write_req_latency_avg_show(struct 
>> device *dev,
>>       struct ufs_hba *hba = dev_get_drvdata(dev);
>>       struct ufs_hba_monitor *m = &hba->monitor;
>>   +    if (!m->nr_req[WRITE])
>> +        return sysfs_emit(buf, "0\n");
>> +
>>       return sysfs_emit(buf, "%llu\n", 
>> div_u64(ktime_to_us(m->lat_sum[WRITE]),
>>                            m->nr_req[WRITE]));
>>   }
>
> Is anyone using the UFS monitor infrastructure or can it perhaps be
> removed?

We are the user of the UFS monitor. And we are about to integrate UFS 
queue depth monitoring in it.


Thanks,

Can Guo.

>
> Thanks,
>
> Bart.
