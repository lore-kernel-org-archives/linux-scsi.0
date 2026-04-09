Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A9040DFA6;
	Thu,  9 Apr 2026 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775739721; cv=fail; b=HuR+mEDNZTV/pU67Q5OwtG0lPekl1JlIGDl0oIPptuGRYAG1MJB6KLxRp3kZkdm5f/jAZwheI2JCpNql79rGwxIn1s9lTUn4NSjHf0m/d/EHEkHq/Suo09J+mAxusi9duNBPqpGQMtJsUP5qr0iMlkQ1IkamZl6ngufUR+VXKTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775739721; c=relaxed/simple;
	bh=1sNrSKP/HOD3e3++OzV9k1Vo+iRSq/U2TqTgdhYrUzE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M1ysA6fRbc6QjCusCBk9AOPJv/5gYl7+h8VMlAKnPYmLtzQQ8WozwNh+hH/PuHa0CGSs0KFaxtBAnbn0t83tgY6Q/Ibs1iLqrXifGV/5zkipSrtTGVYQ17whAWVOM/FvnHg+7SUunwVV/76M3iKdT1X+aNwI0/R9QUfiZhxtJ68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JoJXHoXg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u+ry+4Wm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JoJXHoXg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u+ry+4Wm"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639BjLhF2240411;
	Thu, 9 Apr 2026 13:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=moKbhU6RpUlRJp1qPopVMiwQmi38bvYS+/6MifxMMx0=; b=
	JoJXHoXg9Sec5JbRBhBi/R60AT0KlVT1NpwfvB8QT4MwvPuKrbFjsqOc7KU43axW
	ibPpAlNi6L2e1AJQ6XZMXVY6czXnO7JgR3xb3555Tl0JiX94to4robeJab1euRXz
	kLnd0H6NzNLH3aH4FQ1p2I6osd66figVpdUXQpuGKhUCPs489+lZSi5+91BtLFoi
	fHkdU3rPExfoWXTwb/3TeoAgcTDh8Hh5DWyyd9gizptVoCimc3DMT3y2NSlwFnfE
	+Cyi3ojrQocYbIwKk+u384rJZlpVYL5Ax66tey3Avp7MKeqTg3zyemOQbcExDtCq
	w9C/XC37aq/3jWA7E0l6cw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqaxrv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 13:01:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639BZWxo005196;
	Thu, 9 Apr 2026 13:01:04 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010058.outbound.protection.outlook.com [52.101.61.58])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ddgxrug6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 13:01:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GbAJTH/EwDPKpqFN/SuaMSh15BkrmtCDb6CPwW5uWxtNnlRRas9uvBI8Czs/YuiX9gwZLUpAJuakUoFbFfkbNq916zqd1gGE5j2p6EqedT3R9MwrQAuLY+yjt5Bslk9MRjT5JzDPcGdmy2ws9t30sOOrmEXZU/LHFBJfUl4AQWzs6q2hHYZs4dhLk42I5nNZNjY0fzD4ohDqUhlTWU1WcfmNECjsUfr1ye1uw9DTHyXTOcX4/IocOn4UBy77H1H0Gcy0jdjbFudtY5eC/T64YAHaITWtZu+q/1i/T8jIX9LRTNI2S6W58oHuu6chQ1vlAVXeDihP+t4DGt5Ti6nq5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=moKbhU6RpUlRJp1qPopVMiwQmi38bvYS+/6MifxMMx0=;
 b=Tqc9MX+AT2pQhYXN+m0FpbeaMrvYvjhe0WvX/iIMkAdAq0C3W4+J3TI27T8PgbMbg6UAN/Da2mn56rucZ1RO5GWrtpnKbLkXaoHn7F6z2VzQhCxr3sx0lQLIxndI/FrXI70RfW2Fk5eJwB82k49kMNRl/2IVfXIzV8Y+T4zundRU/wDyZ37FQXnNZhhS5WOqrdcNpK2lVOa7lmFxLcNROKP8ZXhx70Ux7BV0VDFA2qZhm/eTkmk5lhx+Vhov3TokLRasVNLUf158A/GqjGcAPd/HiteL7vUEJSJEJEKzouqgN6Fh5jYvg31OwDcL3M09Mer1vzSTW9bcNrpt72mVhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moKbhU6RpUlRJp1qPopVMiwQmi38bvYS+/6MifxMMx0=;
 b=u+ry+4WmETbzdWNIHlRTUGmXNIAB1fHpv1H2/fA1RayIo5+i2oMCvsMYHaIIrUN7/c5l5YOsGqZvNYE1UhvO/RhrqXQYmLGDOD+boqFw3I4dsQ0P2yiZOBvrNZzEdRDodu+/zT1028irEJfeG29fhqSadEIDfJOuGI7mxLpXuPg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BN0PR10MB4855.namprd10.prod.outlook.com
 (2603:10b6:408:122::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.42; Thu, 9 Apr
 2026 13:00:59 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 13:00:59 +0000
Message-ID: <ccfc867c-e744-42a2-9b22-47245a6c06d7@oracle.com>
Date: Thu, 9 Apr 2026 14:00:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: Nilay Shroff <nilay@linux.ibm.com>, Hannes Reinecke <hare@suse.de>,
        hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
 <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
 <74eb1f9b-265e-4264-9575-177de6c924a0@oracle.com>
 <6d7a4076-a4ad-4185-8e82-8e27d704d20e@suse.de>
 <c5334a6b-8089-4ee5-abd3-8340133db29a@oracle.com>
 <79725a83-3dc1-4398-ac86-c3e317e0e107@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <79725a83-3dc1-4398-ac86-c3e317e0e107@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0127.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BN0PR10MB4855:EE_
X-MS-Office365-Filtering-Correlation-Id: da65b0bb-ca86-4c9a-3a50-08de96380bc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ClsoHs64NOVXARMBTJkroBrpgK4DGLiPeLsiGra/d6pKLfTW3EfJOYkYjfhrPDp5lMd3O74OIjjDSmyFflRsVVHUcJXH6TtxDisqN2D1MX6ifMgCe5aQPuC5P3PMIS6iwBeuiKHJWCsDspt4678pg0YOqdn+hLz3fwXsYGbs89InFm6UzX+oFhWWrvihouTR2kzSoA4KuqdjPFDl8rFHrMbLQVG+1FO1MMQYeL++H4uZR7tXNstySZssBOulQ9VtpLJITlabGyhHdwk8L5vW40RxjMWbn+TbkLtOZoTu7fRVLynOuSKDlGJ+LI50n2eVDqNXaLEMOjfR7YXb7ESN8PY6FwFD+5cgC6hyenNOMWH+Cgy2pnl6Ugo2/0uY9yO+G0dnXWGnrW31kh8d1+5dAAU5iG5bQVPmOZ6rZJbiQKCmPkqmRmlFV2IIUZ8nm+psNJG4fnSk4AU0RcojcwpV46lYbxIJDy0GMxll/VU+SwPIRLaez/vVSDuU+HrmbotOz3jV66i+Hq1dK/24eu8lk9rl31yCm6nGkqWKbhzqczGQ3m9MLm7+Q/Lx+iTOXIUfEX7zJIaO7G80BoWPFktynS3GpNRTB83kdRxvpfhRMOyFCcYbuRGWDsHA34enLUsQuti6d2Z4l+vF7Ifay6V/zeQNzp6iXfKCpIbVfDG7Bgmd2q90HV+JeVqr3INQ8fU2npqPDvVhKshAR2iYdqvVGEHeII3KZIdn1vosS61u0/o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUpneXY2dmVwZGl1ZGJtYzlackU4UlVrKzF1UStBczMvQnBzNFlxa2dqNm9W?=
 =?utf-8?B?MkdWdU41REdyNVdUZklwWGF3YTRJN1lGTWhoK2FVNjU2NzlQQjN4ckdzc3oy?=
 =?utf-8?B?b2d2ck5FRFAxZWdXcSs4OUZ2SWRFU2E1KzAwMjkzQ2FNVUpra2U0UlI1czRT?=
 =?utf-8?B?OWNDNVRNdkI5TklzR1RheGNON1ZvZWJsbmtpbEhxRDAwQWs1YVNSaUV5MUQ0?=
 =?utf-8?B?L3NWdEsxOGsveHNqdEdlUWJwRVZuWjY5QVJPYVNsZDhPTkd2WmhhNVlZV1gv?=
 =?utf-8?B?QnZCaEkyTjhuRmFJL1hTU3dMMEExdDZHdzI0NkVMTzkxak5zeGZEalB3Szln?=
 =?utf-8?B?UHROVHltSVZvNldKaURpTk5DaWdmY2kxUU9QUmhaRzBRMWZscVNvQTNRbTlz?=
 =?utf-8?B?UkxXVndOc2VoUks0YUM3S2U4NkdQWE9PeU42RGNOSHFtd2JsVHZBTkhpaVJq?=
 =?utf-8?B?eTExaThJQkpIWlNUdUZrMDh6ZjN1RWRCcFpwYjhWT0R3SlVKZ3VGSXdUUGwx?=
 =?utf-8?B?aFRpT29kVmttWnNydEtiL2M5bnZXSUJYblBIVWZxY202ekZ1Q3FqNHFIUU9y?=
 =?utf-8?B?NlpEVFBlZ3o3bHFyaElOZWtTZzZHbzNKS2ppS2QrQnhkK2g0OEljdXBNem9S?=
 =?utf-8?B?YXZObXoraTZUSlFFelkvSm5vK3ErZ2NzWEdEbVFHdnJEYkhkU2x0VXRkU3ZK?=
 =?utf-8?B?STRIQlFhRm1YajJhNFJjblVQWk5hNmtMdWZWdVo5WUtkU0J2RWl0OTN2RVFQ?=
 =?utf-8?B?S1hITWpjN0tJekZIcFZ3Vi9qbjgrV3J5eEFHZk9zVUxLVmFmL1NneGlQSDFx?=
 =?utf-8?B?Z0VhTHh1amNoR0dma1hrd1hncjBLaXJnM0dtTkhFa1JMUGw5a1Qyby8zN2ts?=
 =?utf-8?B?a0E1a01xeHcrQjI2MldCMTJwRWpIOGkvQVVlNUd2b2V2cnlIb1V1THkrY201?=
 =?utf-8?B?SVg3dWQ4bERxS21FU1dHNVQwanQ0L2ZxUlJJQXJKaE9lTlRmR3Mvd0tlSFVj?=
 =?utf-8?B?NWYyRFplendsWWUyLzdFTVl2Y1E0N0FuYUxRZGdKSUNPYzV6ek9kQkY5bW4w?=
 =?utf-8?B?eTFGNU1Ba3hJWFNjU0JpdEs1eklVY0d6VXorWTZyZVZDazhCclREaXFDZjMy?=
 =?utf-8?B?Sy81SE0rNUd1eThtZ0dITU5WWE0yMUg4dXBWTWNjemFIa2tIbm9sTEFuMWl3?=
 =?utf-8?B?dkNTZkJjU0NyMWlualVnOHlpRER5aGRTWlIxQktaRytNTk9rYTJqYWU4N3k4?=
 =?utf-8?B?T0hPVUczVXM2NEFLNEhoYTkvazlDSi9acW9Rbm5MT3p0Ti9LbWNwQnZBNEhl?=
 =?utf-8?B?eGRvSC9qMlVtR1BoWS93ZXNoNkRGUmI5T3YzRFVqR0IxYnM2MXR6N0dlUUVs?=
 =?utf-8?B?bko4cUd2OFI0MllvR1JtMXI5YUt5U0ZhZUkrNjJOMWwyMVpNWXhTZENUWExP?=
 =?utf-8?B?WjZYb1JCdStvTmE4cmd6TVRZdXk4ZmNTbGUxUm5paGhxbFZQdUJwcVNYTTFU?=
 =?utf-8?B?VGhuZStNS0lsL1o5WC9sNmJ5N1d5TUIwWis3bFE2U255V3ZFdGFQY0FzbnMr?=
 =?utf-8?B?R20zTUVsMllRTEFkWWdrVENhcUdhOE5WMTlpQ3R5MmhKSHN1VXVBL3JKSFBt?=
 =?utf-8?B?dFNaMmdWOU1vdlJzTjNtSDFYYzZMeXhydkV6bE1pNkMycFlHSmh5cThFbXZP?=
 =?utf-8?B?eW90eTRiTEdmYWR5M1dyWUJ3Sng0OC92dG9UdUp4VWZNeGJVTTRDZjA4c2Ny?=
 =?utf-8?B?WEJ3d0NLcEtMczdrOUxmak44YnB3SVJYRnZSajFCZUJZek81Q2ZmNWJYQm1J?=
 =?utf-8?B?VVV0QjlGZkU5cDFLYU5mRlNRdnFuMjAxaGxHUk9HL0NiWVBUY1R0Tnh2REQx?=
 =?utf-8?B?aU5iWGI3aU0rZkh2ZnVYcEp3Rmc5d2FJVXdmdUN6QkFoUjNRaGFPMThpc2JN?=
 =?utf-8?B?a2NaeHBtK2d1dDBwbU5vYmZqd3JSSXdFVVBnTWQxNGJSeDRCeWFqbnJTUVor?=
 =?utf-8?B?Rk0rL0REKzRjcVpRY0NVTWhkVjh0YW1EbkY0SVR4V29Pdm1jMmhYQlc2amx3?=
 =?utf-8?B?S2g2bWpIZ2RyTkM0cDhHQW1XUFNLTFhFQnR4WTljNGk1R3J6TVpsRTBsNlNT?=
 =?utf-8?B?VTAzWWJydW5LbkhCOFhrL3hPZUQyTVJ1YXhwNGtXektwNGRjNDlmR2NJK2ly?=
 =?utf-8?B?RXBEem5MZlpKZC9KcFU0SVVXRU5zQ0RWNXBqeExMZkNCMlJNUGIzS0x6NVdw?=
 =?utf-8?B?dG0rMldFb2QyMHM2UC9yQlZhcUR1OFdRQlJIY0FvaTVaWFkxdlNBbS9JeDBl?=
 =?utf-8?B?eVJwc0V1UkorTy9PUHZYRk5xSE1UL1JIejUyMkVhM0M4RmdDWDJFdz09?=
X-Exchange-RoutingPolicyChecked:
	BjxF1ncYDgSFwO8nDRhImmaizVbz77cB6NiA2vWh5Sdq7373gf0tqW6R0/VaXffQMCMbvlzMxmrdQq3uO+a7CV3O4BQZlLBIIMvI0BEUYELanGoun1LFQ6q9r+ZdRBdH9KtqlpmeVgBh0ILOyPUcFJUMqu7SilPuk0nKN+WqUqgyjoat9Scb6nGmXXDpgrORtnFJ77U/4u6OjqOW0retQkczG4MAs8CR6CRVLKE6lSsffLz6EaW6DkpVVyA3VL0JJvI5I5HhF9LOvIbl9kO5APTEZrcSfB3MRYSrbA/DlzrBYUEDGKsUSv/rBm5/Oavj9/mdvoExldnP/AA0zZOVhw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WLg5Aj16ASFeit3Mku4ZEXozhMyoM3bn8ST0EDr7knXoSMVVCMs+sjPInme4gKVosZOZB2JFUJ/hbricKlY5Cx/dVGxuL+g1FAwICRFf6X72YeoqELYRJOgcvKPVjArq/EzYJWMLsmObqnY4jIJXVysf3diYC1hhCVTPhYGUklm2ljTVqJWnztED0nOJdG8hm8wLs9OSRZyeiYbgqjMYRVm7Ih+931p52Jq3lQ+n4lPqXku08Qp4hlUep3yjoj/GYoFZlyJqeUdcU085c4KtDcOmcZH/acmJVZQBXxnHaWpDu94P8Pm32JrtKcXVfJ4FmEDzVk5TU2nfUN03zUgs89JL10zzAeX03SKHaxE+lsQnNPTn8keAcWl90FYjLT6VteRvz+XMGk0K9rjARTZAyFr/P569GASH1vfeG7EKxzDaQD6cB+9hF5UZXMOcfWQH19dxi6qM0yGxaL/2uo6ppfOIcO0Zae0yqPzeC04D9QkBvVIbl1L1/2E0ORw92d+HPVyHit7gj5qwNX5YyKRGhw4LoFul/koNApj+KYZwmzcKaxnC9p/qG8866Ru7bCOKAaKQIpOHL9QeueMiwhUHDvvyp2TVAl3zUGjakMeQQUM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da65b0bb-ca86-4c9a-3a50-08de96380bc2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 13:00:59.4553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7YMY9L2L8wtHoyeCsoFACB44YhlHQoAaaBIvA0vAsP8ztP5wvFBRkkZU3MEAhhqHt8n3yuXBLhDCPznovveVdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4855
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2604010000 definitions=main-2604090117
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDExNyBTYWx0ZWRfX8E36cQn62JS6
 QgkGIepqtQXTEtAUv45Ek6+0rsO8bkdhcJj7AeHJF9UZqOcIatiXKttG0h2NGtdy8fpvziDlOzv
 3K9QssGL6saDKnqEThGpld3wf10uVUjfFf5xJZfd49Rn+oRmd3cE7FZZRvq8mmcPqpAVVpDTsv1
 UZqd/mKv1/pnsz4T1KhaHXUZZv1/6JyavI16tsmaJHz4/xUbCWJwo+XlG7nlpOJ2BDTM5o6pE8V
 7+liEhTREMLFOiE+Wne6JWOsczUsQQ0tef0KbdFIm3/NXoI23sRXVBT1Ks+ZhTRTK3euXLRc6oH
 ubOzKsRNxvybWQiksgC0m1Wxv+H0HgUogd+gHiGBmheDz/AzDSCehDMso90XA2dSm1YvwMtNZTY
 iUTdXx+ApqzvsYR9ay0nYcmw6CampA==
X-Proofpoint-GUID: HE27T0jPciFQ3AfxEBadVISuAloxvuy-
X-Authority-Analysis: v=2.4 cv=Oux/DS/t c=1 sm=1 tr=0 ts=69d7a311 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=uCV8Ycjq_x1_aQsODi0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: HE27T0jPciFQ3AfxEBadVISuAloxvuy-

On 09/04/2026 07:37, Nilay Shroff wrote:
>>
>> You mean a common blktests testcase, right?
>>
>> For NVMe, that test would:
>> a. try to remove NVMe ko when we have the delayed removal active
>> b. ensure that we can queue for no path
>>
>> I suppose that a common testcase could be possible (with dm mpath), 
>> but doesn't dm have its own testsuite?
>>
> Yes, I'd add a blktest for 'queue_if_no_path' feature. But as we know we 
> have
> separate test suite for dm under blktests, I'd first target nvme 
> testcase and
> then later add another testcase for dm-multipath.

Testing a. is a challenge to be effective, as we would typically not be 
able to remove the nvme modules anyway due to many other references.

For b, how about something like the following:

set_conditions() {
	_set_nvme_trtype "$@"
}

_delayed_nvme_reconnect_ctrl() {
	sleep 2
	_nvme_connect_subsys
}

test() {
	echo "Running ${TEST_NAME}"

	_setup_nvmet

	local nvmedev
	local ns
	local bytes_written

	_nvmet_target_setup
	_nvme_connect_subsys

	# Part a: Ensure writes fail when no path returns
	nvmedev=$(_find_nvme_dev "${def_subsysnqn}")
	ns=$(_find_nvme_ns "${def_subsys_uuid}")
	echo 10 > "/sys/block/"$ns"/delayed_removal_secs"
	bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
	if [ "$bytes_written" != 4096 ]; then
		echo "could not write successfully initially"
	fi
	sleep 1
	_nvme_disconnect_ctrl "${nvmedev}"
	sleep 1
	ns=$(_find_nvme_ns "${def_subsys_uuid}")
	if [[ "${ns}" = "" ]]; then
		echo "could not find ns after disconnect"
	fi
	bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
	if [ "$bytes_written" == 4096 ]; then
		echo "wrote successfully after disconnect"
	fi
	sleep 10
	ns=$(_find_nvme_ns "${def_subsys_uuid}")
	if [[ !"${ns}" = "" ]]; then
		echo "found ns after delayed removal"
	fi

	#echo "now part 2"
	# Part b: Ensure writes work for intermittent disconnect
	_nvme_connect_subsys

	nvmedev=$(_find_nvme_dev "${def_subsysnqn}")
	ns=$(_find_nvme_ns "${def_subsys_uuid}")
	echo 10 > "/sys/block/"$ns"/delayed_removal_secs"
	bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
	if [ "$bytes_written" != 4096 ]; then
		echo "could not write successfully initially"
	fi
	sleep 1
	_nvme_disconnect_ctrl "${nvmedev}"
	sleep 1
	ns=$(_find_nvme_ns "${def_subsys_uuid}")
	if [[ "${ns}" = "" ]]; then
		echo "could not find ns after disconnect"
	fi
	_delayed_nvme_reconnect_ctrl &
	sleep 1
	bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
	if [ "$bytes_written" != 4096 ]; then
		echo "could not write successfully with reconnect"
	fi
	sleep 10
	ns=$(_find_nvme_ns "${def_subsys_uuid}")
	if [[ "${ns}" = "" ]]; then
		echo "could not find ns after delayed reconnect"
	fi

	# Final tidy-up
	echo 0 > /sys/block/"$ns"/delayed_removal_secs
	nvmedev=$(_find_nvme_dev "${def_subsysnqn}")
	_nvme_disconnect_ctrl "${nvmedev}"
	_nvmet_target_cleanup

	echo "Test complete"
}
#
#




