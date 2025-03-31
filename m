Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7DC2B2CF;
	Mon, 31 Mar 2025 07:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743407059; cv=fail; b=HuuXvijVAKo7LcTYSt0cPUVd94YVx1lcGAcdRkfqZd31GODs1K+ZEL1dHAcwPTwZCJee43zfgeHZ3gEqDMEkyNjKmyuL0ph+ztbPoAqaU+ShtqrpyWo2iUYV4DN8AeXObFXDM4xM80JVQen1nXVTOtKJuuMMyPF8VVfy08SlvSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743407059; c=relaxed/simple;
	bh=HeMcY3RXJ5vZmHU1nPz0BK2fTg68eSxoYzEnVoxesdg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bSNqUc0AhB1XIjcixOM9em3CB6daduoIUewKnyO3i2dF/KXd3F/tTRMDXc/j24PKWbzQEnIUUnFq1iYBHjBFxzBAG5ORHx4Xcdy62cAJBrzuUdSjX3KINlxuiSOWhLX2O5+UHtl8JZ+2oFAHP5TX3saBxw/0kFr9EZ+x9Tp4QP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TaSMhMjW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IxLgrmsK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TaSMhMjW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IxLgrmsK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52UNrlm3027570;
	Mon, 31 Mar 2025 07:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Y0Tx491zW4RM6eui80QK9wmvYi6NjZYSe2Dlyd7oT4E=; b=
	TaSMhMjWssAyLNWhcEr6pcyPyAEDkbHPqS2X7nKBiANN28hyI53MvhGxYu9VkncB
	/4zxHMQC1O+5koSDHWTmjHppTE0sQohXF2WUwyiF8vzzphkypWfEtSZ4W9PvFBIv
	FOr7smclX6aIF1vV5l3Lz5l1XS/ZHKsfm7ADceKnAUTeor+wCJiiygeQnlffGYCq
	nb/a4rUK1WBGePc09qmO63UVyeq3jBzKuv0Gw/cSNDe17cF+P0mcADn2vz07RICd
	030CMS0/5MI4T1VvS/l6ewPyb5alPEFaLHBP7rrTu9Dvh2bsCAAsOvZ0oNx2MJwF
	9GXCIwNxzAihaSvglYTorg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p79c2q42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 07:43:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52V5ZDJI004473;
	Mon, 31 Mar 2025 07:43:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7a7nf1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 07:43:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZKiU7XNAmK5DusZuqT31DIfXEQGnfk/1A9ssHc53N8CBCogIfB3XBURjUbEt5ROMopzq6XhU7e6ytiI6oeBQ2JvCeRfRXYN57R3Jdp/fesTjJyBdpN664bYRGFUyzgqB8vsdMNXQ6aNtPC1RvHpRSo4pHa71SioTua6sHvadD7q9xX+tpzKbOwVVWeIa4jSn2vM49GnWwi4xfTI4WrfXlnzifzEG2gaoI5rE1HsstmJXYD9LEtHbtE1wDeqputg0r/u+9UENtJXff6pIHCFELQ2beGTnBPNBNsfteBhe/Kdj6jmhyyEAjp5cHO/x4sL8R+BexxHm0/WgXkRAk1EXxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0Tx491zW4RM6eui80QK9wmvYi6NjZYSe2Dlyd7oT4E=;
 b=b2r2sBaTSdoFj37Dynp2B1jt9NGnozpXXcpm5zZEvUASEVnIZJGmhySoUqLgqVKaDVHhwcQJNLy15YW7ahRY3VdpXpLgNUNGTqXTILRHJaMIvpWh/oz/jVnVKGdXmLGsPqM4U8Dqr9ZcgxXVBe4klwr3eoD3+8BNhUfxqYN50OWEnuipOvHk9487Ewh13E54zjO9z6DzrIU+DtInimevD3gS9Q2R7NOFjGrdrzMV8qru9dk88KLD8jaQn7YvxOFDrXfxnEIujezMtt8f1ueMilH8wu0+LaQdCiPsTBSlbU72LUseMnSqD5l85dJsB8Tiaywi5k/s8QT5Pi/ki596RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0Tx491zW4RM6eui80QK9wmvYi6NjZYSe2Dlyd7oT4E=;
 b=IxLgrmsKOUYtznjFl4xwax2AObUqpN8a0erBBAwLOsA6OY9DkAyxqeXxIVrzZbZNSORos0nFwhoQ2aIxTNkzHU1WeJiFhfn5NxIJLgelfaHKWDgtLUYUTzRVsmCn8HpjvfV3EjQR8A2ZSsvIWgEUbFnvalgm9DZAvhOtjz3rBUs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4261.namprd10.prod.outlook.com (2603:10b6:610:7d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.37; Mon, 31 Mar
 2025 07:43:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8583.038; Mon, 31 Mar 2025
 07:43:50 +0000
Message-ID: <c60bb344-5ac1-4e6a-b68c-217c403f7017@oracle.com>
Date: Mon, 31 Mar 2025 08:43:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] scsi: hisi_sas: Add host_tagset_enable module param
 for v3 hw
To: yangxingui <yangxingui@huawei.com>, Yihang Li <liyihang9@huawei.com>,
        martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, prime.zeng@hisilicon.com,
        linux-ide@vger.kernel.org
References: <20250329073236.2300582-1-liyihang9@huawei.com>
 <20250329073236.2300582-2-liyihang9@huawei.com>
 <f53505e6-9bfa-4553-91cc-497512a6977f@oracle.com>
 <e5ab4e5a-33d0-6102-1c5c-f1f83a752346@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e5ab4e5a-33d0-6102-1c5c-f1f83a752346@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0131.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4261:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b422785-1ae1-4b62-2e9a-08dd7027c6da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXJVSWN4T0xaRmFONVpRUm52b0JxU0xQYUxrMGlwTjZLaHpacWZEUlZhZlJn?=
 =?utf-8?B?SmFNaWJjVWMxVk5NVTM4QXBidTVnMUp2VUVTenRldWRBb05mZi80eXhLaldE?=
 =?utf-8?B?U0UvRnlxMGg5bFFkc0F5MGVRZHd5NlhidThkYVp6eWdPSXhQVkQ0TTl6Mks5?=
 =?utf-8?B?SFlwOE9RYm1TTTlFN2RGNWY2UzBJSzBNQ2lkaTdhSGtMbDlPNjJDR2Q5aGF4?=
 =?utf-8?B?K1Z1S2owLzhIdUNZZ2tRV25mSm1jd25TdTltVFlkZ3o5U1dWUXNuZ29qQ1JK?=
 =?utf-8?B?bzY2QVFreTR6THo4Wkx5eW1rSzV5M1FkaGIrM1dmb2hMNTVJWTY1QitqNStL?=
 =?utf-8?B?blVJa28rUU9uVkdXV1NvaWgxQzNDbjVHY25jckw3dVNkMGIzcHRZMmhPRjVv?=
 =?utf-8?B?S21QYjE4MC9vWWJBWFJmaUp6U0NmV0VYa3J6VE44RlhTZFRoODYyakthZ3VQ?=
 =?utf-8?B?cHNrR3dTMFEwTFhOWjM0dkx4TXcrZUp6VDJ5ZmIxMGtmYUY5OUV2WlhTQUk2?=
 =?utf-8?B?V0U3ZC8vZDlCK0Y3c1BSTEVCUVU4SU1QbERLaGh0eEM2RS9OWFoybVZYOXl0?=
 =?utf-8?B?akRsOXlGRExIbDF1dHJEZXNnWW1lVk5ZMGp3ZDVJQ0JuVGI2NU9GcW9uWmtX?=
 =?utf-8?B?czNrNnRjOWgvV1FybzZpSTBzNVBISUJuaTlSN0lEVkNTekp4WURnZ0pYSTNZ?=
 =?utf-8?B?SEI4SVh4cUw3clAzdHZGdVAvZDdpbTYzbEdHK01tcGJBQXpCZ25IREtjZ0VB?=
 =?utf-8?B?cjBCODBKUkQ1aHlpNUtnVlAvVElpaVpIamJXdzh3eUIrMWVoTUlkWFJicE83?=
 =?utf-8?B?cUtuWEtYVGhnd2tNUWYyRkVYNGRTa0Z2ZnVnUFhFekRzZkdqTTdjU0VkVVVl?=
 =?utf-8?B?ZUlVN2FxVmRhYmlMZHZBVEYvcHF1VndGNVFnR2NLUEh0d1NneW9tK1lkRmQ3?=
 =?utf-8?B?eCs3bjVKQnRQKzA3TkkzUFRiekdWZnI5K2Y0Vm50VnFJcGFBMGoxMWYzSjl2?=
 =?utf-8?B?d2NyWHhPV3VFL3dJa3l5c3NZNEtveTcvTVF5MXl5dzZxVmV6WFIxZzZzY0xr?=
 =?utf-8?B?RG5KdTVjWWRMSlZBVGlKR2FPUTVVSDErZnlUa2svNjgxWDdCMVd5d3pPcmRa?=
 =?utf-8?B?TzVBTGk4TCs2TkJvLzgyUisyeGFxb3RXWXI5djVINzFETENILzBuT2pCYlhS?=
 =?utf-8?B?ekFQUWVDVjlrY200b1lxMDZuVGtXekhxazBWNzg4ZVFlOXVQYlp0WTVSdXBz?=
 =?utf-8?B?VldaMEdFT3hpRWhsS2Z2TWhRYnJrcmRPeDNCb0JITklDcGlPODRjTlRlZ1Fa?=
 =?utf-8?B?NDJGbnFXam1Tc3YwR0lYZDdvTTNLRFNGL0xhalJNZEFCSk5TK1BEMnpPSjFG?=
 =?utf-8?B?WjJGZll4V1hsRVk1R2N5cndVYjh4UlhXTmd3SEpqMk1tTlBOM09VRHNZVHUy?=
 =?utf-8?B?cmw5SXJoNmxMUTFJRGtvRkk0KzVHZ2VqRXZpMGoyYWVBYjgrSE5oQkwzai9Q?=
 =?utf-8?B?U0trK2ZJQXFmVDJwR0hlY3lpZDJMcjhtZ0lWaDNPNkJQUjlvaGdyR0c1S3M3?=
 =?utf-8?B?cHQxTzFKdGdBNGkxV05KeFVGWWV3YlJXaWduSmVmekF0ejBiYi9mMnJ2U0xo?=
 =?utf-8?B?UStaeU9YSEpiU25GMkhnNHZJYmx5S3gwN3BJMnF6Vk5TazZZSG05N01wM3VX?=
 =?utf-8?B?a01LcytLbVpweXpOZkZ5R0J4NnM1aTVSTTR0aEZtM0ZKZlI2M0ZPYmU3MWRm?=
 =?utf-8?B?THByZkN0MDVGbmVTVjJ6WlFEcktmd3htQ282QUdudmp3bmFCdjJNL1I2dUt1?=
 =?utf-8?B?V1VyK3gzY1ZicjNPV051QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzdBWkszUkNQVWExVSsvYmF1d3JrNFgzbzUvK2thaVVCU1Y5Z0xqSGxZK214?=
 =?utf-8?B?Rk41cld2TFZDRnVFSXl4VXUrcWJ6emU0RVFVdVhPL0VpQlJ0aS9ET3kvMGhr?=
 =?utf-8?B?cUlVNzJncmJoZ0RZbnlkNDFOZnl3c21Pb0ZTaXBUWGhzUllFOWJHd2VRTFBs?=
 =?utf-8?B?OU9WL0FVYVFuS0xnSEtMSS94d05UdTNPWnFrWXJzNzVnNHZWdWJ0QzBWR09O?=
 =?utf-8?B?T2xDd3hQOVAvNUdhbXNoczZHTkJLcms0cjhzYUxBc3lrbFNaamtoU2Z6MTNW?=
 =?utf-8?B?RzB4d2pLQTNSWXJvN1lsN2ZTS0haT0hObUFZNkFLb1BkaytZUDNIbUIyWnVz?=
 =?utf-8?B?M1RQaDF1WUluU0NOTW9QUDVxbDY4djJpZjBWeFpEc1BMUngwN25aRmV0RENa?=
 =?utf-8?B?Rnl4azRPWndFcGlBQVQ0TUptZVR6R20rS2JMcFlSRkY1NXVQUTE3dlZzUzhj?=
 =?utf-8?B?NnVkanJ5cGtZOGNGUlpkRTFlV3RpKzQxenhuaWJhVWIrSTRrZ2xZNFJnUXlF?=
 =?utf-8?B?V2dZRVBra3BHS1drREczN1lTdHozbkU3YngyeTkrdXplbUJHeTJObVlta3NH?=
 =?utf-8?B?SkpVRXFBRjBZdm80WEdxaTFteG5EM3ZSWVhPaVkrOG15dlJVbjJzbFpYSVFN?=
 =?utf-8?B?M0kxbDN5dkYwY2c0S0h5d3c3dG9VdFlUcUc5dmhGc2VMWTVmMXd0UjJ4RkV4?=
 =?utf-8?B?T1kwcVk5VUxPeXcrNmw2bnVWS3ExNk5OS3gyRkJFaSsxVFJJMDFxZUUwazRT?=
 =?utf-8?B?U1Z4eG84UlJtR3IvRmVqQ0lBemNXdmJhS1NqNGVyVXI5TFBCQnVuY0VKQjll?=
 =?utf-8?B?a29rOWZyQVg1Tkxjc0psQzNXS3NrTUNOQzlJVk14M244WTMwK1JHRWdFY3lD?=
 =?utf-8?B?aXdQVU9kaU5ObEJGSmRWNmxPeDRsOGRWNGR5OUlWckFwOXRmR2RJNmJocVhx?=
 =?utf-8?B?NFlKQS8yVHlpb2c1akdRa2svYmFtdHBJbStpeXNOZDV3Znh3VkU5S1JrR0dJ?=
 =?utf-8?B?NnlKZ2pLdzhSeE5Bc0xUbllOWWduLzNHazRSK2k1Y2RyN2xmb01rWE9ybWRE?=
 =?utf-8?B?NGVNZWwycnh1eU5tb0tPbXdYZUYxOTBlcC9ERm9jL1R3Y1FpMjl2NHhVTytL?=
 =?utf-8?B?WWlVQTRaMmtJeElnY0NnYzMvK1dVa2pYcG5UWnQ3bndBN0NJalF4TlR0MlE3?=
 =?utf-8?B?VFlMdXhWUXZiakREZXVzYTUyeU1TRThqTHpNY2RMdUdpNXlIS3hGTDdHeS9F?=
 =?utf-8?B?eFpaRmQ5OXpGVGN2ZVJKTjlTNzZockxaRHVnQmVBTVZuRGJGUDdTSFdhTmhv?=
 =?utf-8?B?aTJyK0kyR29qNWlDN1lPSEhlcWttZFNpdi9xL0F0aUhnSVJjQ21nR2lQZTNF?=
 =?utf-8?B?THY1YVdFbUJxSE4yL2JYaEpnN2Fmb1QzTTVsVU5neVFmRGxsNnQ5Z2taU0tm?=
 =?utf-8?B?YXR3aW94ZUdSTEtiZnNteFl0QmhWcHJJcDZkYkdaOUd4YUpueGJRbGFaYzZG?=
 =?utf-8?B?eWl1eGVWd1o4eWs2TnNyblJGY3ZKZGNXR0ZKWVdvNC9JOWFocmhpeFhPYmxn?=
 =?utf-8?B?TGExM0syOFM3bnNLb3VDMGdzUmk5eTFYYzdURm95YzhoUEtqTjkyWDRrUUNJ?=
 =?utf-8?B?eHdMZlFuUE1HQWhsSnI5VFVRL2VJRnYwZEFmdG91ZXB2L3Z2Tk15bVRCRnJY?=
 =?utf-8?B?S2ZmclBKMC9BS1FodmYwZ3BDeWpaenBSTnRYSTRSWCthMG5UMFRDOG4vdXBX?=
 =?utf-8?B?UEIzbXNzcUkyZmNZcisvaWhveldCM3RkMnI4UGhtdkszVzQxTXBOaVJMZG9M?=
 =?utf-8?B?T3BPN01SRXNSR08zcmhjM0QwcnFlUjRyenRiY0pUeXp4d0dqNEl3WXpJY0Rq?=
 =?utf-8?B?NXk4YjhkZmlRbmw4djJBMHFQZW43MlR6MmsxNE90MEdTM1pISGVhbjZxdGR0?=
 =?utf-8?B?UmUwU21jUElJRlZNRG5qMzFtQUdkNVZ4SGlueFVSUi9OZFNVeGFYUWdSbUlk?=
 =?utf-8?B?MDVWa2tDVGxXb0llUUIzbEdjb1orOVpqWlVSdzB2VkovKytBUGo5cnNxVWxi?=
 =?utf-8?B?K2ErLzRGVW03QzRCWWlHczJ2RmpPZG9GRm8weTh3dERDTi9mTEZIOHpYSUFx?=
 =?utf-8?B?UGVHWnFpd1pRRXhKODFLZUpUeVFsWERQeDJlVWJPOGdXYXphVm5QV013dTN0?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nR8yL2wK445Tjsi4XdTugcWWL5j1t+SkAdPr/raXwlBRV2ShyxCkV0Plnb9jJvUIyJNil/yq0ixXWuGfHiwMg2wjCV5SKkdfZaKeOKkHX+6fTdlomiLtDFNpR3W58OFwrv0SzGduHsOx7K2tUa5Oj+PaPYG25qzG6CJaaGRnazYTj03ignWAhg2DpvAFMaEEYKIw/Blazar9wBiH9WiPzXxh2CwSQd4PSFMf5ZOYnlzndVqoERlYupnfwyirtVFdMPLjdZ7L/EevmHDW+bMurk64wPAwvMjD2X0TmWxk3H28q/Hm3W/E3DVg8e16HrG4SPOcViFeGP1oclUeArbOEARVF635hKTr915/IPsZ6bUP7jmOPxClliA0uikanDx3mD8KSLmDhvFPxvAvQrVVDEJe7A0876JvWk0x8scaXL9l033xDSN73EKGxRjVLj5nemDJ16f8kR3MEow/WMh9dejhzg+GfwafSI8NszPwdj7KnGH4gMqQTIfRACDNipvQlV+/tGWScm7Tp0t9twpCwxLVqNafB+EdxkJuEoSQk2Db5xVv/sywjczgxh14dW551fCn8MzRCsKIOlgI+Vq0NoAbJM9yccHdeZ1bkPfHB8I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b422785-1ae1-4b62-2e9a-08dd7027c6da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 07:43:50.0941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fVDlHMmW/iTV4pb4y9vf49WkKxKX5tU6PZRA/ox+5loumg7Pk/O8gq1yih6KxxgrsN5pYVsA1tR/4mrV7xwsSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4261
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-31_03,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503310054
X-Proofpoint-GUID: Xuu3miT6-jxUVtpwRR2VeoFv8unmHdxe
X-Proofpoint-ORIG-GUID: Xuu3miT6-jxUVtpwRR2VeoFv8unmHdxe

On 29/03/2025 09:49, yangxingui wrote:
> Hi，John
> 
> On 2025/3/29 16:50, John Garry wrote:
>> On 29/03/2025 07:32, Yihang Li wrote:
>>
>> +
>>
>>> From: Xingui Yang<yangxingui@huawei.com>
>>>
>>> After driver exposes all HW queues and application submits IO to 
>>> multiple
>>> queues in parallel, if NCQ and non-NCQ commands are mixed to sata disk,
>>> ata_qc_defer() causes non-NCQ commands to be requeued and possibly 
>>> repeated
>>> forever.
>>
>> I don't think that it is a good idea to mask out bugs with module 
>> parameters.
>>
>> Was this the same libata/libsas issue reported some time ago?
> 
> Yeah，related to this issue: https://lore.kernel.org/linux-block/ 
> eef1e927-c9b2-c61d-7f48-92e65d8b0418@huawei.com/
> 
> And, Niklas tried to help fix this problem: https://lore.kernel.org/ 
> linux-scsi/ZynmfyDA9R-lrW71@ryzen/
> 
> Considering that there is no formal solution yet. And our users rarely 
> use SATA disks and SAS disks together on a single machine. For this 
> reason, they can flexibly turn off the exposure of multiple queues in 
> the scenario of using only SATA disks. In addition, it is also 
> convenient to conduct performance comparison tests to expose multiple 
> hardware queues and single queues.
> 

The change in this series does not even solve the issues, as:
- you do not guarantee no SAS/SATA mix without that module param enabled
- the driver still uses managed interrupts in both cases, so with 
disabling host_tagset you are now exposed to CPU hotplug issue of IO 
being in-flight when HW queue interrupt is shutdown

And pm8001 driver will have the same issue, so we need to find a proper fix.

Let me consider this issue more.

