Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4005158A31
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 09:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713950064; cv=none; b=XJ6wdNFWkIxCOuNwDhBGrTdnLVJp0OfqiIsyCHXX96B0ZlzdMJyiQN2dHIZPvQu3h70gX2PJ+9fgoZB+xfTv/eYEUWf7J7ePOYy4sAtMGT5NeWRLCPA6DJjYGxDQzYzkJsl51qaoK9qJkClcjh9pun/KafG7Ly1KHMGam4QKy8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713950064; c=relaxed/simple;
	bh=ooxJjvqsnAzrQy7qiazVWeifhCKc96JIk9+VIseSBQo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=erHh0Xdioj8DQH5PU9u8JGwBO2M4++WMUzDwco1A+J19tgP/EfBuDyGeCW4Q5uKbDVv0mNrLnq3vS9BUnw2x11cAIaz2qB5L+79Mo5bWi4efUXYt2TLw/ROIiOwkukR54rB6pfnjk8SW6XGY2ENb4eJpAoCVcDivfgO0n2B17u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=nu6TonVM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="nu6TonVM"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 43O6XAWC014995;
	Wed, 24 Apr 2024 09:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=FUqU+IvXr2Vv2oG8tDP3wcEqKESAS4OSNlAJPWGK3QY=; b=nu
	6TonVMMIo1ap3gwR2udjW7J+SuZa2VEvKwMNVBLrq6Ic4kvmz294MTuPG5ZpaKCF
	YwwvK0+OXtLGbl/I1IKwUsBR7cBCjYeC9WC/+Z9Uv54bnZhUV+HQGfdcxHiQNkgs
	H/pU/otjU65VTflRo82ruaPCP+HWl6TvrK9+vSoSC8YLgAbXeu7Ia1ZpenCbe7u7
	H1qd73Al6AIBVkAJTjYNo+BZyOP/SuUOKZwmj1VtBCSi8kiCi8Bq0AZHmicRVeDO
	BZkcSTbzh5PkHSdVTfsSL3ympDxfoavlIdmoo+S194/MBDN/kuixJigz7tZTZHy2
	ta+FHqY+Y/Vxf65erIJw==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3xpv9e0der-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 09:14:15 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 43O9EEOo004751
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 09:14:14 GMT
Received: from [10.217.216.18] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 24 Apr
 2024 02:14:10 -0700
Message-ID: <2d0c0aee-0dcb-7ac3-907c-ee477d5fc376@quicinc.com>
Date: Wed, 24 Apr 2024 14:44:07 +0530
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
 <bd253a59-de58-2184-a818-82ef1ed8c962@quicinc.com>
 <768897ca7336df5b159c7d39e467b5b74f49b3b4.camel@mediatek.com>
Content-Language: en-US
From: Ram Prakash Gupta <quic_rampraka@quicinc.com>
In-Reply-To: <768897ca7336df5b159c7d39e467b5b74f49b3b4.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: EQuYIOiR1DOqrU4buLA6QE2ZH44-GePL
X-Proofpoint-ORIG-GUID: EQuYIOiR1DOqrU4buLA6QE2ZH44-GePL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_06,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 clxscore=1011 spamscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2404010003
 definitions=main-2404240039



On 3/5/2024 6:25 PM, Peter Wang (王信友) wrote:
> On Tue, 2024-03-05 at 12:59 +0530, Ram Prakash Gupta wrote:
>>   	
>> External email : Please do not click links or open attachments until
>> you have verified the sender or the content.
>>   
>>
>> On 2/29/2024 1:21 PM, Peter Wang (王信友) wrote:
>>> On Wed, 2024-02-28 at 11:04 +0530, Ram Prakash Gupta wrote:
>>>>    
>>>> External email : Please do not click links or open attachments
>> until
>>>> you have verified the sender or the content.
>>>>    This reverts commit 1d969731b87f122108c50a64acfdbaa63486296e.
>>>> Approx 28% random perf IO degradation is observed by suspending
>> clk
>>>> scaling only when clks are scaled down. Concern for original fix
>> was
>>>> power consumption, which is already taken care by clk gating by
>>>> putting
>>>> the link into hibern8 state.
>>>>
>>>> Signed-off-by: Ram Prakash Gupta <quic_rampraka@quicinc.com>
>>>> ---
>>>>    drivers/ufs/core/ufshcd.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>>>> index c416826762e9..f6be18db031c 100644
>>>> --- a/drivers/ufs/core/ufshcd.c
>>>> +++ b/drivers/ufs/core/ufshcd.c
>>>> @@ -1586,7 +1586,7 @@ static int ufshcd_devfreq_target(struct
>> device
>>>> *dev,
>>>>    ktime_to_us(ktime_sub(ktime_get(), start)), ret);
>>>>    
>>>>    out:
>>>> -if (sched_clk_scaling_suspend_work && !scale_up)
>>>> +if (sched_clk_scaling_suspend_work)
>>>>    queue_work(hba->clk_scaling.workq,
>>>>       &hba->clk_scaling.suspend_work);
>>>>    
>>>> -- 
>>>> 2.17.1
>>>
>>> Hi Ram,
>>>
>>> It is logic wrong to keep high gear when no read/write traffic.
>>> Even high gear turn off clock and enter hibernate, there still have
>>> other power consume hardhware to keep IO in high gear, ex. CPU
>> latency,
>>> CPU power.
>>>
>> By CPU latency and power, do you mean the QoS/bus vote from ufs
>> driver?
>> if yes, in that case if clk gating kicks in, it means ufs is already
>> in
>> hibernate state and there is no point keeping the votes (pm qos &
>> bus
>> votes) from ufs driver. And as part of clk gating, qos and other
>> votes
>> on SoC can be removed then no power concern would be there.
>>
> 
> Not only pm qos vote, but also vcore raise is needed for mediatek hw
> design. And this core voltage is used for our entire SoC. Which means
> The power impact is very huge for mediatek.
> 
> 
>> Now with your implementation, since scaling is not suspended, in
>> next
>> window of devfreq polling will get lowest possible load when active
>> request count is zero, because of which devfreq will scale down the
>> clock. So next request would always be completed with low clock
>> frequency, which is not desirable from performance point of view
> 
> If a polling period without any IO traffic, it should scale down right?
> If IO is busy then scale up.
> If IO is not busy then scale down.
> It is basic logic.
> 
> 
>> when
>> power consumption is already taken care in clk gating.
>>
>>> Besides, clock scaling is designed for power concern, not for
>>> performance. If you want to keep high performance, you can just
>> turn
>>> off clock scaling and keep in highest gear.
>>>
>> I think its about striking a right balance. And if there is really a
>> big
>> power concern on mediatek boards, clock gating can be made bit more
>> aggressive there by removing the all votes (qos, bus) from ufs driver
>> on
>> SoC as part of clock gating. Also is clock scaling disabled on
>> mediatek
>> platforms?
>>
> 
> Mediatek has use clock gating.
> But, there still have a window after enter auto-hibernate and clock
> gati
> ng. This window power waste is not reasonalbe.
> 
> 
>>> Finally, mediatek dosen't suffer performance drop with this patch.
>>> Could you help list the test procedure and performance drop data
>> more
>>> detail? I am curious that in what scenario your random drop 28%.
>>> And I think your dvfs parameter could be the drop reason.
>>>
>> There is no specific environment or procedure used, I am just using
>> antutu benchmark to get the numbers. And random IO numbers are
>> degraded
>> by approx 28%.
>>
> 
> Have you try another dvfs setting?
> For example, enlarge polling period to make scale down harder?
> 
> Anyway, I think it is not correct to benefit from performance gain
> through a kernel bug (scale up when no IO on-going)
> 
> 
> Thanks.
> Peter
> 
Hi Peter,

I tried different dvfs settings, none is helping including enlarged 
polling period time, its degrading perf numbers as its taking longer 
time to scale up when the load is high and clk is low.

I checked from power side on qualcomm boards, suspending with zero 
request is not impacting power hence I am consider a vops to add which 
can help your use case too, I tested this vops and it works fine on 
qualcomm boards.

here is a small snippet of a different approach using vops, which I am 
planning to push under a separate mail subject to remove this deadlock 
between mediatek and qualcomm, scaling config.

-       if (sched_clk_scaling_suspend_work && !scale_up)
+       if (sched_clk_scaling_suspend_work && 
hba->clk_scaling.no_req_suspend)
+               queue_work(hba->clk_scaling.workq,
+                          &hba->clk_scaling.suspend_work);
+       else if (sched_clk_scaling_suspend_work && !scale_up)

Here no_req_suspend would be false by default, so would hit else if 
case, which is desirable for mediatek boards. For qualcomm, 
no_req_suspend would set it to true via vops. please let me know if this 
is ok for you.

Thanks,
Ram
