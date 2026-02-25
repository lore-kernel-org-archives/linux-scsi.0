Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1973D7D8F;
	Wed, 25 Feb 2026 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033847; cv=fail; b=tDsDr7UMAV0RGo1qj6r4GPvKX+gyk4K1agmzS9XdKMt7Jyd0t1N1GMDJ1Wm/d6w2LPehVgssJiN84sWPGbgY0uKWArZikNNrjmzP2ndmRwqnr9WMqNYskrGFP/dJ27B0ujZ09zd19Em62i67xepTRjZx2lEMCc89bBhRz2wQwX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033847; c=relaxed/simple;
	bh=odIn6rdkiRc3nsIwV360ISPOOLh6FMlnVPmtSIGn9sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ycxy6t3MApzSPTeuqRh/VvyC3FFCZf7Xo36UQUD9s0XEYHmUnM7CE525EhshaMCuGTMUwdgbZfl15lShz8tPazsTMsiox9h1vl5S0K0F5goLUIrbgn/6I2urHv6qpuUezgF4DeXXa58sKnzdHugMNH2IhB4YZCWYJIlcG7JY9O4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d735J579; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hdIrofSX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d735J579";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hdIrofSX"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9j6Hh1959968;
	Wed, 25 Feb 2026 15:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rxQVP3W+bMhYykP1T+bGduYNafHlLVAKpdx8DqbC8lE=; b=
	d735J579SYA2dmAKVkGtalIDpRSKyM5vo1FZ/GZJiyyWX/STpj0Ki/42zI/ZRMqj
	p8WRS1cVaYQQCQzW1hwTqdOP26VEOwRIHcHRfrkkB49ERv6bxmTYOOiQhUims9t0
	lCxKvX3DhasBakncbW1x5xZuFSC5rT/yEcl44IrZ98GYPV/13sSzJfuUk2xXSJCc
	ibvF4JbA4zapJCntCZJvF3JghJFzt6YMEHZ+TpTD+F/HCynN1/j7PrWPDRcXBrqi
	txt/oeP34SKCylzODS/fdRJG5WyifYmP/iEux32IpekRd+v45FsYglZLM34V26Iz
	8uXMr/OIt0z41n51BxeWFw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbegh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE7QHS006382;
	Wed, 25 Feb 2026 15:37:08 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg9h7-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ck/H0+8AeABa3as0sZZGe6lnjsoyYBSgyf5EGS4d3r8UX5H2Qx6W7H4sLVBxB5bYKojt4/IZKd8XGG9x8YHubR+gfVJXvt/2dykulHX1VmXzaBlrJfcGuQm4qv0G/rpW2yO19glXdXrt2qLAC6PIrNrjNxm/3OZmBsI19roFECAHo+mjJGkeNAGk9605z/dNN3ZcRQjMsZ4cQCRKo6BRat1wYHq8oqN2YJIAKNf8JETPzjQ9CvbNUSzmMnPgGOoeVfxn4KVtkALNn5yv465A1j5dAFMjRGkp4F72/5PKqXF/yBtZ/LvCAvhmEX96l55C7SnzDVhJ4NbmBz+071b4XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxQVP3W+bMhYykP1T+bGduYNafHlLVAKpdx8DqbC8lE=;
 b=pCa6zLG/kPLheN3TZDmiaqUHSUR6GDQYtwTNE8Ts8jBI4Zl4kipRlYMlocHM2ep5Hx1dc0okOUuN3nWNT4EPSae5ibXpB0/VppZX4kDlZMde88fGdBKT8aWmooz/tT/YCtfGhjoeMlxcpK+7LYwMHrYCsTcmTZiPyiSWvcVsdd+Vxj88+WZeQ9OAVg2Cw4chxnwy+5f81J47VNtih6ox/vRTWStJYKaYv0zLFAFqnYuSMykMhrfJfA+lf/kuUQ8pafiGwxIJvIkkhEmwbYw002N56+ErHfr5N5U17Rn3bLEXMKb7S0NzlZeiiBkU1T/MRzzYXWFJ3as4G1hcgiuXkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxQVP3W+bMhYykP1T+bGduYNafHlLVAKpdx8DqbC8lE=;
 b=hdIrofSXmCkj1qTCXhOnrWUCkAUk0sNemPuF4+GgXzkZQzj39rXX6bir3NdBe6FMJ4x6yHoBJB7hNa+hN79Gb23AJI6b52o5k3IOln00pjSiv9eaPGE39lkvreYBT4iGpmw8DWjCgPM7x4O0i5suk0RvdVqlIItLJDpd919YVAA=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4626.namprd10.prod.outlook.com
 (2603:10b6:303:9f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:36:55 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:36:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 06/24] scsi-multipath: support iopolicy
Date: Wed, 25 Feb 2026 15:36:09 +0000
Message-ID: <20260225153627.1032500-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::6) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: 86fbb82a-d8ef-417d-a69e-08de7483b448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	DOtq8MMBEpiUNWkUylGoFS2u9T5tTVTNdPGnUm1xN8iaeR4KqNuh2Roz3VFD/2yaS4zpwZd4HxTtTevlw8+5Iitmh28B3d+kH1NmhnBmTNPcwmqkOpDKfUG6XheWOHsWm33nSNFzuSU+sc+7112dKjRk7XsfYz4qphDqSgGQOMEbxECph61VzXaRVsX61UCEaDFPajHJnDAK9dU4B64jNsY+MFtPiWMeUxVDWAwhwBJUWMR1IAszMLTOS+gynl1GyNYdLu1KA2wuTtcIN5d4yknihUW8mlJRF+11qTsesOusem4N6QYUCYcZl78Ty/rkSGeR+glcBVBS+6Oq8TwcMG1a5OdaIpqselDsCCmdpEeuKUN/kuoG6NX3Bhrz1gMutevinZRFFWOtSkxoDGSwvcX1Xq2TS/1GohjzKknQaSg7e9qAANuATmcAxaeM3dCt12PvxPhool2QkYkkz/Q/J1GMLmmC7axXkiYkr5RfM1z47fxo30LIAX2j9kCkpFq/A3OI1xm7s3OX0XNXCC1ux+824Kb1Gak8HlU/8O8plKcIA9FLK8e5bwzY9ovYXKo0aMyTel2PbS8dKZMBOB+BKimzktrBhNHauYt1bfJV2LAdzBCF1rg9zr0uyvPruvoCfBvEDmMsBEObTz0F2SkeZzClM8/CkfSGhNG1eFuyGXR3/OnCtXJXFrEfJuAuJ8DXxY0Bs8D3hdSurjyxwipxs/eYV+0ogwx9H6KPNPNLu28=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?unQ69kIHMy9bN9JDuyNEo2SOfTvHD1Hn/dZ7J8PBvAxwCx9YtoTXMfQuoIJF?=
 =?us-ascii?Q?YsQdMyNRdVVKkIb61vM0HtxHGs4eXeV2KhyT2cuNE63K7KN8/rh2qZzrHSsy?=
 =?us-ascii?Q?IiCKQu0B8lAxZFWiOPf888tl5AkSGdMyKg+zVFuiXhNNX6wo6UHqnEf4EyrK?=
 =?us-ascii?Q?noW7XusDhDa5J0aPOrEiYQuWG3YCJB4AAQrrZYYK85D0kjMvyb1ABmYKKhUs?=
 =?us-ascii?Q?IFsGZgsNViuXndxTaR+hhGOa0AlKijbjYbEtKVhqkocKl+Z9oW1WdAVjlhTy?=
 =?us-ascii?Q?AQctkJ3jlFt7ndyU/2DKwKTv29tSsXVSjUe7egGw72k+b2EKWTJYKfOrhmMs?=
 =?us-ascii?Q?tDy/BcifIDa+SzGR+NudPK9y+p6x9UvV1L1XMFsSMB0CmorrEPa+4UJXSwNR?=
 =?us-ascii?Q?otwTREpRXMujsuoEgXnpZibC0FaCQAxvsbkBkPf+8PGz2tX2DHUNAOhJVdZV?=
 =?us-ascii?Q?8dfTmWlw9hXi0NccCF1N8E1XS2CF1cjVZIqbkwoyTrtPWvY3cnmKfxX/gMHD?=
 =?us-ascii?Q?wYG0m3sP/ExZmbXE6C+7Zs9gdfOLwXXXP9VK9uzdK91d8VuG2vl3xBY2EZ7R?=
 =?us-ascii?Q?53gEcEhchnWDvVR9PFNPwxq0ZriAwBzpumn1jUUNKPcfPeEbjlQEzkX/IH94?=
 =?us-ascii?Q?ilUxeBuNaecXBtFjIkQTAp6AcIcLsvR0IEyVskT8+MU88NADPNxpqbSE2Fiz?=
 =?us-ascii?Q?6vOIm/aK3mNx9DJxru4WhNrhidYhxo2Ieu90Me+EmzG6MyJvMBPT9uw8YDbA?=
 =?us-ascii?Q?/mLelfusDj0UUznqqgRn+8Q/R+SLIprSBO49o3gMHle9Go9ZzKC1HgK+DtY6?=
 =?us-ascii?Q?JT1LoyizrOLamkECbJqWv49aevQUSWfnHiIITs3teW/x5a1JbkDu1N+lr3wo?=
 =?us-ascii?Q?dy80/QDVKqc7p9PkY7J9bpyyBn3t99I41zmUVVwYDEfA8Men872vIuubDC/1?=
 =?us-ascii?Q?2DrckB2y8ARv81V6eAGJsyxWAJd3GL3vzCcmbHCzZ40odOpiXNhtuQGF05uM?=
 =?us-ascii?Q?b/i8L7V4JWMowC5TTmUxNie8nZ7qOxgOV6HO9fAvWUPILiDgVKR00/u1krlp?=
 =?us-ascii?Q?+iHZSmmNeWZ5bLOAruZNfv9IBSTSJAcy7bT7p8bCiKgp/4yjw0HekNBVvDgS?=
 =?us-ascii?Q?YxXLsBZ7nQSB0vwGJ9zpaiSX+4D0YnjQYRAsFvNX9UQqQT5Y3rkAv/vghhj8?=
 =?us-ascii?Q?IzrM5561vVJEbyJ6Aps6AJRf38M5m/xgDxNGtx2/H9P65+t9KAGzCC54YHtd?=
 =?us-ascii?Q?Nt8vMhVG2FGyNqVsBH2QDNhejEJ+Lr81dLrvS9z4XflPxtzl63+WzaNVX82G?=
 =?us-ascii?Q?rcnvs+l+jq5ckC1laVF0v44HvrZJbIFv20ZxbXdm0WOlPG95jAguN+nJuvDw?=
 =?us-ascii?Q?4AQ7DDNO2/niFvASaaRqZZRVJnFBwzatxdIIO49hkNEdx2Npux0obdIBMdyP?=
 =?us-ascii?Q?bOlYXPR0lmNR5LE7VvFvg7EdjLtRYCz20KQXpHaloPt0UAY0jRXHre1TL4hj?=
 =?us-ascii?Q?NGYojHrAvEITCC+brt9VAbg1VSrYMKlWWOnVBZUUygMajAK6G893XoBFaKTo?=
 =?us-ascii?Q?+Wn1mNNjwd7QCEUPfZ7MF/ebx00zOOSMCAIPElYOA4es7qQ+YHU6aKL9zL86?=
 =?us-ascii?Q?UTn84jIS0o7aHHbNwisbDFXDQhPdpqo8noDJ3fO4pbsjoO68vjz1lsJV4yTL?=
 =?us-ascii?Q?/hjoF5ZT5JOH3KjdsUx+9+H9X4N50Ybk4jwnrslwEVWOdLLILL4ZImM5Vu0v?=
 =?us-ascii?Q?FnLA0F7DZeLg7BbCjeWTud3No1KKVRc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BHskpXJaW4u3cu2JQDGg6cY30CV0jt8mkiZ7VJZsy0shfjKvUqK5q+c02SXKdi52aQlKrJn6wbNQaAChRwCGouojfYEjOcLwmeTJEUeH8n1MXRjssADcehi3IMGBu6EE6MwznIHsXWQYCNSviXMUPSO07hTtRLIv6Va6wBX8UhY/e6TMlX4+qOeGsiMwZHa2qMnVJzAjtkpz8iyae2sZcj5MvRVlOxu+XDVBLjBydncte2wum74pgtqOHqkIFCX1dLjrnFleBys7Vbh3AXefsbOXkUMWUnzxLGbQ2iw7T3MG+NgKgOw0amMLw+dm0/6pKqD/UeApB0khnP/seOFRYG0KPBxvQCMah4qzTFgD4T/3Q8msKjIHirV838uo8c6A1OZQDbfOA8bzUT1y6Di1oemiUzeIpVXtG6asvQFhsMoZOdKT8Ya8caXxbuS0x8pysa1UVeji+k5WaoG/PFIPXKQ3JKUmHqBL1B53qvGhQR4KJFi6aKHCnonJUbFnKwju4R0jPqV0ZVzshrxz3BbvP49gevkzJXGLNOxLMWx2e5fhukewHA/fUrg4wb4d3VI8HSIK+SN2EMm58EKqeJ5BXBESnvuX8l525Tb2qyC7eJs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fbb82a-d8ef-417d-a69e-08de7483b448
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:36:54.9016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRAuFVsXw1zTSqgOw6xg3l8iFxLOP/s8fM7He/ijvZ0Py46Mm8dE5Oy2jt37WDM9vnFaYLnPz85MFq5k6nvhCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4626
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX+9JwgTiPlCoP
 GH17WN7CwFvT2xZica2Xx0p4mfP7Nv5IKepAF1telyzYTcX/iTxHYyI3H9D4pesebe/X6oVzcBz
 V6ZuqdM1ZiifiXyuaN8TGbj7e9bUscd52UKJA8fgsTrfy3o3eHPDlVLNElzdmjQ9hOphqpJG+Mq
 p4T8lDHc3awA7kmKjeN9/EB0zvV7IGfv8QqsKCoDNEWa/hushipDTzM6SJumWfK1nJQDhyKlyHV
 PaazuIiEZpBFBLhVI+u31ZmLczbFrclV70CgQ2mqfZUcqahIKWLpgc+QeGktFeMlv6j9uT4GaD+
 0MeXxRMl5RAqPlXOlmHlzRUlx+Qj4P9XTp8OGzEKiOgnmtO7OXSKhaREwGReViYTB6TCwStEON9
 ABfDsraCWuZ0YmTH1lhEpH5kBY3cKVzlvPls/CxzcdcoKKhP/30qrj18M/RRx2T4BPaY0e61Etq
 CiRg4LecbaoK2o9sT5w==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699f1725 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=8fwEAWchWUUFBy44-ZgA:9
X-Proofpoint-ORIG-GUID: eDZ1fS7ppT2iigYniJC9Sxvm6lLXyf2U
X-Proofpoint-GUID: eDZ1fS7ppT2iigYniJC9Sxvm6lLXyf2U

Add support to set the multipath iopolicy.

The iopolicy member is per scsi_mpath_head structure.

A module param is added so that the default iopolicy may be set.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 57 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 58 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index ac55f9f39a5b2..4b7984e7e74ba 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -72,6 +72,23 @@ module_param_cb(scsi_multipath_always, &multipath_always_on_ops,
 MODULE_PARM_DESC(scsi_multipath_always,
 	"create multipath node always even for no ALUA support");
 
+static int iopolicy = MPATH_IOPOLICY_NUMA;
+
+static int scsi_set_iopolicy(const char *val, const struct kernel_param *kp)
+{
+	return mpath_set_iopolicy(val, &iopolicy);
+}
+
+static int scsi_get_iopolicy(char *buf, const struct kernel_param *kp)
+{
+	return mpath_get_iopolicy(buf, iopolicy);
+}
+
+module_param_call(iopolicy, scsi_set_iopolicy, scsi_get_iopolicy,
+	&iopolicy, 0644);
+MODULE_PARM_DESC(iopolicy,
+	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
+
 static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -116,8 +133,40 @@ static ssize_t scsi_mpath_device_wwid_show(struct device *dev,
 
 static DEVICE_ATTR(wwid, S_IRUGO, scsi_mpath_device_wwid_show, NULL);
 
+static void scsi_mpath_device_iopolicy_store_update(void *data)
+{
+	struct scsi_mpath_head *scsi_mpath_head = data;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+
+	mpath_clear_paths(mpath_head);
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
+
+static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf, count,
+		scsi_mpath_device_iopolicy_store_update, scsi_mpath_head);
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
 	&dev_attr_wwid.attr,
+	&dev_attr_iopolicy.attr,
 	NULL
 };
 
@@ -211,7 +260,15 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_head)
+{
+	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
+
+	return mpath_read_iopolicy(&scsi_mpath_head->iopolicy);
+}
+
 struct mpath_head_template smpdt_pr = {
+	.get_iopolicy = scsi_mpath_get_iopolicy,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d8102df329d6b..8dbe1c3784d2c 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -25,6 +25,7 @@ struct scsi_mpath_head {
 	int			dev_count;
 	struct ida		ida;
 	struct mutex		lock;
+	struct mpath_iopolicy	iopolicy;
 	struct mpath_head	*mpath_head;
 	struct device		dev;
 	int			index;
-- 
2.43.5

