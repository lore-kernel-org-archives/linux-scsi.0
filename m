Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A1B2FFF80;
	Mon, 20 Oct 2025 10:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956729; cv=fail; b=YHykJYDAYodU5DkReIHsetJazbxndgMxudqA4rMhnzm1KafMob3t/BTfJR1j1Ut+84+IgzrL664fQWtWGZ/VczVL0bMw9ol4dmjJ+1dm5eUruOhBKWBLYBQRFkBfiHBa1g8xLYBo80OtqlwMFIdVP09h4+fWNP3c+N5ubMObpho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956729; c=relaxed/simple;
	bh=5fB2BBJMhRxS1G19Pkcoqo0QCR4GQX/QpjtkbzkODX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tVl6BXJu7adPQITuTaor08B3nTN07UegD2oi+awR3Pp380QD186Hx3NrJ7GR/c/TN+p/uCo/KFLtF4AziVdzTZHql8T2b6GGuaK4S0UIoJIbx58bY8GNRE3OveIPhe//uXitB09pE1Krud6kqYr0z1yPbF4oCkOoaIFZdAjuoJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o2/lgsdx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GU7Txich; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o2/lgsdx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GU7Txich"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8RlFo005899;
	Mon, 20 Oct 2025 10:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XLgc0ZZ5kB9CaS7MGDaCyc5T4uvTR43Rj5c60z1fX/Q=; b=
	o2/lgsdxo17+f2+p1iEEyFGUL9su3p2VWg2VhcYudmR3zodpEMKOIilha1PbJxjZ
	F4X8MdrYodmKfk+wD4OPABFCI32Cf9YY/lb9p6cvfMrhNcqqPs+cVgUwQ4dWMrsb
	EQLFoCpSC+TtXbbvWXjYqevC3+TGa3xYZYHILLQJcublIVH85WhG55BFuOe6xJIL
	XOspk021PPoehvGRmyLcBtR5WuPGfZzfOjqFn9BkK62AUtQHDX9fMKfdoNhVCPSX
	A89JIomfxHQZ1zRywnW9AS/HcCrPma/u+nwoyy2fXSWJ9dXNvuPec/pjqXjzBGuw
	rFde9GkBTBfMlEJuxo7qzQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vvt0sh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KAaK4h013669;
	Mon, 20 Oct 2025 10:38:46 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bahuvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WGc0/lj6V0Gi59w/npA4sF8w/FqIvOqj4alAM0JZY3wn5+u+laqSN0goF42Yp5e/j2h9Bhf1Sm1lelJACleU8rzPhqI7Tl51cwcrCZFe6XajleuJvVwWNNwcTGr0FMxSWxCkwhh7UxpOUH0h8tgEihRBtNRE0I27a6leknrTz9ZVXTsLaHXfZ2yKDMH9LCzOSRiwaJnLMfHiQWjF8Ke7uHaM6wITSdpeIccsoyG/RtHvk3ALVXO/EKUlBUfZFkkHyy0U3kV2X57+R0Otqas2TlHjjqSUNYLRDrlgfTur3aJnoR2WgdOjqHlFjI1VVxWxPagcnbVN+ItI0tc6MMi4OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLgc0ZZ5kB9CaS7MGDaCyc5T4uvTR43Rj5c60z1fX/Q=;
 b=CJ/oZ2n942gqWV5rQRbqhCnlzAvcAaVBSR5HvqkdM0QBmgYsMsYkFH73/eY7iakLX1Zn9wfBqR6P81XHuxBwOVcUuL7va5C1U2SHwrNEjbxXg7DpX2n5+frRUmUoMvjWyZxll/ipx8zySIDLfa96SahvFQXROyA/xf2kqTnjyRlX+z5NEZyxtEkGDB1T+qZg9i4EOZ5G2AgTE8f8Wk4ln/aZAKU3oi3juP64xwMgDWhGy7PFULlajtmLgdRckiKl5pC7lNJxKB8XBT2Y+XvYLdVOCMG2QetzB5RhGhYYnZj9ZR1nWP6aQ7JWOklxTjqk9ApyOUH6V3qCRn3HI5woCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLgc0ZZ5kB9CaS7MGDaCyc5T4uvTR43Rj5c60z1fX/Q=;
 b=GU7TxichvwfK9R9T4DYa9/f3+CQCB4KW/Q8O/UrZbG6Czl03v+SuOM3j0FrYz6N8o0atf7rgnH0P2nnEgRz4++cCMZx5gCg9w5QvXWMCjaLTqzPiwltfZ7MHHlsn/Dd3Ht6eCih9ewrq7ze4SBkKXa/z2dme+J/z5Cjd9rJ+W1w=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 10:38:38 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 10:38:38 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 6/7] scsi: target: Add WRITE_ATOMIC_16 support to RSOC
Date: Mon, 20 Oct 2025 10:38:19 +0000
Message-ID: <20251020103820.2917593-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251020103820.2917593-1-john.g.garry@oracle.com>
References: <20251020103820.2917593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0001.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::30) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: eac996f4-e92b-4dfd-997b-08de0fc4d40a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pf2uly+pscz1Q2JHYOriHQHf6WCZiWnNCQJz12Wnzv4VCqICMWVIYVDmH70E?=
 =?us-ascii?Q?Ag8F5fxziOACuGsT3jWqzQ3k6cvmDxzbXNOqfDOVPD+CF37XnIViVw87KMOK?=
 =?us-ascii?Q?815YVCGU65o7cuY394Hr26MCd64UnzFXiKTrrYnj4deIYYzcdhYK5MjD2wTj?=
 =?us-ascii?Q?XvedxJDz7h1pncET2NxwRh9qvUWfdGDGOqlhR2MAnlZmbNdfUTHO+lp6HpCe?=
 =?us-ascii?Q?g6KtYL8zAE7WgiyAtn/q+6EqOuAWrm2rk3hnLEKAH56yGgo4jl9HYHCLpwQG?=
 =?us-ascii?Q?nC8LZTDVY8mpay/4cOGfUTsmdTUXqUjpQBtAU/Hr97exXiqB641n68E2xCNI?=
 =?us-ascii?Q?atlkvFfAcgx057TwkqO7C6KK20kUuJ/quE4iVw5iUB3K+o+eplaqJHYnKBGA?=
 =?us-ascii?Q?52TCj84PPd8yJEh4cPLAmFJ7hqq/+YJKYb2eEegYiSF/ulSeW1fqD+ypyS7n?=
 =?us-ascii?Q?3SsFdwXV0vxaLZc9SCgXg4rt8UITHKMuS4N2O0qpaRrI79bAuwuteGljvUzz?=
 =?us-ascii?Q?7wn0DCNGonP4IuiDPFhqh4f3yho3atxv9VfXnae9RAGabKosE1cUfkDRFJKT?=
 =?us-ascii?Q?0l3yngu4mVQo6DFGXPujKAQntrFtAss5Qxwhu+l7CecIn/wiv8tUOXwQnTMy?=
 =?us-ascii?Q?HVMhcK6wm0JrD/+rl/MRCuTlmVU9MzVWfQ7kao6zcGSjdF5Zl2+bp5nYJhP8?=
 =?us-ascii?Q?rzUTWHHQVcNXh5SxRo5JwoigY7ZEmxFp8D/drLkeePD2kc57qUimoH3PHzIK?=
 =?us-ascii?Q?CGh1pYuPfH8DFEOm5Icpa7IrP36Y57S6ixrRKjeixF61CS10+koXYOWxpF0E?=
 =?us-ascii?Q?8Ab+4yYEVrnzcAIBBE6D/+S3LGwFLXN5arhHJimb2wmm+QoYkQ6PBu+8gOQT?=
 =?us-ascii?Q?U9NmS6lIot+HaJNUBsQCetON41rqzJz/0lc/dFURI6PK653kyJW9a3C9DnBl?=
 =?us-ascii?Q?FltoQEqiLOpwaNRlsi2fbctHql9sUf5ysnMqiYr8FrnKG1OoerbCm+TtsDyn?=
 =?us-ascii?Q?ZdWATfPnMz22AfKEdbvP7JoClIUZprhtUB/XUuO2DaEKH6S/rsTJpJc89VmV?=
 =?us-ascii?Q?Jlzb0yXt85fHXs8iSTP/t0W98387w4EJaaEIalWANlPHi9Z1hl+Aueg6samp?=
 =?us-ascii?Q?wYFdwM4rw9A0/ZszcYgL/s7nCZntKkuj7zsbZ7ZqHU7Q6L3Dgfd2B0aDaJ6h?=
 =?us-ascii?Q?XToCeyqLQnPXGtc7DCtOdjbkHad3m+ANm3ShILWPKezyMT8zgWOCSy6PlUhQ?=
 =?us-ascii?Q?tjxEUmp9pBtNcJ8yPwtrwyX+sSuUNx1C2Tmz9gJkJ2+5moYHC7+FA+HMDxI1?=
 =?us-ascii?Q?qosZk9YE8m6gb6112zC9+ozVJkF+VDib+LpRnIttHhndQycWTrJkcmh2FkBT?=
 =?us-ascii?Q?QgHt32PDS9zBWcoJDQ9/XO7DCuKbbbMZsPomLB3bUbwGKPZtrRFsQzFg8DAj?=
 =?us-ascii?Q?qFeGMwQHYkeg3pdxdEfZC9XWCgbS7vcJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Og4uYLM1vB4iHQyz3FE6Q9t9VXwKUKb4dyjd3s/+CTXqfpR5z1Nrw/IUQITO?=
 =?us-ascii?Q?GJH27RUBVC+hndXHPU2/aiHTsGziF74Nx7OUlcsbIh/3aa+9hKl4DE5mXBVI?=
 =?us-ascii?Q?yer0ynBLczOv8cRuEQSJ9h+tz/BliKU3EOTIVhd65ULYWry5X2hCq7j25NR1?=
 =?us-ascii?Q?+X4d72+EzSgPwMu8uYIOBPQin7ZtLNqflbZc0hB5/S13PuSd3CXN9PzXMFDe?=
 =?us-ascii?Q?bphvaK8aJyIB6V+QglE0/y/2BRDS0Q8vq2/I/G9pWdUHeHhvJizep0jOB02U?=
 =?us-ascii?Q?CkUtmwL2xVuthy5YyQ2ON2jlIgcW7MxBXqqMCFFUXljZ3Ui9IHTxgZRrU0Wb?=
 =?us-ascii?Q?1+MpV0F1VSireyrtvULw4UH6vGnFWGJDsN+FHpAZCr2aHQb7s4rd8p6mi128?=
 =?us-ascii?Q?VU9f/UI7wi44FSfwxdHzN5GNkzUnh/gHvVmggqXe5j1bWRKhtxBRMJIKDfa6?=
 =?us-ascii?Q?eKXqjBas9yM0uY+A9XdPgJCRsZCzgfl+Iku2V8tp8ZaqaaumCHd9/kTvDh0S?=
 =?us-ascii?Q?FGg0PQzDhZmVECn6U1+8JsI3m9tkM2KL/sqjhphVq0mcM13JPD2SnktDXD64?=
 =?us-ascii?Q?vpRnK1aYMNg9LH4Ro7ALJhy8SyGTpf/T2fLyRcCSQhAHf/YS9IadLlP7EbF+?=
 =?us-ascii?Q?hsNM4fxg3MPFFJbL7hwt3vKZ7Kdlw/W43NI7dthC6Rc70MA8iDEa+lfCFxgb?=
 =?us-ascii?Q?YaqVSQqcE3IbYFGQS1y/ViYlmzkGQKyTxQWiMUN+M1UigbbiExzKiwQCPRv2?=
 =?us-ascii?Q?rFhlDhfmAJW846LTqIUTYnAMgYmesFxHfO6KbFeVjupniGfA2ZxCS0bnHJZ0?=
 =?us-ascii?Q?q6HRe8LKAAsAj2DSM0CiGqwx4IY7ZjnxeuPv8FWKvnTOHktrYmK+HBZG3rQ1?=
 =?us-ascii?Q?PR8uk1ntdP5vjozM5WUsaQMbpN2zBMjbWk/YSSIapQDieOHMF83o0a8CgjCD?=
 =?us-ascii?Q?TE6R+QqAOXUcMbCAvmAEPrMUgbQ0Y18gxDMq7thcP7aCE7V8/NIzrJ/4PMYN?=
 =?us-ascii?Q?SAZc0NVOpaW5kZX3PJ8KG27Aq73po8vhi9hDX4cv7LCU6vHmmilfnBSypG0V?=
 =?us-ascii?Q?lSoPJfvpAaCy044YO8HqEDGwg+goUaW4uY9lY1/EPhJHoIcdgjxvyH4qwjkx?=
 =?us-ascii?Q?+yYx2cgut8DSIr6DxqtlnN46UphCX6dBGjyNQxxmaceZ63U+EM9rwgmHAlYg?=
 =?us-ascii?Q?eftB5taiORd9p4ryekORGDxnn5WmRtzaMtpkL/XQuiwILBaV+qv+ahVvyK6i?=
 =?us-ascii?Q?b1qDENfygabStLqNBMj1e5eOf6RLNOKweZAhCekJRloo6M0ZklNZzD0y9Bzb?=
 =?us-ascii?Q?BykKbEqQuGwjfbuGSySzWZLXw0N9GgcRRk9j8cUO+ABo1jxC3RkY2W6clCFs?=
 =?us-ascii?Q?+RG02PhtBFJhyMeENwlHq1NpbHlZsnB/AAjM9NSREImBocERbwDQotAtLfFb?=
 =?us-ascii?Q?7NfI7wEkS4E8odaxaqPcF6CQmCnzYawe9F3KoaSlC7aUIBAChiM3Syv7fzbo?=
 =?us-ascii?Q?ZNa4RVyJnYv/0XrDK8BHvhvonZr8nh6RCGV+9Hv3iZJqvP1ncMa5mzW6+ptK?=
 =?us-ascii?Q?oqAYMERmoDw77bQFmO9vqgb2k4KHbk64UZNd3wIcdyb1g2q3yD8sxadDtCYu?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sVo5/zYcy5LtNPZN0N1qgKnO7SctP+OovKzRx2c0D3qxcQnki2Bh8Imu+02oj5Yvm8lVJaTlZzI9duMahbmUUwzUif/9pRSF2T8dNCm7rW5YIMpGJbkJBa9hqT82utDDD+vNK1jDI0tPSeGU8mWMZ/3/GPyre7ryr3gD1M2kJqSjPZANmvpDrnkV4yinTJ+1I1adPNdfyabybmaeoI4q780n3cRuEk5KhnPKB3IOHaCzy2k8ktRCfoDzMbiHtY/zAylaUs9DoXpiID+GomWCwrPQaIlNxIiveL6K502IrYcR9c7f2eSMo776hgiICPDojilh81YIrTJ4OSJfI3YRlXDU67NW9SVRoKNRJfZlaoVj7+cWCVy4EQRsPGOCnLe8HT25YX+E8KYlx4OdlZIfY3LbUpufefJjdl/uZVcUrI35jnrm4Hf4W4aFwB6jZJB+tcnmnqR9yFngPV8h2E4UnLPOQGCJmznJYi9QpFU2t79wFOqHQKYVJ/S3YA+2gGQZ8DZHM8IXido5+XSa2FHVn/Q8/LXdnPJzUH0KUNPH0AHOEoeOfh0zaR632s7jaN6MDBIMMzAaHxnHqti1vOz5r+J7HQPpDWt6iiBGcVQakyQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac996f4-e92b-4dfd-997b-08de0fc4d40a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 10:38:38.2691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHVc9vBHxYB08EJYRmR0SMzOrBWieO7emUyUWjnk6NqSgcaN0pR5C7vqGzV5NfG8AWFrJua9/3pLWqzxUKxCEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXx7ECytDABoXr
 8lmfRmlP72bYqS6gJEMZJd+jLPhKBB1hOOsnfwQEtGkVxgiXegGvpPx3Oqjy3Qlon4bq+Jr2ZVJ
 GP5K7+/j9XvNmBnj+leYdhuCiDa1CFIgJhO7/Q6fb/suEg4mNGRrnauBFkoQDnYpK+cCiM6qWWl
 qPmF9ll4vnnTS31qz71UaKIVHOuHFYV8/yaalIOP/nzsqES+QqoVDdGpMuH5yMmdVB5JuBHimD3
 Fhhu2phQ77hccp6aVH+dgnp2AfUtulQxYLg0Ic7z/DQJ07LFaD0aJgnGd/YdTHXrGxR7dHpZQl1
 mqX5mU7ifD0FbQX6bQOHjWkFurBF+OtfTwbtTyCActkK/KkJQ3/YBdemuQ4mbpcO4jMrYJYPLTu
 d8xNNqvgRouIfYKbN34UzOTGGWn+aQ==
X-Proofpoint-ORIG-GUID: HoRkOftCJVc9-kwwysDAKdQl-ZiPAL_k
X-Proofpoint-GUID: HoRkOftCJVc9-kwwysDAKdQl-ZiPAL_k
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68f61137 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=O87o8OpA665DpUvGGjwA:9

From: Mike Christie <michael.christie@oracle.com>

This has us report if the device supports WRITE_ATOMIC_16 in the
REPORT_SUPPORTED_OPERATION_CODES command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_spc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ddf8104645d1e..fe2b888bcb435 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1470,6 +1470,24 @@ static const struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.update_usage_bits = set_dpofua_usage_bits32,
 };
 
+static bool tcm_is_atomic_enabled(const struct target_opcode_descriptor *descr,
+				  struct se_cmd *cmd)
+{
+	return cmd->se_dev->dev_attrib.atomic_max_len;
+}
+
+static struct target_opcode_descriptor tcm_opcode_write_atomic16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_ATOMIC_16,
+	.cdb_size = 16,
+	.usage_bits = {WRITE_ATOMIC_16, 0xf8, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_atomic_enabled,
+	.update_usage_bits = set_dpofua_usage_bits,
+};
+
 static bool tcm_is_caw_enabled(const struct target_opcode_descriptor *descr,
 			       struct se_cmd *cmd)
 {
@@ -2026,6 +2044,7 @@ static const struct target_opcode_descriptor *tcm_supported_opcodes[] = {
 	&tcm_opcode_write16,
 	&tcm_opcode_write_verify16,
 	&tcm_opcode_write_same32,
+	&tcm_opcode_write_atomic16,
 	&tcm_opcode_compare_write,
 	&tcm_opcode_read_capacity,
 	&tcm_opcode_read_capacity16,
-- 
2.43.5

