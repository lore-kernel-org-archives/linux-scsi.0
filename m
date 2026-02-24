Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6724C2BE62E;
	Tue, 24 Feb 2026 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956964; cv=fail; b=fFw79XPgBnfp+d/pfrc009qdEBpDRP6xN1srQv0logaA5TdWIDQYK0UKdRhPYzWUFsnZLAl02ncei3ECxBH6Sou19xabL2AiqhjR7dVjs0j2eEtuhnVUfoxxURzWE7vDe7rj970s8iz1R0jphGwEcxkJKkr7tkox5prZ4Fa/kdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956964; c=relaxed/simple;
	bh=fuURrHNwhl19U6AaMr6nwZTt6YkhKqzRztrytTI2grY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=SV5GsRoBjkBfqUW6A22M82lKPtaClxY8ImfEfy7Kpbj57/gh6vHxyanUQEQHmsV7koIGRWUtqfvjYudNGJIzBcqcIBmOMvUC65N6kubEnmqjlcidWTrvW35hzSXTXWa9SPNBQ06rplJ+ksReoCSV1/gX2YeQNWt01EUdS5gKG1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SkuRMUEa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=isT1YwDg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SkuRMUEa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="isT1YwDg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMvXE1492654;
	Tue, 24 Feb 2026 18:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BgmMF/Wik0a0jBDBC+
	baFRir1jEwLtNwFG7KlgRpWvU=; b=SkuRMUEaLDma4OlmpNotauk7sWhrg5YOWT
	hkH98W4ntiv30f52Kbe5jNVzIPMU7nHqx2ComfDsjMKO9u9gGG3vVCJlexPOpK0E
	7a/HXv4Gfu/DJVG/kQk6DKzVfZyNStGGAn7PX8/GIUxKUVTtAq1ZnmnEu0afSHKe
	IM0e3sI0XEgYg+VXu0PYepcAM2XZm0Pk3QA7jyN2KXg0rQ4wdYlAU2H6kcp4oqao
	G00xaNvlK1vmNZKW+57Xtzojbu4LOh0DEhImPp9jb/nUogX48VJeUntwgJ7OSrqz
	VkSb6IyMB4Zdy7HzcMgaJx+79ey66zBV6ia4qqVzpNAizFTgnRZA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbctc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 18:15:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OHF33m006382;
	Tue, 24 Feb 2026 18:15:52 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010067.outbound.protection.outlook.com [52.101.193.67])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35aa7wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 18:15:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i5S2ejqipmSiWBKHUg8V9Y76SlWYApOivIOEmxcuNAIOna7yzPXo1CDdBOVmzRaELDRzwexWRprC+mLW549FFEOq8d7bZ+JKC7pArwMVHnW35Irj/VK4k5oG7ohBNvvCQJrGvwvbjFUH594Lnw3mBcKEgHOjuZJcvezPw+pyP0xfCOjq14T3EM/gUvrkaQh8qfcgmqLihaj8WAwSvunBC0el2FpTQkKYYMwVv3m7obYGFLjz1pvA7dRXlqNeqBS17mOE6pyDq4C18PECRkL/5N+CJHlu+TfIYwshKfJAV8EpxBsaqmJ/ux8/TmwABkZHRSMrmx/Jz45JBSJ2Z4bgVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgmMF/Wik0a0jBDBC+baFRir1jEwLtNwFG7KlgRpWvU=;
 b=Yjt7FYVWFf3e/5jwCHUlXhBugx6XZprTazCrXaiLWHYNIPUwd+N4Eg2Cm5ZcR/tY+WWDax/76BuzX7DbscxJfNoOEnNXbOTt0G7PQzaqrjlXUZeehlDfTeXeMbosCrA0an8LCwDJk4kEcAOUFiazinFoF047ExLKp14iI1kNxVoRzE6OEeLe2nA1tD7JfSzqGeuVW8bz9Sz43PjyYWKvl2iYl/cFPPiPL2PPQY7LCl5W5Wyds1843czShsTVgayJDwfx/Q7OoW0TP2SyAO5hUx/6D7VnKIkmGRJp/I3q0a5SbpFfiObjLBTLHFdibbRpeUaPca7zEDZoNBinjHAxwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgmMF/Wik0a0jBDBC+baFRir1jEwLtNwFG7KlgRpWvU=;
 b=isT1YwDgFJCZ0LcoSP5OCSCfQa7eQb2qqUpv992yuLe+Ew+l7qDxRwvIF78Bom7nv0af818eeYZ1aKSXQ47JVqrhd+BhwqOvH48eDQ3B/Q7Ckc5olUV7oG0pBzQGdC5wBZtozPIkWiXoOKbMUe2N5Uf0q/yXHU+9yl6LTATY4bo=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 PH0PR10MB4648.namprd10.prod.outlook.com (2603:10b6:510:30::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.22; Tue, 24 Feb 2026 18:15:47 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 18:15:47 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] platform/surface: Replace deprecated strcpy +
 strcat in blogic_rdconfig
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260224144828.585577-1-thorsten.blum@linux.dev> (Thorsten
	Blum's message of "Tue, 24 Feb 2026 15:48:27 +0100")
Organization: Oracle Corporation
Message-ID: <yq1qzqa80xx.fsf@ca-mkp.ca.oracle.com>
References: <20260224144828.585577-1-thorsten.blum@linux.dev>
Date: Tue, 24 Feb 2026 13:15:45 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0160.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::15) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|PH0PR10MB4648:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e8606a-4e58-4d4c-1238-08de73d0bbe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mm/faX5h7AiY1xEjGdifbSjMJRnGe2EOJ6oxVemmQz70sr4NDB6V1Dcg08Nr?=
 =?us-ascii?Q?txEBKQTIu+tJDYirW6PS1c5rilI9kNmaazuzxA9iMNTZD9BoX0dp4FEjDCkd?=
 =?us-ascii?Q?dCIa/UXlbwKieJmLVNssM+iHyziik4M1mHmYfxKAg8bndcNUXiIv4fg4aKga?=
 =?us-ascii?Q?7HxZfEp37K2weVq/Io6t9sWYNaIP5cVI4Oi6OgAJ9pjnpHLmli+/xb+iMrIL?=
 =?us-ascii?Q?D9pxRWWhfBNgTA6uEBE3LcqiTe3XeW46HfDjXx9/uP+GCjJw8Mot9dM4JKul?=
 =?us-ascii?Q?4r+BJA9eNdmNPeDY4vpKOQFClJ3sKH28WySMc4J1nLfMBrvGcywzhYCFdaoz?=
 =?us-ascii?Q?QCmQpdGfSd121JSbQTwQyLqukVlva8aL/no230Ueo+0tqcpS4dUl4L7MG/SS?=
 =?us-ascii?Q?zYEh5EL1WQyyDwYb8xX290H6mcj8x6xTn62Y5L4ctykCmrRP4/pxopc96zbg?=
 =?us-ascii?Q?xQCL1jbjGtshC4UfOHLdJQPWT/+l7MdWh9NJTJotgCILTaD5peScDy3s+tK3?=
 =?us-ascii?Q?h5+Jy1JBf4aB19F8c9jY3++k8zNn/eG9TAY3vT1/33LiYPR9t5J68xUTM1lb?=
 =?us-ascii?Q?A3h5vOazPuaL3dT64ODTgF2+zs4mqRXJY6+wKzPWuwnsRlKJ7cz6E946qwR6?=
 =?us-ascii?Q?OMKGQX/CtQ2zMPXWcfig1db6HLVaY5d6GxFNzKNUU8UJ3/yN6afKq5Obq2eP?=
 =?us-ascii?Q?MAAX6FDqYMj8BQx6b9yLmDpCPjmAHN/5rlCdmV3xXOy2TPuPlPEn0WgqXPN7?=
 =?us-ascii?Q?Q6Qs5bRO5yH3QRrV0GeSQJpHgepQmhDBnWH8EHt2cxzo1EvIGUn6rJlMl1lK?=
 =?us-ascii?Q?ssSUo0afMCbOpwSqOmhzho240kIF1bNmHw3Y2eEBTMuZyEzE0W9cnmdOcJt3?=
 =?us-ascii?Q?qcfsYn76p2vXMwSSqP1Fjx7cQIjm9r3S75tl0EUX31VcZkxe2hBlr2AEsHRw?=
 =?us-ascii?Q?RjAzJxBmiqpJKHXNJX+eFMvT+IvZJHueREW+FHgcQBMN5VyW8kMcb0Yirgfq?=
 =?us-ascii?Q?ppcMDmh+unNCs3cWSjUMgAKW8vmSsFMD2/s0PqMoo5rQMJLudZT5s5BRNs77?=
 =?us-ascii?Q?m27Wvji5VJvLul4GaTbPc4PNyfma+XREmYdk3t7f2WKiQmYJPyRuuRYFULXO?=
 =?us-ascii?Q?XRf5N/86HshQBczNfCAS9xLy1Vcx4CjQRrA/hB2XdkvvEga3OFNH5D27DdDq?=
 =?us-ascii?Q?tCrHIfq8T+4vk+jq7+Qkex7ahWPm7fQrlnm7GevMGJyvx3P6nLaQU5MaS/Pe?=
 =?us-ascii?Q?CmoWZbSkJOxuN7B8QIXGhnxrLLrmIU1ZiTax70ZsVi6E5Apg1y8wHuddjBsd?=
 =?us-ascii?Q?iRaKSzqEn0x6Pyr6kDzgjUJ2hF8VkV/YyzBzBjKL1XoVQ2qlYzZoVC+pGWc/?=
 =?us-ascii?Q?nbkVHLZJfF7ISjkYMDK8R1dJU2wbAIhl4WTHZaBsgVqn6S0AxivftsvScnh4?=
 =?us-ascii?Q?NCj5qXgMWremETywxdIzK+09teSh7NmzJBsKNXUwhvE1nvz74u4Qh6jrhXBM?=
 =?us-ascii?Q?EeVvfkbZEgtTXvD+3zlcxSs4UFQcI1xUWR9kSB4hSI8i0nRsJ+ypeV3Amb3A?=
 =?us-ascii?Q?PmjeRx9N+42SUX5+FrM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GOithi8yMrpJ9eXKtPOIUbEyEH5MdLhG0goENAVhpSv8SurFm76og3Vtcwfh?=
 =?us-ascii?Q?fVBVqvwrtfycw5Vgp13JTAOv/uMbkIZDutGIsEMNzaTm4/bb9dLpRpaGowOP?=
 =?us-ascii?Q?KdKLrSLUmKjqTPdK18UjVj8wk3ePZa5DQ3i58QQJf1h+gBn8yXFL2TMwVJL/?=
 =?us-ascii?Q?fzXX8r5rc1+I85gzvJRuPlP0oQTpLiLwfz5xnCUWDI8zRnqFIfre7VJ6G5ai?=
 =?us-ascii?Q?NBHz8QBrsEWBYPT/eB9xmMnUV7p/cUNjv8mwNSNsSacL0MRjiEpuHtv4seCB?=
 =?us-ascii?Q?IR1pVndoFtat3wdZIUUYUlzC1rj/Fv0cZdLUC5X8NabCxKNJiRjsG5HNs9jQ?=
 =?us-ascii?Q?egreXkaanjR19SoJOZNaoGHEwr+0Qj2ETd6+W+n1zQLEOAZKHWn3cmjAAJxa?=
 =?us-ascii?Q?KZnbPjC2IeSBw1kOKwv4xbRXON1VX7ai1STEz3ACqPrlwtoOprVL1C93+4D8?=
 =?us-ascii?Q?hoIT1Ib65vdhpDuHUL9yuER2IURUy1L+NbO7DzYQA8UCxB+0SDcXUN5VXmjM?=
 =?us-ascii?Q?KltE8IBW9HCoiYvBmX8B/3MPOjdhhHZhZteF9yxfkkLmGomnvc1r+UDHEp59?=
 =?us-ascii?Q?X+a5fPpMj0pPi7KN/f8zZWZQJybRynSDNKlepAg+UjT0kxqwfWmcF9FfkL/8?=
 =?us-ascii?Q?o10o0irB6r3hv/ea0ml9OUU4/Tehiae6Pwo7R4wdQRsA7cg/qGSbbm5xYEEm?=
 =?us-ascii?Q?8MwW+/4zjb+chj+Ezk5zijd8gjbMToLPQwp0CA+tBeapgdq0WzYnDHI3ePrY?=
 =?us-ascii?Q?kUNJ8kAJt7+DeSraiIbzy6mHgMTzrw0Os3MNTfUaXWSETvBY9Pc7Gajr5LO6?=
 =?us-ascii?Q?Wz96DqAztbnQvhpfGIf4qMaWcWPukxX6Rc1AkNsgEksbOCJeYyg0j4V5fFUG?=
 =?us-ascii?Q?GZLR7kATLwt6qfwzQ4Z3BFbvmYlWj1Pk+le+wSq/VFyVGA//1hds+MPlG7qI?=
 =?us-ascii?Q?ZlwApFaOkTztCPGM5eQv7d2dxOm4OjQteib9N61QsE7bjT+E3gh8U2H+ghEK?=
 =?us-ascii?Q?VBMnK/kRMqY6cF/tziIWfC2iCswD6qgu5i3PkjFVdTWfBpiYCf2g0CCjza44?=
 =?us-ascii?Q?d+DE7L5swX3v4n3sMKcRLjQlpusH224YjPEUxdTKmmIjsPtyR4oeZ7uwQyqK?=
 =?us-ascii?Q?2smXW44zgTU46fpMkCxjr0tW7VCoFJWFIujgpW6sAKC5/Fl8W0WZ1vThK5zd?=
 =?us-ascii?Q?l7+ggs7/hyYW0fuutSKk9h9PNTF83ZwRL+ypSvUDRC6sVTDdnNshXxOa8j+B?=
 =?us-ascii?Q?PFbTCFFKN7Y3etqxNSxXs9ddYANcM63/ocXud9smE3QsXPvfn2T6hVBv2npH?=
 =?us-ascii?Q?gouCsgrB3hhdf2tG2a1NhgJk+W7jaW5Q/w2aHu/3JMYotLoh7UF9kvmy25Ws?=
 =?us-ascii?Q?00krQbboUpi9aNmklAvZdmuP/pM8NRXDNvo1SNyfSbnPuqK0o5jZyGT6OKXW?=
 =?us-ascii?Q?mOCP3nDcLvwUdqo806IGu5bKKv8IxtnxxIZVNm3ij7zzpN5Jx303jD3sGqTk?=
 =?us-ascii?Q?+nobSorN0Xxk+VscFNyVgbwdLCKAdGrb+a23KTL9s0ALHDli0zP8fcHJN6Z0?=
 =?us-ascii?Q?dkxhNy89kK9TSG7h7s/VFpb265zxADahCPPj+tH74KHsOGtAFKLgnyLMJAok?=
 =?us-ascii?Q?oY9l2nJfjZ0689Up5mrzXGrkmUxgEAKMaGD3p/44S3bi5z8256DHou6ss/aD?=
 =?us-ascii?Q?nokv0ZfXZBu9xjV/HVc4XnjOe9grXE6jgOhMjlSCeWpkiNtAbeMYEhiqZsZD?=
 =?us-ascii?Q?UqdB1wioaXMeFINCn/W6gU6fmlbzv4U=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oZgXoZ4l7evvg4TXmGrfTV/MFzkyZW9IiwZKaI5jAwobXX49kxMYma+Zuw7SLoF+BalhF0UDISGoN8TWC/T5i6/rHGAQyNJNxiKoID1c9p8P4/tmGj/90P9ReeDHsnGA9frMyT4MnbO4SheXDYTNGjHY3KRanap/lnv/eTf5XNo4gFnyJXYU2/M69rzsapxisGhJyz5jKAsisUDu+8N6UrqPQElii1ZAcRq5JoGhK7EyaPBt24NHx6awDi7dblNSWvbLnQD2LzKbYdM3Im6Gp/o+FI2wrK6PG6WYefA7eU6QStltTIH4w/eBWCedOTfajMmCPk63JOvdJdY9a1T55nOGa5RgBLofk+DRCvI4ruKAbMPNuKyX3UggMpI8EPtkNnGQreeCweZo9OClZol1J/5QZDkQIOWoafslJHJcsHoUs4Qp4EVdIeqRLOvUzQ9HxN1yIx1AHBeu2uBzgKEDZdNpG3ymzF46W30AT+S4teswwTiyVUJv82zvVy5mvpJ1gjh+OehiOjGKfGomI0bcW1zpxW7nSVCXs984cE6eL9Exa98UPBPsmshhz+y9sVdouk0OCMyaoFqYwpzYG/YbZTg4j/8doJm03RKoihzjiwo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e8606a-4e58-4d4c-1238-08de73d0bbe5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:15:47.8211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/Z66fspPoHX19eNaOTWyYjn3i7hXSj4YgAYw8mLKGgE7L3oX4BGcfw7WV3wdqmI0kQ3JvdlTq0bn+2SO+Fy1w/pz45zHMTl30e38C8zlW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4648
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=823 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE1NSBTYWx0ZWRfX2RYC8F39nTvH
 vt6wInM4QjJJ7AJREKrBMvo+qj0jSpaprgethIx6gHwNt4jiR0LOgX8DBOUjKxPdr8bRvIdOc/A
 OETv9ARxCRJTFEkRmV9gzIU23SdZ0YN4JrfwU5c0ZZpqQK+lGkAvLTMna7n0gAqw57c0zNWNLGf
 /bPSVe28DuTDFOIbNlrDArKA93XeFxVSth1Tn3+btd4hu5Wrc/9lHaGdcNF0X1SNG9GryettRrN
 oGkABTwKCoJ0WDIlp8sZDRq97fdA+75HtCM36VCX1ycWceAPr7/auxCQ8AWp0H/0CVBoz9tw6UL
 Elo59fuLek6LxNpuJWeRLc2qBWXS4U8ObZQsqt5vI9qs2n4hYN3yEtpR8oWy/TQtrl4A4SPh4Gt
 OMnZYzxmEGt+ruIrtwy11/35Wfsh8BQ2gmg00DxjG8riPQAbqRs2YOhgW+CYRAfwE0GNAxIZUUI
 Tlxz6/K6iVUiTu3jiQw==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699dead9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=0kqc30WquML4S0zG3vAA:9
X-Proofpoint-ORIG-GUID: EtFc4S05y2GTvs5my_Ju_UfnW6QoPBs1
X-Proofpoint-GUID: EtFc4S05y2GTvs5my_Ju_UfnW6QoPBs1


Thorsten,

> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c

...and yet tagged as "platform/surface:" in Subject. I fixed it up.

-- 
Martin K. Petersen
