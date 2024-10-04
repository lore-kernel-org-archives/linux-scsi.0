Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31E64AEC6;
	Fri,  4 Oct 2024 02:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728007242; cv=fail; b=OYxW9LWMdaFCGSrv2pSfzcklN+ye9ApBlSnwDDu2mDQDJMqIZDIQbCm684ksQkVRbujbipMHpenPiWcqDCkdmip5yN+KjU1UrMBNwC87hujJkZ5QpNgGNyoBeSdWxRca6BwAnkruf8aRyHE29W/OZV3ueuaI+Pj+h2NmFbMC+/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728007242; c=relaxed/simple;
	bh=UUXEE8ubzS25I9fZwjPBHX3Bagiyn3Tc1+Fv5YoKZtA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=T1nC87Ideg6Ay7mZlV9DcIduUBRMdIkkTTENm8eVtqXoj9QBs59HqAGIk6S6cyWjwE86h4FS2XydG8UE3fRnyp2u8N2LEOBtmAH1/6zT1RTJ/indA8bKCMTGR5VP6K/5iLIU0lf+/E/CmVnrW+ESufEhStbUlfaa7QHDHtenbzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QG+ePo+8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qVlLyHvO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QG+ePo+8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qVlLyHvO"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940tdbW022823;
	Fri, 4 Oct 2024 02:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=fddAMkOUzP++0v
	7YbJ04zbk0iAwMzq2iXRfivyGFpgE=; b=QG+ePo+8ZBRTY0O7hqUWAOC8rvuoxm
	9DqlmJP0MABL4uXo1AfsANnnLUf0uBif10Ei654OY3CNHZhv1HyQaKkNXyKOp1/m
	hY16m8vKmomsxotGwBc2PNtqbgcPCKIwneYaPYVi7Nn0y4TkiTBP6EFNB9Kagmh7
	v7RVDyBhrN2O3m8jDpuCoYFbaqGhKZTSLF3BRp/zpG0WRaYxWg1dn6vk3TX9Wi8c
	9R8ZfJ70ynh9NSuMBKOuakXLXvaFktc1vHOhhUYlv4ntTTHpXZ5X67IJxi67YYdx
	S+n/5Ia0NFhz62jO9ZuNnbpf79ymfOiqMPglUMk/gGp+AHzQcByDJKUA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4220490p67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:00:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4940OOaE038405;
	Fri, 4 Oct 2024 02:00:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422054p54a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G22DQ5dldWno14cyp72iCsPxNN0Hx+45VzYsk0pnuic1ataOt+Bo8GxP9YPoiIT9ciRYnSq7vMpSyh6cIxJUkq9Ddqr9ODtngW04N09Xvsjp2pd9CcZwaEmCwxys3yxT5JVk2dFau+pfHFxB+l+N4v+rNnOKwd86+QGRhp2tQhz6ifwKswdUexCDFiCWLPYymsNTbCLmV2W8Dyowamk/b+GlqAoSRq2AEOX9yqtTrjiYOEDd6t4sVT2OKJqjT2/oriu3q778mCN3ak2os0xTtiFtxUS9Z1PtQYio1k/fsVHZEfcog1jOhfTe+3nUCG3OU4ecs2YvduLZO1qvNLjM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fddAMkOUzP++0v7YbJ04zbk0iAwMzq2iXRfivyGFpgE=;
 b=D+izDCfkD2rAcUns9VbOA+60MPV2KsOpdc0WvDe7E+0VClW2+v/7W7HjD4GZeAV6cQn38qDo0k++0eauaUzTzBlyppqBCL4D7CGwQsPaNpfKsb1MOVYm0mSUFHK3a6RI4jJr2mloN6sxG1f1YaCxQ7sZ1yg0MJv8akokjxKnxm5dnnIvk8PnY0bUgNucpv2Fb+3zUFSPdjM3sfzaYr2pMzDAegZKAgVJJ85aWCY7+TWuwbSFqDyn1Iay8dif4tKQJ9pFklO0fS/hHY1eHg2E74X0as1o/oLpA8Qr9mF0zn4YLDHlLgwINfUfcsBPqm6QArEjX08gjGdgUK6TgjQk7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fddAMkOUzP++0v7YbJ04zbk0iAwMzq2iXRfivyGFpgE=;
 b=qVlLyHvODc4XoHzOHVi6/cejIl+xOqRdIMhzKR+PSOhTMQ6QOjnGK+nTQfweJ8A9N3rzLawT1syteZs890QhVsqxwquhWbP5aOMYLlIHU2N0dcjunq6qTbjbXuKd44uhJIfV+syEZ8UOavaxFbwOl4xU4dIjzrLw1gCINuIRGoQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6233.namprd10.prod.outlook.com (2603:10b6:208:38c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.18; Fri, 4 Oct
 2024 02:00:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8026.017; Fri, 4 Oct 2024
 02:00:31 +0000
To: linux@treblig.org
Cc: hare@suse.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Remove unused aic7770_find_device
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240913170116.250996-1-linux@treblig.org> (linux@treblig.org's
	message of "Fri, 13 Sep 2024 18:01:16 +0100")
Organization: Oracle Corporation
Message-ID: <yq1wmio1vbe.fsf@ca-mkp.ca.oracle.com>
References: <20240913170116.250996-1-linux@treblig.org>
Date: Thu, 03 Oct 2024 22:00:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0886.namprd03.prod.outlook.com
 (2603:10b6:408:13c::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: a88d4c49-8351-4bac-e4e6-08dce418538b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PQ3kksiszdE6tL7GHIQmOrf8Rs4A6Zg1ffhKcFgYIynbeuVM7kSuuOKhl9lU?=
 =?us-ascii?Q?jWksEtoa9bIZhA4EY+ko2h5w5VqwAR5lKm8lESVF7OXg9Wt1UcUuqT640bB4?=
 =?us-ascii?Q?9FkFse7IY/2nAAJ/b63bb6Dx1rnApxzPUJuSqt3MeZDUBHLLQXXnn8HSKsuU?=
 =?us-ascii?Q?8A2YhRFEM0sU0ULJWeVE0pVWXU0Xmplh/+XAVXyy/6ig0lG3B76UcEWnZ6LN?=
 =?us-ascii?Q?Si2vTfgV5ZoSK9pD3lVmmC/lbYWwapol8ZSEmWLz/mjHflspuXkAA40t5VlY?=
 =?us-ascii?Q?yEEPJa4/GaUsgSCTrLpCEjoprwNTYVVrc648oWchbhKIBs3EhNQQ34McVBgb?=
 =?us-ascii?Q?ZGhUjsB+xbistKSPT+ge4SnhvLJMEWTmQEVunV7rtQFKv9i3Q6NvA3yJobco?=
 =?us-ascii?Q?1yLRD/YMNdkcjyYJQQ31w1aJkrQCzIxdGDyyXB8lzkr8LGl/jMzWF2QpxE49?=
 =?us-ascii?Q?VeDfMirce9jwD5apKOzJet3988dykBZlaDaWJdtGptRn9qo5zGkYCjHbpC6y?=
 =?us-ascii?Q?ezBflFAnLB1kfIkf2zBRXv+HUpEo4QzvFAtr5qLV7w3hy2SvyFPwGEl60iXx?=
 =?us-ascii?Q?jIYJch+e2SWg0Plybu1kp9O6QVRIkLONxOFMiqS7tWLYbP00PskuqCpu0DXL?=
 =?us-ascii?Q?riTNa0UZn6JvRuqmx2JqWB6I1n3MVmbUl2WMZzsKwVF4paxApyr2sZ7lRKrg?=
 =?us-ascii?Q?2fWkEiz2C5pqICkFEHnSLTXbD4XLmBvL85tYj+p0+iVcsxs+q+8C1wC3pYb0?=
 =?us-ascii?Q?RbkjvrXcFk4z8SA8wAatrXXPEdm0I11QIubBdVpyPPSFK5LozHiilHhWUnar?=
 =?us-ascii?Q?Jn3TiL3cYhzCs/mNTL8Ekf3d6RjZ3mlBP+hBVWh7NBN8Q6JCZNWhG09crbVk?=
 =?us-ascii?Q?ZGr66viT79ZUge57GgBjkBGiUUOQ3kcqQJl6VUxTygOM5sCa8VwlR6Ls2eFs?=
 =?us-ascii?Q?2+Lfi51ci2o0s6ymTuvTWneJswAMLUdC5AEAcA5t6FThkH6Bo0Zx9oAzWs8J?=
 =?us-ascii?Q?RtitXUZ8UsHbt1F7HjeU034r1BYnnZVKAx1gOMsTRFFdo35BT6+bmcCjoJh6?=
 =?us-ascii?Q?uL0kBGpw56H2YfGSQgdSUmb9kAn6Os3r/ctlh6E4MSkBIrjJIlGh4g+YVNoB?=
 =?us-ascii?Q?xohn378Up31IZOcvyy57jKfAuQ2Wg3RqO5o+5lAWjRR9T7+x6EOh+C5QzRys?=
 =?us-ascii?Q?mrrwMxlCS580gLq+simNi6ONNDYzSKnRcX0IpYR30T86ljE595BcgaWQnMnR?=
 =?us-ascii?Q?uolkk8SBaTSv1ANzSEVi4G++F5Oz1W9E1PITps57Og=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9M6iddHTjGL9OTPEOxTueU8oM1zot9BgPtXE6bdzg9RP3Apu3F1YA7KYVa1W?=
 =?us-ascii?Q?Yt3jZVAsH48hyFfLVeuKsqizSH+ktntIwbV1vcio9iTciVe4LyRBki3rbAkR?=
 =?us-ascii?Q?132ymokqj18qRk216cH3g1elTJcY4o/RCCQVdkAo1cTj23cafpnqAnjqA0Ks?=
 =?us-ascii?Q?Z99sroajg1W3YQ1Wa6A5FeT6MErLQ9bSEYklP+aDBnWQg6HUavzhWK0g2OGJ?=
 =?us-ascii?Q?rA1nGQHRh/mf5rsIsQK6JpNBjiSMOFJWtMO5OyMag7Wweymm/pB7PS9hVJWS?=
 =?us-ascii?Q?qAbnndQcX2q3jk5lNZzAWV0+v8jOjnBFbOd0Cvkc4vNU+P1nqK+fB7Y5LogC?=
 =?us-ascii?Q?2NshuhxTf0LwaW9shcOrpdM1QVeChJTUZepoy+x/xhVFnMGwo2sP/ThFMmfx?=
 =?us-ascii?Q?61IZYlCYTaKRadWAFpAOnvMPgN8ovzac0w8DpSyhdUX6eUPcXA0xXyKWLNSj?=
 =?us-ascii?Q?CthmsCtws2MUUCzWdSW4TxwvD12lfAoA7UjmEC+Cz6XEpYeLXzmmJkBOIymS?=
 =?us-ascii?Q?J9zYpYoDM7SU/ETKXSWjtuvhLiv20qlihFsC+qoSLtwF5+q1r/716IiuRobV?=
 =?us-ascii?Q?zYCZ9blVNdcAtElkVzVlrFm/bGKggDLs+AIjwhTtRIHklBYxhKc7XumPnAJ9?=
 =?us-ascii?Q?6vRr4My59mMPdIsURb64R88j3R8dxib27VlaYSiRI+BxW1lW9Hl9vxwqCzQJ?=
 =?us-ascii?Q?FlOyzTbAB22OJR1aozD9/qMA2GudMkzPCwZA0twvCscgHCm0yuR3jja6FE/w?=
 =?us-ascii?Q?WzUUQp4qBQWI8EjKtGE/UM8NtSBDdIyziM/9x52LQJ9rsyHTAYZFfUhZzYp7?=
 =?us-ascii?Q?qnRTE44X/278iNqZuMxSqXxZ8XGXlIxQh2DPVitW1x3Utwq1BRwISPgKo88F?=
 =?us-ascii?Q?e6pGoxtogDH3wVQzpQjAExkNH5nbcDC/SxUvUo+iyZfd8kbuPi+rqzbGESiB?=
 =?us-ascii?Q?aENCeclCDn8pRYpI0O3zxGlXHBq/kMlh7C8zk/Y5mhutzqdTLlY1PEhFCoi6?=
 =?us-ascii?Q?fRAZJlOHLVkAj0wRv+c55vKJK6b5v25doT3eaRqYrvCax8RdyUUFvyMScMGL?=
 =?us-ascii?Q?WouHiRAmaR0fIiCWSH2H5Ki2jUd7naEQ10cDg8KCRDWpNY6OlYOEXPM9mIYj?=
 =?us-ascii?Q?SzPk90B2TiLJbgMkZSApHvumsFOkQFnA+PDCpLuonwhdjGK/N0ViW9/x13sX?=
 =?us-ascii?Q?ZPVzOrsqGoJAV+wooyuSLMTPc6ydLxjRG64Cs8ZgaVBCAjOakUBY319zoJ6y?=
 =?us-ascii?Q?MU0JVRLO45Ha+jZJMTgdznxmzpiqB2Li+ga+R4ATXOs+/PMVuj01wN0fqo62?=
 =?us-ascii?Q?W10XC6pxK6xb4xu92LEn6xhXmKZiWmkpXFHNupnb+aSyYOVOeICeXKomYM7z?=
 =?us-ascii?Q?dh5DMQrI9gKRAqx2if4gGINUr6Okg864TILDB9cMsV2ImS8fBzd7EL8ZYchF?=
 =?us-ascii?Q?IDS4TZ4L9Nbqkfd/69XK5IBSvMXCvs9BRi784DiUW6TCqSB07Fbq0XX0jRqQ?=
 =?us-ascii?Q?8u5cqAyAQLY5/QKCoodk7Gneprs1rqbDT/4tBwvyeHvcy8/REUnBxrFtELR+?=
 =?us-ascii?Q?AYdslOm7ifnP1YWALMRNyVYKk5CpEZri7Zw7RgStFvwBMtcVMyoaea8fvmjx?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fQcN6GIrSVw7KhrEjXd0HAOS92qEteMf3gGSL+8gnNKHbWKuOgah6yivbOZDxVq1768YWJWkB/42rQMQwdKh+R/76MhehNGunQlFsafZ+WSOUpQ9mYoFqnyV5q4Ehcv5ZPQmyGKWuEhT2RaxKtHpAppK8Y2XjVxydNNt8GqYmXeK2c+LVjtdwwXuQWD4O//HgTg9swPR+o2q76saTWox5HggrkwsXspi/0cmMmIN//aHgpk7ltqVnrVWej27H8ZdvZwQLZF8gN2LnzDojSxARMYNvIckyTdGqo09IjT3DGuC+E0jh+EHXtAsFGlAuwpbla+tg9WZY6y8ujVMfDyBII2Cq4xT/+Lff6ZiwuPrJHartqFvzUIy5YSwPoDCXFbgMIrxGstwdNIAaCTOmVNSfGJ0Ws/mygzUDc213jmf1VIzEJKFKY+PmLQIn0kXkUo8dF2WBJbca/tUYkMlugEj3p8gSZ1Tyh8zvo7bo6/aCVMVCR7gWPr8zo4Ly+ZwV7hbaOKy3BxOX/gH6ZAazartMEjJioeFQgUnSEW59XI6H/+C0dKa3aEgPTs+ohx07KeLWsqZJxLwPO3euHb2YI1hw8GeawiXImHuRYYYJWm8MCE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88d4c49-8351-4bac-e4e6-08dce418538b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2024 02:00:31.2670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXccENpI34j6x2K+o5MiKM8enbMasFsPQ90Nzw4kUo5OcHyQc3JDwxsnKlc/UZpNsH/4eE/SbzO3QTo6hDFA70+NtWUVgjRWGyC31D+PmOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6233
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_01,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=699 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040013
X-Proofpoint-GUID: 45mLar3XWGBUjIr2ncaBdGP79ga7VJI4
X-Proofpoint-ORIG-GUID: 45mLar3XWGBUjIr2ncaBdGP79ga7VJI4


> 'aic7770_find_device' has been unused since 2005's
>   commit dedd83108105 ("[SCSI] aic7xxx: remove Linux 2.4 ifdefs")

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
