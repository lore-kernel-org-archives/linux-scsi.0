Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C43038DD8;
	Mon,  5 May 2025 10:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746440099; cv=fail; b=F5azQ0mqBywO89hwL/e54xJahkHMuhqPi3dAsMgpEKm/49+ppwpc6BySMt54F+1+8qrbwJYtt132u84lkr+LLDdwVa3yk2e+7fs/4JOA/rm+wi9LE1uoLU8jm0OGH4IlcRvlYN52rPy9JC2Ajufa+hQFkjIxKCu6OtUewQPVWaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746440099; c=relaxed/simple;
	bh=Om7lizt1z/Jz9vsgUsaQnjfQxyHVG9CgXSiyx5vrZpI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JqIT4qt0W6BgCyt1ibys9xRLgU+/vSb6d2mEv8sAKHECLtfden2L22P8HrN+P0UshzIDaDdZCiXpOgCfXbEQsIz4R3+MjhY0Y+nvEbWlDNw+O2OfD7t3y1u8kOcoXeUymTL9iKdWoBtYSaBiZLLvWNoCh3kv8idIgVxFZ1r58ZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j0ZnefEO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QRGPhO6G; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j0ZnefEO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QRGPhO6G"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5459bfW6006124;
	Mon, 5 May 2025 10:14:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CXfhDhfuVskl1jXxafVwUR20PyBSB+hjahn60GMQ/g4=; b=
	j0ZnefEOnn2+UdEPVh+/RgNptJjnLWf91n4S8k1+m5/uTvlrW1gmkqDAcGkoe8Bd
	WVxF4MZMUd6KT7G7zUpnRnALTmHa4jh7lJ4f15QivT3GlZy+47TpY40iAbOT0gZ1
	iKxsdRYdDv+7T1hS0xl38vzuH+LHEAsaHfykWnRo2Un26biTLrqcRMR+a7xpCsKW
	AO9uadr9GB8o34Q4BYgycsd9Z0WHrf8FGfsmG7ztNb67eAxHSQSfku8x7ZGQ9LBh
	AfImE7O31SkfAHM/E71H86PWbeIq4lpjhLt3x3Bq6wDatLfU2y6SfE4iFuoi7Ny8
	qKe9vG/gBsx0j0f4g1g5dQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46etuwg1xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 10:14:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5458fbqY035415;
	Mon, 5 May 2025 10:14:38 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011029.outbound.protection.outlook.com [40.93.14.29])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k7gxwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 10:14:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ydEhWcVcNQzPDApUSK0sadBRVxiomgVe3NUG6gkl/4iaG4sNqteTLIDp66LThPzkgTtDCfTgo8xq+l85AXhSXGGmrVFsz357BomUKaJMcR9A4Egi+ZKAmMpUASMs6/yTpgiiiygdIqAoln2a8+7rcsKXrr3p1v3UYMNdo9MzVXvRX/b04xoIp2qKVsjWM18GvOkfY4eiNFfay+VZGwFQDd7zb3mBWyIKrNjwTs8fIzG9TtKBO4A7uJHRdyuFPElKdgU//ScJYXAOimoTNq7aYs4Qsn4gwhokt2CeeksaGJYt1zSaxTcCLRMnE6MGLlDu53hxXK9z1NKn/+Udz0+aiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXfhDhfuVskl1jXxafVwUR20PyBSB+hjahn60GMQ/g4=;
 b=jQEXoMVuOppXdpJeBv04wy9JpkmLltJqCmP4v6YmEJETHLm+xWKTwT3T1jqpc6HpjrlVk02bO36Hv6YfNRqPcY7S9e7N9JptZS4d9tdkRoE62Huhagv5KQbsCrCNp0PnBRx9O1uw2ebQTlMGBrk5N/fSFFl15NMRlY4/xBCEx+8NmnXaF5N3rm3zwmLnZxsUJ3ynx7FptYPOk9QKvDaJicULrUtPZQRa2WDQ3p6yc9g+8ptBJQSyhqbqwbNWeIjXADnfL4LgsExICFZ5+xwniAH5nCzqyi1G0PS/BWSWetKIzJMNUZ0yQ2KwLsAyuXfia1kjpWImMotzrn2RvHGcFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXfhDhfuVskl1jXxafVwUR20PyBSB+hjahn60GMQ/g4=;
 b=QRGPhO6G8twVjoYg/kAcqJroZm7vHlMsdui8iYTp6uNTh2nMRZvi6sRzCN/P1r4HCWoQxNGMYUiaGLo1ATHaqLWNlTQWRWIWok/bZFx3ajC8LMrtZ4xVqBPSly1hIeqdHQkAFYVEBAfSZmD+pphB1mXcuHOawDDh61Db+Yrm/bQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Mon, 5 May
 2025 10:14:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Mon, 5 May 2025
 10:14:36 +0000
Message-ID: <2e71e6aa-7889-4259-884a-9a03a6df9eb3@oracle.com>
Date: Mon, 5 May 2025 11:14:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] scsi: remove the no_highmem flag in the host
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org,
        Hannes Reinecke <hare@suse.de>
References: <20250505081138.3435992-1-hch@lst.de>
 <20250505081138.3435992-6-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250505081138.3435992-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0016.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 429733e7-903c-45eb-aaad-08dd8bbda318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXUzc2tZd1Z0UXFHZlhGa3RHTUpuekFVSTZYNHp6a0RRODBsTEJpTVdOZzFl?=
 =?utf-8?B?clBOaGhTM1ZiakdOVDl5U1ZFUi9NcGs2WGV3NTFrVzFMbVVhRW8wU0hJQWNT?=
 =?utf-8?B?S3AwL1lKSjBiLzYrbUlJZ0loK3BSSzJNa2lTNE03NUZjUUNLTmwzazFMcXdu?=
 =?utf-8?B?WkhtNDlweTc0VGMwOTZ4Qm1hbHlObWdrNWsyOE1ySUlORGY1T0JRRCtSRDZN?=
 =?utf-8?B?TnRCcUpUaVF0Qm44Y1lxMTBFaW1jelVHR0syRllVWHE1bUd6ZTMxcmRpYzdk?=
 =?utf-8?B?dDJkQXJJVHBjQ3hsaDg0cXNmOVpYVll2K0dlQWpVcHpEbXZEWjJkeExKY2xM?=
 =?utf-8?B?SEdsbG5KOW8vMHB6QkZsVThYVTlNOG9BbElic0llUTlqOE50OTNhSjBFbU5m?=
 =?utf-8?B?dHNzQ2FZN1lOaG4rU2kvajFjbmg2dnZKdkV5enBGYmZ0ZE56RHd6NFRjSW5i?=
 =?utf-8?B?b043TmIyWVZudmE4eEI3L1lMaG1YM3Y5WUw1ZU5vaGQzR2VSZ05xVEYxaFRN?=
 =?utf-8?B?N1c0Zm1CSzI1TlFuY3lzQzBlSmI4QWdzd0p4RVRlUVA0L0ZVZWlLVnc0NUZx?=
 =?utf-8?B?ZGpkb1FhUGNnOE9xMUtXalJYUTZhZWhaNk9hMGJvSkdOaFNXNTBoU3I1QnNj?=
 =?utf-8?B?VDdSTlpzSUczZUlGTHQ0c0dacW0vT1FBbWxnODJMN0ZYVlR5L1lUOEptZGx3?=
 =?utf-8?B?aVJNNk5PN2JBTTRpVVZJQjR4VTMzaDBQWEh0L0pxWnJzT1pMMHFBK3VTVG12?=
 =?utf-8?B?akgwRUpvMEJtZEJ0MW0yZGxJaHF4OEFaZGI5S2FmbkZiS09aZTEvYWJDWnlJ?=
 =?utf-8?B?VUYxNU5jcHROR3ZtVlRuemxFZlNKWDZzNlJPRjNxUmlnQW5ETUtlZnUzR09T?=
 =?utf-8?B?WURQY0RoWnU5YVNFdnRRYjUwZmdLRVhPRjduMEpPcnFjSXVvVC9wNE1DSmdw?=
 =?utf-8?B?cVpSazJnYksyYW0yVW51WE5wN0V1RWkzMXpUbzU4VnphZzQwQ0pWMGhMQnBt?=
 =?utf-8?B?aDUwNDhpY2dLRnU2a3VkUCtUc1NCd3c2OENiSzBQUFJjL1QwQlQzYUJFemVr?=
 =?utf-8?B?cDFzcDJZOXpicjFUcUpBZkIyRWkwRURjNHh5azJvK25QRURQcGR1OWhkRUtt?=
 =?utf-8?B?RGdHYVZWN2hNVXNGSlU3MmFLNWRHNkNqSlU0RUM0d245REVob2lYcndoclFT?=
 =?utf-8?B?TmlXaXBFbXBZVVkxRWVaRUhyQVFZNjZ2YkkzaCtHUWt3T0srRG1jM3ZNU1p3?=
 =?utf-8?B?cDBLTFI0bHJhdXB4MFJlZWFMaGVnakhrc1hUb2tHMTFERGxqTkxVeHFQdzJB?=
 =?utf-8?B?VVkraG56MHFIM0p4RVBwS0UrY0dSRklHRXkvY3VySFVtUmR2clhZMElGMEFM?=
 =?utf-8?B?OTNBaW5XTG02OUR0TFpENlZ4YTBjb2VObGJ1clBqUlFNY1VUdG1PRnZ2bVFC?=
 =?utf-8?B?V3ZVM1hFVEVXYWVjS3NLcUVMb2YyaGJDdGR4T3hhSFdJV2tnZGo0S1RyK1BC?=
 =?utf-8?B?S1Rua3loRExzTm1UdC9LQTFPVEh2bGVCMDNhZnI2WTNzM0ZYVEtBSGNvKzNs?=
 =?utf-8?B?OUx2enozRnJzSzhoVjFEZUFXdU5BRjZjQ2lKckF2dnRwZ0F6NWVCaFZmK2N6?=
 =?utf-8?B?TzhoZWZHZlAyd1A2ajJadkYvTlBKQ0kvc3Zyd1RrWi9TQWFldjRkdWhFQ0FL?=
 =?utf-8?B?QXVEbEUxVGozU05rQ25OS21lUzVDTzRjWWdUSmc2ZTFHT3ZDUlNFNmN3bGFE?=
 =?utf-8?B?RjRmWUhYckVNdnNPUEJCcGQ1Ni80NVc3WWhZbGJmalhRb0xyZS8xUVlzU2h5?=
 =?utf-8?B?SUtSd0VOTWdGeVk4ZFBzdjFPNHdSNDlna2x4RUFKZ0NqWUFScjl6RHNTM2dN?=
 =?utf-8?B?MnhHZ3lIQnpGKzNjd3l0aDhFdkg2cFVMWWl5cE45SStJelh3bDB2NDVVTE51?=
 =?utf-8?Q?TSKNcQgBug8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEJpKzBEZFNHZmU5R3hVczRySDhZME5QODQ1OVp3YzJ5TjZNQ2k5cnBtT1Rn?=
 =?utf-8?B?YVJGU3AzRXNFc05wblBmNU1lTTlaaUtuQkEzcGtMN05CNzlMM2FmdTlIbk5U?=
 =?utf-8?B?STB5TmlFeDFFeTlzSVBleGZpbGlYWmhFOFpOcEVkSDBwUmNZR1NoV3ppSFVX?=
 =?utf-8?B?Nkh6YlQ3Z1gzM3RIWk1TQjBOZ090ODlQSUpCSmg5OEVFZFc0YUNTcEp6VXVj?=
 =?utf-8?B?eUMyYm9KQW5DTHRpcEtma2xnZVpqbW1IZkF4d2RDaE5oUnh5dWtSYThTRm9I?=
 =?utf-8?B?WDIvS1lrSzBmTVFhN3NRVnZKYi9nNlpvSGlGbkw1UGI3SDJjT25pVHY5SDdT?=
 =?utf-8?B?QWFvUFVubWRpMkxVb2NUVEY5aTVjalZ2cHdPUUdidVkzK2lSZ3FyR2tVbmo5?=
 =?utf-8?B?dDBNWjExRWJJaENraXI3NDRmVzJLZktpS1F5OVlqWGJVbmRGbm12Y3h6b21q?=
 =?utf-8?B?RHRZQ3llcktBK0xxcVVDN3ExYkJwbktabnBVZWxWalVNbmlLd2RmUUxHOXBW?=
 =?utf-8?B?TUExb2hSMDBNbE1kZ3M4UGV2MmN1ZVRpaHdsNUoxRk9EWHZPY2oxcGh4Qmg3?=
 =?utf-8?B?T3BnYWszTGk4ZW1lMzVTOGhkQXVBcGdWVWdlV0JPS0swNFF3MmVzWlJRbm5i?=
 =?utf-8?B?azdoTGlqK3BHaTdCQjZFa3liQkphRnM2ZUtVVG1lT3c3OTZEVnc5VXpjbktD?=
 =?utf-8?B?Z01SN1NPcXVhb25NTUloekk5NTJEZGgzNFRBRS91V2xXK0JIRE1iaFlYeUM2?=
 =?utf-8?B?NDVXcjdYT1hNZWYxVHVBK3VIOURqZ055TTdjTXM1NUFHelJVTHZDZlYzTnBr?=
 =?utf-8?B?VTErRzdSaUZJTGFRcFcvZkJ4WlkyeVZzazA1ZzdXL1l2M1B4TjZ1UERJYjA2?=
 =?utf-8?B?SEhzcTVTcDNWMkFLNG4wS0xyVmlNcGsraGEvbFprN1dQVGcwU1FRK09OWlBB?=
 =?utf-8?B?T1hMRDUrUWh1RkFiSGhMZ2ZsdXcrRVlJdjEzcmpmdFJZV1dXZnpWSUNMdTcw?=
 =?utf-8?B?SDQ3R1MvSEtwc2lzSHg1amRwS2dhamRIR2JOS0tVRG95cEcvdGJMdGNwYkx2?=
 =?utf-8?B?WXVCNytsS2dqLzE1STY1QnEvNTl6STczUkNpRTc1U0ZpSFlDV3hPS3Nkc0ND?=
 =?utf-8?B?M3BxN2kxUUJRUlpmQmY1eXk2aXNjQUhBWTBYMnN5RkpjUy80NzhqbEpBZ1ZM?=
 =?utf-8?B?K2I3MGJXZjNVNFpsMDhoeStwbDFHTzdhQzNxZjM4U1g4SjJYNUVFd2pDbGVv?=
 =?utf-8?B?RjUzMWREMWhZYVQwVUMwYnJ0ZXNEaXhVbW9nc29rMWtkVFMxS1F5YkpvaElm?=
 =?utf-8?B?QTFBbWp5ajArZEVWZno0dWUyZlJ0enQwVGxSSjZxSGFnKzMxdmFHR1NBWnlL?=
 =?utf-8?B?N3czTlBuNFlEZi9UUjZwaExuc0FUekIxOHhETG1IVVRDcnl6N1J6MGIzTVFa?=
 =?utf-8?B?M1hmZjgwRDIxdWU1V1EwQ0dWRWRiY05OZGhyZjFlc094VEcvY2RZSExGWEVB?=
 =?utf-8?B?b1BCTjkrVlJqeDJxN2Q0b2NFaXhLK1B3WUsrbW1Uc084emRQN0EwS0FpM0lT?=
 =?utf-8?B?ZFh6N1VsNkpLcGJwZEs1ek5Db0ExbndmTVdNWGhMekMydTJxVkYxYTM4Szdu?=
 =?utf-8?B?UHNTcmwzcHpTQ0duSzlqa0NTWnp5Ui9IL2h6TjFQY3ZZZTFJNlNHOStUTm5H?=
 =?utf-8?B?T0g3b3EwZnVQMnppZmpWOW5QTTlvdXpGU08vT1lLSVpONWpHcjFQV3RQckJZ?=
 =?utf-8?B?ZWpnL3BsZmwxTVVuM05wSjB1SmtKd3FldHM0Nk5IdUxoOWZXYzVVcDNKUTVI?=
 =?utf-8?B?TnYwVmhPT3Nna0ZGL0dVRWhjcW5JQlUyb3FXaEZ2UE42U3l0c3dZcEtBSXIz?=
 =?utf-8?B?ck9OK0ZWdnhCeFhrNlQxUXZQREgvT3lwRW9leUd5V1phSXZ4eEI4V3JwaGFZ?=
 =?utf-8?B?ZU8vQ1JXMUI1QzFoczBDMy9qQ1VDZ0V2ZGVmd213Q3dERUpwbUNuT3JEcVVI?=
 =?utf-8?B?d1NkMWxZQmR6dVdRWnd2OFNNUzNNaG1lSkFWcWZlUWpzcFRJNUJURW1PRzVt?=
 =?utf-8?B?aXZCU0dWMTJwanNrV05ubWNrWjZacTFNVVdMb3MySmZsWndUendScmtGaGZ5?=
 =?utf-8?Q?PHfmmoBwHGQyL0zk/OxOoF6z7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bB4ns5GmVORCG0SKKFf/VCfNGiCPBtam49nKof6sWsPkPlA/Rt+nSXBuLY/ri/7Io0wi1GkOPo9b8ajzbultzvtW8waLJ35VzlhZ+KqQJV30ih/YfLjtVDf3gm9r56ja3joK71xC48lPKrYPdKyLy6Gu3F2/A4W1FmC0vZBPgHfvRR3T2V2uHPxW9s5VtfP8LrzbUZyvJVOO8kROPUeqwoJxla7BOG/OYTr0B+gPrAxA6RmLgyI0r4TfoiCo5R07rqyN+scFuPF7bveA4+9eg7imY5JTvfiHm6QZpN3xlcznJANnvOV6fQTc0thhLw9zj9PAFpCY0LBU5cS1oTK2PkgxAi04y0cqxgoV48z52dj3Ulfut5TY054h0ZFQF2HtKTrlngj+RY4xNpiMrwuoqKUl6lvJSAcmbQv7seZefjByuDJGJ6+mZIf0qoKrJmJjqT5OTgF1caiSlYZO7YdrLlUa7ZP8lklk/ZRaD1BtdpdgtALe//J+UgPw/ZkHx9eoaA1BiD+c2/S5Q2oP+pxLqS9XEHN3PUREOl0Xi2ZddITXuDcvf/cr+3rMy1zM+kcyACmNMIhBa8O3zU5iOUmV0btnFLXpv3pQVeV6Kh5ziKg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429733e7-903c-45eb-aaad-08dd8bbda318
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 10:14:36.0150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TbdE2NOzfn4eu8xBrMTbTwrXuakL0rzm9GZMbWERyaP3FThxbDXkctANhwZo8ztxZsz+9Fb5ZJVrOsHjYrE78Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_04,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505050097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDA5NiBTYWx0ZWRfXy7VmoQsLSjeB 2DPgejJkAKftJdMx308Wu8xjUA4puAPqbTuZBZ8LAVAz5mgeACanWBMgtMXuKu86jdetjs21AUD PFg2NBqQwe2h0Z433nj0JPDDXg5Jr6rVVKqIDqD+ZTKuJctMDKn8qIprplRHRw1VJiufIlA4yMF
 tRlpJZ1VY0kKCZcksOAfwTrEC+46u6GTqP1h3ygO6CMpQqfZOVKWuQ3diZMkOlC6MchqFYz7anC fl/sC4Eyk6JDwaAoHNOvkXlRC86hl05J+EzgM1v3jw9Xio1Av7qpkqTgEKPdBXaJ1EA0UJzPoXi WYMYG9ATyFLA4vtljdGU0WEAaAFF9QrFOMFX41uAYfbHa+N/U5sx0Cbx637bwfCHss0dZA2WVyz
 Q8kjraCgaenqXxQPb2PtcCxjCSLKxqH10MQQ1rGgs0lby9UVvQALXaDN4Ki5+LK16GkIZ5DU
X-Proofpoint-GUID: GSpfuWTtJmpgc6A6LnI40_wG2woOJI4h
X-Proofpoint-ORIG-GUID: GSpfuWTtJmpgc6A6LnI40_wG2woOJI4h
X-Authority-Analysis: v=2.4 cv=eNgTjGp1 c=1 sm=1 tr=0 ts=68188f8f b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=7UoxDxbrbxLo21U5uycA:9 a=QEXdDO2ut3YA:10

On 05/05/2025 09:11, Christoph Hellwig wrote:
> All users are gone now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_lib.c  | 3 ---
>   include/scsi/scsi_host.h | 2 --
>   2 files changed, 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0d29470e86b0..39320dccbdd5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2000,9 +2000,6 @@ void scsi_init_limits(struct Scsi_Host *shost, struct queue_limits *lim)
>   	lim->dma_alignment = max_t(unsigned int,
>   		shost->dma_alignment, dma_get_cache_alignment() - 1);
>   
> -	if (shost->no_highmem)
> -		lim->features |= BLK_FEAT_BOUNCE_HIGH;
> -
>   	/*
>   	 * Propagate the DMA formation properties to the dma-mapping layer as
>   	 * a courtesy service to the LLDDs.  This needs to check that the buses
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 26bc23419cfd..c53812b9026f 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -670,8 +670,6 @@ struct Scsi_Host {
>   	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
>   	unsigned no_scsi2_lun_in_cdb:1;
>   
> -	unsigned no_highmem:1;

I note that there are some ancient references to highmem_io around. I 
guess that this was the previous name.

> -
>   	/*
>   	 * Optional work queue to be utilized by the transport
>   	 */

