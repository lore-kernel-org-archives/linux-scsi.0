Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB37025EF95;
	Tue, 25 Feb 2025 08:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740471594; cv=fail; b=obq05Fey9DWW1/wp/CCeT/dmarAXqg+tqXOIFhoaBErma8VDx8aJhKHmKavhDw497zAiyCaHy3K6LaivwpUaXkrs4AAlVjHad65upzkz/kFeT9xoRWcDs08BM5vTMm3Kf+dd4ceX3gDL0pXI7ixha/5vVLqjPSsZkow3fMdZQsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740471594; c=relaxed/simple;
	bh=YYGIEnfht2wosALjdy+jfEUdFq3H/gS2U7uhQevdcSk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LNViHpYbs9gjGX0WFrj1D5q/+KEAFbzsBUBnS5YMPeaHvKjqxwuJfGjrnUz2+hUlTKMr8OqPNlLvI05WuwxbUG0euIKzcf1dhL1j46mefaghAhSabvsqd2S+FjTmmNaeWzuYnlCAFbK2KCDGYR3r/9lQADJ9H4kMvRWjvWJCmow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JhlaiZQ7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ete0pmN7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JhlaiZQ7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ete0pmN7"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51P1BbTi005420;
	Tue, 25 Feb 2025 08:19:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=jXapH14O4joYPyTpYpQRgR3nd4+t2aelwKHYVExAnc8=; b=
	JhlaiZQ7DJPfnAfiRQIwctVo9++BIDQ+IiudzUmipjb2cb0yO0N8y5XhbmADGncU
	QpcMjSlcnvf3qacSYRGKCL74wdjgB/Wi1xnxfUbFWAwMQx8lmXUdEsS4gpL15jaA
	r/D70UDva7eO5k3IMJPXAb7WnKrGA+559hjXD0AJazd3ZuxzEr306uarJOMx5axA
	JF1oajdUoazwR7e76hKehNq08yR3Q28DPQ3U8aWbuM+Lrgzs8qL1bjm+RIz1SWdZ
	eNEpZ04jj+7RujsKMV7pkCHmTwsfTlUu86mefEs9pGSLFS+a2AA2SLou2UFIsJvd
	+YX+EYVAHOa81bTZAsqB/A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5c2cgkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 08:19:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51P82GgQ024406;
	Tue, 25 Feb 2025 08:19:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y518uguf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 08:19:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WhLBr3bV+NFztkgFomZXv704StAOgWtevc2XqqtlYqhe+Pt43k/tL1KtiO2HzRiAbcE6a25p4wmkF3CV8iz8cXMDz96/UDBIwn3jLl2ACEqNnMVWSYozGGRJTEmVZi/6+T86FF1DpDZP83GczYka3ihIR+68wienlqIdU4A7kakE4NNEdoI1L5o1CdrzUlF9gGuwwAdc2FdgkxlWPzAVQ+h55xRIkKT0vwP84wRgi5ijK/81SZDSi84gRvnlHHN+iyyesSdR4pM3d0kYKO29rL+SBizwPT0xyHh3ZA8cJ+kbxyKVydQiJ1H7P9bOz/+6bLsN83ZTKARSSOJSwKKKFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXapH14O4joYPyTpYpQRgR3nd4+t2aelwKHYVExAnc8=;
 b=FjK/ke06Ijsj39NeJE4H1WQ7fkJIJUiWcqMj5IPl8JYtLsEH8ACT0f5+ALmjUjQ5gxHzZ8fy5quBxrD84B915tTCk918Y2QxASFO7eVMkew6crAT9S/bpEVf5Jp417CTrg7r2qLFdi+6Mb8gm6T5aM/F3o6olPiBJokIXHq4Bc1FLxFYDMKj8omQCNBktj5INg7D+rXY7rATlEnZQHt9PwM1A/3CvsdCYa4V/4wgasRWm8I2e/SD9Kghbe97xR9OFQDTgFlx6wDKC1rYLuAZnw7N2wxg5TV9ET4EVJu6a767zYtn3pQ8VZ4mQQpdYhuylgohO2k3fqvx+bXZfWs6uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXapH14O4joYPyTpYpQRgR3nd4+t2aelwKHYVExAnc8=;
 b=ete0pmN7icG0t6/+Da9xBMo9CPw/2Dsb86XOafmSzpGdyA8x/VEOY83KWV61oJflB6Z1ALLc9DM/8qBIA7XTbxeJ0ddCxfhlm0PXKcdMA25aalxB+SXXkAwo03apXlcGbpL492KWzeh0HNhRPB0H68IpjbNtdNkLiT9PL6nYEUI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN4PR10MB5608.namprd10.prod.outlook.com (2603:10b6:806:20b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 08:19:05 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Tue, 25 Feb 2025
 08:19:05 +0000
Message-ID: <420fde94-28ec-4321-943b-5cb84cf14f0e@oracle.com>
Date: Tue, 25 Feb 2025 08:19:01 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
To: yangxingui <yangxingui@huawei.com>, liyihang9@huawei.com,
        yanaijie@huawei.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        prime.zeng@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        liyangyang20@huawei.com, f.fangjian@huawei.com,
        xiabing14@h-partners.com
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
 <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
 <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
 <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
 <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0274.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::6) To MN2PR10MB4318.namprd10.prod.outlook.com
 (2603:10b6:208:1d8::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN4PR10MB5608:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b838707-a2f9-4c9f-6d7b-08dd55751137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTJMQllwYXFCZlhYSjVOa0M2TmIxb1NteGRrbXg1cjhrYTI3dUFRTDM3eHd5?=
 =?utf-8?B?VXhVRGVVcUFoOEtBd09la3V4WDBtWjExbkxjRkh3OFhqMGdmVGdCR09WaG1H?=
 =?utf-8?B?UjRwUFRHOUpoRXIvcXNZb1lYWjZUdzQzc21MQ2xNS0JIL1ZjQUR5cCtXOFRi?=
 =?utf-8?B?OHhMSDFETmxIY2VnVENLL0hGbDNla3dOemgrZUo4RWw5RS9tTnJmRDZPMmx6?=
 =?utf-8?B?R05VUDYvazZsdVhsejJlWFJEQ21BWkRPYnhDRHA3MVprRkRUaVQ4bzR4bmJL?=
 =?utf-8?B?RUdUWXZVaFJjTVVkMWtqWEwzbjV0Y3VwZXJZWGN0RzJOQUloYXBiNkFWL2FB?=
 =?utf-8?B?K2ZJSzRpbHFsVjM4WnNuWTAzU1kwQkVMeCtGTGZhUSt1bWtqWUo2dmlxbnZD?=
 =?utf-8?B?dndUMmI0ditTRjlSVjhMNUZrRGphTlpyQU5YQWZDU0ZOSWVrR0dnc1l4ZnNx?=
 =?utf-8?B?dk13L0lVWDNSNWJiWUk2NFNBTXNoVjFmclhSMThzUXhkSTJRODlhVWI5SXZ4?=
 =?utf-8?B?ckVudW9GeWdtazhvRzhrNWVRaTZ3R2djT2FKcHlOa29XUUJESkRVTWpzOFR3?=
 =?utf-8?B?a043TUVndEs4R1BobThPNWQwVDhWSzdMRlAwSDhyclhIV2JNTFdRMEdtenIr?=
 =?utf-8?B?ZWVJVVdGYUtMUkNxTEtpcmlXbDZBTE45TXAxRjUzQytLVFRUak95ZDhZYzJr?=
 =?utf-8?B?ejcxSXQwbGxRM1l6aitQTXJxamRZL3l6SnUyczd4RWs5YkM0QWRaLzNEOUZy?=
 =?utf-8?B?ZW1JeWpJZHVmblRYR3B2dHZTemljYkZpTkkzdWV5dGN0UGNsUzdpb2dpVTRy?=
 =?utf-8?B?UzZGQlFSdHdERWlBSjl4SzBSTEc1ZG04ZnNDdENJYzlMcEthYU9BaWVpSmVW?=
 =?utf-8?B?WGhTbVFyTVZxWEdRYkJTcDJZUEMvcEFhSDNEQWE2WDRFM25jd2piSE5mazhh?=
 =?utf-8?B?K2VPWWtNVkFtbkRaNTlDOUtkSUNlQWlrek9hZlNEclZqek56V1R5OUxHeWRT?=
 =?utf-8?B?dldiL21pOHRxVzFEbllBR2IrYjJqQSs4MHdvWXIrazZuRjFkTVh1NjNpZmgy?=
 =?utf-8?B?WXlCYXJySy9tZXNpOUJkYnVQRHFOVzl2cTFQVnZQYzJZSzR0U0I5bXAxZ0Jv?=
 =?utf-8?B?cUd0a29EbmJLMHNuMXR0c2dtT0hxa091RE9nMndDNFRJVkt5OG1LM0ttSmdm?=
 =?utf-8?B?SjdiT29jTW5WdVJmWlF5REREeTNjL3FZTjhQbFoyWkRVZS8vZTJuaDVUOUM2?=
 =?utf-8?B?ZFFlcGM1ZitPeFB3b004N3VpZFZtc0NxcTBjR3lCb1E4M1RzUUZubnNSaldD?=
 =?utf-8?B?dFd3Uzdjc1QvUEp6MEM5ZWpZSjM2cFZJUk0rK3pyQmt1dDRwOWY2WlJWUG5l?=
 =?utf-8?B?ODJnOVQzckFuS0pCclo2YlZoZjlXUUdsT0dodlN5TStqZjF1cndUS252ck4y?=
 =?utf-8?B?T0kwNW0yUTBHYmRzTTR4N1dpdEEvWVZlNkc3eElSbWtlSS9tQkxiandNc2RQ?=
 =?utf-8?B?SXpaVTBpT3hQTGgzQlJpcEQwWThsdzlYYWlMVTFnNEYydVg0V2FtV1dRUHN4?=
 =?utf-8?B?QlVSZ1d3dm1DWDFsekpWV1Z1UnhBNTQ1ZTk4aUlMTVF5MlV3NC9PMHV0aFZR?=
 =?utf-8?B?RTBHOFlPdmxvN2RBVURVNU9taWZSc3Q5K2RUanFWVWhtT3BwSjBhL09hbFJJ?=
 =?utf-8?B?Kzk1ZVZrSXZFWFZ2ckYzdXc5Z0F6UzB5aUVNZGpNQ3RXQ3dybUNDQjdJSXMx?=
 =?utf-8?B?ay9NdEJxQmxrTFpxWXB4alIvQi9CNUxvY0prM08zRG9oNFl2b1lsejhFMHZP?=
 =?utf-8?B?Y1NZSzdWM0MxSTdocVlXRFpqaDRGVGJodTllc1BoY2JWZGM1UFFYQ2xFcTZk?=
 =?utf-8?Q?sfHCNfLNgFQMQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1RDbVpGNVZwa3RoSDExaVZnNVo4NENCanVCMlZSSHA2dkdjakNxVnNMazM2?=
 =?utf-8?B?Rkw3d1NDa3pTa0t0S0FoWnRLQW1Za3A1UWFYWFJtbkpYMCtUVmlmN1d6U1Nz?=
 =?utf-8?B?Y0I3MHlveElma2haRDFRcXlwcEhPNWhLVlB6UElVcjVCOC9rZW5PRmhxTThY?=
 =?utf-8?B?NVBWMFJWeDUyMTVVRlV3MW5jSkFyNG1kbUFTcm43czc3ZVdnYjNRUXZNb1Q5?=
 =?utf-8?B?U1p6Zk1tdEhoYlRndEFHbkEzTzRGays5bFNHbEtpR0xNUWdtTU9jRjVGQVo0?=
 =?utf-8?B?bFJWa1labmMydC94YkZ2VzZoaDltcTVTd2ZGa3dwU0F6ZGdiSldtMTZLSWt1?=
 =?utf-8?B?NUZhRlZDR0hNd09RYi9qamlMWStEK0JIK1NFZVJNcHNRWThERk1JQVBoOURR?=
 =?utf-8?B?S2h4ZE5aYWg5VGJsUm1LcjNzSTFqNWlwdG9SeG1yMzFHWS9ldkROMUo5SXRO?=
 =?utf-8?B?ZEo4RkFCNWtURXpsV01tZGhpT3RFdzNVK1c1MWw5MElKSlNZbHRsNjJLMVdk?=
 =?utf-8?B?dFFBZG5jRXluVk5OZlNzVURONkE1OXZhL1lPb0hyeGttUXF2emJ0TDRJV0Vm?=
 =?utf-8?B?V3gzckduWjgxcll5bExzVHpLbGpraDVUVVhoNEpVNUlIa3YyTUhRSm9Xakpk?=
 =?utf-8?B?dTdrVGdFeERjZ0RNaEN5YzdOamJ6b1h3dGxsVHE1RTRyUnVQREZ6WlBiUmdk?=
 =?utf-8?B?aU5rc0MxZlBBQ2RsRGVlc0VwakZmU0hmL3FOZUlEbFErOS9IekRHK21uNXgr?=
 =?utf-8?B?VFozcU9GS29Ec2locVc4OHJYTTNhT2tsbDZ2RCsxMjM4eXFFN2VjV2paU2hV?=
 =?utf-8?B?R1pTVUxNWTJWUm4zcndKcEo1bmswVkZkOEZoYUZwb1crRjZLOHlqcy9vcFZQ?=
 =?utf-8?B?RXlxcGtMNjFjK3prTC9idEY4bEhHcmdlSmxITlREOTZGaldoZ1ZyaDdZV2Qv?=
 =?utf-8?B?RG5LN0ZyTUZodi9kOERhdVJ6bGV3bXFqbERFL3g5QXdXYTIrUkpxWUJTNzY2?=
 =?utf-8?B?MTBwb2hPN3BiK2YvY3VNWWJBSloxUTJ6ZDRPYVVMK0JYcklTcDlKekVieXhi?=
 =?utf-8?B?YzJuZEJsUUlnYUhoWkZwa1VtSlhhVWZIWTNWdGlUbzJod2tOdmE1YkhUa3pa?=
 =?utf-8?B?OWRMYTRVZWlnaEUvSTMrRHdlYW5Ic2NkaDQxblc0QUxHTW5QdkcyNEhtWXpC?=
 =?utf-8?B?QkNCZU92ZHRUZDFMUjVxU3ZaUk5QQThzbDQvRldjSGJHTmRvYTVPVUxVbVBO?=
 =?utf-8?B?MVJRQTdEc1BYbUFEWXdBcERrZ0Z6Qmh5RmduZ2IrMkZzSGVETUMwbU5rM21h?=
 =?utf-8?B?amQxNTlyeHRwK3QvaUQ0dDQ0ZTgzdnQ5d2VMbEhhM2F4L0VIa3ltcXZKS1VX?=
 =?utf-8?B?ZVNXdHZmeUhFbVJNNzJETVMrM1VXUUQ3VHZoOVhXOVUrL05HdDVZcjZ4N3dD?=
 =?utf-8?B?bmQwVnZMUjF2NjVwVkpUMnI0bFo1UXFVcEh2bnRvNmk3TTJLMTFUNEdHLzg1?=
 =?utf-8?B?VlNhaEFwUEcvVFdXS0VYOTJ6TUhVL0RweHR4S2hPRnc3LzlXbWpKMWF6b1RH?=
 =?utf-8?B?UW5jdmxncnRJMHJaYWZpOFhLdDBhUW1NOE9zbHJ0R2w2Q04vQU5sQlM5czRq?=
 =?utf-8?B?cUhtY05rSTlQVHpIMVBEMDZoSVZBZ2k0RnhQWkEyQm02MTNHcEVhZkhYTEtj?=
 =?utf-8?B?LzdHTlphWU5UT2UwU0wrM0IrT0tiZkJhdnlYamwwTGFxbVZibmM1U0JrQ1JZ?=
 =?utf-8?B?S1Z1Y1VWKzlQb0p2WXl2ZVhQd1VSdlZBL1dTdTdoczI4TmNlVEx5NzVCVHY1?=
 =?utf-8?B?VkFKaEs0eit1T3cwZGpxVXo4THNXSzNacjY3b0ZEM1lzQVg0b0hLYmpQcHc1?=
 =?utf-8?B?Ty9PUUYrTVFKNVBnZWNLdzBMSnMyU0k0YWYybm9GcE9kTkZTb2EyTURsWjc0?=
 =?utf-8?B?SnlOLzNSZWVvbHlCOGJVOW9IbG1OeXJJQjMyYWxxV0hsZmxCdWRPTklwWkZI?=
 =?utf-8?B?MGs2VkowMjlaVHNxeloxdEtSUjFZTzU5Zkl0S2xxQmhQUWNxdm5iRW51U3FP?=
 =?utf-8?B?NnBnQS9Xb2pjUHdjZXhMUXE1VDE1a2tpbHlERW1tWlVOOWhjd0doalBaLytH?=
 =?utf-8?B?SEpxN241aVUrZ0tuMTBiV3pIQTc2bWNkdU1mUzVVT1p4cWhIU2hlWlpVQ0hE?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	isJrPcAxwyojvqBwJ4jFZ30mD8KGS5XKbq312X0uYiK+bwbnZFGf4fVEpfZfTwKxIGAdHkRdbhbiXOV6O774NkwmDBz+V+X+D3r8u9/zipNCL7BXcQa/kwOBfqEwppdGUcG4EBNd0KZZrj4/xvrx805FwjrHtjUk+BhRKhjI90vjwK9OsMKyMJ9rYDvAjA9D/0UFJPx+tgDyzTQ+eTH2Ou1BIqeNA0+HnYCcENJ+vdGYE4eNHlfi2Tx6Z2hZ8ZstopRqys55y2x0OXy5ZCdMFVoOmaKg3lO3gg1qZM0zPefq9O95y+qPNSqE4ER4H671ZlKQfjKrhlxov7eAb+2xR4Sj2GNlGLzgETjnwzeVj+hAQ2vOBh/c+mgNhd4YWKEoFf5JqcUEofJWtF5Brz1sDU+YDkZNFJy6saCNRDX7ChauB4eEW61iAz7yqiHNC3YzT457k4SuodGqRVUTH8ZqBMwwVmu/nksPbyZiKr23h/KvsObI5cDAdKoJCBLeg53e91acJsdOoWDPBrpgZMYOzF+IescE8RsQQau4yX97C5EJ5wBi5ZsvJgBdkN0prYM9eQFx3WgxWnKXxZj8xejyRO0fn/XtVEEIgcrkd6jclcU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b838707-a2f9-4c9f-6d7b-08dd55751137
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4318.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 08:19:05.2525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9xH+s4Qv7sFnIGvv9cYtXA/nx7gttmL3XmPKeGnFNcEzX7gAtiRB0XrV5d6ZM+zkXgmbl8xvRV9zs8bQTOJcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5608
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_03,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 mlxlogscore=788 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250055
X-Proofpoint-ORIG-GUID: vOxmT6aF4HkYwCnURe_SVF35_Vj_gqTL
X-Proofpoint-GUID: vOxmT6aF4HkYwCnURe_SVF35_Vj_gqTL

On 25/02/2025 01:48, yangxingui wrote:
>>
>>
>> pm8001 sends sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,) 
>> link reset errors - can you consider doing that in 
>> hisi_sas_update_port_id() when you find an inconstant port id?
> Currently during phyup, the hw port id may change, and the corresponding 
> hisi_sas_port.id and the port id in itct are not updated synchronously. 
> The problem caused is not a link error, so we don't need deform port, 
> just update the port id when phyup.

Sure, but I am just trying to keep this simple. If you deform and reform 
the port - and so lose and find the disk (which does the itct config) - 
will that solve the problem?
