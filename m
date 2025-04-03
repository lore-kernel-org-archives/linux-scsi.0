Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D911EA91;
	Thu,  3 Apr 2025 13:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743688066; cv=fail; b=DYnQDv9ACHBKHDs8aqTh+2rJKZV7OpixnOL96301MBSU+RhxaX+WnwkNdQXeShprmjlnVEhv9sEMF37qs6SmprYsiyoCfWlb6yBZGbZs8npTgXRCq/urp/O17Ju7QsbMKdcwkiZNcwMCpGjkZ1ytUQqL+r1x4LMZ0j1jpucD9Mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743688066; c=relaxed/simple;
	bh=Nd8pIYocwCG8QKiawo8fYZEEs+R+cwpHuz3OxtbN/Ps=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u7Z6WFQrW+xc2kjgJAL/RAWVsoHH+SKN+EhW72paHpxFzHP1lBc79RDqSCrYEqkXUc5fQOqkbw44v+7ZByE9+GiFcc8duU0eVGD0DJstCog0Kv55z18z0fLAtYeKzFIQDTFTFAzWp2J0AyETlAZwtFYfoVnYuaqXzQQ2536R/BA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oG2auB2a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SGNEK/xJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oG2auB2a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SGNEK/xJ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533BHfNi032062;
	Thu, 3 Apr 2025 13:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qcljlpZV9wR3oHxW/m
	vTc93XYWyFCCJeo2E6+auxVCM=; b=oG2auB2aH8hDCKS+SxXhqnYq9UCR9Z2B6e
	UAGHskEgDvLpoeGTKYrWR6Qpt6NoI5nRBJUyHifZrkSQ9/WxkbCE226QaP9/Qfse
	dR5eH9mNM3XQmOvdzknLBMypLr54agK6/Y2ZwSg37zudSlQBZFTbN1BFfvdH9TX+
	QBhWydgVhBqG2VIejmatbWEoae27kS8+Na5kRBq+IhBo9CUWBuEyEtcqBK/of8Ep
	XgmWoKAqlh/IAkZiQhiWqhzzHcJFGG4qDZ+WB7C7UsWheM31M9zJAsoCm91p7aug
	22UMFjw+no4R0YaSOG207iRSpsTuZorKnb+KZLbtEGwrB1IapPOw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7f0mr8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 13:47:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 533CR2ka032863;
	Thu, 3 Apr 2025 13:47:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45p7acaujs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 13:47:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uk1EofkSvbuFZrpizkC65vngFk9nPojrsEcwzGUHqu2KUzZBzZ37o33ozCV3Q5xSo8ldZkJRmo/fgZQ0WdEiCnkKAv+HLtxo58/vH9xYTyKImG468zr71qxBffnQtWVdblDVNOp+jdThJj6uLT6FcyU/QIfhmpXbXUqNSPUpFnnoYov8bxn6LyxpK247jtLf89y5arzkDEPuGioONTdpsci4LNp+Dn3HdFRF8aiSsemZFYDKmy/3ocdjUom80HqdFYIa08jJ7c1xT3UB/+o5LY+KflZbPfVI11wOVrEar2JAdXVGAktGE2947DXnZYB26trpfSky0xFAPBuI4MVD5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcljlpZV9wR3oHxW/mvTc93XYWyFCCJeo2E6+auxVCM=;
 b=ABCBHzwgmAriLDEj8X0Pji0T0jqvero9MCodRWMwx4A2p2RhI9PiMb1KHa21Piqo+KMwFndsJL5qU+R8Hl0W0voxYoI2C/y/ooIZwOVOEw4tNmtgpf4OIoSAJE7CkrfltXuuC2swhXnS2sh9qQ+y3BSE9UYdMmDqyBPv8lbkhmWTADD1NiVdgPduNpSkAbm2hBazogn+OwLHuki3nivPo3iUOEtiek43JB4f2snkYgriheHasmNaKnIWS18uhmcoOGJDorDzY3xgVdBLWPk9Q+o2qETeVP3hf4lelqsKycpQp+AXK4+cd83Fv79n0qQJqmNB18nELk7/YBwARJSYqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcljlpZV9wR3oHxW/mvTc93XYWyFCCJeo2E6+auxVCM=;
 b=SGNEK/xJldhn4q0MViYx8/d19/pYfVJw4Y9igFcFNVadicqasmOMbISrUDAUhOS7H5zgnNNdGmS2evfSyyu/QrPSbpkAsDDOs+tdZoqnl+0IRkbVdLYW5hKn9wv8PR6wQxQO7KaCLtzscj5blxko6Vi+mWeNJDpcssJEx2cxhzE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7252.namprd10.prod.outlook.com (2603:10b6:8:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.42; Thu, 3 Apr
 2025 13:47:33 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8583.043; Thu, 3 Apr 2025
 13:47:33 +0000
To: linmq006@gmail.com
Cc: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike
 Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Lin Ma <linma@zju.edu.cn>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: iscsi: Fix missing scsi_host_put in error path
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250318094344.91776-1-linmq006@gmail.com> (linmq's message of
	"Tue, 18 Mar 2025 17:43:43 +0800")
Organization: Oracle Corporation
Message-ID: <yq134epwe53.fsf@ca-mkp.ca.oracle.com>
References: <20250318094344.91776-1-linmq006@gmail.com>
Date: Thu, 03 Apr 2025 09:47:30 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d0dd41-8d11-42c4-96ba-08dd72b61582
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6FIY34+XNN6eL97/n6PQGrmx37gH+eozuWsv+AY5tz0ZjH+NdRwxhewhybrR?=
 =?us-ascii?Q?OLvCM///1jC1BcuF7tdr+Gc79MN5mgOEEefH7yLxaGeteY5q/G30Q1Vszr4P?=
 =?us-ascii?Q?MvDEOzjsWLT8JhR5tEiceEJrCWQNgattSFZ/cGrsUDUwCYduuv3S04mBSJwM?=
 =?us-ascii?Q?9UaTC71OvRKAeXzzw++Rb/xe4fHY+4Y/kWC4Dj1/EF3u+6Bb4cBrjMgp29EM?=
 =?us-ascii?Q?A9fxmZxDuSpkFaof9chGiKSUHFPcjAIKtdAJfb8BZdk98A2ZgqDxUza5NKbU?=
 =?us-ascii?Q?SK3tAFvCAGS2Y5clVK82Hh9tfC3oySCP/NoZOnNFjzlaJzkcX35dkv9qrIVs?=
 =?us-ascii?Q?fmyzfD9Yoj00O52U4leiDidIgh6Es72zldHGmuS3H3Htkqr6fEiS5XpUCIwB?=
 =?us-ascii?Q?SBlDOJ+xl4bG/xlskOOqbrBYWrwsWD5Lqk/bQhO+ujCKuorOov9V9ljn8Leh?=
 =?us-ascii?Q?y/xTV6ocqQfTUKwSX5D5XuV+/+iyaLCDQ4Nut8YFIZ4tquMe1ZY1KCfl/P9Y?=
 =?us-ascii?Q?OvFeReneRNAWX00HA9pR6kjgqVaqwOgQV6sSh+JvPNKryAH+knb6WvYn58so?=
 =?us-ascii?Q?hK1mOF24LmBW7J56HeOpIDy1Jqy4EGeFHwMZkEYlPD3l5vO2g57NzkuHYhrF?=
 =?us-ascii?Q?4D0fnCAKZlQUk0p4mg02F5aW7CWEFSZ9iqNhjzU5EGpsjZNzk+6M1TemNXC4?=
 =?us-ascii?Q?o/myEM8KBMaAEt5zxjx05f6dInBLX/U99KtLqWgN00vi0MlrKokDBrPIolS/?=
 =?us-ascii?Q?+IEqST2E8+DwW6DzbrybIpHaL3vGCgtTI+QsRfxc18HALa0rC6hHvbO2DnaI?=
 =?us-ascii?Q?lV+PWUKxsEzvUtoS1mLlMAbgV58qJeFyC8z0sD172QDW/bToMddK4o+C7rB7?=
 =?us-ascii?Q?59zK4DTDVybl/GsjWcCK2/4a42v2Jahvq2Hnb+t3JYv3E4LAzD044m/szAwt?=
 =?us-ascii?Q?aveW3Js6h75eknsqux+MxcwDWMra/KyE2sx11v0Q1lwHwSZ3/S1byIfSRJUP?=
 =?us-ascii?Q?eavbUIxjp/PVWxTZLL111K38rbpKCKXP+qHNymnBye6rz4Q8x/Jmm1HKZAtZ?=
 =?us-ascii?Q?tLRNXz+Girnxe3wq8QtXfbf1eKK+wYZjzLB+3hybtpbGu9MCiePXhaOOmXYJ?=
 =?us-ascii?Q?z/FBZkixfgW36Y6C6IE9xiq9O6eZkUEUYz7eu8axnIeE/xDhIkaChyvvE4OJ?=
 =?us-ascii?Q?RBAXkmnvJ3xwA/8/5GgxILtwuRCHzTRa83nMtWlohLxuYJnPqHqBT1Nu5yE+?=
 =?us-ascii?Q?nGctejPUAtBqAak4rXk2sR/jQWJSJUUy5nkTLqe1AK7qh+lQwIavutjeFQal?=
 =?us-ascii?Q?EKojhza2t6QRVyHsnCO/DAAeiRPPYe7NHD+9eD/rTeEyRDe8a+2x6iKXGmPF?=
 =?us-ascii?Q?UU395BvUnZk7vndf47xhFE2yxzd2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CX0/TuLdObNfQyixH4dr6aAXCeSWu/FfISAXmRNTvNE0E3lQnXuMuSx33pYp?=
 =?us-ascii?Q?+HPqzsXZZqNSM4p4/2y2ZZyksOspOE4JdiXxaieOhQm3dMO1xmwfiToKXlOU?=
 =?us-ascii?Q?7CwYR9R95D8pOC9KhZQ1D9UKRG4aEOURio95C6qzeE8L8VNW8a0O9mQ3yxbb?=
 =?us-ascii?Q?XxQdd3Wm8ToEVWvPvB6nl+ceSqTuTaNRr7jbDvLY0JwvPo88fnYvUo7FmCtZ?=
 =?us-ascii?Q?UZc/o6WzlKp8PI3YgwXeq5suUxQdpIiR+uDGw5gT/5u5QMMLrEODh4nDtyyw?=
 =?us-ascii?Q?9+FLlEPEnQi9qXmsdS7W6V0uHYual7OvX9o5A4hF1npI4z6g9gczhgg/5KiF?=
 =?us-ascii?Q?pq+5wlJYiayv4FN7qneUz/Dd13786q0z2odbtYY3m3vHOoGJH2HopVpYZu+y?=
 =?us-ascii?Q?MY9PXfykpW1vKnBUV5ZeOvTD34lbckFkS/MkDBxkb1bGNVKYHTp0RpRnQ0Ve?=
 =?us-ascii?Q?TQwUd9m53zPzysH6DODO7waAuVQj7G7gpMuZLBEzvzh/azvMr+B5njAsxHhZ?=
 =?us-ascii?Q?9XR9+kbr0x4PG3Ni8UfoPo/oA7LQ2owMgvXM9xkLIm8+VYr1ZXTA+M7d5+h6?=
 =?us-ascii?Q?uPW7b4GEC3FGirbsHVjZMPzQ7yIybEuZkzpdTyQs8LULsqWNhuTP0yALlhzE?=
 =?us-ascii?Q?AAdKkb87vXuLapv+sT5J7YsjQ57F0c0/I+KKkaVlh1fn4qUbsKTw7c4gy7dr?=
 =?us-ascii?Q?gPBKKcpc/W/fVwCGtN9mAF0S1nBGJA6oRq2njtLDftNV/v0O+AMkjKYwGz+2?=
 =?us-ascii?Q?YjzuN/RTQIkyt+7Ado/3jkM5Kn/w1Kra7k7pCvZM5yQA+0eNdULh0kFiQvlk?=
 =?us-ascii?Q?Ec4mYIV7PMhb2VcccQOwWsao1n3aECVNLiB+9QXpx2ERuF+66G3jAQEWNb4C?=
 =?us-ascii?Q?ZqDHvBurbBlY6lHEn1YlTo4Gyf3v4nz+heNOGYX0yUJfwmB6EgxV5R1PkOXP?=
 =?us-ascii?Q?CVVYRjOKFz8vkyt6hAyQlF1cQqpBJzKhARlHoaCJQc3M4KflMBi2s2JCn7x7?=
 =?us-ascii?Q?qSM1RkWf/FzV3V9sr+T4yEa+RA5L97f3eGayAq2i+DX2LS5JNBkWh1zo4aCT?=
 =?us-ascii?Q?6JroHzdJiN79JmBVaw9EqwYvo9as+jB4DFMkcF5YRtGE2dwPu830xI3z42IZ?=
 =?us-ascii?Q?kbVXmzNcDX24eLC5o8/JWf2z05R9JSICFr9Q5GNCa/qUD2ww830t5o8Yc/Zq?=
 =?us-ascii?Q?GTjfvx3jtZt/DBFrXfAPbkhEcZ97WdeK29Dmrv/FDUnwLh4Uq6zkZu2Q1V0e?=
 =?us-ascii?Q?r2IhoYvN6XT3KNOK+QFVAL/MyplJSjiacO50pnrDRuX21ZU1laNndUKCdY3B?=
 =?us-ascii?Q?lP2BkYHznbHxffboalOaRa8Etllz2LNQr9CO+MfAtJQl5AmgSaiaZrCNpeB6?=
 =?us-ascii?Q?vliiIYv4X1ATqQnNNqcPYECozzYY3rcrcwNq7nlSU9m7X+Sph2FC9ZpCJF4P?=
 =?us-ascii?Q?ubPm3posgtv1fLuP5Y4QwcxRhtgSUTrPOTCTHwXUMOmCviTGSOiBwXm8Y0lo?=
 =?us-ascii?Q?YVP/KDPaIN1Xjje6zRwr3cAZz4M6ALPlr0dq2kl6qV9E4C08WIlNjBcWxrGq?=
 =?us-ascii?Q?02S3zG+ZkJA0Gkm3IH6t/XCRWYPEMrXWgVVVebB9pBILc+h+qwn7mviCIMIC?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JU/qZD4uY8TQb+20OZGjdh01bz//3/qOzcJQS/KFHIc5EAkRv2e9BVEiwTtr3JvYO1IWsT0DB9VdOTeEVEtB1LsB4xoQ03AXVNc1ar1pUREP7MrEEnVSZ2l9fwvbJp7LB7tXSpsgrTH/F9D+TD99cLBQo6uUG820/oH/60Ef0ooTpOh3pDnLAr8MzNpzRNUEq6F1GAs02WcGvIGUojg9OpOs4dIQHTuDM2Y/LaGM4QBu1uvni1/KSV29h2p9dlDgNEcHVQ+R4zrVNHRIhRU3JBEuk+u1e6siAzGNOIXs8zlIAJGyfTEIf1hc8Z0mUTkL6bRfcRP/GFIgbmeuHSbSU9KODL1epTplQku5G+HbIjgl78TOiHaVGJIUeJ8KJLFJzt1iuP3Pzo3t+jb2/qL+EpOH5tfCQ/SqorkGo5g9sj8X+CH5IqBwKI4lT0M0qxw58vC5x8qs7PGdxrniUh0oTaFLaRKChREVrqPgRg1viOHEMtnEYb9FXHfkfPM+PmPUraMXg83EqZrFL7VqdYSPjvHcZfKcDA68JOcQBNOR4WcB8cUNHsYo/NBDwYjtxXsSFVQZfrM/xc+EvFulyCmRjz7v/me+rvhUE76bKNIX4D0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d0dd41-8d11-42c4-96ba-08dd72b61582
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 13:47:32.9624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uADkCogCphmlb/m1K4jxkM4SJR+18n0hXfVzFSx/VuBX6exJeizlBN0EsJAz2asp4h6H9mUJKRFc0LIFgPHebE7Zoene1plwargJT0JM+rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_06,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=691 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504030062
X-Proofpoint-ORIG-GUID: yc_CEu7gF_WTeL5EpCUjUt9Xg4WkE3fD
X-Proofpoint-GUID: yc_CEu7gF_WTeL5EpCUjUt9Xg4WkE3fD


> Add goto to ensure scsi_host_put is called in all error paths of
> iscsi_set_host_param function. This fixes a potential memory leak when
> strlen check fails.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen
