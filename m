Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09E53E95B4;
	Wed, 25 Feb 2026 15:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033859; cv=fail; b=b01tq86a+LzKjVK51TMEbg5y8/DAWlLL5eVmhHNTHFj1WXPyzCUsAevUwSPry3Z+jd9SEUXUuW20axVfQ7j1GcyYwD78HaVJXuBAOdHSYlSZfNArtJ0shZwPEjSv+Czb20y2fmThl5KiXLvZ1cxN80KHJPCJTDP5IiSJ7foYFrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033859; c=relaxed/simple;
	bh=NYldLKLlAmThJFQnT2QBpjCEbVgIsZwwNdOSisAjtfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UaEa/ip5AaGpEWfMjNgoBbkAal+/2AkP7kKAY3e4F7sxLfm54mcDxFP+JVnVXSHtaCrGbKPrDbyI4KOLCPuyYgQXefa4sS3dIxl6H1rUu1RLeChGrD0GTHcNrdq4eCkV6WqpPrwS7UX0V56DQQBqzHZInOQp+CwBr0b2YR3APVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oZPi5/Zz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cqglc4J3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oZPi5/Zz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cqglc4J3"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PALCrV3928816;
	Wed, 25 Feb 2026 15:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=O5gULBjhGHflReyRi2Zpz9HVekDOOyrM9812HVoYDUQ=; b=
	oZPi5/ZzRgXdV8NJodojD1SIz9sVaH8pkaBpJOyGVTLe2LzdxjiNeafJHb9q8Z7g
	5qMHJizdJxA6XOIpeplloVmr0y5P3tMRchhcBy7M1Ml4hYP37QQZSCVE9YCTbf2s
	FiF8eoq2nWluyrfOtZWdoS1i3uEa/X3Npfp8BZqjLKUnNxTJeKPrvDORyyQwXbEt
	GWUOjcYFz6uqmEwsYkL7L7J3Ra3p5DHWLbPAkUR6wjvIK/eAOgS77mF1sV0C5F12
	7mhzkhBi/jC4hfVkcgDQY6B4zJQZ98QF0o2+SfAOIWtIsPcoUY7DK5smTDNIDVD4
	hkrJQEQ3cenywfUbBP0VGg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qedy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PESt01028497;
	Wed, 25 Feb 2026 15:37:15 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7hfn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V2vy4iFDyr7uy4AOWfhv6yAmyJfjFpEaPEOo2wr8usfV1jL04Ux2vK9Mf12XXDR3hR0qiYOhaD5IIKoOLRo/JMTl3SLzxXjcXu1kbWvzkqWtMd4G0kYMsn0VCghe+XEA4KgJ06L02+/A+aDgFDU5u6/Rj7phQ10U+3C1onoYOPUpIOks4R88ULpLYZvnCq8IwT9nnE+WIq2fXAne2WoYOTLGevGsXSC2Crhu/4s4uKq8fRp1CYtWab3ofbLDjgxi9sJFMpL3EKUuQGtHSF9bGi8+NFQzjyCE6yqoiyrJ4cmnwy4h2NRx7jyTDKsCSOLbkM8BhEwHfsKd6VKCs8p/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5gULBjhGHflReyRi2Zpz9HVekDOOyrM9812HVoYDUQ=;
 b=AUpuSKole2DHAmRTAe3j2e6RyMnkxtMNuWygWNuajQVMdNQToj7OzE9ZLq0FLh6YwGJk06I53mSXrZ6vmT6HXKVUOMu4d3TCEzWYv5s2OsTywVgl/ULhbR3jYsGyzLQ/mBwRObVoNQd+yUq/hHElgL2DW6nhBM5QdiO2ssbzrXAs6KcS2JjX1V49zTIgHvWpm4NDnBNC9tPjtPWV0wTy3Q2LLGI80F882tJBCgFa9dD5J9155qvRZuydvDsNQ+Bx//I1N6TUbvoLl17ux8kYvGIjdkLiOKIvNd7AOV1e7ZEc6Zy7xpJODIt+iTOEQf3M3dmmn4BJsQAat6ZtoSvQCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5gULBjhGHflReyRi2Zpz9HVekDOOyrM9812HVoYDUQ=;
 b=Cqglc4J3XZmwGWJ+L9/HqOQJCfsJZBnwKXgu6+9JkQiHZnB/TGGqfqOYD4h4HMHv0kjaUWYK46VqSKcO9Z/nc9G4ALiKNQF07XUSGkzsEEv6PmERnv3Yh6yvtTrOpEiElOC9NPeTT2y1kciK8cP9ZMGuyE0Z4XDAUfHfV8tlAV4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB997712.namprd10.prod.outlook.com
 (2603:10b6:806:4c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:37:03 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 10/24] scsi-multipath: add scsi_mpath_{start,end}_request()
Date: Wed, 25 Feb 2026 15:36:13 +0000
Message-ID: <20260225153627.1032500-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:34b::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB997712:EE_
X-MS-Office365-Filtering-Correlation-Id: a85e08cf-d67a-4ebf-dd5f-08de7483b932
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	T7ntfPtwjQq+A0SNKbDBFPge4v3DtxhNpBmecUhf039SQpO20A3t8IgiI1a66jCejWKs6GnZ2kL6ZXgNHfOPrbZeBJw45gE7ZouBf06R27aYa3tbNt115stRZ7Jx43Jv7EJOUuW/EJCcK+k5+Whowl/b1Ztlz5y8TD+ITbYIByTbLxus6JkaUC/JO1/DNTFOD+KI6DsTEOkqrYQA7RRfKibZpN58xhdXojLZAiAIJKPziDYO7raIpizQn93ILyAo97m9/6onsutx413zZN4ksu3Cy6098D7BQc01kJW6n6nsInn6NvONqnNpO4T2FpXKKk56KeTwuXzHcXeqYireyWYvR1J+OxEWeoVx15SvHJ5Ar2rW+Tv2vdEtwYRigYsBnVigf1+frOOKx1AMB4hIXsFtFmqMhXk1sqMi+2nmi9acC/B48upkAcUBYz0tvIyA71sTXeZnqwnueOI60bgCetrZ8BWImfwTF1uycwnzeIlcdopjN4XJCSNRvAXW9tj5ccwGz5ZPpuV2smC7HIEEMDI52uKJ6fIkqKALOd9+x4LzuPY71affYr3+dmWUbLAr2CiJJzsfB0YlfUIJEWtpLkz7RsHzycA4J3VIaYgomaHPyYpyuMvfr5QUHhfb0oayRR2yIuHSf/IUhy+RJL/ZseRURnqCrlC48/Itm7Pf9fri9MITKzxo+TJCGKaAqOPpPlSdgaMhloYN+Uq+LzBn6lD8h7ArTM4zhD3SYiEDdFw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v0Nky9OlUEDEVF7PIGc7rrs2ynWTv12T+mf+J+vWJ9LuXFNE0CQlvoNGGv9B?=
 =?us-ascii?Q?zDfhlZ68eHeVSdG+iTohrfStZBlnAR/9b6BeZv1jNyN69msF9NqUFCE26Dbg?=
 =?us-ascii?Q?NWYJIMadYetqJoPuTbzCCbiHN3BMfdptZEy/FC8iyC4Ahd0zNU/StuHCI5Mw?=
 =?us-ascii?Q?VzRPHE0x3moaI0iiGTm9sfM7EwAOd24VyfiPhdlR2Hpi1LKSFBtgz1+zNvHz?=
 =?us-ascii?Q?N1FgwqgEmUmB8XSYOx6x/bMAEFyLEqTgLwzSIZ/epREsPojxDp6IhZNA549+?=
 =?us-ascii?Q?i/WPenU8YszDH7BgzETvMXvmRirhKTvatpVKqLv9ZHKLZCx9Fc/qierbFSR0?=
 =?us-ascii?Q?f/B0b1N9+cdESQG60McWeuGuah74DveKBlmpQV2v4G7AqZJ3W7kk04r0lGWz?=
 =?us-ascii?Q?QRUA42S7nTxnA0tmlcrQz17l5POx+K5pfj2mjHtLZKcJwM4UY8VYZkNpMPkx?=
 =?us-ascii?Q?N6pNXOHsoy6fniheUbGhfvppr1k5VrnyF6DwbD58og5aGcl5KtpvWfWglU6u?=
 =?us-ascii?Q?/R1f1OqmkFDWQj8RVsDS1ZpISj2XsQNZklThBxXMyDbQIadYT2/pA0bIAOUu?=
 =?us-ascii?Q?I/gS1AImBmxILkwFV7lrkgCzWDg9YOnrpHYcjaeOfdSf5WKxqkCSPCoqj7DD?=
 =?us-ascii?Q?Aga7O0jl6a+szbPmFbIkA5FfF1SQYtCM4zGCEsTGcZeYp3NvlqPZ6UV3uB5z?=
 =?us-ascii?Q?nxq4qtsyEzAz9yBzXBM+SFjlxb1OvS/PJsf+/09wJBNzkKBtSTwGRjntuNhe?=
 =?us-ascii?Q?ycYIFIjEBKOPiRaRTaOe1Qdsnpfs20A1NGYI4a8mcGjHIJxsGhkX456mQ+3n?=
 =?us-ascii?Q?56vnEiZxPPFjAVT3GALYHDjpGApauuLn2C+ITnOslaEPXGEgzomIPkC11OKy?=
 =?us-ascii?Q?b3R3DyXqLhjwqrULxWRb3R75sleU8xFB53YIrodEZdKEBKcuhPaSqL0JbH1U?=
 =?us-ascii?Q?S7NF5Osfdo7oSilRQHtK/Kyyp3ZwMJoo4knx7V+tJG51pV1qurBdV9Md/MGv?=
 =?us-ascii?Q?vGqP6kji1ltIPHeZ4oGqspJoiT9enF8XCDrOI0YmTqElOmn25de1hqpe6myD?=
 =?us-ascii?Q?vV8PTuQ4S3dbnXIR93lthplklGBqcOHSY9vMTCqFKPuJC0BkayuF1OZb4SuI?=
 =?us-ascii?Q?fTDoK8TjWUkqew/sYZcv879XAXRSi83ogIKA52Mr8HFGNq9QE4ernLJ/Ii3n?=
 =?us-ascii?Q?Ab9jGcdWuC6yE6Ifqe/dcgB9uvZN85w7giB3Qefz5XQMSsEA54VRP1pXZQ4o?=
 =?us-ascii?Q?402Kt4e4Is1FkUGz2sZ5ka8EewZ9MW8gyffobAJt2u96yCWRh2FGrwI5k1fU?=
 =?us-ascii?Q?Du4GD4Pl0lNiUmMI2GP7hheTqwDkUcVNaq7cbrgjgwibGqeONO4TW1T3WJR6?=
 =?us-ascii?Q?c6D8t28GuLvH4DzUnCvXNWg2wG0rJ7DGuBzyEX1S/xem/CtRmbigJtJ7Zn/e?=
 =?us-ascii?Q?uWWtR1x7SGMt4s03XQZ3Zpyk3KO/DjYNjpoqJW2WRerOOxV3bJIX5hII7ebz?=
 =?us-ascii?Q?Wid9AZxy0lrjJQbk9LHR+FnFjnZ1fXHSv40l8eZK9NB/YcLwAdIUi1B8t0Er?=
 =?us-ascii?Q?EAOIckRzkEgPcR4mgCYFki6Slvx/ngRW+SlRYnL55AzDoaf+eDVl4mnUxtEV?=
 =?us-ascii?Q?tPLiv+smRWyqs3VUpXWTA0r9FtrUoU2aaq7x6uToTQrAvlAT8O/P6h9S770s?=
 =?us-ascii?Q?wLjBr3FDbNvUeKfAyyCFks4jB76s1jwsVVorMB9MMsRco2z/3rMm1TNroVJk?=
 =?us-ascii?Q?jkY2fzHCy+O9OnjmO9M0BBrOHstyyqY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gyIy7iOOT6hmAqBjgh8IzKfc6+/HLPC6ghppSYfyKaoEhf9i8qIlbV22QeQEVDUep6nzfoOP38FrrrxwCbFELR8lSBFasP/87jkrgX2nhV/jEMmvXjVIqAMw24RcYcxU+lA9XEgVwUtCmYCoxb1dbyK7dt2cOGE1M4GjBy9+QBq1nAfXkcbAVGbuFUQz8M4taMdCqeqbyd58DadIhCTw9zb4p7M9fiCOc6lVOrou0VeqgRwmUXpBFYS1Qv3Qmr636o2c7/yb/upFVW36otSIPC1H4P2PxJuYuJJZXtqDZwvzuM42pm9wcFJpthssCBvuCzCV4b0jyEDOsLvfiOirNovEuk5Eax1jXMwfM+1vJSCbWvPIxJ9KEwvk6iOjYqCgbhblRFB6TYoat4qhHGp11OcHEQ/d7Q5Cx1msj4HWWemd4GOxRKGZbNyxn5ol1spqm2377a1CJ1njjNVoCpyViygcY1NbndnOqdmC0UeFOOYw4ZqdyMsw0wrvBRB06/yWYulp2S9ud9EBsNxfthSGB8b7p8oYojTy7GCtRIx3MN7kX0FPY5gyrz8pQ8jlS1lUGlQ2SwSL99TVdMjhSG887nkkD5/7/qCtTwwv94y6pQk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a85e08cf-d67a-4ebf-dd5f-08de7483b932
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:03.1826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/pNJSd+VuC3b7VjcvTzgxZQFnqJ+4ZXAUOaUxl5YFpjX7/bFz+2mwmxMOlCMoKZPxxjo1wtLNDxDaTFxsutxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX77zdp496Set2
 UypenfMzEdh8ckreonSBytp4nvSy7BZzqBIV1Xe1TUZ4Ath2spij/2N3te+a1uWEG/0cntibhdS
 2woleGUgSv9S2I84L81vAi27IDsJnt+SsFRMx9QFxn9e10cb1jvQ+LYfvv16oTJjLcnUOj9MRS+
 JeLG6RQfsajGLJnHYy1cS1uujqjr9zB8JeY8xjyLrMTRfFQB7EYlMfu2wbT3RfVswx1HYTJJbCU
 nrERg33wgdZ5egwv3r0+vkd5eorrZFotekmwRVsf2AUDYlURf7rzTaqhsdBE0bsm1YLcUp0pY0/
 0r4rASm5IswGb/lGcyihrI8yv4rL4ZZHOiUvoqRqfOvJkXk13lzbTKVs/3+PQpajBSAH7m/fchU
 3ZMaYlc2B9pALWcUjex+hHgwDYyCmETTR53/Iqe4UlOh0tffAzbhwm9/B61X6A5WbEgr9YSmWo5
 1JqrG8MjDzY1m6YiHBg==
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699f172c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=sw4HHgXiYKNNKPSRYmsA:9
X-Proofpoint-ORIG-GUID: SA-OYZeUNf2ISYUf5cMR6cdtoArJGr7L
X-Proofpoint-GUID: SA-OYZeUNf2ISYUf5cMR6cdtoArJGr7L

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

Since we may need to update mpath_disk data, add a callbacks in
scsi_driver to actually do this work for the scsi driver.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  4 ++++
 include/scsi/scsi_driver.h    |  2 ++
 include/scsi/scsi_multipath.h | 24 ++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7ed0defc8161e..61179caa7b2c8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -654,6 +654,8 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	 */
 	destroy_rcu_head(&cmd->rcu);
 
+	scsi_mpath_end_request(req);
+
 	/*
 	 * In the MQ case the command gets freed by __blk_mq_end_request,
 	 * so we have to do all cleanup that depends on it earlier.
@@ -1887,6 +1889,8 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	if (blk_mq_is_reserved_rq(req)) {
 		reason = shost->hostt->queue_reserved_command(shost, cmd);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 85e792dc4db50..44e50229a75e7 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -20,6 +20,8 @@ struct scsi_driver {
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
 	#ifdef CONFIG_SCSI_MULTIPATH
+	void (*mpath_start_cmd)(struct scsi_cmnd *);
+	void (*mpath_end_cmd)(struct scsi_cmnd *);
 	struct mpath_disk *(*to_mpath_disk)(struct request *);
 	#endif
 };
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 07db217edb085..6cb3107260952 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -56,6 +56,23 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *);
 void scsi_mpath_put_head(struct scsi_mpath_head *);
+
+static inline void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+
+	if (is_mpath_request(req))
+		scsi_cmd_to_driver(cmd)->mpath_start_cmd(cmd);
+}
+
+static inline void scsi_mpath_end_request(struct request *req)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+
+	if (is_mpath_request(req))
+		scsi_cmd_to_driver(cmd)->mpath_start_cmd(cmd);
+}
+
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -104,6 +121,13 @@ static inline void scsi_mpath_put_head(struct scsi_mpath_head *)
 {
 }
 
+static inline void scsi_mpath_start_request(struct request *)
+{
+}
+static inline void scsi_mpath_end_request(struct request *)
+{
+}
+
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.5

