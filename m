Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764A4149C4C;
	Tue, 25 Jun 2024 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719314813; cv=fail; b=L7qtH58xcx00JlPM2t8eJDY9PNrG7xVqdtaYCQ2jivljq5BWyUvedECQFtsuqONgLaFEInGT6NxvPDFtO4m4Wq16DhPy7Gw46o3pfiBDwMywlENHW9KFzCL1pN/XyVEmfMcIYwTiWMx7G/UPlCnT60Lr/t8CUdFS60JZn890Z0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719314813; c=relaxed/simple;
	bh=l6bxWZLstHZ1QeupeTKfAG1KEDx8aRWddTt4s6KO4/I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PGRlu2umSeFmm+D2S/H9X5ktHLK1TYF313vqIkxcn9Wnxe5cDQWBw10pUzBOSCkK8piv3+wzJwRrj9cOLmDxz2gN/H83dfqLyF1ZmNPv9rdgTBvAeLuzi6drNrZqKdBJxkmtvnH9Z/Eh7kPJki5tSDkxBkB9IzNj4y0d2VLjrNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QFvWJMxA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iv5iEyre; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QFvWJMxA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iv5iEyre"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45P7tW3g024962;
	Tue, 25 Jun 2024 11:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=tRQEMjbXfvVK4mTSFpVAVh2qIV3JQiaahTJIwMQdFUQ=; b=
	QFvWJMxAxXfz//OHp6Z15kXx+6KBvh3QolBWaiq885X/FdzZxaFfo84YwUaFIWA/
	HMAxRCC9mhRYa21WKayqbX8CyVFdh1d32UPgh2vgJYX48mNFuFK2URbvfsaV1Ibr
	5nWTQFQJQyweuS/Vcc+AGRpGuTJQPvmK8ZgpufMoXy6u6x6GmCxcSS6nW/zmCF2P
	eVomOQk5hOmCS0LZojREJS0N2MxE3h4Mckot+xVxeh5L2YPjG4fffaEw8sMCQ1G5
	w44rUet4+wUSv/5rTGPg1L5LyHTkSu4WO64gdcyY4hqaIFlpTY4FjJpB3iHb5AtF
	X6qPo+CO34P98gkl4c7Teg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywn708dpf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 11:24:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45PBNSKX017844;
	Tue, 25 Jun 2024 11:24:15 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn27c0xs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 11:24:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5bvoA+UIPssM2Mlm1UFvy4oA/rPrpnUGmSoAnaREVL4BA8A7iLheZ90NsOwRQ+IYMTZjHW3QDpbil38svGVUenkg3tOZPf1T6+1g7VXDAVDuhO8xMXRWFemu3RQ1weiuspuyzg3CyWJbM40j4tAcNcmPCQM79VqsGg/efqpFzPMRHFl7Jln/aCs6reWUWS2IaIh8aycDegB3PiT5b2jKbS9yfDqYSOZmrotHLCNycw9s7Zu57c4f5BsBTqQ36Y05O2w/9OKNWdZfdSQXQ1LoowGOT3zVpOvv//3+A5fh/9eQESMPLcEv9VvP3NBB7WhicPdtxMMeLOo9U6lc6AtGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tRQEMjbXfvVK4mTSFpVAVh2qIV3JQiaahTJIwMQdFUQ=;
 b=boRhSnPvu3Th7nblj079EVOj3rIxmBl2MYSvEajOeG/fZQ9Xvxptq9IWEoJJ4u/BymM6i9G0PaKc3YngGRFgc6PN7MvrYIH9wNAQ0yK/2jyLv+LXnlPrw5zhkGd2bLFv8vIwdEDYYowa6sinuFYET8AfwCqUtEkxC+RPiVnVyAjDryrb9RFBYYyPULQIKcTGK5G5dqi8iPmtODSf3D6HAC1/K32veyd+cLzfJoAzJQK+seDuwky0dVkGT009y6xwn/dpK0puGw4LIhbLPNER7qvKKwxcq813OhaEkhK4RSD3BnXpSzvOdLlht1DB0Swv1aaqcfRWbsfQG4BeauV8Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRQEMjbXfvVK4mTSFpVAVh2qIV3JQiaahTJIwMQdFUQ=;
 b=iv5iEyreKTcpaRWII0+viskR3LyRIgZF1SHtgCYwVqyaGkQP0Ff7j+SK/RoH4/tc6YT5OtL9wjAGzcw3bqL+a6g+GbOhjb2DFD0kmLt0vCk4Ww8ZUduZA6gCqeUtuLguNENqbV38/MYQ1GhuWjpQ0aMekO7PZws6nYFwJOZT1NY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6158.namprd10.prod.outlook.com (2603:10b6:8:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 11:24:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 11:24:13 +0000
Message-ID: <c7184755-3e82-44d1-bedf-d1c6f0211f59@oracle.com>
Date: Tue, 25 Jun 2024 12:24:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] block: rename BLK_FLAG_MISALIGNED
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20240625110603.50885-1-hch@lst.de>
 <20240625110603.50885-4-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240625110603.50885-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0072.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 50d59c19-1818-4815-5a62-08dc95095742
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011|7416011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?UDRuTDJHcHRYUEhsV3BGUVQxTEF6UUhZRFVLeFo0ZzhMOS9FcmFjVUxjMXpQ?=
 =?utf-8?B?ODN5YUp6eTNndkkrZWxteGY0NksyU3FTYzdIbEJRazhGcmFzQ2xVTnBrcDRO?=
 =?utf-8?B?VzVLc2JHbFBWT2s4VTVEeTljcHp4a2l0UFZNNjdjUytHTUJHS1l6VFBWek5L?=
 =?utf-8?B?cTIvMnlIcS9Tdmtpdk80WXlFTmlsNSt0djFCb3NLSTdLOHFObVhEMm1ob2U1?=
 =?utf-8?B?V3NvQUJxSTNaalRMZzZaQjlBVnlUci9YVFdqSllOOGx6K1Z0Y0xGNFc3Ukc0?=
 =?utf-8?B?RVpnZHl4bWVRYjVCTXA2ZXBWQU81WjVJMDR2dVlKekRtYnQxNjVmTG9LaCtO?=
 =?utf-8?B?ZVNsUkRIRldkaE1OZ0tTSnJxQmRxNityZTJWbHJxVzRXS05JNTVKQ2ZtTlV5?=
 =?utf-8?B?THpONnBtYi85N0tPR3NrdStwbmIybGlhNGRIUUNIcllMaTFJVTltTGRWYmJL?=
 =?utf-8?B?dDdiTjdxUmZWVTRQU1NQV29OdXlqYmpNbjBNdTRJQTNGYTg1dnc0Uk02enZQ?=
 =?utf-8?B?c25oYmtaR3JFTHpFanEzU1c2a3hvbmFNRERyLytXQ1lUenYvR2NRZkIyZDNp?=
 =?utf-8?B?dXZXS25Hd2l3TVVUZmhhd2dHeVFiNkF3TVAycjVzQWZXTGNVV094ZjViSjJj?=
 =?utf-8?B?TVBSYjBmRzFMaXhzTzRIa1pTT3dRaitEV1lRL1ZCZXNDTitPL3RPcWhJb3VO?=
 =?utf-8?B?UTR1aUE0Q0ExVFR6OWtaeUlOdXZiZE9aTmUxWUxaY1lDNzZxVlZ3UnNBNklj?=
 =?utf-8?B?T1h6UW83YVFtd1dHNnBoTWFnbU9EbUJCbFJHaFFRbWFhdWN1M1lydmZDRjBu?=
 =?utf-8?B?R21OVzhORnpQY0k5RjJrVUhidWIzSXpNT2kxRGdqSlhVU2tQV01ram9tMDYw?=
 =?utf-8?B?QjVTVXNsM1B1cXJHRHh6Sm5sRmx4UXRXSHVIc1dpQ0MrVlBRSzZBZmZiSU1H?=
 =?utf-8?B?eFRKdCtyY2M3WDJRMmlaWWJyUlBRTFRqVUE3eGVPU1hxaW1xVnM2dnArMjVG?=
 =?utf-8?B?dU5OSU5NTnNudDFOU2tCam9ZaHlVZkRoRndHNUh5WC9LaWxCUUhVN2NaRFJT?=
 =?utf-8?B?N2pwTDQwUmZzMlVvN21rOEU2OG9saHBwd2JubldMbGp0L0R4dzM2b25acjdT?=
 =?utf-8?B?Y1lxRnFwWTlYN1NUSW1oM3B3THZzQnQ3eUFUcG04MzRsZ0UwZDlZdWdVTkIv?=
 =?utf-8?B?V2ZqbkVSdVA5SWRYNEx0eWZhcmp2NlI1VDd3QnA3M0dsOGxGR056OFh0cCtl?=
 =?utf-8?B?VWxLaklUMWlkMnF3N29aS1J4bHBZYlBSV2NRWVZTanhycFVqU0l4N0FKTWs0?=
 =?utf-8?B?ei9NUVFGUURGNTlDcy9BZ3dWalA2ekpSVENucFc3a2REUi9oV0RYajhmdW85?=
 =?utf-8?B?a2xEOE0wa3RxK2lKOGczTEFQSHo5dEZiTiszUWE2NEhiRGZXTTQ0TE5LVGJ4?=
 =?utf-8?B?eHZnYUl2c3A3NHladmpGR0loS0xHTVRxVTFMblQyb09mSzYydGRCbHo5eFBn?=
 =?utf-8?B?YzBLdEZrZXZGb2IrSzgzVWVXdnNCWjhCSTl3bUlXRi9MM3pkK0lVUGNuSEVZ?=
 =?utf-8?B?dEtLbGJRZW1vdC82K3ZGcllBeG95SHZ3dUI1K3dwL1liZzJ6SXQyTndpM1RL?=
 =?utf-8?B?VFdMNEd1RkNwaUZTeG9Iank4aUdDU2x6OWl5cmlad2NoY0llR0pzZWUyRGhC?=
 =?utf-8?B?Tm9ZbmNhSmJSM2o1dElUc05RZE5YTUtpVjFaUDdxQm9xZFVla0wrMVZIWmhi?=
 =?utf-8?Q?bSEPvIDvkuPwOUT2C3skral7EFxWhHhric2+Ns0?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011)(7416011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bUlyUk55cHZWL2FnNEVTellSUVVmb0hxN2E0Nk1jamVBZ3o2ei91QndOKzJp?=
 =?utf-8?B?Y25Zd2xaUFFaZUI5YU5PNnNiN3pGTVF6Rlg3ZllWWlo1OFpNb2pzcVlyZFRD?=
 =?utf-8?B?QmE4Q3NWc1NXVWpwelhMb3pXc084TW1ncDJBOWRmek8vM2hxS3Q0aCtpb0g2?=
 =?utf-8?B?Wkc5TVZyQ2JSOWdCQkQzOHVDQkFjMkROYkkrMGpqVFpzcjF2ZXRyaHkzc1JD?=
 =?utf-8?B?Yi9OR2hEU3RabldoQmdFY25YSmhPTnlrS1R4WTdtR1NTR3FkaGlnK05Ca3dC?=
 =?utf-8?B?a2hySTBQMzFlcTdDUzF1Rjc4clBMeHM5UW9IYjV0OWthRnVtTnM4ZmgwUGlX?=
 =?utf-8?B?VUt4SmhkOUxHdXhhQ3cvUlFXWDdCWHFZZmpVY3J2OG5lWTVxbXp5RW9LNW91?=
 =?utf-8?B?Y3Ivd3BLMXFrVUdHV3RqZTcxVzBrRFpWZUJMQVZQY3hRRVZZMWQrd2VLTFNj?=
 =?utf-8?B?c1JpRkUwbU9iNUxwSFBQY3dYQ3VEOFdLdUtsWnRKSEc5NkxGZG80MWIvbkFm?=
 =?utf-8?B?cEg2Z0V6NXhrVzBDVGUxREltOXhuU0JMRXZhbXFLRFU4ZUJ1eVIySG1lYWxL?=
 =?utf-8?B?b3lQalpsRThicnhpZVllSUNhWngzRGttRy9UVjhoZUhUSWV0NHRMamJBTzhY?=
 =?utf-8?B?Uk1CNGxzQk80U0tpVWpQVWgxN2liSHdHOFlJS3d0UnpaN3hyVkJ4YjlQTHRG?=
 =?utf-8?B?MTc2NCtGbE1TVnNkMkFjUElXL1V0YmhuWnpOWVpBaDlDQWxoNTMydHArb09Q?=
 =?utf-8?B?cEdYVEhYWmRGdXpiVVhWQ3NhSlI3YnFDVEZveVZTZG1ETldnak5hbG16THhB?=
 =?utf-8?B?Wk9XK29WenFJMko3MjNsZTdMT1NPdTZpR2dDVGUvSi9QY1lFTjNRaG1QYW9L?=
 =?utf-8?B?Nmh5MFRYZndEOGIrSVk1VzVKV1FCQmlpTHExTURnbGtNQmtwRG44aWJGdkJI?=
 =?utf-8?B?aEZHUXVLS2g4WVNZUHZYZXVyb3AvQytFRjZiZVg4SVB3RU9qemdiZnh5c24w?=
 =?utf-8?B?UVljMytVQktoZ0RNN2M1RXdqNDQ5ZEQ0cFdoOGlxYjhQb3dDTkxRTjJwdEt2?=
 =?utf-8?B?WmtBOHpoVU9NR09OTHNwSk9OcHNNRXFRWW9OQ2pTRWFKd3JMc2YzMzFDVFVu?=
 =?utf-8?B?WTFDLzFHUWptWkFKanJMSFJxNVdDaHFyQnFWV2hZb1QySlRmN09mMGFNanhq?=
 =?utf-8?B?U25WOWtUWUVUK24vMjVPOXhXYysxMTB1QURYc2tGc0huVmM4aW9raFBuTE8v?=
 =?utf-8?B?TzFhVmRXaVlrcDBQQnJlM3VnSnVPeGF2R05EYjJRQURWY2RLUXh6SEZHM280?=
 =?utf-8?B?Wkdndk4yZ1k1ZTV4TGpWRGFDUE5sVnU5U0xzV2c5LzJJbktiN0t5MzBaQjRj?=
 =?utf-8?B?N0xqSXgxUHNTN1ByblFBbDNoM0RIbXhmOVlHeUg3N0N5bzk4ZkIyaGFpR004?=
 =?utf-8?B?ZVBlUVZDb0k0MGx6bTB4eFozWEQ4WXFONEZVWnNXVTZDZDQxNXhmS3dBZDVi?=
 =?utf-8?B?ZmZ1eFNkdjZVR0crTm5CcWdxQzFzSnkrUEVzSk5FWk5VQm9saEN6Rml5YS9a?=
 =?utf-8?B?alhmRGs0NGIweGJsbHQvRkZ6OWp2SHRLeWFHdEtDOThBbTlEdldJVThGNUJu?=
 =?utf-8?B?QjBMbnpXMVk3SG9YMGNTdzNMQ1lTOGJYczRsTTZ6TDlWNEFsMXB4aWJhcGND?=
 =?utf-8?B?ZXNRVkNhYmF4N3RoWnZaMnJ2VXBEWDE5ZDdUYUJabkE5VXkyNVFqQmFtSXpF?=
 =?utf-8?B?cGNMejl4aklNalhBeTZpaDRVYithWmVydFlBcjRJQTVZeHdNSk1BakVLaGc4?=
 =?utf-8?B?Q3NZZStaZytoLzN6UWZncGtRUEw1T1FBMnVzTXUwdGdMdWdLQ29oNFprR0Zv?=
 =?utf-8?B?YXF2ZVl3SGNJZDhHbWlDcUJuZTAwbFlsRDc4N25wV0FXTGtuQlBOdlI2OHpD?=
 =?utf-8?B?N1ZvRkt4SU15anhyekw1MDFjUk52NlpSZm5OWW42T3czekJBNUVKd2g0VmZH?=
 =?utf-8?B?NzZsZDZKcnNXdUtodjFUb2dDMEZqSGZTMHhOQ2VXd3drTGJsYzFGYnB3SzFI?=
 =?utf-8?B?NzltVkhJeGI4N3ppMWNBVGZHZmpRVDFxNVJnY3N2ZlJLN3RWUGRxUmgzbjgy?=
 =?utf-8?Q?BZ9H+osSkH92K1L9ukFOv7SGt?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	zr1wR5aoL99mXB8N0DZdKsbVOr2GjfwYo3k1HE8DOex6e/Z+XVVrdeE5pRinqS2dH6/fFOf83Ky8maum/O5UyZTnUqtGGmtR9WXGTv8FbQFpfE1D7gT2STz1Y+AsvxuaPMRHSEcc3+gnvCKaNY7wCU449dA5RG2MpuqVgSD1ZssvxDvHQj6KYpjVzIs3S1Gct/oM7JiI/wRMckTxZEz6bm1RtG65OFA2mrvUKvBzF67SVKoxbZUZsr4B8+CsiwGTHlk1G8E52eR5ri/8xu1wMy4NRyf907QU0afZSFMu+89FYIPufOtYIsOca9ZmpkTIVmmi1X6X+41x/uJW1ri3p5QwV5VBm2lQRH+MCqto4IRfWYvbaV5zJ51XX3vWoGnE3bJkPwoFFJwOAMDf0SqLP185QutHdYgLPOQN5tAIKvASyjaAv3h/ZvfWmRFx8LjsJ9s0xWNNCiIIHsEFbwLSpFncXf3UuwbbOz8HhyToXCvVANIP9d0zCR2A0dqBVIb5t8J+Lg6DrDaemENTWup1/SOWjOZy1WcTnfZjZ4tyjSbblEj7MCzX34VxkwHKa49TI5Ts5ycsbCCxcYkSZQUj0oghzaxL4S79G1lu2tphsxI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d59c19-1818-4815-5a62-08dc95095742
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 11:24:13.3514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+JgyGYOkvAwA9IG7uFA6oBJfuV70mszxDLDO6fC/ZmQDXh8jJ/ippDGaZ/FKBoqV2+zcq4zMdGRDxA76XB8MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_06,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406250084
X-Proofpoint-ORIG-GUID: WutfipeOZSNphLkB79rTsvi7beItdiwQ
X-Proofpoint-GUID: WutfipeOZSNphLkB79rTsvi7beItdiwQ

On 25/06/2024 12:05, Christoph Hellwig wrote:
> @@ -351,7 +351,7 @@ static int blk_validate_limits(struct queue_limits *lim)
>   
>   	if (lim->alignment_offset) {
>   		lim->alignment_offset &= (lim->physical_block_size - 1);
> -		lim->features &= ~BLK_FEAT_MISALIGNED;
> +		lim->features &= ~BLK_FLAG_MISALIGNED;

The comment for enum which BLK_FLAG_MISALIGNED is a member of reads 
"internal flags for queue_limits.flags", so it might help to comment why 
we clear in lim->features (if correct to do so).

>   	}

