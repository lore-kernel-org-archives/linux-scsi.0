Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12537D07D;
	Thu, 30 Oct 2025 03:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761793615; cv=fail; b=JmF73mQyvk/g/UWon7w0O7nSgwOhCAWTw/HqcjYYO7LD/hFE4cGHXqmQpFbuwrKm5jagJHhcT4qSsYjk5CSEl9tQTn+zWC0e+Xqw/eJrKEVegEZMU5Qi52T2Zyc5zHJ6oVeTtGgLOzwNN+ZAcB8N9cpVaVj9FO/9LTxyua2tA7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761793615; c=relaxed/simple;
	bh=mxgi2qDLiRhpmbFSmUggO3/Y7+ohzEbmjDHEHRka5/o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Wa19Ej497ySQGEKMCx11cDEfxppK+qkTNHG/rVfcXg8/SkxjGjdHl4bgj9TBfPErvbiZmwYi4Okl2XwHsEAnPUpJ2fE5V1qj02Yl0tIVS+VTdVCoVtRINfLfRRxua4wKQ/hGHnP7iw9f95mmKuTLxEJIklRIBQ8XOjEYFz0qvu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UhxRPPHP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jMLe2lhg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UhxRPPHP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jMLe2lhg"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U29pJp019205;
	Thu, 30 Oct 2025 03:06:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gMTHCPXhJlV8IG9xMM
	UOw3Epx5/1k8bM9Ysiupbxq9s=; b=UhxRPPHPZApug07LETxVIVM8ulHQLoOWqN
	yyyCxfCxInjvB8gKkoqeybNIoB2QdwS63tGxh/4iR5LcrpDiWNnW1O3qnC6fIqQ5
	lw/IOlbM6sYWzUp9N632y9LTtDN8ibtK5yAsloYbgojI/khZyFLxWoEO5g+3HgrX
	Vymxpnxph72dhrSSjstBD8ChvlajUHpplNiZymdWlIaWVusIl+BpnS3SzLVJqes7
	DRe1FQZw3PINAY7LvG/MmtyvCsuDwiDl7iojzzG7H11H4x1N10M0ODBzHudhot97
	TEzsKVp6ts9niRNCMFx6RXD+NRumaouiQLcm1UicaV4cEH5QLLqg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3y02g207-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:06:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U00PdT022792;
	Thu, 30 Oct 2025 03:06:39 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012012.outbound.protection.outlook.com [52.101.53.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y019d0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:06:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GVTYSqeQzBC4fviaiOicmLDkQV1fXYirYTrGdBp6lTBSvDBAmxpVMZBt8Mkj96BEiU096hBD4CkVsHchtQcaGJ4w/Ys6ug9l5qpWbVfVIsW7qTm5fs2nTzepge/+8YFhF7HoAuTygGuJT6pwsmcIF0YY7Lk5h7dQ8IgVodEH7tEn6U6xsnwqbhn0hjgQoTYG7TcRMusjUibuQnABdMh+gU5Rj0+N9THeGclupnPKYCpPl/ULGUfJY0hRvc0UeVRW8g/Rehp8PINEpkdTvsEpl71LKSbJ8u6TKTrsPj4dbeGRKPYfUP+oOxyTn0wF+7IrmQDPjyTG1cXUot1FJJyfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMTHCPXhJlV8IG9xMMUOw3Epx5/1k8bM9Ysiupbxq9s=;
 b=tUQ+x3TJBff4ARjV40QpEodmy06IeqA4bygfWX8rKTM+hJZ7ZjDyJJZS5+ZZ7WePXS/Tc4PGzp37I0mnhlm1tGGPTG4tE+wNovm7GrsDZsWo9UcBpAswA8ZrJTbymUBJR5GOabVzh07g0uLFCCT+uDcSPrgh3vQK0V86aBlIjjqjGod7s/wkhUP6557M2kiCv1sO/nl4SqhWfCG3vpzsZkZSSQnQoaEivhSPLtzxmtppHQTu0hFeW5/3ycpU5YSui4YN9GirWoaijXeqHT0pNPnjtrq4HHnw+sBAu1hwGfiWde5NCnc8ZUmgGTtQ5hndrV6EDpXc5NsyLkRuOkot/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMTHCPXhJlV8IG9xMMUOw3Epx5/1k8bM9Ysiupbxq9s=;
 b=jMLe2lhgOZ3gW4s8TjtJI8fJE93Y7bNW3GO9QVKERF2V+S0bMjUQe5G/CP/zGzik8GnLoMUMfnitC0BCMmW6j+AjwFGdnjzZ5EHTStAk2g9VkZ9+78vD9espxI93Sbi7tejrGIxC8Jwc7w76zR0jQo63/vlFpeIB3801qCJZ4aQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB4949.namprd10.prod.outlook.com (2603:10b6:408:12b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 03:06:36 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 03:06:36 +0000
To: Ajay Neeli <ajay.neeli@amd.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
        <pedrom.sousa@synopsys.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <git@amd.com>, <michal.simek@amd.com>, <srinivas.goud@amd.com>,
        <radhey.shyam.pandey@amd.com>
Subject: Re: [PATCH v2 0/4] ufs: Add support for AMD Versal Gen2 UFS
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251021113003.13650-1-ajay.neeli@amd.com> (Ajay Neeli's message
	of "Tue, 21 Oct 2025 16:59:59 +0530")
Organization: Oracle Corporation
Message-ID: <yq1ms59t7f6.fsf@ca-mkp.ca.oracle.com>
References: <20251021113003.13650-1-ajay.neeli@amd.com>
Date: Wed, 29 Oct 2025 23:06:34 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0136.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB4949:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f87c932-cb8d-4a66-a207-08de17615671
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/3TBwjVr+TvCHtBBvibjtSeILmOf6vePy9oXLVqUQ9jmt0cV40ecklw/v0eF?=
 =?us-ascii?Q?P2/HpJblmDGvo2bTsojXbPhrCabEK+Vtm/tAj6JaQwjmIZE1pKIYDogOblWX?=
 =?us-ascii?Q?6xf+Yr1DvsDMAEYbS3wUiCc+C4BW91+bma6bWIxCs1RMMOjG8iOoK1fOdvUM?=
 =?us-ascii?Q?qvPEWcPk3dLw/O3VUTLINaF+wxdULPOKNGTbW1HkekKO3Hf9sQ2I9bZkICOE?=
 =?us-ascii?Q?ZXebuwBJPOJotRQS3gJtYUpRBMZFBuEA+knyCq30Vi2i7rJV1TTIKX1Ew1Ux?=
 =?us-ascii?Q?noHThYrIvzU5r/+0mxGArkknVrq5927NKjZ57+OL4Tf19W+JJ1zj2M09fF16?=
 =?us-ascii?Q?jwy9ZliQTPuLMrYcVEkQqVC1d1M0+m/5uYJ80MU9WVxlGiERTT1R5XvAo91W?=
 =?us-ascii?Q?kz1FTFBRLk93FcEOTe1D54iUBB51OvHtRz7S8QmcjuFszxFvU3AoRK39mZwW?=
 =?us-ascii?Q?zCxpVhN6blJZDwM517YNVKn6wx1hk4q20RpqQWRh76k9xCsXvp4wSDQZSQC6?=
 =?us-ascii?Q?Mr9hZ5zWWyeIJP6FvzwX05MZ/yDLGlz9UpgPc4vix1tndiEMTEryDtr/SgTh?=
 =?us-ascii?Q?yw8pXMRIGGlJqM7c/aQU15Op8E03S1YgdtkQLw0V5aXyzDzkAARDM8fNlunY?=
 =?us-ascii?Q?fosWsRETffxIXG6Ua1z658rfg+lw7AXPvw93LW7DfoB7ATy36u/GW+zUEgmD?=
 =?us-ascii?Q?N3MGhBBApeTmpyK+WHG/CjXuSwclDzafBgyUJStfioVlcpzddRsJePv4EWG4?=
 =?us-ascii?Q?u/nYO9kKXHMqYD6q0bU9r2ASbUm+Gai7oyunOlsR6jLWsVr+DWDVD84iTlb8?=
 =?us-ascii?Q?MCklZBRkYtA5IF7F5cjwarXv25Arnscw9xjxo9KraIwSRhAlo2ulY0joCTFE?=
 =?us-ascii?Q?TBJ2Z1z9OlxrQQJkLwlD38paYrU67pwtZdFXI+ziNd4C9hd3/X1E+jZh4lJt?=
 =?us-ascii?Q?hPVMk46bzrrqL0LsxbYUyw6X9cMNabprO7tu4ZBSgitqAArpB7qVq3Uq5feV?=
 =?us-ascii?Q?WUV72vqgCWsIywfZN0ApuAU58eIs1v7G6ktGbYXH+zim+TDWi7dfvGSfBjs6?=
 =?us-ascii?Q?fmqKitvLIp9q6O3ugYQyniSVR8L24FZviJZx7PmgQ8iea4uVJOaEiV64aY/Z?=
 =?us-ascii?Q?1g1d9shdbdEWbnYNZwPC7SdGXHaiLZBoekojuL/4or0xa1F1foPVa6j4Zm4+?=
 =?us-ascii?Q?gPA5ybBwO7dVpy9nD5lJUs45ZJ6tRNbJT/TwQYtNYjYj1Q6vRE6CDuoVPSy1?=
 =?us-ascii?Q?MbhvuRS2kqIe1TUcjcT3qw3ppgPtoDLKb9fvpzi2dRvVVoP6yU9nowiY1HCm?=
 =?us-ascii?Q?UZhYTVNWG3YDmw+uUdgs+434aCQx3j573AywftyycuT/5jjDLa/U1mvd5XQa?=
 =?us-ascii?Q?1Bqdzll3x0ndJsOj1Uy4GY+XK4UFP1GUe+/2cjipvGnBn9S9M/ehgGvxiN+c?=
 =?us-ascii?Q?65idOCUM6Jj94DfslYe15dcw8ycXyI8I?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bmxfz/RJ9riPAl5gMxVfFEE1Ef61mURuS4NQWANzqy97waHvs/y88hefoDy7?=
 =?us-ascii?Q?zqNf+fnYNxWbVHV8Xz6WImwr+8reiZzFyyuj9jjEYi76nS5zA0/ByKAf45sr?=
 =?us-ascii?Q?npigSu/TMxnSAyUkMSiTimuAQ9vu+VAe49/G24SK45UPhrKTKmzgFYk7CbS/?=
 =?us-ascii?Q?jofQxKFyLRwIrKnoP+4VSme4sH/vToH/f+Yn8jfcSXBTM4Nwh0PzOc1+Oup3?=
 =?us-ascii?Q?fe+IjpNlqnGpzIIs7rIMEXDZBgosHnQYC8EYLwDUOvFZl/j/onwVmOl2M1un?=
 =?us-ascii?Q?qmRAg+Q34Ss6oiOxOQOnWwOfxU9NgbwdgWhvhG/uHAe/BDPbj4fMsmQDs2XD?=
 =?us-ascii?Q?FzAn0ngfF+mAVvzqa5pjXnTXWlUTjLZ+5tfB9WXwwb4nogjT8HEYz/NN3wDe?=
 =?us-ascii?Q?Mjn+OAtJiYeQgPun9ZFPO7KL1diwdw+eCP/71t049r0TS41aZl8b6Z4Cf+sM?=
 =?us-ascii?Q?52CJOUFzEajjJomM8d9Iqa//KJO9PUXVbo0OrRlpRoPLAWTjUhpZEbRvoo8n?=
 =?us-ascii?Q?YjMNHHu2uy0C3yviyDB2Ypvw95VEBMjgKiEI0YnM3FzA5IdoRpkpNaJs6WmR?=
 =?us-ascii?Q?NgB/6nNEN5iAxLswVmXxkJCW6y05L4YNjxF0xgUXVpZtFkgPlDvT+L42fceS?=
 =?us-ascii?Q?ktpW3+Qmy9t/fm2PbX6z3pIkc6fikMkJ5zvxxhEngp/d7NZuAD9FVoQqy7ap?=
 =?us-ascii?Q?Q0pBzLtjSe+jhHli0RnuBMKKN949wI3AKCdVbVeNlStki+27N1mo5k20bFKV?=
 =?us-ascii?Q?M00EC53HywG+7hbPFXnK0zNYn1PLYgeUgRyR8QOvH2nXdIMYToAdqGXnrGfE?=
 =?us-ascii?Q?Uv34VB6cKGjD4Osl5Y9umASJX/ydhRdJkEAo5lEFh/L8G1luRirUNCnKMPFc?=
 =?us-ascii?Q?gP0olUsH/jrLEO7LBnZdN+5S93ylEANupEMn3JUEpKSbcXd0z5BNl/T7L9f2?=
 =?us-ascii?Q?DZG2UjFC6UxY9mAXsB0/X+ZsxFzh6rWm8Ay9EVuNNpeXLNZx34L16bTDBL/w?=
 =?us-ascii?Q?4xe8BpI5mlKSVmDyEmBxqFyd76DtlArPWK07ppSVsHT8zLPUTRwQohta3ebI?=
 =?us-ascii?Q?aeUH/1OmwDDogDD2MEGtL0mToWqshagWR1X6eNura3UWFoey6vH7kIZrD5Vw?=
 =?us-ascii?Q?H6TIAmrt5bFsiDugtA076+5mL7P0rAPtuTin6wEn+DO2GSjcBsenBXUcX0h5?=
 =?us-ascii?Q?NWWkMN0bsTnGN1e9JJYvEJUMsoMD7e9EbygSFNEk/X9+lDF5cgrqTHRLh0MT?=
 =?us-ascii?Q?5DFCpgcOT7B86pow+W+DjB2I7gsy9AKHhLd9rvYfI5H4XZtC4l57pVLliMBH?=
 =?us-ascii?Q?DVtYIgcMKTAL0ly8G4a+JA3D8RsK7zdRtmMQElBVOC9M5OjeZMxYHfVbiprt?=
 =?us-ascii?Q?WCWC4N6tAYV3A+4nbmjVrkTVAiT7/stz8lCmwTdsSYeKl04kjJf2X93BMBVG?=
 =?us-ascii?Q?/SyBDK8yCGii5SZglBIviMyvE2O14NnieXtl43tmCPmF1CzzcTAu/ZrfEYVx?=
 =?us-ascii?Q?0ihOC2bo/1aQOKooCjc0RLORvX16nn3F9iNDI/VcGLIEVkpkiASwmkLGGNcb?=
 =?us-ascii?Q?tGf47jmucRCdUgCoe4vzXbEKyWVZj8jz++2xmmUBHQHP9l/W4O4UFDf6GzVB?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wvWSSrFYsjnHIFYji9xs8oFsJzoFICDGShXXaSTFfTTOwdaJV0y3MIc+aitbzlkc497kLqtc1Q/l0lu5d3sBCQj8l8lCysJjK1i3nWTvB+v5VO+OFacEoG7kwBPLilpz4RZKlw7AEnJHui38sTIPPe+QshQaDGmIa8JQIjxe0K0i1SoTN26iobEk0ljC9NirVn2Q/CZNMkLQFb33n8RSZIdSXwjGtvSoVEm58Q6u035ssZzwds9YrS4WEzM+aTVpVe2VJZy0B/tdZtGYqk8yFVRf/29Qwq2zZgVfat9TtGSwviFYVd76salF1DsZbjwEYBExS3H5SrXmSXwI2nEJwyIJW4H3GpZNZpCEZmy32H/QU9Ky7dSkYV4/N0UaOLQZdDMOhcRKiQwgyka4Qo6jC9Gwwk3VRwqGjIb4hRBtujrA+dFtO2IJ1AClcXXqy5YelMjpxqFiZ1fZXnErFBvSGWS9zY9P4ZUGVEspfuUnw5Q+TUq2t8dTzOGi9R0pFEPA0DRFvQ/BSjOlhtWsN43XjIEOjtzOAWb/ROO/XttJTSvHX55inAxp9CPbXSIVlqi5qmEh6NpsIcUZoPzscS7xa/ZNMTjZwsfK9XZNSXaA8eo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f87c932-cb8d-4a66-a207-08de17615671
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 03:06:36.4710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C52hQB7POaCmLheLvThAD1quPH7ISB8U6tPZaNpIre4Yz3UOcl7s4uK59PyE92+DLP6PZH6uTym6dsJ+5YIfBOJ6QXmTdSJrsk/SBJ/mQM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4949
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=890 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDAxNSBTYWx0ZWRfXywsyL3CTtu+b
 2p8uypqQW/CI8GuwBVCCC21EwVqH+J67VL7sP5/Ts8yCqQrmungRSFivi7ruj+Yy5uHTnmva7bU
 7J09Jb2sBCWvOGEUth7WhZXjj4wun//so786hx72qMRZ76GJcJHfGEJAA0z84HpUd63G/CulHcm
 vFPw1EFuZMWPaIHeNI1HRyYLNhbTnbximVozyhBkUs74gm7FjHShe1BxaTzTPvLMoFQ7zUBXFwk
 fUXjjJIMHPYGgiu0AWAM93N5qY2uyOk06uU27r+S/g3tKMc9wuOuyz8vPfGGSt80aOTrNTCJqXV
 T5YyGeTUKTsKCfXFbGSUPMJieS3c9BKtg2kHFaUlNuk2Daz4JKJXdPVxM6Sq3bguF9iaUuYpYuQ
 6NZ1ZZ9Jpfsc7fBhrWuHtDglkg7SRA==
X-Proofpoint-ORIG-GUID: DbkJsJMGJ5Oh-oc06tjp0GciUvpTqkMM
X-Authority-Analysis: v=2.4 cv=Vs4uwu2n c=1 sm=1 tr=0 ts=6902d640 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: DbkJsJMGJ5Oh-oc06tjp0GciUvpTqkMM


Ajay,

> This patch series adds support for the UFS driver on the AMD Versal Gen 2 SoC.
> It includes:
> - Device tree bindings and driver implementation.
> - Secure read support for the secure retrieval of UFS calibration values.
>
> The UFS host driver is based upon the Synopsis DesignWare (DWC) UFS architecture,
> utilizing the existing UFSHCD_DWC and UFSHCD_PLATFORM drivers.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
