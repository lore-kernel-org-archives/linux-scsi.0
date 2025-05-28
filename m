Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25701F37C5;
	Wed, 28 May 2025 06:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748415129; cv=none; b=A+0hivnDdiYgjlyzE5s1tR1kvPxX5S6vW0EtBD4EIScdoFj9Cox4pI20DU5++upzlSnyHyVfh1rBNNBhpeYjt3HVsce//bDe4sRSS58kTZEf/iURwvkN4XIB6hGLv0H4Gj6TPCV+O54OpnJqdS6fn3YVNyO3+xL8zHns/s/fMyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748415129; c=relaxed/simple;
	bh=SwCCFc3J07x65QPIgVoZYK30BTySVWLwnbPU1nHWDlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q2gLZRnBE93eTPPBjtFwU95RGlD2EAsCCXD6yt2LrIeu0NhXOSVdiIcBOkwZRjFHFKzPCjtkhO7xAyaC40RvJBt06PvhJzhuxYoPRbUTmUNosCulexmlbrqXl3zOGrIrRsVLaJFHf30lcJyeR4Izt7ecsdKMp9nAyNQKGFm3Mo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=GPFvRArE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="GPFvRArE"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54RJiQXG010166;
	Wed, 28 May 2025 06:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9aLcH1hBdTg01mFKLdWLhIeSUih5p2xNHC/qNtPj5Io=; b=GPFvRArE5NZj9JAk
	ZW/rpeckxU3DrliyKWRcjvyo5d0VtKYdpTRXk5303yHf6luG7aaaJOWi+tDO9kaK
	apfUJd6D0bV/2qm/H5wmB7eTBnCFCG7w0zNV0OZ17c2KwnKpSMDbtGSzEiNJgMnw
	I43tDWfa5sRBR3xFRsQmIrLK1u+KubV65q+lTzynlbxbuShAnlTrRP66E2D7jaKh
	pp8YKkmZ4pSGBIlEf4bUTvtjASXWI5UBRmOGouXAem29JmlKyg5RQIdnxB+g7+8W
	ize33LIHw3A444TBqQsOfXjqdG54TAtBskpoQwKhPYQ+KhQylbUOkfsNSqNjKg5D
	GTjqUw==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46u6vjsc9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 06:51:59 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54S6pxEk019488
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 06:51:59 GMT
Received: from [10.232.65.248] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 27 May
 2025 23:51:56 -0700
Message-ID: <9a20624e-a8e0-45b2-a48d-134808a226b9@quicinc.com>
Date: Wed, 28 May 2025 14:51:54 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: trace: show rtn in string for
 scsi_dispatch_cmd_error
To: <rostedt@goodmis.org>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <mathieu.desnoyers@efficios.com>,
        <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
References: <20250521011711.1983625-1-quic_yingangl@quicinc.com>
Content-Language: en-US
From: Kassey Li quic <quic_yingangl@quicinc.com>
In-Reply-To: <20250521011711.1983625-1-quic_yingangl@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=UOXdHDfy c=1 sm=1 tr=0 ts=6836b28f cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8
 a=PWMBinub6mAziS3_Yk8A:9 a=QEXdDO2ut3YA:10 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: _DwI2tNK0qkdlTUg3d2mQIaYMkpkka3d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA1OCBTYWx0ZWRfX7W1Zcgb2lMjt
 twBUPMLrJyAiGbxOZzemyLEVlqki/gyG1JQJ4+Ged7h4tZlxV8Ei9Ldcklj3FUiC4mFvTMmx1eE
 IFEE1qZYrjfPuiuXoo5bAypdNBzC6IACBkSDeMGblUCVCgraIzBaHTDiEGjEfWrBQFbvHd5I8DQ
 jAdD72dpZ/4SaJSbruJh54SAleCtvthzyZnij0rQxoqkaGyr42QhYXs6n+VxOij39vpe++JwWSJ
 CIBG+THTRo5p50jZquKYG7u2DgW3Qw9oREa8JB1wsWfHVIBX8MLu1KY+po0o6wKs1wy0E0CDL3I
 jc1zcL5YLMG8RMCOajQLfaqblO4BeQ3ZzZgGu/Io7X655Q2Ff5ogMWYAYL1TftoQ83dUyil87+8
 0KXBOLceNYXklePnV2pObR24caZQgcULx9ZwcjZVLg2NYzyjx3XtpEdLJHdTK1SWAOs1r9n8
X-Proofpoint-GUID: _DwI2tNK0qkdlTUg3d2mQIaYMkpkka3d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_03,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 malwarescore=0 impostorscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505280058

hi, James:
	may you review this change ?
BR
Kassey

On 2025/5/21 9:17, Kassey Li wrote:
> By default it showed rtn in decimal:
> 
> kworker/3:1H-183 [003] ....  51.035474: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=1  prot_sgl=0 prot_op=SCSI_PROT
> _NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0 raw=28 00 00 3b 9e 8e 00 00 01 00) rtn=4181
> 
> In source code we define these possible values as hexadecimal:
> 
> include/scsi/scsi.h
> 
> SCSI_MLQUEUE_HOST_BUSY   0x1055
> SCSI_MLQUEUE_DEVICE_BUSY 0x1056
> SCSI_MLQUEUE_EH_RETRY    0x1057
> SCSI_MLQUEUE_TARGET_BUSY 0x1058
> 
> This change shows the rtn in strings:
> 
> dd-1059    [007] .....    31.689529: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=65 prot_sgl=0 prot_op=SCSI_PROT_NORMAL driver_tag=23 scheduler_tag=117 cmnd=(READ_10 lba=0 txlen=128 protect=0 raw=28 00 00 00 00 00 00 00 80 00) rtn=SCSI_MLQUEUE_DEVICE_BUSY
> 
> Changes in v5:
> - last backslash aligns.
> 
> Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
> ---
>   include/trace/events/scsi.h | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index 8e2d9b1b0e77..1decb51fbf6e 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -199,6 +199,14 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
>   		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
>   );
>   
> +#define scsi_rtn_name(result)	{ result, #result }
> +#define show_rtn_name(val)					\
> +	__print_symbolic(val,					\
> +		scsi_rtn_name(SCSI_MLQUEUE_HOST_BUSY),		\
> +		scsi_rtn_name(SCSI_MLQUEUE_DEVICE_BUSY),	\
> +		scsi_rtn_name(SCSI_MLQUEUE_EH_RETRY),		\
> +		scsi_rtn_name(SCSI_MLQUEUE_TARGET_BUSY))
> +
>   TRACE_EVENT(scsi_dispatch_cmd_error,
>   
>   	TP_PROTO(struct scsi_cmnd *cmd, int rtn),
> @@ -239,14 +247,15 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
>   
>   	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
>   		  " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)" \
> -		  " rtn=%d",
> +		  " rtn=%s",
>   		  __entry->host_no, __entry->channel, __entry->id,
>   		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>   		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
>   		  __entry->scheduler_tag, show_opcode_name(__entry->opcode),
>   		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
>   		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
> -		  __entry->rtn)
> +		  show_rtn_name(__entry->rtn)
> +	  )
>   );
>   
>   DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,

