Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868371FF7DA;
	Fri, 10 Jan 2025 08:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736498648; cv=fail; b=bGxZWDHhRVaC/37C0VBJPf4DNVMVRXJXYZGa1bSwl4uQsaRccNtL/4CCX71BOOLnEsJl5M9PU1sP58pEHyiaVnYOIqlmFpsKPWfmt8qCcJxjhrH1JverPqf1zrpLmENxF0gA0ZssJrE8CB9k/5Ql7/KvbOPfIFDILNrtHFZZZnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736498648; c=relaxed/simple;
	bh=23JN0w8+y1C7Xgd3JfxicIVA+/5wuyggsccU4yfdwd0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dM7c528bXUNSlFU5eIBXtFtoEPscIv3eiD1Q8NJYYDuYY2XflI21Z9Ue6WqJbE5LWL7b4GiJ3Wjb38f8FhmNQ/mOvufPqntJMOVrv8PLZeZSMo1BlP3jBdbHlw7tyjuHEUXlGhtwgXu0tyuDD4aVfLnGTBuFsXn4BpzBB4sjyAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OIpUGMHC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oqSJL2P/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OIpUGMHC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oqSJL2P/"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50A7jSkH021291;
	Fri, 10 Jan 2025 08:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=CjTryJvcvl80fKK4zh3QdAuX260pfjeaTeTGSqZEO60=; b=
	OIpUGMHCER+N6ww7stYzOh3zt/B1n4jutQlTn3F4lgMOXoNK20nNd6D8tUi1/5eL
	Veh9iJCXCb+P3wDle7ngAb0Hpuz9QhCTK4nVn7U7yzl3YVUr3qpmE6RYpmeY2HIc
	4igXLCAPvhdHoWSZrNaS18Dkvwoht28HFQ5G5xy3EQHUULlPYAqqEHrExBQF3E/9
	6WofML4x7KH4FsocKgpIo4EUbeNep6HWQzVx1jTKWeOHymU1FwtNhNQ6vMIOIwxJ
	9KywLZajBBI+no4iKiKSMHnI10vl3FCccKzbaGhgkVIp3u6DsqlPYKDBo54Cg64N
	N+BBK3Hte8ExZ4dq9LpaQA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcas4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 08:43:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50A8K7pr004832;
	Fri, 10 Jan 2025 08:43:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuec61da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 08:43:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y/LYG+Vc3g97RjXTs7npcCoQ6MdFJ/f5S7u1F+d6axnW5YtOx76U60yMErU2RIFAELfMMIiiL4NhPF58vHOMOwDVkHhnzMX4HROWptMnkCLdfej8ohg3Noh2MdOPly/DJEyy0t1gIqfSaQuoHbSSAaiI64zUvD4tImgyB/LqUKcxYq96iAcR4iWACTydnFdYeYSvMcHlMV62C/4MXAaed0A5Xez5RlMUtt3+IEEAqCQyh06kACZp/NaiGz6XF4z6m2w25mxBqT18dE5mzl+TgxivHObqdvk3SQ32V7B5WUgey9gNK1I6xecrmMdQhH7BfTfYCZz3PkaSn6BD/NzCCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjTryJvcvl80fKK4zh3QdAuX260pfjeaTeTGSqZEO60=;
 b=bqqQdORPVXSo+kvEPuq1Iet+4YButru9vBxQev3L/ksVf3QgnVgKNHjl1dfHUlVpvXMUsVlJF8tCYlNXWxJ17FlQQlSg+4N8OtVIxrw70tep//Pipl0iMVhlmgT12HiAVY0dSgqL73RDGjtGBgx8+ukMJ4rQn38cIFtuneKEMg1+6Su94x3D0puiKsf2ovtazWk8D8tf7EEFAIsbdvifT6O5Dv9d4aHme4yrjOWgDGEOdlR2WN3eqUtesYQ3lTY3obmEtdliNYacyPGWUvKpDrheIhmsBq/18E/1mnZGSFgGSPRQZ4OB7D2dg7BeNBsl/v0feeCBizT+tsHoFqvH7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjTryJvcvl80fKK4zh3QdAuX260pfjeaTeTGSqZEO60=;
 b=oqSJL2P/5NLlRdbyfBefkjYxOyGIlY556eEs9gTodULBgIZTJqqyUNLnHxwItYEHVL1cpA8U991sdJqUFrOMs++91evr7R4AlNF8ZTBnHDTVFEOszuEj1VIZyOR3H4iHn28lHYPauk5Et2QOYpNbzIVKOOxfVFqBXXTSf36oCtM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5835.namprd10.prod.outlook.com (2603:10b6:a03:3ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Fri, 10 Jan
 2025 08:43:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 08:43:46 +0000
Message-ID: <8e0c6ad7-a043-4923-8a53-121f13660608@oracle.com>
Date: Fri, 10 Jan 2025 08:43:41 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] block: fix docs for freezing of queue limits
 updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, nbd@other.debian.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250110054726.1499538-1-hch@lst.de>
 <20250110054726.1499538-2-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250110054726.1499538-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0038.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5835:EE_
X-MS-Office365-Filtering-Correlation-Id: a2999b64-82cd-4bed-8112-08dd3152e53b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDl4emE5Sk9rZG9sc1dOS09UaWtsNkZuTit5K1dKQVhtdjJLVVNpV05QK0V5?=
 =?utf-8?B?TFkwQWZPc0twOFUxMG5qeXN5QUNYQm5rZFhITFEva3hiWWpocGNwSTJpSGdn?=
 =?utf-8?B?RXBaSVZPV3M3cjZoYXBxRm5BSzZOY3lpcW9MdmlDZ2VQbXYxcHhrcjRMdU1r?=
 =?utf-8?B?LzMyNGZFZTlNY3hYY3lhd0dUYTBjci8vdXIybE5ac29hS1dveUtiby9uNGFz?=
 =?utf-8?B?eHY1V3l2bGJnWGtHTVJvMDcyU1hMb0FjYUxYYUh2NWdiRmw5VFA4WmZieEpa?=
 =?utf-8?B?Zzc1MG5ZSllSL0VpbGliUnZybGRPUG1yeGt1N2lVN0N2VDlqcy9YWVYyVjVT?=
 =?utf-8?B?bkVoMnROZC93c3hweDZ1VFhTb2FGSkxTc0x0TTdRTFJ3RGlGcTk0UnFQcDA5?=
 =?utf-8?B?bjhnY3cyQ3RVbCtwQmJ4ZkNzWWd0Yk5wQjZtMWUzZlhqZk8za3FGT2VlN3JQ?=
 =?utf-8?B?UXV6RjQyRlRSSUFRd2RaQU5CL1lQYWFkRzhOSWpxZjdiZGF6Y0FhRjF5N1Jv?=
 =?utf-8?B?blIwR3NIejJxUVVFR21DdTY5SURMSFJlVUNJUWZhS1VnS21PMHRnRmNkbTQz?=
 =?utf-8?B?WngvUVA2aDZSOUVoMUFmL2s5cHo1b3JKWVBWYS91WmNpcHRHb0tOL0pwaHJm?=
 =?utf-8?B?ejdUenIxVVdzV004TWlLQ29wdFFLa2NVWElOZDdPMVhBNS9rTFFiOFJNVGtY?=
 =?utf-8?B?NTIvL1pIV0x4dzdLTmcvb2xYdEduL2xjVTdyWU1LdjQ4bS9QM2NVMks4eEJ3?=
 =?utf-8?B?REFJTW1XQ0FORTZKRkc5ZEtNUGRHSXIrclc3NXExZzAyRE5XUTlYaHFpVk9D?=
 =?utf-8?B?enVNNWYvaHpqT3RZQW1FVUJpQjdMbVNtdDkwb2M4RXhqNjBoeEVLcENvSWtr?=
 =?utf-8?B?YzRGWVBhVXdycmxVSW9qaWJnSDR2ZTA2S0oyUmZzTUpTbWVHYXN1NkU4NGo3?=
 =?utf-8?B?WFl6TWZ6cXFjOGVsM3V6T3ZNaDdYNmVvR1VrNnp2T2JZeEpmRmwxMko1MnZC?=
 =?utf-8?B?SkFwMVZDdEoxb0xkSmowcjk5b1czalk2RFR0WVowTTNXLzl0TG13TWFDZWlD?=
 =?utf-8?B?ejVrWTNQMCt6OXJzWGxtUW1BZkFKcjVQUmdNSEM2dkVlbC9jNncvZDcrWjBE?=
 =?utf-8?B?QmhXWTF3dSs0cWNoRzRUTFpURnNBYUIrVmJBSmVRNlhxSUVLbjl4VjdBbDM0?=
 =?utf-8?B?cmM0dzgzMnlza1lYQ21QcThxbnp3Q0pNbzBYWWJXM0RMM0FkWTFZZko3enZS?=
 =?utf-8?B?R2ZLZWtKczdzZkJ0alNIQTY3Qmc0TGRNVVdWRGh5enJlYTcxWEhRRmc2T1RT?=
 =?utf-8?B?UWo2MWhwV3Q1V0UrQ1VTdFN4VHY2SXdiK1A1N0ZYOWNWMHFlSFdtNzV3NDQ4?=
 =?utf-8?B?U0ZYTGdHWC82VzlXVjMxUjVucmhzTkZCUnVQeExDT1dRb0FBM08yZnlINFAy?=
 =?utf-8?B?dVhpVlFGL2xIRDNHK1hFL1pPbUdaUkhsTlJ2SElTUXZWamRBbzY4a1hDdjVl?=
 =?utf-8?B?K1ZyU09TazNiVWNSSGJxMXZ6Y3NqZ2pkdWtCK1lCc2VvK01wcU12Y1J4TU1O?=
 =?utf-8?B?ekJQMGpDM1BOamt3RHEwM0g4RFJURFBtOXZFNGRzb1crYlJQaGVDekNMdDFl?=
 =?utf-8?B?dnZMdWM3YmpmcnlUa1hBVllhRElhMk85RnBvSVQxMTVvemxNREx2U05WWTZC?=
 =?utf-8?B?eXNpcVJsWnA4eUgvRzlxYTF1VmlBLzJzT2FzSWNZZWpZaFNUUWQyWmdFUlFN?=
 =?utf-8?B?cTgzR1QyYkovZytxRnFmRWxVMnk4TGpHbVV3cGZzc2RocHhXcHEvMnd1Tjkw?=
 =?utf-8?B?UjVOeVdLaGUvcXJzSXNRREt2TXo1V3dzdEoycWFkcmFKZDIzUk9wcUpqV09v?=
 =?utf-8?Q?d6ZLuFG2NRq7m?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUdSS2V0L29kazRmMHpQRllWT3NVaml3QUNkeXNINlI2bG14amxNT3M1TXBU?=
 =?utf-8?B?MktwVzIyNE8zT2xSa1lOZUNaOWl6WVZGekRxeEVWci82eCtjZVpWejhVUVNF?=
 =?utf-8?B?SlM4YkdSaGI1Qm5LVlZkT3BYamZlREhPcXFMV3BZOGVjUTFzSEpyRFB0cUFQ?=
 =?utf-8?B?Z09tWklrQjVaTXFqZXlWdE1iT3h6ZHpCYkZCV1VDQkdBbXB3VSsrMkp6QTB0?=
 =?utf-8?B?RWZLUlRhVjZKUjRHcFUvMXc2WE0xRGNJRzRLTU05bjVoTGcxOXl2YkduZjA5?=
 =?utf-8?B?dDJNVlFyM3RaRzhNb2FIVkFzREIrQ21iSjFteHErNWpCK3pDOVcvQkRoTktQ?=
 =?utf-8?B?b3p4U1lMdEFsUGRmYmdtTWVrN1VNNkFFVTNrLzFyM1JtUE9wVjB4M2lNemFM?=
 =?utf-8?B?M2tERGtEZHVwemM2RExhZzhjZ3JBRUl6MVRVZEdvcWRpK1F2Y2hRSTh0RHBP?=
 =?utf-8?B?QjBZUVI5dDgyOXkzWFdnTEFSWVpzVklMUWdVUzhReENXb3MxcFlDR2huYWw1?=
 =?utf-8?B?MmdGTkpQR1hKTWVXM0JHemtRS2FDY3d4K2N6TGxQTzRyNkd2Rlp1YjJhNlB0?=
 =?utf-8?B?K255K29rSmxZQnZRMFBYV3ZEUkM5MWpBSGwzcU9sUlVaMGZUVENyZzUybkto?=
 =?utf-8?B?ZnhWcGMxZlBuSGVLVGRRaVlLUHVhVGM5dTlmbk10SFJqSzdoVDlqU3l4N0E1?=
 =?utf-8?B?S0pJOTRYWk51ME05dXF1TnJYNGRIWVgwdVE3S0VlSCtERGNXd2RzVUM0YW0w?=
 =?utf-8?B?Z0V3SEFmMWx6aUt1QkM4cHVqdlVhVUJvS3BrVm8zbUZyYW44YVNDN3lZR29X?=
 =?utf-8?B?YkFmeWJHY01aWlNyc3VrQkRSOXJRMlFRL2oyKzhxTXJJQ2E4OXpZOHZ5Q3dS?=
 =?utf-8?B?WmNZZEdidkFmNjIyWFpUMTdnOFVtK2FPbTE3V0cvcDJ6MS9tSUtza0loNk1I?=
 =?utf-8?B?NU9oVDdCdC9NYVdrYXI4Z2xVeDRnaHBPbkZycG95NVBwVFNLZTdEeXduNmo5?=
 =?utf-8?B?QXkrNS9OMHZuUWNTR1RsbFAzVVR1L2l5THp3dUY0Vlk5M2RwdFdYK2ZacWNX?=
 =?utf-8?B?MlhSZ3BqUTNVbUJHNjhZZ2xQYWZ6MTlVMEN1K3VyNG1KRTRiUFJmM3Rmck5K?=
 =?utf-8?B?cVJKTTA5RFZ1bllMY2FFK0JMVXdXSktXNWl5RGlOY1RpOFZkSEoyRXVDRXov?=
 =?utf-8?B?bUkzSG5PTkZ1dFUwbVc2dVFoMVozaWp3aktIaFh6dUV1b2t0NmcxUmFkK2ZW?=
 =?utf-8?B?SmpvNlR1L1hVc1BuVjBYTm5EeEVaOXR2SEdiU2lLd3pHdHBUWWJraDZsYVJk?=
 =?utf-8?B?eXhqdi9zT1dxbmE0blZDWE5xV2t5eUZNTXNGQitPeGRHN04vUm5jUGVTUlZQ?=
 =?utf-8?B?QzEzbHRVSitQTGFZMGxSaUJmNStsVU9OdXhyeVdoNExaWjdwVXNOcUxhM0RT?=
 =?utf-8?B?ZHlJNWdkNktNZ1J2ZnVmNHhZQ2ZMeFZ0VUxRSkZsRmJ1d3cvaERSamNIRVd2?=
 =?utf-8?B?UE9LZFEwUHFZV0t6bHJHR0lxSko0MzlGMFNhY3dCbzRPd2xhYlZqdWRGQkZx?=
 =?utf-8?B?bUVNTzV3R3hWMUFHTkUyNFRtYzloSGxxWjNtR0RHNXhaSlpWbEZuYU9qVU1i?=
 =?utf-8?B?d3lqR2Q4T05XUkpHd3N2dGlxRDFLWDk3MjBwSFlsUUdWcFYweFF5SmN2TXNF?=
 =?utf-8?B?Tit4VzNMRHQ5K1ZESzhCOWRSczdXSUdUejNWLzJRL2FjRVo5TDIwdnFTSFJY?=
 =?utf-8?B?OXFNUTRoSUNCREZIcjRIRVczNWlJQ0pyNkFZRDloWGRYQUQvR2hER2hiM1dK?=
 =?utf-8?B?UVVtS1J1aTA4MlNmd2wyaHp5NExlRnBGTytDbFBQc2xFVFZSZkRuQ2V2M0di?=
 =?utf-8?B?UW1mVWEwK09KN2hlV05McHQzRzNxRHZsem9FVE1DWHdDeHlGZE1zNmQ0em5T?=
 =?utf-8?B?dDhaQURWUW9yZjZVOGtpdzVHTHhWZHYzUmI4OUV2Nllpc2tTVU9haXVKYmdh?=
 =?utf-8?B?WExpR1lKN0xJbGxXblBFeFdrK2IxSE5tSWRFc0FRSXJzQ3RWdDVWN1JDelUz?=
 =?utf-8?B?SVRRSkx4RXU2WklnQU9jUjBkelJ5ZGdaNCszbjArZTBOT3M2Smd5ZTFScDNO?=
 =?utf-8?B?SGI1Zy9RaWUzRXJYc21zcWRyODNWd240NFJJYUVYeFEyVk5XOXg3Rnp2M05U?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vGYJvVBHhjqJvmgaLrBm6AjDCoyVz6AJHAWIHFpx/pYGDHc0VZvoaM/Bf6tVecIlQBEb5HAj8k9Ziv3TfBg9DzNVK+4EQ9GdPD+m8TVTO6DHT9YN0XL74mDOTmDp/QjZpX5X7aldURH2ASwT9emQcSYwnEkVkktCpiUrB8Ejzqsme1hoGFWqPNjjYmgEMv5QbFG1F7pW6qe9Kpu+XaXwMVhYctcMp6Ob+gB5WoBKNbQTTx0hYXRFZM3hcwGTR4mlLz31moWlF1ZE35UAa6tUiAbWbpMvk0FFbQyMm1Ac3qWw8H60AC/ciBgIg4bA6hZm1Hyj/X/AyO6Ah9U5gJ/oFFfjrTmiDpUPc3v8J/COCNkV2fzi6Ks+phSd6t6nXkcyaRP7/yj3L1meQd7FoWR1rtNkFrLNdmCaEbd7s76kWk8W3cmaCHZyVYmUkSERiSkUavTmgcKj6QRb/+VkFZZXMBY1q+3XM4kzEGZJauYi6GqeUhCQUf9Fa4svc+qafj/oG/jMBu6audtqvUhZyCrQG0Wp/9lMDJoqNQsFAocVC7vxmidQag8H0wp7667lJzMksGl62SQQad/iP02NS6pMDrUelmU+P7mXioyH/5vCtGo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2999b64-82cd-4bed-8112-08dd3152e53b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 08:43:46.2128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qqt2Gu6R+93i82o1ed+xXGT5DG/BGX3rj416R8EgygENM89T9sCgnnEjrMe6yQnV7bTySpdL6clHdO/YTGo75A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5835
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_03,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100072
X-Proofpoint-ORIG-GUID: uEQGqaYhKaLcfklxC6I9GCCdcmGieil_
X-Proofpoint-GUID: uEQGqaYhKaLcfklxC6I9GCCdcmGieil_

On 10/01/2025 05:47, Christoph Hellwig wrote:
> queue_limits_commit_update is the function that needs to operate on a
> frozen queue, not queue_limits_start_update.  Update the kerneldoc
> comments to reflect that.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Ming Lei<ming.lei@redhat.com>
> Reviewed-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Martin K. Petersen<martin.petersen@oracle.com>
> Reviewed-by: Nilay Shroff<nilay@linux.ibm.com>
> Reviewed-by: Johannes Thumshirn<johannes.thumshirn@wdc.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
