Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6E93CAA2F;
	Fri,  3 Jul 2026 10:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074897; cv=fail; b=Mk5AoKtZOxN480Y+k7aO2emN4BlDWwyyO1cwrFab0sIV3mc2AlPU9yZDZcB9I6QLImJ8fe3mkIzno19k2SczXa8EsX1QYGQYUUhHmZPmDPWfAkPM6dr5hiL3dRzqVNcRNtKsygoxiDrAYdhAzzdhF9DAJ2tRZjQVDhptcHU5xio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074897; c=relaxed/simple;
	bh=U4J4qJF+delDFbJPsi/GdJmNcl7s5tQ/1r7/dRh72ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rPYt3XrcmE+yExad18l5Ou119ri1WEYUa2fT3LpLPeRsRObvETTKUXpqPmVBLbV0oOQFsbkHCDI4mGE2p1SBmsps8+aBUcl5/SIBHlJuhFjL9Nnk69vhurTlKCIaXqwNNJ0Ams2+pMY6ojiLUSAcrByzKSvsp630Bwt0sYCGVjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lFi8AFkL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xn9zb01d; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lFi8AFkL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xn9zb01d"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638u4Jh3081231;
	Fri, 3 Jul 2026 10:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J8ir3KFszEsFbrt/KIytQGkNrr717NBhefD3L5jE/qI=; b=
	lFi8AFkL1p8mqtww+PTHLA6KYe0+aFWLi8t0S3YL/fvqlUALd2YeM4cwVdg12mbQ
	gj5pR5WuLH83JI8KWRORbpFr2fBrpZtOUcbovhBe2ICb4y50lIHG8j1tevnxK5Cw
	J4Hk2+UHG8L+Cdev8BzsWCrT7i7Jrp8flYPPPT/PcQL4DaCehjV+PAhR9UdA3mDl
	6HSyaDlNlYKCJsDwPFpyresVn7fAbpUYNbDLG3xF/c/Geur5R33hc4dEDor5gMi3
	6iF6HwKSA+GxoyLbt/JaW68EQXcMyF3IC/IipMGP+X0ayYAYCkjA6dlt7LmtC+5V
	ev1EOfx4+/XbVoZ476jcjg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqahwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXTcs019323;
	Fri, 3 Jul 2026 10:34:40 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yu87h6-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HlgSY85T+obHbGdoFmBcU6S66W+CJIZs4SeqAYj1ZqGSQ/uZzmuLfiPc4+6z4c9yM/1N+9HfmmkK6lYiOsgnlAt3sP4S7Bxq+v9OmCCDqQv2QaY/JQ4gKlF2i7enqxDwnSdC7RNdg/0yVTxc5fjvC7CIOMhbE1LlNEsOtpxqxnzpLr/i7LAPqMebBFXFkDkKJu73eqPDYPIU2NPJgaeGUe9ei5NSQMUo+0dVdTiWAlpGXqdIaFcRNsSlBX+Dq6+uFZyqYQoH0KvJqDPQlF683w1UQp5w1kzq+wkqWlLhVh9MtytcCyquWmwBeJRvl8w4B1pwdkYguBUUq82Ltxq9KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J8ir3KFszEsFbrt/KIytQGkNrr717NBhefD3L5jE/qI=;
 b=KUl0gdVd7HmMVTzBzFT4SdpofcLxEuToN1knMmSFWV0X6jaEfhS5zV0y7zyH8FTW5cB69gRK8U9TO9dtDz2eV0zKT8VEQjWxh67HpM2t6vmKI5FoBklHyxl6iz/nBlGZub6GiaYABbC1W8TUUqndDIPo3Yd5ZQ7u6xl3trzPQtquwvZbukJwaxuBy10aawBbYzcUdnau/pcbV6Ouw419zq9Vi+hFNpwvx9rjitmwKgUwod4NKrZMk6OGzqiq2gnQxpUKt6maZwZ7qdRMmOWab/O9nUZy+cq5ssclBHDsRRLNWX5aydKuaDnyjAzpcNZ7WfSo7pTS/EDt2x3WwNCYOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8ir3KFszEsFbrt/KIytQGkNrr717NBhefD3L5jE/qI=;
 b=xn9zb01dwBzj8jqNdC2HLONcDVeGbHdiZ4FK32tKw+Jw9Okw5utFMAHMUbRi46v48V05VhmOhB2L2uilA0dVaEeuOdnINP8fDk08TARTAteI4SJ/G/I6bj+IMMWoLrE2CsPcvCADA9BBpOaqrJW+mZyACsnH5JpEwpC5fmo8Pto=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:36 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:36 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 05/17] scsi-multipath: clone each bio
Date: Fri,  3 Jul 2026 10:33:50 +0000
Message-ID: <20260703103402.3725011-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0020.namprd20.prod.outlook.com
 (2603:10b6:510:23c::21) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: e4f6bd74-d83e-4946-96a3-08ded8eeadbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	MKfjcWkA9CEZ1htYHWimd+rcPxjyoHBf/oi6z36wefbBehKxt5UH8SOWEC+SUvg5jpIleodnv0AX6t3VPZF5mznxTh0DHi4uFjIK/4ViKtcUS0kvESEZdiIqyeUwWkNyOi2bQ29dpVBgxwzG9IO5j1a4ikzqBJCF9kAC1Ivjlbh6eqjLlF+U8Ha0puEk71RQEYwoZ5zF5IVmjGUmJ85kRUHEELqQXTK3ihGZlT4EXY/pxbWUKYRBBWDNh69aho1Kz19+23HMBB477J+xiovCTxEuJ/QfpSfiVuIvhhbNS99yp/4WUHIWWgaCNNLopFPDuwn5TUYa9MKDYyYqISLzFfZWPfj2FvlvbGBWKm7vB1d2KRzeFu5x8AGf08RTmEJTq1XOY7krkuvQUUXmQjC1ggYGNtob8OhzDTb3WmkMf1jd7+X2RIh+nhClLnp7deXK+EkbsedSs+5w5LC8JH5i0+A0Rz6P6nIHOgU9UZ/+GC/lCbW/mjMmBqPCwhV45+JZiEvxLQjC6scTM94jziw87JEd09urPk2p6B7aySV+3g6V317RiNbwUeEnyL8l7IxcKC3890JCTV0+TagQAtHL8wwQANE7O+/mGoumf0IiDU0UjEc7wUB+bfwsWNlJiZ7ItSwmP8lxPuvUj6/9an99kqtLHg0Guo2Wqu6+pqYQULs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xU6hpR55/8nTUnq25D6xYmecm5cnYq5gCkG+QEHHtYL3axAmF+tIuGwiap6n?=
 =?us-ascii?Q?VaE7WHNY3kWF9nPPz039qrs1+r1l10xEdudbiJOjjt+q9wr2WMPYNJfo0spP?=
 =?us-ascii?Q?IwX0R0GbE8o0HLFfhjYjtigX7DsvA7MfKkUUdcVcR3NrAd/ekuxEUAdKcx5E?=
 =?us-ascii?Q?HJ7hsXSSM9u87vgopowtQKD4n0xodCTbUXtn4twLQdrHUCnOfYYXiZcdWEvo?=
 =?us-ascii?Q?xwZRkIl1/t4zoepURGmzjPy5jrvmmKX49lVTymoTnnogTkY/y6oTB17IqgTY?=
 =?us-ascii?Q?mDhPM3VTS8UXbCu882Qb1fZRAqvsGfyeN9xHEY4COvSLl16lSuW8yLsk8sq0?=
 =?us-ascii?Q?9o89oyDEa5wc7BYocT53nAS82vdfVbREbKkFpaE+VkfhgJeBsBkkGVndPmh0?=
 =?us-ascii?Q?4Fpp9UFHOiMAMKx2hIPjPFt6HSlAAmXdS5ZPOob/wytyIEuL/mN4QqmANw5U?=
 =?us-ascii?Q?5pRGGbXKEzslT1mJRvntPfkJMEHaHaGtTKRL5w6hXenvF4d1w1lg+xryUHJJ?=
 =?us-ascii?Q?bPdFuEgDQtOy4LPdi3FRBEsE7wAV3STV5OdMFFN+STGoVlrqg9S0WG4bqGGp?=
 =?us-ascii?Q?CzT91Ov1rlthJKECyp6ZT10tikyHVyNzN1KGsqhX5387m85OPzLOv019+Omo?=
 =?us-ascii?Q?fOMNz9YhsfAerpVNiKS4wF9Qd3CNi4FukdvAvE0Wp3mpYazPYLdVhqPBnV/3?=
 =?us-ascii?Q?+oeK0CAPbyZzF+bjVLnRYZe7/7AxNivanewTWgtZFNAx+Wlqj4x/wP/Ks8sV?=
 =?us-ascii?Q?uGOwTF/bLuuHUG8sn3vyhZGpMgSVlc6RFA7DzlSl3OL8iPzE9Hl7vQTjKq+T?=
 =?us-ascii?Q?c+2qQtUaFtHoVcsgLa+UK9u0VXiFDlQEmPGYXpusr0Eo6K1sqdLfLrnd35bu?=
 =?us-ascii?Q?RHM3NRwNYrluw5P2uoniGN19ZxOP/Gyqt0slWJCfZxpW26FKCIANoZ90oNsZ?=
 =?us-ascii?Q?DrE5/pywqDP/WWiy85zNm6ETo7+C0aXNo38aUVXY0XKqmMYRy6kAQqZH9jZk?=
 =?us-ascii?Q?f3n9jUs8SlMvD0PADRzaD0hOVFIf6IBfnojUjGwPsIr1v03CWRWaEE/+abon?=
 =?us-ascii?Q?+vFuonYcAeacCyJJp7Y4XciK67QempJ7KGrStLPUaWGlpCxg211xINnW8uZl?=
 =?us-ascii?Q?tk0zb6922Qsp2D4jDmUsRoh3mKzoKYGP6JoeR8DiND7PmXe/ukErpmIZTQ66?=
 =?us-ascii?Q?LMGfPRKIpCuS5prkX4b3WnZylik4BmMxgiE4+RMRc5L5yOeDLdgeZQf/Yd1R?=
 =?us-ascii?Q?lDLdimqDYe4tEBsBNHCQI8qU4RsNbFcHWb71IfjcZq4eNDS9nydV7AhyNcz3?=
 =?us-ascii?Q?XRC4/gcauujEVPI0C+JcvTHM6F7Rbl8ES5dTUd6dKvWPgqmavDNzExyk2GN5?=
 =?us-ascii?Q?XOBvAz8AMRvhr2nyuDxcKYpTKbDR5mQqxcAydoBGZ8LN6ba8CeTuYJ/3NqJi?=
 =?us-ascii?Q?pAdfQjkbYR7rpvDTY+783Js9YxpOynNa1FxWjk4K6J1uoFTYrp0jm3S9poWR?=
 =?us-ascii?Q?t42MWGCX2OQGq1QLFWyR+2mzA/joteEs+rC3Q9V2HnE2qR+JE+pDCBF2P2aR?=
 =?us-ascii?Q?MqL57wLUn9LAei7XaTBoLM/ilicAlN3/q8tTL78/XFviiLRLy4JIZgwxN14p?=
 =?us-ascii?Q?Gf0lRkQMClerdYePRGbnTkdSKBAC8v7kwxqGQn6iu890ay5RcHJZF1IfX2El?=
 =?us-ascii?Q?s3dhEyOlky/CIngTCM+Jqo11Hl6hx1BnTZIbjL/PI8hCwMgyzW9xSyZpdegH?=
 =?us-ascii?Q?oUpc+5l9Rb9DO9NMI6t18xqkTMUyDCg=3D?=
X-Exchange-RoutingPolicyChecked:
	gvRiBq8epDbGUWTpiuftG+LI6JMmYcZ8EpkUi3i2/YX/F33rHcg8ZBBl9YrZHJiGd2sW587FTfkfwGEff9JjZnb/FtD8lB4s2+dd5pzHtYeYwU5cbI9XEYjFeUgAU7oZ4f57aXq7XwlPglZAChjOJJ+EEsFe4SOD/5DGMw8vK4CFsVvEbXZWxVHYPqh/bfCwlGhrJCwMSbTMA5UEWfSrGOgTOOoUI9fyFRywl2dEekdckCePG/qIbwQU13RNxXRiWRokIffneWIcKeD+VtCeWyy3XrtbtwoUS0mwmOR8nrZ2IXpjmzYLa6UOKo0+PZlK5qHSDxw+CgoB694j2D2bhQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SRUEupasc5R/xrwZc6/exCy6y8B8D4RZ0uZ5UOTiUGLPpOdJ5NPnc7NSPuSQf7bIG1aZWJed8vviw0kEuGJJ8s11VQswcTto/1ppwSXkV5MES98h6mA68t1SWPrOX1LvRQwF4PUW6lBPJyistSyvFb///DfYT4HCJk7zaGX7vIoCQ+tt88qMYqttCkjO6Kavz9K1lMDYCxGLhfuEOGsm8yOyY3fXb3aWZ06VdWwZ6Z0KQ3B0GaiVmPZxUrZOGrJ02ac2I2r+MWCdWjBgjIJrRsQT4TemExhOITysWlZh3VEsgZ0Hdga/0AAavyPyqK/dREgSczf+R9IFYHwTYsPtn6zBUk7pJ0KRIE3appfPBDlY2mJqbb/uoVPKjvShJ40a0aw5YrPSyvqk/hjV0SsSHCUC2K48vNiLLIlp2AOAcBmoxBk/Jh+snVpK5/bgkXxXbq1/nmTsG8i2PlQ/YiF5tkvp04jMfx5XQUG7ZxX2Jh8JGFVu8CgacVuNCNDfIAJQrcMQ/pyVpm3Sy4yzvjOZBPc9SAsoqssowG48jFmAfUovlSNpN5dkhME7wtdDvPOGpjUc2K+hOebdstzkqmqldr8Wchxb6utStBzi+VvBFVs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f6bd74-d83e-4946-96a3-08ded8eeadbc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:36.5199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ja8BcISmsrykFiSQLFBh+VSI8AABYkkibjrN4abHDZo+uxb0AOVl/wz9RmX4SMXBPrxsLp6fkL09dEZtSmjYWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-ORIG-GUID: aBZDAWfd43q1cialvdM-uSLoXd_yB08S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX4iDRymeQc4FD
 Tq6vikm6qJM+jdCNIly1R6umFAu4kyX81thT9urwBaD24nZgtJTVyKunHJ6k3+U7KZ7aynVaKWC
 zb3VteBvTmcVQivUi4xVx0jtMv7QEl80OZ9sxNzsJFVwOupTwhwUKAg58+/O4+KPArMaDpuYzl8
 zwPvqG6EwMjdOdKdX6fSJKP7CcC/+lxmJIvH3KFj+isP/z4f3uf7rhF/RLcW6bn3ICowV3kqcpl
 h1LD/Ww25bAOPDqqyOgFV+3sqNrXCUWzkSxF6LVabDV5urwbt8QmG3IJreujF14hHmlwLICrcPA
 cdQDBzqvD722v9Tsv3jBJhh8Ec8VyPzIHyI7P4uHu+d4JeCOoEn5Q/Y+9FeYf3dHI4+e+jyXyZP
 ZUFXAQkZfEwTze+ZywcG2QBEvrzdTM0zsyMGo+ka4jS4YebQANtGonLTkMHki8TR8AWBYrI7yCA
 iMD53qnAp269r3PBpHpt3+R74wyc6iixUF4bojz8=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX3CpIrsWr1CpK
 YSjkFRE6Pjsy3eKZw9h/QFN4FXlft5ORwryynzGm/pBkunob1Qc/ifpg8cn0YzQpKlUIfaFAEva
 eCwO55QDbkJdqN5iwEyKsK4HrJ8PUS/5ClgJfxWIU+gnUwUMvMeH
X-Proofpoint-GUID: aBZDAWfd43q1cialvdM-uSLoXd_yB08S
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a479041 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=PbwEKb89bYuBhGpDIggA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312

For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 36 +++++++++++++++++++++++++++++++++--
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 6159803d4cbb8..ca4ab720c19af 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -96,6 +96,7 @@ static void scsi_mpath_head_release(struct device *dev)
 		container_of(dev, struct scsi_mpath_head, dev);
 	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
 
+	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 	mpath_head_uninit(mpath_head);
 	kfree(scsi_mpath_head);
@@ -230,7 +231,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_clone_end_io(struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	master_bio->bi_status = clone->bi_status;
+	bio_put(clone);
+	bio_endio(master_bio);
+}
+
+static struct bio *scsi_mpath_clone_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+	struct bio *clone;
+
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
+				&scsi_mpath_head->bio_pool);
+	if (!clone)
+		return NULL;
+
+	clone->bi_end_io = scsi_mpath_clone_end_io;
+	clone->bi_private = bio;
+
+	return clone;
+}
+
 static struct mpath_head_template smpdt = {
+	.clone_bio = scsi_mpath_clone_bio,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
@@ -244,9 +272,11 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 
 	ida_init(&scsi_mpath_head->ida);
 
-	if (mpath_head_init(&scsi_mpath_head->mpath_head))
+	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
+			0, BIOSET_PERCPU_CACHE))
 		goto out_free;
-
+	if (mpath_head_init(&scsi_mpath_head->mpath_head))
+		goto out_bioset_exit;
 	scsi_mpath_head->mpath_head.mpdt = &smpdt;
 	scsi_mpath_head->mpath_head.iopolicy = &scsi_mpath_head->iopolicy;
 
@@ -270,6 +300,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 out_put_head:
 	mpath_put_head(&scsi_mpath_head->mpath_head);
+out_bioset_exit:
+	bioset_exit(&scsi_mpath_head->bio_pool);
 out_free:
 	kfree(scsi_mpath_head);
 	return NULL;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 2dc02313b0496..5cc37acaa664f 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -26,6 +26,7 @@ struct scsi_mpath_head {
 	struct ida		ida;
 	struct kref		ref;
 	enum mpath_iopolicy_e	iopolicy;
+	struct bio_set		bio_pool;
 	struct device		dev;
 	int			index;
 };
-- 
2.43.7

