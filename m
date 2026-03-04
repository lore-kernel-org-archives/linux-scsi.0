Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41A7C2FF;
	Wed,  4 Mar 2026 09:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772616064; cv=fail; b=E4lWd13mfh2C90aiVVn2f0Ei81A7Sjj8aj3NmqMjpA8SybJH4TGc6q6Av8hhQgaSCrh7hzy/ld0QSpK7h3LuDN50Cx8JftxQkNnqX3Jwf8g7X130fSu32ZsAb7AxWz+Wk8LIe58FZ7AXQ20lSXTtdGctyAkoNX5uNXogWBNsUDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772616064; c=relaxed/simple;
	bh=w+d5qp/GHl9tQ5E9EJw1Od3C8b9M66TXEv1uXJrdBHw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AAnkveASr69aFAKbKWCcQq5JLllSEXHNcO6lCUFmlPO7hqwbXJGfpKBUKReaV03LqIiYzeYGC9S96ireFHhKEF4PR6RsKtmsgGQhoBQKc6ktF6tzKqrwg/ETTxpoGcTEYKXptAfoTGC61E7+PiLQjDxOYyN0teg0ouOBZPdaLNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hG6z+auQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qidvGKJF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hG6z+auQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qidvGKJF"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62497skr1979327;
	Wed, 4 Mar 2026 09:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZQO6G2NxH/MpB/aLhwOLhA0TYIOsEZsNxV78jiLBQDU=; b=
	hG6z+auQ0PhxfvCx5k+J1ijZBNnKlo+7IFJ0rkGnMNvyLPr00kh8W5ALSykc2ZyL
	fWi2qtPGIogq3ecoY45VgJGKB/8qE9/t0YfaGsAba05mcAxEIJIFiU+fmf8XB7QE
	PDT6LoCKA1M7d03DPEZ+CgDElvOHM6BCrGhmRKlq2ff6xKBUjCIER5AcNUJab2+I
	msVZtDLJSK2w90weXjtooMrK93u12mbIcUl6huzZ7BHueEmuZ6BZ35T2D/acYzT+
	Dx+lRyf+LZZ87Tn/fDBCx8fm3pzF/xsMerL9fZscfgoKDk964m6vnMCdthJoH3Ol
	TXffqkikJ8o1GISGoZexMQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cphu400pm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 09:20:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62489dAk023035;
	Wed, 4 Mar 2026 09:20:39 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010061.outbound.protection.outlook.com [52.101.85.61])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptfu98n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 09:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jd9F1dH3A1wOhfDyAdlYhHiTaeZl1P2Oj6qT4oA1nu/TlS3ZjdTcfB/SOtSHAeLrPXgeN//9Y4icyNTreRKmYxmP45oGwuP+aZktn8B38RGJPqJSm4TX1eYiIXVkPY1JAhBLlCJxUEawaXMETS0dI80nUvbLJROdljeSjF4/CKfl4+5zJMiGu8qbY4RdiixxQkA1iqHV3Vx6A4vAzEcaRcdz3Wo8P5J5r3PMkTMS++yhP8br8OJAMec4KAIZscNtHNCKEVRn8l69x25unlfd+mooxfoshkYf+jQJOGXzgB1pH9bd6URlABAj/YLNLwOtQ5DefwmQf8l4/7UkQ5uqoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQO6G2NxH/MpB/aLhwOLhA0TYIOsEZsNxV78jiLBQDU=;
 b=Y8z7ObXlqRzWAO122Hqekv7FHL4PWG9KwQlWrOiyBWDbIMP9T7m28HWtyqubKjeQkrMpMgQvpGTKL1rmCx//uj5tfKRtf+W2VFwkW1iLLLeLoljLjiIKGxlcNr6DsOfYubp94YJxdOrMi5gd4qGJl59Cfny2oIlXQrqBiTH1rYa2D+OAC//975dTGfGbcAzOMtfrGE/nIW63w0xS/flJAd9/3L8yLdqEz5DBINlqadHpi65L3u5TPM0bJ5QKNRh7WXw9rsr/dZuTDo/Ht6m7rkYy1pcBwo71Ne7GADfEFC3WuIRLTahpr4K4g8y/PeIiKGZlwqo5BHw09dgwo8URtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQO6G2NxH/MpB/aLhwOLhA0TYIOsEZsNxV78jiLBQDU=;
 b=qidvGKJFWME8v8yZAMuuXaVCT3cw3VSkqZ5Vxh88KJbmDEeBG7QIg8H0tTEbr7rdSPJO90fGDOHHeEP5yrJoeEIWUbbtfoZ3yspW2iaz+dBOnRfaqqsLimw8avqos4B25gkX62617j9e+VNNUXvTE3Kq1QjlsFcWzSjBm+iI0nk=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by LV8PR10MB7728.namprd10.prod.outlook.com
 (2603:10b6:408:1e7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 09:20:29 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 4 Mar 2026
 09:20:29 +0000
Message-ID: <2885ac50-2326-4548-b92c-c5ae566a8013@oracle.com>
Date: Wed, 4 Mar 2026 09:20:25 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: Fix async_scan race condition with
 READ_ONCE/WRITE_ONCE
To: Chaohai Chen <wdhh6@aliyun.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, dlemoal@kernel.org, bvanassche@acm.org,
        hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260304075712.3039960-1-wdhh6@aliyun.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260304075712.3039960-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB3PR06CA0013.eurprd06.prod.outlook.com (2603:10a6:8:1::26)
 To DS4PPFEAFA21C69.namprd10.prod.outlook.com (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|LV8PR10MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: c728b5e3-54c6-4cc6-5eb1-08de79cf4701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	Fk4BsxZpWePz/+t0wGXyy1HRzni259X9wVdTcrVoRfWdFj8ZnknceBRuYW9xoXV/GGvSiJqg8spMediYXWbPAnzKbMB8PkuBfsXWVvP03QmqRXK1af0erd08iDx8oL21zTtRqgv1C8E1rFc4G4GnDh9Samw/8wACf7XMndJp03WCfr6D+3wZ5q0TbGYDJ13qI8JLEMR3WWvJrs4OQUlA3q7+BlbMJjP5fUovzip39c49FtTf6e4DcMlnCLdRSVBI18eCBI96KLMxtI7U4bFt0Xp2kIuCuJSa/E6Hgy7WxZbuyZPuMH9LcTjkqb5biUMMIlymbJ29mACwD0z4LPYur0PXV4bWiAGNiIRtnT7pe93Zh1gvRGYHXPTWYJ/Y12j3wfrWtkogOIpniseslRIzANstLRScAl5jid1WqG0VsHBCTGrC9Heow2JhH4qdQwMUnHqMiJtj72dyi2JHiD7oAWD6X7wLmPikWxI4MMMz0gtSB8jQBQWO5fODMQ+aOkU/NTlN+1fJ5KZ9jLp/ReB+st36vmWgup6zUikvYhTANLraQa8A0Bcvt6B+jHbs0+ghZoPPUhTakojZ+bmrvNoH8aYjCXclOQ0wChoGziG61ITG475QR0CL/RNuGbaxbs+vaP7NY6ohLOex67nfWZHcKKOKboiZHP1hyGT+uP4ro0uzY2f2+s6o/ynPDzH44JJ3NqD6AaS/ghV7+vCXEanPRyyQra8Y1vyVeouJhblFlro=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFBtWE9KSmhLbzkvQTNhUWVHQk9tZStROWRaQnFFeHBuQUVORlhBRHRyeGxX?=
 =?utf-8?B?M0dxVndRUk1XdEdxOEpDUjR6Vm10VjJCVHZRVjJrMzY5c0ppQ2JGMkgxNUQv?=
 =?utf-8?B?dDVwTEtwMHNWME5TU3J2VVd0SnliOXJ1OUdYR29RcmUza1hkNWYxQ0hYdmo4?=
 =?utf-8?B?ZThxK1dlRDB5SFJrVGFMM0t0ZTROcU1ob0N4ZTBoZlZIN0h3bFNsSy9tYVRT?=
 =?utf-8?B?R2NIalU5RkFzOU5OczBxaEVTNGpCblVSZWs3MzkwNEovaVNtQjdLSnFRNHcv?=
 =?utf-8?B?cG80UVF2WXFGOEdqRkFBUG9uRG56NHY5UklEY1Rnd29SdVIyVGVXaWkzU1NF?=
 =?utf-8?B?VktabmpNUTNhbG9tcmt1S3Rja0tmUEdjcktvYlgvUzF4WWRTS2o5alJDbEtL?=
 =?utf-8?B?dFRSOEhlWVozcUxRSW5PdkkxMG04eStGaG8xZTI1MGpka1JPTThvaHUyMnNx?=
 =?utf-8?B?ZGM5TlJJdEdtSUVocEpodXM0WjB5VjlzTTFOcGZ4cWxHZjJ1QWgzM3praEgx?=
 =?utf-8?B?emJmWlRxN0pvclRMeC9IRldBMW9NNU02blF0NDREZTU1UHltTXBZVEM1eDNO?=
 =?utf-8?B?M1NZbFY4cVlKU1orNjFPVUgyTTRVL3FldTVIc3I5OTBXY3M2aTFDbjY2Ynp0?=
 =?utf-8?B?aDlmWS9yTWxnMWpWRmRXamRoUkZHQzRBeGZWc0NmZERJVEpYMnBJVWRFa0lw?=
 =?utf-8?B?MkJPaVBtZ3FMQU91ZGl1NjBxcjhWcFpsNUpDRXlZTEZqTjdvUTl1Z0NWbnBM?=
 =?utf-8?B?R0dhVU9KS3MvYm1xd25YVVlWMkp3M3gyTzF5K0h6TjhvdFJDSUx4RnhzRWRk?=
 =?utf-8?B?eVFRdE1ZSWl4VjcyN3MwY3pnWnYzWFNxRmxJZGprVmttNTgxV2s5djcrdUkx?=
 =?utf-8?B?ckpFN29oN1dKNGl0Z2Vha2ZnMmVhbkZlV3hLZEE5ck5hYXA1MTE2Y3NDM2Ir?=
 =?utf-8?B?MVp6M280WjV0eUw1Wlc4NktSSW4zN1E1YjRhT2wzdWNDY3ZGSEdwbUlQZktP?=
 =?utf-8?B?cENJTmlwTUh6VjJwRFU3VlJQejZud3ZlTCs0dUlJRFU3UHlyaUtvL05NZGFD?=
 =?utf-8?B?MlFqaTl1dnNlalRUdFBHVGRWemduUnh4anQyNVo2UWwwZUFVR2RFQVhSWUdP?=
 =?utf-8?B?czVNeUZzeUlYNkZYRWxoRE4xcm04UUZ4UXZUZlFQaWFsRXdFVTN5SUFQc1V4?=
 =?utf-8?B?NmtpdDF6KzgwV2p4cnJzdytMcVVxT1pnQ0pWUkIydklwMjNBL0xsM0pkWktj?=
 =?utf-8?B?d1R0WHM2TWs4Wi9qcUtVSHg3UlJnaXp6Z0YyMXdxWmwweXY5UnpERkRHMTUx?=
 =?utf-8?B?QnR1SEhsN0VtVENUb1ZQR29YdWNzTC9CRGZ1bDJEd01CekNpUDBWN3A3Q0xR?=
 =?utf-8?B?eXRRTlZsZkNPR09qaDNGN28vY29za1gzSjkySVlzeFdPR1VVSmhCK2lUK0lJ?=
 =?utf-8?B?U2NMNWFOUEtkQVVQRGQwd29qaG9TOEFhS1ljaWVXY0lKbUFKQWJWKzkwRjJL?=
 =?utf-8?B?NHowbEFwMmJPbi9oZHRvVytwVWVVZytSWFZkRzMwUE90eXlLTDZjNmQwNDdY?=
 =?utf-8?B?azA0OVZkR3FNUTlKa09wMkJmd2tqNDFKZUZTc1J4YXhZRHhxZERiYktMQm4z?=
 =?utf-8?B?aXZsT1ZsVnA0dThMaVpIRFpKcUlqWUd5KzVWWjRicmxpbWQ2aHRPL3R0aVVO?=
 =?utf-8?B?LzRVR1Z3SXQ3L1RSRFE5eDkvdmY4MU5EdnJNK1UwaWtVMS8zaXJlM2c0WWhm?=
 =?utf-8?B?M3EyTkZmRVAxcFhOMmlrNEcvdlhvM09kRjBFSTBZK1kvb2VCZVdPTHJuMHBh?=
 =?utf-8?B?SFBFdnAvRUloL0RjTWNmMHN0NjRXZUo5Vm1PajNYRDUvdW4zNThuTFRIMi9O?=
 =?utf-8?B?TkRyZWFUVzhsVGE2M3N6OWtscllrU3YrT05EMHdkb0pMd1dQTWdlWjJjYThP?=
 =?utf-8?B?VGRyeWRraDlqU2ZzbE01MzFhN04wWE4zbnZmRnlsN0lBNWxERjlpazQzS3Rx?=
 =?utf-8?B?WXRLN2JUdHp5b2xFbDlwQ1F6Y3JWR2J2eUZFQ3BxaHRyRG9JVU4zaitGdFM4?=
 =?utf-8?B?T1MrVXhoTC9VYnVNajhLVERlYWJJMFVNTXR1SjdIZklGUWkrUFJodUMyOVk4?=
 =?utf-8?B?SzVvVEVqeWxZVVdVVWhCcEUzd0JaYTVkN1djQlBNVUVFWnJabmZPczlqbUxY?=
 =?utf-8?B?aXJOWDNxYmZqZ3BIcjVEWkYxT21mR1RwLzc0djRSZTJJc2o5Rlc2d0xsblVn?=
 =?utf-8?B?RFBrUHhPMzNNTlR4MHliZnAzNmxiSzYrTUlqU2dwRVNFQ2ZtYzZEejJLajVv?=
 =?utf-8?B?MFJPeDZQLy93dDYxZ3RzTWF6eHhYY2FCOUplakJTdkZ6SUkwcWRLUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fb1vwZpRmwaxYVnw8eU3BC4+KVGYUJHhI9WJDbTYXZV5JccS1agVnRWJRuwmEKQhBstrEXpWSBiSwEba8qbajyLsFpsS/B2WMvVrVLxjuc+d4CyU1zpSv4fSkM3YYbYduTp/Hi67zrgSZ5nNTBgR+lMmYDuzuCrR4i2qOQ1fQtqCuW0rYvlubjyO+8MtnzTPSz6GkunRFuEloFYtiqK/NuwwA8l3n6JIaviQV855vRPtC+kuTU9Vj89olZxF4XOmaECDS3r2dQku39rsaPnCyki1TppxxwzmNqaWaGQIkHy5/2Snt7SUaazbrWQQv6F8YegNlwjVoZjOaUTxYKfYg7WIk0TT4SikAvjzHTtvWr0X8Yavrl0lLjbpW/zU5q37SdkZSLQstP64vhrvt4YivHC2kcVwfyHHTsUptjt7cq1lGQnoHbK+QBIwGwuMUp8wbQ4OrI/yaLUpuWxQlvKRebByWi/yUwwJa6YVR9HE8cIPJI4gF54+1oQWNYOIjm6EXDZSEgyhpIIbK0RJUreQzxJP7U30VTtgayVtTSCAgYxsRrQCziKE3F5akLRmj6WLcMz6F3YrvOrpacYi+JMvjs8QStjlMe7Mv/370PBnZi8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c728b5e3-54c6-4cc6-5eb1-08de79cf4701
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 09:20:29.2485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WzFtSDiJgU3pLAYoapO/9PsosAkFDADQ3AOHxzMr4+z2ZkA1MPMBcqLTsaxYcZX6bbOFSQ69lBXtQyJgc82YHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7728
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_04,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040070
X-Proofpoint-GUID: 53rw2rfOl_8b1nHF3LfnhwaBZu0JvCy0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA3MCBTYWx0ZWRfX9T6OYu0VO1/j
 gor0VrqAamqaIVVqeVe7k+nRVQVmf9TGByAAMz/AOxUdWXVG2wiMlovJsWst4TcalO92Z5SV4sK
 S6oQ7O9+IMCLxQEAYniR78mAtXm+o/i4VXdXJ4Izlwc1hlf1iB2BgpLv37SKdh1n7zQM12TFUeI
 HyEVY+hCr77f6cDycPbK+lDsxLuBbtxdbdgcFQ7GYZXdISoZFM9VtA7z44KT9V010f6i/dqvMSO
 E9boXlnnKysyHElj/suXkNXU9E3sLSAPm+TQKz2GP4kqvxUincWcKMxUwl5RVTh60oUZCtwnBR6
 slXDg2kVX2KLEini83Mh6ieVaNvP5bvdB0N2QqWJDMcpiU1159sBdmzVpIJBA2SO9oRwdDmYbnF
 Qjo4E7RcxMGAJggXj8sj8bVdkg3kJ6c/3NigpwN/1khlBc35AE8oefTljnLwjRyieVnvrgaAKdE
 aR+w0qh5T+mJ31ahssELzLTz4lRf8Trb7yII89wY=
X-Authority-Analysis: v=2.4 cv=c5mmgB9l c=1 sm=1 tr=0 ts=69a7f968 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=nTg3QbKWAAAA:8 a=LuKxigHlaxzhYvMnAJUA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12267
X-Proofpoint-ORIG-GUID: 53rw2rfOl_8b1nHF3LfnhwaBZu0JvCy0

On 04/03/2026 07:57, Chaohai Chen wrote:
> Previously, host_lock was used to prevent bit-set conflicts in async_scan,
> but this approach introduced naked reads in some code paths.
> 
> Convert async_scan from a bitfield to a bool type to eliminate bit-level
> conflicts entirely. Use READ_ONCE() and WRITE_ONCE() to ensure proper
> memory ordering on Alpha and satisfy KCSAN requirements.

Is the shost->scan_mutex always held when shost->async_scan is read/written?

> 
> Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
> ---
> 
> v1->v3:
> use READ_ONCE()/WRITE_ONCE() to fix the issue (Christoph Hellwig, Damien Le Moal)
> 
> v1: https://urldefense.com/v3/__https://lore.kernel.org/all/20260302121343.1630837-1-wdhh6@aliyun.com/__;!!ACWV5N9M2RV99hQ!KlZN-O7DbZEu25CkCc5u3UxNVI8TafYP_8y7BLOsNvIv6kwKjzL038XMO0nBle4xVoVlj6tMo87cg7mr$
> 
>   drivers/scsi/scsi_scan.c | 22 ++++++++--------------
>   include/scsi/scsi_host.h |  6 +++---
>   2 files changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 60c06fa4ec32..892be54dacc6 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1298,7 +1298,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   		goto out_free_result;
>   	}
>   
> -	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
> +	res = scsi_add_lun(sdev, result, &bflags, READ_ONCE(shost->async_scan));
>   	if (res == SCSI_SCAN_LUN_PRESENT) {
>   		if (bflags & BLIST_KEY) {
>   			sdev->lockable = 0;
> @@ -1629,7 +1629,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
>   	scsi_autopm_get_target(starget);
>   
>   	mutex_lock(&shost->scan_mutex);
> -	if (!shost->async_scan)
> +	if (!READ_ONCE(shost->async_scan))
>   		scsi_complete_async_scans();
>   
>   	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> @@ -1839,7 +1839,7 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
>   		return;
>   
>   	mutex_lock(&shost->scan_mutex);
> -	if (!shost->async_scan)
> +	if (!READ_ONCE(shost->async_scan))
>   		scsi_complete_async_scans();
>   
>   	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> @@ -1896,7 +1896,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
>   		return -EINVAL;
>   
>   	mutex_lock(&shost->scan_mutex);
> -	if (!shost->async_scan)
> +	if (!READ_ONCE(shost->async_scan))
>   		scsi_complete_async_scans();
>   
>   	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> @@ -1943,13 +1943,12 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
>   static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>   {
>   	struct async_scan_data *data = NULL;
> -	unsigned long flags;
>   
>   	if (strncmp(scsi_scan_type, "sync", 4) == 0)
>   		return NULL;
>   
>   	mutex_lock(&shost->scan_mutex);
> -	if (shost->async_scan) {
> +	if (READ_ONCE(shost->async_scan)) {
>   		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
>   		goto err;
>   	}
> @@ -1962,9 +1961,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>   		goto err;
>   	init_completion(&data->prev_finished);
>   
> -	spin_lock_irqsave(shost->host_lock, flags);
> -	shost->async_scan = 1;
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	WRITE_ONCE(shost->async_scan, true);
>   	mutex_unlock(&shost->scan_mutex);
>   
>   	spin_lock(&async_scan_lock);
> @@ -1992,7 +1989,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>   static void scsi_finish_async_scan(struct async_scan_data *data)
>   {
>   	struct Scsi_Host *shost;
> -	unsigned long flags;
>   
>   	if (!data)
>   		return;
> @@ -2001,7 +1997,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
>   
>   	mutex_lock(&shost->scan_mutex);
>   
> -	if (!shost->async_scan) {
> +	if (!READ_ONCE(shost->async_scan)) {
>   		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
>   		dump_stack();
>   		mutex_unlock(&shost->scan_mutex);
> @@ -2012,9 +2008,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
>   
>   	scsi_sysfs_add_devices(shost);
>   
> -	spin_lock_irqsave(shost->host_lock, flags);
> -	shost->async_scan = 0;
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	WRITE_ONCE(shost->async_scan, false);
>   
>   	mutex_unlock(&shost->scan_mutex);
>   
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index f6e12565a81d..668ec9a1b33c 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -678,9 +678,6 @@ struct Scsi_Host {
>   	/* Task mgmt function in progress */
>   	unsigned tmf_in_progress:1;
>   
> -	/* Asynchronous scan in progress */
> -	unsigned async_scan:1;
> -
>   	/* Don't resume host in EH */
>   	unsigned eh_noresume:1;
>   
> @@ -699,6 +696,9 @@ struct Scsi_Host {
>   	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
>   	unsigned no_scsi2_lun_in_cdb:1;
>   
> +	/* Asynchronous scan in progress */
> +	bool async_scan;
> +
>   	/*
>   	 * Optional work queue to be utilized by the transport
>   	 */

