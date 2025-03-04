Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E8842AA6;
	Tue,  4 Mar 2025 02:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741055769; cv=fail; b=dWV4krLBMklmvaNpoSoRX74TsEFD4uF/kw+lIvjwgAo1WFyRGDu0TyMDsqXZWd2Ibi3yQrH3/qOH5CfNAnMyYJTbrdeV+3Q3A6VjeZFQmOCiamPn7H7gk3eDUs+/zwK8KDqQkTJAHtOm2M607hq8r4/a+8KREuYjMI58Ur/TJXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741055769; c=relaxed/simple;
	bh=nd9sCKdj4zXe2NQx5gfOsCEOgjPr+s41Ba4J0EYGHIg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XxQmBhwkRSTyKFNHctkSx8nVQKLSD18r6PBPZgexPSgzE+26NTMLZpIRWuzHc6v70GFzj/hTya75BoOFhhfj227Kmmlb+6kF9rno62mXplTW84Ca8Oii/mOZ/tENHTnktLjDSYG3RNhdtRYve6zBwTsKhS3ma6Sh7RQc5EtmYV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lj+syKvY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IRRDIlcX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lj+syKvY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IRRDIlcX"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241NHD8011342;
	Tue, 4 Mar 2025 02:36:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=xlv/K7IbGn3zYYLwIp
	qUIw49ATjBMfOUjwqD+QLJJWk=; b=lj+syKvYud4M3IjgZtJsRbXy5e6AMCy/YQ
	Q1XbtBgyDVHIZ6MDjvuiiCzKvanXYGUFTaL4R/D1CXxflyAkvnbv/QwAqHPVcvi4
	h2XR6Wbqjkg9Ma4wIHFP+lv6nDsW2pxw0PNWBKdZ+htZfwPtp3zq8YTzXeZb02yr
	1RfDaQ4RzLKLPi2EtDc7tV5lXmDLZratC6n5ePu9z1GR+la9s8JP17Gecnq2QgwU
	c9PGkUkrDQzATTmK/EIeeYKsjfnqYEhND5VRcPcCfqzfWujwapnwCKvCresDQ/57
	ePjk+rLgUrNc+yJjPj3uqFtRSglHcAYA/kiILSS65KKgU2OuPtqw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8hc2tu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:36:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 523NwDJb038909;
	Tue, 4 Mar 2025 02:36:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpeke60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:36:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q9aayQsC23j8vlFeYGtFRjQHPj2qtwRBzKRtTJel2g8v+i4ZQBkT//nF0arCsqwMxNeIJLoYW7fb1eCfjjuCNViri51mH28sioV1Y2IJTo1qlnTObGwTWJVcEmhItAvOGvDSblmtuVZ5pGlAbjj1GjfFUfFtN6hzoay/uaWaVg3XHo9BFCX2cWcrtJdhTyoKLC+pD9L4io1GuqkNN+KDwNRZ4nduC1KGMaaKhpoatPpB4CxoOk5V97T7t4xSXx7S/EwbIz6pPc8G7wzS+kkbZnGlQLiePE2kA2MbLh5zO9sgyzWOD0fc6L3X2UeS40R1Yl+tgdy7N5+/1W8mdiBJbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlv/K7IbGn3zYYLwIpqUIw49ATjBMfOUjwqD+QLJJWk=;
 b=WcL2308djbbj6PHdlUU2uXrPU9q8gG6JOuRR6qog0oH31LLoTTxBHjlkt7ELKCrXA+RTvQrWv6t8qegakA82iF+Kc+0qid7Pw0e1IGcDI9H2k6GoxdfjoFGdwXYyHvsCNyWF5faVPfr4+p7eRgUjtg5D5y1Vk0+FZ7B9Yml7lgCDN33c4GqHvf81ewXL4GackHuqFoin3+KUKRhRlo4UHWAM82/i97v0y/kBvvqqlzxM5MIIWdaI77EnkGTNws9TkYnzWtAeJ3MhISa/kkrLRbsU8D3hJ+up3TY1rORn1t4Ff7ZuUWWymVXxJeSKqO4hh6KfaBCdVt0fgrQwjdDFVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlv/K7IbGn3zYYLwIpqUIw49ATjBMfOUjwqD+QLJJWk=;
 b=IRRDIlcXjeqX7hmChY/Hk9px0zD+6zEgUKpyOI+gnzoDxS70aNo2Vd2jZ1yNDEsTZ9wZAyBlX+duFiBdWOMXYN41ioV0qSJfJIaDgrQEWZPclnDXMpD2ZPckQBdAYVDuYVMqByqK7XB3rpO945enfJkAqRYM1eU/AnrPWD+K678=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA0PR10MB6889.namprd10.prod.outlook.com (2603:10b6:208:433::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Tue, 4 Mar
 2025 02:36:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:36:02 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: Replace deprecated strncpy() with
 strscpy()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250302225641.245127-2-thorsten.blum@linux.dev> (Thorsten
	Blum's message of "Sun, 2 Mar 2025 23:56:41 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldtlttdo.fsf@ca-mkp.ca.oracle.com>
References: <20250302225641.245127-2-thorsten.blum@linux.dev>
Date: Mon, 03 Mar 2025 21:36:00 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA0PR10MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bbeb018-381a-442f-fe9a-08dd5ac54de7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l1zsUfQtfUi7rzOYazAIYBFLyG4PIeSxSZ8oaKBv+1D9ecieNy6dcfWIfwZu?=
 =?us-ascii?Q?/oLOYxFhlGO80eH1ZZ/s4UkY9bpbAY03PDrpMgi9uTWNi2wnsgxWB0QX/1Kl?=
 =?us-ascii?Q?0cbt5HZ3hbZRxHEF+FaEbGQBuVzRDwBRcHtPAGxVuYFTdDUf1RMdKp+kXz3S?=
 =?us-ascii?Q?53weX/+eqcXTFWLTPFaOZu+VCUw6auQDAzquiQTEp4WbQprBNsUjVOoXsuv1?=
 =?us-ascii?Q?UfMAYN11HOD9DK0CmeQbXdvWFrjlI6b4kzftQ4x96ePKhqxOQN24pr4SFfFl?=
 =?us-ascii?Q?yt/f/VzVyOykHFvc2xCZBbIg/DT22bA1YXizhwmVR4UFlCSrMzWuc8H6Q3VK?=
 =?us-ascii?Q?h0KfJLzhsjEYcXROywmPYz4MZEdiXHOc0CzUibkRYIOAlQf3W7e6Hc7i2hvO?=
 =?us-ascii?Q?PHbdnS/Nviv4YmGHBQE7VQ82kFrMr2iHEi18f0fRVmgljfhV6cOftXHauFLN?=
 =?us-ascii?Q?mCVIamVzpBZxeCR92B0lvX7/tmLyiIStGMlXMtceFE/MhWR+eYB3ej4CBcUr?=
 =?us-ascii?Q?BaxZMt7GBwYoN7vdT1+Nzc5rQJFvUixuu5PtLsKTXP5r35OPrqNfTDUkj1OF?=
 =?us-ascii?Q?o+unzc4je+RlMx6xVfbuV4bF0J1UxlC1qWaGAUAa4dOghUnmBuF6wWFkxyDw?=
 =?us-ascii?Q?lsRVTd1tZMg2ytzye4VOTn75kjp67qVEQvwOfixhgstL1l2zE38VILOBtwTt?=
 =?us-ascii?Q?rGOrtB4XztKXtiaKpJE9/2iiCaIBwpazSfxjvSN0xG64PyT48Qry2FtUyInK?=
 =?us-ascii?Q?K0knpQUG9alZjrzbnHUHaHGWJE1pRKWou3amOAe7WXZK3Cp2AD8M6vAnMhMi?=
 =?us-ascii?Q?MZApMrEKyOmmV/yc/30V5J4bOBtOtJUJ7G8hJhSfdtDLq107/+bIsO3WIbTE?=
 =?us-ascii?Q?hBEdtyWGMFc5qsAIu0Fj0idyi8Z303tXdPxkJNnvXbpdJxN3BDeNt9ZD+Mo2?=
 =?us-ascii?Q?jFNIS4BF3WPZp5df4o5DsDhIyimXw7kiWGrvaQcRMKKPD2qbc9J2tov3L5Ma?=
 =?us-ascii?Q?jDr9e9XaVW7wJNL2GzTgekfQkQ4TEujn1jL++0pw+UPUB093nV8f9/i4YDMw?=
 =?us-ascii?Q?pR2mzE0GfrI3L/9K6our6BGgltpcmEsNhvnl6doUFtpQenafg181F9hPW5FI?=
 =?us-ascii?Q?XaowL/2pxQy3adl0SkNlXPq9ph/9+/BdPB2cpeg7wUa4gNV8MYIcfUiv4OEB?=
 =?us-ascii?Q?aoTg9DAds+TcmnEiCWQVRj1U74jhE2CTupEDzjgbV+/+Pd/Nte0X+nIYeuYg?=
 =?us-ascii?Q?drFtLYr+chXawSp6i6rjgKkS8hTkliKIgbGYmdBfOsWY5SLJmAVEZTT+P/T/?=
 =?us-ascii?Q?onm4XmbspPuvXUVsVFjwHwqAovH1/DPtesbzczqER9SUvKDRKGfm1GkAFoFm?=
 =?us-ascii?Q?MVGlESp38+zI2g1++wbKKSApSHPf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kYy0Ct5xl/aa2t3iMXn2PAIbJ/k8n6mKFB1tvoLpfCkKEV1SLNoSiNRBTLu4?=
 =?us-ascii?Q?GARnCNJYdmBGGSb63nJMKW3uru1PZUXp+LUjZwiA+1GINlRzLci//DOQuoJv?=
 =?us-ascii?Q?w1k8fAzqCRaQs5qzIMSUJsgEBd4cDRYiL3m1SPReLFFB7UWEXg//pFQxg5vQ?=
 =?us-ascii?Q?HqHpNAA3m1D5+a+nzVPbQVdDL+VcZJbJYQTmW6/dVgd7oViGz7bDkCGp5Y5T?=
 =?us-ascii?Q?oycwS2sbtzZnBpk0HBBo1JvREuXS44a8TdAPo+5tFAmph22gQnpkBa5Zj5PH?=
 =?us-ascii?Q?PaYl4B/anR3oQedwRGI46G4VpEF6XhE3/sVAzsuJRCtMu0lsV+zBuKurf+RU?=
 =?us-ascii?Q?ntWpSBKV5QkpN3tgZ+2hh2yIKHYWWQleBB+0dmE0lb6/B9kuZlr8y5ARfrjd?=
 =?us-ascii?Q?foDEvDyLn539z9g5dRXGNQEvuzhqDyryxB5kKBrg2JD524cKkgCuPqAYOVsT?=
 =?us-ascii?Q?Zg4cCGQv69JxkFDSFafsJ44LnZ+SFB5Fr+sXEB4HB7kFD1H+Unl3NKG5n6Y+?=
 =?us-ascii?Q?wQmercfmsuuDIXaHyVUfSA43bfimmUbX757L2RKm92RAdnLV9qe7StWV4zDe?=
 =?us-ascii?Q?OK/KFYEhwKTspJtLJqJ0YOu0DSPXB1h07rG9fbFe0DwuBnOyBjboOO+NEVQJ?=
 =?us-ascii?Q?g2aPFi4V9X9G/d7zwbDM6rl4p/jaVg9tBt6gsvxcHRye0H+HVpyExoelE1ZU?=
 =?us-ascii?Q?G2HV/2aUqx/Y4oD4OkYzxzMX09q9h3PXjrWOG3GNY6aliigNfm2YDyicMfbG?=
 =?us-ascii?Q?IE38FobhqVIBbMgDrGOVPW4Ic65leYTt8Y8vL8gsAiudrTXdXX/nF35ZexgJ?=
 =?us-ascii?Q?xuDYAK3J9F008njVd9QwrY43dchqWXjUMzz8CCjsllEkll3n4PCPYDdN5JMw?=
 =?us-ascii?Q?YgY6IITv6NZAuxMLMWErcy66HKHjwwQcJcO4dR/JgeuU9V/imZsQS2tngP29?=
 =?us-ascii?Q?hJeT18016+stZT1CYIfGMdVLujFQWoYHTSFcjsRc11NTMqZAGLIamxdlZgac?=
 =?us-ascii?Q?OPoxEoBGXtup6gAcBIHDHfGhuSAo/4CCD4EQ5gt7lc2mBbvrmkS3oymi38ZG?=
 =?us-ascii?Q?mwtx1Sy7vxlnF5H12HtPo1Q9KZruH7TuXLoL66AeDmGmAtAUiVBe1ivjwrPX?=
 =?us-ascii?Q?QvNW8+1OPyclZ05pLrQsKb2I4Oaun5fbhJXxlI41D+kBGW+A7CX2+PhN7m/z?=
 =?us-ascii?Q?DvfqKUUxYxLEX545tB9nKRz+fNyOzq3eAmKOgo96deuYgj4MZrywIb70U5tZ?=
 =?us-ascii?Q?qE2SHcnXziNHuVKW410dsjNg6xCC+AiPt42k0tZqX5BOylNaqs+zSGHX1Oj3?=
 =?us-ascii?Q?43m7K+8Lsqh6GTRbYRsF8idrHI1Id0TKW/cRYO9PWfl25WhpIz7Z/fnaNI07?=
 =?us-ascii?Q?QO+n3EJugPQ1dd4qhK07iIxd9SkXd6B7xX95tFxR5p/M8ByukUqc8suysmkI?=
 =?us-ascii?Q?KohzC2XLdul+uFjdGPiD/ENEe+gXjPHHL4r52skOP+63vWbLM+3ggCdlCTO0?=
 =?us-ascii?Q?h7eYQzspzE52vEq87pA2HpVFePBIzJywPoZE+cK0G/nXxQ1T9adJE00tq4o/?=
 =?us-ascii?Q?y/8kN0TASRGPte8S7F1BzlalZWrmvDwCkZQG7lTEPSq0A7EV8VImtZNjmeDg?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kOhU7OcN3zPakQkcJTLuL9Ct9fwdl62d5GlRoJ3/VLAFI9dyoJBu6hw3PUS1m/CHyUrp2j3koJKZcVNUaCb2wwqtALt72AK917frqrvgkZ6jBjuZs4OGJh/vhoQ9A7Np6o/SBNAAbDBDXMnb4mTvLH99c15zZbfzUNDoUhs50sh3I3LdfcbsR1xqM1GmV4BErk05cTPK1JPQAXNntDfaJTsPl8Yrs867G2dauqTB1W+bgDhBPPxWIwHBISuvKPyOl7+hOouRgVdqjbX7NeJLwhwR9cr2HWOT1d8KrqyQeGRaU3+IfupxLI42xVde+RydW2Is/JpvwlyKtpWRMlPraZZQeVYlfySgqJxoL28DMGtIjOWmcfO9uzqQ9aBq2A0pgl3Dmd7OwbK8NinUJTwkIujzG+KSh/+ZG8kKcJIUC0vakUw38LBvBMA61eZa+ZoT5hyIEslzGfKzgb/CkkDoMYeyeq+QbVbUMNpTfE6ezN0I9iF5lWvcDGek/H3vu3JWW912ySNjnZzcu12cQDXS6os0XqsHRfe+eH6fICrGnVuCpuY7W2MvqBObk4yKkhCM4Cqr1UIcAW46LLkRaUJ3EL7u/G/HojX2OzCYfsIrsZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bbeb018-381a-442f-fe9a-08dd5ac54de7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:36:02.0604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtQrMh5Yl0HZMfjcBK0GvbLKqaPZtr7rMLUZ6gsOZA0UzUMN6oJQySOdmV0vaJTaxWmz7TUq+8cK6vj6LU31aDNG+s46inR/rAGKhzXrotY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6889
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=847 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040020
X-Proofpoint-GUID: bQcOoJcqiJ0ug8GlG1ACJMEgdLLT_VYk
X-Proofpoint-ORIG-GUID: bQcOoJcqiJ0ug8GlG1ACJMEgdLLT_VYk


Thorsten,

> strncpy() is deprecated for NUL-terminated destination buffers; use
> strscpy() instead. The destination buffer db_root is only used with
> "%s" format strings and must therefore be NUL-terminated, but not
> NUL-padded.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
