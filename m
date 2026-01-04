Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A002221710;
	Sun,  4 Jan 2026 20:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767559619; cv=fail; b=vEEcSfZYg9rofM6ge6/bgF7K6Qi6WlKPWdG7a3ymYkCK63ef8njiRsATZ64Be5vatEPq7cskiDctOAOmu++im8wtsk7A5oAqjBrXydGECPeDukttvPLQLpgtUvDlkCGmVyx83bGOx4GuuFUf/dcOIgBF+IaxkbEBh6ZhMgija54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767559619; c=relaxed/simple;
	bh=hlV1lFfAidwDs2QYdKFlY7WHsx9smUuhRmIVVBv7g5U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hZOxLs2bgGBWEYQUxuLcqGxWy+nBfJJBgA7J0w8UuOMUhUCILHNJ6VAz/X0Nky+h5ILj7sz0cFKGxtBiPj+rbnW+pxafvbKJXFDMw1NDbtlJVpaYIGlZNcOhMCZBKb297k+zDqTS/zDfTKH6SlxrYW9XpH5L7jX4JeUos2jXMiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QURX9/bn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yZIaYlOB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QURX9/bn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yZIaYlOB"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604KYDWo4099312;
	Sun, 4 Jan 2026 20:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1XgQi0nyT+vMh4C3Zx
	9dVSWXZZ/8Ld4RZeOpe1LeWmI=; b=QURX9/bnHViC3TnVD5DVq7W6S/pybxfDr1
	sqmzCrr8VF9KrHS1+gN6ILCPXpukgq2gVvmYmnSpB5157rWe4RgvtLoFgFS8wvPB
	QnEWKWLPdDu6qrjUFvtBicsOopl+a9vpsTeYdvTKW56bSy0r/ggCFoIdqy3+sXAf
	Mr1Mz3LCEjcGLc9n4ZhXEjKG+gPnOVHpUdLfNn7Jq44J5aSzOYDIT028plM0F3Zh
	GF8Uuqrzxb/5WrrQmlwUKjMRxSSABEg9bp9NMRf2CLXDcgrEvUFNtb/an9QsgN7+
	HjDaXTNgxAZaiCuP0IAc4btILo8mn+X7ogso9r+GPdJWmXkZ6Zxw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev6ngxcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 20:46:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GLKkd026309;
	Sun, 4 Jan 2026 20:46:55 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011022.outbound.protection.outlook.com [52.101.62.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjgyv36-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 20:46:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEZqso5FFB/5YAXh+2U9B4l5kRk9lRf0nfPjJFC8zodBsy157SZaZKoXdNxPNqhzAadl6brzlfFXX3X24WeqlMEUUBCCN24EH618rEoKn+Id/XAGV2iGSdF3X972xuJMG8n78ou27NGVS/mS/Dtw6tS5oLeDSY2iGMY4EI7sMsot9Ifvd2Jeeyq5JRGN3BAHf1x8yrlpie1Gej//EDnGdxPZf6uD40M+TX8P/pgTCdUYwndX0AcNYkBGzccxf7FkwjADHE5pvd0idnbbDiF7tqIa2M3cPNxyAoKn9YpUz6U3wnDfH31Ta+vPHS6Ti51gp8WG1DDlFk/5V8V9jWKAMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XgQi0nyT+vMh4C3Zx9dVSWXZZ/8Ld4RZeOpe1LeWmI=;
 b=o7LaNTS624Y3uwMF/WvpbxA/u6IByOQDNZTvGRM8dPCqSl2EgbdBvnDTeAIOnSZoLo6sp65cZmnMjE39JnulGhGecrXAATCgbWo+Cs92Ti5NjzZUiwNCpsjwihg4a/aZtop5SjZqPMQOUTvsR77h8NBx3j/eas+9fyLi83uDXrkRxiZ7XK7PSiuYQSsY1XHw909vMrnlhhwdYUrema/24BAK3d0HtaDOGzHE9hpevHTD7L7QvWnjh6bcRz1hN/3hKLmQ9AFrAzRdgoW7/t1vHTfeW8eHXwAsQ9neukHFdBtBY4lE7GGMHr0CuAb8lT5rOhdEeyGTu7QRznQGALwOhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XgQi0nyT+vMh4C3Zx9dVSWXZZ/8Ld4RZeOpe1LeWmI=;
 b=yZIaYlOB7ahwXSfPIrMcpGzRWVHsAZLNwGvIZOQv3JaMWfRgf49lZwm5BW+IERWYkJnmU7N38gnkF/5II5H6SD6OaOcLSNb2jpgsuFHqm5qBPz+Cb+Qaj0Hb4VBA5C8oJqjLMMUM4nN3GIS7N75FgTDJsd4ynh46Pue5z2L9f+0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PPFC3D93F6EF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c49) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Sun, 4 Jan
 2026 20:46:52 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.9478.004; Sun, 4 Jan 2026
 20:46:52 +0000
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: target: Constify struct
 configfs_item_operations and configfs_group_operations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <a0f25237ae86b8c4dd7a3876c4ed2dc3de200173.1767008082.git.christophe.jaillet@wanadoo.fr>
	(Christophe JAILLET's message of "Mon, 29 Dec 2025 12:35:01 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldidt8bp.fsf@ca-mkp.ca.oracle.com>
References: <a0f25237ae86b8c4dd7a3876c4ed2dc3de200173.1767008082.git.christophe.jaillet@wanadoo.fr>
Date: Sun, 04 Jan 2026 15:46:50 -0500
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
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PPFC3D93F6EF:EE_
X-MS-Office365-Filtering-Correlation-Id: 309be503-0301-4051-5c04-08de4bd263e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/vu32htsZkdSwHKGW4o1XFE2a698Lu4nd+se2/CIdXSypU4B0XpjtmPd/HB3?=
 =?us-ascii?Q?o7HOr2p/OybNqG5UaXddFR+FNIrV/9oNICal+bKpumh0DgSQt+vkVmJOGPXh?=
 =?us-ascii?Q?iumRyrox+xA8qsjpdGsd6YS69aPz9x5dEZosQMOKfoLvXbdkKZoFBNCoKPR9?=
 =?us-ascii?Q?dKOHQuxF2q73BwGhbfJ5MNiOYjI+0WrAln0G//mKWCf/wwu8oL7I8TcFJlsA?=
 =?us-ascii?Q?oh1KR7/ljVrH56xeV/fdsCyrmh9Rq0ujWEqI0dqVVMva2LQ+4SQ6jjlgVxsF?=
 =?us-ascii?Q?LrYndOMRwjiIf7g42wnUqVpLm+aUDhrBdaqvUDD8GPKBWcgIucRgAKN+EtVU?=
 =?us-ascii?Q?Lx3H0RZr3gQzahuti1H6K1rCT2jo8Cg/GdwkOyRIMKsobGd+4OrdXSh7R3aW?=
 =?us-ascii?Q?EJRuMH/uxdCha3aYRMbX+T/aGJNX46iingoh83dehWrLEHZmDvF2PG5xLdSh?=
 =?us-ascii?Q?3kIrWVsHpoZArRbF0Br+Uxbjb7gZ1ti1Fq+jCsuU/izgZzwQ9IbidE1rkUXp?=
 =?us-ascii?Q?o/n+Z8msI168sbSIbHE//I3xKT0/JbYR44uyAkb7vVKcS0JD0+62VDMwBr2b?=
 =?us-ascii?Q?lHRrsMIFa+/Fr9j5WX3nhFnJQGXwEWelIHxb2dlsTbiMlgiRWyziIUrFVEKe?=
 =?us-ascii?Q?AT0yZy+y4bLM9utpyL3P0m7urJ7yHPfd/ojLAGqcykI9yZqCY/9MKogzGFfx?=
 =?us-ascii?Q?JEzOm3MrISMswfV8ItK0XNp4+oRn4+wl1l0rR3B+6KGN116dUAyq21IR3AFm?=
 =?us-ascii?Q?/JpwT0/5aScWiGIwO1U/yqfX1IOUKx+GXD9knlfszzvXY9JptlPkQzATo2RH?=
 =?us-ascii?Q?YfyZUihR538aS9G042BBX38VXPZJMgdKb3w/Vriy0X+8I01WjYpRpRfl1v7O?=
 =?us-ascii?Q?uywfqVdTIgfpxMIhoU4SOzd5aYpUHy30G5tu8syqln69l+ETZeSk/xnlx2sC?=
 =?us-ascii?Q?xOaun+AzWDCOQICgLKX77oPdabgpdqjnfrM52fymB11Z5Yw1tSip2D6QfYBX?=
 =?us-ascii?Q?eTA1krs3wCgWAkyKidgDHMDLlwqHL3RRqIOkHk4TBVjkq7JMSIcIegY7UOHJ?=
 =?us-ascii?Q?Eh02Rysp0G3XDaZsEY8o4azyb7Dnap/mm2iwDt0Em6CIN4Q818lRmS6MFNDr?=
 =?us-ascii?Q?IAGozYfgiQUpGJ8kz//be0dAO1vlW3Bp8Sm5ao9ZXXzOmo+VTXoHzN/qB3hF?=
 =?us-ascii?Q?DH47ucx8iFkJZc4I56FFO9GqpNPNoxGewNisd9UGUk/gjwKgc6kTYbJjrLJA?=
 =?us-ascii?Q?C6X1HsdVyjXLCargBz4dqB+Ij71dgWJ2/sD1v49OtMWy82kdTyDdBuopNrVn?=
 =?us-ascii?Q?jnLMXA+hYSeeGfD7p0irc6tbCpKeMshkqha6OmZegBXaR84C5lKBYAD3OCBK?=
 =?us-ascii?Q?f5Rpx/Eq6QhXwsgoOh0nnl3BHI0w+/lcS58bLXOXaKC4uu/2lyKEJ4l3aD/I?=
 =?us-ascii?Q?JwrBG8uwfebNVAA1IFxW8jDc4YMhMsQz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hdbeKKHD6mBRwlhZda7uqTfoxcmKPtrdp2XWJvXiEsdYTNb2bCNhY+Q2NHiT?=
 =?us-ascii?Q?5s3nxT7gd/mXkbWgg6kiUMu3SIV/GJ8V/+LAOf04mjaiyj0nN5rpN+nhT3Bq?=
 =?us-ascii?Q?g22YSwCaABwc9FkZ1r3ZMUMAd5Lxv9ke3mZsZcUf4e1HkkqduoiFzXssPNaV?=
 =?us-ascii?Q?dNPJFNZttAd0pha46bjicHZJyFFfJbeI4ti1AVQNVXvyM75ID07aC7udxIMq?=
 =?us-ascii?Q?c/fni/zV5+2uRxgLECZMHrvptmr85EU0BhT7+oXQZf6GRYuh8cMVv1MdaJCZ?=
 =?us-ascii?Q?SHlrwsPpnKR0wR9JCwukE3Kjo8YLGtX6WbDTOOZDzASd/binfzYeDhopQ8yG?=
 =?us-ascii?Q?/Raw2wQX2asglfaMd3/9RTmyqESLh/lKy7hljkG27KHQ9p8EyEDkP7sjhxuF?=
 =?us-ascii?Q?z435hOwejLjM3TGYsCatbrm5H33J3te7zL7VnQTLhagvU4ykXM6KTKUUL/GB?=
 =?us-ascii?Q?EsOW1LUuewGq7BAGwwNKftAdXbFMhsNh2GfM47ZjG8jCzzgV2dvdFELcEjVk?=
 =?us-ascii?Q?afYAEbNMdDIWwrUsxCwnL15fWucSTcFs7It1BHf68iofyZnKQzz3A6zZAiZY?=
 =?us-ascii?Q?wugBPyjyf+ztQFlI7UFkaEkfA7LBxgjWpD4s73QJU5dwM1D2d01PbqdJRuWx?=
 =?us-ascii?Q?iN7oh2xgSnfm9UPaG3nDCi91V3vL8Tzf0sEuYkHdVZ1NCe7FBJp/RKBA50Pj?=
 =?us-ascii?Q?/CpzfzC4YKLXQVigoEoR1YfL2zZH5oKOia+8u2Wz/M72hrhP1SmaJqubf1pH?=
 =?us-ascii?Q?RoXZPU6I2y+wWhEfVfRj5Xqtz/A3VTjNY5eGLLZ5A9Sn2cTXgXfNOKptckLJ?=
 =?us-ascii?Q?X67kmpPAEoa7dBD/QV8okGBFYxsoitNYcFHdmuL1aUfNF+x+yP0ZQs/t8Gbz?=
 =?us-ascii?Q?UJlW7icAX9r12DDelebGazIMTdiVCNgQ1Fx2Yx8wSTWSUxekQjoyfH9EfjJx?=
 =?us-ascii?Q?JDd8m65mexoWR5LLDkEVKBKsW4MYRpuBcOY4+CJgMmKrMSDZFvgr7F+0SU0f?=
 =?us-ascii?Q?FIW95HKg2CC6XhEThPQ2/thst5Qfw/YmkeeAQ2OJskt+izE8KsiLORqP/KBr?=
 =?us-ascii?Q?CGcXEXKtVSgfLcVR2dv9mz8xda1yBMQvCQlFOhMCKCiGz2edoXyuJhSMhsCG?=
 =?us-ascii?Q?RGtp2WwWTMuuTtTl7GmgkS8sUqf/NyyFn8VuSsHlvDF+e8IVikL1uZ7eW0d1?=
 =?us-ascii?Q?dG6jW18drhiiYbEPZv1g7ELW0xtrlamwljuCt420ntR+iso8Y4W/Uq86pslm?=
 =?us-ascii?Q?PoDGN4Rn7+4eaSMO3NqACM79On5pALHJe0xYHssTxJHOBo7rKKqyNbNGmial?=
 =?us-ascii?Q?090egJ2+xCVj2GbSYhpWB4mtKIHW6Ofr+EtOB+AeuXc4rdyfMkRWtXisFwx9?=
 =?us-ascii?Q?jXp7IcZe5QJGyNj2G5VTewsAowvovRYKqECfFEk8LpOUOQg3/nAgmj6WvVlv?=
 =?us-ascii?Q?de3Gv7JI3Njhm2Yl3m1tQE8a6m+JaLDVhfyzEuQHFe1g5ZYVkSFCKaQiVqCH?=
 =?us-ascii?Q?bvwnkseYtgF+W+bapJwOJSP9d8g9+LPDgHNKgCnPctDitQwYlZCrFCsy+KS2?=
 =?us-ascii?Q?IW6UwJz7cTAws+ooY27yaImw6HQCBQJ69C4KoicX5lwPeTB1fKAVlRJFCZ+6?=
 =?us-ascii?Q?4cJqmOaCIBjG12klsH9fShZhYFPSR7xDpMVLY6DqATUb6yhX6zrh+CK4e4iS?=
 =?us-ascii?Q?IG5WKiIzXtX0laNlLuzDNRvBvtUQguCp874apl4jBSUQQNYYDnTXp6031lae?=
 =?us-ascii?Q?z8QwV4/QCu9JlPx2kloFTX0860cKrjE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ShCkqYQWa9hS9wK+Y3Wnza81OYxHnRDQF+F4SslUo8FUSZhjNtOyArIV7PheXF4dNMbMIBaNb/iwxdRasEYJmTH/2sk93xlZ440t05/8LuqLdocpOZpMEjaY/BJgJGntt0uKjD1rZZWjGR7huqruuCmJ8PbfOZ1yQeFQTgEUImXL3RfQhfBsEUn8xMRoNbNhkJpPH03s/5fouDfm14AB9kUitgtefjb/spQtWQkZxFK69NdIx+fiJmFSHd4wM/cOHSya2ubP6LqjSSXnlQFvVyjy5Ra7eU68OfVu9qfSlKJmh41qqAOfgHcljrrhLQLyhXLbF22TftNtz4HW61aES2rcTbJY1mMDE54WQPmsn8EjKYzkGzlXr+E6LV6wTiYX2evWWVY5D8QOa98S4DkhgTw3e4BxwQ8TpeHLgDm4JhNa9+KsRMfGrlLVNs4Z/+ExVUhI4CxLlL5Fa7atdfJljLJjCoyD/MVgTOR2+omgtfNJkEHZyblp17pwl6dXNMXAsuUwhxmaa69ePoOwkOIrWE6gtsa917v6Nn6wop7/F5EEi24kx6lMoiAh0LCcp0o8s+fghj3poE4JT478ZEUUmoOaKxCO+JcFLbKKv7HMJjo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 309be503-0301-4051-5c04-08de4bd263e6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2026 20:46:52.5323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7znyVUgC/oArhtObnaMgMR5khpEWLu/4Hic3L2IfQ1ZSXymc6keFASrT7oJTgQMUtyfeLXOd5x2KaeuEB39jwBvtfD1IxFXSGUZskkPKxQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC3D93F6EF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040191
X-Proofpoint-ORIG-GUID: PHUJpiW_AUVPBq6syot4_aJoi03gG2Fu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDE5MSBTYWx0ZWRfX9vSAcMt40xib
 J4sa0KHaPKyx7rjrCpScZVC38b9lSOcU/MZjrO4gEwibL8fquNlJBHvw0eazOwH5xU3B7SAhEC6
 57eE7r3JhaOuNka3Jo7lirB4z2sJcKUpPJVrdwOwoKMmrG6Ekjhu2bLBT/sg467gUbfEVd8EUKe
 boU/Rnk72kENTlKw8hlTkIVME51t+u1E65fbikOordZTKu1RTfXvus/Cb9AZJFnryoV83SRNfXU
 8CYgEB8n24Bm+2iLutRICYjzsc3yyf1H2ePZuRSstWaXmOpSJpFm/IdacWSVpYuMe2Jb4ScLk+h
 HJwH++Av284HccG9ELJmUsZzvnwpNNXRRrVD1BANvz1CIq2sCv7BsNWRAJbf500WxoXEIprKChF
 hzu8eZWzySy4coPqptLf6dLlFvHqcqqD528UOStGGFcNcg+mS4q+gC5uYY3/ODKreElh+Zc8gD2
 Gp6hRuyjskFSUX8iux3pNykwOvUYSTTMwrCwXQYA=
X-Proofpoint-GUID: PHUJpiW_AUVPBq6syot4_aJoi03gG2Fu
X-Authority-Analysis: v=2.4 cv=QtFTHFyd c=1 sm=1 tr=0 ts=695ad1c0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9 cc=ntf
 awl=host:12110


Christophe,

> 'struct configfs_item_operations' and 'configfs_group_operations' are
> not modified in this driver.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
