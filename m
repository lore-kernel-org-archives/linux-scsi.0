Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBB313C9C4;
	Tue,  2 Jun 2026 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780364629; cv=fail; b=SB04f/I4m1jW8fE5525mgNC9N/JxuTnyrF7Q7ISxC0rDUadsBn6kY18nXu8dGEyMxBB54ZF9WMHYhOQC3d+3D/yU9/s8AKuWiHj5AKuOQgzerUZcYDohyv6aN6fY7aPVJxMtQdm91lw6Qx8sqCtu8nw3KavsP+0wr+llJNT+aL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780364629; c=relaxed/simple;
	bh=38mtkwUYXy4+11PO6gzXZWOAYcjZaWYL8K2dGOj+HNs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=g1xL06BqFWQf8XJXY1uf5BbRX/aHUmNpR/ps+9n8AWxnzDTdJXs8FVblYx/oYAltP0WbH9PJ6YjNZl1D8FRb6+W8Ig3ALZkesl/zyqPUcFC8IXm+8hdnjZ7pyPJvXgEDAbs4ILsJ+63gXA0RybyUzzlBf+9003rog7m+Pz1ORF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cksz3gbr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pLiZD+FF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cksz3gbr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pLiZD+FF"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Gu0s1665486;
	Tue, 2 Jun 2026 01:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ECm9cJphxqxXyTH9eu
	cXqlNCbfJ617InY7ixtrspKok=; b=cksz3gbr+20UIy5EE3YwydafAIuZXAbvnj
	NpeYNCM9umN4hjWpzgegzY+XZC5SDYzHf5ReNWvXtCAzCw4RAXr92ixiJizjqtBw
	OExQexUbb8KX4OATbkOC7o9vvbKZ+RDAiyjk2S84SmnU7CxIdgw9JZGrJ6VztyOD
	SZY7U25sILGnKG/vlUoGAWX18PdbVC2CiW69LcAa/98HhMV4I2Sj2tSFfKtvC4LJ
	HpdvSFp4zYt+ZXylf+jybae93GttwNCewpFUvH/TfKYmc6a47Ogqwcd/8F26FgzX
	Ae3ZBhgf9bQQdhWNP3iQ1ZsGMmCh2iz6Gj9k05V+UgMIueI4ozcw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpaau7m4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:43:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6521eJbN015089;
	Tue, 2 Jun 2026 01:43:29 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012029.outbound.protection.outlook.com [40.93.195.29])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbqbhp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:43:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twnimCGZ5XbirnDE8cGwj2Y9mQbAneUHRqmJcvUhER0h9PiysyuB9tOSlfPQD9iXOAMQcxSryWe5zxK9uLGQ+K56PqSdSA4w11MUdiIix+WF3uB7qI8EiFd2fgcikJdDAn8MsdNQAnbniv8asKo3mfkbNbE6eCVTSQ/DQVnCNAOqVi1wju+A8J3/ba8LjJ7Zolxj5lQ9VvJq9QYJazgf9jfeg0tvBEP1LMXRnVsVCW4Tjtj1z2YyJLKo+GSVzWP7KvrCaDEHsjT3Ug8z83k1o1TVlp3JUlGGVMHVhapEKG706c1skqE3ZXG5JZnfzSydlmCSqQJkGHMDr94tTeNpxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECm9cJphxqxXyTH9eucXqlNCbfJ617InY7ixtrspKok=;
 b=N4fNGsn95DESTNLuzR2no1t6m37Lz60XWWfSlVKcNrSI6xFBl/fdCd7JZzLEA7Cf5u8D8Y6ykduD7Bp58fsmQcH0vKgHMCaOeIVnHZ/+GAwc79ccCCoQ7DPADkRK2NNupYB+uNjY2s05QDaksLUYcTAb2EOTlQZK1x7kyXuz8RPvmXRIThO3Am51n95HjdISJm5NDSf+hE7ACRTvtxYuKxh4Hw/sUdRlff77zdxynOl13a8BMirsNQXDgv1I/NNbGdrvc24zVuQhEDkfMFnBw9AUrHdvxTLa8/KwxqbHFREFWzDovYkvxEMgOSdoD7ngP6n7fG9/XkWwx/ufbyBsJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECm9cJphxqxXyTH9eucXqlNCbfJ617InY7ixtrspKok=;
 b=pLiZD+FFbz9qG4wzziET0/C04oqbVwNlMMsPckfHL1IhEcdpm/dJjwViOxYaEYuVWoSX3FYaJvc35IN4akhVaw/2ewlWQQg2lb14L6FydnS7IfMwN7SY/EOuqOBOXNTHqcmAEoQA1ejz2aqVExu1tFD113NSUjedMAu50h6gcuk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6193.namprd10.prod.outlook.com (2603:10b6:208:3a7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Tue, 2 Jun 2026
 01:43:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 01:43:26 +0000
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
        robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
        m.szyprowski@samsung.com, ahuang12@lenovo.com, ionut_n2001@yahoo.com,
        sunlightlinux@gmail.com
Subject: Re: [PATCH v8 1/1] scsi: sas: skip opt_sectors when DMA reports no
 real optimization hint
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260519135238.373784-2-ionut.nechita@windriver.com> (Ionut
	Nechita's message of "Tue, 19 May 2026 16:52:33 +0300")
Organization: Oracle
Message-ID: <yq1mrxdafa9.fsf@ca-mkp.ca.oracle.com>
References: <20260519135238.373784-1-ionut.nechita@windriver.com>
	<20260519135238.373784-2-ionut.nechita@windriver.com>
Date: Mon, 01 Jun 2026 21:43:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0160.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6193:EE_
X-MS-Office365-Filtering-Correlation-Id: b14dc98d-09b2-40e8-1def-08dec04856e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	N+PmfiOMvnNiPwal4lUbbNPo39N7kALi+2G9TszI8FN2TesujsE0KyBIO6rah4aLGaOdFffm2vdmD7DwfpqnZiD0qt+2GSIa9Z1aC0YnxyqkJTRfi3gGhHZLvgr468zLU1sg9f/5KQFm8EgjBtdHwInA2MVAUumBV9fuYF9P8bVqrPiND3rvwcZ8X7119AbJlqBfHBcJTDzGHEm3jHrnMVTXGrq5UHRm5T4fRM0CHgPEyeTAia2dkTkHmeNzLxYF4fYt0DCUONSuAVWyvhc/guvaEMl2KRjb84FoLKYmcsgXERvqzT0VPYI8AhHkE4Q+dRK6XpEMgHQCCX9N7Y9KfWM4gTBoT1+H+7wCu7OzRA/lrDrsA7p2avXZkYdkBBKQYZVlUZxaaHCduQBFjstr20RkVZO83Nsunz/Ljts298LJ1P3Udy2pn+TZSf0IhUYmg/TK98UYtzz0uDm7daRhZ+lxEzYuUyt81D0UKDKyS6+WbB7/6eGoi2t/S9M3UrD/hDCoryFIHEysEZD/X2cvLhqfQ5jlq86wBcvukcd9Q4HOqlrUUYifB6g2okZ0vSL/aJ6GmX4DCIkhsfvQZ6syg5E+AGiuairtLnvbceLNgTj2C9E5n3T8WiJr1SwyWLzoVFk2Td86g0kcwId0/SN7RUrcm8y3MvYSQX+yFWsiZoBdVZ0wcw99WB+fXVgdlwcC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jUs6Ano0Tcu1PgDUL0TV1SdgkrM5hpf/HG44q+LJkIMsG510xSsyciYOaFDs?=
 =?us-ascii?Q?xJxoYrgcy/0WyY+Y0bB/18BGtj9xvC9D7eov8/wH3TStT/Ni+qcXsMrBk52W?=
 =?us-ascii?Q?Alh/5DYJuiEP7l/OFE30kR0pAXBkcYWLAD1CYQbCPOiUHTXNS66DuCYT6TKY?=
 =?us-ascii?Q?wD00BZvHKCFWAMgGXCIXuksSShFl8uoXEfzVL5p4CkXQkGDPsOYtM9wzGCRi?=
 =?us-ascii?Q?5jyv8FZnqbZbQXgiuh0rlh89LZjIl9PwLlAqU+UTmcc78uT7SNFIONxYUm6n?=
 =?us-ascii?Q?lqdlsgArUuyb4eOoa/Apr0XW/s3sC4pQeWffJkQAaxi3gmkkElaHGgKGSBYA?=
 =?us-ascii?Q?tJS4ftwD/+7jlIi3ESO/Rc75kV/3ppkvHU3e+AsD7pfAxF4t86SlMM2xxtTC?=
 =?us-ascii?Q?I2+7HWIfxcvDHtX/Sc+YU/9i+zy8n1dmzZTCpEAKICHP2SSibFugfCL1Me5P?=
 =?us-ascii?Q?rj/LbU93dgnoHyVkUbWs0b+gS5jBb84e3o0gY+ju5cmhGjR88HTFAmUXPdf4?=
 =?us-ascii?Q?+9Nsz+d9+pCbPWYqIggiBByyc7M2n9V9aazZZvHde5vsxeNnZKxRtiMxXP9j?=
 =?us-ascii?Q?UkqyqHYpLCQdAZru9WTuMzGxC+iYWB6eKHDDN0KJrwQ0toWZhR9nDoeibmbY?=
 =?us-ascii?Q?wGevKdVvt+IznQ8OYSGOG+QsNPYWnPhNm0qSwlYmYQRntAeChDSwHRJ8ngZe?=
 =?us-ascii?Q?Dzu93zyzvt/uU+AOWLcUHJW8ByDkhIVdIEIDroFmQBdjFSJxuZr8XIawcnag?=
 =?us-ascii?Q?7qUzjfWgd3tJYC0022bupXujPJATv4+vIQWOfVEuj1aGCVSu08P6IpBi3G42?=
 =?us-ascii?Q?1Yan3G8BR5ZXzNmhoNrNSE+0PNdFMGhTt3UpFfs5y8UHKWTt8Yd3FPPBRVgc?=
 =?us-ascii?Q?mtMpyVJNGcu8i5zW1zHdi7E4TFa5xR8ND+93+jiMf0zsI6t6e8jUSlOqlb6x?=
 =?us-ascii?Q?0QGHme9HwrSFsj5p6txqtqwO5cnwSSDlwUYH8c+NeI+0AITVI+a/IWT9xsDn?=
 =?us-ascii?Q?rhoXqgSj57jxHyHwGdFs1TcH5p0Kfx4wSrzapAcPGVOzNtiM71vX46uAIJnx?=
 =?us-ascii?Q?0o3b1rp+zTktTlt6l21Xpf8PzcMLp67EeVO7lATXkHwZBNWSX+JvU3WmyZun?=
 =?us-ascii?Q?BDMV/suVRsuvWqKrF+n0CRxAcZtpXnxpQAAhOQrbkk24w7KwI4N4yDcIzyig?=
 =?us-ascii?Q?WhNJrrF4NDd3Ln01+erAg3qck83JicKDbaSIdjR6nl+ri97gDzhwgcUY3zHj?=
 =?us-ascii?Q?lZIRWYV7ngpao3uZfPNhqvVBeQoEORSATFZutQtkeSAvQq9ve2yfEKQ8e1wk?=
 =?us-ascii?Q?lr9APLqwGltGfVRSvu3NtvvBD8wlsmFma3av4Ot8E9qq01g8tR2TGo/+RgQn?=
 =?us-ascii?Q?BFSj7219n5aWEQ2yddfnsDUnyfNk9oV2dXWHbgODnlxAXa41RHA6+co5dybN?=
 =?us-ascii?Q?keoPIf5Nf7zQyW2aS0B7fa4WKEvRyw4vhRiAclEz/B0oWdzQH+U14Rr1Qr0M?=
 =?us-ascii?Q?IrQ8lYsSQnwUMPCAv+/0ZZ1CW8XlMv3XeNY4SlakY1aAxJpBn7BsCUUiv3jp?=
 =?us-ascii?Q?BGQb3UAmtfbmhEZV+vNW9X0SU8AAnHOZFvpChD/ZmRkiGvdn3U0bER9LkrCl?=
 =?us-ascii?Q?n3HSD9W0Wij4cmr2UjY2dLaRDilSA8bRsgIjimNkxEY/K76/7BUes5JValGh?=
 =?us-ascii?Q?IhtYEvB5qRyR/7GwYpnHwjTSwUMfpk9Az3oJOMaa3fC2EPMFg+ql27jo/vRV?=
 =?us-ascii?Q?Is5AUHW2OCsUpEpfxhg1fEvbNlgcXoM=3D?=
X-Exchange-RoutingPolicyChecked:
	Hhhhyv9w1otO/KkGw8IlX0FLJKnRFbuY+MbFOQ8iQbKmpqbdSBGdiIRqLbJjVJm6ivIY8eVCWhaqGr6OezVf2ypdCIyJOUHcxmmzLHAT4XcAk4sBXTNEhg5tIxoxuyPXFeHZLhEy7I9zUzZttKAw3H7Ba4DvmGjH+gl5LEISRQojQZydDGnLKPafuSbWCbS+Se+WddRLsOpCYp/t8S+TQhvYGZD9UWqP2cgDaYY56w2MuNmeTUquq5p80vO1WMdYXAfFRqeT+CV3Sz4U1AjZot2EU8r6foZBiFnaf8+ECJIqylqQ9g/oi+X0DOvyjblG7FXYmjyZev7xkY/+nmb8Ng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WOOAkfuDCBt9uFa8Y8eemYF7QFtALwPC1wtT3gkvWNKoD1NLIMxrM4pr1fSNE0EMwLsVzYjvsxRKIPV/lJLl69Emy4XQuFmNkoR589v0P6EJGQYbt8YD8DmpuWmtrRlVoktwYOMLmOhz4mjbxNjqQxAfdRIVoUcbMo1iCq25NV8/ywJwehFJtY2OXLSotnAP8nWWUrYSfndGzwSLU40nZOuQWcY95Kn/33JTvWE96dWo1/QLYB8TD1Jyb3EZksuc6046BqCP4DFdwUBbQ/fCCLfQ5CUXXVcCpmoPcUJw5nMZpE+bW1r0X2Ofamubyjd8iBzsQ2csjM+ld9Ni+6XYHpRbnliAutsVkPngbbB5mUQI+mmlLU9LOV/HXGcoD4bSnX+TGLLYVRYmSa7JnqSve9GtRqxmo4QtjchYjAK+bhvNcBDsgMMAirbUM0E5PA3EyLoxwDUnlDaM7o1V5MLK5mA2L4wnrxPOBmbYG40PEkX+QRxh67UheJH0M7p907FueYez8/7ozD5AiCettzUSVrPCV8KY+LCppZjRl8hGEAyPJxI7JtTrPLyaKOwWGit31BIWQBQTRRqYmBbCxuHg8MN/uA1rTMnLChHQ9LnJ/Fg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14dc98d-09b2-40e8-1def-08dec04856e2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:43:26.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imSEl13DUd1Gn0WLqV93R6iRUaUm4PrUtPYYRIKk6T7/mVepJR8RQnwZ5iooiDlbnVNcYbBm53Cj5x1rH1o3OUio6IpW86sFzJNjmNkRmls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6193
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=857 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606020013
X-Authority-Analysis: v=2.4 cv=T/S8ifKQ c=1 sm=1 tr=0 ts=6a1e3542 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=staTs4HCIzMD5R9_vnwA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12303
X-Proofpoint-ORIG-GUID: plhHLhHbxdiD4jsVLqSrC8W85dnqsScc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxMyBTYWx0ZWRfX3zQPL9ciXGch
 bv0nADA7NBultygH36fOnWUNdeCkAAp/kRKYEqidO+P7BAWeXfQmfAtJPDGZSnPvhJ3GJ46A6eK
 R9C/yhCGjXwzazF89SXbNs0ePNshLVNrS4/slR+lISuQAx4FS7mP7gFcbHv2nSs5d5TceFzx5H0
 Ec8SDXoiRLDXF3xceMCSCrYjTSGyX2DYYiqMyuSaZ0wXDWg4BwDNv7ExcgeX57l6sAYlgIIh9PK
 dgSnpxyH5prvbw+llWaWim0jH78+S+6IzKW43U3iKetOh4UXDNNz1y1SS3V5S6SkeP4TrEmu6Eh
 WXjw8ZKYpwkBcKRYBwK2P8LhKH1XN4enlasqTRULvyiUrX+IJ9iYxJPTMYbNKR5HewDMGAqow0p
 XnaEd0+er4WzQz8ls/Dl9KZ94oxTKNGFKvQ7/lo99e8+8yHgyDcAX8Os/heuZRRTZ7VblXVyFhE
 NxH+ZCDkfUeIoYCg6D8QyF/MHPtrRah2e30ZgL5g=
X-Proofpoint-GUID: plhHLhHbxdiD4jsVLqSrC8W85dnqsScc


Ionut,

> sas_host_setup() unconditionally sets shost->opt_sectors from
> dma_opt_mapping_size().

Applied to 7.2/scsi-staging (with Christoph's suggested tweak).

Thanks!

-- 
Martin K. Petersen
