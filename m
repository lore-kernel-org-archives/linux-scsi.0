Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55105126BFF;
	Fri, 25 Jul 2025 02:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409080; cv=fail; b=tFlLu8p9rrJULSxo4OFKE66YbedhH0Um+AyI5SJIv4iA9dIqQUfRQJRyAkVa3t+yjnlRnVoZcL2A+TKlLpJtT2R0ejYQ0Agn9B5lINeBU/JEeal0ivXjhNxN8SmTCO7w3PHT7vImBbmVYAYsmC8C63hLp+2VDgbeZDLVkTkLsP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409080; c=relaxed/simple;
	bh=AwS8Kz0ELNU3QdGQEpogbAWFS8MaK7Y46NDRvBBr/lY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dnQDkEaJhAguUgny8X7ZLKQu1WtZX5mUj5j69rB+PP7UM56wj3C90t+kvOY0DpwnzBYZWO5VOf77i4+WVGtodeH04ESO3ZGoat0HLGvMV15fzTRyueEbcWmALYwrC22H/U5w9uirkZt7MQQjJ/oaZUnhHQowdzyEGWyA1tlPpgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E1G/lNW0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y5fRhFMJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E1G/lNW0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y5fRhFMJ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLpSwW009047;
	Fri, 25 Jul 2025 02:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ba5RcyF3a/Iyp38fig
	5rJkb07awJmGVLU5bn8IiCCAo=; b=E1G/lNW0h66NafQfS7vdLKTV6mJ3aUXsmk
	hpV9pgk9WmJ2B+j3eIT5e8mA1olfA894hg716A9RpoOMhEK7dMoHvuVSI/Go3N3R
	L2BRUoDBvYNs0hQVrbJGRDRbxRktb/B3lqUZ9rgh7ZKdpeIPTtQ4lP9PBJqfjmV1
	wPs1YzDEqXZBmEy4/1W9YS2nOclZ0bjGMpHTHnTkbjZCESFwiFTPWehakYPvbmdJ
	ICDt2+VffyNn4+w1s3qOBqxyZTmlkBJdrddx/kQWwvrAIwLnY51wLjaOSK177IIl
	hZWXk1le6f/TFPcygVAzCiVYQcCnAvQP7XnvKwHAluxIG+2edVlw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w3wg6xc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 02:04:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P00PWx031503;
	Fri, 25 Jul 2025 02:04:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tjvdns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 02:04:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQSQTAIFPKZnPx8H7042CZgp5zAXk9cTJ1Zx3nV6V9Ij9Rsq5CE0siOq2WXjIsxsfGwlEYTwqkdzLQp47bHWpFKonxZgIMNXDzk+A4eL1AzWtnndt4yyz2KeSwJhvIY8Tgavwg82zESmE+btHsKxGu0x8x0lPrxlsf7Sy53c0pWPbEOB3I+CE1ngOnGzOuV1iMTmMyy53JAxYjVMA97IUtgcxBJCIG3u1rBSvwJJbTiVLn8mxdxb/0gttpA++vQ6hi6+v2mXhtxbzxJ32PpmVU4I7qOKzueSJRjRQF8qDowEjCvfskxavz+Exa3JvhHAf6gNoT7AzO7yndDEbovFCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ba5RcyF3a/Iyp38fig5rJkb07awJmGVLU5bn8IiCCAo=;
 b=R1mqmkXt7FchYW6KHcS9D/vuMoDKZsD/5huUPR1QtgC+V7QEMeXv3azdKEF6QGRNX9YIkAhBf7kI0dfzlJF6DZv/ZVmxVwHgvpU10Ggvwnbo0X5Bb2Wb+N9g4OP6hWS3oWcSdPanWAtBqoQodRDg4wJaoY7EdU+ak42I6PUagcWrx/D+221upLB8Bs5O5Dtunl77125GEbfMIYYIbIug2m+hA+S0QjwUqS/fvlbL2Mm8bvOoeeiOGq5QpJPZAeHg8PEtxDGkH2IcEvbEiQj0k1guHAw2LWFbqvDgga5ui5/LS7bR8+9Pc6uvbBay8eS4hks/dPu7sAPykWgiSTsL4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ba5RcyF3a/Iyp38fig5rJkb07awJmGVLU5bn8IiCCAo=;
 b=Y5fRhFMJ4Dt9uxi/JbaM4OhpLhJ0Dd6AeeWj4BodP2Pio5EdEYEW68GtLYgP+i4LhGlvcdGXCHxDWoKUAODrkBilVInBXRktuHOrWJ9nVH4nbYYopWIeURq1e71GgorDSPlAStpqMykrHM5wYcACti3rntv52JjX7Pmq16GZt6I=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPF4B2F62DBB.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::79d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Fri, 25 Jul
 2025 02:04:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 02:04:16 +0000
To: <liu.xuemei1@zte.com.cn>
Cc: <james.bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <huobean@gmail.com>, <peter.wang@mediatek.com>, <tanghuan@vivo.com>,
        <liu.song13@zte.com.cn>, <viro@zeniv.linux.org.uk>,
        <quic_nguyenb@quicinc.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: core: Use str_true_false() helper in UFS_FLAG()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250721200138431dOU9KyajGyGi5339ma26p@zte.com.cn> (liu's
	message of "Mon, 21 Jul 2025 20:01:38 +0800 (CST)")
Organization: Oracle Corporation
Message-ID: <yq1tt31qb5r.fsf@ca-mkp.ca.oracle.com>
References: <20250721200138431dOU9KyajGyGi5339ma26p@zte.com.cn>
Date: Thu, 24 Jul 2025 22:04:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8P223CA0009.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPF4B2F62DBB:EE_
X-MS-Office365-Filtering-Correlation-Id: 521e912a-7619-4f8e-cf2e-08ddcb1f8f5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7P9tQs3K1y01B0MhaQRVwZpu9gOQfrrA1icXUXwqPXAF6lMdZGriHUVtEH+a?=
 =?us-ascii?Q?g2MOpMMMwBLlABMv5CYNW6g3HUuygbrvtaqoBC9xDcUNOx0Z0zHgyMRgtKGU?=
 =?us-ascii?Q?w9AQFFc98rpyflCpBo6laAKWkG05Z+zpwtfKv6UShtwgyCh+Y3rXagKL+J4B?=
 =?us-ascii?Q?l+okJIKXkJRsakLqF569zpzefqHIm2fc2X8zOFqYMuBMhgCPCjxTYXMLdo5k?=
 =?us-ascii?Q?x+hGFG4zbiD2XhnxoXykSclNh6GyGWDSYPRotB8oslPpA6TtpbKLO0vv5EVE?=
 =?us-ascii?Q?Yd6PNpqe289hclQDcY4ARyk7CCuuqv9mk3Do9C3sghNUM4ANFxNAFLegWMf3?=
 =?us-ascii?Q?lcd8mxT+Y2izO8Mbu8irIApjo5BBl2zIEvKSQ6KmCM+qaKi4j6OLynC82ycT?=
 =?us-ascii?Q?TxeSU+nwwP9A0nXkw7vKNecOtS3k2y2CLvEeAIcmmppdoK9U6zAVnZu5JPCJ?=
 =?us-ascii?Q?cubEnu8Um/z+pAR8LQT4x0UT++MDC091dPbkg7hzBQu7b3kjEmLKvKoc8xva?=
 =?us-ascii?Q?hfnavzo0s0MeVO6vAc3aE6K2lMfadK9sVbufCwIqjgKgBnrc5i70w8iO6b3E?=
 =?us-ascii?Q?LZZ/RlhArRu069xqDqbMhcWQ7Tfy9eO5YtjmFlqsypoRNl7NqPM5t6cKQovk?=
 =?us-ascii?Q?+Ifkat7UEnuiesAaWOs/bRWP5bF5OLEKcaCNWLt0QpDyoF9Bqqt968Ff70+0?=
 =?us-ascii?Q?ugpd8CuKqG//g5jBMbnzPrpu15TuLnIPOvII2pJ9Tzvf2l63E78zPXDIuMDF?=
 =?us-ascii?Q?qhfm8bKHcUrD45O+8Mz8I23Rmij1e8Rr7i+toUXuZEx7CNjpVb7dZh4xqY6U?=
 =?us-ascii?Q?wQrD0m97ebeDrZdgtM09zdGJRO3XsRtGiu8Mm5r4VLslE8Lp8tQpQlEE3ovG?=
 =?us-ascii?Q?TBEmpPK+xNW5dx8wsR6feDBo/mkCL8KWLH1mNTzHv3a8eKfVYEZrgSJ1ojqb?=
 =?us-ascii?Q?K7qGnx03wUvWqq2mzLeabi5MhbeYy4nD+mhQWB/eJOMQCvBe7FQr6IE4OvQe?=
 =?us-ascii?Q?2Rcbj+zEgZmNZCJhWpXMYTkO8SIx5lrszKEVUcn6VGTVccLqdCKK6h9kljSL?=
 =?us-ascii?Q?/0pd/40wxRZn1FEKxI7GjqPc7L042345TdNmfoDtCIz/E47+SbsPlpj6uGYx?=
 =?us-ascii?Q?0ppivrF1zuR/XLpaltm/TN13Gk3gqAQVmqs1aXdI8wTjxwWygcRI3wa3qw+T?=
 =?us-ascii?Q?adQ8PBCp76DBMZTXCBv4/uQJ7eucUjlGgw9vNOA8RQ8ynEOigsu1W1CzqVRY?=
 =?us-ascii?Q?t5dbONIICMZ9UMPtQoK8WGHA0CHcJcd+hkpXGz53CkCp9/Nci61kTVcC7YRx?=
 =?us-ascii?Q?LJQGecvi4pnXfAGULkJbr6hiNZGrqABaMOA/FcmsATcGBVwoV35+R9NhhCIM?=
 =?us-ascii?Q?bPtNlIX8fmKJeq5c4SXcx2inkHQ36PudPSbBPKUTj5LvG9ZYZSjV0acTzqHb?=
 =?us-ascii?Q?PsOafQFuM+E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qt15Y49slXnDm7Up9E50zYYHfpDD/yucrG+qDqNDhfedoltUxSutu3DWBGae?=
 =?us-ascii?Q?iezUvzfUWdN/QyJyALTD084QFKlsEItuaBW1jGfcPM5X71BrAwJwMMdFNpJI?=
 =?us-ascii?Q?xZ1qkId/p8I4S1b70IRxuJa3G7skC55qgNma4aBz06jRPBFd49w37GRy8ONd?=
 =?us-ascii?Q?/Iyztuzs/9HYF60lT+k/Mfm6wltDAHlQ8SLk7IRuTnc/1SaOH2oMx00LGRBf?=
 =?us-ascii?Q?mjR0yXP+sPw9dROthsqMWwDCTbXxHVa1w8B59EqhcUCcZfd1RwH/9O2Exoxc?=
 =?us-ascii?Q?V2TSxAwlRpH4bZlnarvH6vDR0D1zev8Oypa4R1ZdqmrPkzlbMPvmkZCWWZQ/?=
 =?us-ascii?Q?v+gOqIWJYKvK8Y+/xgqdEcqBva9pKHH5Tqgjct9y8uNddd99VnkeBC5PDzkE?=
 =?us-ascii?Q?RribqlXAlzRK5oiRXXJycEXDEHnTNBtApbwNhFBioWyCgdeKXeZgwlDs4whj?=
 =?us-ascii?Q?SKdG88E6zrVvV2bz5S1isz9DS1y04uBpYlOB+rgWEGHZA6PglXJYCL8j6PDN?=
 =?us-ascii?Q?kdnE94/1ZBZi7LuYA2oOOQbjabeahgx88yCFFhB43qpdl+JLsqOAdRP/9yNI?=
 =?us-ascii?Q?FzwAbDGxH65jT0NwW6Wff7F9oy6lKlrL6Hf9rHXkDDgGW5vUPwoBh6gVBpLI?=
 =?us-ascii?Q?lTbhLPJOl8g1eh1A3/bJUtzpDoRQy+FA1Qv8Bu/9/kmb7OEwOpcRJgCiiR77?=
 =?us-ascii?Q?oYx9DIbPUVA9513an+oXOkLaxfEOe99G95C5Bzexr9zA0BUFGaTnweAQ2eEd?=
 =?us-ascii?Q?NcmgQTIBMXt9NXiZvr3RZVhCRNTk2jp7pU3NICQaqrwJxLgm3rFvLEN7eBja?=
 =?us-ascii?Q?Vx1iB6ZiM6yRv53LC0co/9uiHA7puxECojz19Li4BTHcQzb86GZ3ZfPUQ8Kv?=
 =?us-ascii?Q?sJXmAGmY8b1BU2EtqL6M0+Gzow+c9YPu/he24NXIe6v+NRwwbItfjEbpvbYd?=
 =?us-ascii?Q?//YEOzfOJ2LpRxfvoKWLH7NfERXqWMfpDx65cEHPuBvgsclR+hzIk6mxLkIz?=
 =?us-ascii?Q?SBLMn9WZfdIK+difn7QwbMFGQCYHHbIwjW7G6MFhSZ0VX4dIrxWu8vShVDQm?=
 =?us-ascii?Q?NWto+qqEeKyYVDfBp7YfIEz2OCqlx49jJeV6TG1vOe8WhVQsCssFktr6yxUu?=
 =?us-ascii?Q?wJ0m9hVyWo8VTBVYr6UhRuuzuTFpsCPxYdVIqOEbDXsXvqNxsUqGmj66z6S0?=
 =?us-ascii?Q?AuQaH5HLEyzJx+oge16Kp46lD9lLn818vkf4PbTXD398Obz1YHiPyv42xXTM?=
 =?us-ascii?Q?CAiZAMdvzy+X9uLjzXbBGUXHmyiHmA8h4b6SVZEQweLK272rOTpEq+UvfEL/?=
 =?us-ascii?Q?sG73CahNxGCXCYcY3lbTFBpBeMXNpvJiQN0sI0t1553l4uPJJdXckRDtNfaK?=
 =?us-ascii?Q?u+2J+o4HuvjDDzjUdNbUgDtql1xWHczHuJkuUUOZCEcva7SZ821qJifeyEc/?=
 =?us-ascii?Q?508CoWq5hg2GealrccyQQbPvbea+EIShYZu01OYmmfk6R+n8FTwACCBe68AL?=
 =?us-ascii?Q?MGxOG8fLaDiwKv76YuZ1faRjIhK5C58VoZYSCHIhXhWHZ/YPX9I+ry3xfMk5?=
 =?us-ascii?Q?V4QgHxUR8r8/4usY8lH7HWPcNmTws/V3Nb+Y4LgN7bMDoVN7BDzXLJfcP12d?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KtSYJmMigGG/Z9QfX1PJV99EdRrzy4YmW4qDjUz2u32ffSZ3Jb7fYTLJ8HcOCOA2gRs3eVCuFa/JkMHfZbG7BGavDQiebRm69vd26KzVd83ckxwPxjcrUlBQ1Ikwo2SIOlh6Mw664ACHDaro3PtRz5fYAMuhcPQksNmfEDCvChpOeR+RR4mfY6InPg1uqOlDkt88lcf9Zp3JXZZcEPaRLS6JZolFVgCjwXvXO8UY/jX9uko6EGS+D0WRC7qBnh44dOzLbZEXMtCac7TIa/4rOT9+pCzqlUMozR/fSv/rOyzZwR8DehLYC6aW7XrhPQ+AWkhcpk6f+LYcViq/PpQzrIzKb0gxA8dupRhx74SDLhoaJNIrPX0pu5isAYS2KbhvfCsgpNqDzVurVcEc1dPPIQq8v8U0Ax0cbix33hhL1IzdzIvzSzQJGSltHeeZ4um1PGEn1c9H5FD3TqtQgzL7We/zJ1nmLM01VVF5Hh92GkxVRjdCwnVyGqdQtaYaOUpWhTtahY5OXTWoL8GWc7sgt/2tkr7cFxWuWPHIW6UASl5wm4kdacnvf1HJC7BHo7J8R+kVbWnfsKuX0IQs0ZJ+fLnaQYwfuQW17i8QYsiWZi4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 521e912a-7619-4f8e-cf2e-08ddcb1f8f5d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 02:04:16.7293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5ozgTNlnNJv7cu6qbZqdDj/YkTwxiFbxuG26lXlTC5VRBrWPqdHyjRC1vAHUzIfpOaZB1u86dHDsGbsgrFR4HgeKCsN9LWoA++PWsND27Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4B2F62DBB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=894 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250014
X-Proofpoint-ORIG-GUID: Eb1rP5_3lLy8uWF7IVVZuqItv0FxZdqD
X-Proofpoint-GUID: Eb1rP5_3lLy8uWF7IVVZuqItv0FxZdqD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAxNCBTYWx0ZWRfX4YDosp5mhWSZ
 NGhwB4YR9i5O/p2MEYPv2oE7ecHS2OtHKdFEBe6vhlLER0o8xkDxeIn7QLZYAqgipWJs65YTcab
 m8QoikFxutbNS6GVj0cvCJjITbG5C3yn/ffCI7+OoAjtnOIH4ikjHEv7Skq/Ez3nae3kqObBdST
 MewwRM93uOfpLTl8I0ed+DsLCV/IpP2NfknWRGyc5RFdhn6wl0XKsdnS+QkaVTBUeWKXvKv31dI
 23IUMe1WzmGMxgHhbZHh7h7blY9P585I8KaqRkPIc4S85A7jN1Cr5fURu/WPqKfHUasw4RRrpfb
 1zqtnVgid2+Xa8G+XxctvzoAtRd94hrrfVe/Uu59rNCVgtsEiXqw5P7QOXdlA8N5Pm8GJJz8am3
 /thIBUizet+LfEC2eGvru5Y6xM1A4UMSXaqf6mo+9JClEnV7J3wCUJb1IevFV1+syjeFwDFs
X-Authority-Analysis: v=2.4 cv=Jt7xrN4C c=1 sm=1 tr=0 ts=6882e629 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:13600


> Remove hard-coded strings by using the str_true_false() helper
> function.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
