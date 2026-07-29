Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A3E47D94B;
	Wed, 29 Jul 2026 10:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322433; cv=fail; b=mJmJDKnOffNIcwBoMGww5pND6tfDZeGCb5x6L0VbMNKYmHPD4BcjagEJtvx3ov0LTYwTvlIAI1nMt0MorkgK4YxJFJybKw1t4z1Mb10hrGXqwk1284d/gf4KfV+7eJ1NHcJ0X9WJX9VQadKZEK9j2aS4SC77/Vzyx7C7fV8Bk8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322433; c=relaxed/simple;
	bh=3ap8f850gEH6cIvVcK0yU7MgJpkeM8pTtCqvS4Hcf0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BygoPPkImTWAqQSnt++YaslDNnSgNs2Nz095AJsXdKIgKrf2JJbXs1AGdXSckZXcQcS+1MuLQxxLv5FBc11eAulzIUx45poRyl6sQHwQ3vTC5byaSgoKscux+1Dn1eREZkIdRCUrZovc0ZG0K3PElDOt0rbbzTcplJznhrR3V6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y5Nedfuy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xrwMDcKA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y5Nedfuy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xrwMDcKA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItcKF1279546;
	Wed, 29 Jul 2026 10:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oyOksBr5LgFr/FfPiDyFnA9u6GGKHuRIXcOVwxv7L78=; b=
	Y5NedfuyCzGnkMFOsyobLnVk9rx+wbO5/daoq/n0W7UkLRNHs4h02Z7r4dV8ib1p
	5z2lD0zGTIkbOvlqUxM16Z2TaNVC83dpLM5fnWXAIxToE6P3hvIMY0c89Po11Y6j
	wKVO+XHkLh8QoE8XhgAoIF1KlezSO2jaxhhIeSfH1fAwBc1oNOS35SadIa56qZAx
	pHj7LG1TVqPvEr8p7zYyRvbpoa9gY6TAwHfnoXqpPB16B0VAgSexY+Ztb0KOmkO1
	NNiJer5js07A8qWPS1UOt1wofRimnEM1EIMgiuisyP0roq/FCLDQn6W3lAdL+FM9
	T3Y0o3md8YnKE239PeOnBA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pnmxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo68x040089;
	Wed, 29 Jul 2026 10:52:09 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrke0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VE6shQadCsbdfGNm5qiLR58JsuMmhLF/5957izvzF4cQ400VdM/NKDkjJokK8zcfL0o+mVv0ZwoD0r3Hxd2LjC8TEuNIetncFDN4bPL/nBGc6lEr4HXFUKLmN9rwMAK5GruXuvqHE7u94VCmj1qhAD0ZUUP5pVyFaMLPaDH2yD9CncF2D9FayRVMTh0lD4Wz+QjT9wOjx2DAzc3kcai3+UNP0QomGLBAJiwvuIW9Ao41okLs5nWIxPoXbGuLn8WCjwzK9OUBMEHtEBNi/dVfjt5DyRWd2c5qDL1T+kS+VhYeJv/Rb5wWPQea6JhI+VcKDPfVj+gnaP/mu39HwyShww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oyOksBr5LgFr/FfPiDyFnA9u6GGKHuRIXcOVwxv7L78=;
 b=Ti16UrmQ3bS2Er7PCP5F5Z5jVSkjIftsme7NyIGjxmkOo6x7f30ev8vmm35Q411ms/8mSNAY7lUqbvBF/u3c9+C9PTtGg6UzrMfNcCjzf+oZiWyYYEqfWuHzE2WmucaxqzMogcfvGD2bVPMr3UR7xwDlYAaKK3V/rXHfiHKXiXmxGhQDEYtOhcxIP6rAYHCEB9K8zv6lpaOV7gh86TOKy3YSihoGRBTCASKDhxIKqGcqbMs2ngfHCrdlxxeZuMm40MD+jDYlzD5bRdYsfrYDnO90fDGs5Ix1034RuKMntcRlTf36xXSUxOqSl386bjtoIRbDJ6Qtpja1WEEfmOvFag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyOksBr5LgFr/FfPiDyFnA9u6GGKHuRIXcOVwxv7L78=;
 b=xrwMDcKA8CyU3OZfQ1BwFz59Ix505uXVZ+V3oMFUicq8sZH84T8T4q0TyMfaj9w9v5Njk6bD7JO7FCC+XRbj1RNjqaf7GZ8HQkotffieFOJj6oV9ovtzNsnNtK/q3eLeIMb5OYBfcDNc2G01lzHVpp9Qa5xiy4XtUCT8Xxv3Qss=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:06 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 16/27] scsi-multipath: clear path when device is blocked
Date: Wed, 29 Jul 2026 10:50:56 +0000
Message-ID: <20260729105107.255712-17-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0066.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:349::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c106bc1-fd85-42b8-b014-08deed5f6dd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Rpd7U0TnU4G9gCuRMcBS3BVL7xaVdOLQllJJ3jdpgGii9tsH5LtAKyPRQfBEPXCVTATzIQlweRAhgEEt6EbF6/kqAucf0q75R1iv1lynS4VYCXv2ICOaalpfnBfwI5ZxD4Zw2A+eDBURZWLAYPxedFVrBsUokVpU4acA/CSPk92G1FU2FjeMj1pBWLi66+XBEJYtw/ZAdcA4iktb9+c6IyXGDozZPFQQlCqzQestu/l/8fipQ3WugQ7lV4Y9Rl9Op5YhwAQPmn3OeCQ/KKqqCooy0QlWYlj9+xcz8OVz3V8bJRUpcO1h4hUVQNXA43LN9jgcuer+FC+FYeLJX+h9PbTI7f5d+iHyKNC9Th7sjnEJKdPd765E8srbQC+EnrRB6elUTayywZJxJ+gl3YvwWzq8OmN3nO4goc8v9T+J0Dv3QFqKqvLF+FM4Y796mYFHiqny0cIsG2zBBRp7AfK17iYP7q+rcObSpCx8dtn76xMuy/KmCmv/WfsESg3LS0AFYp+hrU9LUwr/3u75x6SDus18AGIsAhJi5l5AHzTFSGLhzG6C3iHQbRBjFKpGQtuao92RNZXOsBWQCXWsJ9JsUMq1aw9AdycW382BXQroQh52TSC5hXudyI/e6fCcUpvGG6Hr9wGM3oSX0M4vzVNJq0emUbqZE/6WD3nYnjAQixw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vrjsLs0OiPuiMdqZf9vCqL2rYr5emX200P/vZwbygbvQi8NerSQa2uPS++UC?=
 =?us-ascii?Q?BTH1ira3dVliAzwwPgsuJGeTucWqsXhEABEwFtnXYMW+ApZ9OFbRAqTbLYgl?=
 =?us-ascii?Q?WA4QHqVMqVSec/cEmPqGhNYAUFGEgpRrgJzZfBElwLLWDyv0bTb4y3wlTGY2?=
 =?us-ascii?Q?SPmrg1miRLufAkADfBJNwEK+dX7ux2G+4ECvM6LvIM2WIjtgtm9lYO6s9dcu?=
 =?us-ascii?Q?TMUUHRLYarGre2VtO6gKeNMKf2AEWFzWV8LHOaTp3W8/jNGaSpc+zGgulVfW?=
 =?us-ascii?Q?08Fm/Tc6lB55mY/e1VPdtKgOcQPwT6osUD37bCdKLuDYssWll5ssyT+xc2db?=
 =?us-ascii?Q?Tp7cKTdo0fNYDLfX3ym2KAohrUBFOmvXTk5duTAt9L8ln9XB95o1+Exe4Bqo?=
 =?us-ascii?Q?KHleGZt+tnDKzIub5dUuX2zIzdbH+nee1jlA0gFObe8rK6LWVKuy3XzyhBG6?=
 =?us-ascii?Q?+SLdg5+uHQDQUEvQFHAMsOaIfUGro56OTsnAVjgXJgCPUWIgG6xrEtekbZuQ?=
 =?us-ascii?Q?Y/tKVrEu7a792cgqvCcoPW66dow87/M8NXlO0mQ7HiMf/1cuH4qubARMLs0y?=
 =?us-ascii?Q?pn6StmEodrNOGhBDyoPRO6WWKyjaCqbV5r9IjIRCae6WWd9xVrZ+JlFHiyco?=
 =?us-ascii?Q?7ve5bjP612pctAeL6wyKDjKlId2iI+4cNGUg5kxoYwZPXoGiKJW6/y6rowv7?=
 =?us-ascii?Q?8c4SiSATiXzp2GBkWQ/8M599VpCx1ogRWlO/cQuqzPCJCXUmnYYn+pumV8TH?=
 =?us-ascii?Q?m+bx/oTgc8BL92+GfIFUNJuusa3B3tsYNgynOudp7M+i21j1okeDzAEbnY/a?=
 =?us-ascii?Q?gxCUqScvrYCWrB8plIXxGuc1SVZE4lTVi+BnGADEFoJM/KgoKJS4yinX2mH0?=
 =?us-ascii?Q?1NbHwmrCHox6Lpy2b0aG6z/2ZThIOQ/EtYJiGxVu3xWnbu9XfPUs7K4ZrNZ7?=
 =?us-ascii?Q?7bBLnuakD0VgYIuj3Tb/lu99Q4/ZUlqH6nBk5OEB5z0ieHDB9/JkUSXo5n0V?=
 =?us-ascii?Q?29Vt2DYzTQImyWZwAoXUhVXlDoEwrui1RoQzM4yyUhH8vCRoD8azYYkYpfL8?=
 =?us-ascii?Q?PFTIL2pk8FaXfAN7jQQqu/NgPdBTS5vfsN6V4kd+gjcTJDxTagLR7Hx2Fcqj?=
 =?us-ascii?Q?K1WY/yMok+KUw9dMEg33+KufAzAvW3jNlHzGxD63w9fT8vpBKgXkMaw4bMHo?=
 =?us-ascii?Q?lNxCs4XnpLHzXRAPs2eSPgl2Glzqvji5H1BCKvvQPl0E2yVugtcei2VoM6S7?=
 =?us-ascii?Q?7fIKAeEh6L0H9ZyqP10mZ7krNcHUwmkll7EQJbQ5JVATQLW4FrHmDYrQzWOm?=
 =?us-ascii?Q?8lPFv9KN73h0hIYU5XeZCWUGNN5//MHAp9j8hEa3o0yEZf1jrgBOLeR2QkJ1?=
 =?us-ascii?Q?uZUCowZEuY/zlcNqSTMsM3s8MylER1UX32Bnc0+69ueZTymhdvEm7wN8ElwX?=
 =?us-ascii?Q?NRHE4pQLQyDi7DJhRT+erGuoWx3P+lOwObCv4DuPImwSqvx+Px/nNPOFekwg?=
 =?us-ascii?Q?2A6l7sU/xyzzLJb+1p7am/bvijJKgjSClXJK74oALPYQVN8eOAYGy1jr5/6G?=
 =?us-ascii?Q?oI13ohYBDjJP7lLZUuSYEVcQ+dhJjiBxuU9ATnx5NQWscGVr6X9cvV3WZTlS?=
 =?us-ascii?Q?0Rg7MiqLiqcow4pT75EoZmoAlUsY7OlkjQeqwlWi6KczKpbZ/AqCDD+uJHnO?=
 =?us-ascii?Q?aqyzCtzNIEpqUwJVwy/NezByF94roDHxFlKzTA7keHoqKFdVZbiOqmKt6jV0?=
 =?us-ascii?Q?QyEuxjw/Ow=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	s3HsnLC7dczeKKrjDzVdEqvTKkqhj4fzio+BksZKuz0Ek78/wgQ0xWoA+d3tn4KxVZvwDLB+orESSKlZOClCqKtS/qgmf4yrcOarug0DflBOGWsNF4jLCFOMJeeN2ix8YlijRTPloCGi8/0zuRxjvr98nTXTT0Y4eAxyoyvAYXXEY379622juNZeMx/VnkW0qC1Q8Tn1ptkv7qDxBwHLDv60vPbPq8gZGGTKko5SoPYX5VIAKQkhtvxecEn8MvuichN1Br0QGJDn2YUqmq5opcXJOvu17BJvRLE6x1k+ZiACI1TxTxhM9cOowtmevz/gwsLqjo8pLEJ+E+cNz63E+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WGGfQkujMAZZ9LwG26RDTRSDQTE8pcrkS2/N/yqPBvtUZzb8xFuRyVnE/IeQNi959BnozesPJyRKITH5stOap5Cw4XbSKZpI5yHP4ajfQnPHg/of9VEEwm3csWeyrzlXNGwznLQSO2ojN2QVarIs+P0SdyWLn6a5K6evVbjF4ENMFM52l5EuFkl0YqKoCnigOR0i+H3uDoxyNHJWimZm8dwvAMHhvJ25egqg5fMAfzRxVu3zCt6L1OZpClaMtxJXgx8OqKRFsXII9XADT1tuTyN2Ty3lTToZxBCeIw4bseiZdMtOMbc2tQI+rm5MNLxhZ8wBYXL+tzevRgpCc1zQgAH6yC11BQITp5BYx3zfk45C+eFc2ySf5/D5C3KyK3uJl1H2lVMace5GTsjHo4/poNbJ05O8aU0O4JsYSa5dNensBOKGd0ePPWDRnGi0mSEtmNVCfYBSbP0WOV0r2Ra11h5Z6/AVKF9vVj58HCPGAy1nVA9jywK6YqHdpHUYt/1zzxKyW2AV69pWAjVzZMOLxLTDmvZAlOjgf0VbQUC8nZhnoNfQ6NddTvTl7Ye0LR7Ge1hMgxjaK1vyhvWGLye27W/n4P3zHgvxviSWc/uD5n4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c106bc1-fd85-42b8-b014-08deed5f6dd5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:05.9735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ry5Vf/rhuqrH7q+74ZjNFUOVxHfbWxLJr/bnThbEOuV/KfXIt+pFuQ0SO1tdS0bdxodc7pIbtPkPeFMgL1i11Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-GUID: stwMKqP8XLIjbwNbKcDE8YqotoeN1gto
X-Proofpoint-ORIG-GUID: stwMKqP8XLIjbwNbKcDE8YqotoeN1gto
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a69db5a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=Qos1PIJNDAoiXpueWHgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX0JbIU9JeR1eh
 lblSMAh8b7dwhI74V+fJnccEO2+BRG6cmwprEi2hD0p6AM9eLrrdHM6v7i06bICzThkJ8AS1cXb
 T00TPFK1zXJKk1m3Z4NlwG71CnXeo5I/SUBOMldL61FUlgpBDAaI3eykigHPo5QfMyNC2thrVmY
 GecyY4Ts4WqMiKc9m545dRkMrfRQIAvVwTnScnalEykaynF7Zx3UeuAxGdR8e6HoHc/UYzVLjHx
 tLdrDrcKE/bL165B0WlRM5TQHIZINluJdVGcmCr8PYBSuPqIgGD9mhT8j32JaAz/XM7NPESd77C
 rzyqBTWhszu+5isWiUyFwz8LymW40erx/ttnlPq043Vmb9lOSAOdiuBQX1oi5YMatbt47ipo/M3
 zgrERFZhHjG7XbPS+P5awMnVn1M5aGElc+tAsdKDP8kbsFnrkQcaSkBRCNerRoEW3cgSsIPtv7A
 o0/YFtKUry6gs0GkzQg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX168r2Qf2Nup7
 /EbcD2wN6wtgweg67MoRMb5sOhyvMuMoxKnLt1OCoFyYmBVSsfPvspXAvONbTccGpalUBVXsnve
 7+VGWz21KK6T4bRh493kl3seiRrfTmBRNSvu65vIXtWZbx09L/fv

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  3 +++
 drivers/scsi/scsi_multipath.c | 10 ++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 22e2e3223440d..e2452392671f5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_multipath.h>
 
 #include <trace/events/scsi.h>
 
@@ -3016,6 +3017,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 		scsi_stop_queue(sdev);
 
 	mutex_unlock(&sdev->state_mutex);
+	if ((err == 0) && sdev->scsi_mpath_dev)
+		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
 
 	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
 		  __func__, dev_name(&sdev->sdev_gendev), state);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 0d439cac6447a..b23cd6f12c602 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -238,6 +238,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       if (mpath_clear_current_path(mpath_device))
+               mpath_synchronize(mpath_head);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 5cc37acaa664f..8f58c44d96a77 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -54,6 +54,7 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -88,6 +89,10 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 }
+static inline
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.7

