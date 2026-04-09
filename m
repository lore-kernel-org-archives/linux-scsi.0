Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127263382DE;
	Thu,  9 Apr 2026 15:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748090; cv=fail; b=CUPG158XP8mx5mLeTZKFe6InbR7F+pQzDo+RfMSMZ6owH1lmMIPMdjB3XjlcancKA45ebZByA7F+SFFIXQ6SRuChEGvTZ97HA/UnAOFX2hm3ZJJH31+SQZD40pUZnPQwnEIIqaX4VnDpEGpKygEZWyJNuYUHhXXuNlw5VWdvoRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748090; c=relaxed/simple;
	bh=intBT66HCFdasEr/Z6st/HiE+hTm9hBtFzRL9qOGj7U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T312dPEtwz/JvZQ6pFbjob6pDWUA4xILTaVJpUVTY23bNe8ghZ342j+cAFOb8XA2Tx/xHjcXD9lMxl/iHue1u89QM+2kKidAartrA7dxgdmKzy1udWcxCIBaliHL4OEbHzaUbPk+el+zOnsLDhYF7Chqr4c9lk5tDb/L8qsPcmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=opOZI/4r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fdSZWy1C; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="opOZI/4r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fdSZWy1C"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639DYDJU588153;
	Thu, 9 Apr 2026 15:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uG6tdBgk2uaS9CIIj8U1k6+8O8sTL6sGOYH32Rs+CRs=; b=
	opOZI/4r/IdSPQDBUAaBiaMn8necm6HCgBCy0pTJDXvG56ZTPuzfEN4e2oK/x9CY
	fwbnLlVWxlSRNa2DRda+1Cx37L2fZ2naf9ykm+MLJzV0457c2ikbcZ7Z443Ww44b
	aPWP5+aVDbOLc3copzbjN91/e78ZEOCLMu/9VMnGZRrUslnv1xTFESYSS+KWIsNi
	Sks1SX+U2UpUJyJpVPh5C95fwrql6kT3mn2mynrQoNBukbNaydlvDqyV3EiW9ZXO
	ftP848t63IPQiA4/Ingiav9PjyxGYSB+xAfH8Pp8UH0FaCX5NY9UukxS05gmH5wC
	IR3fRmg69h2xlKoe+GOdfw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqbq0gf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 15:21:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639EJT3T006997;
	Thu, 9 Apr 2026 15:21:01 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011003.outbound.protection.outlook.com [52.101.57.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmembg2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 15:21:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pVDsVapxn+h3yAqNIxJffx0h862qgoFx0Hh2fY2Fzj+KG811qJVc6jtXMqj9K9NkojVvY7ys5uU2uYnmK5w1WQlRjnmPNVnV/0c7WPiPON6qhAIXpT07Bw/3cKbjuj6JjqtKlz13gwGx0tFXhzLOWqFFO8vVp+AG4QUvDr/3HSjEJh7adYocPlRs1fvQHjLXzBuP73Qr64TPrifK+Wpm1V4BjMONwgITiS3dmTG3f7vCWJILLIpo80vDngYoWg4ENithtxYOJBLyLKLl309GcUG4eUqFCwAvJGh9M5l4rvJb3SKMITOHOScltOg6Dme5xX4cLJc/3o1sBUonuzGokA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uG6tdBgk2uaS9CIIj8U1k6+8O8sTL6sGOYH32Rs+CRs=;
 b=VQQLWo3Rwxa0YiG+mN5V0H10Zz3K27KdoU3Tbi8PC+0NzQUsYLGhILfa0y5XkI/58Iw0lqlSAlx7cMtB/WL3L9jR3xTIIDzEoUcAJNnditDkVdPvdE4Vq+wesjlnPUHoJDZpg38K7ou2bXLxHxfPjRruvkz/vlbs+yuPYy06JHzcCeP2ob/Q0MBG4c5xTpwyqqXA5dDF6MgVUh9mwHn0U9/WczGLAoTF78j5x2RLTsnChBj28UdYjSb0b2RkHg7j+vu+k245qqCI9k+Eq0fbzpMB72aB2oEkFkf4foIzYeXxv60fypGHas/juTXgXa2Ro6XYDsqh+JHQuJvWS0QjNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uG6tdBgk2uaS9CIIj8U1k6+8O8sTL6sGOYH32Rs+CRs=;
 b=fdSZWy1C49p6L6flh+jgBIuqSh4ve03bZL62FLcpA8qkAQ85MAqQ2efkdmAktNFwKdXKNQnZFsg43NreJyvbpd7XRLUblp9Hk1a/rPXxqT5Ml9iAL9pBK2u1Yp0ibzknaIELPaWBrc2UWO/l/jTfTMZCJWT3AhrnX0v9ZSNSrOI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH2PR10MB4214.namprd10.prod.outlook.com
 (2603:10b6:610:a6::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Thu, 9 Apr
 2026 15:20:57 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 15:20:57 +0000
Message-ID: <c2b838cd-ba4a-4ac9-98ca-677ca40859b1@oracle.com>
Date: Thu, 9 Apr 2026 16:20:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] libmultipath: Add support for block device IOCTL
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-12-john.g.garry@oracle.com>
 <aaH18HKCMdjuUhUh@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaH18HKCMdjuUhUh@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0467.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::22) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH2PR10MB4214:EE_
X-MS-Office365-Filtering-Correlation-Id: a3f20f58-7759-4cc3-5972-08de964b993a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gF4vH4ghccM+WzefK+t1taDD7sq/tAMByagLxpJ5M4W8dwPlHg6BBly6eyT5JRftyoxqfEgbtG755Zyitwy63TIUPxovMWNBYk19/xi7tCTfywIS/2oDemokzeT15qLYQT9mY3lH0lC68dJ/rWd6lEok6uheauGlVUwBKDG7ZoRvKIkGKFhLnmUmNkKxuRG5Hr3Odjy7T/eHq/76Ji1JaIn1xF52wukPxQvKUFOuZceUzZYx8jj0c9fekvppFXLYkwdQSIXR3+Vn58PG5CoELGSZTJEtHHSWbhbQ7csMWWJw7o8Cuug2ZEbxDYD2jPpNckTgsdNB1WWBFWjVYd5VZCAJo5C3UCO/XWzd+8zSvnvuaTmXky8gNqTc8dK+wLbhH9jMOEPw/zHHmR3jHLnuWD7ciYos+IVufctAFfqA+5LLhcJa6XmLHzfoId6G3d/fzCS9AiS41Orvgs/s18xtfxLwLcrPve9y65fqRiT5R+x3c3kGLRy/ypeDiryi4Fg8xzXKOPPAb7aHJa4UBE4vfOKMEGK6xCRuAiz/D09Mbx//qts2pP8g+IwlcfSGv6HGwfJ0TIz4TeuqafvdqlqEOgPXlhS9nSHPsa3SDytmBsG7t1Uc88bRtYQMlmwwh5oWDvIgpCK2e04sL6IelxVlX4Bej+PZ3gihaomxVYPRxG9TD9T3kusmlJfb0LvvGXk9tb4rV/0fNT5i4DQFyFDWSizRYUKpNwUKyYRnbIokc14=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHltcm5jWWZPTWlnSW9QT3dDYjZGNXFmY1lqL2thbmVSUDNZM0NJMXpYMmN3?=
 =?utf-8?B?VE5mUUFmNjBISTM2MzJORkF4THhIVWNtMk9EaTdRdGgvN2Q5NTV2cDBVaTgw?=
 =?utf-8?B?N29LcWIxMWxLSyt0dld6ZjV3dVFmNkdKalU4VURkNndhUFk0cUZMam1TUlNu?=
 =?utf-8?B?Q2JtcGZBUFBOeHM4ZVQxN0VmUzg2ZjArSFlua080dlFCY1hRNUFBd3RBMUJY?=
 =?utf-8?B?WW9VYk9LVHA3bURYQ2g1MlBxQ244aWxNVG8yaDYzVzZqd0JMZG1tenlCZ1NU?=
 =?utf-8?B?cEFHL05PVzUvaTl0ZmsvTmFBRFEyRkVmQWw5TE4zK2g4cDJZNmptV2MrZXo1?=
 =?utf-8?B?RFovbXhQck9KTGdDOHhPMVVWR01TZkl4OExTTjRiYmxMTGdSTU9QQmJHaE1J?=
 =?utf-8?B?NDlxandFOVA3Y1FRbkRKc1dNMjk2eThRbEZWOUlVVGNRa2Q3eEpPMkVvVjNu?=
 =?utf-8?B?Z3FEYUtCa2U0Nk1DbTU0MEkzdHB0M3JTUEtOVGVLTHhzUVVBOXJPck5DdEVY?=
 =?utf-8?B?U3hlbityazZ5U0xiUDQrVnhBRUQzNC9hRkhkYXhhSmtYQ0w0SkpJRnJEaEVX?=
 =?utf-8?B?WkJtOXJwbklnUlZzZ2JXU3JLeThXU3V3TTVYODFiNzliRlY5N1JVeHF6M1ZU?=
 =?utf-8?B?eVFlcEtFakpCclNpblpDWmh4V2JsZHBwVWtqL3k5UXg1TmQxb3M1bStEUnNL?=
 =?utf-8?B?VTBUYkNvTFJaOUtNZzdiakRXUUZHM244QnNyK081cms4VTRUcWNEaU5OK0Ju?=
 =?utf-8?B?T3F5UzB6UVJlVEZVeXZTOHVwSURvV1h3bkRnNGI3Y3N4UXllMkdVNTZZaUJU?=
 =?utf-8?B?SFlQdnk2M1o1UUhGMXp4WFBzaW5BNlVuNlpHNFdnb2t6bWFFcDAxeHNlTW5y?=
 =?utf-8?B?U1o2dWVFTVN1aHo2cmp4SW5uVk9lNXJUUXI5ZTRyejhxYlQwcFUwVWl6UFlE?=
 =?utf-8?B?R0FZTTE5dDgwV0p6UzkxZ05kRGdUQmhtdnJ0Ymx5enRhMHZIRm1vY2M3eW83?=
 =?utf-8?B?eFJJTW9UaSt1OFlWVWRzN0d4SW5yQXlGVmdObmlvNGIrS3dJSzhKZDlnWFQ2?=
 =?utf-8?B?dFJ0aW4xemhwRnk5Q25FYXFPZVVrMWNMZEo0Nlc5bmtYT3RISnFNSFNVc2Jw?=
 =?utf-8?B?bVFIeS80VnduNzFLem01RmlhOWtzUTRiQXZrZkl1QTNWZXVKTVBYWVR5VFJG?=
 =?utf-8?B?V05jcTZTQzVaZDRwQU42UElJeDFXV1ZHejFjd09DenExOHlBcnNHVXk1WS9B?=
 =?utf-8?B?WWNyMXBsZGNuOG93UkhnVU5XL0VMNHNrTUF6eHNDNDFaU0tiV3ZJcWU1WndD?=
 =?utf-8?B?aGhUYThFeGZRMVNqU20xWlZ4ZnFkeXlQOGdZSnkxQm1WRVFtNFEwS2xRQ3dn?=
 =?utf-8?B?WmZ0RHN2d2JWRlNOYW5WWFN2WENtWjMzNmd1THVFRDZDZzVKT3VmWDk5UHlN?=
 =?utf-8?B?YUZKdms4NGdJOCsxM05YdnF4M0NFL2RrSGFSbHoxSnNpcjUyb09JbTQzQXpY?=
 =?utf-8?B?ZTZETUFlSjNqVVYzT3IvWCszY2NBSnl6SHVRTVZtNnZDNVdCbno5Nm9Ccjkx?=
 =?utf-8?B?VG5qQnF4dE1CVHlyUjdLYVhPd3BvcmRVQkwvY292Yk93VHRDNDBMNjBpOU1Z?=
 =?utf-8?B?L21KdmwxeUxRUjNIbzFTbnBiYzNqck1OeUdlSW1NcU5LeW1DYlFKRmFZZXUy?=
 =?utf-8?B?Z25FNjNvaUttd0hTZzFBNDR1Z1VETlZkVUdYL1BHRXFGc2phd2dNY0N3SmR5?=
 =?utf-8?B?QUEwc3Y4SDB2bTBtMDdMUk45NThPZnN1bTIvRm43NDJaR3VoWVd2RVl6K29s?=
 =?utf-8?B?SXVCSXNhNW9nYmFjb0RLOHB4dmRZcXdUSXFZbVVLUitLOXl4STNkdHl4RUlC?=
 =?utf-8?B?ZTZ5eTBhQys1a0JhWnhnVytwRmJ4NnZTNXljMXl4WEQvejZFV2xnYVBMa2tl?=
 =?utf-8?B?NW1idUtzQ2c1UVVERjNwa0hpYTkxbGtsUHQvZXBTN08wVFdEZmdBcWc3MlY4?=
 =?utf-8?B?L0Z2RGdSQ2MvMkZZaDI2d0Vmdm9SSTQ5Umo3bFMzdGJpa3FmUFRpejl4ckFC?=
 =?utf-8?B?NUFzQ28wdWsrU2lMR09KNkpFUmo1aytxNEpCaFBXYjR0UWhIdElvSExpS1Rh?=
 =?utf-8?B?T2NlVGpXSkFXb1pKZ3hpQ3NzbDFCZzRGUUVPRU9qd2lJZmZ0cXVyMWNuRHlT?=
 =?utf-8?B?SGgxUGRTeEU0UndKUUtWQXNIdXZEd21zWkEvY0tkMXFZd3dpVjhkVUZTRnRX?=
 =?utf-8?B?VE55TUlPR0NJVkt5RkNMaHdKcU5nRS9wSlpVNW1CSFN4cTViZFFuN0xjOW03?=
 =?utf-8?B?bWNkaVNOd25PTGxHYXVYcGVDNDR4MXpwcUsvYkM5T1JPMU1ldjY4Zz09?=
X-Exchange-RoutingPolicyChecked:
	IY/9CI0ya8QAwGk+F66ywCa5S0gm8wo74yAJp94ZcJQls1Mbg4JE8kkfHVKq2AmX2kmaDLK/DyA9OwkzdMp/DEjbRSP8Ark+YffD5TJlp2B3k5gU4OrbxoJ/mybOX2WYpa59eeRCHB4wHnh8O2AlxU5C2T9UirBlXqvMsPFn9Q+bo5REGAvoVd4L8IPinrKWl3LISstpt70xmAz9kk2juz4s/QnSa+DBCjxvC44mVHTiBlRE+iBX0DWmN2BSpyM6TsPIkoMqX48U5cc3uUn7zgsgLsiq1hQF1oSbnkIW08ALSuCfytTUFrcWX3KsWD0vCwBnothOtpFLAyNDOzkwyQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LJ/LwHJrB4m++woGJx7x9LjUfRi/6Bqnm7QX9Cn/X0f504uLWp5T/DCPbOR0DO7TQm/j99zVPKknPlpNgSPiTCJXhAlfsI7Cuvmp57pYyXs5JOGwwSdos52v3IhbmSZmBIIHB9I+wwWwyXGctEWtomHeIxLn7M5cDxHATXzb39oim+SbvRnEfgoXBY79lmZyayCf8PLW4BzTSgcTtr69xZE17vgyps2jcTZk4fPQJQ/P1gELKr7xFDDBz6IHOrXepaKJeNBqQ1QICkMdRBR2HhpblR2zOShVdtvz6eQay7WHSqY9bnmtLdnV8WDR7CgCLlA+LRYd/u6ueoT6+SMdozB9nigETVDTf7MiO6E1NISm++Q30jfmWnv4S4R6vI5cTIPt15lRUpnDtD4t/amyHl73LNeMHF1L27cIWjgvgRV5aC+i3rcrqMvAqKv3v8Br10uBQdCkQQd60TSs7wPT6yAPmAJW2QsIe724187H1FUgMxyJ6FnEkpw/aBgwMCV1hgg+a2aLxDG9wkHZw9g/1Ld/ZfN0Aypub6/GNr/qHkxCmTtn3hbWSW9k5eexBlO1p1tk6Vm7rI0R7VeBLKMoF9iUIyf5mydkKJxTLC9/VnU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f20f58-7759-4cc3-5972-08de964b993a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:20:57.3950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vWWttCpbVr6OAzrb7UpY6pQB93UNblzhKMMAWEapJa9wOJaDcMems2r0FdAICc1hsfnW5L6IZypS4V6RRZAM6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4214
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE0MCBTYWx0ZWRfX2UQs6lFUuD17
 rkQn46HEB1l2qGdyvRNpLQ0B2B0Y2Fn8Ort1ldww2egZb4ZAJezDhV4XEk18ljb/hp/lx3lDS3q
 kZJ5UAGzlp1WCQYuECcw8JzV9YPrsOrvooZZFDTNFNyf2xxKzTTcBfHsszbg84ck+F5bd0TNHzW
 kDz31tsktwkwNA0fkPY3RNVy2ENmaz1HipwAdZkOieWpQEw9UwvJQOkZ+UQf+MqQTaJ27mUirOy
 OLtluOv8/dMgv4MIvOrV47IGd1368+gVEcDtgXR3Grgva2vyWxJCtcZqdHn4rvFLlkGtTT8tbvQ
 v37dEgGU42S3fSnVxlsPz74At9F9Q1UGB6w9c5LB6w4L+Ncd+fTQh/F2kdu8ZzqsBMH28/+17Vd
 AUGhjJ6H0Qb9vMISuHPnT93n3j9frgOcOKPLLjXxR+53OKTQNm8ikBnDAuRF1vO59NkIh5yADkd
 y4yQEIXs4D9ea8wDMKvg1Pbuu7sqrzPU9rT3F0sA=
X-Proofpoint-ORIG-GUID: 1LJVH_QLf51C4m2rLLzYcLP1mgDrPGki
X-Proofpoint-GUID: 1LJVH_QLf51C4m2rLLzYcLP1mgDrPGki
X-Authority-Analysis: v=2.4 cv=KO1qylFo c=1 sm=1 tr=0 ts=69d7c3dd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=C_tuc-koSl-OxiWdQSIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13825

On 27/02/2026 19:52, Benjamin Marzinski wrote:
>> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
>> index 3846ea8cfd319..40dda6a914c5f 100644
>> --- a/include/linux/multipath.h
>> +++ b/include/linux/multipath.h
>> @@ -72,6 +72,9 @@ struct mpath_head_template {
>>   	bool (*is_disabled)(struct mpath_device *);
>>   	bool (*is_optimized)(struct mpath_device *);
>>   	enum mpath_access_state (*get_access_state)(struct mpath_device *);
>> +	int (*bdev_ioctl)(struct block_device *bdev, struct mpath_device *,
>> +			blk_mode_t mode, unsigned int cmd, unsigned long arg,
>> +			int srcu_idx);
> I don't know that this API is going to work out. SCSI persistent
> reservations need access to all the mpath_devices, not just one, and
> they are commonly handled via SG_IO ioctls. Unless you want to disallow
> SCSI persistent reservations via SG_IO, you need to be able to detect
> them, and handle them using the persistent reservation code with the
> mpath_head.

I'm just coming back to this ... so I am thinking of not supporting PR 
for scsi initially - like you mentioned, scsi pr has lots of nuances.

I am thinking of something like this:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ded9cb8c57ea..c82adfc6871c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1295,6 +1295,12 @@ static blk_status_t scsi_setup_scsi_cmnd(struct 
scsi_device *sdev,
  {
  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);

+	if (sdev->scsi_mpath_dev) {
+		blk_status_t ret = scsi_mpath_setup_scsi_cmnd(cmd);
+		if (ret)
+			return ret;
+	}
+
  	/*
  	 * Passthrough requests may transfer data, in which case they must
  	 * a bio attached to them.  Or they might contain a SCSI command
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 1489c7e97916..1daa62361dac 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -280,6 +280,18 @@ static int scsi_multipath_sdev_init(struct 
scsi_device *sdev)
  	return 0;
  }

+
+blk_status_t scsi_mpath_setup_scsi_cmnd(struct scsi_cmnd *scmd)
+{
+	switch (scmd->cmnd[0]) {
+	/* Special handling required which is not yet supported */
+	case PERSISTENT_RESERVE_IN:
+	case PERSISTENT_RESERVE_OUT:
+		return BLK_STS_NOTSUPP;
+	}
+	return BLK_STS_OK;
+}
+

Which should catch SG_IO PR-related commands.
