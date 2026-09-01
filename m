Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3110647D446;
	Tue,  1 Sep 2026 10:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259619; cv=fail; b=C6GaTQpR45yc+2BGkzsDO2WrDOEKHSXwV6a+TsMxd+BvugMpNnAdbYTZqC39/PSdC7mvJNn0ar5+goU1msoNKMqYroN1ivlj/I6fPUfMnfYXF69Vml5/rJTHekUd9UMzx/X0g0W/9tZCkYCrfvbe2IdUPNsF+vQjt7sdc0x9RKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259619; c=relaxed/simple;
	bh=SzfpWJriGR3KHg6Ac1n6cyUiayNevUn4h/o+13uw5bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M+jLfj0iJoJp6Wm/Vq6c1LSOjUwFTaxChy8qydlI4vRaonDpY23KdXuVIP7dgXqV5Hup2cwh/At+Tx4fNJKZkBKTmfuLUFDbDLQ+aMLAmGzHCkTkAT4rMMia0SZG7TgD4SDtdMGtdEn9ROEdxmkknZZqaG2ZKtuxW1CoWpcLGho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vo7NfqKF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ruga7zqI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vo7NfqKF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ruga7zqI"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VNvo402501643;
	Tue, 1 Sep 2026 10:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cCdtmCk206BC8mTObdvMrFwjOsXH2/2uPTatX84AB7U=; b=
	Vo7NfqKFMuKmJAKaXu9aXA7UlnfjlXdIkp8Ix/VzvbY6x7ByQznEqd6gxRvVs8WD
	4d05/B5vgui2A54LduiHCzo5aWr8WIfeWu/ng0Cr8nMcrkzvh3+aML3ZsDR9FA5w
	z9MXMeFU79d65uvessFlZA09pLH75Bb6+I7MxkW/c7YphLDdp1C3U4msOQBVCJzY
	VhtZlM49U4P69XqRImM3l22DIqIlOildcVnDEtFIx+C1ydQaEYWJtcSEizAHXAW7
	rSyGvUhpYIG6Ciu58BQ5lngNimB+zrvI5Qdfq1pepB9zyG3X1tnM48TIy7l7jyqB
	Sl7UnLafCesYIvrpld6a1A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbnubcbuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681Aja7k001164;
	Tue, 1 Sep 2026 10:46:31 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqac89-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CAjkEk6X4wXjn9WznplOIVVoBaDTcwC41sYyiUi7OxMkNd1MvHqJhmSvUgV66C7L7mDpwZ0PnF4sfSFwLr39w3/P7LGlSo5qE8UFL8IH/J3N6r78hT03phq+wWTH5aO2VH3dXUan7y0vpll3MkysluMme7hQjMNsSh9ipkPsyh/sK5I/brWzGIPwde/UbC+XIocmnws8AJsUZnXL5RGX3EzNUtz9Ys47y+iBG7j/Ra8H7rEFRIpbLd5hA/p6qLWAho4/YUmEhUS47gD00GVdlXAFg+9Fbjm+bkiHR5t5zeqw0nK528oMFKYzbYHYrW7EeakaPJtR7YcynQNDdCGYgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCdtmCk206BC8mTObdvMrFwjOsXH2/2uPTatX84AB7U=;
 b=pL9KE7c1hiZSLf15SGJkpTMhC2jTt7WfzjT44CAoI9Dgm1Z0zvUvxtrBnfsrUzw77exB9QVgeJaZm22o9W712EAFLQrQdbOWYe96y/8cFBPvlHBZstRr38AvIYuXFnIURLyJ5Htf3xa2kJZFwqkRyG9507AbvKXszEsCaXE62OG2BVsmg3Dk0fmZFxxEfm9hr+Kh5+ogosAqL3gpkFqqhSozifhG1Ov2FGB6Ir548kRg91RyjTQzHTskLjYMOTUQZXLT102bfXYDd2u109vErd0fswG+PpdqjgOy/QX2lkDJleMKBqZtWEr2ZV886rx16TjFYShYCd6PSdwxexGykQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCdtmCk206BC8mTObdvMrFwjOsXH2/2uPTatX84AB7U=;
 b=ruga7zqIEmyGzS/RVNq2bcC3rmt0k6HHuvzcO+Z2uQ+ZNza4u6V/ifNxKtJIgvwo1w35/xMYRNmqlCTdCDgebrqYz7xZfzOGF6vunKsqVJp2UYNfIOiINUF3fJdO1Gwg8w/KCu/bqccZ5ql8lZ5p34dXL5IKHZ3uyKJYr6LlzWs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:28 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 25/27] scsi: sd: add mpath_dev file
Date: Tue,  1 Sep 2026 10:45:24 +0000
Message-ID: <20260901104526.3850621-26-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0087.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:328::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: d1ddb36b-1d6a-4bfc-adb6-08df08164717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|6133799003|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	5YqfhedOMUK7McASmuPHeFufGw3+Xh+iF2p38c+Tk7wJjj7dU7g6AbQSkqVUZ+HaKoy2k8o4oVqPwEfmbN5f6hWGNxIJrYxmNsUQcJcJp/Wa6wwJlOpLwWPp08jgLgAGy4t4R59EupEZkJyQ07NPlhrrMxFqwseVyngeMWaVI6UuFM7u6tilgJ+JpQe+D1HTWkQSnj++1/UM1A1gzZTiwynSHfxjYtkd4kRlSD0F+TzVMmYAgEOWc6VO0VbDeGI13dPQGat5jAuYcBUrl2E6IeqllxzhazXIu8X0pK1BoLUlX6R/X1A0Dv7z5ijdMMwBg5otS3VnUyyqpaBwNX5UjuNI8qiqFUXB23vX7kUQ9XRje3cX/xyQE+Cz8aJgH3vzeuslylZXd0oZGzlmN3CTKX9kisHvAiwOkY7mNsBVKTzPEtGJByWpWwJQnOYWb74YDt+oWLZaHpeKf4gIQVJ5/8QNrI9LmIPtB3bCztOCDwszkRxKsGinQJwA9TEKTIQv2N1hc2p9TmBqSNRnTcAxBJUmDmyM9ltHQ68c1y+Qs8H9F65LtL6KkrI52SOJmFycl1JoAE/UXShWFLurvcKRVa4P9flVnHOMH+xGnXfdspCOiUSeBJaPWu2TP2hHENpTGeSzjMBkV7DQDfM3BRgmAfqkFf4t7Vd4enM+6sY2+Oo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(6133799003)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xn9+JrkzDyGt3L8RglTUeX29xrKygsTb8b2rrX59jaEhn5Zt/vfovLICGyty?=
 =?us-ascii?Q?/3q7gN6ilzCEYqZBhTxKzuP6vUjbytAo5VMY6T7QXhgzCyjSd/s2/6QUK6Ae?=
 =?us-ascii?Q?wUamhMF/8w61y2/F3qBnwQZl7ZM/pStzCvpZbt3x17uVqUtpbD/+fluzOdy9?=
 =?us-ascii?Q?1mVDVYRbXrUPgbc0yB9oYpQOQd6JsI3Y8f7dufIgXubq8pHnOlc76OM0r0b9?=
 =?us-ascii?Q?okt2RvP9ibGNTpmZ3wrzfuNwUWduM6Z+gX2XQUb3D7XSz1e8flocfxwsIhcw?=
 =?us-ascii?Q?74Y04S3JIOr0t5PwlGmTkB2KeGF2WaLdv1UEPtNps41siny5EAo4WDDewJhi?=
 =?us-ascii?Q?ZO7tNblmNdDgzgnFOSyXadZmqX/aY3kwopUBSF6Cjo0VW1SlKZAblXs1xCpp?=
 =?us-ascii?Q?VGGXAon9SZxrxM+Ic0iRc/Es2yTzvqQnyXDXc2SavIg3lxoMHXezkMSrPIlq?=
 =?us-ascii?Q?zMMKfBsGUFtJ7US5Dq1UH2pR1KZSK7SGnPcltbXvA2Un0bpNLzvjj7bLreSp?=
 =?us-ascii?Q?xdDjsrKeRNRZ4pcbX8UpjySvKn8rGIaH6wtkxpTTXmCHa5l2YnZyhZIyrO01?=
 =?us-ascii?Q?oreaPRnmWiovtQjrjUOaVI5ZaKr4xdz5l17T8sLizjiCpn/jazpqFQoYoXNA?=
 =?us-ascii?Q?ddqmM6h0OF4SazPxV1Oz3EKOUinu2dvdP7+ygD8U9MEw+w6t8qDoeW9SlCfj?=
 =?us-ascii?Q?Ysfco7FvUgmqA+zm44QgjKQkWYUn4sm0sa+Ln2mlvmcRdJ8wvWGW2ALAaf2S?=
 =?us-ascii?Q?gsvZeclcxOMaGjzgVMavjSHVvuF4cuD+Ko+drJvCePAsVm5Ct/yI26BGCx2A?=
 =?us-ascii?Q?GCgOc52JqR57Emw3qQ7QaqGGpZHzgPHigJfWMZoWpWp4IBfEXekrZMZVnzpJ?=
 =?us-ascii?Q?QZc9SXsp+Sat2Vx2C83QturOd0okJeal0hyY8HhxYpPdepAqwKWdE5XnsF23?=
 =?us-ascii?Q?58jjGDLZCsL1pVcSEK3xlSLca4oA5kvbjW8+BpSl7viJaxxvZ+XuvuNRC5tM?=
 =?us-ascii?Q?WT6V9F0odIocLFC/x+Ouy3sl5RCjKftGonfw3SQyROckBsaHIjlt9Mz5RYa7?=
 =?us-ascii?Q?VE3Sxe6BF/zFzWVtxgyZHIUIvbnzmdkwpwNjKqvVI+FO2CnSReyVS3N/JuwP?=
 =?us-ascii?Q?NPANDzdaYcbrYbxFvxwu2tdfb8dOiBimgVMOMiXrrxfr0qi9HZu33upNQw8q?=
 =?us-ascii?Q?IJWkR29QcjbkY3HFp99ARk9Cc6oWucajdYcbUjoMoGRnxqMyOZWaeLpIbRAj?=
 =?us-ascii?Q?9n+7tl4KpzDrTe+UebzXqqCh7qbkA0W8dFqUNeFc+jBmvvALVOpSOPf4B1EV?=
 =?us-ascii?Q?wlfwQMpd83JSI/pJSxGp1zj0eQiO03Vy3Rdhh+eh2/uHjurfyJ0pOyuCgWme?=
 =?us-ascii?Q?ODx7E5eUk6hx0oQLS1sCIrCWOezE1uQA6Th/0T3LGlyZHeoLGxUXUpWygslA?=
 =?us-ascii?Q?49MwPVk+T1BNCgmZlOnSMwqkGp5qIJ1qCY6/af1hxqv/ytF5Zm0ho/eOO6Bn?=
 =?us-ascii?Q?vk30JM1syFZMWCoIcBd5AA9gwX/TQKLMu3FZlq6E5hMqQOpu8DaI3qLn7TGB?=
 =?us-ascii?Q?Zsz3OooZep06/DzF+53V29wjC/PmMWwDr+h4uJueonRZgQlxHrYIvIFB/UBv?=
 =?us-ascii?Q?3hd+nitVlH+OGJ8JYdG59eM+PbimGeDrTVcyTJi6z46sESwKdXwzfl8NA5sT?=
 =?us-ascii?Q?eMCGqTHSqS12tjqNaAPYccLL7IUdFpmWsl3XhXrvFqpyc0NCXrVuQyfujzsX?=
 =?us-ascii?Q?hSY3DJcq3yiZMjj651EBaJ2B31n7W6c=3D?=
X-Exchange-RoutingPolicyChecked:
	pmr+RCJyrPdRboiIlpR6Tu+1THPHNDDL4GcDKViclz/USe/W8JUtSzGe9QBsZMghtN5YEy5KGQoUf3/rJC2rd5sxfWQwO07lg3GC+G4iNwtELf0BEXeiLLq6kOyF798pCC/ZjMeGCh8UtRbSyufHShos0X1UhZDeAL2NOalFMSXODUPQvx7e/danHsLUaHTlIIm2aBzN0/lj53ewAG6BuszBzGKURh0OE9Ojjt7qWGutpnszprCkP9ZSUDpYLEZPDhYUNR47+akUEvHMH1LRkveUk6tSlDlKnxSw/wm5e4nsx8DyqK12N3F22zTpBd5rsdFm62Bnl0zCrMWq7GBtAA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w2Bcx0zFFLIgQuYNwsXboLk1amaAbG6Y5L6nKt8O6uzlHO+hRsKhvW6zAwFWgs+wZteEIkaHQ2af04iL3Fq0oOtMjp9oRfjTK7DuY2bqjJVJHtGPLmGLALfFitHY+pFiyIFuPhLE+RkIf3NB4C3HgFREi5oWiePzbFf47xwrmipxPblJSpfCygnxQKN4ybXUZqs+5CxbBU9VhncGICqdBXoAp8FfWoiL0QEjlLvG/sYscUryyQVwP8JMY3gXEcS7AU7DYJPEK772ztuFEJcsfLG+z8Kkre00LcRa08L2oqOCWbh2P5YeAkzO5wv2QlAI4BgN54ZB65j9FyaaWCXKcG0LJ4W/FupKUfNEiev/93cygjfyjes3VOQftnYoO3ZYC3eHAbUhveawsDuP6XFYR91IzCNVmpfxwQlFJoDMBLrs6S3FP//ygNkMEaWCrnH9OzR/69ZoBCHG5u4S9HYNwRzz41P16WyQtYiPCgmbNH29IveDxkw+3DRXJDTf4xnJe1jVoLEmiZ+zxFPNTJYBdVTEGDh0l1qRHgairISqiazG/7QVdJ8Ey+LeBZRhbR6q9pthnXkwedQWWrxwO4tzQLa2qKfi085I+Oe1UUPWsmw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ddb36b-1d6a-4bfc-adb6-08df08164717
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:28.6349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8Mr9E5ePLiv7Fof4QwCvr98lF1xb7Jk/35TWhog4NnN3dYWDbuz5EpeyMIH+awdtj7W9Dn/jiPZMjDHk3QHVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Authority-Analysis: v=2.4 cv=QoJuG1yd c=1 sm=1 tr=0 ts=6a96ad08 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=7RnQmdzTPIgLJ45uHnoA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-GUID: SLzBl0Bqlsm9j1eWdxplFArxm51AWH5U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX7dZUYx2edgXw
 n05uLITmMun+RB4omofGQw++SaTNkImsy1i7ryZ+MnZQ4yJDg4vNgRS3+epRBP4z/E3tS+l0F3O
 BnZICSATDtaJ47GRCZmW7qWXLl5+6r7XD6m8hPetSiK0sAo+wtfOFdf27dbzf52l+8UJL2WDIbu
 iJ7Qt5Zzo+/glYPZYR48WpYhk9WnMO2pesumOF6GSEZwBrakti96B5bTnEXI+vOwjMy336oHEYu
 Pi2eDc+DgjI35Rsb5Y27XdCrqY7+a0m9KVh4ld2fKfWmMRXjuCnk3b0swFNEqxA/nLAsy1t4+oh
 sULTxuQIzwGG/ruyWwD64xOoDgnY1I5rR34gbuvzLmzh7fs2B2dsbjpmNGtZbg3Y1gSLeW+Xtv7
 wJ7bignJ4EpN4u1jqcb17a8g2VYa6t1E+zy5+B7YV/7nW5jcS5FCjsceiUH40aoMg+blncw7U+z
 snGgfJEmVcXabutaD7OmEqS+k7LvxhAmrItt39Aw=
X-Proofpoint-ORIG-GUID: SLzBl0Bqlsm9j1eWdxplFArxm51AWH5U
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXwPRkatwBRWxY
 kb2S/WF8zksWeUJAT8+N9lGeIxgiml60uXRS9UdVKVbkGFpS54zXkg4jenDgT8dqYr6xrDgtwY1
 O9lck9K2s38RSLULXOCOsscnu6/KXl656Bit7QbLv6guQJss7iTi

From: John Garry <john.garry@linux.dev>

Add a mpath_dev file so that the multipath disk can be looked up from
per-path scsi_disk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_disk is missing.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 28304a497d8c6..8c79a0ab52575 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4122,6 +4122,77 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 	return 0;
 }
 
+static ssize_t sd_mpath_dev_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct gendisk *disk;
+	char devt_str[13];
+	ssize_t ret = -EINVAL;
+
+	/*
+	 * This attr is for the per-path scsi_disk block device. We need to
+	 * handle the scenario that the multipath disk has been deleted and
+	 * the per-path scsi_disk (and its attr files) is still present.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk)
+		goto out_unlock;
+	if (!sd_mpath_disk->disk_count)
+		goto out_put_disk;
+
+	disk = mpath_head->disk;
+	/* A reference to this disk is held through sd_mpath_disk */
+	if (!disk || !test_bit(GD_ADDED, &disk->state))
+		goto out_put_disk;
+	format_dev_t(devt_str, disk_to_dev(disk)->devt);
+	ret = sysfs_emit(page, "%s\n", devt_str);
+out_put_disk:
+	sd_mpath_put_disk(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return ret;
+}
+static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
+
+static struct attribute *sd_mpath_dev_attrs[] = {
+	&dev_attr_mpath_dev.attr,
+	NULL
+};
+
+static umode_t sd_mpath_dev_attr_is_visible(struct kobject *kobj,
+				struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_device)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group sd_mpath_dev_attr_group = {
+	.is_visible = sd_mpath_dev_attr_is_visible,
+	.attrs = sd_mpath_dev_attrs,
+};
+
+static const struct attribute_group *sd_mpath_dev_groups[] = {
+	&sd_mpath_dev_attr_group,
+	NULL
+};
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4402,6 +4473,8 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 	return 0;
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 
 /**
@@ -4554,7 +4627,7 @@ static int sd_probe(struct scsi_device *sdp)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.7

