Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA043CDBC0;
	Fri,  3 Jul 2026 10:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074900; cv=fail; b=ZgkVmab3TVI7w7EAZLzcPwl+TL1lO5StMie8/9rCf/DQoHRAPROBB8cfnADHLEY17W3kwjKOrXT3w9+xS/51Avs6Bv+SZIT2MyDTj49pCOHmTfEzMk9/ZiFJTbfE5iVLntxusMZXKdPceENvy4H5WF/6DekLFWjmEZWdvS2zfVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074900; c=relaxed/simple;
	bh=inpAOdQi4vqjfNCJaHWm0Lq1RZE+PBtEGW162g0FKHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cY1/PZsv54CMbkWfN7d0yzl7NMb2vPNpsdz67yGxG4hOm6m47Xo2kd8OusMjeUJoFn42U5VXqvCFIHzDvuX7xPF+b4fs+jB93cQaTUoiHlmZC8oJUBbGl5rLexXorYbr+2RVpj+9BJFR6UiIaXTPcTxd9fjmsF8dJ5szbS2SeK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UV8+qhSs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fRc1pvAc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UV8+qhSs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fRc1pvAc"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfOT3062719;
	Fri, 3 Jul 2026 10:34:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E6zf+j/q1YTRhrnxM+3vX+HPrfMscnUobig9MDbkHEg=; b=
	UV8+qhSsg/34tQhNxraGr9j5FjIbqb1f2aRDUHMgHEUzDqRcxZzJiXIDxVk/ZKO9
	8Imd7neXl+qFdYXoiXkVDigBGL3wm7Tmlvt2BDoc1joPR9rTXj6E3GNKvyXImb2R
	jSNnV1T3xu5nIvcOGUL3cTvCYlzEYMMXN6j5LxcNBKMFEkjTDHmwgB0XMfv/uLCR
	7JEf9TTkQVjeSwqr7ORFDPlGTEHrOUMb0AGy3lYdvPvY1VmuUyII3JYpNVxd4qVF
	9xdHbsYKqRAfcGa/Nw4gWkioWJGhUUX7NOMO7V44q5lUehmNXfkvGG2WIBySlctd
	s2uvywRCln8qMNDoGUJAjQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26n1aeb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXWVi036965;
	Fri, 3 Jul 2026 10:34:43 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f3u20fu17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GMamRqnxWW5nAEjDraDouFiFB9ewSAzN1nhLV7kIU7sR2fjD19K2328hY74fhkc/feyj/m3HEOq42Su029BCKebqUE1ZibOE/6b534Z3FQMtbPjY5/I6GPSB/ZmAvl2ZVTU2LQ2DuROLM99XpKdrtgbIFGVazExVbKC5sl/yg1AFzNBtR2dCFKyfpatzL0ZQFN3P9lUh/1FIdVRNbo2zRkS2sCZSkEjWM/EkpIpm3s7EREj89fIOS0IEnti3s/3XJRzEEvvcTwvuEhNPFaPAVNqCLRfmUrV7180GlGU4Gbj5SCvTksK3VaEeI+qPqXdzb6tB4tpDFHm5+LSiQZVUNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6zf+j/q1YTRhrnxM+3vX+HPrfMscnUobig9MDbkHEg=;
 b=cLCEOaE5IlwLfeSyjVjAJRoG3RRPm9++/sxZre4gHcY+d5u94yL+gPFj5s8dmLzkJbDZX+1wS8QkMexz9abmX+z/aF2FLyWqYcr1ME+EBwhpjgDghQi4oRG1aIMQA4telvvklaVq3GoyY3mTniTkL9E9EMDmhocKZl1RGttdwt993Gui3QV1L9vz9l8laizqTBQgOd1CYU1Kyh++Ll/1LW7tCpPrcBRqobfAOwjo8Hq67YMebcd6cwo/RDt8PVZEvW/ejR6Jm5+TJnNNs5RDYhWbureaJKNziu0mmB4cLASE5LToD76K7JVwfF66IQWtiLd4TXO2qlWQvb6T2IhX3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6zf+j/q1YTRhrnxM+3vX+HPrfMscnUobig9MDbkHEg=;
 b=fRc1pvAcunI3UvB34lbcos22gjuPDZjCtNrUbeKl5Qu4iIbKza4enzTUC3pEEUwQdeLOj5Rbf0kd4uEgkFUKHyFfL/19/xPPx4ng7SiLOq2EOYqsNgTExEiiTG0w22am7VkBH7rnlbYbHQ1XedxMhZdmX8ZX8hQoRg6+AyhItqs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:39 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:39 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 06/17] scsi-multipath: clear path when device is blocked
Date: Fri,  3 Jul 2026 10:33:51 +0000
Message-ID: <20260703103402.3725011-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0010.namprd20.prod.outlook.com
 (2603:10b6:510:23c::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: 45ff0e04-a5af-4c4c-9be7-08ded8eeaf1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	axO4M0J+FhMtQR5Pzcrg8THKY4he1i24i/cT09gilVvpnSsvuOuRzoG6JKrGjrO1j3eEEZ6S+WMaf5zm1dLq3gmfqt48pnx7bG1F3Ow6+6UDHkPAK9UlcwLTnDXKTzrjQlYqjimkUyOlQzUESvIemZCfFN7GE/dyauwb93hjYqHLGL+IyfcTSUSRy8aT+3BT7jJB+DmoPYyXaJ7A0Ql1WhxsUVhGGKcpmbLQN3rqHLGG4Aqp787d9/0tX9VNszux6XQNXd6eymPeA2+l6Y/x7MlGOaPOoUk5aKar96qEANMLxG7OE3QAiEItMNFcLj80iVn3QmbUdWcOVXi9re3V/mXE7EBN/C1dD49i4azJsoLwvAuex7EgSa90jAXLTnLwEuCe3fESetQf3q1KR+TjtW5NrTcqCzqVWvdrZ/eQld33sP23unQgU5Io4YjmOhxf5wRUgOIHkj5x/ULYRzCmaE5+Az+murNZiUSaEvBtwNgNBv1TiB7iKpdi9zJabrwmcESjvOGfzjfbH/5UfDbwzTBr+aXAnSNkJhQff5w97oA32WcuGmHQ9eFRKMj9WEHO9bdSGO/VVjZ+ZCx4sxm1nGNS8+2uENMt9W7dLtiqEPwZnkaEoqEduxhQWx3uy2kSiqtiNOpfOL29oKgC5DLGA/UvBjikvdunMOJmpWU50bw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2h1pIvNeYvFwWGc2NrgbXSWbbK5T1rxZJLNwLektP6S9LgQCtAjZJZcRpylu?=
 =?us-ascii?Q?M1v48jGnZXgyZsZh7Nol9W8a7u0LagCI5RjLLe3PxphGaOdZHSgy8J+MFw4b?=
 =?us-ascii?Q?XvRbx13DJ0zIRUkotX4kXjo31Ne888baSoNktTJ12c60wWEYFrnt8ePWz/Ij?=
 =?us-ascii?Q?HilNk1q5bHFd73hTeW313zMaGXM4lUDMpV+3R0E9vzktJmObRCHDnHZmID0B?=
 =?us-ascii?Q?VU3QxLX3vZsi0mUHqp2DWSOjuw1ps7ZcD5xmktTA7yMUWW8gUkU7hRkIDv2u?=
 =?us-ascii?Q?Lph9dv0+/Ib8f67WuJ7qcRzRPVV77HMgMmyyn9x7m/6/Hx3fCeK22I/atSXv?=
 =?us-ascii?Q?ehGVMIdFTV39hdJAdqfeaYEiq3dDjJQrWdCTXkhCJ7N91LFyjUWGpF/pqtKi?=
 =?us-ascii?Q?Pi/x9I3YShi2xxekkliCKQuRXMYTg8777cSqiAaLk3THmiNK1Zgl2PoRoYdr?=
 =?us-ascii?Q?l6DFd1JqtGZrw91HoI2skOqyYQ1Scok1I14NOFSux02MY/GyBv7x9py43XzC?=
 =?us-ascii?Q?jl5p1oeQ/eG8VpQ7gk+4e4LUQUkluFnCRapgovDdrG2e4x6L3W5MlDNC17LQ?=
 =?us-ascii?Q?+Aqwj7i5Bcn3OgRV/qppm2k3IhGUATvtxeZ2u5U0i2VGBKXk7VDw7uks3tqp?=
 =?us-ascii?Q?LJSt4MPOJwOF8SrU2ur2HSujuHgzGoQC9Mc97FG9nuYugu6D1qkh4EVA1cfG?=
 =?us-ascii?Q?8n0kjiV23RpaXQ9ELsySqtF5xnj9HUso+8JAQWd4N5sXBNgxMrb3sQl9YS5p?=
 =?us-ascii?Q?KUxH175ttJkf6Dn7OstgGzPJt7z70mYbwqVu2sN/oPf2aIXZIFUXibyVOavj?=
 =?us-ascii?Q?pGGNC2VGrI3kWSROSj4TLKk97PtBXIGcxe0Lw1IawA2MuQ6bC0vlQ+IueZHk?=
 =?us-ascii?Q?fKCJoTZEWIFgtfhBHS4fQTjolVxZDyn75Ebwd7wNPngiwTdb5bPFmDHIq2dl?=
 =?us-ascii?Q?rvlxBXVlSfshqvLkpAvbLZzwSX1hgmsTsz2VPEsrPIrmFpd5gQLlUkMZzzCB?=
 =?us-ascii?Q?NbJqda8/qFPoWbyuqcZ9+yCIL7XHh4nQsC7PiZSh7l853b1yt4eEcAhgf8+V?=
 =?us-ascii?Q?/ZkDaXmj53FJqsPAMGnkIktRNcJa2AMFATQfUmCKTJZK2wzNr03ZOdT2Lizl?=
 =?us-ascii?Q?35lQY+j/e0lv8Dh+ZQv4dzyrgceWhLaUdHOJHnzBoUxXUzxCnTtMg+YuRBO/?=
 =?us-ascii?Q?c6OE2l5X9+BoawtrWPGVdWRA29tI3dVo8BiTdOrAzMl5IYXGN8XKcAWf0te7?=
 =?us-ascii?Q?3eKmoIx2hhNC7+fKqhwIgkfYckAFQV9EwWEKJ2F6XVAR39b+7xjB1pZw9uO3?=
 =?us-ascii?Q?qTszYi3cc/XOBFz5Cu5Zd+5JmT1fePdIVZ5171t+/0TIK1bvUYDnJIcZcCbg?=
 =?us-ascii?Q?O9H7XDlBVB/VsJrFMTJP089p7YT0xFLo38LpSVCuRDH1VC5sRWPslWPM0Mq7?=
 =?us-ascii?Q?/c2c79yQc1oPy0yfKkRGZEpa/Z2JzWLPXl7MqiTx55xzr7EuYrSUeY7rIRNZ?=
 =?us-ascii?Q?Vj5FQL74uC+DRvecYxVKPpbyjvsJbwcaQ9ATPIkO57C+wKnhL12rClu56G2+?=
 =?us-ascii?Q?ynD/CKsZiiwl6n4ybgoO0rsLm5Sy72u1fgMnqxC4vckBVx1bfpsaxOfG8+j+?=
 =?us-ascii?Q?Pazah1d9C2Gp1Nz5U5YUvYQ/fyMIsyztlJ1ZnGEvo8ghMWQPamm/BFT6vVeS?=
 =?us-ascii?Q?T32uLsdAg9Iq2cZ3BD9rxj8jm2ERY5AQR9CuRUM37dFUwhX+exveY8TVdkAG?=
 =?us-ascii?Q?yeZ2o/lZO2JhBtdRrtnJOtEsvkLfw70=3D?=
X-Exchange-RoutingPolicyChecked:
	WATqKHsgPcJbImiTRJV1gM3fYwbdbrJR/wu75O2tQwH5+63/bezMoTkIVJ/YIELI80+UlIDi38HNngbZ+CVXWaCxQGIR2nQxorB/d3Q50xGBqtmr0aFrACM5y1t2k8kVaEWLwrdL4TqjyKBw1io3KovG49fpead3meqhmm+v1einug4sN5mnxSLzG76ueXnIXhmVV5cl/dpMcabxF6WymrM16uY3BLAFtyU/wqu6DExa+vGeiTW2DXL/jy9Koxd/PzwNdN7K5KTU/hEamWDFNs4QGbgdQSa3m74lZc80EyCGT11ki3Odpu2xShfSyElGw4fDyQYJFgEAjgTDXJNFPA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l5RWoVMnVJLtnsiNNZfr92pp7o+enTenr43D8c7ulIzpyajRerxT8Fqb0tUYztsIHV0LTcYK3cyCEEX7LFiTb6zh/MJ7SaLCPiGqbUpdRIplCJYa3dsHl56dtuQnP5Nc/PUZShWph/hB/n8Dzhk/ZQhHPnXM72saWQhOvMb28qKcwrRageiScMyQu+S+vJrHyJ0JcZwYKNCi5F1UK3Dt3Tx0lSul4w6tpQmASbxIfT5q87vgm7weOF0+bOfe9A44qFre/b7uJErfQ3PtoC69bWdWmYCe/pvICtRlu4EdxM8nBRMm6/dSXFY9tDj65yHN9CbrmbkY7b0A8xlAsiJgZtJK9+nQ9E5C2w8ArLamKSMI/+fGo8OB6ra2v+6sEiPFnCc7eVJ/Zih1awJw2HH/8N5u+Qny8ARIOEgC+ZEUURmanD9LxjVsh2+nPIRfUq7Ng/6s8XdWUTZ1qQ11faEpc3qjErkIyQn4LtzRp6Et6ImugjGksuDKrTbUtCp+F26Rdu3C/8EqnsCBJofJcqk8LBmnP0AcKzfRkVBYtO0C+WxtJaOTPikQ0kCwHCtRPuGEtS7hoZ1GpI5UhY6aOdD4LBUPL+s5r0Y8AP8HD3bd5Rk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ff0e04-a5af-4c4c-9be7-08ded8eeaf1f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:38.8238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0CI6lztDHDWOanSje6uvqXvZBS3covJHQu99T6aHTVLqDjy4Kdmg3+oOL6Rb8leloLGDrJ9qp9kUlph+x5zufA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-GUID: kO9-nAun06TyRCTQbEB73Ho5R8ErFoaB
X-Authority-Analysis: v=2.4 cv=FvI1OWrq c=1 sm=1 tr=0 ts=6a479044 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=kQY_DWcjttSAKOrtr3gA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313
X-Proofpoint-ORIG-GUID: kO9-nAun06TyRCTQbEB73Ho5R8ErFoaB
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX1Zt3efY3UqpJ
 wWQZ2JfmG7cuMQUVPA7N/JY3gPN6jCO08Gv6FSc8wQqwtCJdh9Tipmk/LfjYgJIYGdRLKZDymzj
 xQkQO639qgiNImpvTD1fEIxFzbi9KO/YrIIBU8eopS426gxhFP4/
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX7JCNIgNItXHH
 y5aGc6g6emg8bP+7/G3SydeCKO6L08lA2e1JXhqBYcdr4QFCeD7cdiyJV9p74GfQ5elcPm/d7MS
 uypdFir4R7EQ7YT3f626yVP5mzSnflfGq61Cd/Mg/8uSJ0YG/ViWSEYT15Y8QcBzQB0knUdXdIc
 ylDZjfyWxrmmGMXkm8EEiyfPVUs/hdcKs+fu6t2MbMKG17iu644WKzDBC3XHU83LCNA1Lfi9h3Z
 +cttJfZnpfmcT87QZOfQsuBIQr+ihTVmmUf9YibLtY+zlmw4Vk+MuAsKS14jZZphPR2MHbmluct
 2nQ7fGwyxnOIfxhgqcESAQa6jtPpx/QFx+qUaGJ5WDxps+53mp6+loR5BavQLrW1IV79TUxxqWt
 WBPGAXrgQZ8rE6qG0JCsJSQ+Dg529ux0I56d/d8PpmEk2yyLGR/nef9whsrN1FvWEPRpKPKthOG
 Ai7D51AaYon0l9A4vbO8RHkYg/Q9K3uGdaN2azUA=

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked, and call from __scsi_internal_device_block_nowait().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  3 +++
 drivers/scsi/scsi_multipath.c | 11 +++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 22e2e3223440d..cc34253c467a2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -34,6 +34,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_dh.h>
 
 #include <trace/events/scsi.h>
@@ -2931,6 +2932,8 @@ EXPORT_SYMBOL(scsi_target_resume);
 
 static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
 {
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
 	if (scsi_device_set_state(sdev, SDEV_BLOCK))
 		return scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
 
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index ca4ab720c19af..0f3f3f9fa5fae 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -113,6 +113,17 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
 }
 static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
 
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	if (mpath_clear_current_path(mpath_device))
+		mpath_synchronize(mpath_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_dev_clear_path);
+
 static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 5cc37acaa664f..d8644d6261992 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -49,6 +49,7 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
@@ -80,6 +81,10 @@ void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
 static inline
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
+static inline
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 	return 0;
-- 
2.43.7

