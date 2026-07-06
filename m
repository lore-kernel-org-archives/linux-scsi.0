Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A4A38424D;
	Mon,  6 Jul 2026 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783350276; cv=fail; b=sS+EDv6lL2AoA+XDAwlByYFz2h8oMoVetwlazwm6hL7cyntDPfp0uVD6z84WH1+Bpu//Zno9bomFSaQ+9Zht9zcmBYORYeprckHT4LFJbOAibV7a88crORaDO7k8omnaQQaVd4gpCeV1iI4NZHu7dPghGp//VracB4GbxH8OICs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783350276; c=relaxed/simple;
	bh=t3qdIK55fTD0Clb8JGv1xJoJpuYViaWc3QY+p5df7xQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CdKvJu5TbyVGgcZRbI9PesTmuE2x72xSXDUXxuaPZG4bi0fmX857s74JP2IyKtz07QS54kCu4DnDZQoX6urs25jVM2uU3VaMk9tSXxm/8U0G7Rq8p4ppn81wPd6AulOfLWYRu57v50Ye2lpIpNCC3mWqknWOHLVpjiWyk8Fsb9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZtmEIXyg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mut23eiQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZtmEIXyg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mut23eiQ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666EMfQg1041500;
	Mon, 6 Jul 2026 15:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9DRR/wR3Iry9+eeem83nciYQZLXACJG0hPvSHuO6Tms=; b=
	ZtmEIXygQtKceFp0kMeD+ymRyZ0GaCSFMRZgzdoEm4KQSxye6rVyPcDP2wiILkXV
	NwZ3nN0d4kTtnoAWIkj83SHKgZKLEwYFpiHy13PuNSa1WP6jiKXf1QhuVSf4NyKj
	OA3cdMnAH4vshgRL0K516DUlRyz099E2sMJYZy1LCZBzkJB0g5lIfdxUar7QU9L1
	bR3jEsB+ArYEzHLPUJNTQJUhJoRFHbU9Kfi0xRg7W1J8knB5PKp3WgYdREklcyeR
	Los/yrTYL9bL3116HljUKi263uE8c/GpAZ5pmVFR3cX8bJHGpBcYuyeJdou9asnR
	vmPGCo7SbYdllMDy7m858A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rkbbxk5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:04:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666F3GGR008199;
	Mon, 6 Jul 2026 15:04:32 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013003.outbound.protection.outlook.com [40.93.201.3])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6twgr3u9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:04:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmqdZS6FyX+YtX+sCjRKQA5Pm0MyY+fr3oe+xRkZ9a6tgOkJc/PtZzoQzAjLtSiGqjFCjdvm9FvQ4rKZJ+wHstoUp2WAnnw5p8NB+A6eT2fswN5+s4CF1GoNS+HdNz+dxpbOxRVYhOt5+drGBNejGHjmbuU0IW19zZT8RriysqVep6BvUmzW7tVRThPA/ST778n/OIsoX1e+QS7ukmI/syJOMaCJAc2yaNnAeDnCQNShlnR3ujUxaqK7c7SV3REpY6gJXg2qouHmlD4287vPUqq8Svo2D1gpyk1Y8WKUliaNmd5Og+WtvpHF3Jy8naT3+Iw/S7CKHryA4mJhLM2JOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DRR/wR3Iry9+eeem83nciYQZLXACJG0hPvSHuO6Tms=;
 b=mCNlryo1UKb0w8rKHh+oSCGIdRfhYwu3LTXFJ2ODnghYeBeskjQIWSWT458aEoDFfD+hsMpYHaYhrIzvPcy7ClZhv+6fuYjsR+6olK9DV6+LW+lG28TQ1nFY8Ir/o7km8TT97ArIZ8+lAm1zyPAQiBfd9RmrxwsMC+HdzQbJ2ZLkBIjeyK5hYrO4aFd/3drmkZKEms5Kghkb3nBh0k8LrIIN8ZyOf8bTvJMfGJfR6vJeGHz4SqrQA0F3c1taWf6jCr56/9QjkGajQYyKea125YIuvsDOk6BF/sV5AeUsuvtSyCxGj/6PhANMzpB+QN4M/KMeLdCJoYcej9dCF0xKmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DRR/wR3Iry9+eeem83nciYQZLXACJG0hPvSHuO6Tms=;
 b=mut23eiQTi2lV3KD22UoGTvAKiqizI3xDC2Kj/nPGjE3ZiXSEEKBv7TPFaq8Hp1oYEMQ7dXSkg6WtAsUMUDSzvREqktX7R40sc+VlegF+xhFYDudN2fIIh1JOA32ZMgV8yxt+o8OAyc3V/xQC+UanCy7wGJzq/XDACqGGUNsUaU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS4PR10MB997573.namprd10.prod.outlook.com (2603:10b6:8:31a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Mon, 6 Jul 2026 15:04:30 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 15:04:30 +0000
Message-ID: <e99a1f34-af9f-4bc3-b933-4ddf00eba057@oracle.com>
Date: Mon, 6 Jul 2026 16:04:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/17] scsi-multipath: clear path when device is
 blocked
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-7-john.g.garry@oracle.com>
 <20260703113225.D312B1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703113225.D312B1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS4PR10MB997573:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f614819-6fca-412e-fe8b-08dedb6fe113
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|18002099003|22082099003|56012099006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	opSonkXrjlW7u5GGTKAxlZ3PNsZX9aZ2OIReckyhHz9gN6Wc9wCHzQ4XybPb+Ot///SRAfMRJneIKMPXct+1elyyU3GL5ZGhJkkYT9eLRG+AeCo97jab3Fyd1x2qz7BqBb2haiBAONmLr6xZ/5hCUA0s5tVA9FP6Mtj27xfT1U5akghMR+OrUwfzeqN6vHirjVzXNuVnbokZSRDyhHbOzmhackT0Vsr1CJ6mEtzXj+P3ERiA+F8T+6MDyfpF8h6FL2/ItCF2ukc281re3+NT65qxXwmM9/apw93EBxY2AjY5cAjXv7ESOF6hudM+t9KZ8Md8x9rJUNeLO8iVZnuBQcwP52wPBSsER/VusAqgCGvzHxdYEghHmIpsU03LsCg+OWjWklAQ5MksHR5cM9Y+CFG6i9+AIB+p7Zp4BBWDFsCH9TJI817luDL0DdrBTjs2wZ7cSLWjgQGQh460/lY4PFmrjhX8MuhnbwwtECNMrCeoWFM2r0knVRYT43JNGE0D5C4PD9JPhWJ7OeuFzb2fIRAEVY5Mf+XTumB9jxJgDVQSWQidMsqHDSqI03RDND1bABwgWWsTLGh34q0pTlLtE800hwTka2P/f81zLCkJZf6FwNhTwJXPRCZTcKsuVzaJRA/QN8OoB1sFi33l00BoD0trYAARCgLe8dDEkzDqkDU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(18002099003)(22082099003)(56012099006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1duU1pVNCt2TmtxSG92K01VQklkZkNMQnByTGpRaktYV1RJbWY3SGc2NU1x?=
 =?utf-8?B?WUdDcWZkbS9lTHJzZ2MxZWUyb1JtZG5jcXNjbHFWTlMwYTNoOUVIQVBGSzli?=
 =?utf-8?B?dzNmOXlMUkNiWWcxOWlkRzhkNWY5bEJFT3JZT2JOOHEvU3htNkNxU1dYN0gz?=
 =?utf-8?B?ZGltYnlNSDR5b2Z1VmNMSGRoOTd2eWl5OHUraXNUL1FYaEoxbzIyZSs5VW54?=
 =?utf-8?B?anQ2c2pjQUNIMzFETTJhQjRmRVhLNjZobWxGMk1OeExWd0toZExkSDVXbDZC?=
 =?utf-8?B?ZnJ6ODdXSEFZdGViSUJTWDVibmxJLzg2Tm9NZ2RzeEdXM1c0a1lKZW0zaEdF?=
 =?utf-8?B?U05nYlpDVmVyWVlrOVYwdWFJT2lXQnMxbjZYS1FhRDFzSjBUZDZmSVhpbTBQ?=
 =?utf-8?B?V3VxYXNCbjlWNUlvcVcvZ0NRRTh4MFpFT3lpR256OHBNSy9leUhIcXZqTXNh?=
 =?utf-8?B?Ni91cGhYVGpHc0xQNC8vQ2ozaURON3ZkeFNLM2xyT0pDdzl6SG1LZFhMWDVm?=
 =?utf-8?B?cHAyNGhuamV2TVE1TUpwVUhlamQwUkJoUHRGTExoUzVTWTFDa3NFaHBEU1ZP?=
 =?utf-8?B?eWlWVXNBMVBGTGhnUEU0WTZ3aVFjdnlGTUtCNlJvSE8rVWxVQnczZWE2dVlt?=
 =?utf-8?B?WUFKZXkyeXJlZEpXaEU5Mm1BenFPRzZHdjUwRUNrbTBCRlhmaHJEZTlKR0xM?=
 =?utf-8?B?dU5qbFptNTZuRnY1NmhLUjhnbnQ4NjhhQVRYR2RTYnJ6bkhacjllcG5EV3M0?=
 =?utf-8?B?K0xJNjZWaWlaVFRWdVBWbjdXMmRxZGFRMDYwU3NvNTRwYzBBK3BaTytGTzNB?=
 =?utf-8?B?QkthSDV1dzVBZDdrK0tCbmcyU2t5bVQyTzRGT3VtT1loTmVnWUNsOGZKZmRH?=
 =?utf-8?B?d1Y3TTNGQnU5MFNZQ0hjOWhmRzlGYjhxRFZEd3ZXSW03ek1pUXNkejZLZVFy?=
 =?utf-8?B?bEJLZ2xxcG1YNnFhaHdKdWFpMkhMUllETVh5ZGR0R0svWW5KNG5vd2NPRGRh?=
 =?utf-8?B?TW1DRmE5TDhkTGFKTVlmSkRhSEs5QkRsVkIwOGVYSENzak5ZaFNXRmJWdGF5?=
 =?utf-8?B?bWJrQ04wTVVEYTZPOTRHMVR4WFFhUGVqQ0FEbVFKVmJRaW1qTFlxNW50clFG?=
 =?utf-8?B?WmdvSE8rTitJcGxqTEphNU0wYmUxb2JTYStnTlZTYm9zSzU5UnNoam9EZjNZ?=
 =?utf-8?B?ZFRYRWVwemNGZ3JoUHd6ZTlGcHFDbktWQlAvYStma0pmY1h4NHpCcUVDekNF?=
 =?utf-8?B?SkVNUlh1SEJMazB1OGRQVnVwdjhkUVBHTUszUm5taDYvMjlaVU1sYS9ONXlx?=
 =?utf-8?B?TmJGN1AwMk1xQVlRREVFdllOMWFVMEh4Myt0REVsZ0pLSzRpTHpHMXk4U2Rq?=
 =?utf-8?B?d1c0VEVNUjFlbm5ubFFkU29pSGlPS0ZDdmd5OFZERUdvdVZtMWNyMXZGNVND?=
 =?utf-8?B?eVgrNk0yNHRNaXp1UzRPOTVKZVBZZzZvNE84OC9KaXRCVFhvMkx5Mk5qY3lY?=
 =?utf-8?B?akNsZlNOdDJUek0wQVp6alhyWFNFSHNmbkhwWVNSd2ppOGVFdWhacHdDVTdx?=
 =?utf-8?B?TFlqWVg4c2xnbmpLVWFiWVBQenZlcG50SXpTYmNKdHN5ZlhIcjg4YThGTTI5?=
 =?utf-8?B?QVZCQitiVTh1aEtVNldLUjUvbUx2a0NTbXF4YVdrQ3owK0RKZU9aQVlrVDIy?=
 =?utf-8?B?dVMyUGJEZUZ2cFBQVGhocGVXNFpJdFFmSXhNbkM2THRGRmRwN3JYQnIyZCs5?=
 =?utf-8?B?WjNtR0VTZkxlanNmRDFIaFE3YlFYNVd0Ukc0bnFuQnFZVm5QWUlHZGk4WEQ2?=
 =?utf-8?B?WHBnUFhQcHVqbEVrOHJHaUpnVyt3K2toRTFBUlV0MlBXY3BycmxNUzdpK01Q?=
 =?utf-8?B?TUkxejRLaUYvRXBaSE5HcDBIRnhrcUtJSkVURWxoaGFZTGt2UFdFV1ByVjl3?=
 =?utf-8?B?eHRBQ0dkOHV0eFFNSnZIK0RiUWhvMllORk1FNTVibWlpS1N1UE80ekZSNk04?=
 =?utf-8?B?MU5JU2RGTVU2SFNCcHVacDI4WWR4VnhXTHJWTFNVMnBFdEVUenBEcHhhWEM1?=
 =?utf-8?B?Q3Q5dWJPdVA0ZTFvTzlUdjlyYVIvb0xaV2xhNDJsekxXWlFyTi9JcEdpdkJ5?=
 =?utf-8?B?QUVsVjI2cW1kOWVqRVF3aDJMQXJXUFZXeDk3c0E3RlBIbERVa2xITGZkZFZP?=
 =?utf-8?B?OWdxNzcyTVVTb1RqUWVwRTRxcmVUZUluN3d4cGtLWUhlc0pjb01QbmZHbEYw?=
 =?utf-8?B?WER4M0ozWVRNTTB1Y1pMQWEzVTBsVy9ERGJLbm4ydDM5c1hRVHJqMk4wVWo0?=
 =?utf-8?B?aWcrR3Z6TGNFbzMvczVJWDgyTWgyUVU0L2NJRWZKY3RhZXMzNHE0enQ5MFhw?=
 =?utf-8?Q?oYIrdQfFUDjJ8ShE=3D?=
X-Exchange-RoutingPolicyChecked:
	NG8/oJQiCP96VsWMgnTn4gyhwzveV9XXx0BKXMNteV9gpMz9zyQ0r+Cs8ZQO+Q33jtUGGP8qUSm5IQu8t6wxlglxDSdwN4OtrxlP86SUxZSqKjIO/eHARNkMjoMUF8yZ43egUeePgBhVLvAbyreoyFHky+4szcEAQo5yNWJkrOuhD6p2WQ5PZPNuv3EUE++oqda1RrELMHKQEWbyfeXmAbX5hQhg1ByCyaYLLWV6QnaCP5bA4hte6/2yBdcvmXum8SdM5g6TGnVrMpuNzqP1MOIuAejYyBuqZKrPFdu4ESUri2WdwVRGaJZz7WoQjbZelPb3YhSjjVzjIqz9jE4NEA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MBjLUyi7AOIEhi0yIo2e4UCj0y7bktwg6OG6vaPOWHVlUJZSCTKsE+1CGVmTryAtGC9oiF+3E4xG6mJh3TMFXxPyWVd6bxZnXF2R+z4erta94YcY3+Yno1OE4se2ZsSva0FX5/Ny/iDxeuiMQOrP9xXj/kJAOfxoN0nJFgLwFeeRvPFeavIQ3Ookmm+rxVZdBW5+Gm4PCyGgNvHexd/xbIzvUtS+P1XYFs1n2Zi5Y10ypIMVp6/e/cTdDr4LADtkDkEcS2gHU+38GJqYbatQUXGjEfIHWJA2tpEFBLSTVKttxmA8TUV4lw+eIl/XAVFTWBjCCp+tzDBPpjgv5PW41y+3QypJwdLNhKJVxbPDKfO9Qh1+sHIK3F0UzaUTOZyNOiElx/+4UejLBKyQ7b+KAvrcSgUlFSOKzCuNJ14zQpe7M5g4Pv6rFgIY8dnnZCd1ce/2GNHJjRAc4vuL9jrxRsQsV2VcvG4lV4OHiv8LbliIpSbIMdaNuRRntYn2FjNhTmNuNFswMZDZlsiSnG4OGjBbfnyunanSgffk4BiQyTnLTu3+7azpddaYhTiTx+9J1hIEcA00mOUrIw9xbUM/RbjtuyLRL2sNBHUTI+TXsiE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f614819-6fca-412e-fe8b-08dedb6fe113
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:04:29.9830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qh+BwoLsmOK3twgX4Xg7fMmxNdWmLKZHKnx/uzJh71v3cCAH/0hIntySq7UNB8rwd10tsQxpaIJdL+fCczmgMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997573
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060153
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE1MyBTYWx0ZWRfXzI+Pq3NCqvRQ
 9Vq5NPi5d6eJLwjU1minobAWPIFIwcDjWBnjcuz3/OSyKOWucw1BsxcNcexXwQ0sMY+fX5cNWGs
 1SCwd5j75D/CpfgZpv2Xn+axR8LKHyA+xjAcn3b+bou266VGFKSG
X-Authority-Analysis: v=2.4 cv=QP1YgALL c=1 sm=1 tr=0 ts=6a4bc401 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=aaiQL0g2587lZ-FksTQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: lUyp6Of5YqMOUVfjv9eS1Exs8BAUvyEG
X-Proofpoint-ORIG-GUID: lUyp6Of5YqMOUVfjv9eS1Exs8BAUvyEG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE1MyBTYWx0ZWRfXz+P4aK8zM+yX
 +CDGaY410S+PRQ8PTiC2WTnQ6yXRy67edhb/Oe5KlmDcVZqJpyEn/MqN7DGoB63mBmme8/j0vNa
 rLRUWPyn/BzVTjrn97nfFGAK2NVTy7Nof2VNwJsFn3MgI94lqnkaZJ8HR/ar8wEF1sOrSzWLWiE
 /YRqrJeb4EUROhPYKhHO2gSBZ12LDB4Jtf8XbOweEaQAI/flVtoqU5k/2FfaQ8dshUZd4CRUJQg
 d186XiGG5ju4x46c116isaXP9CeWo7k7KHCayro6bkHlpKGMy9mU3rwle6n9lSF7eiIxFCXa3wh
 oWeqTYvbZkXNJFmAKDjBVVrnRu/cfW3ajygn1a/VOlSKzR0pZNHMoZHu/y9wP37La03jtEm7z5u
 gZrYB72zf/PV+PzD2lZm1/A8j1k3Ajhy0F/IGeaIiw3UplFE4dSDZXvHYNdSJItKxMW+I+lP+pH
 bPTxvUetvU7Xvrxm61Q==

On 03/07/2026 12:32, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> 
> New issues:
> - [Critical] Unsafe lockless access to `scsi_mpath_head` in `scsi_mpath_dev_clear_path` races with device removal, causing a NULL pointer dereference or Use-After-Free.
> - [High] Adding a blocking synchronization call to the `nowait` context of `__scsi_internal_device_block_nowait` violates non-blocking guarantees.
> - [High] Publishing `sdev->scsi_mpath_dev` before `scsi_mpath_head` is initialized leads to NULL pointer dereferences during concurrent block requests.
> 
> Pre-existing issues:
> - [High] The error path in `scsi_mpath_alloc_head()` double-frees the `scsi_mpath_head` structure and its associated resources.
> - [High] The error path for `device_add()` failure in `scsi_mpath_dev_alloc()` causes a NULL pointer dereference and an invalid `device_unregister()`.
> --
> 
> commit 848d562af61faa57ddead6bc3e5e7a75ce63ea4e
> Author: John Garry <john.g.garry@oracle.com>
> Subject: scsi-multipath: clear path when device is blocked
> 
> This patch adds scsi_mpath_dev_clear_path() to clear a device path when it
> becomes blocked. It updates __scsi_internal_device_block_nowait() to call
> this new function when a path is available.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index daeb3693fe559..3c493068adb98 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
> [ ... ]
>> @@ -2923,6 +2924,8 @@ EXPORT_SYMBOL(scsi_target_resume);
>>   
>>   static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
>>   {
>> +	if (sdev->scsi_mpath_dev)
> 
> [Severity: High]
> Does this early access race with device probe?
> 
> If scsi_multipath_sdev_init() publishes sdev->scsi_mpath_dev before
> allocating scsi_mpath_head, could an asynchronous block request see this as
> true and invoke scsi_mpath_dev_clear_path(), leading to a NULL pointer
> dereference on the head?

this should not be a problem, but I will change to alloc head before 
publishing sdev->scsi_mpath_dev

> 
>> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
>>   	if (scsi_device_set_state(sdev, SDEV_BLOCK))
>>   		return scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
>>   
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index ca4ab720c19af..0f3f3f9fa5fae 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -113,6 +113,17 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
>>   
>> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
>> +	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
> 
> [Severity: Critical]
> Is this lockless access safe against concurrent device removal?
> 
> If scsi_mpath_remove_head() drops the head reference locklessly and sets:
>      scsi_mpath_dev->scsi_mpath_head = NULL;
> 
> Could a concurrent event hitting __scsi_internal_device_block_nowait()
> unconditionally call this and blindly dereference the NULL or freed
> scsi_mpath_head?

this should not happen as the sdev should be nearly removed when the 
scsi mpath head reference is put

> 
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +	if (mpath_clear_current_path(mpath_device))
>> +		mpath_synchronize(mpath_head);
> 
> [Severity: High]
> Does this introduce a sleeping call into a nowait context?
> 
> __scsi_internal_device_block_nowait() is designed not to sleep to preserve
> batching optimizations. Since mpath_synchronize() typically sleeps to wait
> for grace periods or draining I/O, will calling it here break those
> optimizations or cause scheduling while atomic panics?

I need to check that

> 
>> +}
>> +EXPORT_SYMBOL_GPL(scsi_mpath_dev_clear_path);
