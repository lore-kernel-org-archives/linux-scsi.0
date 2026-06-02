Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A63382C5;
	Tue,  2 Jun 2026 02:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780365655; cv=fail; b=lbBzVJSdpE4bXDLVa/Hy/gozc9hTVjThVsv/0/9H+u8qyhSNMJ9w0pvTNyHk5rWHpy4sNxfqneePru6pXei/uoBCocAEExXLrDC+VSlMuy//3l1VOX1YnMW9SeMFdiCPhBv6ePEz22T1GfJmJPO8zIekpfNbtgblRvJlsx1FUvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780365655; c=relaxed/simple;
	bh=25ieyPpteDro8Gyrrv20vSxNQ7xnikO20z2AbYgoCjo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=V1gDL/Rvr11KzCZWwGlAYba73yhUJftwPOAYswcHhmSNjofCuLTTQzYOWbrdH++FSztR8Jr323HqJoV2YdYCA2s+Q4Shn9KTIQMuBVBqF6yyESFl1NgEWiMBBcg/ZDZXmPgpjsUJ3ixfY/POwC1M6e4VxOu5x+NSJXn3KKNs1Ro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=frh+3zkl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iDU5NWQ9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="frh+3zkl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iDU5NWQ9"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651GteEf3106831;
	Tue, 2 Jun 2026 02:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hjytFTmttEyFDmZRDQ
	TvJZiOnus4UVzSVrcns+uSvbM=; b=frh+3zkl+mNxEET+9YPShQWvdCHlLcBmkq
	i62oee+nyZzZtR04KHO9jWqTZs7pgU/z7s9eSQ1ejfxrajg6LLG5fUvLViVeX/A9
	6kByP8evyUP5g/2MPGfLa5bhqYOLa0gJtXEg8/+H7daW7me+8jtlOgd/EuT/gZ5s
	GCkQc21jj0pA5uTjj2C/BybDVG9/AZXvEP45NhUET5NtfRT+Kaeg4Og0DDLiSPAl
	SYmdehD8JkQxVdISlNXzDieh0ZSyP6+f32Duwfngdhfyv/plubWM+CpFadBf2vXB
	JUyRsIP67ElE4vi/4h1ajW0K2YeuKclsU0jgx546VplXJQrzLc9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpfxu966-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:00:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65220JLZ016636;
	Tue, 2 Jun 2026 02:00:38 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011043.outbound.protection.outlook.com [52.101.52.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbqbuej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:00:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OlTaUg+khA0qR0MbWGmt/yfUSqDgMbJCVZCONdJ5EDvWqjKBfTB4/7TIJCqxDVCkmS2BJjNQgyHI3eZgra74ETiK8wAoVJgqMn3hFUvTrj0rVEFUK5t91kLnz6mT2Dv33YdHNu+f2J3L/2+NKLi6OziCBppr+wFY+qQ0ppWLyRhQ2Oodg7OOrLM/VzU8otLpx3gPXoDe6nwBWAy9YaQgF91/3KlRVqUAkSFXHR0RKrAMECHk9/RSt2J3KmvK9jc2luX63JWuoTozDnKpRxejR9pXpRM44yYDEi8Sfs++/gdtEj314SwnmsFmi7jgSAashjTpMITO1uPOb+XV/eVImA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjytFTmttEyFDmZRDQTvJZiOnus4UVzSVrcns+uSvbM=;
 b=xVhAPefKL6OGGNc2mI5abo0lqK9wvmDUsbXBgbRREbSoPQuZoNkXhsFEZloyu4eKHiroapJzyTw+wLXKHDVWURjnrMzG+Zmec5wzh5vZc4mQiyzCut4rKkflCa/QNGlX0TdyDPwioT8aB5ZdgpmFgAHuUix/1vQpxw544L3iTJX89KddjzkL+O08k1Lv9X+zQKzlyiYSXTUXvvdYSak6TUDKKET1hmhG2NcFB9vX6hMwlSG1r0GykOyJED4mDoYUdVaw9ejoI91JmW0hrSGNt02+SHNQX13U2bqJ3M04C0XH3w+vXukhtvhczV4HG+4++z22rDs4uxLxXOqQMx8jrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjytFTmttEyFDmZRDQTvJZiOnus4UVzSVrcns+uSvbM=;
 b=iDU5NWQ98YpVA8ae8TfW1939/CHms+W4gM6jxK2mHL5trdnaLK5UqYOaLuTZQ89clxXM8M7t70P+Jol9E4mSsVfnInDKzd5yf09frGTswl2ZtUllQhI9uKDxGK6SmcUptef3YLSVD9g6aPJ9il2twWrEF3t1xPaNNyCobvdwfi4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6729.namprd10.prod.outlook.com (2603:10b6:930:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 02:00:29 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 02:00:29 +0000
To: Chanwoo Lee <cw9316.lee@samsung.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean
 Huo <beanhuo@micron.com>,
        Can Guo <can.guo@oss.qualcomm.com>,
        "Rafael J.
 Wysocki" <rafael.j.wysocki@intel.com>,
        vamshi gajjela
 <vamshigajjela@google.com>,
        linux-scsi@vger.kernel.org (open
 list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] scsi: ufs: Remove unnecessary return in void vops wrappers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260529061503.301182-1-cw9316.lee@samsung.com> (Chanwoo Lee's
	message of "Fri, 29 May 2026 15:15:00 +0900")
Organization: Oracle
Message-ID: <yq18q8x8zx6.fsf@ca-mkp.ca.oracle.com>
References: <CGME20260529061506epcas1p298f7ccf8e65e713c3cc2b8fc07549dbf@epcas1p2.samsung.com>
	<20260529061503.301182-1-cw9316.lee@samsung.com>
Date: Mon, 01 Jun 2026 22:00:27 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0115.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: 36b2b3fe-0541-4392-0e24-08dec04ab8f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	3e7jazd88atB6LX+2cLASml0UZKVUhE9eiAwjrV1+/7mMiLQH3kzIaiqVd8lhBkbZzqaRyGBDZ+Dt5OIUtJ/iIRU9dO9JOOw7xOas1CmCS853ubhSO+UNa/bob7lFC4Nnm0rV9BZme8tvoisBcJlmAvpwy2goBg4oHrqayqDxZ0lCCPd2gTeAZ3ZSeyE23BsKInIb5jlZE4bp0DINNgBB7cnO7v6qbtC1N19S99Meqtxg+CEfG5FAgJM1V6sWEDE4IaHaS/Yy2iu7fPTYOz0ghW7/Atfj8U3sOeVu9gQLS2nzz0klLuhy8BmXGuxWksOmSY+k1v5tBMahp9ZfIGy7rx4flCEjiy9ienaTdEIOhuAmyJCRSpWYEIQeCjDkoCKpZcuqbFurI1QQWpScqscIeU5MOD+KbTbHBeQ3XW8z3h5wom0LLLj0VA2N5r/7MpOCwBY+yckLoWaYRdYmuKHsI4YMeSjIRpK2tpiSmmm1W+eG4yaNv/0X6U1sYpdWsVUaRIYTVvAcY1M/4OuGSzOJaWyi3sWkp0LULMNx8ihEHjwvOkcOl8LBnZk5WbsfwjyNlEmpJ3cwxWcTTX9U088ILLNATA9mAKMujkSvgM3+T2rRo6p5q3g+TaZVnRG8nQUqUxBSVojgmuNK9oH/bgIyBGduj3IRCt5CxsBneJxJFCtY/alp1gJsu/afi4tlA4o
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PtgfmC5Pkj60y6Ez7gX0LXwWHTMsE6XyVihSU87PfrT8L6jQUR/EZQ3dpc4O?=
 =?us-ascii?Q?SrW8uqgwDbOsNUjIUVxlwKV+PGLHx6UvJlfsXH7baUKEOgnGbOhVuRIegH25?=
 =?us-ascii?Q?wcVpsF7APkgV2EWYA4l1eP315ZkIOuUnNZkvWoFnwE26mRgtmb9/z9rHmDOL?=
 =?us-ascii?Q?61d4IvLrCnWxnmqZO2pErRoxQnch5X5B85oJLzSq/7xAiJ0iQvRX1aK6fOzg?=
 =?us-ascii?Q?FYOA7aR7bgM8c+EMO6XvF2NupJJN2SL5hNlUyVPLva6//bfyvLHYDSV8vdc7?=
 =?us-ascii?Q?sgykZB0F8PxJh7R4v8zVE3HBzfGY3JQivaEJalVuY7bUng3KPSzci/FknglG?=
 =?us-ascii?Q?zf+LtcQBZn+ym9Fnwv7aYWMRsymFdmTKNuZtWam1xuVVuHt5joKtBH81/oxT?=
 =?us-ascii?Q?UD4zJarmzQ7558quEoMMBC3ei+Xi/NBNxxvOKafy2FlG5B7QRcJdk5EEeWJV?=
 =?us-ascii?Q?aV6I60f84EnUdpyaLgmLpaNwBisMe5tqOy4jok5bVa941f7gS8S6AZpdEj6O?=
 =?us-ascii?Q?tkF8BXWx010HwRDx1Uks4+TPZaxe84qoE7TFQes1TJtWyjflSCJ7gsvbk08z?=
 =?us-ascii?Q?dxiGnrPH0Ltpf2IR1QX9UVwhwIPdQDGtooYGiTrG9LlMn045hbNDpqj6UxeF?=
 =?us-ascii?Q?dKGhsOitc3KkywQBdbvepJ/VweShV3m+F3Z8e/RnC0zHx6nAU+u5b0B1z/Sj?=
 =?us-ascii?Q?AWjq6iaVp/UB8MOuq3lYjDPOLzwyrlP35K5HLeEjPlU3xKEZ+BmZJVUI39Dr?=
 =?us-ascii?Q?rBLoPfaEfipsRhbWXFJKbGXOeRaIMyEpdr6ghF7ce1aDrb9nAp7BTvzdRzIt?=
 =?us-ascii?Q?q/ZlDte4JIXdxwYg7StsRoZpnoNd01mnc30IH/jn4v+otaEC+8QSeWTLFL2m?=
 =?us-ascii?Q?uFMKj8jUceQL65Z6q4+a6m1lgZ9rlMN8wG1TgOwz4So2bL93CPCV/MSErzEc?=
 =?us-ascii?Q?TRXS4eNxqxGdLQhOe8vtURb4SQ3WzhDFTdfQeCZAPs+ZxWxeJ2CcGT+200Wl?=
 =?us-ascii?Q?WRu/RcprlIeRSXSPBDX6qYAZ7SkFPLWDs141jFSgzG289gY6wTmRqdTfO++z?=
 =?us-ascii?Q?ljNlte8ctCbCgK8D2fW/NIyRu/aq0x5aEuAFT5CUznez+Cn7+pBW8gmvbsoq?=
 =?us-ascii?Q?1ccPDaakI1qp4D4IocBxWsH5NpQ8LIqNHEVJFem1my80awA0793mJ61mF0Z0?=
 =?us-ascii?Q?e26dBt+hvg0ZKu4w94/hSL131o2hSM2xGb1S8QsvbGkKHLFvdAGPu8bZDfRS?=
 =?us-ascii?Q?OAPRxUk31E1/6mtA7nxnVdAqk5CecDG2RrnBGG6MPmVh5MLCNczcYc860ISV?=
 =?us-ascii?Q?8brxt3/09D0zf0gQfpgD1+UaHVJZ0sNCyYWxEk+zEZIFnGO+K9kg+FviHrEZ?=
 =?us-ascii?Q?etT+JARX4Q2WMIhQVeySy4CnLyQSRgKLkQwjr2ySmYGGj+QrVygtHu0Jcfh3?=
 =?us-ascii?Q?9zER1u5kySqprDwLOU88rlrgEmfMhlBHSc3xfdhDagqG+UEDzvNdaDwH5YVd?=
 =?us-ascii?Q?VAqcFQ2Be7c/+LM81AO1gFaMEfYtIYhVgofPJ5YjpT3XXAzLSCn7QAcltYfB?=
 =?us-ascii?Q?t7ZlGhGGr8cQ45Dat08qO1u9ROSef8MjocS/i93QCmplVy7quVBXE6Qx5Tzk?=
 =?us-ascii?Q?agoWdP00JiJ/+Q3yz8yDQucheE7SuJKSPvL4H6l9nbTvL5ZZt7oinVk70oH+?=
 =?us-ascii?Q?nvHsKPcKU0y48rMN/zM3uzqwQXS9cEiwTw0gxE+OeIuvd/DE4T3VXIyggyHW?=
 =?us-ascii?Q?xTk+n+cSa5FjTBbz1N16ZqYQqGDyuBw=3D?=
X-Exchange-RoutingPolicyChecked:
	rH0iuWBVyUcU8Vz+quITaeX490aFBAym6IqarLfC1bh9u1o0+90niYRADBhO89x2WU54EVYxd8JNreqbMiL9MntMsAyVKA8T5zaX/U25y16qudywLGfJneFoeFxexucVmbz2cw70w+8FOobKXed0jLeLXf37HBSukhm3MnynHKiZaV04h2Cxq8WAsP25JKC2+5L0QdJLZk++7KXEsKC26tyFzosZSE7z6vDuJSxvBbM/JxunQuCTzq2s5sxK364qIrKeoePjqbpEwQjSX7BEF1uoIJzAWSncXl6lx9wbsQ0Z44OQBjVikC1uusH7295S0B+LUBiidQU4kWSMTpOZbA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jlcIsZxTVCJDLcw4wSHQA/9lRe7sXvJ5U5APQ9wTgFzeRhXB47WPjNuvAvy6ofsSMKnOdZNuyaofG2PQB6RwpzqBZ2GQ0ykHY8gGhpi6TdbTEf3QBA1MQKD9UnIXIs5qGQfW52rv0Fvcma7wY9n2do9IrnhKixh1O12+VI81UDeWrSqDcwsRYmeZt094k/iMqWxBHkS2RX5wcAS+x8004Y0rLJmyCg3i02V/yYWM9k8P5kpgxjZs8T+vcrr0yKBtkzx1reZL5LSLG2Ac4UZN/WnIsLoETpi27wfwg6mcXeq128K9lKVMdDOnrYfQhKToif56Yig9YHJNMdmAuap7YAM1MgBnPTooeUdHcCUHXJhZMPWd3bS+059LKqstE5daRVUTgAGNvSonyCbXeLkjxzGWf4F0Prrp8kfruO24KsXUcZ85kuV87hUCAX0B3PDI+0saJf2Ug5orYxD8nL/aLdmgUSZou5Hz4GxdRNfdji5lCeRkDA9/J1FstvYCSN4QKdsUgfLaXhXOSvQdxiYR0j2Yq1RPx4skneFDmod8+WVnYJcNHugCaN6ircbwBKHuweGuL+70I/kQo/eetx6jhu66aGAsP9RnLDP3jYr2OBs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b2b3fe-0541-4392-0e24-08dec04ab8f4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 02:00:29.7525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: px122Eba9f33ghsl6Qam3qPRYXoKjACVcU2dov5F3zA8AqnUd3idjjgNa3VXL4b+hQokwiLbOgMZ1qv67ZMU2h0w2R6sNtkjahHxlKL0gh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606020017
X-Authority-Analysis: v=2.4 cv=FOMrAeos c=1 sm=1 tr=0 ts=6a1e3947 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=37jQO9uSrOesRDA2IFMA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12303
X-Proofpoint-GUID: NUfo_SEH3-oI3WlLENmdxBaD8uxbOOam
X-Proofpoint-ORIG-GUID: NUfo_SEH3-oI3WlLENmdxBaD8uxbOOam
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxNiBTYWx0ZWRfX/t2Z9B3SWOSQ
 YMSvoMy2QmufSEazNll3owN0aXqrCuyPlDgQCV3VWomfzY7gjID9ioald0lQ8cn3F/ON7wH8J7m
 KF39yaAFno2UtPcyAi/ecVsnptobGOh37TRZZ3xwTEZJwOGBXoUEnTDVrnB9WvyGpUC6K9I78xO
 NclOfWqlQNEtRsvANscynuugsb1XgjUg1bUbpWSgMdOdx/Yc8KSGpGSXleecNHR7oc/diaAR6Oe
 WnBLijo4ri34vVndMzhwCJ1cJ5C/TPXeXKIvnNIFfKN2XL6NvQEjSnALedu7fm0uegOu/Om1dHp
 93BPj3NNMNtS40/e+3gt2U/av6g3BMmtloBIvkIpFQ5vfA1rgGDYtN7CQv3A/BrWrtEoFobd0em
 kINTPEHjceC4DvA3yQQQ9Z+s9cu9thkzhANRCmMjj/d1HLEppYfAfUDUUQJPHScYVDVuWXVtXmt
 j2XFC/h7djiTdkQuir1Zi0IZqpilTCO9D6+KH1Uo=


Chanwoo,

> ufshcd_vops_exit(), ufshcd_vops_setup_task_mgmt(), and
> ufshcd_vops_hibern8_notify() use 'return hba->vops->xxx()' while other
> void vops wrappers call without return. Remove the unnecessary return
> keywords for consistency.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
