Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D3BDDDC;
	Thu,  9 Jan 2025 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736421661; cv=fail; b=Vt+CyxlKqHUjv/4NC1WFSan+n6PPCRfqhVS9jNtgrp4C5bhg6ZjfHURXQytO2EwhYh/XfDejflTb1/9iYXKl1jeJ5O44M9R6ZSphxaktQ7MsKmcD0L9N03qzMNrieCCUnCdYGVZMHavuA11ndwRmHP9a9m+pNwssFkTjB8jU/pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736421661; c=relaxed/simple;
	bh=TOa6puVNTm0KXtHIOf0AE5mbhIS64MYJb9+9UIQW4+o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Fsc9/0FcP0BpEbhpo6yDOOIZJ72IfBYSJ+f4iwmDOnDiE67S7OSRRsTn2oMbBnV9c6VI5yrvVAymmJQiS/I/YaUbPpwT4BvszD9WGPtLfOlWSAYNCLKd/IwaBpahNT/zUMpolA0a8KpMBHlA9wo01PWJgRh27a3BucAmzmonrIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BoYsoRf7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q8GHSxr+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BoYsoRf7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q8GHSxr+"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5094fqhs005682;
	Thu, 9 Jan 2025 11:19:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=89w91TQb8L2CFSjfWhB6i9kyMd8aKl8nh/RhKdSnsT0=; b=
	BoYsoRf7AuR6LtRJS3GL12z6cOmIje2HmcYkX/8yu4QSRFDoedjcT5os3KwMo+9/
	UooEIZTt45Z797QP+zfwk769Uq5Rl06cSrXBoVBGlF6vsh7nMlanBK6CxcgzAnRc
	sXJjnyIPLH/jkUdrLXuGtiZuzADpv9iHIH3KC66uVDCkzQEojJEhnOCW0OZiK8wl
	DsOprRsSbQbbApEd85G4PgwuFMT9ziz0GKP3wEENOk1lFfBLguJTGCW08pJHk+Ea
	+32JfUgYA1suiiv+1PZbb5R3BxxIlcwcbac94KRtayAbrL/xt9ChZ44bSrrgFLmT
	R+YRXZvxlwE/rPkxnVutXA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xvkt0f9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 11:19:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 509A3RL8011202;
	Thu, 9 Jan 2025 11:19:41 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xueat18d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 11:19:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s0434jlmeEE0daZtzCSmBHNz5na6edRi9ToeiG8czh+Dcv/CljheDoRIeLDm3WaMQe/Q3kCmF2fiOmzRYJrIocgnZp0YIIZrITQGSzPMuDdE1fr1iGEHinm32pKjxNg2uJQJiKe8XdRI6FovedI8Inot6kE7Ixh2Nz6e2xQl/BrZJvTTfJGGmdc1hJ5d2GGg7mfSf5cy5A2Dl7UY2yJI1hyX3PT5kTNI9g9vDGYigUwco8hwUrtVy0lY3FY8UNjs4SBVFp8ySiDK3+TUwRGjRwmRcJh4IuSishnjxfp0d+kDsVUPxQ7xTm0ZWgN2nlcx3SVeuAFY1HHKC+miEr0V1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89w91TQb8L2CFSjfWhB6i9kyMd8aKl8nh/RhKdSnsT0=;
 b=S2nt4+bAhSCNBIKbOmUIG18Ef/FrgYr5ICh0NJ6QB4rtMGuCUwZESo9HwDEJe+JYjjDqz69OosF/AoJGtyaTJ0Q6dyian6Lm+j6pqHIAyqnmmguYLn6zy6BcwzcIs51rXmx4mZes25ba7RtWGRtz6uoRKiqfM8M6x7iIawW/aVG5ajnzPT3coS4YAQoqq6wbq9lLAOyIHuryXsv8C7xvftPFN9LTWVrKvjaMc4mG/4tCWH0CHupfrQzru7YY5C2XF+Qy0yaui8aCFN1X5eJAS0sQuq0qtLmrO5Znw6mUgIVb2Xja+PpN80s17shuGl5AX2we/yNJ5+StvayVLmPFQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89w91TQb8L2CFSjfWhB6i9kyMd8aKl8nh/RhKdSnsT0=;
 b=q8GHSxr+bjDMVpkfs2tRPPVfJHcal7x/6gzaO/zEgU63H+28+39HY+Mkoc52+gQ7qkadtKSyvtikDM5YA3whCmwJTcQDmGkAjt+Um4pwucyfXLThIef8pUILstdZuMKohLEr2Sp0wx3v/kV2hzxYENMrHCNSJwJBV7RiFh+0VnY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7116.namprd10.prod.outlook.com (2603:10b6:208:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Thu, 9 Jan
 2025 11:19:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 11:19:39 +0000
Message-ID: <33386009-9d1b-4a7f-96a5-a2f0ed2fb075@oracle.com>
Date: Thu, 9 Jan 2025 11:19:29 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] block: fix docs for freezing of queue limits updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, nbd@other.debian.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-2-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250107063120.1011593-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0069.apcprd02.prod.outlook.com
 (2603:1096:4:54::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7116:EE_
X-MS-Office365-Filtering-Correlation-Id: f34ff254-d2e3-4908-5a78-08dd309f81b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFBaT2dSRDFnayt4ZnpYb25CUERSSnFSdytDdTYxbm05RXoybFB6ZHA2NjdO?=
 =?utf-8?B?cDhMQW1wZWp4OGNGMGxUbzFtdFZNdk5HaGZXcC9Mc3ArSjhIcGdBb3BiQ0la?=
 =?utf-8?B?L1YrL0tZU09ydzRuU3drZ3RLbnJERnROUjdPS3BOd2VXUFg3S2x2WTdtL1Z1?=
 =?utf-8?B?ODNmcVhaM0RyZWdKMDRXMUhnZW5GQmp6bmlxalBHV2psaERsdkVqdkcrc0Nn?=
 =?utf-8?B?ZEdkS3o4alVGWmlWdXJLYmRZV1ZGc2taMXpyRVJDdTQwVi8xV0YyeWFEZnY0?=
 =?utf-8?B?dW10TEJhNDZHNVA3SUl4YU9wdCt3N080NE5ZbS8zSjFBZkFnYUEzZDgwQ2la?=
 =?utf-8?B?TXR4R09PQnJaTlJaN2JpTjM4WnpJRFZIcTcwN3JMbEJtTnhBdCtOL2Y3MVdE?=
 =?utf-8?B?ME03Vk1TZUt1VGkwd3FtVkdXU1FDT3dRbWQzUXkwRnZkam5hN1VHOERUM3RG?=
 =?utf-8?B?NmpabFNkZmNsemhKT0NkQlREbDI3aTJhUENCTnk1ZCtjNisvU3RuL2FWYlZG?=
 =?utf-8?B?blZVdHZsMzJpQnFDWXZWWCtxTkQ4d1dEdXhiWXIxWWFJTVY5bGxWcUI1SFlD?=
 =?utf-8?B?NDdqNjJyR2c3TDRFdzJGWXk2NWxwbk5tR1dpQ0YwSm8wWUZQTlBzSDdHV21s?=
 =?utf-8?B?WUJuL0tOWS85SEI2REc3WUp4Q3ByNFR0azJZYkRYVFBySEpxa1k5MUNjWTUy?=
 =?utf-8?B?Q0d1bDd1SEgyM3RHUnJIeHJqejhzNGUrUkFWdDNSSEJkSFdoTlJmSTgwd0or?=
 =?utf-8?B?YTJycm1TK1pOS1pvajVxYllJU1dwMXpUVVhscXBaUmpWMyszRlJHWlIyVlNy?=
 =?utf-8?B?VEV1QXRlWmx0TUhhNWcvdTlXOFRramoxNmxtckdhQm95Ymd3YU53aThYMXNa?=
 =?utf-8?B?Wjc2RFVleGdpb2JNQjEwNkhpOU1vU004OThZcjZhdys1T0JjdldZNVlselhM?=
 =?utf-8?B?aTY1RlFBWDJKWm9WVlVjZUpsRW0zMnJ4cUJydVR0ZnFXQzhmUUs2QmlLcWlo?=
 =?utf-8?B?UGNCYnF2Nk04NnRiRktRZzN3bjdET01welRMQVB3SjJTSnZZbEhWWi9qTEMx?=
 =?utf-8?B?bzBCRHFYZ2ZMblBKd2hraTNQU1dqZ2FUcjVmUmxPVFhmYnd5S2tHZWF0Y3Qy?=
 =?utf-8?B?TDRES3Qvd3lUUm43VnA2MzROb2ZiS2ZLV29MQ25qWVVneEtOcjc0aVdGSVpP?=
 =?utf-8?B?NXQ3am9NVjFHN2xDVjRYT1BvdFFuMFR2TmdQaWJtMzZYaGZ2TlVtSVFTRi9N?=
 =?utf-8?B?S3FSWnViWmN4WDliZzJQME9lTU9TNlZDM1VDVmxnR01haVdTdUQ4Tno0cVE5?=
 =?utf-8?B?cytpK1YyZGJpWVkxbUNSQXZ6cE80czA4L3BKcnYySHljekxhcXVyUUJWTy9F?=
 =?utf-8?B?UTYzdmJWY3cvQVlqMHN6RndURUVNVFpHT3prMlRBd3ByUlJ0aDhkUVRDang4?=
 =?utf-8?B?cm5hSzJMcVVlTlJwelZycDQ0LzJJMHgvZG03SStYWEN3QkNhcUNjQnVhMG5B?=
 =?utf-8?B?ak0zWS9hM3B2cDl3YzVqd3A4a3M1UnBTZGZLSGQ0Z3lTeGI0eUZUYWVIY3dU?=
 =?utf-8?B?ejEyRys5SXllUFdPYjlTdUJyaXlKQ1hPUTVPSFd4WlRiR2RpQmVpeEh3SlAz?=
 =?utf-8?B?OXNzYVRHZ1hlbnRoYW1ydVo3RzhoalB1YUd3MUhTNFpxZzhmbVBhKzZpWmEy?=
 =?utf-8?B?YjNYY2tOdXlHM2ZQNEM3dnlIVUlab3FWWmdBcFB6QjJRMlNuUGtWekdGUFZ3?=
 =?utf-8?B?NHE2b014VWF2alF0NG42cEtoU2J3ZDhnU1FEV2l6bnRONU52ZUJnd3VnWGlE?=
 =?utf-8?B?ZU5NOGRpZnhBU0t2WUhwNGF2MlVvL0FwTVNHQ0lXSFhKdlpTclRmYXkvK0x2?=
 =?utf-8?Q?WpeHiaqqV1+9W?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2YwQWw2bXdIaU9oOWd3VGljN3F3b2I2aHJKUDBWV09YODFTN3RKZU5LeVIx?=
 =?utf-8?B?OVNxMk81VUhRUWdWTWNNRWEvTUtrbU1pVnpaa1B1aGFya3hWSXhubEtveExR?=
 =?utf-8?B?c1JvQ2dnT0VDNHZtRGhlMURid0dVTzlBaWVLNUs2RHNLbmJlbkh1QmdGcTdk?=
 =?utf-8?B?VHZ1bmJxbHZWdnIvYVpkODNram5VclVpeXhqTitmb1oxS2NFSThZZlZJNGY5?=
 =?utf-8?B?b21NUnJnMlVZYXZDdUFkSXFZTzh2ZmZDek1sbzR1c1BTSHM3ZFozZk43bVNT?=
 =?utf-8?B?VFByM3B2YTl3ei9kMVlwZ0YrR0N3Vzk2aTVHL3RZZlFzdG94OHd1R2I1SDJK?=
 =?utf-8?B?TmJOL3NCMnpWQVpzUStLN1FsVnpINnM1UDV3Mm5sRWloVWxpcVF3VU9wVG54?=
 =?utf-8?B?YnUwU3BkMS9lZVhvOFRLZEp1K1IxalZvTDhIaklLUE8rWHpUMitPbFRqaFZn?=
 =?utf-8?B?VnpHSCtjeVBaV1dnVmoxWE1uUHdUVnd0OHl3eHcrTE1QSWdNNkQxdGNWUWx3?=
 =?utf-8?B?N0tKVEU4TFV1RXcrWXN5VXBhUXF5bFFNV3BDOXVuUzJhblF4T3lsaEZEODFV?=
 =?utf-8?B?bjdIeXI0QlJpK0ZDajdOTmY0aFpHUjhJOVhnSmRvV3U3VWlON0tGYVRTaG03?=
 =?utf-8?B?bEtLZ3c3b2NWQW44WVpOVDlUSjZxOTNHL2hGZ0kvVmZubFRwczF3QkhSeFl0?=
 =?utf-8?B?L1NzcjArTTFuVXRkSXJ4M3lWVDZYNkRsemp4bk51ZzZLcGp6TzVTTXJGZkxx?=
 =?utf-8?B?T2F1bzZLZUJJU1dWYk5JWVNsN09uZ0lGd2tVZVZnc1gwUE5hZys4WGtsVzB5?=
 =?utf-8?B?NmNsVllKNTB6NXZITDQ1NmkvWHROUnM2QzJ0cTR6SGd0N1ZCRFZPY3JoQTlz?=
 =?utf-8?B?WitPblF6VnVRZzI2L094Z3JZTlc0YzJNZlBHd3VHOWY4a09xV0RPV045WWti?=
 =?utf-8?B?R3NVbFIwMDdQcUhCUW5kTVNLMlErQnArK2V2eU11cE1XN2czaCsrczROZmND?=
 =?utf-8?B?ejhiTXBmK29lYnhVTG5kNTNIM3ZDYW5Pa1F6TzRaQm1FQ1l1N1hjbkIvdHVF?=
 =?utf-8?B?SVF2enk4aFA5WjlUd2F0RW5sdzJGVU1iVThRdGUrWVp3K1lmTkI3MzJ6U1RS?=
 =?utf-8?B?UzBwRVhxNitodGFmdWNsNkRkQ0M0bGxSR3pHNXhGMXlLQUF6QVNRdlRFU1cv?=
 =?utf-8?B?VGNYQzdVYUg1bmhyVUdseUpGS3dyczV5NXFDQU5iVlIvUXdzM3d0QkhycVNi?=
 =?utf-8?B?SmJkWmlOT0pPcU4xQlZwVTAvQjhWTHkzL1pwd2VjalRmb3FPa0t0RVZWUEtp?=
 =?utf-8?B?ZWFVTk0zamVzdnBNTzQrcE1SNFR4VzFzNjllUDE0VHhnUzN5NHpKS3dIUzdM?=
 =?utf-8?B?Q3F1aWF0czlEMkM0VHpjY0RkVUZOdGFsamNla090QUc5QXQvZFFvcUtwcUJV?=
 =?utf-8?B?UDdpM05zWi9wT0JDVGMycE4rQXBQRFc2MEtuem5mTVFENHJ0S2djVXFtWW9R?=
 =?utf-8?B?ajYzNTY1eHdpcWJzUE1palVneHVHOUpFK3lkM0phSmUwYmhHd1BldkhZeHZH?=
 =?utf-8?B?QWJaMjU5cFN5ZGZiekcwb2hlR2YvZWZKUlRqbTJoTUtnQlVMN1o5M0xHNmxM?=
 =?utf-8?B?QTFVZWdwNVZGSnNaNFVVOW9yVTVvZEdTdmJJcjgzRzI3ejd6dmR6M3lFZStN?=
 =?utf-8?B?Ync3SVN5Q2xXY09wcys3SkxTRXZyTUZ0QlJnNHZmeng5TnJrMm5id3RqNCtj?=
 =?utf-8?B?QkZyRU15K0hqWDgxZDJBUSszYm5qOU9QcHBYZFR3c0NlWlRPOVdqMmpteXdn?=
 =?utf-8?B?NElkUW9PSEhxbDQxYnZLU0xmMmpxbWtKNXdOZ0tYSW4yWFVLNVlQTmJuSlhs?=
 =?utf-8?B?VWxnd1R2NUZoUWovZUtyakFtaXpiNE9Vem4ybldhaVQ2Rk0wOGRkQ2tJUkk5?=
 =?utf-8?B?WDAyQlJXSFFhQTB0cEZvYW8vajFCL05FNmdtZmdmQUVHaVF4TDRJdDY4WCtz?=
 =?utf-8?B?YUdLUjRScmlMd0xqcXc5Rm5raUdkeGFNTnh2ejZrWTV1SlJxalZuNThQRTBr?=
 =?utf-8?B?OXhRL25pdzNHUm9EM1RnN2dOZDY5SWs0WlFBbzhseHVIZ3NDblVncDQ4TjM4?=
 =?utf-8?B?dmp6TGozeW0rMWltcHNCOGJYYlJ3aGN0RU1JZXpkbEZVM3BXVUliU3dKdTFh?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JcI8w/d4EONXMxCeqrfmt60K1+vIZ/y/9uLg+t8+dQZjvOBKSw3nZlH/AeJeLlNOanZpGcyx3RaOn+Z16/Rke9CzlDTdYW8fssWSJQmMJHr1o2JZV9Ot9L8cYTb3vPy2sjCAfL6MOGppHD1AU4Uy22kY+ZXvLxu6LROc+hklC5f17BtmF4W92zcK7TikUiIn4n3LF3Wrcc4LVYqhVYg0eKagYZ49rdrlmXyRVuR1GYtiV2HObDfepT8MAEo7tkYbF0YbqkVj3ymAqaIt8ZD+S4SqnmHubN64ODvl/d9rp5HqcZ6sxhtWN81Eyzc61J/E8cXzVvfuaps7b5e5RHex6T99VWdyV+iIB4t0XFC6Jx404TGdjKyddLrAXbgVI4Rcx2m69bpxlFPT+MgkiM5D87FdczSGxchYpOmIngVgYJV9oNALOwAQvR5m6ohOrH5RRZsKe0DW1ihq6ex+uS+B5nbv/vyD/751p+u71J9y7paeBmQk7Oifj9teXit0CPhIRuvVmwrap0jMgTzcabYr9nE4gglR83OxFbpkzoeYFfU3gBSuKYBQq0o9CTve+AR90xxECANDs4CEvt2WtBhdSaTe8yLWzHt2FvbX5w2hv1M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34ff254-d2e3-4908-5a78-08dd309f81b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 11:19:39.3728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MizIjK9YFoHz9lLKn1y0oeemDPQr/EIdnqWuCrah0sKGruK4/w5mUYVnFk6RHehjWCm1JhNqjfRZxftvREX5Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-09_04,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501090090
X-Proofpoint-GUID: 8HaDfHwP4499YPjPCgy3IwNFAw60PmiE
X-Proofpoint-ORIG-GUID: 8HaDfHwP4499YPjPCgy3IwNFAw60PmiE

On 07/01/2025 06:30, Christoph Hellwig wrote:
> queue_limits_commit_update is the function that needs to operate on a
> frozen queue, not queue_limits_start_update.  Update the kerneldoc
> comments to reflect that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-settings.c   | 3 ++-
>   include/linux/blkdev.h | 3 +--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 8f09e33f41f6..b6b8c580d018 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -413,7 +413,8 @@ int blk_set_default_limits(struct queue_limits *lim)
>    * @lim:	limits to apply
>    *
>    * Apply the limits in @lim that were obtained from queue_limits_start_update()
> - * and updated by the caller to @q.
> + * and updated by the caller to @q.  The caller must have frozen the queue or
> + * ensure that there are outstanding I/Os by other means.

is that a typo - /s/outstanding/ no outstanding/ ?

>    *
>    * Returns 0 if successful, else a negative error code.
>    */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 5d40af2ef971..e781d4e6f92d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -944,8 +944,7 @@ static inline unsigned int blk_boundary_sectors_left(sector_t offset,
>    * the caller can modify.  The caller must call queue_limits_commit_update()
>    * to finish the update.
>    *
> - * Context: process context.  The caller must have frozen the queue or ensured
> - * that there is outstanding I/O by other means.
> + * Context: process context.
>    */
>   static inline struct queue_limits
>   queue_limits_start_update(struct request_queue *q)

