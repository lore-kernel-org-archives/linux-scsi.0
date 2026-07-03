Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7DD3CAA3A;
	Fri,  3 Jul 2026 10:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074897; cv=fail; b=UMHUNE/nS8rucXgxMS8IibVPITNeO6ZNI5Hc2VvhQwjvGCrUuHwxpOcFLbQ3LRSDPgRmpJPBBBc5MV8V/phjqFJnBbgIrE/FlHgNuqayTrUXxEgb5b3Lhb7a1dtmoRZu0jubVHt7laR0zW/jdXNfYtWiIJRV4R/UX3CirV3yE7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074897; c=relaxed/simple;
	bh=CCow41KcN4PP6Ec7PMcrq9U3z+/jMVHTIzbKjS74NBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e+E9jTTpj0mLsC7nye48zAT/IL1/wAZTc2ElghWKsp103N3MQ798amJhOf1HfC/2yFKdUuc72fyqd4vZLVefuQ1AwSxeSQ//F3CyZZ+btAGHzo2evUmBmy1ssoe464+8DqrJ9M1rM1oIR+vZoBmiulk6uFTxWwb7TQPE5vhDJ+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B5wvWqC7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WdHlA4nJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B5wvWqC7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WdHlA4nJ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638u1Eq3081121;
	Fri, 3 Jul 2026 10:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=w+eg6PzIV46zHco3caHGCrCR4I682knhyIThCLMlz2I=; b=
	B5wvWqC7nXObgEcteGKZWRdAnoH6HMy0d4/4A9uO/kmvY10hP7XROURaR4WujIEH
	0WKAi96LEiT/rRGOlN9RgUVE91nI/ZoyqjEiGLI8zzApTngsNxxd5HUEP8XtlBb5
	8rLNTyqL6cNtHE1X2432ByKtXsbQ16R8ELpJ/Jm28y8eFfd4dkdqgOR04efDzfDw
	RTxD+t7xmQj3X+4HA26AF+FWZ+0akV5NNt/WlYcSikCftQWYIgtHCyW1IU0GB/jl
	RqI4nMULDGbK0WfEQX+g9IGwJ5YM3+F4jH8hsf/B6oY3XeeAbHywiSVXck/lNJ+Z
	4t5ZeEtHwD9xOyoF2fWbCg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqahwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXTcr019323;
	Fri, 3 Jul 2026 10:34:39 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yu87h6-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xA/4yzBGMTSvpOxTh0KlNvOa1olFcl+gg2K+XL+XMRDAuhQsDxB4609KZycrenQIFeKI3hQJ9WecRPp2OmItiJFEF4JhNRb+yvF9ymeAR71STtb13zf7THBvFtPKCz41uz6n8YN6Ge1rY32NOG/d9Ery9oV6VmehmXZyvH7JNhM4A/U4DO76X0MHdW9wUSrKD8/tH2tFyH2YZP+FXPw0nxOiD8ifeeAaxVn4DV0vwD1NYRDEFiWxT9sDHKyXsDz1guQ1d4bjl63p8Szv+f6f4lgdRQ8ynclk6DRWnyKKDuWeh34Se+fPPZ9iyuDK1dvVbucTRHaE+P8EgcI3EP7JrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+eg6PzIV46zHco3caHGCrCR4I682knhyIThCLMlz2I=;
 b=k1Vqh5hDwFsMaP+OKGUOasEBK2W+7bjWRtfqU0+mRYalRBTyBqAjn1nwgtNhf0WlROcojUENurdE8Os5TFRmxx733bqRqedgQxBqNCZ4q0CmwgcD3374zNRDSIKM5/FHh0HVy8jIkoujqtM+ya7PeJ+yg/nWR1ZIuaDvc/1C5fXI68+4US9dfjYWqLAjdHd+VVvTgHoRKevkcKOaHSK0OIIAakul+14xCDLSScEAXnwBSuXly/nmn07crpB/hBllA3IroMmJ+kqxcDAaA91O/DsQ1PWM0iIAvFet4A2kR0uz7VCXZt0kwKFqiHVL0JmzY9s/ohqhjlf9Dtc94rqIJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+eg6PzIV46zHco3caHGCrCR4I682knhyIThCLMlz2I=;
 b=WdHlA4nJ0txTx88qr6tlC907DcA4F2xECWY6BDjgFG56yeYBtbZVH3bGre21dLP/XujSkuzsrNaWf8+8pXa4i3ZxWCEJq1+jgxYJCWg6H6/yMzCG/xcChCth9TF+EwANSu1jsL8+fK38aDN++PURT0BRIDy3iM11IUXxw6GrvaU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:34 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 04/17] scsi-multipath: support iopolicy
Date: Fri,  3 Jul 2026 10:33:49 +0000
Message-ID: <20260703103402.3725011-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF0001330B.namprd07.prod.outlook.com
 (2603:10b6:518:1::1a) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: e17b6dea-4808-462b-8181-08ded8eeac74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	PIfHmqQczahMS0BM/emB5hk0v2xwLfyi2kedBcW9e6sbL4rMpV4FyfqvUiaupeewp2WT/NPGsNAZWnn/D04VWEPIQxPFEeKnZXWKh7GdqVyvSNJu+dZnYuyDmXUDvTTr2wknsiTtNKUcPYDhV1KJRX1vLEDJ/2SMIcvATZ+tGh3UedHs5oQJgQhbA7qT/j5/dwGlw7rYry5vkn2HCwsp8j7cm5uxQkPLGLBh7MCBN4DXJmaXt/Uz3j22JMxgoC+gxjj7UAatHtQ8TVFMtynqVqVc3OEQOW6nC9vbFsDk6TPvjM5ZZW4ZxpYyV/epVe8EFDBgU1TyaVsf9wCtprZLs6fHuzEA3I8l5pru8jmcNeT6jD5Scy/j6N7i/nwmkjxm6nKUOTvK+ImQXal+uLcm/KN0/Jzd1MqCj3zZENVG68pb/0o/+AI3HYoAzsXx/pbqPm9OpCTFYWbUtUwi0bLPkq3kCPju9RcD0SwlgckZ5MrTCEJ+m4bFpDg05nd4unZENmWEuqGDML5a8sKba1DugidDuFP3/bEG4vcqKZccWrg1k34Bn26BVjbK8AIxetGLiw4Mh+CA5ylZwF4tXO0O4DnV5+B2cGBMQWvT9l2B91IYB/BR+MY3/Ffln1+ubhK5+jo/Ak3bTserkCTKFxM7IqagSqYFROmUH9bgLJuhEJk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v61V6rXBg542G4FvbPL27dVcA7UIRZc8D+ib3Tey2n6AxnONQaw3CYy9WWNg?=
 =?us-ascii?Q?XrbANtWahigQpxdweeo6ADDRvEWwnVjpgE6H/0NHLIKrOKXgtsyqGrBlYkIi?=
 =?us-ascii?Q?DufJLorgcOqTm/C7E1YUYX/GMGXl7KzNIdlCH281qg67b9ZZVI9j04dzjrVj?=
 =?us-ascii?Q?PLxuR9xiCYcvvZ/qHOD/I7wISAX2ho3QG6ptOvC1Z6f0xAEwIY/jlCnJNr3Z?=
 =?us-ascii?Q?zQjfoGsDkOer0ZzxywmiKOrZMaXDb6wTG6aS7ShXDC1TLVNbMGX25IJPKKRD?=
 =?us-ascii?Q?9wQxz2FOlqLo++EvItGB+JagmolPAa4WRMfHv2leG441Bp9kPEbNYKyRDdN7?=
 =?us-ascii?Q?9wfQGKFb45ZJL3jvJCDv79BKXir/RzYOR/ofDCi7RK1ujr3dl6X5WbUiEo4A?=
 =?us-ascii?Q?XG+Zm1e66vPzqciEIX7q1FAcG+7hxjaz8VRyNjrclHI2an9GEuCFlDeXnWUr?=
 =?us-ascii?Q?n9tSurXJbDhIfTD0SYaXfrdCWBvdLPky60nXVBDPK+fS5DgRMocntC1LCWIw?=
 =?us-ascii?Q?gxtTBMeXgEqoD9ASsbuUgXM9ljpLkANhviskkuyc765hVDeFCQVi1BdUyfZC?=
 =?us-ascii?Q?gptWyDA1G1NWnpQwLAM39IE44eO4FXkHKoKWOpPOrfHznKxKHUImB7PxDeTw?=
 =?us-ascii?Q?dRvsIlOQ4i6f4My9NlmvLHl/SIQws4MKBoMHa4iYzlj6w8I6IBq6SSkM/ouJ?=
 =?us-ascii?Q?U0v5ia5nk0rMNmhJJcZ7Id3ln6pW6Eif8ra7MwXnVMBzkL4pS8hdN/AZvbAv?=
 =?us-ascii?Q?f7a5TEmpi8QkwV4g64KjWK2v0O4xLHXPGjxG+w/T20fC02qaWBnfV2C+bxQe?=
 =?us-ascii?Q?CfTy9D098lGhsIDC+m3L0sZswBPFgx50eDtv/VvGndeZqZli7n0MnUZTVtx0?=
 =?us-ascii?Q?YQQd9AcQ/Pyqy6PR1hMdBiOH2IRGomG1lqI8lf92hqW2738sEnmPxXFP98Ol?=
 =?us-ascii?Q?U6nYwkB8xHDsBsDWBn6AW5keo3QEtadod4LBT+wk8gaICNsh2fLY6N9mK8dp?=
 =?us-ascii?Q?6XUNlxlDT6cri0wMy7vdiT97VyJnfUgq8ewXThay0xrRY5sCFb3STTcUheCt?=
 =?us-ascii?Q?y0394G0LgeQUUxWCvzIpEsaXryw1TJzTVJH8o9mTLEH46X0nve8qjQ0DxO6U?=
 =?us-ascii?Q?qVYB1jsqu+kMNLS+8lfUQcRqqxPU7C0P0PRuPoE4SILNM1ezoLbT27QFMMzf?=
 =?us-ascii?Q?ughHolON/fzveDO+B04SJYbhfTuJ55dWt+Je/5WNdAWysF/QqznWe8aphHwj?=
 =?us-ascii?Q?+A4lphG5isjG/ZLjM2u+KfPmVxyBWaWJnyAbeyCuxPUlMJrbu8fB+Ylbnjng?=
 =?us-ascii?Q?O6+wskdHdIFURWFVJGblVmSAPL15GTJ9wVI9xnFUOYexxynNU9uDK1/IoC/c?=
 =?us-ascii?Q?TdAOmv/jF/5xNMPatIE9X0i8aYQdCNCChfEHK2dnOJyHkb4CrVlbuTaSvpvN?=
 =?us-ascii?Q?kSoBjCqQRn3M4+AXcoyXaIWT2mxK00AWoJd5iU2cjK7zyKAOFbU7vjjLD+Po?=
 =?us-ascii?Q?dptxUeq2+53V3d9T406heKLpT7NzpfOkhlTaXbGQIYaF+tYTFEPspbTPaZuH?=
 =?us-ascii?Q?ci2hZMzNld7ajfJe7zxYCp3aVUtJyfYri+l2M7vaFuBzDabaLvWC+v1JoO+c?=
 =?us-ascii?Q?EO8adFrnH8eeFMu7D0UivUOymlDkXmXJ0kSqR8UWATob2QJ6q7ChL/a8nLu8?=
 =?us-ascii?Q?dIq8wzluGht5kjXyfuVdc205otu5zQhcbap0pHywDlr6WOxQi955qMtnvAuw?=
 =?us-ascii?Q?493E5nfQznze5Arh3Z8+FYURu2KQDw0=3D?=
X-Exchange-RoutingPolicyChecked:
	qg0iTqsF59GYBZUnp4Sh5Zcg7owIBxLz7JIvaTZs5hHcCtMZRcmRX+UD/vWluepWH1TIs87yHwmbFy7hsq7Ce0IQeSiFWrJDFqqH9hMjTQsozUHB760bh7RpkK+SjBrMIwdY2xWox/BEnnMtYHKl1K63vhx7xvOpb3AXCmGR+iV3fZFK5zw++XNW1BcNo8maKXhuC9NXqTq94okpNo9KwDX/mC6RFTMOeAF8AC/98LnqLd4jCicA0uPOUHNXwP3gFCsJpnANiOTTBWuyJ1/WEXKCmI3soiJ+Sp+EvPFa7dJezrPfkkegQpVFCSm3FMKxTK9i2BPoSBh82jXzZEzZ5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i+hGzM99AMAUwUmixxQIG/gU7ImfoNc4UeM8kIyBKzgEO47VrvI/S95uNYxmiKODEDpFYToRHAE0qsXsWLZeysBTNvjVy4++gGWWPf94DWNCcQ2MtoT5vrDrITIeWCHPyGik3OY1MLPRjbWWYN4oJGUOj6EVbOYZb36fMNJshN21HEy4P0QIG7ty87ezgpsspNZkHJWVwgpDTAXwmVBOyEuWcF9tIc5JA6snFxYC+OJMvoSH565Nj7pX66nsA8kGXjk9P9EAn39V//fyv07t7NrU//cOvGjqZp/mx/L/1mEs84pK8nHRCLtDW75XUZWEB+LsmhZHI2n7PI18PSw8fELJcSBGeQChagAfzonZLigKPxivwBBeu2Pao0tr3WuiufFPUtIHKODhNRUyJ7LyLiP6Xs2V4VPBUys5H3tg4BX3StwvVhBj9bx/U1s4HeLRQTEzG4rekRcNuUoJusafiNjewJS81wLyfCOjeBhTJ+1v7C/Ipy/ITx1NZ1Fx5d5n2JkGnjuDclFytAfiOXaY6Hl66L1U6JPPoRpRMR5RjeuIS0eX6Uh0ycGtNJnRQ74/q+pFgRyNgayD/C8pDVaWjEnAWI+3QRUqNnhtsqebWdo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e17b6dea-4808-462b-8181-08ded8eeac74
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:34.2960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iH+VU+3UpxIfuLj7+VlNlCRzuINREjfEoUhnFJGd5L7cMytO2Vs++LNeqjBfRtM+yLuZjNVwYv2h6/DPiwAsiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-ORIG-GUID: aYE-7vUsdB9WQxzpoOsxa4179_rDy5l0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX1mCsLlOr98E+
 cU9cFadHfBBG0P4rkJwGPFoG7Q7Pa8l3MP2QSWY9RmMGJk+nLwFP1jLc//E24rpPGBM3czuMcKT
 rpxwTPs+TElun+nbRB8TYapAo5tJVLvtfYfxKKbe7vh2VX5m9yDgEG68o4BiqEf+NPPIRQMaijP
 PxLKi4+hEGHrSV9dGRUZTsrwIs2Csh6Z9h3QK3xVviDxCK2WvlyaJrGEjeTNLEgsF11u5NLR7Ty
 775tue3MTAjIPxL4DnIV8PUECeIUtlAbN8eCH60bcZbC0WZbfeiNiKyNuxx9dnh0elxQ94R856E
 t/p3tkZnW/ixAL1CaSVFP1xdtqdVJ2eVFiAAq2r+dH+Es+o1eDdQg/VpDS3BoKb1HPlTlx2dIn1
 BI98/hCY+5ujQ1m7A2lVeJLyMv3QWC7fUkAYxthONsKyLV8hCaU/HGewS7oT0OcYvQasoNxXdA3
 FR/ynIO6xonMdtlp4MkcmHUKTVeFPGSuPSDxH+fQ=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX9byaacOfGSvI
 V6W5nWbL9lmFYyjL/eWlL+LoD9ozmg/sT6Z904maT2oSdiRdoDHnyVPdNKL9eXepzfJ2jToyv41
 2rFHHFSzTk6b69Pq408OaNQdmNqHUz1AoNRCnNGE2EMV2G4pU8ts
X-Proofpoint-GUID: aYE-7vUsdB9WQxzpoOsxa4179_rDy5l0
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a479040 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=8fwEAWchWUUFBy44-ZgA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312

Add support to set the multipath iopolicy.

The iopolicy member is per scsi_mpath_head structure.

A module param is added so that the default iopolicy may be set.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 47 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  3 +++
 2 files changed, 50 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index cb433a028dbff..6159803d4cbb8 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -60,6 +60,23 @@ static const struct kernel_param_ops multipath_param_ops = {
 module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
 MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
 
+static enum mpath_iopolicy_e iopolicy = MPATH_IOPOLICY_NUMA;
+
+static int scsi_mpath_set_iopolicy_param(const char *val, const struct kernel_param *kp)
+{
+	return mpath_set_iopolicy(val, &iopolicy);
+}
+
+static int scsi_mpath_get_iopolicy_param(char *buf, const struct kernel_param *kp)
+{
+	return mpath_get_iopolicy(buf, iopolicy);
+}
+
+module_param_call(multipath_iopolicy, scsi_mpath_set_iopolicy_param,
+		scsi_mpath_get_iopolicy_param, &iopolicy, 0644);
+MODULE_PARM_DESC(multipath_iopolicy,
+	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
+
 static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -95,8 +112,36 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
 }
 static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
 
+static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf, count))
+		return -EINVAL;
+
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+	return count;
+}
+
+static ssize_t scsi_mpath_device_iopolicy_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return mpath_iopolicy_show(&scsi_mpath_head->iopolicy, buf);
+}
+
+static DEVICE_ATTR(iopolicy, S_IRUGO | S_IWUSR,
+		scsi_mpath_device_iopolicy_show, scsi_mpath_device_iopolicy_store);
+
 static struct attribute *scsi_mpath_device_attrs[] = {
 	&dev_attr_vpd_id.attr,
+	&dev_attr_iopolicy.attr,
 	NULL
 };
 
@@ -201,7 +246,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 
 	if (mpath_head_init(&scsi_mpath_head->mpath_head))
 		goto out_free;
+
 	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+	scsi_mpath_head->mpath_head.iopolicy = &scsi_mpath_head->iopolicy;
 
 	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
 	if (scsi_mpath_head->index < 0)
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index a9fd02bc42371..2dc02313b0496 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -25,6 +25,7 @@ struct scsi_mpath_head {
 	struct list_head	entry;
 	struct ida		ida;
 	struct kref		ref;
+	enum mpath_iopolicy_e	iopolicy;
 	struct device		dev;
 	int			index;
 };
@@ -40,6 +41,8 @@ struct scsi_mpath_device {
 
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
+#define to_scsi_mpath_head(d) \
+	container_of(d, struct scsi_mpath_head, mpath_head)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
-- 
2.43.7

