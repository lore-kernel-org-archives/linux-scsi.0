Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDB01A08A3;
	Sun, 20 Jul 2025 22:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753051479; cv=fail; b=VDu1P2gxWtkal78v2X2TKZXolC4Z+KclJkrUGbo1yT15VCwYdEBjOHLEpz9qzToutFGhj3D4sU+GBVkj3ZgXZxCbKD07GNW3PQlOKYOUKoLUYkzMdIB6iEPlwM2bbINJjAU5ppjmhh2a0p0p98lBANzZdju5XNRlqYhqoa4fD0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753051479; c=relaxed/simple;
	bh=PlAew68SqJYPx0fDDlUGkIOfrnOCO4qd3KTsOhpq9VY=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sv+cZphCXSGKm/jJw1RWrgCzcXFR32GLlJyze6rgqXdQ3A/YjiP+7wui4fZhJP0cZVSovyz//7h3Co7NXoz7lUWXhx2G8XAJQ2a2VtYbE1Yl2ksbjI7rRgqe188T/3/CLk3H+BcrfBQwY7OGmBqNUsohePGJwV56Ep+/lQjm2tM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ITWjXMRP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PeIfaAEl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ITWjXMRP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PeIfaAEl"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56KKJFIU008735;
	Sun, 20 Jul 2025 22:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=18vPuXqejsnIpcXrZF/6OcplkGj1jJ83hs6fSGOsKRg=; b=
	ITWjXMRPM0481O/2mtAG96BfnT2Jzp1GXpJ+3rOSiyvcxqRDW+yfkCJ560ujVlwh
	8XCMUDG/41eWXVxxp/F2bfIW0qOjXiixvt9IqrVBYAvRDMq3/R61StehofcHLQlp
	0rt6QXFTttsrbzzJ3bk5psYotnUs0U9UNCqiWC/V7fovJZZO2p6FhzjPXenl2oNE
	cEwOswhqDIqsWJj+yDlq0nMEzwyLoAXiHVTQEADTzrh0UwtWAb/OfWsQx6AEi5S5
	ICy2IcyXdI9Vd/LJQ0XZYfGvo4ULkyFsJyOCfQ9pjWldEPYUnUHtosPWosyeCeVm
	SdPW6uKSAkuDMKOFz1TfDg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48057qsj6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Jul 2025 22:44:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56KIjPiH010340;
	Sun, 20 Jul 2025 22:44:33 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012046.outbound.protection.outlook.com [40.107.200.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t7e174-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Jul 2025 22:44:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4+iYvurfQdrdNXk+jO6EBI8tVokjw9ziTfY4GUXI29tJPrCBpnYxyv8Wh9RpHgLG3DDDYJFwGRvcuL1Hw5ajifzCPQctl6U27sWa8EzsyyNUahq8d99rM3CDgQQHPTB2rL5MD7GCrHGrduYzovrwGveEwL0rMSKbv5m4PXYSQt72VmRtvmury0wL97cXBqdaNVfd/og5PyedIOoq90oKDBVFJKfhbjGgey/4jrDTgDppkE9315FJsYfl5MDDT2g7O2ZDNjN0mBInmCVf/9bLB3YVt1lSuxDiD8iZD1XJ/XWAreUXUCVrl0vvK+84lBny9k+2ND4oTxMPhu1EZWbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18vPuXqejsnIpcXrZF/6OcplkGj1jJ83hs6fSGOsKRg=;
 b=If4OnYvJTBlzforUkzuW5iHGCAvEQ7i04yDAIgmfKHMjiBos8hE3pE/wfemf+ZXFQ2jKPsOKrBZFkw6yeaaTKimOcHzQb01IJUgnfn+Tn8nLBc3A78z6YlqQoU7QW+XqV7N2yScWSSOYHiYHoYtXiaEjundtuxnr8Q4mhAjQvgmjp/nniezbzNj88aCTj3lVB9uPPY0OEEKBFeSqmCh2JBw2X4gvb1O6IK+rBn4gC2+xrm381cIF7R7xIT7dNp5BRdRozRUsvVIHazod9jaPiqOhdsJCrMOONt3wuBbyagLE59uLIc2hHqvRojd+QSV/mE6PqiPziUJKIZsnQJlnMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18vPuXqejsnIpcXrZF/6OcplkGj1jJ83hs6fSGOsKRg=;
 b=PeIfaAElv318cmcCeuoKlWMnO5bl7A3atZkcuCgd5sNWjjpEig8+2SfGBt81dOOvKQJzTgmSBEyLR5rrZUrzSxDm8JQ4b9H75DgCCqy0xwZ+Ede8bpv+488Bl13AGgwU2qIx9nB1mquNW0ZVz1QNUTI0AUwBAClsl/SSqRuXDiM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6206.namprd10.prod.outlook.com (2603:10b6:8:89::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.30; Sun, 20 Jul 2025 22:44:31 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8943.029; Sun, 20 Jul 2025
 22:44:31 +0000
Message-ID: <a1b73345-703b-43dd-90f4-9ed98067f4a5@oracle.com>
Date: Sun, 20 Jul 2025 17:44:30 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] scsi: target: Add WRITE_ATOMIC_16 handler
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-5-michael.christie@oracle.com>
 <7a756a07-b70a-45cb-83f7-3126ca22e1eb@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <7a756a07-b70a-45cb-83f7-3126ca22e1eb@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:8:56::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6206:EE_
X-MS-Office365-Filtering-Correlation-Id: ab44d4d3-e12d-4139-7cc6-08ddc7defdf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWlKTmNaN1IwNTFxMU9NdEJ5RjlTYndodGFCc1hYUk5BUlcydUdXWVd0dy95?=
 =?utf-8?B?MHByQ2MvaFlLMW5yaTlmdEVLdm15b1E1cndXUWlpKzhBbi9zb29vcitIenFH?=
 =?utf-8?B?U0p1dFgwMjlDODBsbk96d3JsRUVoa0JBZ1B1ajk1ZS9OTUR4WW1weFBHc2pU?=
 =?utf-8?B?YTFWbGYzMlErclFqRjJTK3BkWVdvS0xWejg4VmJZQnBLcHB4ME5qZkR2YjFX?=
 =?utf-8?B?Y1RXNTk3MFVsK09kRTh3amJiWDJVT1Q2VmNUL1g1MzgrSVh0VmZabHhSMGZn?=
 =?utf-8?B?UUwvVFRldWIyMGFaRGpTejNNMHdSOXF3NU9DN0NRSEZPREZpZnE1bUxRd2Yr?=
 =?utf-8?B?am5jQi9iOHdFOGUwK2lWNzlmdS9SZHhoczFNekZ4Z284cHNwVmliUVdmcEYw?=
 =?utf-8?B?SDlKV05VaFpZRlpNZkJQaGVDMExwWCtCcGRvWTNta0UzSGF1YWJ1S0VYRzM4?=
 =?utf-8?B?ZGRSYzgxT2Z3U09FeTQ5ZmxtVm9LS3ZDU0xURXNYcitSNTVBc0FlVkw2Z2hv?=
 =?utf-8?B?d3h6NlgyQ3pLaVU1dGhlc2NFMFBBa3dQREpHRTNZZUVrdmIzYVpQWXhBei9t?=
 =?utf-8?B?NzN1Rm5WZFdMYlVvMGEzZHN2UFdWMDdHR2NjN21LWUdXRFowaEQrNFpja3JC?=
 =?utf-8?B?VjdxWi9TSWV0VHNmTTZvVTN2UCtQRkZQR0FhVTRlOWdBRWhYMmRiUVBtVDBJ?=
 =?utf-8?B?UWxpcS9QRGZXV3ZqcjBOZ2RIZjE2S3BuWkNIaHpMYVNaYmVZVXo0bjNhNmdP?=
 =?utf-8?B?VDVWbUpQQmZpRDVhRlk0Q3o4L3EvRC9vbmR3alQ1L1cveXVBNnY1Rk5aNWF4?=
 =?utf-8?B?dmFyUEhjMWZ1VjlGSjUrMkp1MWxyd0psM0Ftd3hBMW9CaUVaNnN5TEFKcjRM?=
 =?utf-8?B?UjRkWHRjZEtFV0ljNjdQVFVOODdydmVkZlhPODV1REpvY09QeURrRTViY2Iy?=
 =?utf-8?B?VDE5VnE3K2lkTjRUSFp5dUMrYjdjaEZLWkdNQzdPNFIvYXVjV2d0RFZKT09K?=
 =?utf-8?B?Z2tGQVFPendZaGtGQkcyOU9GcXlUVXJ1R2JpSmJ2K2xTR3ZUU1Q1a0pnWExX?=
 =?utf-8?B?TDJrdnBkMzlORThjNTdnb3ROc21BTWtqWG1TYlZoeUkxUXhuUnViVmRvNnRu?=
 =?utf-8?B?OVp1MEZOSXhmS0c0WHZhMnRZL0w3dzdFMCtvVUtscUN3VCtpcitSZUlLc3FK?=
 =?utf-8?B?TzZoUlZmOVA3bEZ5TXVKbjF6eXpueTBWSE5KMVc5U1I4V2dnRi9RUTRXdUhY?=
 =?utf-8?B?bVRKYzZHWXN5UkR5NElKNVptbjhQcXRPUGp6dFh2MU5xbTVxL1RjbDAzWkVK?=
 =?utf-8?B?YXJ1WE5qQ3Nva0NZVHRYNmcwTUpQbzdDKzg4YVpoUm0rYVJ2NGtnaEpoVlhr?=
 =?utf-8?B?RStvSHVVMkttMmxpcTRza3R1M3pxUEpzTjFzMWd3S2hkUExESmpGaWY2TStR?=
 =?utf-8?B?dWpXdWlsdWNSWnpKVFJkWVFjLzdsajR4NXRSU3k4dEtvYXU3SGxodXQ3UVFE?=
 =?utf-8?B?UFBqYlNaOHg2VkFPbGkwYjFMcnAzM21ma3BHYVU0V3QyRFpWTnZYRjdxVmZV?=
 =?utf-8?B?Sk1Gb1BQVkpZaHpiQlVDQ3VBT2l0M3IvUTRLa2ZRWGFuTWVMbUc3bXVFcWQ0?=
 =?utf-8?B?N1d4L1N5SHgySU8ybk12OGJkNkQxZ0FUSjczYWV5aE9oSUtGWlcybGxvUHU2?=
 =?utf-8?B?aFk2UWFTUHBkTHpiNy9RWmNUb0I2STRsaEF4aFRHZXgrRkVyL1JWME1xRXd1?=
 =?utf-8?B?eXUzT2ZySFBsbGx2QjJDNjhDL0JPbG9MYUl6R0FMTzJieHlBM3Qyc2FnVUJW?=
 =?utf-8?B?SzZOSWF6Q2ZBOCtqMmhIMEFFSzBnblJlWkhTUE5Cdk84ZHloU1NnK1drSGpv?=
 =?utf-8?B?WndEdFRZeE5RTjZzdmRTWjNBVzAvY3pEK0xnM09LTVRJUFdOd2dIUEo0QnNQ?=
 =?utf-8?Q?XmEjls/rde4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGltd3lXdlI5NEdsRkZzOUFZbGNOS3Jzc0NFWlRtM3R1ZHZRWnI3V3JNcTcy?=
 =?utf-8?B?K0ZUTE96RGJZQWxFbTc3cGNIYll3dnhHOE5wMWFoMC82Rjd1ZXJia2pPWXh0?=
 =?utf-8?B?Zk11ZHZNR2QvTnNjSE1rRHl6czRVd25MdlRxU1BwQ3VIbWhEeHVSY05PUm1H?=
 =?utf-8?B?NXFnNlpCNG9NT055YXVEb2lIcmdNVTVDOHZ4cEVTZmp5SkZsSlhlWTVOcS9k?=
 =?utf-8?B?amZTMlFybEkzZW4yMUFadzNWd3dRTnI1aFViOXFITWdzMjhpazRhMWhOaWhW?=
 =?utf-8?B?M0RUaDFDOVQ3aGJxSkhuTmVFMk9MNFRjSUprQ1ZWZVVCK3lpN2dMY091bFp1?=
 =?utf-8?B?TDZqMUxEVDFSbWx4Zy9kTGNESmxrYUxsNFVvdVlEeU1oWFNQUncyTmhSNTJu?=
 =?utf-8?B?b1gxRWRacDBMTGJUbXd4TzZzSzUwZ042ZWdZcVlzVkU5RERXR25pbXlVR0hL?=
 =?utf-8?B?cTlBZUg4dnQydmZYYkFYZW85ZzJFNDBocFJEa3dhb3Z3cFBocTllWmRQRnFB?=
 =?utf-8?B?ampXTU4wTFNrdWUvSUxjM1FWVHZIakU4cmYzNlV0b3NYVFh0V2R4dTVPYWwv?=
 =?utf-8?B?ZURlUWswREQxL0ozYjR6WGRHbVZnMnRjeGRBdG9rSEhSMmlReUJWbDhkeCtZ?=
 =?utf-8?B?UWIvdjJrSVZtQ1lubFlNKzdPOWZuUGEvNUEyaDc2aU42cnJKWkI2eWIzYUpR?=
 =?utf-8?B?aEtscnpnQ0Qyci9nUWZ2NitRb2RGbXJDbWQ3WW9wZXUwTTYySFhMdG1JaWlJ?=
 =?utf-8?B?cE5oTEh5WmxQMEpRczNXdXJCbGptQkxRM0p0TjZzWHlLeGY5YnluWi8wWVFo?=
 =?utf-8?B?VGZQNXE1NlEwRVZQUU5zL0tPWDR5Uk5JY0d5RkRjT2ZTRlkxd20xUEJ4bmdk?=
 =?utf-8?B?K3c1VjFsUG5WZ0NvZFRabE9iRXlhU0J5NzlZSm1FMU00R0pLNG53OHFaL0lI?=
 =?utf-8?B?aEk0Rk9jSm9zZUxGWVZUcU1ZWC9qSUhYVm1xUGNYMTlpZkRQcWVId2pubmRx?=
 =?utf-8?B?ZVB5MklTN0tVSk42dEVXZGszOXV0R21KalYvOHM4aHRCenZRaHdJZWdMbU5h?=
 =?utf-8?B?NFYrcXVvWkxsNnN2clJ5QUtpelg5U1hlaWZDdnkvRXE5ZlgxQlVMYm12QTBL?=
 =?utf-8?B?c3Y5S0ZubUg2NDRlTXNSRU12VldvNUJiTGhuM3NTcFg0Wk81ZXBpUERSdHpP?=
 =?utf-8?B?cktneGF5TW9qRW9VRlZJbU9nYmFuS3hQd1c5aU42V0xWUDh6Tjh0ZkhwVElI?=
 =?utf-8?B?SVpSZ2ZQYjN0dVhjN2JQa2wwcVdZL2pNY3ZTVXRJc2dvNDV4NHJvOSsreEVB?=
 =?utf-8?B?dkFOZ3NydzFMTzVkRzdkNWlaVnlGUzFzc1dBRTJCbnphLzIxdVdMSkNxT3k4?=
 =?utf-8?B?RlRYRm8zc3ZzWW9uRE0zZmJSNHdoNENic1oxRURBWm9vZ28ybTdrV05Pd2JI?=
 =?utf-8?B?SkVBczArSFVxbWpOUXVFZnB2RHhpRTVaaGFSbVJYcDNrKzdwb1dIRXc3SHZs?=
 =?utf-8?B?eWdxZ0RXeDFwYjgyZE9OR242RWUzV2xUamNrYittcWJITGVEVm0zRFlkQlBi?=
 =?utf-8?B?RWl0d2V2bTh5R1ovTzVXZ1JYM1dPKytzZEo2Y2FuL3NKZng4cEhMdTdiajN2?=
 =?utf-8?B?UXZHZHdVcXVLcDN1MURsdnZvdi9yRmd5VDFVbEdUNFZvUVdmQTc4cnJKbjEw?=
 =?utf-8?B?WU91ckpjSi9FdE1jdmVxYTFIdHo2alJORi82cDVrcTcwbjkzVlpwMXBibkpM?=
 =?utf-8?B?c3ovQlBhdG54L1l4VndnRWVGaXJJRGRGeUUxcUdZVUk0Q0tJZ2k5aVlURDl1?=
 =?utf-8?B?SE5uUG5GRG9nVWJOMTF6TW82VHpIb0V6b0RhWnlPQ2xlRm1TTGt3NzVlMUUz?=
 =?utf-8?B?amYwYUs3VUs2a2dzeXNycTdZV3R0K2R5VFZnbnJ2VThlcHU3SUhURHNmUlR0?=
 =?utf-8?B?aHZ1V3ViMWovbzhlSFN6MHAvWU1hTzFDbTk0aUpzQll0ZGJiaWhkOWVwSzZF?=
 =?utf-8?B?TDhUWHlMM0IxdjdDOTk5eW4xNlo5UnFZaVovVmFlc0I5dlRTWXNYcE9nMnEr?=
 =?utf-8?B?ODlhbWx1VTF6NFZFZFAwaDllU2U5d0J4UjBQVmZUR1YrbU9hdWtJa29xM3dF?=
 =?utf-8?B?VmNHZi9mWjZrL29ZRTdVeWpCK2VBTkJDSllHWmxGaHhwQkJzalJadnFZalhn?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QFKPLrwCJVk9zsB6noFn/WEodIKuRn8HW5FEIgD9dqRjCbgG5rJsHeAxvgylC9FogC98YspMMvIUAFsshaSytpLJTPdTF5ubrjs0mn8xzPjtCOMQEL03L7Oltc6+OjHD4SVFccNZnqlq68aLwHIx8tXQke3M7FAiS1eHevoYuDtfuPpOXuwrxDqJZqQU4++hrx1IVQJn/p3hrRKfXZlmLufyiBCGzd9qBOhb9rNFROt851JDMM2gWt1TCV7up+yPofpT6n4NgM3NHiDorv22ZxO/hQBV3SKMOJzsx7rP+9OB5RqKu2LHKedOXbAMR91VLhzvK4l6Dq5q7BMQ1WIbGJjfm1LHGwVd/pBQtnR0hMzZE4vb9Yqh4hkc7V0kk1xPcPlzVUYiYHW2la7f+6sz+uko3rNGDYYguOpX4inlE2xFMw4E+WjB53NzuG8cxr1KloPT9sEK9ShIxK1t1L+qnvOxKRcBcPJEYy2uFJV29iGgJZA0PkTAE1bwSiEsOUM3eOI/3oPZSHbMkGb13spV+q69BcI/PLp9nSX14xbF1Hr+pP+Ynm6nrTgW04P47uh219zOjzSgcqFqVrpC/ofmuPDTICJQgsearC2Bz988QoE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab44d4d3-e12d-4139-7cc6-08ddc7defdf5
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2025 22:44:31.5384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jaOyBCY4GmUkOBpPOAHGDGELgLQe+RZhNI5a9GIovgoFKMBS1H0Ban8TWF+95wmfOMEdY1ASEkacBJeRzi06WWiwAWmTbm6DrK2tYAhy2Wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6206
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-20_02,2025-07-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507200219
X-Authority-Analysis: v=2.4 cv=MNRgmNZl c=1 sm=1 tr=0 ts=687d7152 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=leKjk60jJCpmCw-pLTYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Lq32BasL2IlfyJpV2myif213TcQ6vbVy
X-Proofpoint-GUID: Lq32BasL2IlfyJpV2myif213TcQ6vbVy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIwMDIxOCBTYWx0ZWRfX94SAp4dudbon
 zswj/OtpkkHQXHS0S7nkIN+9aZVhNbc6qMF2BjP5i+wXZS6AHwML8RLKu3gPARMhkuwNq1e8VDv
 I2MFwRU2ah00bWKzOM0cngL3kkEyYn8zCW6jke7iWj6O1IP4SbQhgWGxlKcOHk/1KeqzmQzc6hw
 joZBF/LFjbUecU7MTC+WfnCOLMcHwJLYIXdnjPoJgyptlECHiIGsL9oOrrN6TX/CoWa+TcqXQsz
 sW3OUxDQejgRJOxl2gHKFIjvEdOzpwVKLIJpb1Rr7NX9IHTFbsrc/b75VUny62LkJtFWJxYTfXp
 M1j/tWtmZ9NAiRp1zSa51XdlVEDSY4EcB8laJdUgZZoLSFEtOZflsfdLECvMUbt+BMoCqWdRhd4
 BqahFsMkTFZk50psTxCPi2fYgeoJpDdaSelPEgccBmMwzQAWxOt7Aqys4AOg+qzIau7D+4va

On 5/14/25 5:47 AM, John Garry wrote:
> On 08/10/2024 03:03, Mike Christie wrote:
>> This adds the core LIO code to process the WRITE_ATOMIC_16 command.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/target/target_core_sbc.c  | 48 +++++++++++++++++++++++++++++++
>>   include/target/target_core_base.h |  1 +
>>   2 files changed, 49 insertions(+)
>>
>> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
>> index fe8beb7dbab1..0ae0d4ec0ac3 100644
>> --- a/drivers/target/target_core_sbc.c
>> +++ b/drivers/target/target_core_sbc.c
>> @@ -764,6 +764,46 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
>>       return 0;
>>   }
>>   +static int
>> +sbc_check_atomic(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
>> +{
>> +    struct se_dev_attrib *attrib = &dev->dev_attrib;
>> +    u16 boundary, transfer_len;
>> +    u32 lba;
>> +
>> +    if (!attrib->atomic_supported)
>> +        return TCM_UNSUPPORTED_SCSI_OPCODE;
>> +
>> +    lba = transport_lba_32(cdb);
> 
> should this be 64, not 32?
> 

Yeah will fix.

>> +    boundary = get_unaligned_be16(&cdb[10]);
>> +    transfer_len = get_unaligned_be16(&cdb[12]);
>> +
>> +    if (!boundary) {
>> +        if (transfer_len > attrib->atomic_max_len)
>> +            return TCM_INVALID_CDB_FIELD;
> 
> from sbc4r22 4.29.1, the key is ILLEGAL_REQUEST and sense code is INVALID CDB FIELD, but is it possible to have the field pointer set to the TRANSFER LENGTH in the CDB?

I can. Will do.
