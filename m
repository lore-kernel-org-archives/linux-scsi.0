Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA173DA5B4;
	Fri,  3 Jul 2026 10:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074923; cv=fail; b=RhwJA4EgBYKZR3ISQODTBF5JjfDBJbP6ybN4CIEmkK9ihYrzJS8w1yKU3a/nOu33wFGytwe4kbLXWG3+h/ulg0OSYn54sMr4cKATdwe/zksMzmg05vRJma0AzpKi0BL9ffZ7s7N5DCRM5kREoJ+O1kVZFpm2rz4l9hxvAkO1fYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074923; c=relaxed/simple;
	bh=OHO/gaJdBh3USfYo/d0znnP8mEWs62q1JtUTCBQK5JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Rvra0cpJFsc7+pr9WZRZIbB7/7TCbFfraEnx8qq8mNAP8iSha3rNcOT8TcVS0iLcHRVgUiQVpDa5Cmfat2s+DPq1bVK/3vFrUhcemoWRk/F4sqPm13PldCu1kDm21X5oYe2RL+LM0irYsJ6FnHU0j0W+u2Mf9QmP3GSrF4JLQsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WiTd+wz6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tn7ea7Cz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WiTd+wz6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tn7ea7Cz"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfsl3062718;
	Fri, 3 Jul 2026 10:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E7ocs8tcJBkks5kCP7MKF+jeA6FXb4R8yU6zqDBIOl4=; b=
	WiTd+wz6LcsGmfS6Nb5liLBqdRvWy6UgNaVDcYmdy9xoLjvFnp9gb2Qdz3cI3nQH
	WiWF8R8KyjvWr7zO6IMsmfm5sXEm9kUf5fXrUx/X0YSkCfP36BCZbW2hiPsafapk
	XGWL6iLk0JqYcpCesW3KVDoYc+1ZaBPdRkYgeGVEQN2p3QyPdTvItbUChmi+naWA
	aHlfWbH2HQNT7eeTgmVKUdCByfwxCxQ1vqIOqHZlTtHm5k91Cb1P0O2oJ/D8TJPG
	VCx026CNafK0skau53zg2rilfT5DOW9q+aoW5hYbBhPgJV29mHMp63kivyy08Qyz
	+kVcw60fqUMIo+9hge3KkQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26n1aedj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXW25036972;
	Fri, 3 Jul 2026 10:35:03 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f3u20fu7d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fHwoqwMqcIRIDMByJHtsMUCOMj4zJO2CisN8kf8zmshF5JNaoexo17H6CpPdFyArv8vw2ng6Yu/nVUfa1lbgf3c1yXS7CTCCVInb5+7G3wXeOZ8UeSDEnAWQNjQhsl4MbIaCy+VeQcB44Yv9tE/sF7P2o1jcCyspqNSMP4oDpNUgvDqpgPAlJ37M1pJpM6/PaMHU3XpxWDPxmrL7HylCcKNU8unw+ht6/E10DPMzSRA8GwQP+5O4GPLanBZepwmQ4BUFUNPFwuLLNZovEHO53PBAEmCJQ/KOyPKXOnIScegOSsbRz/MPG9KbSWJr6IEiXSQYeoHjQh/pVPdqAb+pDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7ocs8tcJBkks5kCP7MKF+jeA6FXb4R8yU6zqDBIOl4=;
 b=YskUPNTpTe0kY4B+15Xmx1axWTLKcD1aH7htm0DxgBi0O5lsVvinWDL3tzcM4bdEE2kOh7faUdfySp6nZ1AMeAsAxh1VNk3C5nuyi5LSWyD8vZde+aQ9qCDS4VKKWBZwKipa5Z57Hfz5o1MALnl1ZL5qc1gaRWUkYp6ywckDiECLxB/Gxhy/l5f0CFpFqjHLl8dnBbrgtcoFuXmAQf9m4yXcip1X1r1nVGbUZFxTn7s2mq6OiebGaVWjmzkXeAmzTnKK5UOq/jhLGbdDjEwJ8eo1t3djgGl0mr7u3DCNAevNzoOrJ6EbGVMmVXN9I/oYyW/ok2QOdE1JSAgMoZ6GVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7ocs8tcJBkks5kCP7MKF+jeA6FXb4R8yU6zqDBIOl4=;
 b=tn7ea7CzO7h+MQc2EJAfYc0BO1WbivqtHQiQmRgLvN5wf/qn1JqtuiC2hicp4D98WCEtb2Iv/lmEVgm6GHonMAx7hzfvmw83PoRP3FzVqmOvYwk1dNd6ZSmyuZEILSqostY6aksBOocNJv9bNWgk4S8ECBEVfaJ3aQ/HZsk8xuo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.11; Fri, 3 Jul 2026 10:35:00 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:35:00 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 14/17] scsi: sd: add multipath disk attr groups
Date: Fri,  3 Jul 2026 10:33:59 +0000
Message-ID: <20260703103402.3725011-15-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0042.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::25) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: cac9be08-dfdf-43dc-08c2-08ded8eebbc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OhW9RMjbbXbsPCVOCqzFv21kNTs1lLrgMSVVZCuL7YLkHBKlA0WktQbEl7CrPwcTHQfeyPZ6AgTA6pRPq0mrfwjIr0w5pwTjA/+pdrrAWXACTP9V1I5ACiPB8tykFne2r2FY2hQYb1Fp7x2jo/pGC7WdQBJEhfyPGHGf3t1BUWth5+SPz3UKS7BkTjU7Rex9yGyFpRhO9qyFZBBpE2tdMDu1pOsFxkd4gMJKn3W8w0U8nKovMxNgPnInGnZiACyag31siUXsyANLbUKsHPePzTEuRVOdu1DJBxfhILoy0DhCs1A45s9RMXUlLPY8faZtvEK2FBkRoij0+qg7UKNqP1QkueBx7KhbyTt8SY/OkK5OS8UI7TkP6V/2pnkgCyPpQHA4zMSUJPunC8V0gQh2XVuzz93D7xTyr4dLh8+uDNrPeE877nGA/WBBZm4KPS0ggCMEdLzwlAQOo04Ovcoo0OxUyk7nwg2XVz+l2u5DnDuyOHtdqAh7Qpm7wPlR3mfzpkjZdq5vGrFRG5G9riP1szPzOZK3Bb/9miOMxqGPUTOCiDoT6b/+I10oPAqnz0S71K3B6y5EdYYPEys5wx9ea0MIN/OC80CAQY9BmLi5T7CG2vZU/wpsxEFTiycU+IDs9tQv7wpwXjjhrmF/D+uAV+ZIE4ZSgIVIsONWUu3TmdI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0CMhF+2eZQ2qPxTI+3M9/+LqDpb7TDpEriqVH8Q4w8gBdhwaJ+6fjSgfEvch?=
 =?us-ascii?Q?A/Wyx2tUYHrNfHP6AcKe1ESJ8Fgn7IJqmzsIJELHXF0Ep/+IWThJ+Sl7Mfh0?=
 =?us-ascii?Q?Zv5zt0Dr8v5r9HcHOpKG/ohLkkR8fWhq8P8lzU4gcgOFHAlhbK5r0pRamTMX?=
 =?us-ascii?Q?/KvIgBF+nhclMcU3i5qhtubw+UlHg/OOYp0ls75GbZ8Kif+qHT6pvA2Ntx/Z?=
 =?us-ascii?Q?YMF07x6+uIqcIxUpHrGAM0V4LC1qz01EV4KPUIvq/+HKuLqY5SEU/cwRvV2y?=
 =?us-ascii?Q?04NU2Z5YPuEEXdazZABzWNRDVgTpz0UGBtsybgxdF36KmSlrN4YB9VjT2rBB?=
 =?us-ascii?Q?MPgmA8L8raM/0TSNWcsEjgPknT0MC8BTMEBJm9cYXwzPkv3P5I3swcEJ8I/E?=
 =?us-ascii?Q?T6wvgVstsJrlQ0cePf8383EccNEYipiz4mhj1qlvtMLxJPhinP7I83UCSgH/?=
 =?us-ascii?Q?Jg7r51q1QF1MZHxILzg+aZ5B15OFotdCa8A1+yap3qhZWsLH8umFv/Yo//e7?=
 =?us-ascii?Q?9Qui4lPnhEBSPNfYUdpazqWo5iBNDEg44HbyO+MKYtpxarq0RL6MqUrOsvie?=
 =?us-ascii?Q?ksbxBk/e1hYrbKWQM/G1SrqwwzVZ1qMVLyYsKpIKWE+oNCDznU974kRd55uf?=
 =?us-ascii?Q?caz/PgHPUVq7GSQdUItjHBuCOn7CdumnKTq+RiKf30QP5q9l2nYrgemsM0pi?=
 =?us-ascii?Q?ZxWTxepc3OE78QrrlsljJcgqtC8vDjJVRsUdk9wKuhLQxsaoP+/lNkxN51uO?=
 =?us-ascii?Q?+3dQrxm4p2UmGvOUvTr+w5AhbDEJJwDbZeq73jY4av1a58pJ476mpMfKaZVV?=
 =?us-ascii?Q?DBlcC3ldfi/kFxT71SzJg8/Ym4NSRursr+s1y5xZnVWTwI/ZOn5obIHG56Xv?=
 =?us-ascii?Q?jXbJZecjzMDBo3RgAWo0n4IZ/opyBwLOnUvXq2nT3Q3XCZCF/GyVFCykw/G+?=
 =?us-ascii?Q?JoZZtDbTL73n8kkxB58lSsdn6SooGTN/kBthKHtgDFnDwjEvSgeXm9D1M5cX?=
 =?us-ascii?Q?6iz6cI1rpjWPd1QeOItuu8stoh7cOjEiulhLUc0iR381R5Qjy5b5AyGN3GzF?=
 =?us-ascii?Q?018fBH70vRgerfcf04mfgwtSskQ1Cnn9e6Ojwyp8bc5Uy4aKmDkVSVwE4L+S?=
 =?us-ascii?Q?KyMrzGYffUc635LbKEozlYrbyj3uhkwehgnVlmpKuzKrLkbC6lsG+DyVoj8/?=
 =?us-ascii?Q?6AW6r1RPi0ZhAR/XkigQhQswxW6UPZEhvsDvP681mz/Auo2A5/lYNgqWw6YI?=
 =?us-ascii?Q?bGsc2CYtPMJXUKxI7Zz9C1xB+EAJw/OPPBHQlPEhiLf29OubEIlD9XtZfaN5?=
 =?us-ascii?Q?/AAEFokjqwpY1Ove8XK64WE0FTEfWqIUXkFyXErB2KtNwLiAk6V3cJgBd3wN?=
 =?us-ascii?Q?Dz59GZbGSZQkNkcUczhpt91+VIkU/tafelEMnYGM+CmNW92b6GCqYjLTV38t?=
 =?us-ascii?Q?8m3vOnDfZn7vqFSfutRFTtBVso3fLwu7ib4MoMG8KbtDoFEKazLvQwhEbNKs?=
 =?us-ascii?Q?oqBQWzITGFDp+TBtRCz4a7TrmcFeD32yJ2FQDVCCinFkaY4D7De5RZG/qfk3?=
 =?us-ascii?Q?2E9SjA3pZlcZfIOa7Anb6NBGXCH5ZbeYqXgyXLfIU6IuACCyBxaOZHMEe43X?=
 =?us-ascii?Q?d0UMzBCWBfxgwx6tVn1MNw8/ph45Lf/b0Q7jhygKozx/x7A6Vpt82Clo/WJE?=
 =?us-ascii?Q?8L6aswWVxBkJppNZfreDABhOtfD1Y2gcJBuoLuc9wjyI8hPC3QY70/Q7Vk5g?=
 =?us-ascii?Q?3p57L/Uf3x0Q5N7NWwPwE6M6ZV0GQYA=3D?=
X-Exchange-RoutingPolicyChecked:
	R9Az546oCQ52NzlMnGT+iKkknH8+46EAmtoyZtlcgwPk3XPZJ6HCBMO0jXjDNdGk9hA7dNCp+GTJsfAmfrN1dYcLBKEonHFRQhm5N+5kHdyS074QynUvhQvXgTi+Jf/CRGHiKhpgMjxi+MrLOvxs7Ka1frA1Rh3GLdMTsNeUF/ntOXcr3uh8GucLfQ30XAdkWH6Oit9TfT4VnG0/GZ6XwvPjmahVgyYgKNHF22xRMsqgJc/e65fvN14/oE7QYrh4P7CbnNfRkdJ2Fd+II2Kf18ZJx4kUpNrVMbLNHRpaolfKG6mhU5jS6+qKPDk6UP2rMAejIjj9ybmtmKcF6ga2RQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F3mSFYz8mFdvH8JoLWYTE4v0ozlKVZrWM3ZolAzFFVBY868eqypJiF4bIv6shfqIvNtYjGSWN3wtq+ZRcg/1gJs04qXlQ2HiJsvyHbNQhS9vNSOzBUDzvAhle9LtAchrMpLcsTbxBhlVvevvXoGUI3u1jhk4To52NLTLvNsgF1rayPP+Q0S+C3wXJZcIOLXGusQtckamHtmyDzl/KUtk5achzpHIMVXB2jBB1AlmIsAQB6WEjeFc/Xhj5/piQcz7r2je4TiqfD5dXN9dpBwGNFDRhIjGA0sJwn1rtZuSTtJVaQfVl/oRplINraprP5VIBanJt8g2Z7N0IBcWQH/OWtCf66pebukNIfF5TRRzPQuzIN8SwFmlmtyZYygjwPpWiE0X+BsnzB5wwIXjEJev8kkozDE9x3KhYUBCHUx7JpGrX8woDKPNNo+W2xObvcy0NAvnztndWJdMNl79kbMWg9l8Ls0odKvLjS7Xf0DWHuhOB6Xzq/VNKXSTw/W0pAu9toe9foJaxkhnNcSfEhHyWTtp1iEGJXtxxEBDnMCVzsmZbrX+uiWwmPGlC38MdX1q/YPfZoq9RKqtyUJ8WmiGBwaNhRLz4za0C7Ym5+FsqvE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac9be08-dfdf-43dc-08c2-08ded8eebbc6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:35:00.0026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBqlq/Oiu3JxtDLQOY0+NFPOxiBlff09NosaMsxkiTa4z8Glf90ud83dgE2OoFrRl3l3N7KEJ+Qca43ZsvEeCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-GUID: 3RxKkkFFuigNNSZt4QCGTTD7r-bkeeqJ
X-Authority-Analysis: v=2.4 cv=FvI1OWrq c=1 sm=1 tr=0 ts=6a479057 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=4WwWyauO2_0H2zdGQVkA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313
X-Proofpoint-ORIG-GUID: 3RxKkkFFuigNNSZt4QCGTTD7r-bkeeqJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXw2kOvQDM1qpy
 2N1VhXzS8xf2q13eEb1ORwdTi0Zlu3btw/OLUXlJ3eibmLaps8sO7MQP12Ox/tX8N2wjeLOUsfC
 x++cr4S1hZYt8by5rrlZSr6EUZuv1+hUXwdhqSVbMpjEuCTBBY8o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX/BTSlpC3CWu5
 v6izW5vMYPLTSiAGEV2RNJej/GKmdDdQrhY+lnhZzx5qlwTY3algx32u2XbUdEYztDXE+gLsGaA
 0R21mkG/cmu+NcB/o/G5n4+HsywoSIaQdiEuJHbs5rY8uRZ7ZgoomjIg6bD2uNZUDg7qOoydBb/
 0hmCR0pyPUIOGvyhvv4xLs5gzjBzuF64ierOeifUgUB8ztrTAobhPicQivzV7flvh8D85DeB9Hx
 5sRSwrOvpzDqu3LLEO1uyO9cePEI3NSnZYFyD1y4BHrW6oeKbHyhPHitIAPZ9i3SnIl0VCpZua8
 vRiwHLOnRSPfaRTSZuhXp2vwGqANAPz1wBCRgMUP9eEBBgxmjVsGzIFpys3b+G2QYyxyDnlgkYe
 jKYZtzod3gKE2O4qapq3CNUHtBDCo9T6BN83IwaCwSGMHXd8plTr+TNgmZlzGxo/TEvClvGQPHc
 +tl9HkivB0cRd553TqBdJHBMIvZNh5+BWIRvu0rw=

Set multipath disk attr groups, which includes delayed disk removal and
everything from mpath_attr_group.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3df70b24b688e..a9a29e50f5eec 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4106,6 +4106,41 @@ static void sd_mpath_add_disk(struct scsi_disk *sdkp)
 	mpath_device_set_live(mpath_device);
 }
 
+static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
+}
+
+static ssize_t sd_mpath_device_delayed_removal_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_show(mpath_head, buf);
+}
+
+static DEVICE_ATTR(delayed_removal_secs, S_IRUGO | S_IWUSR,
+		sd_mpath_device_delayed_removal_show,
+		sd_mpath_device_delayed_removal_store);
+
+static struct attribute *sd_mpath_disk_attrs[] = {
+	&dev_attr_delayed_removal_secs.attr,
+	NULL
+};
+
+static const struct attribute_group sd_mpath_disk_attr_group = {
+	.attrs		= sd_mpath_disk_attrs,
+};
+
+static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
+	&sd_mpath_disk_attr_group,
+	&mpath_attr_group,
+	NULL
+};
+
 static int sd_mpath_probe(struct scsi_disk *sdkp)
 {
 	struct scsi_device *sdp = sdkp->device;
@@ -4161,6 +4196,7 @@ static int sd_mpath_probe(struct scsi_disk *sdkp)
 
 	mpath_head->parent = &sd_mpath_disk->dev;
 	mpath_head->drv_module = THIS_MODULE;
+	mpath_head->disk_groups = sd_mpath_disk_attr_groups;
 	error = mpath_alloc_head_disk(mpath_head, &lim,
 				dev_to_node(dma_dev));
 	if (error)
-- 
2.43.7

