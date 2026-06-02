Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFD4373BF8;
	Tue,  2 Jun 2026 16:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780418588; cv=fail; b=inr5E0/pk2swOEJZ4XyiI5weaAWqf65l6uVD1hyOZKWzrGqHNx9tm+XesibPqoNOnp91Y3vb0w9VOTi01kHUbV2NT/sNid1OX9EVWLrIggFPfafs0ap4tQJKXORZYM6UzgjgTPTGgT+Wwd8yiqsUvPcqugF52LpkrOW9N5oAd34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780418588; c=relaxed/simple;
	bh=Cl3UAdruvNyV3VqPP+wq01h+BLSV86yHwCvFs4tqJks=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZNSGQdgSQXxF0uoUhDGo2/uGNj52BcowOef1/wyNmpLXTdcRgZ2MQsMSmCDcqYIk4HA2+AR3KFe+hRQ8bRtPbk4Uu10MDjOITCd5uNPbE09cRNsCRDfVnRgcbfFiveVAHmMVQ7JE+fi1N1VxXYV3o7Fhls45U0rSiMYTFEB1/YY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lqE3b/BF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VZWDT0IG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lqE3b/BF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VZWDT0IG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 652GMTLA3515628;
	Tue, 2 Jun 2026 16:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7+Pg1vpCywUZlbIJmNB5QGEA8ScvTcz4pPf7fS9JE8I=; b=
	lqE3b/BFhUv1U5TSaJPnJ+ukX/pTsZTKRjUvHMJ6RRpzGFjTbr0qHl0CEn+o9Huj
	oqyHnse2xczgZueN4pNcHy1+gMrbAwx7+6e5tCzwtSYVUbbK2l6+iub6+0AW2rVu
	LUlUhGFBMf7HxPEvazn/qIMEQa0q2Y+BMahT8iR/zO5gnxIxUDDGTF56OTi2SC0R
	VpQ/Din8DjU6w89qCUO65puGO1A80IJaMgesYJAGRiDyEaQKt2VszlWocLFA5MPP
	RdpHN74rn64YEesbET5bCixE4XaCSkBoVLLZKTr2uzTc/h5+tfNUo1GbWZ19R4eC
	5/3iIECtCywll73BaZNmLQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpp1vk9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 16:43:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 652GZMQv038402;
	Tue, 2 Jun 2026 16:43:03 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbrd4xb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 16:43:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cRKSsD2+QBOWcpZI1TLSwjWhMAlj1vNeX0urjoE5Wr2d2bQBWeY2ltBivf6wPBwObK7tRG/Zz9wn8uOTTuNnUIDFMsXoHGqJTPFgnx/zwBX85AxJ5r83u7oYL4EstPtnkfZAf+0BSzXYNVAdx2Nb9QqRvSw6+5XwMpa9yXDeu63gTMXOobUrUuX4DWmC0LWIhNywgRlxKrvy0Tr3rvQPpS8kys71LwcVV0cOQExN9jtmAD0E4oTz8awZsbwtfbZNd902TeXzJCdNrGewnDskEdIhlqgaN40Ydl8YQv0I/dpDYxn+VUEUCP8QYg3iWwkNOnoiA2hm6Thet4KUD5FOUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+Pg1vpCywUZlbIJmNB5QGEA8ScvTcz4pPf7fS9JE8I=;
 b=ZT9ri7c01Us5XgrLYoWvoujs42qcKaTccIQ2aUNu/PREIeUFgP18q6yAWsVP8hOxHL6OXw+jruiyMFB831E+zSu0jG+hcze87LXrsqOmVu3DPsK7mHjv6/yt1pKyPUBzl6WDU/Oc+OdMMm2qqcRcEEOZl0vW2OqzvNyRqtZDSzBxhavT6q4QiTMHY8qbyPkcY4adyiLFcggneURPVbUrWJOncrXlZ38UCU8gG6OhVIfRoRBd64ySn1tTz18kdy00D1Qq2Wa7BRzIB/btwogB/Ok4TMp3utPHWYxD3h850NlaXDqPtZylmwxKFUVp6G+OUrD6Sk9ZMaeGPkTL6D3UNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+Pg1vpCywUZlbIJmNB5QGEA8ScvTcz4pPf7fS9JE8I=;
 b=VZWDT0IGgicyaiugma/MyfHUioxTUTQHjsBbfvUUHP0iONGSQJgA1SGZR40IrCNb1gQdrE73Hd0ItftObxPCqTxseSfjvmqWWo3Wxn1QYYyYp+Ig1PIFStxMDqJCe82AAchtjy50D1QYrxvnDzRl2s1RNCkhZW3lTcBrJggdBaU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH3PR10MB6857.namprd10.prod.outlook.com
 (2603:10b6:610:14a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 16:43:00 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 16:43:00 +0000
Message-ID: <d8126fb0-85ac-4b1f-b6e0-b4e206ec90c3@oracle.com>
Date: Tue, 2 Jun 2026 17:42:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] scsi: target: fix CHAP_N handling
To: David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
References: <20260602115840.26490-1-ddiss@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260602115840.26490-1-ddiss@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0144.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH3PR10MB6857:EE_
X-MS-Office365-Filtering-Correlation-Id: 195fa60f-5b74-4a0e-1aeb-08dec0c6020f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099006|4133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YZ3hwI4i29uV/UPxuAeUoWxABmnInBXye08MR2jjOJsx/Auwqa6mTU6NDXx1TugMvykP/KXza3+2mslbw2vcc3S5bQ2s7geG+gByYqPgy8wZyO8Eu8jWtwN3gHUH8DzU+mJVkLit1YbPLqbeIsnJyVCXJYCRbbkq9hJGShRIC0vZ5wQQIxcNfVnHmV165mNTXVTo7zPS2LO0ZNjL4EN2XkVH5cIG+egKOM3TZXzztcA08fFbp8EBGZ5l2ytFBkFJRF1mA5l/lXtA640UgJQlXtJ8owsfIBw7o/Kw3Cr/rH28S45MxGKynK+KuGl4TjTvn7vcT66+0F0kA6w6xUvuHV4rbYYxtytVPvbipLDtXUvvxuwbU7nvrmbw/x/3qm+JytBzMjHWSujKYYQT4j8NcfNKhqYh2N7TLNgx/RrtD0XnG1APGX1S/+6CjFpHsVDGvIaJrxyVcl0GfadBrZerlQ7ihZ44fuwnW0KZYH2C68E/Zf43NZTXqrpPwWgwv6hS2tIFsgPadGUJkqaNaWyoAkUHn7yhalZyvVNUlJSCoppjO3ICOY7KomENsoN21XdmyJnZfpFCUCbSRsHjVA4uKzC6Pdfej/YdeQuH9185bXca09NBFqh0gucNxYryre98
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099006)(4133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rk10TzJCRncyYjUrc04zU3Ruck5zK2xwSzZxZUFiTlF5LzFDTmU2Ti9penBt?=
 =?utf-8?B?R0l3RHFwSmJTT0pBanVXdmZMcG11L2FrOTg1QTZsd3lMbExxWEZlRnRKS3pY?=
 =?utf-8?B?SUNndEpkY1QrVnQ3YXpjV01iWDcrdiswM0FkK2tiM0J3YlJSbm5WYXFpS1Fq?=
 =?utf-8?B?WWRubExiQWJiQXlacVQyNG5McDV4cFBmbjdSa2NPSW5aekdGK05icjdSeWNF?=
 =?utf-8?B?NUJteStkamNjTnRCckswOGg3dFRrTWxaUmdkbnBMZ0U2VzhWT3hKbmI4bU13?=
 =?utf-8?B?ZXZMYjhRRFN4QkJaYng4TTZGdjJvY3B4MkY2eEdYYVhnMG9CeG5VM0lGc3N4?=
 =?utf-8?B?MUE5aTR4dHl6cGJ0ZE8vTUxxeC8zZE90M0lsQVhPT1htdG9CNXZzS2ZabHZ1?=
 =?utf-8?B?RGVNejBhUXZJZW1DazRwRWxTbFU3aTJydVdCeUFPdzRuZy9JemdOcUZCY25k?=
 =?utf-8?B?c3pGVkV5TDhxQlZVcjdURXVMSWVMUlZIWHMwUlNOVWFBdmJwOXBtOGZKSnlw?=
 =?utf-8?B?WVZLcDdjN0hPZ1hUVlhtVjdNZUxuNXo0VURiR002V2tweWg1WnVXZ0J5YjIy?=
 =?utf-8?B?bGlKSmZ2azhydFNoVW4xazB3S1FuaUNsN25JWXhXR2g3ZVVvN3VyaWdDOHI0?=
 =?utf-8?B?alBMbGtoUEtPWFZpS3VYMnZlRFM3a2FJeGplcEExK1FQdzN2c040T3lkQXFF?=
 =?utf-8?B?WXBVeWhhL3ltMk9OS0JEMXFodXFablRWS3pQQ2pSS3FCQm84TkpydHNBRTFR?=
 =?utf-8?B?U0tLOVF2VkFwWTcxVEdTOGFEZmFFSnJZdjBqRXRTVHJDUkJVTk9DbzJYVEZs?=
 =?utf-8?B?QjVQOVpPQVdvNmQ0YklXS1JEcUcrdTFHWVJ0ZEo5Wi9QWkllVHYrb0p1Z3NP?=
 =?utf-8?B?bVhja056WC90V1k1WUNmUVUrV2o0MXVLWHlqMElvUWFNbjlEcHJ6YndITlps?=
 =?utf-8?B?S2FjdjQzRWpabWdFZG5yQ0xoMDhxN2N1Q1lITVA3eWo5TDNwUDNKM0dGS29a?=
 =?utf-8?B?WjQxellmQXRVZXJJSEhWVjhWQ0ZHREhQT0NrdDFleFQwaVNacGlwNEhxb3g1?=
 =?utf-8?B?bW4vVkUzSU9pZ2RqMWdmRjdtYlY2L0NyVUlXdkxJQ0YrZ0x1SWI1S2xXMmdi?=
 =?utf-8?B?UWZjVWJsWHF0Z2l4Z2dLdy92UDd0YnVJeXpWNVRSQTVZSHZnL1U0UUZmVFFq?=
 =?utf-8?B?Y0pvSDI2MGFsL0lqOFZsNnhwcm1VdXdLUW9FVHJmcVFNVm5rSFV6dStNM2VF?=
 =?utf-8?B?NTFMWWNvcWpURzFmdGlwS2UvNE02aU1qaFhTU1JSMXUzQlZqYVExKzJpMVZn?=
 =?utf-8?B?eENWdElGOTJvaTVYdSsvaDJNbi92SW1wQ0Y0NGVuajB6Z3dFNldKcU9pT29s?=
 =?utf-8?B?SUswYWRVdjgrS3U4QjBlb043QllDN05wbkFoem1VMEVsRmdicTNTc1hpSmdl?=
 =?utf-8?B?bHQwb3Ixenc2NWtWRmhEVkcwVDZ6aUNYWWZocnhEOVhzZ0ZpYUVZSmY3MFlD?=
 =?utf-8?B?UEltN2VjMHVUb3Q1VWZwZ3cwYnlla2wwdkxuRlZLU0JMQzZiWlRqMmRYejQv?=
 =?utf-8?B?NXk0L0JZUmVObVMxaTI3QmZpVUhlYTRmK0pYa2thZFVaVDliVnR4REhWVGJW?=
 =?utf-8?B?VzNHNXM0aXJaUXpiL3VTVDc4aXNKbDc3S2RRNnVMa3F1Nno2dWhkYjhoMXlz?=
 =?utf-8?B?d05EY1ViSXNJOWNzTGRyVlA5eXRucWIxbWNyY01MbkZIL3hqeXZpcEdWQlBK?=
 =?utf-8?B?RXhHZEgwaXlJM2JQU0VzTEJCUTlnRElSVm8vL3g1LzJYVld5OW8ycHJEUEFT?=
 =?utf-8?B?Y3ZnRlBjVDkzcldabUZSRXJkRGpEbG14Y2xoWnJRTUhHdG1BUEMrZjB4bk9B?=
 =?utf-8?B?OXFmY294TkxPU1dsaStkVXdLUUgrS0ZkeTFtUWszd1VuVGlaL3U0KzQ5TDI5?=
 =?utf-8?B?ZjYwMVQvakZYd3NkQ2UyUFFwSHA2K1JUZjUyL01ZMzE1c0hKQS8raTJkNHU0?=
 =?utf-8?B?UkVyVDhYUjJ2blBBTXlFSzcrR0JLa2dwaGh0MW9DenpUcEF1UHp6b3FjZ3dW?=
 =?utf-8?B?cU00dGJ6dnRhZEpNemFPYkJzbS8rVkJVSjlsaEdLaVRQaE4wRzlJSG5id1Z5?=
 =?utf-8?B?S1dOUW85bXBIVUwyOElzUXNwOUhmTkpQbVJtMnk1RzgxWGRIQUsrUW9tajlH?=
 =?utf-8?B?STl2ckxpSTBhYjJhZTZLd1J3NzdQYVpMNVVZaUhFWjNDaFhKQ1liQVhKeS9O?=
 =?utf-8?B?d1VLOXhJUXBqUEtuQ1pxczJKRWJYN3gxelIycncrQzNUT1RMZTJkKzBCSUJp?=
 =?utf-8?B?N1YrOUFLVldHMEVMekdzSHRZMlp6dzJodmQ5NGFGVDBsV3hxZDdudz09?=
X-Exchange-RoutingPolicyChecked:
	OQ/EXlEIAq65v2mnByZ4DgzVukgASrNaxOh9X4NLAdi5kdn7LnGF9TnFTWFPC/WRQRcbvBNg9W3VL1k1i39uKr9L+5F6WjxmUYh/7XhlcMhOBJYFOu5ShrGamR9n07QMAPpzOsTz1zxUo1qLfwdxPtNZxgF3dCa5JZ2uSwcwCnEim3gaysAkI0x2r9h3jUr+FWQMl/xSvfp1TBv/Lmxhw3lVOq1MMUvil+pz5uEMjECGT/nWKkvf21tddr7A0h54+FKE53dsGDzS648CKV7p3bq2F5HaYuZ8w1RTg+0AarZq/okS1B8AD5unRDvoJmBOFg2gjXD8HczWRSiT3I8vKg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ToDbfvGSxMbuMr6FtHchOWJXNFS54NNzLewQXGO8KN03dzgaB5zLDucvjOkzzPg/fJ6wsiRm/16xRfaxnMPH4UQJq+QV3un1uFiHVcI01IMPKpt2lHDheKLeXwo8EC4ZqGwVFFZ/HXyJGp3z2Hx99DclwWyCJKih80iHjxWtmIPTBcLgb5mm+8yOrYE13c5WudsODi/Bh2qrAa1E80SaFM1Ffu5xTBQBr3ZFL8SlsG29alVrHUKlOcw6dhXwsZQdliK6g6HX6QV8N90JSfd2S31JGFi0G5F31CK3qHAt9iUEiFk4Hz9LUJrlJhuzybXqm+lfEYTU6RDLrodeh2PgSZdjzsc35eOzIHfbcAXm6tRFEZMgUyQ8dsrL55M+KP7H7sd2lKSfulxF37UqY/b6R2htomp2U1ytaCsQciOIPTfSZNAYS8bGZHorqGoN24sHf1JIj62rNGqzye2nOJYcEIzmahGEPWdUFv0wf7bCLQfUKmLKfCJWdUcIXtdo9e0yWS3ba/itywhPDUgKE0pnnrsovoVuwGuXB3/R5TRlgDVU/fDWejImDVe6YFeekKGLEy9v9MIn5tt1duBox6b2ou+Tmz4sSYaMQTfsAVjlHBs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 195fa60f-5b74-4a0e-1aeb-08dec0c6020f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 16:43:00.6778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WUGXUWao8GN/hm7brfFqwJWXKzXNiKE3JAs+6MCfAqzgRnvPGsuzBQI2PIUM7LqTQIHjQBabLzT+Wkpv0rZhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6857
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020160
X-Proofpoint-GUID: YS6X3selhrZxhBhmWpwVCZUJsceePL77
X-Authority-Analysis: v=2.4 cv=BMWDalQG c=1 sm=1 tr=0 ts=6a1f0818 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=c92rfblmAAAA:8
 a=pGLkceISAAAA:8 a=NEAV23lmAAAA:8 a=9Nlmk0GUvUzn3b8vrQAA:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13714
X-Proofpoint-ORIG-GUID: YS6X3selhrZxhBhmWpwVCZUJsceePL77
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDE2MSBTYWx0ZWRfX2AJZ0gqJ3u0M
 dxtixHnUwe3OsiLCHNpfl7nCnhWkGycai2feHyLu9dCv7t8djc2Ay1kIVojF14W9qvsjz+xSNJ+
 dELOs2XvKcYzhRttGAmFA4YUu9Lr88uRtRNJj4dNzEEvxYSPEqr6LHA7C1NbV+2v1XocbT1YTwn
 E/fMBLNWZS9e7QwA9vyJL2gq8/7M1T0dvMHQj0KU/wadxTUqXykfJS0o8x6gvGiFeJpQ/Cq+HuR
 fyzhN8UGHpz6EPkL5VSxC8zM/VCzhBhU/LH2/EHiDpdBmm7H3vcUiI8UAHiqQvbs2DjrV9MEBjJ
 4fwOCJvnsupZ7bk0hCFaT949MX8MF1sZ2B7WwtaGW9pjo2pB9763yw1U9qSJMB7cIE9cLJcl80m
 0rRaEb4fz5FI4Jil6A/16HVlV8/vUnYzVujFksUmtnoL2wWVrrty6Uw+RQe/t2L3pSGKA5/qJWw
 RmeHPcWaNfg/Sh8m9WswW9lvvLAR/cNp6m1jYqjc=

On 02/06/2026 12:43, David Disseldorp wrote:
> The sashiko bot pointed out issues with CHAP_N handling recently, when
> reviewing a patch for a separate issue:
> https://urldefense.com/v3/__https://sashiko.dev/*/patchset/20260521151121.808477-1-hossu.alexandru*40gmail.com__;IyU!!ACWV5N9M2RV99hQ!MNesZJ3IsH9Mv0iZxHUcVmbC_3uwDkJgMhAX8i1TelyqqZD_dAq1cwIy6RtYI8D3boJh5iFeGhtTvfTX$
>    Since extract_param() unconditionally strips '0x' or '0b' prefixes and
>    alters the returned type, wouldn't a valid user with a name like '0xalice' or
>    '0bob' have their username mutated to 'alice' or 'ob'?

is there a real world case or vulnerability being fixed here?

> 
> I believe this behaviour is contrary to the iSCSI spec. I added some simple
> libiscsi tests to cover prefix stripping:
> https://urldefense.com/v3/__https://github.com/sahlberg/libiscsi/pull/472__;!!ACWV5N9M2RV99hQ!MNesZJ3IsH9Mv0iZxHUcVmbC_3uwDkJgMhAX8i1TelyqqZD_dAq1cwIy6RtYI8D3boJh5iFeGh1A_gMb$
> 
> These patches attempt to fix CHAP_N handling.
> 
> ----------------------------------------------------------------
> David Disseldorp (2):
>        scsi: target: add extract_param_str() helper
>        scsi: target: fix auth when CHAP_N carries a hex/b64 prefix
> 
>   drivers/target/iscsi/iscsi_target_auth.c |  8 ++---
>   drivers/target/iscsi/iscsi_target_nego.c | 37 ++++++++++++++++++++++++
>   drivers/target/iscsi/iscsi_target_nego.h |  1 +
>   3 files changed, 40 insertions(+), 6 deletions(-)
> 
> 

