Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80A32EBBAD;
	Mon,  8 Sep 2025 23:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757373016; cv=fail; b=LSnORIeJZjJQV1YuIBWM8pUgBP5pLYn4UBKFryRvJnwOafPD6uKSbKVyBv1tHRfd3D4FHDIWdnnx6P8oz2Ob+imzv8+Hj4ngJ65uTt/ZiOunFkabyR07igUHethtVbqT5QEVG0malxNxgMCmnpcQN2Avu3wHmYqfkveEFWMRvFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757373016; c=relaxed/simple;
	bh=YAy6CrUz3umuJXCxVr4/duYxYMuXdwwPghlsqEu5oQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s2U1xDgIEibMlJBmxcXBttmXuwifVTVGj8Ck8NKxvzLypeS7beaw91Z+fX6Fb886Fve1qi8AW56MP6wqZPVTCE3BAU4zyahTlnyfRzSqdSG02YTbnwVqxRMKmRsJu8mVoUpCxElegsmuGzwP5naL2jeKCyrzwNfMYFV87UI4zVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bnffqgPX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eccTPx9U; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bnffqgPX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eccTPx9U"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LCI0K003185;
	Mon, 8 Sep 2025 23:10:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QmnmWrqf6PQAqzhF/9+bvXEkdY884jfsSae8eIFZPBw=; b=
	bnffqgPXiH1DtVp02tAnioUQOiuSj2Yt9ZBpjXbvy2NENk5nKhHFteS4C6u/BVf9
	q5TnX6De1PVLD0dbypT4Q1aOgns8WvAtAB8iOZIEEzqoQKJtpPqNywdtWyzFIOwm
	pGEcjQ4yz5bB8F25GpZXFIT7NqAvIGIdYf83vlOMqJcCI3Cxl9VH/i6nuxt84bL+
	BZtCWczt/3cG04XRXVl6iguYLLomdkR49QNQPqKl1GmwOJWPHiU9bGpAjb8YxJqy
	TDKnJ8cgreFHBTJdrDNO+BDkFeNMgp31xYj7pmE7GKg+Xp6cdUByAsCp1UK89Ce+
	IehDjsNck5h22PvbOYTjNw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922x90kn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 23:10:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588KcYtt030745;
	Mon, 8 Sep 2025 23:10:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8tbgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 23:10:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DfQ/qr7vYrH+DCjxqADkPRNmRDPyGvm6BaPcZoAD1ogX+6ze+initrZNgfRKMkV5V7vTCCa4M1MPTPuQwPvhu7JD4zg9hIfzYYgKd6xfJNCRSimK4Jbv5mbXnXlVju84wHzkmEREjz+b3UsUwf197sK1KmwR/5xFzEt6uXefLXMU+6ah17niL9fchQ9UjJiRowhEKwga03Ywo8Zj2a4Xmrm3DOmCg5UtYLWGyn5HgDD5b8svrJwOkmqtwsx3P9MWzLAgVPFjenqVxWgHMEIPc5QBOUm9/9Fxcds53/J1dITJtEVxhmNPDKIzdsEV9Ao+48Khjb50e9sHLW3QkZ2zEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmnmWrqf6PQAqzhF/9+bvXEkdY884jfsSae8eIFZPBw=;
 b=BLpbFrfWoBbyAFLmW/Xazh4EKKc6fvT/q4krBSmC5UAoSwo3YwQS5V7axigmggOKtnyawDwUDoOLyVWhwZ0DMzrem0Me5XVNcqjCF+jnMaVuIBj8QVF/RmzE+EsPE9sWEJolFpNdqyJ1xAK9s0fBO25pq1l6HXc312HccVlMYrXRAkJKcA/9FFhPCoRktJlaFGEG7JDyjbPQ9FTHJCZtlgc4/PGf9/Mys9sHxcvT4uY5k8Kx0bQ1m6hI4BZ0QlA9xD4MVDIlwtLsi/QJNZzn913rs7lV2o+N9s9sghEuIMEiN0+DGv29vMqS2i9+hiOaf1t2HEnXH6ZD/2K17fd98A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmnmWrqf6PQAqzhF/9+bvXEkdY884jfsSae8eIFZPBw=;
 b=eccTPx9U77V9ZhAf7iYazxZ4BrYE4pcd1sQ5YUTTYCr61yji/iqxE0+8/2pfwoqVMBVR5b3trMHw6+gcohvZw8Mk43fLKpDjJXpzRM8t3yrDDhQb5mdMIjjCZpu9k3FTZJMI32xmK25zhDtv7FPxDb0wfvQWPYI2spKNpVK75zU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB7437.namprd10.prod.outlook.com (2603:10b6:610:193::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 23:10:04 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 23:10:04 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/3] scsi: target: Fix lun/device R/W and total command stats
Date: Mon,  8 Sep 2025 18:05:54 -0500
Message-ID: <20250908231000.10777-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250908231000.10777-1-michael.christie@oracle.com>
References: <20250908231000.10777-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB7437:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c073691-53cc-473d-f77d-08ddef2cd834
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xCkRttejdBv90uWNRPYa5SkyjwbUdg5D6DLy7IIxx4/CSoTaOzfR7G0jHVPW?=
 =?us-ascii?Q?AkQ42Md47jG+BL2IA7JIHqqDAgQxKJ6tcshIBaWqPViLoXX1ctieN/BrlfVr?=
 =?us-ascii?Q?KU2RccxIE0f2RtUNhasM0Mb4VRbSBcb5fdo7aNFeEcXzHC3PgN1hrbIPN4B9?=
 =?us-ascii?Q?u7vz0WYqAmhJjVjnz+1ESQLDuLjZEkHmbb7X3V7hA1KGSkeW2/orzxb1+DZb?=
 =?us-ascii?Q?srJH17MkBDXYm/IUswWelQymWdwUJzFR6W8I6RtFlsmcnZGT4AVYybDXIrHF?=
 =?us-ascii?Q?r8Sqc3E4iH6voKsDFyex/FpS2OiOZV/noNbUV3HzkKI2Zlinvss0/5YyaAlL?=
 =?us-ascii?Q?OMjrSsmG0wJRA1FH6GiJ2KH9OzQox7BYxLe5NyylTOVOCFetvGVCXZPfeznU?=
 =?us-ascii?Q?5aM3sQKnXrsW3Tf49aNlbL0VrSQvESQZNTF4gskMHPa/eo88bcP2HF8/Z2cr?=
 =?us-ascii?Q?r8UWlEgzs5s0H74qLwtvKFkxL/yVfQHgrZgbbiCHKAZemhXxu83sF4ljFGHZ?=
 =?us-ascii?Q?g45Nbex6xQVuiJsAmh9fvzL5ZZqXG5blq/8OSR9kuJGjGyYxTxH91f0bqMr6?=
 =?us-ascii?Q?5dofMVtujNltwG2nV6gectf9gRdvv26vWkloB5FuzUN2rzg8Xm02mbbOnqyJ?=
 =?us-ascii?Q?nKxcagDDphqEzunbPRuWHvwZBb5Aq84ED5+2loEPGJ9tjvl5rx+ZimBVPtb5?=
 =?us-ascii?Q?LhW2ahfX33yjSt3gspx00Yi8RE4Tn3vu4F/QdlJlbSt0jHyiVQJMgo10hzBJ?=
 =?us-ascii?Q?X9ecZW/QsXNs0aiXLYTmjnp4NhDerPFvliVHpxSCU6OoVufBsW5oHG1NPegu?=
 =?us-ascii?Q?7WnESSW5GdGEz6Lh0Wt/vBhLu8B4yUqNy8NzFjCXV3ZTkmCxmT9IBeK5kq6o?=
 =?us-ascii?Q?kqurWeXrkeKSb/WNLLwTdl/cEcxFylfI5uSeF8Cpz17f+s8N/OANqR1NIK6V?=
 =?us-ascii?Q?/KB2RvIymYd11+vPCmLTLyb/FMNMKp2KWng6O0sGEmM2YqR+Outa9HnAHvlJ?=
 =?us-ascii?Q?jWYxHRsrOgHHXx16tlMm3Yd0kTspt810jxMJNTNBZZd52ZsgytFgBlug7D0I?=
 =?us-ascii?Q?99Q5tvdNVy7TEY4iER4U1DOwxKaiw08Dderff8xD6RccSgvOhfJ1bM6wCyK5?=
 =?us-ascii?Q?hK+J5LOcX9A+8GkqmbyvzdIiQyKRDPbrm3fNJ+dwHjDq+En8uyfg9n7G9/Ek?=
 =?us-ascii?Q?omNsHBQjKrdN6Kk6GXr2vnPlIXU+4VpuhtS7ntuQoFha+KvTdgjyNcgLVU7J?=
 =?us-ascii?Q?oNiqa5lCN8rC2oCy7JEWBv+JWYCMddUlne08f8iWXmpEVs7NX1WGaA9ClYz0?=
 =?us-ascii?Q?c0v4FkmAtkf9DjYd5NszpbBoFtNvqhc6Q0wOgSeB/b4QwIuUdz20hkOBSlD9?=
 =?us-ascii?Q?epf7npCacs145tl22jJckDCj+iCgKsXsAsLtH0GjJB9a2qWFKou5LT6/AgKO?=
 =?us-ascii?Q?t2JVk2Ooxzw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DVWYyfGKQCnwTVOdSPcZ9m6HQv2d8MIMj8Nyd1EULNyHc5P6DR5b7cH7Md58?=
 =?us-ascii?Q?jxLTifAe5nANrJmTwYkGQRYTkKHqkqvNRw40v1tLmmOtDb8u4zWetrGU8frX?=
 =?us-ascii?Q?44dwutS3YiZyxd4KYN69h/0MEmBv2I8WSO1zYomrNCxFH3Dry9sQ9TUKEkgY?=
 =?us-ascii?Q?vGyETeSAegszgOi3BqNnWvZqnGsZbD5n9f98mMr6c4Mxdh+60X17j8sFKqA9?=
 =?us-ascii?Q?9WfTO2hd3MDeoLH+bAIvq5oqfVJ76FJfD1euKBMCD9SvnbXNJ6/Rpgc96Clq?=
 =?us-ascii?Q?/2YY9Qzn0xd3EeJkxXe60TRv25TTt7sBVgmgpaoVXTx0yq/BNxwLW75jvHGy?=
 =?us-ascii?Q?msJ++fomSq7VLkeVAF9nOqO25OVrMl6qsW1fPSL1Y38Jw5qwlD6DzZ2cUWga?=
 =?us-ascii?Q?gYKAXdbz461jyjov/8vyrjIolDXdb5fH0yrqYbB5PxNWA4v/7j9Tzxpm2hQX?=
 =?us-ascii?Q?rW60LqR9QvOA4FTPg3BzXLpho7JmMTsmxoC3qr65YI2bQmUWFCsQVJM4IsmW?=
 =?us-ascii?Q?sOxAjjqF/ySBGjc1/mbNL1lrno/vVmTvQL6/D3IP61ltlC7Ghbl0E7X1A9kz?=
 =?us-ascii?Q?2fAljtLE6fjfHFah+0avqru3TB9tfjsvaXhWO41cwBwHs2Wmd7xMwaC5uDeE?=
 =?us-ascii?Q?/GppDL2Vbpe1dGY/MafBFSkZHDd+YT/dFVkx/P/Zi5pkx3qoOgFyd7RyDVkI?=
 =?us-ascii?Q?To7J6oL1WumazbvqQUy3lRSRc3wH9Yi2KQxS5UqAxXm/Ly0Cnv53EYg3295r?=
 =?us-ascii?Q?C6Isn/q7KthPW7WDE0uEjuyLkB7FfrfmyhwWhXkh5VOcKHI30tX2u2SoKX8D?=
 =?us-ascii?Q?ahMWDqG79KqsvSHMmxvu91zfCHLqOVyb/j5UVWXhNUoxwT4DfKkBl+vztQw8?=
 =?us-ascii?Q?Oqi6HIoTqt36pB/OCShHQm5WWwZRon3kXenBHn0ZQGYLv0uxMiBh1s23/PKb?=
 =?us-ascii?Q?CoK6vYIQ+vzKy+QqW2oTySLx1Jnjd1aNh+cyEn13/J6MzvKfTveWonGNeATX?=
 =?us-ascii?Q?+mLRvJcjjzEjEcNjaBUuBZwOl6kFyaJCXwzOxmCZsQAMKtT4uhnUEIC9wxzC?=
 =?us-ascii?Q?G0v+Dq9w81UPNZ9y2XW8mwejr8ioJ8Y/nzeFAQNLmYYqzIwuMsmZfVoui+Sa?=
 =?us-ascii?Q?aQNzqm84wzcgStJul4K6/aP+UrEr8r3l1/UuHe0NO1WzHBXpont5A6fad3B/?=
 =?us-ascii?Q?mtDRmhfBRqnjeWtyNgCYF7patLQ2B+FUpxTAk+upJHt36GXBJFl+W+l7JoE2?=
 =?us-ascii?Q?lPspbQOqV2X5BEVdVIqY3Gh5+otFX/+RfpgCioqJXbwgWzxK8OYG+hGBIOqi?=
 =?us-ascii?Q?F8oTnVqqo5Nc0II5x7xC0otfj/RIJxIwtD8EJXtQ4QafuHGSToBa2Cyzud76?=
 =?us-ascii?Q?jK0tqWxZlYVdwDj44iZ8zWrZGzJf2UZ/xJqz7unjBZLVRnx6+i0bxLwpcLeN?=
 =?us-ascii?Q?iY2dvaiPhOw3UGxQdjR82zPGSpQp9pTxmAEYXohz0DpvqBqxLV/G0WuYjXpg?=
 =?us-ascii?Q?Gcia3dy19hAsaY2BoL5ZBR89iKFDb9p2LeILZ//nHEglPYqB2hDTHD+LeJTW?=
 =?us-ascii?Q?STLyJ4UvRF7AyRYfV0NuJigL+pbOfk6U/74pLsO7w7ontbg+7EJCg5T5CCyw?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UoixHx8BHfBS8nWqNaCfeEDnVlF3H5gX1PrSHNfayQy9Jlzm6/345Eb4bvP1AD4QfwYukAulG0PGSHVZdhunJob7N9eOCBeIM6OmQIyCaBYmbdtzE1PotD+vI5NWTkFs6qpOww6/JCkFWcnPkNydyOkFelLB4NdSkEb0zMWBV/iA8T6iZldolHFlATrYtW0d30yyvuJLplAy/Cu6xwBwap1wrV8N2Xyo3G+LuGjCTG2XonmpZdpBeKD0tb3BbItbuddU0HRRjidtY1iUg38bAbsnfRtZ0+JOcRePsLBhvqHPvuSW2W7+pqgt7lG1XAqUZtOVvqdwLgLZ8snyJoJv9umEO9SNmKBHBtv4BDOqu1KPF55+sBGSA19/4iF9V5RUmjrT6T+Zwr1OfzhPTxWxhnOOZi1YsYZLPZQsdI5BjEFmYTzokcfLhV5/qO0/ZI+DTcDRdQ3GeAQ009ACmv+J1q5lMlHTqImKYfsTEK+NT+j8tl1Ws+Ff03/wAk3jg+ZeHQkLiOJV/N0QSa+xWzoB+wdTeIe5o3JKRZZbCbj56wVyurNYfOE5CWjP0s42MsaTfCnczKPlvbneKE7HMozAtCitr+cshsBK+WyUCRCaNEU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c073691-53cc-473d-f77d-08ddef2cd834
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:10:04.3077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEoaLztviiUrYkZYhm042trXTFglpvGIT4sui0CsL1hR6++ebwQlt5RwOssfIcR79CvTEInuhqKzgdQm2g1knvCtJy+ZLMkiLl2fOKhtEOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7437
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509080228
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NiBTYWx0ZWRfX8DU3chdOEun2
 tpSCgcy7IceFdcQquIqiTWn+ik25uWGUmPHkeE+s9oZh3mUql6bc2XhouTkuOz+E36gJ7FvvFGd
 skAN281wUZt8ueztWUagBbRrLNcLB/T3PfUiTFOpu8WjQqW2bf/z5DvqBX+b0AP1MQlQyutQ+Aq
 7lx5EJUNHjnfcx5hU07t+hYqwKsTqcESTxRUZolYFBSRPuCyL1O8O1lWrNGFussI2nU0MKZW5vF
 FXl79eR2VWrroofR+nLzRWpFx4QWFqWkKO6U8CWh8YP0DcVAhyDhF9Px/ayq32hlLy4SYriTK4R
 4m9RP4/upFOvZCzq+eNHnXlMxbmHQ2wSF2XxvpmHU/2UTCh1eUakrZQU6w85YCvVd4Io1wqoBM0
 2ZD92Cgl
X-Proofpoint-GUID: pXiQrcXWA0xHJPxaNK2KOjtL7ZNSq_Ra
X-Proofpoint-ORIG-GUID: pXiQrcXWA0xHJPxaNK2KOjtL7ZNSq_Ra
X-Authority-Analysis: v=2.4 cv=LYY86ifi c=1 sm=1 tr=0 ts=68bf6250 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=3cnjVR_UEJ30e8tU16oA:9

In

commit 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")

I saw we sometimes use %u and also misread the spec. As a result I
thought all the stats were supposed to be 32 bit only. However, for
the majority of cases we support currently, the spec specifies u64 bit
stats. This patch converts the stats changed in the commit above to
u64.

Fixes: 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_stat.c | 24 ++++++++++++------------
 include/target/target_core_base.h | 12 ++++++------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 6bdf2d8bd694..4fdc307ea38b 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -282,7 +282,7 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 cmds = 0;
+	u64 cmds = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -290,7 +290,7 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 	}
 
 	/* scsiLuNumCommands */
-	return snprintf(page, PAGE_SIZE, "%u\n", cmds);
+	return snprintf(page, PAGE_SIZE, "%llu\n", cmds);
 }
 
 static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
@@ -299,7 +299,7 @@ static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -307,7 +307,7 @@ static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiLuReadMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
@@ -316,7 +316,7 @@ static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -324,7 +324,7 @@ static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiLuWrittenMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_resets_show(struct config_item *item, char *page)
@@ -1044,7 +1044,7 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 cmds = 0;
+	u64 cmds = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1059,7 +1059,7 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrOutCommands */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", cmds);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", cmds);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1073,7 +1073,7 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1088,7 +1088,7 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrReadMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1102,7 +1102,7 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1117,7 +1117,7 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrWrittenMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c4d9116904aa..27e1f9d5f0c6 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -671,9 +671,9 @@ struct se_lun_acl {
 };
 
 struct se_dev_entry_io_stats {
-	u32			total_cmds;
-	u32			read_bytes;
-	u32			write_bytes;
+	u64			total_cmds;
+	u64			read_bytes;
+	u64			write_bytes;
 };
 
 struct se_dev_entry {
@@ -806,9 +806,9 @@ struct se_device_queue {
 };
 
 struct se_dev_io_stats {
-	u32			total_cmds;
-	u32			read_bytes;
-	u32			write_bytes;
+	u64			total_cmds;
+	u64			read_bytes;
+	u64			write_bytes;
 };
 
 struct se_device {
-- 
2.43.0

