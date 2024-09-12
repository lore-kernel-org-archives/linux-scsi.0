Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48971B1429;
	Thu, 12 Sep 2024 14:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153153; cv=fail; b=DfTo360UqJfBCeCicDYt44wYKC1OyllkmIaE3sahRcxz0aVjrhdWG7NMe4IdB7iXLQW5o4aZWjEj3v5ZyOJqgKERvRulo6vLqd0Eeni/DuZKg40prhyygK6XWzA3hRq44bQNfQfkGxlZtC8ULrxx/3OmuQv0azmjs+kp8WEU0vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153153; c=relaxed/simple;
	bh=57kBkTAtocQqMMXOFOeIXuGPyMA8LChbv+THcvxUR9M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FM/4gG7OrB1l1qzcECEAuUFEBuYNevIfLgj6Om7VswHCpp4apNHiJW8F7CYheWmJW5QEAqh8bbVKIFi5AuFiof8EQSC0l70kUmS0uN6MQ9vAyRkEsNoNAIGznTfYPZhJRqyXxJ9OsdgxwAp/4vEKAP5J5RFtr4wA+cw4PMRiKCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AlMOgQc8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YiofWgJf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AlMOgQc8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YiofWgJf"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDtVU6008473;
	Thu, 12 Sep 2024 14:58:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=nI/a7tlehkX8b4DQ6SNb1cNBUwAyt2LVXPkMPWiBeNA=; b=
	AlMOgQc816CRwRCVfT5q1UgupKE1/mVFILm+p+p/HE3qrtCZrRBUEaIjwSFynw77
	DbRTviL4tymumwHqFayt2f9bmLPX7GLaLb9jiwlawJjLCOP9P3GqxbXLkIao3C39
	SdD6p+/SSOwukwFsU3j+iu2vfNMMr1C3/3dMhGsXjYMe+lj0gXLIeeoHIhUSqTOd
	e/4YkA9yXOe8OeQEdDDLB7+lPAmHIzCgqhPsCjPH+GbRDXy282kEkuAErzgVpdbj
	or2w4g2O0qgpWVHoeYmNhyHroTHOwVAPkYBXoTK8ksg+SGq9+krE2MviMNNuH/da
	kmEko0aXEezyieEGXUC7IA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2u4nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 14:58:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDQ5eX019800;
	Thu, 12 Sep 2024 14:58:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9hxnrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 14:58:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yirBz6M2HH4gmFZuOPG34urKI/Pi0JDNQuSlC8qwnXbaGqI5VbK4d7ObSWsMlQVGTKYU+Nm29rKzo66M8qTn7TxXpoNK8pHUtKKh+9N45OKRuAgkdZpv6ZymvrXmgGM7p7mDN18wfEWLlPAa8D4GwRj0UHAVs/K3JAuwiF8OWXp0nSQ3zTt4XsO8NevcpfflodFD2DX47hgVHl4zDiZ/vUN+AS3cbr5HnCsvtCXi8GClBszauKxorweinaZD3ERnk0jEQ4zSOlIuRXLeh1OkBmhsRe4Bya9DeaWh/8tx53VCfSaxVdpZMJ2e8EYOtrtsI77n66zAS2s74YoMM+nCIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nI/a7tlehkX8b4DQ6SNb1cNBUwAyt2LVXPkMPWiBeNA=;
 b=Mrwf6NkJ7yTzGoTnLq7uOYuLShpm2eTCFxQ4/xFXtZLkpiXhTcYpbT85Ajs6EB35dEKHdLefLSHyEkOrFSbHy6K2r1YGR2EhscvYXviiyi4b47y0iHsvqq3PpD1gHpKvgn1OUwDkRDf/7xpOujO9xwnWHhxZPFPrUKDofn9wzS8x/xNjCJLo0cFu+msfbiKVQZWlFZwGXGCty8M8HDCqyERtMT/XGIU5l7a5NBX2f/uNU5DrUDLemFhoojhUPuwS7DotXOb/o72+0ijpM0HFaGzu8ioQtI1I6jDZ+CD1UBbSEdUnlkNNWmZzf9RckulGjtx+upS6LrdaarFpmMwasQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nI/a7tlehkX8b4DQ6SNb1cNBUwAyt2LVXPkMPWiBeNA=;
 b=YiofWgJfALqcG+sYvFTeP3l69mLsI2E9pvqkySxfOlJq4VDE3BUlwND5P/nUPLeDHHA9K4prtStiwK3cFc8P5cGvl8YApg2SVc4YC9g17Ouo9Uz+HFFv9mo4TgTzkmLFbaYTtoc4S4SR0a0rJoWLnd6km3cvQoF0Yz5gu4qXD5M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB7078.namprd10.prod.outlook.com (2603:10b6:510:288::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.7; Thu, 12 Sep
 2024 14:58:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.008; Thu, 12 Sep 2024
 14:58:41 +0000
Message-ID: <8c91e5a4-4f01-4906-a002-4a9032cb8da3@oracle.com>
Date: Thu, 12 Sep 2024 15:58:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/4] block: Add BLK_FEAT_ATOMIC_WRITES flag
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
 <20240903150748.2179966-3-john.g.garry@oracle.com>
 <20240912131610.GB29641@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240912131610.GB29641@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0023.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: 715ffb7e-b428-4857-3d6e-08dcd33b6398
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWNpMU4zRjRaa1pJSXUxSkZjTkszUEgzK0lzQlJScFdWVmJTVDdOc2JFTG1t?=
 =?utf-8?B?bU96QlVpdkdYRTRtSUpwMWNzM3MvUUpNMFVNc3FKMm1iOHlkNnoyZ3NnaFV0?=
 =?utf-8?B?c3ZOMkExbURSZUhLbHlaODBhUERROWx4YUozNHhsV2dTTFFQSFZaRGlmMDJU?=
 =?utf-8?B?cmpVSEhLMUZ1cDJHcnRRcUcvR2grMVpvWkJtZU5ITC9jNHZkR1RUbmpzbkM5?=
 =?utf-8?B?V1BEUUVYS3VSWVdUMnpqRFpONjdPckhEQzcxS2FXMVVJVFFUZ2JYS3RiRCsr?=
 =?utf-8?B?azhuVWdxZlJxSFFLU2M2RXVldUcwbkxzTGZaWlJ1MFRXdjNBQ3lXSndyU1ZQ?=
 =?utf-8?B?TUNlT3pIeU9lSVlXbkhSZXltVUQ1NWFoVTd5Uzc0U0k4OVZZNHZjc2owOGhZ?=
 =?utf-8?B?TVJkQlE2MWdJb1pMbEthSHFTanVtNXFpaW5ORzhhem5reCtSMC8zK2ZKQXpn?=
 =?utf-8?B?dkpXV2VZL2N6bkRzZ3RwUm4wTUc3aFhSemlaRk5YbFI3MGwyZnVBNGRtc0xT?=
 =?utf-8?B?eGs4UDFqWkxwSWZKRGN4WWZNN2h4c0xjQTVkQ1JFMEZGQXQvRE5ody9vQk5Y?=
 =?utf-8?B?ek53S2l2YVcvbm9FZDNmQ2FSK3AwMmN5Z2JiU3F2ZWZscHBqc2VHYzVXODNu?=
 =?utf-8?B?NmdvbUJtcS9JSzlGbHlGSlp0L2lvSVVZRFEvNVcwbWJXUEwzZVFuQzlaNzFM?=
 =?utf-8?B?S01nN1lyVmFaT1NxR1VTYklaakdhQ0U3Uk12Y2podWY0Q0UrdENPVklFV2gz?=
 =?utf-8?B?UnhFS0EyOGw4dGtDdlkraEM1WjBKVkNweUdzSmdpRkNvMWVVYmFsSTBWTDJx?=
 =?utf-8?B?d1ZWdTh4S21mdDBsd3NmcEpYT2FEQlpXbTZ2UTZqaXA1am0zSUJ2enVjRXBP?=
 =?utf-8?B?d3pmWm1WS2pCMmpLTXhNWDB5RlVQQXdFK3hpMDRKa0lNN3VGYmUyMXF4UUZ2?=
 =?utf-8?B?U1Vha0EwN1hFakxwNEhJRWdvc2thQWtWQW42TlFMVVo1NjlLZjBudlJsbGFm?=
 =?utf-8?B?WmxiS1UxTUh5ZHlDZzlGL3oyV1pLYXoyRndHbG1QQ1FIN08xeHZUQlExSTNx?=
 =?utf-8?B?anpnOUJodzRiU0FBcUxoeDl6QjNHQWdmeVFBZXNJbE9mVDBDSkkrNWU4SytJ?=
 =?utf-8?B?b2xIOHh6TGZpc1RwMTJqZW9rejExTDZlN2NMa0kzWXMzRlZIcGRPNC9iU0V4?=
 =?utf-8?B?MU94OGZHWExBOG5SdnJmcjRoOTIrQXZFdit5Q2hmaUUzZnUvRWVsRWV4ZktK?=
 =?utf-8?B?dEZNaThValk4M0FJeENBQkwvMnRvdXNIUm9pYURzcXNncTVrb1M1TExjVlNt?=
 =?utf-8?B?ekZXT3Jybm1hQmJJWlZ5aXJjM09tZTVGSnZRMHZMQ29iK0grdXF5dko3cnR6?=
 =?utf-8?B?VzNSYXBYd2poWm8xdE45MkVkRlJ0NWZSbmh0QVFaZVMxOUR1bWlaQlpDYzg1?=
 =?utf-8?B?YlU0ZUxZNURYYUMrNlJ3aG9vRE5YME9XQXFKZkFiTW9MbklzRWNRVVBodksz?=
 =?utf-8?B?WkwvbWU0MVl6T3FuL2FwYlMrOXVod3JmcUFjMHlPSjF6VzVzaFpjejJ3NjV3?=
 =?utf-8?B?RDU0bkdQWFdNZkZkVnNkSXdZUjFLN3diQmZQQmx1TUd2UE9hL0k3czFhUXBw?=
 =?utf-8?B?UXhFbmxBYzhLNFJFR1IvMFJhTld2RU9CZGNKanprTDBjQ1Z5VmZNZ0xDU1pm?=
 =?utf-8?B?ckpjUE1TTkdxYUFpUVlSWFJTZ0pOdElCTnlVMHZCK0d0Z1RodEtIdzYyeVNH?=
 =?utf-8?B?VXI1T2ZOdm1CNWlSWHBVWHBIOU9MWWptRWdDRm4ycDdNR05ZZmhnU1l0enpL?=
 =?utf-8?B?N0pqSXBQQjdWV0ROT003UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGErVmV3bG9rYVJhS3cyd3phT0NPVzI0dDdQc2dqWjhJeHZTdlU3QUVMYnJ3?=
 =?utf-8?B?cWdObW9KVUZwUVkwNzZVRTdpZEg1dnBtNWtrNXMxVTFqb3lTWXc2cmJ1WXFN?=
 =?utf-8?B?NmozNTI5RDZydGU0RzFNRGdNUFZ0bTVGTzZQUHlOTy9meHNicVp5S0VTamJ6?=
 =?utf-8?B?Q1VWSnZ5YlpJbDd1M1pvc0RGUFJSclFxR2d0NmFRQnhGZmtTemxkZm1MdXdj?=
 =?utf-8?B?OTdQeG9mL2Z2dnFBY0pwM00wbjcrUUZOWGhCWGlrbDhXenBMYzZhZDFFVGxP?=
 =?utf-8?B?VDNYQWhJREc3OVBHK2ZyYkp4cjd4NnEyS2d2UzNuL3AwQ3B2RWtiNU53WXNa?=
 =?utf-8?B?amdqVUxva2ErVDdyY29uL25JcGxUWGlLcUtERDR1QmxWVkdxOG81ZEsxN1M1?=
 =?utf-8?B?YnpTSzRDaEFScG1pK1N5NHVLcDRSUTNMZHVzTE5IU3llSXdDblhJVEVGeE4v?=
 =?utf-8?B?ellUNkJwQ2xURG9uT01RaitQalp4aU5Semd0bE1hV2V5dEp0U2YzWkR1MXdK?=
 =?utf-8?B?QjZoVU1wLzY2cEFLV1FiUWNGc3I2R3RYYUkxb2E3ZVZ3UVBnMzRHZFJxYzdm?=
 =?utf-8?B?NWtYdWNmb1BCdFN1ZGJ2N2FIUGNTL05TU1pCa1RQOGFjK3FpNll1OXVyMSty?=
 =?utf-8?B?MmtlSklyazlFendDaDhtaVdERmFOdkhDekQydEt4Nk5sUUtSNENiYjhWMlRj?=
 =?utf-8?B?bEpCUVVTMUIyTVNSRnVrNmhYTzNHaS9pbnl5TkE1ZDBIczRIQ0MrWDQ4UXFF?=
 =?utf-8?B?eGcrM3NTNzQyWmczRzJmT2M0eWRIV250dTVFTnRhcXR5SkJQRHJ3eGM5Ykds?=
 =?utf-8?B?M0dyODdSWlR0OENsYUFWc01vMTVmYUE4cnpycE82M0lKak0yVXJKSmpWVktF?=
 =?utf-8?B?a25IdEpWc0Z1eC9hU2JlNFRGTFNZaUREL0pDRVlLcmszOFJOZG1qNi82eVU1?=
 =?utf-8?B?WFA3RyttWDArNTJtbWlQM3FNNUFLUWh5cys2c3F0bHlDa3djclQ4TnRrVnor?=
 =?utf-8?B?aVVKYTlNYVBpSjc5MnM4V0h3KzdEaGl5V29DaWNWYzhHZzAxQUFualFYNUl0?=
 =?utf-8?B?bDJDNXB6QW1kcmRqaGNMYUcxQ1cxRW5tVnVLcEYyQzl1QjJBVUIrb2srck1C?=
 =?utf-8?B?enN5N1VIZ2ZybXNvRGtQQU02emgrT2M2TEpMazBQUExRRWlFQU1TS3FGYTMw?=
 =?utf-8?B?T1liSnMvTzMydFRHTVgxRHowd0FqR0ZvZm5jMEdtUGsva3RaQy9CWFpWVjc3?=
 =?utf-8?B?eWdUVWhFR1ljZ2hiRURWL2V4bEpvVXNEZFpLRFI4L3F1dkIxbVBxRWJYTllX?=
 =?utf-8?B?V3p5T252LytiVXFZeDZkVG16Q3VPTUFieXNkSnBJUFYydjRyYXhmL1ZNSitw?=
 =?utf-8?B?dW9PN1lwRGdwelhhdVM3bEYwRjZSeTBUOExLaGo0SWkrVDRjNXFPSmtZZlI2?=
 =?utf-8?B?ZGJ4UUFXazQvRVNRQU8rK0JZQzltM3VyWWMyeVF2c1VvSTFsazRzams5VGk1?=
 =?utf-8?B?dnBWTVU4Vm1BcDNwZTY2K3Y1aDRmWkt3ZjgrL1o1cC9sMmZ1dlpDOFpPTGh5?=
 =?utf-8?B?ZCswWHM3M21oKzJUd01MNWQwRDYyWmRLVm5hM09wVEhTR09PbVJrUUZkR3l1?=
 =?utf-8?B?UjRDQ3NPcDRmU3B3bEZaQlhXMURkVHF2SFB3eUM0L0NiNFNPUDdMd094UXE0?=
 =?utf-8?B?N0FRcTh1a09YRjVuT2c4T1c2TldPdUV6ZWRKc1RROUZQSGZPejlySEtqVnFT?=
 =?utf-8?B?MnJjUjZ0OHdBczFuVzk1cWFiL3g2dnh3eGZJNUR6ZWxuY0dLRlp1VktMVkV4?=
 =?utf-8?B?aHpTUnB4cHRnSXBwVzMwOFprZ0NwYXYydXFRTG8rTU85QWNCN0R4L1pjUTR5?=
 =?utf-8?B?T2NJRDY1ZW5FaHdma3ExanRSVGw5aE5ydTczVG9lTk9YN1lvdmZ4aHAycXp1?=
 =?utf-8?B?b3IvaUp6VUx1SC9kUGFSd29HM2pDRWVoVTNQQ0dVNy9WM3FnSHFDWlZYRXRJ?=
 =?utf-8?B?MWJ0YWRyaFNCbzg1K0p1aS9xYXluWm9EUXJwaTIvRWZIMHVjdE9mckp4ekdi?=
 =?utf-8?B?TktkUU0zbDJmNnFUT2Z5SjF0azlrSjlvb2Q3V3pRWTdObDBSdzRyS25ZNFNq?=
 =?utf-8?Q?Xla6Vv7Zo4Y9CnzrMSz+15sn/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yU+dEypGGi61I5hqOOG0/rlOftMWmZHA5Dh5m0dfdU4kpCBXNoL7/lH8nOIjbGvEIWpoNr8Y98odn7jU2eVdQqqvDOiM8Z1pAXfrriieCBInpuIgu/D5mnzHkiSFq5UJYjasTeB35lZ1uxaSRSJDLyaUA8PimbJR9pXatIfRZqkm3FNPcxYE3WRPlmewhqxXuGb9UulNbD9dnR5w4JG29f2NvMYqj0NLSIh+NaJ/ohU9MrIcMxZah38j5AUyxVbh60YI1Be/Z5BZYBy1tqjGwnkx42TidE1GINbm8oPCGxgWnWTrCbchmO5JI6nclENucCiGxmulmD+VdKXdrE9vHE1FHBK7ld2PjRe5yT3fVC/17zDfyX771GsE9OIGoCRAk+iF2qIKg6zZEym32ZBofpoI9brMDjs+UBmM8I8dHTKoITpCvHByXMjcr4WWhDzpz7Cfi8fIIjNSi9+LTzs1wDrOiOl5rC6pQgD0bLrQcwb53LffxKX1Jja/tnwvJAeG9pus0/wEXJar7JA9L2qcabRxdH0RwOfxsfEKLe44Efsyg37UwGavIyZyGayOSGzAXwwr8p+wDO4kOX++7AN//caqgEXV2oYs/CYiiC2fPTQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715ffb7e-b428-4857-3d6e-08dcd33b6398
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 14:58:40.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5BKm1p2TVFrxSr7G3LsiCDbe49Pi/aE3ENspcQx/iuEx2i580taPe4f8+5/RqZkF+lucLITenCHrvps7+Ow1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_04,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409120109
X-Proofpoint-GUID: 5WZeEyXs0ZjkvozscFCbhFsDrFpzWMi6
X-Proofpoint-ORIG-GUID: 5WZeEyXs0ZjkvozscFCbhFsDrFpzWMi6

On 12/09/2024 14:16, Christoph Hellwig wrote:
>> @@ -176,7 +176,7 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
>>   {
>>   	unsigned int boundary_sectors;
>>   
>> -	if (!lim->atomic_write_hw_max)
>> +	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES) || !lim->atomic_write_hw_max)
> Overly long line here.

ok

> 
> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig<hch@lst.de>

cheers

