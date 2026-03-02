Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6882E4400;
	Mon,  2 Mar 2026 12:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454041; cv=fail; b=T+uZqbxhR6W7M2DgJbuBqB5GOaFhH31W0c8pLZtgZCDhRXu9XxHhvXjExJSo0kB8j997IC3pdn2EJJPEvWAQ9BYr1UCXHnjNDeeg2HC6QxLC54oF719L6RV52sQ48G64lCnPhvj/myDjE2gArGaxRBViSB3RmuxuOhjLndfo+RM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454041; c=relaxed/simple;
	bh=P9rKeAi+mgmqtjg7QoIxo8pGVilpxdCx0qY1QcygKrg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IK0SkfWGmTCt4MC0eX6ZNltlPNno6K7bhwkoSkHNxUCeZe3Jhk6GsG0lS3dqGj+N6cREyBWtZMWUUhAPlfH9Ot1Z20ShkD+s0Fz6Z71KJGwGoWuq5P1XpTzQRQosSVgzVATFxKbEZ2RFuYgOPFIqZly++HWtqZpqdRBpvHLa4Z8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RHI91MXB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=do96k2jv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RHI91MXB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="do96k2jv"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622BZfZY1808259;
	Mon, 2 Mar 2026 12:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ag9VHydv5j9zmSXdOXW7WWftVb9P+gtTu97pU1Mu0B0=; b=
	RHI91MXBdRwDr/MHH84nHzdmP5mSRCToFyn8PICfb/rTrGAh9utFpQ21Cb/Ccsmy
	wMsFTrxRrPEhMJfixDOLn3YqHDT1kcsD+yb7Z3WeYquN4s9LAfrWJP0C14SIUJwL
	fQrQayQbm6Pk4RnVUlx8yvn9Ypz5l9Duw4pwpKUgVo0+nyKuEQ0SZCDMhkXI9Yjy
	TMpgaYG/Y1QzuaOzM9B+xf79duzFdti0asKwryXs/5y6Mxlf3QHBCL8GjRNglRt8
	rN1Sp48HkfOfo7Wd8RZ+sOu9a9BIl3eLm6h9FZ6/nTUdfAh4cpMls4Bdx0Fefko+
	SozAAuIg2rlulPtfkA9qsw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn9tgr2jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:20:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622B185q037177;
	Mon, 2 Mar 2026 12:20:11 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011024.outbound.protection.outlook.com [52.101.52.24])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8ksj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:20:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yba5eFgB+jtXEhIWaJFTZrzCdoF2CM8noSMoz+V+j50LY2Vi5c1/UCloo5YvJqqhxrUyQS48fR+556PdcgwMquz/6TxC4OCgdMLfo1aIXNCIQmo/8wEVNA0/zeoBfhuzij1+YyAsyyGmsYax49mJBGGaZ9CsXTGIdNOm8rHAwQ4qCp0U87k7SGsSXMtI+YiKBRIhXSf6XS25oTRRummhGiO6mblT/FNwZr6XBUY31CmVzrDl1oMF3GZcKKFfJzgBEaqy6a2eqtBTkQbfJTv1GfzRImn/f4VXldbuUSbQ4LRqtYmvTSyeM+dd55kY+FSfnwph1rjiKai74C9NaLmv7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ag9VHydv5j9zmSXdOXW7WWftVb9P+gtTu97pU1Mu0B0=;
 b=jMGkwzSMfxdwWFTLCm08hOqPMysiNhEC3Rnm05Vdr14UyvRWZmceJCNST/iuKjj34INcDMGJasm1A8gZ7jGPlOPlXiV4jpLtOK1GlcNrpF8+haPJWaPKn9i9VeKy7XsEc3mDftUxz4q2MoPMbcATn727JYHaH6hXP7cK+RSbWBJgtc+q8R3RmlwP6pj1KiReYit9qjDmZkLW6F5GX8yA23ApV5OvoLaLWs65E6tUDfQjTykvDqNdeyNpyuFEh3dMznStNwPRXDjQZONLMLMNrBX+qKTmOGBlmj+JMW7ySZxtw02/8ozLeToCaclPf+KV1vEdggujlI0urJKUXcuuCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag9VHydv5j9zmSXdOXW7WWftVb9P+gtTu97pU1Mu0B0=;
 b=do96k2jvtBkKfBaQb3Z76gAuazUieDSnRROBWEXLJF02BGz11PHYgtfYU/CArpQJpn4XUeqBoTEAxGzoS/eFl/ZgUs8UAx6/9piaScWxkbK3S3CLu2Z1r51eo3zdHz5f/pyShP1QGKktUQlZ5ENbAgmuVLLBX2tR9keMh8f4GIk=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5035.namprd10.prod.outlook.com
 (2603:10b6:610:c2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 12:20:07 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 12:20:06 +0000
Message-ID: <003df5ab-957c-4ef1-8ba0-b788451971fb@oracle.com>
Date: Mon, 2 Mar 2026 12:20:01 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/24] scsi-multipath: failover handling
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-10-john.g.garry@oracle.com>
 <aaUKxeoT69K435UE@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaUKxeoT69K435UE@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0524.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: 71a437ec-41a8-48e9-c3f0-08de785609bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	1SHMZZDUY9wVDqE8N7EpERr7IWI1fTjSU5Ai8D6CwMN6BqA4K553bteU6jL1rGOcQzrI9uBIb1pDvI3CHHJPkxFj6H6WteljqNfB2w2uLC+TQecwBGkPOPCPLPMvnHyQBw9u0fOHRQDW8icRllvw7qrrSApNEnAo8JtiYTT3r+jsKIYL50bibtsGthy9zHrxqs8WF7elGTvMcRtsQ9/WuJX7xCq21XfDLQmjp3Wljk6ZNsyJwVzlGqC5NOXjnLg6OtHwNIytJug0c9ANaabDGmk8BYhIBzxiNVHAgBIOPpfj50zXYf08wLR6TGa6el1wYSjsQA1qcA0JFAJ42k85ykBMCx9ajpIYmtqhVwqmbndpc+S+TirxhMs07eMDgF6gXFl3rm34EwOjXKTYIsJLF12X7gXpEthv62GwyKYZVhzzJV6rD+9uppcZr6iXpdcQ28oas34deC8WwINml3QHGiVnSTJSN095Rr7mNRZ2HL3QXzQuvaW1tJQqaGUzjyE0lLCHQCWmoMes/qd1KaIMq0sdswiTmQxUv4/NjJ6o+RKWccCx8ZwMv3dE0OgNkLyzsditXawa77dIWBrZPKunfiFPAHD0PC53K1xV1I6JEXQmFNeWub1DgArxRWlXlKiK47QynMHaF0Aroh9w29DXaF6At3qDUaq4fGhk2mznqqhfjjDQOTbfpTbmJsnHWbruDblyRV22tlHqMED+XQ7x5MI6JQUibUJvgngoj49rws8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2RGVTNVbGJqUlYwK0xqcm5XMnoya3BTT3cxRDRHVXBwKzBhY2diQ1pjMENh?=
 =?utf-8?B?NGtzNWhNbFIzaE9saTBLOFF2Q2NTRkFrTUN6dEhpUHFRR1BYaDhIT1JHK2th?=
 =?utf-8?B?OWpxRFUyRHpPK3BFK2VWU2ZZaDBZaFVCNHdvWk1BSm9LNktKYTJYTVZ5eDVt?=
 =?utf-8?B?TW9zYUc0Qjg5eFFNU08yQkc2eXBYM1o1YWswazBzQ1JITXFTb2VVajM2NXRP?=
 =?utf-8?B?c1pHNHU4RjNzWGJFc3ZRL1ExanpUb204WU1BazJsQ0tLVU9QakMzUjl0aTZK?=
 =?utf-8?B?clF4bHRzd1FtcFNxZy9UWjhJNGhwbWF1MmxxTVV6U2VyTFhnUDJLMjMzRUxq?=
 =?utf-8?B?NVJabU9pSDVONzBQN0NibG1iekRwT25oUVRpZ2lYNjNpT3ZrYUtLUk1sRmJR?=
 =?utf-8?B?dWo2TjM3YzE3THFZZXdoeWxVVmMxdkxWNHpnd0RjRWdWdncvbFN5QlpXT3pK?=
 =?utf-8?B?MEtvODNJWVQxb3grMEx1WUJsa1pqbE1MT080T2xudnF6bEJpenlvN3lodSt2?=
 =?utf-8?B?UGhVR0g4ejhyVlhtSUdsdFViOXFlR1RXZlI0Y0RWZDMyK2VIRHY5VDQrcGZV?=
 =?utf-8?B?eUxoYUhZRnhCckpYL1VEb0ptbGZiclh3ZnArQTNpa0dXTFJUbDNCdHpWZVBM?=
 =?utf-8?B?azBMZ0dLL2xPMGptTzJkVzd3MmZhelJVRVhnSStUVkpHYSsrcE04K1RsdkVq?=
 =?utf-8?B?Ti8wN0tVbWVlZGw0Wm5kTkVQL1VHV09ORzNuOFY5RVVvd1ZJWHZTZlRVQUdM?=
 =?utf-8?B?TU9uZHV0NjRSbTRtVWpPNlFITFdMS0hKSWk5RGk4NDdhWmVIWGdyMW5EZ3d1?=
 =?utf-8?B?cHZPeDJQUVNYYTVXM281aElUWEQ2RUdzclBDbXBTc0UzNjNqMEl4c2Z6cS8y?=
 =?utf-8?B?ZFpXU1NTRHRFNTB0aHNRcU5OY1NrRkM2TGxSYy9kWmNrSWsvaDNnNi96d2RT?=
 =?utf-8?B?djBZTGFxVE9DUm5EZ2NMUU9ZRWJwZGZ4NEQ3SjZwVUs5RHBUb3g3WjhzUnU4?=
 =?utf-8?B?by9NZ005RVF6RmJ5ZWVGWXRkZmxPZTNxVXlHTk9kVXJoZ1Z4WGR2OVA2NExB?=
 =?utf-8?B?endad3ZMQlJCTmlHaklNalBVcDA0eGNhZ01adXlGWUlxMDh4R3krN0ZZQVZK?=
 =?utf-8?B?NjBrYzl5WFRDYzVGSjdMdXlmNSs5dTBybkVucGNVRUVOb091RnFzOEFMenpo?=
 =?utf-8?B?UURvdGcxWFlSRVp0SnB6VlN1bk4xd2REMUVQdVV5RHFXMXJia3E1T3c0UUsx?=
 =?utf-8?B?ZW9SK1NJYnBiUTNoQjNTVjRuWG8wTStGSnRacEhzSER4UlJWSHBOVm1XcnZ6?=
 =?utf-8?B?VkhJbWFGR0xDMjlBQUQ0eGJKbUNzY0JlTTN0N2w3ek50d0tQa0tUK1lDMUlv?=
 =?utf-8?B?N0VpOVJSM2FIQlhZOHNpQVZzL1VPV3FvM09kUnVYZDh0bWFabmtHaEJFaDlK?=
 =?utf-8?B?NzRSdzN1ZUdFRWI0VlVFMlN6Q1VDVlJvS1AzdEhzWG9ycHc1dWNNaDArYW9Q?=
 =?utf-8?B?UFZheGM2U1o3Z0xzRDVESzE5djJxVjgremxkRjRPMDZRaVNSdmlCcGxCb1V0?=
 =?utf-8?B?aW9VbDBwNXFCNWFuMmlzeld5eTlRUVRpQWZRcWtWdTR6aTNva0sxOVFkWFdv?=
 =?utf-8?B?THM3aXNFMzF1SnNEM3M1d0ZkRmtQYjQ0Q2x4OUk4cWZPRS9VQXBCYUE0VUNO?=
 =?utf-8?B?S1dGTHhTSnFhWHpnKy9yVFV4MERWU3A1RHBZUGl3SG5QSVpvUC9lRVVsc0Iz?=
 =?utf-8?B?dkNKSnBpVGZlMEdNUEYyZ0xJMmwzRnRCNThlR3hKZlNLUGpteHA2US9ndUdS?=
 =?utf-8?B?Q08yNmNNMGtZMzB0dXpBZm9PbU9Mb1dzVjUvTGhZeHBIcnVKK0JjNUR6WUgw?=
 =?utf-8?B?eklzWHNUNGVtTEdjbHo1ejFlZWZsRmhkTW9lZHBIREY5TnRXay9zYzlobElU?=
 =?utf-8?B?T0Fma1c0UG1RMUpabktkUkV0WVZsalFwbDlQdjNOSlhUYU1PTXk0NEJZL0gx?=
 =?utf-8?B?d1BGZkt3a2RqcnhFbFBJSVQ3NTMzaUZIcjRrL3BxRDMxc3FsZGY4UzdTVnEy?=
 =?utf-8?B?V0Y1YmJUWmtURDhPZmtDTkFKSnZZdzlZOHJZV2s3WTlIZmk2dVBBNjgxV0NQ?=
 =?utf-8?B?dmFQdDUvdWd6UTVrdmRLbDZIOHg1R05pMTVsZmVoRjhLUnVIQzR4S2hsL2lM?=
 =?utf-8?B?M2J0VjkrWXVBVGZkbVcxNWZFRmRCWks3VFp1dDc4ZCtwMGhwbWRGei84OWVW?=
 =?utf-8?B?VVc0bFRScThqdHhCTE03d2dzbHA4RWZrWnk4aDRRU1RrQW1vSjhLcEtIejR1?=
 =?utf-8?B?ZFVpWU9PUEFHeVVzc2x0MUJkZThldnNRNHhvMVd1RnBvZmswUG1Pdz09?=
X-Exchange-RoutingPolicyChecked:
	o7avYDk18/H5eMZd03gBsqpXN/uzXgl1InnHQvpWYqTskZcmEnScBglBOVtwImrFGktXPm+oF6vUROkg5Uf5v7mkvnWqxOT5MLgTWctbqqJjEXIkZLoELnu35JWD22lMmuSnqFFq9SJQAwi8b6ZdDFslngH36qvC6u2ufswz5PIuT+VK/k73Nvm/28FxbDRpXOzWZYoNBLdQ/B0ikKjcchlwRsYNHAR8VxVefDx+oFE3uXfVGOykV2/L2zmEAIXO+8yEVRQYJUR6vS+ZMG+iU4I8XMv/W730hG1OwfdbClzZyG3j+K7jR3NQ4eAFvo+GGgIklb0RAHUJ6MhICoANoA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Kj//rCbItOqADfLn8STQBHfhnKotFKnQMZt2ItPMjHGztFzBv/d0mIVTzwZRI70gyztMBxR872B8H1Xn2iljII6UEX8Q6ikYLb8xquVO8l3fV4Q15RYC5ES+Z1cbUAAIOCVWD7LEQohQYvFBZ83vbX67O7CSF6XW/rZUX4f+1VUn4J4MyQdkUVm5xgDb4yXkPR3M3LVEzezKSlOWgZeMbu873LqjMZRDuJLmv4mdXLvDw3a2os1GJkp52OH3+6cQkWcB9Tr+VS1/aXEVYJzqQUo4zmi+Fx3hxQd+D+mBhjxgxuZ7SSfwJPAwsuWD6ySW7fFf4vZe0OX713WQ6Rpd28To8igA2hjc7eH4087xkNSBLlFk3l4goALp4cgb6kq5ICB13+wImLnli+0spv7H/WsGA3JG+f6qn45JwVXRDVRUcRP4C4YEqLhiNTdNU9YMIgAIJm6HOlmoSCpwsAg3XJKYfj4CjZdgaf3J+pszGigxDF/WdJsM+JLMTKAbIbia2n+qflje82Y4/tuOChQR9CTiCnYCxV9Gj7lbkWE3uJhGFmjos0ln0cXNpbE21P2djwoOiANNNtiFUhql7fSe1zuZfTsZctx4mxxucIaXSZI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a437ec-41a8-48e9-c3f0-08de785609bd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:20:06.0384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5+PhAiqGkrZck6lLZKPZ5A/qEmm/gSqb+N7Qdne3JQx1h3wWYjsxzo0sili52hMMA9lHrMHigDg8Net2c5/6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5035
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020103
X-Authority-Analysis: v=2.4 cv=NNfYOk6g c=1 sm=1 tr=0 ts=69a5807c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8
 a=adJUw2xki9zCdRIUkkUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Jnw45C663ElHyPOvXlulJldCoiSb95cD
X-Proofpoint-ORIG-GUID: Jnw45C663ElHyPOvXlulJldCoiSb95cD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMyBTYWx0ZWRfX/qg6LiZKAZm6
 fBLWeo140898m3XTVmJsCp30Q7anhbmm1XwaWkOiZ2tpSEkEV5pOqms6qu8uhavLC+apxPfqWBB
 Y+5EDYPlCIL05SEaefEYaQ/0dWu05lTLy3/SIQb3OI0evsDLEApi2q2BH1WiSTTHraK8Pat6lRS
 gKiTNT4fd8rvwrzJbK4zg+yX9VpjsxYJBObTv4Re+qo7Ha9mSg95EK4PmKx7XCmJWVXZEhVOcLu
 TD9auRdUZ4v0jU3kT1D/k5IUJR2nyRQepbK0/DFvMr6sp1lDSe2RKX+fD3zQMufrjTbZu9AGmH3
 YwRvlh/Jn2DTlk53UL1G8+qGsO9lsFo7bT5qO/3Ghs5Xqa5W7HHZifzKQSbDDe03ZSBAGLI9W6T
 ksArNxGnHNHyZ750X/GvioVtCObZ6o3KC4ekjavpUqi97/Ry2hYABAFGdF8m+mSU58qWI11SOhZ
 bEgsR9ZCvwAxxPbI4cA==

On 02/03/2026 03:57, Benjamin Marzinski wrote:
> n Wed, Feb 25, 2026 at 03:36:12PM +0000, John Garry wrote:
>> For a scmd which suffers failover, requeue the master bio of each bio
>> attached to its request.
>>
>> A handler is added in the scsi_driver structure to lookup a
>> mpath_disk from a request. This is needed because the scsi_disk structure
>> will manage the mpath_disk, and the code core has no method to look this
>> up from the scsi_scmnd.
>>
>> Failover occurs when the scsi_cmnd has failed and it is discovered that the
>> original scsi_device has transport down.
>>
>> Signed-off-by: John Garry<john.g.garry@oracle.com>
>> ---
>>   drivers/scsi/scsi_error.c     | 12 ++++++
>>   drivers/scsi/scsi_lib.c       |  9 +++-
>>   drivers/scsi/scsi_multipath.c | 80 +++++++++++++++++++++++++++++++++++
>>   include/scsi/scsi.h           |  1 +
>>   include/scsi/scsi_driver.h    |  3 ++
>>   include/scsi/scsi_multipath.h | 14 ++++++
>>   6 files changed, 118 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index f869108fd9693..0fd1b46764c3f 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -40,6 +40,7 @@
>>   #include <scsi/scsi_ioctl.h>
>>   #include <scsi/scsi_dh.h>
>>   #include <scsi/scsi_devinfo.h>
>> +#include <scsi/scsi_multipath.h>
>>   #include <scsi/sg.h>
>>   
>>   #include "scsi_priv.h"
>> @@ -1901,12 +1902,16 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>>   enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
>>   {
> I'm no scsi expert, but the checks in scsi_decide_disposition() don't
> look quite right to me. You only failover in cases were it the code
> might want to retry (and when the device is offline), but there are
> other cases, when you don't want to retry the same path, where it would
> make sense to try another path, DID_TRANSPORT_FAILFAST for example.

Yeah, I need to check handling of FAILFAST-types more closely.

> 
> As a more general issue, since you are already cloning the bios,
> couldn't you just trigger the failovers in scsi_mpath_clone_end_io().
> blk_path_error() can tell you which bios should be retried. That seems
> like a much simpler approach than trying to intercept the request before
> it completes the clones, and I don't see what you're losing by letting
> the clones complete, and dealing requeueing there (again, I'm no scsi
> expert).

Sure, I'll consider it further. But I am thinking that it's nicer to 
keep the error handling centralized and not have FAILOVER specifics in 
the cloning code.

> 
>>   	enum scsi_disposition rtn;
>> +	struct request *req = scsi_cmd_to_rq(scmd);
>>   
>>   	/*
>>   	 * if the device is offline, then we clearly just pass the result back
>>   	 * up to the top level.
>>   	 */
>>   	if (!scsi_device_online(scmd->device)) {
>> +		if (scsi_is_mpath_request(req))
>> +			return scsi_mpath_failover_disposition(scmd);
>> +
>>   		SCSI_LOG_ERROR_RECOVERY(5, scmd_printk(KERN_INFO, scmd,
>>   			"%s: device offline - report as SUCCESS\n", __func__));
>>   		return SUCCESS;
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index c3e0f792e921f..16b1f84fc552c 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -518,6 +518,86 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
>>   }
>>   EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
>>   
>> +bool scsi_is_mpath_request(struct request *req)
>> +{
>> +	return is_mpath_request(req);
>> +}
>> +EXPORT_SYMBOL_GPL(scsi_is_mpath_request);
>> +
>> +static inline void bio_list_add_clone_master(struct bio_list *bl,
>> +				struct bio *clone)
>> +{
>> +	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio;
>> +	struct bio *master_bio;
>> +
>> +	if (clone->bi_next)
>> +		bio_list_add_clone_master(bl, clone->bi_next);
> This is a pretty minimal function, but a request could have a lot of
> merged bios, so you probably want to hande them iteratively, instead of
> recursing into the function, and eating up stack space unnecessarily.
> Also, this reverses the bio's order when adding them to the requeue
> list.

Yeah, I think that this function can be improved. Self-calling functions 
are generally nasty.

Thanks!
