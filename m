Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF2D3D903C;
	Wed, 25 Feb 2026 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033610; cv=fail; b=KZMUkuNzbnCS7q6J5MCKjDSJ5rtI5xCAxl5pBBvT4OeByEsXnePzaX7QCBVPCZMbFy60J3RY6qEepqaWSwwPyqLZRACMpZGn/NZ5s2hleJPuuuyEQXsMF9y7FtAv9An56N3EOXPne7H4WEim9EIur0bk2IQ+Da1m6WG38umtCQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033610; c=relaxed/simple;
	bh=P1LNPMTLI5YHL/TELBQi6OqJ4Zu728rwVz0MI23M5Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GV0pHo6DXG1pIZ2poxtT1MEyOhuK8OS5gcXAfKoyM21FdZ1hjb9uH9j5PtjX+YbvPLuWE/e+qx378C8YcmU/Fst/5DoOP5hWgO7CAfPzBJy1sfEg5uko0TmavKiTDnl6ko+mvNHY2mbUZ4qYgpsiCL+Tzt6Pf1JQDNhjDx/ux6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IfnCQ95k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VhNx/plE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IfnCQ95k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VhNx/plE"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9TrFQ1959902;
	Wed, 25 Feb 2026 15:33:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9sewjq4L2LhqiUC6WTr1BfLxGKsbfF+YofsELud+NA4=; b=
	IfnCQ95kBmtm7BW5+BBI+l9dvnHycED2Gj1Foht+FJWX4yixPdCHZvnQHt+UNrCG
	ucMuUzxbDDR2smhi7SWA7VsTSvgGS5CpXd7ENUexKvNROP/Y+qzcxTcd/mRl/0xN
	vjPcCRhheOLiEm5T7yLC8NcszwubRki+oAg6OCVu7aNt1fEF3yoNAwuJkrjY2l3z
	fN3fiG8JZdjk5Wlq4zZY+g4AcN3YkP8YLFDfHIYeNUA5s4db0gRNBRPEZt6OLy4Q
	zBpyoEdDCa1qcR8l2HbyKqRGTIX5939BcgrlVbwV8xv1Aof7OA/nldLngXOd32O7
	fZzawweq8YB5x43RCWUdBg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbeg9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PET33X038418;
	Wed, 25 Feb 2026 15:33:07 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35nfkr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zfgf+gsVtyhd6js8E0oeJTSpQaClWolToxkIidfKOYpsRSQ4so1GzeKgZkuHy+fPfUElpXGYZbKq8ZUe2umYUopWiwdiGvzz3CQ8SuO8lvbxJRuyILHgzQ7rIXrbQplQhdXkDpeMmSVC/Msfa1kcH0gg221ec2ae6d+y/G4JdynzMkzeZjmOs4uCx24csVraOHx5ez9Og5QHOEGtLx+KGemUhGrLGUx0NgAgCLzexZ9/gX4TnkoOJd1EvUNqlsGr//eUhtaVRR1WyJYKvTM41cXwpirtS+zhJz5tVy5oW8U99wp5W5i64tVlS6Vnsn/jTVJEdhOYAewy9gp5tdaL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sewjq4L2LhqiUC6WTr1BfLxGKsbfF+YofsELud+NA4=;
 b=l4nv4LFANFdSRht2letbIwgTa5iRyBef8d9ChsgpwyugcnLIlnUJeWqgRbbvNaX8B+r6nnLwRAMiFf5CuF0SmGgL6eHfXA3mpM7hqT9EdHaofsa/Q6I8NNOXL4CVjR9cT9nGKbsrvp5BgLWuhU9UDhKn+Ld7YF6ZrfoM4+LarleAK2vxEa/DbhwnzfCTV8cKORMFE+kr6IKerOuSVTo+8yFMWCX6DYzsDiFk/5LRWsPtxhW47H8hv5RyGe+cBRkitIhjCZUn39XVF83QaLR/GDYbixhQUYLRoTyxAuBxrp+F4H4xoeOI7/ub1JhQN5qfgXBoSQTp17UVLY89NaWKDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sewjq4L2LhqiUC6WTr1BfLxGKsbfF+YofsELud+NA4=;
 b=VhNx/plEAvj79QUcPYj2Ot+RriNMNflMhszE56Hs4nFVL/x7CGGoK1s9qAAYjQVR96ZvBgzQusv2IIclEa4ktUtfCFYxJr1ef+cArQ6RfDdG1CeocYPKmLMKHRiBzvcAVPZtyYaQ1ZiBohCsYaGGbZ19S6W5yypjfmBiol6ysI0=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5017.namprd10.prod.outlook.com
 (2603:10b6:610:c3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:33:02 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:33:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 06/13] libmultipath: Add cdev support
Date: Wed, 25 Feb 2026 15:32:18 +0000
Message-ID: <20260225153225.1031169-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:610:11a::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f69c06d-8ee7-4f50-6a2e-08de74832964
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	Sq4BndAHv5crBGAXPmym1aqCCnQ3r5OpiREu0qA5XPVVefryHKokSMDLspPHwSSsgvJGibaZavrl+B5mvLzrjS2+V+lZfth4fyF7P+OP1SkxWrPVb9s52D6VvxSIicm6wbEuMI7u4GH5t7RXoRWhEw4S3RdzUfPvF/FFN0CjmxlEEW3PQFN1S/h0OnTazdK4xdJcw6e+5iZgHojAsLclUaT4QDD11RAPKetlu55iyY/CwdQN/KhKXkpOazLDVcjP3QIBHmexcaqmoC5Nyz+02HhLVY8MpTX4hGbD820SHy9UFYQgH6lkWtg5D5yuVM4oyuOMZxW0RW2rsxeGjq1mmQw2xdFFvnzBhNsjyP6KVlenRGi4weF0yTp+BdU0rJ1ddeiS2maksi1pVtFZ6+zqJQwUdPuV4eC7PWk0lvV8lLCMk5Cg8cx77Kd62HsVeXS0yDSOvDAko5M5ooXpMwpGkhybDx96tJtGE20hDFHF52VwaUxhfZngL5B6nrKjXAEzs86Epr3sLIMGNq8CpH4W5qCDya+xoPnGRUGF3CPzvxKGhkKaj9vTZxCs0xm+cpM3MmQLCFrB6aNyfSmd2nYvGDDvMODv3/X4YnZrUq/V3bPfOgPaI13HfRpJmuGzDxdd9I5Emcv/x1D97DjtdnA/TKLAshw7okf3s5+FBE7ErTPE+vvmCdRQ96K5c/8lb/YXT2LFs19dKrk8kxjCb7S5xOxqHQmB5b11K1lbjxtuSzA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eKJFADR/q1GklJlDHNf6cUhEtkOKsbSinA8EKqGyPWXd4dpKo6w/C1dphx0g?=
 =?us-ascii?Q?BEKufbnkzgEpHRuYsPVHe1WB3Bx7NiftwxgtePJC5bJln1A36ltLHlyLh/3e?=
 =?us-ascii?Q?mmiqs3aNQ4sy26DR1dvrPZwaG1Z6N29D2+Srwi3JnKf0CVCy4UcKJqoCDkpO?=
 =?us-ascii?Q?WFJCw1L4YZgvr5pH+uJVlUlLPF2vbjMFmALnARsg2FmPi7r6FrrDa1ATcsEV?=
 =?us-ascii?Q?slnW59S6LH6N6kV8uITTSt5X36IEEPNn1yAbJy/Iopc/ozd8rGLYTng4G/F2?=
 =?us-ascii?Q?V1S8EvmpA08dlJcYqDc6OniULSiXfVMvZa74AQzYZ2/bpvOEMYZWN/RZoOVp?=
 =?us-ascii?Q?DLm1JXMV4LvboNI+r0Has0E/VkGI4hIIKRmtEut2CqVP0kso/C84D9oiDfqh?=
 =?us-ascii?Q?/NbOGZaM5gVjjDMSaNP5CWAvyLIUmeDmUbqGrkYEGZW9+4lK3UPehG3Tiau/?=
 =?us-ascii?Q?pnn1/MXwJtbnXgNihvkmO0MHKije3jUigTHcGnobp3FkSzIYSqf5iboQp6jD?=
 =?us-ascii?Q?ACTTCmoU6LIYTQqcOSx1tVO/IhOehKzlk41nFQO4LcQcRRuI0VSsch5wMwNf?=
 =?us-ascii?Q?ZsqawlurYAxyttsfy8DfeJy2A2ufgVTMGn+UpW5MKfM/hFMfrigoLWxqlzOg?=
 =?us-ascii?Q?m4nUBxX6fnOqZ3dvf1LmyAB0J75AB+HJTOTP4pTP08cFvApWq8A5tVob96sY?=
 =?us-ascii?Q?Hh54b1rJ8IJOlVM+zoQl16NdVxc4JU2/eZaZtCMUYfHEu8Bgu3xs6zUBALwT?=
 =?us-ascii?Q?X3qsdl2Y1nhlBfpY6gUR7PQOaMq7NnJtDTMGleBf2xy1rg7DYmNdkFRvU1R8?=
 =?us-ascii?Q?7qi/CmM8iSIKRkovPMxIdLLblzQCDHfVe74YAk51/gTvyFOAkKKKR+XkPf72?=
 =?us-ascii?Q?59nPK2nWpp2WQwyOudPcBPfYIdONT6HGNG/kYHwLyK80Ys36R5StAKR/a4ji?=
 =?us-ascii?Q?VE0Wvy6vj8b2IE++irRxKlpSqsAyiH97QZaGuv6utgYFS9m2hRlbhnTmrsHP?=
 =?us-ascii?Q?/zrq2RAmHQ6GC4mQtmekaH0tcxuheakcmvD+r7LhjugrvfE3QMFtn0VpE2R2?=
 =?us-ascii?Q?FRkEm7SlpVvcewQnYNF/cBhar6qW1vdjQUsIwvgJMGyqLD/CsVOLpTBjAAiF?=
 =?us-ascii?Q?X/cov2WoHDreTu28j9aFTXcMlUrukPu9Typahabmn3OL2PjxCzNkjqESmZj0?=
 =?us-ascii?Q?UdFlkf5zfsdofHaoFRbgQuqSpNDHYt/MNi4U/R5aVkapm9qXNZ2M+zUMx1va?=
 =?us-ascii?Q?PZhVxreUYqmVZW7ECg7UZGL4ArkiWMFxUU03mFTx/Ebdn1SD29OchZJ6miCO?=
 =?us-ascii?Q?3iHTzuOiwA6agjusJQ4E5ZqFWcgMz4qxu6kdFpAiVkwWzWubMuyivEeUg9m1?=
 =?us-ascii?Q?a/grUMlQn1xbNnw73vJpvIB9t0Z8Eywccl7N7yT9oEpThahr+2XO7mzmLdv9?=
 =?us-ascii?Q?2HwzLJb34ryTR0+pivGkboL2KJBgEb1s0LkYl28vpgoMtwI0gOGuqzxjbrhL?=
 =?us-ascii?Q?L2NUfpkVk+QxNauYts2Vlrsvi1AkS8v/yqdp2e5HZ5weuw/tvd3/JLvaYv8P?=
 =?us-ascii?Q?Xh/ml2+g55mnOiIAA4NQ7/YdsPetABdk8pTb5lGEKW/SC5n5BPDS9I3efmOI?=
 =?us-ascii?Q?YdyKK3N/ycSMJw1yfKkI1CrTXl34ASgV2Z6gKy3ow0HEBNvUVfKibnpsib4c?=
 =?us-ascii?Q?ZCOPaSEhGanhmeazlZvBTEmY1AyCop5EHSlN2AWJ8drx1W+sCVqv42gNbNUG?=
 =?us-ascii?Q?VF5iZOFiP4VHSmfTCLHOQH1UKrWSEAM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fi+i2JFBH6MXnxbasElR3pyxHgLGWKtky6hgykZwYCV/zeQVnG8W8VHqOQjft68nURzeI3tZpqEVJLuFxLOGjXguviORorCRuCguuc99ve52pNPW3GsxXQfr6gaSK+NPEYCG/iIz89+mUJFaJki0aDiYyOB42dMxad0dJnS4fTS0JEfjk9BJNyRkTT67Xei23BT7flB3IpRYEJ5vJcJS4y9EgBVOMy/Lf8nU1DAlmeJkybbiDHrFAOwS2GWHkc5j4V4R8ffgyBC64acG+lp4irA7swLjg8QMUXCp5kYaa93+e2oQJvFGQ508shPkjOw1zcm6W03y+n3zBgUel4pPKxVdQ602oobE5OL9SkBFgISeY7XaG+wl8GDoZOuwuSl9JSs1WaVDO1QMoDmEy9+6Jwi1A44YJHWmyCml1GxjnnkZvGPPXXplko97FvjV3DhAUPbYnAI3ZuMb6IQ6YfcKnXuHwAbSF976k3Bb1d5qJTJneoxj+OXqKdA09mvcebWcptN08AVu48cpaI8dasfVYAZoAqzeQLNd98Im8u8C+wLOrsGZbiR1Zgin/prTYcQm/2m/Rl6UUQnIwUxJE3xaFKtYYwykOI5jGuiWznGE5CY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f69c06d-8ee7-4f50-6a2e-08de74832964
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:33:01.8938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Ck0DZ04ezZ1/3k/753kUZbC+mUYaYCyJFK4sGjGX2mioR1PYqkpJLPfApoAR/PGZ1joiAMBwWLx34+T2Z7aig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX7xjbWfzS3vpz
 zCxwmQ+XkqGm8Ve5jO0hsqfZZvL83pvAApGrg5u7CMX6wowQoWcXeETGj9Q3WSLOsj/9H50Gj4W
 P86a5LF6W5khSw8rr/71wlZbhyVrp4Q3a/xbDF0c9dZQ/UbLTodozx4t59e+H/N+qRA0Gf7cCMX
 43kY7W0UUb5N81+t9dUnheCvuHtX9k8zq1km3xfzMFX8lyFziEqz0Er2Rjtcp9m7tR7E0r40Q1Y
 XvY7M2/cPvt2UaaClxWy5QG+/jSFoddpNd3+A4vKz6sdQszoYglPkBt8Cp9Z7wCGQnL7/sCe3Kc
 gdhXlLWGGMmaoa9O5kTJykMAHvmMTLUva6iPMlNVS9vkS5ossVcU1vFoJzWXoFtEGlflu67dVjk
 dErkmxWoP+AYq+zBRCZvmk34CD8BRDDm1qvjjSbbGwmtSxsmTeyiEKjTcgsrSHX+EoJ8awQy9E2
 X1RUcg2eai41MvS+iPo98K80zD2P6uETsJvZ/3ss=
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699f1634 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=loVZsHcDvd6Py45AcLcA:9 cc=ntf
 awl=host:12261
X-Proofpoint-ORIG-GUID: WwCS44Fd_0EbOUUSSv2j6GxeQoNZ9dA6
X-Proofpoint-GUID: WwCS44Fd_0EbOUUSSv2j6GxeQoNZ9dA6

Add support to create a cdev multipath device. The functionality is much
the same as NVMe, where the cdev is created when a mpath device is set
live.

The driver must provide a mpath_head_template.cdev_ioctl callback to
actually handle the ioctl.

Structure mpath_generic_chr_fops would be used for setting the cdev fops in
the mpath_head_template.add_cdev callback.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  15 +++++
 lib/multipath.c           | 116 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 4255b73de56b2..0dcfdd205237c 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -4,8 +4,11 @@
 
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/cdev.h>
 #include <linux/srcu.h>
+#include <linux/io_uring/cmd.h>
 
+extern const struct file_operations mpath_generic_chr_fops;
 extern const struct block_device_operations mpath_ops;
 
 enum mpath_iopolicy_e {
@@ -45,9 +48,18 @@ struct mpath_device {
 
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *, bool *);
+	int (*add_cdev)(struct mpath_head *);
+	void (*del_cdev)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	enum mpath_access_state (*get_access_state)(struct mpath_device *);
+	int (*cdev_ioctl)(struct mpath_head *, struct mpath_device *,
+			blk_mode_t mode, unsigned int cmd, unsigned long arg, int srcu_idx);
+	int (*chr_uring_cmd)(struct mpath_device *, struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags);
+	int (*chr_uring_cmd_iopoll)(struct io_uring_cmd *ioucmd,
+				 struct io_comp_batch *iob,
+				 unsigned int poll_flags);
 	enum mpath_iopolicy_e (*get_iopolicy)(struct mpath_head *);
 	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
@@ -66,6 +78,9 @@ struct mpath_head {
 	spinlock_t		requeue_lock;
 	struct work_struct	requeue_work; /* work struct for requeue */
 
+	struct cdev		cdev;
+	struct device		cdev_device;
+
 	unsigned long		flags;
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 	const struct mpath_head_template	*mpdt;
diff --git a/lib/multipath.c b/lib/multipath.c
index 7f3b0cccf053b..ce12d42918fdd 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -469,6 +469,113 @@ const struct block_device_operations mpath_ops = {
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
+static int mpath_generic_chr_open(struct inode *inode, struct file *file)
+{
+	struct cdev *cdev = file_inode(file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+
+	return mpath_get_head(mpath_head);
+}
+
+static int mpath_generic_chr_release(struct inode *inode, struct file *file)
+{
+	struct cdev *cdev = file_inode(file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+
+	mpath_put_head(mpath_head);
+	return 0;
+}
+
+static long mpath_generic_chr_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	struct cdev *cdev = file_inode(file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+	struct mpath_device *mpath_device;
+	fmode_t mode = file->f_mode;
+	int srcu_idx, err = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device)
+		goto out_unlock;
+
+	/*
+	 * If we are in the middle of error recovery, don't let anyone
+	 * else try and use this device.  Also, if error recovery fails, it
+	 * may try and take the device offline, in which case all further
+	 * access to the device is prohibited.
+	 */
+	err = mpath_head->mpdt->cdev_ioctl(mpath_head, mpath_device,
+			mode, cmd, arg, srcu_idx);
+	lockdep_assert_not_held(&mpath_head->srcu);
+	return err;// ioctl must unlock
+
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
+static int mpath_generic_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	if (!mpath_head->mpdt->chr_uring_cmd)
+		return -EOPNOTSUPP;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (!mpath_device)
+		goto out_unlock;
+
+	ret = mpath_head->mpdt->chr_uring_cmd(mpath_device, ioucmd,
+			issue_flags);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return ret;
+}
+
+static int mpath_generic_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+				 struct io_comp_batch *iob,
+				 unsigned int poll_flags)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+
+	if (!mpath_head->mpdt->chr_uring_cmd_iopoll)
+		return -EOPNOTSUPP;
+
+	return mpath_head->mpdt->chr_uring_cmd_iopoll(ioucmd, iob, poll_flags);
+}
+
+const struct file_operations mpath_generic_chr_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mpath_generic_chr_open,
+	.release	= mpath_generic_chr_release,
+	.unlocked_ioctl	= mpath_generic_chr_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+	.uring_cmd	= mpath_generic_chr_uring_cmd,
+	.uring_cmd_iopoll = mpath_generic_chr_uring_cmd_iopoll,
+};
+EXPORT_SYMBOL_GPL(mpath_generic_chr_fops);
+
+static int mpath_head_add_cdev(struct mpath_head *mpath_head)
+{
+	if (mpath_head->mpdt->add_cdev)
+		return mpath_head->mpdt->add_cdev(mpath_head);
+	return 0;
+}
+
 static void multipath_partition_scan_work(struct work_struct *work)
 {
 	struct mpath_disk *mpath_disk =
@@ -501,6 +608,12 @@ void mpath_requeue_work(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(mpath_requeue_work);
 
+static void mpath_head_del_cdev(struct mpath_head *mpath_head)
+{
+	if (mpath_head->mpdt->del_cdev)
+		mpath_head->mpdt->del_cdev(mpath_head);
+}
+
 void mpath_remove_disk(struct mpath_disk *mpath_disk)
 {
 	struct mpath_head *mpath_head = mpath_disk->mpath_head;
@@ -514,6 +627,7 @@ void mpath_remove_disk(struct mpath_disk *mpath_disk)
 		 */
 		kblockd_schedule_work(&mpath_head->requeue_work);
 
+		mpath_head_del_cdev(mpath_head);
 		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
@@ -572,6 +686,8 @@ void mpath_device_set_live(struct mpath_disk *mpath_disk,
 			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
 			return;
 		}
+
+		mpath_head_add_cdev(mpath_head);
 		queue_work(mpath_wq, &mpath_disk->partition_scan_work);
 	}
 
-- 
2.43.5

