Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970723E9F7B;
	Wed, 25 Feb 2026 15:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034043; cv=fail; b=ZdmZ+V6gkYJ7G7Qir0gP1z0traddu1oXmefC/5EXC0cPyZW4iF+M8WaXD5fdaUPHhoY0n/GSdxyY9IgKFJ/HHdp9ClmZx6x3/tGsKgP1hIrDLfwZcg3qMhfFymPUi2IxEMpV1aDYOTf9E/a9WvCTXHE3ouySPURZnDqeMues+0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034043; c=relaxed/simple;
	bh=5/4IXUIdbTwATrJOwyIug3slFQDfL069r2e2qV4XSjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UjwK+S+QMaF/x36xSCSmRfPIHLdJWDsjoSKF+xWsT/OMnugaRmY4vJt/IWHmDMxwdUtI3AtG54nYqQJuda2OtVCc7GKvsEDWoc6f+tH8tqTSLBoMO2nesqA4KRWwmCRFsPsfo+UbjL1FpXRqSO8IsORTJDeS/dr7FHfouCZeHLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lFC0yicW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bmkaLbFp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lFC0yicW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bmkaLbFp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PETBJC2703463;
	Wed, 25 Feb 2026 15:40:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=t4F1YgsZSr8VwnaPPP60oFYQYXTHavIf5RkCIbWMIyo=; b=
	lFC0yicWD3I0vBjdK5pUltIsrz5tUPSx7XL79WWe3KHHIHGbxuonkA98efJYmq5V
	iideauq9rLtrLRx0WnJ3xmOkVmf6el6ez3KMDoWy21MN/dgo+NAlfqoPSf5xT2mE
	/zU6w6U1p1I3yATwtwVX28I4Rifx3uY0mqMMEazq8uVeQnvd6wwVwyYUJve6LlHk
	SMVrOpIqMbLFqZ+ClJjyybyiiOYuxgJyJpDXAGc2BhGhqSGYxrMahP0NslxNC/Qx
	IwVKgiJRiSasqjxQKe6e7i7SSNNzVtxz0JfYjJ5UAzQDGbD3rDvxZE1hNWM3+rfj
	qWoATvLppJJsAJ8B6TATiQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbegpn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFAHrQ027842;
	Wed, 25 Feb 2026 15:40:29 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35g8xf6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Img315Uxb+7uwOtn6wlSJBfPzit4BvYsnk87OLESAx6sjHOpg9Z+jEDbfIQ3Rx+9KSpFkQqfDsjmq+LSjXpFHR4MfFYOFc8uYYXlexL5G0b+Y2UGjPpf//iqOpg9Jn9Ic1bcpjS6OhjJhBUlWQy6q8WK2tIBHte4jCJzPQI9nfw1XXpLiUVNxNO3ijVrUPMf4e/SNvw9DxuDMC4f5jKxm1xzy3aZwHISCvzIS6zXc6drNG1b7Q9QydxR+g6doRIcMjOk3sS7PAPZCQYewv8l+BCUHOTivbeHQ9GNUmKEc+Qk5CzNMzq/51El54Lj0z7W2xBIglgQ59E+PJZLkFgLZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4F1YgsZSr8VwnaPPP60oFYQYXTHavIf5RkCIbWMIyo=;
 b=OBceJDjN/U28qqM1ncGwM0WILUVedM2iHP9zljVFPgMtbImzBm2vIoCl8HqzgoDrtek555u0aP1mNkprAS0d4JUtkUj50yu4bCjDmNFxbxiWDj9yEgO2f1YbAotJZRRbxLmDfT/YbwW7FV1mqs8CKbdPZjpLHTNj36TvYDxbdhz/fJ2BtcAa/4At7lMnshR8zpRDHiHXgZ4V/1zBLQCWnsdSYpe3VqyZOusDaG5Np5JmM0rIpxIIQZB8TrlkbLVtH8rgXhbvrPrqFRamZmz68Mt1WAwzJx51JlJguJvSeMuOfEKpZDqkdDdE55ON+kyjIuaB6DQqUI51rFDL0ZUobw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4F1YgsZSr8VwnaPPP60oFYQYXTHavIf5RkCIbWMIyo=;
 b=bmkaLbFpasfQFVvgRjvHwh8/MZzz/IVCP7J54uV1wUXVV9edThovSwilzSmjtVyXnWEEH0e5RlNF+0QRe0Iajqz+F2yGbWZ8vVBDgX3/GEFOtFhp8v9Ws22CQQzR+eAKGzupgsx0QdiCoK3iPH1CI0PWs7diRttTvVDRxlFzx4o=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:24 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 02/19] nvme: introduce a namespace count in the ns head structure
Date: Wed, 25 Feb 2026 15:39:50 +0000
Message-ID: <20260225154007.1033735-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132FA.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::2b) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: a040e8ae-e3da-466f-c2f1-08de74843142
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	jlFVitFvO7uR+e9jjpfNOOhDQX5lEF5u5FfJnK/l9K6JajFuwHK/C+TZNApM5FOsjrOQISaurfFhP97JhgObskukpP1PNuXlcgWCU4S0Pz47sMeVONCsemmmGz+UdjCjkWqDdp9+2Jxa7+jTTRqmncw3wxEmlCIW8RJLTJu7srLjKsKQwTUfOcJ83n7PB9p2M63yg6yIh3r9sDYipJ7CVYRKybBVRe5kAzEwJDZ295Hfq+GFtVhSRkONsar7lXxSVYRj5z9ovgfpHerrFb4pUfD77rQsrnLT5hNWmMQoVCTqZ2CCrMd1lOAK66JBhAJfXBnFIhNvp/dbFjQa5m9YJ5DP0GZaNc8HqR3jH7G2L9ZiHMoVZRo7lkmqTkh268CabaAdj2HJysTsGt0Tzp1MZmpTVlRnwCLhK5zGmqSXVpkO9vS3sQP6+tBzeEFj6WOVUaVayZiOc6hXYuarXnhyNOD9sYa0QNiPlUJhCcKRsdAbDqDo7J7lQwLnUxVZ9gT80dXIqLUuqzTN5U00yOmonkaNKL+tZkOO2S/Sl65kVlHZ3B3bO9DRMcLPVoO8QvH1WSB8dR83uCd7pvFv6XKyKDGOm2vqac2Wejt3xOU9WjP3fGva84pm94vTqTk+KAuvkbSzLKoFQ9WUm3W7ngFwFAqcykE5MMnrL6BunDksBDncN7IL3BqmwBWadamoDygVCBZoxw+FFtck4E0v+XCWWEFmuAJSIl+RkjzlAnz89Uw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W64zz468OKGusERyEvhLr06zro7v3a4EwOvS0pCPRlrjKuAa5rPDObTgfY9I?=
 =?us-ascii?Q?/BiKBq3eHknwXcnGYaKr3DI44aJylYdnHXbtHwgqAAc0FC0CNIhP8cI0hIog?=
 =?us-ascii?Q?a8HyryB3YbOFhO8WdZZxBA+XI8DNoN/BVslnvveYaKag1d6ImJLXh/11DWJY?=
 =?us-ascii?Q?YSrhnGMS/9Yj/Wz8g6hU/QqUxySPSZyRo7HNIrQ2eo6pSW/9XTCL4lvzwXlm?=
 =?us-ascii?Q?g/0ZJoCnRch2v/scOH53mT5NHVYog5gfwKRNcPpa2d5ktBihSvW1VTni7+YW?=
 =?us-ascii?Q?xEIdQt2aULbZtGwKoYG8wZb/ylhnTz3zhBkKlEX0L5bqLOlc725E7XFWrhup?=
 =?us-ascii?Q?u75o/2yt+k7mp+07V99yx5rLHaJRxne/+lUs4KrAiq0z99CCUnv+nDa7954L?=
 =?us-ascii?Q?rBfx4Kbx/x0apE+MXayBjdYbkydipsAcK2D75Qua16LxOj7CkN7KhE330Lnp?=
 =?us-ascii?Q?fRNUvnzYyZak7rpC5WffAKK35NF5110zCPtL+8ZtbxLJJsyv2xSrQim6OYDr?=
 =?us-ascii?Q?yZ58I+Hmqi7SVbA3Mt6lfUaICdRtNBYRxllC1/X7UZTXT9BYy8uIhVRhLUVQ?=
 =?us-ascii?Q?Ekvj3GR4ZAMJWu3Hl+jskciaKsPrlDxrkdeSuD+C0OcILhwgdN8cZbGAMaoI?=
 =?us-ascii?Q?fxnaTrV/y22MtfXpnpcZiHoCkq3jb7cOi9XbZIBy7/CVs1hjDdWTk2HAGg5Q?=
 =?us-ascii?Q?rpEvBQ+prE5VuBJhDQY5Cb7gB2rF4B34tQgniGMwlbZ7whf7wU7yIxd0FpPO?=
 =?us-ascii?Q?64zlOvm2l5Plq05D1LegFJTYu+V9pX3PTZebdny9M0cW42nC/pKc50Gcwkjd?=
 =?us-ascii?Q?xDxwocqdjgknKb3brtqCwzzvCYFehWuzdKBD5s3iBEmLtSiVeVbN1tvsnIrq?=
 =?us-ascii?Q?suEiJoISeZTLBnrZAh4/DEemv+8IhEtA7TmxMg4saqUB5OLmyJ8m7P/oW1QC?=
 =?us-ascii?Q?HQ35c1sfi/GBYHS9n6mmrM2HcANTo6CU4GtPdsIV3Ys66A3KKFOoPu8FiTFc?=
 =?us-ascii?Q?zs/a1qB7YjQlOkXbnnDi04lxukqViytkRwXmWUlFyRQeUYulY+ctGRhcBCI1?=
 =?us-ascii?Q?Rbf/YToAk8ogRjq8aVNVQXUkIja+KhzQdkcp4VzupyF73zS53ERAIriX+nUX?=
 =?us-ascii?Q?IHo5+xYF7Y6VJLaN2foOEoa9erkypryLL5cB52PezHCuZro0+N+lEeDFSHEe?=
 =?us-ascii?Q?E+e4HaBuXHOgR0SBqgjzo9kWQeinlUeg8PJWu9Aew2wLLeiZ7727rBARx11e?=
 =?us-ascii?Q?77cbBSGygdZERpyqKYpCOBrI8snnfxrwOaD81hV9aAutPGXtbmvyY+3fDeCy?=
 =?us-ascii?Q?0uF62XJ26nmg6bIzjssw7+IbdkT2i/GAfkZvN7LmMaN76tIIlGsCM2KexrER?=
 =?us-ascii?Q?qvr/K5PlXnW4687/nKj70y4q7rsWT/7GHwMAmt4AfguIIN5pc2i8LOX8Pc86?=
 =?us-ascii?Q?rvp1Apm+0QsGRsaa4XzV7rusJ/Qa7YEEbfcko7+53FZlGyMrnlxiPrUwGts2?=
 =?us-ascii?Q?GhFfSS0guwYvtunM49pkxjnqL9g9lqMrIyvPoL6+08GQYGtALphB28jY0i17?=
 =?us-ascii?Q?DYXsnbDNEhSqDaR7qp0VhawlKOFdE/J6bo9hrnBNxx9GFx08e+qOwkOStjs3?=
 =?us-ascii?Q?pnKHlGyy2l8T3zYZswdryqBOu3q2XR34zJZl5rf+hIMn2vvEQQeN4ToeQhql?=
 =?us-ascii?Q?qyT2+rD6XiJgv+xYvsKD9SEY8mfGqLncDhOlAvMwdlZDUQnXgvr6JmlkCBIF?=
 =?us-ascii?Q?5VAmPK4JkRQRR84IM/l3kEl6Zw03u0Q=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e5fzOc4uhM48vxrKztohGDRT7C1K6pb4Rv8NLSzTFVdROlU52sS1y3u5V3AnfG2YGxyihoxT9Jm2I3CQD2rF1GmMySRE0tukDb5S11D+biKjvC+v3Y0h9MWT2D4XEnBq4zRKTIMxSkGrFeysryJKa53gHSJqitYsU6ReR4Bz4u5lTVeQrx5tms4b3gj/SF9/wUMKO54y6O3lsGfeThDbYfd1NYLgNMaEcm89RNEvtz6zSbz53/8f1ct0zadPFBrDi7Pab62zmwsaFxSVZEiGbuj5tWxc+KAVVdHgRm6hz4UjSZPiKBQpGeIEyKBD8gOAd4LrXxqsJLj5y1z/jgRRB3POoPqeyBL/ajY2Jk9YdhjN7i+NH3j/mABenuMNjEO0NE/FXgFqP5Bu3qhr7uLiTZoX4aNJf+qjrnCm4qy5RNwuHENYlZgXJJC4zzQosWxeKVYYoDINCbG/nOwuXXww43T4kn1B4VoG1voLgiDJFap7yEmSXRD/rwayrvA+8AMswlr1YMITrcyLiwYl0mjW4lroof5BJmjq+frCrcr/152veGAXrtL0jdZEPgQnmDei6rDVLbf/P8x0edxOLs0yCk8Rvsz2HNnJxSmIWmUlJG4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a040e8ae-e3da-466f-c2f1-08de74843142
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:24.6690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDyYY6kPHmuWXHtCX8rbeNQ9PbJ8jr4vDCbRJsIt4PM27T7jnJcBgY3+Kb04nZcgwGhgb7XhJx5uY0AlNoc1Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX4VtpJu87Z6Gi
 PVpRRYnd5dQpxbfaQAr1H4bXw6X7v86kd6gWfWBmWdYr4+afujYypkwNSidRKcHlRTm9QX4wbM6
 FXbBpYjKDdwPCtgZkYwD3ClvtT8MbXm3gjD2o1B0BJZw9V2w+lwgrQNelFzg1phYjFmejRUH8Ay
 IDFxL4cuzPRQ2lUn10eo97M09yPuSHwewDbKq4pSQnsh9+p+xY7cyhEQP7VIOlvQ64FJyUGT1wL
 4pEwIy7uPjaaDy/SI+GYkHu6eOIOP38gMIGNUylUiTgia42s9Xb11Bxzd1cgLAdqscBmZdK5WjP
 u6OVX7nr0OfCGXqA+Tkqs+FV/fC2B034d9lw1lEdb2SzOCrUpYAxDLdWrA+q1FOm2zFfWVBrkwn
 m0+LGWnPSUGrGdZrow5wcH0lBcFmfJ7geJyvZKDsVBWxV528gQD29qw61F3J/aTHJSLLqQYSgC2
 mQBGpni5OS1Cw23FJ9ow3b8qzHMhmpz2KPSJP70I=
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699f17ed b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=QmXYmMcIHYlnA2eLRDcA:9 cc=ntf
 awl=host:12262
X-Proofpoint-ORIG-GUID: H_hDjpr-94MrEksRFLWGpvfNWkjkkBfs
X-Proofpoint-GUID: H_hDjpr-94MrEksRFLWGpvfNWkjkkBfs

For switching to use libmultipath, the per-namespace sibling list entry in
nvme_ns.sibling will be replaced with multipath_device.sibling list
pointer.

For when CONFIG_LIBMULTIPATH is disabled, that list of namespaces would no
longer be maintained.

However the core code checks in many places whether there is any
namespace in the head list, like in nvme_ns_remove().

Introduce a separate count of the number of namespaces for the namespace
head and use that count for the places where the per-namespace head list
of namespaces is checked to be empty.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c      | 10 +++++++---
 drivers/nvme/host/multipath.c |  4 ++--
 drivers/nvme/host/nvme.h      |  1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 37e30caff4149..76249871dd7c2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4024,7 +4024,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 	} else {
 		ret = -EINVAL;
 		if ((!info->is_shared || !head->shared) &&
-		    !list_empty(&head->list)) {
+		    head->ns_count) {
 			dev_err(ctrl->device,
 				"Duplicate unshared namespace %d\n",
 				info->nsid);
@@ -4047,6 +4047,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 	}
 
 	list_add_tail_rcu(&ns->siblings, &head->list);
+	head->ns_count++;
 	ns->head = head;
 	mutex_unlock(&ctrl->subsys->lock);
 
@@ -4192,7 +4193,8 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
  out_unlink_ns:
 	mutex_lock(&ctrl->subsys->lock);
 	list_del_rcu(&ns->siblings);
-	if (list_empty(&ns->head->list)) {
+	ns->head->ns_count--;
+	if (!ns->head->ns_count) {
 		list_del_init(&ns->head->entry);
 		/*
 		 * If multipath is not configured, we still create a namespace
@@ -4217,6 +4219,7 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
 
 static void nvme_ns_remove(struct nvme_ns *ns)
 {
+	struct nvme_ns_head *head = ns->head;
 	bool last_path = false;
 
 	if (test_and_set_bit(NVME_NS_REMOVING, &ns->flags))
@@ -4238,7 +4241,8 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 
 	mutex_lock(&ns->ctrl->subsys->lock);
 	list_del_rcu(&ns->siblings);
-	if (list_empty(&ns->head->list)) {
+	head->ns_count--;
+	if (!head->ns_count) {
 		if (!nvme_mpath_queue_if_no_path(ns->head))
 			list_del_init(&ns->head->entry);
 		last_path = true;
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index c70fff58b5698..0d540749b16ee 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -703,7 +703,7 @@ static void nvme_remove_head_work(struct work_struct *work)
 	bool remove = false;
 
 	mutex_lock(&head->subsys->lock);
-	if (list_empty(&head->list)) {
+	if (!head->ns_count) {
 		list_del_init(&head->entry);
 		remove = true;
 	}
@@ -1307,7 +1307,7 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 	 * head->list here. If it is no longer empty then we skip enqueuing the
 	 * delayed head removal work.
 	 */
-	if (!list_empty(&head->list))
+	if (head->ns_count)
 		goto out;
 
 	if (head->delayed_removal_secs) {
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 057d051ef925d..397e8685f6c38 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -539,6 +539,7 @@ struct nvme_ns_head {
 	struct nvme_effects_log *effects;
 	u64			nuse;
 	unsigned		ns_id;
+	int			ns_count;
 	int			instance;
 #ifdef CONFIG_BLK_DEV_ZONED
 	u64			zsze;
-- 
2.43.5

