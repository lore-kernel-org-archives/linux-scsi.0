Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7742D1509BD;
	Tue,  4 Feb 2025 18:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695528; cv=fail; b=PooSN2yizXKz2a8WYF3O+ycFZ6tvnHrCtFEso7C2y5EnhTX29GAFcZts6ZMT660MGIvVN2IDBEUFopW0LCvl6Ap06Oq7I6RpAcC/6lNlfS2BZDdUOCKy8oIhGBek2F3AZ7gM9YtVnD0IFtOhKtsHrd2/uyKliJZ3rdk4cmbWGjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695528; c=relaxed/simple;
	bh=gBW2o5MYQGxCkZdmgZ5IeAOTfci5SgCtdAnyzztE3Ms=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lGu5Jw7HlO0Eo67yf1KPueRyIiGpApWplCcrbc5Mywm1lKzupe/48nnMEKPFIUmHYe5QKm9noiBU2MDbbPD61hAfDS2io6X3K5mNs67GqYvF40dpo2WJ8HMUmIg+Alkwoz3iA/Dtz4g0MULSbXuq9U0bp80kZHTfJxuI385g7vs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gUgFpQ4X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WlFe8duy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gUgFpQ4X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WlFe8duy"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514HBs6V019503;
	Tue, 4 Feb 2025 18:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ADxYxM8IIQmeC70fxJbTnnCS07D2//4KMXuBaeJLpiM=; b=
	gUgFpQ4XiXFGMBRdG+9pTsnUq4bSqh4NwStKYb/w7eAVlhYV2EyHXTPXwqitr1qI
	GqdSTrv+Fh7DGcHRgkJU3xwRSk7HrnV24AcGxPEMFKg+ObtJNlXtYzCO+V9v80OA
	O3cmUy+gv4wrHjHjoQkBT8YlatxVt81aDTkxkORyOgytpzCt4pAoQH89gwZtsmul
	ARqkdUefutbXRIVhzMcdS8MZpMeLvF7hzpmMj47evlPlvYjxGIGvsrRFEJs/08fO
	zyEGRH9l2l4nC1isjDPn8QSZk5J7+wxH6N/IM9UP5yIwY/vTFYwiGaItpCLrkbe2
	5SgYgsjiOBFTglF9Y3rm6A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhsv5mk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 18:58:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 514IKUpr029079;
	Tue, 4 Feb 2025 18:58:34 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8p3djdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 18:58:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G7HAOT7TwtT5ZFAVK9/4IklR5XQ/tXBdtsapis5FS8AyffYIiSi2XQ8zfdiCK650YwZe6TIL4WwQF9LLrh5uDZBKWTE17D8lHS4nf9yj1KWhmQjs9pDw0RIQX8wCLergy14O0CPgyddwXMJ1FYBsEF4KBkmAuKJf226XnbB8zJjOR13EcNyoE87D/ay4GjhnpXoDOO94w4J0JxLKq13CrztfBHYkkX8Dn/n5/K+B6pScV15C5uyo9a7FERM77J5jmh8FPiucASDxDAiz/a9aXRt+XLSf1i9aFwwtuZNozSaBVThIV3uL6CLEhNYRPBZ71jwU5+oLznyZtn8D4+3XQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADxYxM8IIQmeC70fxJbTnnCS07D2//4KMXuBaeJLpiM=;
 b=wQFhBURngkj2+ip1g8dR8fmYCMwDKKP01sMpctwGg8JyGNBrrpBT87tRHX4FCzWCiPyToo7Gp2A1R4qyOy6miTR42U0NlYhkZ6UhdW4YBGwIj8LgMx7jgK31UP8EI9KRJ8NF2nq5ZEuiGpWBA1+5dB+QNIiWVVPdgx+n73RNnrNru2kqpaO92vNkAVq0Dk/ac3bu70j+Z5tzJKpQZUeo0ygBqkWMGPyBjiA7EvGChY+hEgOhwnu9jUubJGH+g1s7OnY9fZYYuRIjdLdBNR64S/pNyyTKV0oiCN4R0zRTwiLeXYVCRXcWhNQ25ZjxW2Ka93MBJvq4+LQnsEwiLut4GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADxYxM8IIQmeC70fxJbTnnCS07D2//4KMXuBaeJLpiM=;
 b=WlFe8duyeffNfxuOwNiWLoU1CGaLRy0JejZ9w7C7k+9yH9MSAQMxfv2hfPCLVLvKmSl/odmGhgVR8qicX6/AZPIgiGPIFzd/2MMyIIw5LhQ8lkpUw4an+hMSb36rEaG8yHjHUeUz94+xOB7ETw65PXHYWOwFFVctl9kZr9jDiU0=
Received: from SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5)
 by DS0PR10MB7090.namprd10.prod.outlook.com (2603:10b6:8:141::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Tue, 4 Feb
 2025 18:58:02 +0000
Received: from SJ0PR10MB5550.namprd10.prod.outlook.com
 ([fe80::10a5:f5f4:a06d:ecdf]) by SJ0PR10MB5550.namprd10.prod.outlook.com
 ([fe80::10a5:f5f4:a06d:ecdf%4]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:58:00 +0000
Message-ID: <fd76be2c-1e27-4ecd-b67e-fa57cf52e9ab@oracle.com>
Date: Tue, 4 Feb 2025 10:57:56 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 blktests 2/2] nvme/059: add atomic write tests
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
References: <20250128235034.307987-1-alan.adamson@oracle.com>
 <20250128235034.307987-3-alan.adamson@oracle.com>
 <vhdb3rsa4vgxm6nm7js75cnlxpv7d4rjxdvqpa5b63u442m3sd@b7w5w6mzjj35>
Content-Language: en-US
From: alan.adamson@oracle.com
In-Reply-To: <vhdb3rsa4vgxm6nm7js75cnlxpv7d4rjxdvqpa5b63u442m3sd@b7w5w6mzjj35>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LV3P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::6) To SJ0PR10MB5550.namprd10.prod.outlook.com
 (2603:10b6:a03:3d3::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5550:EE_|DS0PR10MB7090:EE_
X-MS-Office365-Filtering-Correlation-Id: de4ed27d-8c20-448e-c398-08dd454dd89c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SSt4b3hwNXRFRjYvNFY4VUIvV2Q3aXF4NEhtbVkxd2dEYlBwVkszQmNJbzhi?=
 =?utf-8?B?bWFYdngwWTlVMXdYd3V4bmhORkRleENVeVJPUTZ1NDRlNzlubUJSTXBjbUc3?=
 =?utf-8?B?dXRQSFlSK3Q3YjlIOXVwMjRNeThhMSt3cVdncDRnNWN4MWxWblBRM0RSekVM?=
 =?utf-8?B?TUJQYjdkT2JicG5uRGtmNGoxYWY2VEY5TmsvRWxuVlA3a05BWHpROG05K2tM?=
 =?utf-8?B?M2NVVytGR3hzQWRaa081cGMwMDg5dTJZWXlLOFB0OGFkNmhlM3JyN0JLZEVx?=
 =?utf-8?B?Y1RjcWNxT2krc1ZGNFVmUjIyc2Z5RXQ4di9JMktNS0V1Qkx1a0pHZG9SRStB?=
 =?utf-8?B?QnJnM2x0Vkt1VmpwT01DdFNhK0xHRmxtZUVEdjdid2JMWVR4clRJenNiYVdT?=
 =?utf-8?B?cmNOckJuOXI0c2hUa2RON1Z4c3cyYWx0VjV5VVFMT2tTdmNFRlR2NkVOWjV5?=
 =?utf-8?B?ckQ3VXZnMHFXczBicm1aKzhWUWhqTjFLaytqcFc3bkFQcGxMZVl1ZElPSVp4?=
 =?utf-8?B?UmlMV0F3Z3R0ejJaTEdVaHIxc2g4c1IzUXltUXBhdkNCUnlQcWlWRXI1WVU0?=
 =?utf-8?B?eFVKWGo1b1FQUU5pNDg1VHlra01rTHZibytHa3FLU25QckdLTmhMMFRQUGor?=
 =?utf-8?B?MGYxMDJkdHJ0NGJhNUgra09PRjBNT0ZFUEdTeDY2VUV2WkZmUWMzWUNBWGpF?=
 =?utf-8?B?MWthNDJMT1ZoVUc5QVB4Z2VNYmt2aCtGRENtc2RGd3JNaU1SWHBqdEdmdzdN?=
 =?utf-8?B?bWlJZ3h4NmNNOE41U0xQVFA1K1IyaWs3MHRzcThwL0gvWUhlbXF6c2xUeEpk?=
 =?utf-8?B?SW5XQm0zWlVKb00wNFdJNTV6VHZnRUIwWDRWdWtoSzltKzdxVWZTeHo1UGJR?=
 =?utf-8?B?R21vaUp1S3V6RHhQenhtN2xoWXQ2Zm9CSmZyZ05sMDN0YWhYM3dlL1JPaGVv?=
 =?utf-8?B?cHhqYUtpYjUyWUdsYkUyWHJzdi9OeFB0OUdBUGhtcXQ5bnMvaFBZekd5S3JS?=
 =?utf-8?B?bTZPMmFTbHdhV1JXbW5tckpleDJROHhOVHA3SEtkamZXRUtMdkd2UWorZ3VD?=
 =?utf-8?B?NTJYNjFCQzY1bGFFOFB4MDVpOUNiMnFLcmFWY09ZL0tDN3ZaRnFqYVhjcy9R?=
 =?utf-8?B?azBHb3VJZEE0WWMzWmtjaUdLaVllUklzUXpFQUNNOEZpUkdpWXVsQ2MvQk5X?=
 =?utf-8?B?bWNRMjJ0M0N4ZFNTU1RwdWpXeEl4aFgvMm9RM3hKSzJCUzl4R09tQzNTYzRt?=
 =?utf-8?B?dm51SHUwRWM0cDhyRTFTT2prR29yR1RYeFpRejFiaFE1QjZGTGFrUkgvQjZy?=
 =?utf-8?B?ditPdlhKNHZXbDZFa1VETUlyeUlGNzUvVFdTd2R2amgvNGtpeW5TVnJybFph?=
 =?utf-8?B?UlJpMUc5a3hEc2FJQ1J5THRETEhFcUM1cWRDL0hWbWIrUXhCM3hzRks1YjhB?=
 =?utf-8?B?WFdhYXc2RDgvT3owM1N2RU45ZVRUVG5pUm1HZ0xlVUdwZ3QyYWhtSXpVc3F4?=
 =?utf-8?B?a01iaEx2V090WDFUdEJSVjhHaFlITGdJL2E0SlI1V2h0ZjhqU3IwTzgyTzNi?=
 =?utf-8?B?cDM4alE4b1JGYU1NbUZBeFV4cDJYUjZpbmlHNmpzOGxTRUxHWDMzK1BUSWhW?=
 =?utf-8?B?aFVqMXJkdUlyaXlCRUYza25RRXFudVJQSi8zVXRlZVU4bkhDM1MzVzBCYUw4?=
 =?utf-8?B?Yjl0d1pQeFNDUit4SG9telplVEF0MjEwRUtkNC9aQ1JINUdDYmhLMm51cjlX?=
 =?utf-8?B?OGtDVUNacFB4WXdjc1RpOXZnOFhhYldONk9JK0xOTHkxOENQdXpQSGJpTkx2?=
 =?utf-8?B?czVHOFlld1ZkLy9rdGxCZHd3RzUxNDVYa3ZyblgzZzVKWkY1NmRsWjVvaHF2?=
 =?utf-8?Q?19XEaAHhgcyJA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5550.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3lwcXVyTkN5WWV4ZkV3M3crU3BvRFFVbTlGUzZReUttUW1uRmh4ZEpvUVpZ?=
 =?utf-8?B?WENPdzNLSlZnNEg5WEk1RnNTQ1VLaXgyVmFqRll1RWlHazErblpCWFQ4VE9x?=
 =?utf-8?B?ZEh5ZHZpd0ozeStEMmtYb1V2VFlUU1FOZm94dWZKSzBzb1BqVFNUeGJFSWtZ?=
 =?utf-8?B?cUpaOVhpYjlrdkIxcUt1QUc1MFRUUGlZdWZlUlAzemVZWDBjV2tVQUxuYmZo?=
 =?utf-8?B?TjRaR01rUXV0UTdMSm5lR1Uvak1FWWpUd3lKQTA3ZEpueXhGQTIySEg2N3Fo?=
 =?utf-8?B?VkVJc2IyZ2NHemg4S05YNjE4Tm83Yms2bFZvNmlUOHRNY1pxWlZWSFZDdWsx?=
 =?utf-8?B?aThjYkpVcWFUQ1BrSTNoOHg3MlVKWHc4RytIdW5jSEd0WmhpOXRSUHpOUTNi?=
 =?utf-8?B?dDlRbmx4UlUxYmdHc1N2SHhvV2pXTTBGMlVIV1VOOFpsTWpDUStPbEVTZDRP?=
 =?utf-8?B?ZDBJdE1PTnpSd1ZPVnBXOGRIK2lRenl1blJUWWRIeVZTMmlwaFpNZHRPMHZ6?=
 =?utf-8?B?VkgvUDdLNWd2clExSWpmdUIvdjlQN2Mrd0MxdnlVY0NLSW1EVzNDSEJqWFUr?=
 =?utf-8?B?YXpJT1AyTWlaS2k2N3cyTWVWMXVxZEphaWRHR3pUS25QRHE0VEdXSEhiQ2NN?=
 =?utf-8?B?ellWT2UvTC9STXNNdTJNeDNvTnJnWXE4UTV4V2d3VHhpQzVzVnF4ZmxYVm1q?=
 =?utf-8?B?VHRGT0lPVElnNjZDejZmOGJ5NHZQS0FRUWE5OXB6NlUzWmJHYXhYNGw0MnhG?=
 =?utf-8?B?VUczeldvb09sQjhMcVJnWGlNSFM2OEpVdGt0WHB2Z2RQTWdsU1h2aVR0V05I?=
 =?utf-8?B?aS9hRUI2YzJBRGppalV0cWVwaW96RGtBZUtra2VnbDVYdXkvUUpVM25oZnBE?=
 =?utf-8?B?dVVRSS94bjBucCsxeDh6R2FzbW0xbEtqU252WEhUdDhGTWJQSUs4T21IM1hk?=
 =?utf-8?B?M2JnTFhibzlHeFlGU25IUEtrYnlvL0VweEMwcGFoaHRyVGFlZk1wVEpia0Fh?=
 =?utf-8?B?VS9XdllGMm9HelVvaTNDVlJNeDA0WGFwaTFIK0lhbmc3NWI3MjJYd0Z3MEZy?=
 =?utf-8?B?Q1p1NTJxQ2d1ZzlCb2t6R0VMUldyQVZibms0SHZOMDBRMEdiNlFtZGVNL0dv?=
 =?utf-8?B?cFFBRXZPMXVDTmFOYzNnOVpDZ2NmQkI2Rkw2MktWamRucTZId01ZYllFSzFN?=
 =?utf-8?B?M2I2T2FGUS9FUnBub0pzVERoc3pBSHZHN0lieS9DSU93K3cyc0J3enRUSTdM?=
 =?utf-8?B?WFNhYkU4SHc3N2dmSE9XR3I5bTk2UkREUGQyQlI3WmlVZTNJeUs5Q0wzUkFh?=
 =?utf-8?B?OHlTNkJuOFZwTGh3Y3Q5SlduQnRVUThiRVpFQWJGc25SNTRoVXRUYWdrczhC?=
 =?utf-8?B?NHJ6ZG1ZTDVrc0xiSnpaa0pLRjhxYVdLWlBlSUdnQ0FpcDFRUDNMS2xUZFBj?=
 =?utf-8?B?cm4vRnZlOXNmNjRCVW1QTnlMeFViT1N4N2xGZXNBanQvY2Y0NU1rbzlLQXJV?=
 =?utf-8?B?akpmRVU5VkJZd3I0eEc0WHVoTE5NaGRTM0o3eGdjN1ZWdjdQL2F2N2IzSjFX?=
 =?utf-8?B?VE9LbkZvSXg4RWs1NEJ1anVuU0RMK09Wb3JHY2xPQWRmcW0vR2d3WGJrbStY?=
 =?utf-8?B?WFcwMkcwOFZmY25pcFg0cUZ6R2VGbUNEOE53U21CSDhCdGhiczRuYkhGLy8x?=
 =?utf-8?B?R2NLNmIwRzU3RHdpRm1VT1cyWG5ud3o2eXRJcUwzNW40c2NvRE5XSm91Vmt6?=
 =?utf-8?B?RzNqakIzNEpEUFRsQjRTbjhmb2o5eEV0TjA2S1NQcWdZUzBDNlEzWlgrUVQ3?=
 =?utf-8?B?dVdheXRFVENocmRVL2lQTjVSdVNIUnJVYWJGZUNJUnVEM2d5c1dWTXU0WG92?=
 =?utf-8?B?eUVteWt1NnFSc3RwbzRRc1dmYVJWUlQxeXg2SHhwR3Bqbis3MkdjQjU3Z3pW?=
 =?utf-8?B?bXd0V2hKSm5pWDlJWFhxNExONjJvckZrMzFZTmx1blp5ckRBd1lDUWx4cXov?=
 =?utf-8?B?U2ZZRHZpQ1lscG5LaW8rck1IUU1CZkNSTGY3QlFQTGh6ZWpRR1NlYjl5eDQ4?=
 =?utf-8?B?TlhsYTBoTjdwNjM2L1VRYW5hVktOREJKdzNtWkI5d250MTZKdVdFQmtXazkx?=
 =?utf-8?Q?7WOFnidZt7/fr3AaUQI4ilvMR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CZKRMbe0lD+t4eyHqQgGYy5PNfRu4lshjYRF3Iq6FyBoiw867jHG9zPTU9ojFgfAjHYi2LG8SxErh34nx8TKUHypsSJdIBlhAdgpJLHcR4d60OSBwvwG1lm0R18pHI5Han7g+M8IY0dxGypL/Swi+Vl8Te96InmdnOUcBS1FGCjq3IOWjZXHBaJI3sYDPDxd8F6N3eoL2gnBb3l084cx0CGSwy901bN6PB5OBDZ3SDaklO03OhmwkMav67NGeAeaTNaXaQfdianDS8npLtAvCEqr0mrRy/nYWk4onVh9zeEduJtGJPcIo2o+FlIVPklpKWdTIn7mnoBI3P7l6TdBBc73dAYwkZRH5ft5tpQYSCMQxsW6JrGeIE2zH2WwaatpRKIBEwym8QIbUdCSKTkAyv3rja8saUpcM2ke4XMIy5s40kzdhbTh7UoES0wdqoxP6b6ELezzAdNidUf80Wkt7OLb5cevERtOsGyFMtwmlSpYawWl9aBaRukQiZDW1K5VEaMLR+987ROM85ASmO7vUBrr42e8/T8g9aUUHoYPKqKmpBBc25P2dSv8/WiNuDcleTBrzSHAI88Q2d+FFmQAL9OSLx+2GIopWkmWVWVxGbQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de4ed27d-8c20-448e-c398-08dd454dd89c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5550.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:58:00.8043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qsHQG+c2ItuHFCf7uNvVEeYajLmpAQs0xZze6sR+6kbvuKGDU3ezfHYNJ9RE1h/3l7gX9yXXZyQfDJMGFLUvMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7090
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_09,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502040143
X-Proofpoint-GUID: h_MZcrAFFjqX08Dq6yKrX-oz_HEfpFa8
X-Proofpoint-ORIG-GUID: h_MZcrAFFjqX08Dq6yKrX-oz_HEfpFa8


On 1/31/25 4:50 AM, Shinichiro Kawasaki wrote:
> On Jan 28, 2025 / 15:50, Alan Adamson wrote:
>> Tests basic atomic write functionality using NVMe devices
>> that support the AWUN and AWUPF Controller Atomic Parameters
>> and NAWUN and NAWUPF Namespace Atomic Parameters.
>>
>> Testing areas include:
>>
>> - Verify sysfs atomic write attributes are consistent with
>>    atomic write capablities advertised by the NVMe HW.
>>
>> - Verify the atomic write paramters of statx are correct using
>>    xfs_io.
>>
>> - Perform a pwritev2() (with and without RWF_ATOMIC flag) using
>>    xfs_io:
>>      - maximum byte size (atomic_write_unit_max_bytes)
>>      - a write larger than atomic_write_unit_max_bytes
> These test contests are smallre than those in scsi/009. Is it intentional?
> No "minimum byte size" test, and no "a write smaller than
> atomic_write_unit_min_bytes" test.

SCSI supports atomic writes a bit differently than NVMe.  SCSI has an 
atomic granularity which translates to a minimum write size when doing 
an atomic write.  NVMe doesn't have this concept and always guarantees 
writes of 1 block will be atomic so the additional tests aren't need for 
NVMe.

Alan

