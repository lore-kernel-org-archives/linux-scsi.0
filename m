Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCC841BA8B;
	Mon, 27 Jul 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163423; cv=fail; b=IsH8bewe7rQGm2B4vDZMDy9utgSQb79WvZbAdk44Zd6AEzkcGGhzfgg60t9pP7OtB/I9XPZBPBtKLJjQyq3mP2zxrdIeiqPPEzB3uJ0WLS288S++CguWggCQ6iOBK9Su6Ijc0ruA/v3v7p/+uxNdJnRnyZDuFOpMYcEc8+yqN0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163423; c=relaxed/simple;
	bh=ocRZUbV8uqJk5p0zecyj8KiK7hEfuu1mI4j2CGYrEg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o6mPjyOZplzwHz6SMdv3GabRNCXgMYgE4WpUflFBeZp1SDIoXVWr/NcwMle1c1EIkEpyEqgFNQmuSNEXH5UZnTEYv4e3/IahbQ/JpmY1Dv7Zoc/3Jn/DeHSSoCnVoPQSqY5vMEi47krdaNW1U278b8GiCo0aCeT0UaWveYFhVeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oT70ug+i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BnU+HPnb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oT70ug+i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BnU+HPnb"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTNFE2057047;
	Mon, 27 Jul 2026 14:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jEZnYY2ypCToqmRdci0Gr1BhgDEo3DNK/lbHxqf/ako=; b=
	oT70ug+it/3MrRozoXRE8ewiJAEjBWNSC/aFgUPtZtBB/VQrHt2bxqbO1Xts3pE0
	HXZrFSowhwPTD23iEJAtgEChWOO5Dc+fqJjsQmmApeMvT6k8VdjcIl/YjknXx0G0
	fwQ7AjfkzBxAWZtz4sc8h7BadP8eO35GQQw9izTyyySilZdBFfiBBkHLaqpvZ1/4
	i3Ez/F44tK7ESLwCM19s3UwIkjS/85NGZtNAjPgL0FTQ7eB/wiN9UvZKAVzV+7YX
	xZbXlltj00P8OE232jKF9XY0fdwO4Q+ijUjnO88nLfLfcLN32I4ldO2OOI61EULY
	WBP9Iqg0kTuIY5gCmQbtqg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq1xgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeBOZ006867;
	Mon, 27 Jul 2026 14:43:07 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehaw70-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U0b67HO+/nWKPZpWnCKjH4GS1hkbVNaupgsgpvbrvhE4Sb5dmw52iJ7gge0rrl2Wlxt0CepQXQljNdhA5ussHdGJAatLDRc3/SCFwy3wNCE0epP8S3ZxyYF4isOEfAxSHJA1d4/Bi3qrxZv6eF4aClEcFQoT+h7e9Fz2egCl5g1oc4xTlhC6V0zLJusIA5MiJxKo8Rejj4/9iMZsM0mwQ7ZxqKBvHeBdxy7+6IAatRoUNdatc6h5vdoaq6g2+rMuvVXSuGmAwBiRFZZSPPjpiGJQk/+7tb+8grdtlemQcKM/eYHwKNGFZKdJYnmxJaVjqexwQe4VurL49jd7OsV4cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jEZnYY2ypCToqmRdci0Gr1BhgDEo3DNK/lbHxqf/ako=;
 b=riyvJ71g/QjH2C/U/EcrGKyHMo2IpWBc0ZkhfjEPPPdiu/Os2r12XU6xxWyTRw2YzMjwymfErRRR0HW+PXOjUYvAwa49Bi1MWc+scPiqcViFMtskadk3vMT0ZdtNjzeQyGl1otL+iriLZ9YeZyTmkVF/UlijErhi2tQlaEdXWzPQeCy6GZdo0QRkPMlTdSd+B2xpCTvwFe8hOFRV3bAjhKGk/zpvGihrQRS4FL8n8XxLXvU/d9DSeD7GqwQXeXh6fTeC7CVZA64z1kZ9CAFcH6ZWtX+3kLZmKUQxz/TAed90MnCBbEt4RaXaTPnKlhetX/8UNYapwapqqqaL2W5gvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEZnYY2ypCToqmRdci0Gr1BhgDEo3DNK/lbHxqf/ako=;
 b=BnU+HPnb+9Akt+x+IwnRsnZGmp7vwxLRb8/yFNywVEvZIIumMpiCMEh5ODyRt4HiUoeLzhQAGiBgDOrGKNR40YvvQLDLcC9XX54WnsMVHUHOIH7WlYN+UKliXzP9fmmLkVzXlbpIcFPp+9zuic2/n+/C2pFlqEtbd321yy1B2W4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:03 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 05/27] libmultipath: Add support for mpath_device management
Date: Mon, 27 Jul 2026 14:42:12 +0000
Message-ID: <20260727144234.3802948-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:610:e4::26) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 43f6cd40-6745-4fe3-d57c-08deebed5cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qmuZeuXDZMolYmBlxAkEUN68lmMXrSHs3YEES15bJ0LI3Sb2lNKY2m+QK5dyO5dK0EOnG3LIVmWI8y07tWKMtq/7tUuascDEzEZ+0mVdjSmN4ldRfkj4g+LrkHUPBCdTbj17s1TsAdSEyhSu84J0W6zj7syfozWdjeBuqAV3AvHxGSv8Xq+BhT0Di2fTj7NvqemYs5Bx+mgkyvNuxk57LF7uqV+waUkPdm4tN+dMAbJooz7RwaVB4zAjzSgLmAQbdhNg3WhZZYK6jBOoL9AXLvbjvGX56Tm5QJq8rhNsS+rsiS/mA+XR2DVoQ6FEtSzPLozdFtRatpjxzv7w80RbUKLRVvzgnMN+kgf7R5RgkPrXtpYRMMVx33FVLQW9OpsTjtzahzmN8Rl0yBfWf9FQCGL6KbDrTYxVisM9HXTY2VVDcJjBfe4V1uuNt4sOg7U46l1U4w7BGlcupKdHfxdKMlDqL5rZJUOaIE+FHr6RV5Mpr52fMgXCFd9z8OAd3WoeYr0iVFPo18wXawyLYwzOYfS3hLI1KKXefITelKPpNKh8Eip8RdJ8HVJWDpQzTUeQgy74L5jdalAIr2TF5R3U/Z4Gyo0y/rvbw2itUlRLSI40WRF5tWgDZ7/M9VBC9qkyhBw5l0iT640eaLawMPTY1KtEJOMkhWSaX5oOnYshuS8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PAdT1IEkciouZu0Vmd6by7fOQo4BF7S4L3/cEmBqDMSJMfLr6zA4NeepXvz1?=
 =?us-ascii?Q?Ta2rEQKhbR9QI8cJrOuvhIrPayNqlO/5KD3fx5E00ArSPaOMCJiUfFgQptpm?=
 =?us-ascii?Q?cw9RcEx0CK0/EoglbyQ69qtXKWhbY1eT26dN5ushnGLUA4SZYLN68ZidthdJ?=
 =?us-ascii?Q?7y10bPVpgyzmxsK20s5nqE50iOO0CTh5IygQaEwzu1KeHZ5NziIUV9v2Ju6C?=
 =?us-ascii?Q?UIBFCNWTsefyZOczM1WQDyPQSaoexF33PGuZ8Z/DJVHwlMwQ5x6j/gYOD7ef?=
 =?us-ascii?Q?I6M+NZnm9LAtw6xlLkFdUJ5gfmkwrIYssSrodH7e9N4XJwI4dbl+r98HZI7S?=
 =?us-ascii?Q?LkZAkBfEHrmRl9j+6fnIaY7C3x1zyooMUlSZdY1OZxhHtAmuOT7tnv0XB+T7?=
 =?us-ascii?Q?fkWTEqF0KBsBcp1vi+96sa+Jgeq4V2xdsot3euCCR1LKERZMIcYb4Awt01Lo?=
 =?us-ascii?Q?1asKfi0EgEk0xNQXt/Ixq/znxXVyn8Jy7kGbsWhEh1+kanWZSev/uIUJGPR9?=
 =?us-ascii?Q?fCarGcT3byR14DcBwfb39VV/sJp8QLY1ndWfKIWlPmUWiIDXJpmjjGKsBTPW?=
 =?us-ascii?Q?JUMPQkA1AWD9vUhTr3w8Icdt1Qp/KFQ2VvCy3oOmUt4RFypGLgXNUwaD/6v9?=
 =?us-ascii?Q?7157gKiMgwboJsbfr7xo555+PYmOHV814EVsj651LNTDwBQ3DD8ZbM5STsgF?=
 =?us-ascii?Q?ZB8CAfoIRpPimzzSrHjNw6uojyK1BKUYJTJvwgwPdDrhWbUqqWgmjFWVe1Vl?=
 =?us-ascii?Q?m130CIQWK1DcIiWUh2bSI/e+50tTo4wvqWZnHYZiGgzSO0+P+OpIwuRN1iAJ?=
 =?us-ascii?Q?4mqCmPI6IpXR9fxS7fqHgB02/+/8zqu59wF4H/d+BePywT812L+h3J7Qy2lc?=
 =?us-ascii?Q?Lmky6JXZ2wxAG+KoLbad+yQIsKK8lvfDblbw4MHsa6QOBT2KSS/B2gDeZTzY?=
 =?us-ascii?Q?sju+lI3CMU2otukzbq+CM+LmhetMDPRTHMIBGEiRWWnSddxvZ0KoR71g6Obo?=
 =?us-ascii?Q?14UuFDINVFhR+2vYmURCmDGqYN6E75WZdoh9Gt4Mvmeoz0LoPW7kdXofoxiE?=
 =?us-ascii?Q?xixbUwkhebpVxMeUfoPXjGtojYAWwCCw4tIQL0/r6Rl21pBDkgj2U10BPVIt?=
 =?us-ascii?Q?ju5YsZT34n6seTCzm42V+g2DEh7HcMttrwiy/sbjtoyOQ2lR8g8HZ2Rwa6LY?=
 =?us-ascii?Q?C+/BX9g6AFn895IPPnc4znjKihcK5lB+NKK6nqMIrlCItjvZvY2//NB0jhJx?=
 =?us-ascii?Q?hwT0bMR/fiabFqqs9GjXSDMSgdslSe3d8NbQkcp78nGnB80ha9ys6Hkul1sc?=
 =?us-ascii?Q?/PwQFF7ZSj5Eqw5rIth6YXrs3QSXIuGMllPJZmN+alFStcuKqU0IyvxrhyUK?=
 =?us-ascii?Q?IBzm05JpNvPnUTtqa9RsTZPifpXYoRFlvGCKN1Da0PQXUlwKFq6TpZpcbc6g?=
 =?us-ascii?Q?EnohXB/xvZjJLeQJK8G7Tgv0BSBgySZGeGgKjWTR2JDakwaOEhMUrjgi7n+A?=
 =?us-ascii?Q?A4I0zM2CwVGSP61yIs5aS/yE5ho2UmLx5PhuolS/r94d3HVjxeEI/Ejrfmkq?=
 =?us-ascii?Q?1VUc9cN9uNwC3+AUdQVopqh1P44zkZWPoNsvPIZi8BUzFuE8/q06r7rc8fjj?=
 =?us-ascii?Q?qzYJypYOEZac802+KqPcdyTMLG26KOMM3571VWSPFwc7CO7jXJab0At0CXYt?=
 =?us-ascii?Q?p4xj3FJyBUio8VCj+XA/KkTbTNursl2sryUkKjDrK7kEovluK1ObF/g+hjhw?=
 =?us-ascii?Q?TskxdvH8MD2rUJoVF0CDKoeCXWOuaMo=3D?=
X-Exchange-RoutingPolicyChecked:
	XNBN5f/W3dUOA11ju6PbEKuu9wd4vhtsDrQ6ZqTqa2QxOCNDaM6O8SoF5Ak0TdvXpVrvt/td+BLqrzkrqMprxXJckv9I6092JoyP1Nut8prj59bvJGdbnJuqN3kPOmrWbu123kEsw/HwDB3E9YdZcgSE+Au7ssWZGmdoXrojSFrovAok/12WV9DpNG3PCEEDEvI7J2YvV2Y+J3luD+lALvhJsvhuxogOuAKGDWifoBMhbbgU2bpc3NK41QxsfB3lM/vRmYLFT3aq+QSRkG+/OQWeN2I2ooUKUaDcDIsbjFLLCD8jL/uu/iUjX4VWGbnynxKyEakrAVwZK1nL0LDGuQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZcF4PkHuSlhWvjlT1HkCLKjfmi2JyBTt3VBvCQbgOLlBLNpGxDmjrqkGuVal6Imuet5CE/HSphVhWJNyye9FrkkurelUtl6PHbsFhuLZd7f15jgz4kZs5YELTWdIaRQVcEvU52rozdA7xrZGdeN1saMTAgRUMe6Yca0/dSJpqwro85MYlGChb/IGVBVgUk050GImbUqQyDk0KtyGUURCFyv0uBfiZHIfBkHmtBKH0ERRnQSJBkFbzAte4GW8zvc2SaXSDbbWvYFo198/6gXNDfhHihJbNexMElhARsaBFNX1JHYj4BWHTnfqXFrNad00swcfbAobhtaXVBy4IswfJenhUgMIOGMzdGSBmxNMsIQbI2tqTd5/ynHUDto+BvQE0aaSEszaiYYI02YMJt7NIvw7ISd1fk7LP6vAOikSw7mgTF55gx5/r/ELQTtPTPvnaubdgDwSVTZNDcfJP5G6fPZUAUO4lQeMtTCxdXVhgqLqsb5BoJg1f7K75xWSIuC4+5ES4GfPXtY03K3Vb04rMnYS39XfeA+j2aqSpPhiOINS8rfO0D6eDGF/DIzXWjscTE7SwKoRcwhJE2zmSq8s5ToHenerh2ycSsDgpOMgHgY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43f6cd40-6745-4fe3-d57c-08deebed5cb0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:02.9819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WpXsjhfcf3nZn+0eONz3aWblLDQi9DwkWucVU+iT6C9iDdhQmsXR0ugNYy9eNAj9McxrUxWG2CfjMkBRbn0whg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX6wRi8236utZA
 GVF6I+6Q5BTOKUXtr7ecbrHQQ+Ip4O/klnMgMsDuq/l3y2sGykwYCIdf0hiJQNyWD3QKDxqI+XS
 Z5NgapAT1rvbvzfDmc1abBRK8RWhWrUvZhATWRGgPltGL1wwKnZVUpWqtpzox6+/OXc5RTJCtGL
 hbzv2NjX9l0njg0DkjyxKzDPQMp/kk4/RB9Q0DbACitPVtSrGC9oIKj/1mHPgNiK2gxwDbUXGh9
 2JZQN5u2ha7C8/PoANZDZBEbwhlT+v5n0pxKOKF+rXOvFXMHsZIrvPW0U7qOnSo0lBMpvMeZfJb
 tXvIonE2GKF3L2uJdTwabLy1JwI8EUAyq0CREDUwPeUMoznKoZJ7J7hN2rJfuQznWthVOZbCDTW
 k2zX9K1AqjQFHFd+8snjgcQcm7fOpGxVJ86JIP+uTbvGmWJdp5hw6E3Qh5s6l8yqwvxOFSFre/8
 oUTwPM8I1woMjbTvsew==
X-Proofpoint-GUID: bIZCu9ejqXHKAwIu_HQxZQkjGuOCEpHw
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX/PtQkWy134Bk
 X4L4lHDrrw9ubWjNaHpyYAd0h088kTsC6v4xjOTlhicbF/Fb0Uza6M+XOHdnIx7uLNKSEMytimr
 zOhplcMlf3bth67vY00sn/xrJnlZoxsnSvolgrXqmiGM187WFlLr
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a676e7c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=WlZ9DiTZ2y1qVm1cHVYA:9
X-Proofpoint-ORIG-GUID: bIZCu9ejqXHKAwIu_HQxZQkjGuOCEpHw

Add support to add or remove a mpath_device as a path.

NVMe has almost like-for-like equivalents here:
- nvme_mpath_clear_current_path() -> mpath_clear_current_path()
- nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
- nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
- nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()

The functionality in mpath_clear_paths() and mpath_synchronize() have the
same pattern which is frequently used in the NVMe code.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  12 +++
 lib/multipath.c           | 154 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 374f0531f7e07..033ee8d54bbe9 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -20,10 +20,13 @@ enum mpath_access_state {
 	MPATH_STATE_OTHER
 };
 
+#define MPATH_DEVICE_SYSFS_ATTR_LINK      0
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	unsigned long		flags;
 	int			numa_node;
 	atomic_t		*nr_active;
 	enum mpath_access_state access_state;
@@ -89,6 +92,15 @@ static inline enum mpath_iopolicy_e mpath_read_iopolicy(
 void mpath_synchronize(struct mpath_head *mpath_head);
 int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
 int mpath_get_iopolicy(char *buf, int iopolicy);
+bool mpath_clear_current_path(struct mpath_device *mpath_device);
+int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active);
+bool mpath_delete_device(struct mpath_device *mpath_device);
+bool mpath_head_devices_empty(struct mpath_head *mpath_head);
+void mpath_clear_paths(struct mpath_head *mpath_head);
+void mpath_revalidate_paths(struct mpath_head *mpath_head);
+void mpath_add_sysfs_link(struct mpath_head *mpath_head);
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
diff --git a/lib/multipath.c b/lib/multipath.c
index db5f83ebe5d7f..f70049b6cede9 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -50,6 +50,87 @@ void mpath_synchronize(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_synchronize);
 
+int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!disk || !nr_active)
+		return -EINVAL;
+
+	mpath_device->disk = disk;
+	mpath_device->numa_node = numa_node;
+	mpath_device->nr_active = nr_active;
+	mutex_lock(&mpath_head->lock);
+	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_add_device);
+
+bool mpath_delete_device(struct mpath_device *mpath_device)
+{
+	bool empty;
+
+	mutex_lock(&mpath_device->mpath_head->lock);
+	list_del_rcu(&mpath_device->siblings);
+	empty = list_empty(&mpath_device->mpath_head->dev_list);
+	mutex_unlock(&mpath_device->mpath_head->lock);
+
+	mpath_synchronize(mpath_device->mpath_head);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_delete_device);
+
+bool mpath_head_devices_empty(struct mpath_head *mpath_head)
+{
+	bool empty;
+
+	mutex_lock(&mpath_head->lock);
+	empty = list_empty(&mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_head_devices_empty);
+
+bool mpath_clear_current_path(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	bool changed = false;
+	int node;
+
+	for_each_node(node) {
+		if (mpath_device ==
+			rcu_access_pointer(mpath_head->current_path[node])) {
+			rcu_assign_pointer(mpath_head->current_path[node],
+				NULL);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+EXPORT_SYMBOL_GPL(mpath_clear_current_path);
+
+void mpath_clear_paths(struct mpath_head *mpath_head)
+{
+	int node;
+
+	for_each_node(node)
+		rcu_assign_pointer(mpath_head->current_path[node], NULL);
+}
+EXPORT_SYMBOL_GPL(mpath_clear_paths);
+
+void mpath_revalidate_paths(struct mpath_head *mpath_head)
+{
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+}
+EXPORT_SYMBOL_GPL(mpath_revalidate_paths);
+
 static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
 				struct mpath_device *mpath_device)
 {
@@ -469,6 +550,8 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
 
+	mpath_add_sysfs_link(mpath_head);
+
 	mutex_lock(&mpath_head->lock);
 	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
 		int node, srcu_idx;
@@ -485,6 +568,77 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+void mpath_add_sysfs_link(struct mpath_head *mpath_head)
+{
+	struct device *target;
+	struct device *source;
+	int rc, srcu_idx;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_device *mpath_device;
+
+	/*
+	 * Ensure head disk node is already added otherwise we may get invalid
+	 * kobj for head disk node
+	 */
+	if (!test_bit(GD_ADDED, &mpath_head->disk->state))
+		return;
+
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
+			continue;
+
+		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags))
+			continue;
+
+		target = disk_to_dev(mpath_device->disk);
+		source = disk_to_dev(mpath_head->disk);
+		/*
+		 * Create sysfs link from head gendisk kobject @kobj to the
+		 * ns path gendisk kobject @target->kobj.
+		 */
+		rc = sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
+				&target->kobj, dev_name(target));
+
+		if (unlikely(rc)) {
+			dev_err(disk_to_dev(mpath_head->disk),
+					"failed to create link to %s rc=%d\n",
+					dev_name(target), rc);
+			clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags);
+		} else {
+			dev_info(source, "Created multipath sysfs link to %s\n",
+					mpath_device->disk->disk_name);
+		}
+	}
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_add_sysfs_link);
+
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device)
+{
+	struct device *target;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
+		return;
+
+	target = disk_to_dev(mpath_device->disk);
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+
+	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
+			dev_name(target));
+
+	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
+}
+EXPORT_SYMBOL_GPL(mpath_remove_sysfs_link);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
-- 
2.43.7

