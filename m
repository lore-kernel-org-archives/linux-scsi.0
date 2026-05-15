Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFAE36AB4D;
	Fri, 15 May 2026 02:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778811005; cv=fail; b=JNqwo+0j/xmcolbiuAu4dxt9jA/E2XG9HPlsH0Si2qLLpSDdWyvVjwfmquVduUj3caIMsY2t2o+I2JeheIwxO77w/sgrvapsUVLI/IhwFB/nH4tM0zlqZTc5CPUzJit/ndUbCmB6Oemjkgq9dxCv3iWBI49KCTJ9Ph9Ghey5Vzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778811005; c=relaxed/simple;
	bh=gsyCvC8BsQvAkA+BwQxNpeCNYAhny9gTzCBuYKSyNuk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UiGSuSAuy4/xUiN+UAB2knUm/HbSVKqFQanKJZ1PFuE2yKVAnIZnrk1eerw096rWK2KvGrT/nQUbvwMvkVEqk7ZIQDkgJvRJOM+f39mie0ttHUzZgyvO3XPa6s/IskZvcxqhRWn63iwLCg/rDJ/d3Ooypr+Zf+HQvu2shNFFWDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k5ibhxCz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=buLO2viB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k5ibhxCz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="buLO2viB"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0TJ7Y3368038;
	Fri, 15 May 2026 02:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=J9TAi/r6f4I4r1wF22
	0uzQr5cBzYzBTf3UQfAh+pCqk=; b=k5ibhxCzBWyP2oI8GGZj2j5g1iE/wUzRGq
	AF6HXCI4SYMI8S8F1D4R/3m8gIr6fKdCGiLjz38vYAYyCLv8nhnY4/fWkpow5Bby
	skywKrzOkyDBj73W4U5MWGEs53uTicg1+/DG9keMINGEUifZPPfHRD3ycM2jJ0Ag
	UJqtRSJJqxcnSMV3Jr/yT8rMMYUL2TWBn9nPJzeEZQ+6C9n4GV4vuL+K2MEDGSuH
	zOGvHEXqas7B3p3kzmwObHK0nu+pZwElzUyLTzuX6GjkcR31wA02je9ht81Fv3mP
	fugqO7sIV2SL2A5RN9BaETvELZvHOkdxJU5nwkxaR9Nk5JKmh++g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1rge3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:09:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F29h9B026205;
	Fri, 15 May 2026 02:09:58 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kvx4yug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:09:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U/ZtHBX9zg/G7QiKwAzb6FYWgJQQn4iSbKaL61nQ4pBbZeV0K+JNcXRvumTvmSfVoI1N5YaxR2FDUoXBrBjUldTKkZ2HAh9/JWSG+YKgZopDWQbokq+zbWF/IpwJj276fT6YH1hMHMziDelg159weQ7MFVUnzqLaistl4lqVV4rnqEE/CeXd3nm/o3PnYsDeF2t4+PEsKJzaj2NaYYHyQ26zNZxeCxzS/Gvm1vp2rYsvYippIMGW6ETyYMj4YAV5+3ruHRmVURfjtBQBRWK9rVUtk5JJowqfjiwF9jDzOwJ/pzLB8zQT8yVqX1hn6Fe3o/mhk//QkHnl1SkAO+7JBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9TAi/r6f4I4r1wF220uzQr5cBzYzBTf3UQfAh+pCqk=;
 b=TCflgQo7lo+lTmbZj0ccKg59yHmgJ3p8pWKpjmxuN63VahrTTRS9WoqJTXy2I2EoissvTYpWgD3uiKWV9gER6NDsTCxqpOwtX/Pmi353l653xyr+0zYjqZstaFy0rgrgiY2oGka6LJkvQ0g77Lu31ItDWZDT56e5AfUnt16ZV48SP0XmCfmKyVWnn88UhgLGjbf7dKqcNh3VROUlJv37ZBCvhIre+kGHOuDrJ15zeEkQ8WYZl06ozIhLfuerDY0z1FXh+YVZ8MGoDf/UByba+4+WX2gMdKtqamVbrjg+cu0yo9uQXoXBTT8m7PsWTAF1mm7gxixsc66nCwOG34oZ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9TAi/r6f4I4r1wF220uzQr5cBzYzBTf3UQfAh+pCqk=;
 b=buLO2viBetCtAzVH6we6NgklqWMhjhE3zu+Ny5EKLPr7TYtqh7Ivj8RQudY4h1K9UlLRDqzaOVSDr3KPaYrEDptVNG17koWRsn5L7dO5MCygZVApBPaok5NFzuZSUMWp/RO3ggcEKF7VglrzgX8wdfaTUix9RW/pzV4r4BMr0ac=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 02:09:52 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 02:09:52 +0000
To: Sagar Biradar <sagar.biradar@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>,
        "Brian King" <brking@linux.vnet.ibm.com>,
        Don
 Brace <don.brace@microchip.com>,
        "Raja VS" <raja.vs@microchip.com>,
        Kumar Meiyappan <kumar.meiyappan@microchip.com>,
        Abhinav Kuchibhotla
 <abhinav.kuchibhotla@microchip.com>,
        Uday kumar Bagam
 <udaykumar.bagam@microchip.com>,
        Advait Churi
 <advait.churi@microchip.com>
Subject: Re: [PATCH] scsi: pm8001: reject firmware update in fatal error state
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260416153757.414896-1-sagar.biradar@microchip.com> (Sagar
	Biradar's message of "Thu, 16 Apr 2026 15:37:57 +0000")
Organization: Oracle Corporation
Message-ID: <yq18q9l5sps.fsf@ca-mkp.ca.oracle.com>
References: <20260416153757.414896-1-sagar.biradar@microchip.com>
Date: Thu, 14 May 2026 22:09:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:610:32::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f6af655-06c4-4939-8ce0-08deb2270cd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|18002099003|3023799003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	SprMRG+5ZIDifSOzE47DUeo+dXYK0wa71nXxZNt8GWjJzzvQJpjVOOvgEyOkEz93v3zPAR2ZWgom5BHigH2f71ErY0ILXOuh+ylNPqTpi+aLZJQqaYG2e8XPfyZJgzBhhk1V+sXU3NZD+BpeVL4GGeWOOQmUWpnSQ32ZypAkZPHesEjn58VxuhI7o8I16nMNxI/nLMJkbjr9BalD9GvwyaMkWr/r3zHJnYJVMZvn01SrXFtjuKbO1odnXOS9D8FHRIWCPWYcRqTyv3LQquwUVs5Qc4sLcyfdRy2bGd09f95F6w/xHjOjs9nOebt1WSAeyGsdnY1KL9/yDONEOfDALJi96tltmoFv0VrIVrfLPbaAQaseaZ+f6xFhZ/O4sE40ulZpE2p+t5fCu0mfH/1Xcorn3/23mcL0LFFhC/pHhrxjrrYX8QjqzDBePF14w3Rv8BP3X937aOdrsDsY7GhB99cU50QAHg+A9pplt38LVTVjnZRj4Km5HAHdspgeBZEhQpy6VGKE5uqWGTsBvdHIop5pq4Pf+FUsBVv8MM40ybPIddosUKf/ZooISFK7iDfN9+1/PXStIx2E8hOOauD9BkehX2rfGzffposbaAt8p1eNAGwfHquW8ZguNzPuSvs4+qoZu418yF/NS1t8LaP9gSpI2Btq+RpDTSN9JRD0TWec1hywrW1+/l3W11yjbBjE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(18002099003)(3023799003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YaEf0eaPPJJpdGLOvfg30Gz0PDpFMn4c2MyGF5/Uhc9iccncoSnKM7bo6fse?=
 =?us-ascii?Q?ZEAqdDY99EbOE5soND60JlXPQhMcPpuSjAaYTHGzw4a6gjVQpzsByFDbiRXQ?=
 =?us-ascii?Q?XEbnb2V6227tQMsjvVq5dFmATtSzdxBcUPzz15c0GHemm8RI2PCj2a7UF3fc?=
 =?us-ascii?Q?IZ/6XyBKFNwTrQdQSPHsURyi7wqEmqYvobFbY3O3uEtBh6lLMAnmQDTtunBG?=
 =?us-ascii?Q?hpuQdMnpcWNUCiwKe3eENlMye5QXeeh/B1c6E7MroSCabPBb18q1eSHxg287?=
 =?us-ascii?Q?yn6QH9Tix7wRXOBQz6MiSBumpQ7pMpslZQ9phtzPCE/SZhSGlcz8hG9M+Nyc?=
 =?us-ascii?Q?3nPmOCEKERMomirxlUrg1l3d2scqi8irjxEzz5tOYzAfriL7QSU787rgyS2J?=
 =?us-ascii?Q?N2iZQN2Fq0qxEmpFnotsdhY1XEjF+/jlEQ3/6+0DszZRXUir5kkjMmLAV752?=
 =?us-ascii?Q?s9TMZ6xX+r4eyUcjVbjq6FpEMJ2zV5EY1TzJR8cHIPgLiONadMlag02ippRr?=
 =?us-ascii?Q?zbjEc0FV8t9saBMSr3A6tF/DCgs+/uVNZP9C4ylz1QGYYeO4EQQclrTtD1Eb?=
 =?us-ascii?Q?42TbZ+yWCsMnfNzLS2qT3rA+3hmY0PkEaFWdXlgeG6doFCxezzW3x5f3Mk2r?=
 =?us-ascii?Q?U2qYNFdpV8EoAJO0HgbdAc5v2n0XN7FMkKmcejaJQBlGuC/mkdbflK/pHtXv?=
 =?us-ascii?Q?FWHvsCvpn4K4b12krSKPcvfyNyskCSfGsoI4c52Eh0TJINFiuOHJJwYtwKl6?=
 =?us-ascii?Q?xwCL0Rl9lBk92GfGr+6PKjAGAYFLKNtKNCiETw69K8Pu5xJMKbs0ueW11LHB?=
 =?us-ascii?Q?3lQYKm6POlu6C9F7aD/F5Bj8pO4jzPS1choWhm9/nWi0qdwQCwfEdbAYEsBm?=
 =?us-ascii?Q?2bidljBRQENGBP55UPlrB58uNu+MES09Vh1brHkOTZm/BwTmOywltbgINzBV?=
 =?us-ascii?Q?Y09G80Cp5vX01pQBtVo9S1O06nMXndyMOPS3JLrLjV0tx/ya2TjX5/wRTT4l?=
 =?us-ascii?Q?Q8SV1iZB3mxt+Y9atEGU8ZJ9vVpmkLbXGwlxgEo1IMbCXQtO0Wf+eJeYNMVB?=
 =?us-ascii?Q?pi7MPIsql69CQz4VGU8Vd+F9R/lP2Das2f+MssyxKfvuEXQymUzReEfA3ic6?=
 =?us-ascii?Q?IFVUexL9dz0TK/7tBQdVaxFbYOPrd59FqZzGVrmQSFvUoMiw1HwVi687e35d?=
 =?us-ascii?Q?Oh09W/i2L8/i1e7suWVy38y9LI8DAUXjDeVwB73VsukFra0IxZkQsbS1oBzu?=
 =?us-ascii?Q?A0y+dcOHYDhT8187VcmZz/SkpKt/wK/X8dV65YY+ZMXj5+IXp3R6g6MsmrCx?=
 =?us-ascii?Q?Y97f44kSf0BREAhoEKO3eZRBu/HvAtxE4sSnfJKa5xfOHcC2+XPpHgFWxn0U?=
 =?us-ascii?Q?i3yL1TcVW4zAGEE0Y3YIdqowlTPr2viCcuv4GL46pHZlgfLemQVcGIkZ2fhP?=
 =?us-ascii?Q?prPM0l27QmWIuSh5cVpgEI1wyKmQHjQFLP95SxdGHZYyjR7Li8Zl/nNh0No8?=
 =?us-ascii?Q?SFIMPt74oHtMBeXZbKXgRvOvav4E9A7jEBsGtow6mLjRd5aVN4fociwFo8zx?=
 =?us-ascii?Q?feXO6riLSS755srVKIa1W7R5Zzg9WJjgHZRgMIacPsPw7pGVp0s+nG2dRLbk?=
 =?us-ascii?Q?hvbHJDHP8H0X/mQ+5EN8qgb5jC1+xWI5P8Z2vkGbE6qcktg+PWC4zHZgBKwF?=
 =?us-ascii?Q?+uwJdFA//Th7NZ3IQNhSoRy2bPwHqtichC5JULfngcJxRkAEalWowE82/vlQ?=
 =?us-ascii?Q?8C++iNe/B0Ri4oJWRXYap7mQln032IY=3D?=
X-Exchange-RoutingPolicyChecked:
	KvXnDKYeC1CZCUhudy28xOncTOg2AXKJOuwPbr8g9uUX6VejbPqKpz0+Zig1L4TE/dKT1n2ZjcBNaLq67Hkj8pRck6MAbbp5cEqKDw363ez/NU826OcYRd0//p7RMZ/3tQRYeNB7X0ozZZ7wtrmZ7gPDS53P7FI15hju5Pw2/5nNdGchTiPUN9AGVlnSZ6mY3FW1NXrxLSsCeljQco50zg8wuoju2XSn/7pnbUkqe51zVjjgHozX0fArK8RQ3qOe/rPlTgIQkNBtJdoDmE0KQLs/75lfqInyU/9z70ZQzk16Kngktx0y8TEyaY4uUQXAaqvnUnUGnOnQLfwgNV4mzw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TJUqY07hkfJ09cm8/zUY6+RhQzeLt5yzZPKZt3iG8oL+LBCCPhEXKcE0fpqBTJgEipfxY6zmsXoewJTJmXI4iDW1RQ5xgHIsVEaQztoF/bl3JwZpxT1jlCaRxRiOjybyLNf4a4PyXsshdSeb4cezCIqStejwY8kgwt0mqZ6aJLOJlyn+4jicE5jZMaNPnkvoLBoArt3830GztVll0Yh7D+vhAxkjosmp0nOQxOux5V6QnU0iBDtG5/pjPm+PJh4+rirYAaCV9H2M7B7jGnLrmtW6rTngzvR5fPl9i7s9t2Z4BUFNWDePZqsMfFgbF7+U2V4k2SXnIDc/ElNPnz3tR1tIKtirk42+5fjohQfnztWBE7LA80vPUZ3K8xHn8Ta3zpibXJ2ovMVaX4O86FLA6ngnuKimfAHR9dptb+a/JovXyDvRjIqvKwNvdjWQUfiYjEFcL30Fj9sYISlUXM95UmYVn6VRIJ9zy7ZkhU45neBTp/SxNS0pz8n1z/ye53CUqPzkL0qCqxeErS5bkKBwWxReeGQvzS8N/AxLbCwR81On+UUp7QBvCNvzu76dIBoAWleM7SRDdJl2JMDCHkg8rbbKDc2wVm96Ev9Q8rKOmMk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6af655-06c4-4939-8ce0-08deb2270cd7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:09:52.3183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBVQ7hHJF/6Djs+rcQApffmsUWCjtGWF9nrsumQtzEejhU0rionNBCPb+Yd91DNAyO/UVppCyB8J26zbGqWzz7Evh/5FRxgrPoo8n42CaXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605150019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxOCBTYWx0ZWRfX03/mTVDvOWWP
 TByQIMyoj6ksQ+F1SXV5XA2R5HCTyCZYr09Gzq+DQ7yzZMUnlFTApsa2if8YY+bQsus+lZeYod+
 n0GpjomgmHuxrTwwrm9ZELROaEkYxdAKMJswghMg1pjMgWtHGsTGOI0v7GiottRYBAWNVzmCgFp
 7Rs2lt060AnvCZWucHm1657ttBFHOcl9olFx/kxbicCKUbD5+twsT+mEBJFNGh8DwI6qEpG1U7n
 yNYSfTCD1DlnmzqU1hD0urLLKpKYSogFvMvoIO+Zmuo8o/rNUmfA4TuZ6YznWCrhvdvsD56v2sj
 7e3N+/AJv3fZwr2XzovjTWUG6N1I2HZ/nGmrmB7HpSuThkpJyXxVYlsKQOQUUlVW7jCLgS1emeR
 Yosr1smzXHQ52cnetRcN3Bfnwh0zt699PBWiKvbJitpObZ7NQ6XecUJ5QG8rnnCbZk8xCtDIoNg
 HD0/8OMkTXr6sSmNA+g==
X-Authority-Analysis: v=2.4 cv=cfDiaHDM c=1 sm=1 tr=0 ts=6a068077 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=_rZmq5vioulwqW56FrMA:9 a=zgiPjhLxNE0A:10
X-Proofpoint-ORIG-GUID: knzF8j24H81ya-EguNMxnr7JBdMSVYSo
X-Proofpoint-GUID: knzF8j24H81ya-EguNMxnr7JBdMSVYSo


Sagar,

> pm8001_store_update_fw() allows a firmware update request even when
> the controller has already entered a fatal error state.
>
> Firmware update is not valid once the controller is in that state, and
> attempting it can lead to a call trace. Reject the request early by
> checking controller_fatal_error, set the firmware status to
> FAIL_PARAMETERS, and return -EINVAL.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
