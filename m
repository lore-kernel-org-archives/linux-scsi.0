Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C533EBF13;
	Wed, 18 Feb 2026 02:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771382513; cv=fail; b=RT1NvaAgD6ZG+Fshg4UmhmgOQlfRAC8ASQ14EZI/pFqMtdJAdT85DV+rp5Epg8K47bxBmexTVNPGpylsw40Rn2OXzHUnYU6lzYVZOoOKvP++lZV0JtyukrSv3MYWUddIgmG7hxaZOQ/SVKLCu0q7YVtTLMHMM7UWFk04zrblxWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771382513; c=relaxed/simple;
	bh=kwUqcJj45JAFuSuGO1POdGDe2RGylZ2c5zYPYLqs2kE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=h24Aya8UGYoFxq2P8QEjVncmZ/U89PJLHv5zXQJ1yf7dUnkzjl/qMIrqr1nrcQKAQ/KRH9/F67GRObB3+LyvB2cJCpr78FTFMg4aRYBZ0TzWcV/zLxMfbHddHW//WdlKbXYjpxbO7cyE1lB2Yn4Pt0NMJUPniRaym91oDs/GVzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eXaL0JuW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DKTWZbvF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eXaL0JuW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DKTWZbvF"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNQca026280;
	Wed, 18 Feb 2026 02:41:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8aw/ipk7fOxjeQzfvk
	ENY4hDp1PCUKA/YQhG8BRbTms=; b=eXaL0JuWcU4OJNqIbUTqXyF9f2BBaJQrPR
	ndS3RUsoZDPwY0M1m56tBsltlN4jj0jwJ6X8y5YQJ/0V58NO2rVW/O5jp1kWfx4D
	E/hQ56FgpSPaVZ7HG9W/EW+kh/178yi0pI7kFVkGIwAepFjE5+EzkE6oXeE5Uygn
	k8UJuUJPKnr8q3KDTkYujmPGnSOGEmEmrJuE18G2fUKdvooP9Kekjuu0V4YNFNKO
	ji9jiwO9INLnQ5TJ68VURzjCijg8U9aojShki1w0sLLEKJU+lIyAzUMEtpYd/12f
	GGoSOs5DWJ3D5VbQU5t4Ivnjs5PyxdQO8O7eQ2zC5BSq9G59CdEg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0rct2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:41:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I1mtDk022918;
	Wed, 18 Feb 2026 02:41:47 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011064.outbound.protection.outlook.com [40.107.208.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb2d1d4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:41:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eUCkJqX0X0+bthie9WJXnRw34XZR3+oVK1lGNivd5lQVw5Hx6xy+UmjnzaRTtpbEVVd7zjBgytCHiqee5nrSGlEmrIlstBSdqlyQtFncfG6i5ehhw/fiwPKOjXkFcAAdMrWvtT75aSHfd+wL/vMGwrQI3QbBgDxRFRBLRq6OE4iwxu8SEh+wb+o92NGkvlHqdPSvcdCB/0/1Oq7E84fY6we77fdKSu0o9oZA1vaCmBLYtnc7lEVhjsm5hET3m8r/+JjkdZjhSguc8RLOaKvxfRgvfgS7mxzsMRBWPxXnEEtgcFjbbCi6Sbpc6btm+Em3yvBwgXOli2Ib+HxrjjBTTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aw/ipk7fOxjeQzfvkENY4hDp1PCUKA/YQhG8BRbTms=;
 b=nx1ui1g4IivA/EO2Xp0ssYy+CeiQ4k3UDSJflz4Co9y0pNe3u86G63lmV2xONgtR/JDIpq1cbceUnUj4bDE4i4vqHFGP3WuJvdvWus6hlNUU704fEbsc1UsOz9yOF5lxqOJcMO/JsZ9NeiOxg4+gWIJ5VJ2Igq3oQPj067198XfnCDmb9ivsCu6vDNN9Y5wUO+Q3k53ig1DxlGYBQHuCdIyVaXPPazPZQJpmbzH4UeIrxMCx4MyY9MjgNZw23rW6TMWVuaz9z4mbh1uMkwMG6YAA+uAtoES5qdUofClVRJsI3wTd1Es5DL7c/O+mEBl2vkK7EiTtTHHiD4IfPtWtCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aw/ipk7fOxjeQzfvkENY4hDp1PCUKA/YQhG8BRbTms=;
 b=DKTWZbvFi9g9sO24hPxyBaBcsbuQfwaCY4hNFXcywFmsb8bbDSOM3gitBgvv8qxCsz306BJfT79eseekrqLqUF18bGpHfL8MDfpqemW9RM30PQTtydLtHYFatnOwG6DVZYsrQNeeQwkTrpMypxAQXDYc4lsUrrRKe89yBsL4H60=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN6PR10MB7492.namprd10.prod.outlook.com (2603:10b6:208:471::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 02:41:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 02:41:44 +0000
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nmusini@cisco.com,
        fourier.thomas@gmail.com
Subject: Re: [PATCH] snic: MAINTAINERS: Update snic maintainers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260217204658.5465-1-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Tue, 17 Feb 2026 12:46:58 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ms16db8h.fsf@ca-mkp.ca.oracle.com>
References: <20260217204658.5465-1-kartilak@cisco.com>
Date: Tue, 17 Feb 2026 21:41:40 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0322.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN6PR10MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: eef4cf25-8b1c-47f7-de06-08de6e9740ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vfamHyrmNgh/rsgLL18I1OONdT8wt1eXq/wtw7nx0SK/wKKUYuctCMG9kqZs?=
 =?us-ascii?Q?9EKhsaoCO3CtvDaf/TekRwdFCx1/fRp0fU5z+Fr0WT8wokeOf+sr50RRTRtc?=
 =?us-ascii?Q?FDYNvNh3YN4yHcp8ji6ruxfjon3BkwN1vwiKI9h/QDk9lKjUiJ4B730pTPmQ?=
 =?us-ascii?Q?L+eUoSZ8ZoB9KcoMwGSRwftPmZ+vmS6nQ4rho8YXEt0GlDBDqg4j3AR1E+nE?=
 =?us-ascii?Q?fmzyY7dF+i9G0SgtQNxGF3yFmC9vs/A32CPvGQBUCFOp6UWxdFz0l6TBBqfX?=
 =?us-ascii?Q?fXQtC9qDYrEGgCd7PES9vuNGf/chnGeSojI1dPfAMr/1V0RkFf0zU0CC8M+k?=
 =?us-ascii?Q?pIPhHVTJ5Is0HluO461RVd7iHXYfyrGYMq39KXWvndrWF2HRJUvUhS/p/lZ6?=
 =?us-ascii?Q?1IOKwHfLye0fczAnVwcCGU888Uv+B7EeY5MQ6JEVn1tDLsl0cgKklPloT2pw?=
 =?us-ascii?Q?0WCXfkX8YtYx1O6fuYJhCiCFiaKGtAzj8kdKi97Q8xfKw3n5/woAw2tF/IK2?=
 =?us-ascii?Q?K128xP2L1+laJUfhOUEEYRitVG0fF4EoSPR4RBdh+gp5LxNSGJL0BonXPygp?=
 =?us-ascii?Q?Kyi7rLUhTp3Ug8mlURmV0jXVaczly6gZIFx4/1H1NvwTK6ZPszV91iJ8w5fX?=
 =?us-ascii?Q?wtIY5A5ayhZyObN5Yb5sJN3FBhsBObaaIxXQM1fcRAaF4llW9w80VoW+UbCL?=
 =?us-ascii?Q?jbTmlyIJB4l4nGP0M73rvMkuHgWL1aISyzZCR7JX177uGvffnDcdmmHDeWjG?=
 =?us-ascii?Q?/EMau1EXr8zypOIYMd2bfFYFCB2/KuXCbz8ro7Sf0VEv/oN4/tWfslurcOGR?=
 =?us-ascii?Q?W3Lh+88lWcJS9UNPdzf6nBWTr2Cw69quyPpCaZp6vChSa6DuThqDMAN98XIt?=
 =?us-ascii?Q?mf4mwxJXaSTcyUU5sYPq+WenT7edRt/IOR0wkj99cyiq4w3kf5O5FKWge2bH?=
 =?us-ascii?Q?94fFCfdLh/oSpW5OF4kmwM8dbwZdqLnDC+wInQhI40mCeoA1MgNr69yE+o5D?=
 =?us-ascii?Q?3HF03pl6Z32/fQ4IqdUbaivH0lZdvrKtWS11jUqlA4X0/sSir6S60MY7vFzX?=
 =?us-ascii?Q?lTtKFWfueJT3oXA+Z+ksF/wPVBnIGQdBMPhTKu5uDJLRX/4uL1RWFGCCDEon?=
 =?us-ascii?Q?/Q5ap3Nqcy62RAf+yWgzsDKRo7QFM+as2bFJeqPg9gRxEg9/EKJRtbnUcbHE?=
 =?us-ascii?Q?ln+7B11B5bf1ZMXwTpRXQd5U0uxda+zyGA5CpkhM0fUOV9WjdGYg6V3AWn2j?=
 =?us-ascii?Q?aYn2FodqhrZSTjwPXirrSEQA0+O2tc5Ty+kgZWWLdy95LNkOA8bSIkRv+OiL?=
 =?us-ascii?Q?sPpz4U9MlD7p9hAblJSpSYp1pkSRaEsJDk2PrqYr3ARtDEj7pHWUae+LykMR?=
 =?us-ascii?Q?V+0QVslX6SotDsThRTGo66p0kY5WtXdDjpfiGAmYlfjomiXw83lvldAheHWK?=
 =?us-ascii?Q?YpVyWTB84bzYJScsKsLvPAQFrQu+ghvRtKC0h5hqpY2xV1oLdnXZN0oAu4xb?=
 =?us-ascii?Q?7L3MSaTausUas9K4IEizef+Gm/UOJq8YZUEBPuyOYE/JlnEr2aVNQgF0hcQ2?=
 =?us-ascii?Q?I11u4icCWiAB+FaN9VE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g7hv6Ac8RuOBA2kWPQ7pXGRoyXl/c4nWARZZfFewjkhJiLW5Awa/XcAz9yeS?=
 =?us-ascii?Q?FnNKt+ifZtK4Ok3Ckv/BGK2vCqZYd9wYx6vkLv6pY+cYnMvSp33pMzHZCqmQ?=
 =?us-ascii?Q?AsD/tyc+4qQ8531SnVSzoVFOym4KINEfXR3/MdTrWsfZIYw3JpeiTjkFlk7H?=
 =?us-ascii?Q?Ii+VCPRaLHnkh6yDoXzd84v2qj5hCT2vRPtkjW4mLS+oqNV1ftg99E6NnSsP?=
 =?us-ascii?Q?Rjq89SDjJquOQkTtshU2bbAx6IducmLkFWDXzWyqhcBUt+i709SQfC85mjFU?=
 =?us-ascii?Q?7wfP5pvRTFjtqpI8G+8FdH/g+G1IdBzNG9fM0WTcb5G8342/66PWpJb3N7OI?=
 =?us-ascii?Q?SUM7rNCxmKSQDsRdYGpPTrataRbmbOI6kxTqVTZpBt8SmVHxZtBqkpycT86c?=
 =?us-ascii?Q?TfOZWheMvnxsFU6ePqgyXg08B/RATK17reYPV5+i3r7Vu3tx+dzXKbPGyeVU?=
 =?us-ascii?Q?aprS52yQnENH2bFT7ZufXVZIHcXFcVVyjp5AbDRy7PGlpuEJKiOo6D0AS539?=
 =?us-ascii?Q?pK9dhCtYSog+gSfbQ/Pfrfl3NgIyPxNg3b+++gkA52muClsTdG+k/LWgWc1o?=
 =?us-ascii?Q?hyD13a51QJKVRNcqlEzwbywm0MkAK9DzYMB7SgTAogmoVBoM84UFymKpL4oC?=
 =?us-ascii?Q?ym7/Bb+G0k6FopE8e1kMqVKq3yuD0D5BioZ+VurEw1I9LbpHP1Uktn88mFxX?=
 =?us-ascii?Q?gwN+I11H8vS9/BSSUGjnk5ORZrF8SWw+yjs/DDprN/lFyomTgDWafp3IaU8+?=
 =?us-ascii?Q?/xGWzdyS4wIEDG7ZSvSnjKFAhrG6q9lpndv5WV/7OkwobY2UPEk0LH53lycq?=
 =?us-ascii?Q?DZ6XI2O5feAT/r8Pge161SW8jIGXJyDnT+RNzCO/e2sXvmUy46w3YNmpV5l8?=
 =?us-ascii?Q?7d+IY+mvm9VCQs8CpQ5dhh1ZDPB6dWyMv+8kpVjmxDKiq6uc+/khAGmbQ8kC?=
 =?us-ascii?Q?h/wHaF5fj1lqKB/nY2zvU6eEiPpNxffIonCbcr2r/I7MoHW0NIXLW0zfRZHz?=
 =?us-ascii?Q?xb6DooiNsBfpGoqQxFeulk7R/vaT14Xpy//v03DHIPYHRpNGozq/jKfySZLM?=
 =?us-ascii?Q?PkirV7JNYcDs1mpzDowk7Ysu6p+qC6oOUKY/OxutRsf8rr5/HvS1tvqDUrgP?=
 =?us-ascii?Q?79F+PxGBgJAWOTwG30o1zkAcvcX7XVa4tWNkdItAc+tf1UaIXDlkmvrXfdJR?=
 =?us-ascii?Q?V+FsyVS8Hf2xsCtE0HUZXjwrttwO69XDEwK2V7VPgzy16G1DhRGwnMBXOFIG?=
 =?us-ascii?Q?jXrTFU1CkZ8wICRCqo2qYNc9LNGB8xHla1+Ci0+/1kb43O3pld/azQmY/kRU?=
 =?us-ascii?Q?PNK0Y33ai+293OliSSFVuL5LYaJRtI9neO66Z69WPpsiYjiYDL5WdxQa9opx?=
 =?us-ascii?Q?g7whYGhpIeLtN6c1D+Rr6pDxTZdh4y5/ePwW9fD4O5diHjchdrXpGfxMuaVG?=
 =?us-ascii?Q?qHZkpxyWrvgq7GHXPyZO8AfPRWkNr/F0OZaDuH2Cki/FlTBWhtT5TH8sQNkJ?=
 =?us-ascii?Q?cdzwc64hXgNRgOFBCZrzE2hDFK4X0LBCQW5EfFmsl1CyJzpLhyfTxUzoLYYH?=
 =?us-ascii?Q?wM7KOlYVNz4bmCwOhKKnvoXkH0A6RuENXGyDRJ7DXgSd+sn5ppci477V99rD?=
 =?us-ascii?Q?zyVaNl1kCdrh8PDDw6ArBqHLpFCg/WsnEiPUKaMgOzbjBYo0/y9yJoUzXHBE?=
 =?us-ascii?Q?7OFrF7E2AZp09IGjRUw/tqfkyODFMGzVwPm9l3UATeEQtXTj31UwTiEOkDgK?=
 =?us-ascii?Q?kdaVCQ1gu3rop1suX+B3mUOzGy2Vb+8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QUcpW5wL1OjqReaU96RGu6IruNGKIciWCUsuu3vPw5JIwNrxAt7GV2no5nVfVYrxq2hBjRTvkyUxjl/qtXdtmX68gDK9blBqtW7XGQh95itrvMU2RxKzUHggsODFVoxoedOMx0Zqvlgz6hCXwLG2okoVPRcRb1Q9Dvm2+yirkaXuu5HnfwjIduQQp2HEtBWGURDjUk5kq8ajmo+cWvErkUG3Pg7lRHK65BkaBKymNagwCTTf3egWqmajbFxtzPuY1nzmq2ai6NY19uvSw8e7JUIOnUNvIbTFABNAeHMxjJlUPxZs1ewRfGbwpAhukY7M8UFwWbwIZSKZdiXSl8p5SAHJGhiMZWbyRSOnugvVDLeTi23lJ3ZdlM1lYJOHVove5ti1GrUukcLPozPI9I48NvEmZOEqvQwRSw7GL2AhmOAmRD6fBPDfIuEziJ5KFmNto24ruPx8QxFnZUKEchmbqBb02CGrSVLRekaa23h1IuEpjkvzCBLNqoHEhYEepSKvXJLMB8ZThu/TtZX3y50QA/kCSdwv0E8937QdKL4pbhh/8UsLuBulYBbfpiZBYI+Ljp+iUTYDScO5QwLs43U6nybHBh1+AqaoKACEWFmMrw0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef4cf25-8b1c-47f7-de06-08de6e9740ee
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 02:41:44.3428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJCGR8d+oEGr0H9KKX9yAjuEl2BudpNcNKndMWQHZfPP/bBkSUhUCzcwBeQ3tDscQ4kblakEWFgtDG8Lpp1x2LrOyzDg4xAi7rhA2l1Dfi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxlogscore=653 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180021
X-Authority-Analysis: v=2.4 cv=V6RwEOni c=1 sm=1 tr=0 ts=699526ec b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=EPAAsEYDAsF4OvMgnhIA:9 cc=ntf awl=host:12254
X-Proofpoint-ORIG-GUID: 87TdHEtIkdDTXASRQj1gxa91n_JJBVDm
X-Proofpoint-GUID: 87TdHEtIkdDTXASRQj1gxa91n_JJBVDm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDAyMSBTYWx0ZWRfX/CWyXe4Ht7ct
 ZelfrWGNje9V1wgQWHuq9PM0OwzP7QPuR/ve97SW/2aW9xb2zUHdh6lr6Z5D2WmwQCmYtKfTwaD
 VSIk2Nw+/n94+NfE/COljLOnvqdw3whXArsnRWwFzLFeO6LldqYLwiXE3j/ssrUlZ2Qo4nhfQJs
 xQEHzKWEpSABWK8rtdHc2RJTVChxBW5klJNfePnE2++iQDaSmKaTMtJSkogSdOGAYzRtbGdyYfq
 vYE20PkgfxJIOsJC6yeAwqem553NWOA5S9IIEptJJN+/IQgfd6CC9z3U4fMeBui693jRQh0bgel
 OguEER54NyhVKWur3ua5wq5rQpmy+NvqGkWyRVURhLJpTi93nJW/JoaZLZVDhx27V0mtn08GoL3
 A/+N7wruAXUQvJC73yBbyTeGPcl2ZbPYNC6ommVkGVWqHhm0BneNcNoZlI46tjlQktTy54hgKnl
 oKJbhr2bcoywstvCNkt5gfsClJaJehBxCB2hGYYc=


Karan,

> Update snic maintainers.

Applied to 7.0/scsi-staging, thanks!

-- 
Martin K. Petersen
