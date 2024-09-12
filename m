Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA221AD276;
	Thu, 12 Sep 2024 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153116; cv=fail; b=kh2WU7XPC85aG+8uO8Zg4zfBbYuIBgqJnjIQGiz6/AqdowuZWK265oCIFKcaxgp2kzmlG4NC8+jdExNweigbVzCa6RKoUD0ZjXFvCY8fvNW/u/yaV340wblTrKe2F798OMIL+UsE24hZ1JRi2UufE/ToM3nnvKKTrcM8Dv2qIts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153116; c=relaxed/simple;
	bh=n8Usf2UHTtAPI+5klh41osmUTVyCvpjgmPhMniWRKY0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lFTOvB/hudjOf07sXhxm40/3AS7PJ5UaZXX+AzuLCCc0O1IQCo2a6V/NZnZnXDFdd/hKFC8NveWoLfMlRqnywhYNEWxsSlahJk1Nkusn5oobnFq1V+ReaZBBUGQUjeDvTa0Eikx7GApnj0m4dq5V5ujcg6zdfOQaAvlVltl4U38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GrzqdZ1d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G+Ok6D52; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GrzqdZ1d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G+Ok6D52"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDtxdK007136;
	Thu, 12 Sep 2024 14:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=QgbAwVar6WZvsITorAfa+AoBK3nZ0y2P3/fZTkgA8Eg=; b=
	GrzqdZ1dfHFe523RL2vRcdEWZQ+PpNUBn1P5vcGHAdtoack8UcDFLZ7OSqBPJ4pa
	VWC04ANZyiZSvQfI9eFoYiA0povUVSi348gtuW6t2Ca7RV7sbRDH3JVyUhgsTzH6
	rm7n1oBp4d+TNOKlZv62VoM31UETqkIPsAkkjWL57cpg7zR7FmcNBYgOtDHcX4gN
	cavvhJbiYMQIsAQOU2B0ABIWIKbtS8J57NO1bwjC/x/WmyRDky2PPSL4IO4jgxtm
	Ih6GPouH6VadTWozEEIrBfUqoSHqqJ+qN3wQTDJ7ZtUiKZnAcmJxhCLfcvE5aSA5
	eBFYqPmLT/LfnRiO3SvdzQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdrbb49d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 14:58:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CE8HtN036128;
	Thu, 12 Sep 2024 14:58:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9bdd9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 14:58:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSBDxORaUkLDzndvRnmXPWBI+Ppz46ymDNyusDp/X6n9RfV/v61oKMwFjE7R826OtCx63Qy8ZaOqSOoemP1HwxAkudkjaNkoHcBEQjwuDTRY6+r8Xi3VhoMiZA16BjfLb83cnsdqcvJWySwcjsM5Am5+ueOZPwypvkAkKoQNef4QjrPk/gIX+n0FDu9d8e2XaZ0gKLaZWLIpRSCBQpbEiqRLv0rEU8pU8IQT5NUhudIVSf25Xb3YAEcPvHkGGEJNCM3ArGO3eZc3vw3iQkrUaEeR1L+RqCuTa9U7kiOdWW9x4bWMmswO5sCiMbr04vPIVOqO2mxuY/Id6rbelXVmaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgbAwVar6WZvsITorAfa+AoBK3nZ0y2P3/fZTkgA8Eg=;
 b=jRaiCeiTdf9sE/E1YgrgrNJcSiEJB35osGEHko6nt65JqoowEZDrSiedVLETIRQAM5PzABKBRpNOhomX+TviU7J8PF8pGil4OU/yt2EyEPDnbNmB0OUaRTmaKcLSOjNRSsL9H5YCiNr/ac2tMyJn6ccLIqOrKM3NCVMmC3GATivh2WvWttbL4+EBMsMl3+6/sNA7HgFGPrAJ2NuVxX6KezWatUaNvbtFf4GecLL8ZS/ixq7xU6TncBhsJt+VYbmcBx8bA91v9qJYR11oNAAHZ+8RmwB4WrdYDsN1MNSgD3R6RQc9z71RJLN5gQ2PiNsSXKfxAL4JkgVXSl/gojeQ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgbAwVar6WZvsITorAfa+AoBK3nZ0y2P3/fZTkgA8Eg=;
 b=G+Ok6D52zpMH97hB5jUzeAdKU1xhqGUhoLzunGQUW67x82ZK0dqlr8RS7PwUJju0Hq+g9cYEpvYFLiAnijbcmy2BDKvPrZUtHPoaP+UVvsF2re48aXEK3YkxP+iyXbhTY2uC4h603gBmp3SuSd2Mb1SpLqYeukWlDUhmSdY0Y6w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB7078.namprd10.prod.outlook.com (2603:10b6:510:288::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.7; Thu, 12 Sep
 2024 14:58:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.008; Thu, 12 Sep 2024
 14:58:03 +0000
Message-ID: <0f2652ce-63e1-4399-8414-0bd150521e1b@oracle.com>
Date: Thu, 12 Sep 2024 15:58:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/4] block: Make bdev_can_atomic_write() robust
 against mis-aligned bdev size
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
 <20240903150748.2179966-2-john.g.garry@oracle.com>
 <20240912131506.GA29641@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240912131506.GA29641@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0033.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f76df4d-c756-4065-3b80-08dcd33b4d2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFZJdGdwL2Y0OHM5TnQ4dFdIV1MrWjFIMlFLdEYrUzNnYzgrUXJMTEd1QUZK?=
 =?utf-8?B?TjIyMjdLV2tMbEdXTlBxWGtFUjVxZGVjbWdYQVErbldaREdudVMvbFRhWkhW?=
 =?utf-8?B?TStTZlBoc1JrbFF5dzNuWXBNSU5aa0xoaFVpdUJNb2RrYzRZanBxancvbjBw?=
 =?utf-8?B?N1NubGV4UTNyRVYveSt6bG52NGEzdXNESWZmcFA1MG5tMDlZNy9ySERqNjlp?=
 =?utf-8?B?NVVOMm4zcXhnRDY1SE5ZRXNXa0JjZXZnNzBEZXdINitzZkZRd3VEL2JsM3JI?=
 =?utf-8?B?dGR0YU5LdFJLek5tOVJudWNVdFRPZkRxc2NwRURiYkFhUFdiSmo2ODF3WTdy?=
 =?utf-8?B?QnBDU1NCK0t6ZzNUY1RGQWJ0a3NiMGlxWFgxdXh6L0xKV1Y4aUVrMG1KZ1Fn?=
 =?utf-8?B?c2lPSjExaklIREV2bHhyU3BUUkxGdzhjQ2Zxc0FHVDdWUjNMV3VOMjNBZmxl?=
 =?utf-8?B?bEFLNjBpaXptdTk0NElqeTRpSzkyU0djb2pUNzI2OWlubGpvYjBCdGdja3lP?=
 =?utf-8?B?emQwbmJBNHVPVTd4aWNSZkVWQjBQNDl1R3hONWlMNi9CK2txa0pONmdwZFd2?=
 =?utf-8?B?N3dCZVYwTzBGekNJQU5tSm1QVVI3d1EzSUlKcDBGK1Q3NytGODIyTVNpVGhF?=
 =?utf-8?B?cXJkMGQ2RGprMkExOGlQWTdQRWVzS0ZBc0xFamtLMmZrODdKNHRHWDlNTUNO?=
 =?utf-8?B?S1hMaElYRm9aY3dFWm4rZFB6dWU1b1oxM2ZWakNBa0FGRklQSjg3Y1NzTXJB?=
 =?utf-8?B?b2xDeVdqNjI2aG9KWnptcE5BUGI5ZEk5elNIcVBFM1kwVWh2VnRDdkVMTmx4?=
 =?utf-8?B?ZjkxMGZQT0Z6aHJBdm9za2FiQXlJZWR1cE8vMkx5NzIwMUQwUHVlNHJWd25R?=
 =?utf-8?B?RHliWHRGOUlxY2cwTTREcVY1bmtuR3oyVkNERmFCZEdidUhIM0U0Vmp0UTZ6?=
 =?utf-8?B?OHJDM2V4ckNwUUh5cmVRb09HdXlnd0g1Zy9CL3VjdzNLMkdOalNsenlhU3ZX?=
 =?utf-8?B?bmI1TEFIMXRkQ3ZsL1h5RS93RXJ6ekVOUkF5dllRR3NYdzRNUVRaYXBBeUp3?=
 =?utf-8?B?Y3JRQUxtL0FiQjBNeWZ6Q2c2dDRtWFByUkQvRS9EcHBPR1h5RG9RcDROWFgr?=
 =?utf-8?B?TEVXZW5lNXNsOGNjbVZkWmZaTkxKNlltYWNYTml2NTgydWtaa0k1ZGIrTlNK?=
 =?utf-8?B?MnJZOThNRmt1OUVVY3VHTjJLMmRJbVhEMWZyRjBmb2tUZGFJV0pVSHU5K2c0?=
 =?utf-8?B?MVNqMXFKeDQ2eVRFWmY1N0J6b2ovQ3Y3eXFLdmZ2c1d5MVk0b29Ga2N6NnJD?=
 =?utf-8?B?VE1uRXFtdEE3bkFRckNnRnBnUnI3UWR2ZzlmWkl2cWw3ckJodGlQT1poSmZI?=
 =?utf-8?B?a2Z1aTY0VlNpOG9zazMwNTA3Tll2dWZUVmJPV3E4a2x4WmU4MUpWbVMwSmxL?=
 =?utf-8?B?UkFJVVNmQzV1WWpNVmRXRXd1cytEdmlQYVRhNGFuRjR1ZGVXb3Q0UnQxSDl0?=
 =?utf-8?B?QVpCNkhvSFBHVVVuZVl0ZnlnK1pLZWwwbmREM0hsNWVleTJWT3Q1MmEvUUhU?=
 =?utf-8?B?bGhBRitJYkYwNlZhNFhxcUVtRFJwUFl5RHg3U2xrbnZnbWcwWnVJNnVxYkpL?=
 =?utf-8?B?VjBEMUFVeFgwZGwya0pIZXhmNmErbVJ0b0c2cUlBcFF3Y0s2ZFNzWXVtVnc3?=
 =?utf-8?B?R1F6MmdRWDNsVTZobFlVK3lFYXpoZEtvZ3c4MlZEZVVrQTdqYmtKMlZjQ0tZ?=
 =?utf-8?B?cVk2ZTdTQWNTa0JhQjVublJ6SERBVEJRei9HLzZKN2ZEcUdsZExmdFcxUmRr?=
 =?utf-8?B?WHkreFRXdVhoaTJic0dyUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEQzUUllcjh3Zk83NXRWN0FFcnJ4RzVyVHNMWkp2alFGYkswSHhkYmRNNDha?=
 =?utf-8?B?RmViSW9KTlNGb3JhaHNpeUR1SGlNUG5tUEFraGVMYStwTVFpMEtaTEU0c1Az?=
 =?utf-8?B?VEZDMnNCYUlLbXFlTHp1RGZRYVozQ29McFFNbTFzT3cyeVgyUnVIZWN6VlBC?=
 =?utf-8?B?NHZISmgyN2s3ci9ZdVJFSWE4N3hqK1Ivb0kvMlZVODRDcTFvWGJZZXdaRGxn?=
 =?utf-8?B?Nll6T3JlMzd0TktFY3lsaWxlZEREdlI4ZFYwU2d2RHMveHVpMm1hdWZHZWJu?=
 =?utf-8?B?bG1ZeGUxVlFUOStiTVNhSmpEQ0JLdG9PNHdMZ0RncGFyY2JCUnh1eHZCMFJC?=
 =?utf-8?B?dWIxMWtzN1ZnN2V4SnkyTnFib1U3VElUSFVLdWx4WDZqSVYzNys3Qk1Rc3Bh?=
 =?utf-8?B?L3RZMjdnLzl5N1F2WGp1WFRRY1VhNVZNVFZBQittM2VkbmZLN1lxV05rcEpt?=
 =?utf-8?B?eDdWNFJVNWdydnVIT2UyNnlJQ2NXRmg2cnNMNXhZL3VDRHArTUR0WFBPUmF1?=
 =?utf-8?B?Zk16R3hkWGhSRW8vb3ZQSnJkVUFmQ3gzUWRROHNBcWFCT1VnaDRFenF3Y0Uv?=
 =?utf-8?B?MWQvTGRFc0NkQ0JJaWY5djBDdDIyRmVocHRiZmE2SlFnd00zeWJiY3ByZTV2?=
 =?utf-8?B?Um03cSswM2hDRDNSS2hSK0V5dFFweHJ6Sm0ybmFDSmpyWUxBeDlKS1lFK2Rk?=
 =?utf-8?B?cytGQVZJRVJiVFNnYW5jcmFiVnZWWHlYenJyWDRZUDA4NDZpTjdwMW00UFN6?=
 =?utf-8?B?UU5vK3dNZk5MQlZ0MzY3aXZ4Y1BGWmlNdE9mK2RuYkR5NTUyRW05b1ZOKytM?=
 =?utf-8?B?ZzlKamdrelZjZzQ5cXo4MWgrMXFQeUtFK3BYaUI0RDlRNTFyZTFRdDAzS25l?=
 =?utf-8?B?SC9vMkkzZ0lVaFJnd1BGbHRzdXBCRCtZVk1wdTVBV0RLUXE0NVJVdUVhbzd3?=
 =?utf-8?B?dU1hSklWQW9YVCtmTmVxOVAyTGJLNHZ2YXNhMnNVNVNGS2lIV2NVbFZCQVVJ?=
 =?utf-8?B?ZUEvNnBTWVA1bkdMYmM2eTlUY0cyVy8vdEdLRTE1Nm1zU3NqV3hRMjJPb3hr?=
 =?utf-8?B?anJMbkIyaVdSZVZYaHFRWkZkY2RzS1hjYi9nYkRHbmdLZ1QzK2tSb2QzS1dz?=
 =?utf-8?B?VG9xOGlRRzErcmJ2ZUppVWJpVW9pRGFOZlp3c1JGajFZUy9pY3QrbC9aakdi?=
 =?utf-8?B?L3FmYlVPanNCZWF0aHI3U1RDQkt4MU9hWGNTWXZIL2x3cW1OQnpsUlJUM3R3?=
 =?utf-8?B?WlNyd3FZZGM1M3UyelQ1YUllcDRCUDRiWUlMSnNtQ3lLRGtrbDA0ZjAvRmN6?=
 =?utf-8?B?TmFWR1FSeEJlSUt6UGQ0WmRFdkt1S0NCTmR2emxnb2EvbXNHYkMrbHlLcjVG?=
 =?utf-8?B?bDIxWDArUjcySkxJUjdFNENCemtXY3lxM29VVTV3QmJXVHQ1ZU11TkNPOEN6?=
 =?utf-8?B?K1ZOSHZuS1dNV2Y2TW80VXBmNzhyaWZRSUIzam03WitTRTdvSEk2RHBSMUVX?=
 =?utf-8?B?U01ia29ka1pXVkszcEhXNDljbTFmZklZZ2k0SU11ZjhKN1JxdkpCY0xRN1No?=
 =?utf-8?B?dW55VVZYRHQ0Tyt4Vy9wSDc4YjBSYUtqYjQ0amJxd3hGWU1tM2d0dWQvWHRz?=
 =?utf-8?B?MSswVUNuQ0dleHdrM2ZzbGowcURDWWhheWJlL3A5Vml1U0pGeGpYYlp0enhQ?=
 =?utf-8?B?WjlQT2dpRWl5V2ZTVE9JdWJ6bVBpZjNYMmtYNFVaM1c1Zi9NVGZnNU9Oazho?=
 =?utf-8?B?VklFWFNpL2lxZ09oNXZuWk9kQ2NzYk1LalREbGRyNlNsMlBsUmdaU0ZMMkox?=
 =?utf-8?B?QnMxbmM1OU1CWVAvSjNKZFF1bjl5NG55Uks3RnQxM2REQmRkZ2F4c0MzVTFa?=
 =?utf-8?B?YzVqTWxpbU9sZzdUbmRwM0E5NHpBTy95eDkwb2lnMW42cTdoblB3THg4UzAz?=
 =?utf-8?B?eHhZU1ZHNVA0azMzQTFMOW8rcm8xYnFEbnRLenhxM3pnVWJJcjBVYTdET2hQ?=
 =?utf-8?B?b24zMUoranVNaW5RbzhFM1o3YzBDSlUvekFtWkhuNnRRZlZBQnV3VHFMUUU5?=
 =?utf-8?B?OVY5d1FVeWZiZDdwREhSdnZuVThLUGJPcVJiQ0RRUE9PWVdQdnczUVpBQ1pm?=
 =?utf-8?Q?TvU2xYwrm537xBtcREOJLlRRx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nfw74o8ZRt1N+PCMu3xvGzAxZ1zZHkLFzq2h3XepOyWN0mVI1RdZnxnc5BxwmgMG/U+YVrwTxylvz9indsvBdnPWhj91QB9fYocBB5BqcNnajzd7cJDcTyc1S7s/6GhA9b9AE9hNDid6BxznynzDlR+Ns9f1W7YWqZvo0/+q+KM349JLj8JPiPOUUNahdUL/gSW2jCId//e1wMi1nLQBHS++vXzrBiX/E9dN+4RT7XrDhTwycQ5pr/1KbBMDUxuUdjCk0HZusAO+MVVQkpNdU1p0YOXjEiCv0N4ePQ18cWJ5jdioI+Mf5t+7gXfyJYon4K3PveNw/ivsuIZ4jsUyOhjJ/1/+RDGGa6r1MLoTT9CHRu3W3xetvIcsFwPIItD324lP9XyoJgYzwBPZgs5qTO783PnDRtKmag904AJTJIrFTmRLypitgqxXIjjoTdZiGU9UAj0Wf81UFYyAZcYfwqlb8NpmJKHjtCBRYD9hr13Qw0+4duMwK50e1vr8SY+WGT3XJntIhNc0BqgHQgtPLaXLo2/3TXs6OlIhmK2zrMUEyJzpj7x151q5lPEo2tu8dcjAdJVAiwQZOiSXMukVk49uiSHyCC6v4TCihKwgK7U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f76df4d-c756-4065-3b80-08dcd33b4d2f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 14:58:03.3606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GMgxbd36x3DTOJLDI8UlVNcmbatWyoirB0nzyQ7pX+ygPd5RW4MtTDy/HSDw8YTy/p55/YLefP0R5Sc21OmT8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_04,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409120109
X-Proofpoint-ORIG-GUID: K25RRdT0BM-fjMPK1kZNAfqUj0FhCq14
X-Proofpoint-GUID: K25RRdT0BM-fjMPK1kZNAfqUj0FhCq14

On 12/09/2024 14:15, Christoph Hellwig wrote:
> On Tue, Sep 03, 2024 at 03:07:45PM +0000, John Garry wrote:
>> For bdev file operations, a write will be truncated when trying to write
>> past the end of the device. This could not be tolerated for an atomic
>> write.
>>
>> Ensure that the size of the bdev matches max atomic write unit so that this
>> truncation would never occur.
> 
> But we'd still support atomic writes for all but the last sectors of
> the device? 

We should do be able to, but with this patch we cannot. However, a 
misaligned partition would be very much unexpected.

> Isn't this really an application problem?

Sure, if the application tried to do an atomic write to the end of the 
device and it was truncated.

> 
> If not supporting atomic writes at all for unaligned devices is the right
> thing to do, we'll need to clearly document this somewhere.  Any maybe
> also add a pr_once to log a message?

I could also just reject any truncation on the atomic write in fops. 
Maybe that is better.

And at some stage looking at making parted, fdisk, and other 
partitioning tools atomic write aware would be good, so that the user 
knows about these restrictions.

Thanks,
John

