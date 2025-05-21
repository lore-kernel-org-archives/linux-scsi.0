Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CB6175BF;
	Wed, 21 May 2025 01:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747789388; cv=none; b=aSgn2gvqAkBIN306bXKe02LZKL1w6Uha1dWRAY5QSWsSyjQzF/yIunuEOxNN98gIz04Q2L0hmx9qdE+Gl9P2qMmLH1PUAPaxu0eZv4ZfFggW2YvXnJHVscrTniUNnLZ7EcWFGCMdj1gxK6JsTBPhQqLvwYb3fLwmQk9M80gmTT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747789388; c=relaxed/simple;
	bh=bWlsUpPPBHauVKN9p+5G3ASu8F3jOPJvm9Y/2ALUCX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cquYsPJRlZ9R4CESQzTpgKWrZtidggoFmovBow4hspn+N/nd0ueUI6U5bq5Yb5QmdvkiKIfTP3ksQki6vDA8dkleSt6t4uTNND68Wj1MBnGG/8XnJu4ISsa3OIgucF9bnHMKJNEXfwIg4TvLmZKFLy3XtppKk+EVOoEOx3hpSCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=H/ENqj7O; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="H/ENqj7O"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KGhr6M009577;
	Wed, 21 May 2025 01:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xZrVMyfDpNP2xh71MISc5QeEzVjguTRM4aNoiKoGbZo=; b=H/ENqj7OeozKkpCr
	9CsZFENtGWYTabfGsdIrDCbIG6wqh6huFIP8Udizchml+Ln4HWq3QDjNZ7gG9qNE
	UimnNbLPbavjkGY9pqvkZkrlvwiTc/zCBZggCPzPgWgvkQvrl4rJB+7VuY/DKNm5
	OstcplSWRoe9Di/rKxogpM1+LGf/3ecUqjoUIOIFupTgtlrh5srR7C2qnkdFHkBx
	a5rOzmy7KT85kIKM+uvR7coQb0kswgfq2upJQ4f9AUI3Iek6DXFZNZ+hp5lAOdLm
	7oj3G1wDOvWOl0y60yBfbnQ8xn/8sPfO7soxBdOi7KMyN+jCLqGDP2XLJ3/bhY04
	BJI6ZQ==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46rwf0h1y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 01:02:59 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54L12wQk000424
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 01:02:58 GMT
Received: from [10.232.65.248] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 20 May
 2025 18:02:56 -0700
Message-ID: <e17f9f01-338c-4a25-ae8d-46957d53507d@quicinc.com>
Date: Wed, 21 May 2025 09:02:53 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: trace: show rtn in string for
 scsi_dispatch_cmd_error
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        <rostedt@goodmis.org>, <martin.petersen@oracle.com>,
        <mathieu.desnoyers@efficios.com>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
References: <20250520015915.1464093-1-quic_yingangl@quicinc.com>
 <bd3bf680a8910e261ba55a7ade12b93978cff326.camel@HansenPartnership.com>
Content-Language: en-US
From: Kassey Li quic <quic_yingangl@quicinc.com>
In-Reply-To: <bd3bf680a8910e261ba55a7ade12b93978cff326.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: _PzTgc35ZOQ_wDbQbDgTY5C3o4WSL9aQ
X-Authority-Analysis: v=2.4 cv=J/Sq7BnS c=1 sm=1 tr=0 ts=682d2643 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8
 a=t6OpEJg1tfBCJtzgfJMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: _PzTgc35ZOQ_wDbQbDgTY5C3o4WSL9aQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAwOCBTYWx0ZWRfX0hbSvVd5noME
 lkaLB9FWQAp5UkVYckO8Bm3X+gBfRBh7pGnetCXK1P9ogbQhTIKfIL56Ph8Y3OZQLdwJL7D6aDl
 qlIArwLYgw9gQy58lC2GgGiGZuMI/3Qsc8LV6ukJfWMzgw37GjCorAfNJlZzN0r3JOLyq6ZMdmJ
 eLG12Yn3GewSv9h+slYUF1mHtBU79E2tYzAewAOilNgWTbnYcaIiE+rca5sBu9XEwiWYjGiUH3/
 bp+I4oA4ic71fNHmMqT/GWukqPwSa+J8Ftg7EB9fSOasRT0nXKHJjnkreMgNx6IQYw6dh4VQ+qn
 qwmQz3+1lp4jfHXfMMCZ2Zv0aCfHXKZ9Kn/RTp9t8T08oRww7npVqcLPardiuC+6z5ACGRj8z+h
 xI0z/ERuAZSWK86r76y1vRMB7Fgx+gRp05Ur6RBlfcGfgfG2sQBadH7fSipEtEG+/ReKUlTi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_10,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 clxscore=1015 mlxlogscore=974 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505210008



On 2025/5/20 23:28, James Bottomley wrote:
> On Tue, 2025-05-20 at 09:59 +0800, Kassey Li wrote:
>> By default it showed rtn in decimal:
>>
>> kworker/3:1H-183 [003] ....  51.035474: scsi_dispatch_cmd_error:
>> host_no=0 channel=0 id=0 lun=4 data_sgl=1  prot_sgl=0
>> prot_op=SCSI_PROT
>> _NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0 raw=28 00 00 3b
>> 9e 8e 00 00 01 00) rtn=4181
>>
>> In source code we define these possible values as hexadecimal:
>>
>> include/scsi/scsi.h
>>
>> SCSI_MLQUEUE_HOST_BUSY   0x1055
>> SCSI_MLQUEUE_DEVICE_BUSY 0x1056
>> SCSI_MLQUEUE_EH_RETRY    0x1057
>> SCSI_MLQUEUE_TARGET_BUSY 0x1058
>>
>> This change shows the rtn in strings:
>>
>> dd-1059    [007] .....    31.689529: scsi_dispatch_cmd_error:
>> host_no=0 channel=0 id=0 lun=4 data_sgl=65 prot_sgl=0
>> prot_op=SCSI_PROT_NORMAL driver_tag=23 scheduler_tag=117
>> cmnd=(READ_10 lba=0 txlen=128 protect=0 raw=28 00 00 00 00 00 00 00
>> 80 00) rtn=SCSI_MLQUEUE_DEVICE_BUSY
>>
>> Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
>> ---
>>   include/trace/events/scsi.h | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/trace/events/scsi.h
>> b/include/trace/events/scsi.h
>> index 8e2d9b1b0e77..38743635f2c1 100644
>> --- a/include/trace/events/scsi.h
>> +++ b/include/trace/events/scsi.h
>> @@ -199,6 +199,14 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
>>   		  __print_hex(__get_dynamic_array(cmnd), __entry-
>>> cmd_len))
>>   );
>>   
>> +#define scsi_rtn_name(result)	{ result, #result }
>> +#define show_rtn_name(val)					\
>> +	__print_symbolic(val,					\
>> +		scsi_rtn_name(SCSI_MLQUEUE_HOST_BUSY),		\
>> +		scsi_rtn_name(SCSI_MLQUEUE_DEVICE_BUSY),	\
>> +		scsi_rtn_name(SCSI_MLQUEUE_EH_RETRY),	        \
>> +		scsi_rtn_name(SCSI_MLQUEUE_TARGET_BUSY))
>> +
> 
> This looks much more consistent with the style of the file, thanks;
> just make sure the last backslash aligns.

   manually adjust here is OK ?
   or you need me to re-send out a v5 ?
> 
> Also, could you assure us you have actually compiled and tested v4?  It
> was pretty obvious from the kbuild errors for v2 and v3 that they
> hadn't even been compiled.

   you are right, my compile system did not detect the v2, v3 compile 
error.
   I switched to my hardware platform instead of qemu,  compile the V4, 
flash to my hardware catch the log.
> 
> Regards,
> 
> James
> 

