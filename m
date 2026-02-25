Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0911134EF05;
	Wed, 25 Feb 2026 15:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034097; cv=fail; b=dQR3wWZodJ5FIbbJP69ridWZvF9vbLN6ysQ21E/Iq3Rp44egHiSkZVl1OFzsd8ICpSODCqelFRzgMav89/Zl72ta/g/NZYENJLu0ZYtvpALIyU+PdGk1CpFSwLyj5C0YS1hgT5+gUyS0VxMV3LlJXkLy/Rq922X56VkjQNw+6JA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034097; c=relaxed/simple;
	bh=AFGOWN0eXCpplyQmJnaittUK48HLoKMw87E/gJnHiBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CQpIJJcT7A9Yy9Bb93XkmkQCuwkTnyiZnuCPyiiL9RpNKQS1aQ/LS7zzR1Sl1sWXNvwT6mwKFvuXSNyTZ8SFiNNq9Aa7+Xj8Xs3dTVMZCiDBeDIh2teJfsT3r2j3SOUJdyKYTpUa7cykKve8y7sYVcyS5hjLwe9NaPpuPNvRZck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IgYL8tzb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=irr9VIp1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IgYL8tzb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="irr9VIp1"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAjClQ817392;
	Wed, 25 Feb 2026 15:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3VNKRwcxBhu09Hrl8043+J1LdhMGueH4K8+IJi2W8Lg=; b=
	IgYL8tzbO6L2QV/XWqVQzaW/ECUmXzfHYIABeDHq7LPEs9hYvLDEGrSYuFjDD+rt
	th8LisjROkmthEiyLu6IraIAAhYzErzXYC4mNtdJj8O+cotF2oZfeqIxRR6Z5vZz
	42pvrYhCTCRpd56HeG6/ZSoa4ohBkw7w/KIwZP1yCAXtIomen6qJhmygAqVoTm9I
	vGVU0IzNiqVM0es2HH2qaChFb3FD7lAe8oZpwBhq3+L8I6vSYukXc/tCaVRVwpJs
	n6zqFmZVFjkLqERBjJV/58LwYs9bK+MufhcVuGvHGpL3Bgk1W0AzX1eueRjmgUsz
	6PSiHEOmB5rvrrdBV9dy1Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areetr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFCLrt038517;
	Wed, 25 Feb 2026 15:40:45 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012002.outbound.protection.outlook.com [40.107.200.2])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35nfwuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eBK+FUbOuXR4tKVI8KYsyjV3y6UdjRJSDp92EAAJBN/hX/IhTI3vbIDjWTqqxaEC598I92gpJ2BVMy0qcywU1cOCtXn8XIp0y1nZsld4I4uUhPR9FBCn0lfA9tZdU7ekmfSDwYnv9fQPIfcy7yh4LaBcuiE+ddbAt/Pw1xi2FBsbmxE11T4xc2Sp1G06O+nLkJiL0KHLCWDVteDmOSnMWtm6ioWNYTVKLh4s79bZ0U8BvGW1O8iXcu5rLslnRC6dlCGh14u2Xs57r+MvVsq2BmR39miZF+R12ezssPYKoL/afDIsOQ9YEch8TjXvHTUmgJk7rgEk4lJg/J9fmJxtPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VNKRwcxBhu09Hrl8043+J1LdhMGueH4K8+IJi2W8Lg=;
 b=Jni2hr+pLJqDC5w5w2teNgevrQutMtzCojKvV3ym9epSlMgictO2I4++QSvvN4qCtmu/vvumH5FPVpSXlEtApktW/uDeRNMvFi4O0a+QGysuvkkFEinCtGLBfFOs7ucsBhWSTqTQJIAvgbIs+B1w5ZmlhkmzmVIo4cTkAtXhKLaY3gy34jI/PiAorDoUnEzGpyFwdP51goFP6gv4Cdhs4ame1BvI3HOu7441yYkeusu91JaE4Gxmhu79Kcq+vCGhj5D2SA3TOj6BbbVyM4g/2u2ey39wHQ+9uzyd1yoKbGcbNO/P8lN0YX6uumBu9I0+i6OmT6545xSCmTTnz9ng9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VNKRwcxBhu09Hrl8043+J1LdhMGueH4K8+IJi2W8Lg=;
 b=irr9VIp1n3PDYxwSA0KOypiXgJEdrca7X5ksu5SXp7o4ZGaM8vX062JK/DG2m9GgJWY7lZytyJYpvAew4E4shfUUVci/odMz8sJ50o+dKGnm0Y+b3CZejN2Qu6NOWUm+EbVPGtMWlnow7Jl9O2r7Rz7rKHSq2oNdVHpyrb6j5AI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:39 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:39 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 09/19] nvme-multipath: add nvme_mpath_{bdev, cdev}_ioctl()
Date: Wed, 25 Feb 2026 15:39:57 +0000
Message-ID: <20260225154007.1033735-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::22) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b8d6ee4-852d-4629-0b81-08de748439f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	K1RV1x7MzwPxpLsO5yfcOHBHcaxRwm4aWxsBIoDvqACQl+N9ODgdlnfjjQ88WQa3hqTy+5KuCUqXS7ag4GfNAGeJ3bmn6BxkzR42ObRfU4HKVax+HBQKyQNgadqbFcFhZApX+LZ9w20ZjhD8cEHGO1M674qgkFcrbp5aZIo1MYWuEXYVGPhv6XlZZQcvMcS2sYH85Qoaxw7pM++zigEAJs2rXJ+GRjjjaSorlMmC36xNfWPPAVvBkBEyxHsrrXyDKT4gzh+3AX41cV8FwVy4HPJ7hluQYkDB28G16XPVE7AO0Ej6x9/Zo64hRjmpi5gIJk4gwnN7UK0/VkGXUZVk4aCDNvkwwavfIGx9xEP/pcebtS+WEzNW0hD9YZOTcuEcRW4wsr5QMoxwyXAuaEBJx5VIfzB1nLSuOxEJshvOMf8f+mqIWbAfITH6YayyEO9tvJNhx4KVUBwq5eU2JvxoM5xXBXL6aeqgjX1qwLuDc2YoiO7B7ahmpjpZeEHEHzzq8cAyetz5Xe3QRoOYo0WOKKlQngPkBC1gUkJT4oJHe0hE0veexznQpzwiXWISvBTH3qoxdkAsX6AzYQNO02AGOVx0CunQs9vlC80KWr9CwpdDI1WfccWbTCOL7ag3AgdV7pDkei5Ac0kJk8DhRDBAighMDcnxEqd3kH2ULZ7J6bYTJZlnMC5wu/ONy6F8ZSjRZLEVkD+S5A7Ha5SQwTrh+8/zyrL1fJVHWQcrvj1enRw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vf3mCbYoL0xxHnZTZ3UrNa0iI2r34eSxrvuQuXdOIbpUEq8r/bOJz+o50eM1?=
 =?us-ascii?Q?eu9Z8EHGVrhUW1VQS/+7pRtbmayhcxft5BZozw7n6nLARCDbtGUwxTLQiIsi?=
 =?us-ascii?Q?3LBuiby0b+vfAv6UePdk3u80k4gO6/OZhfSPhZVipWy3KDmdRrkj9luPl3GB?=
 =?us-ascii?Q?ZjBDHeSgyKzJBShJacyDs8pe20zet0NPNKG1ply6wzfsTZipcIH9owEt05D1?=
 =?us-ascii?Q?33gFqvvGmAGzTKxr/CA9EeNZzvJNYwyOOcuQRaTzzXQaaL5tgn5Tl2enPINU?=
 =?us-ascii?Q?4iaoH1DmZRu9Jy7VMAWYhbLhhW6wlXbrc01Rnqf58b5h0Pb8KyDpoxhMt/s8?=
 =?us-ascii?Q?6ARaZ2vZ8leebxbp0EdB1yHTmZUU5ZNkZvGpjY9OaQIHH59mXt2y88Ekxkt6?=
 =?us-ascii?Q?LL9WKDZW2joX7bT8zeBm+Pape6kQ3kSC8lxPYQdl5NymZuG8qbJnFse2Fjot?=
 =?us-ascii?Q?XhFFsatqcs6KyP8Yz2qBQbYkKGVgaAW7WDgABVkFLc2M35n5OpGZLPzwSrXW?=
 =?us-ascii?Q?Yv0akunLFUNYiCVj3OgSIe8NaGOFB98VJj2v79vr0F8+uql6dJPtKkSwoqMe?=
 =?us-ascii?Q?1bnsu0bJdIGBBA1FflL75rZD9n4fVhHFzmE1d5BTa2sGkcpLeDy4KjIV6Q6m?=
 =?us-ascii?Q?xemAlFxClLbTbU+VLVogcXo+iUVe5mA12IGT5kYvbZHawONfopgkiP2bcpZw?=
 =?us-ascii?Q?mw34YqyEUF90/PI2F3m8VeBfVXmPxU9BFInq/64M15xlFq6tfAANBz5TkrhI?=
 =?us-ascii?Q?lykF2JTFLUfbawTLM5DE+2xh3bfAiiz57qVUM004Dv+00QR89JQZ+gfcGIJu?=
 =?us-ascii?Q?gVzoJY1s3l9wG53/WalgXpiG5CWuK8HuOSDD1zPPLvYgYkt/cCyYx75hhLYP?=
 =?us-ascii?Q?/hfidWaP1rkgqBdz7o5xv0/ffgaM8/1/pbjE2J+WCAHmp8qLk3GHr8RSouwe?=
 =?us-ascii?Q?TBF0bBDEqolnavghpgbRc5r0rafd94txmhDJOS3moBVXzfmitmNVMyAiif6t?=
 =?us-ascii?Q?8HqdSzl5CtBM0czRkuXwffcAmp7oQl/2TBEHq+ukyc6zQ10LtUAW2nMxI6rh?=
 =?us-ascii?Q?IisSOz0CHwvrgEKBItphVH+ytfhKSjNpZvZY7+uLtMKVaOOqnnTOYW7mnerw?=
 =?us-ascii?Q?iMLkbWqONex6BK2UMHw0Z6btXJR24rbbDAg1+otv9R2TAtrQ0DdVqiPUVIib?=
 =?us-ascii?Q?Ql8wGgIK9bbnRAA/o52XWqMeEYdNfK5djXQxOy4mZiNzO63GiNhlKcaxX1Wg?=
 =?us-ascii?Q?PKjNy+rQ5BLeKQSZMd5Ywtq5bUKgRQfoRdswB+XJ5xZnE9aLvAVEpBeB562U?=
 =?us-ascii?Q?tYBBlL4n1EUJEiZkgIMgt2HeVlsnO6X/zP26IDhzK7l+V97sutJqjvSo/FQq?=
 =?us-ascii?Q?rvHUyBSYUR1nMZc+5IcTFtXcqtkkUV8OJ6LX+E+KSdbKUXiOSd/9tpif47hY?=
 =?us-ascii?Q?MeZO07pMVRIGlTCYJRB2wD52Z2ehhEGWkxxF0FL1Cji23cBW8PzC/ielIpYm?=
 =?us-ascii?Q?eAkBxoDzXOxlL5tFyd+JI03N9AvjcRKkhbsHPMXZJF1y4miQ1rfXAfwKdhCi?=
 =?us-ascii?Q?rOz2E8aLGoeVGmugtEZ5nmKHVMazHranSnzRAHnOkgRNCjcIk6s0QnhDKDmx?=
 =?us-ascii?Q?7AaPn/7u5lSMHZSw+Dpxeq+sNBJbuLW2NIGnc0nK1xaAROFPNDapbjEuZuX/?=
 =?us-ascii?Q?wFY2ocsTrH0J5wX+skEvxV4ye7bci7jmqwULZ6pEShX3Y9xZSWtdS/VsMTSL?=
 =?us-ascii?Q?9g5fxUaRWvv7HyYjE9P0SS9EjD+h7qI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tBUsIV0N04PgCu8/HwLHOuOjUPV1i3wSG+N1RKQjPCjmdHVV+TyEc2HZGwxNdm5oXw6Isn/Q+8WLbeHxbMsMW3GfgaajpZwh7GZVN0S4XGs4iIvEhhWX3oB71XKx7qOez4DNoTmY1CxH23lMzYKyuy3d8w+0y3V9hVlG6yvSvk8X99sneawE9h5MxrDGC2/Y2227VfstfaRD7pLr+G52qFxNFVgoDGO8H+kgsAQnJkQTmyeZ80j74sazuckIisSKRkOA9RccizWa8Xz946WTWw8cBlTLFvS37d0UPeNW6dr/ytuKMLd90sAPb7SBEq3SQoUu+AoO8SMNOIGlPJYcP9ftvv6t+szw5QUbKdJDbzBFRH9Ed5ljJAFvEeET2Jp7b7002fkgzAqXXGnz0uFNkPnYhoaT2gUAcm7/r8169drzgJtAvVX7gsDq+j1Vu6fYBjW86cnvUfd/D9tsFXro55BOYoKJI2GGrSmRLKbVgEwSOKK2yoMABdI2Ag6vTyTJGdvhlzhoFZYOVNcVtIS96BrSkVSk8OFKGPHSgZ08mwcc8LZgJH5Af44HsaEwW9DEcwQ4lKhpg0FE/i0SkxOjnRgEh71IPNS17UGzITcAJhc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8d6ee4-852d-4629-0b81-08de748439f2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:39.1151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ssKZmdAcdFVYRmi6XxfPTI4OPcDHnbxN/Qn6V7/H6XcvSn+ytKdIaS8B99E/2l44pfqUM1XE4NLQB3URA7gUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f17fd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=3GUDSd1fvbfyDRxfsxAA:9 cc=ntf
 awl=host:12261
X-Proofpoint-ORIG-GUID: d9RGSStuHwpBlZownrG6sidkvES5Dj0O
X-Proofpoint-GUID: d9RGSStuHwpBlZownrG6sidkvES5Dj0O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX93Sh5JFCkHd7
 qoS3Bt6qE0SWFnUR62bVWCA9rw0FQVZmxRn5oc7pWsyh+rTc395B1zPiGSK+y55xM5rM0V9GKi/
 RpaZ6G9XiJpuDZBmJ5ytme2jsjw7TDRD2mAhKIurGuJWNidwcY6FuEBJOJE7AXCod49onoss34Z
 iMu8ETboEvKoe88Eb9U52qFKAcxtrmVf4wU0NggQm4ouodaD5C8Nuoil4mVRTAU0XGlApbleoJp
 OyyspvFcc0sqnt3AF71VyTY5b1+KxvGeiW078EJ55F7/c+kdws6EdOSwJ49ljNcCwKVrqFIWaO5
 vFN4yoj6/XISSiknPEaOy5JyUI3HngPGkNJp8/3sLUc1kG5UcvwZsAuI/WrKfoW+gL5nSQaeUkZ
 yLZFi3k1TSBsCmDeGwFhMRNqLJM3L13qNOkGqk1d7t6yhVjR9KJ9tMAoq2e3LYGpVqSlYXOVOvO
 AJPZgqCYnnQT0vyv6QtZ08sFZJ/qFyJ9PjY1xqhY=

Add ioctl callsbacks as follows:
- nvme_mpath_bdev_ioctl(), which does the same as nvme_ns_head_ioctl()
- nvme_mpath_cdev_ioctl(), which does the same as nvme_ns_head_chr_ioctl()

Note that ioctl callbacks are called with the mpath_head srcu read lock
taken. Since nvme_ns_head_ctrl_ioctl() releases the lock itself, it
is expected that the ioctls always release the srcu read lock themselves.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/ioctl.c     | 76 +++++++++++++++++++++++++++++++++++
 drivers/nvme/host/multipath.c | 42 ++++++++++---------
 drivers/nvme/host/nvme.h      |  6 +++
 3 files changed, 104 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index a9c097dacad6f..7f0bd38f8c24e 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -682,6 +682,25 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
 	return 0;
 }
 #ifdef CONFIG_NVME_MULTIPATH
+static int nvme_mpath_device_ctrl_ioctl(struct mpath_device *mpath_device,
+			unsigned int cmd, void __user *argp,
+			struct nvme_ns_head *head, int srcu_idx,
+			bool open_for_write)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct nvme_ctrl *ctrl = ns->ctrl;
+	int ret;
+
+	nvme_get_ctrl(ns->ctrl);
+	mpath_head_read_unlock(mpath_head, srcu_idx);
+	ret = nvme_ctrl_ioctl(ns->ctrl, cmd, argp, open_for_write);
+
+	nvme_put_ctrl(ctrl);
+	return ret;
+}
+
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx,
 		bool open_for_write)
@@ -698,6 +717,63 @@ static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 	return ret;
 }
 
+int nvme_mpath_bdev_ioctl(struct block_device *bdev,
+			struct mpath_device *mpath_device, blk_mode_t mode,
+			unsigned int cmd, unsigned long arg, int srcu_idx)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_disk *mpath_disk = mpath_gendisk_to_disk(disk);
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+	struct nvme_ns_head *head = ns->head;
+	bool open_for_write = mode & BLK_OPEN_WRITE;
+	void __user *argp = (void __user *)arg;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	int ret = -EWOULDBLOCK;
+	unsigned int flags = 0;
+
+	if (bdev_is_partition(bdev))
+		flags |= NVME_IOCTL_PARTITION;
+
+	/*
+	 * Handle ioctls that apply to the controller instead of the namespace
+	 * separately and drop the ns SRCU reference early.  This avoids a
+	 * deadlock when deleting namespaces using the passthrough interface.
+	 */
+	if (is_ctrl_ioctl(cmd))
+		return nvme_mpath_device_ctrl_ioctl(mpath_device, cmd, argp,
+				head, srcu_idx, open_for_write);
+
+	ret = nvme_ns_ioctl(ns, cmd, argp, flags, open_for_write);
+	mpath_head_read_unlock(mpath_head, srcu_idx);
+
+	return ret;
+}
+
+int nvme_mpath_cdev_ioctl(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device, blk_mode_t mode,
+			unsigned int cmd, unsigned long arg, int srcu_idx)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+	struct nvme_ns_head *head = ns->head;
+	bool open_for_write = mode & BLK_OPEN_WRITE;
+	void __user *argp = (void __user *)arg;
+	int ret = -EWOULDBLOCK;
+
+	/*
+	 * Handle ioctls that apply to the controller instead of the namespace
+	 * separately and drop the ns SRCU reference early.  This avoids a
+	 * deadlock when deleting namespaces using the passthrough interface.
+	 */
+	if (is_ctrl_ioctl(cmd))
+		return nvme_mpath_device_ctrl_ioctl(mpath_device, cmd, argp,
+				head, srcu_idx, open_for_write);
+
+	ret = nvme_ns_ioctl(ns, cmd, argp, 0, open_for_write);
+	mpath_head_read_unlock(mpath_head, srcu_idx);
+
+	return ret;
+}
+
 int nvme_ns_head_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg)
 {
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a67db36f3c5a5..513d73e589a58 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -642,26 +642,6 @@ const struct block_device_operations nvme_ns_head_ops = {
 	.pr_ops		= &nvme_pr_ops,
 };
 
-static int nvme_mpath_add_cdev(struct mpath_head *mpath_head)
-{
-	struct nvme_ns_head *head = mpath_head->drvdata;
-	int ret;
-
-	mpath_head->cdev_device.parent = &head->subsys->dev;
-	ret = dev_set_name(&mpath_head->cdev_device, "ng%dn%d",
-			   head->subsys->instance, head->instance);
-	if (ret)
-		return ret;
-	ret = nvme_cdev_add(&mpath_head->cdev, &mpath_head->cdev_device,
-			    &mpath_generic_chr_fops, THIS_MODULE);
-	return ret;
-}
-
-static void nvme_mpath_del_cdev(struct mpath_head *mpath_head)
-{
-	nvme_cdev_del(&mpath_head->cdev, &mpath_head->cdev_device);
-}
-
 static inline struct nvme_ns_head *cdev_to_ns_head(struct cdev *cdev)
 {
 	return container_of(cdev, struct nvme_ns_head, cdev);
@@ -690,6 +670,26 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 	.uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 };
 
+static int nvme_mpath_add_cdev(struct mpath_head *mpath_head)
+{
+	struct nvme_ns_head *head = mpath_head->drvdata;
+	int ret;
+
+	mpath_head->cdev_device.parent = &head->subsys->dev;
+	ret = dev_set_name(&mpath_head->cdev_device, "ng%dn%d",
+			   head->subsys->instance, head->instance);
+	if (ret)
+		return ret;
+	ret = nvme_cdev_add(&mpath_head->cdev, &mpath_head->cdev_device,
+			    &mpath_generic_chr_fops, THIS_MODULE);
+	return ret;
+}
+
+static void nvme_mpath_del_cdev(struct mpath_head *mpath_head)
+{
+	nvme_cdev_del(&mpath_head->cdev, &mpath_head->cdev_device);
+}
+
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
 {
 	int ret;
@@ -1490,4 +1490,6 @@ static const struct mpath_head_template mpdt = {
 	.is_disabled = nvme_mpath_is_disabled,
 	.is_optimized = nvme_mpath_is_optimized,
 	.get_access_state = nvme_mpath_get_access_state,
+	.bdev_ioctl = nvme_mpath_bdev_ioctl,
+	.cdev_ioctl = nvme_mpath_cdev_ioctl,
 };
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index c48efbfb46efc..11b63e92502ad 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1047,6 +1047,12 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
 void nvme_mpath_end_request(struct request *rq);
+int nvme_mpath_bdev_ioctl(struct block_device *bdev,
+		struct mpath_device *mpath_device, blk_mode_t mode,
+		unsigned int cmd, unsigned long arg, int srcu_idx);
+int nvme_mpath_cdev_ioctl(struct mpath_head *mpath_device,
+		struct mpath_device *mpath_head, blk_mode_t mode,
+		unsigned int cmd, unsigned long arg, int srcu_idx);
 
 static inline bool nvme_is_mpath_request(struct request *req)
 {
-- 
2.43.5

