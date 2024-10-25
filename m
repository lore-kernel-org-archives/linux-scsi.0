Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E991A20EA31;
	Fri, 25 Oct 2024 18:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729881652; cv=fail; b=VVOtHSBMFMJ0WVIAiiRKmTTiJ5OLb3KOdXLQ5uVANAssfncnDmwuXu6DIKPfbI6t6MW/mjqWdG0fqEhVtYIFwPCLwJuob1flnQ9vh2M1MX9iE8dC+yOGCeYaCBcIEgWHrNzeT3yZ8eZEpjzGJWvpAE0jHjRVgMKZ5UrwV9FhzE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729881652; c=relaxed/simple;
	bh=t1OMkfZjP5PZrDtMXets+rg7kr8VDLKZQPhbv3pQYWM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sUnQyt+ig1fFDUtWY4nyjFXTRJvbnPbgiWDbmt3KVzTjgtzjog82u/vYHHAkj+MTUuZFH4K4LLoL7DEkkzoQlCuOhmT7jTZbJGzLzPPAWYOLIojG3BO+uFHY1QRy928BZyptQfsuL1NCGGZFRlX4HHd9Pfp8omAqCWqnwpT+hds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Llb3OQ/2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YyuG9mPE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Llb3OQ/2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YyuG9mPE"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PG0WcR031975;
	Fri, 25 Oct 2024 18:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=CEMVUXZItw27AsA22t
	OdV1QHJrOMVxL8F+7l9E/wVp0=; b=Llb3OQ/2BHnrKilz++hB6o52ST4DEBQ3nq
	e9oPEnWvVwrzGoapWWrnZgdRMnYOUl2/M9gNT3nI5cB3xxOm2bSNeiyMtpwIAjJd
	3cYyEHkAOlnjDs9ZuWPOMRn0Mw7DFz2fq7JGVnKXYY1uwI074UsFG9zacisPPRlM
	r3eMfSTAuhCBcNsElkD0e3nJYqpFV7zRHdjcrCeqDvkW9iGJvs3926BHm+Y3ckdZ
	ZshWu5Gar/aFYACsAaF8Lck9Mq7WqDWhFVUAlJp9l5QfAGPJsHI1YZ5iC/QBVLvn
	44sWcmmRR5+4o/Fiqz0zqOIzyOZQLWd4F86NOQv7veUbiaKNNKdA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55v5nja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 18:40:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PHgawC020961;
	Fri, 25 Oct 2024 18:40:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42emhnqrae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 18:40:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnToI/sjLORdAGFXFiWNjOXdDLgpEVc9ye1zZAGagUFC39TgX43/HhLWqR1nl7C50pnqj89obGAHTQwUSijlJc2M2vPCkfjzsCjG3kOw3oPOsWfV8ixIlg32p/4UMls8tgmWg/WpTgS5f1qih6Ml15+n1lR1SAOL9t4XwcAeE0Flxy1mIN2bgKGJBeyOTctifHtr9l5kTUYizn/mOiGvkguaoogwaQzjx/NG+qd7IZG+eM46f0ay3jaTHVfLjH/lfy4biLRodv78I2KVFFhea7EOMT7kffCLoGlMNZ3gxuwSCTej8KyR6x8OSImBqCuAeEoEKWiuNKXqew5eo7ZyzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEMVUXZItw27AsA22tOdV1QHJrOMVxL8F+7l9E/wVp0=;
 b=c8sjdbW34Kjle4hLxqHUWzDeCf1zKHzB4DHJrJGIveq+7Ugn26oodgWK2J8HcNnzNYsK7fbCZ95Wq/hj9zfiZ1+Ypa1WTNcc8cASGcwNyfaarB3KKnp2GiMR/qeAR+qgMcOrJ+/vdfkcqC6MRj5FbJz9pyfiNkZheG7/y7KmzCuUUq3qpxbC6F8LzTs59XmyBGY0uxM8LdgJiNxSee1KWqya0IYsFF0Bd+FnZo71Ertr9Zd4iz3m1SWm03jm0XKvHG6B/vCmrfcd4dYzwt8D2AzVmckb2WQiFcPSF/iOmWfEWaR1lATdnMXQRSegS7mU+coRhyN8OJTFDW00uQh37A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEMVUXZItw27AsA22tOdV1QHJrOMVxL8F+7l9E/wVp0=;
 b=YyuG9mPEnNjz6EiK3sBZvvUzvZp49WTreszKEJZ7YCRk5/ezs6QLR0osC3sD+lSz3Siz3wLY4DYHCkTqG2Kt0Iya8GWlC1LdF0J+F7t3bbrs1dhw7RHUOkWok2fg31izYJ+ygOQ1CR/sXnv05gbO80FtcI6xRRndMJD+Fi7j6rU=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Fri, 25 Oct
 2024 18:40:29 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8069.018; Fri, 25 Oct 2024
 18:40:29 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>
Subject: Re: [PATCH RESEND v2] scsi: ufs: Use wait-for-reg in HCE init
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241016102141.441382-1-avri.altman@wdc.com> (Avri Altman's
	message of "Wed, 16 Oct 2024 13:21:41 +0300")
Organization: Oracle Corporation
Message-ID: <yq1ldycf2lw.fsf@ca-mkp.ca.oracle.com>
References: <20241016102141.441382-1-avri.altman@wdc.com>
Date: Fri, 25 Oct 2024 14:40:27 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0087.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::28) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: c92b9110-f121-4248-9af0-08dcf5248008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RCPVzaHd6oaa4GcbPxrpWu/2oCLS5cTO1v0g8Ul1F6wSFFZNIaykWfObIaL4?=
 =?us-ascii?Q?mu373Anzh6cpbrnFgqA7hZ6GWxqzmOIaOPWBUHDFxFgr3h8B3UHXFCkaa/tw?=
 =?us-ascii?Q?2I/K3nz3RFEoqlBk8rGGSsyOlbFGhHChIaL9xxfWZ5c+H5lPJOHhcs+Lyi0K?=
 =?us-ascii?Q?7QWKJF/3BSueclbXjkmkpc7CoHoCWgWi1axlrfYFXxjsQpczTQVxauPfAGU/?=
 =?us-ascii?Q?N2fUJJ3Liiuj6mvRa3pdcGT/Fb6D45A8/JR1UTGJRMxjQr92w0ya6BnOGRj4?=
 =?us-ascii?Q?0cn9k39gWlbPeFZDhxRO8pryue34TfimUUO7tXUZLNm42/UmJRZEcNoGrQT2?=
 =?us-ascii?Q?OsBEWpisoXN0S7vL+Pq/c+lHESahphNWIvoBDhr/OQbujnSn1pg7j3t1Qc4g?=
 =?us-ascii?Q?gwTmvf0HkDIRUuvtPtDYL+7fhtsJFZmKzdXzBixLC8mgkHa7vTpFBGawty+Z?=
 =?us-ascii?Q?DqCg2ZTTsZUURy21A2N/AICmgjDb91Q626yNTDmt0LnjMuwSU///YlJahAtk?=
 =?us-ascii?Q?o/ms8m+L/rdAHHMFqNdyU40rvBylRRailHQI52m3ERjZU+IgGeeIMij87LpM?=
 =?us-ascii?Q?BHYUN6pteW+mhCpP1VKRA7ymP39LkkULnZq0sGcqiP8WgutUiyfv7xH5YSGe?=
 =?us-ascii?Q?u6chb3cBcn8NyCw6cifFOmDu2dJEl5wllYQYKqBewOFiH9Bq1v0ZR/2ln+RZ?=
 =?us-ascii?Q?uqnIOXQxaFhSBfUP4nmlGhIVJydQVwYKgrZqGLMxWpyR+1zYRB8h5P66DbO0?=
 =?us-ascii?Q?ujl3DAS8w/tl0LmIWWLf92G3oNz+kMaksuGtYX6O/gaBTPtUpVZfBe38ykN2?=
 =?us-ascii?Q?/pS7xNMGMDo5aK1y3uZ28TO2qd5DJQccAQ7JZZiIbWnBJP7Z4VnPpsfN6wux?=
 =?us-ascii?Q?XgA7UjVdwri8Qey1FQw1jb2yOAKAV6SEMBRWzcxx2jieblNl2Cm1F7QzimCA?=
 =?us-ascii?Q?VK/MHTuIVRTTZhFUbTnTV4yZY4vnEpFSi97v8RDo0h/zq5FrjtgJxBnff/GM?=
 =?us-ascii?Q?amtcw6nlNd/vxB+osbVw7FUBWjzF75WXuempPphRNNroiw2x7u7/rs2pdKGh?=
 =?us-ascii?Q?wT64xUWo1mb4qq6gBEahFCfn8IfNUa+7dT8V/kslekTOrIKqLssr4MyQ++Ct?=
 =?us-ascii?Q?FK2HC/osf22Sb6UfHVk8e/1ZbvvAkzt1TOg7h2Zz7ypEh+UMzRoOJDO1AZDj?=
 =?us-ascii?Q?uoWXN8lUpxgywqMyPRP9/PUdoXmdTUi2IFwPknYnY0bO/p4/BpwSYuDFJJTo?=
 =?us-ascii?Q?LkHZsV+U+L3FUpXYDEsEjbrIYttytvFMOiuVNonDzUWjVNl5ckAi4CXZjW9o?=
 =?us-ascii?Q?y85DaDUCz4QT+xu6w12OKxGy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JdSWiLg8f82/o7FvCV/fa1zfVCmpTQhINkaJxlcWu/FGYV1seg0wXRZuBoa/?=
 =?us-ascii?Q?m1JHRT/pqlL6bYT0lNa5FLBQpkk8iHxZCZ99B1vYty/lqhd0xL82ZISt6b8N?=
 =?us-ascii?Q?0Haz7tP5p1UcojGcQL8mXcVktsHPxzEOBu+H7jnHCcx6EAACvLAad1OJtH2y?=
 =?us-ascii?Q?V491+QG+9jBkwWb3/5kH8rWUhupeqGRthLCcAIyJZ3ZHyR9orxEsLljH6hmh?=
 =?us-ascii?Q?F4zaRjl/EtCIFBPoqqYV3rLURMrH3W/CJmFa9sGZTwMgikNWei6SeBu/7NHP?=
 =?us-ascii?Q?0HRCnF6S5QH5mt/ieBbAqmFUYVMCvIhcGKotttYQRkNyV242uoP7o3sp/4vU?=
 =?us-ascii?Q?t0zc+FLSZDEE+JMzyAeq5++ZndEbOU21NcMq3KDfSxYk0tNTw4NujesUCUm1?=
 =?us-ascii?Q?JO4HmZsQFYgqcXNagvXG7NlktsNbkvWrWTl45zWD6EiKjLTMPgIz2f+FpD29?=
 =?us-ascii?Q?82Dk5l9zJTwIxIABvmCYJX9Z7UL30XzTOd88hSO2HxmgB1VplZzCBy4kpGvR?=
 =?us-ascii?Q?r/acbPJ98SOfaLiuzqtubBLdyFBgRoiG5mMn1Sre38iWT+7gjsX9hQaa4hec?=
 =?us-ascii?Q?3i03NWlMHLXe2M9Qx/F9sbSPXg3+W50dz5mD4WBLDoHiOW6zdpqAupapbEU2?=
 =?us-ascii?Q?xCiGFoagt8/xDAbEj3c/h5aEvVSebppgnaQFwH8jOsWypYzlY0H2TGkbz0BZ?=
 =?us-ascii?Q?HfXifHIwPgLxIqaPARQxnxg73IKJBJgVuReVaMZSrV9aV1RHTN31FQCxBNgX?=
 =?us-ascii?Q?5gi0RUI4gXZnGIaTqNPDCdNXb1NltOY44WMd0BW2sPUcl5gi8J3uTSytTgQo?=
 =?us-ascii?Q?Pre4nwTJ0zBuZ7U1rU5+O5jHabjfmNm/nwiBQsY2VhLnSz+4haqmanGNdmFF?=
 =?us-ascii?Q?gfjruUv0M2s86xGD/QkBh0BJOZrgYXHfUDSQDpIdFnRNqkIgmacATRcFISuo?=
 =?us-ascii?Q?2RRhqpR1ToCjqD/Pq0FwIqsaL1Y4e93PkijRLZD5wYPA+w3LdiN3Ty8NHVN5?=
 =?us-ascii?Q?vyjAkxco4wsiCjKZ07O7d21hJr623qQBIIk3mgkzmIGXzmzAu3i3KKIZAdlu?=
 =?us-ascii?Q?g7JiOeCXriCaJTTqP3Q7zUDv+BmsdeCUzmkDs9ignTc18mF5liYfC9MARwaM?=
 =?us-ascii?Q?DjiuI0VNun0nDCBDy1kEwhNRWcHWwadbXcETZRI5rR6IiHpl037qSsBcAxAn?=
 =?us-ascii?Q?I8ecMmX2y+c+SGrHk8nOJbauHXH0ChCw49mYSedUXtvzkvXczP3RvHKQBeQw?=
 =?us-ascii?Q?DmrjRVrR4UYo9HMQh2gh9D0MKaebrMskmjGbOJaEX5n+MCR/sB4QMLVViksR?=
 =?us-ascii?Q?jMGENPxA89CBJ/HiDPF7MIMbK99dtwYjL7akS5Fo0PZzTB6ZP1vYOPA4F+Ce?=
 =?us-ascii?Q?6BkdN9+rIDl27W4S2kIb/p1LCyUy8dC0/g0Cp7BX7UOOCYB3fTWjNjrUvsqt?=
 =?us-ascii?Q?g/9PLN/fZQjI0CJ2/KZHSgYOEDcJlgAwhSt8sg9o4jE6Fb839mDGKaXgobaz?=
 =?us-ascii?Q?hzGW5wLcr5ib1m2U0wGXPGC+HjfanOB67vKlgzkD5fo/jEihfON9qvNoc/8p?=
 =?us-ascii?Q?urmZckTgV7JJoHl73Qth01OdeFsBzxsGfacZvz8cd8hrq5a1OSW7Te1kS9aE?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PObZZjEhC6rgggZcMzTVsNMG38DVtzWEWEQcs+8CJLByZdZY9c/8MpWSmPTDyV3dpH2v40ohwtaQFbNosp25itgQ+sLJDhzHkqa3mkKB0U/Rx9GlMlC9iSPPMNL9VQ+CUCQDnvWizHNkJ+fnF13BFATQGMuvBYkv/HQXGpPBiM33WWN3SLYrrWri+RpNUjJKRtMjBCsPRBfU3vLpqUauYq6ob+FWhjCgZbKIsGEmJbRKH4aWnT+AwhE81DAcHtFwYv2eQ7zWXZu4+9DGKgLKKVSA/DXT+/1igA9Q39sqUaBgi09069xKhurt4T+bhJYDljVMHOacBqoDBkJ7oQGl5U77NdDh5BoUFnxFQdEnXGxLVeTl1Dp0SrOTt7TawO9esD+w29Vdz+/ZV7Iat4UP+O5zK1jQUevhqOxSE7tr3khI40QpcGh5Oq2oiH8hcVEKNFgGj2DIRM9Tl7etevTOOEvhA+/ZMdzyqTx/dJeTYzM4OxQoBospsBesPS7p2kSq3FSBkMcLS/9Db3e93p+2jMAPYmt0UeMWGjhzkslaujGJ/GcOUiRpy9HvW9z/eo9QZcgb93R5HI7HhZbHm0toFygIXycjSLVAELm7RN4epfs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c92b9110-f121-4248-9af0-08dcf5248008
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 18:40:29.7105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRwkldbfvjHJQvjuJpel5H85a5Om3E1dFqHPjt++cyoPu1EJ0emFwEctsu0eU7opQa+coIDeMYcm5d+TBPpFPYSE7oVLoVysTAGB/P9EQk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=770 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410250142
X-Proofpoint-GUID: yQv-CyQDH3z4LDA0Jevi6EqOyI3GJeiC
X-Proofpoint-ORIG-GUID: yQv-CyQDH3z4LDA0Jevi6EqOyI3GJeiC


Avri,

> The current so called "inner loop" in ufshcd_hba_execute_hce() is open
> coding ufshcd_wait_for_register. Replace it by
> ufshcd_wait_for_register. This is a code simplification - no
> functional change.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
