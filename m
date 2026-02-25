Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EDD3D9052;
	Wed, 25 Feb 2026 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033853; cv=fail; b=pSmwSYyjiCtZzXBcojFrpJh07Jq7TlGWmccEd2urMTTw/F0VSar4KGayoH3GcQoKoDcwvlTO86XCOUPCCZf3RgiSgc3lDfk2aWWF2uz8XFezoz0z5chxtys6eBjLanYBAuc7uN1KtwHWxiYnGUh+Rrb8YMgK2t+GVGH6i9LmxaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033853; c=relaxed/simple;
	bh=zsnstZC2fWFFBerB23BHIoQIk5Dii+4yDul5kv0tJys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KXrrE6/QMX/67GFCZaBLcRDTUW+g52HLQ5/3zbFDIDuIhtPP3Iiitjr2tQSEl4BU/+Gir2bhg4zr04WQ3+hmfmNfy1NGdibg0VDz9zxz/Y6xdO9CEGvs/B8v3UzaWkjitedxeXAF4bwP68f8KSl6cwrPEpC8uytrOjCYYmJETdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VUATOFBH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yqU+y3y+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VUATOFBH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yqU+y3y+"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PASJN8817877;
	Wed, 25 Feb 2026 15:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hXVI/lhrlza4KLxbg2PZzwOU8V1932GRAQrVFEctQXY=; b=
	VUATOFBHArY5rXo18whq4NGgfcS1y/xjS0NrV3XFSIbLAXDlB5yeV7apwZpLsVMn
	0qlFG7cPdxeeTi7hx354l0G8iFL6SML+H7LXHJ879ASqRvsS+31SAKcMSzeBqLTR
	2BFiFEp8uinfbQtUA3tcvxOm5Z2jRmhbk7UGK5qNOO/oTMKCSvJl/UYdFQwycgwq
	S5vEJB/Kxbjg5BY9ywTSoqeeCGJHYuV8mczRtTAjc+I8ipno7XdaGT7bWyVuHHA6
	SJx5PvYGJl2gGM3k4UGlp1YDHa+h8EcBh4pFu183IwGvqk5QRnWZILpKtcZY1El5
	v0Hv6Eus3Dty4/Vqk0HzEA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areemv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE7QHV006382;
	Wed, 25 Feb 2026 15:37:10 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg9h7-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJoVjVWScnqiK+Gi9hl1uxbs2RJNBN06ai5bKvzZkEKW74yDCHH3mY3khQ9aof03Pz4K5PNo3SEdYASrBxrgEj5THhe2iVHCRIgcPsaCMxU7dg37USjUPlJfPITaxrnb9D8KDzTqxp8dLexLTVHuwYQHfMyxWoaXUqFccY11Mk3OERp6r5d6Ci/fL6W5ljh7WtAyeoP5BnPLoQiGi61NJG5c7hCiYFXST0Y5ZRXlGptDexiZuPp/CVM8oSUtKi1RHwkC/ocO59ZHViX/AA0p+YlGrpxrEZC623CMASQX/zSwm0RqhOUGMcqyvk/Ns6yu6oZe+wfeNTUfA4DNRcs9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXVI/lhrlza4KLxbg2PZzwOU8V1932GRAQrVFEctQXY=;
 b=gVqyhYETNZqQW+9WJsoFdmcysiqav0BvN5sQtpsBXwfpYQh6wUVxz1W9ZkqazpPlC+g0XSbJFvikUG6m/Jta3ZMxStn9GSBLNQpsi+ZNtplYZLu5L3Yj3kbO2CrHpjr2ExFlsFcHfqx1m/8hZs+nd4DC9pQXp0/NQyuLZb9SpZdXt9g+BpwGYHQPmMOnJsDtnMK7TwlOQWP/cG45rZyPcFF38B+QTLR6do1jUy5wiJ64LzvKy7+S8tE3fHXX0dbfVFwg+PJ04h0bKByx5s4qxb2D8Te+IoD0uvlmQAINfWnz+M5yAOyjsEKZLhtrbVMWrGPLpddRDJzs9PstquSz/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXVI/lhrlza4KLxbg2PZzwOU8V1932GRAQrVFEctQXY=;
 b=yqU+y3y+7LPewYWZ1afG+VWe1af82000wG3cdgt3SI3ch1Fo7c+e2eEuTUKJ2c/VU3/SDhe/h4oI/oZgPQJU3sBbuYu/9rPx1JsgH0ZGk3JjNUTsAF3lsj29i13mA7kSahjvLopsWy25MBmiz1UuwEMJemLI6k0FtGvW9igL5Pg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4626.namprd10.prod.outlook.com
 (2603:10b6:303:9f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:37:01 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 09/24] scsi-multipath: failover handling
Date: Wed, 25 Feb 2026 15:36:12 +0000
Message-ID: <20260225153627.1032500-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0061.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:349::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: d4da3c09-39d1-4adc-cf5e-08de7483b809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	wU/AiWBHEObB41L2GRbpMglBsF+qDvO4ZX4k+k1Z38g66t8JJTEPEd93NSAwWLliDBzGpvAILlx5HmsikDDorFB8OnjHojpAJXY4wuOih7YALqwGDwZfPQGtaBIe8+ce/737xM9v08oCvQxDqa6dmh6+wuQ9di8PmCDpJXQuUJ8CCHGqvusQDR6Rbe7AeHZ3Jwnj8CMfmQOIdObEDKj2rd93GC7X03JFxqou18SjJqLs+PRM6AHkhJONhVVhJL7X/fvxeJ3Qs+jRqrx072mYxjb7H22o+scv9giDOUiWyoMLE9VvulOwlQv2I8nTqLX/r2gQdMMsieXJ0KxJM29+duN7BAzUaXTjS5YMigSln9fbZwndLSS+vsqnnOQt3CjDJPf5hzoMFmXa1WsijgarSt7gGYoOViyg9y6A0+qyA0ajmBWgyz78S31VvbAEmA+HwX87NOCE3yE8EFRSoPjd0Vrxn4qYYUZvO3Ixwc6DY8eC7/83fdflS8ryBgZddUBTjGAfIOQdwQrw+V0tGMOqBHNJn7f75KTf6jyLekEzqdBLYjDzvkIVqN9KuecvD23sITbV1Ejg0675y+xQ87pNg6x90k8gR7yigGewtiXtv3/yQe8d1GJ6+30mCbHgmdpu7FKIKU0mRxVT1LyTeu0jyWVFAZ9aBgEQMLz2Y3W9cZ+qBU0jk7QnCkvzbRLvbc6N1AsG2F2tw8exyS9ZaPC7RiMe+N2Pci/E2n2c8HEbGrc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0OJuqFoOJjOKuiKnI3kHZSo8LCqGBpgP4BiAA7+3Kpqy2oX8BNHOjsko2ZlX?=
 =?us-ascii?Q?M/yJhhaLyj8zy2aqeO1ogsJ4QIiQ3GA7S62WrTGekVtnoozFGuDXheyTtMVu?=
 =?us-ascii?Q?6W5aUzKrbrVHiN5o5s3iasmXQANiuc281kQYyt2lmiYeNgjOckPr+Mr8ws+v?=
 =?us-ascii?Q?mf41kSsXUOcFC8RXWJqTnXWJ1tEDVUjTAZ97r3td5PCwtX4iCtYrV05cIBHF?=
 =?us-ascii?Q?dSQeimMaFKoN9ZVDZoGO8yn+r6QTN/byKq8nqRWyzaoqdUSxuBaJyznMeN1S?=
 =?us-ascii?Q?vLbTegYPENm+WXek5duNYiofTPxGrhEg6hMlleUQe043iy4s+MbYo4iv7jQb?=
 =?us-ascii?Q?HdDzYS80uydtB9g6qx0VjvY4RxQ0pK341WBMq4MMl5ijlLxdto1q9+ntp5MH?=
 =?us-ascii?Q?kb5IalOK8SyXaPA/H5yHURpzg6tA6nPkcdt5ID6hhZ5gFeWi0L9WM+7W9v92?=
 =?us-ascii?Q?CoRCi4xVK9+i9IGbWopDkh0/0Nq/0G3Xt1h8i6O2o8ZEJkfo7lMzHYASCaE4?=
 =?us-ascii?Q?Y+6I4MMfuNmZx4yhkie4qrFbNL+HqrE8iyrxVZIhci5F1apS/IrTocjaQJ2z?=
 =?us-ascii?Q?PhCMDn/FNneRXHeuAg1wi8+UfP0a/RyUNWY6HD3deb7FeDJC19g1td92tirH?=
 =?us-ascii?Q?EfR2ptc0tgXpp3B8Nvg0huf4Rjrp7sgchVpPeLLFAeLGIToAj+65QIgxGH5U?=
 =?us-ascii?Q?9dktSBZo/FYwIsyrfXyh5oZDcvTi4NQvkuYdj8uzowGcqJmLH7RTV87lyICF?=
 =?us-ascii?Q?MZI32KwpN837YTMyd1EkvYZE9FUsFryhDQZYP3X/Hy8BOFGwO+2GqSm64x3Y?=
 =?us-ascii?Q?LxmKFVA8dG3YX2EUogROLvfXl82tUAyJZwdNSQgYo9v6+FkTTMfMyPlEBJjl?=
 =?us-ascii?Q?BMTeJJqV8JfCwLWSo4wzvyMXYYmpB8ntD18GqRN7hI/SkBJxBdULlXKeUqOh?=
 =?us-ascii?Q?MTllKXfDfZFVcnxOhjb5JGMdVtkbTgE+JUoryKDCTsLdzVIb/tDbeh3iWuF7?=
 =?us-ascii?Q?pZfgklHsiCwrfmhBMXJaMIj7orPLW1ln8iK0IMXQtJCblRiQ03ykDMMXB/ko?=
 =?us-ascii?Q?uzTalctHvnAsL8niqhNDPAI0xXdGoS9MroKwp5A+29t7cq+2SWwefvnnyvhv?=
 =?us-ascii?Q?he61+9tU6zZqFJHVenMqaymsTOyvhUPmuDEyl8BpAzgEKAbgJ1pLKGiPFCec?=
 =?us-ascii?Q?Xx5FGP6HAYqXuMM6/LmQo1HU78lQBZJ6b0Vqd+we9SpVtlpngCqfSmTgDDmv?=
 =?us-ascii?Q?oMM1IifmmhSbyN9Sx2wG1LyJTVxTiMxt6OgIogoGwTyq9O4W8sM5gbt4WyqB?=
 =?us-ascii?Q?LrZUpMRs2IoZtG6XI+lwP9Tv6qlTHwCjljJ0JLc2nzK5F0vJw4L1OUUS8JVV?=
 =?us-ascii?Q?kOfnebMIIpFPLfRQ35bjucAuFg7xuuDDoVy5/nsliatYrVl9YQLjXDiKU5zU?=
 =?us-ascii?Q?mI6c8/JIEGIwAiQwuExOxqZCxfKo4LFr/8R1xrTbXkYFtL3Plm68lNAoUlrz?=
 =?us-ascii?Q?7whPZaSxTFnZYZdIJY1GaYUO0w1wENi/R6gRUgJ4vwRKgdobhp8o7JxYVMpY?=
 =?us-ascii?Q?+mQVfKq7Z4ou6waW994gytwX4MC2S4+VOWJMZXPHj2X6zzkdEXjrJtOH5sXl?=
 =?us-ascii?Q?I2PhZqewxmTQ4NQNGUnT9s1IQTJczBoLDFuRbNbJqGaV88H0aY6uL2gBbOLB?=
 =?us-ascii?Q?D+678aGxsG5SoOCAbKtLH+G3uOFW6R+4GzXHWqkT2Hv6jdYxPXMhwDv3w2O7?=
 =?us-ascii?Q?mQWnSmbDpXpGVRcGWvLwrfR9RYN2KTg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9zpYsE3BaNEvSGAlS43J66hrI2GP1FViqyYRlqWQECq8Ev5J1B/JMwnfiBopse42Ww6ZRMcfFI4zq5b4RVV6lwHo78H0IvDTNGxbq6PcE/IOM0jcVXRhXuyT6CO9kzA6R7ADMBjR8vSskU0gGyssf6SUViCsUw5hFALXnJo5sFN2dl4KkmdH6Z30VGHTh4Xn3NYb8XraxHV0VIyKr3ukI4N013EhLEw4OdY/dq8D5a6n+K3AQAk8Kqzunq+pDdgHNWIZSI2bHg6v9nWJl2DebqvlLAytYG0Ylu9rkyAm/r25p7P0a3hiAtb+ddqjeY3rC2hq182Um1UTaqF8nkXsjApNUZgowd0lBhltbEC2F4JZNK/m8CEwdQsbVmmlNUzOVWoD3BXvj7WAvjemVLrVfU+qP3OTDtP/dRQy8xD3zh/CJfQfBgtMCIFGmOKWnMDMSPeZtAkL3RN0qk0xEoODNSOsNG3VQVt+qLxmtAOzqWmpIzhHCryMEJh7IMH9CYtuv3upSDjkxUKBv9J0D8fm+jUzCq82B9JsXb9f4BZ7iHI4KOCzQdpYsJJBMf5nT1WCUOi97XV9EUVYDyOm1lS+BQp7qTBsZcV5YO3kdOXtCMw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4da3c09-39d1-4adc-cf5e-08de7483b809
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:01.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lE2lchiIXowY3W76WQ5UQ2Y41m+C0M9PHIr6jHw1KzEfqgBdLbdc2brNkITzpw9inVTneHEF+EDh1ju0THtNGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4626
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f1727 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=QZGp1NzAbWfVdzUme-oA:9
X-Proofpoint-ORIG-GUID: Wt1ch1icA2X4NWlfKrZxTdduvaZY7Dha
X-Proofpoint-GUID: Wt1ch1icA2X4NWlfKrZxTdduvaZY7Dha
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX/G4ih/sUb0QU
 wVvs/5/+70zZitXIiF0Kq253nWJnLMs7OaCdSTwNqKMOT9Ak0JT6w7JUHa+Eztu0LgBlhA5nBs8
 DRYS9dgmBsY+0L69Wr8yTwhPivuEBQb6jP56xPKgMpiGoSPWvkpssGhF6uMX1DsOAFjWLB26Gc6
 L75KRp3h/ABPmpoP0I7W95wUrPOB5x9dbWGlCjsJLV0jq2f6vETnp1ltCtLGVaRj8+xuU+U0ABh
 WQsHHsZOg3x9cDwEm3b9jDsarkOtaxPlH+CEBKSOx/99f6M5moWFGmXa2kGVJsEITUTEIFfIUdy
 LFYcKAZ9ozNshyJEqSU8lydzhJ2sFY2h+X5Dik/u382WB8SanyRrPCoAksE5DUQjziOCIE8+fBr
 XcrGpq9ZXyq+BHJXo2n+ksDov0zyh7Ludc5GvH1uZ62avY4FWrtE+EzZ3vqbQD8MaU8TLWRUE0/
 IMdmlwrTdECTfKKWlJA==

For a scmd which suffers failover, requeue the master bio of each bio
attached to its request.

A handler is added in the scsi_driver structure to lookup a
mpath_disk from a request. This is needed because the scsi_disk structure
will manage the mpath_disk, and the code core has no method to look this
up from the scsi_scmnd.

Failover occurs when the scsi_cmnd has failed and it is discovered that the
original scsi_device has transport down.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_error.c     | 12 ++++++
 drivers/scsi/scsi_lib.c       |  9 +++-
 drivers/scsi/scsi_multipath.c | 80 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi.h           |  1 +
 include/scsi/scsi_driver.h    |  3 ++
 include/scsi/scsi_multipath.h | 14 ++++++
 6 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f869108fd9693..0fd1b46764c3f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -40,6 +40,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/sg.h>
 
 #include "scsi_priv.h"
@@ -1901,12 +1902,16 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
 	enum scsi_disposition rtn;
+	struct request *req = scsi_cmd_to_rq(scmd);
 
 	/*
 	 * if the device is offline, then we clearly just pass the result back
 	 * up to the top level.
 	 */
 	if (!scsi_device_online(scmd->device)) {
+		if (scsi_is_mpath_request(req))
+			return scsi_mpath_failover_disposition(scmd);
+
 		SCSI_LOG_ERROR_RECOVERY(5, scmd_printk(KERN_INFO, scmd,
 			"%s: device offline - report as SUCCESS\n", __func__));
 		return SUCCESS;
@@ -2070,6 +2075,13 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 
 maybe_retry:
 
+	/*
+	 * For SCSI Multipath check if there are path errors to
+	 * trigger failover to available path
+	 */
+	if (scsi_is_mpath_request(req))
+		return scsi_mpath_failover_disposition(scmd);
+
 	/* we requeue for retry because the error was retryable, and
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ab224cd61f3ae..7ed0defc8161e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1550,7 +1550,7 @@ static void scsi_complete(struct request *rq)
 		atomic_inc(&cmd->device->ioerr_cnt);
 
 	disposition = scsi_decide_disposition(cmd);
-	if (disposition != SUCCESS && scsi_cmd_runtime_exceeced(cmd))
+	if (disposition != SUCCESS && disposition != FAILOVER && scsi_cmd_runtime_exceeced(cmd))
 		disposition = SUCCESS;
 
 	scsi_log_completion(cmd, disposition);
@@ -1565,6 +1565,9 @@ static void scsi_complete(struct request *rq)
 	case ADD_TO_MLQUEUE:
 		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 		break;
+	case FAILOVER:
+		scsi_mpath_failover_req(rq);
+		break;
 	default:
 		scsi_eh_scmd_add(cmd);
 		break;
@@ -1935,6 +1938,10 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		if (req->rq_flags & RQF_DONTPREP)
 			scsi_mq_uninit_cmd(cmd);
 		scsi_run_queue_async(sdev);
+		if (!scsi_device_online(sdev) && scsi_is_mpath_request(req)) {
+			scsi_mpath_failover_req(req);
+			return 0;
+		}
 		break;
 	}
 	return ret;
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index c3e0f792e921f..16b1f84fc552c 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -518,6 +518,86 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 }
 EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
+bool scsi_is_mpath_request(struct request *req)
+{
+	return is_mpath_request(req);
+}
+EXPORT_SYMBOL_GPL(scsi_is_mpath_request);
+
+static inline void bio_list_add_clone_master(struct bio_list *bl,
+				struct bio *clone)
+{
+	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio;
+	struct bio *master_bio;
+
+	if (clone->bi_next)
+		bio_list_add_clone_master(bl, clone->bi_next);
+
+	scsi_mpath_clone_bio = scsi_mpath_to_master_bio(clone);
+	master_bio = scsi_mpath_clone_bio->master_bio;
+
+	if (bl->tail)
+		bl->tail->bi_next = master_bio;
+	else
+		bl->head = master_bio;
+
+	bl->tail = master_bio;
+
+	bio_put(clone);
+}
+
+void scsi_mpath_failover_req(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_driver *drv = to_scsi_driver(sdev->sdev_gendev.driver);
+	struct mpath_disk *mpath_disk = drv->to_mpath_disk(req);
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	unsigned long flags;
+
+	scsi_mpath_dev_clear_path(scsi_mpath_dev);
+
+	spin_lock_irqsave(&mpath_head->requeue_lock, flags);
+	bio_list_add_clone_master(&mpath_head->requeue_list, req->bio);
+	spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
+	req->bio = NULL;
+	req->biotail = NULL;
+	req->__data_len = 0;
+
+	/* End old request with clone detached */
+	scmd->result = 0;
+	blk_mq_end_request(req, 0);
+
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
+
+static inline bool scsi_is_mpath_error(struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	if (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE)
+		return true;
+	return false;
+}
+
+int scsi_mpath_failover_disposition(struct scsi_cmnd *scmd)
+{
+	struct request *req = scsi_cmd_to_rq(scmd);
+
+	if (is_mpath_request(req)) {
+		if (scsi_is_mpath_error(scmd) ||
+		    blk_queue_dying(req->q))
+			return FAILOVER;
+		return NEEDS_RETRY;
+	} else {
+		if (blk_queue_dying(req->q))
+			return SUCCESS;
+	}
+
+	return SUCCESS;
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 96b3503666703..544153a01b3fd 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -103,6 +103,7 @@ enum scsi_disposition {
 	TIMEOUT_ERROR		= 0x2007,
 	SCSI_RETURN_NOT_HANDLED	= 0x2008,
 	FAST_IO_FAIL		= 0x2009,
+	FAILOVER		= 0x2010,
 };
 
 /*
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index c0e89996bdb3f..85e792dc4db50 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -19,6 +19,9 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	#ifdef CONFIG_SCSI_MULTIPATH
+	struct mpath_disk *(*to_mpath_disk)(struct request *);
+	#endif
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 79e6860243e74..07db217edb085 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -43,6 +43,9 @@ struct scsi_mpath_device {
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
+void scsi_mpath_failover_req(struct request *);
+int scsi_mpath_failover_disposition(struct scsi_cmnd *);
+bool scsi_is_mpath_request(struct request *req);
 int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
@@ -60,6 +63,17 @@ struct scsi_mpath_head {
 struct scsi_mpath_device {
 };
 
+static inline void scsi_mpath_failover_req(struct request *)
+{
+}
+static inline int scsi_mpath_failover_disposition(struct scsi_cmnd *)
+{
+	return 0;
+}
+static inline bool scsi_is_mpath_request(struct request *req)
+{
+	return false;
+}
 static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
 	return 0;
-- 
2.43.5

