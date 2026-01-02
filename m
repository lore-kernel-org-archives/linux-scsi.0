Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A52D2397;
	Fri,  2 Jan 2026 10:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767350024; cv=fail; b=NEyVgflQSUBSeF1RsTUBqGSVJ104FTjxs9zppo9W12CEER/Wl/+I8w/q1b9hUFhyvztZ7mrjztfC3HBMYW493lW018YkRwMoKBAbkfJocH5NDad/6Dg9iskfud35NQ49F3WBf+FgBUnYK5E50VDPcZYJS9xyXoKxwt+V/lIHAgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767350024; c=relaxed/simple;
	bh=i0lkWkKaT6AW5+MKyc/2g+UfDK4Po9tcaLdruyGOfZM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nAaP733QXWZELYzgoQLP37V3/36Wx9EpJ/EjfBIOtQ0WEZycFvKl2KfgZIK7/G53bl5P/W0Gu1x3zgtcjtPjEeWjm5GYGusu/yjqVks3DRaxXcCz1WwuCCfJh7ct82I9XOOBEoHFtDBj/fg1GmFg06iKk45mBwyjyXqHzKMJdCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b9r0pN30; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=orJTKo3X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b9r0pN30";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="orJTKo3X"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6029uWPb2794596;
	Fri, 2 Jan 2026 10:33:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MbG78bMvE2zoKJTFx3KBtYz3guUr9d9SQ23anKW1RFM=; b=
	b9r0pN30tS8ilGgFJk0R6aSRAQlD0f4ZNgFXcJymTaLVVImL2mmBGZ87HVs2+KNY
	/J7S2h97JVSFa41JoAjnLUcUmhTBwSQEd31SzAHtIwde/rWIH+r6ng06wEbX3AUh
	4/vHIuOiJn5xJ/BFpktAq2852W0oTVtCOja0dK7XI4Ul2D3MheW5rSkCj1R7Txyu
	NTwuzqSbth/849rAWIM3MFZ+6IkB1DliA/s+YpldH5mNwDIpmm0q3im1jIFcao/N
	jBv8LBAb50RNR6g+DxexJ0Qr6VUAwzeEdvUQGKxHxfkNElZztXczG16XYzon5o8A
	2zuV7N5II5LVr+dkzWdOxg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba5va4xdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 10:33:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6027GNv5013660;
	Fri, 2 Jan 2026 10:33:36 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010059.outbound.protection.outlook.com [52.101.46.59])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5w9s6bg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 10:33:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CwR1z3tPWsvEmNe6YSK0zgeQXUDch1e12jHSwpPOG4u5q3LnkbaRdyjOj3uClbcSY97XOdC5HU78Qr8UuSHAkp8Qzu8oVJgbDs7MfEJmlhBLb17c56I/bTTuhjCNZKK29R0TZzFxfj4ZIa/fzzo41X2CHFEarcb75/c+i1gpRBp/iKOi5JrdY/3GlI5Hcj1o1oorfyGFEczUf3w/FugTCPckt+PZbs7FNn+mApowwzMWeqbpMM2UeSt/7rLRVS/Hk7guP01/G/3t1DbOgszSK2CzWDnhxM5D3C9Zd9l3DngaEhaEFfwozvejLZ2d8XLKP8fz36yIO9KoQAMVpcBqMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbG78bMvE2zoKJTFx3KBtYz3guUr9d9SQ23anKW1RFM=;
 b=iiOo65s0sN2JMORKxq0q/v8OwcCBsOKd1S2pl6MaquuEWj/Dnx8BbpPZEE3oT+5YPxtiYghAdS1hcUUy+GIbOa9/57CUqYxrV9OQoqaa79w4uPcNBqL247/xdbDDOU9fSUUlXvenrvDs9aUjX3B6SDQ7rxHS3Mm6V/3bj21j+LLE2Noj19qL6x05+Llk4H+EWe0zLSMXPv5W7eCG2WOIz23BHOKhBxmYuXuhKrhb1+nsykisy0tEbNUxRJ5n4qJKJda8PKhWv0wghjnhT0yT5WbkryWwCiSWZ6h713oK5zajL95mr4A/qHdiEwVHaCMbs16Au0Ex6FSmaklz1EU+Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbG78bMvE2zoKJTFx3KBtYz3guUr9d9SQ23anKW1RFM=;
 b=orJTKo3XOrGmdm+k44ChXExFxpKQ90dsvX3SnGB3GYa16EgYfZqp9eIGOS/l6SEuNn0K1UVx6tPm3n7s8+yAhhmKYPZ+fnm4B7ZKmk3tkJNHWVFepUj8EufmaRGrivZPiHj+B5XZflLCF4pHveNABKpTwP4X9sr9piOWcSfn1VM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA4PR10MB8565.namprd10.prod.outlook.com
 (2603:10b6:208:56d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 10:33:28 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 10:33:28 +0000
Message-ID: <49d4b21c-cb2c-455b-8ab3-014bac63deaa@oracle.com>
Date: Fri, 2 Jan 2026 10:33:26 +0000
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW1BBVENIXSBzY3NpOiBtcHQzc2FzOiBGaXggaW52?=
 =?UTF-8?Q?alid_NUMA_node_index?=
To: "vulab@iscas.ac.cn" <vulab@iscas.ac.cn>
Cc: "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com"
 <suganath-prabu.subramani@broadcom.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20251230031416.55328-1-vulab@iscas.ac.cn>
 <cf0f9085-6c87-4dd5-9114-925723e68495@oracle.com>
 <SE5P216MB338083B78B7FFF35811F70A3FCBCA@SE5P216MB3380.KORP216.PROD.OUTLOOK.COM>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <SE5P216MB338083B78B7FFF35811F70A3FCBCA@SE5P216MB3380.KORP216.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0055.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA4PR10MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 466c4014-b594-4dc7-72b6-08de49ea5e33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekIyU2dYQkg1aUN2L3dCTTJUMUhsaGRTdWVvWTdSTFdRQkk4VlQzT0JrcUtB?=
 =?utf-8?B?cEo4U0o3RzlWYmkrRWdrbzRYKytMankyakxOSzk4aWJWOGMrTVdyNVJrUnlx?=
 =?utf-8?B?dGRpbk5yOE1JRlBja3NPem01Rk14VnhFZEJuangrQ2pIY1duVXI2TGJhVW5I?=
 =?utf-8?B?cmhzaWhqQWppbzI1RXdMKzJWczIzcjdMRkNLSTcrSnM0blpjRC9JUjhobTZo?=
 =?utf-8?B?OGRYOHJjOUkxalpCZGhLNVI2bERGSGFKQ3p1SUpMUDhnMitOWXVNNGZBM0lV?=
 =?utf-8?B?elZ3akx4UVR5dnNaSFhzTEFuUlFjbS83dVF3Q25qMjIzcnhPYzRLeTR2aUpi?=
 =?utf-8?B?dDUzSkFST3ZZSjdvMGtyYlYxV0EzYU5DMmhGZUt5NkgwZ29CN1lVbHJMRUlU?=
 =?utf-8?B?S1YvcUpqcXpHaHlzWjlsNGYxMVZhaTZ2KytPWW1lS1dwQkEwbDRjdjY3NUN4?=
 =?utf-8?B?U3E2dVJrWDlldkJWWEZObHpuT1BocGg2RTJlR0RDdWp2NjZpVjhkbThuTjRX?=
 =?utf-8?B?NS9xZDJYOVhMdEFIaVgzeTJiSTlJbEY0SGw2T091Y1IydnVzT2NqTVdIUDUx?=
 =?utf-8?B?K3VHV1ZWR2M0R21LV0RGZ0Q2TnhWVkpGNTV1dU96L2RvNUNJU2RRdjRjdjBw?=
 =?utf-8?B?Z3lGaDcveWZNRkZMR2tYQXFvRnhRWE9VbU9Tcjczc0MrdnVCRVM4eDNoY29R?=
 =?utf-8?B?Z2o1WVUrbCs1MENpUTM2a25ySGVRajk2RktpNEc4cFRXSHNYR2VtU2JrTzh3?=
 =?utf-8?B?ZkxhVjJ1b2ExOUVSakZQTmZuOFdvNFpJZ3g3Rkx5Y1JUaCtQWlhGRWtLK3ZK?=
 =?utf-8?B?bVJNb0o0OUlMemtDTDhGVENWc2RnYzFJbkQrdjA0UC9UdnptOVZQa0ZJTVAr?=
 =?utf-8?B?dGp4dVdPSnIramhUU0NKU2NWY1hDSkRlZnorQWZyNSsyWEdlK0xnSUFLczFx?=
 =?utf-8?B?OUdrNTZHZ2hRTzlPOE1VNi9xK3BHbU9BTVMzNnRkTHQ1M3FIS3BFeFhlNHlj?=
 =?utf-8?B?VEE5S0NDYTI2eEFVcGYxdVVhL3cyT016dkU3bVBwbG50L1Qrb1MwbUpRNDk1?=
 =?utf-8?B?bk00bHpEMmhhRW8ySjJqdmlQc2hCbENXZVRYYkQvUWRHeHdwRU9WK1lnaHRk?=
 =?utf-8?B?OUdwYkpUR3p5Umpma1I0Uk1Xa0pxRnVNZEZKMEx6UzM1UXBvdDBSMkFSSDNY?=
 =?utf-8?B?eE8xMnhNMHVYaXR2MURLRUNqekVvRlJzRmpra05pQzVVakRXdngyaHhzMGhY?=
 =?utf-8?B?dHc3UEY3OFVKeEViQnFGbEdvdllGMnJxZVltN0FjSlZjeXJlMFVBYXZLKzIv?=
 =?utf-8?B?SEZaVnJyczc2cXdKRFdvVTQwbTBvQUNDUlREUFlHZVU0RGdyZEJFRU9OZ09o?=
 =?utf-8?B?WWk4bnFRK1NNUHFmb2tDa2g1MkVjck16MVg4aVFZbUlqRHJrbWVObXVNVngx?=
 =?utf-8?B?TmRJeGlZcnp1S3hIY2NrT2tIam9iNVlCNkd4MFlwc2NQZkMrL0h4NUhMK3RM?=
 =?utf-8?B?WDZPZHhuTlNyaGhJYys2SGx4VjljaE9aRTk0NVBMYjdqbFZzSHBZRzJ5TU5I?=
 =?utf-8?B?NjRoSTFvckt5dEE0SmtuVWw4Uk5qM0RESDdGdUF2TURDWmtGQ2dFRVRnWm40?=
 =?utf-8?B?RFdLWUMzcWROM095SDA4MWVrMWZlUEpyYVMvU05OSytTb1A3alg5S1BOSGdP?=
 =?utf-8?B?MGxCZ3o5bDRCYkg1UFUvVUlHTDhsSW0vaWQ3RGtXVDJJZVdHOFV2ZXZ4bnJZ?=
 =?utf-8?B?ejFVV3UycGwwWkszU1A4RDRlOEVvQVA0dzB6SmMwUlZkZVQ0dzJmYjAzNUVt?=
 =?utf-8?B?UGRsSHdQTHM5dXlkeVhGSVhpY1Fpb3A3czFHNHRPeFZBdlMrOXhKWlZ1NzF6?=
 =?utf-8?B?NGZxcUIyZTgyWG5jL1F5TitlRE80Uk5SQURZT0dpcW5nYTVhNC9OdjZsT1Bn?=
 =?utf-8?Q?DoQ1l+9JIZZjheGiU+6zN6ANZt1RWcxL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWhVUEwxK1lJYnVySVpyQ2E1cjY4U2tCeXJveEE4dm5QcSs5N1pPSEtxMldX?=
 =?utf-8?B?ZXdyUzFiQy9oajJJMisyeVREa054d0NDdk04MWltT0JEYjNiTE1sbXFzVU5m?=
 =?utf-8?B?d1pJYVgwZU11eGI4SmRnMkFqZUNTYS9YdzlMZGNKV2ZwZ3RHeFdsU1FTRmRW?=
 =?utf-8?B?YnZ3cTlWNEVaY0JESC96TFgybGpMcWE1WWREeEpNajRmR2dZQVQrVmU2WWpx?=
 =?utf-8?B?NytmaTNvS2cydEZuaGdWRG5oS1Q5U0d4SjVWV0pCN3RjMTRPVnRXRnVTU0Jn?=
 =?utf-8?B?QXZBU0hVWm43bjBQUTcya2tINDIyQVp1NmJkSW5aQ2laamduRVl2S21GVktr?=
 =?utf-8?B?UlNhSGtVREwraGQ3QnVjY3Jwei80cGdRc0xZRzlVOXdHYzQ0aS9oZlVVbHNT?=
 =?utf-8?B?UCsvbnFFbnRyb0pLdUwwT3ZlNGxjSTZXVlVmZ2hGOTE1eDJnMFMyYTFEc05C?=
 =?utf-8?B?YVhmSndTNTNTWDYzZ29RbnFVQ0RqbFR4TDBxaFQwa0VMeS92dTAyeXRLbnNS?=
 =?utf-8?B?S0N4bm1NSlFRNTFMNDNmd0xFeEhtUGFRczhIWGRKUHBOSEYycmNkdE55dHBv?=
 =?utf-8?B?T0dOUzhWSTBOeEtPWndzOWQxcjFTcGlrMis2dWZ1dGVEQ1JWaTZEd3VYb2NT?=
 =?utf-8?B?YVJXejcvZy9zY3ZMMUF5alpscVkyc2JqRklwbnZBNW1TNnhRWlZJLzJhK3lU?=
 =?utf-8?B?Y05Lc1NyV09CTDR1YlhXanpwTTJIMTR4MEVmS0hqTjJEUHplcW1ZaDJldkJk?=
 =?utf-8?B?UlN3N3hINFBmZUNDZmJSdE5XbWU4NW1iTEl0SzZuQVcyL2EwNEZSYjY5ZFAy?=
 =?utf-8?B?d2JheS9ZaklWWFhqbnFSMjM2R0prOU9tWDRYSkRocDVVNGVQQnZQY3hhUjdo?=
 =?utf-8?B?Qml3TkthTEtQUEJFanZQcEdIMGY5LzBJdFdncnlZZFRnQVl5dmpMbXJZNkVY?=
 =?utf-8?B?TGZvWlU2eWUwb2Q2YWRHZHRYR2hmeEZmbElQdXRGTENBMDlGdkVnL0RVOUY4?=
 =?utf-8?B?Z08yZ0ZGMmRhazg2eDNnb0FsNWM0ZC9BSEl3ZWVqZzJLNm11MXJNeWRuYmt4?=
 =?utf-8?B?UkJqandEcE9jSnBtQ2hCYUt5aVN6bG5Oc0dqZ3FQLzVWdUhXVmZwaGh2Y01i?=
 =?utf-8?B?WWZSUThoVnNocC9JMFo5MC9ydUVTcW05Sk9qWGRUemM4eVRxdUQ3SGN3ZWZM?=
 =?utf-8?B?Wkpac1RkYUduUTN4bFFvSVF0VlNYRzBTSkZFdTFYc3d2VVlKWnRUdG5LQlNs?=
 =?utf-8?B?RGlmdVJXRHF5Z3o2S256RFJTZ1FydEdEbEc3L1NKOGFWczNhYVJGdDYySWQw?=
 =?utf-8?B?UkJ0Tk1NM29wRkR3Tm8wckdFQVQzeTZ0eEU1c1V3amtWTU5WNFRiYjZTZ0sx?=
 =?utf-8?B?NmRZRkVNTzNCeVMwcHlGZXhRQi9FQkV1S2FMK01Uekg1dDhXVnBxSEZIVmdT?=
 =?utf-8?B?Y3RPVVBQSGZNSW1Da2JNSUVPNXFMNTR1QU0rU21oeUZwNERiRUFKbjdyUTJT?=
 =?utf-8?B?YkF4OEFWUUd2YnJMYStmRWJvb3JVUDNoWmJQSEF0L29OOHVuZkRLdDFPVkhr?=
 =?utf-8?B?RHRMRjNxQ0pic1ljb0J0THhsWkNuTnlFb0hPNTdTb3RCdCt3NkpZbHNaNXBW?=
 =?utf-8?B?QTNNRTdtMktqUndsWTBWR2ZvM1J0aGNiYlpnd1QveUxNV1ZvM2gwSWUxYmZk?=
 =?utf-8?B?RU9KS2cxb1lRTzVuV0pNbC9qV25FcURxaThEMndzZFRTcDBwQVNTbUZTU0Iw?=
 =?utf-8?B?bWZvOFFlczNUY3JFa3JCRDBZVWI3SERMQU9ueW5pYy9kS2NJQk5FQmlwSWs1?=
 =?utf-8?B?RDBrRDUwWFAwb1VEcVB5SEF4Y3BiS0NpamROSTJyUU9wbUdoU3h6cG1vWjhG?=
 =?utf-8?B?eWE4Y1dGSUdIeFF2VHF3NTFUTVF6cC9iaXRTV0FWS1Jic3UvVnFXVWpPVURz?=
 =?utf-8?B?NCtmK1JFOERUYmt0L1lVcTJHN1VhTkpHWnowaVZRay9jRzJwRmROZHlyYjhM?=
 =?utf-8?B?L1dlQlFTdnZKRDV3dS90aUpUSjMyaEI1QmJ0ZXJWUGdoUjQwNndZTDgwbndB?=
 =?utf-8?B?eEduMnlFSDFRTjBwQ2JGYmRlNHV2WnBRTU9EWFhRV1hOcHBoVzk5WXJKLzEy?=
 =?utf-8?B?eTdEZExUQU5iT3lUWnJqOFNxRHloTFNtalVsVmpYYm93RktOMHJxSTVvT0lx?=
 =?utf-8?B?MVc3OW1adVg4dlFZdlk0b3ErYU5TMFhZbVI3dk8yRzJ4aW54Y0tUWXgvRmtR?=
 =?utf-8?B?cnFRQmdOMktuOE54Q2czVUY2VFl2MHhPeU45ektVMUJubjVtdUtPbWJLRFZ5?=
 =?utf-8?B?WnJYcTVEaFhUTE02QjRRTkdhWHVaZUNVY2l2ak1QcmdnRUxiK25zdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2wHy9mouUNuqOef3wTJsVCar62GYBfHwCYVcdmXGPPwBdpYsJXYumjR8fLsYrMxiT7QmfLRZBivIdUgsp+7tFdkQNVeVKlrlH232BYdi3cnEKs5Dmacc7UGUCkuj4s6/AtwQAncytE4qZv5maBFw9D9hbcyKzR+SZjZpY2I1sZrTUEI6HS0wVvM+ZwkIM5FhwhhFyl/9at413/Lue054xtnHTmhZmIFRBEKpaUmtXxZA1P5SrVRpBvwAoedqx/UCAxhIYdIEVsjJoKB/n8SuxJ3ns3MmtWhfAvIcpMZPyyFJyCv+a2uVaM1xG7n60SJgCm5dzwu3BYJN9Uc6XCN76oDG/xit1z0/W9hTjKcLfaWNuUdt/NpRSKEkta0d3HJwm7aqD1A8FxuVRsvNBXXzE/JVz7rb1QulPIqWYjrS2WJr6cSCxQW0Y8RIc8gQtzDuOK6cbdhlVeiyTqDwv3IUMrXs/V4YgAE9Or7b2Dpq9c+uym/9SO6RHNIX0xCzQ3216HGR0PBuccU2Rxc3OHftn5/0m/F37+V83Yh0aNbLbDYAvxbCmWt2Maj1bIVNq8XL8kzNyolPKNM3Jxt4UmCSr7Nl8FdfuBRkcZ1aolCBW80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 466c4014-b594-4dc7-72b6-08de49ea5e33
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 10:33:28.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awlkwsLNmSCu2sRk0nPTogUE+A0Fsb+jvLqmnbfEritk1tVRb22GS4P8hSPBgrsZl0f2lkjnXuKj4nctT4dw7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8565
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601020093
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDA5MyBTYWx0ZWRfX4IOE5M5QsRR3
 BjT87LBk7/0lDklXUbIq6Xyl9hMMiPKvS57kyk11NS86DQr5lHBeFJiRajVy3cM8khubG2bmmls
 SSbhawqobjJ+6u5Dbd7buL3xJI+rtuv8MUBqvYS589hCq9HwRAGCNoULlgZiTCXSGignk7HVjSi
 qC2KGYYlzvnQwTG947eIu+QkNQ0HlX/YS9YE7GswXZyB3DaIOnLo3I+KAOekTaTu5zhguQYjXee
 8DzQG+Mnel0YssMtu+18geOkHxQb9vdDT2UCGVQzLWjWvxMA3ANn7ttiohcN6o4sIJNRzAtvJY9
 eaq00COo18ym1xgYFl1I/3KiQrglW8J3klNFSZHThbCviLkr9z1vcN6hIRVsBb+mRl2mm1qY8AT
 897/Vi3ktBbDkK8gswVMBHK58Id90RxmsQhz+clYXhQwWKoFULYZHyz6akic7NMHeY5TOzZzKk1
 upvwqOHMNYg5oY6xXIA==
X-Authority-Analysis: v=2.4 cv=NMvYOk6g c=1 sm=1 tr=0 ts=69579f01 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=5KLPUuaC_9wA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=2UBqqSSNp84Is-KnQXoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: RgqnscTXNUISxk-_u42SOv95qU_OXlZa
X-Proofpoint-ORIG-GUID: RgqnscTXNUISxk-_u42SOv95qU_OXlZa

On 31/12/2025 01:19, vulab@iscas.ac.cn wrote:
> Hi John,
> 
> Thank you for the feedback.
> 
> Regarding the suggestion to audit all cpumask_of_node() implementations:
> 
> I noticed that a very similar issue was recently fixed in the
> megaraid_sas driver (commit 752eb816b55a, "scsi: megaraid_sas: Fix
> invalid node index"), where an UBSAN array-index-out-of-bounds warning
> was addressed by handling NUMA_NO_NODE locally in the driver.
> 
> Following that approach, it seems reasonable for mpt3sas to handle
> this case locally as well, while leaving any broader unification of
> cpumask_of_node() semantics across architectures as a separate
> discussion, since changes in the x86 topology headers may have wider
> impact.
> 
> Regarding the fallback behavior:
> 
> The existing megaraid_sas fix falls back to node 0, but as you pointed
> out, some implementations (e.g. drivers/base/arch_numa.c) treat
> NUMA_NO_NODE as indicating no specific NUMA locality and return
> cpu_all_mask. Forcing node 0 in this case may unnecessarily constrain
> interrupt affinity on NUMA systems.
> 
> For a v2, I propose to:
> 
> 
>    1.
> Fix the issue locally in the mpt3sas driver (similar to
> 
> megaraid_sas); and
> 
> 
>    1.
> Use cpu_online_mask as the fallback when dev_to_node() returns
> 
> NUMA_NO_NODE, to  better match the intended semantics, while still
> preventing out-of-bounds access.
> 
> Please let me know if this sounds acceptable.

I am not the driver maintainer, so it is not my choice.

But I will try to remedy this in the per-arch code if you don't want to.
