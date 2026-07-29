Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC79469857;
	Wed, 29 Jul 2026 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344234; cv=fail; b=DngSA2Oo+/yUOeHVw5g6Ix7Tzqzy4zIXSHq8KxPY8Tp9ZTpBD2U2XTbxC2aP4filJnFeFkVezKSvWiHgOd14TfRypvp6NyRVWfXlc62SRrqOcIEw0WeUiNB8xDx5m696BBAhP2EjxrEPOzy7Y5KrdjlGDXP8hmtsha0Esi/Y1hE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344234; c=relaxed/simple;
	bh=KfRth7NA3bskvcdSRQN4FnpolRauJiiaIxh1v8OpPN0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rbd0SueFokvp5MUrG3cPityusrVRWpGOm5mRqT/p5mDiWso5vmZqsQhz4gqo4208sYiPIIjImWxdou2NXVKKeu+qw3V2vHOEvRm7iBcRC4IxxrgXw/CYj667m5S3TgGP/RnOTZboCKrTY5RQaR7rFwrvCzPFAhlvMeG1CrqH3MA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fNZp+vKv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BeHni2kl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fNZp+vKv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BeHni2kl"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDU9WB3007609;
	Wed, 29 Jul 2026 16:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jAelzPj+D0YYZOK4c3TneqX0cYIt1yjVeVCugpS64Nc=; b=
	fNZp+vKvtfsXAski2bKAn01TR8E0lCRlL14Wo8l4nLWG3p0cfFM30End9WWxFSJg
	7QloSESeNBPclQDL4AB4Dy4Z5Nh+ofYjdmWD/MTPy7/yxDF8ZNkdNZS4q54oZ5HS
	Zbjk0cmqis8CDQkW0JnMGsFSRQwPGPrMmBAmy/CiXlpLNk1KTe+Ei66Mo/I+MgD2
	CIFiLeUwx7jn9J62eBcXlH+cHzokuguxJOGgpOsvtHkMsYs6b909MO6tbTg98yly
	cGOypq30lZUJrdCq1ELaoqpKGwrG7CTryTAH38c4YUHUEUODyvzv+8MUAnNQw7E2
	bt55B1834fk7kxhRiCqGDw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym68tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 16:57:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TGjAxl018443;
	Wed, 29 Jul 2026 16:57:07 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012052.outbound.protection.outlook.com [52.101.53.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh88ewyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 16:57:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IEF+Cjx6hRuxXQ+X7xLXFCrnj7DHIPtfwbM6CgpvlFtjgOHuYvW8zQ59dbp08gWseUJVgigufV4RG51I0VFMiigLNwwiEIAs/y0mnPTIv5kSYPDJ9+KSDFQ6Msye9aA0cp06OcKPj5fXhnBDkS4n3LpVZgdNnp0StwPEbTXZrCu/Nm/TSILmhvmIYdPMiF4eOESh232nXBqU1dCekEO9QvE6wGiKVLCii2XmYznHBV7uw8xAsgO/61tHx+9TFCRvRQ5c0boa0QZ65l0RqOC+x8oZw/mMccYtrqWL2E498lQ6VQdfD4YDte3GIocHEvop8Ar5vTc6/jwDZFHGzVumCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jAelzPj+D0YYZOK4c3TneqX0cYIt1yjVeVCugpS64Nc=;
 b=lZjP04PSrHXomqO9GIxPhIx/KStJ67AHM29SoZYJLhBYAHri08qB4v9d5vJ4tXrOfGEWgNiWTNkt/sirh+MXLKxIf1ILBuo38aFdb5yBOmCVjBKvKISK7tsYu28hwN4dolWzTNVq3T/wJkqQgJnJ0I+XyZlZ9C64/kdAUy8+XWHuzw1vbre7GlKrN5NNAGeUypWKFChMi0CDs4lxbtN45Gj3sA3jk7CXE5G0nZ3jgyg7yGTrvBlwNTIjbB3bbj9scEPEkF0Qa4wI0dpxGzcyuRdo7ThFBI6XE1La06Ql/ER/Yb1OzD0GiePq37qZofAds5Tu1zIOgje+td++BIAGBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAelzPj+D0YYZOK4c3TneqX0cYIt1yjVeVCugpS64Nc=;
 b=BeHni2klI51pRKoxtzB/LKu6Ga6LuT0ggmBkQj7U5Q5ljrFDS5aZUiZlpkXbFkcGipyFV3tbY7rfzmMhY9lwIr6AWVNHHQ9DgODZlAlD3DL3P4V06MzBAwFg6/28KdazfFD25EElY937kykUZIidyD0vN9nHlFpKNp73NIVqfF4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CY8PR10MB7242.namprd10.prod.outlook.com (2603:10b6:930:79::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 16:57:04 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 16:57:04 +0000
Message-ID: <1d126288-892a-4602-9f54-7aeb93a67c08@oracle.com>
Date: Wed, 29 Jul 2026 17:57:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 22/27] scsi: sd: add multipath disk class
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-23-john.g.garry@oracle.com>
 <20260729163338.1EE111F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729163338.1EE111F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0098.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::30) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CY8PR10MB7242:EE_
X-MS-Office365-Filtering-Correlation-Id: 306fa07c-e1fc-4475-994d-08deed926a3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|5023799004|4143699003|56012099006|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6tXpNCx3DkwDfuLAc7W6V/TSbGxEWiScYVG+qxRQUxuzjhfIWAGTGvgqFYYKcbMJ6M4uTNsQOxXCrTnJujzkJmAWMlCCdBnWM/IbFF/VlzO9TzL7ero6v5oujPb2pK5VGipKMXRPJ+3euv62B52mZa48EDXSiTnvYFzYI8vTI3PQqjpkJ8rSfIsGsbNwNTvQhYJUCCV+PrCHE/GbvLbKkvm7mS1MlPsyG8FnwPQ2LDqBdaU2F0ItIwmPczcVJMY/LgQOf1r+J5jNTNfDdFR99UIquLxZyctAsuunk6sxbuYYGaBucTxaPLwGjHSLWNGiJvjaadCL9KFTvNISnBApy8Pq8GXmsZ505laSfrC9ozfC7AoNcp17L6vqf37J42Q3zGmfiYmvfG5rv/TmoSHoGbC+l8O3Ug9oZIsR0HS2LRtFzSkF2eWbxKi9FOzLfUMvnbAFJj3BSwwu8B74y/4cyvaoj0RiEdx7N0siYqfRS7Cl0YHRRPLvYB3bmNBMt4+EOrmhcqcjCzY4e2LXv6OTVaBQo2YCChFQOMRW6PQbzDEgS0G+nTR4VL6NV7s4GCyN4SEOUw25+GMkP+L7oa0i9lUnF+P2GnsMqK6i9y5oFLx8NS2/+bDZ3VVIryoqzhr9wp3fU11/TQYmmJMjszUjMPQUbE27rzDxpmonm57hHgQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(5023799004)(4143699003)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2FKeDdkWHNEZmQ2R3VwTGl4anc0UDJKSURHa05ldzVkSEM3MjQ1UnM1ak9t?=
 =?utf-8?B?TzhQdHV4WFhjMzdCNXNRVGYyTTJuRzJURldIOUVwZ0psRkU2ZkM0Q2tHLzFi?=
 =?utf-8?B?U09vaXNNMGxvdzhNVks5aHBrQjBQbCttc0dMNlg4QXpUVk9NMEJmNXdDTEhl?=
 =?utf-8?B?TGVDcTBrVW56R2dTVjkvSmxJRURBWE0yUHRrbW9IUEVTdy9mekpHVndwZXlP?=
 =?utf-8?B?SFR6K2ZOUFBhQ3UrbU5vQzNFVG05VFlOZlJETXdOYW1GR01saU90U2ZaNDVN?=
 =?utf-8?B?OGJkc1ZrQitkSG16aW5JTDRaUnV6alVOT2gxWXQ2aW92OGRrRTMreDdjb2Y3?=
 =?utf-8?B?WUlTZncweUZPMFpsMldncFBwYmNWekthdU1iZ0QwWUFlU3lWUXd4L09pWnNo?=
 =?utf-8?B?N1FPYlJsRmhMUlFrUXloeEkzWGZXU3NSeDNEa2N2Sis5VHJ4VC80QXQzZmtt?=
 =?utf-8?B?NUV2SlF0S1pzQTFkbHVXM1h3QmsrcGtvSC9LclVRaWRQZU5ub29WeDcxM3pT?=
 =?utf-8?B?UG5lcGZCVmhtWFo1M0tEbjRibkFpcFJOQndleUFEMWJQc0FmSnBHRnU0Slds?=
 =?utf-8?B?VGVIVkF2aXdacUpDZlZ2VDFYaWVFa3dkYmtRZWpvd2t6UUE1VVZPYXdtUisw?=
 =?utf-8?B?bXlFM2ZqWnNnSFdRTUFDZFhUQStqVG1Zck1DUTh3VFJrUXBXUzR1SUZVaElL?=
 =?utf-8?B?KzEyeE1NNnU1R3FzNzhxUzJtcU4rU2l4ckNlK0tJazZBT1NnUGlNeTR4amlW?=
 =?utf-8?B?Z2dFMHJIV2NmMEE3S0N5UCtkSXA3NlEzaXVzdDZBRzE2S1hKbFM2U0JlSEQ4?=
 =?utf-8?B?YWFiMXY5clRlOERCT2lHUjJTd0daS0pLOHJVOEh3UXA2SWU5REZFRjlMRzlC?=
 =?utf-8?B?RUxIVXhvcElocmd0NHJzQ0xXSFJEWUhFbkd3bnRPUUdyUDVGUzUvbUY2ZVBE?=
 =?utf-8?B?SjlzQ1RMb0VzdWhneTZ2SDhRaHpxMjdZQm5acmVWeDVHZ2RDSkFTOVRzVThr?=
 =?utf-8?B?ZkN0cTNNTTQzbWFNRVhlVC9EV250dUJaNEFid1F4b2RyZjYvV2JtS3kzVkRZ?=
 =?utf-8?B?UzhWWEZJY2FIRWQwc3BZd2RxekRrTnpHb1Zydk1IR0Q0QlZvNE9KRlB2Tmdu?=
 =?utf-8?B?TjJiMjdiVCthWHkxSCtOQTVjTURsM2lxa0U5RGoyT1A4eXJMMmhqS3J2cHhR?=
 =?utf-8?B?bVoweWhkektBL3FYTXdxR2RUanhjQnUvdlBseFJjeFpNdE5HeXRvWXNSc3Rk?=
 =?utf-8?B?Q0JqMEVicXhySzN6ME1ncFUydmE4aXpPUXdOajZ5eWJuYzJGODJIU0NoTENj?=
 =?utf-8?B?Q3o4ZlBZT0lQSm1TZnArSE9GSmRMZkt6NHd1eHhhb0RESldPQnA4dXl0T1Qv?=
 =?utf-8?B?RExRL09Mcit1YXQ4Nno2RmhZMWhuYm1kWDkwYnkzWGROYTVpc29HcHUvMFN5?=
 =?utf-8?B?Y2xLZEIva0Y0WjE2QVFkeUk2ekppRElUTnd0eS8ramZHbmNlanRGcHF5VHNF?=
 =?utf-8?B?czZWckdGaThpeFZITE54TjBsNUxiYnV3Y0xHbFc5Q0NKYW94b1MyajNzYnhi?=
 =?utf-8?B?dFA4RU9ma0Fod0lvT2l3SUVra2Z1cG9VYTl6bUNpL2FzdjFOSFE3Wk50akhE?=
 =?utf-8?B?dS90d2YzVzJHK3BYeWRhdVZpSkZvQU43MzBlTmU3L29yZmxDQjNPd04xdy9v?=
 =?utf-8?B?UU1LS0x5YUw0b1VrUG9Ga2h2cUduWDE0aUJYYUJxelRLb25kcjB2WW9vcWVp?=
 =?utf-8?B?YTVWb2ozUTNvaFdFNFRnQ0ErSmVhaWYyeHV5ZG9RNnpjZHhJRU4zY21PdGV4?=
 =?utf-8?B?U2NTL0NnRW9rWDRYeXI3TVFqd0ZXS1JoMG5HYU1nc012VkhRVWR0R28yekQw?=
 =?utf-8?B?dU1KUG9NMm5BTDZLa0ZDUzNCbVc4RytVL016SWQrMmhHbzIvV0VFZ3I4K3RI?=
 =?utf-8?B?L3FuMXRCbSs0Tk0yRjhiKzJxWXduemtaZFBISkY5RVJiRTZpYVhzdEl1R2ta?=
 =?utf-8?B?SW53cFZ4Y2hxbW5ZWGFndkE2MW83TnRuNE5Jbi9ZVjNTdHMxbVFrRVBtQVBk?=
 =?utf-8?B?S1VYejFzc3hpMGxEbDhEU0xlZmNTSGRkRHFIODhtQTlETmFSU3l3ZHFEcGpm?=
 =?utf-8?B?Vk9WK05STWRXQmhkSnBEYXNLbFZGNXFzMjJ5di84dWdjc0E0NVhiSUxTeHpW?=
 =?utf-8?B?M3pmdnJlVnJkUXMrQmE1VHVQOHNNSWJVMnMrMnZhTTArN0NvVExMQ29yVk9L?=
 =?utf-8?B?eUNqcDhUWWlseERFVld6c1J1K0NVWXBoYmQxcjVnZENFMFF3VHc5RklWb2pj?=
 =?utf-8?B?K1VTYklZZHR2cVIrUmJXYkpQRFpZajNrQ1h2cmhMejR3MDRreWxYWjg5Zi9K?=
 =?utf-8?Q?Gy6UbhtVABebNSbQ=3D?=
X-Exchange-RoutingPolicyChecked:
	gdJspRLDRDRQbqjQU/1E/FNCYIVx0V/+BF96uQGHSSjh2uLDgb9rfEZwodAU/Oz2jgivNHDroBJZJzHBK8JQ1PULlYjuCd0iwLOj4CdlrFLJP+EjRvU2x5Xp4+sBgG6sdGfjneUGXuH5y+274wVgk3mGWl3++Wt2hf6sjrY+uV38Xi59rV1BUYNMhHXtuqHGMwli2cFlvj/5xgBOFDihfd50PBn9MhfwG4Z0CnxNmA86W/+rgIHebUIvZea36q2URzAKxGzVgC3yqIAd0A/aGsDc8Ezyysuo4Jkw0CkP0qR8Bqs2/RNDDei/iR8O98GEXkras+fjOHB6R4pxtX1Tzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	veX+rxbjUKJjixUn+1ntK2XWOut5MwM0YIfKlOYirxW8D07MQ294jIhKxdbCyb8+VN/2CijGmbaSz+LS6z47yWJWK+NWShSSiXUCTMX5tsSI1+rXn7f6SznWJPFrG4bgsbLsSdpw7BLjEwnGgPWsxIzT6JGfPnGrrs1zGjrlBeb+aZlwBtkB8vrk2B9pACDrGkMecxx48eyA3GY5UR9mZyvZW5WQJK6yyGI65joGHh7N5wPxX3X+LfOWB5IU2x4+B59s3vmUMlZuBNNnCYXpphhaJCT8wSUNGDlqjtVh9FwJR2pE3C/4ReHzj75yqvmwfEKR2msrTCHYIei8uQm7SNRFNYNn9iIw1+lT1l9DCQWTvIy2dzUjsdbo//XV8QrTiT4WXFruGYfmGcf44nwgpVKSjLJ118SAo6DqFQs1N/lnpcvSuK691gsPWwFH8ZbC5Cc8KbTdE6n9GY3VtJbRxyBh+EauUn23lj1Kb0rUtRmvuMw7dIrToMUxuB1T3oJcKv3TC5bbK8NOJlKYQLwWmXQZhzqeqBqxuP9kjIsmVRkd0DHkNlYRIiOTAtBhsPQsJYDpChAPfumzJGwnK7tpx4cHfUY5NTgotCWi+CKhykc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306fa07c-e1fc-4475-994d-08deed926a3d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 16:57:04.0747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /m43Gbd9ryiHXVhRsb4DrNCQG20LXWtYGeHNb6VHnIasDzaiGkYByFLZr6f748fSoHaebW/vuVtcDBN5gUQjAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7242
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290132
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEzMiBTYWx0ZWRfX0M7p3ZD9vd+m
 /ORpL01qsFxaOMYmxzkRSV28iInnQgEvv0h+wZLRyFyB1BGDUqYNM5oLVUGhKQ8CFR454iTGhxZ
 DQJMHrn6wJ6SjLISU6tq490H5B95gY1/B/lGzEwCO3iL6SDlomKw
X-Proofpoint-ORIG-GUID: uXBKn-rGFx3Dcv7Ux7UoHn2zYhHqNZkd
X-Proofpoint-GUID: uXBKn-rGFx3Dcv7Ux7UoHn2zYhHqNZkd
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a6a30e4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=Eri6SqDaKGsNzizpoZgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEzMiBTYWx0ZWRfX0tj22Rfzkwf9
 PEJcbuJfH7ts6dqWxLq4/cjbpNC10aYzIy+iQRsv+exlTMdwcFzDuI85vyh6KIoQthSczI2xxhD
 CXk6YQdf8nF8fyTfnJx2ysjkEU8aqBeI3mbhKW7LGJLLk4C0sX56G9NNZbm0q3cUfhu5ItEqwl6
 t+43HrPA30DDozO/nmxxvkWO9SuyskhefehmjhE5dyay+WwQG1AxprAPbR3HHdmDK0lRzs8hop8
 KZfUSLAEmJdNnv9ZCs/yLr/u+vBJQsJlLPEWJ5qTFQGO17nibOXhrfWXRkRK8dQ9wUGpI6H459/
 uR0wXv8xBysCmbXoLVlRRgyPYTGWQgvoHq7++1f3GHIkybHRUaZ3IzG2CmRzZzymdOdd/4cjhQb
 CeSi7VyWkmdw4vp+521MuRnsNB5sb5yUxlQ5ZRZ3rppp+rN5OR5pgD9ocCCSzxPmWZYJjYbGCla
 Ilag0J6WOjvpRkR5mhA==

On 29/07/2026 17:33, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Empty `dev_release` callback `sd_mpath_disk_release` bypasses device/kobject memory management.
> - [Medium] Struct `sd_mpath_disk` is incomplete and fails to manage the multipath gendisk as claimed.
> --
> 
> --- Patch [22]: [PATCH v6 22/27] scsi: sd: add multipath disk class ---
> commit f604e0ae8b45c7be3d202656fafcb45e6c81e7cf
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi: sd: add multipath disk class
> 
> Add a new class, sd_mpath_disk_class, which is the multipath version of
> the scsi_disk class. Structure sd_mpath_disk is introduced to manage the
> multipath gendisk.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 599e75f333343..242a15bc2c5bb 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> [ ... ]
>> @@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
>>   static mempool_t *sd_large_page_pool;
>>   static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
>>   static struct lock_class_key sd_bio_compl_lkclass;
>> +#ifdef CONFIG_SCSI_MULTIPATH
>> +struct sd_mpath_disk {
>> +	struct scsi_mpath_head		*scsi_mpath_head;
>> +};
> 
> [Severity: Medium]
> The commit message states that sd_mpath_disk is introduced to manage the
> multipath gendisk. However, does this struct lack a struct gendisk pointer
> and an embedded struct device? Without these, it doesn't appear capable of
> fulfilling its documented purpose of managing the multipath disk.

This is added later

> 
>> +
>> +static void sd_mpath_disk_release(struct device *dev)
>> +{
>> +}
> 
> [Severity: High]
> Is it safe to provide an empty dev_release callback here?

This is added later

> 
> When a device is assigned to sd_mpath_disk_class and its reference count
> reaches zero, this callback is invoked. Providing an empty release callback
> circumvents proper resource cleanup, silencing kobject warnings while
> guaranteeing that the enclosing structure is never actually freed.
> 
> Could this cause a memory leak of the device structure during teardown?
> 
>> +
>> +static const struct class sd_mpath_disk_class = {
>> +	.name = "scsi_mpath_disk",
>> +	.dev_release = sd_mpath_disk_release,
>> +};
> 

