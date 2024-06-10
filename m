Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C152613213A;
	Mon, 10 Jun 2024 14:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718031463; cv=none; b=AWPInjehhbOw4HbXEvqnxRw0zPZunMeZ1X514aJi3rOT/T5dS/8a/9tclRU965YA5l6UONOgKdSlgwhlE9xOiEnMbOJ1uHePhK6ee/PumTuaExbXIAy/U/IX51mnnYmvoCfHwSIizVnpv0Eso5h1MmrJieatoLnzwxfjLS1DQ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718031463; c=relaxed/simple;
	bh=2rXaxkSAIZotar+nnN9S9D60wlWokv37PQWPyIcOILk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Oym5x8PHouvYM4H/tZKs/HCsttuioWbrp+hqcaUkIzv2ow7AGvjqS4FVldb48gjl+A+o7BsoKbVzMXU0sGrhJnCRKLLGRoxEYkDBpO6IIH4k4P4QPKIoDc0F18T2JuCLDQLXWH2MMnay0Ld35SMuUcdA6RAiYNIawO77H5H3NBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=fQKXY5Uf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="fQKXY5Uf"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45AEEjPT011686;
	Mon, 10 Jun 2024 14:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	A4LnwTREdQzipPnKr1IjzxpDtyZ+lNAXOoAtXrqzceY=; b=fQKXY5Uf9KHvhFHu
	4wup75oeDHsrQqOE6uYnnZ34qPIEZdxWousE+F4Uz3p6hvM/2Y2r0TvQz7dUp+s7
	d/GcyTRV7DHbxPdyDkjmNk/+V3D3786O+gOuNC9carLLiLrf2Q7mwAwelEAqltn2
	xc8kW2W9GDfF/kIri+1umYTwYB8YfuMbRm4K5n7jX2zl2LmAn3GP/OW7WIhzYNxC
	TjRO+A2jVj659MkfFeWAiXZjb8IWvK9N2jLyrli90o2rRPbtDr24zpgWpenKA0SY
	t4Se+bsR6yvfLoB1i0DZHlJSbEPJSINKERcksATcmqtmq9KivycFhNhgKKv5HcZe
	uN03dw==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ymcnmuvw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Jun 2024 14:57:23 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45AEvMcm029467
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Jun 2024 14:57:22 GMT
Received: from [10.48.242.196] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 10 Jun
 2024 07:57:21 -0700
Message-ID: <1988d782-e9a1-4099-9ca4-4a4d7c560554@quicinc.com>
Date: Mon, 10 Jun 2024 07:57:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Hannes Reinecke <hare@suse.com>, Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna
	<ram.vegesna@broadcom.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "Juergen E. Fischer" <fischer@norbit.de>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20240608-md-drivers-scsi-v2-1-d00d652e5d34@quicinc.com>
 <58217b4a-d731-4bc2-b625-9a5f0b9b17c0@suse.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <58217b4a-d731-4bc2-b625-9a5f0b9b17c0@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: h_25syYpGui5lXjXdsdojonkffjkwlcJ
X-Proofpoint-ORIG-GUID: h_25syYpGui5lXjXdsdojonkffjkwlcJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406100114

On 6/9/2024 11:10 PM, Hannes Reinecke wrote:
> On 6/8/24 17:33, Jeff Johnson wrote:
[...]
>> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
>> index 9503996c6325..add10098a569 100644
>> --- a/drivers/scsi/aha1542.c
>> +++ b/drivers/scsi/aha1542.c
>> @@ -1009,6 +1009,7 @@ static int aha1542_biosparam(struct scsi_device *sdev,
>>   
>>   	return 0;
>>   }
>> +MODULE_DESCRIPTION("Adaptec AHA-1542 SCSI host adapter driver");
>>   MODULE_LICENSE("GPL");
> 
> Please add a newline before the MODULE_DESCRIPTION line.
> 
>>   
>>   static int aha1542_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
[...]
>> --- a/drivers/scsi/atp870u.c
>> +++ b/drivers/scsi/atp870u.c
>> @@ -1724,6 +1724,7 @@ static void atp870u_remove (struct pci_dev *pdev)
>>   	atp870u_free_tables(pshost);
>>   	scsi_host_put(pshost);
>>   }
>> +MODULE_DESCRIPTION("ACARD SCSI host adapter driver");
>>   MODULE_LICENSE("GPL");
> 
> Again, missing newline.

I'll update these in v2

