Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284FD3FBEDE;
	Tue, 28 Apr 2026 11:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374798; cv=fail; b=mN52MSMpEZufNo4Umfli+iZCavCR3iLBg2tQVDbTFH1SYnYsdN/TkBPUeVnF+IEuM1AXA+AMS6Iuda74PaO1bHaNvwq+8o2zOaLxf7XbVHBGyuJDQ9M8JJFFe9KB97etDipg9RDR4o2q6Sj5STwpDemTApZly6mpgVM3k3JDNck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374798; c=relaxed/simple;
	bh=q1rQSXoFlm67ilN8xlKEg0iOQWFxEap5U9XPPlkwoLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oFo2TsGX5QROhDM6sHpI8n5c8WOoBBbj/6u1gC5PDTNL9oZBboMTZoGzTzGDX8EpE3OZaMtL41YdzUeroBtWCT1oVb1t4AYiXURKz5vLkfm2TsgRvo/JZK41uOuMHRzRX973jW13xsvj3MwG7wQxeG1AhkkkePb4HzJjOjIMM8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GuhTEMGk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OEAP/HJs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GuhTEMGk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OEAP/HJs"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9ruHW1015433;
	Tue, 28 Apr 2026 11:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/ggwr/FpAHTuoIttWBimz1s7obzLE67Tg9XwALR3ekM=; b=
	GuhTEMGkmK5jV6Apxav3xW3hm0wzgQuNYfW0dsleNaMUVpGUn9bwAR5X0aOQaYRF
	UCaf08wQybuAxGZgRHboPAeu0ckZdBYYHy5Lma4BJCLVmkT6P6Q7AhUSH4KBKG8O
	pf15FtBCYJN7G03Suhp6d5Nm0OGeV33yicEd3g2eQLIkWERr/S2Wfw2rLaD/TAOB
	PED7CWvmR2iRzor5ZwjmC9o3Xe30nxFyBFrBHvCSQmjMAmEWodlN5Je2rH07MNFU
	+sjEBk73Qz0yPO4DLWDD0NohGjLgwTpq1wnT1WBDTkqlpTUBmO3Qj5rZQ/z7NYBU
	PIhtkJrcuttCFTW74fEw9w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yyjvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2jYB002800;
	Tue, 28 Apr 2026 11:11:40 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010004.outbound.protection.outlook.com [52.101.85.4])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cchad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nY/Fr3XZuuZQE1gnKZI5zPMM4k6G4quJnkGxuoLNJYjX/E4Onm4H5Adx9cr+xunIRZx4G79alpVmYruwiDyC733ZQMSPnM6pPogMMbQEg7Rd8IW6fI2hT8BBD/LS1iYAZy+guqzhx3mw6DG0BXPCXEHAuD0SsXYPA4C9dhX+1H5uQ5Wbgtynl62ALuF3dsTe6pV2qSAJ59GrIkc77acqxN/BPKumH2FAi6wDw2yzwMoCuWjccb/xveiVLG034SjEeWErQWiNhev7oTJgVt4viNjiOzXXFszvhRn1mCvNx4U9M0I1qeOZiLnMvhrnrvBcQYGBMVR9iACbKN70DQJnuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ggwr/FpAHTuoIttWBimz1s7obzLE67Tg9XwALR3ekM=;
 b=UuOGCgIc1WzVSmTSfP/tddT9JPfEXGT7mnfsA/6Ou0alOGrXOZ+IZH1lIGbsgEfLTddnYwekCt4pEsn83mt2TiTqIHNU+7z73d4Y4MiJ3dDTK8Rd8kwaOw6B5MSnFtxU5KruNHkdfAoVykVVcLUifxgEGKEyoHs9tMC6eYTLUMUlZunsrhCGeDdvq7InIu3iQaC3EjbsLoSexKe78ZbxEE98d3vxK2f1Ja9dMcQbBHxYnqWDIpf++ZSufL+mv0CG0alq2xbd/ZisNST2Ii7lYRN8gt8PsenjCXWH/GX6UymrbBbYGdywWTJYeh9GCjBhk6UMw6aqPicZC9Fi89kphQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ggwr/FpAHTuoIttWBimz1s7obzLE67Tg9XwALR3ekM=;
 b=OEAP/HJsgsnX0X4LSrHa1yHWsgLvJL8jwkDMiTp+lHw73kRvG/2cH99MqXRDXoaDrqE5J5BOR8ytjj+Jaqe4s8oKEZgHZIs2doOjFWY5/vhAt/zaHRrL/McGykZD9eqG6SB8KVotbsrIkm07XFAhmzU09Iew+BmC9Jnz+AGBpcQ=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:36 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 11/13] libmultipath: Add support for block device IOCTL
Date: Tue, 28 Apr 2026 11:11:03 +0000
Message-ID: <20260428111105.1778008-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::15) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 5338a13e-16b5-449b-1766-08dea516e965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QlJv07KgEhBdZ15NGBXs8JeIZWphocTy2JdLCeVXAjbae0pQj2rhglkV0mAGy4wYbZDMEjIvDA4MwNZZ+11etpOX1UQkkXblQQQ1sLDwPJ+gmWLcekFTl3JEI1S4AliBb1ECgA8X2Ex8/voevU8T6WCLuI9MsZp5MvRF120dSsP1IAPaS8qwxWjwIGXbG33xaxx2ghxdW2RE0mx/KtySNzCS8tnx8HSYQXstXovCExzStE+WLKAGfmBdhwuJ88FTfxPb5MId9CKjzkznwcWP0XA0W5ysoS7nMJSfIl4qrg0FR1R7J6WHMamP/NOHY0Lc0F/Xlej00vUwEzr5HrXuM3x0NQb1doUXA6ExBDwD1rmLRJZPcHvjcxnjdkTerDCJB5RnDyJlKaQNcEN9YvHU8SbFh8JLeTl31UB/5AkPli2SmFQaRsyBvIHJMd0tMT2ulJ5+ZENVDCu/4SaXLHJVu/uxyA2OIAXZoc123T5GFpg0fuq9c4miZQ97E7QKwf4fL7ixRctGzsRlXWjP9QJR8V6F65SX2K5y1xg91kGQpx0ebNV1StCHORH+Nh/9h/EcsUNf0V0sW1ZjUX5O0BUx05uWHw+/KRkHmkGrvT9hCCHDy/UH/P8lzQZEX7FE+dYke7eU+hCltTaLW7fa6dTjK1BMcQxq2sR8WZ88FsAmcoFGBw8AflMEcnzQShPR5qNzF0ANXAfvBUMg9YAHAE2hzjO0GRPG7Nkhf2M9Hfu1y3E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ze+IFWIKXlUhPhhj9CVqGW5/WbZezEqdMMtGJKB5V2meugfsJhfq3zwhzoUg?=
 =?us-ascii?Q?AJZFpB+lDQZDP8T3rQNejMnC2I6ztR73YOxMkPJkE9tCEPiO/AAp01t3Zxdu?=
 =?us-ascii?Q?V86Z1i8lOwNR3gwKWxjs+Uoc6i2MtDcVIlB6IRbAgvsvtUMQZuygIv7xaJYz?=
 =?us-ascii?Q?qr1wzEwmNt7vZTvfLef64BWzSYXhQjcdrHwLUQkatjvid0StRxJPqUFKZx3e?=
 =?us-ascii?Q?7svYRUPMIdT7N5if7bypn/t7VRWrVlnx9XgHr+lmUCbW/FkBSiqQlxmH/LHt?=
 =?us-ascii?Q?8N6Th429gQpVlPAhk7PDn4LbHNWKQieI+LgscTAkMWSEwC8ytfbO0wPi4Fwt?=
 =?us-ascii?Q?MDT9CRUiJCIEl/KwH9s2Gc9Sdy7fOLfCwApiK4HmiashlMjz1yBqXK5Onjqv?=
 =?us-ascii?Q?yDbTUnjZr4Nu7KU76p6JtiGci2zrkpz3/TvFbMXDDTod/CprTNd86G6l5+1v?=
 =?us-ascii?Q?HU/ksg4bl1ixG7jFw8d8C5gwuNi+4pffpkfi13Ns60XjJ8ahk7SmCXOqLxtC?=
 =?us-ascii?Q?VCHs4uehTl4+pBh1sIf77iD0eYOlkQ9KybO8/tdaGgdaDp3P0C/SP8DCFUV4?=
 =?us-ascii?Q?AyLA+jtyc543A7XmNSqu+guDB/WCoL3wmiu8bljUmlDlTzCSHLpd+czyyoAu?=
 =?us-ascii?Q?bLnjJxRpdYpp/ZzssaZ3Tmv143k47htweS43mgzLuuRbUesBa1SixbVOeeA5?=
 =?us-ascii?Q?jGQ4HpNAM3bhY2i1EQj5St2Fzql+Ywlex/fcEJPuTp4e7temCFw8ydOzQZh7?=
 =?us-ascii?Q?wP3YMzVd9rqqHt1PhNNbfoL2Nq/0wZfMLKRb/ezQT7LhsMv1sn82ZBP51vEy?=
 =?us-ascii?Q?57+61Rd46gvvmknrLIqp+znokKzMuuFiARXgpJdQIh1Uaw1sQkP125DXvMLW?=
 =?us-ascii?Q?7//XkHZfD39TSSp12ENfS7ImjRk/VDf/IeUVAAJI6oyC+Uqc70qXlDpYp2gD?=
 =?us-ascii?Q?qz4nlsl8cR6JAmX80z2qkPAt3vhFYkfP8oN1i4Sef4t2/TlFyvEpwol3BWfY?=
 =?us-ascii?Q?5AqA83Q8VYYC/1vmyi0kQ3pqBzuUMAvqWFfkMHpaWtUOlrhHspFJLqQYAdXz?=
 =?us-ascii?Q?NWbzI4hffCj/irBTB0kgtXsixSAlQFIKO71s72p4ujh+uncG70MGAbceUnTm?=
 =?us-ascii?Q?Bzl9L1JpeVU8PeGwQ57hNw7QaudMNXVGCoKrh1qaWtAnxTrM+fx8jLV+QmpJ?=
 =?us-ascii?Q?29Zpkt//qmqcL0KT1Sl01NuvRc5pCrFNI03XEiFpMt6tYyJv2VXqOsAt8Jx/?=
 =?us-ascii?Q?Aio9QqgMtwTdQiD5BxXVxuRj3PCkZeh1JeJPogAgE+KTiL4zRDrIlQYsRA5T?=
 =?us-ascii?Q?ESNoflXyvQiRDv9wMA54+OZkZFByJr8H2oRcusjxKCW9P/Gi8uSGvixZFEd/?=
 =?us-ascii?Q?FmUh2Q2XOYCfaSY2prtqLh4V0cEurBhZb8aEvt3J63Gu5Brlc+LDw/eHpSuy?=
 =?us-ascii?Q?pDdkDQxjWIN4nX2JKFRyKtK3erqeranDhLtO5gz0iqefhT+tuihcUipkCXL4?=
 =?us-ascii?Q?R1XthFto6g/l5mvUBTB6REqjHefZdLZwkiNoqW7a5WN6RnIj6n+mvy/sVHYH?=
 =?us-ascii?Q?lym6TljN+yfdS+Ll5Esl/tAY6kozJHrUriclhxkZcUsVw34Cb5qXFRGFNeR3?=
 =?us-ascii?Q?bwRbxRQpX1KAX0ufh21Oy6n3Dph5UMWHM7aedC1qhjxeeRWWEdSb66muCykT?=
 =?us-ascii?Q?fFj8GOQ7Et8LFJsKd+6E0SstGp2I3oyfhUkDgFTXLqBeezWXKmvyeqfZZ1yK?=
 =?us-ascii?Q?yfpFchI4ub8idyfPKdlhxwIIsda/TZc=3D?=
X-Exchange-RoutingPolicyChecked:
	kOcnUtr84dQEikNcQBKTsqMN5mngCV5uq0X8jX4G00I6Bys2TJGofni+0Z/CdQmrsJhvYh6PWHbGJQEIrRpcRXJNA0fW2eVh4zjYZi5xCCgyzKIw9ZBU+rwgFAqdQgPNa7e2rT15gO+eASfn2YXdTai9y2W5l77S/geL9tX+aYkIcHQ3a5iDVL1m0W3vzYvcFrd1eyMVCwmTSyvUNp1xuD4wELswIaNkP2FJ0n6UdXU7PNFSCkqoPLAoOnIJr8KCIZNh66bE4z1giaiA71Y3QUpOFWyUn0qQI4SlyO93Y8vUwsdbXgTIG8gtiAFQk2hVNjZk1wxxqi4nfu+gWMqOog==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ILazpNNe8YLErdi9mvTp5jKrvMgNCgxIvvvSkkE7HZfsWVtcoqsg5GTNQx4yRCE0M6lkEeSvUnd8zFHDTfiiZ+QRTiSnUN4iJxPWfHPTpfC0NADKGOha1Uy8Xw071UtPnDJ17JmacyrV5GexFR3cg5y20hEpKNQimKUFIBe90adFyYQuG6yHsMlP86CkJeaoasIE5NhSjUYO256P+1QAJMUUoTN2jmttJYiMwka7BrZFPuJVVWecjdKyvmO7VbYf+12DJhPSHolBOUx2S0CxPmVya+68AELC+cvKPkjK17R/ophlWh+Yh3jeXOdcjvhtGpSlYHXMGOpvoxB0UsL1TDXZF1uBkir+dZ13sofV7M4oUA+oW6kxOz0qLkaLVWcqHinPGx9vN4KpX3FN1i9uz6dzfWG8yLu4Olm4cHuZH13M1iN4mtSp/IhEjxUl3i3bPgi2jw9akpFAiDGhc/xUJBwmA3b2tS79WxASgntUxzsk8q9U7ZADguYedBcZyaldb8q5Mw+ktY7Q/1u+Ya+feLuYnPWpbheBm7uIfcYIb5b4TjczmErQQr+sUn/ttlShZld0z75FrK1juYYhx4wYvQmhlB4eUKn+nMwrab46G2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5338a13e-16b5-449b-1766-08dea516e965
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:35.8515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KnrMT5/6ucW7ct7qy6wuDlRbeDSzMwY5hFqNQ+bY9IDrNEYCDH8JmB0GRSh6kE9Pfo46hbC+7AUvOymFyICprw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-GUID: Cf0GDO49aGmO4ur5RXu63k7kf6i6jQut
X-Proofpoint-ORIG-GUID: Cf0GDO49aGmO4ur5RXu63k7kf6i6jQut
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f095ee b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=4znCJx2T0Qr4yWH2F_YA:9 cc=ntf
 awl=host:13844
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX3/TaWZcUcLZY
 gntQfbRv+UkqBZ8B3RCXevd2Dq641gOBwVRSAAKip6Fd6lBX4jeHvaBx4N2dSTmauu6eEaqmREc
 LpopMMpzHNUtHT0HHLki4duMAIx2t9iirskXi5wBhLXSbmhBYWc5iWjsa1JVGAhIrpLyYPMBl0e
 hVk2NtHfrpJiysPSdMgn702qL9UKt+ZwzJzgAdyeYRq2DQO87Fo+pXEBpoCW4xZqod5WNWkhZUj
 SN8Afy8sSAUj3SLi5WEJhOa/X/nuoNMIH1DRjMi0xVgu55kK64XAAAh0V3vI1AL2zOSJ/BVICPx
 6w9cjZ/+Yxar1Z5via/M8WIwIOrTV/hQwr00xFzHBMfEGaON39gZXDbAffe+nrmrSea1oQEEbbT
 Eg3iS2gl4LqJ9pVr040tXBtJmUwy2PvdY5Wi5ur+2Fd8qgw3t9UACf3VBNorXZPqaeo1z4Gy7jx
 VCaklgQ7vqSUu/9D0Xg4V7TndsZiwmHmrwsxiPaU=

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

Like what is done for cdev IOCTL handler, use .ioctl_begin and
.ioctl_finish methods to know when the until the SRCU read lock - this is
for special NVMe controller IOCTL handling.

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index c72f35e02e2ab..e2998c1b277c0 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -490,6 +490,38 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+	void *unlocked_ioctl_data = NULL;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (mpath_head->mpdt->ioctl_begin)
+		mpath_head->mpdt->ioctl_begin(mpath_device, cmd,
+					&unlocked_ioctl_data);
+	if (unlocked_ioctl_data)
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	err = mpath_device->disk->fops->ioctl(
+			mpath_device->disk->part0, mode, cmd, arg);
+	if (unlocked_ioctl_data) {
+		mpath_head->mpdt->ioctl_finish(unlocked_ioctl_data);
+		return err;
+	}
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
 static int mpath_pr_register(struct block_device *bdev, u64 old_key,
 			u64 new_key, unsigned int flags)
 {
@@ -676,6 +708,8 @@ const struct block_device_operations mpath_ops = {
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.report_zones	= mpath_bdev_report_zones,
 	.pr_ops		= &mpath_pr_ops,
 };
-- 
2.43.5

