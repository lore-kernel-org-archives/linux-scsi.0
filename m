Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E8D40FD8F;
	Wed, 25 Feb 2026 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034077; cv=fail; b=l/U2b+HFthfMzaUdzfcAS7gwMXZo7qp2u/yPO2bHKil7TUYZnmYdingucHg7WJcls69yJnCDJus5dzjLG8tQpaZcqM40ncbnwsrBubbQmKelAOyKsehzIzJCQkNdii+zPlCQ7jaXagc9KpcSRDEPVzXC+fPOyfIEM5axSJy8d74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034077; c=relaxed/simple;
	bh=82uLIQTi8YnoPuORENdACDYbSVWe6uqqSJ4l8bjeTuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XJiVwhbgttqmQFRTMGHzLLrHetPjO6imVAcE+QCJRwEB/JzFnUBl0O1LLoRVld4+MQwxEKjs7oyuI2mS5YvfWPDrI+Fhgz5MDl3VYSoDQzFhZRi4k+sZE6Pfi5cv2DG0X9ezhcP9xkp5CXuUxzNBksuTr/4OtyZustqz/iVrb/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PPCdPOe2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I3yJkVMf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PPCdPOe2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I3yJkVMf"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9SM4M3927989;
	Wed, 25 Feb 2026 15:40:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MpdahrpD0k6O2b812OdSrKXzfptqz6EkiYrqBTF6JKE=; b=
	PPCdPOe27eFqzWSWgbUvlQtiThUDqttVM7ZzrOgFj/uC6bbXETk2+EQOXM9pfrK9
	4F8eHXgM2+AlSSByf/uZAd9az5C5IeHdUpjNLj4IHsXuFAdMLPIGLDZvCoAtQ9hC
	GmYAdqIIkJy90M9V1z+uBaA5eZ2H2+fGpiH5skyZXLHHWHurxZP+Tqo0KeDezMSZ
	QU4TTGhu2t/UH4C2ljCKzBcBN3ve9SfzN7ZqYopG3CKNp374dTp/LNYYuBFEYjud
	itu+zjd2ZhpTtyOkhSZG5/2/GXjr+J5yf/gNzDygQI7cJm7tSq/ORcWdwBJDzw1f
	HDMF+zve8gVMx6TgK6x1SQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qee8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF958P027845;
	Wed, 25 Feb 2026 15:40:58 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011006.outbound.protection.outlook.com [52.101.52.6])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35g8y40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jX8kO2kl3BP8534icyHPdMmTQWXoNxDB5Nnw4RQKfCuZ8em9LC4jt8c6xskBbFFn+zwBUNuzHOSup4ZcYjHYjz/KSoPGnFhb++EPuWXxa9VTIId43bnrOcLi2aAWwlGxxrD3Bxo5MwbBSZ76sYp6PF4hSYh4yC0aCcf7FyJarjHRl8Se413is/LrBdTntWF0D1J/5/3Zs70fSc/QmKI+HJztuIgvwMVINGgRmPKKoPgvk0BU6xx81hNXm+SYVfIzGafb+vcBorQ80J0pfq/a/aFehDUtPxDqmMeFoHS+d/Zq+H7gQ2h4b11jhptIJ4W2yO12rvQsvPZERftKJxJu+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpdahrpD0k6O2b812OdSrKXzfptqz6EkiYrqBTF6JKE=;
 b=NPAN3Qq2kEEukJZOLQmvIVbMBO7yJRN9SIzMHK3ZkgD51bd0qknFCV/k4RIVKcmyY/ICJKtTpDUJrWbrxQX4Mtxr5Q8fvVeRQHNRg7W1HAUsyEkMEbvseowRW+t4AVVeyeKnRAqarLn1zq73g2cLhVoCizcKWwdI7m/XhDJDQhGAR8GElbcjLjYoe93GCZOXOBwmgPFFdCtewixYO3BxoykhphZvSr4a45nsM2DSx8FH/f4IhVThBomO0bWIyElCO8dcpe9MoLNi7pGb/lm+efCbEwZHX2+YMmTcpCjbGFtaGRUt5ztHC9jsxGjGkNiLZq9jLSELauTVmuiOzyiobw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpdahrpD0k6O2b812OdSrKXzfptqz6EkiYrqBTF6JKE=;
 b=I3yJkVMfSN+s7HFlkOiaAoCzwQ/SHG+EJCWyK1RegmSZPB9mO/RA5a88vi6CGCuCGssYJYWkdkrbZZyCz+juyJoCW1em58yoXrXrpjdIY3f2BmDnkPSVCssHMglffHDV8c/GKGKmofTlNiHO9tLf6THQDmaLmKUJv9KwHTGmnPI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:52 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 16/19] nvme-multipath: add nvme_mpath_{add,delete}_ns()
Date: Wed, 25 Feb 2026 15:40:04 +0000
Message-ID: <20260225154007.1033735-17-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0612.namprd03.prod.outlook.com
 (2603:10b6:408:106::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 1562218c-e68e-4296-6cde-08de748441e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	udqVB+3ypUvIW9z9ulunOehhGbC7zYhAs8DkLxRi7E1RCeXBp0j1XwVh6HT06/x1rkejzY9kS42tQLj5qvmYg2um7GlMfJFu9T2hZtUt8ZneV9wuMo1ysGRoVTv5sLtc6+AUFrwpbVwtdkACgzxo4wU5uumuDC/lwRocvSnsP4esbrvmNJPQXXsOZOZu2sd1/a7VJ/9YsLHOyNoEkmG5DOjPijO2Pkc6ajNQk+qyR1I9z7MDtBeQEqQucQk5a3HMwPuf5pruVzdjgSGfniMG5RKzbPxlqR6lBJAkw4HUnhX/4yrarNjUNwCoPhXt7Kw1RYlsPgNmjEM3Msdb8GNxdvjiAVL0kRiUXaRFKE8ftFZr3hLjUPgSCshIqme9onZ5uThdLYD2qlfNXaWUoHSxVKHImWshyLg+k7DANCe/XX8zqJDqcuvm3JiCki/byvt/FomD201vpQ8TfiYHYDyrEskbmwbTIppqEu1JbCsJDu6jH2sMKeRj0qmqRJRH0LtHyZsKXvOGEKF9HDt9IQ3/MwqJl+7+bKOZElvu2IinsgZk2y/2s1xgH2GtHcDsY02clshLsixMc7YpSmS0QjVlPiveCLGW/yPHMRHRSobfMSUuVVXB3nYEU7EEApxZG5PYFJdx0t9rIjAb7tbN5OSBehhhsAdchKtHCk4lKnftADJJCvPb/pYT2WeiM0a1xM6GeNZxr4eNpSSS5eECJ/3bhv07cXtTjHmI8rbPpRs7S8w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kyuhz0T7qFuDdBp34xo8eSHyJpfOAddiYMtI1yH1gaF2eRFyrKBDEa7CtVez?=
 =?us-ascii?Q?OKmkLM3wnMt5JoKOG+GMMb1V9a4KUnxGNn5Qafma2B8klLtGe0a+gd+afY42?=
 =?us-ascii?Q?Eooe9Oc7m4rrOWrUa7E9SZ1/oqdFA/qUCtRl/Cjtvb20IBpQlIgVgpcXF5bl?=
 =?us-ascii?Q?jELVUO/7gZcVRgP8HEt5xzmYR5Wt3h+ozef8RJYlTmcXmvYMIBWWVMmEdmbd?=
 =?us-ascii?Q?zBfRt+R66H9JpwIyczdZUnFVkP+yalJF8dwV0rWd41vCK3Z5br940iVp3s9x?=
 =?us-ascii?Q?dyVGcHuVDU++m+loGdulzFnMA/qJbbKIdbPCtVMr/yJKW3O0M+y+xmfTHeFJ?=
 =?us-ascii?Q?rXG+UOql9ii6C9bDUWPCIB/z1wkIGLJIwHlnpMdQmGRjGn4WmSNKDDi63nc/?=
 =?us-ascii?Q?Ui0kEtGBiOnRz8zt9oA2gw7EyTM3/1denM8TZacL0xyds0w2yV63iP22SWxQ?=
 =?us-ascii?Q?wDwGwiVF/skr6y+e0KPZVvZ0tX+ltQSJSgiSuv0HFBLGCxUyQtE71bHV2+tY?=
 =?us-ascii?Q?/H1rGqH8YfVmYQRYW/1D8s21B1lSdITZGPcWjBd+OojGDNm4GAvFvBHr1cAM?=
 =?us-ascii?Q?XAhSylV0PPdxVmTy/p/Gy3070eiqU+8Sm/sk/hC10q4vHAFKQ5QEJBBGb6xh?=
 =?us-ascii?Q?2k18nZlHW0wojA1xs1woAHNjlp+3sjhUMbbWc9bhr99BF3vMNPm/Thl6I2vR?=
 =?us-ascii?Q?qrAWM2QXegrz0sGyiLVcMwKodD+H5FduAr6zu8GZ4bMp1LRb9D/lOHMYgQx5?=
 =?us-ascii?Q?lDafRuXg65XnsE45eZ/c20VS8wCriP2oDwlbytUa/b7Suhb7Q92RK1JTYBl5?=
 =?us-ascii?Q?c4W7qr0pOd8TG68iBh1wWbjMtTyGn8vdJci7kxlbixYl+8TPY2DnzqgA3HJp?=
 =?us-ascii?Q?PuCFvKkyb8nIy4L88RZnv4dtAfyO4I2rip2Yfi4XJHhqPb1TvG1LsPPQIf5u?=
 =?us-ascii?Q?bdxt36WoXceAXKtnXatHD/PL0RwEt1AnbM2E7UATj3vdWjHRN85KtNFuTL7z?=
 =?us-ascii?Q?6/2Dm4icljzAFjdKfTZUoxczxtdROVvfJ5TK9nw2zVketKJFBBWs8VaZUcVV?=
 =?us-ascii?Q?lY4U4qnCAaNKBCRh7HEHNONm3R1bq30IQII9r7/+DhkIv+Po1FAlkkSQ7g41?=
 =?us-ascii?Q?EbmOCqTmCMlgeo//TwEkbikmlmsOXDlSvfGGFTrvOZ6XvzW9b8KpIhWvwHGK?=
 =?us-ascii?Q?qrQnz2cnggdZ2MClO+NQlAQIMIcovVbTLcSCBJfd3cy7eTSROd8D6csMO2+K?=
 =?us-ascii?Q?dWeR5HMspwi7SxhuxUQUWh35QAalLnxbPOMIj+cnF2Ss3MaaAlgX7cT7YFB/?=
 =?us-ascii?Q?E01s2CerqUMHU3RXpGv6CcM82B0xswA/qFm7QKp22QrdC4/tH/0NZvjegUYG?=
 =?us-ascii?Q?zq7nPvkDedg4cAhgj3bixyGKQjrki1gOU98G6h0L0HAUVfOGEIrMIqHbJbaC?=
 =?us-ascii?Q?H2EXhO74tirBB1ZfyPWsRAGqCOBXkHBWjc3IqcYSpdkT9JP0YBvBToZ9uIc8?=
 =?us-ascii?Q?Yc3U9VDAH/Gj+wyTow8jk8k1fOqiZBrEJaLapb7Y8RSeu9qaN9jCc6NyMPgs?=
 =?us-ascii?Q?ryr0EH68dV0AFiIbhS1FJVvdJevVjSLQrXvzQ4Yp1lZMODoJDv4zi5o/W3WQ?=
 =?us-ascii?Q?YMOTwmJo4lXLafkyX7dhV66kFGoDeBPtEUErXck/ucGTmMX8qaGSronW65yM?=
 =?us-ascii?Q?OPuxa5tytN+DnVo47ReQohKuVI0dmYsvFbWitDn86QpP1MH8BbkX692AmTrh?=
 =?us-ascii?Q?Wr2LXzDs3EFfiOSz4utfoZ0thOSqoTM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5MPijs1pwy+owhpoCySP17gFvFaH6FGdTt1Lc1ibImjCTNLs1CPPHWiQF3FYBYdAU9Kfv3wBc+GR72x/ZRP7gNvEIiMuhSHXzpN+6X99MUTbt/u9F3M6nbzuyr7ewZqVYXV4XXRAjJOOBA6bHNcDwxMGpweF39heREw2GWPNOC6Q5vnwRpymfTSt/tZTYjXVQRSfvNRAX6gzJ/O0dY8whh+Z55IMftaBYArnI2GU7/mP4EgXQP2y7V2aZKhmHB4wzdPWdxxr36HibkM8lSu2X2lrKp1xqNF286g7NIYarPyflfvSyV/4dv9/+5wdAsKFntsnBuNlmVWxFIV4UjG/pSjyZLCHNDLib8kEm8Pfly9Nhv1bN0J9P3qpIrFc0m/cvujpvyBF6gglSqJdE3XUucsHWGgKW7iynuSOy1CiZPTXnrhTSxnFpniMIwIrkaOj9I5aAZKPFoJDmvOEnI5jkbYPYTBsPjFU4g5mE/FpUHqQkdfNpe7NLBl0oQOe6i2HUoJKrmuB+z8fUR0JzyQwX/p4iDVTLQx7eCO3rSpRd7oE8t0Uo6FpLyXvqUTVS6jGqOxMppdLymwlIhKeQosiUtEO1Hc3CNQ9O5uOYFSM2Fw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1562218c-e68e-4296-6cde-08de748441e4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:52.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ucWeAFW4CYuO6aIUqla0X6ryndbK+HDvEQOHefbPZSek8giyOPLhx09ymLd8jZSx3LIj2cxC7QIp9GMmS9qjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX2O1ff2LskfaH
 n313B/mBhrcTEujqGR9Du+Q3AW/FHkGM/kbFhRl1I8w4f0wP6Qsgoq9lu+WAP77nzu68o9ExQgi
 B0WW1x90SYtHVwcskDziLD9TcRw59vsEyqWaD71WlKZfHRGes9TTWUjsyzWjWhR0bqn5Mgq2Ll5
 vju4DKfWDx8HhxtHzgWBqVcR5QjPIJAL5VRZaCJuJ5YOyYA9Fsu5cNh8iCbBoVfsUr4MsNXZym4
 KNFiU7hV6zDfZoJHN49/t4nrB40TBLSMtBtVogsG7F6Cjd6/T1xA+nGgjN5MtXTDG8JtO7uIiOP
 oRHJ6hCFN+xY+J9hHMVo6G4fsqvpnQiWibj0GSeQtq6tm3hYWgxLu/k3y7WWWAUrKxFoWdGh5mi
 4KgpRtwNHtVgWe6irmSo6EBsxNZwfzSA2KgGtX0ibJclmzK7IYurLcDre1F2o5c9UG1KVMNEUgV
 yx0qifeGJN+YBr6INcEQg67IJ+Yzh7mE4oFAq21w=
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699f180b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=Xn93PK7WjqZmNzYOTbgA:9 cc=ntf
 awl=host:12262
X-Proofpoint-ORIG-GUID: N-vvZat4rh2JjBFOMIZoV_-FBnPLZvO2
X-Proofpoint-GUID: N-vvZat4rh2JjBFOMIZoV_-FBnPLZvO2

Add functions to call into the mpath_add_device() and mpath_delete_device()
functions.

The per-NS gendisk pointer is used as the mpath_device disk pointer, which
is used in libmultipath for references the per-path block device.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 26 ++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h      |  8 ++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 7ee0ad7bdfa26..bd96211123fee 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -982,6 +982,32 @@ void nvme_mpath_synchronize(struct nvme_ns_head *head)
 	mpath_synchronize(mpath_disk->mpath_head);
 }
 
+void nvme_mpath_add_ns(struct nvme_ns *ns)
+{
+	struct nvme_ns_head *head = ns->head;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+	struct mpath_head *mpath_head;
+
+	if (!mpath_disk)
+		return;
+
+	mpath_head = mpath_disk->mpath_head;
+
+	ns->mpath_device.disk = ns->disk;
+	mpath_add_device(mpath_head, &ns->mpath_device);
+}
+
+void nvme_mpath_delete_ns(struct nvme_ns *ns)
+{
+	struct nvme_ns_head *head = ns->head;
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+
+	if (!mpath_disk)
+		return;
+
+	mpath_delete_device(mpath_disk->mpath_head, &ns->mpath_device);
+}
+
 static int nvme_update_ana_state(struct nvme_ctrl *ctrl,
 		struct nvme_ana_group_desc *desc, void *data)
 {
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index d642b0eddf010..3c08212e4a54f 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1028,6 +1028,8 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 }
 
 void nvme_mpath_synchronize(struct nvme_ns_head *head);
+void nvme_mpath_add_ns(struct nvme_ns *ns);
+void nvme_mpath_delete_ns(struct nvme_ns *ns);
 void nvme_mpath_unfreeze(struct nvme_subsystem *subsys);
 void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
 void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
@@ -1099,6 +1101,12 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
 {
 }
+static inline void nvme_mpath_add_ns(struct nvme_ns *ns)
+{
+}
+static inline void nvme_mpath_delete_ns(struct nvme_ns *ns)
+{
+}
 static inline void nvme_failover_req(struct request *req)
 {
 }
-- 
2.43.5

