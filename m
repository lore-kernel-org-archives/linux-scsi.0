Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC33F42046D;
	Mon, 27 Jul 2026 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163454; cv=fail; b=jDbmLpDRO5GCFhmZDV/eUnsrCGu2+t9ny+JMS8KnDdlaiKotGtzED6qyw2t/dwsyHz9+bYegCesR7qY1PvB/iO80E3cCVvP8rzwy/AnXscZYOL6Nc2Y7aHN6eIDp83A9/3154Fs6lacYkPIWl4f1a9AE1kzMCxlydIgqSRF+sb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163454; c=relaxed/simple;
	bh=l5HOY3cXCjM+FPPOVpJyVrUIJ1lCFXH0/DWrJ+URDL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q+MdOLuqrvDCXTdpak7wJC5ZP6uCXzjVlV2hFEaeW4GW83vfq5f8zkpDQyRf52CS4fGsmzxT5H8w3BFYGe/QbTHv7i1JQPkF1wMrnRV9UuXRnWH33QBflPg4t1mKnYM6oje1K7NFM0YID2HRcIsM/8SVKSFROwsB5Jxkxey3Ly4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TZQ/Ew8d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QCd0co8r; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TZQ/Ew8d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QCd0co8r"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCUNRe2096592;
	Mon, 27 Jul 2026 14:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sZ23hHz0mHD8clYQLRPovfHT8Dzr7j4fxBCMpgGjm1U=; b=
	TZQ/Ew8d0iGNv+uBBgXWuCN8cqKOeKROdj3gOVbIGq5osPDAvcXDLfnNfKTGNT2h
	Rrb4A86/IoVF8+yDjG9U/8f8YsI6FItwYX0onAe+s3ipKAP2eNBge+/78jteqHhO
	+TLJyZP0tDdmEvgSW6uldck/i1kDYgbfQu9zqxvMetwlfHY4Fe/7nkF1+xJBSdmp
	VZtOesM9Nxm3PvyrDTILIHFfNtWQkjSw3lAmHXYNSUaKRWO/XkzNeEhzoy6zlK/C
	gxNRVUCLXUZrjfWBiYb134MW3U+/QmJUuA/8QbIR5DwKrGhgKf1mj+/WxRA+QbGd
	x0+B9URLixpck9KvOtJ7Fg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xsxj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeapP021472;
	Mon, 27 Jul 2026 14:43:23 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8gewqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X4sQuHn94NP48MoDX6hBxQ4IBYzH6kOf+7o399Mi2Knw14DhIukoWs2WcvXJVgqX1DyzhfBr9EOnNERgXzYRk6jV/u9PCNBnzGHHWwruMfkhhB5VtrU2gSXIbTVvYla9CIKsNcYu7Gu2qeBcKvGd87n/kDK+xQDBYMijOoK8EzEa0fwddIZUKqbtRXryTxSP3gX3wsN/snJyeORFiAzAYSbza6JDnoOd8BSNnX0+VTryp+B9LFUWiTDWXdJUhCKFyxC8JJqXjORmRv3v4wFI/bajTY7zlsU0jWHpUjVJAUmbfqV12Oz+iGopRUfJ3TpFSwDWuJfduFoIbkjVNqUiAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZ23hHz0mHD8clYQLRPovfHT8Dzr7j4fxBCMpgGjm1U=;
 b=xeQWAl/q8RRMfS6UDUIWEroj8e9Uya8Q5FfvCD4WMiXyMFSw0XL4W6+DkleZN/rppTK04K6hJxFGJsmQiYZthzqhB5aT23gjcIW7ZOFFiZKy09ol/tMV/1myK9DQFFO8kfruX9bXODXMqsMJVy3SIKSJiUOSd1YEHMTs/3duYRO5bgHC+yIorqb+sUjNLcpDWdvCbMKAdOrI03/NJOMRYszGaZklftNQJ9vDh/XpJbDbwH4QygFefXm8b7618F54eY+blFYXPkJyZAWIoDDjHTF4A4hZSGkKjtIvgWJRNlxCO40udKMK4PDyEG/inmu3bw/q2Aikpi4Hldht6OXwUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZ23hHz0mHD8clYQLRPovfHT8Dzr7j4fxBCMpgGjm1U=;
 b=QCd0co8r1uJnSsTr4iiRIUoTi9JWzG8iyXK2oZHvsOw37yMUZFe9HdOaib4wTvfYf5kc4jp9Np2hoe5lvPYliWMjpBq9Kgccj8zarCdsc0VyogjK28PTu0GJB2qDoVKkF9EmUlT2Zw+ZbgYmuZsnpcs5VBmaCan9X8SIeUB84Ko=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:18 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:17 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 15/27] scsi-multipath: clone each bio
Date: Mon, 27 Jul 2026 14:42:22 +0000
Message-ID: <20260727144234.3802948-16-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DSSP220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:3d3::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: c4d8c0db-150e-4e6a-5aea-08deebed6588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Q6QMuPdNRCFzsltn4iOD6bM2F6kmBVMN3j4FduWpgjUVh7iw3EnsUcHr9mgyqxuord6VnnTosIJcJBVAk6IgLiclwP06sViD5N6qZf01grL5B0sWXvT2EelqjE86l0Th500rT1Tfg/QG0LuiP0IA/ZVwJZwdFLcr627dzqQGvkyS0JU1br7kf3QezsOlBlBeqadHyoWBbhy85BFpeCrFTjdytnDB+aUqt8745HHVp6YQjX3PVqKWLqTb/6BR2g9eEnXFUQx1Mbw8L6M8OHiG0OXgl6J66v0nQbtc+n0ew3N49/XJHKd2gnYBsN+TrxigXJBSifz7ELYLwaH3BSXx1w/Kl1CZrpiRHnMa12emCxs7ruZTnVuOqnwNAYFkzpNMBZo1385Y0ctdtOQfUptYrHMr2XTa1R53M1PuOyrXZBqxbsAxdSiRRutGGW7NfuL5cozb0cxbPK/b3gavvVVNQsIcPnW0qr88qNi/IjAYFUjrijJVn3ZnGIP13pq+3/8t9W06f2PC+BnMQC2hB1n04VZ5jNbBZ/zVSCsz9N/siIp7zSXp8OS3aXeCzs4l7Oa38aBodoy8rX4kmtsb1Zb2+DOM/8eU4UGDGzDDBJfXeEOaKUvUpHa5r3CGQIEKuuujDmjz65yc1W5sj9szTdUWwZ/sNC8M5KWfLYfhbiYwSR4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rv4oieiJx4RZUAYCcYm5DYCL+K0+g7/WjN06XmscPZ0LmD/GKBqOmbDg/OKv?=
 =?us-ascii?Q?aZtrw8uGtVvUORqnvWww4QjkVFO5PW1sp1Nm7QFCpJWiWFTv/RMITLMOT0oq?=
 =?us-ascii?Q?BtLH4dJeGx2N5jGq+W6S89rj/0Jt20ItVfaZdDnJtYVNUNM2fn+msuucw3Rr?=
 =?us-ascii?Q?guua/PnxQxKER3T7bT0nbGknCmjLxLjm0WWFLMktsznkjxmPlsyH4gDw4Cnq?=
 =?us-ascii?Q?5DuUuF28tLNovJvfxgVzYNbuZ15JYFwTv9RLMxsL8H0fbATcVmD4eql1WdPq?=
 =?us-ascii?Q?/bSO5sf8dKQr02x7ldkXXbJeIb6KuVqUN8S/Fj5Htl6s/9kcD5EE8eIQgm7I?=
 =?us-ascii?Q?2xIoYKaNxhTC53IGgXQPjuDxrttkef33EEgG0PkDzhFTUFFs7TxA7yz0YdRf?=
 =?us-ascii?Q?/Gz1z9A3K8Ky/TMBSaEuTkDlQh/PymlkX0cpDiQRegKjqQznSQrj1HgChLt6?=
 =?us-ascii?Q?zJ2fCQ+N3pRrCHZjyc3n/D0/Y0m5e8HZtbIVotMgyvQm7xvF5We7tvx6qDtT?=
 =?us-ascii?Q?2xzXIxSqRXbklRa+wgcZpw5/17SNl0ftaGy8l/TD4Z5usqD8kQLw69wkTqyb?=
 =?us-ascii?Q?EcXnNR2tMvOnMDulJzVFPdsNEHFe7U0f7VHrUYgLrwakSKOIs+7rR/gmQQGk?=
 =?us-ascii?Q?DKKHxHUaAl7rn8tz2CZs16DxEUHjMPw/X/ydtl2tG02VQzynq5inA5281+nc?=
 =?us-ascii?Q?LQeIGFrMByyKJ5aZR1bBe8dhB5PfRXBAZcmGfcZop314luUNaBJLXtyOJd2J?=
 =?us-ascii?Q?UU5fBYVftWn6uNPKCVpQYccMu7VNi3uFEn6ru+XbqRPe5dQnLswS4J1WVyx9?=
 =?us-ascii?Q?mVhbM5i6HeAj5+908KFdS9QCZ0dYlRxoIDEDWqAkk5CVDXEmVknvEv6TW2dl?=
 =?us-ascii?Q?oAWFu8RkJjqgsCrxP/wn+LOoHK+TdSrJCZwyEYF+Wazvu6CGuMfoGhMg7A4B?=
 =?us-ascii?Q?lbfM5HuY6BgtvT2pbjulPJ53Vggqj9PtecLSEQOE5qmbRs1aH1m9I16X0mlf?=
 =?us-ascii?Q?P+sn2mvlUTYdJu6mSl/Kh6CjVC7axUrp2YT6Z2UOQ79BP2JS8+A9UAAdZu60?=
 =?us-ascii?Q?BWZV2QwH9Ksm3/5hgIJvRSzrjg9s0L/G1YX1lMbmS3lRMfpPaVv069Q2kd8X?=
 =?us-ascii?Q?6x/JPrRQlwJLmlWN3rrk9vKVQEzTeMTIQOEE3u5H+NQww09ueOKLWoYSg/no?=
 =?us-ascii?Q?pytU96dVdsFVp913SLHZh2Vzgqq1H5BGHKliDeTV8syabY4j45CQ+Pyz+By6?=
 =?us-ascii?Q?eV+jUJjy92W2nqMyXnfU4Mz1Ncdat6lkzi3bJ4YKPHbmm4Q9DTZ9QuSC7NGK?=
 =?us-ascii?Q?2rf9EkCdhqaUqx2skVCw8otXnADkmyIvrgaQSr/u3CRmuiP5wkGzfiA7hgUV?=
 =?us-ascii?Q?YcFTOt2dfMRrB/bo33xfc6jWGVoFutBhoZiIvoxxt8PvdBDlcoBMnf1BkvFx?=
 =?us-ascii?Q?wXh3wLs1HGbvh1xSXGNfbj4thnGGDTmgudpfevwyWUNl2XxPTnYFWw7X91/M?=
 =?us-ascii?Q?IyskBtQtCbSZk93ywVD9y12AnfgJWgCsNOCj8rVt3G7kKWsKUlPYgdVlm5Rl?=
 =?us-ascii?Q?1vggrENs3Vy/eb0acF1GJFdGGGvX3L7LhdlwGFMX6yAeHVrKYYbYCZYH3jKX?=
 =?us-ascii?Q?8eql1Qx80RggqCEi1SXml2ZOWX/uV6/fmVbR6fdOukFndPWq8dDdpOhqJ4+d?=
 =?us-ascii?Q?g/OllXZOz+UcnKSrpAYgfgRms9/1yj9ukVuVX29dU0lH2eCEb7OpTRm78Lgq?=
 =?us-ascii?Q?ahmWzdv2xhkZv/LyA57Zjyd4+qITxEQ=3D?=
X-Exchange-RoutingPolicyChecked:
	BotFEyNq8bbbXFI+GMUZbplwhbZOq8AZqGL7W+86I90KG4XTFaAAol3WwIwmVwaJPErwj8X47gO014qs7XPBrBxpViFXQJ91oncTOj1ErPnRrDQWBxWxgG6c9KZVz9+Yedn66Xo2nI2rBbLLotJQoJ+6sSmgn/tVHeFthQLPXHy8JBR9xc2ncfDEwVtDkwuWwNKT29Uqk458N9XmZNXceIwNwNuVf4JVsY1O6qLRT0TK0AdR1w7FdfeAxvWsK6l2ou0ZXQxxfcPPyZhBChD/hHW3w0kGMR4VcdsYepELzVjwaOVVgH/VaHXw+TaQL/psNejCdPxeAnCt0bSb9pSrkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/NP3ZN1kDCW8Vh9C3J1B/xhxCvfPj1Br0qKtA2DDwADEAaPOy3xMl2G7UOwY7/D3dzyuHaA2dQWva9orcaehvpExzOdyI9cHwfug3HNYnc/uJuw2yvdQClVOf4cpiiDq19XxK1xBmIhZM6sB34tcBEXUJ3ydIwMussmNN7qPYp7ibQdQ1cD/DIQwQuRtR4FhDHEri480+Q648SyOs/xjIs1/oEDH/5YNLY9Ktg9o32fryV0RVN1QU8GL35wQCRERZpHURi0h7kmXJAWlmkJGYsFGUPdGyvYBIQ8AJgilZsXHb1dLeORFgdP7NWvbpW+ZvgCt83a+t2tOsq/IxgT31QV8MZv1+Lp/1WB4VsmXQimiihSBcj7GppsbQuSeCybqj4xImG3u8g4AygYIP1Qb0ffnbLLD1+QrKD+Y36Iz7fVyxwXQ4Tn9ENS1eDtGxGYYuPlq2D7SIbKqg7bcn/cT/u/rlwz39yIExyrW8dhyJCi03BzJus8mmQexXxMG/4Tr6DM9ON34wYIKo0TO9S00UrkWh5efjnAwVwhplDvsqNEGF2dbEY39mVyTXYpAZtTJJy/9Abm1foGvkk75cKwNLvoEarLvU7fZwNr+1AIAoFk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d8c0db-150e-4e6a-5aea-08deebed6588
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:17.8170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dJev8lK/n23dx0Qf4/piCo27aYh6nSMS0dO/STLbg9oZaBJ8tiWEI+Zxca9wDkYvqP/kgy5dTfQ9wWhIfh/CTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-ORIG-GUID: hm1OM1NXCJwk_E_efwrTUepjwMap9FuR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX8064Mu+Wwwpw
 zQkdGjRLpmQb4clCNAbsdnOpslXyvFMBt1i16qqWkDd3w0iISJUSq8kYzQRk98PFbFETHGgdkXo
 Xk059VD/8umSiTjJthPDPaI100fSCArWLkjyM45VCIRouhzk4Iyc4POjq9rzMNZ1lCIZL26WJII
 uJDiOiAZofViwHI/A1PJayXK3uBPaz80ZcctrNFlEVa8rC+O3aM+P8dwXoZ0lF3qyV9wOKon8F3
 4YnSz7tXZcDwvFBKPfkvvqPKIEi0egwzFQS19korvnGY3+OjYQSJi1ZK8VsEtqMzoBiGhTaaO+9
 MwEX/F/M2QwaP0+5/jNMnQE6maa4ThZJg1xXj9LofFaCB6IROY5q/kxQXqebUbsSswmaLRfhFeH
 jh6aT3ErJmIggTarej08VFOxfbsx4IzKlUpiR9/Xefcq+iLRIBjFnNquLIF71Fj0YPyvyr18HOD
 AiQpUeHuOjzocJTD0wyaynryJcsl6RpZLB30uznU=
X-Proofpoint-GUID: hm1OM1NXCJwk_E_efwrTUepjwMap9FuR
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a676e8d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=PbwEKb89bYuBhGpDIggA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX1llGa1cBcnvi
 m2tkIDJsSGjpS3i8vDbqz8TzrZK8amNCmuRiP0Cgqg/zLcToHYU9y7a2j0NVGS+OJHvRnTljvJ5
 XxNgT4rUjoUWOFdasVuaxCgQ+Wd7CJ0TgKsZ+inAVW9fK0Usx59u

From: John Garry <john.garry@linux.dev>

For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 1b955e19a6814..5999c59bf7297 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -97,6 +97,7 @@ static void scsi_mpath_head_release(struct device *dev)
 		container_of(dev, struct scsi_mpath_head, dev);
 	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
 
+	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 	ida_destroy(&scsi_mpath_head->ida);
 	mpath_head_uninit(mpath_head);
@@ -230,7 +231,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_clone_end_io(struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	master_bio->bi_status = clone->bi_status;
+	bio_put(clone);
+	bio_endio(master_bio);
+}
+
+static struct bio *scsi_mpath_clone_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+	struct bio *clone;
+
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
+				&scsi_mpath_head->bio_pool);
+	if (!clone)
+		return NULL;
+
+	clone->bi_end_io = scsi_mpath_clone_end_io;
+	clone->bi_private = bio;
+
+	return clone;
+}
+
 static struct mpath_head_template smpdt = {
+	.clone_bio = scsi_mpath_clone_bio,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
@@ -256,6 +284,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
 	if (scsi_mpath_head->index < 0)
 		goto out_uninit_head;
+	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
+			0, BIOSET_PERCPU_CACHE))
+		goto out_ida_free;
 	kref_init(&scsi_mpath_head->ref);
 
 	device_initialize(&scsi_mpath_head->dev);
@@ -275,6 +306,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 
 	return scsi_mpath_head;
 
+out_ida_free:
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 out_uninit_head:
 	mpath_head_uninit(&scsi_mpath_head->mpath_head);
 out_free:
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 2dc02313b0496..5cc37acaa664f 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -26,6 +26,7 @@ struct scsi_mpath_head {
 	struct ida		ida;
 	struct kref		ref;
 	enum mpath_iopolicy_e	iopolicy;
+	struct bio_set		bio_pool;
 	struct device		dev;
 	int			index;
 };
-- 
2.43.7

