Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF48F377EC6;
	Sun, 26 Jul 2026 22:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785103552; cv=fail; b=VCg+8FQoqCkgZkY8Xi0sLqXMgOVf6OQdGqHGUA6n2h+k1aGoeKSqtywntCmnTL1CjIgRT1a0KvRzsAUAbWgYuJkUGxPJAOopKnALNmCEI2o8PP+uAHTTQtBRK2pVVhzkbtnm6TyoOQvNTnrrg4tjw5sOLBXbb4/3lEbBLPTalik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785103552; c=relaxed/simple;
	bh=HpfXbKHWgvoNx2U1+t706Mx/By7SA9fzPDRtgsAz7t4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BdrCifF5zaSzL88JT/h+ELnrxa8M5oCySOL4MKON7z8ItLmwfpKrxG9rgVeSvyCNUmlzx/YWYxzn509GvJ620kLU5dxnDNmJi5njGUzVSmkjbsl0/OPO9IOWlqa8MsTKfR+5QY9z2VnaPoaU92siqL1fkN4oCw9XpR3oiSGi/rE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EkxWzscr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zrcdMSLP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EkxWzscr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zrcdMSLP"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QM2V9t1582043;
	Sun, 26 Jul 2026 22:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dKbENmTyoGceVGj/V/
	9XKba9fwXXvdSjusXZ5seOEus=; b=EkxWzscrNU8Qxa65l9pZRZiaKVbn9zokby
	Hq0EXgr3uHiU622hRaNWO/9YoZR+U3u5R94lXUVhE9CGFRW4RGrjVCRx7c6sJurI
	5f5S2JQ92X+elQQpuwAF7kUQJCGyibB+iuRTs0r/6paF05DKI6R3IaRJfb1+1mcb
	5GXdEGtzoMP2sddAFcgU7ZJ9TrQd3kexojETTgXGlmNF2AxHFs9zMO7BBeaLyY4e
	ncn6gzz8FatJnC3RXAhec7zM71GjGSXc/Z6no9sJdqeJmII5g6gCbQfr+G/YBwma
	nm+xw4xYJKwa7WkMM4XgQet4OZFDh9+ae/eBsZwjYdVctYJfNCUw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyy91fm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 22:05:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QM5VDa011279;
	Sun, 26 Jul 2026 22:05:32 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010019.outbound.protection.outlook.com [52.101.193.19])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8507ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 22:05:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2io6sGAXHUuGWRaMdKPYzPNA5JgUhkKkBQljLikEG03F8fgqAKoAnyVoGsF8Yuh2kJMpB1MglYO7di8BdbeMF+FtpxtQunghniMMsXoB0Nw5SoJMoT32/QKzjLJMBxfFPBx8sSHLTp9zhvPc3AsKckWsctVxQiKwA66ujGQW87Eb4J6wUDBkuUDNOcKCLsSnpozGgqZsAs2nGO5iLrZ83JwdRUmio8FwNX5P8FMOWF67bfRF5OW/XNGbEvMTLmdXtWmsJu/3SFuSp1KMypPqlI4Wnov1C5jhvIGd1DL8xSVkEmt3aJB6M9BJ3XwwYNIcDlCALbePDYWV/OvAQoaOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKbENmTyoGceVGj/V/9XKba9fwXXvdSjusXZ5seOEus=;
 b=qTRmbOI6Q0RkIQcCrQpSPggVFZfb2ySo2s5I+IBaAslhpDhLU09Kj9ymqIxXygVs0SgEXIdx84Lj/z+6i9c4OPmXJhuDKuDm34+xL5NyZ5E5zdv7fMdxlp6pyicTKFvWuBCl5yNOF+Gr1jdk7MS+yocDyy/8JKVR1CpkAoWzodBCxpf98F8nKLPGycYR/GlDT2pOsOIFoEzjSDJ6kd8pal9iOH0hoc6hxzqBspOpWKWXNtmNfKiTc09ljv+GffDfn/ehdqASlzfvUgDtDPi59lxcVYPJxJKDAYovJS4uKwITeC7yX7SF/02ie8E2v51XiPzoBDu1kwnGDydvbVwRkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKbENmTyoGceVGj/V/9XKba9fwXXvdSjusXZ5seOEus=;
 b=zrcdMSLP8ggCl/75CeIgYvccmMXjt+WzT7dZ14KNi/Y1RMKfMZ9ApAalG1IHOW2XLT+9J8EQwBbA5myl3Y2wbH7BwtwibNGMgkgG2Ur2mq+F2g79/0N93vDi6nckwqPH/H7xZJWFe69DU22IrEKndGOnHJHRdVJ0X+2UmNHIZ5U=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SAWPR10MB998087.namprd10.prod.outlook.com (2603:10b6:806:55e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 22:04:31 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 22:04:31 +0000
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: krzk+dt@kernel.org, robh@kernel.org, andersson@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, avri.altman@wdc.com,
        conor+dt@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: dt-bindings: Document the Maili UFS
 Controller
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260719195833.136543-1-nitin.rawat@oss.qualcomm.com> (Nitin
	Rawat's message of "Mon, 20 Jul 2026 01:28:33 +0530")
Message-ID: <yq1ik61z9ui.fsf@ca-mkp.ca.oracle.com>
References: <20260719195833.136543-1-nitin.rawat@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 18:04:28 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0127.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SAWPR10MB998087:EE_
X-MS-Office365-Filtering-Correlation-Id: 503c2a98-d1f1-422b-f128-08deeb61de51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8kqRkqSYp9PbwoBlJ2xllHW1PqdHRG1a9DpycM1p5l8ZoIUWHhKreJZbBZIdUyp7Sv1qFsnaF/izXQeZEaUuKJlDpDC21dEKZhQ4rpktPNlMNHScClvbS0cKv4xQQCEenN9FvrUbxofvobcwpnQx5AxCh3zyhv+mqYylVJuEAYTpahIpmt55EzY/zoubxIKGObr1cKQpAB3hRvx+xPuFzxgVfsVHZ7Sg+vDLrtEYg2MX2yDuKgKut5u3rNEReKPa6wHkwWwptFxed00tlYB5H9OTO8xJctVn2Pz0Su3aeIHjX9W5VYHEGX1D84IaucJlo4o3kNO4SkLGFSavyvAi14a90l258qVLn0CU5r6JOT4iJdf5A4JT1m28U4Mh8ObasearUMQYjKB/uCEVp0F5b0ZQsLy9eMNTSokrSxcuEkAzGiZj7B4pFthwWQ81QHfyrDyTBu12GQXWyjEIcdYeSm0t8ajlMAJEk7hePASBbNwAgp5+N3P8aH0fsLwqvkW+7dSzqo0e8lBSmlhRtLWY54cFg9BdCqFL2C9xcWbiFE9s2mzhrKhObzEhaUuK8eJrzHQhgXbq/3AZvmvVaro8r4YW5opJ5KfmQYXtRPu5snR1ZRhqGsU29WCodt586Q+75L5XGcnD6SWu3OsJt/jlHV7+43qKXcSubQ8YA2X0xoo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?717rEtSRUO0tZ4QielRlSW4eqJYMC89Pow7jPrgpP/gHPmFxl5YxoUauKRbT?=
 =?us-ascii?Q?c48+Kb+1EcSXzALU4b/Mo0icmOc2K2x1EHZ+au/ox9u1osBuOr99V+yUsBcu?=
 =?us-ascii?Q?s3td6jVPzjxOPmUhfJP89cvDFeKVcjU2tNq+O90K1JPB387Ag5o8eeVn3+Ae?=
 =?us-ascii?Q?nwuzwpM7dX1/HVLMHXNbzl5gXzJ/9mgNtFsbqC0swy+zEw0T8IzWT1VvdOVB?=
 =?us-ascii?Q?Yy+wQjc+6UrAKItBaHaAvr2DyKLdLQyUckMGPgve4QEhoVgm2osUoWYFfToM?=
 =?us-ascii?Q?BHi7Wr3FyDW4HMx7OVyghkET3p5w8jrYbGULQ/nzoegZCZT4rw7BpQDAnX88?=
 =?us-ascii?Q?+yg7/7kNpEeSoWhHo42X0H8c6xjRN7T8vHG/Xf6Qx6lu9cl/nvJNz2Xitpda?=
 =?us-ascii?Q?sHaU5P3/CF8vQ31lRIAJblLM++ENzZLVsnSzVkwWzwgS0t4xtNZEgPPY6KTk?=
 =?us-ascii?Q?dtOtT4P41+G2eGYL9oH+yyH4o4+MID9cdQ/P2YMvRcHmcskJRGZzHgswbywl?=
 =?us-ascii?Q?XOmcxAKUjZLbP/Fc7MTAHZO0iljY+HCqvVMMzH97hlypwcM492vEvXG7Qiui?=
 =?us-ascii?Q?bREQhHQ8klLizmOOANvb9S7ko5RVFXacthq2iICkEL3A8fCVyKQl+QnH4THx?=
 =?us-ascii?Q?1n54gX5Ha0zfQtfroBSdzWyVKQxF3dor6PsPceNihAUGlzZtwkjFndL/JSTl?=
 =?us-ascii?Q?bf7QAy1ntMzojvTtgJd+XrMXRZAbKYi1tnkUJXcPKhYW4FXAecmZQTz/aZMf?=
 =?us-ascii?Q?BlAs0dmwXCU6GMkFm7WM+5orK1tccxQMbVcDFD77Xy1CsL14daibbv1E9+y4?=
 =?us-ascii?Q?U+yFMAWcDQyaEL2kfFLGsx+XHE0CJpzDdj7QfMuE4F5A9IZAh99sX3co6uur?=
 =?us-ascii?Q?X8uGGjO6aGeEo2jcgXhEZ7dyhf0l89L4T6LBTQY2ztsJ4VIf0x3rq08nCXhL?=
 =?us-ascii?Q?A3NM+omCNBbkMdelQJC0p6bO3ltevYzo2pdUhKYu1xqNMoRmQHNSvQQg4wHG?=
 =?us-ascii?Q?6Fk6MN3L3xqTR+qEL1xsW3UkRlYfIvwpkIkypFFL9Dtf+6BrAzk+uhk0db9+?=
 =?us-ascii?Q?D8iIZ2eu/rZ2+2snptApYE8M+FjdP6MkQ4ofI1TS43XcNHSPaRdSCuUnuT0V?=
 =?us-ascii?Q?TuQqrxxqrsHOfMzuthPdOGs7opF3d45hzHHTDh0AUKEYgT3MAsNwGSk/iDMs?=
 =?us-ascii?Q?byyZ2hOzCElUb54BvIkTMKy4IYMiPJmjIR5+DNI9JcH29UnQumNRz0NVKhr3?=
 =?us-ascii?Q?OWSbJ7zWU1DRxus0x6MAcLP3iZwucomxCa0XJCwSx6ZXagsMAcwU/tfdD+OW?=
 =?us-ascii?Q?HZnB77/AY4tF7OCUqZ0xXhQiRHwlZYcJEWYvgYfwhPPkWPRjVmYvjhfFy2Gk?=
 =?us-ascii?Q?4Fc6vhN3wFrpe9nhw2Dp7DDyyzkseiU9FDRrr2pvndHXtzfO4C6No39WGQcZ?=
 =?us-ascii?Q?SsjgrTl3d4aoen2ZzI+cott/+QFyvGib4lF+yuLtp6AmYACoOYEcZGYR4A0a?=
 =?us-ascii?Q?dvtgHx41ijV0nMqUBr7Rjx1o2pQz/eU0+//0FZtac/tMzd95JHiSHeAoc92k?=
 =?us-ascii?Q?NIKxQomsPB6XQ2/F9HQL35VwLUPDH6XrhHG7RI1JRrhw0YCkX0dHBY+gs54n?=
 =?us-ascii?Q?QGnOG6zXgEFTATzNzKmtj3Kc6Vfhyu3dcUtfvvY2AbySUVhontIhw6G8XYtg?=
 =?us-ascii?Q?dyS3OGqJYzgQzaGyNi8DQtHOkn4XdK/n/Af1OOt9hNBNvAQUwaGcI7+wUJZc?=
 =?us-ascii?Q?u0I4iT/qJ/fpIePDRL+lhvJNegHFpIw=3D?=
X-Exchange-RoutingPolicyChecked:
	syAk/tBZVFUbPFbdA8n4MEOUbHdXz+j6zZrhTJmLA5c4GDaNV3j7H0UEGfhXlRjF+59taz/YXmtB2bBWN/2Q5rHstOVFVMdCnmOZVhTtlrrNd8dTJthojK7BTC+0PG770jLV+beIWpK6/EjpZ3MeewSaMPpF2AaFODmkqpQ5bjhmpHg+mawHrDoA1pZMLRMl12+Fa/YDdIcJRhdfofBWTYZtxVsoJbC8Tl8j19ICIh6ysiUO5CVaIzO8U8p1pSPmy4VPn7/ihoK6dcdEx1W2xMO1MKgWCZ0wdU3TSxs58EmqskdTCyzggubSoTPluEYXdjnxSmBSGwGORGEC7gSYgA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qg3oSkJv7qjXZV1H7PTfUZt43YrgauGbTbcTfayfLSrPKw5xsl9pCRqEPJRjWSxoDqLSkvhkSgqYnoJsuV7JoXyBigOqKAa/zlb3q+Qzyyy5Q85QczIlRz9f3NifuefEq3LFhH/vl0Xbpo8a4qTTDsHz6Hllsuu4rObVkq+WNCd07Y/vL0vAzx6LmUQF58fBa0iccZCKPL+5cYCeAeCDQ+DctWr/JFDzMKLQ9shEuO8J3qHaS4hqcrAhiWOLIJ/PbzKIyRJujFqK1wtbtcmrwHIQGUy5Oq0WBY2kiSFtYhZRomdMiCC5TDH2k+OqIiMUuVxX2cHBdoXKVZqjX2u3uOK2NcZSahbpW1KiHj7apyRvZ6NYjVPZFygBMGe3KTwSQbjbLtPTTVgOp+0WUtxqprph52zEd3nLf8EW+4G5DiSW7+5W6ubvslKcVLPbFbFqGdTL8QueLnx1Xsmj04AYOfxRatLHgqEH9ntgwZ7vjQMITWE8sjVLgU0vJQ63D7HHRkm91ZU1ldwjj4PcqcZhXFzAxYgsdL30i3WN8sKRNm7NIeuSPSOv6t6keaSHkj1p67nM/8ubJ/HjSWYXYSu7Ye7JlzfLqa02NjkvlTKME3w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503c2a98-d1f1-422b-f128-08deeb61de51
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 22:04:31.0092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qqRZcP0ZBnZJIM3pLtEOtZaIzWblieTWMVKyAXLUE27ruUqN/0Bn32BcDdnre15qAme25wwK3vP4KyvOd3J8U+KimxwfBMkAVKY93uxQCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR10MB998087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=828
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607260225
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDIyNCBTYWx0ZWRfX7GY1E4hAINi2
 KTNoqLbA+WAolVTvEf7iSMJ2zOzNu7zf6EVOGV0MklurNWOKzU96lC/bneOsf9/Y4Qw3DmPTdP1
 6A8CZQ3UP8IW/sJ/YaajTwtc5ru8MH1PcQGhA+3n/GFgnnc2omt0
X-Proofpoint-GUID: v3XZy3aN-BY8dBmRJBNMlhw8Os2X8ZxL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDIyNCBTYWx0ZWRfX6yBWP+cTSPWj
 7NyWVE1XOHxUDmhA8GsIXyN3dGlm9G50hjtTfSWXWh32GI29Rcg9cPETkVJ1zIIUES5wHYIUuSB
 CHRkJ4is1XA0D73iM9RNwLwJr+5JLBB6HkdceVVi+pz7kXCTh4YTQ/MmaXwIZ4k0+GPgrGdGish
 I/+RZO+zh9bmBJCVIEtqUmsyFqn+ZAEI/zFanYQQtRZ5/zvn2lneDwMSUudos0ieMa7PJJ7SE3m
 Hl6Y9Xx96lXbnj/rUFDBkUkCHIj9B4cBK/zuP2Agd6Vb2KYCqRJ2Y3w2j2MV2w0FP9THqc4OzeN
 M0z5rz7r4BnRgLrVamkO46DMn+xMQ3gCSsZMiHbbEFYOtdpOprJWDRQMYGpzKJWnhK3YNl5FT3k
 XuREXziVCUsurb3CeXFRPXu6W90XmjRTSZVxPhD8PTTqsMGggLOXUxio8LkyPx53TA6ULr531ZO
 GITlQHANZfxogPClj3w==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a6684ad cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=sc3VoMfREI2dgromAcgA:9
X-Proofpoint-ORIG-GUID: v3XZy3aN-BY8dBmRJBNMlhw8Os2X8ZxL


Nitin,

> Document the UFS Controller on Maili SoC.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
