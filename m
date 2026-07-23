Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B324A42B746;
	Thu, 23 Jul 2026 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799452; cv=fail; b=BKQVkGXAB4yK3p02AxyDcQSmSfNUVzrl2eGIWR4LLe29yZDdzzdUek6Ze3tTHON2S8YpQCRrVtcme0JQXViTF6b4ymLrnYkCHE8o9OqbEmhBO57SBVk8ScWPTpYGUVZ0L/ByWCZI4SxFLQgtCdXPd80HgROhjXXH9EZqPyUzk+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799452; c=relaxed/simple;
	bh=EkIrVuKIk9kmnn7CUPjL6RTpI4iEfEh/YtotSmpRCq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kT0VZYTI9+yAjbC2Rt3vvHFXw9z/aj3xgsJHwfrorLYRxjRojrQb55VMQxVAbrfdwu7cT9FICFIRtXmOEJdXQrvlweR653kRg3u55E5skXc/EdVRHhl8DGCTldXvyOOkp/ESflXnIc4GPCYkpH4XWR3O1meHkbv/tH6DfLNg7ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TdoaVD02; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ghJRZkVY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TdoaVD02";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ghJRZkVY"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtZbB3391769;
	Thu, 23 Jul 2026 09:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kHla3464PuKLoe3xnhQ/vLbQPHYs9BL3B5y15b4dBlA=; b=
	TdoaVD02wpuk1urEoPaPWXGludigZN/ry3lM9iEWzfccf1lETxS7X7lI0yfHieIG
	bP4eyVoKqpzEL6WG2btZ7Kx7P4DrSvEFVpXT0IxE5ddaCR96Ll+y4chOAOixERXX
	hH1LbqxG9e08Mt+Ed7TL1FQgGia2DbpLme5UYRF3EENGbhfdImnbA45gpA6PgWXc
	jsKobI1X/URJNGN0Auex3LhslHYivWdpMc+zYS5JjbAK/D4pu7Jbz3SLULvkI1v+
	iJjGpMVmgYn91/uMy8ck1cU1L7oNTZh0h3LIdjdIy6Bn/5yo7yM3ETaoatXlkaD8
	mtufbLW30Xqs5PeCup3ThA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1tjxn4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XVPU010588;
	Thu, 23 Jul 2026 09:37:00 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011004.outbound.protection.outlook.com [52.101.57.4])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxsdebf-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uacl+2oJCJEgmilGl3PC81YtRKqryR6P54EcpiXESMqDAIduq1QDu05Sh8F3M82H9G6kkBUbUFZN9ykRzJOSLxqLTQgaIBhg0IC55RZJWQnjVNbztkoRzUMLVczINmSuFnrbO0aHwov3YmkZTs28HPOTe8o2d5hCRRb/JyEWfnUKVy9Hv4MB/gf2WM/T7MYr9znP1DFSPkbVfthMbAMtCYdfsP2UtVRPwpldFahoaAJEqg7L6jT00vQO2A+/EWVIs5lcnfGkUuIyoQZYDi8XZIt1zK2Vq30p1kvAuLhYkMtg869sokXY+PCcJ3aUqIZf8eF2C5PuChcx58erGGGIXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHla3464PuKLoe3xnhQ/vLbQPHYs9BL3B5y15b4dBlA=;
 b=atsyqCYJBaPn8gDgnkF7yPybMjpU2crezS914g8e96Kivz+97qXekNu+rmS9PJsSMiVnsyajn8hvEL30I/UodiOdvy3N7kFKC13JNYb3qkEm3wo1KKJB6ZGTW+SjKRcK6lwnNPX+fsmX1CWK76pgMf9piOmzh4t3hOi6/g+mj+m/GAzbvAHd8DgRm8SHkrft3m90OmbtVCuIOO0AOQgqoMzwFH552GvGFdc3FlpcLsCrSVie4YPQrMZVA1tS+KK6RmiDuPL2+yuAUgNG03JwE8mohn9po7kYcgxXmY4aKLDNsd89yecLViaJVz/srpfp8rNbr78RGyShUexq7FjHIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHla3464PuKLoe3xnhQ/vLbQPHYs9BL3B5y15b4dBlA=;
 b=ghJRZkVYmN0ZWPz5cJvcB8r/d+UmFSiymwpZKNKdm+qdqJgCLY5aTcgitehhAdSJQtGMyxNKlYx0ftrMzn7M4lEdc7gcM4pRgtw9S3OIZBhOcjWbvWjy+hhiJOHMr3fLfmkkGMvfKEB7LN3doiL4+ICKDihsgw8CKAdX1GMOMyc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:36:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:36:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 06/28] libmultipath: Add delayed removal support
Date: Thu, 23 Jul 2026 09:36:04 +0000
Message-ID: <20260723093627.2327456-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0402.namprd03.prod.outlook.com
 (2603:10b6:610:11b::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: c873e459-da3b-4a9b-592c-08dee89df087
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	3yo9LFhb+l5Wi8dF5h5ZQWdOQK4E67g7z3kTt6GY8cI93fuJYvL85ddyEUVwWYcS3II6IENreVvdke75O+K85yyo2hdXFDSOHdl6A1nYPP7tTyVt97124QDEwBijHsjkVdddpe/1m3tAqzDQMEMdZoogkRkoc2AqJ3NqG9qQBH2QWwwvlMgvjm28HRuY3jpBrrEufJleGtrirXRL1H3BcuX8vtWXU8iy0mbNuTEinm0P4tKa1lR3iF81W8qJDpeepw8n9aTddkMgnzPDWhOld3gzWENd3qHqT7BphBfrqSmrurJu1n4Y5viViRuUELXFsulTXdKtB9jLIX27dqmWw/ctO0YP5PsyUbxv+U7qzz4E7SBEWtPFYOlbHkEAMh8l8B1uT5tzHffr2GLV6LAowXj4xpoqKfyH/h1B1+XxP2PBQDLZDHx46aI3A2ZK3B/X0X65IoQsBDjuOsSEL90SHv3BS3X78/uuyXefLvRrJD6QwLi4kWKPtiowW25pWQ8/YwFJsF30DM3C3dDgcGUQEtGlwQFkLV/PNlWGUgGTJIKvreEwQXlfyYiZoI5ABsNPsOZYhuIjEZMhQ34J/TnEupk1NXdJUW7z4jZ+0zefUM1ji/RYHvUA0rPJ7+tvzJGjsup91QQJJzVZ4OstydadC1X0pSfZOrg4o+mRMxJqoL0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z0K2CF9YKaLqCA6La9AWHhvRdSCgO6o4aoj3Gp+XaqoVHVlWAOfH+tccO3nb?=
 =?us-ascii?Q?s59viI4CSWovKgshIYfFMrEofEf7tNpIHiH6TMApivm+5KMMAN4G1DPMrNSm?=
 =?us-ascii?Q?xbzjcVxa4G/fGNybJka6BY0iZ/Kybzp0bxraErIyyaYtXLsyROfkYdfuJJlk?=
 =?us-ascii?Q?UQoSwM8IdgJRUr9S40RgkZ6VVCSei2nw1RLA9zdhyUBz3R2CUf9CUdKD3Msv?=
 =?us-ascii?Q?tTbfOCeCSuK9YGbQGpdJAWL1mSE7vgtTy7oyJVL8pJDbltxFbypwHc4q/Ty8?=
 =?us-ascii?Q?yaNnZmk2vnk0YB6g039Ggln7yA4qV8QdhnwVWZtk+2Tn6yEDyUExYamuTL+c?=
 =?us-ascii?Q?spYw/627dYAaVSRndkGxBWCjsZTikSfi4j/CtGbzJiuwFOAqUFlqqzI+K8BM?=
 =?us-ascii?Q?ni3Op9AMq/BwokgmITYlNkscTbj/ZebYdfZ5LeYI9ZcNeKtJ5jKCTQfCJbs1?=
 =?us-ascii?Q?3JCGETcHJjiVkVoUr5xdlP28ouhzFzUfax8wq2b0YGNkxLE3a9zJBXu9Ds67?=
 =?us-ascii?Q?UPmjw+jVAzcvWsd0TAEhW6u/1REw+cFVDat99rTXdkGvEazR72H/rMBXHP4y?=
 =?us-ascii?Q?EFyyf6bmVTrrJs5ZMAosTiV5gIt4/2SVT/p9ahP/LoZsXqOlOZ95XDqER2R8?=
 =?us-ascii?Q?ae/ZJ6i/1bxbmvXrIEQw6hnlZCPclK44wUgmCNRb2CbivS0OV2ymOox24seX?=
 =?us-ascii?Q?XEFUp3TU1ipePXVb/AEjelQYgzQYNJuneXfrCmvMEc/xv6eBw2bshd7jOJ+w?=
 =?us-ascii?Q?qqhdwCOUHBAUtOhtx8ilLK0QexyRaB2czT7RbZWtNFOCN3cOXqSH6bu8q3V7?=
 =?us-ascii?Q?TMDc3NnDBbUaZ8ehZxdIwNaThRAGZ9YeVr8JDxXiQ2SasxlcxelVzSS6Fgx7?=
 =?us-ascii?Q?SXIuzb24Qx/i9igSOCeQAcqWDdzX9ZnTh+Pn3brPZamylop/pi5+JNq859d1?=
 =?us-ascii?Q?V+GkMiO6b3beHCWCjQUTvitoIfRIHPps9zhpwYh7llqr4u4hL6cB5a02mDH3?=
 =?us-ascii?Q?ubsZFogOzSBWwngXDPVJ7QE0rr0GTu31NJ23fx+o+r+PkYpXmGwVfvSTlb1z?=
 =?us-ascii?Q?PhLUSR98e6+vp4FPyiEXiuwAuKLpHLcKEB6cc86y9CbR1jkiy3gHQuywAIci?=
 =?us-ascii?Q?Bs7dEGqdWs3fbcvL6OCL+o/vjzwxTK7QM+o4HrraRiWU2RqPW9dtyoGThflK?=
 =?us-ascii?Q?0XeoKK1raMVJAo5SpYliq/DgAxg/9XkmjQyDGCq2UQI4F47QEWNuwDvvAADq?=
 =?us-ascii?Q?cI4SRMaVqd50BDKo71jkx09YmNQNpAq63U9OYAbK/gR3RDdUG7+Ro+1rdRu8?=
 =?us-ascii?Q?vUBjwLk7GpAP0vApXyNI0whXveDF8QrJK7TUACMc3X0O0CiVEHYGWmf1EHWF?=
 =?us-ascii?Q?zgohjV6IB+/QQzQNofRpmCzkzGP0lPck0eK9yNJUdkfy4ILTr2H+osVQE1HB?=
 =?us-ascii?Q?a99NHlF0YFkognk9L+EHea/HKHZ2uUiSobitFuHiarFP0BXGbwHdOifuq15v?=
 =?us-ascii?Q?fFhyxwKCZbiCnwsy3AvRpHbHEc36vAdYWmBdvYqkGBc6GxEWFsZrf8HAXWZx?=
 =?us-ascii?Q?31RBVNbR4fDRhmqco+xQQwQExaIcig9pGRR0YOYqhP91a27uS0Xf47lq7cQt?=
 =?us-ascii?Q?ZREj2aUMKn3a1bgMikgX9tVe4mEpCoLrxyDOtAAOGAiRi00eLuAeHz6N1Po7?=
 =?us-ascii?Q?d7rRF1HVGTGplQhGKMnoP6GbcpaIDjz539Qwdg+D7ujM27zg/xPiG+2g2enz?=
 =?us-ascii?Q?44vQTXNoQQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	YUHEiGkr045O5E9GwH4xsQqA+lQi+US1ngY1he2cGhej0gZRcJon54wkcQC0eSmtAGaggcny2Zb4uBYi+m4jcNDfuSQQpKyBEDJFhn+CVjrmcw/A6TIlcW5g0nXMwishNfb9fBdbdj/tUm61pitgZQ14UZNQ3mwQyshXaGgfg/MRMalsNYo+nAOSOzimOJ0fGG2ilX5brdT1RgO3Wb2Jzk0cUoCSoEHHrosRtsnJxZ5YWpYOhtzNQmrHXn9KnThv94hk/QrOUuEW36PHkl49Ncgfi2IkJHRsIhU/G+DnEwcSYrrNmMF4EXAiCsl3k7aRycq7ZxQrFsgaX7TORYumRw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jzfnQN7bSA8CedHo+Hvu76F5FYhmYz0y6lnLaVLlDzLXhF9KJ65mDcZD4QVEcmlnpqb3Zae/MepMbmLBk+yVbqU0nfS5FdHZiHWZ8Cp32qjHKdXJH/6O/QP3yQSeEIdCk4IQHL0i/198Ms3HhCtgxu7REmQQfXmdiEZRwOG4QwSIydnk5if921RcNOkk2BJRJbEOZ7cEAVhS4vUC2VnRRGG9O96Xchs0QmILltDv10jx+mALQvbrDdgYuwjZb3epCSHii0LF83QxgGxPdlsv5uv7btyj2UTsuWcodmlz3f7VB3iN3Ul14f1uxrjDk68c2TBq0n8z6RQ+vikjw2fEETF+kuXFjArGawN/5+QaPAwZ+EMNiFDmAlKh3rtl4gZC4qJ8zOphHDyDR12vEA8o8/PmZDFN3sJsh36FCAftxU3yBYELlCG0D5ctDxzUIiVRYwmkZ74o31hN86PzcBt6Roa9Bv/e/3apDilThRvDqMjqlHkApOydnWvdu6ViNDVuro113wx89Wq3gt/hfOCUxA9qm5k3ELORy9fG/RNeCVJtJ1xj5l5KI8GPltvFZGvdDMlOaEnWhqQhymikH0S8NPSXQJfybXWHgzDUi4SEJzs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c873e459-da3b-4a9b-592c-08dee89df087
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:36:57.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5pN/Xfs0VIaBBLcaLBbYdO96+8Qz9t4IWXsa17EPaKMFh6K/H873812WDKwumUgLJAKomeqxFRyzDFPVJSyVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Authority-Analysis: v=2.4 cv=TN51jVla c=1 sm=1 tr=0 ts=6a61e0be b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=BfxcaXdt0Lgmg1IeN-8A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-GUID: mwo0xSTJL0NRWgsawQJfSXZJgDWUy-3y
X-Proofpoint-ORIG-GUID: mwo0xSTJL0NRWgsawQJfSXZJgDWUy-3y
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX3BKs0Nka4ciZ
 XWC/ehAAIaK6uEkPskJpLn+agvugb7HpISX7Oa413D3JuRklGw3OY2/C6GNnQVF2s3pgcetxK29
 8lL1hp1nRpRKVvyHp+TQog2Ih+pouTYCW39HHqDHX3Jv2nRa7MIf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX8+iy5FeCpqut
 LVne6rrRnw/rf/PeWmXPx6iDhubjkaJ23y2Jmfz1Ia8U8xkv882e65V/l5kWUSNI8Q3fNFxeeB7
 BreoJnOryfxJIOpnK6wH+xlAdTaJHqTpLxQY4/nyIR1y4z/Wddq0wKn1FQd44rHR5wdVEv0fXf2
 4u+TYwFgu8Ll+KXN6ywHan8wIax/A9eXi6EW1hU7xYuDBvSDUO+aKKccjWT39BpYQ66r+zMclsd
 jfKeA3ZIT9Hr5BmBAGQPsTt/bucVqU4mNTfIrvPjuap4ejy6kNmgs/HH6x85LltD6NXq4t28biF
 TVGbyfScOquPcLl/oXi+hsh8JiPfXs676qhvGl8rtv/vY+c9b2tykS4YKaohtbjr/1ta7e+qe4D
 V9yVIIdSVdXUdcxrk8gdonHQ0mj4Jxa0IkSOEKZzX6Uan8PGLvvZZx+HOZC6DIhJ4GVKz9MLeNf
 xKOpOpF4QP4SX0FjhTNQZQJ8HgWlVQnFpJrlurFQ=

From: John Garry <john.garry@linux.dev>

Add support for delayed removal, same as exists for NVMe.

The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

Helpers mpath_delayed_removal_secs_show() and
mpath_delayed_removal_secs_store() may be used in the driver sysfs code.

The driver is responsible for supplying the removal work callback for
the delayed work.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 18 ++++++++
 lib/multipath.c           | 92 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 6915c2a979642..44e26c16b3dc4 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -34,6 +34,7 @@ struct mpath_device {
 
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *);
+	void (*remove_head)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	struct bio *(*clone_bio)(struct bio *);
@@ -41,6 +42,7 @@ struct mpath_head_template {
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
+#define MPATH_HEAD_QUEUE_IF_NO_PATH		1
 
 struct mpath_head {
 	struct srcu_struct	srcu;
@@ -58,6 +60,10 @@ struct mpath_head {
 	atomic_long_t		requeue_no_usable_path_cnt;
 	atomic_long_t		fail_no_avail_path_cnt;
 
+	struct delayed_work	remove_work;
+	unsigned long		delayed_removal_secs;
+	struct module		*drv_module;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -113,6 +119,11 @@ void mpath_remove_disk(struct mpath_head *mpath_head);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
+bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+			char *buf);
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count);
 
 static inline bool is_mpath_disk(struct gendisk *disk)
 {
@@ -128,6 +139,13 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline bool mpath_head_queue_if_no_path(struct mpath_head *mpath_head)
+{
+	if (test_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags))
+		return true;
+	return false;
+}
+
 static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
 {
 	kblockd_schedule_work(&mpath_head->requeue_work);
diff --git a/lib/multipath.c b/lib/multipath.c
index 20c633ad7e1df..1fa4bd6677051 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -65,6 +65,9 @@ int mpath_add_device(struct mpath_device *mpath_device,
 	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
 	mutex_unlock(&mpath_head->lock);
 
+	if (cancel_delayed_work(&mpath_head->remove_work))
+		module_put(mpath_head->drv_module);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mpath_add_device);
@@ -338,7 +341,17 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
 			return true;
 	}
 
-	return false;
+	/*
+	 * If "mpath_head->delayed_removal_secs" is set (i.e., non-zero), do
+	 * not immediately fail I/O. Instead, requeue the I/O for the configured
+	 * duration, anticipating that if there's a transient link failure then
+	 * it may recover within this time window. This parameter is exported to
+	 * userspace via sysfs, and its default value is zero. It is internally
+	 * mapped to MPATH_HEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
+	 * non-zero, this flag is set to true. When zero, the flag is cleared.
+	 */
+	return mpath_head_queue_if_no_path(mpath_head);
+
 }
 
 static void mpath_bdev_submit_bio(struct bio *bio)
@@ -480,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *work)
 	}
 }
 
+bool mpath_can_remove_head(struct mpath_head *mpath_head)
+{
+	bool remove = false;
+
+	mutex_lock(&mpath_head->lock);
+	/*
+	 * Ensure that no one could remove this module while the head
+	 * remove work is pending.
+	 */
+	if (mpath_head_queue_if_no_path(mpath_head) &&
+		try_module_get(mpath_head->drv_module)) {
+
+		mod_delayed_work(mpath_wq, &mpath_head->remove_work,
+				mpath_head->delayed_removal_secs * HZ);
+	} else {
+		remove = true;
+	}
+
+	mutex_unlock(&mpath_head->lock);
+	return remove;
+}
+EXPORT_SYMBOL_GPL(mpath_can_remove_head);
+
+static void mpath_remove_head_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head = container_of(to_delayed_work(work),
+			struct mpath_head, remove_work);
+	struct module *drv_module = mpath_head->drv_module;
+
+	mpath_head->mpdt->remove_head(mpath_head);
+	module_put(drv_module);
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
@@ -524,6 +570,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	mpath_head->disk->private_data = mpath_head;
 	mpath_head->disk->fops = &mpath_ops;
 
+	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
+	mpath_head->delayed_removal_secs = 0;
+
 	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
 
 	return 0;
@@ -567,6 +616,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+					char *buf)
+{
+	int ret;
+
+	mutex_lock(&mpath_head->lock);
+	ret = sysfs_emit(buf, "%lu\n", mpath_head->delayed_removal_secs);
+	mutex_unlock(&mpath_head->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
+
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count)
+{
+	ssize_t ret;
+	int sec;
+
+	ret = kstrtouint(buf, 0, &sec);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&mpath_head->lock);
+	mpath_head->delayed_removal_secs = sec;
+	if (sec)
+		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	else
+		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	mutex_unlock(&mpath_head->lock);
+
+	/*
+	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
+	 * by its reader.
+	 */
+	mpath_synchronize(mpath_head);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
+
 void mpath_add_sysfs_link(struct mpath_head *mpath_head)
 {
 	struct device *target;
-- 
2.43.7

