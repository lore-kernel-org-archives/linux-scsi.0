Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956944C6D;
	Sun,  3 Nov 2024 00:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730594823; cv=fail; b=NnRcN4eVqZBY2oHbUjMu2WQ7+M02CtGeHby69q/xSSbTXG15+jw86BvZV9dT0XWyOR9hOs0CsBDl2s30Bqwopvw8zTSmJ6oh/SXY+WdxtpmTy4uyZKXVVnPTr988A1SaUNVAqliXqxUuv/sSx8gbtIobFj33M3OfQxBGJs85MXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730594823; c=relaxed/simple;
	bh=dDbgRWggcpP7RZ0jiC+S7IImG+mz8xUqkAr5CioxZec=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=B9oWdl2kiN1+U1hvRZxVDBHAIGCvmcW3ynxfDa55CwDSeQybx7LwFmbrqmHhGu74HDX3LYhHyj5uZYpwCjY031sBnMspyv+zX60y35vrBdaDPtZkjeZjvB+Iv+ftDv7tTB4Qo/+CRLPXUjvHM6qacfuTw+uUhbJ8VOR7/c+yGJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KkuTLHGq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tSR7I4f2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KkuTLHGq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tSR7I4f2"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A30AFR4025778;
	Sun, 3 Nov 2024 00:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=mLUl5V+c0KIk1o0jaK
	DzNwwWNL5OqKtfq8JzVQxdZEA=; b=KkuTLHGq2nC3UK8WlfjUNneP3LRcw49vH3
	SkxtAC/Qn4WemSp9C+7PnUrrUhS9VQ6gQbVyc95YAv2f9ZH43/n+gDPTf76D2JXY
	tcJo1OAUEhTdTAGZyZ1s8dH2u+O7+Iu3pbpAsorRwodDLsyFciZTN9bMunVyGwgk
	8AE0CABP2d1S0cqRxPz2+DlMTjpf/b6ttcjthL4ma0K2qGxI714CjDx0yBNpZmLK
	9alHk7Z8ltHHxW4oX03lOmWBaGR7+wJ/eCnOb6LoCQTFaAs/wG2X6nVj6cZGSEIq
	fJTuVE0+AbUuJ2OD9qvvvtoJbBUBkzNtVF/v9pDEpr658RiBemqA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nb0c8qf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:46:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2JFXlT008396;
	Sun, 3 Nov 2024 00:46:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42nah4hs0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:46:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JifTSbQe/SD2HtsoY9UkwRVK+X9GKUGfSdjDiplo7hajD6x2YeX5rx/WsTz7iDTNcvJ8f1dtkFzA5nXzBvKivlikGt2WV37vA82HDhmv+CXbOSIpc9y3pFEjELilQerXSMigPvZSCmmsjsYz9fLkb615uyRTrFX85FypEnkzf1oGohlyXlYhzPomKcf4zrd3K0XgPEXTGp9DbnQMyTu9uoriro3ut56O2hjSCY6bUGDaEiLa3U9Yr53EtVYR/mcQPjPnb/Xvhu0Fy+DA5j5UPUV0qet95Q3LJ6D+dyXe4M8hepAnRRK6OOMszvFEBkKu+ADVW5PtKcHhdU2yd91+3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLUl5V+c0KIk1o0jaKDzNwwWNL5OqKtfq8JzVQxdZEA=;
 b=XQM7ubiK07Acu1Og74vXEK1JELLePFDWv66txliTfmMMoupeu8x2n7MoBn16mVhXMxDNrEgxOWTvHgogxa/Q/d8gE3bdLq2sihkaF4HbFzDFOEbskPYiZdwSx+u53diGGRlpJT8b0DzgHnMTSLmSXJffgmaf7JHIDZWOL/EH1UZn7XPBjW2M+LyfumE9LV24lsTiQ/5y8VfP86BIvnyNGbCuaW6cHp6mlCsWC9CPqmqK30B58aayHFKh9LD2G67K9YMBS4h4kGjbu2YVEXxFyWXNRud2Mv48wGpTMw59XcGbRe1jRxs2+24x29P74ZdsnK+hCNyfoAjTqKhQaK17xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLUl5V+c0KIk1o0jaKDzNwwWNL5OqKtfq8JzVQxdZEA=;
 b=tSR7I4f2J4M6fdu1HBNpiu9ul2n5y7K5oCnVB9IlymaNX+UoYOcOplK+nvNoOGdTqqJsky/uR3QBDiCzHXxuToh+wjLxyn2Vwme/QUhq64BwdZ3liVrxxxQ789ce2NZnmFo83zyR6NVeIcCKlstj92LuQHShosQqfdSDbpjEOME=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by PH8PR10MB6357.namprd10.prod.outlook.com (2603:10b6:510:1bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Sun, 3 Nov
 2024 00:46:53 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Sun, 3 Nov 2024
 00:46:53 +0000
To: linux@treblig.org
Cc: linuxdrivers@attotech.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: esas2r: Remove unused esas2r_build_cli_req
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241102220336.80541-1-linux@treblig.org> (linux@treblig.org's
	message of "Sat, 2 Nov 2024 22:03:36 +0000")
Organization: Oracle Corporation
Message-ID: <yq134k987qd.fsf@ca-mkp.ca.oracle.com>
References: <20241102220336.80541-1-linux@treblig.org>
Date: Sat, 02 Nov 2024 20:46:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:408:f5::31) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|PH8PR10MB6357:EE_
X-MS-Office365-Filtering-Correlation-Id: 845e75fa-ecb0-47f1-d7e1-08dcfba1029c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jsw2vvnEqfLGsBF+2sRMSUOzM+qX7SCz+2kufY3CKxBeh0tXFnyhh1Y1EmSC?=
 =?us-ascii?Q?ZXLOvmMP1dgt34zMWuVyWUcmxelk8g/gYqa+Dcrdo+h3Yb3XPJkdwccedBVw?=
 =?us-ascii?Q?ylQgyHS5aznniL3WHcFjDxgxN+9H9QfGO1nfExWE7ZrmOiVmL8tXsYcwd9PV?=
 =?us-ascii?Q?nK2ALCuvaZDgOBj9igKx/MCijgQ6aNwrOJHHqb3jIeiC3MpkOv467FS42SqQ?=
 =?us-ascii?Q?WiLaYGKWOU483554A/T0bvwNll7DI4IMa1VnFNf7LeTq7Iyj84tJL6m4Ezea?=
 =?us-ascii?Q?2FtlK7Xe5Nb0Xbr0t5vUICocaeYaARZNfI08StuuH8XbWxYKsCZRJsitbjrd?=
 =?us-ascii?Q?ZvNjpGHSC+u0N8r32O4OEoU0/Tsu4ywdoLD973rLnew+Jav23dw2AU1+Pa4I?=
 =?us-ascii?Q?GAN0KCjBNf4j/T6lGkCWDZAYH1AmVKwXirmb76KPcucTI0YZLHvW6P8nkt3Y?=
 =?us-ascii?Q?ZcpPv9G/9rmQsYmk5U+ufWLY/sdWuPdO+ubXmc04tIHI9Jn21Pjl5bCbE5PB?=
 =?us-ascii?Q?epNxLAqnJlJdb5FppCHeowdjAflkTXcnuM+wghjHZIX+qytJPAaecOmVw1AO?=
 =?us-ascii?Q?G+T4k3EgBG444mTNFOBQlLs8FYd8jiD4EuOIxm6oeJs4rDJ8Z717NhfVRg4e?=
 =?us-ascii?Q?t2PkmXRr52vcsSOLWdsH7eVcXqzz+FNlnpdBHYOpsyy7sjrd0BjM1/M1zWPb?=
 =?us-ascii?Q?TFewbGF/CcTOkfFTcwgMbNL6hHdlNBysAH7IiQU7S479tVU5y7Ns2DXHFt5y?=
 =?us-ascii?Q?nnzTF+ojoYeez+B2eK9gPXNqJ15jUOBxk3wkDJfe1HrOsbF3YR4Nx/zFWJoj?=
 =?us-ascii?Q?OiYIE39ZBs5PGN+D8r82gH15fp/iX++/7bii8f2TcinViUvvLlZy0hOVp3Zc?=
 =?us-ascii?Q?sypt02ahUOuaYnCAoNZg3eC1I06eYyE89t7YMrcte+yiQTIO/ulBRkTovhvH?=
 =?us-ascii?Q?Nj30e26RLoHbUmmuJelK4Iw8DQjmqEpUTuvJBvoikblirBowUuexLirafv2L?=
 =?us-ascii?Q?PZ6+Mz0sb9A9lcIfTwRUdwrrIt9S8DmvXfjKbeR5qJnaZlvURNsludeEe3Ip?=
 =?us-ascii?Q?KsrUYieBK/mNbuhUuklALvQSYH12ozeJMxp0wsojiXS1P/OcupdbM8276Sng?=
 =?us-ascii?Q?XQK3V3PTD8UDY5xBkp5MQYRZ9k9TTfdIE733KMZqxuSHe4AzkHgMlYlbu8vJ?=
 =?us-ascii?Q?iBfvmM6NrBnQOLhdYwo/7Da733byvWg7DT5CzSW4JMTEEwBbM+7bM1xSxaDv?=
 =?us-ascii?Q?AOhvGQG8QZp1FbmjV4zTArKtCBmZXd+oVpV3ffb9fWVcQ/V+hq9cUZlHgdCl?=
 =?us-ascii?Q?ysoTnP+tWRrc3+G0DNMgyyjr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ihNrlV/fVjy8+aooVMG0p4l4pzOkewfqP7ZHiTuSWAkoSIqVoZoUbyZWQP9d?=
 =?us-ascii?Q?x90DI0rwlqtKzjS5+0vC5Gpfi7Rk1AFQoYlSF8qbOkLvP3WbRdvGX5qlcoMH?=
 =?us-ascii?Q?afC0Bq9W3IkhNyPs2IWcQNkOtsTUaKl4BgVW93gOeQvRz/i0Q3p4afhwaz7i?=
 =?us-ascii?Q?zB8UxPz6oTp3kb6yGhv9PjGKWQCfodKM83OoHeC7FMVgADpi4HmOOFaaYOnP?=
 =?us-ascii?Q?O6Z6FiIsTW1/ii0dRHzuCO12OmQm3Oj/8S8fmX9PRea3MVV2isO0cqvSiWdZ?=
 =?us-ascii?Q?9vGv2Prif1U/iVdeAlWC1wtfdBH4tDoljSnCs0pBXwF3ufH+XQ/2RK3LUMZT?=
 =?us-ascii?Q?lsLCDxoYYTtvokjo609IUvHVY2dnUwILJVig61ddbyqotDySj+nYYdqtklrO?=
 =?us-ascii?Q?OG8V0yZ0VPmRU+Yt6ort6Cn3Cp8g1wNNiB09kDUT0oxuT51u5nmUx10w1LZj?=
 =?us-ascii?Q?g8RiSmeZHCl4tqMBS4zux8XnHiMi4E2+5/wv3qnVsRVKCuPMu/c6Nvju2PnG?=
 =?us-ascii?Q?xpkE/QP4Hy1wBL/sVJtw/KNG7DWJr5dIyw25/SnoRiz0PWroEREfBbCI7Lrn?=
 =?us-ascii?Q?+DQ3nadYfa+cpWKI3cUoEmHInc6PiiwjCQE6PEpa/svxNBXJeGKQC9isD7bH?=
 =?us-ascii?Q?P7BmQDNh4sudp6FfdSFhMIGTdfzs2nb+T84sjqXaK3lsIZqvD/j2FRkdx42O?=
 =?us-ascii?Q?Z1be5AQBbw+6PDMDCIrkNzmrDYPbxn+RraM5Tw7lVm+QGFmbhAut2jTqeVQm?=
 =?us-ascii?Q?ai6+WaqSDhs+jEGpU570E7J72oLrTE1yuA1/mD7O0Y50FfZ4X09ACNrv6Khq?=
 =?us-ascii?Q?5yfIEVpOeEVAPLw9yuJ0ajiqKLotzhD63Cdryd5GZdsCiqIxqZofkfg0vm4j?=
 =?us-ascii?Q?6yD4a18ALpM9jqG+diTMlSPUDOBtDmIUGrZxJJlFwEItKYd8LEg2SmN3P5e3?=
 =?us-ascii?Q?s21IyHofoA+3NQU96LGX0dqxr4iNeUhjN6JUwkgBQIAYAXnZ3sgKd1F3CFVg?=
 =?us-ascii?Q?qWEzbuBRWKNDCEkTJ1I58MJIBF2HhXeQqyY/7A+bZcsVGKBZNkKQBcB/XXi0?=
 =?us-ascii?Q?GMIKp+MYh012s5dKFtzf1S+7W9Y4NjV9snQdQvyVbP/6tgA56DAxtzz2uyHh?=
 =?us-ascii?Q?dLsSV9HUrJ3510V9cOztJ8ABdz//vPSO6ky7XpWU/xIBvz6s8AZVvKnI2gEJ?=
 =?us-ascii?Q?NESrPp+j5h5FsRMZzRTX/cTgAVlGSzBCQzOywdR8hJ+Zw4INIEawHJzOZvNR?=
 =?us-ascii?Q?WCgt0vOh5JB8S4uVeCe5OdghThtVOkrndnOJZeKXjpyGzlVB/yfcGDIJJ/G/?=
 =?us-ascii?Q?HY26alwM1A8bWJO126cp2GF1uRbL4BpOiOYOKqUdE7DJcFsRzMGNRqd2m+W9?=
 =?us-ascii?Q?C9NAFLyCTcjau3E8TGOMHSTfiY2KC0wOdatMUKFerNpLGhEjr1j2pusTZv69?=
 =?us-ascii?Q?cMg9ospD/OUXB8/D3i9h2T8VuVN8QLFJyyh2xqqghFLuvNfohTWjUSxmIuhw?=
 =?us-ascii?Q?tgDSaG9Vng5wrwcLOq/X0gw8EkovBkICQQcnl6eo/AmQNha0kS1g6ur0zaEp?=
 =?us-ascii?Q?Xy/aa+gr8RGg1KBKdx0xlV0nedMBVFyHfOAhwkRWABLCU735e/voIozA5414?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N7UOI8omjNIid2FdZQxIB41sRnOCgQZG5Kw9InTGDIRz2DVs5Hi4Assahd8uUO/g3vmKEl0XP0cU3Bkpmz9PY+C3PCbgwJXgLvmiheWVPfZu6tPJwSEQAzHRvtJ/Fb2P+excvHPjSHYJMRI6LnSPS2Fv60zHk7KOlZiDxLlKxVok2ayrPGrLatNMKe2+E2BmYpx6u8jcjG2JJbnLfvZqX9uLXHiSN/xsosipP/JtnuZMNYZyN05rJtlT3c774l97XY52qk/VrSZ7gm2vRYBFlKRqP4crl0D7g7oR3gkbSAoBM/SR2xJ3fXQl0fmo+41XB768ps0LJCNs93aX2h+n8iW8wtQTvVTnkZDD1PophyCMw1/C8JO7/ac7xQaBerGHDZitrEUDxMxRh+RmA7tBpXLHOt676hZzCaRHeRA40/VON1trtlZsA309SXhteZjf6cXFSCWLsNVf3rjqF02/NyJUQuDvuRr0pVaxQ2xiCTvuDtXHJpzmUzt8Cp4ITyMMcKfu4jGTK+4YenNp4LwKGP2l2Ok/P0mw9iQdG5bkohQVaiHHnFsJ5ATkR34xOWq0CmAHUG9MNMRJEt8n/UV64d6Q47PfEfNc8hzjAY1Sas0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845e75fa-ecb0-47f1-d7e1-08dcfba1029c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 00:46:53.2885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bgFuwQbn1NczW2lBbjYKARg28kiUwOuMeybgl/n6dYUND17481XslYEuB1lcJCf9f6yUH+Z1LnRkZepjgm5oYpUPCEozz4WI5O5aREilXVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6357
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-02_23,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=595 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411030004
X-Proofpoint-ORIG-GUID: c6aucuItazt1R3nH1p27rd9klDci5F-x
X-Proofpoint-GUID: c6aucuItazt1R3nH1p27rd9klDci5F-x


> esas2r_build_cli_req() has been unused since it was added in 2013 by
> commit 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G
> SAS/SATA RAID Adapter Driver")
>
> Remove it.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
