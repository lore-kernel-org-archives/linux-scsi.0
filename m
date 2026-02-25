Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3C140F8CF;
	Wed, 25 Feb 2026 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034076; cv=fail; b=QQTQm13xmuFFz57PONfC8p6MZG44c3mWqAhgw5YOwgM4uyrmyn1IFCN5lC6nKqszJD4OWYK9QA3HhK4FAmHK3BqwIHNl1cUJdZr1CwwuBmaCV4CzehVh+K4CKxTNHZbNUNsmMTm61BM72JVP4OrJ6gBvBQD5qjGfv7JYU4LE4/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034076; c=relaxed/simple;
	bh=d7uGeUB70faBnn9DRH5v5fVJshEEM7u8oyWuaOMi98o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aXxdC8Y9ZkXTk4CGVdBIiwN6dh+Lsy84Q9TbNjbvRTxxo/r8E6yR9IEIUlAh2ppWkVDu3CkgYIXeDBjPVefj6Ls54kJmh4/KBD9EzMDrkB77lUSTqhRO+zCu3ZG/7J2BFtexX3dCP+GkbCdkc22leBJmbJaJuCKglSfIj59CDDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f1lOlq+h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bhNUHe2E; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f1lOlq+h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bhNUHe2E"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P4BV6V1461731;
	Wed, 25 Feb 2026 15:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6bIKVm/aBSjQkfbMcSVcnsDhnFv9T2oeDFbzLnNTSwA=; b=
	f1lOlq+hzQqXtLb7bnvvUaHqnfgzWYHsSvlqnd5E1OKmHer2bl+0W1NJ5sDBEPNJ
	HX/VZqRxXS1C2rpl56ig3jpdsfr0oGjW9R2+ln9F3u4jUk4Sj5jnGZb8foNAOs+I
	YcavRs5jTyZOdSL9A5gmb1BiGCN/wQpYQuDJEypL1amzibGTq3/nNwjtRI3DkF1c
	1NFzFI+HN98hGLJTx2pnhHUJPG1jeVvPo1NajX/cfJxSOJtusYA9O0a9cbIziY7W
	mPjVvL75loDOI6IcWFsSNUqcSZEl4ftEwVWhq7xILZ/SlAPMrCZnzKW7gsBXhZ7v
	QqjpXMyMHThZDWqnpQAxPg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3pggj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFTrjG012679;
	Wed, 25 Feb 2026 15:40:56 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012067.outbound.protection.outlook.com [52.101.43.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fg569-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vcKywmLK7qR1l4aA1AftZ4EM2n59PnLwfShJipiMD5Em88OXkkvIGcr9GzCmsb9XYN7FwewZQqPMMtjPeCNyZVpRkZhHW9q7jXXKl/Q+EGwQMzHIqg6GzbI/yzaHfnzvu6lhc9y2dxxCTSAQ6LkOL/snYWi8soMrtRYRdV6w5BsGzpaUHQ9wh3d5JWlJAcgAfsb6XJDwEw7sG43ozZb0uWbQNO30fYCHvT57kkVqJyyV2Y9F3+iQdmkNSzkR89Ax98nZvIN/FJ45G0Jo0PQ4qfT2VAYxgT46lg3aatL4+RcMbwCIFi2kTeMo5E6+pKt0tlTyYle5JlAAmO2AWN/zUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bIKVm/aBSjQkfbMcSVcnsDhnFv9T2oeDFbzLnNTSwA=;
 b=xTqAEZO4t0Ix+CNYQWF+ciYsJSt7SohkOGCmtJUcLpW5jzghfaheb59xrLgFdOH9cRKFGtvjt4BAXbDK37uKER1p6OLd+6RtvX+7wQCeDuBqfr+JdIcSnr4Sz9UUo1Un738KX3poKC8AJY4+OXL7/66TsLfaFiUu2dtW6xjtKWbF7pvVCSjxpcAK0TgmKWfLsQMQAzW2aoIiv1e1+Cu2MBUkyrl6ac8RnDLNIn5VRVIDsPdlZYTwxcnOa2NQN4lqmGDk11Pkjp8n8Y8Y8wr6mnLgbHsgKVq7kWHIC5blmwp2KB6RjQsaBzpUo9dGcWyiGkLzu7BJl0FsuWCPt+l9zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bIKVm/aBSjQkfbMcSVcnsDhnFv9T2oeDFbzLnNTSwA=;
 b=bhNUHe2ExXQyUDEO+dvzcvqCG+k67OY4CDv36Tzo0qmsjX887bEJxRSwJ+OinhFdPh4h8jT5ihK8+9DLFtOU7Vxg+P7GZRqFjNeUlAYkeIek6dSVEUiGGEkSRC400as3zljiwE2SydOwD6nV6rvnD6+65HNaTO2Vr3Aj6puS2HQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:51 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 15/19] nvme-multipath: add nvme_mpath_synchronize()
Date: Wed, 25 Feb 2026 15:40:03 +0000
Message-ID: <20260225154007.1033735-16-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0209.namprd13.prod.outlook.com
 (2603:10b6:208:2be::34) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 10cc94da-417a-4abe-15c3-08de7484410d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	UZMLGmA53FRQT8t7RokHRWvqfmpGlKCsZJJi8C4hLrg32CCOdH4YrFAcKlH0KneF/6Odz4fn8OXxYZsxz/1x8TPz7M/xbQFJhyRZyy6+a4x+8umMDBjQq4n5DCjj2TKHzlGgsYkRC8PNw5+c9sM0sVlnLJQP0zTSXhsPfYQlqOoWHBb3wWczfYMmmgUamkljWO30KxDvzmveCUa6wLDNUI+GWmNeQMKYM1ksmn52ZRalYHMjwBxx8CeTzoOGGDtiEkEmEyyr4toSrsXDKo8zhxY3YBcIXMw6qJQYHXgQ/JjxWlQyujp2Gjo5c9ZTL5Xy94nz2eJeB+TCicXDVqvqyA6vmMl9uGj0VVZc6h8rqDG4bMoVVq2O7OJhumTa5JuciWzQ78SsEYmO2vTSIWAm2YR/OK8/mDn0KcBw7vxTVDH+i1TWZzewCG1re1R9Zi6zhn1CTHloBr+aIJzHya+WjWlFIvhdvFUZkgUTXyjGTmnEZyLc6RTSnVLatQR+1CIrYIeRDT3IWINjT+hs2IPqoz+Gz0dvIlBadJacdp4s4IXtVK8I8RLEVp5vJ3PQ0hQ1ECepppPlqUAqf/fox9DYpXbgY48XT7Svla9WHx05YZ67r8yqzEd+fkFAg/Oua3g88rQM5CZeMzEV/NkYv2KNPJTOoCdtevVAsVyyRg5RsVZ5/sPaY/i8d4ZDSfHV7K9uiwDJgP0e9bPavldDnDsfc0MoEFqHRu0bDVRygrKoSo4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?57YwaoIBiJkjOCB/bgHo0ftDidllx89d5XHkW3AVtKRw5EBALvAGb4C50u8L?=
 =?us-ascii?Q?BjiEdZSGhpb+Wpd6aPgzfNyInjYRI7ckEy6OH9VJ5RdOF274JSaATwG9zAhW?=
 =?us-ascii?Q?8yxOvIDrI43tR1JFEgRwab+cE1Q0dehqrjaPqtuOhWr+5BySRkUfATf/CyaI?=
 =?us-ascii?Q?NKFs48gyRPQcf0oAX15ahh7fGx68myTIxkozCQsHJrEngv8j2N2V7urJ2Ckw?=
 =?us-ascii?Q?l/KvSkKs9yeojNMz/2Wla9mvysxhiePHMQ2aaFRBsUZWXg7+RqqHCnUDPBda?=
 =?us-ascii?Q?CUvqkdX9pGrOUC0yUL7Ev7lAqOWlUlogUfT33NbW6Qmw2CQ1m+afjPHbNLsE?=
 =?us-ascii?Q?hbb6Yff6lvXJ5MLX9rzr+KzhcwGL/bDpDFe83WRBuazAJw01L1Qs/VoYDIqT?=
 =?us-ascii?Q?CCN2XM4+WF8kEsdXLNwm7JVTa6q1w9ft971zxcv9qfTdT5vvc9PnTbFkkCvf?=
 =?us-ascii?Q?43+YlU+IGjBlaZYZOoR+Zod6zskboJwaZddEP3jLfwRB58XYJtOmjhPakQVd?=
 =?us-ascii?Q?SWRvkl8RjtEX9MXd1JV2DO9Em7Sc5sTPUN06U0+BNuMOrkRUvmFVEJOrwaTv?=
 =?us-ascii?Q?MK99PPBVbNolXTYG/IN4E7jyj5k1KO+fApN6jqbBV2k+S1TWy020OGKHRDVr?=
 =?us-ascii?Q?EkLfzcbiEr6FieZhjCiLBhXfyMEVWPDgT8Vs+HIO0FzfJ4Oq3lv4Eaj/DZsr?=
 =?us-ascii?Q?4Inzz8bWrhXM4c6jRGDhC59W5J/H0x6MKNkO7gTRKB3QjJuU9xkc9cTPOiaH?=
 =?us-ascii?Q?l97G1LCZ0MuWxLcyNLCrFlE41V6QhRdumhgxKQsQs8bz+gsLe1Zhd+dFDrl1?=
 =?us-ascii?Q?VxLrT9EzV2yaZMOhYvxPaDSr0GndPfugzLBhPOX3DhT9w3roErv77lDlyV0a?=
 =?us-ascii?Q?26bsQzqPVhk50vWjTtUobT+AlVFGucBa72hD3YbthN8o2KVAUW41qKcHRG92?=
 =?us-ascii?Q?i+LAJ/YKbb1DxEfLwz6TVMMtIgIO55MI0mgReDPnaqRd9yTYF/sFM6xnSJ96?=
 =?us-ascii?Q?Wq3v8YoTPGz688gwRh3Y3zZMgBqt0AZVGUbQ1jojQ4xPtSe7Z6d3SL6gniBB?=
 =?us-ascii?Q?dSrrGcTO7ZX4OamDU3TpKyrdEAhVtwtqFFLLv1NBmwGScHy+IT2p3osMSBNK?=
 =?us-ascii?Q?11g1GRChPNHB4CXL0OL9hKWMXoBXKG8lrI4i+t4ZPmUwtmK1RisDadzoHCCL?=
 =?us-ascii?Q?3F10XwIyO3PA+AXIUF3RqaeYXMpZ2vw0FBQKuCJvMUrUJHTCeJePaRKDIbSf?=
 =?us-ascii?Q?nT96t+A0hepO8FUcfLQSbL16Cfr0rpFwZhwF3jFAduh4n+EcidQtp0z0WSBd?=
 =?us-ascii?Q?vuzcbcU/ijZ8uWAMupOMASqciw7GNNMeFj2BfKzCCBDFjYkmS8pV/u6hYWl6?=
 =?us-ascii?Q?NazZngHQqe7FnqhwFCrWy4GVdDsXKl6RxZEH3fDqxVjmYxUs0qtibso8ArM2?=
 =?us-ascii?Q?dyjwy5ubdTaMQtFclpNamL730IOsVpODYSpIGhMLmacxEliP/WpFnpzn+qFi?=
 =?us-ascii?Q?hKf7L+pl5EM09caR0TPnPVT2zyWU594VQCZy/di6GIueoIhf/hn7LShhmuv7?=
 =?us-ascii?Q?yPYPCFxKlsSYstTmIX884Kck51DE207M+MoGHz+W0PmA8puP8xXJl5NjOXDZ?=
 =?us-ascii?Q?kDiUSL+8w+WIWNNXmXjhXqy30e8Ycla0F82AI8tcX/5WUI5koplovAMG8WNc?=
 =?us-ascii?Q?MntQ3/I64bo8VMX7fYw+MVw3kBemd8nDpEHtJkaUL6NK9x4t2H0uNgRyXz4F?=
 =?us-ascii?Q?9y91jOWjRgtLjYqb/+z9enP0ab3p/Pw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J04aVlDEwDlZeYWYbMYKBkfIb5kOZOV7l4/JFbI8pIZvWp/WEw1zqpBx+C+ilQMoa3UJvTpLUyBPXdZ/I4R6l1KwXJ64EPxWOpdmGuY6MvTuolf3vE1DPPujFhMOLkpz5MYd8XEW+R7egb7NAdIDjb+fxPAetlbTOMJ07Yw95BXzeB9z8VnRx5F87UhefPn38lTGuMfkwBWZPnA/0aV5sg9sAuxW/V8AHLR48H6C7hpPnSr5o8xLbof9BMe4RY6J2vHjOTXA2Uc4C5wlBH5wLEAsEp93G1Zk72X+/5RIJ8Olw6gxG1keN8RGON98VwHQ5WY+PMj2kCLZd8ShSlQKsNzqRa/OUfYskyyAIVjxK6j9IwM5aG0ToJE4L6d8hLAYTz81C/Xkx1N7EEovHrv3rNZkosBcZ6V/35fOEFyVI7fJd3N/JaclxUIJTVsczMgynU9JmSmFzAcT3etctbW7r+HyItewpgIWFSvAP8Otu2aLdIfPajTlO4t1IU21scz/aSRUP2+61qckk1u+ws6OH2bwMCCWreWv2vceUB5yTIhgXq2gGzoenoEdeYhYb+8g8AjjHJJRnLU/Rh2LLW09rFwl8vDKxjdNdyuddcB72cE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10cc94da-417a-4abe-15c3-08de7484410d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:51.0336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHLb1CSkPwJ22THXyZu7Ly99/kIcuS/MSDOf9ulz/u4I4M54y49PGpK4ZKZ9PfyXAWKN/Y9yykClS0gmhIJT7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699f1808 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=Q3elSUN60mUFY1dhJLwA:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: UcZnDhh3nTLhmw86GztUvfn1qaLNzMgA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXwJHK/1H0vMY2
 I5etnSsXl/nFKSRdeQ6kpcni0DJW2XhBvSe2uxI42yVk8w9v5tLsNZm+IfjYqksJ0fU8GNZI1mQ
 QUV50+qqsXRsMU1JV0QOYtMAzBmsWfNnzs73mC7pECBNkHDcZDxTexSF5mbv7kJEEu0PcYTuD1N
 0acocEeCFrgfrCY+XFhoSxqqUWuniYKN+eGM3CJPzG7C8WywDA3mv/EzbY4fTrNHF6sdSc7pepj
 8XewiL55fsawgEiuxr5/ADznoIBx2Lv3QhwCfqPyLErtw27GxDYWF8ycEFPCD7o1ginXi2Citqy
 QSPcd45WrtVm4mALHL8RvCe1nGBlO06oU9SPhkBwhfbcntACIkGM09NRR2wh8L3hij/+O+W7IUB
 9NLk8tefLdhineUgpIpq5+oAiXyF1TbrtdkzkGa6cC8QPRiC13dKqBGyAGzXqmi+ylT3Xzcj86C
 ZMLoBpBNp1EKZn/T3MYlGsMANktc/mqiFNHnl/us=
X-Proofpoint-GUID: UcZnDhh3nTLhmw86GztUvfn1qaLNzMgA

Add a wrapper which calls into mpath_synchronize.

The mpath_disk is added as we can be called from paths when the mpath_head
has not been allocated.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 10 ++++++++++
 drivers/nvme/host/nvme.h      |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 15fba20cded67..7ee0ad7bdfa26 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -972,6 +972,16 @@ static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 	}
 }
 
+void nvme_mpath_synchronize(struct nvme_ns_head *head)
+{
+	struct mpath_disk *mpath_disk = head->mpath_disk;
+
+	if (!mpath_disk)
+		return;
+
+	mpath_synchronize(mpath_disk->mpath_head);
+}
+
 static int nvme_update_ana_state(struct nvme_ctrl *ctrl,
 		struct nvme_ana_group_desc *desc, void *data)
 {
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 619d2fff969e3..d642b0eddf010 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1027,6 +1027,7 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 	return ctrl->ana_log_buf != NULL;
 }
 
+void nvme_mpath_synchronize(struct nvme_ns_head *head);
 void nvme_mpath_unfreeze(struct nvme_subsystem *subsys);
 void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
 void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
@@ -1095,6 +1096,9 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 {
 	return false;
 }
+static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
+{
+}
 static inline void nvme_failover_req(struct request *req)
 {
 }
-- 
2.43.5

