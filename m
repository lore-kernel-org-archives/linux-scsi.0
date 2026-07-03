Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A946D3BB69D;
	Fri,  3 Jul 2026 10:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074754; cv=fail; b=rveLwPrConP3ht7vK/PlZadGk3ADRZN2rqGcPV+1Sh6Pkuo0C1qT7FoV1VogZ3PHQEYNRWXQBgIhOjQs9a1u4JfeZ8jTWfYcMByH3IoOv4oceECNslaEMSsSXlK3JodwLbhGdXHr7o3cilIf9+xwfmc/3Sq0EKfuZPdGre5AoUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074754; c=relaxed/simple;
	bh=yj1GMSO0SuFMkoBI0ThCpzvaES9F5hDYH20Nz7axDkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZsQm4c/W5u+X+i9Febpw7PDqbNi5Vhu22sHIUDoYhH8MDWa4VOevl0LL79p3FzeMv+HW/I8jtGWQ47/+sW3MQ+8VqcNdqFDZqKPysyWqv57VSpSjf2Uv0Jmmv+G24jc9QFExXkLeZOjvse0NBW4l/wVenBfNDIZp7LoqjF5J644=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IoSZnKum; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VcY96ipK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IoSZnKum";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VcY96ipK"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tglj3329488;
	Fri, 3 Jul 2026 10:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z1u8P+r92OE1/8Sz9tqsw90vDvkZZ2UKh2PkGyeHpBI=; b=
	IoSZnKumFmR33Ut8SXsmUTG1/E9xZ+CSsK3crSpmsw5mqB3KhQaPgFG0DCMqqTit
	xuGQ8dgiSz4dZnU5AdujN7wu7412xYhJ5GDAUJKtbWaBv75u3JtoZYbUH3pKrDls
	RQE+2Mr+gt2TC+qgl9nUE9M3mvLHf8n3vTRQl85OQacKKvVkQUHa1ldcVw5NRQSC
	tIPt04Hac4yXHlUFacoMHW9pFp4tBVt8W5qrzNvIAHPiQrE3Of0ha/z4rYFMDvU2
	e+7bNZvSwPqd/G9Ta6oian9hn/L01Fqt89jHodQD0PpH8LSC3/te4C5tBzREASou
	/ijtsqmKawAdJjFNR9GRAQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26mkadxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS8xl033859;
	Fri, 3 Jul 2026 10:31:08 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhyqwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnzlwzmepZ75g3VztiAjevrEtDppSwoPS24bsk6ftenAFTRQ03SJGg4pJgU211UxZy3+cbndAEN6X0BmA/5cf06AfaVNlBww9Z+wWl2IDfohBqe0WjwOBq7mat5iB+BdZFAH9DVEI+i5l18Ard8g5FewEMNlb7X0oTWCMqeaDZGhIhhy5yH6jC6IZaUHfkFJCvlWYA3KwPKLj82qfo4qndreFhQVFkxv8U7m6ZEDEHGwHZ3N+3+W8EzOEWUcAvPVYPdpQLvPxrrBmllYsdSPUTN/8gU8USgzVA3ZEVYtXl3mFF2Qep4n70SAN/VvskrGZ58nbIv8P7jxA47K4FDwFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1u8P+r92OE1/8Sz9tqsw90vDvkZZ2UKh2PkGyeHpBI=;
 b=Hj23NEHej4l6u8l6hJvA1Y/xa/quj6lo+nUDxXAwgfg4SY5N7C8XXSYHYO64DAGRGs8/Y9dgGjTxptakeDuWFHK91V7Q7IDJrQ9WoSIHdjPe81dbE9aqzcvgqalfLSu4lOESzVQd5PUfV9hSrvI5ZxMLwtcOCOrdeGIi+LuzdcJ4Ent6iGD/72U2cA3gL273av0sw+rMg2+oaaL/mLt8F/wSV82EUGi6Umo4YFExAaePKTeHjwn1t+XRWlAYN5zOhlcdq2lMBwQjP7rhgYmA7SMEmzByvwEy/2BJTKWDjcv+vMMdPGjAVq0ECBa/qJe3crUm3yclW4uO22u6PoEFEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1u8P+r92OE1/8Sz9tqsw90vDvkZZ2UKh2PkGyeHpBI=;
 b=VcY96ipKVqmp7d3g6+JjPmSFmXVmCUtJTa8dzVbxwpWouKv5Ijl36nsXCZMmpkxgvGRMnxp1kMYXzGTVreeAztltPlnsyM8bgBrFBPVIspr88IM6ObdBgks5vTMC8//iRjMy2Zu5pGXZYCR8btHkqoE2iFCJAvJxddNXwhGgMno=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:31:05 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:31:05 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 11/13] libmultipath: Add support for block device IOCTL
Date: Fri,  3 Jul 2026 10:29:16 +0000
Message-ID: <20260703102918.3723667-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0439.namprd03.prod.outlook.com
 (2603:10b6:610:10e::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: d4935cf8-8442-4214-7243-08ded8ee2ff3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	JaSwRpdwxGvJtEip5hfDGr6OfQ8tjxkpr7DrThU91wIdKDaisMFMwZ87x8eZVqO0m0JU7rmPG2QqO1z8oimi7DmDAw6BbbsGsJmt5UxOCs8qGaeiJdjxbhY5z25tglB/jvg491O1fqM5nPHhIBVMp5s8pjmXQq7FPgrI9or3+Fk8Tp1YCO6TBqkC+LOXdE6ptrg+9HRETEhpj5QPej6Op6XHYEHxz5E2GiLI5hm8nmoNACRcyLmky9U7m06zso8PpzErdpNAiXd3hL42EUetSrqnNMxmu5LhCIrCF9TrqkNLeRZQvhBGvVnPMNXrK1L7eTqPG63MlUAMLMgYLjuVWIm0fpF/09kjRyVDGBk1VVKLVyODA2oUK+vV+TNgOyU7ku4hD79Qv0BbkHz77qhwIokOVXepRIY17vHXY6fLeSx7xhHOV0Kg2K4s7+Imp29Y+nvOYviJfHltfg6Q1ee3sFX5yV5Qdx/GbN4nMT15GKB9ipOfvGFDT79XxnRUpv5IMZLz+bwiSmgXO/DbbSHvDm42QMvxd8g9EyOLKnzELqZr7JC9SgURojg3xP/7j2cGv9o1N+mJ7W/ASq5kLupNdS6Sid8xCfHJCoHpwZU4/1yf9dkJFGpqKhhrEuejfmxWdaN/XHNmXB6z0kw6s7z07bLSGT+7wJdu2Py64JVpZ9M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sRIjOftRZWzhBwCkAs6x9vOgh+rusMYfVp3a3eDnbIA8MVvPbT81O9fluvHy?=
 =?us-ascii?Q?Ivy5PHzqJY2WT5MDDMjN2s0cnG746aFFEhn5RMe2lGO3In5ie+G5KwpQYxu/?=
 =?us-ascii?Q?fUJAuKyvAKrvc5ppKAyh8Rd5Z84SMR6Nitrj/fgTje9BTnvyUF/zh43KflIL?=
 =?us-ascii?Q?AB5AmiVFD4ixrlNAA6y25oJR7B0+mMiZykQvHOuBByNB5pXdbhUgq5VZeWjd?=
 =?us-ascii?Q?cmnHj4wCqRJrbQh0bLsJeUeV3pW0W4bPICboLdlMdcittlWcYSV89BIIsDgP?=
 =?us-ascii?Q?JMX9piFG7tniNhH2bT6hv0UcATnLP1SHnx9uw+ModLWukXBEwJL4O9zn/z6d?=
 =?us-ascii?Q?L746xbzCkvbuC1RB3EOSQ4/qJBmO1mXxt/5qFNOU4GmccG1palM+iBCopGjR?=
 =?us-ascii?Q?ps4H8EA91VLoplUBipwwOKMasPfiGonPEPnYrd+gYB9vtUCXP0MFbxtrrhkK?=
 =?us-ascii?Q?dSAy11qyI31o9h5jVIsX5n8Jd4dGuINWFqzDxtassC5YdHjv4C7UHekXIj1S?=
 =?us-ascii?Q?GNimS1SYNvmyKQwB0CvWZaBGT8QDPT2Xj7GEJVVPWc126yGtA1NnQmn5IHzO?=
 =?us-ascii?Q?PLhyW+bWmvxJsdY0YJeFOS7R686y5+7O79gMS1e6SgnWToYVFf4uD3vf6iPI?=
 =?us-ascii?Q?//BR4PwA+K/lEt7BMa9vByntEKLG5al7SLmbDNTSHSEBKLQMOrlGXo9PDkJN?=
 =?us-ascii?Q?k8wDjvbiVQQgVdK7mr2HaVd+FJOkpu3CaK0AHEIqUcSGiSdvhergapiFQcVX?=
 =?us-ascii?Q?ip7q8UAM86RWl7phd+RhoYKwuoA4BQy9OXB57ewYkavvSdPkOmo5NfIdB9+y?=
 =?us-ascii?Q?/Gsjod72ZejJ8nx41MRzMuQXjROp2Ha8eWUehIXaVNFf3LYNqhzQv9ly8eQJ?=
 =?us-ascii?Q?51SJ8QE0Ebezjc3SNBCJVaMv1Wx70vWbTfm44m3HcBPaqfcWsFqq6oRfJJN/?=
 =?us-ascii?Q?u7XhCmW/d89oITb6sI1rM6aDDT3O3stubCp2x8f219eh7gs3Y0e+6CjnoFwk?=
 =?us-ascii?Q?oqbsG5MDICniFOK9vINosN7SsaA9qnER/XaLrZuwuJu+Xkq8yNpoIEfHJSOA?=
 =?us-ascii?Q?vxe9JMPGV7fBDV+y6lUOAd8YKByxWzfcqiFiYRtbui8nUisuZVN0qUR/OsxQ?=
 =?us-ascii?Q?aGlzGYOLdyh8ieWvXEbh3ash5UHu06skZfpJNCAREpXgktKGGtEI2EIfTVYv?=
 =?us-ascii?Q?6qWpCXyd4kUMwcuOsWAfB1fsR8irfadyTtzRQlAQ2fygpxv0zfZvg6babfxn?=
 =?us-ascii?Q?5DmL2yUVLXI0d2ZteJF3/EF+ZUYL/1y76BRnSVDWfisurbrnprrkVFKPhyp/?=
 =?us-ascii?Q?2SsTD2XEO+0kvm1D0RyJ7kb0ci6niyo2bXLb41+YYu1KACTwzF5TsIQc750d?=
 =?us-ascii?Q?QlnCXzq8K1yANkYXDgC3r7UG6ski2co7mjvy9N+AaC1sGmqHyZeoVytSGYP6?=
 =?us-ascii?Q?GuIjPvU4lSwu5Syhn2fgUH9lnbhUX+uIzHwt+dFucj9wzjQSiF37+sjR3DHl?=
 =?us-ascii?Q?vhd2zsnpzy8AnI17hntXpQ9MAKNGDPvQ0d8JB5oT5bVmvsqWcbHmG1CtuBgR?=
 =?us-ascii?Q?bBFkOTYMfgFpEcQ4y1R5L8CJxXgka7vKKQAyjQv2x3pHbtISG4GJmfhCtrqw?=
 =?us-ascii?Q?dngz8FjFjC0c9N+5cxjaIogCHA69n692ixT5DuHDukFosmfTo2gOlEq/ab18?=
 =?us-ascii?Q?9S06f6vrd7kUog4lwJCjjS/Covq51OaFQ4g2FN/aNjq2FmEc7397DCdls5g7?=
 =?us-ascii?Q?WcLCw13jVrjhbv88uLUFICeBH5XrtKo=3D?=
X-Exchange-RoutingPolicyChecked:
	frPDB/kmcNHWA5S++FRBGrVIptask+KelaF3Qa56occuxJMrmiBc9bA4KgHF5gjwdA/LxlYqo9RYf6Z00Pae8o7hxXeKHdL5UsBeciumVFA81TOHU/g3FLheeZ6bVCjK0G1j6ZyRKTWTCRjihLX56S1wyBdLLmglv0lNnp2czpP3Sv5ZpqUWNrJJn3tOwv1kOcG/Er2hfVOKtIVQYWsLQJekrGqzdPxIems17vD3XjEfuAdf+mVnYnpK6mn2vrbu62id3q2amzKjPgN+KtoQYNAk7qD7324T9Xf9VA4nx5g94UiL4/MfaXU+Yyvok50lgSnZYZnPQNUBfzAEFDGc6Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o9hsVsRU+K/9HtESNC2lZ65Wxzj6s0787KDL4iRcpQffaf846avPUDvRvUK9dkJnT9RxL7avgfIynrrTik3biTXviGbdaBbP3Doa2iETx4Y5YzGVZaJ/hTvEnEua0GkpoRIiThbum1uL0aOFq0bRMhmNnaeNzje+UY5W6du9jJia8pNiPRAbQbi/kUgZNwBO/0/KsWLtPvjJ0ZK7KD1zLfoThoR/9q9B0ZOcyo+B75mgIvI9yoBwj/GoooU848ubQBxjK5gpZ5nVX+LR85i0AcWXPWf+Xwh+r12z04HQPZC3J04+7fi1CcIs1w2UDuPelT3PwLFZCc82yWtruF5kp1DKobcFReNQ2PRz3pYFbj6gSVa2Xd+tlVAC+4Ja7MPSw7KvQnDZtEaaeAJl8O1EhbRPg8nZA29rSUOdvsJnJJZk62YLgNzsNZPR3ZddzbhJzcVZDEwJSogHGPplKbscAqZ4bGVFT2tdsWqIjXIV5JkUoPJpuGhcCH9oisLlIbRQCfKpF/ChlHsHUUOXb1R3oesLakw6bEKgE3QVrFGWqDao2dUWFm0sIBZ0TfstN63Phhvp1Fv/ZmV1y0Y8jYHzd1c4c4Do0aQ4jRHXrqlVjbo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4935cf8-8442-4214-7243-08ded8ee2ff3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:31:05.3524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: //P2nOInNa9FCuh6/hQGFeGq6LDRnqY20vgMf7PB1Hmq5sw7d2TOGnImFSMLQI8OMS8fGzPBtWyQs2X06ppYZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX8CgQiltvgo2K
 vhaGI70AVsKffOLXhjYdX783dShSzlB/fbQ4/Ko+EjkI5iMSyB2Ws8n0a/IslVFeYp0Lb2f9sun
 ibAmtnoekkbuHFsPRaq/X7ks9fDxENpn4YMm9gOujUy+SCagqSc9
X-Proofpoint-GUID: COCuHPT1UPJS1KY55uOOPiPqTRQe-mhI
X-Authority-Analysis: v=2.4 cv=OKwXGyaB c=1 sm=1 tr=0 ts=6a478f6d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=bcaUz5aIumKJpabQAvUA:9
X-Proofpoint-ORIG-GUID: COCuHPT1UPJS1KY55uOOPiPqTRQe-mhI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX9TBmtmOsGZpy
 oT6rBaiRsCqXV3J507EUF7rWPYex7/KV7zquUTejkGpt15N+mO/P+uYqCPWmcolzvCjI+CIakZe
 S9i8Xt1rnQynF7qvk0omiSlQH6br1t8TKR0qC8bwFxtt0U7FlCydCGn8mGWlNmh9iijs6i91V5r
 3BnxN/83OWSAwVtCDXXFkE3xtWR73A6uwSrX1SlEnfHEkcQGPJH4GKubcXMkhhLbSjj0Kh6uNzP
 1AlMoSQjHkmMaDRdnSKlkIfPdtwm1QbNpTD+mIq35yR6SyzoHprzZo0hOzhi/2GTTeOfI0YxyuH
 ahC7C38Uv+lxmYwuj+CVKWvSuPhpA01eoxRSt5y02g+sJtkSD61u5eO+er25qCFsFtjUZYosuDU
 qXPIi16N5TQwfNja8r9LZvpw9xBLu8JxKgr+F6hlb/Rq89nfRbdapMyAmzAZk0fHjfqMzhKTMAY
 a4yNTHt6preZ57U3lEA==

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

Like what is done for cdev IOCTL handler, use .ioctl_begin and
.ioctl_finish methods to know when the until the SRCU read lock - this is
for special NVMe controller IOCTL handling.

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index d335074eb5bcd..4e4b347875500 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -515,6 +515,38 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+	void *unlocked_ioctl_data = NULL;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (mpath_head->mpdt->ioctl_begin)
+		mpath_head->mpdt->ioctl_begin(mpath_device, cmd,
+					&unlocked_ioctl_data);
+	if (unlocked_ioctl_data)
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	err = mpath_device->disk->fops->ioctl(
+			mpath_device->disk->part0, mode, cmd, arg);
+	if (unlocked_ioctl_data) {
+		mpath_head->mpdt->ioctl_finish(unlocked_ioctl_data);
+		return err;
+	}
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
 static int mpath_pr_register(struct block_device *bdev, u64 old_key,
 			u64 new_key, unsigned int flags)
 {
@@ -701,6 +733,8 @@ const struct block_device_operations mpath_ops = {
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.report_zones	= mpath_bdev_report_zones,
 	.pr_ops		= &mpath_pr_ops,
 };
-- 
2.43.7

