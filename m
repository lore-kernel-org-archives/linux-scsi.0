Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A883A48CA;
	Wed, 13 May 2026 07:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778657693; cv=fail; b=ec6Vix55EO618XMfw7/PfOaM0TsrySmmqXwoAMHLenocLKwNCsXX7DeEgDPRgnu8QospSphit6wcUxJBo9aXcFSDnfMAxhauT45Pu/nCs5zuLCk+K0AbsmS+KFPPX81rEsHfMMUT19TBctqfLiEdM6mSbvNK+BBRFeDS8+JlbB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778657693; c=relaxed/simple;
	bh=8LD56lz3MHBH1d6q5a7jhsFF5HBEO7C9xwJ9nArL44U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YdmTeYT1imMV5HdEdWxI6jh7RDx+fPM8i/a1VXMloWnvHY2CrqvT7xq5lHzfGpiOonmG4EqAd+P1Iu5L6u5KLKNG0/ZX7Tx6wd4KrxjmnPADTV6F4rrP9eKv2pv7uq8AKp7zh+WNu4Kg12ljdK73hxlA8Kn1vu+DcEL145/tUNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NMZhZOt0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NyHvsVCj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NMZhZOt0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NyHvsVCj"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D7MaPi3346885;
	Wed, 13 May 2026 07:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=s+3MoTAInA5qlFvaDYPzGASeB2U8aqsolBumLtauZng=; b=
	NMZhZOt0cs4vgAj3fKcOvUFBKBkumpo62W7zR3uVp/YUJN4dx+BBWtZmtQmKNln7
	uyOXUPKBpzQ+AWZRgrSRts53Ab1XrmerLhlTxZoM0hXVzfTqE3/NdlrhKMRC12pZ
	R21xBGCWk2BvSmSkwq1Ui7gYG5AiPYRqJMK/z5qSCxKoYxScI7ERD7vdvgPEVLlB
	LFS6x8P/QwCMM8XAPXwhe6V8hwApur+kBkjzPAGAQPmxB141jgwhpnMiYFjGDxfz
	5giAghs02Fg/nZm7iJtRol4Q2fK3MggegNdIvGOnh7aisxaMlfbc2FJEqy+TMvCX
	ihuRrttsnfjbTnc8jCN+Jw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e4c97rqax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 07:29:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64D7K1cP005339;
	Wed, 13 May 2026 07:29:28 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e3nej35qg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 07:29:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y14N0+cRe68fUxiBn6qymLRoFhg5o38/xhfzDtJbHjzG7UrGvHCoVEwd/bJh2fP+Hy831ww4/cKRMPMc9FQtVnQOUYeDEVmJ2oDoBHaJfZUYGIF3IjXdNN3dM8LmuHyrGA2LCX5QqwgGrgESwYvNVavd65PBmBVxyrrQIpQT2a5YhYmkJfEYHd8hN5tfhR/SvgvlPzrmXG0rLM4HXSbszFzRecoKorYkjyCEADTlF3z56HGfdUMFW4eKdQCKHpKYqTbHn9lfLdG8h80Nin/ufrYK4BdDPnXAXGCR09td8Jvid5AQ5d+02nW+Seq7cUNFkLuNQdTAJ6UXCY+mYlqxWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+3MoTAInA5qlFvaDYPzGASeB2U8aqsolBumLtauZng=;
 b=TRSY6VK3jwSzPLpoNyEAIf7bia0Ao4ckSJpKpFQs1AGuKVDBUi7OloYNR+oxk09HFqdXH0qcBhP3GLlLnhG+HF2qoOtwl9XcjTiHgf9D5Rj2aSlNvD+lY9aS7s66qpW2lN8q2ktF/S3oC1eXJUnGC9yiiRh5TRjmXAW84sCZ99gMJSlaw4vE/XQwQAFyQ2aNRvJB/iNajHwTCmw9nH2sFkaNkeaJIRcyc/Sa4dUfhFzmVSDjtGthju+GO/ABhFOAHzk80I0IIKnw77nzS+x3SXqcwickx0kote/F6muNVjkAO3a0ZgL6te4oePqkfFV9aMdrTjjjJfS/8h7/wHymNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+3MoTAInA5qlFvaDYPzGASeB2U8aqsolBumLtauZng=;
 b=NyHvsVCj8KV0EpqfoW9KE8+V5ZYxIlqiqUHKZJk/OTo+mgsXWfCUrIwn61K9a4vWpumBGXAD5o+Urombkdq1nt/5UYZXEU9xhq/M3f4W1r7h5hJkjs+jpz0Nh50LS3NsfcpGMUyXjzgTKwIv+03XKwjQBsMqXvfievyF6fvNHVM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DM3PPFBB10AAA58.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 07:29:24 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 07:29:24 +0000
Message-ID: <11d3560e-d956-4f0d-abc6-2ed897e0ce45@oracle.com>
Date: Wed, 13 May 2026 08:29:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] scsi: libsas: handle linkrate change in
 sas_rediscover_dev
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260513021603.3023329-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260513021603.3023329-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0323.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::24) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DM3PPFBB10AAA58:EE_
X-MS-Office365-Filtering-Correlation-Id: 708cc647-b1de-41e7-4056-08deb0c15afd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|56012099003|18002099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	quz8+nJWloQN2nxb4jC4RVQbG1qn+h9+48GvbiCO4x9gQ2NaQJycXMD6mXqJkcOZefxWm3t9LT6vGuA63nqM36yWmnR+vOrUDNzA5ngq9UlWDiAIjIXsEFKNwfcLkyBsHfc3XrrmZeHamptnID2tsPsp+t6+Qe4T0AwIPstheYORWq5XbzRRFVeoogIGUH4vGLSL5Zn7Mmb1U7DCKOsf+J3g2946MR1xTIQLwUD9Z6C0UZ3/zMlbRJiLDO2c9Wp/J0QXPD5tPsYDVsyBMqJr16lxr/UKpEF4zWvlQGGSWpTkYE0MCpvYkDGgPpxoeYg4bZ6dHEZoamkthYP6y/6a3711zIdWpK2m2dvacDvsW+J278zbwAk/6jE8uhCeTuoO/eRaeJrkWcWzFRAcq0TUPqi/qvA6F+lw+2a5TUV1Zz3mkLpahE94npo84w1JvYeDmKkrEFQSuuB2D33F0U9cjbpFED4m7q2KFfYgMYSj0n+bSNr8orPXitiZ+Gn0E/UPEpsowiSVK8p51dLn79lLETPrvfmbb4wzvvz9auba0Xu9RkWyfwf5pAcRaxdAe5lVs+HMQbF/Hsz8cDaeiAz6+yRpNrS7cJycY+c+67YTbuHDQpkDFL6798QgdJXPFir3miw6LviK98KgfNLL3L9BsREpCPNr9YZfz6pvdUxMQAFwe+Fk397Zn5yq7zdqkthY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LytFYUJYU1I5N3YvLzBkZ3dHL2pOUTBUNlhYWkZZd0V6ZVY1SEtQMWJqb2Mv?=
 =?utf-8?B?cHV6VTF3aE9jMmlJLzUrVmg1dEpPV3BqVHNuMDQ5M3QrdHFsTW5lYmNsMElH?=
 =?utf-8?B?MFdaa2I5ZXNMSCtnc0JIcmQzWWFUZEpjMXV6U1hLcGpCZ250MEFiQTJRZE90?=
 =?utf-8?B?OWVTTmpLODlXa1dHODBhUXh4K21zdkZ3TEEzbXlLczFaU0oveDkzUmJSb2Uw?=
 =?utf-8?B?RHMvYmRlbTVHUUppM09kbWZlVURwWnh4Y1MveWlWcjNvLzZwTCtnb1pmUVFW?=
 =?utf-8?B?ZkduMS9UVS9YaUZybWphQTZhMFFhVDJ2OGxlQll0OWsyL0NXWXA3SmNYWjR2?=
 =?utf-8?B?QjI1SXY3aERPUnJIaWI0WndpWGQ3MjdaMmhwakd0Ni91aFdiK2xaVnFEemds?=
 =?utf-8?B?UE8vS1pwa2N5UlZmWGZnVWVzbXN3WS9iazVmYWI2Smx2aEZqZkV4eWtLR05B?=
 =?utf-8?B?TE8veGU4bGx1dlRnZlVNb3I5SzJaaWRmZTZ1SDRqL0Fid0NuWU9yUlhIaUlE?=
 =?utf-8?B?YjJBR05uMDc2UjEyMGFWTWZYdUM0V2EyN3o3aEppUlU1V0xuWktpaHlGSDBF?=
 =?utf-8?B?SGE1c2NzQ20zL3ZBdWRRZnVkMkQzR2xUOTNVeXhJOUNZTDR6TlNLU1BEQnJn?=
 =?utf-8?B?ZFpyM3JEdERDRUhEaGZNY1dSOFF5TGZaYVMyK0d4ZW5YdGhVc3MyT0R1bWNV?=
 =?utf-8?B?WlBrK0pESFJPOVNZM2xvTHU0N0JoOThJYUhMOFIxR2R1QllKQlFPamNGbUVL?=
 =?utf-8?B?UW56K080SkpzYXVmZFk2REJ6R05GelZWQjhlZUw3RzR0Sis4cUs1OUFqRVpR?=
 =?utf-8?B?eWFtVGN6c2NObHIzL1A0VUliTTdLdTJsMmxIc25qNlQ5U3JnSGRoZ0kxbnl6?=
 =?utf-8?B?WUE2WjRQUnRHV1g5QWZpajdpS1lGUGN5Z2k1YTRDT0xWTlp5S01XaWF3bHNv?=
 =?utf-8?B?ZTRaVS9YYk12clFYa0VkY09GTGxWK1FFSWhLcmkrUWx5NHBTTUMwdkkyTlYz?=
 =?utf-8?B?dDE3SXY2UTdpa2sxeTkxQ1NyVS9YNDRnRXNRUVF6aHVhdkFtTWN0WVNNellD?=
 =?utf-8?B?ZFYxRHA2TlZGMDNYYkVKaHA1K2Rod0ZoanZxcnVXMVlPUWR4UlZ1d2F3NXdl?=
 =?utf-8?B?SFUrQXcvK09KbnhQS05rb1lWTlJ1cThrNlZLclNuaFVRcDNLc2tQZkdFNVEx?=
 =?utf-8?B?MmtkZ0RJSWJsTFdNakg3OTBzMjdyYTlkdlVwN3lqdm1SeEZRZkxIT05QWHRj?=
 =?utf-8?B?M29nQ0plVkJKWUpFNStqNGRDbWlXWm5ESG5YV1dDZFUrVWl4b2Rud2RrQklO?=
 =?utf-8?B?U3c0Zis1TjhBblJ2Z24yQ3VYMVM4bFFucHVleS9Yc2JPcENSSnFOUExNelNq?=
 =?utf-8?B?NmJVOHhqSXR6UC9ZOFZJTlV3ZThwVitvOVNzUEN3Q0RYMkFkSG9GWUZ4aEww?=
 =?utf-8?B?M0FCY1JpT1NNOFIxcUtncDVzUjh0VDZBQWlWQWFVOFo4S2xSalBkb2RVM0o1?=
 =?utf-8?B?K3M2aWV5OXoxbUVaVmZWdlBic25LWWZhc1cxWGlvVElrdEpDcDZqbC94a1Y4?=
 =?utf-8?B?eUFBVDluOS9rMnhNY1NYUGRsa0tqN215c3VaQzM4d3Y4VkxlZ3ZlM2J5ZjZ0?=
 =?utf-8?B?RXBCTTQvbm5UQjdYRTdTa2trUTBCTjNhUy9SNlIxQU1lRFcxNktSODV3dW03?=
 =?utf-8?B?eThIcFVHRktseFhVdms3K2hYMnRlWHR4Y2ZPUDZPUnVaVmxSOHdJaEZpbHNM?=
 =?utf-8?B?K05NQlYxTDVBVFdRK1BGTlBNaUR4MVZzeTJ0bEdJenNLWlJlOGNhamFFVDA5?=
 =?utf-8?B?aG1KQnBPVTJ2elBuVWZzMEFKeEQ5aWJuNTdLNlB6OGhZcGxPcWZCRUF6Yi8r?=
 =?utf-8?B?ZjBIb2w1UHFpYlVra0RGVDdpSzI0TUhEQytvSURmUWpzYktiVnRiT2szLzdN?=
 =?utf-8?B?cloyeDFTU0RuTUVmQnlaTUVqVk9WMEx4UUlHT1RFU3g1Vy9YWklvbzFpYVdh?=
 =?utf-8?B?MFNNZ3RsQ2RINnk5VHhkZEhmR2xsOXZEMksyeldudFJFODhlVGpYM1FHVnN2?=
 =?utf-8?B?QWIwYm5GVnlnanVCSGxBZmt2VmlMVm9wbjdVQllMZ1IvRlZiSlpiZEJtYXl1?=
 =?utf-8?B?VUNCU3hjbmYxUnBzS1Y4Vmx3Z01TUzc0OW02NEF3bnRWRmpkeW1FdzVKZCtU?=
 =?utf-8?B?c2NzS0dhREh2TFg2ZGttckI0cjlQWkkvQUxxbjVoclNTbURwc1J5UnNoRndL?=
 =?utf-8?B?RTNxL0plYzViQ1NsczFQaC8rWmxuNzBDemVhZWlabUtHcW54aGt4Ynh5Q1Jz?=
 =?utf-8?B?NDZQOFFrNkV2Yk9KVUZhc29hR2xsN2dqUEROeVZLajVsVEhINTRNQT09?=
X-Exchange-RoutingPolicyChecked:
	t0DWJK/tJqGOenm8JUGFWbIRduN2O93YBDSPWIlAaPmysAHm6zdOl6LFUeYAwrmO4TeCLtF6PhvRfgB66/0eSeLrtAaqgladY3WjyHYtv59UFucIWS3GSSEKET5sjp2xbU6OnmRvVm5MagSN3n0sVce5QcC6pvagQyPLkHKc/8V58ZZJrC6XWkO0rL+fvzEFMwcbBORDeTyPzULVrvJS56H9OEBeelKj+//k7wNCVTuE0avcwVtYzjUxLNwSZi/pIlXseGLA+E6vh2h7yGK3rwL2sTgnlG3YsC6fFEd8fByFXDUskSp0P/QwenzVJWoVeZWL/pBYhchYZpYkVP2AzA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t1ntBC+nkoBJeTOgwU/yOLWllG0ULGqIQGnunNXz9pb+lf0re0tOzdQNwf7GgW4VXenN+KxHuvKTcz+bIrKbXWiWGqeBJhvgRHgXzrk8wV1XlMHx3EemDEqJ0jYl3aRZv9ctAa9fiefD3jPvPswQwjROV11U+Ba2IQ0933NEg9KfrS74J+CrnJLZ4muVadPrFqf4wKzdfSXgfNwZl9wJb3W43CTS7kAdPIcCf5xoX5GBKpgWj5iNr01t8xi4XePdLnF6Qg/gRb0ZNRu74RIRk5OD9s5IiiD0ds4lVf+XvVJdSVgTpbEYgm/TqYWXHpZOzi8YQx9JUSOSkMLuXfL25HTc0vnL2j1FmFI75Hz/stCZ94AZVsOpkgrQcF82XgF+LGjsRFbtERmLLKa1fQpL4JU58PeEV02Mb1gfi3A6gcSbEiWdL9QhFEa7bf58viUJapUHeX1uxqtvHW4Se3XcDU3KbpvS4D9gfJLgujB4XhcsOlIb4bG8MXwPZ6/tAQXptcR5scQruq7J9v2owTMu/bKFonAfW6Qwrt7pPYBULPe63hS+b1FNDS+3wpRFIVCay9t1BxNp97vxnyYD06698bLWEGkT1cQNbg0nl+m1Qvo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 708cc647-b1de-41e7-4056-08deb0c15afd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 07:29:24.4564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APS3x4e/cpuqYxYq6zdLMbfZQIIGOFTdP5GySqVzsJSue9Xtuq/n9I86ZofmtkkJvH4536yC2pn8+Xf51MTBkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFBB10AAA58
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 mlxlogscore=841 phishscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605050000 definitions=main-2605130074
X-Proofpoint-GUID: enB-gjnB7MfYa_OpLTsCJqNhmqHOeemI
X-Authority-Analysis: v=2.4 cv=AeCB2XXG c=1 sm=1 tr=0 ts=6a042858 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=E0cOIkhEQl3n4nTqmO0A:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12299
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA3NSBTYWx0ZWRfXyV0ylHJ2q9DQ
 GZNK3cW6XFlRYfZo0m4LszAHHGI08e/b5iLPhBXBkuk88y5ssfOeH1suk1z8J/ZoggWXUY+6BFA
 LNfyPTq8Aiy0MCokakM3ef2A8e+7ej4rx2Uz7UGAf08F4YK/Ba4GtsWVS00rdMTzAII4GWyYACW
 cGsFfdo9AK5O0PWrXD+tCKNjXevRQxiEKzwyNu51IBVrmaLneu2ZBJ9foLB/xZOcJSK2swQsF5K
 AmSBhMy0OIfmxPnjfnMkQw++LLee51tVPp0EwY9EhEwXTnk8ODq/TYlH0U0LkAEagVQXpIZz285
 jhvhxwEW5C1ENc1AwrwDhbi1FIEb4xkIbZa1x2096EM3jVjjf6pJngCglbPUGXsh5Fb/SACzaGP
 t3K1wwtazAtRJ1DeJPPR9jxC2/+YUAAD6vS1cMiHgPpb8Q21gQbaP2qz2eXpzzdOe/777NjI+yJ
 3Jlz0gEDEZlrBqq+M4rHl8/9r6i0CgbjPMq0XYtc=
X-Proofpoint-ORIG-GUID: enB-gjnB7MfYa_OpLTsCJqNhmqHOeemI

On 13/05/2026 03:16, Xingui Yang wrote:
> When a device attached to an expander phy experiences a linkrate change
> (e.g., due to cable reconnection or negotiation), the current code in
> sas_rediscover_dev() treats it as "broadcast flutter" and takes no action
> if the SAS address and device type remain unchanged.

Can sas_rediscover_dev() check the linkrate (vs expected) to understand 
that this flutter has renegotiated the linkrate and then consider it not 
just a flutter?

> 
> However, for drivers like hisi_sas, the ITCT entry needs to be updated
> to reflect the new linkrate. Without this update, the hardware continues
> using stale linkrate information, which can cause performance issues or
> protocol errors.
> 
> This series introduces a new LLDD callback lldd_dev_info_update() to
> notify the low-level driver when a device's information changes, allowing
> the driver to update its hardware structures accordingly. The callback
> is designed to be extensible for future device information updates beyond
> linkrate changes.
> 
> Changes from v1:
> - Split into three patches.
> 
> Xingui Yang (3):
>    scsi: libsas: refactor sas_ex_to_ata() using new helper
>      sas_ex_to_dev()
>    scsi: libsas: add lldd_dev_info_update callback for device info
>      changes
>    scsi: hisi_sas: add support for dev info update notification
> 
>   drivers/scsi/hisi_sas/hisi_sas_main.c | 16 ++++++++++++++++
>   drivers/scsi/libsas/sas_discover.c    | 12 ++++++++++++
>   drivers/scsi/libsas/sas_expander.c    | 25 +++++++++++++++++++------
>   drivers/scsi/libsas/sas_internal.h    |  2 ++
>   include/scsi/libsas.h                 |  1 +
>   5 files changed, 50 insertions(+), 6 deletions(-)
> 

