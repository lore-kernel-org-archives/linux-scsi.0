Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204871D0F5C;
	Tue, 18 Jun 2024 09:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718703217; cv=fail; b=emv56bY/cpyLZ4g73SxxyhmWnir9kn1gn8LcpnV3Kg/O6gyw96bidJuvRf9CDdbzyzM49AisCxPGE6FgKuzd0xuD8oWXCRUU9j/TrYwiTeyqyVg/Bjo3LSkQorXagpHjePTZkBEBLRj0gzsxHIDuRmrlMIpve/wrmmgRWfAwYtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718703217; c=relaxed/simple;
	bh=j4qUQ5nFKpMHtfDDBu+x5S1eMHYmxGCFrCEUjBYcf6E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UECP9TC507EIpml9T/IHM9sVAltdeXWI7zFgQxX0wWPJvz5Ja8F8PHRbz3WPCBkqeEmpW2puSfyTFMaVLaaeY68CsfSthTgLNRej1iM7eD+2Lsvoh+wRKEcFcNvhrysC7KAxggtmp/BsN0W4W+ZHx5ucHp/lQc51uz3YacuJ0lM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PZLc5eka; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b5DoHCja; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PZLc5eka";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b5DoHCja"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45I7tbvx012647;
	Tue, 18 Jun 2024 09:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=QqrKmBSd2XlcFi3XYwarGj5452P5AIQfWOH9gX0w5Iw=; b=
	PZLc5ekap3Z9LnqsSBoWJ+FL2WZ63adPZpj0F14XNCAeFsFhF/gMHF0uRf78nvER
	oQBbF+bDZpRyWgMtSRa2rsZwked8cGXuUhWQwWTY7R1Gd2ggwrtTqFTRepHE4VKg
	qzS6BLWyHYnGoNc2jrnCTN6AeEEISENwjfspBd0g+2Cc7CzVDEyfvgpakVT9o9fn
	zc+Z3pLpS23KViC+Dx9g36I3yl9ZlkmgMCs7M3h0VyOVsLLPWhmSr+FqbHh0lZbT
	DLEcAM01tKwk9t2fihAXmGqcGAtp9et+0sTnGYnjJnoSGraX+KlWfNV5ucueWFrw
	D5KEueFPYb9E7GE/8fM/bw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys3gsmh0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 09:33:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45I8Ucol007273;
	Tue, 18 Jun 2024 09:33:24 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ytp8e4u8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 09:33:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpHJKUHNLFQFblizIVnu+aaivJlZ334eu9OOmXtqgaizqsHrJC9v8eeds3SIhbcN48mAJqUdhGM09VvFU5LlzDDsUbWdzdXWJSNlVwt8MrRNogFUci4K99uRtLcKTQ53RmDUyEbrkKm8ZRioyBXG+dcMfYfwbagLqG60bcOlReqlgm+dJNlz3XpQXr0+nenrJYnuID+IS1JfIB6lt/0FOq3sUGoCDwuYYfBStyOtNJ28lBXUU2ii4RgENL3v2xNNRaoRimfc7tElKgmB56i7v+Ljt/q4mX7AeH2dfCSP0nySF2ehWWSNZ6H8+/9MBB9GI09fc78Q9wbAg8p/NZhqHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqrKmBSd2XlcFi3XYwarGj5452P5AIQfWOH9gX0w5Iw=;
 b=IierayjHYiybT156ViCgDAf/3GsQiT4X2uCzzNqd1TFqvPIxGNpf+I3tELSLMlrNQqC31OLehTtbOwIQ9IEkJGMn7JI2ybcKTawjmKh7SwhYU6Cf8OrKhFgz+Xz5j+gLn/2ViIBaC+NXkfjpDrcRxvD9zuzRdKj9RouU9FoSoT4nkpFLbsuorGU49/T2I7113UHSiSNj7L38X04IcDAzN0rA5jfgteLHGTvKh5tNrhh8SdOtxYa/kXVkxsaFBcXj/nD74nimT9KxogvpwJv/H3jkViqETkTrnKcQ/wxga6IXYUMfcRmxSyzOoKlAXMYQZR+FU+1YkVKWAQ6bk6uBaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqrKmBSd2XlcFi3XYwarGj5452P5AIQfWOH9gX0w5Iw=;
 b=b5DoHCjaQJfjO4E67CPSkjR7botRd/SQA3qarSb+wFl8zdDOM+xAiNAumwCqVQB6F0Or9QNrcLVyomi45DK2ZJhP3/qNzfEjWgOkJlfeFZPN3ABR4LvzIuM7HYjJRvrZIX7/pWgrlIyp0fcqHNEqDXzChUv40cXNq4vKG5nngsE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA3PR10MB7041.namprd10.prod.outlook.com (2603:10b6:806:320::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 09:33:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 09:33:22 +0000
Message-ID: <eeece4d8-00bb-42e8-a7c1-7f05a7f67b5f@oracle.com>
Date: Tue, 18 Jun 2024 10:33:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Use str_plural() in _sas_resume_ha()
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: yanaijie@huawei.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20240618074426.97217-1-jiapeng.chong@linux.alibaba.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240618074426.97217-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA3PR10MB7041:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ded65dc-7666-4a26-9d73-08dc8f79b22c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?YS9oSXNhQnozSHRhaHo0RzhHNmRyNDYrYlpWR1plZUx2VnJpVEJVR3pCL3pm?=
 =?utf-8?B?bUVqaVVjRDBZSDJDWlRNa0lSai9QUldsN0pJaFBNZHNVNnlkSjlQYkRrNmF2?=
 =?utf-8?B?WWZEc1U2VS9UTDdleksrM3BqWUJiTTA1K0xLUEJURlJib3RtakNldjA5czRT?=
 =?utf-8?B?L2gySW4vdnE5bkNpaHA1WUNNU0gvRGk1eTlsT0NvZXFZV2pMbm95VSt5WDVJ?=
 =?utf-8?B?MHM5NG1rcVpZVUIrMlhtaWZNNzhyOXVZRmtLZlI1NTJseXNua2Z4SDdPS0tW?=
 =?utf-8?B?VGdpdTZzaWg2WXQyYllHZE1MWFh4bi9uakVwNE55WkNWVkwwNzZkMTBCQ2ty?=
 =?utf-8?B?YXlsMmtKVzBHVmIyYzB3VkhKR2g4dmRGa2tuR1RNenl3a08rYVFQQkw0aXQ2?=
 =?utf-8?B?aEZ5V1d5Q211dVY3T3hBZllPNGo5Mm1FRlZ1UEJOKytrV1RLYW9FWWMxVXkz?=
 =?utf-8?B?c3RpQ2x0STdqejFKZnpWbzR0SXprdmdUSnBTbW03ZGR3Q1Y2R09NenQ5Q0RL?=
 =?utf-8?B?Zk5IZC9hUUY2VjZVUlpaV0FWaGpZaHZkM0x3T0ticnpKSUdyNXkyZGx1alEr?=
 =?utf-8?B?aVJUNVM5Y29HU2JmZTBiN1BEbUI1SXJVbUVYKzJTUWMzeFBUMXFsZjFTdVkw?=
 =?utf-8?B?RmZqOWtrNmNHcGk5cmJvV2JQM1BVTEl6QWVZUFE0Ti9FY1BjelR5Y205ZFNT?=
 =?utf-8?B?VVdkQTdlWGtnME9ZREF1dVdHR1pkemNobWI3NUQwR0VDRkExWXo2K0tHR0ls?=
 =?utf-8?B?NDBSRGQyWkhldWRqU2J1Y1NLOSsyeHJraElrK0NwckVNWnpHUEU4dmhzUzRQ?=
 =?utf-8?B?bC9CT1JSOWRaeGVhYUpJWHlBRjE5MUl3RWtwM1hDRWw0NnFnQW52cC81NkZG?=
 =?utf-8?B?T1AzeW5YZ2J6YU1pU3JkYjQ4VE5LWGl6YnVadG5sN1hyNGlMaWhWb3dja3hv?=
 =?utf-8?B?bVYzeVB6QS9IQUdZWEtQeEdMZDdmSWRRUmRGMStKcmxtdTBKL1hiMjhMTFhN?=
 =?utf-8?B?dFdaNmloUWNtZW05VEtvOVVqS2l3bURVQ0lkYXk1U1dTQ2crZHhTRllMK1VD?=
 =?utf-8?B?Sk5IL3ZpVTdNejVHalY4N1E5L3FWNFN2S1VpcVZPckFISFZiREF1cTdtQ09B?=
 =?utf-8?B?WUdtQlBzNHdKUVlRVHlaekp5YURNK0dNdG1HcWtFN3lWZ3hCcXcrekRvV0V0?=
 =?utf-8?B?SSt1R0JuZWI3L2Q3aWNXVXNacFJ6NElTZTByZG1heTB1b1NSdDZ2Y1ZERThM?=
 =?utf-8?B?SG9GMFhHbzlJVnRKTXMvRDZHM1lUd2IrNENEbXlyWEVoRkhFNWtKSTlTeGMw?=
 =?utf-8?B?TlRJQVIyVTVISGg0QzV6WmRra0lDMzJMSm0xTXlrVVlmUElyRStOOFZmYVBx?=
 =?utf-8?B?TGR2a0dibDNpdWRJQWFLZ3ZiZXRabURMOWN3TEpWSFRIM2hmempPZHc4OTJC?=
 =?utf-8?B?QUNMTk5rTWZFR293ZENQdkI2cURXK1kvZ0UvSitOQnE2S0VnU0Z1WDhkMjZB?=
 =?utf-8?B?WVdzbFEwcUpVR0Rma0c0TFI5VXZwUUlxV2swVFFYR3YvREs3dzViY0ZCMm5L?=
 =?utf-8?B?ZGg4V1RoWjhpbDA2NjBQejVEc3J1RUQyVWFra3VQSHE0ZUd6S2NGcGI3UmFH?=
 =?utf-8?B?VS9WUS9TMjJyNm5Pa2JkUHhMVUtFYTBzT2RFYU02a3VSNVgxaXVyWXBjd2hY?=
 =?utf-8?Q?hoJhoRU/8l4DNt0o/xXa?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WW9sVTloSnVQMnNOdzVFRVprU2pnUy8xSXV5Y2U2RG1yb29pdzVWY2JKT2NT?=
 =?utf-8?B?bzQ3SFZVS2MwRHVVT1dsYXFab1hPZkFjZUd6TlJSRFAzc2k2MlAvaFV2dlR1?=
 =?utf-8?B?WlhSTkVGbm0rcHB5L0RFcVpIb2JkWUJ0WXVna3Q1cThzTm95VTAyczVDaUlH?=
 =?utf-8?B?MGd4bTVQcFFKYmtqYUFSMGZ5QmtkMmhhNGJ6eTlUQ3NybEU2cHpzUkJNU0Ur?=
 =?utf-8?B?VWlPaTNJWTZjYldlSDN6Uy8rTy85SzZhZlNMa1ZqbjNxeTFyL2NESFowRzdY?=
 =?utf-8?B?ZnJNSHV5ODdISnlsSDlrWnFaOU1DR1pYTDE2YmE3TEdTbVkyblBBVm9icEh6?=
 =?utf-8?B?aVc1V1ZjaWRiZjBtZm8yeEZvMW9sNFRmd2x5RHNHYVBrNDVJVm92Z0gwMUMz?=
 =?utf-8?B?aXdlNm53bkZDZXE3S040dzFocEJZMVd1ZnRHc0REK3puTGpkQVAzNXVMTGd6?=
 =?utf-8?B?eGVXMXh5NmNJTTZmdUpud2lEYzNVNzloUjFmWjdxZTArZTdDeGFOZzd3cCt4?=
 =?utf-8?B?QjU2US96UW9IOVZDTE1JRFpUNThtOHBocVIyejhzeWRxMlgyVHJaTEJ4Rncv?=
 =?utf-8?B?SU1kd1hmYnd0Z2JqenB5dFg3TWV1K0taS3lmL2orTDZyRjZKUUg0ajF6bG5r?=
 =?utf-8?B?dWFvQnkzTlp3RmdMT3RWYmU3STdUc0ZpZUdBQkhEbmxDazRVTGcxYWtmWTl5?=
 =?utf-8?B?K1MwODk3bS92dnowS3AweDY0WHlEYkpUMHlTQTU4bzl3QU9RT0VGTjFxZXZM?=
 =?utf-8?B?R2FkZUFBWUFDaGVmanA2aHA3T0pmNlVNMmNycGVTLzJJdzBoMHhzc2pxeTVu?=
 =?utf-8?B?bE8wY0k1SlJwdnNJWnUvYWs3cEtHTmd3YVUxOWxyOWJ4RHRqZkJoS2dIYTM1?=
 =?utf-8?B?czR1OVZuWEN2bHMzWjErOUhKakRPZW9FUjFGZWVXNEprMWFzcjlUaEl5RVNo?=
 =?utf-8?B?bmloMEcyejhvYzhJcGlkMjhWOWlHMysvcnZ4NTNOUWlSN0l5UFlyTTB0QnNh?=
 =?utf-8?B?WXhJOVplT0JKaDB0eUJXTUlEVVNJVUtyWThlSjFsYnpNdjdrei9Qd0dwWDE3?=
 =?utf-8?B?aVBTdVBpbjBBa1kvWWxGV1B0WmJYU1c1UGN2WjNiaVV0STlidjY2SHdtQ29n?=
 =?utf-8?B?RHkrYWZDUFloRVpFTGhiYzdFSlVINkRHeXJORXorOXFaL3VMVEtWNVdwR0xx?=
 =?utf-8?B?eEwrN2dRWDNLRjdXejN5YmVnU0ZzdkVzdi9MU2RGVlA0Tk9iVU4yb2tNRkZr?=
 =?utf-8?B?Nk1LeWpCY2ZPdU9PM3FGUEFKd1RYZmJVTVdoZmlVZmZuWlRudlh5NE5Oank2?=
 =?utf-8?B?WDh5ZllIbExPWVJDSE9GTmxxV0RaNTdWNXVGakFpUGtiKytTNE9Vd0ZVLy9j?=
 =?utf-8?B?V0FmYmNYdS9ZaHRHZ1hHWFhnZzc0dXp5WTdBbEw0b2hYQmNGd29nT0JVQjlY?=
 =?utf-8?B?MTErNjg5dGE0ZUhHdGJ2cGxHbDhCL0tGbFNTOE1nUEphVkpvQ3RTV21yTERz?=
 =?utf-8?B?elJBeVcyM0IzS1FKWjFzdEhVcTNIRitTM0k5c04rOVNwWUE3ekd2Z2Y2endO?=
 =?utf-8?B?ZERMTHhPUVNGejlGVW1aaVFGR0g5Qm91RFRKeFlERTJYOG13MVlPbTZjNjV5?=
 =?utf-8?B?Y1dFbGY5cW0rTXZOam1RL1N5VDFpUEtkby9qeHkvdE9PUTF6MFlDNzU2LzJP?=
 =?utf-8?B?Wnd0SktYVGt4c1Arbk9DNDhKQndscGd4N2pGeEhsbWtmTHl3dnVFU2ZSSFRB?=
 =?utf-8?B?U2kwRXdHWnJIQWl3aDdaNisrcThGd1ZLNGVUdGVteU9SS0psWkhCSVZHVUtJ?=
 =?utf-8?B?VHdQM1l3WkYwSFVDT0M4dSt4K1BZdkZxSlU2amd1SUZxNVV2QjExYzR3WEZY?=
 =?utf-8?B?RjFtT0F6WkFVbys3OUl4UTM3SXhpNHhPa2l0dlhId0JMT1cyTERmWVZuUGVz?=
 =?utf-8?B?V1cxNmI2MGo3UXp1ZUFpQWRPK3VTVUVEcEFMQ0YzSVFZclR2ay9MOUtBektV?=
 =?utf-8?B?ay9aWFJLNEZWSlJ6L0FlRnE4ZTVmUGVaNDN2b0VUZ3ArOHJESHZ5czhveEJ1?=
 =?utf-8?B?dFdWNFF2dmpyU1Vka2hBbXp6NjJRSkNXNVdSbGxGazI1S3ZSbGtUeUxQckhq?=
 =?utf-8?Q?Pkg86eds8X3vDm3Yjn+hoTfGE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lXk7BmJ+6yn/WZN3zpZuPi31XyWilUOEN0TdHg376Yr91WQry3mvFssuahlxSsCncyrX2Fwuk3vWWpw6RFkdhqaxcM4Ks9PB3qu32jvbQvurxClXOOWQq2DMmA8Chzpv1SxEbOEV5AT8Ag8TIhZS/olFb+lqoPLK5AXwBkraAIyfAdS79Q4WChCerhy6sHpPu2MnYNtsBHkoaRh21+ATRsxkc+mm8VrIBbz/t3/lMRWvyRxvPHyYOU3hDycaH5egZ/LPLjqypaDgZ909Gi1MopCvYt9iap4XNvrb22pUCNvRHItzwNvWXWnC43aD4UpUf9PFMjYblhh5DiOMwUiYaSjwvoTvZgit5P100TyXlz20PZIrryrGllWroLF2f1RGqE5NC0M4I6tyziwN9YelN5O2V8ZRBsImJiWXnccIIj1geHwSPNuS9ANwaTgCu2ZFDR/qsqSUrQMczvQuJZvTAnmJcpmGs4bMlw6d8bRgIXbpuFPHCTUwgeCirUx0z8di7kKRnwXwKjP0YMCVJMCVItsmhSz6cdHSPY2XYQnViqReYhP8ACsa+bHee+lDgcEkNLVboPdDTcm8QjpvdMboht52a2E8apl92jQC2Y1AB18=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ded65dc-7666-4a26-9d73-08dc8f79b22c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 09:33:22.5644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPaEq1FfFiGBgG4ooq+hE2bCjkL3/BiLd3HXdBIsf+n0jt/bKcgfG1V+oR+CyS+8/4fqhuLKj8jtYHdb8TNdSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406180070
X-Proofpoint-ORIG-GUID: BnXeeAOfj29VotiWSBCp6E7gqLGBzw1U
X-Proofpoint-GUID: BnXeeAOfj29VotiWSBCp6E7gqLGBzw1U

On 18/06/2024 08:44, Jiapeng Chong wrote:
> Use existing str_plural() function rather than duplicating its
> implementation.
> 
> ./drivers/scsi/libsas/sas_init.c:426:7-8: opportunity for str_plural(i).
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://urldefense.com/v3/__https://bugzilla.openanolis.cn/show_bug.cgi?id=9351__;!!ACWV5N9M2RV99hQ!Nk42u-g6x28V1UUeWge3hrl1nLg33NAY5X2JMyTeC3VEMsYPh4q3Tr6OYXMtxHEj16ZsS_-eV3fHIvS5qevQliZxzvj9NdOu$

I don't see why the kernel commit history should be polluted with such info.

> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   drivers/scsi/libsas/sas_init.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index 9c8cc723170d..67017c03d4da 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -422,8 +422,8 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
>   	 */
>   	i = phys_suspended(ha);
>   	if (i)
> -		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
> -			 i, i > 1 ? "s" : "");
> +		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n", i,
> +			 str_plural(i));

Is this really better?

I actually think that the following is preferable:
"waiting up to 25 seconds for %d phy(s) to resume\n", i);

>   	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
>   	for (i = 0; i < ha->num_phys; i++) {
>   		struct asd_sas_phy *phy = ha->sas_phy[i];

