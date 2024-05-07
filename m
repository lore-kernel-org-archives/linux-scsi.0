Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E983079DF;
	Tue,  7 May 2024 01:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715045995; cv=fail; b=Nv8wkPBMvV5yizAWq0TVi4ymHlAE+s9pidr7Z8Exa32vJlz0ZcEDySlHRcJRYgwxzO5qgMP3ZNISHdNk41XQEK8a58KX006/k0z3+FM73s6WhKdCXmtBrNqS+BnF6dYxXekc04s+G+c2zGVBByuReQ8A4uS4TjC0UtzUjOG0ftE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715045995; c=relaxed/simple;
	bh=YFM9Hu53Dbn0iP7o/4AZ1Yw65mzwy0YNdBX6Jh+NIjA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OKZBjSDEAB9v96903pspyZNUtcpSNi4xHXCEObdXYDAVUyBBYy3CPjYesXHXvrn9tfxU7ENmxYnlcquvoZU84ljIPfuBxsFguRbJwwkZKYDG6TC9oCj05B/DnTsAmaridFK1zULzw5z6qQFwfbF7YMCU0ujiMkid4lJa1GNkMUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M4Jkb4It; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=clYOmkAg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M4Jkb4It";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="clYOmkAg"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446Mmr20025959;
	Tue, 7 May 2024 01:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=9YYlXkme6qKD6h2sBcIzoD5a7fJcmqZcw6o1GkNu8jw=;
 b=M4Jkb4ItPKDw9x97m7LmLF8oeqWYPUR7iPKxx8rScVZBcfCfSDIFXH/xxdXcbVNNau+Z
 mqjbhJTaf8fawnJp3dHMYrleroVmf1p8xuqiAcb53WBSaUXb1p5KousAY6kIPqUnDM88
 4HQtE7hfd2xuUhC/5hVMCssYv3NS7Gzf9lJVzfyoslB+LDijHVVkYjLYs2R2XFeeusQY
 0hcWe7rdeKalxF/s60P2BeSD4a0P+uqw07rVN1RaU+1f1vNwD3JBc/Km0RVU3Cz2g7yW
 mHkJ+BWRefYdHUnpWk2HyhFkpf9HGIhAjOraGhWmmQj476qOaUtEwtp5DSgmtJ8Bn6jm 2w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwcmvbv8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:39:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4471EI6Y029361;
	Tue, 7 May 2024 01:39:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfcktyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:39:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQ+VeThF0hpKM+v5VloJ8NzV1zQraerbhWPBEtf6dm0C42OryZ45bFUgLVAWnPqA/aX22rg5U5dQEO4YjhnyijPsRNTutnzZPCghopYpdfUWNwzFdJSuhZv77YCZlTczhuJ8cxcvEhx3M7B/5tvEk4r+DFcgRy1w6ttSpoHXgvo1CflmA2TsXlt90koCgMjL5qeZh1vV654yXuMNmVW2y+tEZL6556DdPcaG0tlfy43WYlgQYWAyRPFj4q/FGN5jsFpcLubnbwnakxofyLt8sqmtJCwNkV4GT0PN9IYximzd312p27SNPgg/76Bt6WbYI3qv+T8U5/lYxRQI/2KF3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YYlXkme6qKD6h2sBcIzoD5a7fJcmqZcw6o1GkNu8jw=;
 b=bAgsCbHJOH1BcHY/qY+z5rYHxOS80Dk8yrxALXoNxpcsaBndMdxyzHjYek78Dmf4jD9YGFk/mRij2YxQRgoyOsbIm/ij+eOIu1O5R5DIXyXlngtOuevJ/vYycLNFZytx+B7NTiSLb/LO7C6n+vCeqNarxT2YhB4UWrbRp3mQCVlTfUkGoaKbA/bSXIvR44XLMNUhwsAMu/vhknZVoLJcLrRO81IwXco7EpkSeb3i34NffYsmQkYPSU1IJjaQm6fKAaO3yvzpRbTA8lNcGcSYnSbt0y8F8tB7+S+Zptbjy1iVuUbinc8lPyAJTN1+w1y5zLraw7U9qHDkVqTbxzbXyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YYlXkme6qKD6h2sBcIzoD5a7fJcmqZcw6o1GkNu8jw=;
 b=clYOmkAgO+gr9VEWaYTIcnQRWIFVTTC8wlF9s7UWPPtaLPfB3ZYM98NHaSqddPKSPL1khfusPVQOhcryFxPNaE2KEpRYUHGyabR57EanAsO5l1h12FGwyfl4fDQuJ4svZnElgj6NtvqESat24DVy5ZmoVgKt/pQwp92N7jC5x7c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 01:39:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 01:39:47 +0000
To: linux@treblig.org
Cc: michael.christie@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi:iscsi: Remove unused list 'connlist_err'
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240503232309.152320-1-linux@treblig.org> (linux@treblig.org's
	message of "Sat, 4 May 2024 00:23:09 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ikzqxuw6.fsf@ca-mkp.ca.oracle.com>
References: <20240503232309.152320-1-linux@treblig.org>
Date: Mon, 06 May 2024 21:39:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BY5PR10MB4388:EE_
X-MS-Office365-Filtering-Correlation-Id: 7257ff60-6f2d-4244-1d80-08dc6e36943a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?x5m50fbNA6Qnl+w/FdvDowgO/xUcZGljQfCR+OQFUs9+u6UnUrv9ye4IQLVu?=
 =?us-ascii?Q?cldsHGBWdcNPhYE/offBhX0qaThcVwfnru5kC2Ov6bTrQwy8yoKoIeaAWwY6?=
 =?us-ascii?Q?iF0KyWalXLad/jvnELXBGHOnxOZl50bjj93xtdQNGzfkxXUMKsfB9oBVMHxD?=
 =?us-ascii?Q?zJb87Coks4EIW7PmcixF+Ll8OQYnIidXTBHstEVfniChSV3vzSsIaqIWdkTQ?=
 =?us-ascii?Q?YTEYvequVmDzUEAmtXBRte6RA4Onl606o4PlvVPnP1gAC9InKQ/0jYFFWHix?=
 =?us-ascii?Q?50YQ8H0YQaN+DtYbd/N7OtlRZaIu93d0M/VhHngANkbNvwyNsqZGNoe4m9dk?=
 =?us-ascii?Q?7cg5/ZP+Dkerm12/5b6g8m0lQ024aQiouNAcSsfuoRDlNpcCgnt8UPcFL0JG?=
 =?us-ascii?Q?2Wo+l1XXYh2w6ojfFa6AMShNKQ/nQTWJjLGHA6rhCg7GQpjfjns47ZQYYi7A?=
 =?us-ascii?Q?o4aWWeBz0+0ZlyeLlAxGEsM19OGwa1pybpCMdy4ZyVBaSCTtq481BpW5h8bh?=
 =?us-ascii?Q?h4/bbyH76qwB7qwQGuz0FFQX5m+cSI+c42wkc01SaQ1WY0Rd/4lWqTBQxfiT?=
 =?us-ascii?Q?KZ6DiF1aqjUm80ROKnkIPF4wnYAjWh6JLAW+WHRT8PARkLsL+oxv74VyYgWT?=
 =?us-ascii?Q?PPjTCvnOGaV1YhdzB2WGWBLS8398EMogia0mMEmMDirIn8FlpD+Gvv8za+yX?=
 =?us-ascii?Q?labPP+jOUSR5xKIqu+UH7w1Mq2iRjdHme3pArKuyRNblS26P2nm+i9WM9cfj?=
 =?us-ascii?Q?UomSerawxqYdV7h8VeEH4MYo2FLeljSTUfpdtOgVysz1bkVfkdhRTwMBmwlg?=
 =?us-ascii?Q?mmasJ+wEVWejbTZdhxv6Plxs4MBBi+oMhZwmk5kNbxLCNxNsGtxbA8B3Qoal?=
 =?us-ascii?Q?JVhIFHcQk8eY+vYoCuJSXmIZ3EAnthTSS1POHcFI7pG/PoFIgXMd5G9MUtvx?=
 =?us-ascii?Q?LmOOWu8su9VtRwKdgnfZGT6hWvjSbrwg0yjAUxw52FlKos9MRpFutyFsOIOl?=
 =?us-ascii?Q?l41aE1SW2le7ULLx8l6pvojYuQsEbi2r7lR1BvmiKKm5ZVFOK/ZMT72oSib8?=
 =?us-ascii?Q?o+gOTcahDfcoJ26t101Lg0kOT+7EB91NogYesg0o4Q8/DasNseuRH+QyQTyd?=
 =?us-ascii?Q?LfXb2Rukp5RldgaQ08ZVmDbhJ+/Ncs71cCer023FtmdrmzPL87RtsOQmWVq/?=
 =?us-ascii?Q?2SoxaGLm5nzY+1K9KhR8L62LxYB3sb9L+XeZBuPZSzTKDegJckqUpPO3quaW?=
 =?us-ascii?Q?95iwbs1CnmGC/Ht6FtdIAFk+AzCj8s9HBrKUVJLm4A=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?b5E3y5+kdthwG2ChhufUlj4FpHGHnx9bdOqMgmaLhy4FXLItiEfOklgSYI+w?=
 =?us-ascii?Q?B2k7drjBb9M5W2SulpqgFM6x3QppALHFYt8xGd3pi/MNqDnJpCSIJAYqNXOS?=
 =?us-ascii?Q?4VfVs3sNdXs+tEhQ3X1iw7rtUjwaCuBIME/m+pOvhBeIX2tUdd5daKs8x9uc?=
 =?us-ascii?Q?wmvn0HDW5ezFRIcCFuSlyzUCOqBb7Cxc+3vDqEUIhXK38vlYGcmaEBjH5Ag4?=
 =?us-ascii?Q?7+thBcevogdmtJTyDbnW6lwf2OV7sGrJ3N3VCJCVUWXKlLlvURkoziXrNVNr?=
 =?us-ascii?Q?Ad+/KkSxVmocxy0ZrSLp/iVOraa9/445zm5lXpvntwcCCiC3Xm7U3l6uVbB6?=
 =?us-ascii?Q?wRIFsMhNpBxz7hL31ZjjKVfL9EugaBcI0FZRHGrRrwep7QxIx6AuwTpmHAjt?=
 =?us-ascii?Q?+XlJREUc7wdAMUfCMQig0UxatpQQOgIHXE2U0venTi3sNwcePVRQruVaFctI?=
 =?us-ascii?Q?pAgi8eJcAPffEIFm/UiMiswY4YSpn1kx1fQSsVpHeTuno9XzAoKWarRY6z/p?=
 =?us-ascii?Q?p/ix8NM9zyse/1LURlNx6wCCR1/nyPjZEtcnb+d7PJj+SIv9wLb52uFEvBq7?=
 =?us-ascii?Q?n5cB8tcSVSkW55lOBSP8wns7KXT4zFag508DtMO4XqMMWrkGpDG1h1OBlgZO?=
 =?us-ascii?Q?mTnL/5XTD75CfPRtEqSSpLQ/5zZ4MBHNv1CGLmWdTWUmjXeW4MGQJXijEC78?=
 =?us-ascii?Q?2I7ItistMFyVA3IuH2jmzQZXgKSRujWrVesyiRKzilcZ32Wx1Wr4+WA1qljh?=
 =?us-ascii?Q?tKyJGNOkanqx1aK3bVyCG5Px+oQRfS1nx6QOnbf7u/IMqnvwMrHzDl/UdEhW?=
 =?us-ascii?Q?ecp+yccgIU6LE294XGqdZ2bCs71I3CTig354aUqVG4ge/m5IWRcIx/C37ZGX?=
 =?us-ascii?Q?8HiX2nOP8apfYwjS+8Qf1hcvULoGi3bl8lYOIYAmT/gp+QyRf2eHpqtX+r1u?=
 =?us-ascii?Q?64tsXa99h2hK7xne3b/EqG5mx7SJ+DpXkAztDekTUvjl16Lj4hUcK08HHPO6?=
 =?us-ascii?Q?sfUr7eOnanNs+EoeRg4uwoFd3UpadAaBQ0iyjHrDyhUrjQeeSsc6gVGHWkpT?=
 =?us-ascii?Q?iavYUp8cRckuVuCrCmF1ghj7LA1acgLPyKER0rnqOglpF5z65gBClNnz1l64?=
 =?us-ascii?Q?REEUQQJaGWwOMWYfq03ozDFnRGTmWAxnMURy4VeBn0qVt12PZ5ypNcUeA9gb?=
 =?us-ascii?Q?wEvsCqab1hnRNZxKjGxSltkQCht2h+ZuJMIbitoOsALvpxF2zeavO1vnLVXw?=
 =?us-ascii?Q?vULFKJb5ejpp+Y8QzaVGaaSg/cMfE84lUrXaQICG5eWkxnKXaZZyMww/CExC?=
 =?us-ascii?Q?Qqj6kXwNIYTGL5n9bqEDuVW7KSk8yVDJLWUorJYtQHBeVvUpeAOPjax0xvdx?=
 =?us-ascii?Q?nANTwDSm5Sk5DCIU4kFDiQm10dLLCjrEFf5cWFm0D5P2UW2irB20Dma1Z1ro?=
 =?us-ascii?Q?tanL+SrjR53/M4chvWa8AFU6JvscvsQczkRidr+IBp0q8Q7rCLAcGZ4+LHFY?=
 =?us-ascii?Q?3o6McbIxpGLt5/NMFnRBObwfh0P0DOAkPzjVbqPV8qHClIQ/XEzuhMhJiNoK?=
 =?us-ascii?Q?MZ0Bm5IwZ/Hojg7GjRzE9wmkEu6cBSgI0JVchFBcrUTHH1zdUOSAUGaQHeWg?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	wkDAeL9XnAUD9UETr6l4SJ2GCHcoxIYrGHMX5IPB7fpjjmaZ77j4kbEeAb0Xls6yGLJ0ek3rN30JFOaUDYUvR0Ee2cw9p5Rrw35e/Ndjmye0EoBnQOmYezS2ITcr/QlAZ9J8ffbJyYy2UuYJo+EARnYN8IV+irpagalrVnHxqDA97dWhbcPkNcIKyZMOtsWNaVuYb/CY8ZOmcKf6MJUm2UHhq1NPrmbIQGlWPAouFH3XQngMDPNrbsWfdY8ns8sc2t+/vNS7GFev1EB3ghkABInaQ/csK83CoViDtENmJUbVEPuEOqAWfthfkoWlXZCuuaUIyrp240VyOncWzWQHHb0Mc5mzdk611jObPQC0XsKO55e4JB31LcyLlp0I/6TL65ZtQQQ1qNxNc696g9dEMtgqfvEf1q8QyQosKNCkxuOfwnJxsJUYt7vZA5KyLkXMZFzo8gBNJ1j0u9HZ9mMoYrBRNjEkHIbo2bt7c40b2+RodOqBHI5CAp1X+nYnsrDPsAgd1HbGBVfvYPSKnB4ZE8OfSQ5uDLL5+h/4pyCihq0j+JgNUIINRDOjQnRJd2AN+WaUbRaphmsQAXMguKvmv/WPd2yy4/P4k9sxL79kL24=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7257ff60-6f2d-4244-1d80-08dc6e36943a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 01:39:47.5719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fepudxm/MSg9vSSdZdRYBxa8MLSZuSuV9ad8MldSEDaIdwLxWNkwz4E7LQt9Mzn2Hn4Hy9ODhz+kn46UnFxtAtV7IMya/YWKlShBcvt0shw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070011
X-Proofpoint-GUID: mLY9wi94wXd52lI8O-zHwjI8mI0oc3HP
X-Proofpoint-ORIG-GUID: mLY9wi94wXd52lI8O-zHwjI8mI0oc3HP


> I think the last use of this list was removed by
>   commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure
> handling").
>
> Build tested only.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
