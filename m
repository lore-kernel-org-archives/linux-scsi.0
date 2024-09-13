Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B18010E3;
	Fri, 13 Sep 2024 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726187049; cv=fail; b=SZJ+4p8QmbeBbZB7WqPxLp6yA4dL+MqhyuAMoIRvEjb5Q2kp4tqz1EYp8fQZWpyC5VmSMvM5QtBIcgao0ge3jjLlwAomNerrOtGloV5ecLev556nqKUhs9kDiPqMHU6NxGBGgmJv4lQuCm/Zg6nUais/zjtLI3yXj4l/rolxALE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726187049; c=relaxed/simple;
	bh=XxOKhem16Ey6XG+Tra7sGmuX1l6DZQnaqua2/Aeduss=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=g4lIS6qmLkMkjzrVg6csoXbvytzU0QcMTpzuVfseokfEpND8KiTSJZz2sHrieFOogXRk/h6zR4BiGjeKashfEXDg+cgPQEfpWMsFz5Md6b2l6tHzFsY9sLGswqKRSKuKBCUsowwZj8iwmWqy1Cml6dScxT7Wtgr5OK0eLbZTrWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g0zJxN7O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tl2O63uN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g0zJxN7O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tl2O63uN"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYvI003222;
	Fri, 13 Sep 2024 00:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=1PLhuMtSmG6Cpv
	2kAV4Cruf7mU7Ht/XkUO+ijOvCg+4=; b=g0zJxN7OnXbN7CQB1fJxc91wq3xRJJ
	qpmC9e1J7Jobk7w0FOpqGUD9XGawgtJ4DqvpoeEdGEE2OoDZ25w6IqDdFZLVhaXj
	wFMaAmnpupJnivg5WRSJi6VMkcqKpTAkeYmTmsxxyNqVMLXa+d76FANfbhyh//9u
	5shQ101y6eCrbqI0dNx/apdayuZ8bSK+x6aXreNK7I77rjHbXfAtYAFVJspuQZEz
	1UplvIfdPa3FrzCRKGM0r7MzUPCk+AHhpIWIWrmFOBqMtdukNJAGRuYkvWsc8H0l
	ehe3n/qOjyE3g6F0XVNVtEUlZlyZMfxO4pTNQdNgxl8/tZTNgXVmMNZQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gjbuuys4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:24:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CLXb0p032400;
	Fri, 13 Sep 2024 00:24:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9jaacb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:24:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V35CDqPDTdjWI4zDlWX5u5rbCUfMGtIuDWUCmZmQyWSCBRAbHmioHSZod6VcReuQCz+9zFcFBZ3rl5YK4OzCMUaPUKF8oEss7bto9wyn4m/tXKywyh5wMm6SjcWx2pYybAje9Xp7YFAcfB/rkyCAJyAmfjFt6C4SVjetkgzDcvEu/ns344RZDiiS3/DrKeqQwqhvm/3/0lNgZj686Kz2EwSeej1bORBIlrVbof1urG1FuJcvNwVw+Qvye+i7UfcdBVjGoOX/7yvXAdECshnaaIctT/qeZ7yEs+y2Fmbp+IitDRBazv/WAhdEX+dQEeLsSa1zLFv+wItHnu2libNoxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PLhuMtSmG6Cpv2kAV4Cruf7mU7Ht/XkUO+ijOvCg+4=;
 b=WyH1/xy8m0sU492fZfy9sB9chYcmDjQ4ujZlaB51ytorHxvHlr3MS4x6/3heJZqud0TYnb5oYbQr6luXKOVvqNopOZ8EJ1/09s87Nbd+wAntpUvjVF8rvERESETRHVBmnnT+jSsdWB5Axt71Wz3N/xEacTBUAu6/dV67OC239DzKukKnmV1xw5kH4hHrQZ7HsiFQDFvzxh84XDvBQnlZC8N8KWGls/yZa5B+HkWIoytevTxItfFNyi4Wwj8ESxt2Bp9m+/R/UPiBJ2KwxFjm7AGe0+E+NcIY+PQLukwNAHtN4ODepD97phv06jV4DbJsI5RC/98AY53y2koNRDSgAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PLhuMtSmG6Cpv2kAV4Cruf7mU7Ht/XkUO+ijOvCg+4=;
 b=Tl2O63uNAH4rFNXNyBlR0CIHemr3mACWXk0X1KS7ZJ0KpDHYabtRFzdfW/pzCHfTT+hBK9XQw+G5IvbLhZLkT9hdmPrg205uXNLEw6eW9Gk6rdYS5rzlQakhyRSBCTb+Kf2hWYmwAt/ZTKDcA6FPaz5U83MdT3Jn5chsuUuOw4M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:24:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:24:02 +0000
To: Yan Zhen <yanzhen@vivo.com>
Cc: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH v2] fusion: mptctl: Use min macro
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240902013303.909316-1-yanzhen@vivo.com> (Yan Zhen's message of
	"Mon, 2 Sep 2024 09:33:03 +0800")
Organization: Oracle Corporation
Message-ID: <yq1jzfgz9if.fsf@ca-mkp.ca.oracle.com>
References: <20240902013303.909316-1-yanzhen@vivo.com>
Date: Thu, 12 Sep 2024 20:23:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0033.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::21)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: d784d8fe-d4c4-453d-9a26-08dcd38a5e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rxfoUybK6t8XXOpeExsQhcu/nWVbyI98SvOxUjE6pI+wVwl5NCJkspGtVq57?=
 =?us-ascii?Q?6isiICY37JGYOtC8mvxXP2nrST2AyxS7zPEYO1s6BGz9UB/bDuapnBIzOWBO?=
 =?us-ascii?Q?QUAReq1mu2ojf18YMl0OqizrKvNP89TVus9fgr62MCIislbUES9IxgaDm7x1?=
 =?us-ascii?Q?6ehyWxVoqMO8O4A4YIzEssGIRQz4CnO4OBec5ppxrwYO/vNF+XeHtYj+E1Km?=
 =?us-ascii?Q?QeyxbxsB9q2hLVHf7odmC3+mjkhxKbAaJKnW0B2tR8yvqxh0QDoyCujTIeC6?=
 =?us-ascii?Q?xhWIqgSdwL4CavXOq8wqU7CiyukNqGDsruYAGiIXHmcO/CiT62fU/YUn2OBR?=
 =?us-ascii?Q?iSh+4mCqcchRkgQWeN2fLCsqUiygrd/R33V88VHs0WG+2icDu97dLksWinR1?=
 =?us-ascii?Q?okFo2gkhc+Gv2iF8azPmyppiCBt4QmPudHmjJatryvuBeAx0WLaijuzKqhys?=
 =?us-ascii?Q?aWc/FkX7aZR6+0SaCRxd3MEYmvQ9bxCCLB8rkVnpU2yNlWZ5moct5oG57iRp?=
 =?us-ascii?Q?g6jO6erwAkR1srIrtLz0i40y64hODnXa1TZt1njs1lYkmIxZbcAAgPslL4ay?=
 =?us-ascii?Q?nJjttuf0axHq6lZyVZupyQngAdD8F0XjPbqxJWeqbKGDq6BVkVRXxuIN9dmF?=
 =?us-ascii?Q?RVb8ramvES+/9P2/+VOGUQJcCrvWkDWc6hU+iZKxsiIFn0aL80QxN+VQAP8v?=
 =?us-ascii?Q?ljQpBBO5PZCiZ50Qw6O1yv7d+Aa0ptp/XtnCeSaLhKMbBRyr9hqaIaf7sAXr?=
 =?us-ascii?Q?U7iETZZHq4BsmCUvjdBvWTt8wAH5cpFqJ7WRx5Wo/z9tD/5Z/BinffcSUHxC?=
 =?us-ascii?Q?jWZcPktygd+sLfaAAP9ZHxQyCG1PUAJGpgGG+iCROOJO3PSa+hPeLQdUZLMX?=
 =?us-ascii?Q?RG2PY7+T1ledZOowHoGPj2Y8s2Ap5N1jEJfXF0qrBidzebePegGcD19KqFbP?=
 =?us-ascii?Q?YgFiN67He2d9pN76KfEPeHa2uNxL8YNSkKnpEY+pwryl2GIn6SrVtUqmSNWP?=
 =?us-ascii?Q?Mcc948D2Ws/ddoX4UlGTMUV5fJVplc5i1BzrngY72H61CAAgC/F594wYfzFD?=
 =?us-ascii?Q?hYNsLl87vyhCX25MLavuFhZWjNPTRMDudXgk+Am+23M5xnXgCN2sqhzSdfBd?=
 =?us-ascii?Q?eyCD5SeiRrc/ncjxWCvFaQ0kOivbzux6TyRsGcLSn50X7rCeN8pTQQE62bpc?=
 =?us-ascii?Q?OCgxlPMt3PAPNPjO1VPguFEOm4wz6T7VzWqh8TL8eXJIoju3eVKFrpyrI+ML?=
 =?us-ascii?Q?/tSRLvQG+UYWhXcVTu3WeHT+0TW9QjR3Rj7asE55/iQLzZ+QBL2JEKyRuSk0?=
 =?us-ascii?Q?pYYOikqbRnGWE2zGeXQlbvcqL8NM8U4vPPjDwsKD7+18hg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VEEF6EsD+J9vPQDKZ12olDuAkHI6Ta5xpN1qw2ns/PX//N7iwvecDtp3XlQh?=
 =?us-ascii?Q?jNEpzcEPdOLdTjcGTfhVEM9OAWIyqcmEipVa4j2ck1KgNAjvgZkVwLjsiLlV?=
 =?us-ascii?Q?6EXVpjZhJhNeq0DHAoH6Ywjl7RIWwuSL31ZtpTb/B2ep0sGI7pt6GcPfz94t?=
 =?us-ascii?Q?SZJtURJB9L/M+DBQ4tu10NzW83xE7n96FERdQWh/8HnDU24IsjZS4aGuFTRQ?=
 =?us-ascii?Q?CaEh7pMu7NUaE1deECqj6IPGtlfuwHn7pqnzPCNzn7YZmMFR193a3Y7svg7r?=
 =?us-ascii?Q?87d5aK6IEo9xttlC61NllRP35Iq84T9zFNDxPCL64Wu1H5y252Qe5m4G/DqE?=
 =?us-ascii?Q?8+iVxgdg2f2+Qy65thqaonGszTWpHSEH97xlg3vB9srYxIIxvjO/HRdoGDiY?=
 =?us-ascii?Q?hjuoVPZulZ1eqfTECL99kCN1bVbMj7uEk9LaEtLgAB6cw8EGiSm+xI/AFPsU?=
 =?us-ascii?Q?X9iyre92RFeD5xKweEHkaDYbAE4h+OxZenBslejUVyCIlMan9lGaERmVKH+B?=
 =?us-ascii?Q?SeXiF4QSC9aatn82dGUyLxSbeOHs2cT/bQGIs0r+STQ6Fa0VRT9X78THPT2D?=
 =?us-ascii?Q?Oo+tQjERQV4Xz0maiZL/1/r7mVFFlw8HYzqJs/2+YMOALsLD/rE1vTxVyHUc?=
 =?us-ascii?Q?VzWzyFcBoE1czjfMKh5gSQ374anwa8vlEFRgXdxrBPHKLvPbEdZZENvOaBnK?=
 =?us-ascii?Q?yAHcu80lj/W0VUx+u1J2Ou5YbXs99D74iWyegQGZ1wJVCnmFPjPz23VE5XRl?=
 =?us-ascii?Q?KNMZBK2JmiSxek+v3IN39cvXerTbzFORFWEsfYOayRBrttDGy9z31sx1Hkax?=
 =?us-ascii?Q?FGnSrVf6VdqsC+3ZJQy68aMwEOOOXZCp+O4GTeVDOIRmab/aV0mLbGQghhz7?=
 =?us-ascii?Q?zvI+s8sdnEP+7KQHbp3iEQGgvtGpZ4yMWLNkh1Ae08YC3cm1ZvOo28xI3qAH?=
 =?us-ascii?Q?jeK6sFw+BDz4MDGEzgcfzoHGRlJt7Avj84ABPoirLVNXiffNpdNJorhAblPu?=
 =?us-ascii?Q?p14x2B+wvNpZPnWKVFa7YCc6ge5j5Gf2W9AFyfaU+LWVbPuUgI93dBtvSwMc?=
 =?us-ascii?Q?ojVUtJqwNFXvJUGBxjZutrKsL5JDCidjAPHHK/gEJ3wehVikXdKlSWz+s6Hp?=
 =?us-ascii?Q?5A0Ybd9nrdgQ/0Q/rLKGk1YswyMKE5qy9S/Rei3Fcpxg2AGTCvHIQ6tTJs+/?=
 =?us-ascii?Q?f1ga4yYbgfwsiJBGgn6mURjSngBYWuK1JijskI3yUoWSxVIDq9sUwyl5IVT9?=
 =?us-ascii?Q?SILeTf1fUzN7l0dR96plejeJJ3PCJjaQCaUVa79jcPBH5uB1/YLtyAwBpkIt?=
 =?us-ascii?Q?rB4uaAq9attUF0ivYWhAGaezpcpzjnBYIejHYIVCCVpPcZ8X6n0WgQAuKG+y?=
 =?us-ascii?Q?NReMTOQ8Cq8UI27h3RCg2nF7HL/0lDCIo89qz9nJQyG7EBenOPN0+2b3vvQj?=
 =?us-ascii?Q?WCrZ56QUol9im6vKNQKJ7Dv5KLs0qtNbJ4cG9UqOyCNVqfEp706cdeXzgfit?=
 =?us-ascii?Q?EXcrq9xDMdxdpbUeX30yPFNndPw9mcvpyqlp1oUpWAWWDUH2o0xm0+rUBKEO?=
 =?us-ascii?Q?nQYIF3qoF67lIXTnRo2aVKBk9EOy9+zURHLLXMKRvE21DuQvxCIWJuxaGeTb?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dBE9h9SGXm/JahhkdkGAngpZF1r7s2VpUOTCjhcBJW9n9usrLFBpYOERiwCHVofg3wvnn71Dwe5GyKs01aBK3qgcl66oTuetkB+AJN9tLg5XLh6zpSeW8CuQHEhsLhIFffn1kCwnYbixQDagSCjoqWmettldK/xFVTHFwAdAAIws/lRgiI40V0JjTnE4CCl/k6wIqAQSOryWj9QRboeinbGUIw9vOhOvczAF9vjiIrJ5lUUDduTsl32NBnXumTfQQfOWyNRzxL3aAtPKhAo6rRsc+seyFfSay0cEuNeaWTrn2z3/QfcQPyjZoT5H57ftTMMgRlw1EKMhit1FTEvjgGcco3ySQTnsq3IfuhmvvOm8syiOXAo0uVlZHnwxIv9fKTpoMZrk+zwyAqJhG4FpGgM/Ks/fBxDl5nPZVTrLjRu0UHg1uWSAt/8S9O4u9mW7BPFtapJVCV6XgIrgxI9k9AREWKcgKeBICZZ03DNaa4TTr/q3ybYKkpXTyC4URHfOPqmboXXLdJVBj2GFClw+GDhOMzH9DrZRwzgCmw/2DJObKT5ehH6hfZX199hhNL80ogwPF1LAbPnu9Kk6ucjyh2LZJJF7EG2lsqeu2gJP0Og=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d784d8fe-d4c4-453d-9a26-08dcd38a5e2d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:24:01.9817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcOkhbz3fLGwmW0SSBczxoi23Z3oB+K6TXrJo0YGxoXGyv6rSE3eTa1pvd7RHf3tepipPSmMmiPOs93ZunoLuYFMwBnTeaOyzXjqSdOJ0aE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=823 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130001
X-Proofpoint-GUID: fWp_9FpfkTAIOhWnc_4bnhMEORMxNca0
X-Proofpoint-ORIG-GUID: fWp_9FpfkTAIOhWnc_4bnhMEORMxNca0


Yan,

> Using the real macro is usually more intuitive and readable,
> When the original file is guaranteed to contain the minmax.h header file 
> and compile correctly.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
