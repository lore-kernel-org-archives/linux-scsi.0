Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3FE449985;
	Sun, 12 Jul 2026 19:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783882935; cv=fail; b=iYBy85i9CBrWiLaY/MesCHaYew408/6RJgqXultrZCfzkeXCgnwRrVlXg6ounklc9Mal1mQwGH5TvT9M7BpKP+Q3EOjGc/M5mC1odPJvDccPwgnU0FjgeN9glJJEYD3NdarPL6sx0CPJQGb53T+FUQChrdlU6Np4eDXgGFKFFZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783882935; c=relaxed/simple;
	bh=lfzvgiVbLt3oysKjG9hP+eQewM78a/sVzkUxB8dTbNs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZFBbnx6x/Au9/FYwsvFCbjCdmbK/Ev70SNshsd5c4IccwG9VKQftzjuapiQ4z0xdJkzo95MLuGckRQFfl28nJdPoYI93JBDbSkPH3Y76VX2BRBSNKPqkQwq/wOCcKykaoCoJ1STY7zv2rwj7mQJ4DiS6nRhFOEtkes5kejVbRRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sZ84L0jn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XTFhmVlX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sZ84L0jn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XTFhmVlX"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CH8YUY3655148;
	Sun, 12 Jul 2026 17:36:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nQae+QxdJ+lLxsvmue
	+12td8FQHjr0cp2uUMm8D52ZE=; b=sZ84L0jnTJPE4/c9dRnsu1pkAvo25z9COf
	UdQj2ndxji4BQXHckFXhb60fnCiF797BozM7gcTk7oHrHSs5ovJD6wOQjG4Alc6D
	xWBqnZJHW8XaAbDmCy6tY3WQU5ywPFttgOYgDJGi3/2F00iwk1dSA+Qnz+zJYwng
	ktFc2YhJJc1W3TSHf+ZW8MW5CARIhrKJByra0CBnirNsxUGEFGPUcAV6n5lN0sJY
	bwDYUBwAa5aOStoGB7LVI7eHYBGAE2HieOtQlKqH6+FQKDDppuhveIKdrTGPCJDO
	zpPMKS/J0m6oGZpQUG28Z0qd5cA/w6YG8ZoID0U5pF23i8XujGUg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedh4mb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 17:36:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CHX72D017882;
	Sun, 12 Jul 2026 17:36:08 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9bwdy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 17:36:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PNPQFw+eSZrcp/abhkRVyg/o3UKed0/ttRfxsnVFabRmwAylIZwGaJ6wEeEGdFExHv+2Qs0g79g3AP6tvLoFI5eGDlzMd1Ga0GJ94kLfPZQZAMTjSf3BPMICuHXI3Tw3Kp9RxnNMWJS01rE5Frm6cbD3xeQmzPWUMIQWOzBDBid3nDLaduAISjdoGdklZG1CS0C5XMK1z489UKv1ZZ4bNYr9xJA56byB/cLPQdFBPZnMhtvgNC3an3NMHKtNzKZH6pNOGl7eAHn9OKMCiadGnnYAKdFuk/bDKJWoRaZbmgIlUAXJUzKYFmpiH5A1ih6CB3ngU+ZUkjAWR9LVi/ykSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nQae+QxdJ+lLxsvmue+12td8FQHjr0cp2uUMm8D52ZE=;
 b=fgpSJMF/EONZ0QQPovbD0RrjsGC5sjPAgItrcvPZ5oZb3vNTO6aNNOX+kjAfqvPyKABnO0VBsnc/y4+NWH4e0+oS2kr1/TYsG/nAAe8jc3cuukK3En1WQcKBrYNLrWvybj5VFejhDzl5rRVCbLqmN6SXnJVlu5aiAa5g45GFVbF2DryfFccZm4eVRG/5hK93a9cJhK0asq3wb/CUdemnXgrbjnZPDtY49oCdqT8/SgYsczzi++HW8qv/HWY1aYc6HOT4YxW8IWwEZ7R01wZaW55GjDuqbXpNfmtO7uRfYOOA+Lp9dGarW4yvA+RQG/5TcNKwS7ktUvx/Kf5MljEpxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQae+QxdJ+lLxsvmue+12td8FQHjr0cp2uUMm8D52ZE=;
 b=XTFhmVlXCzuoPEhQJeWucFG70NKbdCj0+sWMrWZ0VIuI/LYZLL2Ge334C1Y6Mjq5yr2WI2BNMH/lbzPm3Dj83sQnkFq/Vj/A3+x/U6vGSmhSmWeyqe5wtBIZ8j69h+ubny7rn3yUvGCCpqsCI5kGHTpQhiyt1YgngnCez2iyoZE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 17:36:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 17:36:04 +0000
To: Yihang Li <liyihang9@huawei.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <liyihang9@h-partners.com>,
        <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
Subject: Re: [PATCH] MAINTAINERS: Update HiSilicon hisi_sas driver
 maintainer to Xingui Yang
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260616032051.1268608-1-liyihang9@huawei.com> (Yihang Li's
	message of "Tue, 16 Jun 2026 11:20:51 +0800")
Message-ID: <yq1y0fgf6v8.fsf@ca-mkp.ca.oracle.com>
References: <20260616032051.1268608-1-liyihang9@huawei.com>
Date: Sun, 12 Jul 2026 13:36:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0041.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: ad323496-be46-4b3d-2481-08dee03c0bfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fdDMMi+lTNL30vSKFR32T+0MaQQjAoWBl7UKoBYpe9cE40mrIKSuVdu2QuQR3UX3qEtXgcY7Y3Lvlw1o9RhPhsEW2vYjUwuzmvRclDEbm2lHo/X3eLUXFZhvwDNR7YOTUy2neQEb1Mvf4VgIAM2gezzctuacLxV7weW1ko7GcIDc+D/dDoOxqGmXaVNTJ7m1ZCfHRX2ETXZkjmfc5PojJanwdIds2EnFbdUbsudkjD8bdazh59nNDqe2iW9X0Ujpm7/V3RQR6C80KXM1tnydrPB1sxLEKRIf1c3ZXehp0mWBcIlGWCKDNoOCH4Y8EDpYKSRmcPb7WyBeVPvUO1LYJ4KDTPR6tmiuc8gz4wTR/sKCdCeqgjBbq9mvbNaxDpOepfjJox4SQzoJzl5bL/Me/suyDIe8BF6dfd5Z8N/fuanqlWvtIMnriwGXNj+lSoISTJsrpY52KyvC+KimKeCRIkID4mngwoNLImXMZjOzXQz49bgvbifhe8GMBzQlNuBFY/ruy3/p34jKdYTXb0NXM6Ks07iNoMVXk6DOYnmHDY4cuQlfJf+7DBxpisdGHTUU4e1GJ49tm4pDc4wOI//zkoizclzb3Z0YR7GpWLk6Bu1cfwPxC7CSjpSxXL24TDqVFdDZMVw6c/MecO2C5icpKMt3eYEnNxrua0edFylp/AU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MDvQi15sPpNIHK1d7yO3+z0eydBCMpgm0rfXc1TmZrEWusYVG8XGqUBHApO6?=
 =?us-ascii?Q?ZuP4kL7hvTmCLMUEg341rJV2NjKm+Eb/mshbCQkkbBhsa0Lve6QjVWCFwE2Q?=
 =?us-ascii?Q?2Sx+VKxUg4lH1GyMq+4F1VmRP8RiyElaHgb4DkZN9ABw/GsTJMOV/l2QAgn/?=
 =?us-ascii?Q?ykJSw3YZeMsZsx/vzqIO6TIB/xOgc+kMUTe7GzmUjOxkBwqUx5tuWndI/w5O?=
 =?us-ascii?Q?AjFa3f/+T3kXNwIfQ9vOsdtHTuZOn1g4H2ZQ+OcHPwVJVfQiAC4ssn/7lxwI?=
 =?us-ascii?Q?3smYqZXNTXXTeGVvTSFYwi30lIsVjXF4rj2BllxAqDQtDzRdwVnG7LpT3dpX?=
 =?us-ascii?Q?IeES0xwJaLpDd+1gYMwS4f4kdhF6w3blPTYq8qRz4kAFxDyhmT1Na5G3+5kM?=
 =?us-ascii?Q?RSKWhY4wOtjlUHhCv4sDDZvaxyhKj/fYnFDELJuf1KXVGTJiibZRSzdrqt2J?=
 =?us-ascii?Q?0zNeG7c6l57YZVmMDeRIbXJzcNVgtB/7oqvVgbXaP1aMHUUAhZyTveAbGSnx?=
 =?us-ascii?Q?jzp3q7EPDm7nZX0Fq0RHUn6jkrejCWOSI5UgXdyQfjN88lpbxFV3lkXtfWR2?=
 =?us-ascii?Q?ntlDL3QnRp355Q4ZKtUqFqmaWPa5fnYPCb0s337wv0jbg8hhhPsAsO4vXMFN?=
 =?us-ascii?Q?JsdPw278LsygGyzdK55tk3GjpzupptRg/9dMiU6uQCaX9SI5+QMWz4NkO0QD?=
 =?us-ascii?Q?GvP/tqbeILUtelS81r1N2zSPUDTyT4yPWT05JkhuJai6Ey5O1N0zPk5Pku/H?=
 =?us-ascii?Q?3+rFQsjlXx+MDwjVzD0Wqsm53767+krDojWqokHbWczpzO3b3Tg6KvI6GHJF?=
 =?us-ascii?Q?K8N4bsmkFMd8ZhCuiN1e6Fv5tfrLdzY3Jo3q3ewV4ANJfEV+QeAVs0uFoG8B?=
 =?us-ascii?Q?tOmA8e6m8iFn5PJ875JanIUKfCaY+rdPOpPzD9STrKUnQihA6Oe482278HRs?=
 =?us-ascii?Q?nmp8AkIS5CHhBWsu4JaJD+fLrWmVn2sa+ny/qt30SnZdt0GFzZwF8pkhZDtD?=
 =?us-ascii?Q?jAcwyI7Lw97neuIw4eKwU8xXOLIVFia1schaFSx7oP70//Gr+3s+pgOZTxrW?=
 =?us-ascii?Q?QFpgb6JEzMULlk8lPCruIlNQIxbOqnpLEL0KRD3YMautDHehbgZMgD+iHeAM?=
 =?us-ascii?Q?EjVD1yIQ55cFkgw08PIKJxOvdK/6U0peMDL7BGpB0xeAlY8e63P/lwcNtGlS?=
 =?us-ascii?Q?aC1fCrzEdWP5O3aalqR+Qvtci+7vJkHbeze13a2hjwg8gg9ELmVdI9Mqwnc/?=
 =?us-ascii?Q?wL58qyKdF8HRS3PqSnUG3QN/Q7bAc2HiaqqaEYQLILoLprdV+eVd5lzhS2sC?=
 =?us-ascii?Q?Y2krvkgHkaaL6jzva4h5f+wY5fFvvp+cqH0ilCqebGDuKP1EYEHhy8RlrZik?=
 =?us-ascii?Q?ZgJ5OT3BOxOjiAgVVo7TIThz1aI2WgpVfOHfds3hahSNGbnTGes8EeY6qgT9?=
 =?us-ascii?Q?RFOJVp7OHfESq4EZLHYdFtjtqRJMQtMFieKSBVTaLw0eFPDkMWipxyiF2fWs?=
 =?us-ascii?Q?I3lpZmJAunQ6hIgOYaXQ3n2s20Q/xx7dUwrRWDoe3NMtaufYgX9OgVOwjbF+?=
 =?us-ascii?Q?+ZN++g+B+nXoKfkinLLuTnRzg6fBYLTZBuDOBOSbd9YmNybNADw2wNpIrR4Z?=
 =?us-ascii?Q?wCSYZy46bBnP7Thy+V0ZCOwaMr7tjN99t6qHigcEahLYPF9VjQdlu4Qmorjx?=
 =?us-ascii?Q?juLS+2LW6P9ceF4lVVy/olsuw025zR6unWfNojqwIZB6TEkZm0w3tOyFOkmt?=
 =?us-ascii?Q?SIOLXIKbbD8N8h1cezrgQNeV/bl7lds=3D?=
X-Exchange-RoutingPolicyChecked:
	WVia45+gM+8jpeQ+pWGQyI9pA++XUK56FC2GUUxNqmiJRUNHcVEW4TYP1IT35eXwdrqoT9b8Z6Kfcdr+NtNteD7H/y3LTW1yPsH82R3a4zHhia4emiOsE2S+q5CDyQ+Rpdrm8xCUZnEi61isSFLY6iWFfimCzGZsXrLAj9Bfyr6oES3sKeXM3jm0EkzOCIJCK1GHM+LrEcJyL0UKcvzQbTuw/v17BK/m3SaV4PY0M1GVSmnXjWHc/qC+dRshq0zS4C7zB/ZX3q6Nxz2/rh70EQ/Gln7OW2yRNOjdyATadaDHeD6+6Otfm10qzT+PYaqgp1RHqnZNCGJ18szE2Rhd8w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rx8ukyWtwRW58IvteDPMkrntjikSgd7mmSIGIGDjRcRWYRpOKac/QBG+lmAe0lrXSiUL/XvTphg1+fKCHQVD9aCWfzI3MsbX0tZBTRvFMJNVFSoOxy0D0ZqzOxPks63wlQ3VucN8329LxohaluIuooJGqF6S+3Kfgh4AkMmr2iXMyPry0G61Fj4VjhQlVzMQuzhd03xtpmHbe2kzHBKBaKP1byMg73LXBUa4F94Rt44pCrOu0y/dbhdxPIxnyldd8xL2b+nEFj3gBL2JrcyaZqH6PS0w19XchZC+E6sHOWn94q0cEs4l0x5SqE5c4RAZQV87x51Il0kXsAveC+z6c2Q7aQyiUeZFavSdy9l9fpi6XYDoqgxSSVVgbJeC12tFWhgLvEMylv4dFtICuDFWf3ZW/OBeC0K1KZndX68OS7h2CiGkRCYHrqy0vOlsz6WLhXMwwfNB+U7jdUYrfRo2macla/u3Eq78EH36kVJVFgYB388Jsf5zW9BNqw56E/9Q3nJangi7h7OXqqqcM9m1JVsWjgHrl7aJsdIskUjJJDDTK4FbCk1+lIzPATrl5HM2ahy2mQEtGXVGgIKURTW+v8YywGXHzcwpxm5jpazTP8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad323496-be46-4b3d-2481-08dee03c0bfc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 17:36:03.8143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mEaUDiifkULfvjXuBbZ/FPBqyn1QM36GSp/abueNHTgAapes+nYPfRD9qiYD/4ZuNLCFm6747iS79GQDLlPbfB72qU4BfhI0kO3R1m4i3sc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=617 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120188
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a53d089 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=U75qAp1fu8h16lXNoiEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE4OCBTYWx0ZWRfXw11P0ci6IzTu
 bhWHPqaDwqus/Dqy9s0gVtcEgrnNxQQqW1vzkVtGxjw4/z9/WQVjdDK64GIX21Nn3Py+nF51Ij/
 0UxVpnTAOpBMhgLkZADNcPpVz54SC3Z2lMifB4oEFxg+78ClDLrE+mxYPBjicaSEX/LiNX1Otrd
 Enkd18SqO25vQqLEzSapDg96y8orwW5DF2X+QJosP00sHTFnvnPLZ80mJ+jxUYsA+RIO9g2c8bL
 JQY7i4cf5EE11YtWy95q12hdo1QPk13AfYsu3ASgowYcf8I3A/IVo714fRJ7YWlNA4Z+WmmZovm
 FGV+HKrrajWA96F+6ftTC9azCSeXDdumpJXwyQCom7p7K/kpR3GJgZAeOG0yqBPaFQUtVExwF32
 QmoO3ciXyVb0iscuv5cCbQwvSnXJqFwrlf0+GwOFRrDUZx1GxyCnVy0NSQVeugJQupbgIxx8fcr
 Y2xpqXanbaCbxB/5leA==
X-Proofpoint-GUID: 6bjUtTDWYGfljZxo2aww-_m6zh-YDbwa
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE4OCBTYWx0ZWRfX4S2vZvnHHFB4
 WTkz2moRQWYiCTdnIGNTeTOt4FOlIFZibxaTgALt4JBxyhFrufE5t/ucrPqrdtxWcA5026HQl2/
 mC1dE2zy4g8/2ECSpT9HXujzBcQ8zmLazN8Dg+4V88MlMwKkqfmV
X-Proofpoint-ORIG-GUID: 6bjUtTDWYGfljZxo2aww-_m6zh-YDbwa


Yihang,

> Replace myself with Xingui Yang who is very familiar with the HiSilicon
> hisi_sas drivers.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
