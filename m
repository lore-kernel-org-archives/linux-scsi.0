Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36443F4830;
	Fri,  3 Jul 2026 10:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074926; cv=fail; b=RYP2Eh7sJ1YmUXLdqtAAL+caG75pRD+grqjI8jI3on5wwe3jHPNoZ7ok99z35QjsiS84AnH7UMaMAuOa1Q5gKsmUns5VxxwILHHJqXsnh8mlmmrCdO6ZxGy+UaRZX4YD+0mj3dHrOSPsHKrleDe+P35i83VpoHT2QsDyy6KCaKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074926; c=relaxed/simple;
	bh=jC95VcPVlKvK0P0qRR0ZR4eAdcdiL/gUIfnA3Lg0Nlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nTOnmx6SbMOt1SX8Nr+X9X0ICG72vc4kru2qa/15Gti3Ogp8PIxqYj0+gMEzk2lLXgBW6GnlcqAi8PfcJcjtXW/6O8/F9Wgs2A/Q19Xxvhb3EqmFZQSWClQedIUNjYvrrZYIKFsS4ryLoZI7oxSQPllMMP8T4OCp8R6ZjKx8ihE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b8VnXMs7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MNbfrq8i; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b8VnXMs7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MNbfrq8i"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tjqY3062793;
	Fri, 3 Jul 2026 10:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ItW2/V3UWBP2kunOQNgjqor4mNnWvrZUbN8r29GUiQU=; b=
	b8VnXMs7f5sCIdVsCy8UtvmHAuYS5Hmn4DDRBe33UbcLGIVBv+AJ3Uzb6ky2GjAF
	jCat1Aq/ov5vCdzcJqhABUElOAy8mXwdFz8VazvBRMZVwgKm9BUVWt9MgxufZUsY
	wpRHFQJzE9mB/a0YYMmz/7fb4Vc7n3NEVdQlPY+LppiNOzD23TpkB/0P5ztxb2VQ
	B3sh6qolGaH3qzV4Oc/BOLmBeUoq7267WTl70wn6cDTmtYKv7R8f10MhCs8lTrS9
	klwHYTKS8vuKn/uxGE58nJE6hhJoqnIEDIGn7PFxMxtAtWiWzV33rfJVjDxdoZiT
	yg/uqNFjNoLFD2tYKHQz4A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26n1aeds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXWSY019638;
	Fri, 3 Jul 2026 10:35:08 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011030.outbound.protection.outlook.com [52.101.62.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yu87ud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Db4ooqwvkxhVd5r6jMWRw8l1F/m0rVyNh8aOI27t89BQLFXMFdhd/Tx9MLFuV7t625Wlbukg4W1hsUDh1WwmdMgcsi7i4caoBIhgyyzZxOws4V96wltMAWZ6Sf8u9QPB19uVZOLZaHjjE8InjruHWzBjftJvAYfomeF4MJd4I2usGPNCUk2Iy8mWYX8FOT5Al/wnERh2hM6efgUXSpOFvZGVzwncNK3nTKjwgVm+pQXjgTCVrOH11xZnssPuqfyw8oosWR7qhDvVCLOZx5q2y9rY9SEd7miH1lPfF5DpZqywNz5ngXMVZnE6sR7z/HxSp0HDaSjeu7JS36X5nG18bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItW2/V3UWBP2kunOQNgjqor4mNnWvrZUbN8r29GUiQU=;
 b=Jt6kATSCcRWC7yKyFIf5mhYacKepeVNsWTbB5LUoX8GXjAOsVCFRzYWxXNDEJoSVFXUfPbLWBfsnuN9PeE8cUHtJb/TabthcV5ad+maKlId+ATz0AUaUOmigduN5pebgYf8ty275A3PVExKQKFTC5j+TmGU84Y0MHs3u3WWBQTUgQiZQPDdDMEVzn6f7NAp+nMzCxrIwP9lT/9d8nCjLb5bXV6sgSzRMz8Js5z6FSzUV0ukh6QV2n7GDmeC8z9HjTAVmyEBhXh6f+FZVmBgxO+eU01aWGw5jc+qKqedaoTbqIMnW/qHuFpJYuQm3hYyLjIPeIMcDH1k3RCJyBxiz9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItW2/V3UWBP2kunOQNgjqor4mNnWvrZUbN8r29GUiQU=;
 b=MNbfrq8i13GmcHe8nOuTL7gdRlRIBuMU7iXcmY/0HRUner+Qp3T+tUQ+AcEnbdvIv6YBxJA0wn2cH1J47NxBsgptOBjyCZMhy7SfegCf1yhXRmASRF8fo6vlJ/3IUoI2VO/wjFC7yvHr+vlwyNrzVBX2bnSt1n78THkWs/9nM34=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.11; Fri, 3 Jul 2026 10:35:05 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:35:04 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 16/17] scsi: sd: add mpath_numa_nodes dev attribute
Date: Fri,  3 Jul 2026 10:34:01 +0000
Message-ID: <20260703103402.3725011-17-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P220CA0081.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:259::6)
 To DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: b5fd6be2-4f5c-47fb-22df-08ded8eebe73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FwzEzG+UHRktu+2EF2lLukszVxZ0LRnJKzE2wM98rsykBI02Fkm4VW1BvPcXkqLUkVAqVE/5wM6XCqiVa3mMn0Bag2sWggnM3TPnEHdbNRj8fAI/1PoK7DvWz/i1khGiTxF23syIqlGI5FwK6yJiCg5Vf6mnSyPHERhHp3IB7qDN5TqA3yGfyTernb4U1Rp8YFHmFBLGs7lc+gXLtbDNVag0eNKiTzmAWuvWrXXzSDrvey+A5XArkmNDirnj9fPRe50cp8Bs+6RC6IYj+xIrb6bTCeUL/QAFx21zqRnr5YblgE49UhMzYsxZPtNiBcVkMixgx9pYZQQFVZUqWZnvsDX3iqNQeu8OHNR0LzKpDUZgl9yh7L74a0KkRrNoZUtyDnsfnM/tqB0GN7BZqUrIHMwNIUDa6WBKe668lYrjq7hFNgJMPrnUvKri2rWQ2kNOPEHVWazQRmexE5nmP0ydjNXk9gwLak4HIUQmMPN7jvRXyLzBCjEC7apd8bWLRgOWDboCU/IowCdjQz+biHtI8xyeTEZiprYxX8mXsgnw8ouIYlrr0u1VJOEnRkvpH1jCC1Ic5c/ASwzOL6fQhDVlpLmB/vkYXw+gjzeW6KQktAQDGeWWBpyN5YJR7Le5o7u8I+So9rk0YGGCULokdK+pKsGnIGB7F9F7SLRB4bkDJKM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fot5XcsQ1qBkkU7hLdhWjzxgONKRBstY1FAK93QWe/rYEQXakui9JawA//PN?=
 =?us-ascii?Q?3jGH1JXDCuZdNxD+jivwRuPSXp83aStjV8xs7aozWKkvjPXP6DGGSTvbCTZD?=
 =?us-ascii?Q?mfHdRPXBXcCNaO7RYoM0bTJ0hPmHqX3+GmHsOF/wwnJOPiiXkWHHtEzACNH+?=
 =?us-ascii?Q?MvtCLgTYsz1bzOYQn9omdmVYEIRckHsXaUSNkzVRsTw+UW4iuKHA8FC5FnVL?=
 =?us-ascii?Q?qYuOmvGyVn2AHcy8R4MMXq4Xn1RkVo98t/Y2zmf9ufZqC2Ti2B3ME8mxniJF?=
 =?us-ascii?Q?bKQiQwW4TUxgBRJa9miOdTN7d95mtd9UiMiv+t5y74iJrOiSDp28pSzzWiAJ?=
 =?us-ascii?Q?1puuIeA0Wt4jbCN9AoOM1XQPVm5eDw5oYtE0H2Yy07xiCMx/zvZP1SJFcYKY?=
 =?us-ascii?Q?/bCambkEvwoeu6dql5QAlOmbszpkBgntxS1LqjdQ+KnRVPYURo9xUtqioV3M?=
 =?us-ascii?Q?VeWwYmA44Sb6GinOxhqpNNVofhj7+JYdXmwy9Z7PProAxSr+3p8M2+fkYPhN?=
 =?us-ascii?Q?fLpQ/Q63qcRhTg/s3TO9GMZzcwE4U7+ypvIQhWv+roDOvplSkKPTxqyX33O3?=
 =?us-ascii?Q?hRnXHvtrSLVWyrQSCjM7UJtRI2seGC+I9RAU83S2wJq6OSe6VKnJ9OzbrLG1?=
 =?us-ascii?Q?ZT9MsfY7njmp1KVk05V9kl9/5K1IMWLjeKMXWrYCPN2YRrQ+7874b8zP6oBh?=
 =?us-ascii?Q?PNKN4bIE8PXKZ4UEydy6J7z7Ddtq9KN19VXcc+VDYbRKPMG/Yg7meaRL3Pal?=
 =?us-ascii?Q?nvSo0nvRbLXmVNpiW5a+35bmITX9SPwnRgYd33cLv+PTSwFTq1ou58+yRGzk?=
 =?us-ascii?Q?2tNrp/ZNvwhRyJOSPoGZ6PLQUb7sP6Jc9l7U/oIeJN3Bvrc9jp29vk3kvbT3?=
 =?us-ascii?Q?cYRFw4S8yW5miggjLCmS5X+TxAK1YW/AZNeninK6QoojfxD8IfapJXd6wvjS?=
 =?us-ascii?Q?2vEgyDAFaSGlh6bXGtPDm+9XO5T8AIz3XR5iBFlTItZNQMRVYmyM3vpxjfYa?=
 =?us-ascii?Q?gzisIG7oS0MdJlLgYXFmF1pEjuXVAbHj31Qm41HpP7uc2Y45v6XJ7LLnR8tj?=
 =?us-ascii?Q?Jhh7OEnIdktaLxGtG4R4MaknF8t14apIMeKb9QUvJjXb9LE6K2FcAestfs7R?=
 =?us-ascii?Q?crViTxHBjzAW339sXg4yOTUhBkuEE8NP596hMPb2NPM3A7FXZeYmTvWzt59y?=
 =?us-ascii?Q?fUkqiBVrY3ws0d6SsJbS0IcHzy9eCwNoNl/bmbOboTj5IfQcMzdc2ui2AQ8s?=
 =?us-ascii?Q?Axfh0Ulc+kG8AXOKYOIp4lMP7c/4T5wkFQH28Ayz6aHq+feYhH5wKcVnVfe9?=
 =?us-ascii?Q?313wpIqo4ClQMwzui4cAylaG5nw1zLZz6HNDttIRLBzIRiTJ3XvBTWI/PXrs?=
 =?us-ascii?Q?L0nZgdGAF8HpaMr0+KLkC8al1wUZwxuSrDZwtcrnRgQ23slbRaTKdPkYpUpg?=
 =?us-ascii?Q?fEvKet3krg6Xky2tc2QTxe9FxGSKJiDNZKXQ0YWM3lSMyIT0QtCWRSdJVhoB?=
 =?us-ascii?Q?WjyjUZzJ7zPRCvUzgrR4nEY5Zx1nf8Wo9JVY+EcyWQNtu4NtvFsDHglQPjGN?=
 =?us-ascii?Q?0bQ+xue9azgtt3VQsUHPZcSUFlc55zEXr2Hr76QeiUW7IEKLkg7OPfTVIDll?=
 =?us-ascii?Q?p3+AEX7Igs33skO2UGKtxx4cLtWchJFq8ixkNPvVj4b2OAySaPicaCKNqGNC?=
 =?us-ascii?Q?5BJWuhZVZg3D7TX697K5JlmLXPWd0TkF6m8Hprrs5yApcNCFrrJ15CDqbKFa?=
 =?us-ascii?Q?PF8bdBFfc65IW7ifo+daLXajcimcqls=3D?=
X-Exchange-RoutingPolicyChecked:
	QSZ2vrYgeG0/eMu0zOqh++kvF/Mw5JPk0iQlWHrG3ShOcU0I03QhwEqoXczvvn4AlbU0YQd8l5YRe7ZxJMSGnQdGYH2PIMwgTvoKkRYT6HoaLFuTFiwOOsM1S1CkzfYJ3J2BFO4RvUe0m5ybNU82U9VFLkv4CuJbr4uJhH3bVIwKepXRAlGFr7AjAWaqdEwC4RjOXxfPCflLapAQnOVsWtBL/ZSu274OtpK5l98ijOiLIHPclsinZNTLoJsaNSn/mw7zoMRW221CocFcQZZm1CAVH803/X8WZWf/uDPYFKJHK+YX1OW+vWYz3RJp9J/DFSbqR1ZEUCv3W/GIRijvXg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3XdAGxl1yM8LbIITd4qPKmFx8C55airpLGhEGoWp82ATC01LIftIjxEolCn/u9ONq2Glm07pHw8Ex5BT98Or6jcZi3RrGiptaVA6D1xkzZozD0D9RVq22iJKjlAAPeIVetjuzSf0pki7UM2nBBGmB0ITDp+2maknDGALgcnPMIIyb/vAQv2ZbVXOmy6ruCburgvcvZl4+KdlTg7VCM823UN4ej9Ub+pr8W/dj8VSNEksxpxS0a9GZh+U0n6Bs8zRS76VM7ma/fo+0ku1B/YIFpQ6YkOiXTjL1HPLlOVpf4lpU1eGmV+gNvuNf7GdFLCM6dVOID+IbGShVW7+vEUSnOCI8E7IrdjeiKKMXuBwSCZJnbzX0gWBdu4qv9jNu4HsqiMi6qwg672Q5S+UtrBM1ByVVJMEfGxrPgpmx7tCHFFAPTZUWKY2cM990E4AZ4iEh5x2UOAepnOcPxV1xEa7bsgPwSLF4vAPvKJZQG0BJpLZ2f2DaF9SwTNvDo/l0nvqRHhV2nP5Pz5AryzuYx+mxilRxgYH7kf766lB7AAmc1FeyFmaVjIYm5CqhN48OGE5f54xjsCzo69gr6kckSEY357klXokhy4EL/zF9kAPwts=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5fd6be2-4f5c-47fb-22df-08ded8eebe73
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:35:04.5568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: un4aR2ZtbhMDLJ+YAG5o5GN0w9x+UtqDaUDuWfco3YV7nu61hQ6FXpAPofJfgxKzR2gtpPvkJWm2+XcNqleXzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-GUID: 3U7t0bEscZddl-9iGu0M2A8L-qCGVPVf
X-Authority-Analysis: v=2.4 cv=FvI1OWrq c=1 sm=1 tr=0 ts=6a47905c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=P2_R26dytZ8aPJic-48A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-ORIG-GUID: 3U7t0bEscZddl-9iGu0M2A8L-qCGVPVf
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX2oJ8XMKNeN8m
 +MeSIVDMZ2pak+YYPkfJJKXv6tzcRoXdwkRguGSAcbNrO7k3SIl9PpylatSn8Edf+YGhgJ4JCDU
 OKQl/dkvu0NknhbrEBbT5iAKcp1cKbYVW71TxJxNscbbiGUg65yB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXwIGEeUUusM1T
 IABcScSke0zmN506mxi+9wxbEo712MbhDngDKmK8RRg7lwjyDOoLUoa9NsB1XsynPdmJZHBgctL
 7dlKx4dWodlAAEPmgM5mEr9zdapNljtd0ct70qo7b4OWqnhQN3CY3nhMmINEqbj089Z6wQPojnx
 rcX9bbjBgZKOPUQvDP3401Y/PlCuZQWom9K7kwaRQ4iMxRCZjTpa7mrgbv4be8pq6S/JpQwilpJ
 Ii29FlL+xk0HHOUGs3hE5VE7FMItzcyb4K2E5c/21ZyK0ThSNXM+G8+S9ws2IOe571uql+X4qKP
 Y7UodNOl7yYsJIozV5KWtbHBYDCB/4CIi7FOSt3qrQKiiBqSjM4mA3sP6rC0JsaC3w0HOIdvzYe
 I96+KsYrbGwJPE6iFXoWaM2uqi/j9AIbrIz1JHri/bSaEPWqbJP4HNzkmY0VArO4JBRXvEl2wF1
 +HLo0pdoNs7p6uiIG+kYfgLsYnHes+rRhFgJWQX0=

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
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0c77466f8291a..5e0514304d81f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4075,8 +4075,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
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
+
+	return mpath_numa_nodes_show(mpath_device, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.7

