Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158331F3B8A;
	Wed, 14 May 2025 07:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747208633; cv=none; b=t1/xN7Sfd1LLf9pO/d5ezx8czthXnT2C3rGzm3IGJrmplpdaJY1RU5evnYA5gKHts4c0NmdULCOnRbbWkWjW9BwVTuNdHADOzbh6Co27AD6tLTTDYuNijleEeDlfIwbRfU6dEB3r2WfCbCbDpsFA7VveVH+OgDXnCaTz1mjd/dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747208633; c=relaxed/simple;
	bh=vhPI4gfqyazCJJ8i+lo2ibtZtkh5DbYf6zlATSn0KRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JR/GeCbkET1AboSagRvUmQ/79Y8nmUUPyP1nXiuMy7uA/HLvGviGRDGVid67yuxMGmB+hpNxBWMBMp8hoETyolGHGCMKVHn3FEYN1x4xvc9E/PRR1U0ROWtnwui0QhU92UM+BspR0tb82d9SXxVwq+cIWMKpsFulneoM2mQhmpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=bwOO1+Kz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="bwOO1+Kz"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E2vTFr006503;
	Wed, 14 May 2025 07:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RXifav4u/XuBfsA8UPw2WrbG92N12Ix6d6twNjW5+D0=; b=bwOO1+Kz+zWjXTfb
	0odn1pMgqRTsimvaH+OUDLgst/pdzInbFwpLC981jzc+OFPv6GL2u93WPcKjgXOa
	6LhdtR7WyPMyzZgdXYNhQd2gd1a/QaiPZT1hK46nMxqHn4IYqQzghbGYjd7Lxdfp
	RDJ3XIwm9iqe+nVCVJY06UOEG1/Ax4RvFXwpOA8pXiPKwqaFok4qEtnU18AyFScD
	vlKwkyRe8d/yyCOWbrakFQKnA8xqzDt/3uXijJrGWanihFfNOTqC6CNKie37mtjh
	Yrl9nw2yqyYm8YJJl4RKHFgV6x9MkLxJWdUX7Cg9l5t+oMdPrcMYZj2tuoghbB1g
	iwCW8A==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46mbcpsu9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 07:43:45 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54E7hiKw000661
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 07:43:44 GMT
Received: from [10.232.65.248] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 14 May
 2025 00:43:42 -0700
Message-ID: <0417e43f-0d68-4304-9400-37fa9416655d@quicinc.com>
Date: Wed, 14 May 2025 15:43:39 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: trace: change the rtn log in hex format
To: Steven Rostedt <rostedt@goodmis.org>
CC: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <mathieu.desnoyers@efficios.com>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
References: <20250509053840.2990227-1-quic_yingangl@quicinc.com>
 <20250512121100.1b3a77b0@gandalf.local.home>
Content-Language: en-US
From: Kassey Li quic <quic_yingangl@quicinc.com>
In-Reply-To: <20250512121100.1b3a77b0@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: s53ptjTS8RXjsRDHdWoRKsYwKa-VvfhW
X-Proofpoint-ORIG-GUID: s53ptjTS8RXjsRDHdWoRKsYwKa-VvfhW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA2NiBTYWx0ZWRfXwVSevs8RQXgP
 NIvl0BRcHEz/HMO170QK7mz6w66HQHbPmVc1BvMeOLS17qDjzvUPhg9shl0q2z+/NOxk58hwWUa
 AO923OvvHmgLHQ7Cy+0X0oJXEB7Iqo2dx6DaEPTZUGx8bQYjq5B3ziYIkQ035ql+tb79+z0HrVs
 gLtpJRa6dv0iqwD6q6QkwBhu4ZYsvnTrFJHCtdWG4ZCLw0Ne3Ep1EjgAhQ489tP3jMzL4W64Eu8
 O45BqFawOlboijnk/6x7E2Bm1Vg5vp+6MjcYK2e1YmgwAOT/RS0hZ1LRc7TH3cvcuSEc6gWPFOO
 PwQCCsdIUI2KSXvfEt4n6aa3joRE/wqffb8huy4VUmkqwFxj+Q8FN4HvUhW2Uf0NrHOnyIgvAYn
 lZWaPi83bw+nv1urMZQaiQNk/uHfxCq8K91Bn2WP+vTQCwvsC9D5+R5UP0L5yzbPrKaEz2ex
X-Authority-Analysis: v=2.4 cv=KcvSsRYD c=1 sm=1 tr=0 ts=682449b1 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8
 a=h-HUdHQiAZVnT6d9FCoA:9 a=QEXdDO2ut3YA:10 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_02,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=979 spamscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140066



On 2025/5/13 0:11, Steven Rostedt wrote:
> On Fri, 9 May 2025 13:38:40 +0800
> Kassey Li <quic_yingangl@quicinc.com> wrote:
> 
>> In default it showed rtn in decimal.
>>
>> kworker/3:1H-183 [003] ....  51.035474: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=1  prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0 raw=28 00 00 3b 9e 8e 00 00 01 00) rtn=4181
>>
>> In source code we define these possible value as hexadecimal:
>>
>> include/scsi/scsi.h
>>
>> SCSI_MLQUEUE_HOST_BUSY   0x1055
>> SCSI_MLQUEUE_DEVICE_BUSY 0x1056
>> SCSI_MLQUEUE_EH_RETRY    0x1057
>> SCSI_MLQUEUE_TARGET_BUSY 0x1058
> 
> Hmm, would you want to make this show text?

   agree, will send v2 as your suggest.
> 
>>
>> This change converts the rtn in hexadecimal.
>>
>> Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
>> ---
>>   include/trace/events/scsi.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
>> index bf6cc98d9122..a4c089ac834c 100644
>> --- a/include/trace/events/scsi.h
>> +++ b/include/trace/events/scsi.h
>> @@ -240,7 +240,7 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
>>   
>>   	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
>>   		  " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)" \
>> -		  " rtn=%d",
>> +		  " rtn=0x%x",
> 
> 		  " rtn=%s",
> 
>>   		  __entry->host_no, __entry->channel, __entry->id,
>>   		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>>   		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
> 
> 		__print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" },
> 				      { SCSI_MLQUEUE_DEVICE_BUSY, "DEVICE_BUSY" },
> 				      { SCSI_MLQUEUE_EH_RETRY, "EH_RETRY" },
> 				      { SCSI_MLQUEUE_TARGET_BUSY, "TARGET_BUSY" })
> 
> ?
> 
> -- Steve

