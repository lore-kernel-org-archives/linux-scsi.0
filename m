Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB524779A8;
	Wed, 29 Jul 2026 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322413; cv=fail; b=rFGT8ni2p9v//kI7NFD05ojToVd7cX+NfET3D37tWMA30B3L/Gh7I6jikOYtX8xvaQ+d0cNfl3F5ARKU/eC1TiowwSzmKLkwymSfO7Q0vYxSIwyhDoZrvrffuVNmn34oBVxXQ2ipqGIuhYjotKBdnXrPN3p25hsG/zIHdEPLvy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322413; c=relaxed/simple;
	bh=xfa+aJ+elRZmBY1WLk8+87s8qy3s3vIdou8ncrdyn70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YfBg+vQQiT6Z92gku4QR2OT71AwdsjkCmBBpvKDbPX8sHkpBmSWwzO7EYjilXVrzOAPTy8UEG6rBxhIukd6j8a/gnbd6P+rmkcifR0DDLtLVyRLmeyKgp9chROw9FTuTZGZrmzG5oMlUXajwTGuo0hhFxfwW/UPIZ1iihEFfGSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Fqxsm5gV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DMJFsQ2B; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fqxsm5gV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DMJFsQ2B"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9CXZA2091658;
	Wed, 29 Jul 2026 10:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ols9NjW0BGn8KoskDEw81vRbkPZVEQuSULPV12NQJCg=; b=
	Fqxsm5gV7UwXk1SyvZ6lmR3acukxaqt+akkxNmU/L/jp9oTciD7a7qqJyIJOj0FJ
	dqpdZGlOssF2BGAxy+Lh/h6t8l006vunv0zWsPiHhBRguJz89C6d0HgP54j0cocN
	tYuRqpqeGOxgUMqntqgZa8qb13QN+S7N+ZlqZ48G+9Gyoe1Je8pvD1m+EUc9AIkD
	x6y7BwIsUVAguPpi9KDT8kLNVe3TuLviEXxC28rL6ODkcITNglhD1ocPd0oNhF+r
	kgp4qPGCJ2oWjqneCA37ing/xDO/a0I4Av4ilHOxYvJZauBnM9xsYqJ8NUQLGco7
	bjH2quphpvbjYYeTbW6PuQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyydqg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo5t5039998;
	Wed, 29 Jul 2026 10:51:49 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010048.outbound.protection.outlook.com [52.101.85.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrk3k-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uTSkN+qupbxELk3YBXldeod5kQjVxv/eZHLJUjJxeK+CuUC3sc3Ch381cpEBwcwi9NNH+ZcYwD01WSsWt9bXD62g+JHc2h6GS+9Jp8pjblRbfypUKaCBE6aOzzSFJRnYDGLhdEZ7Vy6RR9ie/U622bihxylFR2ZPSp/LAhnFg212a0+MDg1ckm6rtL4J/gcTzSRg8og24qBYdVr/MADwld7mnTXiiwHEFnINH4/g+6g4J+dtP0+kJt10uS9uT+r+NnWJ6dQ4z1WCO8PW6goZHzxih1jcRzEVWKFkq1l2SYlbvWcdVECPG4faUL30Zkx9+FjmvF3ufaUihSyDkZQkbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ols9NjW0BGn8KoskDEw81vRbkPZVEQuSULPV12NQJCg=;
 b=fGt/pxTzUwtsliaOKcbUhK//YRbQ8HAgL6rgI1tzPyfY6LdUlgGL2seDi/PrVanj1J6e33nJ03vtdZH9tsUNq0TBiHJLZBVOd8RLS/qXGnBJIJ8WWPt6KNur1XbF2d3T74mj9UvZmA31NmpiAo3ms3pTpie0sKov7katpBIlaY7NyGaS3HGzgH6dVtMsFBccFehbsdohjHrPplBEKnjaiLo/Q6wSg6/Q3CqZCgMLsXqtqychhBxyd1Rqp9qBY+Homm70Go7FRRQJKpqXBSIVtBL9Asz/O36DO7T69KZUzLYxcERlA0YlKKniUc0UtfBzrGFGPSNhLYrdSv7b/xQrWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ols9NjW0BGn8KoskDEw81vRbkPZVEQuSULPV12NQJCg=;
 b=DMJFsQ2BVPr1VernLHciolQtAs3PooGbGAXlx9KJVeso9pdCKgF7KGMQND1tisnffVbvLPn0ZYaSqnOHkjGUOCC+yT4xaZsr0wWya8Pk8O4o34eCCSg5QhrabdG+7FbVwTUVCLCwG/63r5VZVh/Fw/9fkLtlpLrqDNbXkg+cuHY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:43 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 05/27] libmultipath: Add support for mpath_device management
Date: Wed, 29 Jul 2026 10:50:45 +0000
Message-ID: <20260729105107.255712-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:25e::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: b347a545-052b-45b4-e657-08deed5f60a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	79MMvQoc3kfvc1l0F/DUulHpga7xwLIJeicTeH8k4jnn7S5GwrBl8heGoGPGA2hAFPTW38AhrNykscR0lwp94KQtMr187ss9RFzjgTPZDQbEQqEhFgNRPOYNkColjzQvycVBFZ/zsuuiD1N/J3NRhijR7+MdZDhNn8y6dNx4+ftIR2pFXXqQEgI8J2ysUbEfAilqtzqCVmOekFpue4lx6BGXJ5T+Gs/39nS5kCBmTQagamcZxs1l/D0QyXgkqfJAtmj3ShXAFqN/i03v9xIsNFgFye21AtcyyygeE1KmEY1l+CTOu4nbC8sWo+RdbWbaftamIzLhWtPLBGlF0xb8EFNkEQBYVXgUnD/mUK3Zvji6vZJXgJtOkH3BKA7vSuRkrcD79Qj5o8+PEYBLmCuU+UWt3op43X9JP285KZ8r4ZR0/EloQA2Rdfjq/FRVIQrPGaawWfc3WSQQoJ9PkcqAen44+XtQTG5ysV8QMgF8sTqgpgYCI0q4ot5a2CTB2WhkI0yGgIQFvc0Pohbjfju3gcSi5HAtyMeO8DXl907uSBwlGnF/bA83s6DZpX9Io49Ot/4EiMms4mqqTOtNM3oSyFBvOtip1WVNDp7ib3rosFAqizKu7nxf/k6jtXfY/4UzvRtxb/mkOhpuESqUjonD914QEPnU9//Xuyu1sVRlyDM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jjdvFpMYBmZMc95tlFpgcPWfWoYKw20MuRJ4jYTlrOjwywPxhvviE4pax+Ce?=
 =?us-ascii?Q?o6yApf2/qTN6m5Nm11lHXz7dvNiu9vdd9HpGFHXnWa12HkKcaqw8JfpsjL8O?=
 =?us-ascii?Q?p3EdXo0qtyO99uWDD8ljRZVvajzL//zCNmQ9ZET4zf6vC34xl9R7vOWSCfe4?=
 =?us-ascii?Q?pFFydCura5cAypjAC4ehZX1ZBbjJE8CDeb/Kn3ZaT1NTs6AqhiDRGf/qHMOj?=
 =?us-ascii?Q?9UQY46+2ZQ6hTppOt2a4NOVJVzXoaYDvY6DDJA1U5C7Swj64GZiMWgN6SOkz?=
 =?us-ascii?Q?81nD0dYgJpDJ6GLWHQnZ29F9bII9LoRZ/UqeJIhur1zdPUBMbpZx0wl9Fgvm?=
 =?us-ascii?Q?TR+l9FlKtulU5tnb1JyyqjCU99bllIwZjkOC6tHth1PBMe0LmM4GNoTF2RlV?=
 =?us-ascii?Q?dBy6YGTa/gRP/zjiKihp4nLdz/Q6Br6JJoU6ZNBwlnf1dd8opdNOhg8FErmD?=
 =?us-ascii?Q?bz4HoCI32zRURmLFSwGIHwTIvYg6spThwKfDt+8+3OWoU541ksE+WWiLZjkm?=
 =?us-ascii?Q?Y03t5NIKNhnU5JwOnvOpUnKmowjm26JTyyFC85ahK0KGKS7sSzXsjNUQ9cqh?=
 =?us-ascii?Q?R+emvjsy3KR3oYsmE7kyxqrWj/QPoPnINSgXupIoM2qWgKxEi4LcJvPtO2jO?=
 =?us-ascii?Q?FbinHGGhc6JO8BhS6hOyN0XijL+Tq7yNzIQPPJ2Rz0OTFtESsJv1cDApaDG1?=
 =?us-ascii?Q?B4Ad//P0lRqpbww0SGAnPe/yjEJb8p3dmG38MCdLvFRfUT/LBtkuNng4HiCl?=
 =?us-ascii?Q?h5rmc/RvN5E3KW60Z3UhjN3ydeEFf5YFI0SLf4ujO45yYfoc4sunIoUECBDq?=
 =?us-ascii?Q?FIbiQm1dzaabRyCVqldA6cvmtLvFdopGYgIdmgLoNaIf+dvls6qXTBtwXfaw?=
 =?us-ascii?Q?d+LvqooEZAroYXsd4rBE/xzcfjvZquaBGkIUg/29Bpc3tbHvMv3TspLKRUbV?=
 =?us-ascii?Q?vGObCXck/UCOvGQMMUhiV/vTUVOXGvq2XVlmnOgHPTECf1BCYcKvb9fRfANg?=
 =?us-ascii?Q?GTvzIDrI80Md6oocYJjbAdVi1feRc0w3hqvC3slVFJpScdVgPenHU5ggG3zG?=
 =?us-ascii?Q?82PwPVvfOHczkHjEepUFJBEsBKx0I5BOoBVsfFPx9dA0Gi57r0BoLETAnXg9?=
 =?us-ascii?Q?2UAZOf5wrS4HDpnrRzbBGlIQCGS3QkL+lJi6XfRf1Cr6b1ZreuokmDxkO2L2?=
 =?us-ascii?Q?RhN9fovzmaGQkRQW9Z7FLooOXkj1O+CpyapnhO/U2dww+3dA17mBI7uU/NKS?=
 =?us-ascii?Q?xFXintM9xtoBCZwFGzmSAusXJacm8tVY52HzBWH/s5K9FEWvDEvWxUKAXBiu?=
 =?us-ascii?Q?FeTsI2sv81K3hL/QyzY7s6pjkpk8fR6W2saQV/pSTLMJDITPNfsYnQi09Ox8?=
 =?us-ascii?Q?8g2VNPi7t+hDlEfg3AIcgn/B641pErw7YWWhwVLLAXv1lV7NGG2NrLfuuN84?=
 =?us-ascii?Q?DOlbTcu9gTSOGDcOLM9yHVZJuxnAbmoLfCAbS+bVGerkqXZBSGEpHLdxQc0V?=
 =?us-ascii?Q?7uGkzvei8YngvBmEqleLRNmvC+2ZkrAQTXqkaHl5JgkF8JsZnnp4ke63bYR6?=
 =?us-ascii?Q?AIl5fP6kANiQCtCgs0L0qf2hcPkEslepKp3ihEPZ+rJiEft4NXktBiem46RE?=
 =?us-ascii?Q?oNg1STtxYw3UBsWUmayuBeIkBuQQFpuZdRjSslCAGuEUN7vfVmI2TlMB47q6?=
 =?us-ascii?Q?MbLBxOHzTmi5IUMbqfnViWmdEzKlebLk1H546VsJIAhQpl4MOIc1X/xpHJd/?=
 =?us-ascii?Q?mPPPrOgvyQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	XOl/BUEZ0HK3c5xBKn/i9zvmkT5BPSkMZW4e/3SNiYZYE8gRM1v/5DBgjS8uCn/zzKnjLuizfvuMJntzSH4c2N+V4W2j3HqlXg/l28uYpQ+Tbi9GE0kuVElDDOIsfk/hz/kRsx/LLAYDVvtK5Tylg6CSHOLRmUhEUrje5cN2ZdXO8/oL6diMPN7UjXOTbMlyjohxVLjFwi0S5FyPuNFL2m/Cuz9/QlyWeTFh0Kc0LrjjLnKPbV6d46rDMI8UrpUZvzdeQyWtup9nAQrQ8bczh2NmGc6dHpwr0IHIdPIeffyaDg2J3FOop5ImAsfxu1jQlamMT/265nM5z4Mw7A1Tww==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FCefgs3t4FOCMcdHyEK9xDIaP3/W0PUNOXP9lPo/qPnt5i07Rylp908yvmW43fNjP931SEMYQEThiq2qctQ9pdxGV1YqwZ8iQ66MFa2+zBilbeZugYnBHZogbN0b/P8MPJ5o2C5MCOtp4SFfWt7fAppqDGVqDtmhaPCGqc9Hjua02UNsW6D2nLKswvknaBG29nq45sMQlAePCL7vOq1OQtqoI+3TRJDmbt5nnvRjNzj+8i6i4+ukqXRha7wS2WjR9+C5/8ObBuTPF5L51WAxdAtjViJY4BX1N7v58nbRt7I11E4SyGvD5xcKVTCeGf8xCA/FQYRkhrHYJSgLO35+kTkdKTg+5IZ4Es7+ptXoEk/ZhW5Qgywd+9Lc4rgGl09R+VgGlREY835TFz5GX123cGGsAnP3PWDQHSVu35ER2hc3q0Om4tqJTWdsUmtJXg2+z3w8WE3kY5hTHtQf6qHBV+gQ77Rxxbp+JIn7Yl2Yf6+nxdLDssmnPQ8epIWbhC9yJ8/TbfbSE3Nu0uNvGTgWz3XGJw6jo3AHaTqz+D35EoxI9fwHCQv3G/JEdJT+07PMMNlz8zOkBcNcXuMpRzfVXSCFUcJ3xSYq0FDPD2VsMaI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b347a545-052b-45b4-e657-08deed5f60a0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:43.4075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FBlQPJ3ZHQGK1xx/K4UctdsC+PmwJL4Qk3l7zBCuD8HvbILH/4hWbeNDcnuURiJ1j6v/HXA0OAj4D61kDvpgpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX4ISaNFIwYvr6
 iec7OHvt9M49scPZ5drMtQRb7zke8ngqIBr7W94UPwzHZa+HSiNSEFf3eVm0rp5BMySaAFEVfTb
 /tcfy5Dr5kMVkGeDRby8VqkPDDWJh/RC8tWIBCrdbYqEInCwRgmH
X-Proofpoint-GUID: 3p3w3v28IIYpmbf8j22QIgzrbk8nPmZE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX1D7gN01IJRux
 bQ7GKZ79E+NN8s8Yv5bPg2x4RJr+0YCZ2IH48skzj2L1uhdV8avQrM5ICKVziruR/pvX7qG9U1V
 2gBa4ZR92EjPmfeYRWD+0JPyfwQU+MloHqDAa+ZMHp6D0uyKQGUiucbXCqP2eU3tfx7i3F436gR
 GMZMRsUz5vEkfV39Y2JJ/xWq6N3Q9Gn8kMt+Pq7xfGx7LTpso1VmJj7LLazd/yZYNMpZP63GUDB
 kUEVny8BbMoiLo7MK63O87SA4ih/UM4Wk5nKfe+PL0GrRxhaeS5xmeCB2jOZp0jUt9ekAozWo5a
 TJtZCwbJhzQKz1J30wH3ToQ50I81xdoQIgPs5HrMXsSno/LVG6vwCH0+Bqn8hsagm/y7Mg3Zumr
 GOMlUY+AwEQnoWF2pWlaBkvawB9qSzkX0znifd06DgvPxy8epWQKCatNHvuJbXtcmpwzMr5EAXE
 DEs55iDbz1tLsUxvRpg==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a69db46 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=WlZ9DiTZ2y1qVm1cHVYA:9
X-Proofpoint-ORIG-GUID: 3p3w3v28IIYpmbf8j22QIgzrbk8nPmZE

Add support to add or remove a mpath_device as a path.

NVMe has almost like-for-like equivalents here:
- nvme_mpath_clear_current_path() -> mpath_clear_current_path()
- nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
- nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
- nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()

The functionality in mpath_clear_paths() and mpath_synchronize() have the
same pattern which is frequently used in the NVMe code.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  12 +++
 lib/multipath.c           | 154 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 374f0531f7e07..033ee8d54bbe9 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -20,10 +20,13 @@ enum mpath_access_state {
 	MPATH_STATE_OTHER
 };
 
+#define MPATH_DEVICE_SYSFS_ATTR_LINK      0
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	unsigned long		flags;
 	int			numa_node;
 	atomic_t		*nr_active;
 	enum mpath_access_state access_state;
@@ -89,6 +92,15 @@ static inline enum mpath_iopolicy_e mpath_read_iopolicy(
 void mpath_synchronize(struct mpath_head *mpath_head);
 int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
 int mpath_get_iopolicy(char *buf, int iopolicy);
+bool mpath_clear_current_path(struct mpath_device *mpath_device);
+int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active);
+bool mpath_delete_device(struct mpath_device *mpath_device);
+bool mpath_head_devices_empty(struct mpath_head *mpath_head);
+void mpath_clear_paths(struct mpath_head *mpath_head);
+void mpath_revalidate_paths(struct mpath_head *mpath_head);
+void mpath_add_sysfs_link(struct mpath_head *mpath_head);
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
diff --git a/lib/multipath.c b/lib/multipath.c
index 93b82eea7d38b..6b8f6e846987a 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -51,6 +51,87 @@ void mpath_synchronize(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_synchronize);
 
+int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!disk || !nr_active)
+		return -EINVAL;
+
+	mpath_device->disk = disk;
+	mpath_device->numa_node = numa_node;
+	mpath_device->nr_active = nr_active;
+	mutex_lock(&mpath_head->lock);
+	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_add_device);
+
+bool mpath_delete_device(struct mpath_device *mpath_device)
+{
+	bool empty;
+
+	mutex_lock(&mpath_device->mpath_head->lock);
+	list_del_rcu(&mpath_device->siblings);
+	empty = list_empty(&mpath_device->mpath_head->dev_list);
+	mutex_unlock(&mpath_device->mpath_head->lock);
+
+	mpath_synchronize(mpath_device->mpath_head);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_delete_device);
+
+bool mpath_head_devices_empty(struct mpath_head *mpath_head)
+{
+	bool empty;
+
+	mutex_lock(&mpath_head->lock);
+	empty = list_empty(&mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_head_devices_empty);
+
+bool mpath_clear_current_path(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	bool changed = false;
+	int node;
+
+	for_each_node(node) {
+		if (mpath_device ==
+			rcu_access_pointer(mpath_head->current_path[node])) {
+			rcu_assign_pointer(mpath_head->current_path[node],
+				NULL);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+EXPORT_SYMBOL_GPL(mpath_clear_current_path);
+
+void mpath_clear_paths(struct mpath_head *mpath_head)
+{
+	int node;
+
+	for_each_node(node)
+		rcu_assign_pointer(mpath_head->current_path[node], NULL);
+}
+EXPORT_SYMBOL_GPL(mpath_clear_paths);
+
+void mpath_revalidate_paths(struct mpath_head *mpath_head)
+{
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+}
+EXPORT_SYMBOL_GPL(mpath_revalidate_paths);
+
 static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
 				struct mpath_device *mpath_device)
 {
@@ -473,6 +554,8 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
 
+	mpath_add_sysfs_link(mpath_head);
+
 	mutex_lock(&mpath_head->lock);
 	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
 		int node, srcu_idx;
@@ -489,6 +572,77 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+void mpath_add_sysfs_link(struct mpath_head *mpath_head)
+{
+	struct device *target;
+	struct device *source;
+	int rc, srcu_idx;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_device *mpath_device;
+
+	/*
+	 * Ensure head disk node is already added otherwise we may get invalid
+	 * kobj for head disk node
+	 */
+	if (!test_bit(GD_ADDED, &mpath_head->disk->state))
+		return;
+
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
+			continue;
+
+		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags))
+			continue;
+
+		target = disk_to_dev(mpath_device->disk);
+		source = disk_to_dev(mpath_head->disk);
+		/*
+		 * Create sysfs link from head gendisk kobject @kobj to the
+		 * ns path gendisk kobject @target->kobj.
+		 */
+		rc = sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
+				&target->kobj, dev_name(target));
+
+		if (unlikely(rc)) {
+			dev_err(disk_to_dev(mpath_head->disk),
+					"failed to create link to %s rc=%d\n",
+					dev_name(target), rc);
+			clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags);
+		} else {
+			dev_info(source, "Created multipath sysfs link to %s\n",
+					mpath_device->disk->disk_name);
+		}
+	}
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_add_sysfs_link);
+
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device)
+{
+	struct device *target;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
+		return;
+
+	target = disk_to_dev(mpath_device->disk);
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+
+	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
+			dev_name(target));
+
+	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
+}
+EXPORT_SYMBOL_GPL(mpath_remove_sysfs_link);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
-- 
2.43.7

