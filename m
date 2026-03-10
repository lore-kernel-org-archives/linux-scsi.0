Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9E03B961A;
	Tue, 10 Mar 2026 11:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143405; cv=fail; b=dg7NakpUsI/bRL+PKTfTNzR8wwptZTWwAkf0TFWN1cXflzEDb397jKW+ebI87p9SlWhy0ggTi1g0YQhyQi1zR8SlIpLP0U6cgTxAVYCmZjPG277StE8U4Rz83kd2+VyL0TbzvtDrmzMhQqMdwR4aaguOQF8MQLkaLNCfLnWWvWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143405; c=relaxed/simple;
	bh=+A8jY5uF8yCYXTUKdRnmy4R3DlQpYBgHRrqKQNhRPBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pXNbyBAKBGPsxNp7rOKehlJ4gL0mlZycaaxwFDkhHoY0P6/icf7Bedlqfe8KUDAj8/iAJeZ6zN+lJceKJxGWa5Ikz4HqebSG7fkiK+MPyfudMISwg6rfhIaprWkVulZPCyTQfIni/LYpmKzGOaIc8rPMZxJPVLsTsQ00iMqT+zo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SX86KRb0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gk/5LRTe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SX86KRb0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gk/5LRTe"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9DYND094073;
	Tue, 10 Mar 2026 11:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9MuQy9jcIPtNyMTk1v1jBRS5XLCtFrZfuzfs87SRNgY=; b=
	SX86KRb0fnsPWqyvPR1XGVida2a9TS4SDKrF03STuqQONA48GmAF6TbrsbPJiZwW
	bIQ5z9AgVxtI+qz3PYTUFFSt86XndE1LWhv13rfYbVsbZ9a5+1yFYTmA9nTJhrHr
	2KaNVlupdxbIqYWUtjFACY579ykiJflYiKDqKFmeYpl4k2LzKePmmz7yuUvpR3o9
	bOT1Dk4qMryafWtYkIeskTSoL8Lm1y9eUDYeIFh/nbvNe3C7ptBrw7LKf/whgWNK
	qCLgacZk/jTk8MH6mYNyIxdLU+i0M6Trc3uwnzewRN94ICCcLX1LRHoi1hhmP2xF
	CCKqHG8rbHh2xSsiHxr/oA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmdkjny1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62ABBqxI014869;
	Tue, 10 Mar 2026 11:49:46 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafe850d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vjEkG7VrScuyium8HxKtoDwxhm5x7y8jjvr44obKuN5kxRw8/8fXpp4fCmKGfjfeS7jymGBsjExuTmiqWQmS0DBNNeI6Par/Yonwp9l/7rYIKljzQMSoz0/zHo8r4PCaYCmoul5TtDBlOl9o2thbHa8Op9e9pN0GWkTNh1gCQLQqSx4kWyqRpF4THwWAzFvTcExwEtHuAyDHozq6BhzoTSY9jgW5Rh0ymmKCGvAywq8ezG7l2h8pWzvFv4a4I1R6vaa7a3Cqo68UqibskBNNjXIwWu3S/VPeffT1+qKEvQB12ednZo99bhwTiT1AmLICihnwKKkkllAdA09SWH0e2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MuQy9jcIPtNyMTk1v1jBRS5XLCtFrZfuzfs87SRNgY=;
 b=J5gPXoC6F8OvW4555BuCU9QdTfrwLXVniRoGHKtkckVmUn5CKcYf32pFg8AaIerVeoggzduOGb7MqpURgyAeNkH4sS/X9XgDtjAtN84A7N9dkH4WtwdEnjTfHK7YWNfVu6kC0N64JYWNn+U4hEyDEFOCuDQmfcxIN/m5M2g1iUZDNZAhCxwLhUFpRnc/pMZO1OvD+YuSmISn4Y5sUwGqMzZZ0CcTgV2S18j8zvgJrzJRBHxTfjM3mW/tHYiJS4QDahNLvu4YBfH502vzaI1vY/gijeqcn7u1wYS2GefOJgiswS0zGchFLjgtSb+XakICf++4SF+oWXlnzGXY+J4uiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MuQy9jcIPtNyMTk1v1jBRS5XLCtFrZfuzfs87SRNgY=;
 b=Gk/5LRTeBMrNLW5E/nBDAe859qoyUC5NdzWqpH1m2sIS/mGO3/kwHwW+VU9j5qzSvq4MTjBQOZRp262DA4zsbeAK1oQPmH73DMXX4pvQXR6BQ7ljUEztJPgTpoYjWKYNjcygY4khTGemwKSRrVWRE2lg9ejcLgdCaOdkwYhqLHU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4519.namprd10.prod.outlook.com
 (2603:10b6:510:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 11:49:43 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 11:49:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/8] scsi: scsi_dh_alua: Do not attach for SCSI native multipath
Date: Tue, 10 Mar 2026 11:49:19 +0000
Message-ID: <20260310114925.1222263-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260310114925.1222263-1-john.g.garry@oracle.com>
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::34) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4519:EE_
X-MS-Office365-Filtering-Correlation-Id: 2027060d-b355-4361-905e-08de7e9b1e75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	o5AudAKbDr4paETNalFmabjRRj3eEf+uGck0eMA1PRHpIXDa8/Z4yDHYlvL2zUNcqDskFuimzu7Dm6AcUd+h/IANg50UBDLSSnvQqIRAmibPMvocDaWtry7Zi/EdcqU5s7E+1ii6Biipyba+GfL6o6wzuH9tkmAf+M+6puLmsn/ioMkmDQ+Qrj9vdGBeD9QPIM6Vsyuyh6fN2VyH/88LwYdTkibMI3LQBTQk5L+0BbJvnHQrOFY9Wr/6BRwNnObtBciKdUxcnNS3yMFAjmqRLN/SUQxrpU7ORx0Ierago4+Mc0h646pwf5b66/KJqa3p1Fq50mZwsnx5xtLg+KAzwu11QcM4XbOuP6uBIuGN7saDPj+WGzftcQBE7TnRFSVLfMHtYGQsiyJf3T6XOH0aOj4/fppaW30HFks9P4hD2lILpCBPNbHGwoiIDp/oA0opH9HrDDEPuubC0IosMUKdan+l173RFpONZ5xSGU/KHb9ePfCtrgOU+fAOMrhY7Dc/SHn1Us32EYxCl7XS90jtPI5SpCsQCFoPrS7XAVJJU0m237kQmMyQSsjvuVWAlR7KOcV9W9qvPQOVKw9ahchU1mx4GYv4BaaJCJCaQD3VTh+Pbr6fhS5XuXYWDwJ0Nhk0fDsC/eyW77IFVdqzmezH+p+85sYqq1MZzSWZB6sSuGy03fN8dHPVnSpKNvOhbeuCdJsK7PWf+mAE+AzGxG60eh/xwxjdEVAYS2MePzPPk0U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4FfOwMcNyFKS16Lwi1SgJ2DA0RyM9UqIk32maDBqANuKRIx6+7jVls6zEbCc?=
 =?us-ascii?Q?i0bsS0TZr2GIRaszkH34BbJBmBIWRtlNpQHMHZsckRzk+34y0qIKZ3jEK4zL?=
 =?us-ascii?Q?6CwBCet+IIyuVXNW3zrVZ+5CJXyRoykc0o5ZfjEQialIy+mqb6mfe8/PAejh?=
 =?us-ascii?Q?o0nFhorkwrwa2YKI5MqRyMan/Q7T38W5c8Bvy4iIFSuRpowsshyF1mSEEU7T?=
 =?us-ascii?Q?D80tk+kaIZL3bFQvqinPeFkJWLlq0YARN7PHy6o+HrB85rO0qn2Pxio3/Emj?=
 =?us-ascii?Q?QoZesIZ4aHchUuN8VkEnGyuYxXqJ6f5jg+bmUi2Eeuj8LNDGWQv8d2OU4pvc?=
 =?us-ascii?Q?jTFuGGwpI9oH90j6lTPR3BnkX09QCCXVZ6lmx38onr5GLsepAiunZxbMpsxF?=
 =?us-ascii?Q?ch6Xgqtn2bVJ6keqjAlLosAn1GlBHQ4i++1oUTEFbcYYnzyg9VnThbaSgfm9?=
 =?us-ascii?Q?wz4J/8zXy1OpMkuPXw0fQRbOddPTbuRMXfuCkqLXkxD6QSf8e48uBYP4PDop?=
 =?us-ascii?Q?5lR9VBZwDO9OPlVB1qSu3H45UdvZ8dFHlAikXCAL6Ee8GLYAQVC06lyJFTI8?=
 =?us-ascii?Q?YdY42u4JGfcdDLB3Obtw7ujtWPUpvoxIubrUFR4cnnaJpOIu99pV3zkoIXsE?=
 =?us-ascii?Q?JfKQD1HBUYMLK7fGbO7gQP0kDLoVCViBYF9apWGYAFZyIManrzADVvGxIuRo?=
 =?us-ascii?Q?5+Aj6WMUgZJSn+fP1+6NWHV/Hy2U5I90K3KPC53g1XxiudyYDdFJdqBmlhMD?=
 =?us-ascii?Q?TISrhQdIas+RVCy+BZiVmu00rB0VhCC9ujKdmF1pegHspDsqnGCYHeLuaAo9?=
 =?us-ascii?Q?N2wBtq23Ht4XXw1xzf24zsgvqK519IbTixxIZbeUhOOQvk6jXd6mRuJaZCoV?=
 =?us-ascii?Q?Jo9/peZebULsqx1haCgTmB/ZdfdVY8IuNxS7rsgOIKpFS4krXkb8wgly6vB+?=
 =?us-ascii?Q?iMv9YyvqHuyMjPqb3I+4oa0/pRF0lw5psZgluP9bWQhurfH7ZR1WaNCVnrfa?=
 =?us-ascii?Q?9s6dQrs7TknaiAVPPc6PMtADQtbvLiSM/cSXp4vjmveJ+5AXNkAaZgUdgMq8?=
 =?us-ascii?Q?1K/2lHkPmmSzXAJDHhlKO+ZBBCKE4X4zFN0g3KpQCtq1Af3XPZuTfvg1BQbi?=
 =?us-ascii?Q?e2jnTnFb/IY7AYWY7LrqaJVhnKdftqsHRAYrm/CAuJtmcHsdfHU6X7wZ116X?=
 =?us-ascii?Q?mIQ2D4aR30eM5pVaWc4RwvWPIRobQ+0g7CQKwpb0BnNki16Woh1uHZlbxBOd?=
 =?us-ascii?Q?75GfwaYgqO4gSh+yLIkbeeLQVZGzLaUXZkdGGmiTx6ZhrqOsK/UbsJMOZier?=
 =?us-ascii?Q?vmluOUSSwgYTc/VPnt2bmwoto3k41cIwMh2yQgY7CL7+eRv7U5pFruUeVMWu?=
 =?us-ascii?Q?ZbEpsGcdFfLu3ODRWfd4Ij1MLIoBT6AvojpfjEakRWP7Dnp3I47PnJrT3Czd?=
 =?us-ascii?Q?dR2ARkvsuorix35ZHAf3PWZW1zhAI8NcyvBfm5o1igmZ/6dH5ImOMKNX8wy9?=
 =?us-ascii?Q?o4UuoMUjpZ4uYp1ip+0Dt+qDg/ePqXbY7/oXt9ga0F4ra3Byz5Fk8IvGRY4U?=
 =?us-ascii?Q?Xb9XUm/0KwbGQV6QWIjF25qKYdQ0n5I7Pjra5npk+buDRiDexha5n90uuCzv?=
 =?us-ascii?Q?XjjQjV2Ay7sMHxvxOdGIk1Fd0rCcdReYRL7ei6SVNn+M04M8hcjfHhyeXMnq?=
 =?us-ascii?Q?6wxkxRQ04Oxgp6HkuJPLT7XRZY1Z0E8Ru3Zi9uIxFkAgCOzLCpxCsc4mKEWv?=
 =?us-ascii?Q?bAYp+drYRLYnRa23ReyVUnO1BK3QQ1Q=3D?=
X-Exchange-RoutingPolicyChecked:
	XL1gs69iziEUJn5HZ9qNEq1W0HkRqmkRpo1cldhKqK/MajCY0315oAId4LA6BJaSeUVJmfC57ipuHivIgQQ06NhBIuboEdOyoEgNXf47ignT7T6+xbF6L3LGH8EmxyfmFvYkRqqx3f+MXtN5RROvgh29mKAFm239OgNSxKpR+kaapcfinhUHZVgyBxesh1im68qx0bwduKYCn8O9BjkOesb7//pYyKLv+yWm7sFYla+XAdRsVAP9SBnSRIgIgEj5+WQr87J4MtLCsTgeikmspjH2Z9xlBP2LbUXEPTHWfTptBYs9ny9NJMxqBFrf3GE6LzcrchnaEFCvX9JYNTDlRg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZyIZ6UPuduHZUnQzUnwhM421g50nnN444HZFuJviKu8h4MG6PGWqqbVou0BDOLDFSK+Bx6GPtpLWHOunVAS78eeZYw4gdVouW0UNXONlA/k056zruQm4vufubPlkFiw9QFBquOgxdkZSfMp04GDiCIRX3zfTFDP+UjGDa0qHoC2O2sMODFnnN/mTzpezBrL1LQRX+XGSPx3YKaWbgDtjV9URFnnWeZ5AzUrdCk+p99dyVvzPQVB4YrRfq0mEPkuaipSz4TZnJCJU/0Ja5yqMtpzMMFiY542OtnbobI65384X3//cVv6EJGBnmqRx10/IySO3cYyKzPSzvLnVRJtR6oRJeg+OZeevENV4jpAXsVUww9LFRi3o7baASTLht0fqfSsk2PM60dSCbO/iEE4vWtIsIHHu++k4o24b1OIk0Ru3FI6UNiAMFzxod9AVyY9zFC93GVB7vBmfOIMZD/C73ku+TKgJQ1abvUyrzeeuZWhwZQ4bia3okLueHLKn9Xv/vMVOcMjVHb23S77Auj0rwAncsbthpvkb6iHu+u++WzaqrXO/7VvtW4PEUfTJRm5dl+TOUxbd1wJN3IEBnbc5Qy03PJEc0MQIhxfkgSqHCN8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2027060d-b355-4361-905e-08de7e9b1e75
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 11:49:43.1223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpJshHHmbB9PjdL72JxCXT3AF6O0O1UPOXACsTLXyK/grDoaScNFSQsMKBjZRdvGNTZ46HyDKnL9uLIHhiNO8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100102
X-Authority-Analysis: v=2.4 cv=MuBfKmae c=1 sm=1 tr=0 ts=69b0055a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=yvriYwtWD6XCMWUnsckA:9 cc=ntf
 awl=host:12273
X-Proofpoint-ORIG-GUID: BSdjvMp2rIqfWqAf_aZmbGxtOEcinZGB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMiBTYWx0ZWRfX5GC7pEEcttw2
 xT6iNCGwe8x3GurOZ21buh7/VKSSOcMtpjRHnvmsqdpmuZ24E99Zj0RgiwfO4HcLSTElgK9ixcg
 wpE7Rzr5+NJOEMi9Vgfy2GbJdHcNwyl1OX5UqD7oyTbcarI97v0e0rP0sWR2BjgLrPWVWIP05UH
 8UXOgrUfrfSSr7U1/wrfZ9s3cdtJYBOfzxG/ZwIjzjIiuKX0ZHMzE68DdWJCk6cMH1kKJhCfD6x
 VgAcnav9ydk9c8Ozg/m18AR2AiHPs66B7I9mOUsVkGFacjgEa+gbdu/jqCTRlJU8B+0TMbxpZzF
 qp88fzRIk4IWLzSG3m6G8uwMFzrA2OiFpVZfNdPuqaCCWnYa3x73I9cy4snRvCWe6cFeI5pgs61
 bUl8SkHsDS1Wpo6AD2opt0Cao1EX5wsKK0GqKUfjTIqissW9X9cVdTtwv2wHsQFvgf30lwWF65F
 P0c7TPLn2lqtZd5IORsKNl8UfdpgJfNiTtH+AopA=
X-Proofpoint-GUID: BSdjvMp2rIqfWqAf_aZmbGxtOEcinZGB

For native SCSI multipath, we don't want device handlers involved, so do
not attach in this instance.

For now, SCSI multipath will not maintain sdev->access_state.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6fd89ae33059f..7b360e7f11a6d 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1239,6 +1239,8 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	struct alua_dh_data *h;
 	int err;
 
+	if (sdev->scsi_mpath_dev)
+		return SCSI_DH_DEV_UNSUPP;
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
 	if (!h)
 		return SCSI_DH_NOMEM;
-- 
2.43.5

