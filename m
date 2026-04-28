Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD97441323C;
	Tue, 28 Apr 2026 11:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374818; cv=fail; b=D7FgvI3yFoIWtIiz1Gi3x0/KoYQn2x9BssTZXCyYhSG0vRDvuiGf6t6wfS94OMtX0UlejBTzSRbK2Ds0UOAxBNjhgZ+dsP8736bYnQcGMBeLXXEayIIz9k0V708s03nC94HoVymnyu9Wo4Mgx88Idnlfah5kJL72xbcGF3o5mi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374818; c=relaxed/simple;
	bh=Z0L4x6f6bNnB12e3Uysp+NslMeuTkAQHumN/8AexXoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j3GCOVsJfK/OiOkmFNQf0EeSRu9hELX24uu86arHqt7NNdi/xV3CAq6uWvJl20M0YbSe4NTcqne5CVa6gF+0QUhk63jWEE0XgWksxD/64YDcgqsV8Taqo0Ozcxb0UbLPcs7vsgJK1wjsVsAub9HzkpPQrtn3WIK3wUygtkaI6jA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UeWjDeKg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VJnad7p6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UeWjDeKg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VJnad7p6"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAZ6kN752742;
	Tue, 28 Apr 2026 11:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Bp8wcxEJ3ny0t2B2X7/OD77vdcGE9xipuBkypkRIPZ0=; b=
	UeWjDeKgH3qO+JFZxD0G+rWUogwWmwRbWuZOPvGQZ5UkhQT/vUKa6ZFXtc6OQ65b
	aETCLHYPjVVMmjIVyLOD5BqCJyAwRB8tMD01vZ81DFmKOIWZ97Ct3xfkpHiLqizf
	xJ7BjKHyqHNqPkiJez4XzXW/KfTl1HoE8p2eGEQJAfmcwJUVfwVQk2Vxdv+Vudb2
	dlxDDn76ObDb3UsY399Jt7YacrqgqA28QPzbyDaB7ntoctwLvdu/RbEmEDWBYf4e
	RCCBX13/lCj45QYoM/zXBt8uAmM9Z4D2QmeCvlAZbW1laWY0s2zP29lWOthionrV
	1GiAteHSTui6zw6Q5CG9JA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnnefevj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCjMf004725;
	Tue, 28 Apr 2026 11:13:12 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011014.outbound.protection.outlook.com [40.93.194.14])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2jm39e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h+E4PtJMnpYC+xadgiREOv4xX//XGpc7qN/QU1896yoxdnj0dNxEaE/OmbJqrroVdz2lSb0H88+px3qj2ldP2UN1vk2TzebdSnVgLCnBHcIzwurWTO2s8bwg4CRcseN/kgvznoeUqgprZFRfWAf2abYjQVXLk1MDZJFNpk1sfIpPW2vDpsmmjf/HlIfm1wnEeLTp6yXxz99QFOLlAcf4XpDnaCQTTodxno/PSUCjSCsTDxFaQf/p3rpxCScI7E6Lyw7j+iapSim1M4Sd0sXbvAx/YpKjTaZuwMfkmyUSGa9D9JBT4DNWGKbhPhEdQGc/Wp3gplxCKvUVPuXpPV/Trw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bp8wcxEJ3ny0t2B2X7/OD77vdcGE9xipuBkypkRIPZ0=;
 b=U1LO+N1zGtbh8aW5xMeze3XfJAuEB+7UNBCxLz+z2gMjpgQ+whNlDcVmk/Gllql1d06A+PxEZSA4UPx/ilHLKFED2Vbk3dxvLBm+2LkIxpOkeWtAWZFZ+d1xEPT8c1ovpSmLw4gf0dtvX3ipEQt+kRpqmDuM2d2NnA1rvuZu8Jb3b9oo7TZjAPPjc9yjTgdpz+Bw4pT+B6i9atMnJLKeaG3Xq8TigyX3cQrbJ8R/7pUpxX4GhTK/KH9WAZ/LpBi79QhNTfhETrLXKhyIXsRgw2Pty1GEJkxdj296ToFpHRiP5+SRFyVk37Y89zI+8mUYwxk9Q1VBQ0aDKqgUFxczEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bp8wcxEJ3ny0t2B2X7/OD77vdcGE9xipuBkypkRIPZ0=;
 b=VJnad7p6qpQ3/0BInxh8OxfNO8IyZtK6QcNAVYrZAG+8e0agW3FYENfD7AZdDWqUqbXw6fSQjgnvO3OOcDSoW9CAVlz74X6DhQtCSIrcYVt63oyNDQypw+i1MCCZnhh/X78CwtSk/mz3MfiCL9thNB6+ssuoczq9dd3rPwMIYA8=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:07 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:07 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 02/13] nvme-multipath: add initial support for using libmultipath
Date: Tue, 28 Apr 2026 11:12:45 +0000
Message-ID: <20260428111256.1778475-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0044.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::22) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 3904f5c0-a51f-4819-e25a-08dea5171fbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wdIMytYz3YzNMbXmaYweXi7s950/Z+6GXQxkERPS7zCsdh/RjDrnrnA6+6rDsvTlUhxFUNyNirAGUR6uQ9+siNl0K7+4xxhgy1miir97Kr542PkCDCEmdQ90lNh/8aoNzmQk9O1YDMWg1kgw2BLUEQgsSM3G9nQCnq8FotL3EDQY4Oc69CNfQ1anybFaAY181BCe3T7xq8iV+2mOscOC7nFlXrh9z+DhxNNo939bQliuqBHl/3xs7SDJfm8TrVC/KFyFXQqxUpmr4xlgkdxceFE+62vrWgIO46GsA6a98aXZnqFY5/qOXcCOfi9idw3qccsSvF1zG95us0MFSSWRn5Z4trzzhiZzQwZOW1e7TpQ1wzU24geaZLd+r+hW2Rnk97735bTjhemn/KdTsREmcbXBsXwqZDb4+N4tAFzCRpP+JLnVwCXNEOgmSlkMsuaiLHBtBJGC0kjcl6yxQyC6cektL5RR4eUkDJCZ3qKj8d1Wd6f7zz/Pckm5jvvcuvMtgR+FBcF4dIqLQD2U/8isT97b3FH3zbNZGvXeoQmvn6qFwmkVemyzKy+xMS2mC++/F6J2ZGFYfxOiChH+mFDGBB2uhYTG0i6XWKfv1nYPdAcSA8ifM9+J/unRcoQlbAPAPNeuQjKg5dIj0zhhxpENpTRYTAudEeZRPWsG2QbEiXxgj0onZDFNQ7DG8uWSO72wmDxzcW3ksxZh2tJWKoxkjFAM84HbdAdXzaGDhykW8JE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TqSyrgfTTgiy93gbsIebZNLqCNjyeSBmrT/Mduf3ncaGQff4PFwUcGU4K9Th?=
 =?us-ascii?Q?ZF+WLY8kQXkyBQ+lqsMg/w17yrpSuS/d0MibCtVGxGLroO61/JcZ0wXow+mx?=
 =?us-ascii?Q?3VZSGarjL31o+WXZ/4oo+Zk3RQlUPnqepSWkE6tTwqZiTPESI9A+yPF+oyB4?=
 =?us-ascii?Q?EQuZggiUrxzUAHwQi6JPDHSZqqo157/YbCo2uAxdAIt4goGlLB6M9BG5qF8u?=
 =?us-ascii?Q?MNmBKoSxG1Zpr/P7yckSq6hBPH8qOc9xkOBVZ2x8n7ZMOk7DJcNNqIhUcn5t?=
 =?us-ascii?Q?IBmKyqxr66C8F7D+meopMLLaLMJpvsvbKqd/7CvlOlhHRYb2Fs7PxZHgyOdx?=
 =?us-ascii?Q?wjKYTY/j59EHtqF0eOkIlZ50MOqIxNlt2IKINE9TC3Ys+Ho8b5OW9wZqkgRP?=
 =?us-ascii?Q?BsPi1+JhHaU/luRjY8mbb0fZhSCFYd/Q3I8xeEKeRkjjguMLIMTvG6O+AcaZ?=
 =?us-ascii?Q?uSAi41jwjqpwqMXepASTR3t6TgeOxgiO18a8BPswhHZ3cKxrLVmqMe6nKKs0?=
 =?us-ascii?Q?Wh47ofT0e/SrK5PlBKjswnQBn+pSBPI0etN9pxN2J5kSqa9bC2K6UjxnPmOO?=
 =?us-ascii?Q?D5PKH86Zxan/LW6MSzJ0W1y/Q46IJPdQEZV4h9W2aCRKxi55Owt+k4x2IRgT?=
 =?us-ascii?Q?Rvluwwg/9/V7fHkJhXagU2j7HAcQ9fCd4w+pjfcL4oKZ6j/Bl1ZTK5gNzSWd?=
 =?us-ascii?Q?bIfRvHEDB9c0g3f73xUo6htEA3RukdmXEKnLexIAhoiRsLCsZTqJFY2NOObb?=
 =?us-ascii?Q?rEMDegXUzlvAw9r5BPLXt69HtrhTsM2rcuujuin9YGREzN79eZGZhh73tuax?=
 =?us-ascii?Q?k+K6ueqNFaGZ1ydSxWXs4FRlj56sYgrKAnr8iWHeiptYRCSn82HJ1/klP+EX?=
 =?us-ascii?Q?Trw/RCJIuFZYeNZfIOrzcipF5zT3lEQvfZF7DTZMacbG3agT6JUUobZIxJCU?=
 =?us-ascii?Q?HodtNGAuXUtvSIDBzyr8sjO1luUbcVueA1lkC2ofwGAP+e6kxE7K0RyY+nU9?=
 =?us-ascii?Q?0LMb42c4Fjw0aFgVe3OhkUIqqOQxIRxhp5Dr08/SsunQpHe3KgYB9niRaQeb?=
 =?us-ascii?Q?Vl//ki2J4ig37FEIUz4/jZTVwWvjABFs6kGqpj3y5HVbjwz0ukB+7C+Okc18?=
 =?us-ascii?Q?nmAQEqbxL8dQYEObqbguNdM12RM3zE1NGg578IwVuhbC9hJcxZudIjurjJrT?=
 =?us-ascii?Q?YkHfexmSPE/O3mcRZCFMgmqQsMSZp/PB3TlF4hbLI9RkDflnODBOA6WALVOP?=
 =?us-ascii?Q?LIwkTo9SgAwXDnTBm1X1s8gu/3qrCsXKwt9rKdu2Dip8Swuo33T+WfTSBSB6?=
 =?us-ascii?Q?touCHx7Dw8ttXR3nnUWIuXQVjS/lKZAUjxmhiBVxYfEb6o9Lln2K+/VtnGiD?=
 =?us-ascii?Q?CRQrHF/7AdXYrq9S67Ci5U2AyqNYa6GZHF5xYSRxy0CKfXj+x11Y2Ln6ZWp9?=
 =?us-ascii?Q?6B03XJn57JPmC9Wdj6vya8Zkkf+5zrLKIfAqDS0lZBSfmIKj7VlakpOsvcVo?=
 =?us-ascii?Q?EQs3RoaozBN0T+hf9jQ+cL5GBUcZf4iGOWwv3ddbJ916TmJhjUYfeq0KP0Vv?=
 =?us-ascii?Q?kWzRJTmJ0cxVOtVtkK9vfExcIrqmocM18VvZEqY6Eq2MkQFqMPJ5TGVZ0Ih7?=
 =?us-ascii?Q?r42PiQwlaZVT1G2GaJTh2rzo6cz0bvdccxZ0KJRF9Vr4cKAjG93bxTSwkqMP?=
 =?us-ascii?Q?5PiqpITNGDsYqNSAEddwTM5sRS1txhb3IIKiYYtGpU7J5T3CV5iNEyoh4mXh?=
 =?us-ascii?Q?jC1csw7kjE+XBUybyF1TC7bOJILGKaU=3D?=
X-Exchange-RoutingPolicyChecked:
	fLKRx9JqEnXrMeoZqXpCTOLx8wB9TKG2uLRzsQ4sU2ScxcdwFcXgryRmR2Zf/p86n0J7j3OcMBt8y6QgqXqbyKIwA83UhbbGScUsU5V7v054nkVXzasQG21AANxUOwXRZTX4F13ZySs1MADJaVIA+u7HxYt5ioo4U5A2dj+e2TR7gZAFJwcmTPnev5L1RPizpSYzXrzwRbkMuEiTqa+3IZR7J9j7cXYG/8fmkP8oHchPFk7AyUcnnhBpbWXTZ8XE0J09wyam6Lmv4EGLT8RMDI++5fWVjF8fGC+A8/SDbavNbF5/ARWLhAVnDrYJAMX1818pcP5P/InKpRFK8yVHrA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YxohEaowNQoqJBMUzMkUm976qP69sTcbVEKe7QGx3YRqJrunlowkX0pC298xFQgGxnKJVr30L3DvJIQbLY7g7fHQ5XxRtu3nCW9Ba1/KG+OkMLCup6SAiE3kS7lc2QGHFDu5T36fxD4jd9UU0rNsSHsb5OoUDjkC4cvEzsWnzYuTtJUZDN/h8J/1G4PNweIBSHuqYitHu73CT6n8hYkabl2FegungVcVhre3k8hj9yo5wu/FLgcL8TIMMKV5gm+9x09ZL06fP/y/fuBCh5U1EzXKll3//PYyPZOZsFJyu9QuzVapkLOQlM4fONAy7TxXuaphbKw19lQ5XwM/CXp3ZjeGzOz4EKpHqqPL/WQd9L+sYrakBjviyu2wfKn+uiBtM9LV1t3uCTZW0aNgbqOZ2Np81MjbsOruK5bI4l1E8RAziB1LpKDO3ZH7Gb5DNvbp/6G6y5mKM+F9dx4SY1/byvN5Z7cJJYl7nqeVJ1V88nQixLx/NbIwh86IiYWLQgV0Oj3Gv0NuA7mnHJEpfAOvMADuRf5QPVRCENLdpDn5YkWx16L8Zds9m6jZdAbH4d3kVB39mUKKoxzPrLYt+p0iuUQPz51VrLRuvZ8b2S7/mY0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3904f5c0-a51f-4819-e25a-08dea5171fbe
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:07.0417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZEjYdsQzSWNOFBii8kXpp4436l3R0R+x+mQGUv/A75oW1e9gNkYrHsX5ESt2KOiRbdA3O8xTjAq1+mtFUKPyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: LvzkGwZ-eAhMT0KxOgCOOyOxDUWSBCmB
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f09649 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=iqRKemep2BTn628LUkAA:9 cc=ntf
 awl=host:12309
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX69twwSqoM3wB
 cMEYjdcpAfHG8Be0l8eqKd6LCbv0SvKGJitCNzn/rg/cl+km//dZZjuX+Xn+pBHmUP4rrCHkUC1
 SyKUNxw9RPpfjm9n+krupkOVqlczjOewU7siRKiFLJGz0eVRGTIBziThLQs+Z4LzQFcoZC6cZm+
 c7OQG5fvnCY+TkT6955wX7afj9KJv12ayfs0u4OCxL6FjEJfSOFzWjAdjUTOYBo3HPInH/ZaGV1
 ehE2CS/+SlfYkhLLouXPnZHfpKEKAFBEU1UaEwuRVLuCxQX+9rCUJVo4PFmk65Sl86ASgf2DdKa
 8YFp2BQn8Z/jnn5o1vdAhlayXpmiCFZ++UMclWegk0PSFMrv67gDe2eWUvOBIzGoFcdCYFWA9JI
 o8KC+JGl3TChIImPFU98NMBTtM6YF1Z8b02eJkUKurriQn+ea7nxRH/nyO/RPNlf/xD5SQEbdfY
 SwLjgxsK4xdskNrtGZ33nr36crdlJNWm+SYN0OrI=
X-Proofpoint-ORIG-GUID: LvzkGwZ-eAhMT0KxOgCOOyOxDUWSBCmB

Add initial support, as follows:
- Add mpath_head_template
- Add mpath_device in nvme_ns
- Add mpath_disk pointer to head structure

Initially all the functionality which mpath_head_template points to will be
unused, until the driver fully switches to libmultipath. Otherwise it's
hard to do so in a step-wise fashion without breaking functionality.

Many of the libmultipath-based function added will reference the
ns mpath_device, so add that now. Also add the NS head disk pointer for the
same reason.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/Kconfig     | 1 +
 drivers/nvme/host/multipath.c | 4 ++++
 drivers/nvme/host/nvme.h      | 6 ++++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 31974c7dd20c9..1b3f76e781bad 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NVME_CORE
 	tristate
+	select LIBMULTIPATH
 
 config BLK_DEV_NVME
 	tristate "NVM Express block device"
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index e00e2842df307..b727d6b69f3df 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1388,3 +1388,7 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 	ctrl->ana_log_buf = NULL;
 	ctrl->ana_log_size = 0;
 }
+
+__maybe_unused
+static const struct mpath_head_template mpdt = {
+};
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 5de06c016b622..f3026da0f39d9 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -13,6 +13,7 @@
 #include <linux/blk-mq.h>
 #include <linux/sed-opal.h>
 #include <linux/fault-inject.h>
+#include <linux/multipath.h>
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
@@ -554,6 +555,8 @@ struct nvme_ns_head {
 
 	u16			nr_plids;
 	u16			*plids;
+
+	struct mpath_head	*mpath_head;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
@@ -581,6 +584,7 @@ enum nvme_ns_features {
 };
 
 struct nvme_ns {
+	struct mpath_device mpath_device;
 	struct list_head list;
 
 	struct nvme_ctrl *ctrl;
@@ -607,6 +611,8 @@ struct nvme_ns {
 	struct nvme_fault_inject fault_inject;
 };
 
+#define nvme_mpath_to_ns(d) container_of(d, struct nvme_ns, mpath_device)
+
 /* NVMe ns supports metadata actions by the controller (generate/strip) */
 static inline bool nvme_ns_has_pi(struct nvme_ns_head *head)
 {
-- 
2.43.5

