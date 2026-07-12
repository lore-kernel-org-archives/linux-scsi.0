Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DB32D47FF;
	Sun, 12 Jul 2026 21:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783891831; cv=fail; b=p1CTLGa4kPR+DCoREcIkDCaXvnuVUhJCUm1/aM1TXfQYvhPX/a8zCQ+BqtF02kE5x2xV/J1bEP+Kf6Era9z6GPmDpXgnzqZviojJ166myVQiNxt+DnIWf1ZhpW3jbe3WMAWnojbNAYJIoc8kFrAnuDMbPBH4RrRqXnJvhSauCOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783891831; c=relaxed/simple;
	bh=EGVCrVfrlEuvu+vTbySl5F8Fsn8Jh6PG76g8m4VKw8M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=N4s20qRI1CPN90+L4TxHN+QFo4+vp06PtP03/V8FP4CGWK1RrkIUApnZR6x4EjQmrQ47YQWt6g2osZRP8MuCqiBodcewlQrFX43GwwTO4qJ3HgwcWyHZMxyJS3/6Osd97xMEQ58bHvic4HC5DYbvDK865208R80HmlQc9stHCyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ccucrzR/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T21Y5MYH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ccucrzR/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T21Y5MYH"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CLOJlD4086148;
	Sun, 12 Jul 2026 21:30:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GQ7LU1X+UtjyVJebXG
	qxQFfZdcjJIz69ObVSAvZ61wY=; b=ccucrzR/C7Smpu4zsj1Fdx41DPHFVe0VNM
	2ek9EFESOVzjBXdCF8tJxp2qajwlFGoKwyslbA5/hajrYAbgmlwPNEdhg1J/6W4R
	wm8rDaq2C7oi7njPEv3MzF5JhfPnEatb9pWaTI8m11j3NMZyKZIZXoDj3UH/wpFm
	MRB+jkaXc8BXLKiaJBEUC9+ay0ZHOLi56+Fe2hVYL4ySaWqt0eOXrc4kyhXIbJnE
	mN2y/cKHkis/nNAJrAcfk9dZLNv2AiBlcY45mXyAhNoB3HBuVHfykB+9YeXvnhWZ
	1ywso0KBSxsV26b9YhDwztDJzyNcYXEKK7Ry2k4BJdOZw7wB6hYQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed8180r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 21:30:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CLSAb2027500;
	Sun, 12 Jul 2026 21:30:24 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010049.outbound.protection.outlook.com [52.101.46.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9ce1rj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 21:30:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YobXY/vjHKhoBsKH1iep4UJ8NpKKlfwDEE1hTWDuZKV3oJnpYg+G1JbISXmSh+Khhhvv7oxZ/zwFONCKAOmQAyW90kGwK9TcWMEjuLVfR+ZfQFPo81X0jw/PdaaVCxIUoGdodTTC03eaciIKoGOeE7VllIWtsJTSe/2jkJO0IslN6ne/k8pWvatjwOwD3vm/khHfx3fB4e7vimCBN91//x2YG6eon33ErRnYo3FfrQTIKA80//YJBpHLJEmWscpQQ+JzrwyntRPWYGNnNkfFggb+aaucHPgtIqJBifpbTfuHUjjVa6gtpBoSPDr2hMhYRRRTaQ54b3UtbY3OHekEIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQ7LU1X+UtjyVJebXGqxQFfZdcjJIz69ObVSAvZ61wY=;
 b=B23YCuDqYUlAXcvRjdJ85XwVDTw+fDsHjJCRXreSaAgErGoZLoze2lueuPYNVJDjoHPeBIUvyIeCnjUTrJpasOhQ57wm5ArpxOMi4n0k6VhFuO3+Qv/nZZZGtsIu6Td0ylw3S8dWwR2OlrZ6bhNZ+E8bPt63wqXDC5zqoM1Wg3pzHw5XxaNNvBQrT39n6ZKEB5QZDL+x6Yy4+cCrbzfMRDhh1iAzWDrpyLOWZ9BxC2amC2YDFmX2WJAdmbFW92t4tNE1HeltlqVHXI/ILTCGtT9j6hDcNmDaAKrKlMGfhxHkMiYNe28bPXfe4EEcMejdaE8EiCqMHEw+21qAl1mTbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQ7LU1X+UtjyVJebXGqxQFfZdcjJIz69ObVSAvZ61wY=;
 b=T21Y5MYHngMocEhJdEWpKRr2MIXF7C/zU6FG7yHLmx3GB7Rrx9T/LiPH5bCQXMxHtxaGscvYr3yc9RAlJK48AQ5qN2NNLZhMR6P0cQ/lKn8sMXOICVINa5n9Qky75Gq2n3HPHPTGVloE8F2a7j0iARlEOWVpIZrvbPa3aDZclCk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6202.namprd10.prod.outlook.com (2603:10b6:510:1f2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Sun, 12 Jul
 2026 21:30:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 21:30:17 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 0/9] ATA support for storage element management commands
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260706065610.3559692-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Mon, 6 Jul 2026 15:56:01 +0900")
Message-ID: <yq1tsq3dhnv.fsf@ca-mkp.ca.oracle.com>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
Date: Sun, 12 Jul 2026 17:30:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0323.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6202:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d5d1619-10a4-4008-f64b-08dee05cc482
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8FwB5SLqSh/HqbvdQAaDTEWQ7Uby348IVzH0wvaOAf4Z/h2nxekfeF10jS6yGaR34EbiuiwihRRrKoN04Tk1zPeD4exbvfUAtqi5fQjf+6XcB/5eNw2r/oc8EMCbrEOJMQCQNTjiUEoBPLSfuESRY9IeLlrNUzNRUk+W1eMlT5GJbL/6FWLaUpE1XOpN0gD1MYg83gxzlXDm+nnGqS6+QegQPIf6SCVUQXq+/O8c469uFH4TvI4P+61o9ZOfw1qWVF8GZ8wGUfvxnhTNxIhHsbZDfFcsdSEFurnR+n4FQcF7Npe3BSlLxK+ZFKbwG7Z1Vmo97IDtU+un8Ec4wvkmr/7O9viFSq7QBFTV1lZuDDeUC0keqUKf91LNfNQExT/jdMeT9/G8LSdA+QXsUMkWZ4KnrA/nhqM0u6u+u4ObvXFYPXUN7rB7I/PQtOQPBWlFXPKEBSF/q1uKfe/Y8nen/mZrOrdzOO2/DkGugWAmF/X+rJElYpWbleOcpDOri+wQwmmZcnLsYfIdJBlQ/4oj/rRN//+dVFv4tALDhXInC2P9/307Kt3pDZeoscGM9kjd7XzYatF/mP83uomW2Lzh41X41sWJ0ERkChtD5g8GUIdoiDx9bCpxcu/hsNSq0h5ZnHFxniN3QwryPe1jRrOoSUjwsE35cL8ksFrO8GoKikw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zuAKuBDt5fwxW0Hg6k9IjLuIKtjSwqasoA/tekBzUMlAUvO4acb8GAxA740u?=
 =?us-ascii?Q?l0uFhGEvVc8nno/09EEr4A7hD6UMEyusEwXFC8xlNBpAB+Bv6nbu33aQArBX?=
 =?us-ascii?Q?NEYhaYU/kxwNgkM/+kIu/4V9B8qZcRbJN+UIfNz8PRb0ko3oz2ltWwFSeKaf?=
 =?us-ascii?Q?bCB1d5arVl67SDoSFyjB93jqMmqtCag/u2b0EKv+rKbcdv/bpuAF/mwMF4Xq?=
 =?us-ascii?Q?EzQnY9mLp9OTpZi12NSScPPj00lFVxR6/BeI23cx3NL7k983Kc7ALeBRfZ8j?=
 =?us-ascii?Q?rtDdWcIusp8Q7Qozu740j9dAeUZ/0d65JU3Pbca3Jteh9fmkqD/0CS+ZdaYA?=
 =?us-ascii?Q?WoBKBjOFn+tA+wkeK1yXKhNIykQ9g2ofogMwK28wM+xFiy9t8+7qDMfCT5er?=
 =?us-ascii?Q?PtmepXoCXZvl02pzzl8JDhtv63BylYQC4YhNXDb5JGQxxHO23GW9PIY7WdFh?=
 =?us-ascii?Q?LlDmjAMVzrMBzt6Qy9Xf1enSTNOkbN/NxAGOqay2Ea4lopuGj5eTwA7pLprK?=
 =?us-ascii?Q?feOcWKa7XnMUqTT28xvBYDPmB7kgFAi/na3FkkGlVKcU2mTT4ddNBQ29encZ?=
 =?us-ascii?Q?APLmRqwUd2I2DIgv1UJrBuJxIbkuUif12vCnGd2Wu9R+R38npDzel9WOEqq/?=
 =?us-ascii?Q?7yLsxgp6FDzHZgdwHV9GixHJ4bZFhsKTh4a6EClN/sA4Sl+6BfOOj19+5Lvn?=
 =?us-ascii?Q?Asl0JUWFALzH6ssAWihjoBmTiOu4pmSJcHQ7udtV7gz8MNYUO2DxTJ+aaU00?=
 =?us-ascii?Q?lS/J9Dg90nnqRpUzyZkpVaCnZrWNhcJGi68q+QwPfkuxyFkM/hR6VBQz1Khy?=
 =?us-ascii?Q?Spp8t0lGVlrICdpWt95YoKKvawDdovkTXLvMHkZ42m+dccPybQw0RruScdDs?=
 =?us-ascii?Q?jIWuE0i5XCMXWd9bUjJ4+J/hDYTwlnolP6f32HgQXluQk8O5NNauNZuUBNwk?=
 =?us-ascii?Q?WtvApOjqUbLyxXv4yK9sxjzdtog3bTipQQrbqvidVczfZMkr4+17QmYPHq4X?=
 =?us-ascii?Q?vMZdjS+N5QnCbl2fPRA1bxL0GAAv4Pu4haXkjJQDagwbiXrwfse1rITcNCeU?=
 =?us-ascii?Q?a6UcCPflbivj6/VWK5EUpllrdLzNYFbU/YC2vg4SGHYQSu0EWqstyErWSN70?=
 =?us-ascii?Q?kNgfl6+SnQFjbTaj8LHqRup2p5S83PQtRrFeQ7a4DSgbUbsOsIsK0DD5Gu4l?=
 =?us-ascii?Q?9NK0Y8xyuoRIzNKzFcix6VGcR8/XTA8X1u2NWdbDiYWwU01gIxsPcjiUgmT5?=
 =?us-ascii?Q?qAWKb/21G7rjJG6t+Olr4PbbfrT/40j3Od4mnbj1GxVERS/IYP0laBEQvAMO?=
 =?us-ascii?Q?fsK+1iIIdu9R7n/da3YfXfq4bUpjiXVcSZri7cvE8HITOVcF+YnuN+5ux6UZ?=
 =?us-ascii?Q?WPKR8c3k63FG6SvX0E34/99GAOdbiVriXoiTiKVFnC2N9Lfpt2Wfc5cJJokH?=
 =?us-ascii?Q?r7N1JW6+iJBTiQRAhCHXo0dvFnsEQ/59DEu6+3MwCdtK+FKm2hhY6kGULJeZ?=
 =?us-ascii?Q?WDB0tjzVgGiCbzfAPkLi1ke7IG0G9STuldT9iH3A+EtGaGxVp6JvRaorkkg4?=
 =?us-ascii?Q?wjOgkjU5sFw4FZwjmfk6HLjgJrEvN6hCmse/V1bOAd6joLEy3Mc9Y9T4jpPx?=
 =?us-ascii?Q?qEqV8wDoF6zmBcOcsmuY8qk2JGvFqfB0cC+CTkOstvdwoTg6JYcZ3O1zIhP+?=
 =?us-ascii?Q?L3cCtaHD0LpmzOg7LSZuejFZ8D2ZjZV+H9W+UKD9o43cKOpgYEtncAZjoubG?=
 =?us-ascii?Q?Mt/tRUHLj6pMIPME2ZzbraG20EYAW1o=3D?=
X-Exchange-RoutingPolicyChecked:
	scjC4437jvBgXEftj6q0tO+taD99OCsnpcjAH8Ra3b4kMMz1zZl7pgYbd927BMNGPIMxJpA1KkHxfJ2/f4bLBtDa6nZNgtgjoQBDnJyzz1Pq3YFLuvuxzj8udvOoUTTjykFigqx9cE2MzGaj3zhWm5bTMcSlJz4wpYkZJi2RVG2puUemDboK/Ly/dZxfFWuQJYsJ3h1lOHMXEk9LzcMoMpC7vJEP8qjezS6VH8pnRyKZEH5sjysR6Lj3hmCoPWhStU8NVdXWi4zBvVc7y09hcZgjylPNE/uCPQvtMjx+SSBvFztlPK1MezZHEIRsv7xDls34ePxn67WUsqzaZF8gcA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mqbjoH60MAGFd9r9bnD8FdWMc7Ak5QoRJyHS6FNeG7gsUcHdMqTDQbPpfhQoMusb978BcCAqAyR4H1p/fRn690bd3QxgY9QaZRQRx49if8mu6Dn9cv3xl2iyYXYnQoD42xSLh38izyJyy22w9HtEouoZylf7NIPUBAsZ8P2iVqSVuX5sy61RJDKwk5gbFNDidlGQpklsbcbi585rxreXYsUgYwBnhZUT9/z9tRQtUq9sV32gKpWc3aFr2M+O1OSDky3jV4rg8UKOTbZmiFQXpXNhijDjpwYldXk5ILqhtEk4iQYZIE3JpFioIJ0if1t8xx3EKGmvuivtcsxDq8DOMphIAtl4IfDOKE/JsuRGvUtBd+oImKhTFsSwA/B2XQcO6gSLdG2Hwk/pNWQGPMrE5dG7Fwx2UZIIBEt0HSfWxRKqg78suTe/2xDyc83KuSAZr8/U0KLd5H0q7YZwzYcAyqD/LnY5zOWbPP4rEwe162a8zR28RiAm99E8yPc0hRSit1FTIiBoAT13ux/ug74KBc9v/AMQLk4cf9w/vwkUHa/3Awu5bnDIRqLKsxgpggesH+HqfCsRPExwfrviAP1UO5OpNNKoKFy0NG1tjLQ+Xbw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d5d1619-10a4-4008-f64b-08dee05cc482
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 21:30:17.3174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IezP+HdOg4hK+5DOJ3GxH3iIL3dRBTMxkKbZqCs06yvPCKplKg3vHv1mNmaZdw5/X0Fao46C11HqelHrCRnxIVZFQ3HmnuycUk4zvYZhYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_07,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120232
X-Proofpoint-GUID: MsFKew94f4abbBn72Eme3P6v5IFenj7n
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDIzMiBTYWx0ZWRfX+0s1qWG4vdYs
 9JKyo5H+7skU64DDtU6rtNdszGLpYZ8Kb9J6jwerGD7nU1Af2wriS3Zae7nKIRIvXsFoOeEHMvg
 ABe6+VZb4kcN7G1lInE69UrBZAyurcSDdUR9f/JJGOHqNEFve6hv
X-Authority-Analysis: v=2.4 cv=JKALdcKb c=1 sm=1 tr=0 ts=6a540772 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=PjNNxQFD9osv2cWVRxsA:9
X-Proofpoint-ORIG-GUID: MsFKew94f4abbBn72Eme3P6v5IFenj7n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDIzMiBTYWx0ZWRfXx+yqJcg3sO7O
 YZKvyeIr8Ppc5NbKTN9DfzzU55rig8JDyNdqlQrnHuLCdcfPMztcGIN8AuOF1BbHUyc/IU5XrFq
 JKd5Ts2TZZ0/l37RUZ+eR2YuGF8+Q4j/RbL8Ix1Zmg6d3u1sKw6Rm68jXrOd71OefB5UD6uYVzI
 GLAZvaIwIBc70vtuzgFLziRKZYX+xN10ND50Wg+ow1dfWrngG/FMVfeCmXZGTxvuMPNo5zM4oVD
 D06Z7jkbYkjdUUydyRkfofD3NyZhnhs/1zJmkbKKCkvjIrLyNO+eWzXpbpBT1vptHQq7me/wR0e
 Eaw7ruyzfQTtpdkyB+s4xuhSOoffataUhl5x3G77ApL0IGykF6wgUC8g9kWpCKAT5h5E5+lgfxw
 4D5sThHFzGt533JLmpWigo/uCMiczeVB4e0oMEPwCfEtwkYbQjK4Xx7npvzDBTHGVszQ/BzAbeJ
 lqbeATcJ4DYXlw+BYZg==


Damien,

Series looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

> I have more patches for sd and scsi_debug (depop emulation) that
> depend on patch 1 & 2. So I am not sure how we should handle this
> series. Maybe we should create a "depop" topic branch in the scsi or
> libata tree ? I am open to suggestions.

I suggest you put this in a dedicated depop branch in ATA. And then I'll
pull that branch in if I need to.

-- 
Martin K. Petersen
