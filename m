Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A30F26A1A4;
	Fri, 15 May 2026 01:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778809253; cv=fail; b=Xs7AqMPYDDWjpE2yyjDJF32qN8kX8P4py1fI5ys0cHvtso/Q9paPk3EbPkcZWGxeUAv4Ju0yR1UJGjDQW1yQE6qurr4bQ6Aj02gWlIUNeIiCVgyDtfC0uOSRn1p93WBf9CZIIDeX6wEkr38sKBjofeMXxhAF6pPhLOhBJp1ab0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778809253; c=relaxed/simple;
	bh=Z+Qu+A3gi0eQkc2OrE61TSRt9zFJOmWhhpAnn9kMND0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LZ4A2dwgk+z061l5cr5RwcxVc/Bp2KRvjtEh68/qXf7EQ4L2BSBKwWmmoIksCa6fHcbZ6Rq+WaVfnWRF6TJmm9Zlqgyb8QQ26xpFzARVD/BSHb3DaiYfGBmytZ/818X7QFRy6mT6CR9GFEF0J+BpaVh8feluggQHOu1V0ymBQK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qTHWXvpW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y/3RPDd8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qTHWXvpW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y/3RPDd8"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0SOaq3650540;
	Fri, 15 May 2026 01:40:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LQcMi1urScQlOSYjOD
	3LoMRJSJ0WEB2SFoQ80Ge6PTs=; b=qTHWXvpWOJgLj4xI4/XYT7BSTlWLXtnyVR
	Cwb7nvGI0S+Q/Nc6wMd1G/mpKu8gFLtnalllOaPtExgwq7HAYtZWM+0dVTKjR1CM
	t1p+Hkf32wOCujy5Mg/XOutI3IZ+qm5lfT9wOXGWOaVjwzqK3qZFZiHib2KxKRWd
	/C/h3wGIxshNZCiJ0ldGkACc52rJJT/FpJxTb8LqAx/0jpbHp8mWiM5P8VARuETW
	bYDSuzq6QkSSuejQOdgE1Y/6mblQGPi/zCOxtiXrKwaLdnG4g+PyaEffQJbTafsd
	NXRg75GBEtHrrCcM+qUEv5YRIXCRFc03EGlE+fK0BEz1q+97T5pw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1t0d7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 01:40:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F1dg1M036944;
	Fri, 15 May 2026 01:40:38 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012036.outbound.protection.outlook.com [52.101.48.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kvx4bq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 01:40:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PKwKSOzOWSQw2NasAhVplRbLdWl5BVjn7rPm7Un3BVGiGhtA8icHGpcJjaMnlD6X9sIWJ9rjeipP1sLj9ueeFt/Q3C3MAdTv56HVKqmerrcpbQiDGyf67YImyn8Sfj0N0gYaEUI4krAlgBVh8mrkP464O1KkLbDbAb5JEyP7qcHBL2KgSxUCo8FoTo+81EVBLFceITeJfkPyx6eMsfukpWebSD2tIlm5b851L2x5MwAFac8hfW0wXAe+YTXuB0spn6mR6ojf1RKXPSI+kiAJfNUQqvn5t8fejtk04JeSGz9OQ6C52/wnV6ywUlOKiaF+yVoYmgTmb26EHjU0uXYicg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQcMi1urScQlOSYjOD3LoMRJSJ0WEB2SFoQ80Ge6PTs=;
 b=zM2ElFjCT5S8eVpx1/4x0ESnO4t3XRrZk7H+Kb42Cs47YkSYMW7O5JrlFpOTvZkRD3xr8swKlpMv88RRoO4MqxRps6dqFMOKM/UBfZx5+WfrEHQuKblsF4Du0uZDqn4HILXK1RY9vbFuFRst7nduZwYbYTPvBocZcO5/Un8cBk2eOmA9qtbFdiRmG+rGHTNK8Pnx2FV7YX8TQlotbfni4limswMVUSBbaYOlUyuhvlH+cXsZDNS0YPPDNZlOo+3eG4yF3Ecv38lQ3EwpNSgY1LeHZscTxEkTpUxz1a3l5ZJoty4uEGCuYeK5VwYKBa2SeVm1MG4htFPSxQ8q5tmG9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQcMi1urScQlOSYjOD3LoMRJSJ0WEB2SFoQ80Ge6PTs=;
 b=Y/3RPDd8c2BR0sUEv7yS+l81b/92VjfEbAjRgVLVxoJs8tDNU0CdtEG8+zJ7phLkoyKXr740T2FNconaLOR3Y8zJ8ljsOG8VPO146d41AClA/kTPuh4LubFBbPpB5y5rVMsceQEona+u9ggNHqAd4L6NJVtfrG6T/WrAsaizHcg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4924.namprd10.prod.outlook.com (2603:10b6:610:ca::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 01:40:33 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 01:40:32 +0000
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Peter
 Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo
 <can.guo@oss.qualcomm.com>,
        Archana Patni <archana.patni@intel.com>,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ufs: Rework pci_device_id initialization
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cover.1777968942.git.u.kleine-koenig@baylibre.com> ("Uwe
	=?utf-8?Q?Kleine-K=C3=B6nig?= (The Capable Hub)"'s message of "Tue, 5 May
 2026 10:25:43
	+0200")
Organization: Oracle Corporation
Message-ID: <yq18q9la1s4.fsf@ca-mkp.ca.oracle.com>
References: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
Date: Thu, 14 May 2026 21:40:31 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0148.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4924:EE_
X-MS-Office365-Filtering-Correlation-Id: 130b69e9-6c95-4fb2-0094-08deb222f416
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	u5raCZDbJ40cSrjoDYAz8Ei1lYwgfp1ME11F1NzJ9DpJOTnaRd1NZH3Pm59ZYWBQqGZ8kHq+pqRF5T/DYXPO3Xfrw2Izz3MzxKDcM6TVaDCKvJlweCaB93H+suTJVoR19TNw03vRjK29YHceNZQNepvHINzIqyfdKtHuHRzvQkD7SHHAC4a7/kLu1B1+7n6HU0yGd2S6ZySt4HGN5Y+7PgDZK2MQvidWPIIiesXm5+E9lwEQze5gLzZKS1tqQ/dNx8BhxhGO9W6uvkzIYZkJiUAJNHmr0W1DbCUP5Q2s5Ms6Fy9c3MEvNH9wU0eGQ+9ELUMXnnB6qn+X5v6XY1Bfhcag/MqRILiByqB+twJXDYJEmUlUzWhqUf0vJUPfEokog3AKGnnNiIWeRdP+VzYeO0VJ9cdUgjpM96l8TW99egytmMYAavn7XkMrB4DEugV9znxtQ9FlowV2L+1vHqTanfTkIpJopiPlqxV5jW36U+cTK7yZp9ibEC5MCcXUzAS0C7V9oIlh0sgNM97HRo6+by0I1ReQpnaaXNupG15xuyV86UuYP9K3vhsRSUsy/Hstkc4AE9RvrckSyVXemtQrQkMXLP1PrTi0Al8ZQ5j2KBNC5s8tjkmuudFMLAAIH4ggg5Px+aTDVEH5SEwuRDrQSClm0YJRRT6yeadhx43ZT5d3j3K7Rguwe5N/3uUa55P3dMaceJkpq2d3EY6BjOPTeg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cNNIhrKuLEWTW/CS4X1D9I3kC4E63atWKrID0gRspaMdefx1wojLqxquYsS6?=
 =?us-ascii?Q?bebxcVOVLnXIkQW4ta6pcbBPKoIJFVanGm5tmPw0JzlvLIDjHO0q0/Gngaz0?=
 =?us-ascii?Q?ZJftAY7ohamtcJk/lCkyiT+vMWca9uh54nxWEHGsLVFwh0+7f0Ah2L5+kmRx?=
 =?us-ascii?Q?v6GVavq+JCI4+NsjBQRAXtz5PeWiaRt9+ovHlZPeOWrwL+q+nj2UNwu7+ywj?=
 =?us-ascii?Q?bXAR2vJ96skzGiWbc98Vh7pkf1p/Fgv77AqFK1PK6OJ8rxrUwJuU1tXkCpx6?=
 =?us-ascii?Q?2aEF6jPF0tRvuY4p2RivIxrCMWsY2QS2o8o/LJLXjcMS6xgQqyhruGGXzThF?=
 =?us-ascii?Q?bE+GVgRd/hxXmdeDXgo13+kOiOGw4TDP5DC+Zz5HmzqxpPtlLJ/w3vTke5EZ?=
 =?us-ascii?Q?jubzrH4qtyjjLZhDYyeRxr5MFjKA7Ouenxgd6gszMH1+XaBRuywALYcj/reI?=
 =?us-ascii?Q?XCf+tiIcXP5skoUvN5qxJEPhrBfsFBInJgq1qBBpe4MmapJNxfWaEZGW5ueF?=
 =?us-ascii?Q?2RjDF+6KmetuBlserXDszhWqgj3YNx/c7SkTN6FEUxNTADb4A3WYn28mSFy8?=
 =?us-ascii?Q?i3qc4mlGWszPYA0pUhfBCJZq4JekXrs0vD0F+7GVdzb7SYU/bfRmjkcRLA0x?=
 =?us-ascii?Q?LTcrnBzB3Spi6pTk4r2vCvxabhRG6gPbS07381osEsZL/nkNqr/0aPwTyUbg?=
 =?us-ascii?Q?0ETw/jH+pteHKY9RlvS0Wcz2d1IG6jXB9s50iilx8TXWSdhavtPkyCiCxix9?=
 =?us-ascii?Q?SvoUaacmz7l4VQpSkaG3B+5Gc4jsVku97huY2sAji7imlzJDuD9oQl/Z3r5U?=
 =?us-ascii?Q?1bWuHo/m/gZ33Crk+FbP4KkbPafR0R3/+NZDUsVk1FxzIFWstRSXa37o1I4a?=
 =?us-ascii?Q?ipKZR9ScUSeUOPMYCg+boHMfxDlpl8UQJeoYsx24lyEwcrkivrWx7nvGjWPF?=
 =?us-ascii?Q?X1r6vTbElJUIpgLf/os4qCjOGynjF6PkAnB2wt+mckmkhGYVdIYVB8Bii6om?=
 =?us-ascii?Q?BQovJ3bVeezEufdCKsYiCCP47h7dAJXLfsNLhUoUZDiRzeD0XLPiBAo3UHJ3?=
 =?us-ascii?Q?jj27RyzTj+pEIUMXN21sbCUayGaQrYBbHYU6OocHV+qnCHps1AFK//aUGAmk?=
 =?us-ascii?Q?sLKoCUoXF0tyUfnSNOWD6eJzAixdPw1Z6cySD7pcEJ/tgpTHiixgYMy4c8t9?=
 =?us-ascii?Q?2/Ih82Tx+16hKea3Nv9Tj74pJVK3FCUV70QegFiq/PuwsXpwXazDaBKeUHHZ?=
 =?us-ascii?Q?QCeLeucf4m3HKMvP8MNt1+O0aM6++SGc15/IJuxAYi4zP3xlMQmzNxDK8OQa?=
 =?us-ascii?Q?EPTWeplT6PRJIiwfh/nMfTwQ6dzvCVGPZzfgI6L3jHBn3uBgNFdEPC2BvkKE?=
 =?us-ascii?Q?shNDKeiri0LPsygOglehgwrV654fUO9uIIEeiZ2wuyGVne8FtkpHMIp0TEHE?=
 =?us-ascii?Q?WuNIR28nvFQ26EIbIwkdK60OrxPdgp0yryJbgK+/L8FUfNhirFO2pB8+AoH+?=
 =?us-ascii?Q?Xqxc7qBWsyy1jp1ux/zTXD3sbF+O/dKhYvN/MwdH1arSp/Mg2KLT6tA6By3s?=
 =?us-ascii?Q?2gPWlQHzXp1dqhobC+EOLmAAIvjkrbUfF6iOfmmGnhA5uNA39kBdfCL60uAa?=
 =?us-ascii?Q?i2NR0uxUSBZgdkYxLt63LSRViFXm2+//xq+Q+jy2QQX7ltZEwqIobpkK69RT?=
 =?us-ascii?Q?FL5loGKz2fmpnGXq75Jkiyf6NukpFsWqyHVLJCcR1RVV55wyYPwkZth9U/lR?=
 =?us-ascii?Q?sXDMY6QOAMbUcIsacaEMKkv3e9fAXEs=3D?=
X-Exchange-RoutingPolicyChecked:
	gViRXBaLqlngl8gNHHMkpMeSfW1CxxlOfNsTtF8Gu/OByjRRP0r3GszNpR29yjxpqSaaptLYUewoKXZjuot+vr7phOEbd7z94ugmZAK4E/55OGOHS4/KZxenzIWtkAs09t1ecnMTctinXObd5o/cg9npgDXhB78jhTIrDxMxuNQkwLSM1GufqRg70aVjcpyStHQsYY0VapGoeBv2YrAtXOUvmbqT8HVxf6RfrahAxwPSGMajwBZrYBFCU6Af56n5F2BYZHa6uJE8TJZm/A6tnzzSqcJyZlwL1jZCLkEZsNTGvZRX7utxORpmI6FD8Wxk07yo5IyXstWFSFdxwtpZzQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dD1k4F1jmUdLF6TX63F0JNkQd3/YGDfUNFJup4INGTeTj8jxldoz8rP8HSzQFqMhsDaipGJXb6vlZ4O3sut9Q6Tda+hq0ZNhWf47jRtbJdsUPZ+mAjtry1J0nCgvvL9az5fexjH38V4aA6U2Fr0tIK/FqxaG8HSdVjHE42p9aBBaIeeZ+wQCIRKqGW7qTtpHHyR419mV7GAKrYQwYLlhO/dNaI0uo7NZvFNLPBOd84upAUXiYyW9BhsQubTsQ7vbK/AciSf9cnQYGXbPd5EeoA1wYw3+ImAo9ldyfvnZmBcSss2orBOoO5elJzaB0aZJ/P89HiIsquXNNcJ+/ELFDURbIkBmTtWayTeX9rWreYiGNylXlMKa37XeuMRA23leeN24gTszLgg/ig/wOMgwQ3jbzgfP+0XZL3v46wKcvjVZwyA5j7ppwIMQS7wKM7w0OlHLZw5RZmIXK/wH4BMN+6Jmyg6AmeTWn4GCW1qPRjZj74R0UzLSpeFCXPMpMg2YQg9V30qyx/5f7ELMqySSuokj4ZDvle39bk2KtBFJnXhrVdow5UK4oCcyw1wjvdA4nfna8k8/nm+dmtW0n8t4U/RvP9euqI8gqPDjehiTXhs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 130b69e9-6c95-4fb2-0094-08deb222f416
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 01:40:32.8250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5RsNvDSMQ36//JcfNFX65LLks4RL+VWVuz+b/Rg0BdX8rqh3jOcPtfAIba4fdNXYKQ1ZbDCWLeOaKu3dVfdDNvhAbGTAONui0I/A6Fi3aJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4924
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=775 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605150014
X-Proofpoint-ORIG-GUID: sLQok4375186s1_q7eVs5XkgJgQCJWRU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxMyBTYWx0ZWRfXyF+HMDmhdBbe
 4WU+6CEnG9vGeDnA8kfFQfAPz2XHpugszCyrFea6Jd7BFqbD6r9nhWAfFEqhhp1YQi69cYssw/D
 PEulcAd56CH0FxbTHgYejroq5sdUylU9QZJbCbteN8lWQRzc49HJgfpBNWfEgY0t1DnwIyafcdf
 V4gCmzFxEpYminJ2OzHMLwNFy41zNdLrcBid7u3XusgaIuHryIMCKtx9gPrrMpdIT4WPXsIuR4W
 ekBAeHSirbEOmmjHmG5Rh3Rdvt2k5+IYERDqL3jb6ED8HuBgp/Qv221ln+p1GyLv45Ngj4EZueN
 lQpNYgXXpRKbUfnoWSlu6a04TsaAVn1v/ZCfDuIBqpOEheA2x7HGLpwR25vBGiYg206ZL3VwjIi
 oQ6NDNiPDbi7/pBX9zmDq9BvUxGBnTiT3cZHoS87UHjtPBr5lMklFTRHQjUfxywWBciz7lPrys+
 fyAiGDZuMbET4vMOx9Q==
X-Authority-Analysis: v=2.4 cv=Zawt8MVA c=1 sm=1 tr=0 ts=6a067997 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8 a=IpJZQVW2AAAA:8
 a=-5ljeZG2g70C0efMZmwA:9 a=IawgGOuG5U0WyFbmm1f5:22
X-Proofpoint-GUID: sLQok4375186s1_q7eVs5XkgJgQCJWRU


Uwe,

> the patches in this series adapt the pci_device_id arrays of two ufs
> drivers. These are preparing a change for making struct
> pci_device_id::driver_data an anonymous union (similar to
> https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylibre.com/).
> This requires named initializers for .driver_data. But even without
> that this is a nice cleanup making the array better readable and
> consistent.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
