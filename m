Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D4A466AE8;
	Wed, 22 Jul 2026 16:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738498; cv=fail; b=AVX/24bGwhrEra1t8dR/orlvUfgwCsoF6AdX0oL69iNPxEFiX361UsCpdK5qeB9/d+bHSQUDlLCTSh3piOpcDLTEucKkIyOeVH21tRQ3RDlqsfpDvvtbyffBI3ZY73WdBGp9Ui+Cx+nZ63YBlwjY7+ss+5ViQpIlTkuevPEUnvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738498; c=relaxed/simple;
	bh=htjfprO7/aQETlkAwSh7HL37XZ8XsYjf12H1KmnMy38=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pJM1dhzzSN3qQmk2DH+IiR9wPuD64LlDCKdGAxNx1WgD2oOT5Kk4NHsrG5CnlBMkLOMPpVJmnK95nqoyv4KQQLjzI+b+eUGhniKSko1a4UvGBm5hJWgOaXHkcVtL7tmex1PjrVMuZ+M5fELN+t7Yv/8sVykoKo25/TYuH6Tz+7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dhcrXCi5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ps5sldso; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dhcrXCi5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ps5sldso"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MCxplX2753472;
	Wed, 22 Jul 2026 16:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dEpm8XXmvUY74/B7YUnc/LEthYQO8ekZDx3hFrhXrHQ=; b=
	dhcrXCi5seh4nRKbsgf//8eImYuYQUO01dZDD9DHvOfhUpTvZWzY9QFtbeJX5rUF
	DZrFE6sBD8yKzoIkeTFEkjqgnDSbiXvxflfmcjfr/THTESkWBEZBmzXQ/v0XlISA
	SgEx4XTciYbXRoaUyewzoDFJMJgUnYUsjDXzu50cwsGKgVIv7kjVO4zlJvccfUpb
	ZOn8YJVNGN0cbKPEHsaoSa/4gw/Rf/g6ZtxP6F4dXHjoskEykv/Q5m37xCs3b964
	zmruNCAV+hNrvobspj7lgpWWsLVvyk68OV0t+E0e6dgff+4psAMcoVi6O9WnrCjj
	O+4I0RhT77l2093kVLemmw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kpwkrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 16:41:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66MGc9WY021469;
	Wed, 22 Jul 2026 16:41:19 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010048.outbound.protection.outlook.com [52.101.201.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxdup7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 22 Jul 2026 16:41:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FwS6GE4GEQbeEO+FRpko+/bz5O0BsNCxkOMJ7SNYwije/P11Al/pCeNl+uwaxB6VpBNNzQxQzl3SvzEeDSdXHCQTmaV27DDXSgdOh3tbCovZk6dBhD0b17CL0FJI6HJ7nc4aAUBs3jtTaluHCudxbX0PAKEJzawYlYwV2U6gwQj9vP9AfqaNyMZhkk6nz0ax7kQuOz61OMDZQ8bu0fOo+WnbZ0he/fwAJezKkHH1JvHGQnOsPKbQ3kJ4sx6LmQPOvBW6mvZkRoRNeeDHcJqCIJD8HT2pYVCXo6tcMLsm5Ms8FglYZBipDsPLJqqnikampAo12cZ/lESAIn/fTIp0Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEpm8XXmvUY74/B7YUnc/LEthYQO8ekZDx3hFrhXrHQ=;
 b=jJaKbpgkSihWNz26WfD2xmBPFsnyE7GdfJ3C2XvwD56S3hLL3kStNcFCbiom82B+2yVo3KR69oqBzu4AQZFhmCDUZpxoyefPt+/HCODRSI9Pg7DgrFwfuXXMWN7Jki4yHMDC1EFEvW9DQfvvKrWFo2mlok+xbCNUZqNkKn3jnnzsoPq3nSPalbIHj5PyRU9dl6pbKDdyDWrJROFH9DzbWzFNDFhrRi6d6atC4lp6cMqJj6k/9GCos3BHfPoV0X6ZALXezisNcsr8Da2kgGd0y2yWfSKXmU7irYInyJFM1z9KWem5b+EBYlA1oP6TVp9fVj+5PchrWikOte2i9i02/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEpm8XXmvUY74/B7YUnc/LEthYQO8ekZDx3hFrhXrHQ=;
 b=ps5sldsoYGbOnKYkOEpCRHDs2q7+xCEc2AD4uLqgfsWHWP5RxV2VXOrdUPoAM9q4wKImGFXyQe+wAQFJ/weRIc8xLSk+0lmIXmz35KdHyD5FalARR3XRILBv4tD9OVb5IwWAXtk3xM5VKHScJxg310FkNhQM1QeJ9hC/MQczGtY=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by SJ0PR10MB5695.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 16:41:15 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5%4]) with mapi id 15.21.0181.016; Wed, 22 Jul 2026
 16:41:15 +0000
Message-ID: <bacd0bb2-08e4-41c4-ad17-968e359e19d4@oracle.com>
Date: Wed, 22 Jul 2026 11:41:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: Clear cmd_cnt when initial counter
 enrollment fails
To: Leon Romanovsky <leon@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS1P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:8:454::16) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|SJ0PR10MB5695:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d3c10ef-d972-4702-0022-08dee8100be7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lypr/q72yVUFo4ByqmV4VPD1BdjsHhPSbDh7GFWPC01/DZo8aPqSVji/1VwDxa0pRyh5wE2u4zBNCn4p6zaD6+0q+u68PBiZPUMXQpGwtEWseGcOraRKWBFqa9pn/o48LF82SAV5pJ+49GtoaPcIhIK0ZuUSmNAAVGkAJAPsl5VszdVYJDpbcw00bZzS1feznogiD7FbwS2iIux0tXA8NerIIFVYm8eh9jLLvwfmu5jsFYRsPiZBiH1X3s65+sFbAGneIpn/+N055xDpU9pHJ/VmDX/diO6/jdrITKhjATUNHSQvu3RbHk6idBT70+1pygVnYxbp6kSgqQcNgwTmTsjWabWT7bJvEsCgJ8p2sBecg+wlY4kG2ia55C2coZOquZ9d9aZ5LEqEUVLm9XEVz7BI0lXeAOidtWSoe831EyyFBEwPteZLXQHy1jZmKc/c8f+mBDlwEscCUjCQ2tgPHoO56GBuz8nvvUQxm++JSdUqwVBjEn0r0daqDrfHjp+lxvGDN1qiTnU1H932K+JfwRt+FXO5JuYW9I0O8ohEmMiPKPkEPvpx5pfO4bkwExnEwfFc4BoAIG3dDxvLs+4/YyNkRQo/irT9jgCyy3/gvll1kO4q6KFx9KpgDG5bXiVr+Cx2oMeH3xTWtGPgrlOa2/DJsjh1E1pgEOPV0M2eWsk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anBHb2llK3lzZmZmTW54TXFVTnVFbWJ1WkZhRFI2WXdLSW5QMDZONEUxSWJX?=
 =?utf-8?B?eDZKbWZRMytkR1FuTEgvMlU4VmF3V3EzSFJNandKK0tBY0VqSUhDQ21YbHlW?=
 =?utf-8?B?a05zYWNwNkVhdUpWeWFzbEFwUE9Sb1ZEN0NiLzNpWklNZWFOeE9FRDJiZzY3?=
 =?utf-8?B?emRrQ1Q5MDd5TFlwN0FHSVJaWHMrRTd2WXp2blpPSy91QUl6T3IzNlFkaFlC?=
 =?utf-8?B?SThwNnA2UkpQSGU1Snc4TGVBUSs2OGR6Z01meHJ1NVBUWXd2THBXSk1jUGdZ?=
 =?utf-8?B?SWVxNnJqMkVUdDY3L3J4RE1CM3p0RHVIaVk0bVNzU2phMmp6empldkJ4bllu?=
 =?utf-8?B?OUlST2xRS1Y0K3dPZXhKYzg3VDdPVWEyMVFwREVUUlBqQ29xUzVXNkg0MS9a?=
 =?utf-8?B?azNwYjRGdW9jVEVWYzY1RnlHblZWQXVYV0FuMDBvZHlpbGorc1ZTcjJpNXhI?=
 =?utf-8?B?WFZlWXgrVE9EcnNkaklXZVp5TFEvM2JpMnM0MEE3Y3R2RTlkRFRCdUtVZUpl?=
 =?utf-8?B?ZFJ3N1hWTVp2dVpBcGFZandoUG5vcFNNanBuUEpNMlV4QWUvQy9mSWpGRUgv?=
 =?utf-8?B?WDNEOWg0SnNyVVBGOVhHK1lOMEhkMEFBMkhtRHlBNTZLT3U5Y0NjemgrdERn?=
 =?utf-8?B?ZXRvRkpHNzZlNHZIRnBhclk0dnc0RklwcDhJZkNEOUhsemQveHR3K3NSOXA0?=
 =?utf-8?B?VjV1UGJyeVZqeHFYMmU2NG13S2tIcERocWF6cmo3dGlKNk5jYm4wREdVNTdp?=
 =?utf-8?B?ZWtxQ1VKWjlwVllhUVY3cm5OOWtRMzg0eW10b04rZmZwYkNpVDVGaWUzTXhG?=
 =?utf-8?B?UTJiTmxvRkt0eE5LT3pBS3BsN3F5ZCtTanNndktzNGlwU1pCeVpkTklzcDUr?=
 =?utf-8?B?N2d2S3pRTnhVSFpiVlZ6eGJ3bVd6YkZkZ3UyNWlXZFQ2MXl5V3FDQzFkU2xs?=
 =?utf-8?B?b3VBUmhaMDVLTy91Misra3lGYVRmRGFKb3FQaS9LdDBObzhHanZ3Y00yenAv?=
 =?utf-8?B?YVRIQ3VpaTRWbDFGdENjYmJVQ3BjaGhJeEgwU0dJR2N0bzVieFppc1FRL2kz?=
 =?utf-8?B?dndvV25mL240SlRPRlpVREErRERTVjhQU2V6VTZBLzE0NGpmdythY3FMMGNi?=
 =?utf-8?B?NzRlaStOTWt1cU5DUFFHMXI0MTdYZVhOTVpYazE0Y2xuQzlod3hYejVlU3RC?=
 =?utf-8?B?K0dRRS91VStkWXRCcytZMHZJS1VYdHEyaitCNUFOS2dsWmpUYzJuQ3FQVzBw?=
 =?utf-8?B?VjJUK0JvRTVmei9IenJkcE51UHVndXFSSlhnY3RXZFQvd09hUTR3MEZLckxr?=
 =?utf-8?B?aFRRMFFjWUtwdU1kaE1Xd2FHL3kvNDl3cERVSUtmNjV6ZHdtK0tLM0dVR295?=
 =?utf-8?B?QUMwWXk2OFNVREkyYitzd2lLcEhpaThOcUtuRDdZN2pUMHBYU2hQeUp5TUQ0?=
 =?utf-8?B?RHIydXdaYno0WEdJV1RkUldZcFNtM3ZSSzdJQUhHR0pQZlRkemQzUUU2Z1FJ?=
 =?utf-8?B?MTlHVDFPdnQ5ZjBPQlRmclgyVTJqdmJxeldOQ040ak1qa3g0ZnlnL0VnTzRo?=
 =?utf-8?B?VnVRNmVJaE1NR0pkM2JTK0ZRREt3akxSdmxVQUF6enh2TnJvTzJSRGVKWXN6?=
 =?utf-8?B?TWN6d2JrQVpSK3FhcjBiTHFVdjE1eXhLVjZrUUtJczNESlJzSlJwSDBJY0RH?=
 =?utf-8?B?OExUdHkrZjNmaUZYQzIvWHBxdDVwRDVUV1dxQUd1MFV3RmlQSVRDZHpINDh2?=
 =?utf-8?B?Vk9mKytiSmZCRGxkRWsramwrM1VvYkROVWdOcCs5R1V3RXp2Q1FxRXNrVVJC?=
 =?utf-8?B?eFlBOEZlRHRERWRXSjIwUEIxKzZGRmx4UzAwMExadFlpMDJqM0RRUHFycmVV?=
 =?utf-8?B?amVUWDVHYjhUMjZjQkNBSERFNlBqTS9IMUF2Z3d3VlB1a0hkb3grTkphcVhS?=
 =?utf-8?B?UUovWjRrR3l5bGxaR1oxMUIySjk5UC9scjdvbm01ZnBjTjM4bTYwTUhXL1Ey?=
 =?utf-8?B?M3pUT1FVaHBsV0J5QXIwYm55Tjk1SzJZR2YrWE5ES2Q3aWw4cEhkTGRhRUZM?=
 =?utf-8?B?QzJKbldpb2xiNERucUJ1OGVXZk95SG5FRkJabENpQmZYTWVTWUtrQTBxclc4?=
 =?utf-8?B?NUZNSHpoakdlV0E0bzM2emFnLzVhMytRalJ6cUY0eG5pcjZZQ1B5SmZpV0Rz?=
 =?utf-8?B?c1d3YkFWVlAvc3ltK1lML3NuSXVoZXdpWlYvOHVzb0xRTVNQMHpPb3pIamlo?=
 =?utf-8?B?UGJ2NTNZWFduUjkwd2VkRG5UV2VSZ3YwZC82L3R1RU1GTWhGZEpKcWxERm9Z?=
 =?utf-8?B?TnpFemxFY08zZUpQbHJIUVBZNEc4SHVwdXRhL0JNelZEUmNtTE9KekpkYmxQ?=
 =?utf-8?Q?f5cZ7IYY6g6ReIko=3D?=
X-Exchange-RoutingPolicyChecked:
	o24PA9l6gnK1XSxGpMTl5DYXMk9dK1oYBVCNq/jQtNkRWc4VnhtpLpQdR3cb+04XX5lTX6X7TkwwpSDUgi+4Hfyibbpi4vmvXF23dQyPMtbTiZJIcGdiQDpC/78K4zKyQt/oXpItA0FyZ5n95ppFaKaPicklkWFvL9JV2cPRlgZxaNHQaMOqrxCup4It34kV/aIbrSWlLMx8Cuq4ZKsClbSSGdo5ieHyrm5C55JTRQFIstZXuaUjyA8GUXaBO2BdGj+4m0xB8JKD4Q3SdbB+3hP6MjAd5BWC+1jPKd2WEfbXrVE+5O0sK0fukjzWlxU/qYd0N1t85CG0afbQgQDpHw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IGQSX11Y7NM9WuzgHgQeMXO6I2n/QyzLzK5DXz4m+CUM4qAbCw0s6cNR/XIZ7SjTPmoQcutxC/NNLzseaMxtzRU1MxzNKmHgRHZaab/kPD/caHyPp1Cas51rOarIC6uJZkAULRS8vP479ELUdXPxe7dReG0NRmuZJSW8QH6hJWfyZdEOTDvWEq+9GRE0gr7wqC9knzBgDqoPKlaW+6CCQu1c6C8quqt0NYrGMhMUs6rLXAosLkBabKvd9vmhiasLcytQMhrv2t69kJ/XScR8Ci8HRymB29uKbG0pcP6UXKAqdjsbhf7u+rk4Kuj9pKJsxOopuMRjke77iKb3nniRETOskb88CLtJEtqKZ3mc5MKRMTSyioW1nsrr2xWNCwwVgujpVFT7vXkkwDcFVNVY00KJ6yvujt6zUyCdfDAm3zKfMBdZqZut3t873+NldIqH83b9SuWqXBf5H5pRyOFzQFNzKyenY5n3qeJr34refbjlPDJNENSUQU+ikxJ2A52vCHSJxf+Boiy1aRJ4xaTfBGgmAPcY+Ps+dB4ztnGaC4SSoxvbwab68t8T4AfuhuYyX4Pf8CFVqfUslJnYNX4WOUWu832Slk9BTRn+J3C+eTc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3c10ef-d972-4702-0022-08dee8100be7
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 16:41:15.2719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JJ5w1HyFo3KgDzAOYMJH14PC0G+UzPd7B5O93VW2QuUyLeWO1ocSnwF1JbfrLB74VkQ94ybAnke8q3fYyGr+MB505uoeOM9bUrAvPpBqRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607220163
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDE2MyBTYWx0ZWRfX0YY4ixlfNA4K
 nXrEx3/JKf9llo4QDSfk8HHcLoLms7T8MzpIabJyEgekjrh8mWFHVEK1ualA4eeaZ90+KdflO+f
 MjN4ScmPBpYNdtMeejb+fP/LJGryQBWcHdkGhm2TpoOZPklW8kgh
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a60f2af cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=Ikd4Dj_1AAAA:8
 a=yPCof4ZbAAAA:8 a=sT1sXzYijU2ArR0aqBkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ZEq9DjBAYdavPqYn6kSS2ikxbw_is_EY
X-Proofpoint-GUID: ZEq9DjBAYdavPqYn6kSS2ikxbw_is_EY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDE2MyBTYWx0ZWRfX/v1nFZm3rQmy
 uic58ptdc+4cu0Z9oC0mMQcxGlrglTo22LVw+uIRT3yW5j6F00UQWbVmV18+678olsZvg6n10x8
 V6Upxmfae+xHneczNoCD53ixYhra5l9uPUUK5Z9wLHogFcXJ++YXyphj2odm3szPZBXRlF93v+f
 1XuUHY0ASOzEqSsLxd1yyAkmbmkVerL/JluzAlo9qRD0k9r9175Pm1cMnprrDZpUmUuzV1nRmEx
 YkOk80QYNgDNhFvmIArR994mM70XgXDyxY/KLY3K4L9vNJxqSPpcoWblmL1hD2rNFXT/oDYkdmq
 dPox9m/CxcH3AbxyNwexEuVYnlaymxLDMXqbQ3dF9D1y3jLmeF/2L5TnhYzkgsLP6RvVBRIXV6u
 njyRxwvW7QFS+6ofa4kAx8IRiIsuh7vxkkHs5Z9po9IVDGKKW3U01byWwze52sHLmU0MdRxsPMQ
 iFcn6eAdbtZda2Y4iYQ==

On 7/22/26 1:30 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> When target_get_sess_cmd() fails during session shutdown because
> percpu_ref_tryget_live() returns false, the command keeps the
> se_cmd->cmd_cnt pointer that __target_init_cmd() assigned earlier without
> owning a reference. Final release through target_release_cmd_kref() then
> issues an unmatched percpu_ref_put().
> 
> Commit 8e288be8606a ("scsi: target: Pass in cmd counter to use during cmd
> setup") moved the cmd_cnt assignment ahead of the reference acquisition.
> Clear se_cmd->cmd_cnt whenever the initial target_get_sess_cmd() fails in
> target_init_cmd() and target_submit_tmr(), so release performs exactly one
> matching put per acquired reference.
> 
> Fixes: 8e288be8606a ("scsi: target: Pass in cmd counter to use during cmd setup")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>
