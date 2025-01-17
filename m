Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE801A2C27;
	Fri, 17 Jan 2025 19:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737143020; cv=fail; b=kFrjqIk/pDVL8b1fF9uiBWldwbfZN9zMSy1WNLF4gqFYtbmgKdeQDxQzGaB+B9Jn1zPFqpD+NRq4AFjRPEGEWZaTiOYwz6/S2UGYcILNzkeLd5Q0iMDU+xmW51vXa1rlrFLpSdDZ7nGgXSqDb0JkOkirRYtUuArYfu2vIcFOuvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737143020; c=relaxed/simple;
	bh=B7SMxbrpxHFPgXNeiDuKGzk7HSvRQQz9YO0mB5XljzE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nU1KMK4PvvqyyjVDzz1jQccnK9qNssSSNHQgRcAdLdPSGncbhzBhHwUSjzJ6ZwhTaagPIC13FhfqtAnqgrS5qHd+b/H924gC1FLV2iPattrQJOWG2pE01nbt9/DNQFFP2CDSWiu6EtZ4jV/xHJzzcFTj8G8qF/nTctPJQGAauYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VvKvtlJO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WsgPK4vk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VvKvtlJO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WsgPK4vk"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIBqGQ006978;
	Fri, 17 Jan 2025 19:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=fcypvJTVa+sLbFrmi4adZO3a1E18EoiIC61E2STGKD0=; b=
	VvKvtlJOKJF3KvZKWqnr+MdoSo0YVSH3+Tf4TwSt5ZTqIo3UP9lBKMe8+3sT1qT4
	JKEG3Jf+1p8NuIzY7iZzEfwpzODNYHiH+0qgUscUJrYt+ig2PXBFDuThDzx7fflL
	FWfw0NemYnAUmeYgKHAu+Wi7aA5+/1YmNklsQ8avj6TB0a8j1RUoeYtRyKiTTB8p
	ROijWoiz6aiznpXYc5j+cj62AB0eEqxxddXb0pd3boQe6JnMJxcrRcb/oUC2rgZ3
	L1QvkrCx3ExuUPpnaFToMWGDsXkBnm/nwI5rEsyHJBgNzD0Wl08gRKobKn+/Ur3k
	3TZ4xPuiYT+oxlGNoFyZvA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4475mfjqk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:43:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50HJ4t0o004583;
	Fri, 17 Jan 2025 19:43:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4473e6rg9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:43:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RB5o8ZLWtdtOI4GnVHU44TPxFSyfPAZ25LkkpIKbDxe5SujYrb3GaEqwmnfk89f982MfWTUzEwRZzc0qBAa5CMWMZDw2RfRdECu9ksaM6GwtMPPfA1g4KHN8NeZLvh3d9AymnMzbgVKeKHMpc3UzOEscAlqnzfBc9QCE8LuCufQibBRFH57m6PZbYwvJFBhaNw5gWc+zf+zB+pcZD+TZsXRftxqhPQVA6xmsx9OtYbbB7xDIKZIUaOiCb1RD31FWpuKJ0aS98EN3ubZW0fuDZ4aYsd7wZOQLK1R8Ggg9O1y2qoEvCe+Z/0Ct+h2IKl6VRhGtx8RaCn3H9BbLuRIVbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcypvJTVa+sLbFrmi4adZO3a1E18EoiIC61E2STGKD0=;
 b=Hs+yuhfXOMtbQ/kBmBipps7bYTn0K5gtUly75z++5HM7SSoTEhJkQ5qtFNabZem+j9K19VuOGhYjZMbvkxR0PgRSRb8jWrAzAvlOUjCjn2iAHhWE+l1Ve/2uT7gqVZHgYukOhdW4Hz/MlxU5dc5zSqg3M90JwZkeP97QrA1FXRMF+jBBTZazPoZSS4RZFgNXludzfhJtIYXVYLZzRKL5ZY8na3vhDfcp6Tc0WW99vdRwboP8JT7qZA2rgspW7OYokC69HUXcVHnt9tE7Rxn+tX2VpQQx6DZ6mTZ81RfBgrpgyu0GKizs9ta1KHB/QBUN/BzmbDC1GASHGLvDVPZO0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcypvJTVa+sLbFrmi4adZO3a1E18EoiIC61E2STGKD0=;
 b=WsgPK4vkZw26WtwzSoRbxLy01U/ZRy1nUvSOvpGKsBlpCWfrbe0megRyqzlt+QvsCXywi5iv2WNYnOgt1QdstT7L/3gcvcrLfhgVryCTFiLtdtEEtEX734DP8cEgRZvnaG2H4E+roo82qTPIrw1lRdhvFm2vAYKMPIJqcK2xJFk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB7729.namprd10.prod.outlook.com (2603:10b6:510:30d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.16; Fri, 17 Jan
 2025 19:43:31 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 19:43:31 +0000
Message-ID: <cb0c1937-8b33-4bc5-8f33-afbd9b3264b2@oracle.com>
Date: Fri, 17 Jan 2025 13:43:29 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: core: add line break to status show
To: Guixin Liu <kanie@linux.alibaba.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250114025041.97301-1-kanie@linux.alibaba.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250114025041.97301-1-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS2PEPF00004554.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::516) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB7729:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f67a338-b515-4db1-54c0-08dd372f38ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmdZWkU3Z2FJQi9WTU9BWDFUajByOExWRlRTNnhVcEFDd0E4VDJGWXNvVjM4?=
 =?utf-8?B?R2J3WUhqWDdnQm1nbUEycUd6Kzd2Rk92OS9iZ1RqcGc5bDluVmNkWTY4OEp6?=
 =?utf-8?B?U3NNRVlZYXdteTg5RWkxdHI3TmlYdWVpS2M1NmJiWENJZG5sRzlZWXVOZmFv?=
 =?utf-8?B?MUlCbnczOWhCWExvRnpPa2d0M3pVdVZLR0kydi81UlkvZXI4YzM0eG1QYXk4?=
 =?utf-8?B?aC9jYjlKNlhuSEoxaFdzSldpSTJTeVdEMTJHQkIzRlZCNCtDMC91VDNrUExi?=
 =?utf-8?B?RXYyWUE4ZkZZY1grL2NORWdGb3VuRTNXR1MxUHVRVnVvV2hUeFd6UTdUSmVn?=
 =?utf-8?B?YXAzVlp1Z2ZQNUpBS1FEZStueXZLeC9uWGRFOHkxTkM1Si9IRkVYdVQ1NUFC?=
 =?utf-8?B?WTcwNHNEdVFVVC8wRW1udEJlVFByNVdwaHhSZzFVRVRpbmxRNk9na0FBYVpk?=
 =?utf-8?B?bkhGcHpwZnBlVmZNNVUxSWxFeW9QRmMvRjVXOXhxdS9pMmlTNkw4RmRjSTRB?=
 =?utf-8?B?b1dJb0FSRFZOZXpSZEdma2tKMlMwNzRLY2VlZ0ZnVHhwcUNseXZFUnp1TjhU?=
 =?utf-8?B?c3pLdy9JSzF1SHQvSEVJbG9ma3ZQOEQ4Z2lsbytmMk9lSjl3Yk9xdlBtc3ZG?=
 =?utf-8?B?NkJpK2lneUVMR3ptSXhIY2Qya3hYaFpWYWZnR2RKazlpUi9FV2tWZXNsR3Az?=
 =?utf-8?B?cG9FdUw3cHBZU0x6SlVPZTh0b0wvMlpTQjFPdkN5VEppVmJQVGpnVmxIZEpx?=
 =?utf-8?B?VERKMVVWWVlNMGdqN3R2TGxNY0RuUjVwNnk4ZHF6Q2VydXV6eFMrTjEvdm5q?=
 =?utf-8?B?SStiS0hJVHp1bUhZSXZTQzNkMytyS0JUZC8wUEswTE95Z0tTdDZPek5aNEg0?=
 =?utf-8?B?UThxUkhaZU9ueXEyZERsRFFMbThzbUV0am9FT0VkZ0VjUjdCRXpLUlNLS1NF?=
 =?utf-8?B?Wjk5V0JuLzJpZjhKejZDdnJxTFdHa0ovOGsrU0p4Zm5Uc3BVY1BRVjVRQkZH?=
 =?utf-8?B?VktEcGFBa2R2ZHFOaXBadXZzOWUwMVRtM012QVoyOXdja0hUOFJHeGY4Wllt?=
 =?utf-8?B?UWdSeG1Yb1cwWTNmRitUU21hZ1ZKYSt0ZkFIS3hENG5ZckxSRE9FNFJKbVJJ?=
 =?utf-8?B?Rkp0Rncrb0RZQ1l5WTlJWlA3OGo3V3BxS3duZnRDUzFHZkdKZmJ5ak9wK3Bh?=
 =?utf-8?B?VzlHbUsyZ1JSWDVaaUVUOU8zZGtWUDN6eThzN0g4WDhEbGwzYUJySU9lcFo4?=
 =?utf-8?B?bzNhL0djSXk4cG04bEx3bzZhMUhmTmhhUG1nbExFbWQ2YjlCZGJ1UDhSL1hY?=
 =?utf-8?B?cEU0WFRBc2l4MnJKRnhoTDRqS3pLM3czc1FUS1JWSEJSTE1YTlp2S3FrR05s?=
 =?utf-8?B?SlFXbTdWU2Z4YitnbEZpZWZaZDNjWVJvb0xGcUZpcjByeE14elNlYTZsbmNY?=
 =?utf-8?B?UlgrVEk4NVFiRmdZTFVEOTBycHNjaGh0YXZubXFhdHcvdzRxQUhmUndTTE1O?=
 =?utf-8?B?VHJpU3Z3WkcvUUI1US92dHF5c1Q3cDRyeVBKNWFGR3o2TDZoT2ZwcW9Dc2kz?=
 =?utf-8?B?Vy8xUyt3MmtEWC9wK2tJenFYVkxnTmljRk5hVzQyZmxNdURicFNMRXFkZFE2?=
 =?utf-8?B?bkZGUXdTdTF5QjhXb1J4SXdKZGhmNHFrVTZkRkloYjYrUUtRcCtadTltTGND?=
 =?utf-8?B?dkxubUw5dlllMk9jSkw3R1BtNGhvT1NmMDB0ajg1ektlNUxLbDlVSG1VdTB3?=
 =?utf-8?B?cE56K093c3lrbUhEZG1KckhrRUlnamVtRm95Yk5oczdTdndKdURrY1NNYXVB?=
 =?utf-8?B?S0FNMUh3SlRpaDRnUW9PSW55amZxRTF4SkFaaVVsUzYvU0hERGpyYWtxVEpO?=
 =?utf-8?Q?oFmClAKHZ7phD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWNDb1NDTFRJZlZZMFp1QkRUMlR2bGdsWm14am54K3d5ZWNtemUzdVJrZWpI?=
 =?utf-8?B?SDg1T2pHVkl1VUlYZFQxZFlOY1ZWY29LZnNWeG5QWEtEN2M3cHozeTBwOCtp?=
 =?utf-8?B?SmNXQS9kV2pFaG5JZWNvckZHK1BXY2w1dFRwOVE3c3d1NndJS3U3NGpSZlpV?=
 =?utf-8?B?MExvQUdJRC9LdE56VEV3bFhaa3FsZFMvT0ttUW1oNXE4bkFrS0NnQlJYZFM0?=
 =?utf-8?B?N1JJbGV2bnYxakZjbFRRbEJPNWRpMlovT1dHdEVrYnNja1FGcHlXMjdBdXlJ?=
 =?utf-8?B?SE5nVUdVNVNHN1d4dWFDTWRwT2J5SitNRXFvL3YrcTdOWmFEaWNQa3NQajhl?=
 =?utf-8?B?cDc2VWFHZVlOKzZnY3RSb3BsYjJybHhmVkJiZmlSUmREb29WaXZENjJiMUVU?=
 =?utf-8?B?SmxmNXNKS3NzRk5rSFE4cjBuc1hGOFgvdlJmVmUzUmgvMWRCUmpxdkZzWElY?=
 =?utf-8?B?OEd6bmVSektoSk5aQmJucSsrZXNxNmhwMVJGeVZlSHdJTWt5Wk8vQ0xoMkpt?=
 =?utf-8?B?MkVoZFI5MExMTjFIaGJmaEhhTC9WdWV2V2FVZmJkeXNENUdnY1ZHc1VUNXdC?=
 =?utf-8?B?Sm5hV1ZlaS94L3U1WnRyY29RbXIrSmFmNE1GUVNVVTFrdktRTnE0NUFuM3E4?=
 =?utf-8?B?K3BxcytlMTliV3ZqWjFsMnB0SlBNbW5FOTZ0VUhJbEZzcXl4SkNZZFVrcUR0?=
 =?utf-8?B?cjJQNThzcVNxZkIrcS82VWlWY1NGWFgxMVF6K1JKc3dEbmI1dTBzYUtiaGlY?=
 =?utf-8?B?cW95QWpsazlKcnMvcDRtN3QwYm1MZUZ2OHBJOUg2aUdGb2MwUGF2UEhUcmJM?=
 =?utf-8?B?Zlc1UDN4OVN0NUxpTFBCS1BJcWIvTmZabUNzUDR1ZzhFK2I4RENNYzlBNmlM?=
 =?utf-8?B?aVRMbVdYSFBrOWhUa3d5akIxL2VydmhpRFEzNXR6RFkveGd3NjRRRzRIV203?=
 =?utf-8?B?MFRGaHQvNGFqcFk4ZjNqc3NDeWxGYXpNU1c4eXJIM25IZU1tMVpuLzkreHhO?=
 =?utf-8?B?OGE4NWlkcEZPR3pOc3hGbVQ3NFJLemh6S1JNRkc5WER3a2VCb1lLWVpwV1RU?=
 =?utf-8?B?S1d2YVBJb204aGl3Ris1OWMwZHptcENWWVFTWS8ydmZ0M0RHL1JIZ2sxbzha?=
 =?utf-8?B?KzlzR0U2d2xya3p6dk5xV3VwZFlkN2ZVVUg0R3hXNHkrRVlzcGY4dGJ0YXli?=
 =?utf-8?B?ekNrTDZsKzUwYmVFdnFaTUU2SWQ3QkNXWGV5T0ZSQlU2ZVA1UlBMdE9mTnNM?=
 =?utf-8?B?czJUNGYzTDNHcE9HR1VlanBhS0trUzl5U3diN3B1dktwN1MrREUwV1NKSzhH?=
 =?utf-8?B?Y1g3M2gzV2tsc3NkOFNPUGwyTUtsK2xsb3R2T00yVGY2RFFVQUFvN3dMTFhz?=
 =?utf-8?B?WnZzMlMxRE83VkJSNXo5WWVKT0pKbmF3VjNaM0VCOHcrQnNvaWQzRXhpMmEw?=
 =?utf-8?B?NmgwTC9wT00zNmw5bjEyK2haVkJ1ZjVJOHdBcEsvQnlZV3BaaGswbHkvSUJU?=
 =?utf-8?B?dEVUeHRHajRsaFd4WTUyTVhVTmV0VllTbzF3SC9nQ2F4Y0cyWGJRdUxYQS94?=
 =?utf-8?B?cnJkelZTamQwVk4zRlBDZDlxdjAxSTBNdU1Lc1ZjQnNuR1Nla0RKZG1QZjE5?=
 =?utf-8?B?WEJGZTIwdXkxa3h2MmxWS1U3L2hWdGs1Z2J5bTZNcEMwSjBickluMjVJNWRi?=
 =?utf-8?B?TFkzaldyM0pzcEIxL05lNHhyYUpZeWpSZWdoRXRTaGJSRG43UjRMTFFXdUtW?=
 =?utf-8?B?ZzJWYXZ3QXBaT205My9qU25Sb3I0Q2NMTlJNcE1EcnV2TGRVRTZRSVdvM3dF?=
 =?utf-8?B?NlNKNWZXWjFHVEJIRmNqQU1Uak9sSmdEZHk4TmtDOFh2djIvZkd0elN1Q1lE?=
 =?utf-8?B?c0duTlE5N1BZall2dFRiMXgwd2dJdzhKVjRQQjRXeWVOVyt0QnZ6TlpZcVor?=
 =?utf-8?B?Q1dJUWJMQ2wyeng3MXhhcHFSTkVPNGIreFExMW5sRUpjRVo2VWJHNU1QOHlP?=
 =?utf-8?B?bUZpMFdDdGN1RG5zSWpKZlppZ01zTW43V0Q4YmJvcVZRb0pVSzhJM3JXTU1Q?=
 =?utf-8?B?N2xwTkdyb3FWZ2ZuVGhhc01YTDhUZ2NHSUxtcnJhRERhQXMvVWsvWHhUU3Iv?=
 =?utf-8?B?dUZEcGVtYUcwNHZqSDFtNWRkSlNScGNEaDUvTktod3RlTUZiL0R6V1hIYmp3?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ocMSdFajFHyWwxjroAVa9asMRP1V250QsN8YgwmMZBxm3bWpFT2jQb/f+qRS7xmnBByMY87GqtZRqvR0dIEwMXvamme0cVlXruTpADSQq/EvycmOkLTFoqzsIImxFiYxlINWnRvg3yXFrCP57ZfJAo6VZ1Hu7Y3unAaYEBzx7o8maFfUEhutSneX8MISPB7gt4dCffoljkh7VagYgZcw/Vt4te42v5W+idwNuE4uxK/ba9fCv9yXZ6rme8gHO9rm8bnetVMkhnnhYNWEHIXabr1rWLdOeuef0Hdvxrp4lMvAcOxC52u4Axef+cZYAPTDu9OtnS01GW2A/2zbnBsq1TV3a4f5kP0tYGI6BjT70uOKeQdoxF0BVmYpYJw9KaF+RbppniLyHDwFpn/UzSb7y7JcsdcLU/GOp3ACStCvPj5uZ+fQ0Qp0cg7DgadsKGAhMZPY408KeU43V06pSE2B8OwfUm4HElD+rmOQRtQRVRP0BYSaXKQayhjNM3vURl8IdkRyjWTyxmBuEk+5aosRBH3QS/kJ0i3/o7gYqrlrFlz6hvRnQNENNTnvs/f4Loy3QlCw6MS8tlcWodQd5XPtBq1hQvXYtWnBEt6jnpwqH8c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f67a338-b515-4db1-54c0-08dd372f38ac
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 19:43:31.2059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xwRycBIJGeZIvXGdfVYnEPNI+h99Xheoz8QKWg+Lx137HxCnL2vMXoR+L2RyAFBJTR2lzE4gNAlq3oYE8+GE+HD+bYB1irf60u4qqb06fes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501170153
X-Proofpoint-GUID: cVzVbP0LLDhlgwiTU1UbtOgsU3JFb2di
X-Proofpoint-ORIG-GUID: cVzVbP0LLDhlgwiTU1UbtOgsU3JFb2di

On 1/13/25 8:50 PM, Guixin Liu wrote:
> To ensure the output is not tangled with the shell prompt, add a
> line break to clearly display the status.
> 
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
>  drivers/target/target_core_stat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index c42cbde8a31b..210648a0092e 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -117,9 +117,9 @@ static ssize_t target_stat_tgt_status_show(struct config_item *item,
>  		char *page)
>  {
>  	if (to_stat_tgt_dev(item)->export_count)
> -		return snprintf(page, PAGE_SIZE, "activated");
> +		return snprintf(page, PAGE_SIZE, "activated\n");
>  	else
> -		return snprintf(page, PAGE_SIZE, "deactivated");
> +		return snprintf(page, PAGE_SIZE, "deactivated\n");
>  }
>  
>  static ssize_t target_stat_tgt_non_access_lus_show(struct config_item *item,

Since all the other files have newlines, this will most likely be ok.
targetcli/rtslib work fine.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
