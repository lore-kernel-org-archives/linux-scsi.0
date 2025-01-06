Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BD518B46E;
	Mon,  6 Jan 2025 08:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736150802; cv=fail; b=I+DVdMf+qzXU8tJAVLDO5iyhq9DtjdB/SliDxegTnRfti2KRnvT5pB+KydgQQXrj2tXE80x2GdBWhqOVUvysKIFgt+vN9KDjHA38evvKTdzQYr1TjgliM6X3qIW4uVDgdzXYblHw408wLZkzBJDq3Kf49xFbkHMA+GlyVuqyPd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736150802; c=relaxed/simple;
	bh=KYD/s4/fBE/5O0zoM0TI5lggtQqwW6lIwK8PedscitU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BrsqjvJ5cloBwD0w1i5YdKrSVscTlZul7hreB2WcEPTjBaJv9SSK6iD1RSUQr/+V/pvIv3XZWMZxTX+8mmjkvf1jgUbVtd+G5JE043UoJ7TU0zxdtpYh4+w75tQfT5ay82lwGXUOQSxgtmR3iarRfsoHHoF6ixmuz4QiiSuTqgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TWppWr3U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TTnPxMen; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TWppWr3U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TTnPxMen"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 505NUnmS016221;
	Mon, 6 Jan 2025 08:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kJ2pAhbcxjuO3jzw3a8U3GN2UNt2CTcWaHoq30Hj3eQ=; b=
	TWppWr3UsdhpJTfDnkJLQagKrAK69OTrz7ttxKeoWrokAH8tEfNjdOZl+o1d5QYR
	zlkKYIdv3twPlfBn7pCXgM8XutHV5RKZ2C7iJTxvT6Ks/cPhpCL7CZ0tGTlMQRoW
	kawcc+7B3be2EEey5foW+IHmA8V2r0cV13dsIy8JiQSXWxlII7rxn79Cc11TBRmV
	gkuqyYzxy9PmUG79GadD6hztMTGQLSX8OMLJQWoKZZIFOOSt7qe8E6Y1b9QZkyso
	RT3kU4g3eGQe901eo0MDz7T2owrJehGuM9cwhDUGfKtiHCezwvQ9epxX+9GPxhy6
	7oSGiRrb5LfWDByQddGBvg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xwhshusd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 08:06:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5066rDpR027219;
	Mon, 6 Jan 2025 08:06:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue7888y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 08:06:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IQuSfAu+Xee8qryeOkVdkCioCuUA29oay70D/GM4Qz3ApJzzpbvPNRKEpEMBMfFqZYXqf+w1gkmbWcI5VsDuwciyVN0OSI/3ObRGDbUyqK2K72N3Zb8xyP9zp21mJfEdKptNhXbT71KR85MGpJ1OdMDl8Cgmyj4RbmfKWn/aqajg+dYcII3T6GDbGyKSMssHhT9aKHHX4R/DQ9sm3NoUxy+C29bFVlQICXyYNObVz8J6mhSMk0M2KS4XgPKNh5eagByw6qTKbgQuo9wruK/XEa39CMtZHlJXbH1jze3oIDTk/yFv69eI9v1v2AIvLcoVijSSKBlX3C7Q5U+OMwY2BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJ2pAhbcxjuO3jzw3a8U3GN2UNt2CTcWaHoq30Hj3eQ=;
 b=XEfRl1u+qP7tgNNagYa6nV+Squgf6E6j00Ic1fOTt2Lrg0UVi/zN7f4zdnFvEtmCZNFeKNDHosWq2TzpbXngV4heqGR+q/T5h2HB3ExNUIP+ernjVHEEGEHhVsUh06m7gGCRuf00DciFVUhqN+1AH8n7CnCtoYd5eepmsvSaiJJ5OdsNe/FElirtXMwW64iYIU7X9tBJhvCI7faO8nfeHJObGU2Kkwr0ddC9xsdgrmpYqz6v44k1pU4Dmun7IxsTMLCmMY4zfHZBTGxSI1mRVFStNYi9Gwzluv8jdb/rWtvjj/8OT0IIlxjGHltRAhvUTkrLsvrYhpTktcLlI/Anyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ2pAhbcxjuO3jzw3a8U3GN2UNt2CTcWaHoq30Hj3eQ=;
 b=TTnPxMenANKQ44xTQ/Qcv7EpL8bpkw0E3oEXfwwL5OwXdECLlihTxeCCbATNni+vUu4Wx3kkGi1UgDQNCNPm6tbgZ23d8jj8hanlihdPqVBswxwCAFVoGdQHj1KdiSY9DkcySAfwgZcG2XQSpAX6SksksQbY1goADW4c71NvEC4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6255.namprd10.prod.outlook.com (2603:10b6:8:8e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Mon, 6 Jan
 2025 08:06:26 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 08:06:26 +0000
Message-ID: <0a79e40b-71b8-47bb-89da-839590eb390f@oracle.com>
Date: Mon, 6 Jan 2025 08:06:25 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] block: simplify tag allocation policy selection
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <cassel@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250103074237.460751-1-hch@lst.de>
 <20250103074237.460751-5-hch@lst.de>
 <d7cbbe46-ecd1-4bdc-8fe9-7df499ba9e6f@oracle.com>
 <20250106073520.GA17229@lst.de> <20250106075824.GA17919@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250106075824.GA17919@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0476.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6255:EE_
X-MS-Office365-Filtering-Correlation-Id: f0352805-3631-43b2-2e45-08dd2e29047c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekpsN3JqVWVmRHJJQXZBRk5NcmwyVENIMUtiNjNMeDlibk9oNXAyNnREQlJG?=
 =?utf-8?B?MUVML29UcHh4MGxjTlZ1WDJZWTZKUXVydzMvelFSeFJ5TlFwOERKbGwzL3Jq?=
 =?utf-8?B?bDlHR3J4bkljZWd1S1ZRMDJVVFFsL3JRSThrUGpmS05oalFYYXJoWStZajNa?=
 =?utf-8?B?Sm5VUGREd3NyelJZZUxaUHFQMDltWnkrUTd3UU5lMEUrUk9LeTh2aXpLaUdU?=
 =?utf-8?B?SnNoM2w3eDdKbEk1RUM4T1R2NkFYdVM4c25OS1hyWHFSWmYzNDZGL1RHUHpa?=
 =?utf-8?B?QUVIZnpEbUhMQXpWZlZ2VHJZQkNnN3lKZVZ0Y3p5ZGtGZFh5WHAzZVVjVndo?=
 =?utf-8?B?QjV4SGNvY1I0d2VCYUFhenMvR0kwSWRibUpBNGtjVFp0YXhMeEFCZTVmWHRW?=
 =?utf-8?B?MWw2RldFUExHcUVwKzJmaDNLWVk3Z09GQ1ZUWGw1am9JNWRGdmFyRXY0TFFC?=
 =?utf-8?B?MzhSWitJeTcyKzMvcndKcDRoUERKL0NDWUh2V0pjSmcwOUtNeDlaYy9SVFhJ?=
 =?utf-8?B?c3N3NXJEL3lwL0xoWmNVbGg1bXI1bVVaY0VIV0ZubUpXVGJYSlJYQnErT3lv?=
 =?utf-8?B?QXhpWTA1STUwRUZuMUdyaGNDaTV2UlkrRWVTd25oRUxRRk1SMldoOTBHdHY0?=
 =?utf-8?B?Z0tvNVlhd1hBMm01K0tKSHlVN2MvR3kwa1Jzc0JFeTRsbzdGL0hlVFc3YWVD?=
 =?utf-8?B?M1BlY2d2ZGhTVlJaVkhKSkRaY3oxSW1CeW82Y1pHZWhnbnJoSTBqTlJjOVBN?=
 =?utf-8?B?UXovdVJ2UWcvdkNaaVF6bG16blpPdnFnM2cxZ3VxOHZsV3FzM29HTy9LTHBp?=
 =?utf-8?B?bEpLQllpTSttQVlYcUY4UlZWZmsvaWhEdXhYM0NPM1ZMVEZ3NXFCYmIyNjk1?=
 =?utf-8?B?OTJmUHFBUENKeE52RUxnNGdXYlMzMGgvUGUxM1d3MndrWTB5Q0VpM2tvNkZ4?=
 =?utf-8?B?d0o4M21kVndxcU5sMkw3VjdJU0NOVGM3SDl1NXR5aXVOMW1jSG1oNy9CL0dv?=
 =?utf-8?B?SWl1NlYzSlllMzBBSlR0M1U1TG4yaU1La3BXZms1SGlxeSt0Z0ZQT29iK0hm?=
 =?utf-8?B?TDV0bkExQ2tiWTBLYUNpZ1hRSk1UV3dQZCs4YTRwODJSVlFZZDlrRTdxMjFG?=
 =?utf-8?B?eGk0bDQyQzg1Zk9QbGpGUkFVOVY1cmg1Sm01UEdreVZYNlBScTh5NWZyUWRt?=
 =?utf-8?B?ZFk3MGVEaWtOaE10VlJNRnQ5VzRZZ1RUNmMrMElRYUxEWGJLbnEzK0pFQzh6?=
 =?utf-8?B?d0RVNmNVZ05YRmlmak44bTV4cHh6aFgrSTd1aUJsc2pOZjR2UnN1U1RWUmJo?=
 =?utf-8?B?bjA5cWN4YTB3eXZ3RjBVbzdNSG1uR1RQaVlpeEZlbVlEQThoYTcycWh5eitw?=
 =?utf-8?B?akxPSlpQWDFSMUtJc3NOd0FlbGVkVlhwbzI3bWhZZnA2SmdBWmJSRDFkMXdG?=
 =?utf-8?B?T0x6VkpVcERpZHhFdHhyRmd5aEpIaFhZQTNlMjJId013Q0k2UG9IVXFDZHVl?=
 =?utf-8?B?SEh6WlJjNFkxNHozWVZybVQybGpRdmwzSE1nZllwUUsxT1RaQzcwOXZSVnhh?=
 =?utf-8?B?NFlGMEFZWkwvMGFXOHd1cHZqcldpMVR2YkNSR0NaNlM3bWZwelhKUlliNUJH?=
 =?utf-8?B?VHB6YllyNEdKeERhMGhTcU1oL2tkYVN5cEVabXNtT1piS3VnWU9Ud1VsTmRz?=
 =?utf-8?B?UFpmd1RNZm9SQXRlTnBCSXcrd0hnSGZ0bnI4YmtOSjdidnI3ZWx5QzZ5NjJS?=
 =?utf-8?B?MmdCQnJCMS9wZWxPSExRSUwzZzJHRTRyWjZ6c0lWTGF0VGlUaWFiYmtuaHZP?=
 =?utf-8?B?Y3A5VHVSYTBYREgvQWwrWloxUmMvWi9pN1M1bXZhcHFpNHF3b2pBbkZRTHAz?=
 =?utf-8?Q?9LCxDVFCIYxzp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TE4zcHlwaFFYWEtaOGNxcVhGMkg1WkRnTi94YytRYTdRbWl4U0QvUGRnMDVI?=
 =?utf-8?B?U1NZSjlVL0hsMHJNRHhZY0VKZVN0MHJoZFV3ZjdxcnFHZk1wZ2U2bERGWFNE?=
 =?utf-8?B?YytOdGk2T2xQcm9pTTNsU3Q1WFhqVFFYbk1tdFhKWUpDQXFoRzhNdUdMaDFD?=
 =?utf-8?B?bjlMelJLN1lyNWRON1hjV2ZRdzFuaWhQRkZQZVZhRHhyZmtGMGFJU21KZXl1?=
 =?utf-8?B?VmU3TDNZdXVLdXN4YlpObkVNTndFdGxSamFDWFAvOEJrelBuVFBuaEVWRHZ0?=
 =?utf-8?B?Q004R0pqZG15RGJsMDBSaDY0UG4rK25RTStDVVFSV1B3VUdBaGJybEh2UUhl?=
 =?utf-8?B?bm5ySDk4cEFEUUVNQ2tnQzY2dGFqbWdrTVo3SkMwaVpBY3lSenhTdE1sQzNw?=
 =?utf-8?B?QVJRT2UwSGdGMThNUkNYWkhsbUJrYUY3YTdJNWlZRENQS3ZoQW1FNTBZTjBa?=
 =?utf-8?B?blpFTFpMV3VMZy9SNVROaGFIVDlpVHN6UUNkZWsveFYrU0krR1ZmUTI0d2FP?=
 =?utf-8?B?RjVTK2V3cUxKVmc4Yjh4ZmxIeHgrcDIxTjhBOW9RYTAveW45NExBLysyeWgv?=
 =?utf-8?B?ekJJUnlVTzd4dDZQUXpiUmF3bVVBYzROZkxDSmpQbzlDSnpmYUs1dVVFUkhm?=
 =?utf-8?B?eS9CWHpVeWNQS1dVK1plbjJqRFIzeUlveHg1czNvTkIxSXNCWXF5NWE2a2tC?=
 =?utf-8?B?TVF4TDZjbnVOWXBPSHJ6eUlGbGJ4cFF3Q0ErNGNYTmxEclQzZDl1MW5yR3Vi?=
 =?utf-8?B?MldpS0VpZzlwSU01Q3hZMFJmaDcyV3ZxVmliU0ZsK1puU0Z5R2ZJNU5VdDhn?=
 =?utf-8?B?NlFIR3NkLzAxQWpZaEJKWFNxTzZUVlp1UWZSditqYmJ0Uit1RTRwRzBOZVRP?=
 =?utf-8?B?bVQvTFdiZ0VteGRvSDNCYnAvaTl3Q29oVG04L0pYT3dxbE51NFFhQmo0K0pn?=
 =?utf-8?B?N3hnU1N5WkZBb1FVcENtSkh5N1FNaWU5MkM5c2Fma2FBaDAvUFlGbkEyWGpt?=
 =?utf-8?B?bnQzcXNjdDEwRmhvVG9Xdm82eTNKL3J6bFhHOTkreTl1czJJbzN1QmVROU1o?=
 =?utf-8?B?WXdEeTQ3KytzQTRLeXU5cUlKRDRVY2JPSWN3eUIwSnA4ZTdZUkNJMVlLUjFt?=
 =?utf-8?B?cDVsRXR4TnhpQjFma2lwZEEzTk9lVkI4TVVocGFRa1hIQ1hvdTVFQ2gzR25t?=
 =?utf-8?B?QUpxOXNBQmkvTGtWOWNKR25tQUtJWmZBWXAzYmFoZmwwL2ZKa2IxM2xkQXVn?=
 =?utf-8?B?eWpvbUFOcUppSVJYRk5RUVlBOU1zRTdDNE5KdjRLc3pUWjRRVnRJZFBrV1hX?=
 =?utf-8?B?N0U4aTN2anZYK25JeHZsMlNoL010T1NpK1FJejdLdWdFaDBtdTZTUGR1QXkz?=
 =?utf-8?B?V1Z2OGNwME43TmRaSFZyYnNOTmxwK084OWJLcGFnSjhOZFNxVzk3ZHZmT1Nv?=
 =?utf-8?B?ZnZMbmEwcVRvU3ExSHdScjJVZUVXbVVzdElLcUJCQ1E0YTVBUTRkTGZiVkdL?=
 =?utf-8?B?bHkvYzJrQjd2dFloQ2tCWGZpaisydmRCaXYxTDhMYzdEb3crM1pPaStJNGF3?=
 =?utf-8?B?OUxsc0IyLzBSNEQvTG41anRPL29jd2hEM3ZFNGpTZHBaTjhBYXBCRGx6ai9a?=
 =?utf-8?B?c1dmZmxHbU9aUXlPcTNyTHZaQ283Y2NFQk1UUklqSElsNXRNaXFpbXNHWXoy?=
 =?utf-8?B?czVoQTNwUDl5aEdZMEl6UHpVMEVpdWFJVTFaNHJxcUthZStVRmhKb29JRkov?=
 =?utf-8?B?c0xFU3hpcjQzcTFqME03ZUU3V09lcnB3eE8rNkorS0NCY2ZRdGJCN2JPV1JC?=
 =?utf-8?B?QUxCVkxTNmExdEY2Sk14RExHWUVLS0J6bHhVQzloQmFKRE8zcXEyaUNiQll3?=
 =?utf-8?B?emdGb2N1UksrNCtVcGJCcUFURk45RTFHWGw2SlJ2UHpIckFId1dzUjdhbWtL?=
 =?utf-8?B?MjJNdG5DSExtV2JjdXVRaDFnZXlvb0lGZUtWbkdVU000N215NjVNejhRNkZs?=
 =?utf-8?B?VWNRVncrV3FWd3ZYVStYN1ZQNW5BVE9GRHZqTTNscENHZzluaEhteWVHbWFz?=
 =?utf-8?B?ZlB0WFlmWmtzaHM5MTE4WWhKcDd6a2RPV3BOZ0tYbUo5QzhIVjdwa3Q2c2JC?=
 =?utf-8?B?dXE5SklzK240LzJTRGJ5R2tPa08yYTF4Sk1KMjlVMnV4TFFGR2g3VEVXQXpU?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0v4DkiL4YtVpErWeU34PhlB6cSkveemt/+Hsq4PNzhDv68nePO5VVZFEbgCo7cQR9vPsJanCHS9Gfu+cH0qjlmNPHbsuyo5QQ5gBdWHStyr2VGHX2cpr1BYAJ683uZN6+ayvvcUYcUB84f+fKL1+LvrbpeHOUR9kULe/bUVPJTux6aFk/N0MITtZtBRLOTWvXhBlp+I7ursIIJVpLhubV5G0ootk2bL/+JENyYB/RUJlQy/m/lJuheFieYH2sxaT8u83oLif23AiPJvCz4u9BhfuxNmYfWw76chKcIdoAgbsv3H0pcPGJcOH2aCD+mn8JTllN50510F4uu43hPA/Rec72GvtYsVhvxPBRQYR0OVQM7iEeRKaXnVZiMsFMaeuOYunsR8IzNIKoc08UQNlgchKjNOarx2s2vstBBE82HbK1qdZyIG7a7TRIhH0ezPTSOzSd6FAFxdnBjWklD+RECcSNLZP2f24b1365QOrR2N/vxUe9yq6v/mXJmtNL42za891QmycU2o34auQ8GblPiQReUmC1Zky8szN0eTt8Cys6NrCaIEvur4mp2JnxcSIVO9N7VM+XMKiNuITj9lshl3555ofIIUmd/Mn6cGEBhc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0352805-3631-43b2-2e45-08dd2e29047c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 08:06:26.2568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFDILsWp49Eq9xwsbUvZ3fqRMXci1gVvkgjJPdVW/0J9TobdJgQkDjU5m6uLlZCNNptniKm1bWm+aL4uIudtDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060070
X-Proofpoint-GUID: LCrxg4UrCkT3SfA7ZIBYApa4LZ5CTZBK
X-Proofpoint-ORIG-GUID: LCrxg4UrCkT3SfA7ZIBYApa4LZ5CTZBK

On 06/01/2025 07:58, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 08:35:20AM +0100, Christoph Hellwig wrote:
>>>> --- a/drivers/ata/sata_sil24.c
>>>> +++ b/drivers/ata/sata_sil24.c
>>>> @@ -378,7 +378,7 @@ static const struct scsi_host_template sil24_sht = {
>>>>    	.can_queue		= SIL24_MAX_CMDS,
>>>>    	.sg_tablesize		= SIL24_MAX_SGE,
>>>>    	.dma_boundary		= ATA_DMA_BOUNDARY,
>>>> -	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,
>>>> +	.tag_alloc_policy	= SCSI_TAG_ALLOC_FIFO,
>>> do we actually need to set tag_alloc_policy to the default
>>> (SCSI_TAG_ALLOC_FIFO)?
>> libata uses weird inheritance where __ATA_BASE_SHT sets default fields
>> that can then later be override, so this is indeed needed to set the
>> field back to the original default after the previous assignment changed
>> it.  (Did I mentioned I hate this style of programming? :))
> It turns out the clearning is not needed here, as the driver only
> uses __ATA_BASE_SHT and not ATA_BASE_SHT 

Yeah, if you build with W=1, you get "initialized field overwritten" 
error when trying to set a value more than once in the structure.

(did I mentioned I hate this
> templating?

Sure, but it reduces lots of code. Maybe a nicer model is something like 
scsi_host_alloc(), which sets defaults (when not set).

)


