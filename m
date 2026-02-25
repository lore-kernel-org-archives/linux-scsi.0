Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BD23E8C66;
	Wed, 25 Feb 2026 15:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033856; cv=fail; b=RKmJtNpSdIIPh6yLeoS1ZsNWTbvVlNmlEsf1RxdpdG+Z4QgWik25xBMnDX4O5aUp7fJkSwLHYBeE1X7hsyGCNMPMwKW+Kwdw4wnep/rcr5hkItvckAvlCjeA+UHaILpJZ52H0w+L32Z63G1AFMI8T3LAM4ILFahauQzwx2c2uOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033856; c=relaxed/simple;
	bh=fq5p5CjLS2j7LPB+6sxotsmVIuPM0oaYO4922evm5bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ds6XCE8MOqcMp4Cn4ZW8u4oAIxbpfRJG/ct0tbpbxr+NOKwsAJ3Bkz9mJEJer90A+1nzVwYAI+qAirVV00uWvQ5U6EPFVqYynxn8MsMEfwWX1rUaGSSMaRcIa5b0G9WMBgQU/GraYeZ07VsQACq+cvTGAZJnpZDcedf5m9Wbo/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jOPukxTA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gG7nS8oM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jOPukxTA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gG7nS8oM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAMUCf719679;
	Wed, 25 Feb 2026 15:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PWCKpgvvSVtg6V7tn2fLsgSOseeO8p5XNuftN7Upl7s=; b=
	jOPukxTAU4zNSvatH0p6OHKkyuJIw94EqmGy8Mq8WDIN8lzqUhSzZ6nEgVD3WhNJ
	MuYuYC6LzeZilFumRffMCCCO2JjF8LMmMZ6uAmTRSWofibTuBDlY41yJe8oGWKJz
	1txjnaUYjksfZi2VvoQdll+ssrm5sVoDbGHBUmrXpWudvXHz9nw03pxpOLYMHRph
	DNK2m1kWlu4yyPggtnkGye9L0rzAoNvI4xdJXWbks2z1kdFloe9L/+RJZZntzcYY
	hPXxuR68Kj/4Q1Y61WgUaxHhtEq3YgS2PxrQavMk0aecLrN/do/ruCwmXZjopWvp
	JUNTRUzCgu/uoXyhrcIZWQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b6ejd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PESt04028497;
	Wed, 25 Feb 2026 15:37:17 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7hfn-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S8je3/jckXSnYdHIaq4Rg/shFajanLgWMl+hUkMfSQwEphebDVAovcaQjfIlDFWQbMo89/u8R6w9yG1Al7JLoxSHmdVvIjPJAr5+eL4rl/+3WQSD4WwaAHYPJJfTQo3SvSKriCdHuo9/SV5YmskCKIxEz8Lm5XfflWVrt1zG7OEpo28KsKrOwvmxs8MoLJZt2A4URjGQlkU5KGg5bF5pW/kI+I7WIcw1UxIFSSRAhgq5xMfJ6r381klrNrhKoVzN86DpJryHGotSkKLNGNCM2i04hCgvs6I+qWzc8MwxYutO6gb+WBkGmtZaAkIOWJkOypQ7VlRZQFMicxOGg2MXig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWCKpgvvSVtg6V7tn2fLsgSOseeO8p5XNuftN7Upl7s=;
 b=F+zRjvq0Ca+GEcN2ri70ZDJZWv7adptGWVN84m10MnXRH4ARsUe1uKsjr59rp55r06aTpWdELLgIQmfPsixgJK+xBCGnpRUOdYz9fQef62vRKecuOmjNCPoXHZxapYGtHg7Wv83RE/6NIjhvlr5leSZopiWMOUi6Sta1LBp5nsL077VNDgNZwMg1fbvR/Ki3WVWVRom3rlMa2Gl4VdnIsq81jBOuYmPOrm7u94KFkPIbVwZQInCVIZ1bty2iB3ZLd17ap8pC3+9J5OQf4BNa3vIy9FgsXhu0Y8PqVPw4W8rDdrgjmlI+F2qyOSwDSQj4HMQ417RzyAOIsWWbU/y96Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PWCKpgvvSVtg6V7tn2fLsgSOseeO8p5XNuftN7Upl7s=;
 b=gG7nS8oM7Nfl4gwHh2uFyaZK/G1L/O4JH0fL0OWUVg01Q/Spv+58sPqp1ISlabGoaXZmB8/kNt6MElgG6FO+Tn1gyCmiGMF/F9WcvAnZCtZfXkFsoCwEHi2b04ddb+s22k73qpvryztjQowRK2mREHXpDVNNNnZy9NRUsCA1y+o=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB997712.namprd10.prod.outlook.com
 (2603:10b6:806:4c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:37:09 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:09 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 13/24] scsi-multipath: set disk device_groups
Date: Wed, 25 Feb 2026 15:36:16 +0000
Message-ID: <20260225153627.1032500-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0048.namprd02.prod.outlook.com
 (2603:10b6:510:2da::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB997712:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e79b758-bb8b-4c32-39e5-08de7483bd03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	qddN1azfr3Y+56chJMjI+i43Ac4MN8dyzPLzcAJzP62Y4vr64k3qYeNEQpRt2QILAub6fCDyrhbUWiknEvsqASohmWMFftulDLPFyBoLg02+0j/D8yQQ7ZjCIoUeGStFYr2kOXS//GyNQ0X9CRzofjJfc5m2l5jIGrCBir5v7pQ9OsDJgXqi0Jz4/a6kPx67kpcvdWlcJ6OVJSrSSm0Lq/+WMVoTfy3Myr+rR/oVJ1uUzMvNwjDM8GKxuDCf5mwgEZ6JYAKYjM/u+HXDoDHYwYS5zj7F2HYaQW8Ms3eS4kidlqHzGbtXsZTjXI8CW4QITDzGkFmFaZB3KDeE+HSbhWPt+dB94twOlYnUpECD6G/lKiXMUlZ9lfewPFYX4h9RlWmXsvMJcJ31GaD+GaRsT9FYbJu7ABaFtEIgnSFsmEwkqDHzUAPF/iL/AcLGsGFL1zpcLLqKP3XF1r+zVzgl4EF2h/Xgz+h1K24ncvv5FVHMevJJ/u7JD8S1b2KEM/fN/kAXFAGTMxbNMs/wlMblv0aipiVvAwVqraeXhcQHgXA1jA43JK8rinWK9qhlR3IgHvyVXMJq3zHkmaxxYfFi2BpeDIs4kn0/TuCUVQGJ15AbG6m3sm9tJi2xEAlKbLks+xZHA2Y3SHxC7ePgYTogVQXALSzLNq1pndmtp6uSJXv2ca92RVPoKXytnQTiFDRWfEDbpZJMsS9aAnNQl98NIs/gJWLsFtRBAgVa7CDuKxI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IY5zi/0usKBE/UJWPxvwVt0fEKUoIzZ14iHFrto39O52UTFPY5nS4WW//ZwN?=
 =?us-ascii?Q?8qBBHdcdP+bL1XqB6fi+J0c2Y8tMC0op9z2j84pGS2ibbOY4m6c8TbZ1O7ge?=
 =?us-ascii?Q?4awNwNMZLFhHOrRQ9XQ0s+wTDT9o1k/ElBS654hCvuSg+7Vk3CUyJVPYgR+f?=
 =?us-ascii?Q?UT5N0owrMPNu3loHve3sABrxMEDy0WONu0rr0HNs/HT3DxGYVawqfvLwV6cR?=
 =?us-ascii?Q?lh4B2U/VNuuWWiGqs7QPQ7qJM/YeVxS3Un9lyJO0F8eEvxu3pB+Uq88A9SRT?=
 =?us-ascii?Q?DXoUVWzgI+EFw3uP6qtxinCTwQJijLrjIiKaiXg+rQzHbVtXt1QtlL3ZSbTn?=
 =?us-ascii?Q?3IxTYQlEROArORiTttiT0De/aELeD1E+AiSrYbgTzw8BT5ISamqmwxSdFZCE?=
 =?us-ascii?Q?9V5QFb/kvrNlu/e/bwEj3ZfT711rmBwIbEKDjpqFLn6p0+3l9yJ1XlPkQlpd?=
 =?us-ascii?Q?w4K2VFYP8eIgj+nGe2vcIVrJqQ8+zPVtodrSw2Ouh2dfFXLabvFxXbUUgm6V?=
 =?us-ascii?Q?nsZmjBDaKaaU8SPqIvCrIxPZgXLIwkljtybwg+P5bszl0C16vMmAWomsKW6g?=
 =?us-ascii?Q?LcDWPwWvpAdx8FcyjgpYueiSp2+NESCrYaohbrFnlaJswDIhUcPiUDkFi8bH?=
 =?us-ascii?Q?Op6R4O24UdFAs+N5z3NfWdpQAp9jXnn8lsB9noebnsdU1LqxOlWrLoqHKQyN?=
 =?us-ascii?Q?q0n+Y9B3nl0mP9+XVCqFORfUi/BoNvZsYtmTR+dSpWDFuEIwIaK5ZXj+roDX?=
 =?us-ascii?Q?A+JfUsTOoiTl1KuAD/StaIKg6RBS3Ijpt1dfjFhxkfkak435XdkJk9naWdnV?=
 =?us-ascii?Q?D9ysFdGI3rVxFwPiamfmi0DdFz5t/0OR4S+beSz0ETnVNDscPwF/0G+1w/Lr?=
 =?us-ascii?Q?b5I31BqVQdD6PJhnv4ulIqkyzNSQfO6YmXa2oUMsHtLc5yubJU3XzsJomyOi?=
 =?us-ascii?Q?HqcNw+svzSfUIbh9bBtrPjePLU2PaN760nPdHuebJk3iwl1/moUuYU0kH8QK?=
 =?us-ascii?Q?dSlnw8E6ArQf6rt5IqbetEaa1g0zUOlFuGxXkEBEvcvBSHV7ADzhOPkF7NYQ?=
 =?us-ascii?Q?h9SR7tKgmqThLsgM9noZisUBb02KlkcLllVOMNjAnhrVegpFeMhzV20J1RKp?=
 =?us-ascii?Q?DSbLcT0kJqbbvxiB6aHveEQOj6Axgkbp1MNimZnm/zP1Y0zWs2lioolaTWew?=
 =?us-ascii?Q?OGQ6rKoirOkvv06HKGeJN/5622IjpsxpQ15Lk9i3ZDKq8LUjLI+tzYPZgzqZ?=
 =?us-ascii?Q?u7Ohh5m31kTefD6rfsKRofqaoYRMcjM/ZKKMjh3RsGd9z+ArLsyiXaJsB2WU?=
 =?us-ascii?Q?JvQqKmeRig/TnV/xYnasfnX89ZORWG/EGqy75p0/c4a6DJJflATgMiepnFVd?=
 =?us-ascii?Q?KprTmDtULXFn4lBDHJDi4eS42I0ExYIaNYKCxTfuwe8V/SvKpX+7l2RXEXjc?=
 =?us-ascii?Q?y76KaBzbru248BTIyPVHQPnQRiC7yEBvAtMy1WZqmL2VtxReoITX/f/RE3A2?=
 =?us-ascii?Q?TL+wlMTEcx4fMKZ4osT0vUpBH3GQMS7duZQgM2svSNhiMWJzcz2wqHJLTLYR?=
 =?us-ascii?Q?YHQD4f3QtkG1p/p49aJK1HtJvuubynazKlIKEnhS/4fEteAMMrv43hB/6QuZ?=
 =?us-ascii?Q?tISLcryDM7doAkzlJAktC3H+UEf4GRIlxRjmVpIdUmAj0m/bjL6IQV1ASXx+?=
 =?us-ascii?Q?rjlhhTz5qRNk3BnrfWTUnjfpXO3QirEbfUjFu49tf8n73KZrK1VVebJCJC3m?=
 =?us-ascii?Q?7TrFg9rdErOn0mOUq4qxHn1SrE1tb+Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a/KNViuSXkjSIOuJSsIp0fe4l/KqKrbI1bYDAcLoEHUT05KHgjW7ROuAhlAZa346wcFWz3pD5LWQo1e+EF+2Wu/IY7c5mnSZ400VUzqv4OILoVdKoFWDCV4+0KzTATDnJRHLsY3XOElIo0ZZOu9Z0XcWsenxA1ZPvuoecCGvda9JfG55sS3Hh54Mv4/WkCLsCckwcWLQpXD348/rONkGNApY9VR5dnBEtFEDXSawLWXHQACakrD0sULMAuPTqGrvfa+Th630dLugwwMSlqBnL0oLx1XsxFs8W8RIOGJM7gE+YVQy5vQQPzB/PQQfeJ6QDYYj9RjEnpTupNQSzPCV3L98yPp/oMqg0ysCfvjFd68RTIAjPu/lGr3AdoIcXgdJb5TG+Q78B43J2l4FLRifia6q9PYvY1QMxlTbFq4oIUdj8kCq5+fAZAIOBHthBalllJyGG0ra5L9TpHxa8La1+gkPQzTx3b+P8h8WzVhAgMYiiKtjJ9P2jZzPhoEReEljGWJJii5ugKtvXR7EqwI1qyZ9tLCX391avwbz8fxbB1inA5VpnhqV2zGSSOQ6DCp3zneJ3vjHthw53vJh0CBa0hIkRRbzQy8DRbWSluaVDGA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e79b758-bb8b-4c32-39e5-08de7483bd03
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:09.7440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HRJm+KgNgTAJnhEqAdv8T2LdViuRDQi/jJkpDwrAhHjFOCmwmku6REJc08TXa1NAmwXVPA+gqxEK65KzfNb1Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699f172e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=V0SITuWRk-thg8KP-pwA:9
X-Proofpoint-ORIG-GUID: NOUw8fL3oAp8ViFcFBcMnuMkGlasUfdR
X-Proofpoint-GUID: NOUw8fL3oAp8ViFcFBcMnuMkGlasUfdR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX9zbjj1OvA7Pg
 gSG2R3JaTjgEr1apNs/XLknmplQPxVg0wMwFGXkM88r1aTjvy+p1YdJDhjFOCkdnNeUTsOGH8lt
 pO7JcIfth2aOzggFoLTH03bsJnJEfVDyhCeuiXNPV8DxRqNd2Fb8/bf5qlt3kH/CkM6HTBlVuFc
 QFba5pLaeYw/hyT8/jEn+hGprEXgaO0P8q7mEFnfZVgxy5r2COsMsPmlCnMp5/u2Taj+4Qgrc6Q
 uhCwgsmay0H4mEoWl+/61DmQ1KLsBhnq7396JM/dee/JkkP2ftg7DK1b/pgkTSDYVHyYWhql0id
 /DD9ab2XxFqwQVAGOhRQhEd5ldJDK7nA6KlLLNSHIvbsyQtXD8qyUOt03WTfZRFe6yavWaQ9zG8
 kheQXG5YXSRznI+ZWS7NhH9DBIzYwZB6BLW2/mrFzuy0BDjXpF4zaeOJZkQVESYbU0REM+4FPx2
 d8RtZlSb0J87aFxjbdw==

Set disk device_groups as mpath_device_groups, as this gives us the
"multipath" syfs device groups.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 6aeac20a350ff..73afcbaf2d7de 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -389,6 +389,7 @@ struct mpath_head_template smpdt_pr = {
 	.available_path = scsi_mpath_available_path,
 	.get_iopolicy = scsi_mpath_get_iopolicy,
 	.clone_bio = scsi_mpath_clone_bio,
+	.device_groups = mpath_device_groups,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
-- 
2.43.5

