Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3314B1FFC59;
	Mon,  5 May 2025 10:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746440219; cv=fail; b=icsnbA3Wa9BoHukh0jY/ogz5olwaMlx7gs9uLaNJ916xgtlxfaQxgTtaA5GEz+eWk2smr90WUsGcTTn2wdsmJgjYtYoUgjcYnSpgu4ovi0Dg65SpCw5Qc/GUGxwN/2xiO4XBpcBtXfn2RinD2zU4QDmi/mPSIDXYNzI6Tl0NaoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746440219; c=relaxed/simple;
	bh=xoKFlIU/ApGnmtkw35REJfHd3dn0HWWxwUiPMCnfv6Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m90bXtuwD+4+pJpuUG1KdI/quhL41khZTkETcsvUpKJ4UtWn+hE4GLA1zzjbDm/kevomHafdRA3jXPUz4wufUt9MJ6JDXe9UvLAB/yuBH8Q/unA6GizQVhiwWkj3y4aswOBr3k9Vy4k/i9fIRW9oDn7WqFSlnlWQqkyHmv7GNh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z4xs3Z8y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GbwKtqC7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z4xs3Z8y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GbwKtqC7"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5459levf007526;
	Mon, 5 May 2025 10:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HI9BRUiq9Sy1HfC4WfZOkGEHoXQZKomerwtf3Hagy8k=; b=
	Z4xs3Z8yuU69TxVqwXiDWhizdChkBeLH7hwY68XpMa5MKxynOi+JeNyAtgiwBDZH
	dh4EkcNmmOMhdpyZmJ15m1LJytbksMVS5x/dX0efumNucWzHfPJTfhLoCn3zyw+O
	etU3dnaPxftI2TrTsiLgEyOjuBUt2z/FCPB4uFc9Y+bDEYzUrgPkyKMUywLq8h7V
	GpCKPyXeAYdVVNqFwrsaL1KIA2tw4JXT9qQ42BBTiyssoPMjEhplG0ebemnZRX5A
	1RzKDQGZerzyWN0VKAAQx/cYtqMpQKO6cDKfzf0KJPtFeJvyxpG9TxJyB5QMrZrw
	qQNKjUZoBI96DZY7O3l+Ew==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46eu0gr1gd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 10:16:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5458kP74025042;
	Mon, 5 May 2025 10:16:43 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011030.outbound.protection.outlook.com [40.93.14.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kdrku1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 10:16:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r/KMVwXAacKoH7yy+XFV8caIJPf6Dnu2j60OexWVfecypsAeyAamPv0MyovB2gFxxN2jvT+dHTacbyrj0T3wdachIEp1LpjQjMzUFAnn//nznCxBtVLznPngNMeOr2g5xApR9QLDd220rH+JeOQdMNosd6tXM39uc4g+Vru3tEr8QptzlTzbspKhkGCBjxxwTQ1inr4UT5xmmk9ZZxrm24GFI0qPTpKSRG8O5WZpMTGLYDT8wRjvCBOQsaOymjsS4tqrTS2d4I39ZL3vNF0KtqZ5GtGDOErpSydocddL9KcVMCi1L+dFsDP6ULbwG2JpNZAQXdIjUtK0gDWdqH4gXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HI9BRUiq9Sy1HfC4WfZOkGEHoXQZKomerwtf3Hagy8k=;
 b=vxB17JzjE2ogln/o5brNDNTuIU9xE/69doSTqEaiGVmYZ3AF0cs70F5MX2LwfQUjhs76lW93wlBcbC86Z4oSiOMSR5ljzw9Ac4ZHTZNSFVxHGTIkaRHAns/2KGqaILvpTH5P0r0AmHjT36sZNY48x/nrCUJLvy72VDDCcEyOlJ9Z3vNj8hjD7Cq6LlBXgRCGL0gG26PCAWQ4qmEp/gvMbc8U8RrRu6van8v+q5WlmB1Fz4HzkdpmflCfMp2x3PepztI4D5Te2U07nld9U6rXzQxIhs4qrjHRRBNBGWBm+41oMvgfiyaVB1r4Me4nNtyEckhK9W30xMRx81+/1pu86Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HI9BRUiq9Sy1HfC4WfZOkGEHoXQZKomerwtf3Hagy8k=;
 b=GbwKtqC7TGcg8X7G9g0wZGMD/Zm9Ct9I+A/sJLEC4s4pf4m6239uHeOSPWnhgbL+wz2g1zRVW1x7UdJQ07Ev0j9blh38pZc7O1CnOjtoi6OgtYmgH1FKKaFYc4Grwpqvzmap/9nShp5D9kFJn/fL/el/84JJdYTjf0qU85P0No8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4782.namprd10.prod.outlook.com (2603:10b6:a03:2dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Mon, 5 May
 2025 10:16:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Mon, 5 May 2025
 10:16:41 +0000
Message-ID: <0cfc6d20-d5c7-4dab-9108-1c985e77c3fb@oracle.com>
Date: Mon, 5 May 2025 11:16:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] scsi: make imm depend on !HIGHMEM
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org,
        Hannes Reinecke <hare@suse.de>
References: <20250505081138.3435992-1-hch@lst.de>
 <20250505081138.3435992-3-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250505081138.3435992-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0156.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4782:EE_
X-MS-Office365-Filtering-Correlation-Id: cd5092c7-4776-4cd1-d0ef-08dd8bbded90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjhPVTZsUFVrb0ZkVGlWUEFEc3hjdTNabUxqZ3c1SkNEU1dEWHNUSWFYY1ZU?=
 =?utf-8?B?MEh1Q2RXZC9ZZDJiTWozWityTG1zeUI1OS9oSzFHV3J3VFpUVndzK2IySXVI?=
 =?utf-8?B?WEJBanZsM2t2cjZNc21lMG8yeHoyOTdVdWdLblBZM0F4VEF2SFRaODYrcmda?=
 =?utf-8?B?Wm9SWWE5OE9ucitUVG9rUG5tSE91cjg5cHh0ZFU4K3NMd09ENHZyVytWNGlC?=
 =?utf-8?B?eHprQ3UvTUVmT2tzUTkyN29PbHF3dDVXTGludExVaFpyQmQrQk9nSmZaQzZo?=
 =?utf-8?B?cWlONG5CUUNEWUk5bzUwc3drV1pCcXFMUGR6SmpLT0ExN2liQm9KVUxCdzNI?=
 =?utf-8?B?NUFaRW4xY2Nyd25iaUZyYk9jQzJzazZsSjJaNGNleitHWUxkQVRvcVZxYVFh?=
 =?utf-8?B?WERYSmhqYzQ1aVFkWU4zRVV6YmlCcitVTkdXQVJWOWVxSXZRYjF6b2piMWhR?=
 =?utf-8?B?OWFzTEl2ZDlHNHZJREF3Q2IxaSs4eVZ6cUpuRlRQQXcyeTVYQ3pKL3h2N05J?=
 =?utf-8?B?RHoybzVjYWlURktEeW5YSnZIVUV6cGF3dWZJT1JMQ0t4a21CN1IzTEpNUGJW?=
 =?utf-8?B?bEJBUDhudkFGc2ViVU50OUg1VmVvUitiVGxQSTUxK2E0U1ZiVGh4TGdLQWVY?=
 =?utf-8?B?T01wTzlHSXhZT1Vxenk1T2hHcFBsZjNxcXBGUDR0V1BFNXlGRW5kdlo5Y01p?=
 =?utf-8?B?YURIL1NiV1I1ZUw0M3JILytLVUF4SXVmV2dpQ2VVNFQ5SEl0eXBsZ0xlbEFt?=
 =?utf-8?B?eTVoc2dvOHgzMkV1MjR2ODBmODlrcExXVFBQYVdoMHRNN3M1dGV3RG9xeU1t?=
 =?utf-8?B?cU9nOGUybXFpZ1NsZ0NXM054bTdKUEswbUFDM2k0VEdKQU5RcXh5MnRmYWRt?=
 =?utf-8?B?OHJnSnQ0SldBU0NnQWJseWxzbUQ1SWw0VDZCd2owZlR5RkdueTQzUkNFeGRt?=
 =?utf-8?B?NHJrQUR5bzNUL09Xa1V4V1FJOWVtMkorVUlYcWh3aTVGOU0yakRRS0wvU0FY?=
 =?utf-8?B?VkhTUGhyK1Z6eDFIWFNDbzZrZnJOUFNKM1VaOHhKbEN2Z3VqVjh4UmZJMzc5?=
 =?utf-8?B?Syt2RWV2R3hiQUF5QVRERnhQSFhvcXBzYkhLV0pnVmIyV01tbVZUaFhyTVB1?=
 =?utf-8?B?S0M4YVBYTkpEKzFHZFU1UU0xS3N6eGRuS2F3VlhqKyt3L0RnREovWllnZEs0?=
 =?utf-8?B?MWVYUlFqSDZ1YlBlM0M3dlhoZzNOMEVYcmt0emFpSTROaGhncG1OY3lBR1lw?=
 =?utf-8?B?dXZSWDBNZ0dFaU42QVlldDNEcFdLbjZiOGltQUJualg5YVRzZExWUFpsVEFN?=
 =?utf-8?B?ZU5wa2tJYng1Y1dlU3ZuVWUrWmdSNFgxK081L3NiUnZoUUJxZndvY1ZKcC92?=
 =?utf-8?B?OWU4Z0ZCcGZZNk9JOGpHWVROa1RQdnJ6SzJ0RFFZTFBTOXRsV09YbG91aWxu?=
 =?utf-8?B?UFBrVEo2YmZLMFZvclB3ZEMvZHV1UTl2enRuZEJHNmNVOVpJRjV5bUpuWEFZ?=
 =?utf-8?B?dlhoRE5zdG9FV1doVU5JUkR5bGFrbFBZd282QVRUY09nN3lxbUxPSHFMdHhm?=
 =?utf-8?B?eHNqR1pIbWVWMlhOaDc4L3FzMSs3MGovc3M2UDREWHVwcjhxTVVzZ0tqa3BU?=
 =?utf-8?B?MHYyNlVaN0xueHZmcGNsdEx1SXBEdGVhenA4d3hRQ2o0U0had05tR3c1Y2dE?=
 =?utf-8?B?TWFmYmo0Q0lYcXd5bTJoS09hVTVXckRkdTNjRzBtRU1EMktvUTRxV1Qrak85?=
 =?utf-8?B?Tkx3elJaK2s3ZjFzT21nYThhV2xxdVlYT1Q4U2t6eVFDQnJieFlabDkzblVR?=
 =?utf-8?B?bkMveU5Bb25BaWRUSTVseU5vdk1RTlQ5RXZrN0ZuNGZPOCs3QUptNUN2WThV?=
 =?utf-8?B?bVZCTk02MWhzWTZGdEVoWGZmNCs5MEVidGtKSXZsQjFVTGhhdXhFN01Cc0lO?=
 =?utf-8?Q?epEBALj6ebE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnltS3o1VlN1WXlBVTU2R3AxaUdZNGlLOGlSdVV0ZTFLYjNpVEluZDZ1UDFB?=
 =?utf-8?B?SUxGeHRHVDVWalBIUWl3NWxGNkF1VzltODBzajVjTjJwc2tQVWN1eTBMcWFk?=
 =?utf-8?B?MXY5bXVwa1V2aXNzbzUzcjQrM1JSQjJ0dkIwUjhwVUpwRW95OGVsV0h4ZWR4?=
 =?utf-8?B?Y2FzWHRoU2tDNWxidkhwb2JyMTRkLzJVN1NRM2o1R3QzOFZkRk5WQVQwTjAv?=
 =?utf-8?B?VUhyZUtQbFJnQStpZlJvNEwxdUJkeG5WNVd1dXVwdFkxTGVBSFRHems5T2FB?=
 =?utf-8?B?RG9PdEVRNGx6R3FxeW9CS2MxU0FRanpvcXozSXUzMXlCUkJCMmtjbGFxR0hQ?=
 =?utf-8?B?dFR4WWZIVUQ1NTNpU1R4Yms3RGFGMTYxRk9UTE9mZE83NnhIV2hXb1FUZFhK?=
 =?utf-8?B?eTRPaUlPSncvb24vRGpMTTF6dTQrYVRTWGlWUUt2dDBLbmJPUDBPWHJvLyt4?=
 =?utf-8?B?UjhYM3hXOFdvUis3c0xCY2FDYXdTUzBaWG1zWWhvbU54RXNmUnNCTjlMMTVK?=
 =?utf-8?B?ZzZVd01nOTFXNTRiditOaW5TZ3BsdnNDOHY2SGVBZUREUEdML0hCWWF6L1dy?=
 =?utf-8?B?SHN0QVdsSFBmZmtkaW00WktWV1lpa3NqL0RIS2MxaEFtYUhoTnFFUTdPa0R0?=
 =?utf-8?B?azF0QjljYTd1WlR2WVRoZkg4TjZqT1VuZ0pXMVNkK3hvT1pKM2lOZXA3UlI3?=
 =?utf-8?B?OXJBckcxRjhWamJJSENlL2c5R2tmQ3BLK2llN2w0TytxdGVTeHgwTmdPU0ox?=
 =?utf-8?B?SXNXNjFKMUtHWEtLUHg4VFlJT0dpM0pCZkx3S09mb2paYit1a3RqOVFhTXd3?=
 =?utf-8?B?ZllDRjlmK2xPZGZSZzlkUzlQMUNhOCtjZ0VDSWlvRlcrZEozNkhpaWVvUTRN?=
 =?utf-8?B?QjV5UXRRc2lPRmhURlJqdndnMVNIZURtamZIUE1veUprUVZLYnVHbzNtME9t?=
 =?utf-8?B?Smd3WXFISnNuNlpxUEFybTlSWXZvaUVtOHczU1dWYnZKTWNlazJGT1Jnb2Fr?=
 =?utf-8?B?MUtVY3YyWHRJVEFwcEErSnVRNDh1cCtucS9zbjRJMjVkOHlzaXBOQXpUL29n?=
 =?utf-8?B?Q1NNWGZxMEJiY3QxeURrOFNSOTBOaEQ2MWF5VkJ5NDJxQVBtY1NSaFBtS1Bw?=
 =?utf-8?B?MDF1U0dzRWdSUnovbkI5aFp0OHZ3RUJwU1p5OWZRWHBRbWRrQ2pDNXgwWlAv?=
 =?utf-8?B?V0g3RjY2dmJ0VU1OdDkrMXl3Y29QZzByT2EweXByc0tackF2YVhLYTk1YTh5?=
 =?utf-8?B?NUdvbkJlMjdXQnJIR09HbEpKZFZmMkUvWmRKV1pzRGZyZEt3Q2lWcTRQc2xx?=
 =?utf-8?B?NWtCYTUraGN2SGNlT0JQeUc2TnpEZU8ycm80UElhRTNHSzdma29tUXdpWUFP?=
 =?utf-8?B?bFN1TlNkdnFDdWRla2ZIOUNFcmsvS0kvUE1NYzVRZDlZallEdUJ0YjZ0ZWM0?=
 =?utf-8?B?cm53TWNORmQxRWZDdkRVMlhhZWMzbzVwd1hYbXIvRnlNNGZUUTkzZ3ZHcEh6?=
 =?utf-8?B?ZWZRL2JBU29xZEZyQkJBaEVDU1FVZ0JvZlRtcEM3bUJUaWpZYyt2c0ZzeXh4?=
 =?utf-8?B?bHJ0RUxKa2dWZDBzVGhJeU1vTEdQdUhYdGVvMDJzVWlvQk5kRDdrU3MzaTJE?=
 =?utf-8?B?TmxpQVBtVTVyc0tteCtzODBHRkdnMURmTlBoK1hJU0xvbnlNenZXcU02ZGp5?=
 =?utf-8?B?aHdTTDhnZXJVaWMyTmJ3UlQyK0htdEd5VjRJUEVYQkM1WHkxdG1XcEtVcHph?=
 =?utf-8?B?bHk3RFRhY1RSaWtrc05uUm5laHZJNjJsWGU3SVZWbXFYTkE4ZDJwNGtQOW96?=
 =?utf-8?B?cGhFRm5MSi90ajhHenZ5ckZLdUJadHVxVERUU1FaVDRYd0pzWWtzdXowdGNz?=
 =?utf-8?B?c0RUZGpXK3FCa0I4OWhOZGRoSmN6QkVVa3dpbHpKUG5FZUNXc215amc2eTNs?=
 =?utf-8?B?WFVHeVFXRm5DQjFEY0I3N2lRM0Vzai80bkxDaStWa1lHak5sL2NGUDFlakhQ?=
 =?utf-8?B?aHp5QVJ2dWNadXBNUTZpVm9jSTZtcDNvTE01UkZ6UGJJUmdDVUZScmhYNGlo?=
 =?utf-8?B?UTN0RWo5U3hIeTZkTDdHMWlnZWlJVFF6dXJWSUhITFpVaHgvWTBIeUxTamNF?=
 =?utf-8?B?NnAzcXN2azJLZ0xYMzJ2UU1NZURoanYxSkJGTTlMZld2blYrMW0vc3poNVlx?=
 =?utf-8?B?SVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f4e3Z+QtM/DN4q07Q9Q8w5veFpLCOWujx655BmJiA1coAjNCmjURsfE/ZUi9RYUU+QVX7zawavLPMTZiZ4La3Ir14Kw3u8d8Abg04MoHe40L1C3/C+mZEkYBiJy0MXoiXUE8en/vAsTpHWQV1Ilvx2bRldc8C36RVxEjQ7Ma5iprSCgROMV9Uu3/k+bBmXtHbV7tXtVruXzhCgOZtXSN8AjBdmvkJrP86iqlrYgCWjulYN8IFAfiCD/5hf+R56Vmc3LohYH+b96jAFfm8zOqQFrb1R8cgKSWyo2oADV/gksfQ9m44k3tq2FkdC4C5PnPoBm+aCgD/NoOC2sweeNj1k3whK7SrcUD5IKK96U5V9ELR2PZQSHnxfnUU5mwX0+1VMkUf4m9P9nF8SKz3OHxPY7KYoeemh6flbpC4C6CDYPm42rxWX7zWdZ5jjwFXTn3ByR4Mmb6B2p8q+NVbhSeTTNAumJqk3WDpFwE7LONn12urF/hSIhehdKcghZ2Y0tf5dUmS/BCebsWKgvR1OrzcUKyfb7X1UxJLOaVgRYTuQLSDXruAacLiBLX3S/SJNXBbJavtZ3xxKDl7L1RrIfH/9r1BA2un2yGyv4Y5GvaNxA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5092c7-4776-4cd1-d0ef-08dd8bbded90
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 10:16:40.9980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PX+aO4nKmUx1TJP4mFlTlOZS8ZiWtx+MUL3/sVhhir2B03WihSM8QkbopFXWH0bdTabA7NY0VDJXY+yG9aDzgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_04,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505050097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDA5NyBTYWx0ZWRfX9SVLEYP6yfec QiQk/dWNY9RaxcZc5SsREZISvUCBMEsWlGiFB5hYyBzLk3shMjSemxZjO9mAh0Zsl1ZDNPTcp4M HhKQ+LJnh5cKsaWBeEaltTshOOiqpCKwDvQkIifMihl9ePhknh6GHgE3Br1YzOwGONX/LHlNYOl
 jq+/kmxIoWo4fXnVt6X9ctgnRkJ4rl7jMYmGEX4WPzxad97MG2MEjh+JDwsh9tjQNHfCrvKnyHX m1nZTcTj8TqO2X1RM/oQ5/patSgU1J8LNjwvZjhgN/a4zeEJMM6iCkc9wtCMvDxzysArMFLufQH 1oyPIfeb46EaKzLvVxnUuxH0kiMQ6Bm0zC2n5PvY+IrLagTaQSKtiq93JBASuflNDfoBvEO+z+K
 h1nrUC4YT3HdD47HE0sV7r2ouWmjtp/R1i/LjzF3xYpHfWcXMScxs51x4WuWDsz4poScrEDW
X-Proofpoint-GUID: MG7LvGxzsa89SXdg4HUgfoKLC66p4Es8
X-Proofpoint-ORIG-GUID: MG7LvGxzsa89SXdg4HUgfoKLC66p4Es8
X-Authority-Analysis: v=2.4 cv=M7RNKzws c=1 sm=1 tr=0 ts=6818900c b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=_MckG_xjt8bSkswAZlMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13129

On 05/05/2025 09:11, Christoph Hellwig wrote:
> This is one of the last drivers depending on the block layer bounce
> buffering code.  Restrict it to run on non-highmem configs so that the
> bounce buffering code can be removed.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
