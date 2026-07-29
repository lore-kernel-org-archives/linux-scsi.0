Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F0941D117;
	Wed, 29 Jul 2026 10:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322386; cv=fail; b=YbDuu+AnXfMuiyvwRzWHFIaHNUNVN3gZV4MT1lpO0FjQQSMYMa6FrJtnFvCP6atyBwOxPGn2BfNKtYv9cQ5AhxEBDcpfoIj7JwtjdU1mnRORUGwvZnAfQ/ssD9iDYBCJ9w5mQxx4qSWrc8AxP57kdAUoDjd0Lnv1Km5oZdfuxR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322386; c=relaxed/simple;
	bh=4XMYoenVRcfywgZiUXxmJDFt29QOdkYWaCo7hrGcoOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G+hVKO4DVMcWTLbZSM4XTqjBLKkm2zWmyS5A3OdqragOv08jYVMSpfINkMrA5gREuqxi9Gk16kfFiVf1GNo5GO1JcdtSJQSMh/I4u4FQ5YjEdL2Dm8b1cARpqQIl5cIh3pPkftiOlAH5X5EcK9i3a9WTZio6yKbW0vnlwfpTp5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WMUEH0TQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Lk2QUVk5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WMUEH0TQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Lk2QUVk5"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9LHhF2091521;
	Wed, 29 Jul 2026 10:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ElGmHuIthoiXbN6Q2TtStK4Zvyvr9ugP8CjmseLjHQA=; b=
	WMUEH0TQhUz/t+Z8zON51LWpgDEJ61qnaR+z3DmuHaSkZC5N6nV2PLCiLVoREs3b
	gvmlz4YqbvJKzadYwyf8E0fVX3Fzaf744GJdQV8vZTYFXXdCdFadJpoJWIMs43Km
	MdI8kAcDwFkyXS7QSg07Y1hiIM5FRqgLWLH9fTHrdCFXsV1xShO3jnTcJzBMhxfU
	NjX1jeKvnfwX2TWl0oA+kivUNrhM3mztJw7WITU9tSB44RvjjJ8X672f7rCtENp6
	+1xmgNBLLHnqTGoBvC6WzKWZ8V7sJC0Fvdav02iRgH1wkUM+qs7vYLWZI8c8QDJj
	GoOi2z0Piy6ue7PT8HJSJA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyydqh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAoXqB004926;
	Wed, 29 Jul 2026 10:52:26 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011071.outbound.protection.outlook.com [52.101.62.71])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6dt9mx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FVOSTqk7z15he00Ebq/wc92wldlSFaeSZSH20jZBGDQ1nzeO0e4i0eGnh7MYgLeCOLxUcHd4Sk3PpoeCE+b5KHHuD1ucczbpP/3P07XMJ95W0Cvp7OcIi6YntWKw8cv0GPxoRMgEgclJDptEhpt0r4yUFmJ5SP84X6sL7gLhkvhJDSOOLU2V93ARc5muFF31Bj+RrEKH5v9+VuQ4+y/6wBzfKUtW5tUp2bgMaeTw2nTbeGrjlqSocR8Ot0Zl4ciykQhRpHWfDG/1N7rOkCyxg7TKFqP1lDaQJi7eY/E0kR0m8Vsf2gzf8K7qr/mr47+38R27EMG+22+RTd94W/eBUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElGmHuIthoiXbN6Q2TtStK4Zvyvr9ugP8CjmseLjHQA=;
 b=QKVphxZ7VMsQtD9Kr88F2DFnReM9BtnWoNYABc2CaDzr8Pstw9RkOYV5exfGSAMh30CPCm3zdWjJdJ4NAKd8l6zIQc6Wqm9uQfVIkcVi55dQ3n5cKxptO6u07/zPCWU1neZ6WQ/hcmDnuMu2dwdqRd9x8vWI+t92TPr8bijUsYKeJtTR+mMqSaXOA8NZhcXHtpo4YyhBc0vco7JnPxH4Kfm8zUjvSgXwE60EttPL2SLBds0TW0RMiFDG7bZ50TAnqIVUGkf43wxrMQYm5u+uo45l3lOMdQJxlLHlXTYcvFA2Jbg/xia79dFN0hMjIlN4GYHYVTdJIIeGQHk8K36h6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElGmHuIthoiXbN6Q2TtStK4Zvyvr9ugP8CjmseLjHQA=;
 b=Lk2QUVk5KVpTnziwwxGIC7TU1m/KJ4aRXpE3ghoU9rW1m4aD7K0bPVHsMkKoL4o7Gecs43gJHwjJM+WgC6jE5sN4iUGeHNqQPh/twIw+WpUDA05VCLAd3jtH5Ul5BS/dePkqNed+RM+zT6bs+5Kz2hVfyssuC3qurNfg73PICHk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:22 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:21 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 23/27] scsi: sd: add multipath disk attr groups
Date: Wed, 29 Jul 2026 10:51:03 +0000
Message-ID: <20260729105107.255712-24-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132EF.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::37) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: d3463355-9dd6-4a46-c200-08deed5f7770
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|18096099006|10067099003|6133799003|20046099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tK3XYLhRlH3BEFuenPGzuhWC2iKWvsNjvUFfMMB23IrALHOZZnX1vXEvJJ5t6soXPCfmKdv3anxhxf5nbSEK/pXHjuqk60OYtRavnIVDhrxGr4cbbUYE3lUaqtPkRhRRAAkuBSwXwdOy+V9ErbMKKqmvPz+jo3VhUjlVF1qNbNQk8L9cY0CeOizQ0qhV2++zy9HsNoo9LVG0KbqHlYuLcTxMN4/X84CM+NaYjl180V8+zC7711EfAgQM5qoRjb8j6a5Oph82RKs9cTjLr4u+Og9a9IcJEbLC7TR+8/PEvaJ/T5BNLPuL7u5XB79XiQnaBfQ2D3xVPzwU/g19nJSEMiWDT45xBvjlJ+vTQpXB5GHkgqcqErcAw9MMmFREcGLhLUyXCooDAusleCw4TioQxdmJ+WTvbUDobnA7xLUU2uAP/T19Exp983Q2KzpfqWkBYYV8Hof0Ihl4hr2P8YOHRLGYITuxeExxobtxC6zUQvzQ7tlfl3IcbHqD4UWu3A/4g6Vv0ngPbK7qRRXmPi3l5waaRfjMtsVCBWtcaf4W9By1FoKQhqAVd887F6GNFVdFjYUWaLVLfVL0ofQdd2bKjYWYlkOJPHHXpWoL3/JPTmsnWhPSK28PDrPBSrFGpPVCS5rzPlnlwPY3t8LOYkTco2Fmk1XlivSSJFZAnk1tkxk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(18096099006)(10067099003)(6133799003)(20046099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mwpda2Pn2TBWGXqa/0McVOm+0hYoQoctahDsHf1h0y6sGd4XViLxTjOM0dVE?=
 =?us-ascii?Q?QrmSVi5opB3RDtPI2HC2ig4v/aD5Qi0jrh2MgDO5xUVKX7I53/QaBE5t8YG8?=
 =?us-ascii?Q?+/BkKwOuMCEctwk7I05eaIOuTJMOXGPF1Vdjek5FYdFtOzQvcdrzwwXNPDWl?=
 =?us-ascii?Q?7EgdgZxuf09OzFyAP0dRDWLo0QFEHtFx4ZmefR9KihvXBmtvWc8YlL5lBl+z?=
 =?us-ascii?Q?JD8bFqUxoP+YQgJB2fxlAr5+e7F1rH5x34jewvz6trN1TFsliQYtovLilXLM?=
 =?us-ascii?Q?h7kHcHJS1eL5p4IKr9bUvdMAELrEU6wXgW2xiqHQDkkEoe3CzFiK0sggAHwP?=
 =?us-ascii?Q?0dEY7XQ5O+HZzd4Lr485fL3iA+ozT/ofiAerktnK1mwMabbnOBiKdnF8m6My?=
 =?us-ascii?Q?tggIUz8y8bM9cvoUbkbuwQJ0Y8pnelF3NMPMjgtM8TjLbrPBKn+h+x2KnpRk?=
 =?us-ascii?Q?6VJxexyV6z7VWWMuTn4cInDW4Czead0miCXut8Aor3YM4a6/x2fxDW3r87/H?=
 =?us-ascii?Q?am0REyQVOiJ/d40AegUTPbaaZr2rHVDBZH6g8CFbgti0y1uEkWC0HygfF5Un?=
 =?us-ascii?Q?ePKNBDeRZUP+NHqhkeaZxs2RGvCl42ms417arjdXvB2D+BL6hFC9sDxY9Gcm?=
 =?us-ascii?Q?JYMHRkqbd6mcFPlgUms5SX7qiONIFukAfgaKUkCuHyT1tt8Ah/k7v4e86zLa?=
 =?us-ascii?Q?gPe+4CKJpkEMkXAGlTWxejrW0lcxhxycquibzkXpYL6crn7rMzRA4v+TDvHg?=
 =?us-ascii?Q?Z/qSuXjFbH2Jpn+M3COiAeNmN31O1aWQYTZlkG/qiOwbt2pXIorvcz6aXyd2?=
 =?us-ascii?Q?7N/+nLWPsEM29kc/ZK0c15jzLkQcHaeGura7IWaCG5oYjC4/EVjoAmuiuvJa?=
 =?us-ascii?Q?NFlRBuJ7EFaBAPRI7/7j/HpRRbFTDz/Jccqr0siMDqVSxj+H18JiXgERfAF6?=
 =?us-ascii?Q?M3UX643s9emNFfYm1iUUEhOCQaSGYDrfbZ31dLjkxaiGbFsqudC26KEWCk7B?=
 =?us-ascii?Q?Ltor3Q+8CHhOEre6nCVcuKmuk0KQEiMmHKlLp7HekcNsHEzvNMyfq/1cKA08?=
 =?us-ascii?Q?5c0tRcV8k/aYpKIYBrEe5/B2ooQ1HWybCmrBeeMjJ78BtDae8Ulukl0XSc1e?=
 =?us-ascii?Q?h6Ul/tNgdYJhFGeX4R+v459Yq95RolO7aNB1zkZPfgrUDc5PERkgoYeZk5eT?=
 =?us-ascii?Q?G/SHOu5R+4aAP5UWoGZjUH47ntStPiJmw1KoZprrFp13aoA771tuHJCRAX8g?=
 =?us-ascii?Q?iyJ/0v5/ebaqLxrExXO+e5H42acfGVx+wuYi6bllg8EilIR+60kFLg1U3ngw?=
 =?us-ascii?Q?WQLcNcLNwVYnBh3UPuYnV6owkKoy4PiIc2aLNVahwsla4bZnM65by/V3RCk7?=
 =?us-ascii?Q?XwL0/Zh2H0FMCrgjzqRhtZb+GDT6/S4FQ+Zfk5CNcw1znUtedWPKeCkGQgUe?=
 =?us-ascii?Q?oZSUqI7kmMDDy62T38ozM3gBOjgLrAgnVdUnipwDRGILq8uEaeI3GgOX/HKU?=
 =?us-ascii?Q?oa8Ii4ve065GShQedZZ1Lm8yZ3c4VVHEqpFT42IOvc9euGMoSRqLST9qo8xB?=
 =?us-ascii?Q?rWY1aUsi4VH6qNclSm7iRjhRsP1hApSOH9OqR0X9dBLwU1tDLsU7Il4RriXB?=
 =?us-ascii?Q?7KOtehX2hnA9d5dGG67UYP+fwgxGA7eaQPeuqhPD3ld2H1zuztZkzDd9PH2O?=
 =?us-ascii?Q?+YX9G6ZyrHJ1VxSC/8Zpr1WYfJPDuM1iu9ykjqQZ//jwQEK9t60FBWBL8pRd?=
 =?us-ascii?Q?4Pu+BkDN4g=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Wy54b/2B8fyu0tIMezMrRpqR3YBlJOP00fTWfHiUrGz7XzmtScDwbs+XRLYyxs60RlOlTJ4wC/3PXc4dNE/IrtuXci18mFx8J6qIE2Ww6vd4S6UlcJ8tK2buh+JJ/qmmAbXDDM9SVTNL/jd6JLTlJaLJNeIAbYI0Oez3df9W4orQhGQGUKSQXBD1Uthc87Hfk1GCCKMgjml837Es8Bf0oEruz9npuACJu1V1y3AOgRGWihmHRWV8y+zbIAnBHt4rVwBnBcFm5qJLldQ88Yrrf2FcdjdWad7HYd7jb6XIHzzxpft/p19sJevegQaxIXGU0I6ohdP6z2L6cb9LwJp1XA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k2wg36qBnj+yc5bvKNbEmtBfPasAv0Gdz7t767y8VqrVIoTVo5v5Wmanbrp6DAo03doeAxItNZKJSgWMX33dhyU1nOpOkhBYAmJonK+Dzx4HYoU36AFgQ3OelYcoZs0nE+XRhN6i+G6lSl4LMZm8pr9/58CooJyNVz8KBWMpVYG2fD3LYiDvAxLmn1fFBJ8Y9NMo/yPwG43I4K+7aA1HIVa0Hz1UGS7q0vjH93JE9BBvFbetBs6UOZmYrYdXa6IV66MoztSRj6ygedylHS0SJOeliRn9rA19GUEavD7wYGgHxJ9a/kaKBTP5DqrzydxzSv84lTaSLM8U9aj+1bLKue+wsNnXu1NT3S7iWURnQqo6/MU1/BGYyV/gyc6YNjtgkuUY2qiiqZ4MXRf5ym/KPRXgvpe12fatVUGK2TeIwiE/uO9kSTm2qUkGD/eSiHZ7N1NKbaB4WwwNJ97rl7e06G8Dl8+IDbQKClama3BLih3s9jKYMgQfeVJdqJeq2YK4HWIrXVoIK6LcXthGFiJtb/WdoL6co15oze3IKXpiJjaoHq5tlfAwSeVEA4zV5VXSVbdyauNW5zs9pMox6GqXeQTsbhjoajFBOgHmhjJtVL4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3463355-9dd6-4a46-c200-08deed5f7770
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:21.7772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eL379A3Mm7ouGUWkx7E+BOhModKHBXaJhdcDNXWuWnGPWI8GzeMkQnX3vf06eST+8kywDDzear+XQZq4Vbvm6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX9YhLqdiKP12/
 FeZ0PGsdsYe0RkA4BFbq9+yRD+hbUnjmvPg/cQvwSfoRiRMQ+HRn4umFmea3eeOQ57X3fFBQ32R
 xymOL4REBVEItmp5Ona44h6LZqCFYetp7mWkGvq126J7cXyYHW5/
X-Proofpoint-GUID: AHJ0gZN4Yc6y4iGVa-hcC2_Whng9BjF-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX+wMdFohRzkPA
 QVLD6OCdFUlOQ1VLT1JzvLUy/550wlgTbUkbZsStIdTy9kS68pcFlk8pptGX6oTsI+1AzjKtGrJ
 UAU+CRPJU9uFFMd+mzenVyE/loPXy4hx61UGd4xocr5lpESF5A2ZvSOBUJYD2u9prfuTEi9UlIU
 KP3hgd1bAI+jz3nXuQGSMpN4Ybn1AZzVwruD/ALp1VkvfnGgRCrHMhE2XrMUxQmfs+GbDUr+9US
 qpsoyRpbJyJPCFlOEToN6dHZWGKTFf62nZRXrk8pqCY19cMPfaFlZrEYdQ3bmbjrkOYdkY6/DWA
 /5AXqNoYLlALTpxhuVYZmRJ3d1yoGMzVJ/ei0HKBMiN43P0pyrmIAzhtKJai32kvPtgqC3QnBva
 Rt4NA9jG5+rdYmBfgxGdew23Pv2BD04cSxvu0uLhCy7wVPj69ylEaLeO1Ou9mn0YMS4ilrz1pKc
 /9Y3VqZVzXb0BNATwsJIPyp3nP9PvNtQJeqdWpcg=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a69db6a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=4WwWyauO2_0H2zdGQVkA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: AHJ0gZN4Yc6y4iGVa-hcC2_Whng9BjF-

From: John Garry <john.garry@linux.dev>

Set multipath disk attr groups, which includes delayed disk removal and
everything from mpath_attr_group.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 242a15bc2c5bb..36c745cbb2619 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4006,6 +4006,42 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
+}
+
+static ssize_t sd_mpath_device_delayed_removal_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_show(mpath_head, buf);
+}
+
+static DEVICE_ATTR(delayed_removal_secs, S_IRUGO | S_IWUSR,
+		sd_mpath_device_delayed_removal_show,
+		sd_mpath_device_delayed_removal_store);
+
+static struct attribute *sd_mpath_disk_attrs[] = {
+	&dev_attr_delayed_removal_secs.attr,
+	NULL
+};
+
+static const struct attribute_group sd_mpath_disk_attr_group = {
+	.attrs		= sd_mpath_disk_attrs,
+};
+
+__maybe_unused
+static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
+	&sd_mpath_disk_attr_group,
+	&mpath_attr_group,
+	NULL
+};
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
-- 
2.43.7

