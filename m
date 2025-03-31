Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A11BE251;
	Mon, 31 Mar 2025 07:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743407481; cv=fail; b=sYZw11ZgS2jG+D/idKQZvymtZtNYQJtNwB9J0BQ+xo3EL5wHsH9oosNKjuDyuLF35jb9kRd0I9pY5tE/ctj3689Eyj29FM/6COXOKaAs8D9s73fHuhtn8TLfzOsaYKL3Cac5MO74It9LsSrK8a7OGlRmvkOuPMh5IEIir8OARXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743407481; c=relaxed/simple;
	bh=dBo1Dh8PAQilJVGfmScUnIl3sgaraJqsLhOSKj+31SQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mBiOQlUEpT8e/ivux9r+XplpDhrw0VdIQ96BySc2c9M95KQ5H5Echytx68jSxt9LJmD9vP6wOGdct+0UefpmF0t9VuYPLbrRt/hpX2Ja+S8hvh4e7orVyEdQExmOvwkYPMcTvZcjS6DLo7NzspSCAaQ0IKanMKJki+F3VqXJkf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xwk7puH4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r4a9SJQz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xwk7puH4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r4a9SJQz"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52UNe2bd029299;
	Mon, 31 Mar 2025 07:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=BimnWQ5PlCeNIucpl5pARYg+C5uYuvVJGlLG0/iK0K8=; b=
	Xwk7puH45FzJ+ath6aChdkylYGSyQtEW5NQ3EPtlexLkFn0bOyjni0tE93iqyH3q
	P2HLo1TD5dxPxT+9Vw+wz/WVUxa07J+fHAIr2cOmBp0wMWn2jk3Hj+shTqs4EUz8
	9SwuuGGSiGy3PZsxfaFI/63KoPuI0sUD7YnVg/iqovwCL+fUEKkT0F2b1/8r3tFv
	qltiJ8VoetCQHHpyyjy5O5yPGOlK0CHG0goD1s+ZCwPjgIB4RFOKbS8RuUYofi91
	bUYDo2gkEyDxxCZcq+apgDp2sNMo+T/eUpB81oSTHHXF9MX6MfZxGktwKrZqapNb
	uuWzFXGXvekb5iYP3gRMgg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7f0aqvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 07:50:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52V69Ziv032806;
	Mon, 31 Mar 2025 07:50:20 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45p7a7n52m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 07:50:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a3yD3vcbv/D98dZpWp8KcwH6lmGYTA1t7dngc1GkYgJAitfsCWWBBI6wcv7eexgF9h9NypWWQGfFsyDSBJmeDMDjjg/c+8A/SGV7MI/7UFNT7w6AL7pk24Ajt6YyMkr+oEtDbzjVFRL8WWmzQm9vy2/z5p96JhLJagNW8fQMrzvjsken+fCF9GFXpmbkenB62ReDYWueWYHe55u/t1l8tLD/ee4NXDwXi0aMcNvZkduH+xz5qDaDgLs4sNpfLotJppffYwi1P6RIUqBdUCo6etBSeZ967pTRQ3UMWZt8niyf4eaYUbH++tZnlb+HZ+FJfBaerxJ6HiLcgK40lySJEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BimnWQ5PlCeNIucpl5pARYg+C5uYuvVJGlLG0/iK0K8=;
 b=IBtrOgX84kHaTFqRPd74D2eE2T+m7chgnTgdBCpVvp2NZc55cPdLMmR1zjsaP3E/myrEW6Z1DnNi4kLmbIkmmevcJ4rQxebwKf+OAMdgECqrNj0BAThs09UmgWQbFT2w/IwSpInl/kfQL37yfMlVMke7B2W4UgvfgoQuA69ShBZs2ieFigOGiECypm01NRn3N62yMOYSljhK/BAIIhyTPz7XvJMA5BV/gXNi1SKc6wdpBwfejIR2rvAShYooEq6+qlR/SLj9rBRRkTy58AMosZGTT3xObuu4UbnG+uwuvfgtRkCfqB7XZ0bLhGbacGkYXLD+TvqFXRcBfe2kp87TFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BimnWQ5PlCeNIucpl5pARYg+C5uYuvVJGlLG0/iK0K8=;
 b=r4a9SJQzh0B/3SM8/hwWdMno4sUmywvgaFDYH0pFCOta2sYjppO/2jWYil6JHzxSKA+iI/hDKOEReYe9tdLDJW7/taj89rvApePn3tBPVAiGUhSbD3DAoVoBm1cwikcJtuJh5XvQ7TLw2PcHzIEc5ZGcsz+S5alVAaVtb3WsEe8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY5PR10MB6141.namprd10.prod.outlook.com (2603:10b6:930:37::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.36; Mon, 31 Mar
 2025 07:50:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8583.038; Mon, 31 Mar 2025
 07:50:17 +0000
Message-ID: <b4fd7fd1-8929-43fd-8cdf-2a751bca9f92@oracle.com>
Date: Mon, 31 Mar 2025 08:50:13 +0100
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1JGQyBQQVRDSCB2MyAwMC8xOV0gc2NzaTogc2Nz?=
 =?UTF-8?Q?i=5Ferror=3A_Introduce_new_error_handle_mechanism?=
To: Jiangjianjun <jiangjianjun3@huawei.com>,
        Christoph Hellwig <hch@infradead.org>
Cc: "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lixiaokeng <lixiaokeng@huawei.com>,
        "hewenliang (C)"
 <hewenliang4@huawei.com>,
        "Yangkunlin(Poincare)" <yangkunlin7@huawei.com>, yangxingui@huawei.com,
        liyihang9@huawei.com
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
 <f35b2485-588b-40c4-a2e7-1bb65fb7a9fc@suse.de>
 <Z9uwP4axlXOSWxQD@infradead.org>
 <9740056c3b1b4da796d86e67cba4c292@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9740056c3b1b4da796d86e67cba4c292@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P265CA0031.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY5PR10MB6141:EE_
X-MS-Office365-Filtering-Correlation-Id: f873040f-730d-4614-fec2-08dd7028ad88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bSszQU5EVzBHMHFxYlhhUXREcC9PaUsrdzFoZ2ZtVTIwT2RNQVRmOXFTZDds?=
 =?utf-8?B?V2FSSE9GZEc0Qld1U3BFV2hya2pqbEpsSi9md00wSHFPK01xMEk5bVFoWU9W?=
 =?utf-8?B?eThtK1RHR1hJN1oyRDdsbUdHSUsvM1NjeFVCenZqdlNGNzRHYkY5K284aVB1?=
 =?utf-8?B?aVBtSHFpQmpOT2VsWE5KTGRORnB3TE13clhZbFgyUVY4bk1sUjFzQTZqQ1ZR?=
 =?utf-8?B?QllEaTFMRkVyd0o0RUV1QWR4TjlCZnZNRnF3Qm53QWpRT0JZajRhZXdtbzFI?=
 =?utf-8?B?RmpqZWxhSnlaRklCNWFYb2phVUVhWVdwVWIvdFdGdTZTbS9MYmVmdDhBR0hj?=
 =?utf-8?B?QXUyYTFJUTNrTFJ3NkdmU2M2ZzE5R3pxT000RklJSFQ5dXk3UThVSTRqOG9k?=
 =?utf-8?B?WnNHQUNWa0JvN0k2NlVqL2V0bU5PZHhxcXg3eTNMVW5VMGRVL3hJU0dxWU5T?=
 =?utf-8?B?Y0tiRXM3QjdvSDczM2I5TVJBeGp1bi90SkhuVWlwcEpGTHZGZ25HVGZ1ckxW?=
 =?utf-8?B?dkw0ZWlyNGNSOHdlNzcwRTgwdVZBWHVZb05FNUR5akhmNlIrWXFabUZ6ankv?=
 =?utf-8?B?SUc0WXE2UklKd2RUUElMZDRYdG1uam5ibE5NSnhUQ0FWeHFQblJCR2hCcjlw?=
 =?utf-8?B?bllJS3NrYVpESHErS0JEVkhsbzRCVi9nR1ZPSDRlZi84ekNNM01nOUYvVzFz?=
 =?utf-8?B?WWtPbUFFSUJ0SXdWcDlTYWhURnZSZkZ5N085c3pFc1hLVkk3WlRKR3BmZXNN?=
 =?utf-8?B?aGozUTFTODNFdzVqOWpGYnFXUnlNTVAzam4rRUhFMHlmME40dDFaM2Iya1Fi?=
 =?utf-8?B?NmlFT2R4dHdrK2p2MWdtSzdsRnEyb2Ftdkw1UlFCeFpPbnNXOHQ0bldmVG05?=
 =?utf-8?B?Z2orL2JLLzdpTUswblY5SVJ2OExoa21EMTQvMzZYRnFiMFpJaC9Jd1lEdFQy?=
 =?utf-8?B?bm1KaDBPVDFHV1NRWkR0R3Z3ei9lc1Z6Ymp3QXBPVlI5ZVJod0EzOVREeVZL?=
 =?utf-8?B?Nk0rcmtIMGVXeTlCRkl4RXF2anROcWU5Nld6Yk41RHFFdDRyTHRzWEVMMzBh?=
 =?utf-8?B?QXg4SW1qbi9UdFlBa2NUQlRwWnNaOVlLNzdXUVk3SEFWWThTbnpOT096TzlX?=
 =?utf-8?B?WGV1eVVtdHlLQklDVFA2UnpvM05vWHZSUjJoMUNabFd6NDdFQlVNbURnK0Iv?=
 =?utf-8?B?SkRwQm8xZUQrL1lrOVV2cURiMkNvcEtIRkl6aFkydm5UU05wSGJ3aU05Z3Mw?=
 =?utf-8?B?Znl4UEFCcjRmWmNGL0JhaVNkWDBuM3lXbDJZZ0R0NVRmYWxiOEVXalNlRDV2?=
 =?utf-8?B?QkVhd0U2aTNHbW5aVnRabzdKdUVWUlR1NXFqNWNnMGJUOWg3bVZhZXJuZkhQ?=
 =?utf-8?B?Q3JycTI2SktWT0NQM2xwcm5DUXAvUFM3ZThlZVMxQ216S2hzeG9IKzE4VFpE?=
 =?utf-8?B?S1lhdkgrQ1ptb1NDVGxFK3Vib096UTgvNXE3RG5VWlRqVkpVVE1YRHRLR3Uy?=
 =?utf-8?B?UW5qcnFYZ01nMGkrYmh3Vjl5dkkzQnBhd25sT3FvMlpGOUxRYWlnbW5rUTBR?=
 =?utf-8?B?cXdMZExiamVER0lzOFlRUHhMdkt0OC9HNnNGd0xxZmlFaC9tck5UajRnMExR?=
 =?utf-8?B?ZVNLNVFRV0FOMU1mYkZnclNxTWNXanRac2NNUEluNUVkNjNZdktsMW1pMUUv?=
 =?utf-8?B?cmdRbHN2aXN6NTFHUzQxeWl6LzJDczVOYlpVdUFOckowYkFoWjBUMzFjR2tU?=
 =?utf-8?B?NzdiWDJ5N2RtcE15ZjJldnV2bFE2bmVvSEs5VzZTVkZQNWFVNUhsTnVETGds?=
 =?utf-8?B?NDVVRGJ0Ti8vQ2F0U1o1UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEJ2c1QvdkhndzhBQkZPUHV1MlBVbmpnT0RvdG5ML3VSb3BwZmpQVmZ3b1hV?=
 =?utf-8?B?U2tHeVE1azNhYWUwdWt1OVp0WVpmVzZTSUc0Tm9QbDZFK1VGeWYwM1gwOU4y?=
 =?utf-8?B?RytoZFF3R3Z3d0J4UnVHQmNxdS9oUFdoUXhUN3IwR2ExTlhyV3FNbWtBZS8y?=
 =?utf-8?B?RUtoQVhPaHNjNTZaU0d2L3R6eG0ySExUS0dKdTZocDI0a2hPQUpKUlBYcnVY?=
 =?utf-8?B?cW9jL3Q0V3RzUWNWVG8wMzQyYU5QMnpRNWNxQ08yb21ydDNuL1VtSEZOUU1t?=
 =?utf-8?B?MitXemM5YmdLM1dYY0djNjVDMGJ4dG1MNWprbDFEc3BSZzY2TEphSm80Qkcw?=
 =?utf-8?B?SG15ZFNVRjhnRStKYUxrdGx1TTQ4UEwweXovOXVUTHVsb1RNZ0pOWVR5SE5W?=
 =?utf-8?B?SHFheStPS3YzVUVaMko0TGd0WE1rZ1pDelBkS0RtZGJ0d3N5MzhkdFB6NUFZ?=
 =?utf-8?B?WGRoUmlVS2Zvd3NXTmtJU1hocUhaMVpCZmRTcHdDdDRteityUENlY1VkTWNZ?=
 =?utf-8?B?eHpVWkNiTWZvd2Z4djJiZlN6MHhLaFBrS2lwYW1WUnVwUnYrSTUwTnVGSm1X?=
 =?utf-8?B?OTRaQzZEUndySWdZc2xuVDdOSVE4OVBLSWxqdEVtUnR5M2Jvb3lLU2tyNUpr?=
 =?utf-8?B?WGlheDJDZDkwYTZJYlJLbjhTbDc4Y0xUWWRmeWtQRnd4RGdXQXJIbzJSOG1t?=
 =?utf-8?B?WFY3Z1VNaGlibEo1ZlZGMlcxQ3kya2lBcGhsbklLQWNwdldZVWhsUTBkZ3Fx?=
 =?utf-8?B?OHQ0S2RmdFBBQ0NHeFZ6SXR6SFg0M2ZPU1R0a0k3bkdzTVdyRWFNcjl2YXlS?=
 =?utf-8?B?dTEwT0ZnUzRPM1IwbXBIK2hOaklVOUVZaTc2UWdGM1JRdHJ3RVVRR2srTDln?=
 =?utf-8?B?d2psRjJUd2VvUm4yNU85WVZQV0d1MFN1Z3NVNTNXYm5oOVNGeVc5QWR4QldS?=
 =?utf-8?B?MU9ZcGpZTmRXa3Y1NGpKRVNzY3pwa0hURXRvN1ZrRVI4MHhmWXhzbnQ1OWdV?=
 =?utf-8?B?ejFWQmdGMm00aS9mcWh5Q2JzbDNUcGVmZ0l3Rkw1bHU4eE9LeU5IdFhOeGdl?=
 =?utf-8?B?aHVsRHg2WnJtcFhnRTFISlg3UnFIQUVuS3NYVkl6TGZmSmlKdTBFb1lIMUpW?=
 =?utf-8?B?ZHY2ZUFqOERsaTRGdGZ3by95bTlZd3FyVE8wOUtldDhRVHpHbGZPYXZ0TFNQ?=
 =?utf-8?B?ODJtN2dNazdCcEpNWUMwa2pqeWFJeWF0QTdQaTI3NjVFNTVrSFFvQzJid1pP?=
 =?utf-8?B?Y0tpL0Q4UkRtbkVMMXZ3eVJtYVZJd1daNFI2Q2FxVXRPc0J5YVJMWWZvTDZR?=
 =?utf-8?B?SkRwTjh2TFcxRnJrakZoNDNzbmlhWGJVN21lck1OTDM2cHhQZ0ZQZk4zeHY5?=
 =?utf-8?B?TjIrMzdRYjFPSXZ1STMyc1BRRGoralJoTnQwWmdXTDRHMS9SdEJvNXVoeUhJ?=
 =?utf-8?B?YkgzaGdxZVphNW9LYi9pZHFpaGZpREpMcEhkYTZkL1FQeStpSTBHaGIwQVYv?=
 =?utf-8?B?TnU1OWtSVXpuc3FYWHo2OUpLZVovdllsMHp0M3RnZFZXYUdYNkU5VWgrM1N3?=
 =?utf-8?B?WlpzWmVTTTNYNDZ4QjlydW5Kdk1hdW15bVNRYlpPVWxweVpWR0pDU2luWUFZ?=
 =?utf-8?B?Zk1nTFhIQjlmcCt6eHNzOXZuS3htUTE2YlNyTk42YjNuaVMxS3JBWWhxS2VD?=
 =?utf-8?B?QWV5YkJLYkJGcmtKZ1JEL05mT2I4aUx3YWJ3R3h2M05lOTFDeVZPMmxNd0hS?=
 =?utf-8?B?ajEzWnpIeGEvTzlrZ1JtN2xUdVA3ZGpCTzhheTBWeHVrVmtBRWc1SDh4eDhO?=
 =?utf-8?B?a0FQTEY1SCtob3FwVmcreVFxNWZKNVVha2FrRXV2Q0duOUxyM1liZGZabVpk?=
 =?utf-8?B?dHY4L1dPaXdLR1dUaVRSckhUTEFVREFOa3lFVlIvQ2x1M2NSazA3c212bDh0?=
 =?utf-8?B?N0Qxb2ROcndCNXBJZTJmUzgzRVBsUzdnRnU5akxHSjUrZVNEc3l2NWRJSENv?=
 =?utf-8?B?bnoyMSs0WEVtUUwvRnJHZVlLSW14S1dseUcyeXR0N0RuV3hPUXFZKzhmZUkx?=
 =?utf-8?B?REVIaW44OWtLMDAwM3Y0RlpxajR3OTdWYkIxSVREVjdnQi9XdzJUNkNaak1m?=
 =?utf-8?B?bXE5SEs1cWlEWnBnd1Y1QkZJOXpDbTc5aStGK3MrOHZoRGhyV05ob015VWsz?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vd3TpFaTsnP2UgpOH24x5p5jZd+GRIqS/oKnJ8g+O5qiwkdBmRSTxu7Vo5ObTDSap4FL++8UwBLcmyP9EnxojjIxjc/wd+Gvda5cuyVggGJw4E4dWnYiPk/QrbhaJOBZjD1f+w4sCqXCRo6mGQmgYjN3o2KHP89Nd08ijNTr/kRDOHIndUOquExTTfsDAFv6MP0q7JYiGqwIngLjcRyg+LuoDvuDtitAtUyM9IEXNUIPaM+85xkLNrUG0IaipfPJug5PzyiKbzQ0Gud+mdNtRsDj/vn2tqGYUU6dlH/xBKpvnVT4oTQughLrG4HEdHl/eJPbQdmnbCf9ev8g1GhAZRSqnKLhTxj/VFpy2jAxsOB7ztK58K4+QCu9ojFUjr0P3QULp7VUa1++0q/NWI6PSUHkJiChcn8P/ASQ/19gJGUoK14zIEBCfYXIZ1lbLjz90zeFZtKOmfOU3QlhHgHokpmosuvrx5+9JaL6wQAwiPVz2vmEQ4x50A7QlEHnzjMFvLwCpA1mryZoTu93Oltq2vvTAD9xmeqdd/UlI0Dv1IzL9HMdqHikPtuTKaBFwsEbas62Y8yOjtkSJCnCdMkACrmuK7fBXozqrfWAE2b4tZo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f873040f-730d-4614-fec2-08dd7028ad88
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 07:50:17.1258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSepJN+YCTwZUTcWD2aTngRx9uKLUgw62F59FMDkuWfUfQdaRwU9VK/QILoRVsDkrZCxsCrlJekaI3gQVamqow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6141
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-31_03,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503310054
X-Proofpoint-ORIG-GUID: 14m8uYn1B_zIySTlaqLO7Pd5fulCbhsD
X-Proofpoint-GUID: 14m8uYn1B_zIySTlaqLO7Pd5fulCbhsD

On 31/03/2025 04:10, Jiangjianjun wrote:
> Sorry for late message! I'm working on fixing and testing these issues before re-emailing.

What are you actually working on?

It seems that Hannes' "scsi: EH rework, main part" series and maybe this 
one can help resolve this following issue:

https://lore.kernel.org/linux-block/eef1e927-c9b2-c61d-7f48-92e65d8b0418@huawei.com/

with fix attempted in:

https://lore.kernel.org/linux-ide/20241031140731.224589-4-cassel@kernel.org/

so that we don't see "fixes" like:
https://lore.kernel.org/linux-scsi/20250329073236.2300582-1-liyihang9@huawei.com/T/#m80bcb3f57fd176b7ce41b1f26e8560de6ad52c9d

> 
> -----邮件原件-----
> 发件人: Christoph Hellwig <hch@infradead.org>
> 发送时间: 2025年3月20日 14:06
> 收件人: Hannes Reinecke <hare@suse.de>
> 抄送: Jiangjianjun <jiangjianjun3@huawei.com>; jejb@linux.ibm.com; martin.petersen@oracle.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; lixiaokeng <lixiaokeng@huawei.com>; hewenliang (C) <hewenliang4@huawei.com>; Yangkunlin(Poincare) <yangkunlin7@huawei.com>
> 主题: Re: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce new error handle mechanism
> 
> On Fri, Mar 14, 2025 at 10:01:40AM +0100, Hannes Reinecke wrote:
>> 3. The current EH framework is designed around 'struct scsi_cmnd'.
>> Which means that the command _initiating_ the error handling can only
>> be returned once the _entire_ error handling (with all
>> escalations) is finished. And more often than not, the application is
>> waiting on that command to be completed before the next I/O is sent.
>> And that really limits the effectiveness of any improved error
>> handler; the application ultimatively has to wait for a host reset
>> before it can contine.
> 
> And someone needs to get your old series to fix that merged before we even start talking about any major EH change.
> 

