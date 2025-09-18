Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680A430DECB;
	Thu, 18 Sep 2025 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758207026; cv=fail; b=qUasPDOcD6ryTlW11aBhADh6J70rKwts4WcRAkq2qI3gw1XlKmvNlcSEchIMKNTpfd7demH/IznTBhKjmQiK9HnbToVGZ1iPnjJJz58MscB0N0AWprx4fTSUN2u4oGIMCceryS9IyTMJswsgjbNA4QjL+8KZPpyxgRNZQCKFXTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758207026; c=relaxed/simple;
	bh=E1KH6XTkfZf056hEVYFdAffTexctIMbICahfCLzBKN4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FuL9/DVBmlY8+hFySdjMIJc0xRQlYu+TfITl5cSeJapck7ZIqLZUnr9c8kyejmn1cjkxmjAIXrsS7x7Ga3BUvqqdSYFlJupy9rk3XbwwaKgoOlsxO8290JYFjPyHzAfz/8JbgIhgUnDFJoeGURBqklkvGjZbFHdxBjOJdNs9seQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O0Nd1G5n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gUBR0hG7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O0Nd1G5n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gUBR0hG7"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7ft3u008949;
	Thu, 18 Sep 2025 14:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LELECD8YGVSNfw7pMdt6z+JxdBVs/KcDVO7eW7PugjY=; b=
	O0Nd1G5nN7kgLI1RHUzRjIvjjNiy2uarEtOv3na/2vP72sOC8L9X9NVh64su8rU+
	zQ3L2c9eZ+pLwJ2ydCTjD1PA2grbOISC6KiHjTsHPbPY8fgiFt2XQaDIP7wroh01
	SoxQwGDUaaEj4lCLgeHZknOBLqhvxY4OkIwKyVVYdWllOkktZqODHF1oaf+VcuCX
	lVjPRqH//k/FvnObzv0tN6IlScMnVV8u0iZ7JXBk2EfCnw7JiIXw1PvHS9fP9yx5
	3Orfl49UZWGNipN+DgSVaHwpPDDrDcOIvm4NW/qb/h+4g1ARkzJjPrjVKG+9Hzl9
	P493yy72xEcYA48+KgR6hQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbup39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 14:50:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IEL8GX028737;
	Thu, 18 Sep 2025 14:50:13 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2f8222-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 14:50:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=msi7d2gfJ3dpFdYFTVQka2WHQ1GgopGU7dbqPyz18Qc53F+K/RQczg6S55xpj+NHvhrfNvrpZ9J/F/Odx5hMhyRs0HpSAgXPpIYyyz/GNrfBZTHuilTIQgzFTDJTpvWvRJXq+HC6QX3MNDsQlOvtXx4a8pQ1d0JX7bP1f5xGM4O5DpzoKlx/gpz4I2ZsCt/XlYIr+wPHK+fxbLtHBWy/hiSyVdXoG9Sgum6Jad2nJmwvkCMFY0VR0pYi2kJ/MXOZhFSPIdR3c+sv7bAlFFKPWdN6UpqALQ6Unztmo5EIsFtGX0w58cedWPJvNdxVmDrMDTNcpOqQ+RIiOMd11fCl0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LELECD8YGVSNfw7pMdt6z+JxdBVs/KcDVO7eW7PugjY=;
 b=g73Fn9BuKJfsC1CKY3OXonUPAqkzqICA4WzxTCwsvKIQiElYzByYWDnnR+hlnulQj6qxVwo9lVpFNGzEVfLj82Y0cMH014qVxUtzxlHmgFklRLcc06B4UkZNlcK/NTl8wUZgkcvfaQU67d4cHEIrPK3i5+sxvLxEirBanJeyvq3bT4BwRSrJqkCDhAngtFhBBNbU36FzbPCVbm8XONyDARoVTILw4UguZZLEEJS6PWqNd0fjyc8npsgArHBfPKp8VBQI828v68rR0wwET+sihGW2s7GuULOauke36k8rQQMbOrZBmHGoRmm0TjAkCcq2O06GZwRtKVOBkJdStUCZ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LELECD8YGVSNfw7pMdt6z+JxdBVs/KcDVO7eW7PugjY=;
 b=gUBR0hG7Kc39Fi3cfIGQLWlQDS4sURVSNh/L0AIDTIv4USKipFwFKb8C+9GL+ZqtZadHjQO8l2UBW4EBa1+PXRZgC6RwRQ0w4f3RUct0NvbN8BH7J20GKQDj5lLyh2gnh7OKfs9wMjaOSHeOZ6qlIB/CQU+AevuAeQoYsxOrCXQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH0PR10MB4790.namprd10.prod.outlook.com (2603:10b6:510:3f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 14:50:10 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 14:50:10 +0000
Message-ID: <76ba1773-60ae-485d-a124-f2040bb07cbf@oracle.com>
Date: Thu, 18 Sep 2025 09:50:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] scsi: target: Move LUN stats to per CPU
To: Hannes Reinecke <hare@suse.com>, mlombard@redhat.com,
        martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250917221338.14813-1-michael.christie@oracle.com>
 <20250917221338.14813-4-michael.christie@oracle.com>
 <03e53a96-d94e-4608-b52e-bbd87b8a90af@suse.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <03e53a96-d94e-4608-b52e-bbd87b8a90af@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR01CA0025.prod.exchangelabs.com (2603:10b6:5:296::30)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH0PR10MB4790:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e4a8af0-17c1-4d31-ea84-08ddf6c2aa3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WFl5Tk5mOVZDQkEvSXFtbE1uZDN5aGtSdk5BRlgyekhmejFHSUtBL0JhY1ky?=
 =?utf-8?B?MXl2Yk5IeWk2MlVvNWJQZGVUOWhFV3l3aTc4cTR2QmEvdXB2V1BhY0dqdlI0?=
 =?utf-8?B?RGpvbjFES2xTek9xTlMwQzJYeGhJbjJMdnhEa3RFYlVIdW54Q05QL1ZoZFJh?=
 =?utf-8?B?Y2cyVzZzQ3o2UWRHY1IwK0FkTFhWMUlZcHgvMkFBNDJwZE9ZRnZKcno4d0Q5?=
 =?utf-8?B?RFhRc1VMMTdKclhPMWpRWWErdmRQM29XdWh2T0lCeVpTQzkwRVFVNmswaUQ5?=
 =?utf-8?B?bXpSbDNkclZBUDJ6bUx5LzRndmJZTEFDKytBVlNhMi80RFh4YUgrZDJKSDQ5?=
 =?utf-8?B?eklMWk8zQWg1TzR4NUEzbjU5ZmNUblIyKzBiSFJiYVpRdHJxRVRLZCtGQmpt?=
 =?utf-8?B?a2VKM3EwNVQrbHh1R0wxQWJKMk9OS0VGS0lMQ2FrUE1ubXd5d05PUHZBRjRP?=
 =?utf-8?B?MmE4OFFwSkczSm5HNWxnUjlveEtnZWRwSnNwbmVyL1puRHhiYU1sbDl6Yzls?=
 =?utf-8?B?eXBKaFNWQUlXb2N5NDFINm14bTcwWDdVTUF2ZHVSU3NPaFZDNjRHN3JJY2ts?=
 =?utf-8?B?Qnp2MGhEMXkwUmxLVTZMcWdnU2xjVlpEMXNmWlF5SGxGQjR3dDZCaWR5RUZh?=
 =?utf-8?B?YjgyeWx3SjdHUTh6WTFVNWlBalZ1NGhwYVFDS1JSSGVWcE0vOEdOQy9BWno2?=
 =?utf-8?B?elFKUTV3R1A0eis5T0lFWXBES1Q0NFBNN3BTSXN4UDNRMThpaDZCelRVZ01C?=
 =?utf-8?B?ZWFJOGdTRmNxQ21JSmI1RmxlU2JFNXltZkwrUWYxNk5YZ3JYLzFodTRBdU42?=
 =?utf-8?B?Wm9hMk9kNzBKNmhXaDZ4OU9BL0lkK0l5N2RZZFAxNHVMZ0lkdXY0OHNmWlhV?=
 =?utf-8?B?eFU1NkJQU1QxWTFLbFo5T0ErMDRMeTlRVWM5KzVDL0s2QUhHaDRCTm83c24r?=
 =?utf-8?B?THh0c2swL20rM2NEaHZVRU55a3VWS2JEenY4Z1VJUGZ1dS9RWjRlb0Riandr?=
 =?utf-8?B?Nk1TRlRKbGp3RENSV0RodlUwWGNHWkdZb21VNmRNbjN2TnFjRFFqTnhORHls?=
 =?utf-8?B?NkdsNjZnWUVFMlR2LzV4MEozYVc3UGVQN1BTSDBjVGdjWG5nTTVvR0ZyTXht?=
 =?utf-8?B?R2kzVjI1TEtKNWEwLzQwZUxmZzQwSkdwaEUvNnlQS2RtQ3FKQVoxMnBlYXZa?=
 =?utf-8?B?N21Ma0YxNXhvc1dnbjdjeFEzdG84RDZxMWJ5bFRpNk52N1I5czBhNXVRUjF1?=
 =?utf-8?B?V2p1ODJzK0J2ckJNTyt2REU5UTB0TVhqK3BpUXorOXV0OU82RWh2NVJ6ZTgz?=
 =?utf-8?B?V0cwaWdubG41emZYMlFkKzN4Z0JhZUh3czg0KzF6RXFjZ1hNTHIvd052WGwy?=
 =?utf-8?B?UjRSL2loS3V5REJQM0Jsc0I0c0k4d3FwOTQ0ZTlvREV5cy9KNVlZMGdvMk91?=
 =?utf-8?B?U3lhdlNIUm9jdGN4SFB3bTM3WGdzQlN0bk81cGtGeHJ2aWh3V01nRXhKODQ3?=
 =?utf-8?B?ZmJmU0RFMC9ueWN2NVVxdFJNVFEwOUkyczF3NUdUUUJLZXMzU3pqZWd5cWt0?=
 =?utf-8?B?d3I2TGFPaFhGTGRNajk0bXFxekw5bzE4OWQwckZSczhrc2RTQXdoVDdSb3FU?=
 =?utf-8?B?Mml6OVBCNTAvTUZvV0JrZ2tkSWFXb0JhZW0vaWF4OVMrRDhVUDJGV0wyaFNs?=
 =?utf-8?B?MTZBbWNkVGFmVXphZGlLcXZuRlRCS0hhOThjMVVFdTkveEZQSUl5SUl2UCtE?=
 =?utf-8?B?bCsxbmMyZmkvOEllQnBLencyZDVTVFA3RnlFd29oaHlqSHhFNzhDTDNVcUt0?=
 =?utf-8?B?czk5UzNPTWRSdG5rZG1GWWR5R0dLTTkwSnFhcXVqQ2xjc3laWGpqT3Y2aDR6?=
 =?utf-8?B?UjUwYmphbU1ZeWNsMlZsenA4VGphS0l6Vm9iNDdlRG03cUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djdrbmNpZDhZQ1ZidUZmUVMxdUU4VTdIN2NXcUQ1YzR5TDlsQ2V3ZkhiODVL?=
 =?utf-8?B?bkFKM2RpbVMxazJRenhsVHc2dit1NWY2SFhBSTI2TmtrTnRZdEhCVExRYjVa?=
 =?utf-8?B?OEJ4TWRDTUVEVTBJekp4ZGk5aVgxMkptL3l2aUZUZnc2bjRTU2JuMXFUQXRR?=
 =?utf-8?B?VS9DdnZReGlJNCs1Q3Nkd0Z5VDhaTmFCWnVnZjFVcGpqNWlVenQ4SUhGNHIw?=
 =?utf-8?B?bGRYTW0vQnkrbXR4eFlqYTl3RzAyMWV5eTlDaG1VbUxGMHc4QnUxQ21wK3lC?=
 =?utf-8?B?YlFlQzM0YTM1b1lPUmUwZEE1b3VkNU1VR0YrZFVEVmg0S3MyTllHbFhSaThH?=
 =?utf-8?B?NmpsQjc5NEhmS09mYTAyUW9Kank5Qzd4QVYxcWd1azVJRHlDQlcrazhvWnRt?=
 =?utf-8?B?OERnRzBCeVlycDJZcWZYWTFHSjNEOVc4SWFvY0ozVkRoMG5NejFQdEZvb1Zr?=
 =?utf-8?B?TS9IZzBNYUNkelR0Y0t6WTk4TjJIUVZyVHF4ak82UkRWc2l1MzRKbStSQ1B1?=
 =?utf-8?B?U2F1dUUyZlNmY1hUbXZLTXVpM0ZzclBYTHd1V2J5bU1UdmQvamFxZEtvNkp4?=
 =?utf-8?B?YTk3a0lBSkdsRVJHYmdFTHVDekhKek9MZkNJRnBMelVFYjEyTzZad3V3bWNB?=
 =?utf-8?B?dTA3b0t0dEQwdlZwN2Y5VXpsb1h1eWgxR1g4QU5BYVJpTlZFTmdWSi85Rzg5?=
 =?utf-8?B?SW1zRzVLRWZsL2l0RXI1dnBUN1pYT2dsMEZGYklURER2eE5KVGZFTERaZGQx?=
 =?utf-8?B?bkt6WmhDNzR5TnFBTEpxejJ2UnNxNHlwaytzdUwzenpvRTVROEtSbHQ3OUlN?=
 =?utf-8?B?N1drSXZhWkdtSDRndUFjRUFESm1jSjlTcWJQdE5oUFZEcFFzbkJPZFFpejFx?=
 =?utf-8?B?L0prNUtlUFU0bktjcDluU0xTNHh1Y1VDblUyRVlwRTkrZklsT0s1ZFkrZFFm?=
 =?utf-8?B?YkVKNmFBYnFuOG1RTlZoZ2tRQ25vdXZaMld1OWJiODNHSmdBaDZ6Q1V0bmpO?=
 =?utf-8?B?cWU3VTV2Rk92Z3d6WG9DY0hXVXM5ODdQWjk3dHR2cnFKQjhTbEQzc2s4KzlU?=
 =?utf-8?B?blRZdzhVVEZJU2VKMTEyZkZOcXRYV25mR1R1YWJNeFpxVHRwMTc0dzNxTkV2?=
 =?utf-8?B?WkpkNllPcnA2b0xXRGdmSytPNlJXMUJYdFdyeTJxS0lFR00vbC9ybk9TL2dj?=
 =?utf-8?B?UGdiVFZYelMzLzRMVkNoa2dHSHRHUTkydGhOeG5SZGtiTzNpZXo2Z3QzTzZH?=
 =?utf-8?B?TDlGNW5mTWJTdzZWTUpwT3AxMk1JdVEvcCtZYVdJcG1VV1hkRm84Y3QrZ1Nq?=
 =?utf-8?B?WG44ZkRMbnZtb3E1SzJsZjVUakJzWHRsVUpvdnhCbWRDTGl3NEdydkpqYmhz?=
 =?utf-8?B?bjRMamlsbEkwT29Gem04QWpNUlhicGNLcmw4SWJkODZ3dDFvb1U4emJsUDR4?=
 =?utf-8?B?WDlSQk4yWnh5WXF0VHUxcFRZL1NCTnVHaG9rcnFUdkduQ2tWWkM0ejRvaU5v?=
 =?utf-8?B?bTNHUU5RWnViZFIvcnNMcXdDcDg1VG9xZHYwNldTcFdOMDZWOU8wdFlvclpO?=
 =?utf-8?B?TXp2ZlFyamtxRFN1MXBoRDZRRk5kcHBpL2pzbEExV2E1K0xRdnpYVVkxR1M3?=
 =?utf-8?B?Yk1xRjBPVW9TclRZNW1USHZneDVjUVhHTXBPVlZUSUFNRHJoOUxTRmU3cTl2?=
 =?utf-8?B?aUMwbXFzdkRvczlpS2VtWTV3Ly9KbGVqb2N0SjZCbE1tanJ5WHVqblQwR01j?=
 =?utf-8?B?eWZOS2w2UHdJY0dRSG9DM0N5MUlkY1NXczduenN1dG1WUDVmaEltN3VHUlQ1?=
 =?utf-8?B?TUF6MXFzWU5YbzcyT1hnZWVqSmxwalhCTWJ6ZTQyRDE3N2Q1QlkrR0dxWFY5?=
 =?utf-8?B?NDEzb3NMOUkyZVlpbUJjSmpTbHJYaEY5cFlUTHlsdkozbEZPT1RNbmJEWVNH?=
 =?utf-8?B?ZlEweVBEYWo4UUxLWVQ0NTZFSHgrV29lSjlRNFJWVCtrYkNmdVpna2ovamto?=
 =?utf-8?B?QmN0QTd5ai9VRVlZVllHN2k4czNSSjJMeHV1elNISU1jeGREeExsUU16Wm55?=
 =?utf-8?B?allSdlk4RUN2RytxNVBmWXhmZXVwNUtRYlN3ZEV6c1RZalJCc2NiSHZ1Kzdo?=
 =?utf-8?B?MUlBejRUWEpFK3B6T2IrTTNtYkIwbmU5U0ljTlJnSEJJOVV0Qm5FbzNyQlRP?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZpXZpF/JGMac/FaU4m3BrMzJU10h7LSHhNtXDw64UJPxQaHRog7A5doqR091u6Y1MvBNiaix67i0lyduvwjOyneKDWwu+x09KgrC/wmhypAwSsKIx3SiVF5v0hil4AxyUJsHVJcku422WYP+XrsJsLSKWIr0Hi8gpdgmdRQKSAy9YI7ZhJbcYRrnQoIZ/Q3ud5RTbR6eP+xZ56qi1IJAgyHhaLtWuf5AaqXaCHTzoiZWTdsHhHeF2NzJPHorntezxQct5+g1wHn1RN1T4iACd0kuKYtfie7eEQIiQt4276z28Zvz0Fw16IparqFBEkRh+pUuR0fx8SJI7RQFYvAqK1xYKWfxzRRvxPqGBFx0xpiDIBh99jMcQFyQGQGibojRdDLRjIpHellFvV+KwAZcja+DD/gRK0q5sd+VGELFDAQxcVgW5IfqRjwZxuJ30DVdBr4ggr6JtQlbnhGIkcmJA+yqwzCiaVsk8BczFqPQVSlWpuyHWh7YBY47A816kYuhX/Y+obWLV9h/gpkb5G0w2ITOn5h16JsT2TZotMU0lOzmOGw8r2l1biyQYp5Mnl0hIVW5cvC1Bm5idiOZHercSX4a7skcA1UbRUwrcLHkfOo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4a8af0-17c1-4d31-ea84-08ddf6c2aa3d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 14:50:10.0739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LTzKunCqIWBPteIP5uVCtc09wYv/ES5UNTGiZAVC4aazGBNMRI/8YcyUv4EVvbAQWny8DscQYJGqNYZo1ObYpjYjeEA9DLiu2UEgZEMIho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4790
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXzjaQeqezWgci
 rV4KIfGAUY5+Le6FTuUdclIKcwmaBhjNVvmM0a2tddiOy1c8kgBpHwMb6qVIgfou5pHs6mRa13A
 2PzwhDgsLQbkW569eA1dkCcBbfEOBoC726y1B/7Nl7xh2eVq8Iurh1Y14EzjxW0598QBk+Z3rMg
 5jWj8DkxNvbEXIHDY6rJ9rUXYQ6qVhWPGum3tJoQ+2DwwQGGQXJd4TB+lLCfyhBM5SEyEVTDgbq
 dNVwdP+g1NcTWZ8sKcQzb9P9kpswkvzNh53U2ks3i1XXsy/cZgp8Wgr29SK34+DBqqnDcs7tp+D
 d6IayycfVKt9jGvOcv0GTSr0XLtB0L3zII/B0cMgML5S6UCCYkpa52J1UeGzcOSvbDbvH07WcLs
 GocpOC2U
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68cc1c26 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=-c9VzbpeAAAA:8
 a=74YdtBdTqgn0VbMy29IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=WAq88MDkwfy8HpmZFCM0:22
X-Proofpoint-GUID: Re89RHtH6IkpkukQmLuJW0sk9rx6lZCK
X-Proofpoint-ORIG-GUID: Re89RHtH6IkpkukQmLuJW0sk9rx6lZCK

On 9/18/25 1:31 AM, Hannes Reinecke wrote:
> On 9/18/25 00:12, Mike Christie wrote:
>> The atomic use in the main I/O path is causing perf issues when using
>> higher performance backend devices and multiple queues (more than
>> 10 when using vhost-scsi) like with this fio workload:
>>
>> [global]
>> bs=4K
>> iodepth=128
>> direct=1
>> ioengine=libaio
>> group_reporting
>> time_based
>> runtime=120
>> name=standard-iops
>> rw=randread
>> numjobs=16
>> cpus_allowed=0-15
>>
>> To fix this issue, this moves the LUN stats to per CPU.
>>
>> Note: I forgot to include this patch with the delayed/ordered per CPU
>> tracking and per device/device entry per CPU stats. With this patch you
>> get the full 33% improvements when using fast backends, multiple queues
>> and multiple IO submiters.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>> ---
>>   drivers/target/target_core_device.c          |  1 +
>>   drivers/target/target_core_fabric_configfs.c |  2 +-
>>   drivers/target/target_core_internal.h        |  1 +
>>   drivers/target/target_core_stat.c            | 67 +++++++-------------
>>   drivers/target/target_core_tpg.c             | 23 ++++++-
>>   drivers/target/target_core_transport.c       | 22 +++++--
>>   include/target/target_core_base.h            |  8 +--
>>   7 files changed, 65 insertions(+), 59 deletions(-)
>>
> Ho-hum.
> 
> That only works if both submission and completion paths do run on the
> _same_ cpu. Are we sure that they do?
> 
What do you mean by it only works if they run on the same CPU? Do you
mean I won't get the perf gains I think I will or is there a crash type
of bug?

The default is for cmds to complete on the submitting CPU. The
user/driver can override it though.
