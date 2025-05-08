Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C490E3FD1;
	Thu,  8 May 2025 01:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746667366; cv=none; b=Z1bV0IUYbSmTI45cgNe2L8qE55jAtL/rIAhfN3iXP+4HESDfdudzuN/nS83n7NlAkQc85zIliQU/XsgsKGIFJPETxSFIIT4X6vbLPDdiHxT03HpqzI13U74x6vnwsNdwl/WDnjCQx5md/+Twttq9YgiVepGMn8gAeWvPjl5gL3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746667366; c=relaxed/simple;
	bh=BFotK2hjqv5sB60AUCz0NkefXRMRrYfM43cHj5AOOgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=r9XNtM5jPAsbKB81ChtOOgH5gowufycs8VOSM7cOBXLYX/uv9YRmTvzNTRTVmbEG8WCYiJE3X/R77cIRtln1TdKucug8gsZuR/oB31aVy1R9wL57dspY+CR/Nkg72vAPaZS1M9ftnzSJK9An5gkMm5/Sb+arhJDsd0Am9VSOt0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Opth/8cR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Opth/8cR"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5481CLGl023439;
	Thu, 8 May 2025 01:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ri5ZUbH/qp/cL+n5jfKy+SjdZB0yzMK82cVlq0maQX8=; b=Opth/8cRA2rkMlIv
	IVVqZH4/y9eFlv0C07E9twdnMp+aqVFm7BU+12yxJV62oPogIvtXi2tOSCdwxdNh
	0SOc9db9k05knSXP0rDcE9aqxvmM0SJwO2E1NfFA+Lx2HDjPYk9Us+kBRSruGbyX
	GbQ63CteXl+I8UpaGOQJNmi2FqR+Dcu4/T0rum9NNN5OQs5r64eYYVuw4B6qJ6jI
	tOY7LutcZ0H5/pcvXV2gtw3bK2wDx4e/5LTSuJr/yBQnFIaoeDLXld4NF24aDZGo
	JzDz89txHGfsnxAhavcNv1xM0GwhOAzoFzUflvUFWjqBZdScYliKxm2cI57LHhxA
	nzefyg==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46g5gha6ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 May 2025 01:22:35 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 5481MZwn025278
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 8 May 2025 01:22:35 GMT
Received: from [10.232.65.248] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 7 May 2025
 18:22:33 -0700
Message-ID: <05ed82f7-7a13-4f2a-aee2-cc21e509d41f@quicinc.com>
Date: Thu, 8 May 2025 09:21:55 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: trace: change the rtn log in hex format
To: Steven Rostedt <rostedt@goodmis.org>
CC: <mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
        <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
References: <20250507070714.2387602-1-quic_yingangl@quicinc.com>
 <20250507115446.55e09c7f@gandalf.local.home>
Content-Language: en-US
From: Kassey Li quic <quic_yingangl@quicinc.com>
In-Reply-To: <20250507115446.55e09c7f@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: iRDKZoemFL5rtt9YGvNg5b2bWxlsOxYt
X-Authority-Analysis: v=2.4 cv=TqPmhCXh c=1 sm=1 tr=0 ts=681c075b cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8
 a=VwQbUJbxAAAA:8 a=nTcoZT0DL3nY3nl5-M0A:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDAxMCBTYWx0ZWRfX4Ieb+RzsWBYN
 GwhHXCnbu1FNT0ttXJgXbc0bfjcB0lsY7Q2GhQkOmELg/H7iT6rK7Ye58Z+VzY0ytoA0bFCgkAh
 0k9BQxd0Zhdmn2Q01ML5J8XG0v4mH3YqiESjf4orzEn64MiXba53yfc/PGsQCzWTGr38HBvYb5Z
 ezRo4LLvZJcJtAkdEanUgsAfkt1MoN49+KTPsKsGS551f1RVwVPLsPpcaSVWclRburrZZ9f3BH3
 FcbdjUgoWaIn4coA4OpdUocgGdG9+p6ZZkau43HsUvQFNjOw/e444ln0HmZwg/0wle5GvMTDOF9
 xV2g1tzbCl3BMa1BxbCXH5D/p2CkxzT/FAa4vjAUA20FB/ME524ks/SrV3BBpkkoOXsCPRcJzx6
 SAEYYH29nXw/dnYClv/gl1q+F/YaeVIOsT5BS9THMg/ES5FVSxqF6OovGjm6fPIm3bYCAi7O
X-Proofpoint-ORIG-GUID: iRDKZoemFL5rtt9YGvNg5b2bWxlsOxYt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-08_01,2025-05-07_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 lowpriorityscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505080010



On 2025/5/7 23:54, Steven Rostedt wrote:
> On Wed, 7 May 2025 15:07:14 +0800
> Kassey Li <quic_yingangl@quicinc.com> wrote:
> 
> 
> This patch is fine with me, but it needs to go through the scsi maintainers.
> 
> I don't see them Cc'd.
hi, Steve:
     Thanks for the comment.
     add linux-scsi@vger.kernel.org to cc with the review history info.

     if you want to me to re-send again with more cc (scsi) , please let 
me know.

BR
Kassey 	


> 
> -- Steve
> 
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
>>   		  __entry->host_no, __entry->channel, __entry->id,
>>   		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>>   		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
> 

