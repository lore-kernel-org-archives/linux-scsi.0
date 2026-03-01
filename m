Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EE92FD1DA;
	Sun,  1 Mar 2026 01:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329826; cv=fail; b=QyTkwsoEcHMR8/iua/LK+1+McC1usKH51LXSD6CECriP4ZFNxRkwmzq/EzY73xxUjsNqPmSTTBn91fI1ovPdFj94c9ySYNvCJY3FJooZvifdu59KFRQW70xaR+LS9jUCkGIsVj+cOcYFc95rrDv5pP+72BNxchwlOpm56gGVEM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329826; c=relaxed/simple;
	bh=rv7fN40wFZxZsHBbpHzhO4shqNLsTyysPRgaBksnj1Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rSnDNHfrqPIcIJCpH/brv++IERQwcd7aJPNmcO9BqvXGVW8hHiNxwJv8UvgF/xDrqQ/T9r5CmlHtIdzpFltGSywm+4jZaeGQRvY7pFvzNu3MhFE+NVBknkP5WJVBdcW1zhslsyLjdFgaCpLQBjjE3VTXAxGvDnriq6Tl6JltqRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MPk+QExh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RXhYP+vI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MPk+QExh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RXhYP+vI"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6210dCHt2844022;
	Sun, 1 Mar 2026 01:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TsC9j5tMoBQUj/bcJG
	QhXg56sRFbGHZrx0rwli9Xgfo=; b=MPk+QExhJPlEBMJ7yItWKvZiCfdW6I6Lf6
	Zyrfa514H9FdKxlGYtTNgNQ10cN6Gtt6Y5RrmzxSspyHZgDy+ft6k6MQlDk3duQR
	mpAIOGEXe4J4fYVgY+HrV2MX6e1PyIO0zX58Colb6h93YHfLhhQfjpLBS096uffb
	5yCifvLi6ydjJPbbaPiggXyTZraJ/nyphwyues+5jEub1OVC8n9traqNYzPZ6/Lb
	iNNE+bl/poyK9AutPjGKYKWDE9qkoMsMy/5pcFYwUHc0LsD/sL1R9kLE/eXp+9Ea
	pJmcEh0DGGJB+QFKfCUrZhkRaRS42eIjrjkm0nb+jTLnRJdVozjA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksh8rn9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 01:49:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SNMsEu035232;
	Sun, 1 Mar 2026 01:49:46 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011044.outbound.protection.outlook.com [52.101.62.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbpcqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 01:49:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1snNuvj4vzOfSGB6cji1x6WRPGMyxDm7YXqz5XecBXEg8351JoL4KVttygw277xjC7ItOxmU/ryIj+LgiHmAjbMYx7UYQsYRWEh0NYkMxi9tinlyP6YLkP/N6k5t3U7G9kv6oNhqyiCKvM3Xu3tN3NLGTeoy07NS+bi6YK9tkgnr+cn+aQrTDZMmZCuDM6qFX/Rsk+LFvcF7lWA8qjEm8pS5uy7VhRn6Gwzawin5stH4Y1s8BRWUO3N9gAq08kmbKsqwK2v+as54eFG0B4NFbh2A8/4m4zUOA84SL5lsMlA1wAeFFg9RRnhyDY66si7Qo/dMlzJIy5uQ6q8jKxv8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TsC9j5tMoBQUj/bcJGQhXg56sRFbGHZrx0rwli9Xgfo=;
 b=amTUVyGlwHzR/lQLNktoCCPqSgCt/i69vBOKpeHHLv2J8ojdX9wfSUOag2wP4EtjOPT8HXE6cS+ySilrVyUEszcJ4/gZm0B5m6RKrvNqRwf+wEfES2exTSEGCaJrRAYWgAdMn/E2FljxCV3lRMWm4OrctZPeg3wgUA7OISUbTZGJGBJO0iQq1lPSOWV/xoyU8qr4jk5kaM42vdjBN6koaruIgJNAalBwG9wJrDjQxZxxMoinEtQw++lAGW2GI3Fdyx+D06IGX3CBeCc7kpYPo6Ty8FeSZtLA2seZFiIJy4nQ5AAEPMSPVo/51sV21RdGFJLYmTf2BcKoVmDm5rHLmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TsC9j5tMoBQUj/bcJGQhXg56sRFbGHZrx0rwli9Xgfo=;
 b=RXhYP+vIepRR8JWXze1UewSicuJ+yYaU6l7SQPjUeQeE37FXHNFYsTiLY9Ni79LQNqly//5revB556Rq7nSDoKsSC/BGuLi1hH33fdYlFQC74o/huhY/HS4ps39QAA1wHo4yW/DDieTsK/PBj/memrSLlA/tuHx10wQB/LbBg1c=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB6744.namprd10.prod.outlook.com (2603:10b6:8:10c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sun, 1 Mar
 2026 01:49:43 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sun, 1 Mar 2026
 01:49:43 +0000
To: sw.prabhu6@gmail.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mcgrof@kernel.org, pankaj.raghav@linux.dev, bvanassche@acm.org,
        dlemoal@kernel.org, Swarna Prabhu <s.prabhu@samsung.com>,
        Pankaj Raghav
 <p.raghav@samsung.com>
Subject: Re: [PATCH 1/2] scsi: sd: enable sector size > PAGE_SIZE in scsi sd
 driver
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260219043741.276729-2-sw.prabhu6@gmail.com> (sw's message of
	"Wed, 18 Feb 2026 20:37:42 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ikbg1fq6.fsf@ca-mkp.ca.oracle.com>
References: <20260219043741.276729-1-sw.prabhu6@gmail.com>
	<20260219043741.276729-2-sw.prabhu6@gmail.com>
Date: Sat, 28 Feb 2026 20:49:42 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: ee9e16a6-cdc8-428e-eabe-08de7734cf5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	afsONh8hSJW8Tow1MuRZjGAILHAzSK7Zgl2ya/p7px71Nn9Ef1d5hwuqkNYCx6shczZg08wQkuQNEtjbvTbMPurkzGLR10MerfG1XMPbckYUjlnGP0tNxMzUP6WfVgyixkGi1I5H1XjfRDtj9SdtFSvhEBztHvKh+o/81Be+Lb8sZJ6q9M+JZBbJBgl9q/+xus9VvDa8UQDokJ+cswB68aWFM65CDiGxINQzkEvm/3K1w1FC+2d6o4u/pRh+AvFNUatpjhDO5zrfXARY2TowrBGaRasoETIK/Zn7nh8ig08iP1nbPYjVcQ+WhczkkrbLXhMmf6SUwHEmKEFNmHxlNVZsDv9BWyic/6TXNOUnQjoF1DSYwfrl35cF9dMaUsOO0Bl9HaZdP27wviPCqEAbCtizE4A0WdTYDzoyCWBLJywcEbtpHIQ0whoz8AWsB92Kr2vry8i4mKpxOOO9CN55cSbek2fmMEo0BcTX7oxZatojRj3j/JXzm7KdW/sGtNbj/sXol0uLEYpiPEhM8yq/wttM7WM3cQn8IL+VKopQqYECoa/E7G8Oip+jfeDVd8UY+G5WLE/XQRuIAq03vWAcAcEALyuZmSacCIG1qZe0A3j6yyC1+MRcWQeMPQ4sJ5RDZCxp9vdBWPQ4KYnG9Lg2BrMCPD3rjeq9hA0xlPlD83tzymuAl+TDCAJpbu3UqVlU4TenBPR9ol+IuZY9u/t/TgQ/Y32T3KuSi6aLt9n1wPs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zNQMUAlECphRvfAmCXRgITdJ8OVJxTuKZk27eU3c8cXkTdzkBS012z3oKo+L?=
 =?us-ascii?Q?6hvrUdlQtygfmPP2iktjXVw+SGJDsRXeUi8+DtVB2PE8yhVXt4lcSrOhYCMV?=
 =?us-ascii?Q?IbfyvfOPDpWALyh5kyBwAP5B19HUjhod4fmBCDzyCdDuw/BuWz6sNi7DFRTB?=
 =?us-ascii?Q?RY+Vw1dLrfCLiJ49vcscJ4AbfrX1HamSDfwFrFb49wvThrC7hseuFjZ3G7GD?=
 =?us-ascii?Q?eVraJBIpznemKFQ8Kepp5fwDXZPLmArFN/9o8gYyhv5vRNCMK/xhVSoiPxNO?=
 =?us-ascii?Q?jlab/QI34SIIk9Dz+3aYCE9tWQGUhSGMYQf7j4bBeU36rPc5YlkzfGBIQ+Wg?=
 =?us-ascii?Q?HDF/iSEAP2G+/ei+8FQXcr85F0ouJBqcv5TEyP3ak8F6XHrTMOjOHh6owBKf?=
 =?us-ascii?Q?oj76/9rq85MncREU1sjxV4OR8cCa98sf2kbsbHQyc+EOeSoC3iIhqJj/RJHc?=
 =?us-ascii?Q?pUUoIiCMnNdgPynJ4K7jNhkM25qjItO3O1uAmeFakbTDil4AtUSz5Bde02Tr?=
 =?us-ascii?Q?3PHB0g0N1YSNV05xc1Z49qzxe7SFau5PZPUKtgMjuAX/w68kMvsRPfGsN8+q?=
 =?us-ascii?Q?21/A2FFa6WNLU586aeOxpWUdNfwECAETxnIyBEGZ2G6Y9PD9SsoknkaR6F6s?=
 =?us-ascii?Q?lvBndF0bpMMm0xAs4feX9DQbhrRM6tMvvTs7x8+/6YKMTGHHUiC1H93FVmdU?=
 =?us-ascii?Q?EzxaAupnPSOOn3Asm/zTCu+7E2uEAf+WNaSdh+tZGeJU9L+HPB7vaogrSCVm?=
 =?us-ascii?Q?U0wO/dI+la5xSEmF17zb9zaxLlY4gcqDtBmb4OJjZtlwVo4lzJpCzMMlWeig?=
 =?us-ascii?Q?lInbr8d66JTTQOZYo9YieQBOTtcSea4Xbq0IYdjpTbXGrRxf6BDlpGeHddiS?=
 =?us-ascii?Q?TJpOOfI6bNL44QmVb4XdCIy2E3+JdhIKpk4J5MXlznOE+ehQR/kp2Hy2/4Ze?=
 =?us-ascii?Q?fDqzYixiSIHqjzD1ArO9wWyJBAsaf0xTtn+VqxNWxijrmr4WvA+Uou2tybiy?=
 =?us-ascii?Q?UzTVH0QQfa6HHFH2qcNacy84MULNy/nER2gf9c1UEWtMQ2Wzk9EIcitoYAMJ?=
 =?us-ascii?Q?JiFCx+rTcsgc/Q9szV+EI1DZrIZ8t7fxBgp51gARqetAt446m+J20ENMtlvJ?=
 =?us-ascii?Q?B0HqIgtE43wWXO2KdvRuYu0rrPsfrOvAFSQeGZF0pr8Bz3X2vWhEX9ObQk04?=
 =?us-ascii?Q?AGprmypU0t5UlO8Q4B/eo2OP80PljRk9ITH3b4jLKhGq6XSFa7BGaGpALI7F?=
 =?us-ascii?Q?urVSj/yc8A/bqxzK3PU2e977UpFLbMWG5fVEPS3cSz17XTKnQgjhdHvXI3tg?=
 =?us-ascii?Q?Y9MG8aijVMuTRHNGq+ga0L/3iyGRWpaNdIWknr5BeGU0VrvvXGv/o2pXYWKj?=
 =?us-ascii?Q?qDYTlVGiRug/YY2mfpvmafjnLG0xTrhGkBonm3+3GXbQIUXzv4V4bn+3hufs?=
 =?us-ascii?Q?Hg8irXGGCEd57JFwNyp4TcVlElweVFc5LgBerOndjdhRKSHemIbSE3dHRq07?=
 =?us-ascii?Q?Iph7rL8biC1vw9IMVxohKeMdydqp5RPXcdZ575HFuRZ2Xku/nQ38ZPYOlpRz?=
 =?us-ascii?Q?++XvdNOEwXpH84QsVNHdo31W0oC/c5ZhGobSoQe5GdthXyegnutSo4cpq8mi?=
 =?us-ascii?Q?VAhOuFQjw4T9agf4XcTenudjUxjQvjr2ZlmnDK/h7ImySYP7IwVFtfU38ZQt?=
 =?us-ascii?Q?lCtRUyjXIoa6D4dbr3RqdAaK09EgAOAGFWlgoflVCFL9zTMe65NPVmMRAs14?=
 =?us-ascii?Q?b8RaeQWVSI7ZfIpgykU/Kf05RL2QeGo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ohMaXEW5E5KNncJhl1JUXmXJbKfMjeqwHKWP7QRRTbbJ6jAeM790mwbNJktRaEWfhxky6ySUk+UQXhJOgApSEBuZ2MARPzsY+ubXrA/ci9ukH3tiohmuR7g6SLLE+Iy9XCDvqqxe7CfFo1AFaRPT+SM7j4f1YcEEuUPbb2hzxnmSR81SNuLUtCFlE8U39YYTBdfaLO0ISVMPPiUprbvFpBnLcmVTH6gavnlEhMZ+xSx56WVcSvE/TAc0PGvY4uH84tO4+2UCUjlimKG+CehyXGi6T0vWUaGu8Opz5pseSOnHLu+YNNTFVlXOmCvrAVIlvx7/IOdeRv5iSAG2cgZiqNZGVnaFfLuvpG7G0cR0bGssmxhlIQhfSV8QRbcPmLf6/o1QrY1ZlMaf/76ZMPHJFppV2G3U1Ns8NPZE1/DuMHxuiObjykG6TPl/jsvEKtnttCfg310X3SkIEd7ka/KNDAHZP46r1aIcYHTKsrd5kB/5pEnYQeoHrNyCSurLX3frlut1k5f69bs54GpzR2shkUFBYfZH0CTaif8hM14MsduKFGBvrqSegZ25geLbXVNWnXy0gz7TWzUxFX1hjTZywY3UZClWDJr5P38RqD6PzK0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9e16a6-cdc8-428e-eabe-08de7734cf5b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 01:49:43.5853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RA9yy0Zb6MBdaVmmZLH2xrsWa+XmSleNVQNdg3dxcepb/5d8ZeHPhdcI5Ri/965gVrkHIxMfeKoQYUwpH1LvlYdv8WTf9yVHjGJ70N/ZloU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=646 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603010014
X-Proofpoint-ORIG-GUID: ng9hzaVVXHHS0DANIL-2RY-YO8EAiMuW
X-Authority-Analysis: v=2.4 cv=D8VK6/Rj c=1 sm=1 tr=0 ts=69a39b3b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=dSLqjoPzUDTRVLwyG-IA:9 cc=ntf awl=host:12261
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAxNCBTYWx0ZWRfXyPhTwrEVTibw
 J4v2T0NZ+OVY3QvG/Gjw3RiQoDOzKtXE9gTJK+byT7/iXNjApJMejMFH8fERGuG5r7veCxrQC6X
 D6uFEpOqnSlQEF6Mli77Io83PQcL53AX9Xle8f0RE3h2D+ar0I2r4RU+kENlmsGmUP9xoqqQd8w
 aeJR0iHyOPfZe+McXaSvl26dw4vnlpJSAftdxY8h/t+XESbBNR+gKBeVpRNFLvU4mA4N2WYTF9D
 rl4h0OT/HtarFjaLN+K4x+cHsZeKMkEfqPMpRAJHMEZbMrfuu0ySbrezp1hvrIBhEdaPptobc8f
 gmfBPCyDo9RZBwfu5rWFJ5P0RkCnIjdZsnI++1X7rJKyEPmD4x6lHcAun0SP31h+vlm52PRCAmH
 kpiJJ1uttRqvGgkh3CJy5WfcfRnNb+Dz+volKYzjo55bc4KMMRkZzhjimK740AmnDyopdxrD4ns
 8cCzvgEOfygAIMCLA63a8ifg2AfJPJzSvsmYgXGQ=
X-Proofpoint-GUID: ng9hzaVVXHHS0DANIL-2RY-YO8EAiMuW


> The WRITE SAME(16) and WRITE SAME(10) scsi commands uses a page from a
> dedicated mempool('sd_page_pool') for its payload. This pool was
> initialized to allocate single pages, which was sufficient as long as
> the device sector size did not exceed the PAGE_SIZE.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
