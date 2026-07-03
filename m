Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F313C81B9;
	Fri,  3 Jul 2026 10:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074684; cv=fail; b=Tfa2zYZDBuI80Uv/aFeD9sT4UqpQ2JxHZl7EV3bRD1KRfHzk4BkWMINtpXWjGHmmh45dEsJvQpg4E0GC549gycSQr5rBUDAPX9jOQYluGRVD76kM6ZV01dEMabuI6X8gf3bGRTsCjd4gZ3t4IqN4x+nBvjKZRMN/HpQA8DOO5DY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074684; c=relaxed/simple;
	bh=n2IUb3NuzFoTEe5DT61vIfMLPFuAmBueRb0RT+mqDhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=toLaFTwG8ejHFcqjCCY85m4+/UWOyD3HkkgixXhqm+jBoKJMOYhSwTxSDlv/rdEYs5mWfElhFVkkZoVmDfPmquhtwwNEW4pm55AG2rBn5fosvsbUPlMJIlJj7To3UACygxxDV6r8IgRK83xP9BwfZcwa4nToiNvQzJkMi4NNrgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oiTErgx6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ciNpM7Zk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oiTErgx6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ciNpM7Zk"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tme83329543;
	Fri, 3 Jul 2026 10:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kcWJrBYGzitnOk81vlGksug5hKtIbNZI8js4HkeWB7k=; b=
	oiTErgx6Phnm+nO1jTk1m8kF+BrCGCLbmTk69Vvw2oIK51sDIu1qCLu4QH2Q1cYw
	4bgbpaASPv6HPmiR57pQ0jSmrXRDpoImsuVoH50yxa2DB154DnkzulPQ/L9t5WhE
	604qTGScL2ipTwkUb3Z0cPD+OD01qRJ31No8ksuJekKpJynqex63CkRlwetQZPSu
	N0nDQGxb+mFw1T13oDOM8fPWxmLmriTnAemr13V+07/BDQ9oZXQFAiiJlL57ceqE
	TLrkWPH3l45vdpTJJ4QevbhIMa6Bx2eue1RPhFdnMzY4PxaByS3NvK3gf7MK+CZH
	YeoJQtNrulzmJn3ZDK1xCA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26mkadx2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS702033784;
	Fri, 3 Jul 2026 10:31:03 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011059.outbound.protection.outlook.com [52.101.62.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhyqnx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WsqVFFLmvJZabeSW6apm1z2qrakGQ7VRUK6VrWOo9VyFDvuZdadpMMeHI9ekjCUOlGeeSoPE0fRsL1+RG6cseoE+qomlm50KqPdwlsqZKfjg+3l9vC/ZiGvkw77IQATLofNwyB5NoWpC2rQIAj/wuEPRoaDS+5EfxgmJRW85nC949kt2yLeqm4aln7Q01A5bQQ/4bE6SR0Qb4fVYZXwhGc5d0/n5tCRIvvAQVXcY5tdP7OeCReUNWRTCViiW5rxf2gcNj8qLnaijWtJXwToCUmpm5CibOh7Q8IZo/IJltMad3mwizFopRtWc4N1jpue6zPIqb+6IJ808N1xL5fPfHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcWJrBYGzitnOk81vlGksug5hKtIbNZI8js4HkeWB7k=;
 b=DCjiceJwlp2viuGPxxiq1xdJ8FP3cVt2WVOHzha2uowtU2m/cmyNVyTZbSidZ2yiB/FSoehOgtscFjP/UNm0Hg8R4zquKfcKLnSQjNQYErvxafvEKCcZo09/0aR+ghs8AkOEqWkr1MbXeCnPHU0+3+sBoCkNduyqMZLNLLQGaY+M9nhoYpZp4CkFWgH8SitZr0K/vf/qlRsa7I3/IgKdgABRs3zEP25Iw1DaNLUmJxS5qWiszBVkPTGHoOQhilnp+uSbk4X8RHXVQ/n6/Zv4P+DjD7Sp5Y2NibOlDr8OXuOLtcKEKQMZanxYEX+xmhtO5BuTH4K+r2oo5qfTZGJTxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcWJrBYGzitnOk81vlGksug5hKtIbNZI8js4HkeWB7k=;
 b=ciNpM7ZkSP323lG3vnuEFuknaPFZhVfLkJxijNU1p3cZuIpKWZwcU6mc8KAl8M7AZGuYwsJc9xkOo2ggiRk8S2rRjEgbAv2kA+fZVvDSH5aSqTS+QJ+5WS+4FkfzvG9ndnRwaYByYnQWoIKTaxpBVIf1hkQ4l9lsXRTnaLTNfIE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:30:56 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:56 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 07/13] libmultipath: Add cdev support
Date: Fri,  3 Jul 2026 10:29:12 +0000
Message-ID: <20260703102918.3723667-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0038.namprd14.prod.outlook.com
 (2603:10b6:610:56::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: f7b903be-e37d-4952-1b5b-08ded8ee2a91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|3023799007|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	T+3mQy2t/Y7r78t2NFb6T3qr+sw0L8deQUHI3xMewW5vI4MeI0z4tsck94GO4WF3SYAhzLT19KQlEC7BhRrCtlhelBUq258F/v/ejG6D9s/rSI4yTMZCcO072hJWfD4E3vpITtfCpVHarD6tb9gK5sprO0IfJfHq/RIoxa6YIxtwF0p9LgRMLh9BCNb/tp9pKedrj6briFYv3iZdup+vT5hqgw0wYb5fGVukJ2PCRyOH70i4sCWrIYZZy11EMQSBRWpUX179iXJdm1X3WcLpjHa6Gryeh1MT6rGhH4Igy0Abrn4g327xlwfks7RaRfnZ0q24+nob54ooR2/ANGzEnW0g7XM0rhnRlBhD2IiSEcuo4tsT5R4eUuScueTUAqHpRaFYKuNEq5Je5pudclSX45+5gJwtmXO822xH0B/aWDOl+AmcolniUdwTAV+iPrAwzjXaM+mRxtuYgzwkuvYjubZ9oDREka85+ea+XwJWsy781BZb2YlHp09AAZmJaN1S8I9jLrVsD7KaR3kCdcf8/BRBaANBg6s376a4uhs6q7FlEqVCNJh+oxSEBd+U39Zpdqg1851ZBFnixhOLPDbyscspU4iKv41eJUhc1bKFbAQEAkWtu2vzIHJsX+yhLSQwh/6Ojrn3lMTzEgwppE0M0CCfT1KcRBTSI9hOlf04QfY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(3023799007)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6z2SEGjieFIetzaNKgOZliNqNGQMR4tsQ6lXqj2a7L4qge/pzeTwMfXdVJj3?=
 =?us-ascii?Q?eV2ZDco4TxDduiuIreMS/CNn55HkVE23MNuUqUquN+FEgvY7FPmYyftGgHUm?=
 =?us-ascii?Q?8V0MK30U5wcxBn3MpEfFtZl/akF86lKox4Uz6LatiIqnTJo5pcMKMXf5aOQi?=
 =?us-ascii?Q?AMuBSxRvpFcNG3nIbKBtrvzpvnsjYFoagjtm/OwN5vJ99Qc309e4z7N5Nt0q?=
 =?us-ascii?Q?aKmu8gFGZSA09O4w7hcjrd+f3l1ox1auwVbGnNoRMQgr16M5sEgo2pBmCk8G?=
 =?us-ascii?Q?VvbLDPBeHutRRJtTXmaATris0ovLWeHmgMCWlBr8eJocw3y2Qud409UNfkeu?=
 =?us-ascii?Q?Tf82dMLtnK6tqDlzp/q7cZUhyg9ovtahHmyASIBxsYPP8aDPGTlGQYmV4Ejm?=
 =?us-ascii?Q?cLGYo50jthwfNurmbYKp7uC9mKbte0ph0W/R4+QQwPKJwchP+nx3DuA6f9az?=
 =?us-ascii?Q?bSNLSCcwHtuiSSYoI8Np6ySLzUizV9wgOJ/jQpRyCLJ8cXuF0kEdQVdvxA1d?=
 =?us-ascii?Q?0dkOXOydHfJedtcoIKSs2JG5l30DPl7H3Q8LzzRspHdgcCKATUP58FZblG0O?=
 =?us-ascii?Q?ir1DrfQZtfW1+NPvuM8bg8WYSbXEweELx2dqxq/dV0Qxsn8qqC5tL74QuQMC?=
 =?us-ascii?Q?vV6BKm+KVM6rDvTZf4pv7CdroevnCiAPwZRHtkBtLcGAIJI2lkwQ/Rr7xJyh?=
 =?us-ascii?Q?XJXHCy7I3Ho9OYNDtwBUmmC+5aM3Q0vK5YRcs+TFyeKD/0pqSZW6Azp/BdK9?=
 =?us-ascii?Q?V5JfOOhT7QHuD+uiAOJM9pVLAJBiQBL4NBFT9uWQDPhaKsm4EimhjEaz80Hu?=
 =?us-ascii?Q?UEzdX1HFDWCkJ8HO5w14p2zkEJfYor7ECrj4gjdzM3PGkeGZhae6GF8tmU0p?=
 =?us-ascii?Q?7Eg0tzNNeWGUz0sFO7zZYBZy69fbJMh7GIwhq0sNT4YCJ6dbH22R8ZJmaWHC?=
 =?us-ascii?Q?pFYQ4ns38SQuzdpWkG3myZBoxhOQ0WV9vT65Ehu2GcSiWS3+t6EtvErlEp9w?=
 =?us-ascii?Q?lposAz0HlgP2oXac9wrP4ac860qxy1yzJGH6gmvMG3q9HXDFsh5R5L/LbdIE?=
 =?us-ascii?Q?ewoSvkc9SxmRmAfc/66DKSCmWOL272Yj4wMkN5tqkDHWoqmny18Q1oePqvJv?=
 =?us-ascii?Q?BUUQmrJErg9570uttoTU/m+NNRY6krS3iyFo93NpGkQkOQbyKTgNcSz3RLDh?=
 =?us-ascii?Q?ZKnPXF3ImeaCCnT7NC2GZd0shhYCsEURQ607eGa5LpsiPGAXK0snHsLd9Jss?=
 =?us-ascii?Q?LCa7JPjrmisAG5sTfPadjHzklGrP+P21DvgSvR7f01+HJbrv297FG98kcm9+?=
 =?us-ascii?Q?PNq0nox1N6JOf52118tbRI2uutMnRs4/Q2OhOD2bQiFGN70Ro+fAH+shRh7D?=
 =?us-ascii?Q?25Uzw3i3UY7Cj+Hgr5IW+UPkaYhgfDG3fgUrsneGozXL1Y7+eQDf+jLpcxn3?=
 =?us-ascii?Q?uWbNJhCC7mlOgpCebpTRVjthbKd6qyWrw4IQhNG3B66L42yn223nXBYiUW2h?=
 =?us-ascii?Q?0Ln4DxxeGT9NofjLhNXh0lw3G6HIB66jyZlQPqqZdLeGz4tVBVFsVKskn2Pl?=
 =?us-ascii?Q?TgdfdB3C+QiuwE6uBF3MLWih0sdAfQaB02Lx1kGwHT1B6smFEEczAHptnCjZ?=
 =?us-ascii?Q?ZOrQlcr2RPQ8Jr4lo1wQeBTdAsC0s+8bQJvQQzLWLHIDRRuoE9Po+AnkDrpc?=
 =?us-ascii?Q?YHI5nAjacpcKAOYY6E3W2c3JWoliirux+Mk19AfuuQcob2yP6bTooT7p20hz?=
 =?us-ascii?Q?dKGA81Y7zRrlUB8fHZdoa5SivxPB/ug=3D?=
X-Exchange-RoutingPolicyChecked:
	JI1cb+ercsr7ERjWikGqMCyLAiBu9saUrP1sh2Fx8Z4WBtyN0cya1WvD0nfcebhJuQyMAuFLMrSd1sNDNhm9FhChs55uB99PAbSjfdQ5RAmdfwnjpaSmM2FqcJRyssmy17g7tQ31YjduLjg69jUMfPnyF3g2MBa6Z5Y1vAOo1bQsMo3xZeEBcCg48c8zUDsBz4rDcKiP+CH5cVYMVvtqD3I68yr6Xopmo6PGIHmB+ukCn0e7Na06jqYslD8QuZxapxkinjYqwYRqnk1HjuRcSlAOHBOFYfKFFXkrud7wWRh6HghxVBxI9aC7WfSpbT/1W/TiUG51M/OIUl0sYTPRkQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D3sOu3Pr1Sw/tHcP+MSHGoR/8VUbtAvU5Jtr/pRROXpL0lrGmNW5ObKY8g4T6z+/y2hTugK0ktVbLF1Fys5CSGVqIfX9ead7OnlnFSgUTdEu0Ks84pidQasDCVjzKCnn+Vcd4msed/0S5y9aWO1qD1xvXQzKf0EuPRr9PfZTIJqA+wlNO8gPvqSLIOG0w2+LpzNGExDw2nNpJLiXWws5mBROSYrRksGT+PxnGwJBsqY9U38Sq6Jxxbwd6Oyxt//43yKUkJmrhb0mbgNIK/FwYGs3CJCveJeLxcgqPV35NDQwQLxlW6wk59/uLGmLZAVkkpc+7M6/yNVi0WuC6RRKMHt1VWF7XwnFsyPmDWXIqdGuZB9Ruc2tswKUKQaETrhXjCfBBFnYj9beF293cEsP7sxMD2vssJawW8VPEA5JEP31MEPbS8RVlTpAPoCvJA6mzHDDRw92ywxcKMwr7+y03cd1pNfCRv9kME4S5e9yR93gkyFIdhrXgj6e3dk2j3skwWQfRQ4lQDap8R3+3c9+nqvtU0w/mEVxwf6JgDDgi3IfI+fMvTHHNUFc5w4OZnVqIkSgEiILySRwxmtGM5QWYebwh82M5llVQnlBZmSahxM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b903be-e37d-4952-1b5b-08ded8ee2a91
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:56.3236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ygv1MBquP/2DW/ZinxGGl+maYOOww7kSmaE6VJn2471tGo/I0ZaxfyixVxbNBU2i5z1ufsf7vSfc7FCB3sE6gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX0lHXfEVNB8vL
 mW7SB5pgKZEX965GN4YG7JW3uSRouNcoqaG5GoBV4n5bz35p30OCEY3rqq/5lM+ly8OcloxC2gs
 h/kAGduHC7P3FSjjqj6HqHXEur6tEWHJ53dng+QG7FnA+dGG3Y3l
X-Proofpoint-GUID: 7_m5YZPxEk5QF4MwSC9hl6SPtQ_Upu05
X-Authority-Analysis: v=2.4 cv=OKwXGyaB c=1 sm=1 tr=0 ts=6a478f68 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=P5-iQNAxxyhjf2IfsgoA:9
X-Proofpoint-ORIG-GUID: 7_m5YZPxEk5QF4MwSC9hl6SPtQ_Upu05
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX0N0cCWmCUI26
 L+r/8CVTRcNayVOpYb3WWfxZlQ/Gq1vaXbxFwB+Vhw0UqFhNW7Z1YRXEXia7XbjKKZ2ObCwLzJ4
 UVYHthvxPvE1kQDbJLyYTmxQQYys6N7Po0WmpjdTjMP8a2PU99DKRB80qMXnIXnb5BJ6qMW1Tsr
 ulFKzysQBz0yDQcVT2zRGSTkO/KhoIT0vAWdL7T42kxG1FpIum0zd2bT58AqGbU9C9H8LxaNTAb
 zD7u+f5igaBy/GP4hme3pJBtkzdjPvYme7m/ZirRGttw+FOMnTDALGHUGAeorWEHFLa/peEg9hr
 cYNDr9rjWK2MFqg+HnMJMsrPohvEtvdZN/9X6tC4EPPeujzL1V33dxh29QRru76lSYgCvBX53qS
 KkF/VQfJX/O+CpJRnVSdMu2E+sCDIzO4S2suVbne5j2Xk2TSZ9fFjWgs9XKE+pF6ZHvDHNoIQSB
 w1oFyVCXrD3Y5C+30Eg==

Add support to create a cdev multipath device. The functionality is much
the same as NVMe, where the cdev is created when a mpath device is set
live.

The driver must provide a mpath_head_template.cdev_ioctl callback to
actually handle the ioctl.

Structure mpath_generic_chr_fops would be used for setting the cdev fops in
the mpath_head_template.add_cdev callback.

NVMe cdev ioctl handler has special handling for NVMe controller commands.
In this case, the SRCU read lock is dropped before executing the ioctl.
For reference, see nvme_ns_head_ctrl_ioctl(). This makes having the SRCU
lock when calling not always possible. To handle this scenario, add template
callbacks .ioctl_begin and .ioctl_finish to be called around the before and
after the ioctl callback - if the .ioctl_begin returns data then we know
to drop the SRCU lock before calling the ioctl callback, and then later
call .ioctl_finish callback with that same data. For NVMe using
libmultipath, we would take a reference to the controller structure and
pass a pointer to the controller structure back in .ioctl_begin callback
and use that same data in the .ioctl_finish callback to put the reference
to the controller.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  19 ++++++
 lib/multipath.c           | 138 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 157 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 8e4b3fc197637..044061de3ecb9 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -4,8 +4,11 @@
 
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/cdev.h>
 #include <linux/srcu.h>
+#include <linux/io_uring/cmd.h>
 
+extern const struct file_operations mpath_chr_fops;
 extern const struct block_device_operations mpath_ops;
 
 enum mpath_iopolicy_e {
@@ -35,14 +38,27 @@ struct mpath_device {
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *);
 	void (*remove_head)(struct mpath_head *);
+	int (*add_cdev)(struct mpath_head *);
+	void (*del_cdev)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
+	void (*ioctl_begin)(struct mpath_device *, unsigned int cmd, void **);
+	void (*ioctl_finish)(void *opaque);
+	long (*cdev_ioctl)(struct mpath_device *, unsigned int cmd,
+				unsigned long arg, bool open_for_write);
+	int (*chr_uring_cmd)(struct mpath_device *,
+				struct io_uring_cmd *ioucmd,
+				unsigned int issue_flags);
+	int (*chr_uring_cmd_iopoll)(struct io_uring_cmd *ioucmd,
+				 struct io_comp_batch *iob,
+				 unsigned int poll_flags);
 	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
 #define MPATH_HEAD_QUEUE_IF_NO_PATH		1
+#define MPATH_HEAD_CDEV_LIVE			2
 
 struct mpath_head {
 	struct srcu_struct	srcu;
@@ -64,6 +80,9 @@ struct mpath_head {
 	unsigned int		delayed_removal_secs;
 	struct module		*drv_module;
 
+	struct cdev		cdev;
+	struct device		cdev_device;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
diff --git a/lib/multipath.c b/lib/multipath.c
index 78f88b0664c78..6d2e1186a10f8 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -499,6 +499,131 @@ const struct block_device_operations mpath_ops = {
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
+static int mpath_chr_open(struct inode *inode, struct file *file)
+{
+	struct cdev *cdev = file_inode(file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+
+	return mpath_get_head(mpath_head);
+}
+
+static int mpath_chr_release(struct inode *inode, struct file *file)
+{
+	struct cdev *cdev = file_inode(file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+
+	mpath_put_head(mpath_head);
+	return 0;
+}
+
+static long mpath_chr_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	struct cdev *cdev = file_inode(file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err = -EWOULDBLOCK;
+	void *unlocked_ioctl_data = NULL;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device)
+		goto out_unlock;
+	if (mpath_head->mpdt->ioctl_begin)
+		mpath_head->mpdt->ioctl_begin(mpath_device, cmd,
+					&unlocked_ioctl_data);
+	if (unlocked_ioctl_data)
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	err = mpath_head->mpdt->cdev_ioctl(mpath_device, cmd, arg,
+					file->f_mode & FMODE_WRITE);
+	if (unlocked_ioctl_data) {
+		mpath_head->mpdt->ioctl_finish(unlocked_ioctl_data);
+		return err;
+	}
+
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
+static int mpath_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+	struct mpath_device *mpath_device;
+	/* error code copied from nvme_ns_head_chr_uring_cmd */
+	int srcu_idx, ret = -EINVAL;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (!mpath_device)
+		goto out_unlock;
+
+	if (!mpath_head->mpdt->chr_uring_cmd) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	ret = mpath_head->mpdt->chr_uring_cmd(mpath_device, ioucmd,
+			issue_flags);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return ret;
+}
+
+static int mpath_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+				 struct io_comp_batch *iob,
+				 unsigned int poll_flags)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+
+	if (!mpath_head->mpdt->chr_uring_cmd_iopoll)
+		return -EOPNOTSUPP;
+
+	return mpath_head->mpdt->chr_uring_cmd_iopoll(ioucmd, iob, poll_flags);
+}
+
+const struct file_operations mpath_chr_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mpath_chr_open,
+	.release	= mpath_chr_release,
+	.unlocked_ioctl	= mpath_chr_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+	.uring_cmd	= mpath_chr_uring_cmd,
+	.uring_cmd_iopoll = mpath_chr_uring_cmd_iopoll,
+};
+EXPORT_SYMBOL_GPL(mpath_chr_fops);
+
+static void mpath_head_add_cdev(struct mpath_head *mpath_head)
+{
+	if (!mpath_head->mpdt->add_cdev)
+		return;
+
+	if (mpath_head->mpdt->add_cdev(mpath_head)) {
+		dev_err(disk_to_dev(mpath_head->disk),
+			"Unable to create the cdev\n");
+		return;
+	}
+	set_bit(MPATH_HEAD_CDEV_LIVE, &mpath_head->flags);
+}
+
+static void mpath_head_del_cdev(struct mpath_head *mpath_head)
+{
+	if (!mpath_head->mpdt->del_cdev)
+		return;
+
+	if (test_and_clear_bit(MPATH_HEAD_CDEV_LIVE, &mpath_head->flags))
+		mpath_head->mpdt->del_cdev(mpath_head);
+}
+
 static void multipath_partition_scan_work(struct work_struct *work)
 {
 	struct mpath_head *mpath_head =
@@ -574,6 +699,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
 		 */
 		mpath_schedule_requeue_work(mpath_head);
 
+		mpath_head_del_cdev(mpath_head);
 		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
@@ -600,6 +726,16 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	    !mpath_head->iopolicy)
 		return -EINVAL;
 
+	/* limited sanity checks on the template */
+	if (!mpath_head->mpdt->ioctl_begin ^ !mpath_head->mpdt->ioctl_finish)
+		return -EINVAL;
+
+	if (!mpath_head->mpdt->add_cdev ^ !mpath_head->mpdt->del_cdev)
+		return -EINVAL;
+
+	if (!mpath_head->mpdt->add_cdev ^ !mpath_head->mpdt->cdev_ioctl)
+		return -EINVAL;
+
 	mpath_head->disk = blk_alloc_disk(lim, numa_node);
 	if (IS_ERR(mpath_head->disk))
 		return PTR_ERR(mpath_head->disk);
@@ -632,6 +768,8 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
 			return;
 		}
+
+		mpath_head_add_cdev(mpath_head);
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
 
-- 
2.43.7

