Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7D1202C41;
	Fri, 10 Jan 2025 09:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736503020; cv=fail; b=C3BhyDlX5ldu8WbfFtFoBzDmDcVM7jo2/NvGRga7iZzwUIs6Yo8di0lpCtMWJXsg9HNecPC7xgCMU2tJHwbTTXMCpuHRLOLmunRLarPZZqk9W2E9dUdzGVnvujRB7JWmtJNWHqKh9EYLg42WJ8U6qeH7BZA38ZhQ25C5LoK2KO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736503020; c=relaxed/simple;
	bh=auWs5ySFpEG68LAaHtSqUPcJLs4lh3gwoOooc+xcJ78=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QBLaay1K3pIl9sJBky83Aaw9GdEmiRdC0nuxgOnyvaRXH+HSpcU46oPIx4jBhnnp/ayWB6fwui1RkmvgMnMCE7OUVSDmQk8p2MBBtxJjtFwHZoXojYDJPRPmmL9/t8B9UkUUPx72cynjkdqUyQIOODgil8N6TCYgEd0l6d2lq5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YSXXk9M/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TNaxo0Xg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YSXXk9M/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TNaxo0Xg"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50A9D0S2001608;
	Fri, 10 Jan 2025 09:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0KNvtTqA76kZtSvCL/D+x13gtk0YQ207n9lcbJyAL6E=; b=
	YSXXk9M/3deo7PTLgUKIMMpuANiJHup1kgDyLZyhHzdbrCO08GAhk/5gwAgEIW8o
	JoT3Yt4BgunqwlqxTX1QEy3DLG0LoDwmDyyYHYYL6vI6AHnJP/VoK6F6JLHT7d3H
	fiilxBP1nRpqI+5aZEKnKhzvU6+owaiolgRvnYotNr/mMpSDH3VIpTe5H9YkQmCw
	ZGSQrLcVkcLvvyLGkmzc0/EELkguMbRs3fkw8KIDBjF2FPFda6B3+pK9W278kf8Z
	T8h0CIausaO4bBAGNtGd03qMoCN4oDnXghfVG0e/J1CsOEzmF8cKpR5jiVdXoQhj
	m+fKY0zyXOUUiI636hjaOg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk0b07f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 09:56:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50A9f7TZ022713;
	Fri, 10 Jan 2025 09:56:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuec7t5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 09:56:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p2YdT9EFJsMo4w/TAhWhvzoEnexlflsFZMEM8ipUio+e6CxOOcmKcmv1UqtRkr+2G4DaCK3dAYZaST0YKYYvtj9acLM9GvNqsEpEJRY32aoOdXXniqVEd9fl28pmcXOOvEMjMasnvroRo7W9qmoK4GbWcESQvSKhwJIDcqZN2juXLIbrdgsxaYrZ5Axjpdu9eUNimBybwO0Mu5jgwakKnhFusrNi2bbVHr2dVVbvFGqNOuMHXO5eJqCksCM450C5U6Vt8GBxp7oLznqTtWwOvZSe+rxtgUg8EksluT61V339Mxiq51wvtNt3KK3sozmsUR9OXu/iKOMMYtMoFW6bjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KNvtTqA76kZtSvCL/D+x13gtk0YQ207n9lcbJyAL6E=;
 b=r4iHzYu/dlMDIFE9uNqW1xtebm9ZntdSJidbgw333Rho97kQArMFT2aZdhDU9HdoMNYV4oYhqbP0A8b6xC/67/LpFwTqALHBPyRifYYnMGqfqFnV77Rezf2VwhIlHU50+rjHbpV9e8U7G/c259ohyYEw4wN4GrgjjbqyCCmBHsSws7zioPu3tzDJGf4KNBkEnDkaGGgpp909W6rKARohAQWB7SuXBW50ZMdBE7s42m73gNMnymOOKsu/3lTYQuW33zYMTL87IXzwuUKvYcPhnnTJWyW/ONkc2bbM8agechmyWnkq+cVD0DmNNkISBCw00emD3SSbSReFtSidAErwRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KNvtTqA76kZtSvCL/D+x13gtk0YQ207n9lcbJyAL6E=;
 b=TNaxo0XgJ6/zyM5hFGkBmKtbuF4SyklZd0viM6s5Iuanksti8qO+hLkiE0BlPvzI4H3XZMiw6CJZUqXk0vTAgjk6KDXpemc1UY1WqaSGwckEjYSbyigb6ds79vme1QSK4+/LhhyqtIbHNmzhM3CE/J2jZDmuzK09w6BdhMwXC1k=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7504.namprd10.prod.outlook.com (2603:10b6:610:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Fri, 10 Jan
 2025 09:56:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 09:56:39 +0000
Message-ID: <79d85a4e-57c3-454e-a65b-d2a3764eaf0c@oracle.com>
Date: Fri, 10 Jan 2025 09:56:35 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] block: add a store_limit operations for sysfs
 entries
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, nbd@other.debian.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250110054726.1499538-1-hch@lst.de>
 <20250110054726.1499538-6-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250110054726.1499538-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0045.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: 93373516-c35c-4c7a-3d2b-08dd315d1421
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHlRaXBGL1g4cU9adnR1cUlPek5vbno0SC90TUtVeGxDRWVxQ0lPNEs5NGJO?=
 =?utf-8?B?ejhvcTA4MDVrT1AxVVJ1K2NkdE5xL3BWbERhOElON3Awak1XYVFZNG84ZU00?=
 =?utf-8?B?bGtxYUo0b0ZMWUtDdTJjTDNtTUFCRUNTWkgrZzJrdDJkRE5MZVczQkF5NDNq?=
 =?utf-8?B?WHFVK01YVU9DZDRUTWRudUpGbGpwa3FLRlRZcFI4VGJEWTZkcTRXLzVuTm43?=
 =?utf-8?B?Z3hHajdBMzNVMjBUY3NUV1UwU3J1Mk1sMzZxRG5DcGJncWZjT2x6K25Md3RC?=
 =?utf-8?B?WDVGWlkyZnZLYWpoRW1zMHVmRXhHUExvb3lTTkgzdjU1WXhSZFpxR2t1OTZU?=
 =?utf-8?B?aDBXNWk4WjJUdk1ZbWE3Zk9qcDk4aTM2dks1TzhtM0x2REdrVXhUWUF6bjVj?=
 =?utf-8?B?dzVPV1VoZTNSVGtIbTZXaWttam1zdzRTTEZ1L3BnbjVTeFNXbTE1S3Y4Nk9k?=
 =?utf-8?B?TVdKbTJndUhKRlg0VEhtREdmcXFjTE1OclZOTnkzRlE0YSt5UDU3b1pZcFpG?=
 =?utf-8?B?TGQyUG9MM3Q3TVBld0QwLzVPc3hCUXVyM2M3MnhkSEFTajlkYkV4NGFZNURh?=
 =?utf-8?B?WGZ1WStwNHo5LzlER3RmRmd6QTdtUjMzUVZDWmR3UnVJc3U1SzBSanlocW42?=
 =?utf-8?B?K1Jtei90a0ZjL0YwUDFmWmRjQlhOYWc4cm5wemtwbWhqRytxMzZGVUlUQXJT?=
 =?utf-8?B?cjJtenRheDU4Um95dXFoZzVXakc2NVc3Um9BQWJmY3luNm5PSGhhWHkrc0ts?=
 =?utf-8?B?bENHZTJiUHVXcjc0cnQ0RERUc0wvT01BeHhsTWFkbTRwWGhlbTc2Z2RKQyta?=
 =?utf-8?B?V2QyempjWHBGYlVxdWw3QTAvT0RFaDdQZVJ6dU8xTTFWQ2xBdkh4MWVNa3Fr?=
 =?utf-8?B?THlNSG0yMWJITEEzYkNTS0ZCcWoyMjZ3REJGc2xjTWZXM29WSklkVi9teFBF?=
 =?utf-8?B?T0M2QmdJUFp1cUorL1dnSDdLVGV5WHgzdUVxOXhkOVlCeVArSUIzL1hTc1Rp?=
 =?utf-8?B?QktUQm9sQTZSY0JCaDZwQkNtNUdBTzVLVE8yUkdTWlZHVjgxL1RPWnN3MUN6?=
 =?utf-8?B?Wk1WbGcyZGxIVUtCeGtOakZneG1hQmwvUFdYRHY1ZlVKd0RDOWNsUzdkczJr?=
 =?utf-8?B?UkE0MkJlZHJPZFlFUnU5YlVMYlduZVYxc2x6KzJYdGZhS3FBME9ydWNOeUdq?=
 =?utf-8?B?eXlwV1l0eXZmOTdsWGFqc0ZhdTJZdE55QUxwdFY3ZFZVVmVmZjA2VkVkeUdW?=
 =?utf-8?B?ZHhSb29BT24zWnJUUFQrL1RlcEtRZ3FhNEF5TlUzUWlqVGNJRW9hWEo5TWtW?=
 =?utf-8?B?NkpkKzVCWU9pUm1WN3RhZkZheDJDRDA5czRFSzIvcWc0VExMM3FRRzhZQUtK?=
 =?utf-8?B?RWhJSUZvVWo5NkJQaSswd0M2MmRmMGpLU3dpcExhZjZOVHlPSkl2OFM1MUFW?=
 =?utf-8?B?cEl1OVZuM0JyZ1BGZ3RHK2FaS2lBRElqM3ZXZGZrd1VHcldzUkM3WGJROElJ?=
 =?utf-8?B?U0dDaFVsWk9IZ2xONTBDY0w0ODRwUENYMlU5ZWhYTHJXczVXTlpuSkcrYmpo?=
 =?utf-8?B?UkJWZVpoREdoY1N0WlZaYWdTYmtEMkM2Rk52SmRBZjA5NmQ0dXFxSWtTMWJX?=
 =?utf-8?B?cWc1MVQzUFBod1E4L1BDcHRLUk5STEtmbVBFdFRjd3I4Vm5Nd1V3MWtZZjB1?=
 =?utf-8?B?QzEzaUd2UjlEVCtaWFF4WVYvNG5ZL0pRNG1hSDhEVkdMWmtRRVdCczluNmM2?=
 =?utf-8?B?Ni9FRTlWSHFET1djSjFoTFErWmJnYno0SERkR3B5SzF3WS8xamxkQlQ4TjBz?=
 =?utf-8?B?QWp5d1hraFBpd3ppWklRWDYwaERVOGdlL0hIcDZjNXVmZkVwU3NXc3ZUTWdu?=
 =?utf-8?Q?2m0bJxB4AFrLb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWVxMEY4bnhaMlg0aDBucGZHa05Gb1RLNTZqTkpOMzBxSktrY2hMYnQ4L25K?=
 =?utf-8?B?UUJIMUwvb1VWNEcvdi9tamw3YmwycVp4QW5MMmN1V2V3cWViVHFYS2dpMHZ6?=
 =?utf-8?B?LzUxclMvVUx1YzhZemtHR3EvbzcvSkdSUEpEbmFOd0hIRzA4L2VzSkxyWDZS?=
 =?utf-8?B?ejl1alhZcHBLQUtFWEFxSDYyMGUxdVpka2JFdmNMZ2xLWEpDK0lBc3drR3Jn?=
 =?utf-8?B?K3VPNTNNNzd1MEpoYmt0Q1hSRHF5SmNqandTSjQ4U20vTWlrRHgvbUNNQkNw?=
 =?utf-8?B?aHQ0K1pjLzF4TkdQSXhxQm5OMGFaZTd0SFN0c0Z6OW9OdWtzZlJrYmE5MmpB?=
 =?utf-8?B?amRLc3E4UE9EU3hBRENKcjArOG5HUDZKbncrQUR5bXVZM0M2Z0YySG15U3Ir?=
 =?utf-8?B?TitzUUFlaHRaanNJM2xsd2xVMU1CNmx5ekhER25zcTdrSTdKejh0RVZEbjJG?=
 =?utf-8?B?d0EzMHVxckxtcWV0aVFNZDZWOGdoRGlGS2gvbXAydXVhSmhLcGlqa2cvZDVD?=
 =?utf-8?B?K2lwTDJCOEJFeUF5NFdYaU9jdHRtQnB2bnoyNjBtdnY3QXF3a3c4ejZPQ1ZC?=
 =?utf-8?B?RVZjWGVKeC92bitsNTlhN2VzUTBxTWpEMmphczFiZ1czS3pxRG1kbVROQkhs?=
 =?utf-8?B?Q3FuamthYzZnL3d0UEZKVi93M1NjQXM1bWVLMW1YVkh0V0c4UnZvS1NPekFN?=
 =?utf-8?B?T1ZURDNYRGVlRnlSMkt4Mno5Zlc4YllLTEVtOWFkQzMrMW1LNnhzajZxL29K?=
 =?utf-8?B?NVFIa2xKaEJxT012SlA5ZjBYZ2prTWozNzBqRW5odER2RlBKS3VpT3MzMDUr?=
 =?utf-8?B?NTNtWTU5cmN2SWIyNEluRW5kZE1PRHlMWjVza0xGbHQrMUY5djZEME1uakNV?=
 =?utf-8?B?MW1hWURvWW9ZOTFNdWJHd0Z6dEYwT0o4Z3lqQlRVUlIwOC90ajlOTE1QTFZq?=
 =?utf-8?B?OWY0SjBTVmU1blZpdktyaUhZV3M1aGY4L2Z1bTg1bCtwbTVKcTh0NERCU2RE?=
 =?utf-8?B?dzI5QTYwM0w4Wm04bzB0M3lqZjJndTlmQ1BwQ255amtRcVUrTzNHSHlvcU1i?=
 =?utf-8?B?V0daUjluNjBEOXR5N1kwZ1h2TGZINU0xTmJRaXlIbU10WEoxL0dwM001WE1T?=
 =?utf-8?B?U0MwaGk2K2x6VldtbXp6U25XL1FwcUI4R2ZaUXZucVdHU0paRnNPRkViQ2lh?=
 =?utf-8?B?QzBGTVgvVktLaWl1U1ZycUVlOU5rTlNYUGdQbUc3Z2tDaEtpMXhldEk1dm5Q?=
 =?utf-8?B?QzNnV2xsS1VVTVVjbWdYSzdsZjZtYThNYlYwRGZJNnJXYk8zVVpoTGlCbmo5?=
 =?utf-8?B?enBhZDEzaGF6bHJ3dTBkVFlIc0o1VG5TQ2VyU3VVZDZNeTBUenRhNTd5K1Zr?=
 =?utf-8?B?dnFYTDF0Y3NGN24wRzhZQXVycHhpK0dNYlFFa293aURibVRSUjEwRGF4Ym1m?=
 =?utf-8?B?T3BvdUY2aVN6WUp2bzVMeWNXR25XcVBYQjZFOTFleUhsaWgrQWRmMEc1TzNj?=
 =?utf-8?B?ZGsvWWEzTG9lZElXMElmU2J4MFJ4d1MzMVIyTDNTYnF5akE3SWxMOUs2Zmlm?=
 =?utf-8?B?dTBIc3FGMDRPc2tUdlJZNmFZbmZwdW0rbmtCTW1jdzNWSDVyclE4azliOGN1?=
 =?utf-8?B?RUZGZWNqeDdjb2pFQy9aenNFdlcyZW82ZWtReVdXbTI5NGttUUZEeVU5Vm9r?=
 =?utf-8?B?ZVNsTGVmRUNuNXBTMUtEaUJFWnlPUGpySzBTd1BMekVwNUdpWFNLZGhIaGdE?=
 =?utf-8?B?VWtMZ3NQaERKc2d2NXYrYnVCSTdoV01Fb3BJVFhuTDVjWjZiUmNFZkVNQVVr?=
 =?utf-8?B?b3VXRy83ZkRYVzl5NlBBcktldjNLTmgzODhIbm4wanFnVVFEV3NNbEZETGhB?=
 =?utf-8?B?OXQwTXc5dXZLSmZxWWVjNkN6WGFmaW1pMFNqZllkNXpDaklIMWFJY1BpWFJj?=
 =?utf-8?B?YjJxRk9yOHJ3S1pLMFZkVXp6YXZsV1pTV3hOd25EOUpuN2VYNzA5R3ZtbEtN?=
 =?utf-8?B?Mk5scmpqbC9aTktsNmF2N0ZtcUd2M043VnBSL0VPUU1zKzkyTVJNaS9iQWpR?=
 =?utf-8?B?N2dPVEFPTGJCT1ZRZXVIL1VxT2o4cUFDV0pIUlNmb1h1WW1URm9qWW9NZ0VC?=
 =?utf-8?B?SDJkSkJQU0N6NTJueGdMK3ZDV044c0Q5UWRtWVZPWGxBNERWTWFVRUM3KzNX?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vNjwQw+FkU5azMSgVUAI6yh8NugtcP7VIfGrdfmSZkKrKyGgvwPsbqxvDi1hXa40/wetuzFMCBCV5H3dSyqTUbL/1Sw+JwvkriMvKU66Tj5DYn9ALo2VboY3vcJce9GTIp5eGTc76AQigiJQUHulssdWHf047V6QY8tAUslBXNXCvYcmM5URs87+JSI/XplkJmnxkj6IvmMX57drdycTG1/6KU5KaVdynOs37ujj5mkks2lhdrjVrm+Ws9ejBM/CT/kauIwcCivtVneiMqjKj3SzLvlvt3OdQLJUdGfs1MFhwKPm+PBxZjZJWri7vjPJZL4QsbWbULSJiYc+TWYKfD0c1hl8ZeCdYy8c6qSS5b9BfjrcoT1u1Ihb+9BYoQKL/r1NGCw8OTE9+LbU00m3AVXzgfQdGkq/QQHK7v8aVtiPk4/JWfqamLWh8wcAjlX5XFpe7p4bdjmYpevIBV2el6abZQ1uQrwyO3dtwtKJlq05cIxW7hfc7FTy0N4E6/UyFWZZKV3oNcyUSF1fWsoGw6VHmStOgz/ccJi/+spOkqx620GmeYfQWLOpvcvTz8uyW0rJweSalnYUCDvJYRa4pUAYne90bqAEINILIxDM+mQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93373516-c35c-4c7a-3d2b-08dd315d1421
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 09:56:39.7975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0ofDofralQ4peasrsGZ1cJpwvovrMDCRplfY0ue1zmVr6zg61EHwlIZfX7m/KufvTx/WHiso90XukNK9dgV+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7504
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_04,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100081
X-Proofpoint-ORIG-GUID: 0VDAE1BFNOZ3sN4BFFXX8Mg-p8rmuSy2
X-Proofpoint-GUID: 0VDAE1BFNOZ3sN4BFFXX8Mg-p8rmuSy2

On 10/01/2025 05:47, Christoph Hellwig wrote:
> -static ssize_t queue_iostats_passthrough_store(struct gendisk *disk,
> -					       const char *page, size_t count)
> +static int queue_iostats_passthrough_store(struct gendisk *disk,
> +		const char *page, size_t count, struct queue_limits *lim)
>   {
> -	struct queue_limits lim;
>   	unsigned long ios;
>   	ssize_t ret;
>   
> @@ -284,18 +269,13 @@ static ssize_t queue_iostats_passthrough_store(struct gendisk *disk,
>   	if (ret < 0)
>   		return ret;
>   
> -	lim = queue_limits_start_update(disk->queue);
>   	if (ios)
> -		lim.flags |= BLK_FLAG_IOSTATS_PASSTHROUGH;
> +		lim->flags |= BLK_FLAG_IOSTATS_PASSTHROUGH;
>   	else
> -		lim.flags &= ~BLK_FLAG_IOSTATS_PASSTHROUGH;
> -
> -	ret = queue_limits_commit_update(disk->queue, &lim);
> -	if (ret)
> -		return ret;
> -
> -	return count;
> +		lim->flags &= ~BLK_FLAG_IOSTATS_PASSTHROUGH;
> +	return 0;
>   }

BTW, this function seems to duplicate queue_feature_store(), no?

I mean, why not:

static int queue_iostats_passthrough_store(struct gendisk *disk,
const char *page, size_t count, struct queue_limits *lim)
{
	return queue_feature_store(disk, page, count, lim,
		BLK_FLAG_IOSTATS_PASSTHROUGH);
}

I think that there is even a macro for this.
