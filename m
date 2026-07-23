Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEE1439F82;
	Thu, 23 Jul 2026 09:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799512; cv=fail; b=bcIXlCqJ4zOTTThHdea28959risbM8dU6DUbYrbXVEAjUMh3EfncfyVZ5g9h7MJjV1tLIAG6qNTozcdqGw8YewyzxUcZ2GlHBOq72j7E2wZn6OX71VdvI6ex2G1QXnHfbS5LSU5nuR3MX0UVB8/dBzxi8s2+q0Rtctf/aqPMHF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799512; c=relaxed/simple;
	bh=4ms7gusfmKjaRwstgZmMbmMhH5/gdUUz+ieMNPAS2CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ni1cftXJzPQtBSDmZ5Tr69LLpGjHkXr5sthGv6eZINCbXQp+gPZq5EFnaj9vtE6UPlx3/PgpN+OLxKeX5AqrIZEEissUuENOffOrPECeddZngXfAYdU+r8vxfwwsd6zZkylNuviQ3sGfSFs1HzLi5IS54o27qZeTc1nDyMKL9ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ft1sjOy4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GtDhBCTk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ft1sjOy4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GtDhBCTk"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N2n7R3080922;
	Thu, 23 Jul 2026 09:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TeJxKQoaid6p6FJTPHWcgjY0S0LvIMV1MF0S61Is/HU=; b=
	Ft1sjOy4uXEzrn/zt5vD78FvFS9M2DnYEYZhVmM66Idh0+XnCmr/XJUIRqeNFVc1
	80Eq0Wim16OaMbYRn4XLmNFC+a7j1lNpn2xq/5e2vjbWSvpAOGwlysDPVw6yAw6R
	tm5FW6zx9JWnmhWNj9o0A4kSelQDeIbQvncMCXibfwTU6UfxmLLJFOe9hHiLM59g
	MzyCRHx43gC2LTZo4w30YjxbK5ZJGFg4kQ82hEOIcbpLUlFz3hjsv1emr/N68Cla
	eoe4RyS0nWvEjXTLTe3hazQdxkvYYUBh6nUKOyGSsvUi4NkzA03da/dQOOrk/Uu9
	uZcm+M8lsMbGRq/2H5LkOA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqpqd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XVCG010595;
	Thu, 23 Jul 2026 09:37:30 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010070.outbound.protection.outlook.com [52.101.56.70])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxsdeua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AvwUxfprmtaKx4yjY5vglfc3fQRhmZ6VU0S3bkVEzVv3SUSYPbmo3oa9aRwdmBPe3iSOStt/ui8VVf6oScCjEXYm9z9FLuCT8QT1ohpelR0vIwd9d2zaZWl/I8kbhYqrpIdhmMdxe3iHyvUbEeNZhGvSWYeLRrf5exOLZ6ajLIFDSATBl99pcn5b2bv829ZS7kKC/B28VEXLR7st2Q/lGKYdX/i6BTOIkeBWr82Kzz0zfWnawhkXGvQO0BVQ2fB4r9cFDXeQ5xDNHg4J0R6Uh9mFPwK26D5eCjq0JZi2W98OJ8XRXHjvSpYjZiHU2alDBkagyF3dbFwRcG4zJHmcoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TeJxKQoaid6p6FJTPHWcgjY0S0LvIMV1MF0S61Is/HU=;
 b=YbMHfl0msJfmhqzPLYD1+T4x/p+bDQ/gMJPF228n7ryoSpV0ych96MrSXT5jbPh0WzYeBkXSPGI51lsOIfsncEPK6Flf5sn7jgKDTrq6M8cJEIk3NAGjaalJwO19c8jyMTEfYIz7gwke2DrSlaJsxQJR9tBENVAl/L6B2WDQGXgxdvPMj9LBCykM6P7KaEQij6Jdgnbo8o/5edDcSzFHjTGdAUfrS4cxyYB/B80P0++b/qMuIUjl41tbPu9qIG+G4H7QQmgkwxnb4AfbOp8hgLPLNcteTCmlP8+C4lr5Xlo0E7PCKHMBl3kCQt9rLHHGRO4+kqeAhuEIm4FJ310vuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TeJxKQoaid6p6FJTPHWcgjY0S0LvIMV1MF0S61Is/HU=;
 b=GtDhBCTk4qo0RNFq/7kkV1nYAg6AWNEpfY1ZdMB4T7hETp11ZfvdfkrtLm995FhpYIvneGdDJJGoEhCrvbxpubxBr2q8xRz4v+22GizAacuj6Q/1Dq0Fit+fW2Ro34Zvjn0kZaPe0sNajEFpGqIDCd3EFpM7M3paAZ+7jimMEyw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5672.namprd10.prod.outlook.com (2603:10b6:a03:3ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 09:37:26 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 25/28] scsi: sd: support multipath disk
Date: Thu, 23 Jul 2026 09:36:23 +0000
Message-ID: <20260723093627.2327456-26-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:610:54::28) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: 164363fc-e30d-467c-b9e6-08dee89e018c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|20046099003|10063799003|18002099003|22082099003|6133799003|5023799004|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	iNWsOF8XlfFkwBgX8GC+h0rLSb0Kv4CHmEZDScJYIqTbir7u8rzSnlXLXKcBmjDXigIvgjDFX0Xf3ArNRWlZ65ilHERWkTfWp08/59cRln3lFblIAxSWHFyHUNsBkw6yLU2G9VLIsvE+Skel9YKsQR2xIXe4it/mvJY3tDXnLw9vItQS3x1AGW2BV6hCflCC5o6rzaXSM8zOuE7S5otsxAbPy5wJDRjJ1jqUA6ijl3FR6fGrTIMPIFYIz4dc3ChJq3sUgiJVURzMY24QXauClFizvKZhh+CuWNr0noO8rEbIPAXwbMqnBqriAfcN1cwMzdIDhN1Bzbs7Kd1VG01UbSYQwCTwqNica5pc/vbqEO6GPGR1cJt/jKHwfPmLie/ccHkDHtu/FpLVNazGzKLJ6ZDUeoWJzxjJtgcm5FBMpAnN558fLwH7O8bHzGDESUncBnwl2YNKg7jVn1KwCsvLZ84jIh3eKkZvEpD1s8jvDWj2JPZT1bV1mmkQmky7HePVeEdXNRvWYxYe54WhOi8imNU3GRMzMWZ2txZ64SiFdBuUaXt2+Rb76vVD5qmwYO1ojTo8lDYfQyeob9JyStXurOgFKV+FHGgZyzpyAsyVpuN4VE5OrWx2Rei1YmOJUbvI2hHOOAQEHqP29CJV501yS8Y+1AtsLUuEp1E9UYpi0kk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(20046099003)(10063799003)(18002099003)(22082099003)(6133799003)(5023799004)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eASmiBBGNG64gKRwfaElXWoYDNiTYLYzkGDq3uOsl1p5gsYd8wTS1fG0d5ST?=
 =?us-ascii?Q?X01rxwc1/SA930fDYcD4AeE6RsnAhv/8BdkqJI1uR9NwKgPKZj3Sr/b8mFIm?=
 =?us-ascii?Q?JjBdVv+YtUnASRcv475JxNkMB9HkD8VvuzdXlrZJ0oPUo77rKq9Z/d26+/IH?=
 =?us-ascii?Q?Av0u+zYqMjYeqGjhRZpaGY3AENzZciea0okaZFJafz8Lh0z69nj29pCA8faF?=
 =?us-ascii?Q?Rn9p/vt4q9KHA8btwUBhni744Gikhq5c7wIsS5WRMfp7Eu3GzQE9EKx8zlav?=
 =?us-ascii?Q?mi3XVo03+gB/WakcXE1CzV5IcpYAv2Y4LJwAMZOWismmbaHqEJzREFmrd2Jo?=
 =?us-ascii?Q?Rehvq5sKDkr/pgmMKWtNr77/cpMIKzWTawmVz6Y+oRyBo+8XS5zNi5zAQfvU?=
 =?us-ascii?Q?Qwgp7hwJ7y/IoixHpGjOe3UGHb+I9ZmsIiLNBxeO6iGyhtDhaRpfvbj14EhQ?=
 =?us-ascii?Q?hEkDEouNLzXwMEhE8jCJ2yDUp+yeZiMklGFebe9o0elDG5xynVp9ba46cber?=
 =?us-ascii?Q?X5SiucFJ01OstLT4pGcmj77adWrECFQEsWZ9CbSKfRSxbCGoyejdHBYUF8F0?=
 =?us-ascii?Q?DOC0HHkDNdeNqj1BVht4gO6X2uLiw7Ww8rTqYhV3bpy7EcpS4SPdLd+Qoz6U?=
 =?us-ascii?Q?6SUcGv2k4IXZtHd1zbygv3kIz70WsqlIe1RvAWFSWF+XL1h0j2pzdJ5puQ1y?=
 =?us-ascii?Q?pANo0S2RXJZKH5ZsMar1NbqBtDjeu68Bx3LYJb4Mu1UYdXF4+DoiHVcqM8Lk?=
 =?us-ascii?Q?/VTsnQ57RTW6F1aDGmqDbm7Ae/QObObU30yWQ78R0uXG/RXFEpD+Ak5rQQvF?=
 =?us-ascii?Q?GqVpnSghGMH7uy6+idIcf8QNQO8C2Hi/YhJTZnZ0fqrxA8s+OXZWo+TiA8UX?=
 =?us-ascii?Q?SZSv3HhIajqARqOrDIIexVoaqZ4a/tbhVkSaTtc1Cnb7AuIgF01q7/5BdkOX?=
 =?us-ascii?Q?C9ZlLyOkJEAQIVW7Fxt3UxTrRHQnsQsprLx9fc2dJgRy9QmwegMYp04Je29d?=
 =?us-ascii?Q?bHYlqzYFV/DBD5BA86dtNN+tQI6t4ntB/Fzkzd6sejL8M8IoCNeT90Uq0WUi?=
 =?us-ascii?Q?EqAq8GzTsZ7r7STaRdgnxuivAdOCSq555IK1IP5JVgVeatbnKMwMfB5fIbbM?=
 =?us-ascii?Q?A7EY9fWe7IGopJFq0e4lp+iB2emipqv/pc/iHIetijEJM+hufHo7DDP+h+y0?=
 =?us-ascii?Q?goSeX5G7raY6QcOebJbVis4iuA/AWmHlE7d3XyNYzDKEGOVNeQ6Je7XBxnYj?=
 =?us-ascii?Q?LsOV0fX+B/m9YuUURRDRLr/HjknlhRYuwChqsoK0hO4EgUDSete4e2XObSIj?=
 =?us-ascii?Q?FKFmeyCpsS6BqsywrbyslnfV5RrEXjI6SPf0/rSzSBDw48H9KJikiCgZ4JA0?=
 =?us-ascii?Q?nHWzLw1XnWKe/2lcLLIw7ezwgK3ATxdUXCCL/cOuldgsVKjcSEcTKkhgyF2D?=
 =?us-ascii?Q?wgSFgKZ0+OI5XMNg/IklblP4dkqOUyS0zYPyLbXVpkx09ZcwNZY8fxFWe03U?=
 =?us-ascii?Q?yC+1afzefeq3QKWlq3kZYaBMPyXFPGs9XE6+x0lyL9MZr9TLzIDQlSiTsMD5?=
 =?us-ascii?Q?LhnlRlqI4CMOVL8Sm5gk4kcS4zda7zUPe8Q3+juzOS544wRgtZOy1XuZXYP1?=
 =?us-ascii?Q?rDM7d0JApJLHMbkDi6eRtAhD9zznKX4RPYGUi3U05sDLIrJcYkLn8YuU2hDE?=
 =?us-ascii?Q?tt4RtsxS0VyRDfi8Q0P06xIjusl9rlz4aBd86ILf5wPgCBsr55lfZW52rquo?=
 =?us-ascii?Q?lGTazr3WoQWFi9lI+zEUn4pzeswiW/A=3D?=
X-Exchange-RoutingPolicyChecked:
	QxfwMmAeuTOemvHyWzSSMbQIXbZTgRZfWNvWKPwDg5Zf50OnqNHoVHsiz/6VjQAwghG97bLqRu47unFwJi6GN55dwkClf1FK/ZDYmIKkcRxpNetAlshCxUCyjUENqBC7FZxjGE6H83JKOzqYwideYi6JTjATpVoF95UgGlWgnmQR5hEgN6ZhG0/Ummx87TDWPP7BdVsChH1+CngLn2UNastMoWijek7op/SuiorUffoIqR2c3jdmJ7cBGizMiE1BKcD3Lvhv4cQ26odfktvlg15b+ve2XeJxYK1NIVMgP/YXHYSGU9zvgeUHsmu3f9WHoBvZzS6579761axMUvWTZA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3pQ2/YAoHNYgJBTWHHEzbZGkMWcBmMa+SMsdYlxLDU8dHixqD2dbfyPq3FzfmDjpk/d7M5TPmWqn7wWKXq7MS7IFFXfTihHLyn7Di8jqEnpgyPjAKax2hzrYM/NpMqO8VJedpJHiIuLAePx1C/JMpG1u4iVnfl59FrMJ4gFujWPCDnl1AnPqu49+xN5W8iFJFin1hp/MB47acgmsyF09/agZpCnLIv7XpnSqttn6pUmvqz6P9ZbF9miM5FP5P0xDgjkde1C8u1QLLPMKiUs5npPgjBkLc+RdSEFxH1b3wamoaX+k8V/Gmt1vk0CU6yu/rmEy3RsCqNHJtc80NGdpG8BJ6VzC3QrrdR0S9TCePA6qB8ou6efJkgUFBIqvr+X1J/aqpmivC6yXffA8+vHNv+D6/ibjg1rjNQhvkNS0BVrggHpQ5mmwkEbghAC0ObPjNbpW3CQ6BytdYVjLRw+/d3y0aVI6GyOkRhT5w+b6AGSjazZtSJ5/ee3URdTYxujl3uXL8ZlyqpV8Y8/NDTD/n3Ixv2bRLWuf6WmagmkGdFrIXPFtAUYGzTXRIqTfemGV1RK/UjKZMbaMMrQKVFccsIxbUKYJUnsLqZg2+v6t4lg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164363fc-e30d-467c-b9e6-08dee89e018c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:26.3034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DlBbsTDqq++bp+n4ykQda71Pgs/2iINgDKobqKsnsAIhbg/89sqVn/16A7VyTUe2eBWUz0AbcynP1yfaJ47JMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-ORIG-GUID: BArE5DTmzRXxiApczFu_OOifDIaoDD-M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX3BICzyrYOKnj
 kMUrIBY+K2WfqaQPRdQY4upYlNqzJAEYzL/GkiPFOzXo9BPzU99FBzRclbnjXSoWw0g0K0fjn3A
 TVyszV2JtRpdHOHtjWV+wDEAixXPbUOY3xWQJ7gzNVdAcMikEF3BM2a3iuFiLb2nY9umoNoi5E/
 gUW8qzmfp1QVMCY6ON3V1y50YTgolYWCcSJmjSUEfmTQiWtemZHQqfMmEwG+2f/GOpncf1y1BBg
 rcCwX88CsawexDlzSafkziPRF3FnD79sroYVY57+OpV7xrYhq1TNuAU0qYszYaIoUQhpZ2+yozF
 CDy3Pf2slQ+fuXAoT+KS0pw3kP9M5bYFRbDQj4Skgxryeq0Vg5VQFqOacFRPPHS4fuhCvwW3Qwf
 bwE1v2Sw8a1iclXRlRef6UIOhsY8ALbE97Kj7f8A/Z7nxVn0U623WmZdZcs+zrqfqcGEk5VeeCJ
 eZBQ33ddJYaVvUZYWq/8PyZHPV61TuJRmU3tdkjM=
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61e0db b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=UnEsLBAWqG5TZJypXWwA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-GUID: BArE5DTmzRXxiApczFu_OOifDIaoDD-M
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX5FeUAA7Zqw3a
 ARQ9qtHIZTFD/QRPQFJSFiUu/sVqNdQ9Pd5+UgSnW5Fb/me4kvSy/Aa3fkV3h262GsZBgzeLFGt
 tiNIrNRqlNlB+LHCuASCLq2LG5tK4sUci9svgAHvW7pKvSyqowK0

From: John Garry <john.garry@linux.dev>

Add support to attach a multipath disk.

We still allocate the gendisk per path, and this is required for the
per-path submission. However, those gendisks are marked as hidden. Those
disks are named sdX:Y, where X is the multipath disk index and Y is the
per-path index.

A global list of sd_mpath_disks is kept for matching scsi_device's.

The multipath gendisk has the name and disk->major/minor set to minic a
scsi_disk.

The following is an example of relevant scsi_disk and block sysfs
directories:

$ ls -l /sys/block/ | grep sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc -> ../devices/virtual/scsi_mpath_disk/0/sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc:0 -> ../devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:02 sdc:1 -> ../devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 24 16:03 power
drwxr-xr-x   11 root     root             0 Feb 24 16:01 sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 subsystem -> ../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 24 16:01 uevent

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:0 -> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:1 -> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1


$ ls -l /dev/sdc*
brw-rw----    1 root     disk        8,  32 Feb 24 16:01 /dev/sdc
brw-rw----    1 root     disk        8,  33 Feb 24 16:01 /dev/sdc1
brw-rw----    1 root     disk        8,  34 Feb 24 16:01 /dev/sdc2


$ lsblk /dev/sdc
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc               8:32   0  600M  0 disk
|-sdc1            8:33   0    9M  0 part
`-sdc2            8:34   0  568M  0 part

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 425 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 405 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 36c745cbb2619..d5a37b1b312c3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
 #ifdef CONFIG_SCSI_MULTIPATH
+static LIST_HEAD(sd_mpath_disks_list);
+static DEFINE_MUTEX(sd_mpath_disks_lock);
+
 struct sd_mpath_disk {
+	struct device			dev;
+	int				disk_index;
+	int				disk_count;
+	struct list_head		entry;
 	struct scsi_mpath_head		*scsi_mpath_head;
 };
 
 static void sd_mpath_disk_release(struct device *dev)
 {
+	struct sd_mpath_disk *sd_mpath_disk =
+		container_of(dev, struct sd_mpath_disk, dev);
+	struct scsi_mpath_head *scsi_mpath_head =
+		sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	mpath_put_disk(mpath_head);
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+	scsi_mpath_put_head(scsi_mpath_head);
+
+	kfree(sd_mpath_disk);
 }
 
 static const struct class sd_mpath_disk_class = {
@@ -817,7 +835,8 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	ida_free(&sd_index_ida, sdkp->index);
+	if (sdkp->index >= 0)
+		ida_free(&sd_index_ida, sdkp->index);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
 
@@ -4006,6 +4025,91 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
+	struct queue_limits lim;
+	unsigned int memflags;
+	int ret;
+
+	lim = queue_limits_start_update(disk->queue);
+	memflags = blk_mq_freeze_queue(disk->queue);
+
+	lim.logical_block_size = sdkp_lim->logical_block_size;
+	lim.physical_block_size = sdkp_lim->physical_block_size;
+	lim.io_min = sdkp_lim->io_min;
+	lim.io_opt = sdkp_lim->io_opt;
+
+	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
+					disk->disk_name);
+
+	/* TODO: setup integrity limits */
+	lim.max_write_streams = sdkp_lim->max_write_streams;
+	lim.write_stream_granularity = sdkp_lim->write_stream_granularity;
+	ret = queue_limits_commit_update(disk->queue, &lim);
+
+	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
+
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	return ret;
+}
+static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	if (!get_device(&sd_mpath_disk->dev))
+		return -ENXIO;
+	return 0;
+}
+
+static void sd_mpath_put_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	put_device(&sd_mpath_disk->dev);
+}
+
+static struct sd_mpath_disk *sd_mpath_find_disk(
+			struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct sd_mpath_disk *sd_mpath_disk;
+	int ret;
+
+	list_for_each_entry(sd_mpath_disk, &sd_mpath_disks_list, entry) {
+		ret = sd_mpath_get_disk(sd_mpath_disk);
+		if (ret)
+			continue;
+
+		if (sd_mpath_disk->scsi_mpath_head == scsi_mpath_head)
+			return sd_mpath_disk;
+
+		sd_mpath_put_disk(sd_mpath_disk);
+	}
+
+	return NULL;
+}
+
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head =
+				sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	int ret;
+
+	ret = mpath_add_device(mpath_device, mpath_head, sdkp->disk,
+		dev_to_node(sdp->host->dma_dev), &sdp->host->mpath_nr_active);
+	if (ret)
+		return ret;
+	mpath_device_set_live(mpath_device);
+	return 0;
+}
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4035,13 +4139,258 @@ static const struct attribute_group sd_mpath_disk_attr_group = {
 	.attrs		= sd_mpath_disk_attrs,
 };
 
-__maybe_unused
 static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
 	&sd_mpath_disk_attr_group,
 	&mpath_attr_group,
 	NULL
 };
 
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct device *dma_dev = sdp->host->dma_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	char disk_name[DISK_NAME_LEN - 2];
+	struct queue_limits lim;
+	struct gendisk *disk;
+	int error;
+
+	/*
+	 * sd_mpath_disks_list is kept locked if no disk found.
+	 * Otherwise an extra reference is taken.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (sd_mpath_disk) {
+		error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+		if (error < 0) {
+			/*
+			 * Should not happen as would fail for the same when
+			 * allocating the sd_mpath_disk
+			 */
+			sd_mpath_put_disk(sd_mpath_disk);
+			mutex_unlock(&sd_mpath_disks_lock);
+			return error;
+		}
+		sd_mpath_disk->disk_count++;
+		mutex_unlock(&sd_mpath_disks_lock);
+
+		goto found;
+	}
+
+	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
+	if (!sd_mpath_disk) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+
+	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
+	device_initialize(&sd_mpath_disk->dev);
+	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
+
+	blk_set_stacking_limits(&lim);
+	lim.dma_alignment = 3;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+
+	mpath_head->parent = &sd_mpath_disk->dev;
+	mpath_head->drv_module = THIS_MODULE;
+	mpath_head->disk_groups = sd_mpath_disk_attr_groups;
+	error = mpath_alloc_head_disk(mpath_head, &lim,
+				dev_to_node(dma_dev));
+	if (error)
+		goto out_free_disk;
+	disk = mpath_head->disk;
+
+	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
+	if (error < 0) {
+		sdev_printk(KERN_WARNING, sdp, "sd_mpath_probe: memory exhausted.\n");
+		goto out_put_disk;
+	}
+	sd_mpath_disk->disk_index = error;
+	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
+				disk->disk_name, DISK_NAME_LEN);
+	if (error)
+		goto out_free_index;
+
+	error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+	if (error < 0)
+		goto out_free_index;
+
+	/* undone in sd_mpath_disk_release() */
+	scsi_mpath_get_head(scsi_mpath_head);
+
+	error = dev_set_name(&sd_mpath_disk->dev, "scsi_mpath_disk%d",
+				scsi_mpath_head->index);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	error = device_add(&sd_mpath_disk->dev);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	list_add_tail(&sd_mpath_disk->entry, &sd_mpath_disks_list);
+	disk->major = sd_major((sd_mpath_disk->disk_index & 0xf0) >> 4);
+	disk->first_minor = ((sd_mpath_disk->disk_index & 0xf) << 4) |
+				(sd_mpath_disk->disk_index & 0xfff00);
+	disk->minors = SD_MINORS;
+
+	sd_mpath_disk->disk_count = 1;
+	mutex_unlock(&sd_mpath_disks_lock);
+found:
+	sdkp->sd_mpath_disk = sd_mpath_disk;
+	sdkp->disk->flags |= GENHD_FL_HIDDEN;
+	snprintf(sdkp->disk->disk_name, DISK_NAME_LEN, "%s:%d",
+		disk_name, scsi_mpath_dev->index);
+
+	sdkp->index = -1;
+	return 0;
+
+out_free_index:
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+out_put_disk:
+	mpath_put_disk(mpath_head);
+out_free_disk:
+	kfree(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return error;
+}
+
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	bool remove = false;
+
+	mpath_synchronize(mpath_head);
+
+	if (mpath_clear_current_path(mpath_device))
+		mpath_synchronize(mpath_head);
+
+	mpath_delete_device(mpath_device);
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_remove_sysfs_link(mpath_device);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct device *dev = &scsi_mpath_head->dev;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk) {
+		dev_warn(dev, "could not find mpath disk\n");
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	if (sd_mpath_disk->disk_count) {
+		dev_dbg(dev, "non-zero multipath disk count in removal\n");
+		sd_mpath_put_disk(sd_mpath_disk);
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	list_del_init(&sd_mpath_disk->entry);
+	mutex_unlock(&sd_mpath_disks_lock);
+
+	device_del(&sd_mpath_disk->dev);
+	mpath_remove_disk(mpath_head);
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+/*
+ * Always calls for a failed probe, so we need to handle that some structures
+ * have not been setup.
+ */
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_head *scsi_mpath_head;
+	struct mpath_head *mpath_head;
+	bool remove = false;
+
+	if (!sd_mpath_disk)
+		return;
+
+	scsi_mpath_dev = sdp->scsi_mpath_dev;
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	mpath_head = &scsi_mpath_head->mpath_head;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	return;
+}
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+
+}
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+#endif
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -4065,7 +4414,7 @@ static int sd_probe(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
-	int index;
+	int index = -1;
 	int error;
 
 	scsi_autopm_get_device(sdp);
@@ -4094,22 +4443,33 @@ static int sd_probe(struct scsi_device *sdp)
 					 &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
+	sdkp->disk = gd;
+	sdkp->device = sdp;
 
-	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
-	if (index < 0) {
-		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
-		goto out_put;
-	}
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_probe(sdkp);
+		if (error)
+			goto out_put;
+	} else {
+		index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+		if (index < 0) {
+			sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+			goto out_put;
+		}
 
-	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error) {
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
-		goto out_free_index;
+		error = sd_format_disk_name("sd", index, gd->disk_name,
+					DISK_NAME_LEN);
+		if (error) {
+			sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
+			goto out_free_index;
+		}
+		sdkp->index = index;
+
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
 	}
 
-	sdkp->device = sdp;
-	sdkp->disk = gd;
-	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
@@ -4129,6 +4489,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		put_device(&sdkp->disk_dev);
 		put_disk(gd);
 		goto out;
@@ -4136,10 +4497,6 @@ static int sd_probe(struct scsi_device *sdp)
 
 	dev_set_drvdata(dev, sdkp);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
-
 	gd->fops = &sd_fops;
 	gd->private_data = sdkp;
 
@@ -4158,11 +4515,18 @@ static int sd_probe(struct scsi_device *sdp)
 	sd_revalidate_disk(gd);
 	if (sdp->sector_size > PAGE_SIZE) {
 		if (sd_large_pool_create()) {
+			sd_mpath_fail_probe(sdkp);
 			error = -ENOMEM;
 			goto out_free_index;
 		}
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_revalidate_head(sdkp);
+		if (error)
+			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
+	}
+
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
@@ -4177,6 +4541,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
 		if (sdp->sector_size > PAGE_SIZE)
@@ -4184,6 +4549,19 @@ static int sd_probe(struct scsi_device *sdp)
 		goto out;
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_add_disk(sdkp);
+		if (error) {
+			sd_mpath_fail_probe(sdkp);
+			device_del(&sdkp->disk_dev);
+			del_gendisk(sdkp->disk);
+
+			put_disk(sdkp->disk);
+			if (sdp->sector_size > PAGE_SIZE)
+				sd_large_pool_destroy();
+			goto out;
+		}
+	}
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
@@ -4197,7 +4575,8 @@ static int sd_probe(struct scsi_device *sdp)
 	return 0;
 
  out_free_index:
-	ida_free(&sd_index_ida, index);
+	if (index >= 0)
+		ida_free(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -4325,6 +4704,9 @@ static void sd_remove(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_remove(sdkp);
+
 	scsi_autopm_get_device(sdkp->device);
 
 	device_del(&sdkp->disk_dev);
@@ -4493,6 +4875,9 @@ static struct scsi_driver sd_template = {
 	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
+	#ifdef CONFIG_SCSI_MULTIPATH
+	.mpath_remove_head	= sd_mpath_remove_head,
+	#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
-- 
2.43.7

