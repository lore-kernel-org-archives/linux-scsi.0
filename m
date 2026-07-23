Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BFD46D0BA;
	Thu, 23 Jul 2026 11:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805689; cv=fail; b=T4SD2y0CoaMfEg3u7bBFcNi4w3XZfnfIOACb8MwaUCsSAhJgupoVU+9nTUZEGC3IaVmQEKt0USZd3FEyjhp41cSejoG3QCxI3kaXBqBSnNcT6xbzTNzXtuBy8jLT3WonZPWzu5GvbuHaJKsz9B2+g4UwgDNMQPhz/funMnOC+xE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805689; c=relaxed/simple;
	bh=3yH4lo6wd4KIJHsv9bhR7y8QZOspZPlLFc06Sc4nqWU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cZH5ORjXT6/+ssNlaSQ53PTmClDrpHDNq4wiBZvf9MxRLFExyiboaQNJfifmPrOPnxgoixfhl9pXR8XsoIAJXXza94eZWiWg3YVd+BZL2SBDRiULpGRc7+bIYCY+27T2h42a4fHKsPCdaRgpHiqfb9vyReWApaDasb+uU8w3htU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KO/9vK30; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UCPFp+Uk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KO/9vK30";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UCPFp+Uk"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtV7H3573753;
	Thu, 23 Jul 2026 11:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0qqKJc0pEdVQ0Gp48PZvtIwNGei04mEUbSlMjiVnaUw=; b=
	KO/9vK30ne4ZZszj5BL6m2AxxoikmBht0TbLtYgAZerr9PHs9xKT/WYATLIukYvz
	dQBPVh3LSlUe2hVPD1Dht7FC0LchLHmQinwsyfKCxI3ZueK9fBqF5Iejb8Yb673n
	rBT9KNs05qQ+nS2PlPCPrgGGWpwie18DGcOwb5EuHX34sysiFMolOWRCxP+4MoUl
	osmODXjwXkfRwT4wtcUdzB82q84Eu1jE1wuB8TwKllSK/UzNZ4XByNj+LkcnIZIV
	VEfgUNW3o3OIWH/qHNrtt5NZqE6VgljmoIeDDxXKYR9zBiIFy+sI/B7Mua/q0kMv
	U1ModQFDFYoQj63cHRBciw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqptmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:21:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NBIjUe034018;
	Thu, 23 Jul 2026 11:21:22 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010000.outbound.protection.outlook.com [52.101.85.0])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxs8eh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:21:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dm4jcH3BMSnaQwuj2yLTsgnCFB1WYaIMWslWJlJXK9sMp1fxHff4c+cVGQr8bqphh6/YrMjJKwLYPt1ZuhfFueZUXRD3aQSMcsaAfYcvSWuMbbRAiiGcrPwJ9KlGTiNiV9zKMy44Xou04RyBXVI8Q6EZjUG0bqY6oc0t5/dnHaCnqTsoMa4NaRnSCG2elmEd9gGNcXmE5iak/Bp4oFdaEuEF0eIPileFczuheJ1P0OyQJJyG2lXLFb7J5sziiNYAcmfYPGYPNiNY3Hjs416kFzpYrRC+JOdX/Rnl132lE5jK3jGbhnRZYSpNo+DJzHIYtoFRWo6Tq45qq+SaSn6rzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qqKJc0pEdVQ0Gp48PZvtIwNGei04mEUbSlMjiVnaUw=;
 b=ynDpegbNWDRYIcUkPAXwAZxTOQtnvp/g6ofy3bqmaRtRO1KhF5P3VWBylpN0jRGRhgbOSupGPhQMS0GD+4fCeg/oxUWe/8ZvSauTXMRnh9988WqJ5X5VjcDxxPoIgjVV4S1i+GGNNsWUAZWHQErzmqiUpLcPmAEkEmzqOigtskAYmFOHj5cq4kXLKjLWoClAS3425OqXXEhc3jo+5UTc0QcX4HRzEKYBR1SjBctg3oJeMMRCKlCLVl5LWAo/QqgjVgar3nMfbAES1i3VPweAxpmSNuquywXRNUlu7GhGN2hJ7dcsVutVFNynXphE3z8Tivb7m7FSmpApAue/4cK3VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qqKJc0pEdVQ0Gp48PZvtIwNGei04mEUbSlMjiVnaUw=;
 b=UCPFp+UkKsrByvrGaFFNM2rTJwYkht2VHwVdHB1Jh8EByNGApDcFqgcMcci2BD53ZwX/BjoEH1QgVWDknmLsv+nHUXSvtvN4jGs7lkDWZbLDRTMkxfD00z2l3wp286SMhyK5GkCHdAK3O3aELC0ydZ30PlVd5m8Q4glVGH166uM=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by CH2PR10MB4279.namprd10.prod.outlook.com (2603:10b6:610:a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 11:21:19 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:21:19 +0000
Message-ID: <e638d673-8187-478c-9a49-d378fb272f92@oracle.com>
Date: Thu, 23 Jul 2026 12:21:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 22/28] scsi-multipath: add delayed disk removal support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-23-john.g.garry@oracle.com>
 <20260723103956.480A31F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723103956.480A31F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0152.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::15) To PH7PR10MB6228.namprd10.prod.outlook.com
 (2603:10b6:510:213::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|CH2PR10MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: d732f759-bc94-46a1-44c2-08dee8ac847d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|10067099003|4143699003|10063799003|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Z/csIhBa8pGb3n8s20aLYp63hmO3T/l4UDBjorDDNooGmml/sjw8KIlIjGDYlMCMpWxK0cMvt7BKt7UduUw8RGl3/+SCdLVfBG3/KG03FJQXFQEMk2BrpJDlhT4huO/szTMAbX66oaaD8J1PTGwj1ThhvBrNDEPfIFujBHNqELnbtNm71/dsk+knkX60jW4Hcy43IVMCjialqDRE8+Nv9fa6PMan45aKtPgJahyF0BV8QvUM9XXlZMcwvA70jZjLkMdLDCd1ZqOCajCTonkpmtaw//+jR2TvDe7GabeLv5v6y2fv44UT5dQEFAHItTEpJQrh/BpaMmgZn37H2/dTJdYaTxBTlj4Bq77Uja4OcCnn0n5fbbRzo7Al3dnqVAiMk47SG/eEUjpcr9AYfcpnhmcQxsdumh/hD1AUnDm1WJyJRxquSFriU0/xw46OO8WCa1bTBEquzeevCdgiNGNWYFmfHTo3KjslSbQH0Qh5KNH9O18ZTu07dS0Iw+1smeMHxRvOu/q7NVJRWrBdJW3GF9sqHllhnqdbjK1jV98zKg1gc0evLn44s/V7cbdDwL3S7BynThinuUfP+YZC0UoHJcjssvoMHPVsuB9KhwW+Mqqs6UW/oDSLH0G+QT2dB+fuy44bbGuuwatzrTKaA3bxPqLZOfEUXW3ZoVCF6PLjIqg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(10067099003)(4143699003)(10063799003)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Sm0xQ3UrMDFJTjFBN2RzbUoxV0JaM2I3Rk5Xdkw3RnYrUnBnQnVWTlNVSy8z?=
 =?utf-8?B?emt6NUIzdjFONGp4MU9QY0Frd0V3RnhQc2orWnprbXprL0tCUUV2dGtMSmM5?=
 =?utf-8?B?dm5xek92MGFRckZEaHlDMVJ2bWR1QklPeFVWdk4ySWJCamlmVlNzcC8wZFp4?=
 =?utf-8?B?WGdmaHNyOVpxL1VaWVlxNXFNNnM3MjZhWFd2Qmh2Y0NIR1BxMXphbVVoRnZI?=
 =?utf-8?B?OW42Ym5LL0Z2aUFsRTJVV2hnMmV0MXNGSXl3NjB1a2JkUGVlMDFSS2Z0WGJS?=
 =?utf-8?B?YkFHWmhWaTFSeVp1NTBtUmdORUxVSHZybCt2WTNSOUpPc24zK0Q0elJvSkc2?=
 =?utf-8?B?Z3hubVpReGlYc1hkRVdTdmFJYTZnVVgyaG9FaFl0SzkzeldSekEyZThMbXVN?=
 =?utf-8?B?R3ZGZENZOS9wMDVxSVhsa1BoYjFja1RDMEU1dG56YWwwekpEWTFod2lSMmdM?=
 =?utf-8?B?NHlOSE1vdnJhbXhKaHp6QURaeG15QncrbXJnYlcranRSQTY0NVNuTGRPeWht?=
 =?utf-8?B?Q3dVOUwxL2R1WUFvYm5paVRTSjMvTGxJdHBmcGpLVWFGc0Z5T05NOUlvQ3po?=
 =?utf-8?B?d2hwdkN6b01EanBGQk5mTGVNYkpxTHU5NXFJQU5ualBGbTFZRlZoN2JTakFV?=
 =?utf-8?B?VktnTlJ1R2t2Z0g4S3BJbEJmOUZGQkpxK1RsbUVDQ1RIN0ZQY2hTWjQyL0RT?=
 =?utf-8?B?ckgyUWVNVHlVYmNRQXRROGNod0lHZFFQZlQ5UGpvRVJXdkVIOGhyaEhJUnI0?=
 =?utf-8?B?M2tKaUV0VmdabmNWVTRxODBPWmJxWVJhK0NSYkg2UzVKVXJYTmZZVjEwdkJ2?=
 =?utf-8?B?S3Y2aUU2QWgxeVZWN3RtLzVBTXp6dDFPSk1hdEx5VkR6d3ROVkVPUFkrdWlX?=
 =?utf-8?B?QWtuU24xTjlOWGtZeldOYitsSmJsOHJXL1QrV0RpbUtEcTNqQktFZHhKRDhq?=
 =?utf-8?B?aEs2MTliZWRYekZpcm15dDJjUHFzMURRRjFSc1dLWG1SR0lyUTVET3B5czYy?=
 =?utf-8?B?c3RQU0phREQxVGhDQzg3czNmZDdQQUplc3ptd2ZqcGFsUjZmNWtmTVZzdFlm?=
 =?utf-8?B?SmxvdW9qTVVFV3NweXF3VWhJaFUzaXRzRCtDR2l2b2E2Wk1qWkc4MWxZTHVE?=
 =?utf-8?B?ajJJT2dhSEdNWWlzckJiQlByYTFVNlVXOCtwNGxxUWJOVU16eGRPTzhYb2oy?=
 =?utf-8?B?WHZPYjVsTlFVRUhIeTYvQUJhb2c5SFdJUVJsblNMZjcvcENMWWVPbHlRYzUx?=
 =?utf-8?B?TVNGUUlDMDBlMnhDaXZqSHhCTnBMMW16MGRicDlMUlR4c2orWjFVdk9adlJo?=
 =?utf-8?B?SUZ4WnRONTdDMzNwSWQxLzJvMUIyMWQrNGVYS3JDOGF5cUR0Y2tzZDZvL0dl?=
 =?utf-8?B?RStFMm9qZU5sYkdtVDJmR1dnTTJuMkNIZ0JJQmYwV2xsLzh5c2w5SndHbm5F?=
 =?utf-8?B?SGxXK1FWNkVoSTcvcnpMaHRMdmtjTzVnM21CT3VLMlM5QXNYZ3JKR3NESU54?=
 =?utf-8?B?WlRWYWVrcS9CbXI4eDJFRWF2NHMya3V4NHdGek1LaVlHM0NNdDBrTHNvRm50?=
 =?utf-8?B?c25EOHhMTTk5NDBqOVdTelBQamtJUVpHWUdROFpRbFoxWEF1b0tMQVpNUmNX?=
 =?utf-8?B?K1pobjZ3YmI3UXY0MkttQjZGVjhVR3hpbmVNNThwYUtzWFRqZFFNUWhYbTZz?=
 =?utf-8?B?blhXeHdBaC9CSHMwMU5LWGw0SUc0bXlhVTMxNDlQZ09TaFBmeVVkMzFWbUI4?=
 =?utf-8?B?UDNmS3VHKzdOSHJiY0ZsRmJhSm10YzZUM0pBUWRibVpsTk11ekJ6WEdWdHdy?=
 =?utf-8?B?MUV0VzFHNmcvejZhdjhmUll4MFFHNTlDdGpvbExJMUVzdUNhN2oxV3hCRith?=
 =?utf-8?B?T01OZlA2TGZDQ0grMHRqalpLSXNmaVhoSU52Ti9RWlFpSkoxYXhjbzF3NFFI?=
 =?utf-8?B?TTFMMWVNRGhsMWc0Z3Jha1IrNXZ2N0tBdXpteXFvbFc4Y2RjcHcwbmY0MVR2?=
 =?utf-8?B?Qzd4bVRKMFcyM1R4M2VUNDA1TFQ5bHdIQjJJYlNYaGpCWXMza3R4YnBZbExU?=
 =?utf-8?B?NDZDcmdxTGVaZ2d2UFpkdEdFY3ZvSWZyM2VpZTZYeEFBMGNKaFlqYnRQZzFx?=
 =?utf-8?B?aC91OTBoRnllc3hndzBHZjFFOUNIS05nSDZyTm5oVGV0WVkrSlc1WmxBZDFz?=
 =?utf-8?B?bjVMZTU2UTVjMmpQQ2tiaXhjQXY3L3pTdkp0K0FOUkhPRUQxcHBWMzJPTjdZ?=
 =?utf-8?B?WjcwSjVlakxWaTFuZUpGTWdBT1lKWEo2TGRqOWhacnhQNCtlVEVrcDRtY0Fk?=
 =?utf-8?B?a0l3bnlYcWx5d1NISkpSWEYwTy9acmR1Y2R2YnlvcHRrOFdUVXZ3NFRvUFVv?=
 =?utf-8?Q?A6CX2waUefPMvNvg=3D?=
X-Exchange-RoutingPolicyChecked:
	nEuuS2epsuXzqM5k5VAzgOzhTy9PBbPYJucgozVGqHFgchc3OJAiM0HL26YFLvVViJ5JdJwz4zEWMN69eXtmo243Ogj4XYtoyql2Q0FJSTbToqEZXxd67qCQksitg5NimGW4yMtRPoS2lsr2Bb4lW2dCnW1tyLY0cMLi6Sa2wZXpY0zXoowlCV8M/T1Kq90kOgf3JADYsJlI0+4U7AJU6SsUdxPACDzPGWyKss5I+uiAbhLCx3WAn0FdcGcFS5tTeCrYWzlv4QMy2X1KmWoyjV4C0eX7BsmeZPVYI6dH/0a3deUIAKMRcd+26faLt/c22HIXm7tChRXELRvnFj8Gqg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CStje9PNhdKePha8UV6QCGChKMl43vicGAEd98Pdm5dHTdIvclj2ZQvx7AnxnV2GV1Ql5aNcARji19QRi3ge0tAJ6xhYTms2MJLNenS0koQKoumXHB5JHEz4+1fOj0NVHJj+ht4jJOJYS9gnhPptF3yKLmci0ruffG3fyQ+99ierJMsHlB6lSELcMcf3FmMRvJ3nmhBncnHSuF+uzHBdaR+pXROzpfVSo7sMQogEk+38NdrxzVQIXjco0n2pNd8TttRIKofIHzRomWOOb9KjhgDZvc7GLTlvkxytxa5qaNh6N5yHl3KurdvlMsBNuVktuiXJ/wRVGYaebEXMCnuwpUcY0ec9I02T4bP93WJWH1P1YnoURTTVTaXYL41jjZPmZwo49XXYd1ZZxWoX2u0qcTqRhh7s9qJeJeR5cRbCQHj3RYnaLeIxzOkvHAX1HUJ7fRHtQwGN+8NCnurtVnK3L6unZRLZl98cHwzydwTGUz5NtROdyYO0LmGf2ZqmrIuMaYdCJFV7IKDWmcylbBDX/L81vwUxbaURQgwx3jFnKZ9IFlkFShAHT4B36moT0+mJ5TrHy2AnU+aFP1kgLDbZR0chrvoYW2ExdmHoyOg52N8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d732f759-bc94-46a1-44c2-08dee8ac847d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6228.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:21:18.9384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8LsF/XeOwf9oFy2pguKZNesCi7rw9NCc2mtJqEAuOonhTH3bclzCxW0Ws5Fh6gYyf0UzWykC7rxpd8tvX/FrJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230111
X-Proofpoint-ORIG-GUID: oVE7idoxelR8ilxxKnchKlk3Jrjgo6gS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDExMSBTYWx0ZWRfX87HYM8fQYfmT
 /WT5bicthSAnz/9jelmn0IVe+wx8H5+z0qtSkc5BG2qL1lchGlQ7mFUbKT0m888rKbVOSfc+ITs
 4RkECZpj+4NVE+ivw7rekWad0aSBRWlohkCXNgbaL3/XHqjDGjv8ZNKERB5OHzxs1q5g8dJ6wvX
 e14lITGGYAJXW+/IpuhmvgwSncHP1iMfWTaFvkGgihxku22Sb+KxtigLc7X87kKJDORy8qu2WHn
 1mEUcb/ulKe9IMsFQmMsQoz6iz1GxEqJFxBIgcBk1HJ/s0TEKnPypyX2RemPaRw39SjB9j0eGBw
 UkXGIAxXmVLPibAHlzzsn5OJMYbcrVdWPtLEh7DjmOIX82BqTObizsLr+pnQikcxJlzn9HN9eYB
 jAg8JYu2snzZ4ShnhQT3JeRsMrMeYWgsR1a/kkC7XPL5xpEQMN6tD9vBys4qkpVvxeKHehbiU8W
 /6EWtbhJoCcSmETmtI44lX7mTmuOcWnKgq0qsXz0=
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61f933 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=6KROm75YECGozOEhzY8A:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-GUID: oVE7idoxelR8ilxxKnchKlk3Jrjgo6gS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDExMSBTYWx0ZWRfXwUTFv2/OiztD
 jbSsKLZD0Gxq1N5gi0hTxJVaDlF2Ifm86Tg0fDMWYcp0WOrHjFcrE1GZojIxUud+Sm2nGG2fgfK
 adGUkvCdI7I07xtUuW5tKnGMZZezKDsua86X7kW1YA4SBGEcZnbn

On 23/07/2026 11:39, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Broadcasting `scsi_mpath_head` to all SCSI drivers without halting iteration causes a Use-After-Free and Type Confusion risk if the callback drops the final reference and frees the structure.
> - [High] Missing module reference pinning allows `scsi_mod` to be unloaded while delayed removal work is pending, leading to code-execution UAF.
> --
> 
> --- Patch [22]: [PATCH v4 22/28] scsi-multipath: add delayed disk removal support ---
> commit e75160848c3c93c7fdb328d5ebd94850baa881c8
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: add delayed disk removal support
> 
> This commit adds delayed disk removal support to the SCSI multipath core.
> It introduces a new mpath_remove_head callback in the scsi_driver structure
> and implements scsi_mpath_remove_head_work to execute this callback by
> iterating over available SCSI drivers.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 6c50fdde70d65..056b9c35d1144 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -362,7 +362,25 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
>>   	return false;
>>   }
>>   
>> +static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *data)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head = data;
>> +	struct scsi_driver *scsi_driver = to_scsi_driver(drv);
>> +
>> +	if (scsi_driver->mpath_remove_head)
>> +		scsi_driver->mpath_remove_head(scsi_mpath_head);
>> +
>> +	return 0;
>> +}
>> +
>> +static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
>> +{
>> +	bus_for_each_drv(&scsi_bus_type, NULL, to_scsi_mpath_head(mpath_head),
>> +		scsi_mpath_remove_head_drv);
>> +}
> 
> [Severity: High]
> Does this code risk a use-after-free and type confusion regression during bus
> iteration?
> 
> Looking at scsi_mpath_remove_head_work() in drivers/scsi/scsi_multipath.c, it
> unconditionally iterates over all SCSI drivers via bus_for_each_drv(). If the
> target driver implements mpath_remove_head and drops the final reference to
> scsi_mpath_head freeing the structure, scsi_mpath_remove_head_drv() still
> returns 0.
> 
> Could the iteration continue and pass the freed scsi_mpath_head pointer to
> subsequent drivers on the bus, causing other drivers that implement
> mpath_remove_head to dereference a dangling pointer?

any other driver should have a reference if necessary and they should 
not reference scsi_mpath_head if they don't

> 
> Should the iteration halt by returning a non-zero value once the callback has
> been successfully executed?
> 
>>   static struct mpath_head_template smpdt = {
>> +	.remove_head = scsi_mpath_remove_head_work,
> 
> [Severity: High]
> Does this delayed work introduction expose a use-after-free regression due to
> a missing module reference?
> 
> When delayed removal is queued, it relies on mpath_head->drv_module being set
> to pin the module. However, looking at scsi_mpath_alloc_head() where smpdt is
> assigned:
> 
> drivers/scsi/scsi_multipath.c:scsi_mpath_alloc_head() {
>      ...
> 	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
> 	if (!scsi_mpath_head)
> 		return NULL;
>      ...
> 	if (mpath_head_init(&scsi_mpath_head->mpath_head))
> 		goto out_free;
> 	scsi_mpath_head->mpath_head.mpdt = &smpdt;
>      ...
> }
> 
> Since mpath_head->drv_module is never initialized to THIS_MODULE,
> try_module_get(mpath_head->drv_module) will return true without taking a
> reference.
> 

it's done by sd.c

> Could scsi_mod be unloaded while the delayed remove_work is still pending in
> the workqueue, causing the remove_head callback execution to jump to unmapped
> memory?
> 
>>   	.is_disabled = scsi_mpath_is_disabled,
>>   	.is_optimized = scsi_mpath_is_optimized,
> [ ... ]
> 

