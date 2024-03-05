Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D0C46521
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 06:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709619855; cv=none; b=pePDtbj45t/YBiXSdAJpjhF6oYikz2nIBJCaIK3sxPScrN8hR0AR+VQgHEq3Ix13IL+uBXcp22cY9i+hYufRzGXw2hjynFibULuFYlXbmIvPVwtstLLv/2CDGAtNbXrB0zK87/wAg4a5aB003bVHfPCp+C4e/54s8kPJq2Jh6BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709619855; c=relaxed/simple;
	bh=XyAXgB2YoPk7YMebJUvAwa0FLPvJmqVV8vDiHO/jhqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BtfCeG8dN72nmI9tCVrmJhMh4W93W+L3dtdOJKJyfpHnmtuOhQEiArBPTiN2cMbIHH8R+wpKROtTtnniBNj7ISXiycKBsNFoPqxsFAUs6KtsjbVYa39joDYc38nTfYY4FJSyI6tkkIrj0JYyLs8GQPjrJyPONkXRBqACczUO91I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=JYVpjr1Z; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="JYVpjr1Z"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 4253S4hp002228;
	Tue, 5 Mar 2024 06:24:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=O47r3PXTgFalbpepBv8mBcJznvOALYqMQPJHK1GHaiI=; b=JY
	Vpjr1ZYcGvKCjFl8vLx1A0hRZACRsv76FdALFniAA+AFO19V2K1wvsWg+7xyvJis
	y9nnIML/6F74Wn9ZBODnVWg4g5Eb6EoLVllJR4S4FFy6MrTu4scS7lyzw45Lufkn
	PDP8Pm/lTt/mApPIYberZTUhNfdU/tfD4jY2MQ4QkhjKMf5C2sNwrzvkxXfcfaaF
	PwiJD2ZVrkMlcxuQRPySWipK/aOn1mZeREA19s/0kgBEwM+5bbqjPsyFYuzGpkQf
	wsOqzRAJhs/YGa8JOMDWXSGFiWgbJaQDff3ldAm1piLAg7kEFg1X7olV8HAn8J9Z
	oNLb6KKNScCsQP1yqs8g==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3wnjtbhbaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Mar 2024 06:24:04 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 4256O3dd024951
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 5 Mar 2024 06:24:03 GMT
Received: from [10.217.216.18] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Mon, 4 Mar
 2024 22:23:59 -0800
Message-ID: <90989d74-d138-5ec4-2b34-11e8e17f29b3@quicinc.com>
Date: Tue, 5 Mar 2024 11:53:56 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling
 if scaling down"
To: Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley"
	<jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <peter.wang@mediatek.com>
CC: <quic_cang@quicinc.com>, <quic_nguyenb@quicinc.com>,
        <quic_pragalla@quicinc.com>, <quic_nitirawa@quicinc.com>,
        <quic_bhaskarv@quicinc.com>, <quic_narepall@quicinc.com>,
        <quic_sartgarg@quicinc.com>, <linux-scsi@vger.kernel.org>,
        Maramaina Naresh
	<quic_mnaresh@quicinc.com>
References: <20240228053421.19700-1-quic_rampraka@quicinc.com>
 <565c6b0b-137f-4d72-b8c6-eb3d34592808@acm.org>
Content-Language: en-US
From: Ram Prakash Gupta <quic_rampraka@quicinc.com>
In-Reply-To: <565c6b0b-137f-4d72-b8c6-eb3d34592808@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: xVOfP1cxvXz7DhjAqCZ0hIx1f9NwbsCq
X-Proofpoint-ORIG-GUID: xVOfP1cxvXz7DhjAqCZ0hIx1f9NwbsCq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-05_03,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2402120000 definitions=main-2403050048



On 2/29/2024 12:22 AM, Bart Van Assche wrote:
> On 2/27/24 21:34, Ram Prakash Gupta wrote:
>> This reverts commit 1d969731b87f122108c50a64acfdbaa63486296e.
>> Approx 28% random perf IO degradation is observed by suspending clk
>> scaling only when clks are scaled down. Concern for original fix was
>> power consumption, which is already taken care by clk gating by putting
>> the link into hibern8 state.
>>
>> Signed-off-by: Ram Prakash Gupta <quic_rampraka@quicinc.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index c416826762e9..f6be18db031c 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -1586,7 +1586,7 @@ static int ufshcd_devfreq_target(struct device 
>> *dev,
>>           ktime_to_us(ktime_sub(ktime_get(), start)), ret);
>>   out:
>> -    if (sched_clk_scaling_suspend_work && !scale_up)
>> +    if (sched_clk_scaling_suspend_work)
>>           queue_work(hba->clk_scaling.workq,
>>                  &hba->clk_scaling.suspend_work);
> 
> What is the base kernel version for your tests? Was this patch series
> included in your kernel tree: "[PATCH V6 0/2] Add CPU latency QoS 
> support for ufs driver" 
> (https://lore.kernel.org/all/20231219123706.6463-1-quic_mnaresh@quicinc.com/)?
> 
> Thanks,
> 
> Bart.

Hi Bart,

kernel version used is 6.1 and QoS support for CPU latency is present.

Thanks,
Ram
