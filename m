Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD5B3BED26;
	Tue, 17 Mar 2026 12:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749273; cv=fail; b=JlWnn8322+azY+W8HguH64OoaWQ969J5XHJNOR6MCWCFrfQDho7E1gVN1lCZFgZPllCbvFmrtUnkqjgafMYg7KxDRZHKyesKcdPYROJskB86MfMYymKzgAaqZYnPXSOToemk0JFKNOOp0shVsQogqLryHN3zh8u9yVfF7DJOMvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749273; c=relaxed/simple;
	bh=18ExPBL4lFc+FHi0x3KiuPt+qJaiBI1gbTWMkJBdqlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YQzZv/hpFA0zUrJ0lLi1JqpcabvX93GaXOKjTSg7Mk5Zr1atxCQKvx8xUt3wIYPS6ZBkk4W5XBtFBQHhh9TaC+12m5gonTJMOsSPTjuOcTxAtsy2aI1rOfhY75oIT7rqFKowUUqo/QqvnPjWyLtifS7h8kQxCRJctNKxCG0oBbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qbnl1q/m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CGGDsPev; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qbnl1q/m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CGGDsPev"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GLEe0W1337612;
	Tue, 17 Mar 2026 12:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fu3irzz6CEZuCbENjJGVMaWXJdh7PhOhkyMbQBT4BAE=; b=
	Qbnl1q/m9NeslOzmETgMgHIh8FbawwpxpbHxWenMenccnf9Ry1SgcrAsfbyKvF+W
	6JOWl//BS2jiWcP3POMlScfTrQ9YT1coKtsQJYDNUd9XHSA+DlRwqgRwAEUaAKmb
	e5n6HSxssG+tk4OWFoZSzMV/LKHMgAA1dmRyIBxhhURr/x94zt0rvz7TqFBhh98O
	nwnYZLsh53kWBL2pKhhI4N2K1Tk82GkJCWm2qtp+utSbFIBsRO2Iabcp7+GzSHuo
	M8kKgI7goNa5TgkAyRaiUeeGlfnNCpOpdC7hlZWmjEi7gLG6m87DaVreKupGA3Ih
	Ok4b6AjaHz3HauDQyzBCbg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvy9rux07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HC1DtY017822;
	Tue, 17 Mar 2026 12:07:41 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4mh293-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUFA5wY3oJJekcTr6vTWGJZPLDt8WE3ZN9dsC214Y5qM/YnygKz6lvdDt5k22F6RKvDqoGGL29z9EqTfL91+QQEIy7wJqts32V91UXqopqNxRnFYPkdsCKmicfk6Y8aai5+t+lOkKz9ILEjcf0IWd1ADQsIjxrqkyeeVi+pF051rZJ7uUc4ZuOV/huAPCDxlTGGgcLAhsxF4sMYLZUtBQHs1xA8sehydLF730qaCsrcOyQKTsvFrDjnqVd7FqY3PZ94lnrXAYUrB6pLZZx7FSMA34+gOQd4nEEtfu90Y6sicgdilUoSME/FE0zQm/Q59RTm9eF0L0q+BnQ0avq27VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fu3irzz6CEZuCbENjJGVMaWXJdh7PhOhkyMbQBT4BAE=;
 b=oa97fRXg9Xp/4vxHQar6CkccLWfGhG+4t0zDIlx2gVlXPwrPXuK3MwhB+k9Czi7akg+16fIouZgs/KjJdTp8Y6a13A7uyb4m4MFG6sx3RL/jf4i4LzoBQqDn9dTUhJ9NCQqdNT/Z41sOyhxwhZrAxozGKffElCyL4cY+Ccvq6Df5rYCoTNcmcFNXXRIiVIMIAEr0vptibWC9BPaw+hf00gSAznF0PYxppGVBGC7I6AVg77LPG/pKXrFo1B+I8YdaxzPI8AqfFb5lEATVujxaFoLuCRcs2aZ0AH9rjRP4IfOzNOaNdIQVPxP/rdoeP/5L8k3IQBh3vrSIOC9V4vC2cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fu3irzz6CEZuCbENjJGVMaWXJdh7PhOhkyMbQBT4BAE=;
 b=CGGDsPevxge5T6SGUzyRi4ccqCTkxaBrOb5SMZTnb/a9isD+PO/XBy7ZZfWTVpAQF9x9oKUIiFjluIPhX4pDVBvwzgOoOnxx+JfBIs7njb84b5gAxW6Fx92U9KdpWaAsan8OuzBlQfBDCJ57Ce5lqxd7/2GJredrBewSXmcYy80=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB5976.namprd10.prod.outlook.com
 (2603:10b6:8:9c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Tue, 17 Mar
 2026 12:07:38 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:38 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 11/13] scsi: alua: Add scsi_device_alua_implicit()
Date: Tue, 17 Mar 2026 12:07:01 +0000
Message-ID: <20260317120703.3702387-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:345::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: e9635834-8a95-4e86-cb24-08de841dc879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	BcdBgWwaFZg9cd/Xmg1K99HYWfGcvUOtSqyAct7YtZRwdYH5ZmQb+C8kKEF8Oy4hRJBd7iqlM9osBRfJ/gm7T/JfVl8yeXXg0NWWK03LoSwarRaErNkWyTO6rHXtWDxYSgP8ZXbrmYDC+SaCq0DaCNCEb/kgy/qggxmOR3MHmBlU84E0JdtFLZTBdC+rpxKBmrzZV9K9X1EiX2j4JOWgxxhmkPljGmlJQ4MVgwszZQ3YXFG+ImxPxk34bGCPT4Nes79vifXrDmPNdcH5xY+NYgcQhwdobyAJTaWiEcB+/EuV5Jw9EZHM7OkVkbtRlpHcmJL/2lbOA1qumpywqRgM07rcPjU2cbCMEyhaQ6J+lwd6kkOL/5/f2aQsiCStwEzzhwpGdcGprIxYP3IFd4AmXQB0XT5ES1hlrIkCza4eoSd0x0HQuBQq48oGKQg5iK+Dy5yFp7lbWBhhYzu7w1M5GrhNLYzFonspnf8SYnYpDuTnktWjGc13r2U5mhJ597D9bXpyeK363iE/rAWGFVwUXRTMdeaQLZGYFXTg47jpfCkY3QyI0DH0iCNAgdk/zzQxMS9d7y7RL3Jjr3cNSPdaTaxoNIEJkxgEOQjlESqTCrpPOr8xZ9TBwj6eYIPwVev+hMNhxI9OOeyaJF7UjqxPPlDTWGV5AMkoqToPgdKn4z9wUnSIMrpGJYx+RTGby+flQUuo1GgQquNQXyzroJ0Sqdc7pTtp5f4ksdV1aRT276E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oh0NS4pMELjpuEC57Fk51BaUaimyzW+HbyUheXscbB+wmw31mhx4HhcU/jxV?=
 =?us-ascii?Q?BVNOWb3MMznCOWVn4r3Hh+gkLEst3SCGSxWIGNsVWtvaoM34EfZ1NbxMxfLW?=
 =?us-ascii?Q?Ene4AvMRP3h2Wjflw2jcYiuIaqjKztUNKKRmdVb6wZuSyDAcrbqGG9vtsWx7?=
 =?us-ascii?Q?Utus2YC91ExmzHJtGvq2u6VOheFhpWap6MtWS47n8HAQzMr3MMOcOKDcgMOq?=
 =?us-ascii?Q?mTydq79p5Lz6jBbGZ36rVFX0fGWGIxvuHcqrdWJd1EmZnfu5a70GN+eKiGLy?=
 =?us-ascii?Q?KlDY98npsMW4/lALPTX9fp5K+A3vbUc94kfA50edrtmMX5iH1rbjjtak/u7O?=
 =?us-ascii?Q?ZTtNloZtFEkxLFWH/Cvsnr0S6XD2Fuv8WWG/X3e6zaZHzuo06A7LFGttndCN?=
 =?us-ascii?Q?V1/IM5CgV/b6/Vs3aBQQ8ykHAbOi6EnlP8wWFI1yS4YzPZ3JMmv3S4C4yHvr?=
 =?us-ascii?Q?qohX+PTCu/cjGolcCO4gU+bd3XTZfU1FDkW5GD5s9FF3BkkEpwMKfstQljHK?=
 =?us-ascii?Q?ZrTNFnjjx6hgLDB+tzWPrR0+h4MTenarZGzFIUQCgn0xBDDt+vStcO528i+j?=
 =?us-ascii?Q?mpq2iNSmRXbWTjprKM1nxkp/21QvSQ4iZmyY23O6jQAhklMaZ6xKd5H8v3uv?=
 =?us-ascii?Q?KlUWMBxNCoARPYZ9pmjOofmCuOUv8LvQ2wdlazO9FdeldzTm7aHnmQxkH3Tg?=
 =?us-ascii?Q?NCvF0wYB2wnB0hyVA1+zgmYzTDnpp1L7+UvVT03bxo+oTcJ7XRHwry25E/st?=
 =?us-ascii?Q?n8Dl7+6CtzGVYK3nRj7M07lM+wMv53ci4Eq6nFvXDqz2Rvumvt/3QRYwz6C9?=
 =?us-ascii?Q?2yHyG6Mc+56QJxJzXf4BOd/+OYH6twv9qW0/uPL7krsZAFFH0CITnH1jfPWd?=
 =?us-ascii?Q?bKUUnzuabp6NItFJV0025zJWUN7x8iLyj0Jc07Ll23hsCUVJLIvolT45BWJl?=
 =?us-ascii?Q?LAsl3Hrxx6vVAYtk7GpLuKjJqrltOfKA+hOJqKMVDtoqFFiCBLSVn+qSQRzU?=
 =?us-ascii?Q?wpb3TcIrGhVE5g3mh4Ma0VyS7/uJqehA5M6qEscrVs+Vbkrozx/xjzbG9R9K?=
 =?us-ascii?Q?x495IhogfW59JkvGUpsMGJk3mGTfsWurvaxjxqJtSycPpwTEDkkvMJ2o97uC?=
 =?us-ascii?Q?EjeWTPXLvoZMrjQPEmq42MkXXR9zUkYIsLygkGjA931jfSwGc+odf/xGsY3a?=
 =?us-ascii?Q?AIZtDB3U9Ybfw+zkLomJP/d2R8XmmD0/NuRdFX81aktgvZDz2Io76+SqtdPd?=
 =?us-ascii?Q?6PlWIOwsX8PC3FiI/sGKzyJGlmWHbhlrtZR13PtcrO/VebbDiqnJCVDyy2Dg?=
 =?us-ascii?Q?17I4lE5I8I/rWrV5YyFcM7kxEcuA9El7iP5+1fWEVBnG8ix38vJzCgG9KPIH?=
 =?us-ascii?Q?mwvT/aKNbBE+hlgHpkCXI+QLoprTswKNUM0L8jbHXMOZd7n+R7weWBzsr/0C?=
 =?us-ascii?Q?SCIMIuQs87HKQumgUt7kendNKpMUwNke+kwg62Srtlty8OJhty6P63295DIn?=
 =?us-ascii?Q?lk9/+JAqYuXHXuEtCYLMfssOL6Xuf7DQehonbctnemlxJoHPbhkvA85kbOyx?=
 =?us-ascii?Q?77vbX9LNvJrBCIAkGBT4xGrN/s/LCZefSZ/yMJLH62OFI0bzaZ6YUcSq4cno?=
 =?us-ascii?Q?5ZWd8SCxUbsPDRrYyggKSKEkOS0lUSBHao1Nvqg4T9pfP1e+4bzsC0d2EeoH?=
 =?us-ascii?Q?u14COfrLreVhpRX1LvagOSQ6eIitEzaM8yChTFmzwl6RdTAn/DSDQ9e9dHCo?=
 =?us-ascii?Q?30VoB8WfLQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	g4ODHpXHymsgkml0dP3s6vpGtrKdHZzduMbCgrvK2wECQUCJOOrx8eDsXumrz1PUUV20z1cxN4o8mO4cYhG+GFFVox34HHBPIZZLyh2t+q7Qp4eBntgS5En6CvGblfBJl6RYdmXEhTRlUtro92DU4wu/UiWoSg4OCNQw26jzCBbm4GulARvR5d8OVOhfDkQdJyJHpNwBBiogHUoo8weWRoDrxEsOP7Rbe3/qUCke5Tj+x/nJWK9Emx7YBdJRu6BO2vZrMbR36epm2Kpb6WT1SogJpDPnfqIIv6/WkSf/M9qhEM0xtq+jDrS4vDnoRXcFw4qvMysJ+I3rj96+xMtc7A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PqKvGbEhm9KcUVmPBkbSNuUs7qwZ/OqMekKM84qxKJb8lP5n+J77PtNkDQqLC9mTsnKJTfuduMqvg3Lwp2sGMFMK6B8OcKFXcMrXMqFHveETuGK7DoN7zdqFWI4AdbXpdQJFeRmKVzVM48F28QXr9cHZbQ9Zb2FRYuuz7Lpm5uqpB0OD2GjmKxqTvqCTqb8Z3eDBjuNFSKZ+WrmaA2YpUs2GUxXFO0We88ZHKZR5wfKBEVGUQb9u8W3MfEHU2BaGn32oA7wmDDzVFpYUDttF+mAEm2ha5oLwhzvkLq3yqBzRVoB/aAZxZYTO6n+jMJhixiaNcNLw7ZDDAMmblKIwyuN/SZyO2dhEVY+KYCplWakJazogZs04IZNhFQOC2mpk9DElOwO3y0hTvRKrNZesKzzc2gK2O/pNMLlIKkMMcBj2q7wqk1Si2H5dGwfWDMVdZQ5hyHZU4JJj1WS9ZQMmYMHwdvu9Z3kvAPxObim62aoc0UCN5AShxSjE41/Q0m8aDYKY9CpzVbZJQnvgDbfmSZA4LT1RRltbgGAsyFu5m3hN+bxTTn6d0ivxN8m3AQD7Y6RSZEJGRzdx5yNIOcv1zPpKf99NChwgwzFcWww1GsY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9635834-8a95-4e86-cb24-08de841dc879
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:38.7097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YoI+f8Xbqex6gtZdmaLDpWLB+edqBlqSQ8C68lxp75eutEMlb8i53fGh7NVIInlcQoD7V2fATZoPVvXNZSjAqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603170107
X-Authority-Analysis: v=2.4 cv=X5Vf6WTe c=1 sm=1 tr=0 ts=69b9440e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=KAAJkfB_3P8-iicpQfoA:9 cc=ntf
 awl=host:12273
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX03iDTrJULv5x
 vIdLhElcJqTgM3KPfWmvxMVfq0V0cCqD+Ig9e/233JPeiy/cRoDNJfyNJ4aWcgXBM7MVvX32quz
 u893MaChrJ3GXWp46SK8ADl3q4LvYrUA17VsBxtbHfaZna6+7CoiV8iJmvhfTKLgwjKGTNgJDxU
 3CBfgYyc1/6s42cYYBLLO06IXtnPxyhlISdnebHmfhRpuxlPlf3qgt50LHOQc0DP61DdNnMG+UM
 FilN162usQD2+UrsrUdd+sJ8YDtRPD+qZHioGJEH3CKJIv7AiEyOcBT5/r+GjVPXEdvaSW+q6CQ
 vJmg6TwbdPdosrPD69WvgPbbxCKTb6bVKWT08Xc/miIorOARaMjtwJvXWHfpjGF83ynGc79nEC4
 CgvdC2j2Q4BlgrslVhkNdW+348g6yxW/QKvknAtVUDAtFH11WbRCgTJ4/c1jutNZDaHtv3JnX6S
 bq8u8T/0tr60PIItnFcgEsQoFgkaFV56ez9vBWbM=
X-Proofpoint-GUID: ekTHaxyDeZVDRp4onqq5uq27MurhWZy6
X-Proofpoint-ORIG-GUID: ekTHaxyDeZVDRp4onqq5uq27MurhWZy6

Add to function to check whether implicit support is available, as this
will be the general check for ALUA support and no DH support.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c | 7 +++++++
 include/scsi/scsi_alua.h | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index c269105dbae4a..d3fcd887e5018 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -631,6 +631,13 @@ blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
 }
 EXPORT_SYMBOL_GPL(scsi_alua_prep_fn);
 
+bool scsi_device_alua_implicit(struct scsi_device *sdev)
+{
+	if (!sdev->alua)
+		return false;
+	return sdev->alua->tpgs & TPGS_MODE_IMPLICIT;
+}
+
 int scsi_alua_init(void)
 {
 	kalua_wq = alloc_workqueue("kalua", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
index c16d4adc915ec..2d5db944f75b7 100644
--- a/include/scsi/scsi_alua.h
+++ b/include/scsi/scsi_alua.h
@@ -40,6 +40,8 @@ int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize);
 
 blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req);
 
+bool scsi_device_alua_implicit(struct scsi_device *sdev);
+
 int scsi_alua_init(void);
 void scsi_exit_alua(void);
 #else //CONFIG_SCSI_ALUA
@@ -64,6 +66,10 @@ blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
 	return BLK_STS_OK;
 }
+static inline bool scsi_device_alua_implicit(struct scsi_device *sdev)
+{
+	return false;
+}
 static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
 {
 	return 0;
-- 
2.43.5

