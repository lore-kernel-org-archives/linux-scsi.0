Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1684F3F0769;
	Wed, 25 Feb 2026 15:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033878; cv=fail; b=WHfiPttHIGlQpFimDs3Ljeyv5OfDIgA6kGkK2O2p0svPih8ijrzLN9z+sSCIOcIi0uOC8I+ynx07tb2biKErwvA2+8M2nXCLLdE0mnjx6dMgJ8qM6XuqNvCdA+ZRLXADkVDS0HiDn8F1bvPJ2aa0hYKKrg6aPXVhr5hDb9fAeEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033878; c=relaxed/simple;
	bh=P3PW0I2prMNhHNrzI0dqBfiMOJ3U77orHBSTXwds3qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jpinh93w7ylvIJ8ID4JsFtQj+OKRbL/TJIltWeLoKdH3ttLNfTepNC+NBWQIaQGV6FmTnHjsLW7QP6rI5xD0GRJr5eyvL6wArfDwPX90cxxIWF9CLhNMLlXsmCwwHh/r6WEOVIKbg3ssts1l+AR3NzEiKpKsoEIWDKLscGU/VXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cRsZDxTX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cugp2wKB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cRsZDxTX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cugp2wKB"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9W7Xu3927984;
	Wed, 25 Feb 2026 15:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1vGxw/15TPw6vS6ue/9wJx5FGbnAq6RN1yzDV3/yivM=; b=
	cRsZDxTXKnOQ32oarWOtS6lHk7I6TWIWA6/Iqhi/jtWlSDUfpKejf44+zskiFp7P
	XFbHLP8jqEQ/CptpfSGlw591ggfgy6uAmGJbGTd9K5AKCsHEl0hrNnMjkCQjv6B6
	tkSOHciIaZUfco7u3Tn2/VypUcrKEW6qjGU6vH4OEXEzs9jl74KFSX6pMSD9AFAC
	OIoJ69B0kUcIObZry3/VpjeCMbvowKC7xLHafdoHAmBq14wvJLSeHoEE+7lmHpNM
	hEHr7gGJi+e4k9y6HZr54hvtt9cSj0ZDMnI8hevBETC/SpzxGG7Sq0KhNoWxVgGq
	pMD4A97BH6K0n+Gk4bJZvQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qee0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PDo7Tf012482;
	Wed, 25 Feb 2026 15:37:37 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010056.outbound.protection.outlook.com [52.101.201.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fg0sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TGnB3tnkB3tI2EU2iQumJZhaZTxhn5zPxQJbUbyP4u0aOj1cAfLZEh3sFaWZFK0A8sfxm/LREmUWNfO8EblB2j2flLzO76uiGGWemwm1bSIPEoOkK8C4j8naLy+T1KhYZmRzgFh6jXo5Y2iXywEgOYIW/FICOqqEB9NoZeM90Dr10Y5U6GPshVz6eBpWwDATRF5tSv0PY1WuVzbZ71rxuycTWBftBMYhwQ78mDKbmN4CLCVFuQF2Cs5l2a9oCe8NSxbwM+KiED2lV7NY0y59zuponiVdhJgDXyKEmuOxrE6lwuMEz5YVrsMSwpOnzbQyXVi8QsRX5APN92fafRCZRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vGxw/15TPw6vS6ue/9wJx5FGbnAq6RN1yzDV3/yivM=;
 b=N0ahmP13Bko9ZHNTz2TljPnCDMthObvKk84/aNO4C13u7LMnoGUAT/DXMVH2pBlvvAzhpgTm4E1w7o3OERrhTnl04wFEyH3Upm7YqvhRSJRmcMQ9NbgHiFpQaTFERSt/wFS+9IVWu4FihXOZH8CzHDFJsSKclYm+OVrzloHUNqeEzaV7mLvrOcX6jbc9D3lWxUeVHCAn62FJhNm8ZiXq6msVVeLDnoMlJFddFqXeGYbmiJWAenWsOtPwx9bKeEVrrNPyxu3qYt55oImW9dvbMpJRP+ZIlFRr2fIGjal1rSCG5OW5guiWFI/x/Y8abu+86KmSE+i9kwrYF0IAMR/xjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vGxw/15TPw6vS6ue/9wJx5FGbnAq6RN1yzDV3/yivM=;
 b=Cugp2wKBd/MABOWl2UiIQd8qAyYlLYQSS8TfbaIsCCQ+UHSqjVnNXE5vx8jv6Nxn3sxsRySdFpyJJirvoHnDu0lJimu0COjQIIhS6/HkxFPhxiMjbmqv+WGg6H9Djwl0WN/5mcnSoFaU7LWH3GGwIUS0MTeC1xXck1/jHmGq+K4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7956.namprd10.prod.outlook.com
 (2603:10b6:8:1bb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:37:30 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 23/24] scsi: sd: add mpath_numa_nodes dev attribute
Date: Wed, 25 Feb 2026 15:36:26 +0000
Message-ID: <20260225153627.1032500-24-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: e37d1e7d-5ce3-435d-3606-08de7483c9b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	F6TKMVIopNvyexvA//hynoWjLvQEAfrVLIhl5R9P/JNs+DabJ+3tsteibTn4733I2fr1pEq7P+3fXIt8Dl12l7cYlloSV5dt9Nlp2xuXefHO2cpYHgB647x7733Mp8lqGagXZhIKvb/x9Jnli/erFIvKI8JCib+C4j8vpbXSSIvMARs4xHGsWr0JARhUUjGYSlBpebDv52qRcA++IxmmQniMXxmPlYCpijV+slAtAY07d/jh8VhWi4tO/dGfKqKsuwAkToYcaky4tUCAKhKQud8MtZWtc257qhgxFIrV4n778icUYndv48kfa1fi/1kyUapK7IZBrW3wQ+CeQGTw4ZmbRYwdg3tT0bSQ+K6ktlt22Bw3Lnh1at6F5ThH71kCfy85SIVJMbjOR1Lxp4D+aXCgRhFSK+/KxBh5pZ6+8IwtlefCA+CZLTEM4eag6+5GAOkCu4ykeSU/kgWhyGtHsFXaeKjC6ym+0emw4rC7uTYOXThBejek4i2zV0YKBHZ7nxXZA+o2lmSLfNnlZrWc676lh7Darm2wP993m02GJZTXTDncJRN7ZmWPFiCL1xXp3E5polu3B/b4mm2Lx3ZlECypLrCmM7JMKw1vUalavA/F9l1czv/oHc8UjJ/Tb6Ft4y7S8qWXCBgHSQD53sbvZMsP2SZZCIbnRrLuJWUMDsx4nm7n8GmnZAokNMi0RKPSiVrMFpgb1rUDONqJTLsc9G8NXZchUjofAqj2WN+lvxY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?68OgS97B5ShFYRfutarlAombBpxUf0SiScuVv6F+qcZpJvlt7t3X1m+eJtlm?=
 =?us-ascii?Q?1pexbUNW9qzDjxXjB0vwuDRCsp2WmicVA6lIVjyVcASl+tMrTI//owR1mKv2?=
 =?us-ascii?Q?k9Z7LXgiTV0ZX6Rd0hCULqA5QWbSiQyNu74tyBrBKmUkuFQNv5GhLx1ptnKv?=
 =?us-ascii?Q?K/FQ+t0T1Kroxz0pGdy0yO2CwqZbN0q7Y6jzHBw6yhyh3VN47rOTRhYhHcTH?=
 =?us-ascii?Q?QldcL32XucHEtsDbl7WgZZtF277zaaqDo+11hAl+weu8qxORcPIcQCIGuL6f?=
 =?us-ascii?Q?vxwVLixPwnG+Wcf7NPATXUkYrsORBuE6Dcg2J8rmdl+zDRSZYXxmgeEOLY1Y?=
 =?us-ascii?Q?V3GpNSj5kmtSgOoE6SYj2zmtMNs5z2gcf/sq8S9KV+rxnQHjzk/RpvZl4YqX?=
 =?us-ascii?Q?GVbciZdE05yLHhQzpnl3m8FLZ+YkZV4mokqrZE1wgMg2f5LmgoeykPcKFy/+?=
 =?us-ascii?Q?4fGGklpXF1szKmkRDlsXa1JfqhYWuUcWtYLXFDbiJFD3osXVJom1t+Rn8E3g?=
 =?us-ascii?Q?gXzCKzAG675Pv5MIgQ3l212lu0FCSJeRqy4CgV1qDO+tam8xcW/chMSDn8Wj?=
 =?us-ascii?Q?yxXm9tpWrSF5pWKD7XfplSuDfgr7ERp0VmlXQQn1Pj6IM7fYbcLDwhMfUmcC?=
 =?us-ascii?Q?KkB34SgNrUk94dQeHMa4GDy3i4zPDygUD9NYBUjGTwNgLNnu7bV1pQig6kju?=
 =?us-ascii?Q?X0X9+PcoNArQ7/1l0EihE8QwTnaC2aSq2CFiTr+qy9o9VhVDSCp+j2/9OTtg?=
 =?us-ascii?Q?sjVdp93S6ty9ec+bCFYR0nlTG1oXe5DyME0F85mikkxCgE9dTR+i5fMIZtPk?=
 =?us-ascii?Q?3+p6Zg13u5GHQrSIRqiMWY35M/FjQ2y+Toe2EJ4bgsmT1+rz/w0jGY7+Hz9+?=
 =?us-ascii?Q?pNUTjRKrJJqLjjE/7nm2KVZKIEFx9e3cRq7LH1s5zQcxM5EvKEaNQTx2RpQJ?=
 =?us-ascii?Q?GfJBlMepuEF7RdqBn7Dc73phoc+NI8zO+da87ZvyjQXIYyrRYVqJFI1KH4Wi?=
 =?us-ascii?Q?ocXW26gsHngkZlkNJ7JqWlBhNqsdxFC6EEM/yDCQboDP0xuyKNSfXv7ZLS+J?=
 =?us-ascii?Q?EhMo0WUbiKGKwGzDDbEbRa5QcL216t9VlefTPkoBIYEasYt7psYPePkl1Y7/?=
 =?us-ascii?Q?Eppz1j2Ru9ZIRS3u2H5GoBeNOJ4EMtfiV3p5JMXYFM4yrq3wBrFYNhGQ3Thl?=
 =?us-ascii?Q?zvbcUDFhvu7kcyACo6sfUdTmuRHVg1SG7XOhPcfF/elEfbtd+wYT0UfT4tyM?=
 =?us-ascii?Q?QkKFc1Zz2gmsQuE3CLi0vkGklg5zxfs1w+AF6elhNO/sKnNkxuPUt5IhbBeX?=
 =?us-ascii?Q?yvK5AnWEP1SkoiRwe2MBQ/tzvc2mQLqdUKmXE//czE1oxBO2OeXYpEU8oSLK?=
 =?us-ascii?Q?h1dJUGrMiqJM160X+Z3+VY4O6Usi0vYUANQCEiHKoK3Yt5oqRwe3LVHuJc92?=
 =?us-ascii?Q?vX28USs6HAl8ts9UCOf/rx7IcaAX/ZReI+AriLbDvcEnBdclrKWxytLedY9X?=
 =?us-ascii?Q?+VTrC27OZSdwd7AVVQnCyUnnz5SA7nyFl7UJfBUAwrvSSIx9Z0N3wzpQPEWN?=
 =?us-ascii?Q?oVPdwOfqLsV8E+a2sHrHDuvKjmactQfbLun+JmCIUrGDVzvNzPfTs3mkAnYn?=
 =?us-ascii?Q?djQNNKRJ4EP6Uk/+tcPQa025NhTFIUJvymsCtPeBcIPqWU3gIqAqpnEDY+VP?=
 =?us-ascii?Q?vMwy5+RhJfC4TIGdayuT69i21nfXPmLwk/+msbZ8Ef1QfffZMSwvlzzA+cAJ?=
 =?us-ascii?Q?IhR0LcHkQwBqFXxN646TRS3B2o8RLBE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W/t2MS8gvG8+R12Xv2TWY1GkCzi65hFHhZ+wYhZ6GbBVhDzGztOPYPZ+WM6CJxHazG8jbQT5xop21s+Z4YOQ4RqrxJH/1LXAIzZHEueDIhaxZwEN9PaIinZFe48KcFJq4MpxGjOYXZnzDOm7E0bEa6opJZIrzBCMhi9ruaEjg3ZvAFVGchgWsjRunnjsiY1Rwj4wqKvN8COtL1UzC83ibMGgGlbJpyCGQag/nYYuw4fKZfQjoF4Zji+7ekPBbQZ70q4l9Ob8s+bcdLnLKR+OUcJ3JZgrNDfdlcGt1vZWZ63fw6tkX07ADI3TKByv+uaflzTg6sdX52Tsoq/WTMeFBA39wJ8g/UuiBorQWFLNriggnQddZVfWs+yHUoVjdd1pdAhcDekTkZLxzzM0I9xfSUkJ/wZAUNJaSiYy7lgREQaOOduF1XQNgk9YJgjhMu5hz4oXX/CvJVxg3OhOqAbExS+/IsWrUFG6Ow4SzNxFJa0O9hMnikSx6NL3ACpP8y3RSoeXH/dqmAgnLQk75xqtS9+hDPpxhIYPg8E6Hl3y0ZH2b/+5KndcIzvg2p8yf1ZXKEd1FW3f74Gyyt7pZf3xcOPeITixPJoW1zf78U+pRJw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e37d1e7d-5ce3-435d-3606-08de7483c9b4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:30.8093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRHa0xVmMFCdOVAeKYSdndjlffrNnY/9/C533q4b65q/5CS2FEqocT41cTha6L4XQUhDeBwbOk6QCRGqMkvAZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7956
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX9S/+Yf0xjUel
 p4DLvbdg2kcLEoyksIE0NwPk1WPDAdHW+4Yd+7YM97jNkWvne7EG0KtTgKKRADolvn4eg8np3sg
 g8YDfM/Jry9TZtufHvvu94AyifWqeAYFdxlGoqW9TGE6uHXrAbnRDtqizimIV40N/Yr1FpUtY2P
 357Q4oc1yQUZ5rgxgonkKu8lTlwHVhhNLyH7fS7Dk139F4+SWqDpEvHirADtKtPVQDPrzn0Umnu
 sl1czLCnCTWYI15GHEphuNSg+OsU1qgySdU1sBRAd9viC3KiPjzbbAhTzWBAACgtfGJBNrv6lVB
 zLCsLexJ/nXXIOYOEVTqvafZE1hDyWSednEg3+FmjUTvwdMQfOc1LxYxxM39417T0taCtsV7Yl7
 lBxVRdTpgcv7MUcrC0kYF4H5/wNLx/LPxEzuNzzjt3mTG3F6ki5UJwzKEhfi61RiR9XtcKm7Xw7
 sJf0E+5whiYPzuNAvr3HLZKSZNpfYfQZeNbj7EGM=
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699f1743 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=P2_R26dytZ8aPJic-48A:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: MuHM-sU3RVXZqJWJkzanXoOA8Yfnfok4
X-Proofpoint-GUID: MuHM-sU3RVXZqJWJkzanXoOA8Yfnfok4

Add an attribute to show multipath NUMA node per-path (scsi_disk).

The following is an example of reading the file:

$ cat /sys/devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0/numa_
mpath_numa_nodes
0-3
$ cat /sys/devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1/numa_
mpath_numa_nodes
$

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f5922a9fe6c1b..52d9bc34bd666 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4213,8 +4213,28 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
 
+static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
+	struct mpath_iopolicy *mpath_iopolicy = &scsi_mpath_head->iopolicy;
+
+	return mpath_numa_nodes_show(mpath_head, mpath_device,
+			mpath_iopolicy, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.5

