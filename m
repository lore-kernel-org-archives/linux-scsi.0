Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D203726B945;
	Mon, 19 May 2025 09:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747647624; cv=none; b=TKq+smuqjBxqFyzPCZ7JryTk13nqB4XTo7lUHd7icYm5Opb5P11uzybhW8heMecLLDq6KWiAKMLXdyhlawmmeHUBsJ6hpEYUP/Zan9hKVuFJccfBi1xw882ovCtaKeNArw+JeF3PhP3TAeK1aztKhKzLaPnUt8F60ASI250KXL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747647624; c=relaxed/simple;
	bh=qfORC/YbcmkQwPpoHnjWemHaRGXYLYWRek8/z71NkrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=akshi7wUzu8xXzJNGt5mKwS8bwQlElZ4kHlQpR07jtS9uilO47FZCkaczujbLHhAARFaMCJgfjtLdtptRUVrSq1bJalYzKxg52/+xbYZJKqMzWJXxMqUbo58R9P8fAvtbZcJ9J04lN6mRlSgutYFRXp2Ka3yOoWIndOfseFzaeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=nkt1ecRM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="nkt1ecRM"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54J6P3EX007437;
	Mon, 19 May 2025 09:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	I28pOnIUXEYFb88OuUiJgSiksgoSnmFIRIbD2q9C3dI=; b=nkt1ecRM0/FW0fPx
	SRkaiwM1v6HpfUzWFckzPR84hyEEG3a5U3ZG43ZFVVTXy2UbXoxouNudd3RvokxW
	Mb0etADwm68gyO7uDowVxxZFXLBTb/p72oGf8NRlC5L7tntGsZOAZDBJu4U5I3Ji
	eHOZTw6r9raNZCXD+mXZStb1AfAJTH0zRXjmNpJJOzt+HdpigLUi2wxXLxPE9d6e
	AVWLayLo/xpW7O0vVJCjO6TY2earXdnXZnzyM4IwKmfcMwvrOucjAGlkqyHXalrt
	GPEvPFkGfxi31yIlGHEYQ7ZZ8t0Z2jZ4iY/ihSRYKlrJTESqokzNvuQHlKRHGf2M
	w7dSQg==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46qybkgm0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 09:40:13 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54J9eDVZ011161
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 09:40:13 GMT
Received: from [10.232.65.248] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 19 May
 2025 02:40:11 -0700
Message-ID: <0dd2e7b5-7381-4e66-a887-64b92a549d60@quicinc.com>
Date: Mon, 19 May 2025 17:40:08 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: trace: change the rtn log in string
To: Steven Rostedt <rostedt@goodmis.org>
CC: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <mathieu.desnoyers@efficios.com>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
References: <20250514074456.450006-1-quic_yingangl@quicinc.com>
 <20250514090917.0fd363d5@batman.local.home>
Content-Language: en-US
From: Kassey Li quic <quic_yingangl@quicinc.com>
In-Reply-To: <20250514090917.0fd363d5@batman.local.home>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: MN4TKbRvYV3GLPp8zP-D1G6biuL-nsR-
X-Proofpoint-ORIG-GUID: MN4TKbRvYV3GLPp8zP-D1G6biuL-nsR-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDA5MSBTYWx0ZWRfXxEW1U0EJ7jj4
 QMT86UefZ3Mofu7wkLUM865wfyCh8gscF8hSqYZ8tv7tr+CgQ8tenqTtcheDIaSsqR6G98IiVcM
 IFjlP4cKcqa8pGtZxHDON/2PcTHnYbETUkKWQKrREw9eewRYuokqF4MxE20wOqcGn8/0PBnl0Id
 IHRd+dTLjAv/MdB/H8ZQr6dTWfb+sePjwW/u1B/qCChMcglMHIPaKXc4tJJ48rg1N208raBVs7d
 Yf2HGzzrQZ5KdmewTS/QHG7gJBUI44DZOduVkfUR1F0pa6J2MdsIQMBD7tg1FhZeCdRe5U+0lvb
 RMvKTbcLxZ/KD2HMo46c/VrbIPfJj896o2eZxjG0zfjHwdBVdOW+D7y3igCuyuNXdRKZ3/8/Ox9
 uEIWdqGqQ86svp/zo7+w+JDZxpdPz5o+5Uf49S09fQFAHPTDQCk39ek89eIwSMD7jaXqOkAF
X-Authority-Analysis: v=2.4 cv=RZeQC0tv c=1 sm=1 tr=0 ts=682afc7d cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8
 a=meVymXHHAAAA:8 a=r7Qa634jyNMDAKyrciYA:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_04,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190091



On 2025/5/14 21:09, Steven Rostedt wrote:
> On Wed, 14 May 2025 15:44:56 +0800
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
>>
>> This change shows the string type.
> 
> Nit, but would an example of the new output be useful in the change log?

it is not 100% to reproduce the error path.
So I forced to show this by below change,

is this fine to test this ?

change to enforce the log:

	diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
	index 2b27a412aad9..cbc76a09dc75 100644
	--- a/drivers/scsi/scsi_lib.c
	+++ b/drivers/scsi/scsi_lib.c
	@@ -1518,6 +1518,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
	
			trace_scsi_dispatch_cmd_start(cmd);
			rtn = host->hostt->queuecommand(host, cmd);
	+       trace_scsi_dispatch_cmd_error(cmd, rtn);
			if (rtn) {
					atomic_dec(&cmd->device->iorequest_cnt);
					trace_scsi_dispatch_cmd_error(cmd, rtn);


test cmd:

	
	
	echo 1 >  /sys/kernel/tracing/events/scsi/scsi_dispatch_cmd_error/enable
	cat /sys/kernel/tracing/trace_pipe &
	
	dd if=/dev/block/sde of=/oem/1.txt bs=1M count=1
	
log:

	dd-1092    [007] .....    40.975673: scsi_dispatch_cmd_error: host_no=0 
channel=0 id=0 lun=4 data_sgl=33 prot_sgl=0 prot_op=SCSI_PROT_NORMAL 
driver_tag=57 scheduler_tag=52 cmnd=(READ_10 lba=3328 txlen=128 
protect=0 raw=28 00 00 00 0d 00 00 00 80 00) rtn=0x0

> 
>>
>> Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
> 
> Other than that,
> 
> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> 
> -- Steve

