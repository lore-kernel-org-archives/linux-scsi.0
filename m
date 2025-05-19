Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5B61F5402;
	Mon, 19 May 2025 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747647521; cv=none; b=Sc0joEVybd4TwdBpEAln1er0TvjXfyCFkmpuIL6N/u/n78SDUCAV4KtokJ1Aoxpu/RqXw8ISWmJvgdSOIxAvuD3CB0wtRV7QoV7ewUhfEcmdhR09SQ29B5z+I+vi3VH4b28jkZe9GcIGTloGhaPDqEHh7zzF2w2uj2jPFgiYxnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747647521; c=relaxed/simple;
	bh=yJX+MjjyKS0wtJYZhbEgdylLujzKxJGmeXDL4Jz43NU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Co8IsmyrvO2hSl1ONI8k7IEyF0SprSHgl7fAkjnnYnOIsqX3LimXQGa7FNYv5BEQ1+vUQCW4awwmppcSfe9bQgC1PHI03X73VK26KKbw4FKdeFkcNF6M9tdrTf0Gij8ffKc3AGESsA56YB0e3CxhojpWfhL9F6nP1pWjn5UaCis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=IRyKJ36k; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="IRyKJ36k"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54J9Uiwl002152;
	Mon, 19 May 2025 09:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dBZDl1NOtTHRySKH3/pznCDpL0PT5j0wH92G3HqHtEA=; b=IRyKJ36k0md2ile+
	cmfAXox2vsG38IZBiuP5Ul+oa2fPcvXTwHuAVK7xXXpfbai3f9dpjFAh6u3QcMyb
	2fZlgAzCV4HT5FLPHRTMN3p8SK3gHfUfjnxV1AmCKdYyDBtcPlA0eh9q90S0CWvV
	adCr1rjkQxv7sjM6z/yFIpbFZ1VSaMC7sodbWmoJiQ9Snp/sx2xrmbjvYom3pJXm
	mOb8StsoO3FEAHhLfebgpZ4rLbDUca8161DuJVq3YCJMzONem/cXFzI7Ito+HgTd
	kHcKJ0LT/b213LusSGYnbq9Cg/tqBK1esf2NWlKf3hqNsnWWNrXf8RJfUFFGi619
	3NhoAQ==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46pjm4uvja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 09:38:30 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54J9cU3N005252
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 09:38:30 GMT
Received: from [10.232.65.248] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 19 May
 2025 02:38:28 -0700
Message-ID: <6cb1b494-7054-427d-bb28-77a8a65ee0e3@quicinc.com>
Date: Mon, 19 May 2025 17:37:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: trace: change the rtn log in string
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        <rostedt@goodmis.org>, <martin.petersen@oracle.com>,
        <mathieu.desnoyers@efficios.com>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
References: <20250514074456.450006-1-quic_yingangl@quicinc.com>
 <78209d1c512a39b4ebbabda6181110b3c23e6f6b.camel@HansenPartnership.com>
Content-Language: en-US
From: Kassey Li quic <quic_yingangl@quicinc.com>
In-Reply-To: <78209d1c512a39b4ebbabda6181110b3c23e6f6b.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=dIimmPZb c=1 sm=1 tr=0 ts=682afc17 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8
 a=zCcwj0tcYWM_D0doBIIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: sIXGqXD-AG9aGZRjKzg3LmmnPxBiNnnn
X-Proofpoint-GUID: sIXGqXD-AG9aGZRjKzg3LmmnPxBiNnnn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDA5MSBTYWx0ZWRfX9IreZ89vH3T2
 My2hKAow1kTbJpTifqLiryNqk+OzAiHVcPpKU1epFyqgaZG3ZVWWoY+WplbtJPWEcAHf6stdrzW
 +cKCiNPsb/OgV5434k8v45PTjKBTFJrZbOwdt8NIoU2BL7at5O4dwh7fbfla+4sM5+TTgoG5ufx
 xCRBcaP/2OeP5+Y8aG1hKDrl9OO7c5NLSfLbrRa800hTSRc9mkwal7awuVu0wR7K9t6MszLjjPX
 BBHLA/GpfdE/p4ryzCqDGOsuuPWXGvcJ3fKgMvmLeb2xsP3fuy2CvmWJS8Gw6LAHwokpA3z4GKK
 /VdyHyk0t4NrFoGTnPptVnZF3/eAypOVjFhEpeq1fQnIwWWT2hIAOCPwnnqn6E16OYqAE7P53iN
 PBI63UKaSedfD7omXn30yYnegf7o1MxN9GBc8n7jucuqvoaRtcYrWEm5CFnn5wBSbbqI88IH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_04,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=977 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190091



On 2025/5/14 21:39, James Bottomley wrote:
> On Wed, 2025-05-14 at 15:44 +0800, Kassey Li wrote:
>> In default it showed rtn in decimal.
>>
>> kworker/3:1H-183 [003] ....  51.035474: scsi_dispatch_cmd_error:
>> host_no=0 channel=0 id=0 lun=4 data_sgl=1  prot_sgl=0
>> prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0
>> raw=28 00 00 3b 9e 8e 00 00 01 00) rtn=4181
>>
>> In source code we define these possible value as hexadecimal:
>>
>> include/scsi/scsi.h
>>
>> SCSI_MLQUEUE_HOST_BUSY   0x1055
>> SCSI_MLQUEUE_DEVICE_BUSY 0x1056
>> SCSI_MLQUEUE_EH_RETRY    0x1057
>> SCSI_MLQUEUE_TARGET_BUSY 0x1058
>>
>> This change shows the string type.
>>
>> Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
>> ---
>>   include/trace/events/scsi.h | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/trace/events/scsi.h
>> b/include/trace/events/scsi.h
>> index bf6cc98d9122..56987f98ba4a 100644
>> --- a/include/trace/events/scsi.h
>> +++ b/include/trace/events/scsi.h
>> @@ -240,14 +240,18 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
>>   
>>   	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u
>> prot_sgl=%u" \
>>   		  " prot_op=%s driver_tag=%d scheduler_tag=%d
>> cmnd=(%s %s raw=%s)" \
>> -		  " rtn=%d",
>> +		  " rtn=%s",
>>   		  __entry->host_no, __entry->channel, __entry->id,
>>   		  __entry->lun, __entry->data_sglen, __entry-
>>> prot_sglen,
>>   		  show_prot_op_name(__entry->prot_op), __entry-
>>> driver_tag,
>>   		  __entry->scheduler_tag, show_opcode_name(__entry-
>>> opcode),
>>   		  __parse_cdb(__get_dynamic_array(cmnd), __entry-
>>> cmd_len),
>>   		  __print_hex(__get_dynamic_array(cmnd), __entry-
>>> cmd_len),
>> -		  __entry->rtn)
>> +		  __print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY,
>> "HOST_BUSY" },
>> +			  { SCSI_MLQUEUE_DEVICE_BUSY, "DEVICE_BUSY"
>> },
>> +			  { SCSI_MLQUEUE_EH_RETRY, "EH_RETRY" },
>> +			  { SCSI_MLQUEUE_TARGET_BUSY, "TARGET_BUSY"
>> })
>> +		  )
> 
> We tend to do global print_symbolics as show_XXX_name definitions at
> the top of the file even if they only occur once, just in case some
> other trace point wants to use them.

Ok, will follow this suggest in V3.

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 8e2d9b1b0e77..cee057910cb3 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -199,6 +199,12 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
                   __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
  );

+#define show_rtn_type(rtn)    \
+       __print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" }, \
+         { SCSI_MLQUEUE_DEVICE_BUSY, "DEVICE_BUSY" }, \
+         { SCSI_MLQUEUE_EH_RETRY, "EH_RETRY" }, \
+         { SCSI_MLQUEUE_TARGET_BUSY, "TARGET_BUSY" })
+
  TRACE_EVENT(scsi_dispatch_cmd_error,

         TP_PROTO(struct scsi_cmnd *cmd, int rtn),
@@ -239,14 +245,15 @@ TRACE_EVENT(scsi_dispatch_cmd_error,

         TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u 
prot_sgl=%u" \
                   " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s 
%s raw=%s)" \
-                 " rtn=%d",
+                 " rtn=%s",
                   __entry->host_no, __entry->channel, __entry->id,
                   __entry->lun, __entry->data_sglen, __entry->prot_sglen,
                   show_prot_op_name(__entry->prot_op), __entry->driver_tag,
                   __entry->scheduler_tag, 
show_opcode_name(__entry->opcode),
                   __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
                   __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
-                 __entry->rtn)
+                 show_rtn_type(__entry->rtn)
+         )
  );

> 
> Regards,
> 
> James
> 

