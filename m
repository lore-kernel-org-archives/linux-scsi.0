Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA8B244677;
	Thu, 12 Jun 2025 14:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738730; cv=fail; b=uyoy57lAE0Fejbdluvo1nNe0GRBJ91nHBiCrXF+MxQzKMZdJZXAN3PmsIf/wrshJOH9o9f1LewbQCmqBzaOW7+Dh3PoUFhgttd+wLMXGKI0j4ZNZY9lDzwKkJdwGgU+83Mrd6xtNfueJwzwtkhqj9zyNQMZSTdfw+DcyYW4yYzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738730; c=relaxed/simple;
	bh=EzBBDYXaJfgyKQ2t2B/4U9392y8TvFhTQS+UhtXYLTc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bf4YXnQf9J7vESEWHgXvcadcLwPr+/IBrgMDaFA5jK+4j65tzB+RbRsew0v1N26RWk7qojLRW0qqLKP6XCqwCVZTdVBqT2IFSk74v0KZ0qw6ygNKvPTqrKoGXRzK6ZkcrgdeeP5G+9o1RpW7tB/Ju2Gb4EIu6Yia3j6+NDHpAQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bpybyTHa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c2x4yrzr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bpybyTHa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c2x4yrzr"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CDtd8R021451;
	Thu, 12 Jun 2025 14:32:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4AXqmEGpCb2xL38P683X9mv9yKZtEXsjJ/YZGO3dP/g=; b=
	bpybyTHaAKp3O02mFscXIqK6gMRYedDdnVa1egS7CK667hVgjptdaoTGC3CGlraj
	l3vwELyO1dEGpJwfbc6obQNXuTv84B4kbasqhptlP2pURAtQcKPQSbgUVMq3VUZh
	C24M7k7lrE1b/wZ5veegwmOmWal3a+OFo10AUpPBZfnUSw7tZ+rL5SogXujRY1TH
	2sQHG8e1ToJu+B3tlpzw9LIF17qmXpXJTMnIzRBJZuFLT4MAmwL6eNG/U7X2RH6I
	LVTJ4UZqkbAj3EvOSNoxznKd8/JdAp/Js4z1mwzs8zPWFAJza3yzFkHr01gjLfwU
	xbkLSm3rIhiANJ1QI+AsIg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474dad9qjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 14:32:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CDnICN031867;
	Thu, 12 Jun 2025 14:32:03 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011009.outbound.protection.outlook.com [52.101.57.9])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvbnvfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 14:32:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CzKaF07jL1asvO0AMFf/xRd6yASr0GAk9Gt05c4lBK/gp0K2VPyy9c7iDbx6fyaeViBZuh2Ttmmlr09KcHSLeLhyROhmAgd2qjXqXHR7zvwpS8riiFdiGzdbQJSmcuIlp+HKbcbkmGqqgps2HtL3DOcRGkbfBqslgwJeKFPIVk74P08kUlfqvcHWfMJQX/SOTffY/zdzda34Thxygg4+svIASOZSrP0v8gs/x39GonkiEjxy+V0rXkSYnr6UZd+h5LrYamivY0b+qZ1KQ5PO4jWRClAIpPN8+m79T+sy3zI4aZDwkc+wUJXroVUEigIfHxy0oBCnN/J2gtxFrP7yaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4AXqmEGpCb2xL38P683X9mv9yKZtEXsjJ/YZGO3dP/g=;
 b=bMsq3/WXMq3WExugBNQDyHn7UCfSzEJuffCUlJZ0HA6jnSa95VaCGgs9steDCjp1xwfxC7hHR7W5XyouAOrs2U+bnbjeR4qkNcUYIZnZmU6P+OOWcklshCxUpj1K/v8IbyYCL5IOkPzvDJsW4ekzs+8wVnFGPIikGdL7ERmv/m6FaDnD7Wa98tFLTbp4UVxH9fBsM41QyZM5IVYkVQKNVjn8BORMmWleA6E6hGQp8SJASXJs5QxFq9Tjasg+FlX75ughRJvg7iPNbHbPMojOzei7y9Gj14V48gPlbV/WDNFoWNi2UB9S1pYxNA/x8oTTvF/x/tG86mUO7ekfqn3wtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AXqmEGpCb2xL38P683X9mv9yKZtEXsjJ/YZGO3dP/g=;
 b=c2x4yrzr4jx+kjLgZdJ2aN9wllbS8sqo6tWNY9vudzB0ej+p8s+HXRf3BuFe+OWkUdeb+S8+ZHbtAqGv0N68feQ5AyVUEJ7Ygms214ZE7IZHc3/kRkb6Xf7CEggIrZTJA5DYq4qXLmOSzPtgGG3I7f11c6cxbC/J5AfUpJeq09Y=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4136.namprd10.prod.outlook.com (2603:10b6:610:7f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Thu, 12 Jun
 2025 14:32:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 14:32:00 +0000
Message-ID: <b04c3786-d3c1-4043-9c55-84f2598d69d0@oracle.com>
Date: Thu, 12 Jun 2025 09:31:58 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: Fix NULL pointer dereference in
 core_scsi3_decode_spec_i_port
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: mlombard@bsdbackstore.eu, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20250612101556.24829-1-mlombard@redhat.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20250612101556.24829-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0280.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::15) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4136:EE_
X-MS-Office365-Filtering-Correlation-Id: 2442d4ab-3fef-4d0a-7134-08dda9bde458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXU4YnpoTVladGNJMm9CVlNqUk9pb3B1Z21zOFpKTVdaaTIwU2NZMy9Ta1cw?=
 =?utf-8?B?alBUY1ZIM2lPcHdqdWUvNGtYcWErbzZKOGpRd2NlYjRtbTIxTjlXakNrQXhH?=
 =?utf-8?B?S1dodi9TMUVFVTJpbDkvazBWSFI0Vng5Y0tINWNvKzJLMmRrVk1Md3pJOWNs?=
 =?utf-8?B?dU5uRGNNbWhnT0JCVUJpZkFjekpmKzNjRzJPb2VCL1dFTVJmL1dJODdXM29u?=
 =?utf-8?B?UU1idDJGT09lRitxamJLRXZ5QmwrQnhYd0pYY1A5cS9IajJvSlZxQzlPNWxt?=
 =?utf-8?B?ckVsaEhuczBWUVNVQnI2NnR1dXZFd2F4YzkweDZJNS9VR2ZadGxidnp6RUpa?=
 =?utf-8?B?aWFxNmRCTHBWaXdxNmdnRklUakRiMTQ4TERHeUNycDRvVlFpbHhLNU85dmRN?=
 =?utf-8?B?ajAvbGdid3JqT090MlpYelJqY0p4d2lRL0NZYkc4UUUzczE0SXdpMEE4RVVV?=
 =?utf-8?B?UkpOYXk5eEJCL1dDaWJFM1JpSXo5T3hKeXBiQ2x1MTFGVUFxQkxaSGZua0ZD?=
 =?utf-8?B?Z0YzYVdOK1ozdFVGTE9DZWh1YlA2UnoyVE9ZaWtzWmFaL01CQ3VNK3JOd2Zl?=
 =?utf-8?B?emc2VTAxQU1wSFF1elhJTmpRdUNtR0hQQU1SMk1CZmM1ZFhia0VTWVNCK1BG?=
 =?utf-8?B?aktWMlJST21BY2ZQdzZzeFRYcGpQSkY0L1ZoRWZTVVgyS3QxYUpYa2thUVZQ?=
 =?utf-8?B?b1ppMnhxZ0M4dzV6VXhicmpwVWQyY25qYWhnNmtjdDQwOUtwOVd5eUkrdHph?=
 =?utf-8?B?UG1jZ1pRYjNaNFdYZXlMMHRFVU1mbmV6ZmpSelJhU3hDaEM5OWZ2ZDNGd1c3?=
 =?utf-8?B?TUp1ekJGZ3hKYTMxU3owSFJoTjRoTHN2QmNwbFIwMmNEd2srWWxyTnBta0pw?=
 =?utf-8?B?c2p5eGtaaHBEOTl1LzNIVlkzQWZqWVR3VllrLzFmcVZua1phOXZEU29DSmtW?=
 =?utf-8?B?NE5mYTdmNGNYc1BjcHhJV3JOb3BUa1QrYXJid05zU3hJb3g2NkpZZEZ1eVlF?=
 =?utf-8?B?MmxrN2FEMElrQzRvc3ltSzBwWGpoWi9MSUZNY09lMFo3UThZa0JOR2dOemlS?=
 =?utf-8?B?eHBiVmUxQUkyZk9qdVpzNkkzSWhsQXI4UUFxbTVKMW5LYVBvdDNyaWlhaTZ3?=
 =?utf-8?B?bXk3dWdDQm5SL0xOKzZJUWJZTUFBbDBPQ0FZL1piR3JSODFyYTJXbkJFQ29H?=
 =?utf-8?B?dTRldUhNTkxmaXJQRmZ2bnVveGVmS3V6eStNV2txNGEzcjlRKzJPVW41RmFt?=
 =?utf-8?B?aWN4OGFXcmpqMThtSWg5S2lEYWp6aktMcEJnY1l0OHVuNmg0dnFNdGJaeW5t?=
 =?utf-8?B?QldhbE5zUGVhQVB3Z2Z3U1E0YmZBNmVOVjNweEtNL0l3TE9wVXBqSWN6ci9u?=
 =?utf-8?B?RHN3em8ydysvTVd0ck9ScHFpbE5zUGhhZVp1Y3VUSTlsUDZ0dlF3bjY3R0NJ?=
 =?utf-8?B?VlhIanp2UjcySldQamRhS0poZmpLRTVNZnFKWkR0R2swc0JhYUgwSlhmNU1t?=
 =?utf-8?B?emJhc2c4UEJJR2tObFlRdkUvZUR0VStrTU9xRFFIaVFIRnFHNW8zU3JqTkFG?=
 =?utf-8?B?clFiTW5FWXJPQnlmYmtyVFgzcXU0dkhaMGt2c0xZSnN1RkhoY1M2aGtuZTkv?=
 =?utf-8?B?SUhEOFlWVGhaa1dCUlRYM3JHeDRDbktVaVYySXQ2Y1BldTBHdmRoV3FFV0l1?=
 =?utf-8?B?RUJ3OXNSTHpCeWJBK1VwbVRRd2orWHN3dm4rT1J3VFFBbThwVnAzQ1J2Ykt0?=
 =?utf-8?B?bW5pMjVKaVU4Q3VWaU1GUnVMaDZuRTF5U282NitMZGduSHdDTk9YWmRKVDYz?=
 =?utf-8?B?eVZVY004NWdzR2ZFYVNwWUgwYVlMQTdTOTU2bmh1QmtEb080bFVkTEp3T2gy?=
 =?utf-8?B?WmtHQzl5am5XR2Z5Y0VwOURVaDdTd09nYTMyc2RzMzd2V0FSakc4UnJiSHFE?=
 =?utf-8?Q?RNQw4tx2eLU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alFnZkw3eDZueUV2MWNkQ3k3ZVlYSmVva2VMNHMyWEVKaElkdmNOZWRmSkNk?=
 =?utf-8?B?VXRFemRGckU4MWk0YW5mZVlXSnA5cjVadWN4Ukk1SnYvVFpZdVphaEU0NkpB?=
 =?utf-8?B?ZWhJWERZQmVkMmNSR2pETGErOHhMZDYyVk5rY0tBYW1OdUZpNnhsdXdDVUYz?=
 =?utf-8?B?SkxsNXZSM1dubTBHMCtOaWIyVzFFMWdEUlBvVUR1d2xvVEZTdnpJTEI5RjdG?=
 =?utf-8?B?RDZqd0hWZlAxei9oSkVYcFZ2QlJWNVNCZ1ZnWVljeDVTdUZFRDZVYUZIaGZi?=
 =?utf-8?B?Nkk3ZTExNVR5OG5JUnBHZmxRRVp2T21lNERvRmR4R1N3RGd5dUNNSndjMXR4?=
 =?utf-8?B?ajdIS0Vkd0h5MlN2NVVFYlNaVjhCb1ZzZHZVOE1KUkRUUWNaZnFScEpqQk9l?=
 =?utf-8?B?M1o4ZVpBejQ4VXMxOVYvZzc5cFN2ME9DM25xbzAxV09mOG02VVZUYk9vaW5J?=
 =?utf-8?B?dy9NNWZUck5YbjVxbUtZWSs1UmdxOUF2Qi9RRkR4VGM4U2JkVXVjWFMycHlL?=
 =?utf-8?B?WXczUmlXNVdSS01SUkl3Z3RteExmdGVRM3ZReVJvaWVTa1NhQzVGbXZiVkE5?=
 =?utf-8?B?NDJjZ01pOGZyUFcvVkt3eHBjNXF5YnRZK3VibmFSQzQ0dEVNVVdOZ0RmK2d2?=
 =?utf-8?B?VE90YnRTYkpYMVltdWtrSm5ycFl2QTFmZkNBYmc0NHhISlpjQXUzdGJTUHd3?=
 =?utf-8?B?eERPRExvWnZVZmtRMm95VlQxZm9LalAyYmxUbTk3UmRBMDlteFlHZmZqTTJp?=
 =?utf-8?B?NGNpZlBYZzdEVWdmaW9scHNrckNrNkJTMGwzT01UeG5MY3FOWDBFSEQwQ0V0?=
 =?utf-8?B?ZEFkcVFqNlhNUi9OVFVUMkpHenc4WHFSM2pBYUcwdU9ndkJ1YnBUaHRNOU1T?=
 =?utf-8?B?K1h2YmhxbFNWbVlGZnpWMDR0QzR3Nmg1Vy9BcmZ2dnJ3OFhsWXFxSW0yVHl6?=
 =?utf-8?B?N01hMldlK085SWozQ2tWaGpVQkRWQlVxNFBydkx2K3p4cmhiUDNvZ1duc01k?=
 =?utf-8?B?MFliYkxCbUZTdENGTUxBcnN1VGZjSmh0RW1YNFNMM2NmeTFNRnZRZUZJMW1H?=
 =?utf-8?B?ckVINFZFcytNODlGbjVXUzBzc1Z0eXlucGQ1bjV4aHhNMktaRWtpMDRtRkxG?=
 =?utf-8?B?ZDRnWXhpV0ovYlVJU0tTOWZ4Nm94UHhxTC9CU2Z2Rll5UEhlS2dYU0dPcFhL?=
 =?utf-8?B?YWhwQ096T2hLclpRRDdwWXBJMWtDNnlkUUNMUmVNaytObWF6czlTay9qRnlX?=
 =?utf-8?B?NnN1RHFVa29MenVvakYxaGVVbmhGb3hJVkxtSmVOMlQ2bnBHalJzU3Q1bTdj?=
 =?utf-8?B?dXpFSUg0d3lWMklnRXliUWlFRlY5cmhNcjdwYlNDdVBZUFQrakdYRUtXN1Uy?=
 =?utf-8?B?b2xROW51aWxRSWdzK05rUlJPMjdFM05sTlU0cGs0aWpmZC81QTRQdmtuN3pG?=
 =?utf-8?B?bkZqd0M3eHhaM25ndmJ4OWFLSDJSWVFPMng4dS8yMVZFRWpGYnY5S0ZDeDlU?=
 =?utf-8?B?RmlDYWtVbDFhNjBMQUFQSHlLV3pkMDJwTEJoR2Y3V2VPT1RQdzVWa2k5ZHpB?=
 =?utf-8?B?Qkk2SkRZc3pKY1RjTnNBclEweklMdHU5bFZjZEVGYVMwMFc1ODlENXgzTGRw?=
 =?utf-8?B?Z1luNk53QW42eGlFUktsRzNZbXFHK3lHakdTZC8zREJPY2pRZVh5dlhSenYv?=
 =?utf-8?B?YXhYUXI0SjlWRWxwSFlnM2wyT203QzNTUi9oT2JoSlNCdCtiNUpOcXNGN2dL?=
 =?utf-8?B?KzUvS3ppaHZ4bDRNTEd1MkttWitGR0p0YVB3cDF4dHduZzhPY2Jaa0ZkNURD?=
 =?utf-8?B?dkRxVDZTdFFZYjc0bG1Nalk4OVZOek9SckkwRWJpSGF6MTJUQ3o1aDFlR3JT?=
 =?utf-8?B?dkhKVWZJc2hhVnllT3NGdnNzWDBvSUtkOTB4c01tRnpBbml5b3VMeXVjVGJO?=
 =?utf-8?B?d0dqNDFPSWJQVFprZ21TQ2hVam0yQ3lZdjg4dEVsNTZyWDRLdXhvNy8wT2FT?=
 =?utf-8?B?bkJHRGQwa0lPUWFqTmRtd3RDR05PbjRnQitrUDdSM242aXQxNG9YaFZKWlkx?=
 =?utf-8?B?cTRWd2NtS2VlZFd0a2R5OFBPZ003YTUvajdqTEtINGpxUy9tcGxWdVRzaWRY?=
 =?utf-8?B?QjlpRXUyYVNoVDNiRUpBT3lmL3VrL2RyY28yQnJqc0Qrcjl1WjBlYzlwY1Y0?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gxV3RxIV/ACbp/49voU86zcnOfME9HWvXPwQXhCxbrZl+DY8R6DV0naSfGJCcrRgyW6m6uuTbck6EoBjyNaplMg8jTcQAnG+XwR7LJJ5yPMHFcWLBxafji/x6NAX+i8NOHRHNitNuu3jRfWibQr1HEJBrKpC53H5JmmPbrjZ/KpW2COugtVXBK+0JU9KPERZpOQQVS9mjSBVjd6amyFsav0F8tNLl1+vEDRaJ+vZkO0xB8no6AR06VyzUw62isnhf3DyB2nCVJdoU9Hk12Zy1pGOAofrHl+w+b3j+0jjUSoQKnRmD3H+BPVusWYoxTb6UzRaCIDxY4Q2w/ZFPiOvI/CVRH/x9WFfk6zvXXFZUCJfKWtymZN/TMNcZ7PXK0yZm+irih5rIH08vRYfL4oALMkQHXMKtdscvRRgiSTjZfazvo4vwUNrBFuEGZV1UEhI7mYfgkc67bvDJYsiX6b9el2UbSFMNHheS5yb4OuWCxPdNhwmL7sSHmtnDKEOUZiZ4bZsAd15lwz/7t8wjtFPaytJ/Vw2qCHQT/DpLsdf705CJeFoD/a5iLxHz6jHasGGaVNm8zGwifTMWSRbFA6nIs3oXVQYeNM3K01zcAPtDso=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2442d4ab-3fef-4d0a-7134-08dda9bde458
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 14:32:00.3667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nN/YGKumeSKVEGng+Xo6JbWutrgL8ZvUA2mmImYDWKbUeyTc9jtRcK9B64MXna7gBgGybOQ2QIPFA+tGJMZ8BvPjJa0DZk7rbKIo81zxZKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120111
X-Proofpoint-ORIG-GUID: OoHWwwq68b95NSpHauxJWOU2a1YVCh-y
X-Authority-Analysis: v=2.4 cv=EJwG00ZC c=1 sm=1 tr=0 ts=684ae4e3 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=NbXqfkCjWFNbEn25b54A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDExMSBTYWx0ZWRfX1s0s/C7jbXWO LPHDkxdE+L937m+UKUThfkHvPKBLj6sxe80gRnXtHeyxaDDw7lqTAs4Vvhxs9U4yo7m/g+54189 buaavndJueZtljr8K4of8a9khQX0jU8MS/16zwjz/OmjsH1IG0MdJib1bMlCsayP1jXCv8ayf9q
 d3lU+CALyCun9HTPTO9IsmhKKwFdXuPdex4bSUoLZnE2c4f2/Nj+0wArcBWo5wwuTG0Sld/G3Fb vcL5gQKMB6Thlm6Zp2oYcGWm99DcTMR4ZWqTCUuTFB9/qXw/hB0gLYTakNDuN97L9NF4PI74cuM oYeNITfHcBvcf3EADNtL+3sI2gYeprCFyJzHSz4ok+CsCys5iKEV6yoIokJMSpmNyF7BszAPq/Y
 49lLm4cIzyCTuXGs6ffDsrOp+Bti2WE5hv7LEFzlhA22yoizHSdK6krmL5rK6LPHjwSVkg2d
X-Proofpoint-GUID: OoHWwwq68b95NSpHauxJWOU2a1YVCh-y

On 6/12/25 5:15 AM, Maurizio Lombardi wrote:
> The function core_scsi3_decode_spec_i_port(), in its error code path,
> unconditionally calls core_scsi3_lunacl_undepend_item()
> passing the dest_se_deve pointer, which may be NULL.
> 
> This can lead to a NULL pointer dereference if
> dest_se_deve remains unset.
> 
> SPC-3 PR SPEC_I_PT: Unable to locate dest_tpg
> Unable to handle kernel paging request at virtual address dfff800000000012
> Call trace:
>   core_scsi3_lunacl_undepend_item+0x2c/0xf0 [target_core_mod] (P)
>   core_scsi3_decode_spec_i_port+0x120c/0x1c30 [target_core_mod]
>   core_scsi3_emulate_pro_register+0x6b8/0xcd8 [target_core_mod]
>   target_scsi3_emulate_pr_out+0x56c/0x840 [target_core_mod]
> 
> Fix this by adding a NULL check before calling
> core_scsi3_lunacl_undepend_item()
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>


Reviewed-by: Mike Christie <michael.christie@oracle.com>
