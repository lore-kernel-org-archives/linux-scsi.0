Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3FF187552;
	Wed, 26 Jun 2024 14:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719412242; cv=fail; b=DpTCa+3tNVihX3VIZ+hJLjOh18VhNe/No8Swx8ZIDzQLIKHSpUnT2rM9up/974IUIIZZssPshgwl+jxg86HulJWWYFj+I5fj/3JjSTmlFzIgwnEVQ0rkGewqfCaomXAH72PhpmXfCXZmWt4AzEHEVGB6ubEtD2urzNGjeTTI0iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719412242; c=relaxed/simple;
	bh=TRDMmnDI7JhOzoTPp5CMq4jqfcoj5NwsCkgF/cuO5OI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bt7ysibx8PFv/Rz6OuXhoQfSP8eM3fz38fx6WcZGIMZwQCrPWo0a8MQh8BPksB3L+gVhnPysimBGvSzHwyokZKSQb9xPvYuNjIKWrp6tNN4OvTjyPOHL2676XEAU6nj2omdZcJ4QgkAnyM8agnA0e8jJIZc4VgxZle5OrSOIcIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L5AqXKV6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pP9UwiDg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L5AqXKV6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pP9UwiDg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45Q9sGTi013149;
	Wed, 26 Jun 2024 14:30:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=P4RcDH4u3abklgcFHw1VfKucHLZqasQ2fqSyEJrNX4w=; b=
	L5AqXKV6PlSDXfuiaR/Rlh4KPlwimxNtPhPks/CzxYR+c15tMdOJkRkA6zzA18Rl
	/8mqi4mTWOCjsrAJFBKW2zfLwHm74Uevl7yjoQsxPG7t/A+O3A046x6Kf3b+5GZa
	vLd3crug6yuhAQ9/aDgC/FP6cmN91OKW4UdZQ/GX4WL2eqCO+D7wiWAfpo/K9Dpx
	l4tSNjSO5QSdbl/f9FtO9QYvl6C2qHRZ3QoPvq7ofTCdINdJc3sl/GLgU3xOHtOF
	6c1P5A4PmIQ+QUPokkNR3ItpogP3RfJR29sC/MMAoa3s8oH+QN5CKpsiSXBXGqtp
	3yeDqD/yX7q7k/UIA6P7CA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywpncbrd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 14:30:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45QDQZeu001351;
	Wed, 26 Jun 2024 14:30:14 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn29urpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 14:30:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Km40edKc6Kg6FfMSupQNmrPfz2lG8YAoCqAvfvMQoRRodp5TPJKDelzk8vBT4Sze2pHpumAR8yvUXLJntR1H1RbdXJDcF3jLm8tpH+7Ru+b7F/tou7tX+ABw76PtlmaUkdlhBZr4iZU04rKlXJNLwJEHBnwPR7lZDs7WOo/8XzD2owXZWytvpUxW7cJqeCqwbHBnt06WYAzb74U0z1/U9lFFekuqEedrH9qshRpAtWoXRllXC/Plqq0cOkqiYxN5cSeXTf4YLiyMZSk28JVytdzrH3HGzKhYiWleWeszbcT5l+G313MZwCorquVZN9IK9g2WW42skY5cQIJGa58rHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4RcDH4u3abklgcFHw1VfKucHLZqasQ2fqSyEJrNX4w=;
 b=NBNiP1/D6QHGUVBI6KNrfIOtL/S6e1d7A9hci4Z/jp5Pf2PY1qOya61BxY0sSFmjYxVVKZbCHyaH4oNIfb3e1VgXQ7lKYyiIeZDL1Ykkn+BimIZNXLJa6dleFmuX43cTtj3isbQf6JHqkS0U5Mdb2/UIXW9fvFejWDIcEnhcfgajcElyfL3X4+YVFf5kTEcK64NoDCF7Z/MK57kf1t88zaEgNUhxJw2tIBx9MUKvMEoHUxt92NIJ9ecZ6iaYBH6vX5UwRmxiZG4dkhVTaJvWZ5SOA1Z96AXEJVkUOBF1PjdIgl9zG4oo7I1HnvgsG7OSLz8QG9HfF9uI5uyhu3oz8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4RcDH4u3abklgcFHw1VfKucHLZqasQ2fqSyEJrNX4w=;
 b=pP9UwiDg6wxZYH1R7ZrzrLsGAcBhhxg38pv0cjinsVFj/wobtiCyzDOnDR8l07yfSYGLYD16YTQeISmn8kzAuFnpmscgqJ6tgANRwtVkTZTohtHoBTda44YW4/9NEVBmeKyV3fVbrxoCrlCVoM27zW1Q23FUjOtz/oMXkcRsM24=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ1PR10MB5977.namprd10.prod.outlook.com (2603:10b6:a03:488::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.37; Wed, 26 Jun
 2024 14:30:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 14:30:11 +0000
Message-ID: <3f636add-bf9b-4020-8335-75fbfb114183@oracle.com>
Date: Wed, 26 Jun 2024 15:30:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] block: correctly report cache type
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20240626142637.300624-1-hch@lst.de>
 <20240626142637.300624-3-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240626142637.300624-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0057.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ1PR10MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b676771-6d73-4e61-dc32-08dc95ec7c65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|7416012|1800799022;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?cEJXUXkxVHlKTXd1aFdQVXJqWlhWRjBlWjdtM2JWbFBwb3hEeXFYNWMwSDlQ?=
 =?utf-8?B?NWFKQnMwSGZVa05hbE90WGp1SEJyOEFMQXNoa25oM0FlOG8vVEpTU04zUUtM?=
 =?utf-8?B?cG5zYWUvd1o5TEJVc3Y1WElnN1NPSXdPSW4yUUZTK3ZJRW40Q0lOMTYwbk5p?=
 =?utf-8?B?MjZ3TlJHeEk1S2RybnRBY1hFN3JZaFRVbHo4NVR4dkluelBrV1h6RzZtUFBC?=
 =?utf-8?B?eEZEcW1PVzB3a2NqMWRBL2JzWWdXbWszbFU3TmMycXFVOG9QNVhrbE8wbDRF?=
 =?utf-8?B?NlJacmd0WUhVYWM2UzROaEtLK09NWTk2RVQwWHd3b2t1cXpmUTFZY0xZcW1B?=
 =?utf-8?B?RkhCeFFFTmhLZWM5bXZTTEtXdlY5cVI1d1JJUTNVS2trSWNOeVBGaXBVN0NX?=
 =?utf-8?B?cFJLWkh6bkJTOEJWV0syUTZyS3JpcHBJRndCbnFBb2FKdGhOL0cyeXlFc2My?=
 =?utf-8?B?RHk5NUxrSEFyb0dBTFBUM3A1VjlFMGZLbzkyTll6VThVaTFYejAxajdLN1dp?=
 =?utf-8?B?cW94QTNrRjc2MGxLZzZpUTRmczBpM3BMdUk3RGtwODcyYVUrcXpmcDFFeGU2?=
 =?utf-8?B?Uk9EWFFYU2hyYzJHajdtbzFIdDJ3aVhucGFLd0tuQStPN0NaVnJDTjd5TGdG?=
 =?utf-8?B?ajZaY2pSR0tIUHYzdDFjeGRyRUtJT2toa0tZNjBLMllSWWduTDVFUm1GMlJG?=
 =?utf-8?B?bnVaWHloalRxaU9tOXNYbVE0R3VEWnJIU2EzN0pCSEQvTlBIUFFEWVRSNHhk?=
 =?utf-8?B?V3dwT1RIRms5bmU1Rm9YN1NRVkVQdkZqbU5saThja29KTnJSMWdZQXpnbmNY?=
 =?utf-8?B?TXRSa3NibUw1NFQwQmxia2NFOU14cjB1OFJkbmxybVRieDJzV1pZbmMxSHJQ?=
 =?utf-8?B?cGlwaFZ2RkM3Qmx2MzlNeUFXNFduamZvNWFINkgxdFQ0V21MMnNQOHFnN0J4?=
 =?utf-8?B?dW1uWnBISW1INmozaFdRQmZyd0Qvclg1MTZMRzRaZ3VaZ2tGTmZXaWxlKzNx?=
 =?utf-8?B?ZEc3MVpUUDdRZHpYOTFLUE5PbHNsNDl0akZHa3JjSUJqL0Q1TDJyaGlxUlhr?=
 =?utf-8?B?STllQzJTN3d2RnZSZXUrM1RNZlg4T0J0cituRnJGUTBRLzJMUVpZOEpMOERU?=
 =?utf-8?B?d05JbVpERVlBN1pQSHAraHNISjh3QzRsT2pnN3FrYW1MVHovYlRMNllXYVB1?=
 =?utf-8?B?ZGcyb2wwc1I5QlI5ZFVRMU00ckdoWTZ0VzkyNXdzNTdqZnQ3V3dpU3hvckJD?=
 =?utf-8?B?TmZvK0UvbEJIQkNQVnEyVEpYUGpUcituNUF6eVl4MFJyMFU1aDQxVFhuZC91?=
 =?utf-8?B?aHhMWGlVMXFzTWhkL1FTSTRCSkY0bzliVHJxcTZvSk9OWmtMOWN1S0xhdGUx?=
 =?utf-8?B?dXJNd2lYZmNXaUt3Z0VHRnhxc1ozdkpnUGhkREVYMkxsODl4QzFhREhqZ21h?=
 =?utf-8?B?K1FIUkFodjBpMmxEaEhRUFpmWVlVSEVuWmRjVldpWUxGMThqQ2U3dU5GM3dk?=
 =?utf-8?B?d2h3Zi8zZXZETjRoeWU4Qm9oTmlMVmVXVHh1aGR1Z1ErZGkzaGRYditYUXdx?=
 =?utf-8?B?cUxBR3QrRFZtS2YzT3U3K3JMMXdJSkxMc0FqNjMvSktjNTB4b1NPK21UQXQw?=
 =?utf-8?B?RUQxenlKOWxua3JHOW03VTA3aFprL2R5Kys2ZE1FYmo4QjNpcjdjaDdBRjEz?=
 =?utf-8?B?UWtTOEpHZEJWSW9ySEdrNEV2WEZhSWY3S1kzU0xXYlNqUlJtSDgzdG9pcWM0?=
 =?utf-8?Q?pKh/UqWJwJgJk0XrAXwVMY1Fr4/87VCMBNCZtNW?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(7416012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cG9SVXNYTng5TENySWVlQS9mMks5N2FDWnhDU2pmNU1UdmZIQlFVTWZhSGpY?=
 =?utf-8?B?c1NPdnR5M0VWTlk4Z1ZXVWN6N0pSeWEyS0pENzBMNURLbHlaRjNMb08ySW1T?=
 =?utf-8?B?SWUvUXBTS1M3Z2ZYdUdZM2xJdk1RMkRmOHhNVTMraGNaSW94UXU5VXUzU1FY?=
 =?utf-8?B?UG1OWHk5M3FTZkNLYzlwelJORm9UZ1VnbUo4Q0lQTCtRTXJsVXo2MDJTRnl4?=
 =?utf-8?B?ZngyY3R6cUlQS3NRb0N0bVFMTURvSG14d3ltck1nZEsrWlplZDhORlE2Qkps?=
 =?utf-8?B?bDQ5YXpvd2p4djlZVHJGeWJxemhINEZNNnpvRS9BT1FRV2JjOUc3K1RxVFR1?=
 =?utf-8?B?NlUxdjgvRWFVRm8xMUl1ZjRVUmljT3NWUytYQVZXa0FzQnpicFVNSVFvWHlK?=
 =?utf-8?B?Q3lzQ1h1cWxwai9ZaW5zU1IrWW8vUlNyQnJIc01oYlRqUW8vUGc0Tlg0b0ZE?=
 =?utf-8?B?Ymo5R043S254NWw2dEpXSjBmL3QvaDVpM0VMaGlmMG5xczhjL2RKL2Z0SFZQ?=
 =?utf-8?B?TVRiK3JSUVpjbGtITUgyRU5ReWlNWXRzRlJObGgrV016Z2p3eTJhSmNwRzRJ?=
 =?utf-8?B?a3R4ZWlyOWQ2SFlnbk9IREhqaHFlTm5ENnAzRTVMY2JlS0hVRVludFlQcnVI?=
 =?utf-8?B?NkptckhaNkpTcDdNUXZyTGo5RFRxUWtOd3ZjMm0wajZTTE1QN044dXNRaUth?=
 =?utf-8?B?a1NZRjQyNGloM2I4Mkd3REtHQ2g1OUFXUEdMWGhTY0lVSElRR2swQ2VQem5q?=
 =?utf-8?B?dzVSeXNmSjJxVjhnUllNWnp6QTNBQURVV2lBc3pEWkQ1bTloeVdjc2V6T1pk?=
 =?utf-8?B?NVlOR2FuOUZKTGpTaCtITGwxU0o0b2JUMVNLYTFCL09NV1FZOGpEVGFibGlu?=
 =?utf-8?B?NFRlVXpCNk9iNVZwTXJSWXV6cklQdlNMcmNYc0Jjd2RYekRCUkZYY0luUkE4?=
 =?utf-8?B?Z2F0K0Evc1ZnbzhyeXU5WUNCMDFicGpOWGdyazBieTRPa3lxUUpxV1NoTVdH?=
 =?utf-8?B?SjUvYWMrYWNBU2kxeHJhaExSdVlpME1CSXJ0Ujd2Q2RhOUY4T0Q1dFZHdE1s?=
 =?utf-8?B?cHR2OXFaRUxKQnFXbTVTQ0NOSmN5SndTakEwVTZyRVlhZkVkY3Fxby9CTHc1?=
 =?utf-8?B?RFFNbHV5cEQyMklOS29CTW5vWEhqd2R1Y1BMRG50a3RSdFhGbmErU09rSzFi?=
 =?utf-8?B?eXFac0x3S3oxUUllalJYeCt4YkY1cUI1Y0lzcTJUR0NWR01CdDA1YVh5cEoy?=
 =?utf-8?B?NmJrSTlUaVpVRFRnTjNSeFRoTFBmWUsrSVRQSFZubzM0dXR1THVUWjRUUXRp?=
 =?utf-8?B?ekl6ZVlLbUxvYis4YkRqL3VYRStsVFZIVWtRK2k3NmFQamJGOHBkbHlkOHZx?=
 =?utf-8?B?U204SEJwTjNiVWJHT1l0RExKRlF3SUcwbkx4OHNMUDhPbktKSDZ4QVgzd2Vi?=
 =?utf-8?B?UzI5eTBtM1VMVVdYeEkrajROYmM5VWYyRUp4bEtQUkdWdEQ1Z3NHVEs5SUtl?=
 =?utf-8?B?dmJWRzhodmo3OS9UWWIxcXZCZys1aVVVQnVxTUxWTEZnMldXRVpqVkFyRklr?=
 =?utf-8?B?b2sxSHl3eWJkcG03SG5jVGhCZlBENllZbXlWVElQNlM4SmROaE5ESWVNZVQ3?=
 =?utf-8?B?VjJoTGVlR0FOcllIMHBzSE14YktVUThsTmdUS3RDZ0l3Vlh2ZVJMZEgySXBx?=
 =?utf-8?B?VVVLb2l0WHVmblNpOXBhV3U2dklBOG1XRGgwYitEWVVXbHpDZVh4eVZoSnov?=
 =?utf-8?B?eUIvYmd6QWM1eitCM3NURGY4ZFR2RXJabDhNVDFkSUEvenVjbnd6TlVIS0kx?=
 =?utf-8?B?UitaRHRxWUxwZ1pGbkQ0V1dlUUJXVTEwakZUVHB2bXM2RFd0QUhqUy93ejE3?=
 =?utf-8?B?WENyZ08vUE9mYVQ1Rk9TTTFMenljSzllTHN6SXRBV2NSbFp6Wk9kd2RDY2Jn?=
 =?utf-8?B?THFxT1hrS0NyMmxpd3dJNlQrZ3JkMW5ENUFCSzdwcDh6OUorWFRoU2ZXT3BP?=
 =?utf-8?B?eFJZclBZbDN3dU9MMTlPcXBUK2NJQTB6YWxyMWtueCthVzdJNmJXeTFMNUFG?=
 =?utf-8?B?N2FhMU5mVDk5NkY3YVdvSk5ySFNiemhnVmJWTkxEQTNHeXZOZVFiL1lKd1ha?=
 =?utf-8?Q?3v2dP/prh7t+FU4nbFpWApg1C?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7smnXpO5RTa2TxaYzjKsFYY132CdOGGAeQ2q+WdEHwEnnNCRhUor0CFmQ4QqXh0hUkhfQIqWHNoExjjBn5xGlfAuYMUaUjOl+LzfiWEeNNlz/25K2WWz2HtsVxQKnfq8cGAy89ajgD2DYMTEh0y8+MAxqqUnrWp1yV+tU/g6kLAx4+fMxKQW16Sk30LIzJ14XHmdXy7PofX3XALPZNdw/akcmN0kCGFEVNknjasg+eJCyMBZWj1L8JfpP7zHKDvqSXczOtrWxFSEpOTro/poQwWnPxfMZpjYULHNX/OFHPMAHNFgmr2KcvSM0Zq6lE05XwHfq3oVVwELimtdCN68VkUXh86Y+z3KreHjV4v/FbfA5hpyo1tY0oLtgCOKJ6NFDd4LNaYcwqVkR9gLLbWb8KvtwSgIfk7OYZRYMJkJogYP+pyinmX/k7XkvQXcYDqSsn3r2vsvxrH0YkncrtmRGcoGNnmpYGy1rqv6cEqjm+Wn4Qnz15RuZcr7OfXBAQctxS4onc0dk7Ado8Q6tydyO0ovDgIMGrQ/kmCuTIahVIUNwjknJlwqXxiQu8exINXAMxvIBVl57zzNDGi6uLpD913qpFo09py/tJWdx9LxNbY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b676771-6d73-4e61-dc32-08dc95ec7c65
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 14:30:11.5795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRPZLRghpxSzWxbSLmh/QdBrU5p7U2Dc8dIY8DImGyX78I/Cczwx9MW9jbrmAlTaCIWro+VMfWyEgB3eilbc0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_07,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406260107
X-Proofpoint-GUID: bvW7GJNXiE8yqFJoPsQRuG9h30AVmcVG
X-Proofpoint-ORIG-GUID: bvW7GJNXiE8yqFJoPsQRuG9h30AVmcVG

On 26/06/2024 15:26, Christoph Hellwig wrote:
> Check the features flag and the override flag using the
> blk_queue_write_cache, helper otherwise we're going to always
> report "write through".
> 
> Fixes: 1122c0c1cc71 ("block: move cache control settings out of queue->flags")
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Damien Le Moal<dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
