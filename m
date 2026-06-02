Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A1B1B6D1A;
	Tue,  2 Jun 2026 01:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780365572; cv=fail; b=gZPvIakrIOARB9AkROYhiYG7W3w3jC84Culy7qEFr6qY4EeFkr72TdY59SR0suyQWONUGk/PcBPTcbReXY3k/M4x8ZdBNpxuLO2Lzb4VaX3KvlAgx86BXdGtlAzvwRWjpkc5YkS9ZXm9LrH4bXVQ52mZScWL6jFnYmnEPBJUQgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780365572; c=relaxed/simple;
	bh=LSAZ57XjkVD+9BK6yMfqlm6+a9QLNapk6gjJebFjLqc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hytby8NnCvMCdG+T/kGznPvG5pcZZebIFqQzLwMH8BSzzAIwWHWcf2RooZ1iLpYcjBylqZQRwHdPRRje+/ao6ZA7dhaEM/tTd0xDMiLAkj/FC79SMo5YbZPLxKO76u5BHBTMuQ5SkfbtP3ce/GCL/M9MH9LLZXFZIm2WGuvnOUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oaSkdgHV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pC3lXgeO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oaSkdgHV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pC3lXgeO"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6520InOL1268027;
	Tue, 2 Jun 2026 01:59:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kft7NwIhlwNfD0QmAD
	b3jNo38CwAXndj/Bz2qVKEYRc=; b=oaSkdgHVD5ftzL0r1B/F+n/bPR/dYfqRUc
	rHizQOBdjuTAX1Vxg7ju1PP4P1KCA0/v6VJTy9nDZU9Ppg+JLLVhrJQ4ZZG5uyfP
	n0r2146Zo+mF1+oNgxKxsW6F3tY2xE6y+deSjI7LXHsf9R1/5sVoTIlCDpfB/ZCa
	Be9G6tntCIrPiBR+mQIq2EJ7gXWVpZOpVbqVmD/fISwwwfgP/sOphzfGuoof0tZM
	fXII7vJEiMj+YsRhMC6Pa8zqAFGRQDS27wfq2ByberiRPOpE6vqWfxp3KRtyjd95
	vZ66lsX/GbFd8SniGog4UULFiTjqjK8f3Pf5aEYfNUG29WGpPesg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efptbk90k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:59:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6521thfR021208;
	Tue, 2 Jun 2026 01:59:18 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012004.outbound.protection.outlook.com [40.93.195.4])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbqk492-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:59:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OGz7JlR2spZx9kkF8BmQ1X0AGlxPYxExXMwNB5B7ZkICAMe6H+gD9xt2266na8eQ/GtgQmCILfz30n2lPVuK4yKj8ZTGrSYaSGahndQGtiwLTv89Xw+mZ0e9tJ9Lj+jSl0qeMyI88WOiFYdXFLU2PdYOVeHADlXVcXnTwgEXr5BtPbI0qWn6B47RbVIaNqmZFElcthsyyDCuOtd5v8HrILpJ78KEPwNC6m691jPXZEZuhtnHNUpqXJGaMfZYEIsmTjVJzaWLFa6WnzW1BiKWRCXGOE/apiLoRMu2aMZit6N3eawYog3qRNcMKDgSHdt0/ARCirW5p0rvjIuK2e8g9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kft7NwIhlwNfD0QmADb3jNo38CwAXndj/Bz2qVKEYRc=;
 b=eOb7hRMMGx8Y4gqXebPGHYod+E7Wv66CxUDNYDTq6jfTOWMRBvE2pTTkzfDOVXbf9nYC6/8BR7E6TKnkNPgDzurR/AqS+pBl+tAsxIla4mH3Y0CICPJvfFvQ3deLkHT+DaKXEB4UPWreRVjFATruxDvpr6LofTxxk4FTormvcoSP7T1vFssDujHRxNOICcp+z3bwA3FYb3u8c3dYAcCXkuZq6ubjkk6rmf1nRrLrEUJp8obsvB6dUORhzXtRdWrJRKgcPSFSKmBICaV/1yTQdCFJI69VirQZKgMvMHBvgGvbwezqeFWm4/JtNpPsYEh/yQddykyY2/Kl9Sg7Io+oRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kft7NwIhlwNfD0QmADb3jNo38CwAXndj/Bz2qVKEYRc=;
 b=pC3lXgeOEEtpQcRQn2G69OnJ0qjrjjyjbapUd3LBfW7M+Vj7aT18IxFtIwcpkMXwSxh4N/F8AkVehmq8h3Pt56mO3gy4Ro0LDis6DYrzpfnSBMcr2ntuloLXAbd7U074pGiodggo75YvB0cuT8RGTBHG7TpWb1xEuGTWKMwFmy4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6729.namprd10.prod.outlook.com (2603:10b6:930:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 01:59:13 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 01:59:12 +0000
To: Chanwoo Lee <cw9316.lee@samsung.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        peter.wang@mediatek.com, beanhuo@micron.com, can.guo@oss.qualcomm.com,
        adrian.hunter@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Fix wrong value printed in unexpected UPIU
 response case
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260527092134.275887-1-cw9316.lee@samsung.com> (Chanwoo Lee's
	message of "Wed, 27 May 2026 18:21:34 +0900")
Organization: Oracle
Message-ID: <yq1fr358zys.fsf@ca-mkp.ca.oracle.com>
References: <CGME20260527092151epcas1p125118deafc1caad64c4c2c9620124969@epcas1p1.samsung.com>
	<20260527092134.275887-1-cw9316.lee@samsung.com>
Date: Mon, 01 Jun 2026 21:59:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0233.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: 9da6f0f6-b3c2-4b04-bee7-08dec04a8b15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	88iLxki0EhP25YQu5uXJWyMd2IO6T1ZKKJq7B0ZQZC7r5Q96BD6tK0pSDgfLG0yI/TuFjRrcYGUv2ivDFAY5Aey5nCz8wna1O7UsyGfLUm/VEJa6GV5WO1BxbOVLwgkx+XtLMBIbLwmfMF9JqXf3qXrjgYPUwTU2udFSusTAOPzbTedvsU/HDU67yVocrsA7DL3FlyuT4bPSD0dcr0KuGfOyM7E9cPm5Rb2qnn2CMr00POG2S1u3oGaO0xHianFi6y29olhxce+xJP545ifI4igwkT4zzsUcfUYeHzKox1c/iUfxLTqak8NDsQP1LtEHVYw94QPNrc81myT99m5G4zR3GC9XYXT8kFXbrt8m78MT05LfIqLGr/aN++aHqefHJiDX6KNPKq/2H7lYtqKP3inTmHCYNvxO07W5SSziv1g+GUOEtkooKEmUrZ1Jg7JylVpo8nvu4cQY7Ss/cHRH3uU/ap7KYQqqN6CRZaAEVgCfsxOvcLnmmWzNLo/WIDp1+7EAgvDqECceDNCouXaXW0g7/H0ZZoaJE3oA15yJK96QQ0K7w0EQ6HTOd0bA29VKjCCSeOfmBXoQlHKQw9NrIY42rzI6lz8XIE4BgQ0Ag5tNjiivUbObYQ3WW+9Y8EswupuZqHtYat4gK7j90seGH1rtcV+ljmh/J72SoYLjRUq/9K37D60wqr4Yz5GhD41v
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wVvEFujwjoTc3TibeeXkAp+Znp25Ju2V39xJJK/yBcc5Gxvp8hAHdxVyvuv+?=
 =?us-ascii?Q?y5NphKo7ywab7FAAU1lQ6wOMx7lnkEDUjS5dKU1h6f9BCMG1GcG3ucPEUTcw?=
 =?us-ascii?Q?5yoMrx9LR4kZRuMTHpRyimxBf4RiGARZqf08EyNv8eKvQ6Qmmprn7/q8Pjye?=
 =?us-ascii?Q?HTDfHOgiXaKDZJbLZUC0liWo98qTCWcu6DVPj/espTtPpPkk2jKZ7nXOdHDY?=
 =?us-ascii?Q?V7npv3DIJkxqQwzcm3cVmYDjG6YbqvUgrj/gmtdhKugUbREyLx1f4OBsY9NU?=
 =?us-ascii?Q?e9T0RaMupEX3Kbvyjs+YtN2YzsaFMW/CExEgNSWpHHUpPiu7VZGnEkj6FfiK?=
 =?us-ascii?Q?A+7g405vFUlTnWgV9Y+jpG18nCeOI8mhufrU/O5pGnjpVgAu5twSaxjpPky1?=
 =?us-ascii?Q?/Wrn9jaq31BoV1mJ+oOykVQFVpG8R5DGZN3RbW5U9SGum8EuCERng0Jw2seO?=
 =?us-ascii?Q?/zgeMJlRWXry5dFw7u6IWrkjwaekZYr1wJyZNOPvH7V51lcAusV2NzMdINXa?=
 =?us-ascii?Q?epHsEElYw2AbF465NJCJD00ABXtdmbVulmongoisp1XgpxRbI6PitDuB7Q70?=
 =?us-ascii?Q?93LRTf7ZiE6zHM3ZGLLi+B9g+x9ZplYGUchTTIvPPhEVLpoSEpZdpPs1fHMn?=
 =?us-ascii?Q?pd0dZziSobJKhe71V62/auZ069/wN6gXaHwR1TSkkLsT6AupNLHtgNn2m0n4?=
 =?us-ascii?Q?z8Ty8KqIPViuLXwSJwvkmRDUkgheXkeTCy4UiGDJKM7/WQPyyOPmx57Qclux?=
 =?us-ascii?Q?kEbm0XcSSYG6QMyqfKWp+q4CgZnSQarJD8L6kDrrvqMT/cX2NKqx8NHB1y1U?=
 =?us-ascii?Q?ZEFA1Al1lSg9cCcKLpXpXGZVYTBZHxW4CR3dkLQM23OPswX9TPN4nl4z4QUH?=
 =?us-ascii?Q?lio8+6tR7ctdYb00G/7Cm7a03yCQ5MshvY8GUEehrIRTDrRSP5HMXCFv1zwV?=
 =?us-ascii?Q?lVIhEfk94xYfxVLHjIuj16UlbRSrHzqWvflYYkMKh6eP/vDYkHGuPPU5c+7g?=
 =?us-ascii?Q?HVkC5PbZFENjayyQ6C+8KrzohVqPClV/S0JJ+6gy+0kOla53kuQvLb3hEZn2?=
 =?us-ascii?Q?7o8ilbtersZI3weL/3dZZqOTrCb6sbZUL86e2XXTvSeVD9cwcc0nV24qouYj?=
 =?us-ascii?Q?hLIOXJwXdGfMPcNhWRsysZiIY/0QxmPBNvAiWeNbTSzx+GdrkbCyYE/ruh5g?=
 =?us-ascii?Q?pmE6O2FouEu3LxAqQ7tsROCIGEe/7RlAJV07/0pISAib5qA4U2lJyKTSAuiq?=
 =?us-ascii?Q?jNPJ3ob+qS3AC8cq+sBQvbPlkdixKPFNrJpqBJkVBQXrlSJHlx3A3n8TwrWe?=
 =?us-ascii?Q?tbJO7rA5YM2s4pBazlbIuxhDbD8vEQevgt2fZ+PGsGeL0gMRYSRaLNTXIFdy?=
 =?us-ascii?Q?GXP1zfU9zsX+y9EgMZ86WAS3iSmMxu2BGFmmEPOeP842zNx2g0le8l1F+Doj?=
 =?us-ascii?Q?t7n6MtycXlGAbTfkqRrhWMO7TnrRlZXjHvIeg6Y1OxlFp3LRTDAJ3/EyfgK2?=
 =?us-ascii?Q?mIKZn8pEalpDNdKtn3bHEjdgdGc1j6eFTeVD2pAzBmxOUWCDMbKyqVMLUaGc?=
 =?us-ascii?Q?4dewyyrOh355gTEGaRALvAAbmLw0GDHsh99ewrMBSU0XjyRqmc6lktQm8Q4Z?=
 =?us-ascii?Q?XQimpDFNAXnS5HBFPPKy1t2A5Gm/kKCMQu9lbEGH3mReCcA2qzE3BKN4BPfF?=
 =?us-ascii?Q?lkFlSa2o6dyD9243lpDMkNYl4CVfAf7ps7+UE4Zo1aHJp897wHX8QZar0Fxs?=
 =?us-ascii?Q?oZOVjpBBxah+RmwHfJrcEjPsUHJjGhc=3D?=
X-Exchange-RoutingPolicyChecked:
	pMMGbZc7UfrLWNiEglz/TPer3d72JKnGkeAaO/fEOkYLic3GM1q0iazRqB6LNxsk/eqbwKkpIdZRDjNlvDq5w06ReTLnY0Q2vM1W4XxeYE31b7zbFqrO2RNCi+FuVL/8tfxmdyaGBUVAVm6xSgBlYuSfX4NSenbIZceJOqM5eetqehZd1XFTPnQ/mtvZo3yPQyHmi5cd4Nma+tRSQi5n6g5u4XOO/+9SeQuImCF7fvEWOrn561vXQQPshSRbK7o3a1AaNzWHSRNoQNSFEg3wAL56nHlCmeh/rG+7MomPMAuKIhB2wOnwkrSLlfWadaZIW1I/Ddh4/9eQnuy/idSfQw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OCh9qw9/zdlS/gWKf70+NOtWOlBcX9kK+QdcLChk8ZxiV6wWVEmBtW5G+uaY25UTSdiZLTJQ2zOgm8DA0MYxprQG7Hg8blyst3oP4gaa0MmE4BXXZrSsH/Y3b76R0Bbd5TpQnkJnGWFc7ygKSV3Il8ovPXJhDnxtkNor7knL/sjL2a0l6VUUnwRxrVNs6MB032QPzZrGDLzoHE5LuiuILEN0P5Xq9RyH6jXRyoteo5XTfSbwUL0bfPiqjs72tgJ3DcHFkYuZxRS1QjiFd0yOFWDkNDFr9ASC8/cE6stMOIjH9iZXyYjxIW6dpVpQ6kNEtg8mOk3OkcyqxZatrfLELznXPRw9Zd34dIPd4+U8PiKcBafWNJ1jLay08pD8saOk3fSXpDeYclyzwUgCoPCAENmObR4sBIyxQjFjdyVKkM3RRNIzsY4C8kIGIsRfgOm7Ac1aQjZD8UIImWXg7q7wctf3suuPzg1d8o9HWFWZ6dK8fdPbfca0i05SWvly2Wh79uPHynoLKjTQguF2fSOkvn7+ZtBip/f41NBnnkv/syRz4dnhQmgSVbQyo3OYRKWYLQnUJ4L6zZFNNv77W8jfXNKrYVAt7ssFuqzs7FMaEvE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da6f0f6-b3c2-4b04-bee7-08dec04a8b15
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:59:12.7996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfYtvIXggsPpQR5d7EOAUKlk3Lck9Q9mJuJc7ZyQ9sldDb7EZ7mE30CWOxhlNfSDfaYtT7qygxVUr9f0OmqvVzcWQ8HZOE6J7YftEjdsrwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=906 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020016
X-Authority-Analysis: v=2.4 cv=I6dVgtgg c=1 sm=1 tr=0 ts=6a1e38f7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=qLH-q2pxGIW5DTSyXWwA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13714
X-Proofpoint-GUID: CWT7Yk_BX64jtoH81Pg04_uI0PmnS8Z-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxNiBTYWx0ZWRfX09donUQPERNW
 9nCoYyYnWAeOcHbcDax93h9NV5TmNuYtzW6EwpxBZ6RtvlKil7cb/0praO72/If/SpPfugSDF1z
 tQYu3p+oUqYIrX7BElV4ApQ+y3RnnoqtBaJ28k4QnbO9rGhcYhnuvG9zPqG6/hIluo40y1xplL9
 GsMocqD5XzutnrWaAT/vB0yzCMQnbwm4PwVFyw1wMAK8O6hohRN/KteZXWqMqB20Qzg9/d2h0l5
 8rypw7+1/kM5J/CWfe6WlMBOT6d52xe+dGvTo2UMbOqj/6SnWpWPETK/Tf9gu1EBpq1bJt+lwJs
 C9aDF3ZKQwx684ph33nYYbbSaLpYKh86XF2uqudd/b28boWqL8591rRONL69gTIOXvfi8tVSS5M
 eoLRbC5A7DRHB4giuXxIpA45SJhy3Ve8vaXia+4VoU3t5NQpaX3Jmj+WAgca/Grb4Lysavtzjow
 ke15fDszM1vVHS7zzXclH5MwvmzaxilfGKMrUsio=
X-Proofpoint-ORIG-GUID: CWT7Yk_BX64jtoH81Pg04_uI0PmnS8Z-


Chanwoo,

> In ufshcd_transfer_rsp_status(), the default case of the inner switch
> statement prints the UPIU response code when an unexpected response is
> received. However, the code was printing 'result' variable which is
> always 0 at that point, making the error message useless for debugging.
>
> Fix this by printing the actual UPIU response code returned by
> ufshcd_get_req_rsp().

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
