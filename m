Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4FD37475B;
	Sun, 12 Jul 2026 19:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783884320; cv=fail; b=c5yEAaDU301qNF7mqm47XipoHMsGBX4r2bMclcsUbGWybHcrSnp8z1wzV7BWuaOaaYE3JSrfHcFHLo6PC3s8DrI8xUh2nnV9jjVOlmwT8zw8YIBwwuh7F9OpNVlp0CtauXCTXZ53oAplzsQZ/dZ4XoEAWFgJRvMa3CvU4IPzLyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783884320; c=relaxed/simple;
	bh=VJTcqt82vUs5uS1xCHLcyWcopinYhkU3WW5zx1zFUbQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TOaZnC2MKhGbT3cNbT6KKjickuot8GOZwmYDNSLn9kiaMBgELXgs8MtpZh3LwRxTby9JzZiUBRthcMkQJTWmXsRgzBh5TJ6mZXU+uQ71/0qYMLMhraeNgeiTg1T+LXKtzolE77Igi0RxWMKz8R2ux2s6knvoODjgI7RyO5fvSnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e3qnuXYX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yKnAxQWa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e3qnuXYX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yKnAxQWa"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CIxjNX3834919;
	Sun, 12 Jul 2026 19:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AZ0/cXFRx91YRDhHZQ
	ywQO89MsxjqU36LpAn9j25oo8=; b=e3qnuXYXVSBhdOK7S+SwQIuW2m/24jI4Vz
	JVAEIFkwEuOndo97/m+YZ4j6vKw7xNaoIvFcauG87pGB7Wic/csmdqg6/cN1Lp61
	HJ0783EOyBRy0xCR9rG07fZAEVV3W5rtHbf4nW/iwbaVjPbwQjV4SSUiZ86N0WBi
	8hd5wKB20FIu7UXlddnMCC9DPHg1P80S+mzlu11dYpw7/gdP4+ooJ1CzCxrYbl+A
	A/NUfs+6EKF7jazqMJ8NnBP3v2kjntddxQURaWO09mXYF15yVWfZGJq6V0yLx2hu
	BC0dW0fejoEDF53ud4aB1mdy5lVv2MeQHSJT2KUhRw9dZNGXQnLA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedh5yh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 19:25:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CJNdGb006004;
	Sun, 12 Jul 2026 19:25:12 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9bxpur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 19:25:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hNXg0x1t0uuN2l/fnnvsEiwrzol+jxrapVAiYBhXF8aws5OJasHenYSM6thEC/6NqJB3QqpsIrQa6wqcdtJbtpHyT5CxsnwBQuhfCHgCTArol91V7cGVgkQvSz4e9PHlxEq8ue2X1ZEZKI6HIc/P4x3HsjVd7ZulKqdr3Hi6GkmqrEokym7L2eGfVXQTMCjMjDv8Q0LBQGHY0Z0A2UIpXFtyUsdG7Fb3JfcKOY7kYBhJ8bzOQQpKq/Da+lCSE5NWQITSq77H7ffDNoxBMUYD/mgH+ruXIddwVXBFvmtArMJbfmFRvpxSMSg3e3ex2YGvInNa2QGjdGLPTkccqktUdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZ0/cXFRx91YRDhHZQywQO89MsxjqU36LpAn9j25oo8=;
 b=yf3U/a6VNLpusN2RuWVLBC+pkzgsC1FHcaeXEFPj1XL/5J8goOdIFS0u+Qqnf8nXmdZZhobBXPRqSAnf3xA4J8r6Of5/kIXSVKYWc+O0rj4HZhnLMWr4tLRsLW2DJXumNWKnm4d9Lts7dnBReBs6jGUGCZcTQLHplGqo+1tINjg6Etei5zWQsLbWD5UbjG3uiDBOvH8GbdnWmzheYVTrAMURsTuJ61qPJRGD4/W7wHSvPgITMPkbLSSFe5aDhvl9961rJo2d5bBQ20HqQCY6DeRKZOW5JFInib6RJOUMTHULKONg0QI7bNvYObzdMKhtE8gRyYDpsfJI1eR+0Kes7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZ0/cXFRx91YRDhHZQywQO89MsxjqU36LpAn9j25oo8=;
 b=yKnAxQWadn4Y6/XQ6W5igJImNfvSSrVKc0lEfliRxns4BETjQ+Kj1SDfpws00d24HJrkP79yeUhdl4DCOaw3aDoCpMcbdDfqbHMQhuOKHx0Za7yB6nKV8endjZ0335WxK42lOdGc7RSIOcb3qJ96t42NSLn6N/Pxn+xE/SKBmEM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB6993.namprd10.prod.outlook.com (2603:10b6:8:153::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.22; Sun, 12 Jul
 2026 19:25:08 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 19:25:08 +0000
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain
 <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: Improve style of pnp_device_id array terminator
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <096aaa981c0bf1aaa8be75e675f17b1c9ca0086c.1781102092.git.u.kleine-koenig@baylibre.com>
	("Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= (The Capable Hub)"'s message of "Wed,
 10 Jun 2026
	16:36:28 +0200")
Message-ID: <yq1cxwsdn90.fsf@ca-mkp.ca.oracle.com>
References: <096aaa981c0bf1aaa8be75e675f17b1c9ca0086c.1781102092.git.u.kleine-koenig@baylibre.com>
Date: Sun, 12 Jul 2026 15:25:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0299.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: da25dfd1-6e36-4378-bb5f-08dee04b4883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	avOYfdUNIFD2GPB7ucHhAfgXg5E6lGwfNMIw231S4rXeW74wiIt0qu6ZdkwCn3YVbSaH4jg5W4wIHDKZBXntsTxymUHONP4glBxwzJXp9ZhNDxUT3laaVY2wiwzIspqp0u+m0H0BA6IuMfy0qhCp189cgRhsJTzwkd+v4EezrHIvliZVEbEHsmTI0+cgJKDMxzWlbBQGKd+h726phgv6vFS/hhTGK3CbbElG/AQuXe5O9HJlLnEOwRvOsM0fNpANO1GosHmPccfT1xBCEhoqeuMAFpzzrbX1g4F69FT4Dgj/ldUL5+SapsnuwZlT7xtyPi1uQmF/WKNJ0KQi2DeD/rGL6XiTWtjRke/EbtYvDpszLqJ+hwSb90g3qCL3k6YO560z7js/BGcSCg/CQ826cuiHs1qgucKuNm+YER75I/PWGrttnZtYFpjHJtBsbI8Fgrycgz2OuLnHZ7DFvPm/RJpKQxXZBJ12yetPMJyJtbAmFAF5pha2wILkfwyH3SBUKb3m2t/ZTurdUPrQLZsnUSepQBC56Fqxmci07//8rwRL4dAeZRavquvjOpEsv7adgki4IeJFCZrqtbYm7dptwV8a0XArlwPcJPSpcGDBcAjtqDIxWIEXjGXz9SE3NcbLJslWF+vJrSDvqupBQ8ktCuQQhjd+A9PoCvtaYxlbyLk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HjiY8kr5zJEFJmEBRpSivVV9K/Jjxx95hdQcgVmq4k99+kHsuaJ4fDMg1+hP?=
 =?us-ascii?Q?2WBOgjXqytjqm/9foS2jCcXTeRdfImqRp2OeMr0p3B3/TehW0RDRlskCvrNt?=
 =?us-ascii?Q?7Q6DnxvF5vsXKvGdUwfxL4CloOLGecXOHaQ8POLKsvIzsdN9xKO2VrY1zS/s?=
 =?us-ascii?Q?hxQ0poKU8Rq3z3Y3hEr3JQ0J+QL45AiODNuAOcY4KWf7wwACiAzCWnBd4HjF?=
 =?us-ascii?Q?lte23qusW16JUQk4kmqYvG6678iGsS+d009+sUCZptAqkYB/Uzklvbon2cnZ?=
 =?us-ascii?Q?ZTrMSCpIRToDy/xknYnE/vjX9XX308ikTrp7z7MOzb/MCuWm9B+rkL7UjKO1?=
 =?us-ascii?Q?ndJf5D+3xs3Yc98qpqsLlItjY/db1MCuyWLg6fq/YGRvv0XMylfS0jsvCm6t?=
 =?us-ascii?Q?EF5gXlqH+K32UFDEgFtlCMpglPhFpwz5QqiH4H9T2e3tbMhWJvHsMr9JOv97?=
 =?us-ascii?Q?lGlXpLanYGSMOaeLZYicC7zQTSnBR9/SCBkYMROqJTqIrFIWl6zcl+/w+y6P?=
 =?us-ascii?Q?p1zlyF12CmuIHcJs2KlHPtnJtSm8IO9t3SCO4jCpnFHHtLTukLnIHY3cvlKq?=
 =?us-ascii?Q?/OWswoW4mNrHC62b2D6UT2r026iqT2fXSF2BKgwUy26+IBT+zG7CgTDAJpOF?=
 =?us-ascii?Q?KNShCP5eWWQ3iZrNO3ECHjXGMfHAF+FrdGEZEzRdSNjMYUWenxTxTaZWrMzu?=
 =?us-ascii?Q?q36ChH7NtJbzVdOfg+1w8VojXEKOe4A+4Q+NVCek2K6d7jtO3iVWRInjVWHG?=
 =?us-ascii?Q?SgDnRGGPqpuwmPFMGtQi5QVRBU2uux+2tUgJ/08m9JU0Ykdr3kH9A6BUf3Fa?=
 =?us-ascii?Q?ZdxE8qistNFl+OO+D9urNP++wP8aio+E5uY7ln+87RhSgMn001WIYbcb3NSE?=
 =?us-ascii?Q?ynBQbD/wMgL0uEtjt7t/jxvN/8QK9qYo6XLMCGpNn29ahSJP4q6wzSKieZHS?=
 =?us-ascii?Q?SoP/1jKuT1RjJVmvobpKajZZ68QDCkZrQFX5iYZo+/QvoL+ySTy9pSCZV1p8?=
 =?us-ascii?Q?FBqc2ZwyTw/uY8ZSYpIF+rXEV/+JRuiQIUFBD78ZY3g80fzxJ31wCX6xs53U?=
 =?us-ascii?Q?zWul6L+RDlp9DKk37S7dctBW5MvNJv+5Ozbeir9u9AEZ9O02+JoG1qH8BjQm?=
 =?us-ascii?Q?1c9Bxlk4hBiTVyxkG56ulSDRiLY4AgKkUXja+NMec+fyBPb1/F0hjVyV6FzR?=
 =?us-ascii?Q?xFsN633DZdT5d2dpVCh0OLIEYl2dilsGalOSENFjaMqQxb8ZAchx3icmdQ2z?=
 =?us-ascii?Q?5z0KLD0kLxm4t7358LYs62YSl8897EW08o07e87L023fQT3P+sTBhfmfbeaL?=
 =?us-ascii?Q?KEm7bJ6N74DNLKLdNOS4dlH1eJkRHBeXVG/GzlMk2KHOFG+Vf6t7fo6EQzfU?=
 =?us-ascii?Q?SxSIGIRQf7hQVEmsA4yxlZ0U3znP3emNTiYeV2t6iltm2MO98MT0Bq7kKIeA?=
 =?us-ascii?Q?So54nMW9DU8QTvxWy+W7ZBRiGEtarHndfNShDWdUgCJuvc2Dezx/qVxru/wI?=
 =?us-ascii?Q?58y4hlkrvt7y2mn9HV5tbucTtyazlJ+R0+IZ33XHBicobZFy41aoOuZXpc96?=
 =?us-ascii?Q?VgzLaSe9InPDRQOsqt8VPOt4IsE/e4Ljx8dWqfrYr2pQE4rxKPxH6uxvdq5a?=
 =?us-ascii?Q?oGkxOd1Y9WJ176EixZtiA526Sc2oCIIgd4UIV6FcOT65CBrr/dsBQGgvV7fU?=
 =?us-ascii?Q?OoTe0Dm/xJ0iI09EDesz+EtZgXPJzgetnO5PW1yawjj1XkTXEDgxc5hzj1jx?=
 =?us-ascii?Q?+bi3UYmtMPdgEjBaJzCW9McwTnVJ/aY=3D?=
X-Exchange-RoutingPolicyChecked:
	JZgIzRnokflzfpCYymVM9I58MpxIP//5fFNGYWekCfV0dvG8P8EXHluS1j9bSYLZtbBUe6JbIByuf3p7UORaVha/mpO+2pTkN4iFQ4GJ79Dh7ewaRUiC8VPnbheZZZbPlAlhTjMSKfuVAKNvMOgqt5Dtg9QywcmpqVzJtTRRz7dtHAEpSYAzhFK8wyK8U6JhYHJ+PmdzaqsLYHSiy/oC48HzVOWxrcF6wi47sVemaOwSB9yPDqApVkhim/h+j713NPT0x6qWGJw00AYcCjUE33RbAQWUtyqXpaGF7aTYcaoOUdfhojFn7oaUGOaCDw+gZZAz4BIns3g6fyB7CfIJDg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I9ZIbVNFEAQp6CJ/tzHlig2i4qjOcINKZuYbyqOo8Rasn+YSBOGpbooSDq9+X4z+cCDqbqravgVxOcjokmJ/Y7W+iDQdGYjpMMSGUisMxRzYzCgPkSqg/tXXYUJ8xFFREqlzdl0cpHtpvkXI5p12Utmfd1B4oi0VSGcz0rPryQBaC/o/vWCRZXxAfUWW9ZN1XIDsdxIB1PAYphcGcNWEMv9Tt2iAcLH7s9hlBpnabIErwZ4SXre/Wot+caTQYhC6cn6sYhpRB2Qk5ta0mRb0UWZTqIuPi5THC/1os0Fr2Fhhm8B94ljvg7tNOD9MfJTDU6sK3VABOelkjtVl75NBPZFb805gcfdN/vVKSv2xQKdw0+GyqAvzPGl21JqXPCyf+Ef2TKwrt9NN6u9MHx4he4itpe1+luzQ1j6fX2KPCQN8iv7q/m5cKL7Of25xbSO14IKn1WQKvlbHPREErYdl6vxfU8rP1dxhsJAULk0ZDP+EhRS+G/U+GKmdB6SdZmiIWN3efLuOlG6srXVmhbLL416cHIMg4z4XSlSyE3z0fJIIs3R6fn0aYXc5qqWi1FbFuc8GZYTZzCl+KVoVyLbxCjRYL4T1AgsTz/wd5JJfKLo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da25dfd1-6e36-4378-bb5f-08dee04b4883
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 19:25:07.8565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3ovuOYawtbpP6Tbw2oi9hmevcdr3i9HzxxqMJIS4Cmi5jLwrh/m35OWFW5oAiAAwKyzBzEggEblDyDL4rCLGwDnsOO62MVzi6R7gwG5d1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6993
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=448 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120208
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a53ea19 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=uALulf2T401AiPjdZQkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDIwNyBTYWx0ZWRfX30GO/n41zENv
 mSsNT3QfIFyMiPz4i5/mFrgH/MpNZYs0uL511ZFAsS/dgyYFUKEyf2WEBJlr7TVaZ1/Y8AFt1CE
 afMUPHDJx/8p5LkEZktXk4VzTMjjCyqqG1Vmn09YuTH4/I/RqCbbegbwG5SeM2gSg73EOB82qpa
 r49nLKWUUj+Ciov0JWm5hD6xElZ05VFLVwuR7iK8C2V7jURSmPkpcUaTxjuUx0CbxBAOOc6IuYy
 zgQ05PNmbGVS7wUHgHxueUPkKQTZNlXahjNM1jhob5HBY/u9gNKaJjgt/MYa2Z3kx5Khas3QnD/
 mUJwxjgDDNJyruogjEAe1qtn6VvO8xHZTGDWvEMMtg9wR4mNC5AAB8fm7h8B6eYpZ/uYCtfOcJv
 oHFcGE6pJRyvnntVpeHK9Fjdm8NYCYxtJSt69AlhqjiWs/Zn6ZrW+eHZ4XBNlp1PiTNsAH+yIDz
 wUhFOJSnqLNfxM/GvTQ==
X-Proofpoint-GUID: arqCD6MjTdDwaC9GdeeWNBMrYhIkYmHK
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDIwNyBTYWx0ZWRfXyKnkso++0CIr
 A5GjkF4xhLo3CvcXi3GUHXXvdC64TsAWhFgU5AHMqO2jgOF9lj3dNgsyjVNSI/anv1MG+x1iF5H
 lfb4/NP4HS2O8cThRtmaC8Kj7wjgHuIR/IHA8eAWrBo5HUORkOUv
X-Proofpoint-ORIG-GUID: arqCD6MjTdDwaC9GdeeWNBMrYhIkYmHK


Uwe,

> To match how device-id array terminators look like for other device
> types drop `.id = ""` from it and let the compiler care for zeroing the
> entry.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
