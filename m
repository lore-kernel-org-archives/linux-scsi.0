Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D97547052;
	Wed,  7 Oct 2026 00:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791332653; cv=fail; b=VeX37vLJohZ8uF7Mmi0/s6WeUBiWHTpk7tntyirEaaVCGJE1nE72G1xG6wMo5b1yNSLCtvL9GyU/8OQhGfUW94XtMKaQZgeUtejp+aDIyz07y2cMbv8MjErHu+dFr2oTnRLnZSmV0tgVyeUlT+lHysu9S3zGbGC9BC6VrZPxwNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791332653; c=relaxed/simple;
	bh=VreMAOxFxrmNQPlB2sXj7ZdQ01LV746xkfKNpk02liA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BfCo9xJqfMkFD4RbClL0pFmignYFNaYQaUoqPhl5Ioj+VKqdle5gu+7YTbwPSCMAUTlCvfLmB6YL4Yp9P3QgNyZGei1p9v97G54zKbXTtGAgqSkUsU6VGyojy3aE88S2pD5LkHYAzLTD3nihSfsT4M2zKH/BES7BHhy/Dti+oA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WhhxIcrg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nRx9fSSG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WhhxIcrg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nRx9fSSG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696LavmZ900730;
	Wed, 7 Oct 2026 00:24:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LVjc4cMBgZF0HMpl1SuVaHpvDInMi2VPrYPcERREaTc=; b=
	WhhxIcrgVKAH194LRvdrYO18P/BXqE/eRHZ5bSAyShDuBMbBJu+K516+Kw/MssSx
	BsZMfXgtE4o47SQBP5aPGN4+Y6vzTTekvEWG2Lm7bfvV0R3rgCLuQ9YW6559nCVe
	gmH5KlgXMp5CN0j974CAKMa2KbsvigwmLMRqYznKajmaMTUFiBt68Y5xBoXuOCPx
	npbn8XZRa1tOLoyZkAKkcYHTfUk7wfjUNfMUfLdaIuJCqGsLefa6S+w0mdQNu1nz
	oZJVdCkliaYZsBOjJm8xuVwUk54B7FHfOQvMHExZ5PZoQ8db6xMfPe/nWkE/4vmH
	gBm8z9P2KHxNRf+hV+7SJQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2rg1vw10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Oct 2026 00:24:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6970LfUX040641;
	Wed, 7 Oct 2026 00:24:09 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012054.outbound.protection.outlook.com [52.101.43.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h4cxk23c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 07 Oct 2026 00:24:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJIYav1Xud1rYucYrYXuCBQou6VVmH4JnwblZsVOY0RHCXxbzG/UQxxgn+nAi2TWxNxJep8Sv3n0zxN8LASdXvmotoJ1JbPYTJfNRx4qFrfg4HnRpgkIlt0cfDe3i1K5JCIFAwCyo2ZvmwUzlJvq2m7DAXkkkbO/CAN8I/k0OY2yRb756l45YvoLp8/m8FHawQahEYG1B1gyJsfewxOX4jSW0KV45EdwClSYJaEz7TkGdnrnoyCqYiXEZL1jzZMR2snsdpN3e+8jQAOeEqfo71h0Sw6vR/YbWuf/LtpQNxLY7N8ZcHvFS60ooy/SjKBfFkp9ZjAlAe2TDPDHZcjtZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVjc4cMBgZF0HMpl1SuVaHpvDInMi2VPrYPcERREaTc=;
 b=tE7K4QUMtSvjNaCKIFJ9x5/XNshR1LYzmoaCzy+y1RDdPRpOL/fC286m44WamPNCM1GmAVUkhvZ1HUJkBSDVq2BHvD57UXHkcCQZVlxgFZGUm7136Lvbas1jmO2P9Phed0HRSZTuiLy2F0dAH1V10Mhhnj/5PTY1N5p/+W1lCRQ89DNaZzKVWG7ZAjwrw2g6vBmyvoiLrl2jDW0wFb9IM8wK1Bqb+CYHVJ1+4RXDSSy2yiqwZRDpnq4fsfzpPW5vaa4IGf3ZVE9awTnHux/r3DlG3TQPNOCI063iH9kYGMNfNF7xJ//bwRZZKJp8PZYur+irE0d6Da0igE1VenPc7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVjc4cMBgZF0HMpl1SuVaHpvDInMi2VPrYPcERREaTc=;
 b=nRx9fSSG4H6lSi6owd4SVdNDcGNtX9tdUCG1boancSy0l8QXKz/pz8K6BDbgmb5EnB55cFl+sAar1csBbHfT8j7YGqHe3DmPGHPl5i1Hif8yXWVkXCkhFD/ZTM71/zNu5hnwoPc7uMxqXyQYO7pbYZpmZ9XB25QjcHfZ2MBkWxw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by DS4PR10MB997575.namprd10.prod.outlook.com
 (2603:10b6:8:31e::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 00:24:07 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120%8]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 00:24:07 +0000
Message-ID: <c3b38eed-ce5c-4123-8d14-28e01eb24f6c@oracle.com>
Date: Tue, 6 Oct 2026 19:24:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: iscsi: Fix race in discovery auth updates
To: Linfeng Sun <linfeng.sun.dev@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260811124843.6817-1-linfeng.sun.dev@gmail.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260811124843.6817-1-linfeng.sun.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0053.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::27) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|DS4PR10MB997575:EE_
X-MS-Office365-Filtering-Correlation-Id: 07a6e431-03ea-4ab3-cb5f-08df24094cae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|56012099006|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	e1byaiA/CkqxPRydrxkuvU09b4LuN0QXm/yplqi8gBFtzoahIjJOsek8lupurh+mw/GFkfx3aiiczOkBA9ZsdbE6c1FJ7CmNRNOaSOLNHnK36HUFtqSLsnBa2CVCVJAE9V6hoczX9ud52bpc75vWXJZKP4ItxR5J8Vs6awQKcPkuxwMQXj37wjONIqIkVoTThdELcOpQUJ1w7D9D6/ecL63HwY98k57siVPwUyc4uS96mu6CvxI6LR1gsWSb1l8xJE20i7YnDRJ9y1XtIziQ+GJ2iP8oZiHCDuX+ub5v4GGGweuH4P7u8qIdZQWQM7BDNcyK8SeRJPSGHxv8sxlKG1Mq6Nx9x5J4gNfFs3pdy7Lx2ES2zx3udaZI+R0yOIU4Pe7mhv4NVSUrbDmYyppUYbnSdR7bu5IMYKT1akdiZW83+zbywAOrrRUzGnfLfd8dj8TeVl6bmWzcjWLf/QVqtwB4ldfcDIu+z1vJkiLvD5F4rv0qldpbVTUNUo01AZdfY60UrvXc03NNSGZeZDflkKja38LBB9jvGxEpFaIDCpbGtPr3gSUA5JMUmI5l6Xr9u2jj2Y2ev9DEofq4VFiMXDG7SOiR5P18h2qOEhIZS8fe5HIPbX/Ap1YDhjhT1pSg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmFsTE1NWThnYzc1bjNFdlNONUIvc09qUEVRNlZ1eU5lMCtPL3YrdjI0WGZN?=
 =?utf-8?B?eEpOdHJRMDROQzhkNUp6OVJaL1lPRTkrOElqdmo1d2NPQndNUmJLYXdsb1d5?=
 =?utf-8?B?Z2dQa2Q3QUtuWlZ0SXhGbFp6RERrVndCNmlLaUZVUGxZc00vbkNGUXRsWVBh?=
 =?utf-8?B?OGpsYnRiSWcxeFU5STkxbllFV1hhbkl0dTRIUXpRWmtZUGY3WlhSNThPQko1?=
 =?utf-8?B?eThiTUFMSWJENml3Qi9lNStRLzVHU2pLUWdDYXRFZCtwL3JjNWE4RUJGNkE2?=
 =?utf-8?B?citiYVFXdTlZT2Z6Z3AvbTYvOGZwN1dJcldrRFcyQXJKZVJWT1FqYUtOb2J3?=
 =?utf-8?B?dHk5UkhXZm1pUDFtYU5ram5HblFaQSs0ZmZsVEt3MmFTK0swTTZ1aFI4WmR0?=
 =?utf-8?B?cWNWMXQxczJWanhXT1RJQ0FlSXgxOVNxVmtJdzVoVnpadkU4amJNejhLL2RO?=
 =?utf-8?B?UDZBOFh1U3F4cFRRRWpyeG0zT0NjbVdYUVlzMnk1K0pDcDN2dHF1N3ZvOWR0?=
 =?utf-8?B?SERTYXJXbExqWEhQbW5JR0xUNlJIUEdXZ3BrMFdFUEsrUEVZVDZPUHBlQlgr?=
 =?utf-8?B?VmNEMVNNRjVBZGUvSHdsNC9FZEhLYUlWTENwN2pnZWlYUW1lZFBJeUZlZDBz?=
 =?utf-8?B?Tk4wOGN0RUZsOTVYZ1F6Q3FPUkhtdzhuOHB4b0VLYUFXYmVtRVlDbXRsS1d6?=
 =?utf-8?B?bG1zZTI4bnRpKzRxN1prbWpCVUNXSERVMXpOcjFTeGEydUg5alBYM3hnSGxE?=
 =?utf-8?B?STRSMG1WekxVZ01oWjdDdEk5NFVSYVRjemJDMzA0UkxSMjVCZW5lOXdBR3Zi?=
 =?utf-8?B?NHBPa3JwZFpqQWd6MDZ2NG5lOEc5WmFZNmRWbXRuWEwrNk1qZVd3YldYL3lH?=
 =?utf-8?B?S2cxN3pPK2cvamFGc2ZQemh2NTAwcVBCRG5TMnlZZHI0T2U2ZW4wdDBrRTVv?=
 =?utf-8?B?ejdSMHNhUXVZREs0dnFiYU5tbGthZFVKTEVSUmdLVTRJbEZnUGZRNlc2aUlq?=
 =?utf-8?B?QUprVkRhcVpObWNnTnZpem9aR2R0bXErZkVRS1ZJTW9Eblg3TXg2bDBmREFY?=
 =?utf-8?B?dktVWHg2ZkdabklCNkV2S0RmWXNrRGYyekY1bVp1Ylk1VlhsL3dtdEl6WGtD?=
 =?utf-8?B?QWpGZTFtenRjK2hOZ3VZdHREMjE5cVJVUXNwR092WnJnYWNCek5uTkU1SnNF?=
 =?utf-8?B?bXZ5bmFxQ1hqVitOVEhzRnl4REQ3WjN0NG5MZUVjeE9hT2doSjYvNVV2SHdz?=
 =?utf-8?B?TXJQamp4R0tuK2ZzSWJjYlphdEJGSzA2WDJTMjJ2TUlSNlhwTVJsekFIVEFW?=
 =?utf-8?B?V0MvdGlFN0pSWXh6akczZnpNa3NkUXRybUFQSGZPV1dvMWRBOTdwY245ZjNQ?=
 =?utf-8?B?ZjVBVFAzSGNhcmVkUnVGV2hIVTBCaHlIeFh0aHl3NzJwbWFhTjFWQTc2U1NK?=
 =?utf-8?B?UjV2cTFGdXhLYlpkZGM2VUJBdTgyVjRKbmlRQjRGWngwSVN5OVIwaWhlVW50?=
 =?utf-8?B?bld0RFdlRUhFaTRTSDZoVmdHemJQcEl2TGRWNkVxT0Z6MmlMZlpIV0xsMHJ3?=
 =?utf-8?B?LytEMTEzQ09RaHgzVVZieE5MejBjc3BqSmp5bnZTdEtyMGJrUmtZYUoyL2or?=
 =?utf-8?B?NGplRFNWelB0ZForMWhBTU5wRVE5N2RibEdsUys2TnBaZnl4T1VhaDlVM29v?=
 =?utf-8?B?cDJTYXBhZ2RYcllIUEd0ZUFoYjdmWUZMRklhWElnTGVNK0FDTklUV2xkOSty?=
 =?utf-8?B?bzY2SEE2NXRlV0I1cDFTU2l4eTF3M3dNRFpxZWs3SEtDb2xIMmZKYnFSUThr?=
 =?utf-8?B?cnJqREs5eXlSVFFXeUloeVdld1BJUEdXSlkrSWNlWlVuT1ZyY1JTcEdUZmhB?=
 =?utf-8?B?WTl0YzdlUXp2SHZJREkvdzlsZ2VZcUEveS9VaG9VbWswLzFFQnY2Rlk3cVpU?=
 =?utf-8?B?cHhuUE1ZSFE2MU8zMzVnWHpPanQ0NUo3RWUyOFNoRVQ0QzdmQjBVQlNqOXQ1?=
 =?utf-8?B?VU5taEJ3RHBUZzBzK01XalJ1ZXBvQzVmTGR6aCtPMkMyc2IwakpiTXp5TlNw?=
 =?utf-8?B?cEJXRzdkTnN2VCszbjIzejFvN2Q4ZkQzNmlWZ0JFcy83Y3NtYVhKMzR6bEtq?=
 =?utf-8?B?RnlpRk8zMkVwWndCZGw4N3VlL1JFbkM0aTUzeUREbXUvYyt1ZURFYksyMTVV?=
 =?utf-8?B?WTZWTHdLbFY2WDBvenpxTjF3aHlkZ0lEMlNKVTBrN0x0bFBSVFVQSWZwaW16?=
 =?utf-8?B?UDBTNEQwQmVwVVJtTjQ3RHVDNFFtOVl4MnFFR1E5WHdLa092cnVHT2huRC9D?=
 =?utf-8?B?V2NEV0EzZjg3VkpYZ1ZZVWd5ejVJQkZhMmVhK21CMUljTHo1YTg4cmhqUnFt?=
 =?utf-8?Q?YhPyavvmdoMupGAU=3D?=
X-Exchange-RoutingPolicyChecked:
	I5wrOD19RkZKywPheexPVldlwxVBS6IrwKXOOEK5Ea9jBuJa84hv5XOQBCpmPyxKcg4LN730jORcP88J++t53L0G+d4V8TyNcbIXXDXRD3O5yafZWhRcytm0A5CQJyZDyhOzqjEFkaoYXdDmYbdS6zrHAFUdtt1dsd1wuIvRI2EEKv79zMHSG76g9E7HQLoBe3P23jBsz1aFFVPY9+goUoSzY7HfOTyKNKdCGYE0ChCKaF6ONX+h9t8Wyk7JSlN+Wm1+kUIP7octuYgp2UNLCNOxbhtWZj3fA+fEwwKoHteuKkFMyWE9k6bs+8rNyapE59LH+pna5dOarT/35SNxcA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	saqAD4C5oSr0Cd4dFRbBk/faJJRRs2eVTSKLnZhRXi8a9HlB4szajsWT/hlZzYV1pp8CkIUEyJcVm6T8ip1dybNnwjgLmkMydUSY3HArxmmOiPV9UqIZVwOl+YLBZZBdujgijXlbEqJQhzUVkiT7pP1BDWcFrcTimktuREfaupV5XYwd0sgJClhJd5z2OlrxAF9c4DuoZ6nkeir//tYhuKuZbY8KMX47hqrHdwWZoxChp1p3zc60aehyyHEcmgW+jZj1YlNtYTBJwSYSS6j8FmaCYo5996mOL8MJJaPTjJVRQmdBziwec3tYb6waETdt6r2gj+EcXSnPPjH1MuEgvpT8laFWZiHate0D6V6RpT/dIyYgLWoXAeiilfYm+i+QljRkuijLUgvFMyBJdMPfR/EIvAy2ueAh8p3BGvpg3ZLT4+r/12Jd8wuGoVFeNyym7fNAddBp34UaNq1NmeCcos3og15e1bi33OIb4vT8AHBizWkrEx+CVaX/n3T4Qq65zu7OT3n5carVjA+/gRQRd6IqLP7Gby8/NQVBVn3H4hFtDJM9L6EVyQcHzsNAxZbWBpSroGpmkZmBK4ixOqngfIsKjPTULd+PW0TDy1XOtOs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a6e431-03ea-4ab3-cb5f-08df24094cae
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 00:24:07.1346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8gRTEilBtY3oYHTrr1PnpVlJpDF5MUnmOG4p0r8lhMxYo5wcydLunq2TtcuFKMYLrnvXB88KGVoUxwyKyWTb1V2rYD/tcthKHGeZF45n4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997575
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610070001
X-Authority-Analysis: v=2.4 cv=afj0Dhot c=1 sm=1 tr=0 ts=6ac5912a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=qWHg97fRYGoEoMJMrQoA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13537
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAwMSBTYWx0ZWRfX/aVBf7HFgjx7
 S1nD+8HHtJIuyLIYUkrAW9qYEsJ6O001Gn/MAypw3mWNWp6eDkGIwGZXqTmG8OdMRBQqipaOclx
 DAbrXFDhzIANjKWA9gv9YTMxWuqLWV8sVYMbbxmdaT7s2i7f8Id7Vj6+WyvzpB0J7Be4mItVzID
 db+HgTVcF8/V8auZPyOBghBZ9UrCerlnTmhU0d/04H2A40OUgLNCSZrJo7NLHCQllkKZVd0mTpR
 C/0EehvsZ8AJBU2zFGpKo7I5DkbDCGzsJpMNrKLkZLwUms64WnquEhdnyj020xhb2xcEDSm02Ii
 MCXP7giCWCaFprDPn8l8v4FTdm8lFXpJEF+EzIBRLUuVrLb+FMMO8q6q8ApjAA+/Fj7gTW58HNu
 dlxf/WVwSPHf5wVPHllhsgizdoBRsVV3mUwHj8QAaDHD0xcmLbxp4lLpfrqypWu9eiZO7mpMppO
 GdmEvcOsBgp3byrRPVQGIraLnk+fZBza6cAXY/Zo=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAwMSBTYWx0ZWRfX82XEqGl81z4S
 t+Ro1UEXM0ralNDkRAufAkj3q2vyZOE3s+5Emp3cFzYtz1RmvZ3P40OuCEF6hpyC517F5fTwGiN
 c+HDDktcsGuyDeTGHWtens49Xe952nBe2wO6fUz9wTD33hFU1HX8
X-Proofpoint-GUID: K_xTe6clwea8uZwhKzFbSlMUyWJCIzax
X-Proofpoint-ORIG-GUID: K_xTe6clwea8uZwhKzFbSlMUyWJCIzax

On 8/11/26 7:48 AM, Linfeng Sun wrote:
> Separate configfs opens can concurrently update the discovery AuthMethod
> parameter. Both callers may free the same value in
> iscsi_update_param_value(), causing a double-free.
> 
> Protect the lookup and replacement with the discovery TPG access lock, as
> used by the other TPG configfs parameter updates.
> 
> I dont consider this a high-severity security bug, but for safety as a
> precaution, I can provide the reproducer PoC privately to the maintainers
> if needed.
> 
> [   53.935693] ==================================================================
> [   53.936125] BUG: KASAN: double-free in iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
> [   53.936725] Free of addr ffff888012e355b0 by task a.out/319
> [   53.937027]
> [   53.937120] CPU: 6 UID: 0 PID: 319 Comm: a.out Not tainted 7.2.0-rc7+ #3 PREEMPT(full)
> [   53.937130] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   53.937136] Call Trace:
> [   53.937139]  <TASK>
> [   53.937142]  dump_stack_lvl+0xd0/0x110
> [   53.937151]  print_report+0xd1/0x630
> [   53.937161]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [   53.937173]  ? kasan_complete_mode_report_info+0x6a/0x210
> [   53.937182]  ? iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
> [   53.937327]  kasan_report_invalid_free+0xa0/0xd0
> [   53.937337]  ? iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
> [   53.937484]  ? iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
> [   53.937632]  check_slab_allocation+0xee/0x120
> [   53.937641]  __kasan_slab_pre_free+0x24/0x50
> [   53.937650]  kfree+0x170/0x480
> [   53.937657]  ? __pfx_kstrtouint+0x10/0x10
> [   53.937665]  ? iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
> [   53.937813]  iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
> [   53.937959]  iscsi_disc_enforce_discovery_auth_store+0x18f/0x450 [iscsi_target_mod]
> [   53.938111]  ? __pfx_iscsi_disc_enforce_discovery_auth_store+0x10/0x10 [iscsi_target_mod]
> [   53.938263]  ? __kmalloc_cache_noprof+0x1be/0x460
> [   53.938272]  ? configfs_write_iter+0x3fe/0x560
> [   53.938284]  ? __pfx_iscsi_disc_enforce_discovery_auth_store+0x10/0x10 [iscsi_target_mod]
> [   53.938435]  configfs_write_iter+0x312/0x560
> [   53.938447]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x30
> [   53.938458]  vfs_write+0x71c/0xe60
> [   53.938464]  ? __pfx_configfs_write_iter+0x10/0x10
> [   53.938477]  ? __pfx_vfs_write+0x10/0x10
> [   53.938484]  ? __pfx_mutex_lock+0x10/0x10
> [   53.938493]  ? fdget_pos+0x213/0x5d0
> [   53.938505]  ksys_write+0x154/0x290
> [   53.938512]  ? __pfx_ksys_write+0x10/0x10
> [   53.938519]  ? fpregs_assert_state_consistent+0xe1/0x160
> [   53.938532]  ? do_syscall_64+0x13f/0x640
> [   53.938539]  ? __sanitizer_cov_trace_cmp4+0x16/0x30
> [   53.938549]  __x64_sys_write+0x77/0xc0
> [   53.938555]  ? prandom_u32_state+0x13/0x180
> [   53.938567]  x64_sys_call+0x259/0x26e0
> [   53.938579]  do_syscall_64+0xf3/0x640
> [   53.938585]  ? do_syscall_64+0xa8/0x640
> [   53.938592]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   53.938601] RIP: 0033:0x7e9dc22449ee
> [   53.938607] Code: 08 0f 85 f5 4b ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
> [   53.938615] RSP: 002b:00007e9dc19a4e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [   53.938623] RAX: ffffffffffffffda RBX: 00007e9dc19a56c0 RCX: 00007e9dc22449ee
> [   53.938628] RDX: 0000000000000002 RSI: 00005a09e22de04e RDI: 0000000000000004
> [   53.938633] RBP: 00007e9dc19a4e90 R08: 0000000000000000 R09: 0000000000000000
> [   53.938638] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000021
> [   53.938642] R13: 0000000000000000 R14: 00007ffcf2f464d0 R15: 00007e9dc11a5000
> [   53.938649]  </TASK>
> [   53.938652]
> [   53.953000] Allocated by task 308:
> [   53.953189]  kasan_save_stack+0x39/0x70
> [   53.953404]  kasan_save_track+0x14/0x40
> [   53.953617]  kasan_save_alloc_info+0x37/0x60
> [   53.953858]  __kasan_kmalloc+0xc3/0xd0
> [   53.954073]  __kmalloc_node_track_caller_noprof+0x24b/0x630
> [   53.954385]  kstrdup+0x62/0x110
> [   53.954567]  iscsi_update_param_value+0x4e/0x140 [iscsi_target_mod]
> [   53.955055]  iscsit_load_discovery_tpg+0x3fc/0x6e0 [iscsi_target_mod]
> [   53.955545]  0xffffffffa0479430
> [   53.955724]  do_one_initcall+0xd7/0x660
> [   53.955943]  do_init_module+0x306/0x940
> [   53.956165]  load_module+0x66c2/0x90f0
> [   53.956378]  init_module_from_file+0x192/0x1c0
> [   53.956626]  idempotent_init_module+0x274/0x8c0
> [   53.956883]  __x64_sys_finit_module+0xd3/0x170
> [   53.957134]  x64_sys_call+0x106d/0x26e0
> [   53.957354]  do_syscall_64+0xf3/0x640
> [   53.957562]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   53.957851]
> [   53.957946] Freed by task 318:
> [   53.958122]  kasan_save_stack+0x39/0x70
> [   53.958342]  kasan_save_track+0x14/0x40
> [   53.958562]  kasan_save_free_info+0x3b/0x60
> [   53.958802]  __kasan_slab_free+0x6f/0xa0
> [   53.959034]  kfree+0x23c/0x480
> [   53.959210]  iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
> [   53.959678]  iscsi_disc_enforce_discovery_auth_store+0x18f/0x450 [iscsi_target_mod]
> [   53.960236]  configfs_write_iter+0x312/0x560
> [   53.960478]  vfs_write+0x71c/0xe60
> [   53.960669]  ksys_write+0x154/0x290
> [   53.960865]  __x64_sys_write+0x77/0xc0
> [   53.961075]  x64_sys_call+0x259/0x26e0
> [   53.961287]  do_syscall_64+0xf3/0x640
> [   53.961490]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
> Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>
