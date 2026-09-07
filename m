Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331B8471255;
	Mon,  7 Sep 2026 10:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778387; cv=fail; b=LhH1hao0UqzOEoGPfh5QyBoNgDWHzKHwSPiSMXnIjm/aJU+Woyp5zymbrgp7xd/uthW+u0bdSc6PSaRLx0FyiFu/2/7ObdtIsUTxW0EKC50iWI/sgrhZ6hb+ncPh/WeOv8zjDv+09ZTlCvlwFx/7oJk+x9j/f6xu5RZcDpfjSyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778387; c=relaxed/simple;
	bh=V8hOXtdjR7KIFxYD1BT+7+DOpvJH6BtkzdHlul8QcFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RanYPgH6hgNUOJd/dqNIqisLetDlxUe2Gi97O/XZf2j5AkwY6klh9ucSGdgzFJQM7XHdpN7GbNuZLDeWvGsXScRxJMSK/rdZTGUnxX4pWm3dg/CJPCO6hOGeZIvoQ1fuOcPtOHwDlb7Tf7VLVNdeaTmKyQUFsbkkBbfsOAvpmFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HGOISEEb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=reQYP39F; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HGOISEEb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="reQYP39F"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6870K7h8264221;
	Mon, 7 Sep 2026 10:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OqSnADuxnPAqC8+Msp61yJyBNGZPnK1oCGlcQK/MApM=; b=
	HGOISEEbkUdpxU5VzK7sgsHIIchjzS3GjDBN2hktOqSXeXCuUTT666EzEQ9e023q
	DaYeDYSnqKQQrgKZLWfa8owefwC7fKtF6V9JEztDlZmxrnMfGGaaBj6yTE/1fC9T
	CZMXm7fdj7lCIEzLSadNb1W9pDAsrTjHUz7FOQq4Oq2r4KJqalg8DrifvcFhMt+F
	ejTFD0zLO5REKxTOZiqywbHgA49aVCODnhK/ytrmNVOxTy8BEUN/oguJi623hGkh
	LqMen7KEnadBMXtmoTDeFvglEkV/mrPshjGu31EZRlID01pPn1R5n6vvcLKGvezW
	ZJ3UUuds7FVNInsAvIAYRw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbg1sshd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfP019106;
	Mon, 7 Sep 2026 10:51:23 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-17
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GP1nc/6HDkPNC8ZSJGnAAWjbglZUXT9AYIuWIPp1PkUo+/SyKvBIZ/LWcIIYuh/e/rupmCBR5hBBCkrAiZrSvcQcgYd0EYrc/ubVSiOG8wfbXhRzeiBGYfMBy/SPgc0VdAS1XkioAYTameaorR/pIQ/CzdJdbu+9FqSJb0wGq4ND6U0gzAhsa5PoeSKwAaPOCdqSAPuaB8MeEz7FTsjqAkDPCCLkpbWVl9J5B9BcVdDgqx9XQSJVkYwi71+QFA1/WFclrCs7O6F0+GEqXvGF7lGSBFIbHmSC2DG+9v8dbOAHh1V9iwHAaIkxDgsYhmBgZBVQT/epfEe0soHRTOy9Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqSnADuxnPAqC8+Msp61yJyBNGZPnK1oCGlcQK/MApM=;
 b=DeBBz948LvdvvEceKL0keEb2PjX/p2gica9HGeE0WKuNTd34uBCMOOeJxBYevWZpY8MFgw/bRSkEZlZqADfbj1D3RN6o5SA4RKpwZK0N0+/famO0z7cXco7LBe6r4gx3a8uYWHGXzm+tBzh8TLqymz+Avtww4bSt+hVxB2W4692TvtMs2YwvUnCUEHasAYS7pukrDIlqdlAA+33uhq4PfvKcSq+2e/3oBIIcELlyLBRkdE45gg7lHslovjn2Vh+uQjtDU9axfQ9BvRJl7E90NtRapcWXBBqeImIodZ4zsb2NasUocxFFAiDbFex3VGinJpYngevSUKKzldJTU+XK0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqSnADuxnPAqC8+Msp61yJyBNGZPnK1oCGlcQK/MApM=;
 b=reQYP39FhnUY4YykiscjxsIBcYabBoc9fULUniCa/zn7mHH8lFWEvhdJqoVOvzW2lTQa197sWFlCyvUqq5uxSU1UIql7IMyrfSStfPDK47zgB6c9+wABNNQ69vOuW9Gc4CtB+5HIltAykL9xG3axiNDUs53uH7VImj8dhOXaTvY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:17 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:17 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 21/27] scsi-multipath: add delayed disk removal support
Date: Mon,  7 Sep 2026 10:50:15 +0000
Message-ID: <20260907105021.1763236-22-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::34) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 937c75f8-2fa4-4cb8-1f8a-08df0ccdf1c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EbLeZzLTougIf11qSCbBcQNYTOY5yzJUpmuW2A1DtLZ/dx0Bmlxhz9uT9acOpBtQWfVsIkjrmq0ddTT1M0sGsVaPcHJXJTykf7IUfAn07dgGbXwkHC/YJBTcSBpMNqysLxrdWnsP76VXvzD7MiDePI9quWP5QfrK5IE5fIrZUVeTmloviIdYpmcNKbQ/0pzVQ5+SkOpELi6p3LKfKfRmVkiyLA5UDCHeKMWQV3rBFxIU83sU4D2JoS4GRUkG5LGoaaJUzN8rb8SKrPfCLCJrINgggIH5dtfOcvrFhzl1b0yon0+beuSkY2XsCLLls4Rf3I59umvz/nxesA9H5kRS5bDg08FceT0yY7wGN6QSXEJC0acdSe0UoagGMbklGyOShWVEvecTYjzucPxl4nziJQVnr+T7b+2RIJ2PFC8MRnva20qti2DDLanPLM5qgMrncK4Akc0el5RNyGaCy0Kze8BFDoy2Goj82ayotj6RfTS552eN3lzjM5iuii0zQXisvORlpDwxcv5g9B6wGTMqP4eJ5il7J7cQV7c8KDj0whoyyMvI3MpXA4W+1sl/WLHq3csJhtYgJ6Tae2iuq1kV1yusPp6DOyHrXagx7Jz//NxD2p4dqSgdLj4v/XwGZGBQ4Wu1nmDzhcy1bWoEuGoh1bhuKbTMNj0zALDy6vuo4cs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cYOx9ETN7rE6i6rKyp6B2bnKRrQe2b7BY2eG2Ilbk832CfNFbjFj2DW/R3GD?=
 =?us-ascii?Q?5B2T1k8eaF2k3jVacUIz3bh3tgRc3qEUUbbD215ffZSD9qCo7MROCaJMERRz?=
 =?us-ascii?Q?SikswxpWRrHtppBkZfLF87YX5XZtznSfvlvv2FhC2U+lSl1gU9QljvTDHhIF?=
 =?us-ascii?Q?FGZzDgszMOLedAcB5JGxbd7EpV6PtTRaXHkZpzY1WIWP3pDCAWxGUWRGgpQV?=
 =?us-ascii?Q?1Gi9u2Cf/fXYIi2P5t9p/f3PAeH3QD3gqMJNac8vAKaQVnbR8O/2LG9qXlT6?=
 =?us-ascii?Q?xKJQBhbL4ieb76Xoe0JfONEMoO4DTOl/SplYSaJ6NE6zWehJPqblKRyOQaQ9?=
 =?us-ascii?Q?C6SaLt5idhCjF40q8hvGSgktFEpYq2hxEza0KkoeVttPCydceUf3o/UG2+HO?=
 =?us-ascii?Q?SThaO7jVtF2QozVh3QqMar3Kn4lUa4ewNuilqbu4ve4oNAn8DUd8wYrFUKQE?=
 =?us-ascii?Q?5scAbzZ8y2NKx5vrtkp5FDflhVxo9ATQwOmruhHcDtuQaN5UzPDzeH2Kv7Do?=
 =?us-ascii?Q?Ym2RhEOW6jKKU/p2Yt1Cak0EiuVuo8F9biTnEfBl06QAmIXQPBZED87+pWxq?=
 =?us-ascii?Q?C604FTjmiknVq5edbsHABvtcBskj7kVeudWlS0SnF/ewdp7CNYh7nxGMQkHL?=
 =?us-ascii?Q?pc72n3bBaRzxLGsgps+Vni80IC9k8tdkC9jExipFKFt0RlVDQHePak77QTtw?=
 =?us-ascii?Q?nfnyoT7+e9Fu3iXCwBOh7Kqlwolvs+bkE3UMnc2/BEYf3Mnnk1JGN4TbILqC?=
 =?us-ascii?Q?mXIQ4LClqjGGdiXg9fLE2pphNd8wm21zpmkUsIz+J6KQEP1agwPe5QOnrEIi?=
 =?us-ascii?Q?mCJQDMlhSKsahWN2Nh5Jdb02vIT8539W7hKAoQaa8afa7ANvjBhn1KOFsLkP?=
 =?us-ascii?Q?MNQIwjOPgw9LxCnBRx7vsDduNLy5oobKr810DzBTcHn2ReSNj2Km1tmDA44d?=
 =?us-ascii?Q?i9cPrWGpeWM+CYD78gGObCe0akgCsxEFXMkqENk0I6KaykZEjme4sWeqOMmF?=
 =?us-ascii?Q?I8xEGZfSlJ1GMfu3ixaH+ceflGrCO+K/SClq34X9eevJ7tkZYqxPKIkzapcG?=
 =?us-ascii?Q?shCAgKMvXNIl7zo7ZSXNHXKueUG7Ws8FRdata9170HYNTjeCh8bB6W5XY7gV?=
 =?us-ascii?Q?uDAYN+OuzH6Urtkc6CcQes23/+F3gkMRrNJ8dx+wOyoIHwiKsbeD7Ek+G6Gy?=
 =?us-ascii?Q?r1EJmBy9qmJDXGvysuP4wbVDMl8Du241Gr5lmO1BzUfaQpoTyuw0Nnrvv/jh?=
 =?us-ascii?Q?aOQij1kX6FgqdooBX714d80Nv00XK0qctMCLupknWyMY8RDOWQO3sAdOtqwn?=
 =?us-ascii?Q?D4D1oJlr7GNzGNr4hq4/tNSYyadoc4UcwVb2Y/rTMHjcl2Msm+x6hjelyEAk?=
 =?us-ascii?Q?VDUDXs6+rKExeq1KhpIikxAwML3wkINKHugN01GxaW/Jo0nJQqHSJQY/+x2w?=
 =?us-ascii?Q?LvNblNv3rzaffCmpCanhbAoJ90JMEvFAIPhYWkl1jELaZvpHxVbQx76fA2eZ?=
 =?us-ascii?Q?jkdvf6Sc1RRvpPePcBpsbiq6AxGJ/zflxBp12SAS1jr4B4XvP//CqqAv20TH?=
 =?us-ascii?Q?JZG5ZYYako57HtsoJQO/GK3JQMOaTx+yJY/fxwP8mH8lYU5AHrhGybGFmfRS?=
 =?us-ascii?Q?eU1NsTJyXvnveuGbez/iNa6iRHox0mzG17EsJVICL0srha4JyraW9t4QVqrX?=
 =?us-ascii?Q?yDfSp+CtedkE5YLYzaDnjse4NHcGyddBwc1V1uEadrQq7gxoqZTfxabVmpYq?=
 =?us-ascii?Q?LV+Kl7N00w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	zgfZLxU/escK5Kl4hwHL6cETzPRqv3l1lz0SxObIUkikFqzmGqBMGouhfoDm/A8L4u46cdmOyJF7gF1taMkUOU/RZ6PEhjVpsXknlsY6UpMuVVfM/OYkeA7aF++phYZ/Rzroh9d8DisVTG/CJl3O4dVrQpuXa2194GjNj6fjHpdHY/kJYrHKf5l7unnkuJcfcsdb6zvIdar/CUfkb8m+6tv3PU3DNJ5+1tbSQeZmkdu3aZ5/UFOk1orjTyH21IZ5/TYUCWUrv/qb5cmkLIPlyz035NkiYdPnzTcgBV3jyjgdSiZFK8l4F41fZ1ZHyeobGK8NZKFPUevlNogRh1eCBg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2IHCRm6jt1Hv64KtUGOmyLiyjJZ9Rj8HW5HtX7zlaVW+FxwfCYKzBmUUTbcpFKDtm7js+8OklqlBAHCly1f2iGCk/ghIpAwL1d/rdzFtu8LdHgrY6YKmDSeAwS4drE7uaGUWRVGCDNYXs+f8j9NFKO6GzbJzhe3O5LoAXRFHfJ3eqYWQLjWkiHjMp23H8+NLcFVe3p60Ka7k63Iyq6a04jhALsYbj/gnkTVzv/ETO1MyCJuj/rxbKNqR5hg/Q73ZSKz02YN2sH2VJfOyf+ujLkVgJ0E2sCT15Y133qrjA+GthBv7P3Rbykz2o7KP5BBLdzlySP0rNBbKOUh5SS8RPI8+8DVD8CfaOVCuLV+D78a0/eSA0T81eXqi8TJ90y8JzbRaPB/IYQFNV2MQygu1pcTiV61bh/vrDiwswJfokOZZ5pKRtOac1p0dpKB+zZH+dpcDTOEtwk2yzmiNzqzX8c9wPTp7GWCpJKb/Iyaj/lZnCdg6zMz/eFt0ArO9x/2i/iQtyp8i1JePQWZTpZwXEWbnio3CDebt7NPXod8igOfSxSQdjwmkW1rLEPEJgCVz/Cu2hJb1xXVOZFKsUzwVcvGauOC0Z13425b+MZMs4n0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 937c75f8-2fa4-4cb8-1f8a-08df0ccdf1c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:17.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F08HSq+jOatVukO+sFMrbQN1wfRWroa3evCkGpZNqsGJJJG4xlgvZdY7cAKP+KDZsw/9DGCFHKfptIFtH2BynA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=VpYTxe2n c=1 sm=1 tr=0 ts=6a9e972c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=S0-NFRiyq58gb8qD-mcA:9
X-Proofpoint-ORIG-GUID: MBRJJgVfnUjYr29Fg-bI9lmHonLDeaZw
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX87awSHU436in
 gaG3em0FEY197uHJlxMKKmmjmNHluycCULuY2nmOIhAglj+vgj/L+4Pb82E/SrvaWjhiiLIdcry
 oudDy0popFYtrVbdp0g4OEyhGDP7KwvrVJigVjegzPiA0/CBaTfX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfXwLeXkdaV+cb5
 SdC4Jkl26anpd3105xUAxFnoUVGhHrw0sEQx3hedbLRum9c7ceu6jcWCym08e/6lR8wVU0bmTcQ
 +ohmL2ekg3A5b9Ngzqwhbi7rxg2wsaTWUR95z+I4jVncRcyR6VR4U1idk6NaoN4rAEbu1106H6Q
 GDzneIUgRDt68fXMaC9MbxLh4NW2VkuftUe/PIcBsakLPU+FbxsW0o3oSkhRp7QIrG3pihynmdj
 ZU8GD7rVnJdqCcsq3cQl8kwVxZiLPKM4zP4aZCuRycHAjB2Z2BbXztSwklEu83xVB4AkEDWS8YU
 R2Y1wGZNOop/zms1kQ0YLKUziAqk2eky897haAoQ5EIIOwkH6tV2CLUHEpjd1brPVsX8Ko3g5NW
 XYFegWQsDgwyTvdcd7BT5QnVQ0ivPSmDfuDJvldazzfZhB5UiwfK74KpqY9yZbg64sM+4SpUUWY
 0usiCl6o/3m7Mzjbycw==
X-Proofpoint-GUID: MBRJJgVfnUjYr29Fg-bI9lmHonLDeaZw

From: John Garry <john.garry@linux.dev>

Add support in core code for delayed disk removal support. In this, the
callback calls into the scsi_driver to do the necessary removal work.

The scsi_disk driver (sd) must ensure that the scsi_mpath_device does not
go away while the delayed removal work is active, i.e. it must keep a
reference.

No reference to the scsi_disk multipath structures are kept outside that
driver, so that driver needs to provide a scsi_driver.mpath_remove_head
callback to do the necessary work.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 27 +++++++++++++++++++++++++++
 include/scsi/scsi_driver.h    |  4 ++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 5faa06b5e8770..e6b20f862c6a6 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -352,7 +352,34 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
 	return false;
 }
 
+static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *data)
+{
+	struct scsi_mpath_head *scsi_mpath_head = data;
+	struct scsi_driver *scsi_driver = to_scsi_driver(drv);
+
+	if (scsi_driver->mpath_remove_head)
+		scsi_driver->mpath_remove_head(scsi_mpath_head);
+
+	return 0;
+}
+
+static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
+{
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+
+	/*
+	 * scsi_mpath_remove_head_drv() could drop the final reference to
+	 * scsi_mpath_head, meaning that we pass a free'd pointer further
+	 * drivers - take a reference so that won't happen.
+	 */
+	scsi_mpath_get_head(scsi_mpath_head);
+	bus_for_each_drv(&scsi_bus_type, NULL, scsi_mpath_head,
+		scsi_mpath_remove_head_drv);
+	scsi_mpath_put_head(scsi_mpath_head);
+}
+
 static struct mpath_head_template smpdt = {
+	.remove_head = scsi_mpath_remove_head_work,
 	.is_disabled = scsi_mpath_is_disabled,
 	.is_optimized = scsi_mpath_is_optimized,
 	.available_path = scsi_mpath_available_path,
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 249cea724abd1..d92b63d357f2a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -8,6 +8,7 @@
 
 struct module;
 struct request;
+struct scsi_mpath_head;
 
 struct scsi_driver {
 	struct device_driver	gendrv;
@@ -22,6 +23,9 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	#ifdef CONFIG_SCSI_MULTIPATH
+	void (*mpath_remove_head)(struct scsi_mpath_head *);
+	#endif
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
2.43.7

