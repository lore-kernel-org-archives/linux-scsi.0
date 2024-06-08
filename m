Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9716E1C6A3;
	Sat,  8 Jun 2024 14:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717857734; cv=none; b=gxhUYBouE1C+e+Tzu8CU3c+R72Jl8Hh7QcFTrkxwzJqM3n4XkUZ8tzu0NJazwwaV1Ezt1BNHQOngJYdZZ40a8HL9RmrbX8lMvZf1dc6UFaAAIiB2L580HcCU7tZnJUqVcnM7YPDnY1QER5Du0ZGorSpW6x4Zl+97ngJgwp+qRLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717857734; c=relaxed/simple;
	bh=ugXXbx/CLwI99YRexmYb0Gotntqo0tZn8jJp15qegVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=O4b2/YFQA2i4DnfAmfs5AmBIDvA1sKwU62RNGZTlu6nMd0sgsNC0d3laA8B3vOLPKRldzwQSkhQfJ8e7wRWK5HVFv3TJ2BvOht1tznc3LOPhKsOUeMEV8gUnR0SriYFGm8RQL+JEinKqB+1zVKvVWzKLrw6m3CPAv/5K0OtY1Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=bgrB9vL+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="bgrB9vL+"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 458DqOVN000471;
	Sat, 8 Jun 2024 14:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	v6ltMQCxUcuE3p8fTuKauLmI6EQiUGo+ku3r9/Qjuok=; b=bgrB9vL+fuo568Cb
	0BXORn+RAdyrwKy/oABWlD54oLKkvT2pZe9RbuO+YChYOvQF1YnehgGJlsBvzcQY
	WEiabHK//uhBo5jiH9/5nhWwamDch5ri2g6Jc0MxPCTdHYcXKDL/1xoHqx2WdJRd
	C6G+PVWcAGjIPyKMchQ5uO5hFHFSsC6MLtJcMtSWeCTAUBKxkzQaAliKqdO2oSHq
	yMucZ0kSncB2lashx1n/2GwolOsSUZmaLOgK6lH4J0j9af9YD1Aw+mLYShVYsXpI
	lpLyekRuZgjQvyWXavaLvbnY59FhOE33Ln6bmmmR2E6/lHYoc1t/JOOUkHt1AsCK
	hX8f0Q==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ymemggn0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 08 Jun 2024 14:41:54 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 458EfqsM024744
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 8 Jun 2024 14:41:52 GMT
Received: from [10.48.242.196] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 8 Jun 2024
 07:41:51 -0700
Message-ID: <280d8b3c-cb05-4fd6-8710-df328e2ae65a@quicinc.com>
Date: Sat, 8 Jun 2024 07:41:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Finn Thain <fthain@linux-m68k.org>, Michael Schmitz <schmitzmic@gmail.com>
CC: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
	<martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, Hannes
 Reinecke <hare@suse.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        James Smart
	<james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Artur
 Paszkiewicz <artur.paszkiewicz@intel.com>,
        "Juergen E. Fischer"
	<fischer@norbit.de>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20240607-md-drivers-scsi-v1-1-17ae31cc4fe5@quicinc.com>
 <82cdd602-8faf-5cc0-c0b4-87ff1d820474@linux-m68k.org>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <82cdd602-8faf-5cc0-c0b4-87ff1d820474@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: gX9eRH22cdIPfMCDaLtW3GlvQ3i7oL0H
X-Proofpoint-ORIG-GUID: gX9eRH22cdIPfMCDaLtW3GlvQ3i7oL0H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-08_08,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406080110

On 6/7/2024 5:52 PM, Finn Thain wrote:
> 
> On Fri, 7 Jun 2024, Jeff Johnson wrote:
> 
>> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
>> index 742625ac7d99..4eb5770aeef5 100644
>> --- a/drivers/scsi/atari_scsi.c
>> +++ b/drivers/scsi/atari_scsi.c
>> @@ -894,4 +894,5 @@ static struct platform_driver atari_scsi_driver __refdata = {
>>  module_platform_driver_probe(atari_scsi_driver, atari_scsi_probe);
>>  
>>  MODULE_ALIAS("platform:" DRV_MODULE_NAME);
>> +MODULE_DESCRIPTION("Atari generic SCSI port driver");
>>  MODULE_LICENSE("GPL");
> 
> "Atari NCR5380 SCSI driver", please. I don't think the word "generic" 
> applies here. It was a reference to the "generic NCR5380 driver by Drew 
> Eckhardt" from which specialized drivers like this one were derived.
> 

noted, but also saw the comment from Michael, so I'll use his even more
specific suggestion in v2

>> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
>> index f6305e3e60f4..1bef131664e0 100644
>> --- a/drivers/scsi/g_NCR5380.c
>> +++ b/drivers/scsi/g_NCR5380.c
>> @@ -110,6 +110,7 @@ module_param_array(card, int, NULL, 0);
>>  MODULE_PARM_DESC(card, "card type (0=NCR5380, 1=NCR53C400, 2=NCR53C400A, 3=DTC3181E, 4=HP C2502)");
>>  
>>  MODULE_ALIAS("g_NCR5380_mmio");
>> +MODULE_DESCRIPTION("Generic NCR5380 driver");
>>  MODULE_LICENSE("GPL");
>>  
>>  static void g_NCR5380_trigger_irq(struct Scsi_Host *instance)
> 
> "Generic NCR5380/NCR53C400 SCSI driver" please.
> 
> This driver actually describes itself as "generic generic NCR5380 driver" 
> which appears to be a joke. The term "generic" was used to mean universal 
> i.e. intended to cover every ISA card implementation.

will update in v2

> 
>> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
>> index 625fd547ee60..82d8b8f8293f 100644
>> --- a/drivers/scsi/initio.c
>> +++ b/drivers/scsi/initio.c
>> @@ -2939,6 +2939,7 @@ static void initio_remove_one(struct pci_dev *pdev)
>>  	pci_disable_device(pdev);
>>  }
>>  
>> +MODULE_DESCRIPTION("Initio 9100U(W) driver");
>>  MODULE_LICENSE("GPL");
>>  
>>  static struct pci_device_id initio_pci_tbl[] = {
>> @@ -2961,4 +2962,5 @@ module_pci_driver(initio_pci_driver);
>>  
>>  MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
>>  MODULE_AUTHOR("Initio Corporation");
>> +MODULE_DESCRIPTION("TBD");
>>  MODULE_LICENSE("GPL");
> 
> There are now three MODULE_DESCRIPTION macros here.

yikes! my helper script got confused by the presence of multiple
MODULE_LICENSE() macros -- will revert in v2

> 
>> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
>> index a402c4dc4645..f74231ca29e5 100644
>> --- a/drivers/scsi/mac_scsi.c
>> +++ b/drivers/scsi/mac_scsi.c
>> @@ -550,4 +550,5 @@ static struct platform_driver mac_scsi_driver __refdata = {
>>  module_platform_driver_probe(mac_scsi_driver, mac_scsi_probe);
>>  
>>  MODULE_ALIAS("platform:" DRV_MODULE_NAME);
>> +MODULE_DESCRIPTION("Generic Macintosh NCR5380 driver");
>>  MODULE_LICENSE("GPL");
> 
> 
> "Macintosh NCR5380 SCSI driver", please.

noted

> 
>> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
>> index 7ab000942b97..c4a88f673183 100644
>> --- a/drivers/scsi/sr.c
>> +++ b/drivers/scsi/sr.c
>> @@ -68,6 +68,7 @@
>>  
>>  
>>  MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
>> +MODULE_DESCRIPTION("TBD");
>>  MODULE_LICENSE("GPL");
>>  MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR);
>>  MODULE_ALIAS_SCSI_DEVICE(TYPE_ROM);
>> @@ -1007,4 +1008,5 @@ static void __exit exit_sr(void)
>>  
>>  module_init(init_sr);
>>  module_exit(exit_sr);
>> +MODULE_DESCRIPTION("SCSI CDROM driver");
>>  MODULE_LICENSE("GPL");
> 
> Three macros here also.

Yikes again!

Will post a v2 with the corrections.
