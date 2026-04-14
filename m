Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE91839768E;
	Tue, 14 Apr 2026 10:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776161031; cv=fail; b=W04p9j3GFKNyf1Z6eCxXwg7zy3CM9Cw23GGmPHSLxcP3z+MPUQ0gR0JgYj3V9SEANQJ/7IE+IiDkaVEbxcWn0XW+uLNT/MNmwH4lr36TZZdsuQUEDuuO4oWBK3eRFi0rKyQJqK94R2D+sPf348KCoVoAGdY7yjcwlBVHDeqMbkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776161031; c=relaxed/simple;
	bh=tT+BVE1OxVPBLck2pUh6q2h4vuIbJQWXvvxFYGPLJ6Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=srPBz79BBvaANAKR8P8jPMsWGrS8FlP2kUQ1C5/xStaLwpXxfIrIz5hUqfgUL5/tvv4qd+6hBKO5yOdqKIIhQ6apg/yQgl9TStQENvAVaeJ8wLH3zHtpWIHpXiFt2GE4KoiEkm20asJAiSrLKT8ZscdZ4fdrYyZdwDcehN2YN0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nmj7myuQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aex9EtEe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nmj7myuQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aex9EtEe"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63E9rJBD778563;
	Tue, 14 Apr 2026 10:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QO35SHh6NQPmbRywz0IRMkF3ZVpzFzYurDC9Bn4AX1A=; b=
	nmj7myuQY62/rTHJ39K2b2sSpYDfTNexJ7uGLpy6rcaKGbOdjyZTNzKiTWuMrFX4
	kAZEkyInA+3Rfo5APT/x62nbwVRFg1NEjVvJOztLw1DRdO8fR9ylXdBTa5rhLkGs
	BbSk5ecgU2ZWDf8smwfi7JmDzbpUXyMxfdP3tVPdWBWu66v+84AGjtH1eHMRHlQm
	VirxHhjm7NyJnhrUpTzXSuU/F0e56Zsip1uxQy1Z5MdLJsjYJhwI415VQpXHNCRy
	yY2B3HGYfwBkv9fX3AMpIIXA+99s/YChYFT5xOO74mluTZCCXxG4eVaq0RN/kEqI
	TT1JJ9sVUk1kftbxxL5C1w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qhtw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 10:03:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E9sqk5040213;
	Tue, 14 Apr 2026 10:03:14 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nmfsr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 10:03:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKKtFbraVuCNAZqHUV7RaKIDp4Vni5Fe/Sj9Z75rD5sGs1hEqi972Rh/MSe79iWW+8JUTEauy75CxKrdVHlQrsrYOBhCYxT3sd4JyuyBkxvciL2muO5mAjHsQ3HcXJv1CeLXs/O3K4bPILLkbQvSXxdOhHAYz43/1wcljs0Sd1pbyx6VLzsRQ8dfLgxs5+zHMq0hBxIOmISZZwgZ/P6Sfx+C3SjH7pojosObN8WgN2nyKUTEbD+LpDF7D06rOR1nf87eAT9fTSt+6UOkX96B5neMoUoMaHBZGmlS01JCSIdZQ6Oiuap4JjGWLm8JmC0s3ZXdRh4rhrNxZntwuCbCpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QO35SHh6NQPmbRywz0IRMkF3ZVpzFzYurDC9Bn4AX1A=;
 b=G9BxOHFBVK/EgY0OsbIG4ly1WoMZu6puRdCVO5iGCa+hLIGpIHvNZPCQEYJJLi1ptrwN2G6N6Prspb16+rePRLwNA/ANcLECvvqYLFZ+STffzZ4+PFymVtcifAfwNcqI3IarJww5kKy5twTrxG+blVUcbY/0OrvhPJfXOiJkbbv9QESe9Pn3NlXoFt9dpAe7o4FRAAmgDtaXs90urKeUGhyCWxa78GZ0HrLXs3z2Bf10jNFm9sNKT37qY53tsyT/dFZwbZsjCfVkJj4oYfCFEReUFz0TT8Wc7k5/9lVqxdG1zElLkn8cwX2A4zZf3hI2GjrsC7WReNutP6FI+gM9LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QO35SHh6NQPmbRywz0IRMkF3ZVpzFzYurDC9Bn4AX1A=;
 b=aex9EtEe8e9RBShr5xS0dq+MYmd8ypMjnR7eIfZ4dNP7AYihNxZxNMTHs6rchne31KujIj+RSLeLYh++6aaO0kJthuaLRahrXbvFszB9uXqKj+b+lPcTJsossS5Mv/9i8ZrpVaqijTmfufalxSzozS7m8wjyhXZ/3TFpQS1B86E=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DM4PR10MB5918.namprd10.prod.outlook.com
 (2603:10b6:8:ab::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 10:03:08 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 10:03:08 +0000
Message-ID: <bc18ad6f-10b1-4a28-b88d-aed5754b968d@oracle.com>
Date: Tue, 14 Apr 2026 11:03:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
 <775dd360-ea41-4e27-9690-e0633e0522d7@linux.ibm.com>
 <f9fb6d73-9b90-4c11-ae1f-3f2e76773d7f@oracle.com>
 <bb4df6e1-cd83-4a73-af67-f83c543d6e6c@linux.ibm.com>
 <bfd8c2c2-65f7-44f0-a4ec-01158e249505@oracle.com>
 <02288590-486e-4243-8352-c756c6879629@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <02288590-486e-4243-8352-c756c6879629@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0072.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::23) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DM4PR10MB5918:EE_
X-MS-Office365-Filtering-Correlation-Id: 64a8ce0e-de8c-488e-b234-08de9a0d0780
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	VYb8slkIFSevi2RRwexAQTPMr0eDE4KB1GVxXfyyFICvRPiYhUJpJ+/S/KsLNsAa12AK0utUeQFmFTJvHPTruSjz56WUXTCqSXzi5jQgfDHTJqqFC989VQTHESWhjMrHv9Y4NZx7MzbRc8fozAcTfwtBi9P31KLSuUk5e8srDYRGAIfCfeZ2d6z64CI/niVREuccRBPizTxVadDvHWfqzngN9RP7aymHhZ+6gtH+tn7bQskdM3T/9uveccWjrfioFuAdvddg0B08bJ4HcJxoKbBqBRU8cglkifpQObsIOEe9/NgmjLTWm12sG+yRv300anRoGbZ0zBFYANwvqfz26+agQDEOYhLwjDYi1GN6WqQTBu6ds2fviFiI1G2/jXbL50Jo9SHZ7x6A34i3a1u0bJjn4UVhLVG/5gsUT0+oBSFB4kgb94loT3ncLXjcTar9aBknuMal6yZ45o01ZKnZyuACzwnmSsWwOXrJJUSgC0OKlg0hVjKuIsD1QlbXOMezWAiDfeqPy+fp4PKrlsyE6WYnvqz7dU6YIiWwCXkIN0UxCP6oij2j35oVW8q+coN8SGy4HMgpS67jtsb8meb2kJL9NNqrVl2bjO64WYLjnCLX+Jh/AOIHmsfpITIKIBG5sPjfnxLU5Z5ZdHnMV0lbEC7vy8hj3OMd9yoaFU8458EG89dSZa2wxMM5gn3lRK/oPlwddm5fSu1/zPvgzfvtUoJnBkqzGDgkBF3ud1QYWjU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWl5aXJ3U0xTYUtiK0swZ3ZLQzdQdUs4RjNMZ25tQk5YSHdESVpoVFhsQnBn?=
 =?utf-8?B?U0RGZlZDSVN4TUM5OWhudjJWYmVxRm5oMWgzTVEyYjVEVmtlN2ZhQTVsTk9W?=
 =?utf-8?B?bEN5bHkzdGhQVktvd05rU1J2UFFmMU5BQ2oyR05WdmtTbzh4UDMrRXNnME9O?=
 =?utf-8?B?R3VxOWt6WVUweVlIVmh6TWM0Ym5IOUdoK1ZrbTV2Qjc2WG1SaUJUR1lCeU9s?=
 =?utf-8?B?RTltS0tKMktDUlFxQkE0QW1WWEZXS0tiS3B0WXY0RnhwQk1ZWE0rSGVxVDdV?=
 =?utf-8?B?dGx3all0S21iQVZQNTAzMmlhY3BLOXBEM3NQTzFOYnh5eUpmVGR6TzgwMUl6?=
 =?utf-8?B?d1FUWkhmdkZtMy8xc1VsM3pMTEJpL3RFMjNRWU05UnZiNmJPaXU0WVdPQlF6?=
 =?utf-8?B?bGU4WkVYTVJiWVRqN3p0c2ovTUN2SVZSYjY5bXpKb0JHVTY1b1U4RExDM2xw?=
 =?utf-8?B?dTB0ZlJaZnJ1Yk4xbDE4SXI5dG9hTjlJTFArdEJiWG1BdTZWUlR2bk1Iamxt?=
 =?utf-8?B?d2JIK2xETW4vMGM3VUdiS1ltSEErRWk1UUdES0RMOTM1YUh5K0dOUm5nb1Zs?=
 =?utf-8?B?QjVMb2FKWkVudy9LT0poRDNYYjRuaGJRbDNDNmNFcnVlR2RIVElWZXEvbUFR?=
 =?utf-8?B?VG9zYXpua3hUc29Ya0xDSVJrNjdwSDdkYXRoWTFLeHBDZjhEdCtJYUZqMmZp?=
 =?utf-8?B?akJVYVp6azhXTmNXVTlURFRST2haN2ZWb2JMQVh4ZDVWcjNYa0FZSHE2YmtX?=
 =?utf-8?B?QU5BUXJod0FtS3lrU3ZNanhNYTNqWjJvcjYwTGpRejl0RnFxeG9neEM2VDg0?=
 =?utf-8?B?M21icU9KMHVRQ2JzcXp5YVNid2NFU2lNOWZrWjJUdko2SUxjRmlpN3U1RERU?=
 =?utf-8?B?RU1ncFNwS3FLS1Jna09WUWFlQnlXUXZ4NjBLVkx5cDVYalpMcS9qRi9SQkhN?=
 =?utf-8?B?Z0dMakt6UmxKN0VKWE5WV1BsQ2NnZGZ6bUJSalNnS09VcWVYQWhpdFg0eFY0?=
 =?utf-8?B?Nnl0OUttbEF3UGNPVVA3QU9NeU5lK3JmTDg5bGhlZEpzc1hhWXZEdzhOUkJo?=
 =?utf-8?B?RU1BZHpoSk9GdDFUMDA0NkF0T28wZi9RTHJ4dmdlOGxhaFFTYmlDZnJBUFFy?=
 =?utf-8?B?S3Q5LzJzMmxzZUhNclp0NFpjR3RSTStNQzRKUm9WZ0x0enFabHVNU3dwQ3Rv?=
 =?utf-8?B?WDlBSVRjSDhsOVZ1eW1lNXpNS05jaXR2UDZFaS9jOUtaa081ZnN1WlJzVG56?=
 =?utf-8?B?aGNNWVVLa2tqRExEMEQweFN2L2JLOU8zOHp4Q3c5K0hjN0NiZXdqUXVla2Yv?=
 =?utf-8?B?TyszTnhKUnpFS3Q5cnZ2cEl2L1doektpVWFRajI3LzAwVjB0WEJ5R0U2akk5?=
 =?utf-8?B?UUtPYlF1bUx3THRpbVhMQW1HMy9TZ29ZY2FUaFpTRC8ydis0Z3RWdU5vV0Jr?=
 =?utf-8?B?Q1VLdEE4cGt1WVV6cVdTTlZ1ZGNyQkd6dUF4RSttcE9IczA0WXF6U0hNTVJn?=
 =?utf-8?B?WEtXalliNkdKeEsrVk5vc1RNaENRR3V3SCtPcnFUQU9XVk5veVVHRms5dzRr?=
 =?utf-8?B?OW5xd3lRMEVtVXp0Z0VIbjdlUXBxcEtoeFBoUWNsaVpCS0s3NzR6bGU3TWFa?=
 =?utf-8?B?dThhSWJwMmR1anhxQjFpUUFub2tkRnpMSUJGMWNzVzNoSkcxWWtNaGM2VjIv?=
 =?utf-8?B?bzBadTcrUE56bVhEbTlaYlhBZU9GdUlzd1YyNlVlNkdmQnBJNzQzVTQ2M3lr?=
 =?utf-8?B?aFZ0Q1UxSkxMV0crSG54RGhQdTZzWDZhY1RUQ0I1YUthRVZlM3FpdkwwZVRY?=
 =?utf-8?B?MW4yaWJzRlZBcWZkMVZrWUdmRjBHcHBtS1Axd2g0YUZUcFl1MGdmVkloMWhy?=
 =?utf-8?B?WW1CVnRuMDMwM21ZTVZkOXRpTCt2QWdjM1JJUUhpK0ZUaFhITHpVcTIwZm1Y?=
 =?utf-8?B?R3ErdTVYQ3BoZnlxdmdZcVRRTFg4Qjc4M1R1QWdMWW5aV2lEWWRpeTBpU01F?=
 =?utf-8?B?Z1k0WFdnTmI1b2Z3cGhPYkhNUVpaVmJ2M3BjYThKQjQrYlFhNnBsUmhDTk5X?=
 =?utf-8?B?VFZFemxuRG9wV3czUGFPbGVNOXdWYXJpcnZvUmV2SDc5TXBnd09QVjlVSlZi?=
 =?utf-8?B?QkNVSjhWL1puS1dWeTJqS0RZc1FFMkxQRjVDTi9LN3NlS2ZRcERoNUJQaGVM?=
 =?utf-8?B?QjFCdU9KTTBUK1RTcjN1SGJ4cVo1YTJRbUtvQVBCZ1hCcnE4eVloUFM0bTY4?=
 =?utf-8?B?cEtYc3QyMVBWUlhnM2p1NlRjRkFMNjBBbnZXaEYwdWFVTm5GUGh0SDJ3ajV1?=
 =?utf-8?B?ZWI4L3NsZ2tKVVdLdDZwOVdPWStrTTFjVS9FYzhNTVNRR3ZqVmVaQT09?=
X-Exchange-RoutingPolicyChecked:
	GDhNysC0X1zz7/RwIAkWaLRaSZjGQnNrCK8Eo55JW2mDg3Dph+EId5vQRVrW3qf2Q4PIC2Aj1NCyvYzHT/yIdHbet8rau2J1F6bNRMl/3cU9eBzA6XOr4sH4XIMvXMdY+xzXTXLB987PcJGcuKSZHJGzqOQMjvnYeqoJi2+WjhHmFtHJgCSNDiYX5CYHJ2laioIopSAo6GKhm5RpbVembDGdo/78WShBLe9d7NK3AqH9RFQM9mpojZEAI3LAdfNjinom+NjujHlN+vJ7tYsUpzl0z57Drz/CO1jm7O7LGmbtMKd2mKdnMTqc45paSzjLTo48o9wK3zZgX3G2PNuKRw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E2TA06SFq6+Oa4KHroWrzenztyp5tP/QW4r8b5ADJtMTV80xQpsNXsfCtKEkzBD9fZW1B0FmxNWxN7XP0ewbMXSc74yOMTDhTa0aVjr78j+IGyrULn24jSM3NDBrZDAw9W2qIQN0zQjm+1cCZdkChfs9TYdBTEGnE+n59XKz8h02nd22GSTFFl+ObTlpcKCwsk+V4UQS485GbQ7qkcDiJO80Frmi0+lSq2R1xG5xnBXuxQb9pNw4akAwQMsZXLvJ7gJI2yyYEgJCqaeXwKfztn9b8PCBhOFumGcBj1Q9rGtUNOd+B/kYRECCPuZc/KZGCObmhUOqQKf/S36hD09/Cuf8jYzLuXutJdtNSXhLVJd2Vp0VEFMn9SUqWCqbAOV4yTs5K049uebMw+J/Cnb3Gwe6wcavLxeYrGDxLWN+vlyUBnjDgkd0vLOzYbfv1FPfnuzKh2anBeECfmvOO+0p2BycbId7gLA64ss15o/cdqDIRfiRDVm3pKJCQQVyQtm+2SQbFY3lX9OpbhjuayI+gUkQ1wXjdBX6Q24RURbzTbbGV0L6roI4MgHF/TWwSSERJeOoD8HhCOXx2ujeprG4NwOtSX56Y9GfTeRCodU4zr4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64a8ce0e-de8c-488e-b234-08de9a0d0780
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 10:03:08.7047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vLHsuJETRuZC+gw6+z33ve5A3wf59wGFYvG1wVFxQ7OR14/D3hACix/xMdtXFrnOihNA0NcmH6M5G2TGZdZPmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5918
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=911 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604070000
 definitions=main-2604140092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA5MyBTYWx0ZWRfX5rK9rfkXuXhG
 Ir4qi/KtzWz6/kT9LUdXm31RJtN4850m2I9R3QaPIJ3sBrVGC40R2hItOKY2MpNfjJx7knKe3eW
 etJ6tNcXDdiMNVDkHsl3hoAl0lLXqDkz4Uz/PwnFWOBJRWgkORosOIWpdtcRioDjOjUL7DmpR9R
 NTv+hLJIcpHYhjZ/6BnXugjEEm5d0YBtshAXaMAUU872FOH7cyRV8onJPwdbjCeNKo7nMlsWiuB
 hVubgwzKeajUj+Hi+HlwmWN3dhOTGHhQ8V1+Eae1f5FuvWlhZhHlcywc1e9RtmjlVtJcU5KzZ9+
 DD1StbCaHlWYDWHKcMWg+rv+O/WKsRuvn2tPANpnNOH1yUSGkc0f2LmTmDxlgWaKxISKVD9imBE
 AXkuRrvx+LHYoMSsgIuOxuNxQdMEZEtKZIkbCZYIewuDYOUCFE9vaMskYLIhFm2n7LzkwGrP29T
 PH2E/ysyLc2xoeB5Wf8BZJNk3uYt+LGtbsLMtCbs=
X-Authority-Analysis: v=2.4 cv=Lo6iDHdc c=1 sm=1 tr=0 ts=69de10e4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=Ox4tpwnkimX-lmn1Y-oA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13825
X-Proofpoint-GUID: 6U-o2QGhM4tPRRIBulc6_6Ycifmy7-3Q
X-Proofpoint-ORIG-GUID: 6U-o2QGhM4tPRRIBulc6_6Ycifmy7-3Q

Hi Nilay,

>>
>> I think so, but we will need scsi to maintain such a count internally 
>> to support this policy. And for NVMe we will need some abstraction to 
>> lookup the per-controller QD for a mpath_device.
>>
> This raises another question regarding the current framework. From what 
> I can see, all NVMe multipath I/O policies are currently supported for 
> SCSI as well. Going forward, if we introduce a new I/O policy for NVMe 
> that does not make sense for SCSI, how can we ensure that the new policy 
> is supported only for NVMe and not for SCSI? Conversely, we may also 
> want to introduce a policy that is relevant only for SCSI but not for NVMe.
> 
> With the current framework, it seems difficult to restrict a policy to a 
> specific transport. It appears that all policies are implicitly shared 
> between NVMe and SCSI.
> 
> Would it make sense to introduce some abstraction for I/O policies in 
> the framework so that a given policy can be implemented and exposed only 
> for the relevant transport (e.g., NVMe-only or SCSI-only), rather than 
> requiring it to be supported by both?

I am just coming back to this now....

about the queue-depth iopolicy, why is depth per controller and not per 
NS (path)? The following does not mention:

https://lore.kernel.org/linux-nvme/20240625122605.857462-3-jmeneghi@redhat.com/

Is the idea that some controller may have another NS attached and have 
traffic there, and we need to account according to this also?

Thanks,
John
