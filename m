Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE86407587;
	Wed, 25 Feb 2026 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034057; cv=fail; b=C0XO+pKdN/ysyJtMFYeK3tgCEkR6gXlwZzUHzDOdkeudXggnzE1KLXrRjQ6ziWgPs9cUYHMHrFjxOhM881S+wqcEA81CzRXZdfqyos/BfbvSpFsYqQ326QZLn2/XeIQKLBIV2EvF7B3mKmpdnHovOXQQDog+b4I7FXbR2zODdu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034057; c=relaxed/simple;
	bh=2B/u6kood5j2egQjaNMnGXVwmfPgO2zQusskMjF7llw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ed3aCWS6QVNsGQuetKOm6ChEUKRoyii3fRafX9LIjiDUnYexObBgN5+gHLeL8e20WjlUjLcTFq6Akisr8rukGcmMkgSQ/V0S7eY/kYuu1DStlCfCwUagsBCwu1ctCcQlMMA17lSV0Go3mvEbXCZaGGfk3C4m19hBE3UR1cNwKV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VNsF91OK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yBv+b2RL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VNsF91OK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yBv+b2RL"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PA1oNT553280;
	Wed, 25 Feb 2026 15:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UBj16VACUrfTOlLDYzAFrEDrOrl82H/c4dY864fV2IA=; b=
	VNsF91OKKAeCh1hCXH16LB4kj20+hEB8k/burV1Nr5qb7dFxprGY7pG/PmQpijjI
	jgd0/2Fr5LYLEdTlhG3kehzzzeyvTQ9IMaRb9QY4WEh8IQt8HFYCKHulPtC+jtgP
	8AaFQAVoCt430vNC08maO0yipNEhKZCzcExb3TfxsBAOu2DJwa40z9VbtUSPXhbV
	EU/1JGZ0g1qIcxp4kdK2g2+zMAnvIOXk3SJpjX6n9CIdWFGEumNAVThCZrKbikB8
	jxhJBPfYxItY/OkjprnC9unPST/yXYbFPT7Nv/m0+fhzjhAHiNDKmgxn6ldCfY7K
	Qg8RgWfFDW/qv5SySWOVQg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3pgfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEXOBJ006058;
	Wed, 25 Feb 2026 15:40:40 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012060.outbound.protection.outlook.com [40.107.200.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bge5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=plb2HXjvg3YTIRhj2/0WcCCd08WkjuRtMA4bhHt+gs1CUW+v3sFdhoFzw3U9rNMR3Iot644P2EYK+K4qi5UoAtSqrTYo1IbrGIOBaQRfaG4z7VuGUljlXSbTGjIAvvAF1XjEAFIRrlELLq9rKxzrYB4e+zseWdmKiYHS713BQTv4OLjWDc4cYpdqh8lACzqS48OT2aJ/J07XzVy2o/ldG1+3GcJoF+GOdlBEaCqUir42bFyMQXZmPnWrB+UAcdb4WWE+TXZ529D7BgDqK2MEfM8JH3TRzJ8acxa5hnjQ7gUSowjiyeIex2NRF4Md8DXmEGujNlPmSFuXKGM7MDb/Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBj16VACUrfTOlLDYzAFrEDrOrl82H/c4dY864fV2IA=;
 b=UjrHGePVNNkHGTUL8D8LLDM8M80YUyJ7GM5PzU8jNs9J1qQ5FKLwHGfO8rB2TKxKyUfniw19LZ05qaIlZOpsbbg0V5Jb+et0p4NwkV9ZdXL036z673CNtmx8d4rvJp6283hVKyEGBn7ZzP5I6bB856ecAuk+juUClTZAipqmvvq6/SImOQnarRpoCtGBV2l0ULh3DRo9slXJYaFCVAbSeicLCuWnrGJtuSZhAZBYd9I8bM/aGNggM6+8q0KoWFnYNOkD35T11ZXv+lHaatHYvlImZpVpbn7S0mdajVI3JKpd8qCs8fTxT6ZLhr55/POGr/HhmS0tos6IxH2LZ0NzXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBj16VACUrfTOlLDYzAFrEDrOrl82H/c4dY864fV2IA=;
 b=yBv+b2RLfiA87aY9Hmuo0KJMyGiLlaK7cD4uwgkiESTY72CHu8QTm1KrO44c4/G96gu+ffhFRJOzBBuwbRQyt6jFPaFHgTEBp7US992dIlsc2vLZ9RRkgCW0SunELYB3duQ3i3h6gn1bCyca7f+RsHemuVMBHLDEGvSG2sNdVJ4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:37 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 08/19] nvme-multipath: add nvme_mpath_get_access_state()
Date: Wed, 25 Feb 2026 15:39:56 +0000
Message-ID: <20260225154007.1033735-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0098.namprd07.prod.outlook.com
 (2603:10b6:510:4::13) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d359a32-21e8-4849-aaef-08de748438b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	qejoiWfVrzaeW6sHSOK7XizCgIl5s+oKz1e3KOjE0GVxqbrsNr/W9i6btZ8uHe6KQd/RkYLpVLVIN+9bbudz/aHRJA5qGyARfleGJwhkRy8HrYTbYsE7aqvgnZIPNycLiYDAkMI2Kh0Xd2yfe1IOY23G2wrIrOfiWnjCyvXJhiZAc+QjHdR6DyBRKmJCt4cUKTgMQyff4PG8iyC5H9A3NySluU0OCqk30IPdk+uWoyZSUXv5nc1/vYjYO4/eJ4yxFdVOagQWCXxQ1Qq3abOKHB4OQ9R/3ar25m8TiqDOfNfU1MrIFMtCSxtg9zwmXj7B1MQxulLQZf8Vn5ie7tL0KNq63in/euVdTIdNOGxeyoO4NcP8yQJAFjiNCuuGKp8daeKGrNejrhCBCWbKudGqvGU0aNqJz5tAvLpLveRux2MUYEhzwfFzeJN91vG1sHP8AQKJ0p+39Z1M1+sXG9oRW8dkYfCUlAm2odVv4yk+3W8Ss6T9YM2ALqCBvAgLqTI/hyYP0ojL+5L5+8LE7UkAiHOdneqR/7/kzqwQ5uok6TiIY/J54B5dMADt90f+A7/RXp2AQutwx+/zonRkAa1dbF7KXEgnvMxYZgNaLrrbmxNkt0ugSJSG4oprERGmx39rbs+CXEH9cAf+GGYvpUwyGSDzAn+8HZnlqJDneXaVP72QE5+ploeYy40VzgDOVXiOWS9ddpssmvzRboGM90Qle0qsvUDmfBC+vJKbxglTF2E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RjV/O9ml2Gom/hgKqpbOUUPEqiy+9xDaaSPbua9GOGjwL4teKynXAbhaB+AE?=
 =?us-ascii?Q?bEwKmP6tb9a3vIOFpDCRRq6DdEkrlUhFLsnovB+dluvdUMDRlw8vj2MmEWMQ?=
 =?us-ascii?Q?N29jVnJSRDDWXkSGUvWeiYLn3ifOEVTYXV3kSKxcRYQ2nv2HIchoKugtWfpY?=
 =?us-ascii?Q?VUDGYaO5ES+OE3Z7XxKhJWi+JGksYR41tSYAqa70soXWVbypdN03AOLuZkXJ?=
 =?us-ascii?Q?akLx6pyj3hQKab5KS+u0rrnFzkdZmOf8tGwkXA+qXwODIJMGn58jEu5ZBXjs?=
 =?us-ascii?Q?IVutTLM6cyUpeSTzLSwGmNXG/qu788NUYV5xpnrCOMW2KzLzg4QEIxOZBnOh?=
 =?us-ascii?Q?ue5984mG7tgUKZgr+K5CjSJ/gv1Buyll6s0xzU5Iv6SgxQiAgTgYcB8tB8Dn?=
 =?us-ascii?Q?35rPdxDQgDhDFgAjLIJCEz25kPezCO4cpC4bhoEKkrPgboTdXj6NSLxDITWx?=
 =?us-ascii?Q?ssea0GWj1McjnEKLnxM5dT+6LLkNXQI4m0KTGzZ3UKGoBzedhc1yYJbCY7Bt?=
 =?us-ascii?Q?/jp/hfJBHwiiwtxez0E7hcF2Mic1wfFzWbqCUim0WfIeEdyvbkbBMYe/ZfZf?=
 =?us-ascii?Q?F0L7kGl3jgFBY7+69JehsEjHtDY7cjW3zKBbIzH7XWeCTlQyOCxIC0JoCvdY?=
 =?us-ascii?Q?vLt2uW2rm0mJ7nDaSX6QQVNVtghJ25HHhkb5Wj/LEW7tCb5D2ZVM0eI3wDlN?=
 =?us-ascii?Q?QKx5ff4Z8wAO+g36CMz8L8B2k8uebBnDuNLspZNXQUGIgGS7xCIlL7XFG6W7?=
 =?us-ascii?Q?y6vmd1nQYJacagNqcMl3sMvAjf4WBqXRFILSvdS3WMIDSKd8xlUgI97/METW?=
 =?us-ascii?Q?J8s0WqJBUmcgfLCp4SvlhCIe+dvW/gj6TjBMhvMVuwnJZ9PpeK/vb5wFCG7J?=
 =?us-ascii?Q?+Lq/PxU9/UwpusiiJy7pDPJkwjG5uzaWc/QAqC4tKI09yB+SiDiKWyDeOMG2?=
 =?us-ascii?Q?v/tTSFf4bxPG+zeHyA3FqWLkR/k1RVEpuqUzL+16eakjsaEgEhgKxZW9V2Rr?=
 =?us-ascii?Q?A04Mu3n7lYy5ZbiJ713wWFp0Q62P+9wMhtqUSMIXLYycXwFc+eTI092uGpj1?=
 =?us-ascii?Q?+7AZOW8O21zrYDlioaBK72SgT+45H5Hu7QYNB+Hn0qx6koxOdqykmDZG0LQP?=
 =?us-ascii?Q?JUW3M/zNg4cVMVsk2fDJLuygSmFxRt5d7+sVQSF0Ph7SgeUlTk36WpyjcECL?=
 =?us-ascii?Q?IZE4ofvAmalhPf2hURmd0w2Mm6PFHnFgsX0m/dT7l9iBnbG+GiBs8koGrN8K?=
 =?us-ascii?Q?Wd1yVAu1rFtix3tfjDIrnIjCGhP4Jt8FOrRJNz2vvY8FJKeX9qIgp2YSqRwK?=
 =?us-ascii?Q?tuH+7sl946ITcTR2bBJE/2YOyw++lT0qrJd8Wur+GeOXrz3s/Bj0iKvRnlnD?=
 =?us-ascii?Q?Cy7WYeecn5WQzZrMaRBu72leZDvmZsvMqFCdTXviMfzI7UQ+392qybKqwtIn?=
 =?us-ascii?Q?psuJX4VCklyjxhnqGiff+7W6gwggrKPxGt2tV9fBa/V2paps5KHu25p5l5Qt?=
 =?us-ascii?Q?knbXjQ16JGbAgjHIu0XyLkBDceI1EwEbtKgL+7xubNvoCzkbI3IrC0vZCBYA?=
 =?us-ascii?Q?03hcpPoq2ZI7oomYJeAgDmYwjhjRcjv4mesrMAYh+itq85pivPqgUatnmYGi?=
 =?us-ascii?Q?dIOs+jH6wFXBiK6oSl5Np8P+nPzJf97DlgdnXTYhC6wE7sQdl6UHxP3qSY1Y?=
 =?us-ascii?Q?pfSW8URr/h1UQTlwaSCGGF8n7Nc4PTp8TIVP3a9bLUzoh8nj6krmR6urHUlA?=
 =?us-ascii?Q?vGaqxYPiGWdKCWxn4CxawzpwpInK1+k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O3wxWRR4T2Zt/peNP4qa+2kuXj89QhIJFj69yuiMeeWyN7yHiERHKQfu2h4OvEYFQCIAe5cMZe1LywZGf/OwzYD89HiCBTg7AL0az7ew6Kb/pLX00Y5mPmErNGK+A1FbZD/Rae8Y4MhGjsxc/ey55X4jXMAGS6hD12egitxF1TR4Ic2HDvQEX9psomYX86IQ80kauBs5HrpHV97i1JRBSoK280pVx6LwhfAIQDI9C9eYvvNBnMgdX0Xu8ztBzI68Zz4BBODKPP6T2NdJSJXrou2pnFhdkBWAUPbTxTD8cAory3+pKKSi3zTFrP0GPiB+5c+Tnk4kf1g1elYPw7c2MpU0wplvYzDfmw8BVfgf3q3+64TponmNRaJRus2NAp37fsK8X5gomyGGyjww8anErh8iKK1tMWMwARMnt4opyYNxFOgkW51z6ezp9DBbBcRLUdHHA5qoDvmsoOZvFMn7t9cTv0jkXdbkh1DgmufymB8hLm/SsEeC14sN3c6vKBuGAomV3faiANniERTVbgwBJ6b5nwytOtOsyEFJlhEfoLmq6d5wK5vAQHkKg5/w01bDPZaq55dO8HGfRbDcCnrREW0hnf59j6q800oprx9D58c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d359a32-21e8-4849-aaef-08de748438b4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:37.0756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X8ffxrDjP8WMSF6FDFA1UFCtU3i3kDa1rZ3a/md/9daV/Q7Gs9B0gn9D0NeU0X6ymT1NAxWyyWqExr4rxR7Q0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699f17f9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=-14dQaleHrdtcdPegs4A:9
X-Proofpoint-ORIG-GUID: Ay6ef9sgC9OVY0z1xxS7lKOfLWhPNDvI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXxLVmZtK44jf2
 PnoY+XNYyeER+3cmYgdAUe71aRsb+svVTuDUd8K4JfeH/3EHqNOR133N4WoBa2FBwbJ86XQv3Zn
 llPxoeXExuNPdMoHIR/1W1rUOvd5t1uNgpfo5BNzaQp5kl8GLlQ7i6rap1lzsxtw1gH7yOamhT4
 F+DuAT4NjYJWy4krcqTY8skvFTEOExjqFEXJYZIr77q0ybXDzQsQTy3nJ5MLCwVEAl5EPas6a/F
 f6M9fK3ZaSyBEee3YfKkomKgYSe6UGa1S0sR2slmzoGnz/oyJedW5SfKInPohF1s2M2lJDHr23y
 1/mDwwQ4PD+3QifpxBGzmH2tZ1Kdk0zyAAVtpQC7zX1BEWyb+12y2nGTyYM08KQx0HRnUr3fSKX
 0OkBYSSWp6gsaztV+Tmq2kJwzbQ3F3lBVeVq+TTRfaXX3LYX5r6+XYcPeZbMp5e7KGtyQ6Wxtsg
 zeFf+CQ3KvKwrpPr08A==
X-Proofpoint-GUID: Ay6ef9sgC9OVY0z1xxS7lKOfLWhPNDvI

Add nvme_mpath_get_access_state(), which gets the NS ana_state and
translates into enum mpath_access_state.

This replicates functionality for checking ana state in __nvme_find_path().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 07461a7d8d1fa..a67db36f3c5a5 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1464,6 +1464,24 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 	ctrl->ana_log_size = 0;
 }
 
+static enum mpath_access_state nvme_mpath_get_access_state(
+				struct mpath_device *mpath_device)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	switch (ns->ana_state) {
+	case NVME_ANA_OPTIMIZED:
+		return MPATH_STATE_OPTIMIZED;
+	case NVME_ANA_NONOPTIMIZED:
+		return MPATH_STATE_ACTIVE;
+	case NVME_ANA_INACCESSIBLE:
+	case NVME_ANA_PERSISTENT_LOSS:
+	case NVME_ANA_CHANGE:
+	default:
+		return MPATH_STATE_INVALID;
+	}
+}
+
 __maybe_unused
 static const struct mpath_head_template mpdt = {
 	.available_path = nvme_mpath_available_path,
@@ -1471,4 +1489,5 @@ static const struct mpath_head_template mpdt = {
 	.del_cdev = nvme_mpath_del_cdev,
 	.is_disabled = nvme_mpath_is_disabled,
 	.is_optimized = nvme_mpath_is_optimized,
+	.get_access_state = nvme_mpath_get_access_state,
 };
-- 
2.43.5

