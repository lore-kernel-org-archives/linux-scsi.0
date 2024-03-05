Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E817E599
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 07:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709624141; cv=none; b=uK6qYsev8tQhwDIOBh6lpOsECO9ulsW5aZJulH0JEybBY5rDt52kzi5uMNkDfBh7ZSTQhwnL554b/IxVGX0NJ7Dd0sLFe+nkobFfCfM3NcPmuQdrGxC102gj0xe8Nc/1kuJxV3qXI+ZezmmyPno14ygoT6RXsETxj1YisxohQCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709624141; c=relaxed/simple;
	bh=n384Dh4OHWXxoixWhIZ5G4iaBWUh+sVEq+NfSFkBUPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Tx7ZKY5bjeYre+xDNJHVgXT5sMbUhwYs/XGqO8tscI5Qc7IBwL5SFFDikH+/Uc4kZg1Mu2qQWhSgX5snAE1WTn89LXtXnKh2RVypPMEVUC/tnJeqGcGta9IlZDNfdyQgE6EOcRt3+Qwjw+Y7d3bspacNoO+cgFeNE47ynzD/Bc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=RF5O6ZXx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="RF5O6ZXx"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 4254mHuX031616;
	Tue, 5 Mar 2024 07:29:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=awxQEfbU+8utAY/GAoyQCteKVAk3h1S05V17tyYJAwA=; b=RF
	5O6ZXxI/WyJ/D2i4U7DXsEi2peSKkxsZ4uC8opF8shuWOYU4tnWsKndMkS9MnjK1
	O/DOWnfIUbvq1XK17N5YDQjJpfkAJgHJ6dG9GcdMgrRY3QQQItT9bluX27tosM3k
	xIEJNlKrtZ1Mwc96kch7CjwICnCBbvKmV5BCEK6zzxZnujQFpZIFyuvUSLJoiLSU
	6XtgODl3HjXuZ3gFN4wS+6pQmGYqfwL8kDifZqJQk6eC8v97a1rI3NYTWMoq1xRO
	DG3CZY3JvM/zeDiin6T9tIubL6E0MIb0dUYY0o+MSAmJb2Ehr0o9FL46Sr/dfH4z
	b/Ob0/ozKn2+4efc68Yg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3wnjh7hgj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Mar 2024 07:29:59 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 4257TwHv013106
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 5 Mar 2024 07:29:58 GMT
Received: from [10.217.216.18] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Mon, 4 Mar
 2024 23:29:54 -0800
Message-ID: <bd253a59-de58-2184-a818-82ef1ed8c962@quicinc.com>
Date: Tue, 5 Mar 2024 12:59:51 +0530
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
Content-Language: en-US
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "quic_sartgarg@quicinc.com" <quic_sartgarg@quicinc.com>,
        "quic_bhaskarv@quicinc.com" <quic_bhaskarv@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "quic_narepall@quicinc.com" <quic_narepall@quicinc.com>,
        "quic_pragalla@quicinc.com" <quic_pragalla@quicinc.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>
References: <20240228053421.19700-1-quic_rampraka@quicinc.com>
 <a585c5a82fdb36b543d48568d0c5ae1265642f26.camel@mediatek.com>
From: Ram Prakash Gupta <quic_rampraka@quicinc.com>
In-Reply-To: <a585c5a82fdb36b543d48568d0c5ae1265642f26.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: pcUyMUnVwhKfOxyY84FBL5tL8x6LWMow
X-Proofpoint-ORIG-GUID: pcUyMUnVwhKfOxyY84FBL5tL8x6LWMow
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-05_04,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2402120000 definitions=main-2403050058



On 2/29/2024 1:21 PM, Peter Wang (王信友) wrote:
> On Wed, 2024-02-28 at 11:04 +0530, Ram Prakash Gupta wrote:
>>   	
>> External email : Please do not click links or open attachments until
>> you have verified the sender or the content.
>>   This reverts commit 1d969731b87f122108c50a64acfdbaa63486296e.
>> Approx 28% random perf IO degradation is observed by suspending clk
>> scaling only when clks are scaled down. Concern for original fix was
>> power consumption, which is already taken care by clk gating by
>> putting
>> the link into hibern8 state.
>>
>> Signed-off-by: Ram Prakash Gupta <quic_rampraka@quicinc.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index c416826762e9..f6be18db031c 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -1586,7 +1586,7 @@ static int ufshcd_devfreq_target(struct device
>> *dev,
>>   		ktime_to_us(ktime_sub(ktime_get(), start)), ret);
>>   
>>   out:
>> -	if (sched_clk_scaling_suspend_work && !scale_up)
>> +	if (sched_clk_scaling_suspend_work)
>>   		queue_work(hba->clk_scaling.workq,
>>   			   &hba->clk_scaling.suspend_work);
>>   
>> -- 
>> 2.17.1
> 
> Hi Ram,
> 
> It is logic wrong to keep high gear when no read/write traffic.
> Even high gear turn off clock and enter hibernate, there still have
> other power consume hardhware to keep IO in high gear, ex. CPU latency,
> CPU power.
> 
By CPU latency and power, do you mean the QoS/bus vote from ufs driver?
if yes, in that case if clk gating kicks in, it means ufs is already in 
hibernate state and there is no point keeping the votes (pm qos & bus 
votes) from ufs driver. And as part of clk gating, qos and other votes 
on SoC can be removed then no power concern would be there.

Now with your implementation, since scaling is not suspended, in next 
window of devfreq polling will get lowest possible load when active 
request count is zero, because of which devfreq will scale down the 
clock. So next request would always be completed with low clock 
frequency, which is not desirable from performance point of view when 
power consumption is already taken care in clk gating.

> Besides, clock scaling is designed for power concern, not for
> performance. If you want to keep high performance, you can just turn
> off clock scaling and keep in highest gear.
> 
I think its about striking a right balance. And if there is really a big
power concern on mediatek boards, clock gating can be made bit more 
aggressive there by removing the all votes (qos, bus) from ufs driver on 
SoC as part of clock gating. Also is clock scaling disabled on mediatek 
platforms?

> Finally, mediatek dosen't suffer performance drop with this patch.
> Could you help list the test procedure and performance drop data more
> detail? I am curious that in what scenario your random drop 28%.
> And I think your dvfs parameter could be the drop reason.
> 
There is no specific environment or procedure used, I am just using 
antutu benchmark to get the numbers. And random IO numbers are degraded 
by approx 28%.

> Thanks
> Peter
> 
> 
>   
> 
> 
> 
