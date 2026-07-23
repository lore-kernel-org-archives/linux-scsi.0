Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DE437BE81;
	Thu, 23 Jul 2026 16:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825529; cv=fail; b=oxDFIlU1oSegRxGq70+ocRpenUZfV3B57fhz+wdcOzqe9tyOpIUHUnG5MeDVtpOLMB7kxlVVmAaxndqF3wwflbMM0qA983M0vZgLOshNXpk9S+YDZWxA50N7uZX2clAWC/rbk4CeglDVPE67DsmlBXEfFwl/dZY5ODZnp3QQ0LY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825529; c=relaxed/simple;
	bh=yOl56qNqR3PgHihcdJXBQbv9dlh1f7R79gb9bmjA1wA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NwmBEw0VUjcTC++yyrJ4Dg4DP9f1CdzCuqwYVUvY/xG6PdsaQ5SN/7ISiC7xbna3SiIY3P10qDpfQUNT5lAqWygHVq+viCwtnj3VqgAWk+yn+knqd8/BKJeKPveSBc21P4mfaaq3a3xxbmErw73bPmzffURNjpb5Y9ouskWMAYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E+8FqMWw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wWikiRNi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E+8FqMWw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wWikiRNi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NFvP8k1205987;
	Thu, 23 Jul 2026 16:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3m0xLh2DJDgDxzKjrUvo5/hn+QzfyJo/wOkCaqor94w=; b=
	E+8FqMWwI5VK53rTEOVwVLQH1hgNZDyvASSfOBmANwz6yrh4ViRKWO+vqHbAWUFh
	pdKkMb5P5vTSDjimKp0v/JZhHuZeH7aEuQFtp7vX3UeS1nRbW5qTe+Arenk9UQKd
	jUhVG6D12jr/a8ypJviARajOCZW+HN2gC5GaWCCYDNS3R+goPdQJwxud7gtUCak2
	2lw8KF0cGKBfQVh/XoMztYYcXx4HAH1DrdUg+BIubfmuHNpznunZNShFZkGVbIvM
	RvGWkMG3VR3jMLLulIziO6FPaTDZe/R7rNpLBP2metr7Rg/jUrgtQlLNKLWZOVjP
	MPhla+lIYLZ7os6oifLLcg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv77mg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 16:52:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NGm8I2027309;
	Thu, 23 Jul 2026 16:52:06 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011010.outbound.protection.outlook.com [40.107.208.10])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts1c9ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 16:52:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K4u1eCQdIj/XEvphsSVkHxMCzym0rg4bSCILTAUfC4dEtwSHe4fThwkUMsaVGXvs4/VkFqaGHddEKzot38saWqTjLy3aQ414Y0KceZkDbvZJzqOuARFck9NShEXdIeVIaFDcpX7cpMGZuPO2cmXF39UaWgeh3b54s6GEq5GlJ9Nj9IO34zYSGP68wCH1Eptgw+pk1HPpCN2Cni6m2fYycyNfO95jD/3bppsN0igwFJ20j4R9x/5Rkt/AA1v4X/WlrhjDPtrmSIro3tEkrH9iVIn6Q+tFW2vsNTyfiGqkKLJu88kT5SgsGfliGjp32o2W8pK+nLKXA77jnhtOJbZeXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3m0xLh2DJDgDxzKjrUvo5/hn+QzfyJo/wOkCaqor94w=;
 b=G9EaZyj4BMnUvZGx04jFXr355QUSowJldQwMs6/tJNj1ot3U5vzy3TekTaNMdCXGnqns4hE9JzHuAvBwBMMGpAZF5xlAQNoaQVLLxmf1/Huq0WeQd49am1W+1Opd2RxE/My+5FfodM1zb8S8yW44l3Sc6d7tK3L7TVlBi141rS/WWnuTM1rWskOHcnHnV373fjyQpqBsQtzkMqz1J9+aJBAMc+KaTSIUynexvz9X9U6V/uLkZ3Hd7/N/MTg9gzA2W/IWJDsgMK7zQKqpk4qN2kE8TZW+BkMEiFXd0czv31sfm9cG3eM+22TV8dxsNMA+hkkw9tWmnGGNmnMW9I7FFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3m0xLh2DJDgDxzKjrUvo5/hn+QzfyJo/wOkCaqor94w=;
 b=wWikiRNix2+EYGPov+SsPNj8qCpg6ab1Sbswy2+T81cCYVnJ6eX8B61aXzBSb9y8s9MZzB06LxcC/52j9BFv4T8Db/ilAeTR5/zcWuT/HSGU/aHqpGxwz9a9eSgmkz+2i1HmFDfNRCR22Q4Kh34BZN7jZJeymcr/rJF2VXbgEK0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA4PR10MB8373.namprd10.prod.outlook.com (2603:10b6:208:565::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.11; Thu, 23 Jul 2026 16:52:03 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.010; Thu, 23 Jul 2026
 16:52:02 +0000
Message-ID: <4e3300c4-e56f-4226-b141-6c83ecc32fb0@oracle.com>
Date: Thu, 23 Jul 2026 17:52:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 25/28] scsi: sd: support multipath disk
From: John Garry <john.g.garry@oracle.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-26-john.g.garry@oracle.com>
 <20260723104735.40A5C1F000E9@smtp.kernel.org>
 <12619e95-6a8b-4925-8fc5-e12b14d88f11@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <12619e95-6a8b-4925-8fc5-e12b14d88f11@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0097.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA4PR10MB8373:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c8b6aa8-dc9d-4779-48c0-08dee8dab831
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|6133799003|4143699003|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	z2y7C1jBR3ogOeUJmx9ekkKJApzrkyASUM6YNDGAKUrken3LaEI4TldNk44mAOIG6HZwe6mBbaqsbwdIIQYkAgkibNO1X0QggONIWfjjcBpu8QnUfZmOE8vvu+c7x6qiwocc/ScFGBdyk67ZlsC9EOT5MTzp8vc+PXCpwOmiXj6Ma8vJWjo53dbh4TgzYxXlvDZIjC/lBMbgiVSkPagyldppQlTi4kUt3XK5OwVR42nl8/y2wx2dwU/5ho5t4yljHd+PoMZZLBMUKT7Zf0GO4ecWzVChqYU0/DKiL3Srj1d1btqjsgtDVtcZZPbvVtRY5of5pQuzXlN97IAJhqSv+Afai67ZXTx9fM8EMv49y/SxPCQLH8+vWzJ5iyo7QomcnzGetIbU8Uaon5myHFHzrdvTnGaDunY1LD0DA3rKffCBqbI/5RJ8hFh5oOnMcBSSFFYXo7Sd+wbuUQzcEZfHk+dPpW7DtZufpYFvV7I6sya5x5q0nQt7Xq9G70YhFSBNrKfUMxiFIRVQvVyNieBnLMVDQcT3bh/WxRt3GMsyrhRyOrN/5mZmMbCavOC+htqQgWcEHVdwgohU7foxEn0RXhwu/oK+4DAwVKZLiUgXc76qOpi5vZzkhpdl6PB1P1lpTD+vsVobUdk62SH6xws9ZcfsngKa4iKp5EqiX7JMN6M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(6133799003)(4143699003)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGhZdkwrQjgyYVdycnhjVHg0RHpvQXhCeEM0OXlLeTVacVJVa1VTWi9yNFRr?=
 =?utf-8?B?cUR3aGhQMjlodXVwd3BuZ05EK2ZWQmYvYkVUR1Y4TXVhMnE3aWdwbkowWjR4?=
 =?utf-8?B?aDgxS3FDbUlveUFqUnhoY3pHN1dhRHltczB1TG11T0JqeWIxY1dONktWbURP?=
 =?utf-8?B?MDQ0TmFsQ0kxKy93YjNjbmlzMXRNZXllYmdhYk05Tm1CNGdMd1J0QUd0d2Jq?=
 =?utf-8?B?dEg5bzhabHlmSHowam9kbFNqT01CeHk1YUorZDVJaGNEQWdkTk5PRHNxM0VV?=
 =?utf-8?B?WGVGZk8vRUV4Ym50b3A4cGRGYlJ1SnRaYzZsYXM5UXljVUJBWTVtTDJDcGRV?=
 =?utf-8?B?WmdGMDh5ZldJNlBsUG91RCtRQ1FCMUZYdHNtMlZJbm00WW4yUGRFSDFEQUp4?=
 =?utf-8?B?cDJRQWw4TURiS2RoSHFHSzlUam9Cd1laK1ZuTXdnOVRoN2NxUUUzYzNQN0ls?=
 =?utf-8?B?YWt5Zm5URkN2QnJUY3c3SGh3MUlaOHcxL3RlQWZMUWMyaDNPUnJkLzEwaEtL?=
 =?utf-8?B?VFZDSk1PUC9iQ1Q4U2xjSEJYZzMyRHRlcVN5LyswY2x4UjFSdXoyUnVCencw?=
 =?utf-8?B?R0Q4dnRRTHlEVDN4S3RhcFNWU0lTTTZFY0NDeFdKU2hrR2JOTzczVnNBZElp?=
 =?utf-8?B?eXlIMzJMbHRyaEJ5LzR6ZkMvRlZnWmNrU3ZlUkFIMHJWRjZOVUtrNXExOVlE?=
 =?utf-8?B?MTJ3ZS9XMW9NOUQ3WUg3SXc2WnY4YVplck5hczNUYzEyaWMxeHlrUER1WGpJ?=
 =?utf-8?B?bEJIS0JQS1hZNTMyWTRZSmhFSzlYVTJhL3RpT3g4bndHUU5kOFlZWS8wWk5q?=
 =?utf-8?B?QWFTbXpGMGpMbTFNeVdNUXBzUWZJMjhvVUZOa215T09jUUdsL2ZjZ0tWZEx2?=
 =?utf-8?B?WnRLQmlaZmxNeWhPbW5zNVU2WjZtbWIvSWhPQld3WG9iaTVSR0xLc1V1cHQ0?=
 =?utf-8?B?aWxEaC9JcmpPNllvV1pmMkJGM2wvdmlzTlUxYUZJNUxQRjN1VVFRT3puc3E1?=
 =?utf-8?B?RVhNM1Bhd2plRmF6YzdGZUpzTndnZWQ2VDJnUGIyQVJJWmdKUlFqbm4wYnA2?=
 =?utf-8?B?dHdKUGtaaWdrMTRNRTQrMWlnN2FjcTd1RUs5eVpZRktZaS9pTG9DTG5DSlRt?=
 =?utf-8?B?TjNhVDRqM0t2UG9aZTljVU1HU1pDdVdqOHJYOFJnd0hqZUUwT0w3TVdYYzk1?=
 =?utf-8?B?V2h0QkFWTkJvaXZLNnA3cmxXT0pCR21rMWlITHFmS2VNRHJEUU42VWtveDl5?=
 =?utf-8?B?bTBXU2daS2JoNW5kUXU4dG1VU0Q3RDFEYlNuWXI1a091SDh5Vi9SZlpCRndG?=
 =?utf-8?B?Ui9iRnkyRWFlNWVRRU52a2ZJN3BXd1p2eVRPdkFBc3pPblVSalNyRzk3Q2xn?=
 =?utf-8?B?Y3hBclNLZi85ZGlIbVBmc3pWSEkvem9LNWN6cytKdzU0S01VbFRTQVBqT2Zw?=
 =?utf-8?B?RG1NV2JMSFQyZXhPZm85dTQ5cFlzYVRYRG16WVMxdFRaMkFjdE5kQkRKUDA1?=
 =?utf-8?B?c0QvcE1SamNTS3piZ0ZVKzZueVdXR1JaejFiNVU2b2NTZHpMOWVDanJFd05k?=
 =?utf-8?B?aE9VOU5JWWYrdW9vclRiaUdsV3E2NGlxVnQ4ZFJJM2ljTGc1MHVHalRCdGdF?=
 =?utf-8?B?dE9FdDVaS3ljQjc3OGtGNjB0bEgyTkNuWTlDSm9kcG9DRnZtUm5YeWFhN2hU?=
 =?utf-8?B?QStMdUtPeHVZNzB6UVRURUMrZXpnckFuYXZGZFVGNVNuSnVBSloySk9yTDJ2?=
 =?utf-8?B?b0xaT1JkS09sOXpQWEJraHErcE5mSk1YR2tOMmhzNU9RejJCOEM1UytqV2Nr?=
 =?utf-8?B?Y1FpeGg5L2dwQWljTVJ6NXpOaFhpalJyMS9landjM2tkUGh6RDBXNTMvRzdM?=
 =?utf-8?B?bVZyNmtqRGZVc2NyeGFCVG5GQzJSMHMzQ0JoekxyRVRmcndwQ1dqRlFMZkFZ?=
 =?utf-8?B?ZitLbWFrUG1kU29zRTFCRU5tNHM0WDhTUU9rV0Nrb0pVV1pGcTRLdHd0TkpB?=
 =?utf-8?B?Y0hCY1VCY0RwSkRZQXNNUGZvcHNUZXNWN3pwa2lNcXJVdUJvUmRaNlExaXlU?=
 =?utf-8?B?enQvZGgrM2ozSzFOVTVBTXpTTWpBYlBCMXpZbjh4VHoyM0dIZm91YVlIb2VW?=
 =?utf-8?B?V2d2ajhSaVJudGJDTWpWR2ZkZWR0d05QelU4ZTBlK1BGSzF4M0tLRDlFeGVY?=
 =?utf-8?B?YlhDSzl6Zk1zT3ptTkd0Z3AvVGQ3SWhlNjJTRE9hbjlRak1HQjJ0K3hoUWV2?=
 =?utf-8?B?MXJYb1BaaEVNRkEvc3BWOHQwcFVQdXRwYnJtaEN0eXJpb2xsNUFtbjFFaDdO?=
 =?utf-8?B?UVY3dVpZYTYvb3NyK2YxYTNMWTdLUFJhckozeEFrTUM1U0c1bGE3VjduR3p6?=
 =?utf-8?Q?oNAq80BspYlm25Mk=3D?=
X-Exchange-RoutingPolicyChecked:
	oAx8VO7wD2h1vlfR3e0q2oRGzyooLncUviVGxX9w2JLTpZJz2Yh8fclUFzpwqCFK5AUu7pMygA1F3cY3p2KhWOPip0cpNjcd/jJNLM0uBCKZDHPWrMX8fzggkQbf26HerbcJIPWQ1foNJBh14e2PuSSKgHWgNA705Yyl9fz1h1vZbx5u9t1eZV2ZcCvh021aQo0PoSjw8gRicpAvYv/e4EbWpOcOG+HUpJNXvaKhRCkvGXMXG2oEuBAaPPLPptSvQVtdFWd7WBcd+XmKMqk6753CqM4jj+2aOyfrhUmMpho3nZPpDkx9bdYfWpg9WwYHzrTYSMvR/FNgizFII2agWA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0wY7fcn3s7/iTn3QHWF/YfuYOascJ04qgBF+59PwXyjm2dRogcjKQBvyeqnnsXtg0kVGpA//E+HE85Eo2VdOFszoPsWgNNAiCxRO9roOD0vUZe6vBlJAnWvVu19eeFUoY8KY/3Uda/5Ekkauq0zc4uYPBEG+02uynnO8kpRjVN7Mbnq4hfQ03A4rjQmQHWnSBHs9IM90/LHUTiBXg399z4EgDFpolk5qIH3y3u9LoPpRzDFBp/b9cEONn5DpW8l7Rc+XgSzi57elBrdfe8clRX9BXB7QKY+nvxwC/+mu74ehrIaeP73hAvzcp4Gna2752GDxIUYi/eGjPzF5970UGccipPJGcZMFmRipSlJ4NITQEKaNgBZ6xX8hyIDBazLTWBsg8feiUFMDss9Zq+reswKsCKpgxPkw8YGLFKCZjDOAYw3E4MQN5OzMN/xWR2HOwuktEiOG7sbDFTRg1Nhi9c4Ipfwq1XUFkKHX5Ce22zS6eJn3Jmk/hpyA9x1qHx9aqbvmHswfkR4orJSSKczV8hSQYlnOySZxff2UXezz/N4yUQe5e2A8j0+lX3zxV0dU0+EhcE1k+n+yKkcoSD1U3O4soPdLlbTET5Z7UkGGrLY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8b6aa8-dc9d-4779-48c0-08dee8dab831
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 16:52:02.5149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: We3ETkBAteRQfTmTUttQkByUvpGsB4Ou+gFBXIHrRt0p/vnpwvZtTeY8Kksrjnhx8MU3IbSf5WeVeQmfeGl4/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8373
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230165
X-Proofpoint-GUID: DNrRsBE0DdukXG1nAs68FVTCwLSjh4uS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2NSBTYWx0ZWRfX/+bEZYJ20mL1
 el6X9M7y9nAZuTjQkgRVsWn9NDL/VJSvvtnifwFWL9jzX/U9louUcGuEoQEvXRuQpXOIVHM9fut
 QpI67dZrfBRG2sjN18XixjIfPTP6g9vVPBB0ASH5+TXZuAiHrbdn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2NSBTYWx0ZWRfX6Bi187/qn23M
 KnGgcgaPIC9A8NS6DLlSJf3BPGQiFUpmslH+BXKkSsTvm+uI2jr48fPyAbhOqXvTVY8gz8A8Woo
 XCxfcfz/Zb5zdcexv0Mzgy/YQSgvQveN5Dk1lzyiKqvMxgeufzwkLA1ibLMTlldyKYYjgkF9RZI
 Py5FARugvWTuU6Yfx3HBvOMFjnJOdEdcw8xE38OrYJCWv5SiXeIBAt858flKMdqRHdKCu1nkEGV
 iD1NvgwQt0XfyBOMQry/3vga5sL1PB7z7bRiM5E9ZJqNHJUOVaJBdMMCQBn+DyvJm3CzrSNStJH
 jINRob2vdVySLEAzxBfs1+9NDTLFSeZPRizBbGzOoye4jTcmWxLHNya5a6ZbOn4d//8JKV5m/qr
 KNfvTlzBWCITEJU02b/9a+iC8r+M2lb+o0dHOgEF82N3W62px9EAnCJsDk2ObDaKx12nC8pZlQ/
 dorUglVKLO3YsPXY2lA==
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a6246b7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=nQQ82Z3LmMo0BOHCc-EA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: DNrRsBE0DdukXG1nAs68FVTCwLSjh4uS

On 23/07/2026 12:27, John Garry wrote:
>>
>> [Severity: High]
>> What happens if there is pending delayed work on mpath_head->remove_work
>> when we hit this error path? If a previous removal queued the work,
>> and a subsequent failed probe triggers this code, we delete and free the
>> head without canceling the delayed work. Will the workqueue then trigger
>> a use-after-free on the freed mpath_head?
> 
> will check

In this case sd_mpath_remove_head() will report that it cannot find the 
disk and bail out.
