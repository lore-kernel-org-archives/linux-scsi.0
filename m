Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4684712CDA5;
	Mon, 27 Jul 2026 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169341; cv=fail; b=eCRB/E961g5Q2ncCrSlb3tgw1am8lupQfLTttmk8R+hv+RiakHI/A7PaUwLiKQDAEHAWpwGJiFgXs9OhFbrGWbQQRonH5SLCI1ETqwpIzN0u0ABl0fsMJi5WSf3gi5/bY4EaAN4NAc8fjJ/dBVhTlb7knp55Dgc0JjMtrHe5lVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169341; c=relaxed/simple;
	bh=uOJM2yTFepGKZsous2pYrLF7J8Gt9kHcLslbNFWugTU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tX1KRwgOc82EVSiBEk9KiR3+kFKjiy9Ux86Rvcg6L5uj4Ga+lNpUeVCbMyb6v4+LR3+iPgpy04H2BH9JP2M2Bu+k/goXEu+GxCqZo7pAJlGL+IUBbONtkL3EDjZkZpf+XGC8o9f/D1N1HbiVVxJ2j6+q8TthbFy9mAPvs6+IjhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XUFZKReV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JofD6R2T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XUFZKReV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JofD6R2T"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RGE1832480370;
	Mon, 27 Jul 2026 16:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oH24S8O7pj/iuyh1o1Mbd+L9eUNd8TsZ0hy4hzwVyOM=; b=
	XUFZKReVEB6hEV64qjhU75AkHgaKQd+BZ+pPoRexeuDmaOQwA05Fz8NfB7yJdZ5g
	Bgt9OxAoO+135IVwG+Nd6CCWnout9h6+12F3uOfuxvO6CRIiYPfgEJJzJQbxp6G6
	+FY8SvT459xJQ8YeN0Qm9dP1uuH0Ng12YzJZ5mJjeO3BusLNlYcNrC04Z5DdDN3a
	pClhnuxsdOGL/0dqwtcLan/lhQR7ms7wqKTgquqhQ86RP+FAGquOWt1Qij1epeu2
	3+8JcwGtM3qxsaiwSp5NJrGAna4rw3osy/lB9KXGKnObPu5M9vJSCMIG89tii+es
	rJ86FsWoYNwiRaMS+xVteg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym24u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 16:22:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RGJvIE035171;
	Mon, 27 Jul 2026 16:22:16 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010004.outbound.protection.outlook.com [52.101.46.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehf902-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:22:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VW0JjGAUnOyfnJyjZMLngipOaXhNB+VFnAYKVirXnIphq1aSd4UtqFKjwcoOIDBpBUJaIiRnJ5ITlGPujIqAAl/OLfv4qGdXJmDfANlKUR+7TGUQ/uNL37dCk/EdpvFH0jw0NQ/FYtFwBRo1raopypH7+2Kt1eNFeFEyI6dsIfvvOioRs9YY6UDE2ildwlF5RBIDnyE/mk/9CUEhAg2psRM6x0ywzsm57Sfsy/aWIU09tw0blDzvk2VCMhZuNZmSeyksjfRU0BQheyxKZjFKvc0PVatENzzDoFbJ9OvN0/X9u0Z5VPMERfOeEwGBfVIB8UFmo9IW2UHAuPval2+ucA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oH24S8O7pj/iuyh1o1Mbd+L9eUNd8TsZ0hy4hzwVyOM=;
 b=UPDtrIMFjpJY7l6R9HaRdmfQmnRZaQjdWzuefggE8d21fESwQsLTXaVNDXFnksjjU0DjrCxch7SYMohf6CU0e0BzEyEkVwQG/N1VxWVWLIDTfwKihuGx8ZYqJbdEBaDV/T1q6FgfDtGmzJz5h0mMawaqj/Sq+evVvvT1qv3SrEtiKi1Ju/23c13VrunuNlhehlsXrL/MM10wRbwSUWRoQLJoi4saH9ZDh4etHnVwFnk9Eo9i4H1X7t/XlG50DCgQhgX0uST7khbQQuyChluHNZ/L0DVEp4Xkpfht1rvw64DFD7iJNAw9TilINt26oGlaJoXtSFyXjbvetXW2tZVYeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oH24S8O7pj/iuyh1o1Mbd+L9eUNd8TsZ0hy4hzwVyOM=;
 b=JofD6R2TnjIdKhSS0L+hblR1BbTkFiVcR7bR4cF+ME0Jtr3YskQxz/GqmhKAbnDmxHTiiOCnYSUHzNvnrYdJaDR9MjKxGv2xEOIyQFQeRSJ8sy2EX6M1TlHQxZ+pLxLUMbScVi8IazPGCDgLS89LtDtzkr1JllE1kIKVJnkWNDk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SN7PR10MB6953.namprd10.prod.outlook.com (2603:10b6:806:34c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 16:22:11 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:22:11 +0000
Message-ID: <9877bded-b596-4ecf-9a11-4c3e8f9bd127@oracle.com>
Date: Mon, 27 Jul 2026 17:22:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 23/27] scsi: sd: add multipath disk attr groups
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-24-john.g.garry@oracle.com>
 <20260727152022.C01CC1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727152022.C01CC1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::21) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SN7PR10MB6953:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b2d3a0e-6686-4ee3-2c9f-08deebfb362c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|10067099003|56012099006|4143699003|18096099006|20046099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	kD7l0vD2FLsmTZbdvKFuM0eIVz/KVWuVeDaM5zjTrKcAQ0nV9N/5re0z2twYJKTqJIZ6EePeK87ga5A59SM91eeeAzPphWxLdk6RKUU4M9/pos98NFId0ZJE11Ys29pLSK7Svm39/o9iM+E1k84rsDSCI9JeDn4fECdMK1/jipT4FBcRgM664tguxBGeoKKn44cyOCL8/vqvdaOymTXENLuwvTQPXCvKT5wBFio/cy3Elw3h6Ix2YunLQb9SApwAq2TTXPU3xKrgoDq+DtXBeUsRr2sN9DuGi+Vg4rHuo8+T3l+VrbiAeM6QPuSBjsGy0KSjNZ4+K08dHjra8M+ut7kSZNO26Qe0FKz2wPTkNUSIeInMB840xwpmwZS79KSP8pmDK0d/wxVO1YyHDUCi2fzYiW0Q9ZJtQzgINoNRhyyuOW5vF17ouEG3PUe4/M0ACNSpmF/hLrz4QBr+6KOsWrSfeov0BBB6MMP9295tu3+YUzTFQ2pNL8AdyCI+ZDsFVJWRxbsQNgszwW15MN2VWkz7lbVMuZujmCs+3rKz4Hfam/cjSFkWvXuiX9uZnpNUMwH6bW/gr8ZeNwJ0wLPq+DqJ/BrZBDnf+ACqPjj9Juu31ouUQqxmen5WAtG4sfFo3awLqXEmi39xiLKqOZ4j6E8PmilzUoESaRugyvOyC54=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(10067099003)(56012099006)(4143699003)(18096099006)(20046099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEtDcVk3R3MvbTJGYmR5WDR2U081VFpSTkg4aFY1NnI2RGp1dzFvZ0VWUjBO?=
 =?utf-8?B?MHE0T04vVUxVUWpIZ1NmWXJGaE9hbE1Uek9GY1ZTa3lKd2xBZlJsdFFXU3Qv?=
 =?utf-8?B?aU0rNUdpSUJMNi8xWFgyN2FpMnl6aTMyZHhQa2M1MjFZWUVZaXVNTWpzZ2ll?=
 =?utf-8?B?YmRLV1pwbm5RTXBtTW1nMEhkSk94TWx6ZWEzSTdpRWl3YnVzTVFoYTRUa0pQ?=
 =?utf-8?B?SUJWZHk4TFNLOHdKVll0UjhGbE9abTE4K0FBTjRnV1BUV3VRaU91OE5iOXJs?=
 =?utf-8?B?UVVaNTRZbkZWRVdITEpyMmlscGY2dmFTSWRBUndKQkNTeU5jLzIvb2tabWFy?=
 =?utf-8?B?aUlqTmdLdjZBamt3WnRTWXlRQzFpTHJVZUd2Nk1zK1JZNzBac3FyYmdLd1dv?=
 =?utf-8?B?ZU92cVJVbExvdlZQUmo2bjBSZjBVS3VsNzdIc0ZYOFJHY2pMdG95T2VJQUVm?=
 =?utf-8?B?Tlpobkt4SkRiMkw1amFDR2dhcEE4NklsT2x2VVl6OVNiZFFQVkp2ejlXd016?=
 =?utf-8?B?MWZiVktrN3Z4Tm1ydmNEaHFDTUozMnJuenRvM2wwNUZRczhVWW8xQ0pWVXJ5?=
 =?utf-8?B?dmNZaWlSd0tUVG1qWVMzMnZuNXdXVkVtQUEwWUhwc0w4QUlJSFF2dDB6Smlx?=
 =?utf-8?B?N00xck1KZzhldDBKUE9iajVNazcwWnh4TTEyQnZWVjlFWG14N0t5dkVkcFhO?=
 =?utf-8?B?STRRZVl6SEsvd3lLeGZrYjhURzlBU3NzdXI1NXc5NGxxZHJHeGQ5V0hrUm9V?=
 =?utf-8?B?KzIzc3I1dDFwbzlCMlhJM3lSZjkvZkFPSTYzMXZxbDZKVlJtM1lEOTN4M1Zk?=
 =?utf-8?B?U1lGT3phSHBJeGNlQndjbHpHVGtRWm5Za2dOVGhHdm9FWW9nZmcvOTFxcksz?=
 =?utf-8?B?cDlQY0pkRFVWY0dqdGpHMWdlSWNWN1g4ZHdmWGRrMEcydE16UTUyeTVKM0sr?=
 =?utf-8?B?ZnI1UENJemx6TXh4VFQ3azRPV1RBZGpVNTlZeWlOZG9scXcxUzdBVlMyZG5v?=
 =?utf-8?B?alFBcmR4VmdpWFBwdElYTkxEOEIxcDFjMTBjdENEVitvbEpJTVA5STdyVmI2?=
 =?utf-8?B?TDhUN0FJaHNDbEtLZHpyL0YwQTBtM1NCTDhHRFRGNmlNT29iS3FkV1FHVWhm?=
 =?utf-8?B?QkZQK0d4bVNPWEFWQW5lK3IyOU1RRVc3MFJURFBNekZzVCtNWnZ6WjViUGgv?=
 =?utf-8?B?SkgxS3hkT0hLY2lvK29rRE1OS24zNW03dVRWcUNWN3NnTG92a2VVUVBKYTdG?=
 =?utf-8?B?VmRiRmJnVHNkamhqK2wvaytOSWVQcWp4cCttUnAzdG1oSDAvU3RWK3FUSTcy?=
 =?utf-8?B?dGRnRWpiN1UyY1dXNzVkOXhSNGdpaUlSUWtkZnlYa2ttRmpyTFowZXJKVVpS?=
 =?utf-8?B?YjVuTzA5dFpJQ1lDZStQZFFlR0Y4OGF5cEIxWXBBK0toSnFhVERGSTN5bi95?=
 =?utf-8?B?WVFTS1didmFPVTRMbjEvMWZSZkFIdnNWSDBBdWU3N3RJZ2p0dnpMOFF3VFg4?=
 =?utf-8?B?VXBIa3lSMkFDT1YxL1Ywc0pYcG9YdUtVdGdRNnI4bk1HS3hNWW1QRklobkNn?=
 =?utf-8?B?RWhudGltVEYwUGZYV0RSOGNUUGdFSGpXWVM4SnZGUDRDWFpuL2NTdkVTZERM?=
 =?utf-8?B?eFZGR3JMZEtMVWw0VDZ2dk14eHhaaVhjNjl5dGk1WEVJWm1KVUV1SzMzMEwy?=
 =?utf-8?B?dE9wNmFsUkxmbU5weXNRKzZwc2g3V2tMams5Z0h6SFFFdkZtdGVSY2xjZ2JU?=
 =?utf-8?B?RmtsS0lMU0s3QUZzallGQk9pNDlRM2cybHdlNnhkZCtESnUvT0IvV3BDL2xD?=
 =?utf-8?B?RzNEZ0ZJRHJQYjI5SHZEWll1Y0k2Z3VxMi9keUdZL0E0OWNuVlZFN1ZCYi9h?=
 =?utf-8?B?N01tM3Zoa0IyQ0Y3ZlFMQ1drYVM2eE5HQzdGUUJKd2cxRDhIZG1vUUh4empp?=
 =?utf-8?B?RmxLYjc0MUxwSWVubllPTWI0VEJKbmpUTHhMRUREeEZDZGREbFRSczBHeDJV?=
 =?utf-8?B?R0x2MURPd2ZJU3A1Vjk5TlByeDNKYzhDaC83WHhYeGwrZkxvUyt6WmZZWU1l?=
 =?utf-8?B?ZEFISlk2emE3MTEvWWt1a3NpYmEvdDg2dzl0R0tOVUh0N2Nab2J6NkwzNmVo?=
 =?utf-8?B?c0Y1U2p6S2c1REZuNzJhRVl4WDZVQk1QMDBONXZKbmF2OHppRVFzUStrRHVy?=
 =?utf-8?B?R2ppUFFUOFNmQ1F5bHllWXJ3aDNNZTBoQytCeWlqWVhCNlRZbW95dEw1enVC?=
 =?utf-8?B?QldjcnRYNm9Tdk4rVTB3SXI3RTZhL3BVbkJmTlRJNDluSjBXTkRoa0lLazlJ?=
 =?utf-8?B?eHYrR3k4a3BzMHdnNUZHYWYzUHVEVk5rYUZxYlBrSzRQQjFVRC9sRmlhWFk2?=
 =?utf-8?Q?YiV0nAh/o+618C04=3D?=
X-Exchange-RoutingPolicyChecked:
	jCrjeXVk1yPwB3qJilRvBw4HVEMMal3y4yLJzO6/FkYl5fndN2dV0UnQwKBcSPGEfejEaFyUTgGeq0UrbgTMdcqAPzYYXWmNEaeQusyblcXu4rfz8bFWtwFB+NnOOj9wni7Y3/79NCBnIuFZO9n91fJ3jINKqMu9z49jo9qPatyk1VayNbjSBlf3P1A8YN7LVQ3EMvdzh3mFmEKgerFqeakm5PrNSegSWOTT9l7k2GDseWtTBqPy08Co04LVszixUlZXeK8caTswIvYh9q4z2bDJAKr1B0r7tfzP8mSFLkswvdZGJ+jyGNHx0Jt5Hv0ANQjV64UXGCJVTMRVIlihLQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cdpMzGY40v8ONkqchtCxDAJvNnfDOVEl3v+rhpGZUVyZlKpqhgRiQLnPYn3eOHw3wpsNEOWVrX4shGW1LXSofMSL9iuvYju06JskxG5l/pP7tF9dcsAYdTX8PdKCdEMZS6TwvfDh1KwIaRdqEIxj9yJB8SpMcBh/QQ/aIQobVOgxOLOVvmK0+61zXMLKK5Yv9af809Ym7n9Tj8DupcltVxVZo6M3jZ1FCFzT4m3EJV65h2egMitlRylvb2dWQa+wLjUt7wU2+RWYVF0+0PM8WPbE1Y2xff2hCrL/bjVUvstmhZdxD1tMQkfOMQz3iJ7S6wwk6zFYgluxY7EvuhtMbyv9fosex7QEtV1qCiGXOEq+2UayoWHiqfEnUMSroJzGw0PGojyqVmp4GcrOX8dT1lu46Z1WmOXnK7Q6fNegO3A4jM37ZUq32msbZkoiA443x8nskeo3Koeg1PysBT+7SmHmZfuL71ML84PNZGzGUcsQtHvbVNhmRYQQyBUUuAZs7IrvxatLCxgIGklppLRHKBIbifPwY/xzZoh+3FRhyvg0NjliQxMsvFEXpVxpYYg7S1743whnc2CIYAXl+ASlugu1hecJoK9VtUkPKFH0/UQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2d3a0e-6686-4ee3-2c9f-08deebfb362c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:22:11.3232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gk6mS4AULJuf4aO7ayV86+kCaf1mnoo3F9pq9Ps8IygEv3uap2Sl2f6/RmH3q/yOHFEup5hF5VNrLXBNlyuAag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6953
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270152
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX6PFZKDVdMJgL
 7TgMvWUWIz78ZIII4EDtYJqRaWR1k3WvVDxxGYIVR2a1VrAMTLoyg6xihV9MgqfqvJdO7w6vxt7
 CgrtFv1angg32HIiqKuSZfoii+ZPU8RSPBLcOzTYWHh7DEm122MW
X-Proofpoint-ORIG-GUID: TBBf0ctcMScqIUWPJkmfSB7A-sgx8g1C
X-Proofpoint-GUID: TBBf0ctcMScqIUWPJkmfSB7A-sgx8g1C
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a6785ba cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=UGIsTnh2p-wL2BCI6BkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX8GdMh2GUTwpt
 kbSX5lDunYeCvb7rGS0RSkyhUc1nQDN3TdQ7qqXYrPzLKhOf4eEqqZa1LGcTYz8JKgKSreiZ0q8
 4Fs8pIQ/3v1IRxNfhYoa7W1u+Fm+R0dKWnb8n5BCkxnMEkGGIrcCburvzf8anbmT2clO88QzQbH
 V/GxlLyUhBz0t6rSHflApDEBMlQR28bbidOMr/d2dyRZqRi79zfBUayULAR1aTlpwxtFxeE5owm
 L+UkQhG0U2LODKAHzrykjlrermtV8v7B4iQXbYGfHmdUmURJjDsEiFTbPcwGWHBwLoCDJvDH7Gh
 QPubyagFlvXJMoY2035PbYgGHWRB+hHv+KpoJWrDjEIvOck3E7LqDKWlrrj3fRxgH+WeKaeXvuR
 EZh1UCLIjkbFlh7DiVF8WFG0EqJEi2A/vKWu8bBkScSHgvjK0oWCAe2QG/4eswRbWStqjKLdLhJ
 d86pkUbGM59jvF7pWGg==

On 27/07/2026 16:20, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The newly defined multipath disk attribute groups are completely unreferenced and never hooked up to the multipath structures, rendering the feature inactive.
> --
> 
> --- Patch [23]: [PATCH v5 23/27] scsi: sd: add multipath disk attr groups ---
> commit 54820f0d02e2f6d8f0530b7358f2376bde300894
> Author: John Garry <john.garry@linux.dev>
> 
> scsi: sd: add multipath disk attr groups
> 
> This commit adds sysfs attribute groups for multipath disks in the SCSI
> subsystem. It defines attributes for delayed disk removal and includes
> everything from the existing mpath attribute group.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 242a15bc2c5bb..36c745cbb2619 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> 
> [ ... ]
> 
>> +static const struct attribute_group sd_mpath_disk_attr_group = {
>> +	.attrs		= sd_mpath_disk_attrs,
>> +};
>> +
>> +__maybe_unused
>> +static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
>> +	&sd_mpath_disk_attr_group,
>> +	&mpath_attr_group,
>> +	NULL
>> +};
> 
> [Severity: Medium]
> Are these newly defined multipath disk attribute groups missing a registration
> step?

they are referenced later

> 
> They are defined here and explicitly marked with __maybe_unused, but do not
> appear to be assigned to any registration structure or hooked up to the active
> multipath structures. Does this leave the new feature inactive and the
> attributes unexposed to userspace?
> 
>> +
>>   /**
>>    *	sd_probe - called during driver initialization and whenever a
>>    *	new scsi device is attached to the system. It is called once
> 

