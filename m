Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D191A9FAF;
	Tue,  2 Jun 2026 01:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780364754; cv=fail; b=j+zxyGlKqknDfkL44WYSCLe4+qJmyXpEBtYKklHIvHtVCaoMjHrLl/7wFuZ/kCQgODV+Qbz6VH30F/KLOeBT45qUuVES0ml74GqKS2lfsJ8a35tNTspgaAPGHcxH0G8Ay94ah3Z6DZ4AGXq2Ulz3wet3oAifEIRxEiXb8/NtpW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780364754; c=relaxed/simple;
	bh=3MrxLu8AYIwJUCze/y+/YQxJk8XGtlKzRTZWQ0BB/vE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=D/eFI4txskG2lrRS0iXV/653REsZMa1EyHQYau4oqtF53QDkvuuOOlS0BTWQ08xHnHkl4UG/Hkr327paLWPJoLYoZMYCs0M7tc4S380eqefh+GDOQZnBrBWuuHABTcpqNwMTNNHF0nYruAC2rptaDIaMsLVZYcwSCudGCh5JIhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i+XxFfH5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g3xWmzZZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i+XxFfH5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g3xWmzZZ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651GtWfV4094609;
	Tue, 2 Jun 2026 01:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xovZu0FfMDkr4Ze3vL
	BphnRnstWO8HQrh+Mh66laMvg=; b=i+XxFfH5HnPO81BZQJ273Epj4oBorfDMl/
	ZcvX8rfukkRLwwIAZDbg2d3jocXu1UH8AS2pfU2lEKh1HhWTOswA+q/doW3pqtNa
	pVhhH/pZaiIW1SOh708Y9JXAKHRl4vHOAcs639SLbQxszklrxMY3L55ckUgE5TPo
	e/1OEVg425DNRZPfEsDYYNglmMlOi9B5qT4olMFH118xPftMTwQpbB/SduI9o9uu
	8OJz8ltGRKXlQzcjH28ps8zGYP4cf3sV+hKt/j4IXVPh0Rb/AoQou6Cr4EGDORHf
	9i83mz5yWjm37xLbGGqcuUHyGL3Llggbbzues24k8ZBSvHmd7zag==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqs6k6ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:45:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6521itdU020176;
	Tue, 2 Jun 2026 01:45:32 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbcj5gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:45:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RMUewOFvfAAhwKQidHZQrb2A/EPbRbikN3TuxRfLD7M/dVFcPLLERwDLUsa5Ny0IsALEjYjFgFPoj+vzD3FonAEdVE1hyql3+HygfKMEtYliI5PvN3WWA/Rjuw9yHge4n5JDeARHzf+LO0paYbJRV8s7wWE60bsV7Kd4aZgHtyDdblqj1iPyiuL8Vb+0LkH/4+UTlD0mKvHAMMaTkVTe6WTNhjT5TMWqFM8C83K9UEUfhMydHNJL/fS2EWTq8W981ki3dcLmhJXaR3EdmbdjrEPTB+Om43jJWtAg/ivoAWZNGljqYHA79F1h/1PoSUvoAxZCJw5VGeXsAB9qbUngmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xovZu0FfMDkr4Ze3vLBphnRnstWO8HQrh+Mh66laMvg=;
 b=SFxSeBlY1I3IZjAqRlP0vfTxatZjJpvrXBlKi0QkAzqjzK7nKJ2ySpxyK+PEZizpM5FK/la8qC+spqPCDUG4hsovdvipDQSEBWcfM74/LL8k6nvVcZJ7JngVJaJdBv+zQy5+oXKFQu8WwAauKs+Jg7e5MfJ53vu0E0cfB/ASSAjQB4YGKRGthzV9v9f4N+8kqgUnDthTpa4Tgc2SbWEQWH07Tgw/gvVk/ddAFSCCJ2EbJxz2O4OWbnlU9KxE7QbISiegEcKTlkzDmj/eKYG8Ew073d8YMzNUUAxAlGbks2p4Ib4Y03BrjH9gfIqiAzRP2HV8ydDH2INRg7T36dlHUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xovZu0FfMDkr4Ze3vLBphnRnstWO8HQrh+Mh66laMvg=;
 b=g3xWmzZZAw8dBbp0aTW+8/s3kn0LEd24jCX0aQ4rJIqL1Hlj+KLkYnNjnwcQeG35tDc/pIwIKUv9H1c7im+ic1xYy+hdMh+dawgY1JO79oZ+Px+Ksiytp1fcTiou2+xzYs5afqg2xwqAM2HnqlZisBtdi1nZDiqrWd0gVx+SkuE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6193.namprd10.prod.outlook.com (2603:10b6:208:3a7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Tue, 2 Jun 2026
 01:45:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 01:45:28 +0000
To: Daejun Park <daejun7.park@samsung.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "bvanassche@acm.org"
 <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        ALIM
 AKHTAR <alim.akhtar@samsung.com>,
        "adrian.hunter@intel.com"
 <adrian.hunter@intel.com>,
        "palash.kambar@oss.qualcomm.com"
 <palash.kambar@oss.qualcomm.com>,
        "mani@kernel.org" <mani@kernel.org>,
        "shawn.lin@rock-chips.com" <shawn.lin@rock-chips.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: core: Skip link param validation when
 lanes_per_direction is unset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
	(Daejun Park's message of "Wed, 20 May 2026 16:00:09 +0900")
Organization: Oracle
Message-ID: <yq1fr35af6l.fsf@ca-mkp.ca.oracle.com>
References: <CGME20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
	<20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
Date: Mon, 01 Jun 2026 21:45:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0109.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6193:EE_
X-MS-Office365-Filtering-Correlation-Id: 64a55393-f0a5-45b1-faad-08dec0489fd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	LrhnhYeay4rhikHhr3+i8RAOAQzxrq8NZ1O0B59nsPclRBZCyfrs7sihKgdH5nguOsjK14cPv+xVZLbFKGOPiFQ+6idAuUqsvwiEDqWCpYG0kA+gBq9QwhoqHs2Qtiu/aX8ttillJfP7OUjpE+YGOl74e7tkntFXr7hDPk1alWcIaU90WIhSnaNBn/mXghUXk3TSBeb3fEHnyAbtdDofQvBrazGzNqi8frEk7JLVVJN/lPRZSKe+axeShgzOdQ6PLZK5duKQWS549rnZ48XXXKCfh5EF4V3yAJRnJlvFQWnEO5kGSiAh9wFheSJhpEKiHPkNrz86+r81Uu5ClxZPmP1pPISE3/T7lJZRB/oyCBG83sH553EyMRKfYcHrCmfMvrjtjxFW12vA9zsTrQ7UBZC9aTqSubXurtQcbxBpCco5DHCKn47A0alFG1YZxGSOaDnZxc3fDV8dBK+6tXv8Y/iwLHnemk+aV8A30xcitOlO1EYS7OB5TD4d0FaOA2jSFBpuS5iouByAW+3p0HSCdpErMza6DOm6+SNUz/2kwNn7zXlfgq8KgH4Jp6dc4pVR5HRxT1FzyeHMVwtT8VRNaKtmdvx5uZJoo7aDh6hjuqeQU47htntvBWx/9C1ENh9yBphGXpXn2x3LJ6XF5YHpHxDnuWAbshl3ZyuGxT8slUzH8okXq5EzsFEFuCDWtD3u
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rzMPMKhwq6Hna6MOcczBKdV7bDf8VJ6Lzc1XqCA/t7MjlNAaGUB4s9+Zpdlw?=
 =?us-ascii?Q?4gJXjuQmhFIrSGhCJi4UFUwxena8voIwOl/EYBks4Cu9QNQvLkiR3GE1ip1j?=
 =?us-ascii?Q?tSovTQnE3EabTnzIhybx0fR8VQjLDqz+aETo3d0g/BvX4Wotp+rDjyclAkKS?=
 =?us-ascii?Q?LGrHGhTzqWygxRi1/gpcL6la0ZzGbXEtYrKYWQXGSqCr7ul7wn9kjkqysWZx?=
 =?us-ascii?Q?AO/8ZDi3CP0Chqw38ZpHndVt0i7K0PvbHGjPaJLPh3JR7J2i+1duGc6zHYIf?=
 =?us-ascii?Q?wSQNTJZ7XMZZ8WYY3Bh103OWB8or/hQ+twSZwxnWWsgE1YzLyOa0HLIphfn0?=
 =?us-ascii?Q?qlR5Wt2d0zkOMXpSvbOd8zSRSFwOXLNYSB9Ed4go0ClQ0ZuyFtYi83mv1Mu5?=
 =?us-ascii?Q?ZN/EPI+zqM6E9iaPpgdpO5gE45Y1lnK7R40RSTyxI830URi45E7AUDbaFpiR?=
 =?us-ascii?Q?MUNNAShleGECLQaCotrWDODFjMLXPJiNolGqVj5uAEXiXjb2mb+x1S9+CSPo?=
 =?us-ascii?Q?XWn77i3+IdWd1P25GIjY7sj7L+mSR4OXTWhg09S6niVA0/9dN8DaT8aYyPqK?=
 =?us-ascii?Q?8TdEvMZ5JJaYOtW+tKEsx7hMm/OVkdj6KJoRN/9qSQJoDi/2icOmWsZSMuGt?=
 =?us-ascii?Q?TO7Y9qdhwJWsTXZG1EknGG2CDd76Ba7hi5PXAbTDWQcpimFsEC1NQj5/Wnpr?=
 =?us-ascii?Q?z+qf8HpH1NVrjVNfsbSgqMBqTbiLRl27CMHoNRMQ6RqyZCnYzsRuP8kQuFeT?=
 =?us-ascii?Q?2p4wFQspgNRnW/gUy0Yt4WvcEBFTretDUC6aCr9V49vlfQp05NONbYdAMg+K?=
 =?us-ascii?Q?GmgbvGP+WZUM6vKkmtp/IgyTNHMI8D4MzHmhiqN5Zp+3nYwcwdFiKvGZveC/?=
 =?us-ascii?Q?Hl8Yro4kZZ2g49PuHqMFY4HrXp7+BIynSDfqFkC6mgKwY9uG1gyx8kU2kME5?=
 =?us-ascii?Q?4C7xseklux4FobtwD9X60Mtgac0Zu1eecdrfADfi5Mszomj2YdrOaHeKG6wS?=
 =?us-ascii?Q?M6TrR384a/0PPIoZa/DBi/1yIMy4WdWWkg7GcFghCeX+XSaIUS6Lqof2LEup?=
 =?us-ascii?Q?B2NRbxkoQS+YjnpQiXSYK6D4rT2kJlfDCX0gjit0rVMHx6Jl0WMxcdvrgaTO?=
 =?us-ascii?Q?Yof/NzYJkFlAYZ0Bef3HmjSGbtPEnli7wqt1yvcSy0zcyf+11wBsBUNeKz8a?=
 =?us-ascii?Q?9eY35OOJMknivip5zYo7oCrWhZOcm5Es9t7YqU2I414gnEXhXKgXPnusu883?=
 =?us-ascii?Q?/wIUbAlWbsPs4d0fAGHTq4zjqi4xF2jpRmIGi+jaj1WJg6PXU2rSetZHMF9g?=
 =?us-ascii?Q?Zu7lerSfH0nx1Id5NDjLw+wnyDUJgUxZ3hZtRlXxvJA6OZM+HNmhj9S79h9t?=
 =?us-ascii?Q?8kwYCNs37oTnoo3eObdHymkx2tmXaMvLiwTOZtdWdavTAXg9D8Km0EW79jUT?=
 =?us-ascii?Q?u58DsGRZTP16h34TMUQsEQBummNbqE1TTLTxMpmSw2lNL2a75te3L1d9wsZA?=
 =?us-ascii?Q?7LjVXFLGFs2BYaEmoif2aS19Axd31ITOPAQgzJy+5OyaD86MbcWWMn+0cZoN?=
 =?us-ascii?Q?4og7Gdmk8F9xSS2826OtJCbR7pN3S01WoUiJl87OC/TYM4nOn9ItXgFrDE7r?=
 =?us-ascii?Q?gPfpeeQZkB+A19yMGG+pGkoSs5dK7MWdXkFT8UJC6GvA1s2Pg+/vHuZ4Dek7?=
 =?us-ascii?Q?5ZQ1b2w8Ws1R/kgpfIFUCpWTDEtMYh8V6LbcGtofAjKTAxR19tmVbsByCg/J?=
 =?us-ascii?Q?qfmVY7TIItFyoaY/E9uof7tSDcmBxbE=3D?=
X-Exchange-RoutingPolicyChecked:
	Le7APlHYVHH43G8FtdtICWcDcEwV2FmtiSWkp3xVWUhkhwMpsaSBlo5H+fdgp9G6WeBod2yp+Jd4nIYwsRAKmyxtsq8VARwlZmZn4A3GvM2hndtoZVIujup/APHGMpqJqftAPLECxrAu/VgdeL/2a37F08kStqgkOgmXH1MSBDTW71dtQWSvPNwDAzseF5L6H8Djklj+nLzEEt3sUlzKxaRphnvcj9w+BnW5hTHPD3EG1BzSdifp8YJyi7Ic3R68uCPFNakeOHs5q/oIf/MeKnwuPCQh1vWrN0hwyUo9A1bZwJiimQMrT7B47pQ/pEHFiH8BwpUAeM/x5cs3T/R3wQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ElB/wiXnBY8mspp4bzdlMG3ftxpzrqeIq6NexusuGaMHx/Bb0fcnP4CspjxurnTfYCSyj/NMHvj83/zUp9g9K8Z9JX7HxktT1DxBc5GTMbn0ZcGv90st3lFlXiz5IbrkgTmNfWEOpFDHy0CVxsr7QBJJ7/ydA1bXbwRFkdRJdzrZCrHCaZXRxKU02fALYp2POutVDRu7cRywXhvE70/zr09fj7QSNCX9MaN74CS8n4HorNhOm4t0VODc1Ot1DISWkDhozIKYux27BufID67f2am72bCjuimQwT+DxOcmporjJP20hNmsU1Tcw2iN7MlKgB387MS/kzzSIFV2yiI+30yH1tJuCbnDq5jIyAhpJ8uaFL7yaU0kJWSL0aU/oYg11Zs2dXvAtkDSiJn7oVNQO5hE1g1zgYsUEXVnba/RiF3fLvRlCLtdaq4vkRsDBNVb2dOl+N5nf8E/kfdkLvfF3gJ/BlvtGVK8lWR4SnJKW2F7b96eduPzqIyUUvsGL0hteIh1dXgUxW3Sea3nxQG5TSgjLd9sHZWQpT90QkHbcFz1KBoEBdDm9Pf+W5pH7OcUkgUNyRqJ6y9iDQMt74cT9G/8y2U3sb/Fgtde78PT3N0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64a55393-f0a5-45b1-faad-08dec0489fd2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:45:28.5762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xsf9IyDtSYoouVxs4+PzRjyA4TrVQ4nz9naPz/k4Cpb/PWsLLImuZgk0WBqgxW5U7RV028e8GecmWAtgEa+wgqh3OkdElEB+F64ODAKtivU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6193
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020014
X-Proofpoint-ORIG-GUID: 2FGEE0tfZn72d0v7GEcxk22dEFa7CM1Z
X-Authority-Analysis: v=2.4 cv=POQ/P/qC c=1 sm=1 tr=0 ts=6a1e35bc b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=rZbgq3Wq37U6-5rKoXAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxNCBTYWx0ZWRfXzllN3PL+3VP9
 eudSMTGP77QViXe2CKAnyCO8GI5rR8Dv5XXpENE2Kr4gzkq5T6SJNLOPfxMrlK6iDjnpBnwc+z/
 nQPLqwii4JbiNy6C5B4BpP12pER9183cujP+xhJyWrlbMuTzG3GzL/m25g3bJlKy5yQ5IbBVnGR
 WSMdQJ/RowX7wshGCaROetStQYtpdyTAvPwydLnfh/5myJKcA+r9LEu+/z3bmA/B+DdAUbimguH
 5RqfkfB7o8susAYBoHoHrunzwfMYBpkyLijErR9GEO5UDZKz7z2k24HYIhWhhpCrHWG0rDxsNrN
 wkla4SCTIr4avhrWbzoEz981XyKVhX0Hmdok6hYVnB5+/ARPxx9qrkxkpLBufqYUX5HBHzMgsTH
 cln3ce0K9iXWXSTWExCqfVel1RsVv7AODhYTVXiW0oYwV2ajfocE6hMcoyTIxVRivPrpGMVoRJn
 a/DZJ+9maUA6uT3V35A==
X-Proofpoint-GUID: 2FGEE0tfZn72d0v7GEcxk22dEFa7CM1Z


Daejun,

> ufshcd_validate_link_params(), added by commit e72323f3b09f ("scsi:
> ufs: core: Configure only active lanes during link"), is called
> unconditionally from ufshcd_link_startup() and fails link startup with
> -ENOLINK when the connected lane count read from the device differs
> from hba->lanes_per_direction.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
