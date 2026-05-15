Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7289036BCC2;
	Fri, 15 May 2026 02:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778810930; cv=fail; b=gXhVstgNFg43lhmfKEOz4hH2H4p9Els7i+eMPDrvQaqHFxPh2Rb9cCYYY2BkUHGzJLghBSJ8BgUvEXSRsMd9Rr4eZY09Jg9gW/YH6GlIc39RAkhvUnmIzXJMcQJ0JQ4kFzr/RfFVAf9MtnZZrr7QFYXyJGlBfrtwgZhs6+uycqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778810930; c=relaxed/simple;
	bh=Rg9Ioixh7ll9HL/k8Wc8nEWoLc1MCQpuPwmcr4r3Sq0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Esj956JolKQ18n7RoElaS9lnYzDSSaHQ6UzjSoDdClHjQZvNdIWH874Qvbdh5sWTcEXgOgRMT40FFKIldstPA/qJFLyRGK9zD3bqYk/uboNs4KsdgnXxWs6QT+Nwp8h7z+bMAaGmCHMHjU01agj69Sx3NiJ8H7qsvzPjplUQTR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hIZY8cyB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aJJtWv+K; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hIZY8cyB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aJJtWv+K"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0Sth91478160;
	Fri, 15 May 2026 02:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=KkW5pvJp09IcKimKao
	CMr0q9bJPVbmH4FjZGipM5KcE=; b=hIZY8cyBxKQ+lNB5+NKA2rw6udvxzBXwjn
	4QVZbOsYkR2R/3yztoqeeVoit1bFv0gvO39uqXbqxajzQSXICLXM1UPGCV/mhtkY
	OuMmpMBlayC1DiPQQojH7PSWQOTF/0/sMW061uF7JVq+Zbj4aigIjMk2DLquvuNx
	FqckGZ5vK0Lc7E9Rbjihc+ABUQ04mV4Q7tMNaSCG9rc8Qbc0hneKXZPBOti6j75v
	VNuM72VSeCBV8VU+hG8HcklBxbCmE4o0RPJUBmp9dWM1JdHJjIjDOk/nOXjuBgC1
	PH+ylS86kb+bV7jcwrR2/lR7yJQLZNtJoDhDVaDpUsA6ajocOn9Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1q0e52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:08:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F24s9D016614;
	Fri, 15 May 2026 02:08:21 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013022.outbound.protection.outlook.com [40.93.201.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kw5murb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:08:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rTa+jIebQnJVy+KuICT2e+y39fOZiOYBniDAL2+D28JfHTU4t10GF7h1dZrdp+R4XFG3kw2TI6MlnF38MipH01R7nfMY1sTmeGIoDB+CvRIe1XSOJa9mj7Sv85g4u9DtPk1umicH3BwSJ/tT9hitkG2FP1cyVBXcskxbph2WFPT3FaPSQ/SxULZIW57tdpP7ppz9R8h7FQfw8r7r1IJTyXYL/ZP6JqU3kETBa5QKC8ZGqE49DTwx5mKQIeFRU4nBrd1biPKZeq66LNEBGr8HprOXfENfcAmWIWLgMb3GRMzpV3nIgvTS+JeXNEN0I1r7BIwOf/9wmpf7mudnYuVfTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KkW5pvJp09IcKimKaoCMr0q9bJPVbmH4FjZGipM5KcE=;
 b=ePfOukLBX0l+VHWqM/lRMVY7dkLAAbVJ7seh8pgDVudK97d/s2tForPuUdqnft4pmd66coWVxRdoGDoY9/dSvKf13hyTggfiM0eG9CcxPaYwReu5IhHp2FU2GE3QcThefoNBcv0tURdq80VHwVW2vRgW5gP2uzVeV0ow6WPwBUY1P5HTy+6jPqSfiyrNv3tB2qnNro2qnoxQMu7Og1I2f/S2bUpzaDGNfFKCel4urWxGQsasoZSYatz7kcl6bmqGaeRgQ9scFN16lydvPmGPZVDirnJA/hs47RHYLlfDAEiCIzcFJaCWIvmrR5d8WKCpixXFS9yrPjrHGB6H1GrOpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KkW5pvJp09IcKimKaoCMr0q9bJPVbmH4FjZGipM5KcE=;
 b=aJJtWv+KsP8z7fjbiPbDDc45EpqwXiM1B+XY8fFJWU11EC0S0W/dxE41vYVy/2bTZMnQpMrPWwleVHGfJ3npGFSZT9NkHjt7V+n4UTT9HSBIQsk/R6aEj6/AnZXHSMCYSfDfs9XR73QESE1QUtDCQUhE4yqvDkVkUpyiEKAAhc4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 02:08:15 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 02:08:15 +0000
To: Yihang Li <liyihang9@huawei.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <liyihang9@h-partners.com>,
        <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
Subject: Re: [PATCH v2] scsi: hisi_sas: Add slave_destroy interface for v3 hw
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260425082056.2749910-1-liyihang9@huawei.com> (Yihang Li's
	message of "Sat, 25 Apr 2026 16:20:56 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ecjd5ssb.fsf@ca-mkp.ca.oracle.com>
References: <20260425082056.2749910-1-liyihang9@huawei.com>
Date: Thu, 14 May 2026 22:08:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 49db6026-55fd-42aa-b819-08deb226d320
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	IqFLK3A8C9BnRcw++kt8FEz44g9bDOuROncvMRN4yqZLPEPvIYzCJkJh5jPH946/Um+LfkyWEcDZMhbXKrP7a/+sX37ezP2dMag2oBpgsslMGF7Eh2TzlLLGUCs3YOHhTm2dz8mLy0z+eiAFMh1AnaE0wUb3NNs8DLaP+ONluUTjmnsDxpQPTudxG6ZFp4bgvfxAL8oe6JKJBEkvQWx3ho3Af39jRO+RK8CyxQ9QcJV8UFmwwwQJ2K/6ike5KwnvTuBODccW4pGZLkbFF73d9aKNsnSr+fD8URYFevJDJEz+keNV71RW2+J2fEEnttPXNW412nD41d75/LIYEcFr7A8XbnxxLwWH+X1l4LPPXWah4TywO1OStC46QVcBkaq8SsBB46psPP61bFfMj+xOS2SwndOVbbSxZhwYOtuIydd86LBuOJXLce3Kf956bE0hpGR0GAYGigXnAOSfDmzu/BOMW+Oz11TCv2giXD1IR/yldyRQnJglw5Ju4z4gP72PzDyQS0cRarUZTJGIZFJND44vfatvkPwIif59i4ynm6tO4d+X2lMFr7L93MEE8wGQD8YXnhnhfstdP6BE0D+l2gG+cgM0Ipx1BVwteX+Wpp4v0zB/EMfUtSHhMq+/QFWTsKvbfqzj7vZoypKw/sQyw55CxskdX8nL/s3bdXazFz8mPCnFXqaTf/hn5nbwZrj7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zGKcultIFPFYqifpJO8AtD+kwZ6CR5617hM5vrqWRw30zFx8wqnvQHlOuwCb?=
 =?us-ascii?Q?LCi4YCk5MFiZnfhVZfx4+zFATrJ3hD2fqFcB93mGLOmztn8mm50FDrbii8eZ?=
 =?us-ascii?Q?zlBeB2mrPN2WxXCgxhKjnMSUd5+9smnjwG8OUnbwEg3bXiV7lTpD0Ui8/dsh?=
 =?us-ascii?Q?3SRSweK1knWYgsNvDJGPvmwY96BrRnzZ/JElFj1PnRmT5T93ehDgrJqCVUiX?=
 =?us-ascii?Q?6eFpgSgufW37LpLqdiKRUoBuDwcQEbzFHb4JTuqND4MCWBv9spJ8CougXzBP?=
 =?us-ascii?Q?BOUDTPWe738AroqZ3TG+hf5qizUsadj23lb04Xh4g9eusolZvBuVV9Nk63gq?=
 =?us-ascii?Q?gasCQNou/PhWDYoby2JZ8DCddiyDyX4OTPxVedE79Msxjt5fpFnADVh9XWaY?=
 =?us-ascii?Q?q+lgn4Mn7RAptAsVouD01Qo6+Ne4H4z5bx/GQ/XIyP7v5+V4jgDui34pGTej?=
 =?us-ascii?Q?g+GmATIFWa21gZWcqxXqAf+t+x3aaDvXK9ZgpsGG1tku/MDyKQF5dMerjR66?=
 =?us-ascii?Q?NL8ZXi0jNYiyea3JKz34+lnaQkjZUucP/O8MvWQxBLkkMJp5FMcKsN7h4wZR?=
 =?us-ascii?Q?PH7jSwsEmDtTeq5txWQiaW80Y6/XPfYCy4kSnUdnXaAF2Aza3yfRcB50KJUU?=
 =?us-ascii?Q?bgtL9WwztPCWL12EUTQOgce2L4cyhaqTX7GOGaF5Og141yw1WDyUDCwOAkyG?=
 =?us-ascii?Q?5Zhz3NmtLbg0Lx3C/CovKWUmohowiCoj2JxkAmkCPBK9PNEkX8iEFqpOXdaj?=
 =?us-ascii?Q?HNPRdNxLzrQJOwoIbKRolE+H/0GIUfhiYwogEMLGAyL1C44EfGG2960Ft4gJ?=
 =?us-ascii?Q?AzoBx5NScuF3KtvOzcWrjUzcQj/JVutf5qISImiwPT72nnCq8y6Efe9yWsxl?=
 =?us-ascii?Q?DeVcbNs+xdJD3zsd6fg6syxhFaCUgjj6G/TgJ6tIPJ3J+8OJRQsjw2zwvqvP?=
 =?us-ascii?Q?hybvsX8kyeYXZIiqBeaiLmfTG+yc7xX1CQavK57n3EaZzJx59sAzkFdMKD87?=
 =?us-ascii?Q?BhYQIAoLSrI9lm1kYCJNghLOKSIivBApLWT8bZAuz1TCQLLe/QxaNI/SzpAW?=
 =?us-ascii?Q?UVvR7LSWTfX1mOZ1gA2xpNEqJl96c49Y0a/9QORXysKxtPbE1eApK4p/BD4l?=
 =?us-ascii?Q?gpK5lAuWExFbjSZhsID56uiXOIOxHxoryCQ03gDQpN+JjLw/29JGy8PdmFPe?=
 =?us-ascii?Q?+DOz7LFjj9Qug9c73SYAoaZ8gepRrkhdrtDrQNJQD+Brzxqc4pDj4Rm2JHsj?=
 =?us-ascii?Q?m7Hpcv4sVsacIYyOsL2LwiPJow2jQFtVWrXkH3Ze6OP/5nQ9zs2G6Ms+fiE9?=
 =?us-ascii?Q?aqJgby6V3FS2rp99mVyq3KNcf5/71UOgr0SA2/mM/PX/pVoXDWAYke5ZVBpr?=
 =?us-ascii?Q?yZHk7Fwsmo5Dn8vYq0AanC1GWz13GvB+J2oRyZAXbi5X4pj90N5o8eNu6AOb?=
 =?us-ascii?Q?2XUjGv+cViHYd62L3GTde2r/QoCw0YDkU6JkSNv2difhsQBaMa7miAsSJq8r?=
 =?us-ascii?Q?213wn6q44dLTZkjuMRwcfGvGun2csxLPmXmcQqd0f1+PsAyB8ZoVKqBgXyHH?=
 =?us-ascii?Q?OkN7blch1WDq+78QXtrARwcYRBj8Ck3MSsPD/1sIyM0a/GkBugzFND3Qp+YT?=
 =?us-ascii?Q?wLkbt40rgBeHZ9AVuSW0f9vdUL5olpP9aCxPk9/iZuR7vl2/tuXc6oNp58xI?=
 =?us-ascii?Q?0Cuq/f/sd7z8vcZrna0qHByKp44CJkc/q3Wx7q0jBvLogUQWYAsNsxSxAo0j?=
 =?us-ascii?Q?WNVCIU+WVxuXD53r5X2ZtXNrzFvkuDU=3D?=
X-Exchange-RoutingPolicyChecked:
	BtuHKygSbOuVU5I/KwZjhR6/4FDOjPZ0G5/aZgTpvqCICasg7kdjrUaDGyvxr1EMKGex1nQucoXGy5Lxz7A7bZQmZA++lcEL/Eb0d2TcQuM/5YIO1PgtHs0ivsqyOZcMBx5/CCxI3//Jn20J0VVQduCCHjS+g4x6M2Pt+Da5nicuvrh1R3GkMszD6vrG37XdVSG0VskWLCQBbgkYB2cMu+WuC51ZgruryJqqgdHChuPkI6krgFoFFnEBCiFYvOv+iXogQ5oWhhZXbSK9whI2OPE2l5vfhpu4sqIWx/0hqfww1/mfMqdmlNk0wFqTiLUjNcUJdeBt+W8hOfHAzNEz7w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XVnPgEScsyeMlPWboVuZUvN0Uzb6uTdgGP6QxWd9ReJsCTxW0hH+bg22CbxbzPWFzPdt1ejPh4Vl4szYNCU/uRKrZS+rZlg8VLmIJxz3FqFxt7snO945hxHVJjM7+QD9BV8u+4gyMK3smeaaZ72jb7YG171FY574pPEqoATHzAFs+iJ9M1lnh5PGE6fbpofeh/9X5mUzeZwkYkgSB7Ar7R2DE/w1LSPYDYSi7TAe/SiLvVmJjmSwa6+3BjZrE5GrcT5Rbi0CxyEVStgUNpGi2uxjA8RWRvbtIqhX3GSbX+U5z7yasqK8SF0xDL51npy5Scc/6YdKshYDWN98tSokpYM4CjNBdw/f3NgmCdoJpHtrbgH5g/J51IAKaWTQ57OQxXRqjOw9LqbffKdLIdsfAslylQ7AsrEj/j3r+dH9DQBaVROTid36pwNusCBWr/qjbMN6esrUoGthTUypslvQaB7XGNAJZL2W13E1yI+VqYLAX+vTKF84AKYnOvJx1kMeGgTUE8kbJpx2Imj8TiqIWa2KJmHn83AcSwZWCu4Jh4w1MFw8tT+mGdM5ryvmtoOKfxK9OEgXlsWOBxBH8MS1IOjZlT8/BNeTTH4J6+KTTYw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49db6026-55fd-42aa-b819-08deb226d320
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:08:15.5706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKADxi8rP5SbOI4svE7k6ME3GfvCN+02XWCSOG3sJ3y1+zl+vn8xrXT8d/X3vWkCRawQXrVUwWDrpIo7P0sn1lY5CqIZ44aYlPng+RZabZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=880 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605150018
X-Proofpoint-ORIG-GUID: sdfJmK7ippTAx4XA-YKDW_6hJE83wODi
X-Proofpoint-GUID: sdfJmK7ippTAx4XA-YKDW_6hJE83wODi
X-Authority-Analysis: v=2.4 cv=PYPPQChd c=1 sm=1 tr=0 ts=6a068016 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=sUkNAWjWoBFuHH5kdicA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12298
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxOCBTYWx0ZWRfX9GWvSO6Dsx4/
 PW3n0Qafzvn+4WjThDZZKUW/h9kH/L+tHr4DTFN+U8Y4h+MDAH1FbWtB2ExMKT/Hg5BliKM32qQ
 JXE5bly+EtEJ/OL2e5+7fS5fGonpqQUjwuXULmzO+oc9B0RO8KjSER25nKiZFyoMXuPTaIt5dS5
 OzS4Wzr3eCkGp++JSlVy+xIbnHZp7CKAVm7hXYlNL/1SfUlGtwN1M6CDxcRhCpK2cu40EnJFt1Y
 /fQKeXII3D+4olYBO0r2TcTWXhzbVyUGO2r8vEwrKr5QurlbjNra2EC5trBGFhPmJWYJh0CXOKU
 47Us02IIM2H2Manu7Ei4q4wTFnGF31D8bUAKBXBtJxfzpF8IPQOik/fsYr64Rbi9kZux4zhpwS/
 vWcT4sq2VQxOyVD/+BipY7HStX1C1NNiAySCLBSXhlfiQLINIU9MzLKoQArAv6v9rjET/OegwRu
 csj/qpMoIwPDS9RkBaU1fuHKkDLBxBlTBoQnLqAg=


Yihang,

> WARNING is triggered when executing link reset of remote PHY and rmmod
> SAS driver simultaneously. Following is the WARNING log:

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
