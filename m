Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3092341D132;
	Mon, 27 Jul 2026 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165181; cv=fail; b=B4ZAGcmejycaf8aoS0MZf3m+oeHRpFfeCX9x0NI4vvqFvhn3BLJQHx5ff7PTai1tpSRI/AEsUB8BMLIF6cGYdykrQor40bhL9rNHJ+wBiWjaqBoW/yIM1deZNShcsEAZma9LgpuC6+sM1clOHfNYih85eKF2rNAVutHg9z2EVi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165181; c=relaxed/simple;
	bh=8y5qkHrEy8f8wPu4fnZz35RyZa9bQBGDAtWFR5n4PgA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bn2mYUemAaiu9/589KSX6ilk6du247WZdKwM0nV/iPxqA6lTvF1Qx0s1nILqlXaJndWaOozNxI0xTPMxKZum2U2T8KN3VzhRDz6juerFqHFK/sSfaRkf3eOfARzoX6D6lR5wX4+N8bPex7PIQxsKtgrPCNCvS9vtn+ArN5f3DL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b4tTnL0M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FkMluoZt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b4tTnL0M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FkMluoZt"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66REtdaL2316273;
	Mon, 27 Jul 2026 15:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RlSdWj+GY2JS4Y7+z+Q4pAHv8YgBtJgJwwEC3QYZm7M=; b=
	b4tTnL0M+YQO1g2OA7QJWsEmw3uSVQ72i9M4utjgGs7CunVI6b/222ZC9cu2bTPO
	4zD1J6r0QPVcHGITkqy5mhqPryzOPL2bKBss26Cy8QTf09UmiaJwx9Wh0eOgUk9q
	NUkGG9L3O15gMmOxGY8iQ4XxBM+YDGaQkuraKCM0lwNlhH1kvqqn6UH3kFWjdVwH
	nCRs+uKeHr/Qu2sFR6jAGPPlj5CEejpVOkfHdd9azc1iTQGgpIPLFsw1yiBkmSSI
	7Vj8SdoQiS6f3gXIqAwEplP5af8eIEfjg+4HDkKVvnWAQMNCG3FCNAMnwDTD5a6S
	Yto5fqHFdwi+eBUHy0oAKQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq20ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:12:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFAa0o031143;
	Mon, 27 Jul 2026 15:12:58 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010037.outbound.protection.outlook.com [52.101.46.37])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6bj93g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:12:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LisANnry5rdTN34Rq7YCzhyMdK+BGmJWl4w+y2/2hltlhUgGCFV7Ev+AMX6pexQInkhMQYp49WN4LmMU9uhqKuKi1+g+zJWjIs3k04IenMcLB4DPKxetdPi4FSQI76K0e1zFrS8Z9F1/q9miNXLLhf6ALnN18uB8pOMzXVKf2vOiWn7BB2TFRUvaDPgua3PgaYJzlMGYR+oj5EBokb5c/54KIAK1hnKgQqZZeQ5tdwwUwypYbn80ugWVDmGl+8IrQCxS/t6Fd6WHGZbcw1/+AdzQ1hUNwH4Cd0LZ3MuRE3NyKIEzenP+R8djojORVZLA+NurppzHdThixA81SeD59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlSdWj+GY2JS4Y7+z+Q4pAHv8YgBtJgJwwEC3QYZm7M=;
 b=HPFNbTH267iy7AhD5M5QAee+x9mPM/NGhHpgCZMjZR9MLGEp1Kjwv7z2Tcaa+TnDQ8xx8GxqJu8+0EUl87yrRlxXVz05YOR5UsjxNWdDzKvi0tMKWN/XJeL4VdKesOE6N8LCfpHiYTfdOJxFTVUOzBRgb7vbANSpu1yiytFrV3tKL2AjRcrzXxyLb250b1ZL5K7AG/tEnbvsv9KLSfxNKwgzkAtq1kjbj71JJOZMSRlp2AvlvrGjLzL379K2DhCfb5xdBRfwXE6k30yS3/5+yoX8wTt1T1vGBYO4Rt0W63hiIz0SEPX75jzENXrxjTaybkTTUhASfrk0rLfPfmRWiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlSdWj+GY2JS4Y7+z+Q4pAHv8YgBtJgJwwEC3QYZm7M=;
 b=FkMluoZtWWFdvIQmwQDGk6i+rdKxCa3ciTYv+rE2bEoqFoLJcTRjOuDoxk5DsS6rl1hd3Px86ao9W9QY6jdkQsnN+d2uJZVTxfaI7GqB10NaI++HafqjC7MU8GXUjNiEu0vVPYuzjzqNtBKsRPoTgQQupHxaZHSijvh52yZ383o=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 15:12:54 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:12:54 +0000
Message-ID: <54310562-064e-4c77-9ecb-a45a4054ed7a@oracle.com>
Date: Mon, 27 Jul 2026 16:12:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/27] libmultipath: Add initial framework
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-2-john.g.garry@oracle.com>
 <20260727150545.A990C1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727150545.A990C1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0343.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4789:EE_
X-MS-Office365-Filtering-Correlation-Id: 8017db4e-8ae1-4525-4853-08deebf1886c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|18002099003|10067099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Zcoy/PpkHDSkyxccbVSmivc8jq0cm0JbZZ5LyHyy8lgOR61oMidZUZ/eWBjThMTGWko5QDPHW2yDRZGGnio0/AmlZBXRb0vL2oCRg95HAEXBL9ZJOO7bzKiI9+YDpujStqil6VirPofLVJtUrktErUd6jkcxYut5LWQ64HmXcqcjx+86IAH8yl4JFd/u/ZGie0bE53uubOHcv+KI+B7IH0WNuJvMwmdWV940syCiwAaR+QgIU08VRXX3Tgcb6FTO6Y1vJHw3MY6Grj9JHDF69/Zjtm+yedM5EjvB9dmgO4WuUMT8rV2IkCCCMk0OJtK+AFudLKNECeJKYE7FTJDAsXLewn2fVuLjCe7inOUFpSXud1dX37idwJmxvTid0MoQHVTZnhMoTnkHku5at3iiBt/x5a+pWJoJeWFmqzZNfOGlIdCqYjTdAtwrRJs0BBOrlQwZZRKbrJFi5Wh6ZxfpprWZle0eiwk500sej+igd0b8M0ZakLORgJQsQ/T94u6umlIPUAVS8qr7iHtzj5hoVObVRaOO9Rzvyz8LoksA8HzBDmyGiWFBGkYbkNK/UYdQOVntUoIy4bBH1i2na08ssN6kpGNzVSVjVOuVWpfyyH6r0Tz4JGABeHNxhilRJGQkWddhM4xllSrBupPnYWA/5VPnvKMRqBvlMAU7GybeHG4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(18002099003)(10067099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXZaOFFicFgwdHRmSHN6bTRveDUvSWNaYjExd3M3OFpXTUNlancwNVZ0dnMr?=
 =?utf-8?B?cWczOE1SYnVDWStpaUo2RktkeStGQmtoOHNURk1wUWtkK3BJMnVaaVF4QkVP?=
 =?utf-8?B?a2hIN3duNWd5N1V6NWpGM1RURmplWGdhQzlPcTZXWm1TSXRvam1UYk45Z29o?=
 =?utf-8?B?cGdQTE9EYXU4L205Y3ZmQzNKcENGanY2b2ZaUW5BSWpFK0NGZkFBdVkvNDNr?=
 =?utf-8?B?M1hGNlFrRXM2S3BYVnJLaCszVkhnNnRYWXlZMWxqWlpnQ25CMkpGdzl4a1ZS?=
 =?utf-8?B?bkZlYUEvdC8yNmJpakVNQXphWE1YYTc2OWlBVmVVYktaUERzbnQySFBScklQ?=
 =?utf-8?B?OFpxZXhIeGhBejhSNVBVYnBLMzMxZnNBRy9xeXNjQlkrMWxMS1loMWhvRnh4?=
 =?utf-8?B?cnZkWjE4NHZIWW1FV2d6dEJPOWZNWE8wM1N4VzlUb1AvV0tEczFHUlpsZEZy?=
 =?utf-8?B?ZnpiaDY4VU95ZnIyTmZmTndhckpVMzJpZ0pGUktSaXlMSktpTTFEVXBsSS9z?=
 =?utf-8?B?d3EvUlZwZHN3VHpNazNUSjFoWlh3ajlFeXNVS1pEN1dYenVINHVrTStkTmN1?=
 =?utf-8?B?Yk9EMThMQ281c0oweWk0czB0dU5EbmRZazZjZjFBbDFIRFAweUJnK0dPU080?=
 =?utf-8?B?MzBqSmwzaC9VeHF3b0Q0MDNzNDYwaE9sT2tPSG1pUWF6VHBUUnhWczNYcENB?=
 =?utf-8?B?NU9kcHptc3JiYmxRenlPRkc5UGs1eTdxdFBJL2QxNk9BTUlkV21heHB0Tk5H?=
 =?utf-8?B?SmdVRkZ3UXREOUZpK1ZnZXl4V20vM3FSRThYdkZmU2dtSlRNd1BTdGV2QlJs?=
 =?utf-8?B?aHZzODdnU1RqTks2WmFXR3FQc1RXZW0zN2ZFam1WVU9PQ0tZWEo3TFVHcG9a?=
 =?utf-8?B?MHA3NkM1YmE4dklIdnVJaUNEeExNTzB1K1d0WWM5K2hBMkdKMlVtUkxrYndL?=
 =?utf-8?B?ejZjQTJyZmF1TDhOWUozcHhDVmFKOFFFU0FiNGhVMmtxdUxVS0F1L3UvRlNC?=
 =?utf-8?B?TE5kcUwydXVpT04zSktpMXQrQU4zSTJTTUVCRVdjb2hJREZ2OTZSMHlFSlR3?=
 =?utf-8?B?OExUdHlvV1Vod2NHVjE1UUxlcVlrVFNNWjRXZitRNElYOHh3TG85Y1g4SDRU?=
 =?utf-8?B?MTBQQUg2blRWazFVZXp1RFdKRzFndmxPQzZSS05Ra3BMUkdZbnZZTTMxMy9C?=
 =?utf-8?B?SFgwdEJtWHRzcnNaenNOMWVTaStpYnRhWkVLdnkzeW1IdExleE5ST3c0NDI1?=
 =?utf-8?B?Z1pPcmlDOFdDZHFmUTRwMWYyRC8zc2JYQTBYK1pQc0pNWEVGSzBzUU12UUlF?=
 =?utf-8?B?ZS9yY0Yzckw3RHpGUi81VTBCZTdkZkNOcDBDTjkwcmVYWlZoK1hsNUNqSXc1?=
 =?utf-8?B?eTRWSVZMVmRudmp5ZmRLMkl3VEhJeFBLdEJUb3FHR2xNcFdnOGR0Yk50WVVO?=
 =?utf-8?B?SWtIT2hRUzB4NUJoRGltSktEQk1hV3dIdVIxMUdxSW5ySUZJTGxnZkhDSzN6?=
 =?utf-8?B?M09TWVBwam5hQkN0bzg3d0s4b29UQnBIeU1ZQTF2aEFVa3ZUcWVDc0RYbXNJ?=
 =?utf-8?B?V0tLdGdneExRQlhqaUp1ZnJYdGovTTZ6b2R0YnNtSG5ER0tCS0ZSbmdTakJH?=
 =?utf-8?B?VVVhREUwTDkycU1scmozYTVjTUZCa2Z0TmtkSk9WcjRlOHhSbzdDbDhBL096?=
 =?utf-8?B?SmtqLzFuOTZMRS8vZXpYWFZIY0lxcUorMWNlalkySEt1aXhnUkJJb2NDVEtG?=
 =?utf-8?B?bU0vRlBZNCtPS0pNbk9zbzBrSG9DTFpXdXIwT2ZuSk9GSnJkMWZacTlUaWZx?=
 =?utf-8?B?dStLYmFSZWdSaFk0RTNZR085YThuZllHck90OUFIS2xjOEcyM3NGdTZOL3cr?=
 =?utf-8?B?ZWwrU2pXbU1Pbm15cXhobDF3QjZ2TUlEa2ZSS0VvUW1NQkhFWjJsS3RaWlc1?=
 =?utf-8?B?aFFKWk4yOElGUEgrSUFZQVZmY0duWDBCZ2xHTVhrcUNZUjFOVlVML0hUc3pD?=
 =?utf-8?B?cTFkOHlIcUtCNlVINmd5STJTdFp5dm9xTnJUN256M0pkbkVsd3hLa1M5blJI?=
 =?utf-8?B?cHpvOTVMWmJQUGpsQk1Bb2plMWRmYjNmODBrODl0Nk1yVVlIczk5dHZPekR3?=
 =?utf-8?B?YWtIcDlrcFY2cHB4d3lUMXZyOEZNYUhCcGRXb3JkeU05V3V2L1MyR0c4VC90?=
 =?utf-8?B?WnVsUUUzbWEwb1FhZDRQVnI2V1ZiaERJS01tZThMQmtqWUNRcHF4T3lWUnlv?=
 =?utf-8?B?Z3Z3V3RIbW5aZ0ZPbjRaamV6eDlpQzUxM2F2d0tiamZBSmpQTDBOTjd3WDgx?=
 =?utf-8?B?Q04zK1FpSjlCRTA3TFNKNUxaR01CMXdIbjdLU0pJazRuVDBON1o5TXhSa3p0?=
 =?utf-8?Q?Gzlb6T8N9aogD71E=3D?=
X-Exchange-RoutingPolicyChecked:
	HVMF83mZ6KyicZ6tl5BQFRm5nCdeGOj1dqgV/iIStwNdg7QENcUuA2Wg85sS1FSovzVNIFodyi5ypInJdPrwaRx7GSLXTReQvFW2vWMU2I6ZwJ5ME405eZGPZDn8GkEYQXrOB0tUtMVygFOh0cV0jQaeMryXbaZdkI2Mea5EZTed+9KSM5nKTUmTBgXmOE+/KYPgVqO8mT2MWDCELTAx6ZML6KZrlwy6MKi5BaIPz+vArOtUUynC8kb4JAKvRaNbHBv0I/mzScAIQkr0Jz12w6Mjb3MBKhIV1YIiVfUQ2lbuvL0ZU7qOBvZdmE+asN5bGU6PNwg0GZbbsbzHw5Wfzw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zR+GaguA2w9VbL8b6zC6GP4BUnu3tGeyVWVIDGU4mLBYwAv2Xq8BVe8Zvnne5el0FPQ+xNfxJWWnqbo142JJl55UNu5oKHV6TY52bs8fFvshKjRl4vML+SilbvSLkNKVymDvhFzxHoFzMI2V550qucH0pNb69fZb8PrbYHxqUIB0NdW/fN3LMZTYLC50SccnfnYQMxhcQJkdukpfcRX6JL2on6P4OQqd/93PcAL6naqqzvdXP7yjq6gMXgXdWxxx5rL4YOy/ClCylEEPsaXYR8KsYLlt2Q/VkreOVjoWadfMa/0fkEAE6vRql/3/HcfKU/Hs9tINje+Du7y0RcDHg3unY/ZJkP2V+AZrEpqI52AjzTpJn9pduWogiXsKoZ/QeoTRV+UHnkNVIauMvZ+5twnrfHC68Yux3GGRVpIMFElzDUIvlGZpF2upPOz+/Yd9mhGZR8FGQ1PtC7UQEb7t3tBPHl67JwaiLNN2fReK02+pUjEgCqiUDyFkMckUyA/QbsR53z1UvJOvBdnrr1/8P4zUpmiXOO+h6YsnkFr36DPhLBujxEpN3aQYe4Ipxyqcgdnw0xDgs1zI/qT7nosGZZDPTNkgzexhp1W9fWHY3eA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8017db4e-8ae1-4525-4853-08deebf1886c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:12:54.3258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXFdkm8zW5hBnp40XuF++3Wg4RwjLe1E0Fw3ZXt66rXQBc54huqIVnmCOC9kLciBLrPZ6+xQuc4/DV6TBU/nwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270143
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0MiBTYWx0ZWRfXzTGJ1w9jVlwa
 i/7FILpGvqbPuRF1ckYjFUFk3kiwJXJlKVlfhHmCmE9bBhw4FYSIS+jAWgPNiTzfwfb0WTfs66T
 C7VuXJgyug1O8lXiNGUcthXKfs0BqQo5pNVyXMeg5Mof3UsDnztNAZlkfTZRYLefAqwhVYiInQa
 qsFVcSYyzKlX6RQ7u/cQFgpx4rX6vHtMn/AoKmy9Ul846OQDHQA9OieTT5aNmDcZKaf8r07xofh
 eTIXFN8IIVQ8JKnFJwGxxG1cHAEIn9cMQylIiCAGtlbTx/UeBz5QgAlAtMsly/gQTQngjb68ITt
 fwUuxmcsmbpBuFgkgfLzddXyKQVjxLjv2d/ck8ry1Zy3G0FiCLRrTJWzDJTo+NQwNee+MbeNj/X
 NvsRjE6rNaZvnaXuM4Ks+dOQ5IrKrOlKwEnq7+OgTakpsi1twHaScDpuzVgPJTz0OzW4KTBeGAU
 IM8z4nAZDJIIJ3nUijaTIfrbW0uVKhqpAg8SHUSI=
X-Proofpoint-GUID: 5C_xZsjLOdYk6d1T9KkL75qfKgVsYU9r
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0MiBTYWx0ZWRfXy+/oPQi/5WiN
 YeN9wbndD6J8AyGFFVStTTjdWQuOgGiyFoKhlREAp+RmcLx1YfpTvBIO9MY8+q09wupysS9dwiR
 ypPH3offTgYzEZnt7LjZUJMPMKlrhKWe9XATc/xWcqW9yHU09bDN
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a67757a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=QAWhmqVCVhaQ6RvOsXAA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: 5C_xZsjLOdYk6d1T9KkL75qfKgVsYU9r

On 27/07/2026 16:05, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Low] The static workqueue `mpath_wq` is allocated but never used to queue work.
> - [Low] Missing `#include <linux/wait_bit.h>` in `lib/multipath.c` causes a build issue.
> --
> 
> --- Patch [1]: [PATCH v5 01/27] libmultipath: Add initial framework ---
> commit 10e613ef081274ac617a43c354384f9ddc32f1f5
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add initial framework
> 
> Add initial framework for libmultipath to support path management, path
> selection, and failover handling.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> new file mode 100644
>> index 0000000000000..9cc398d266adf
>> --- /dev/null
>> +++ b/lib/multipath.c
> [ ... ]
>> +void mpath_put_head(struct mpath_head *mpath_head)
>> +{
>> +	refcount_t *refcount = &mpath_head->refcount;
>> +
>> +	if (refcount_dec_and_test(&mpath_head->refcount))
>> +		wake_up_var(refcount);
> 
> [Severity: Low]
> Does this code build without including <linux/wait_bit.h>?
> 
> It appears that the wake_up_var() macro used here, and the wait_var_event()
> macro used in mpath_head_uninit(), are defined in <linux/wait_bit.h>.
> This header does not seem to be included directly or implicitly through
> <linux/multipath.h> or <linux/module.h>.

yes, it compiles

> 
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_put_head);
> [ ... ]
>> +static int __init mpath_init(void)
>> +{
>> +	mpath_wq = alloc_workqueue("mpath-wq",
>> +			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
> 
> [Severity: Low]
> Is it necessary to allocate this workqueue here?
> 
> It looks like the static variable mpath_wq is allocated and initialized, but
> no work is ever actually queued to it. Could this allocation be removed
> until it is needed?

it's used later

> 
>> +	if (!mpath_wq)
>> +		return -ENOMEM;
>> +	return 0;
>> +}
> 

