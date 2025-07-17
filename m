Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298811E0E14;
	Thu, 17 Jul 2025 20:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752782515; cv=fail; b=fBfYIJ/uKSNjOE/Doiz6v1pC5U7wW6py0QruP44OVzacRC01vNC1KVBA/CgIlhWaAqw1N2QPaY7CM4THFRiHZit+FjLGDGtzywY12gIkPh8/2Ayeoab3kzJJ+OwyZdih5lvpn5Qxbs2aQ44rXLtqZ5TzSrMdxowDOBDl9EEL9dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752782515; c=relaxed/simple;
	bh=AyNxtr0jHNnerTVsEGgJ1J32TjJUigdBbuPOHdhP6jQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TRXSEAfyrccdoc7l19AQFswQUCiJZXHgYWeUidhE2jDd9bfy1BnZ+2GBmYNYxNayDEh6d6aJtsJwQRrLieoyG1cJmuLoRMmqbJG41U2OayxScSBpNnK4kODAoBvTMZ71aOsUimXhyPBTOR4oajGik5HZi2eUOOSJ+IWm1OneUjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PWZo2yuG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lXkooEMt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PWZo2yuG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lXkooEMt"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56HJXtoJ014287;
	Thu, 17 Jul 2025 20:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HmzBkbv7gLzYQhhtoSFQxCaED2W38Jyk3LhtBpB+nlY=; b=
	PWZo2yuGmMAJ6LJzGJSZyhxe4lo4pm+WM/9ejv+GVKBRZNuH0QLQJK03EFyytrOe
	ZrLL3fm+3nu0FF2jNHBlr/ItMGAcjZG/vJJ32ZnDqPskmunqWB75dv/o1SeI+R5Y
	2UANnMLfhckR3FnIcrQRkt2ugsyXmnTD8ahro3Fpgy6V039LuBhkIPxCV8KThD8L
	iGqGqpRyqXyvcP3FKbLTRnKtrm1bFIu7iK9nvh5nkd5ip2ke5s8n6TT43lRDmye+
	Vb1crdzJ7RLsHdbZcooEy/45zIbsWNY3He3dshIhCgGEZenCr26frGPcPrf3YfWt
	gqoXMYDXuQgc9+9nHsNcrA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk8g3y2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jul 2025 20:01:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56HJtrlx011826;
	Thu, 17 Jul 2025 20:01:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5d7ysd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jul 2025 20:01:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RCMGVRUpq9kTSFY36qiYlVnqxE26G4i17iBj9Md/d8oJ4cYw4sS5u5kUsLoRTUNnwyt7jntUncLdTurJAuHriEqmA4ITnCT8Sb6TXs9F5PhuMkmBH6jTumdCnoawYiD7nhQR0THpky3FlsPk1hypIEqbStXbdE0bjNP8mT1TJSPy5sjQ5OdtOMPxhBcodseg9XOInFTmwaFXvmKu8HGm71T59vQDXc9HKL8+i9z4snHIb4OZGbjMG258e5Z5Nce+PIzBT190t2qauVGV/VP+6K1/TaFJPATYX87psDRsMG0F+mcDTIfuEBjedi1/jsPTQBij19alD6iWyteezP1t8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmzBkbv7gLzYQhhtoSFQxCaED2W38Jyk3LhtBpB+nlY=;
 b=N+wycPSdl6Yfb2cTKiJVoZXcilDQ39ovKUebzU06J5WZB7hNtb9pDLcYTOmRsD3sUolnqaLd4X4HvsUPZ09HU79lWrIhk0cuNlfjR8bzKTycjZmmaCjRNF7qQA5aVE/59fu5yYt77sbyqjzEUiyhEzafmWe76aNUZa/OIZ2ZufWlG7z6A1lBf7w/b0xs0SsIi+EiR3nwF8JE8QrO0Rkhlvuu1aaYlYz3SPj5Mxayrf/LDGVe9gIMQYs8nAm+9p+EXTMnYdQ2ShPafbzUWT8KuuIZM5wxPnTwU8Yr4RYef7g0VYurhTKCUtCpBP/3D8zHL5HamZn6bYx5vTCAe9/pJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmzBkbv7gLzYQhhtoSFQxCaED2W38Jyk3LhtBpB+nlY=;
 b=lXkooEMtNHRpSOyQzmOvAC84x0tzjq4H3gplLlJrDWOQFduDwfOcTlTTBkFYkwJsMs1DZbbgqwyTCByK4FlGb+nR5lZrR/vu0Ztgo2R8y4KOt+rtatWkYUQq57WTvZxLpR71WYgfYdSLTyYCnVgf/YGCpLaES2Z/rkVoqH1CFjY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB7683.namprd10.prod.outlook.com (2603:10b6:806:386::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Thu, 17 Jul
 2025 20:01:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 20:01:14 +0000
Message-ID: <653eaa6f-4e85-43af-a13b-906e34a2e517@oracle.com>
Date: Thu, 17 Jul 2025 15:01:11 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: iscsi: Fix HW conn removal use after free"
To: Li Lingfeng <lilingfeng3@huawei.com>, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        jejb@linux.ibm.com, James.Bottomley@HansenPartnership.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com,
        houtao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com,
        chengzhihao1@huawei.com, lilingfeng@huaweicloud.com
References: <20250715073926.3529456-1-lilingfeng3@huawei.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250715073926.3529456-1-lilingfeng3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR06CA0038.namprd06.prod.outlook.com
 (2603:10b6:8:54::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB7683:EE_
X-MS-Office365-Filtering-Correlation-Id: 18fe747c-72df-4d0c-0af0-08ddc56caecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2pxSTJ6VExaVnVPdFIvQjc3OTFxMHBoOGlSa1NMUGpjWklSNmc1MjNEVVcw?=
 =?utf-8?B?cXFuYll4QnFudW4yUVhyZy9iUlRXTFMwNmZoWnpDU2RRR3NhY0hxMUhFR1lj?=
 =?utf-8?B?a0o1aXMyZFd3QiszanJOMmduOTBiSXBxeUdZMzRSYmdRTW1TMUZzZTBWVTBw?=
 =?utf-8?B?eHJzRjFLZjQ5dEljVlVsMjdlNjB6TmszM2JzL3hib21CcGdRUkl2Z25KOFVT?=
 =?utf-8?B?ODRVc2FRM1RKbUIzZGRHdnI1Rzc5N0xNOFgxMWkySlJlbGYvRldVSmplallB?=
 =?utf-8?B?UWRMR3p2L0hRdFBJV1R1cUdJblIrZWhOMEdZZkxvakxwQ1BBT2VVRzZGN2lQ?=
 =?utf-8?B?RVRjZnQ5VFlmZnFCdkJSR05NVDllTzZXczY0ekxUcDlGMGpvZnY2alpZVHN6?=
 =?utf-8?B?QWlERTlLc1JPY3ZUODdHWGY5MjBWdXpwMXBqblEwazdWRTB6eHd3OHliZ0hT?=
 =?utf-8?B?S1ViNjVrT2Nwa09IODRuNlRSSDJZYXRQbmlycXh3bFhRRGVMdkJiYkUzMHhT?=
 =?utf-8?B?Tld6QVBNWDBvVXppMXZicVdoZzU0UkVDazQwYVVkdVpiV3NwbVJub1h1VmFI?=
 =?utf-8?B?R2ZiTkxDWkM1bndsYlk0L0NBMEhmYVdWZEFXZ3J4bVRKWG90WkxHU0FSLzg1?=
 =?utf-8?B?L2w2c25FTGdQZWVrdkZVc1BJSXRzbTE3bUFQOWFBTjBXQTBmNXphdnVxcTdz?=
 =?utf-8?B?MHZ4cFBCZXBuTWhtYkorL0hCNVpMbE1qT1oxOUhhOWNibE5zM0w2MkZzTGxk?=
 =?utf-8?B?YXJSaDBGOWFiM3lsR0htUEpheXNrR0xmVkJTWjlOZEdiSmI2Rld1TS9kQ0dG?=
 =?utf-8?B?UzN3MDNqWEpLcE5EbndqM0NhcG80eElnQ3Vja3pneDRUTG5pUW5KbEUyTnFr?=
 =?utf-8?B?dVRiSCt4cmtEdzBIa1l5NUd0Nnlwa1MzT2pZWEVMWHViUkF4L3NKblZ1WHQ3?=
 =?utf-8?B?dVozQXlLeUVwMTRzRE5pYnM4aVRhMXdPTUlRL3pFMWcxekEzQVM4NGh0WUhi?=
 =?utf-8?B?dnpEcFRmeFgrWGNDUmJMeUpPRXRHa296ZCtVd1JyY1FlYVFCcVlORXM3VElM?=
 =?utf-8?B?M3lITTBKei9vMHY1OUJOT0Q3RTBDWjFIUEtyUmNlVld2Y2ZSRnpaZHRhY0hj?=
 =?utf-8?B?VmhWUm1oUE5rQ01RSGIvK0ZVQlFxeURPWlRFQm9CTmNBOXFjMTk4WFM1bFNH?=
 =?utf-8?B?NDB0eHBsQUVsZGxFc2NFeVpJYnVGbEI0b2oxcWYwdytvakJlMnprZEVMOHND?=
 =?utf-8?B?NnNxSUFkeVlPUDUyZERQTk05eVhsd000ZU0vVVY5UEJNbDRhUjNaN2dwQk41?=
 =?utf-8?B?d2VCTm52UUI4dVZpMm02aVI2VjBGODhuQUs2TXNUOTlpNTB6OFFMNlJrNjJR?=
 =?utf-8?B?Z2YxTElYRVAzd3JsN0cxWTVmZ0JsVmlLR0hXNDlnczdrRWZYd0lycitGb2VY?=
 =?utf-8?B?Zk5hakQ5aVdHemlNWVRYRmFtZU5WbG1BWTZVWkV5UExnSjAySGgvSTIwQWpN?=
 =?utf-8?B?TlR5eDBBazJLNkxIdzBmcHRrbWROSlcxa2RZTlJ5OG1LNjlibVplZHdtb0FN?=
 =?utf-8?B?WDZSYXQ3N0JkOEgxZXc4QkhJK0liSVlreE1YZ0dvdVBFUU94aEx0N1B6V1NU?=
 =?utf-8?B?TFlNWFVmNUlMbUdDbVF6QytXZlZJa3VoNHlyWG1iOThaSXFkWTBVcnZVams2?=
 =?utf-8?B?NmRSeE1qaHJybVVGSmFxZlIvZlIyaWRNdmcwNHJFUnNZVkgybXpsUnpUMHM2?=
 =?utf-8?B?alZBUWttV2p5ellaRDhNMnMzWXh1aTNDSWRmZmxUSmFwdStYbUlhTEFvR3I5?=
 =?utf-8?B?QnhzT05mc2Rkb01IQ3NLcVg0V2RxRkhQUlBOU1BVcGVXMDRDZGVtSk0yUjdF?=
 =?utf-8?B?RTlOL0FhRWN6OS9JbFZVYXQrMFpJTTJhVGx0Q0JTcy9rTk4zRURvVmRJbjR4?=
 =?utf-8?Q?8f1CIGb6Iis=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVYyYS9nVm9mSmdnYlpvV2pHSkIvd3NwUnVXZGYxZVBRbGg4cEZrc1hrbEFF?=
 =?utf-8?B?enovS251eDkzV2V3OWtKQmlqODJSM0Z3SU04bDlySUtzTUg4WmVvVE1ISmJp?=
 =?utf-8?B?dFFQOEc4S2VpbzJXeG4xb1Q4T0JjeHVmUDNvUVYvM2VhQmpkdjJ6SXBZUkNQ?=
 =?utf-8?B?MWhLZm4yRWsrOGhuV3NEaFBQdXc0aEZnTUlibWQvVzRaeTZJWUZQVzJiT3Rs?=
 =?utf-8?B?aUV2dGgrL0Jyb2Q2ZjhtNXBCZm1XMmgydEZIY3ZyS09Jb255aVBCYTlOdEc1?=
 =?utf-8?B?cUhtR1B3dEhvMTlDQnU0UDFxWG1zWXU0T3FoSUtQM0dXZTVjN3E1VFJYV2x1?=
 =?utf-8?B?MFloM0thWGtSamdYNG5hdGdDS0tJMEpjaG1qQXBXemZwMEM3czVudXpVMFZL?=
 =?utf-8?B?aXh1cWRtWjJSMjlVMHYzTW1yRzJJM1JCcGJuZ3BnS1J0cHNHc2Z6VWJiV1Nh?=
 =?utf-8?B?dTZuQWlFYmQ1R3IvYzBXeDc5ZnB0eVYxcmp3Y0VwT3IvTUZ4WHc2blhCOVYz?=
 =?utf-8?B?YVNiQjdTWmdmSGYrdmVYVmRQa2ZlaGp1TlB2VWpUaUNnUDlUOG4yTU9KTUtk?=
 =?utf-8?B?RDFaZHhMVU5WeEFBZXJZQ0JVVkxpcmVvKy9iTHIwWDR6amF1RDBwSFJISUZz?=
 =?utf-8?B?MlUyY0JFdzd1akErVS9rVWpmTHZZNDZJdlNpL29NYUFHbDFtamZ2Q1BrZ1ZR?=
 =?utf-8?B?djU0QmRuVFlPb1YzcXo2MEtoUUtycTdzTm5SdDBacWs4eWhnNnM2eHpvcjlu?=
 =?utf-8?B?U2VocTI1OVRvaUMyMmw1YnR0WlI5NngxZTlKRU5FNlRNRkhFQmN3Q1RUNUtk?=
 =?utf-8?B?c21YRDFVcWJPQmJYMm1xeTBPUVRaazBTTDdIbFgveGtMVmM3OWhBdkNiMThs?=
 =?utf-8?B?b3RhQmo5WFRubXB6NlpuVHVwM0RRWDhaelFMZDdXRzNJMldOcTdBaVJvQ2Ny?=
 =?utf-8?B?WWtMYjZSNnZtSVg2U3N1VzZDZlZ6N1BBdDJXU2hBQTVLaFJVS3NpYUpRKzdP?=
 =?utf-8?B?K2o2QStiOFlVbktQMGVtSzlMbE9oSUkwUUdtQjA1elhwUWc2WlRTK3ZnSmZp?=
 =?utf-8?B?UlJrbURrS1VuK0RSdnN0RFUzak1IRUVBbjhncFpFYzgzSDd6OEUzM3dyNlFF?=
 =?utf-8?B?MDljRzZ1dXMxWURwZmU5bGFaTFZvR05zZTRKQ0cyT3V6NFRMRnZmVHBWYXFw?=
 =?utf-8?B?MTBubTZhQlBWR0wrYlFCU1JUaUlDcG1JSThMdDJQRittMVFncGZLQ2toeW5i?=
 =?utf-8?B?TnBVRGR0ZVp3Rk9EbU1aeS9OS2w5Y2x4L0ZXN3RDNzFrVmp6Yk14YzF4Ymdr?=
 =?utf-8?B?SHNOa3pSYXdHOUhFRnRrZ014aHhXNDZNQkF4NkFQell5ejRoMldpdVRzQ0Zp?=
 =?utf-8?B?U0VUamxlbjd0MU1LaloybVRhc09uY0tDd1FIVzYxS1hiRm11SG91WnJFWncx?=
 =?utf-8?B?SzYwajJORy9ZRGs5R2RyeVpoOVo2aTFzNXc1b2k0WTRsMnRvdXFsUnV0NEti?=
 =?utf-8?B?ekN5UldBRVEwbGR0bzhTb0Zndk8vZkVHdFdoL0hBWUxUUnV0YkJmUzRzNXl6?=
 =?utf-8?B?OTNmT1RJUXpMMXBQdHpwV1QwZ2ZONndBeWw1cVVBQWlDd0tOMFAyMVMvYUNQ?=
 =?utf-8?B?Rnh1UXVUSUpZUEsySkFxc0tGT3k0MG1oakZVTTYwNjIwcmhFbXBBQ0diMlNh?=
 =?utf-8?B?VGw1UGhZVnI2amxJNmRhMVJRRFo5WnptRVZZdEhoUk9naVVmcTE0aFp4L2NG?=
 =?utf-8?B?NloxS0hNK2N0QmRScXRPYk5vZ2t1QmdPUVpPeWt1SVJqenZ4WUlXS05IeGFG?=
 =?utf-8?B?NlltL2I5VlRKOEdsekhrVEVEWnVQZm05SEx3U0tYWjdtQ1ZkVVNHaU94dkFt?=
 =?utf-8?B?bFhkUkpRZUxWSmYzTE15eHNyT210R2ZGWmtsS2F6ajFLOFJuU2tZUm1aR2N4?=
 =?utf-8?B?Y004K1BZSy9xMXhJeEFrY2FmYTZoQXBQMXlsbGhYaVVEbmZMZkpKaE5zU0FH?=
 =?utf-8?B?ZGZ0aG9kMFBCMkw3NXkyTEg2L1hvTUMyR3FjazVZcU5KN01sc3MyWWpodXNi?=
 =?utf-8?B?RmY4Ky95ZkNvK1BEUHJ2MTlTVWhPWXJDY0NLZXAyWmU2QkY2d2JZbVhjMGxr?=
 =?utf-8?B?bDlMYSszNFV5VnNXWXBYMC8xRmc5Tkd3dk93bWR1L3FveWg5cWFxdHpDVW9k?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SWfwp2tqfBvGk8qMRUb460SNItds/qyo46wYg/1vq58hUZqMmVzv7XNlItalYYy79mJikFoSuWIgDlnsQ4qVXfe553Kp6HnC9UYTWuVm9y8qtJk7Y44b1smLZdKoE2z60JgqRYoE57Wt7smyUxmX84DkQtWHk317LaT1grwLmbMnwSSBgGCCU911brf6mkuxeYgL5QjL2lTg8Ylv/TLIyR65CTtqDMCsLRzUDxUzFLYTRMj4HKtipeDuLedkV9AaWUhPiXsN/luPFzG3el/rGtP3jS4IsDM/Gtr0oPTp0znurn2bpQ9KqWaqslkCqd2GYiAV7O15WX9HKzQLse7hSb4hH8X3TLv5/Qf/QPx1dzrpa8LySNH/EB+cj8MgOyA0VhY1OGYP/8H4CMAiNFm0qO+3KuebRT9hEUD5yrMdGEfsqJ4atcMC4NM1Gy1rL0dH4rxe5moKzzNubMOE5ukDqRNIRZHYFjgPgS9elQUIo82m9I51bxNUCOKmLb9d9Nu7yf8o07i9+0Xz5qN6MLXenMf+/0rvF6jMESBupImUqd47NVAt32z3m2aY21YcsMFTqnelXUkYjcoNKl13z6HfaYNG7WssyOji4Jdoo4JQ5zk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18fe747c-72df-4d0c-0af0-08ddc56caecf
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 20:01:14.0850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XMWDeAOqB6wEboyHmaqUO/ybuYflrbMb9ckdObxI5wfcwnBIkH+Mgzjci/wkG/cAXsQYAL5YE/UDy2vkjo9GT56tAEK8m94DJI5f7NrGAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7683
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-17_03,2025-07-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507170177
X-Proofpoint-ORIG-GUID: _8DjSgmi6om_lTo8OCWPcu-mgn_A5SYU
X-Authority-Analysis: v=2.4 cv=Of+YDgTY c=1 sm=1 tr=0 ts=68795693 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=8y9rTBotl4Vj4Er68ewA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: _8DjSgmi6om_lTo8OCWPcu-mgn_A5SYU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE3MDE3NyBTYWx0ZWRfXyiPEgqxbQmnq fDAdHLfK5bT1NQ2bWGjIAjvt1a9oYj2gex9nqcUxvQKhTJEYrnul3R6ZrOO4ohYSx41IFFTzmsy 0xxDM23I+sQItcs7F2IHMCzXE5xr4eV+snndWhxTZmZBrXootMg+t1SjUoH+lgP2galyMMtUrEx
 oJJgnrBFYIEvd5aIQnzM3Lu9eGZHHkl9KMNxiIlht8gSEMJxdAB2K1ebxaEpGzuJ0iCr6A5E7JJ e3AKbV21b54nHL5PwDJkNUz/YLSxpn9VgvkN0xeJIlzz8ISV5DjuWjqzpuW9YUvMqZhLzQZ4n4r XoU0z/uZFOSMKO6UTyBw5qvoGQpF4xokCHGrK+bzjrXG9h62Jwz+8w6EqPKJuN4Y3McLf+huCEw
 Egv5lGzZf+p4sJqwpypFuyTHjQwIqQ0Ovvo62TZRlJ/L3BmZgoh1LIRzWrAFXTPI7M7rUlUJ

On 7/15/25 2:39 AM, Li Lingfeng wrote:
> This reverts commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e.
> 
> The invocation of iscsi_put_conn() in iscsi_iter_destory_conn_fn() is used
> to free the initial reference counter of iscsi_cls_conn.
> For non-qla4xxx cases, the ->destroy_conn() callback (e.g.,
> iscsi_conn_teardown) will call iscsi_remove_conn() and iscsi_put_conn() to
> remove the connection from the children list of session and free the
> connection at last.
> However for qla4xxx, it is not the case. The ->destroy_conn() callback
> of qla4xxx will keep the connection in the session conn_list and doesn't
> use iscsi_put_conn() to free the initial reference counter. Therefore,
> it seems necessary to keep the iscsi_put_conn() in the
> iscsi_iter_destroy_conn_fn(), otherwise, there will be memory leak
> problem.
> 
I must have thought we did a unregister instead of remove for
some reason. Thanks for catching this.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
