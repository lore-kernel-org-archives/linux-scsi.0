Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BA93EF0C8;
	Wed, 25 Feb 2026 15:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034067; cv=fail; b=Y+LqKrE7UugmXY0Gq2J+1ygkbI2sIRDtMxDXl7hVM9ZsSIMHhJwCRRr34mQOZbXmge5/4HxkHNqAMKlUbIuJ8K11F/SUfjpXT9ZIL/AxzA5H2EQP18yAVM82n+aJHB3hrbq+ulnjrYOmWOdW9dlSLCfSgkAbrYFKZL8bC/yiC5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034067; c=relaxed/simple;
	bh=87RdzUlPwxRR/bqE6fpDNK9EBnug7Nux0t4Q2eRceZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nloEDj9w330tTYviUeA5Z+Nd7mivOKjtEIRtiGSWLW9LG0zEFw44ueLO85A8NT16LfX9TR2buoW8tVzFj6HsTLJzJ9//RqnglcoN2DxPjrNV2oSy7oxZaV7uWGm6xx0nqwYstO0+l5kfNpaiypZwiAcw8yRAE8AsMID98VnGOTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KWKOT43Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p0MxCWOQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KWKOT43Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p0MxCWOQ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9W7YN3927984;
	Wed, 25 Feb 2026 15:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3Mx1/DFDdsowYn9ZjwNuzOo5z1r8U0XcUKrknSZ+nOA=; b=
	KWKOT43QExZLV8t+tyS4vCaMZOYoBnu+5Bf7HEoDpUVsGBytpx6prLhGgENae5Zc
	wzoXGUyqCwIjwqvdUZJlQ2ou0pqrdnZWoRAkt4FESPtrl6TLjvsQPqr9RzDqKEhM
	ilohDiT4DfnKvdPSy9p8rgRALBaLYwxloTqoU6xYpTUCmkztv3Br1XwZFHRXrfzS
	qYIrwCPW3vmy9TmqhIHEgLEKAZGnDV61sbBC23RfJsOKPM9sgr6PP36PufgiqOHr
	yefUjE22AdrJQhA2WQrP2h37/TsVPGaBKv1PRWfbXjqUYWJe1gZxael3UraBbzr5
	IXr8ATC0+KeFD/Mn4TlGdA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qee8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEPdlv028627;
	Wed, 25 Feb 2026 15:40:47 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7pgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=riwoYHUzg32JKlwqVo8kdpWiyMDjQv5Vnt5miJeZ/NsYCzvbdcq4C/TM1ahh0Z8RatYKNVOboQtRPnFPQku8FjXQwHJDtKI6i33+aweH3qKOZALEFyMb5HYMfvkaZXtKKNzpwQoKX2fS4bWP5jO+qXAs/BwStJEoNv83RWf1DhXt613lcfT6kFZMV6gWkkMVeRbHILBgbmtpyBEgrGeiH5JepPfIFLqGsdkx075jQ3qbI4TFnz9U0XG8AgRzfaKtg3u5AtPSj2ttjm5zQW5hnXEv63hPJY4sadK3ZE2Pq7YxXysuWDWeTlq2nouPYIJZ5n4JUq/k3t/vC58EQr1OaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Mx1/DFDdsowYn9ZjwNuzOo5z1r8U0XcUKrknSZ+nOA=;
 b=xbfjiW4Fr3uG2JzlCu7h/Mk7sGjzU3bkZBibJ2uOFnI9+WBMtvBuwUlGrK7WeC3hc94hIjZh0LKzTTjeB9OEEWRr7dD0vHVnnhFFG9XplB1CZpbqmKR9qTd5ueL7y4HnsX6vIM+cUQcL0JU2slkoVsK5/cuDCO7KTILcurinoW9kvGwwNwy3NkzbKMGsVMFS1TASlZUULMXmBs2xH8taNOJTgKJoswggwksLHWTfY01aeW+7R4/fRmEbjEmorAqvhwzN6lL4qKSymupO7eXCWw0IAHvwxgddLRfSatQHXQs3m8ZqbyQn+l5jnpRZmUGaMEG2Ni4DPrwVq6jw/vdOvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Mx1/DFDdsowYn9ZjwNuzOo5z1r8U0XcUKrknSZ+nOA=;
 b=p0MxCWOQPohzT7T2Tizc5QFC7B8C0myNeqRrw3Ca3cQi74I3bzMnQ1ytmpEhaedFjp2rNBVJz4CPK3s6TXkw44KUMSPWhFJfyUlVjIZpWYuNj409DsgTS8fSgJFwwpEgQPcFz4SiLstMhyaAvdyVJ8TsrtxBzD6CtpSk7XddAUo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:42 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 10/19] nvme-multipath: add uring_cmd support
Date: Wed, 25 Feb 2026 15:39:58 +0000
Message-ID: <20260225154007.1033735-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:510:23d::29) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 565733eb-11b5-4640-1ab5-08de74843b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	acA268g4neDOssKAmbgXbL3hcmkn+M92y9LuYLwlrmutryR2qEEMI7fYBXCXD/BARlWCgFcceSc26KHvsAba4fNrciB+WZiaNhqon8FMR3wOlEj/ibLnM3Mp65oPLKq5xZfM9aK8nbr6CQJrfVU1y+r/9pYJgACJqygxZczVVwYmMXyS6Urhcg8eFQzozFf6uSYpoiZ9rdabdTY8y+WQnrUm3p4bF/YkuvfWifWCt8lbthC0pQIoqQXNkAzeo10dKHr7jR5KNXzQlExpeZSwSW4BndCp0Mza9LopymMS/hwmxAB4q0gwQ5bF72a6HS1a9VqOayxdjBTEPZrnKBzSLS/pU5LK1ipMN/CwKRaBY1S0i0xS2wwQLdpbtzb7tmcGdXXHApXjjFr/g9lRqfQ3DKH9wCK8PVR+VDqLwiSXjDEN5ULU90B0JfSOvuOM+oM3VXEp3iNqqYOgeN7oEZ2GVUQ54hGyOrMKvTMxLTCXjMH1O9UOLHIju3g1asA1npMIJeegZGlv7vi5/m7v4oVtC2vxYda9Zuz1AFFwFWqVNJ8iORD0NQ18CmZY2kfmz6/GIGk5wbWeHfg27tZ4Tro2vX2Jroi3zF5Zj4lN+k0y6gYEam+Zs0F6si/IxSemqkdmArvvXJUMT8FFZioMRwmOQA0THchQ+eiP0c0N1R6mhqdR5v4hakuRKavcSYtfKmjqWAX6VKSQuLhTyDkUDiTcliHjlS4VNFi/VlDhjdRLEQU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bYMyg3cH3dw1iIKo+pNQ+6KQgJQmNs7f1lopBzchSjxdGed+MJfPq7sBH8l+?=
 =?us-ascii?Q?b3uv74fTikBXCHtS7mYg1iJh5Kun0zyMoUMFsL8IUmj6Yg8UJ4c3VRxO9aHR?=
 =?us-ascii?Q?8bl5VICOxzWyphe2f6HbdrOdHNMXxumw4SMRAjI5r5js/kc2mq75DAE4CSK2?=
 =?us-ascii?Q?KHlRG7UlwAtUpnn0ilKKMzEi4k2dvSJP+QZknmQR8sreYw3xFKTTiRCa0WtC?=
 =?us-ascii?Q?/FHll3tMWN/6exOcNGbFsviZkWutFsLalu+DvjIraMT6LnJkD9v0hyhVnuG8?=
 =?us-ascii?Q?B4QV551i5WrTUek+1RvfB2sYtsqjNS7P0kOjags9r/qC84x95X5PrJFDkbWo?=
 =?us-ascii?Q?MP0w9TzvGeR6EZryb+BsWKrWhqlyzyZF206I5nzVKAxhVQr50RGhGHjiVwqv?=
 =?us-ascii?Q?3amEN+AfegT16N59BYQwD4jTASt+fdb1iIaBOE3lWzKrPKN+LmUC9Rlxzhyn?=
 =?us-ascii?Q?jD4yrW/h3udw+9b8Uwsb9BWn8Kw7f9k/NHooyYxhFMHvWf1v6XyIFxSKrOah?=
 =?us-ascii?Q?Q7Z0Uwf4x08U5gnvhAVdraqwHfZ2TWW/C2sOA0Yrhxmf1BPSbiooISRxI8i5?=
 =?us-ascii?Q?1ad7pTqFd1UnhVaRohPTMP74oEHMAGywJbjV6Cd8PWRrwFackR9ShTYg279R?=
 =?us-ascii?Q?oQ1YJZhL+RFbvCeLSpjq6hrccXURFubgjkw7V6xpUWRM7utrW+Emcry46n2r?=
 =?us-ascii?Q?gipak0T6t1bDD7+h7nogIy1pNtYtm+Z4kBKcEaguf5InYNstpy65aZVILoRJ?=
 =?us-ascii?Q?Hk5lC0e5e73gaf+3hSQq0Rj0nNarvPapLsjAcve/QSFtz311BcNglYfhUknP?=
 =?us-ascii?Q?hIm997RbsvlccOBpQzam3HvBzbo5cIhXzxuUP7tVgLZgydbMtmreP0OZXEA8?=
 =?us-ascii?Q?UwnYpWdPPYrFMwH46e3BhARI+34RdeAyLTAIR3/mJkj7SnLhkPQGDXIHAMvD?=
 =?us-ascii?Q?Z21tejwZd2yBxnkP6tEO/m4usAR6RJ8cYrWO39HTfCdZWwqbYAah+HM5VD70?=
 =?us-ascii?Q?3NB6Xq+S8mD5l8dJO8w5tu5RYzDJtBIDjBTWEq8I2bQ1X/XwwQdoEnK5UwC9?=
 =?us-ascii?Q?adzFzrX0J8Vy4dnK8TDZ5JKnM4nUHw9nhYt2hJllOO1RDB5qX8L8WOr34lYO?=
 =?us-ascii?Q?4lUN4v2tzXFN9Vrhs6c4EyNtx++51KEMYW5pvvPSxE0XhLDupwfB/6GZq8Lm?=
 =?us-ascii?Q?dRi8LzhXHrBNLMtYbKyhwYZXbPMlNyH6KgP4Bgi2z9V0jobF6jqeitWGKP2y?=
 =?us-ascii?Q?ww8btwL1YzDeg0wmpmyn4e7DoZoUmUxz/NFqEQbiWI9aKGdRfppG0IsKd2Em?=
 =?us-ascii?Q?v5Pv/ngvvCz/ft1EmNbmklxaJTq6FvK59M4dDsAtIq8xZgIFGanYlagi0M8O?=
 =?us-ascii?Q?tmoMJklOEhdFMxTBPyKwv2KAoz2oSyQLvnG0n74eg8Ql219V+jZe6tQ3EvNm?=
 =?us-ascii?Q?AzoOxTRbmVzBeRwp1+r7QWsiyZgDRIE/2GbPaWzEJ3qu0cbgj3s19wBIubRZ?=
 =?us-ascii?Q?jKb9onfuFHez6vwLP4KQwRybmdVTmqtsznYNNP7npeq6aPvCpGWGpr+zXHa7?=
 =?us-ascii?Q?2eqc+SuHbSQ0j0nbabMjFWmhx12//0EYLUlBPyA2k2aVoUGj1WaijAqTE1/C?=
 =?us-ascii?Q?6lX8ccEvVSYHxFmXklcwcUo9KLwHWzNUAvtEtB8r9CT70aRclxALKYaLnRVo?=
 =?us-ascii?Q?/Kog0I55C33L4z6RoyGQDqLXOSsuSCfUPxbw7tfYOBNT5h8LIvsMvmBPtM5x?=
 =?us-ascii?Q?HAwFYO56bwxCGdky+BoZi7LFIC2vN7k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l/7PHBjoQJkCu2Z4ovclw747pUv2mbLyZiavMwp/zMCgeLzjTS2Yr8fImJ7JPu1GQkXge1H2H8YlHfCioKIjzUYSmLXPeplGNKLMWcehRv4L5hMmyU8GJ1koW5FcXPEtCuE95IQ4HMJF1aXKwL0GvfoRMPyB9ECM3K5Iv//Gsas0aylswdkPcDplJCfXdKhSHKRWZ3Pt1tWbd5EVZsTcux3A+nAHYg/xByuaJ8s/5SVkxvUca0CTJ3UJCfLktwSa2/AHAEDFBj5CBzghMqM+n+IUsPkjCyQHUk6+qpgzOcbkJuAtglo2LhkhlgExFdjZVdaymlz1Mu69Cyx63sXlih8MDUnv9Ze2VlyFpumUlwTjqmO44j9i8y/UuJWV7fzS69iwdsdNES/SLijv0IfZq6sS29xoZSFqfpMG6NyfWkup5h+bEYXp1IBfuVJTwpzVKEf6KVkL3CFlPEyEyLzVGB+9KH/KMZIhQnDt3IhFdbVhWDx7Fzd3eWs9jp/iAG9844km2SnclROTAueX9OjCS5meCfBwVsVomUkWNyeHI5msxtSf0tggwoJltreozeezkQFLrlnJ2i9PqWt+IPuw7JN+Pz3BLyopwqOhPqPjHRo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565733eb-11b5-4640-1ab5-08de74843b0b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:40.9608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ez/hoxLs4UuO4lHSMAqleDxVGHSbSmWDOV9lFROxUNRQHVR/IRodJHkpyJjYFaTgoAKfRqGvqNyhM6vUE0v5nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX064BwTmA33IB
 amV/9f1AckLJQXVSDeRY4dBtSmxCoy7d4NezcCfJdoimao/nSPazX801ywhAuHoapJ2IFgOyCQJ
 TUKZCD5z1czgZTtmpLu3fHDTcKKkmfGavv1JIa/zG+3PS3Xy50AmZWVG1eA9lza0aMICcKoK4Zl
 yPkuVN6+dWug5ta9Syl5739Ch2dagsI/E5uI5guhKWfYYLBAevkfy0B+C20LwoCE6bzXSeFMKh7
 4DH8pagzQ7PLtXjE4K8TfOEWAXOL1TiGUdCujV1emPxDOhkXDhW13egBjcy88tu8kitmTphHpqS
 paoGTl9DVsV8e9z/NfvHIjGU2/v1FLf7sxcB0h+EPDXMLLI6i+oCRSkJsY1NVALgdFyC3xBigqz
 OTII1T9+GObdPSNtBs4kHhWe4RSDBw/oEkAxLNiXHxwrT7DWMDTjBtE+lmT31NZzrjHyu1gWZRy
 ZdeUeZm+wSNYJpaSpSg==
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699f17ff cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=9AqYmpHzZGUCEUQmZP8A:9
X-Proofpoint-ORIG-GUID: 4YE4h-3eek2psIZYiCguAs84iDBUA8fP
X-Proofpoint-GUID: 4YE4h-3eek2psIZYiCguAs84iDBUA8fP

Add callback nvme_mpath_chr_uring_cmd, which is equivalent to
nvme_ns_head_chr_uring_cmd().

Also fill in chr_uring_cmd_iopoll with same function as currently used,
chr_uring_cmd_iopoll().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/ioctl.c     | 9 +++++++++
 drivers/nvme/host/multipath.c | 2 ++
 drivers/nvme/host/nvme.h      | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 7f0bd38f8c24e..773c819cde52a 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -701,6 +701,15 @@ static int nvme_mpath_device_ctrl_ioctl(struct mpath_device *mpath_device,
 	return ret;
 }
 
+int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
+		struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
+}
+
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx,
 		bool open_for_write)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 513d73e589a58..12386f9caa72a 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1492,4 +1492,6 @@ static const struct mpath_head_template mpdt = {
 	.get_access_state = nvme_mpath_get_access_state,
 	.bdev_ioctl = nvme_mpath_bdev_ioctl,
 	.cdev_ioctl = nvme_mpath_cdev_ioctl,
+	.chr_uring_cmd = nvme_mpath_chr_uring_cmd,
+	.chr_uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 };
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 11b63e92502ad..bc0ad0bbb68fd 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1053,6 +1053,8 @@ int nvme_mpath_bdev_ioctl(struct block_device *bdev,
 int nvme_mpath_cdev_ioctl(struct mpath_head *mpath_device,
 		struct mpath_device *mpath_head, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg, int srcu_idx);
+int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
+		struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 
 static inline bool nvme_is_mpath_request(struct request *req)
 {
-- 
2.43.5

