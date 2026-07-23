Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B91427FB5;
	Thu, 23 Jul 2026 09:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799504; cv=fail; b=HxbTjTic40hFQgBSvoj6mQ+CVbxnBtCcBdV/zafAZQxRYP/AzcamQxKsc6Jx2YiKQrJFpzYqgqTLkTdHZ58bICXO5g2hg40bibzDZiNZw/xWvcLmSbDOao5ebrrTh9a0izvghStiQBEBD8axjgARCw962lWOmxWxsObqG48I8YU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799504; c=relaxed/simple;
	bh=6dk/bl5X2pnQL5rVWS+t4uzwQxmwpjj+ZS5ylE05Z/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D67x/td39sFhWnrk5UZbexK6vXKm58yTyrl6M+vq+YyoK6UD/qxTfXNIf6uZryxSoe8zZLqnM9WvmQYTXAH212gqcPNn3ESGfocKOGdz+9+9rMTWr2kA3Ay6WKX+xh54QKVqlASaDfOOSkH0mhcROFzoUUYzZNrEjrterIu8Ouo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pL20gS7c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cV8faf0d; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pL20gS7c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cV8faf0d"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJthtx3404240;
	Thu, 23 Jul 2026 09:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7tKDf8NymbEIQMyMkfGZdIdTQex5hUC5B+xEwgA+HwU=; b=
	pL20gS7cyMCpo6SEe6CUPyufQ/ua2zpkD6t72rR4w04v4D9ZZL9PFt6rDIxmKEap
	Z9hpUgTuZ2382DGpbZCjVmaNLx1dX6gHKKtF7VkRsbqayJ4K1CaqnDBPLGWeFRlI
	s1NMm+jxxgvwHliavJ5tKXtDnL+q4qruUnHI0PIc4nOtMdrEKVFlj6MC0Q6PFBkK
	Bfni8v9UV4jYR/LUSVeMHiI63VhoxvoWCBvqv7gN+bTMTmc5UEoK8s0+MAiOZQbQ
	t6xoEqJuP7pWjrk2anCCs4Y53mu3IoDE46X+aB/AAwmyO3S3QnioQEkk8q8+FoSS
	Z8hEpASTwRlQF+QhUwiSvA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3pmpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X9SA021175;
	Thu, 23 Jul 2026 09:37:05 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011052.outbound.protection.outlook.com [52.101.57.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y43e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SkKdY4TWV8ZF8Niws7mO6UJFxr4um+E6RgAVs98Hfojrzue6ej0bK19zSem2ZpWTKLAgLx7oxK5Rs2eJPc7S9vfctBx66pZyp0Dnz3apsVJvw5R0G8kU1gXq2dZtXA8n80K0k7wGyk5+xaSIvt0dyX57v029PwSv2nibOqayA4DW5OfEM5Szr7LQSM23QnmyqmyGGS9Db+TYcTSY2QryoiIlFCrcqBHJUG73rIpHrwi3oH+7koxd1wlQ2yFuegWRi08BarHjb34bHClbcdGUaghAgkpgGLSlK2doM7iBec4wEdFaMFuzNdNy7i/Cfu/x8YIEynHOhshhLSXfOciQYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tKDf8NymbEIQMyMkfGZdIdTQex5hUC5B+xEwgA+HwU=;
 b=pjJVaEBoJOKCEIu6Josb9qxgx7gnXogt+ZsUkHykgMjorf9G9JaWIlXawSsn3t12xDyYp9ib4e08zzDfGKCknpLJjUiWuxIQLO2EDq3rdJVXdDkjs4FUCPDGPCdMbCDwGYGCYs3USjlR+McdrDUiN5TjZ3y+dlg6n1742EHp1zsTG5TCGs07ZBK5CV6qrhIGkld04e3wcqy1MCtyp2e/9pYUxNYdnQnVNNUyDXqSclCMrIah8xtNxoQ2+LEFakWol/6yXYlW0HBGPUDvxbvSS/eW/mDRS6RNY1cNYMKLwz1oOoRZgI4QLMtbmLD76lM1dWm4gjwrFUUeJU/n5PLUnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tKDf8NymbEIQMyMkfGZdIdTQex5hUC5B+xEwgA+HwU=;
 b=cV8faf0dT3Jup+zBuD8DKYPYEfqzdOlasrDvfdjklekawbcZ9fi4d+QNHIctu/naI6wtFdwFtxDb+qBi+6Ow5Gz5p2kAE3Sxs94wDqSQZysOhb5DTMGPS6X8Rq51OXk9/WC9NtIDRh9OPh7LMkx4Nbi41JftKo8Fk/hipP4UYkw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:36:59 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:36:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 07/28] libmultipath: Add sysfs helpers
Date: Thu, 23 Jul 2026 09:36:05 +0000
Message-ID: <20260723093627.2327456-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:610:50::25) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d05c9dc-d70b-47f3-77f6-08dee89df174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	fLqTNs/Gfpn4HpmvcaIKY+9HT3D8YWwEG0hHaxhSWE0DG5cttZdcC+PFC4A+7elnp4xqWVTSkvZsS8B77UmMFnuKDanIsiyhO4BA4s71NVK2eluUkGE9Ha94GjwO7Bh239fol65PvNCjbirg6tNcQDx5sgpKUpRP71tKC6hdxv0VrDvybBDJvkeetsSTByw6zmUTESSfBUdtmKP4YnBZUzgTsDm6KcQYxRqU5NVKdAey5dJhM8zv/oB4m67P72UKMXBZ4nZowiD3Bi8eszxeCKKZCYs3O0JD4EaHrbVlbh4qR9vFgVejC2RUFDzfpTbC0UhM2FdbdgJPSCu54uu+PGpmQj1LXs5PGNChnGfiDMOJS1yPeiHVvUVaBpPipg8/Xl9ihj9B71zdkJGM6Bpy/sxJxO4hfDGWl1qkuQOqdmZZDLwVZCNvryHTB0e0kOQLjPYDrvLnkVwnVcNrmMHGhGLskAFg2KPQmGN+FVW4IFabgPWvtgyQ30vMsp9OMOYiuP/394EUAPLiznEwHPVRY92Yhm78XzfiXRRqxE9yx2Qi7YQYQH0ejXE7Vm7Sj6DZG1h/V1HbJyhIOwxWcmdX7WzkLb8FWwPaRTmHTj910SOQ4DLLhisvaciPwawAwnm+dAjOOMKmbGYMqDzeaOJDtB5PsRm3s9Lf54jaLS33BJ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zx3g85KeZeqq7dj8V8VEVtWEtbYHHED4+an5DQSCfJLrkGBwZ0RD0ACiIlbq?=
 =?us-ascii?Q?x8vMHo7DVOqyWxfrKcl3rl13UpLAIU0T5PYuMnUs+GAeHYS5oo/3zBwqcadM?=
 =?us-ascii?Q?2l6VdfBeh/7JC2TqCfUUPAFgFzvCg7Bp6SRtDC89C8jzkPIUxjjGXuL5xEQG?=
 =?us-ascii?Q?agD+zCI9MOWp0+Jpdv73EMB1lkky9twn2QWy369pIwusRKNPNANQoIIobnAK?=
 =?us-ascii?Q?HfyGD8KBNuB0O2vHP+WqGejaRjC/Y0gaktK879bV83cf38TEkJSDNAA2Qr7g?=
 =?us-ascii?Q?B3i74u5CJtttC+9vBY390Is12al1yPdUe1uSFlJ7ab/Ve5GdtBSd6AQ+2L3A?=
 =?us-ascii?Q?T79DsHWoHBr9vcqckMxs9PIMy+omoKOo0RkN3+i8IxI48kvEChdin0AlpPVe?=
 =?us-ascii?Q?MLfyNjO2xZ57+pTMx70Rtq9DMhpUDvd6fZCtcvFECF8Bm2VENkM+VCpd4/AP?=
 =?us-ascii?Q?+lp6YKZ0FE/OOdItBuXgm3S98YSSBpf6nKTTF9Q2Hwsmid2m9WEd13O4ZApH?=
 =?us-ascii?Q?NbPRvt0hXJ8BVXJlSSrEJJBWZfSkQBvjCA8yi+tqToB81ZVQ9mH0tHQdG0OG?=
 =?us-ascii?Q?SJgdVmfDkgmBnhsTGIcLzfk6kTKr5GABUqCXiVDxwZV3PNP2QCe9ZakmyDJD?=
 =?us-ascii?Q?69D1UuYOiOoTx3UuJvxFb8f3rI8C5E4kHcuc03dwb+MgDvYkC0tnpI3Jt2D0?=
 =?us-ascii?Q?k51qmlNqXYqH1Wf9d1a8W0p6IDQdqgNUrqOdZNbG1T9rt5gMZXmtd8Lkjvuw?=
 =?us-ascii?Q?7XY3z+AuTEEiUtIlfUGUVFDOkhkWp05dORXso4DBqRy4NGyeO71vrRi2c8+/?=
 =?us-ascii?Q?3WNP+UPwQgo+XCbT+Z+x9UruqRVmA7i2OakdwTE4decldLHK5Mz/M0ElpGIc?=
 =?us-ascii?Q?jb/m2wIZXmDDmARwX0MZ9fH8nvtycUstrNT54j9u46EvkPnOdJGL6X+ONUah?=
 =?us-ascii?Q?fIWqK13VVXt/eJT8NO0zHiGKEz5774Myq1aea9mlITH8yLvTk4yxRfi78PMl?=
 =?us-ascii?Q?3sqoPUU575tkTLlRIXgxvArG5M09tyIbXUEZCD9SxCyTxO8TbTOXFK9NLZ2k?=
 =?us-ascii?Q?dpFaIrhw7J3YHO4TBG8uOzr1umar0AFlWRdBi9tgkDIKmDQ4kLeV8hZyyUhG?=
 =?us-ascii?Q?+koKZix7pfeXvZJzbfQPRbT/g26Dpa/3W67FvQb0TPyMDeQlTypfUa5NgOKu?=
 =?us-ascii?Q?zZGy44/EF50JorVndnB4hSvinmCjnEpdoJ4ALJtTcn0EuW6oOLBFCRlEIo0I?=
 =?us-ascii?Q?2TCAbGksmqB0LTo88+djqBwwLy3RtptnHuTQ2qXZdp0J35J1yR2xAtEHBTU7?=
 =?us-ascii?Q?WFPNviCVWUcbDUnc/aubm9kqGngpQsb1gzD6XKC7GJslU2wGWaW3hMIEErfM?=
 =?us-ascii?Q?JiGbkLfJduoUlBmkI20CagSlG+dWQxA9NjAahM+w6/NjygMlhW4erQ0iAoPo?=
 =?us-ascii?Q?dS65C0Y/8UeXxeFEJ4t7TK4SlasWHM4zPqqcOiEwQO4tJPOR61wrc3MOtCQq?=
 =?us-ascii?Q?xmzorf84yCkjtI94SCjdKZoH1LIhgZmInMHNB9Y29D6F/Qy61Vt5tQ6ilshX?=
 =?us-ascii?Q?2Pji7Ir7kejVTk9BIQM7bfaHBuPG+f73FmNnPUIc5t/18FMAAw8XVFbKX53U?=
 =?us-ascii?Q?plSMsH7jIf0pWnfsTZQUBcyL1qhllzo3qn+YhgnI5m8E5P6PH/7fjt4Pb3JZ?=
 =?us-ascii?Q?SDuydURJIMiml5bGeYlOLzP1iapK8Vx7dHoc8srr0qvCzflpI9Bpj1F+Sx2w?=
 =?us-ascii?Q?R8X7odJNKQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	SMLKXQQWrXC4FNyWP4UtLPgAqxi07Cuij0+ynh6hNnisXrlXMMp/W/fg53ISU6q9zL/Fx5oZw6Ea8ZYyN8imWqYA3oC5JjklPJkuXie6okv58v6A5FNi3tzlcB1VqwsMMn41h2HxrO6669fkmLRRg6icIMaKfpBJ9GwbTLJ+7iku/cvhdhmYoZJSf3ylU3kBOmC3jblAAUZfL8uMf9s46umD2oVXsaTOXjXFP48XcrmFcZVAqOnerB6xSM0jpMy3Mp9WumjzPXALBTUd4ZjHKMC688zgQTBJTW+GmOiSdPypISqtSKGuk4qgVjfkpDmS+cGwVQJdfbKsdN7kqnVMiQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	49ocVoviJCY1P2U/rktdc3uumD2uRAhZwtwtiJ844RJRo4/VQxmSWVbZi07u33LaQ7JOckjEzRk1p5Ji+9uPAP+sLN1Dl2L7F2/4jWOAQZvWLAhcWrgT1dG1UC/EPzJtZiGsLOEwMlDkqNpeMrviyjoeOJhyyd18wHfLWmptSPR6St2/7c1ODsRQQBp2Obke0APdYe2a61PcOyU63gf2JI+i86IIkL1UDMqEPvKIbQX0CKZWt36gFEQdZenMRfRiBxpyF+6Xemm8tSnB+gTX5DaEr6HLPJEt6M/rY7dONbZYHc+T42uhDLoqZcNEbtm+YzCBg+wpH2i0R8Pju95MK47+mCua1FZHfDMXyJ9ISxYODYx01i4BIknDeEGoi7TqXO+GbrravW9vYjnJLzbv3JHgZcVpIiJJu9qkSVIdKAX0F/NPLLYx9tNuniMjHA+EjxlAGJyYwobnOHKB36cwhZ8tO6SHikBLZA0u5lTNN/du4OcRHXJoogn5ZncNE1BfU5kLwB4WkaHR0h2WEHgY2rAg5N2McrVL2uBi/0HGbL3zFmsFL4Y2Sp2G9eN6iqFY/tMTDFkYP6jLJuBpraaCqLeBdwiNKM54NBqLdi/4pgg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d05c9dc-d70b-47f3-77f6-08dee89df174
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:36:59.4058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HT7WgBL8b47E4MIEDSTlA+iBzXDHPmnKsN4WqGEQJ3VN+ahibVrmEEFGD/gxisKIinlDedkwelW7H8xby5Bp8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-GUID: so4ErAr2ueb9ZxkeRmRPxE87SfrKBQ0W
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX/nibKC7BngCO
 NSJmJFUyfdcc4Il38CHsYK6OaRJRrSOJWIzUzAU5Vo4zZJvOTjmMVIw1hACCwFzxf90gteB300j
 o7NXTK/uD6IGY6RBHN9j8ETDiAo1XaXkZxErzOSIwlgcdLTrFOAh
X-Proofpoint-ORIG-GUID: so4ErAr2ueb9ZxkeRmRPxE87SfrKBQ0W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX7/viOzm+W1rX
 3J/nMfM3hwFyElCupcJeO4w4e/m7ylBgGL1+S+JLj2r9nS+P2zMj80DTqfASiBvuIkU8EwDiSWD
 3QxPZ4GntBVpWM35UzEEHQD2bWgp8VR9biWbTOHLgOClVkXJCv9WblarSwLIHSLkuaxLkTdi3Rb
 5AD+pAOU6Q68LuIYlJjpyVKKb5uS/egYyp71Fr6A66wVGAjA+MbBv2LOgzePLpyATroreKq2RjG
 bfiFsPZjIu1Eu2HzcfnIVlA4aQVfvuR75hu2qcEPZ08uw/NVJByEdB2XwQmtS1ItcvonlixdLUU
 9KZ9Y/O7UWMokPH9Op8sL24TPVTIjwvZ7uHKj/1qZOqXrCgwsEk1DpiAdbBiJftHGLf4Xszx0ai
 62YMloXk0jgT53ugJ0xc9JMvchsCSVe5SVbhQ3TV5XLbtlc+p/mWDH2HYTOZl793hEmUh+LmiaG
 azwwtsUdK1FILNFOybg==
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a61e0c2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=JWw5DRbbQmmJTouRsXkA:9

Add helpers for driver sysfs code for the following functionality:
- get/set iopolicy with mpath_iopolicy_store() and mpath_iopolicy_show()
- show device path per NUMA node
- "multipath" attribute group, equivalent to nvme_ns_mpath_attr_group
- device groups attribute array, similar to nvme_ns_attr_groups but not
  containing NVMe members.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  5 +++
 lib/multipath.c           | 94 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 44e26c16b3dc4..4dff0911c2002 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,6 +7,8 @@
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
+extern const struct attribute_group mpath_attr_group;
+extern const struct attribute_group *mpath_device_groups[];
 
 enum mpath_iopolicy_e {
 	MPATH_IOPOLICY_NUMA,
@@ -120,6 +122,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
 bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device, char *buf);
+ssize_t mpath_iopolicy_show(enum mpath_iopolicy_e *iopolicy, char *buf);
+bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy, const char *buf);
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 			char *buf);
 ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
diff --git a/lib/multipath.c b/lib/multipath.c
index 1fa4bd6677051..3ff4f42a096c2 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -616,6 +616,100 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static bool multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return is_mpath_disk(disk);
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(multipath_sysfs)
+
+const struct attribute_group mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(multipath_sysfs),
+};
+EXPORT_SYMBOL_GPL(mpath_attr_group);
+
+const struct attribute_group *mpath_device_groups[] = {
+	&mpath_attr_group,
+	NULL
+};
+EXPORT_SYMBOL_GPL(mpath_device_groups);
+
+ssize_t mpath_iopolicy_show(enum mpath_iopolicy_e *iopolicy, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+		mpath_iopolicy_names[READ_ONCE(*iopolicy)]);
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_show);
+
+static void mpath_iopolicy_update(enum mpath_iopolicy_e *iopolicy,
+		int new)
+{
+	int old = READ_ONCE(*iopolicy);
+
+	if (old == new)
+		return;
+
+	WRITE_ONCE(*iopolicy, new);
+
+	pr_info("iopolicy changed from %s to %s\n",
+		mpath_iopolicy_names[old],
+		mpath_iopolicy_names[new]);
+}
+
+bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy, const char *buf)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
+		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
+			mpath_iopolicy_update(iopolicy, i);
+			return true;
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_store);
+
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int node, srcu_idx;
+	nodemask_t numa_nodes;
+	struct mpath_device *current_mpath_dev;
+
+	if (mpath_read_iopolicy(mpath_head) != MPATH_IOPOLICY_NUMA)
+		return 0;
+
+	nodes_clear(numa_nodes);
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	for_each_node(node) {
+		current_mpath_dev =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+		if (current_mpath_dev == mpath_device)
+			node_set(node, numa_nodes);
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&numa_nodes));
+}
+EXPORT_SYMBOL_GPL(mpath_numa_nodes_show);
+
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 					char *buf)
 {
-- 
2.43.7

