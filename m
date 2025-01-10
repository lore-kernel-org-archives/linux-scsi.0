Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDB317F4F2;
	Fri, 10 Jan 2025 09:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736502710; cv=fail; b=p1CO0fI2eHYnTe7QzMKys5x4C7HnwqZ8o09ZiNaV+D8tQFS07oaPwmOqB+HabNIj+60u2/ESeM8WDlrCh5P+0koRypV2vH4NhyjsJD7H0limcuE8y7f1tA5pIibEAtAJmfSbSdePVuI5VP75ge8Rv8YrK9ygi85rjB15rfmcT/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736502710; c=relaxed/simple;
	bh=YmCpLUOtgNxRXbPgZ4YtvX7K5VKhb1LBkgxxWltv47o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=da9W2VYYaoR568HhpcAbV6c72YLgi8NP+SD+LydNQa2K8xoEdB3Jaia+lYpBN1BgumMH49NHxv1TvvzPQ9koQuZ7pj1XTV+EAuYCfAqa1LlLhmsr6hOGrADVxTRWz5pRQv/GdgsoDZ3fwCqWHs6UQue6l68gPaw7+bj9OT52Bro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BmTSlDQ2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kLp2l2KG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BmTSlDQ2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kLp2l2KG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50A9CHKB009638;
	Fri, 10 Jan 2025 09:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8Ak+qnEYaFOxwLuLpsEjH1smgBMPoT79q+3iR+zek8g=; b=
	BmTSlDQ2NZDABQkZRXuiTzftAdppclA/v5z8hihsr7Pi8PqJ4kdsdjAtxF8FFxBV
	v3LX9UmO/pfDXtVQSBTB9J3BUfQhJrD/s1GXJClfSFVQMni7AwJMhujMcHFEOfZG
	U0VfJju9TFrcQAKM2KeQrBEEV30S3oXihT5clYAJ1nntf8XrZabLoF3BeY4zLGQ3
	Z8pq60sBSBXY6x3kC38eL7mmJtp+ypgsejcsNbrwbE+LhTDipXvVyoWYkFFMSc8M
	GxCK6Lemp/5f0hb81OjD5aRvQNfGJpHJ5cU589SGMxxRicKGvRici0CMggSo9RAf
	ghu4xImn5Z+NlHiNWCNfQQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442gy5skmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 09:51:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50A7e8ga020119;
	Fri, 10 Jan 2025 09:51:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuejm3dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 09:51:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gwP6/Fm4VSmtlOwmA/nswZkdxvIoccW9FGw7zjMBEfSMQniM5obZlJhZlr6zVR2RIrkPV7bsjTIb9C1E/pBYx+MYuP+tLTIRFc0aaEmWjOJWukI40Y9Vmg0q1cG8lB5MGg0xGEY/68NC9qeeGupZhYWkV82dMY+XnnwzzjdAXQmt32Mv38NMnESZ6rszZ+aqt1VxUZQ76agDgBgOQAZRU/Y0joTtjxHqQThBBGYzPpq2HvhYmWNqWjp2s/PPMbL85j8xYGRPl+A2+L78D0oGpwLa6NsDXNdznnBPCshflPdIWU9Mxry/6BfqqtPh+4GXx0WRTlcdVpS92DndbGappA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ak+qnEYaFOxwLuLpsEjH1smgBMPoT79q+3iR+zek8g=;
 b=Qt46d1fwZf2iUyYLKtxZG/lJZP2eTGNRUYd1zJrMVsgZQ6AROWaEYcck4V5JOC+Wh5REw0aayFqYoke4he5z14MNHh71wxidBbsVG5nVdzyk/P9QO9bD2vb0kuXulIaUbkvMYwwkdI7R279Zcpu6Q/fsBLvR/VT25qz7fU5GODB9wuhZ4hSOXKAJMWptIcgzGQfMXd+khnd6fhxeY2tH+S7gbvXSo5e/7kda1JohOcirLGtHgF/h5jaddAKVzLKJIkrL5uvfvddfWO9zdNDd9Z1m2B0QzEfIZajd9Ap2i2e106MbHDocLi+sGPmNnedtLToiGb8yC64PaGPy0liPsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ak+qnEYaFOxwLuLpsEjH1smgBMPoT79q+3iR+zek8g=;
 b=kLp2l2KG+KYUuNE4Z8tL36ZxtDcquHYlH0ccymHpyxwNefBGYheDNIEr/CzVFCJh5Kb1c0XJy5UXZZFedP2rolzz5wTCI3qAN/tnKbWQlcdK+xxGNTr/RPG2axegnT50wnt2MTTQn3rYb/KI+nkNMXDYbYsuqXM+DtV29QVlLPU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7504.namprd10.prod.outlook.com (2603:10b6:610:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Fri, 10 Jan
 2025 09:51:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 09:51:22 +0000
Message-ID: <68cd5371-f4ca-44c0-8ac7-c734da04f877@oracle.com>
Date: Fri, 10 Jan 2025 09:51:18 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] block: add a store_limit operations for sysfs
 entries
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250110054726.1499538-1-hch@lst.de>
 <20250110054726.1499538-6-hch@lst.de>
 <e7177a33-aebd-4828-87b0-f790b4fb1306@oracle.com>
 <20250110091859.GA8373@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250110091859.GA8373@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0055.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: 27f72ec0-b9fc-475d-dfe1-08dd315c571b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V29kN0NZcVRRaXRlSVFremRPVU1ZZnVIdXU4dmU1b3hwRExUQmxsTlJMeUdu?=
 =?utf-8?B?UmdDNGNnSzlqdWI1YVBnbHNOdzBBNkdobkdyL3EyM3M4UzJyMzJHa3o1dzlC?=
 =?utf-8?B?QS9lR3JhRUlqSVNLcm5sT0R3eW91aFppVldjWG1FQSttNUFwMDhUQy9RNTJT?=
 =?utf-8?B?bHdweWpNd1BaYTlVc1pEQUdRTDBWT2cwVFNJamVDdmRxdU1wRVhJVVVLYWRi?=
 =?utf-8?B?b3JBUTJKbjFWWmpTajFELzgzayszZlZqQmc3bzRqbkVVbm41ZU5pQWFwL3lB?=
 =?utf-8?B?T25jOXJrNk0vbTlKcHJvY0ZQbWtNKzdvV1BOMlNnSTE1bVpmRzZJelZpM3Iy?=
 =?utf-8?B?OGw4a2V6SkdyVkc2TWJKM0pHVHB6UEJudVNyVEY0d0hqK1JuVnR5enNsQ3Vi?=
 =?utf-8?B?WFovRG54aktIZS9KVkcrZktHa04zclh3UmxzQTJmTG9mOW1LUzV2Y3dRRDJ3?=
 =?utf-8?B?YjNDVjh6WHZWM1dxYzU1VzJZSmpibzA3aEdad2txZ1Z2MTNpUWF0Z0hKM1lj?=
 =?utf-8?B?Rll6Z1dScGMybHhKampOU0VYanliQ2htZ3dEcGZHZDY3SWVuQm9wWVgzbEFS?=
 =?utf-8?B?T21QaTM4Ny9KYkNCR2lvSUNOaWV6RXJhV2FpaXRsM0lFbGZMRUU5Wjdhd1lt?=
 =?utf-8?B?c0tpNnU3M0RnRjdGb29NZ3MwSEtSTnlkdUJKTHAyS2JvRUtJcGY1K0FzRTRQ?=
 =?utf-8?B?T3d2NlBsdzNIeEpqbE16WnZrRm53SFU1WmxuaFFETUJQa3ZjejljSExpRWZq?=
 =?utf-8?B?cENIaDdabWt2TUtvS3Q1UE1tLzZrbTBDK2RrVFdNNVkvNHd2MDRGMmh0S01V?=
 =?utf-8?B?NDc1SVBncmJkR01FMkVnZ2NBWExpQ0FGVVFvd0ordEwxMnp6VmFNR0R1WFgv?=
 =?utf-8?B?eGVjQzFTODlNazl3aDBFR2lBV2wvT3dDKzl1MWhycUdaMmtGRXhIUkRjOEc0?=
 =?utf-8?B?OElFM2pIZytlL3VySTJ5cnZiZVc5SjFFSEZ2N0R5ZUZsOFg3T2t4eU5memFV?=
 =?utf-8?B?QXRSNXlVcllVRFJmQll2bUpqcWFjUHZRa1M5VVhVT0ZoSGtjUXdSb1lCUlR2?=
 =?utf-8?B?b0VTTDg4K3Z5UGRydUJsME9ySmp4WFRGU3RvWXgzVUluNVhWZmVTelB0Vi9p?=
 =?utf-8?B?VXR5UjJRQUl5aVBOUU9BYUtXcU9DYUQ5Y3dFUU92QlpJSFcxUERZSFRMOHJi?=
 =?utf-8?B?aHQwcE80Z1ZNS05wU1k1VkRlV3F1SE54RDEwSEpmckg3Nk4wdkdid21Ud2o0?=
 =?utf-8?B?b3NCb09oTElKMnBobVlNYiszVlJPL3M4ZWNYeWF1TGhsYVhHcnNkUC9NaDhP?=
 =?utf-8?B?ejl5bXM1M2VldjhMd0syVmIrNFpUMjZDNFMyZ0dPeFJ2V0F1b3FteVZlU2xN?=
 =?utf-8?B?VlF0YmVzYnFQcUU2Q2IzSTloVHBkcDZuMjluTHFNMG9XUVRuN2ljVC96OXRS?=
 =?utf-8?B?T3AxOVVibE1NbkV4THQwRUZja2NkMElGNDNKeFFvYkU5WTNmMzd3cy91dFhJ?=
 =?utf-8?B?YjhFZEpHSlZINFd1aHhLVndkTVVZZEFmRVViTXVMSDFpRWhJOFhrYUZWRUN0?=
 =?utf-8?B?N0tLa0tPSlNmSysyRjBYT1R4NE5nRG8wM2lsaWtuZlVFM0svOXhEMjhxenh5?=
 =?utf-8?B?MmtHS2l4ZStzMFcwQmx4Wm5VdlNBTlBkZU9GQjFQSWdvbFh1MEF0MDk0ZHpi?=
 =?utf-8?B?QnBMblkrWXEwNVRBeHE5R2RNNnhNd0NONExHOHFlcmZ4NXpqeU04aG9PSnNG?=
 =?utf-8?B?UnJGNDZMRDJyMXJ3WnJNcktFNlRocW5WUTNnL29zYkxPQitibndLTVBLaHBv?=
 =?utf-8?B?VW5TZlNqdk1rdlMxOEF1dVZJYkQ2cEt5WERtK05oMHBNN1hVb0F5Qk1SYmpl?=
 =?utf-8?Q?bdkZPKi+Ycj8Y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VG1lV2NSZ0dKdTVDaG00QiszdDVDekcyVDV5L3hFQzh4ZlpPNE9CUmJ4QXlB?=
 =?utf-8?B?UDFlakFEZkYrKzU0bXRoRXgzTnlyVDhNYnViOVA4R28ydHdiYWhvRWdFMys5?=
 =?utf-8?B?cDc1WXpJdG40MHVkaFRFeG9hK0FsVTJZdTR3QnlsNzUvTW80U2hPOE80OVFR?=
 =?utf-8?B?L2xoTHkyT0NDMFlKTEV4dVlkaVJpN01GL2x1U2FHQkI3MHFSNkFLcEcyVHli?=
 =?utf-8?B?czljeGdlaC9vTXZiK3daZFdhUTRadUNXbkdyMkZJd2FCVS9nTjMrdVkrK2FX?=
 =?utf-8?B?WGExdy82TGpQRTE3Y052TkZSV0ZZZGhyWFlrYTdvc1U2UU9oaSswclNPc01O?=
 =?utf-8?B?czBMazNMTVgyRlc3d1RqY05SMWlac0REZkpXdFBpbGdHSUJ0SXFtaHdBc0R2?=
 =?utf-8?B?UVJMZ3F0VlA1MmJiSjcrRDdudjlSUWlWUkhFTWNWeURrOVQyS3lHOERIK21u?=
 =?utf-8?B?dWtVdFhOYzUxSyt3ampmTEJBbnduRDFJeXRZY3BUaDlaZ3VPd050YWRJLy9u?=
 =?utf-8?B?aDhZRE5qWWpCVy81b29kNTRzMUtPUVFkc09FRWhmVjdiQURrYnlCcmpYVkx3?=
 =?utf-8?B?REcrcE1JODcxcTNrK3k5Mm04VVNJTnMrM3hOZUlhaWQvWHVJNlBEUFVwWWFZ?=
 =?utf-8?B?QWc0Vm12REdzK2t3ZVVhS0NaVThRYU1GU0dydTFsd1JTbTM1WEN4QzNSZ2tW?=
 =?utf-8?B?emJhbm56Q1dJNXJaV2JTWE9aM2pwRHB6blVURk5KKzAybDV0N3ExWmduS1c0?=
 =?utf-8?B?MU1iUWRpZlQzYXhxaWFUMldITlFWYkd1ZzlvY0tFcFppemhGVkQ3MWg5OGg1?=
 =?utf-8?B?cXdCOHFPNDQrQjFCeVlNRnVJSmJ1Mkt4Q3FFbVZaVU1LZFFGVFJiY3lhdGho?=
 =?utf-8?B?S2VPUkY2WS9kZ2ZQaVdEZGtKYXJIYWEwUXE3cEliZ1ZJVzBzY1c2eWRSOWtD?=
 =?utf-8?B?VC80cXE5TVQ1bzFDU2hXemV4dDRPQ08yVGZ4S2x3bXh4R3FlN3MxZHd1aXJK?=
 =?utf-8?B?TFB3c1VSanVOemtuWmZMenB5eCtTRkErMWgrQnBneWplMnU4U0UrMHdybUEz?=
 =?utf-8?B?QlVLL2p5MXRyK3JMSGNIbGY2NTJQMGFMQ25Pc2lNSis5S0UrMDk5MmhOU1B2?=
 =?utf-8?B?QVVyYWZmdmhYRFdrUjFtYjV2U0ttZkJ6SCt4bDFJWmtWcllJaW9tU3VIYlFk?=
 =?utf-8?B?YS9qQWdHOEpFSW0vd0NPMFV3NXpKV3pwWkUxVTQxTFJtanFHZ0VnS2s4NmRq?=
 =?utf-8?B?UmZZOXc0WS8wa2dyU2VXWisxb09mVEFSRENjRDJ0K0dma3JTalpTRnc1TUFW?=
 =?utf-8?B?bCtmOHhpdXJrQmRQNmJVVkYwN205QWNvdG5XeDY4L0M3WlIzb3hUS0MyTXR6?=
 =?utf-8?B?bGlYeFBvcmdqbEFKMkFRb3RqR0JkcDc0WkVUNUFqMGdMd0l5cWM0czI3TnEx?=
 =?utf-8?B?RTNic0FpQnNkSmFGbkh1WFZ5cGMybkFPQnpPOXJKM3JyaU9PNVlzNVFsTGJW?=
 =?utf-8?B?V0xuVmFiaFhvRDI3eDFQZHRGUUJ5Njh0cVlGdEdGWStBb1VDTWRVT2tFQ1Vy?=
 =?utf-8?B?b2p6dllKcmNUTDZTQzFqNTRnbFNFQ0FkUUxQWUJKUHpjeU9GVXRJakxNMnVB?=
 =?utf-8?B?b1NiNUUvVU5JMjk0S2VqVzBrZGRRM2lFZVRWbG95TDVmUG5oK21hRjAzOVVN?=
 =?utf-8?B?eEUxWVlBVTZMdkx3U3liTWJnQm5ENGwzU011S1RaSXE2TlFHOVk1SUg5dEJF?=
 =?utf-8?B?Z2NkSFg2WnQ4eGNJTU13TG90NjBwRFNBL1ZrVWtWcmVvMWprT1lrY0Rld05Z?=
 =?utf-8?B?RzdhVm55Y0NFeDBiT2g2eDkxazA2TE1TZExYQXZJY0NWemdFSlA3UnB3bE1Y?=
 =?utf-8?B?TmY1eFB1SUlrM2xhbHliU0FHUU9uZnNiOUM3M09nRVBLZ01YUjVKYmsrenhl?=
 =?utf-8?B?Q2lHblljR1FyN1BEbXBxS0luS0JnOTQ1NWc0MXJUTHdobGVtajNuYjVVRTlY?=
 =?utf-8?B?b3ZqckJUdVJBNDVIQkZnalJxZ3luRlVzZTVRb283M01Ibm54bUdBVGFkVUEy?=
 =?utf-8?B?elBiV0VidmhEczZpbFZYREFOaWJuaHNDUmRMeHhkRTRiOWZYQzNzdG1vWUpx?=
 =?utf-8?B?Y1RjQXJrTjlHRmliVnlUM1NpZ2tXTWhBOW92WjlzNHduMklTcjBITGp1bnhi?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BQkA3ek4Wp6kIg1RAHSTFo+cKUFuTCbLFlWPlcPjK+mB+yMgLzPX1O9uoCMLDR/LibZxgC+swG5LR3mCj2VIwafRwWytpfU69dXE61bYI9eC6yZvbhwZkQ4t4aC4jgSTfjyFoxkZHmMW9JZycUYchoef4Slgex0QGqdO9VhlA6VYwTEOEuGLZbWERX7ocKNxsKtn6esAkK2ws1IDRoe0s8jjRn8V507QAZ38/zcDhsZ67uEpb88hMe+bmTu7uP8PlMv92i7yWn8QXNRFJiyQJ4kbr0NQMcXaAaCh4iBFz9BDjLtOSQ64qBws7/mvcq1ftX4yhv+OUHozGHIqpPttiQ6EEcqhD9i7TK+WlsVs7cmr/fJw8sdzuplV0TwTuvn9LbQYnSgM5Bmr6MtuxiMKKU7SYAAtjeQQrD0CLA7AMp4k3pyr9oenyilFLVzr378xAY6vXv0n4Mrbm606uuAMz8SZ3Z6O30aUnfdQf3KtPAqAnaL+IdhfuDLoJRQ1sY9AceD7IzVlcisP6JvNoloIGTmGDdlXCADnmXH3/pMnCHDqTCfnaFpoVdxT80xWv3UHwBPtFN9H0UjtQx6Qpz3u4MAEv7eHFTgsxvvC94/XmzA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f72ec0-b9fc-475d-dfe1-08dd315c571b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 09:51:22.6745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VdDIg34/LPWp2/69PCkOxva6LSG+RXuC9VobZDnxvJKv54aF9H67Sv/ayLQwa2+/14kmg3Tcjegn3DDAfntPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7504
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_04,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100081
X-Proofpoint-GUID: vmoiijcdikbYYYQcErAjYUfSDQCyxcjF
X-Proofpoint-ORIG-GUID: vmoiijcdikbYYYQcErAjYUfSDQCyxcjF

On 10/01/2025 09:18, Christoph Hellwig wrote:
> On Fri, Jan 10, 2025 at 09:15:09AM +0000, John Garry wrote:
>>> +	int (*store_limit)(struct gendisk *disk, const char *page,
>>
>> I don't really see why this returns an int, while the queue features
>> callback methods return a ssize_t. I know that the res variable in
>> queue_attr_store() gets mixed with an int for updating the queue limits,
>> but I don't see that as a reason to use int here.
> 
> The normal store methods have the annoying calling convention where
> they return the parsed string length on success. 

ok, and that just comes down to the behavior of queue_var_store(), which 
mimics sysfs_ops.store

I will note that queue_var_store and queue_var_store64 differ in 
behaviour here :(

> ->store_limits uses
> the simpler and harder to get wrong convention of returning 0 on
> success.
> 

understood, so any reason why not to change the rest (apart from being 
busy)?


