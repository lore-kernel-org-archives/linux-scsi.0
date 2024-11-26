Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546FF7DA68;
	Tue, 26 Nov 2024 12:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732623709; cv=fail; b=QZsQXajU3WlEg7vUgtMLWB1xBR6QD6mjfR/THEKtcQ2H3AxHX60hjaoNZmQt/G6pdP++1b1ewpEbG9vBJOg0sPPFwNabycfFO7xYbgLMKsTrt6YAE8OAZutKvIjE9+AUh04kmEUBYhPxxe26MhLxWPf21O3072fxifKANXLtMpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732623709; c=relaxed/simple;
	bh=0gNn08PMqW9sowz9KvKzZH9rkT2319/GpA0k5oQXdZM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ee13IPxF/plieHZFG3lEjm0iFscUKRWpwz4qojtdnQ72JvQxZBVQ6A3kQp7Cp3l3TwI/QAmRcZb0Gn/oE8wkHpH1ofJpVLwZNeG/ftXFJQWjaDwVE8pcoKYDxd2PFRPLOXnUpcgNmd76W1w42nU3ODMd5tCHfYJB6y7eBnxMmqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UTUtdyfr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ekjBDWBX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UTUtdyfr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ekjBDWBX"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ1Mjq3022255;
	Tue, 26 Nov 2024 12:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=o9ZxS6h0t5d/S9v0FEIH3IKDOQlXCrypqzPev7inZMA=; b=
	UTUtdyfrC+kSbAaoRB5JaM94QnQ4iD8lQnoGGXdMhUpIstgXqpieDcR/UoWU2yuS
	ugEdHqQKp7X+CkPLk/mv36CLMyw+ttTzdCm2xUbHAJoE77oZHgf7ic01To3PWx+o
	PgRkn/R+0ftKR4pZAjSZoIhauzfun0nSxQb3+fNbJy6GqAST+ph0+KKPub5nyXVx
	81nmEowy7+Nh3FhGfNPXXpX9I6LqEHeNSc/t3fUNtXHCQAY46/5fV+earsWlOW1J
	9UORfhWzj/Wu3z8t9p7loiCqqroZkleR+o3X2vOcGLoDdgPlMjw4DmYdKqJaLq9v
	rnfXLCzWSuwpfRoIbVm3gw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 433874dbng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 12:21:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQAq52Y024301;
	Tue, 26 Nov 2024 12:21:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4335g8vshs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 12:21:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ec6MiTVD47nL0jEgiI1q1zJVh4YD71Fpx3ajZ/7FE2TSamt3K8BPK0ETEdgVff+kUxGYRg2d/3FqPemq/6/NIoVtYvpXnhTr/QbGjnWjA/5rS3D44xqiWbhIZUxa1bEtLgWWO1/5baOvM6CZ+jmDCjA3Xt3yH+OKyVBkXJhuaNpmcfbDIZA/Go+EnQZ26c8V2ujovfyYfZdio48BziS+4it7pfzR9E6BCjBA9uFODGYxrtxp/fPwVLxQjtpLIeBYg85C8qlEih19UpizgBqmZStuexa5ZYDSd3m6nOaPOsd+U/zZ9+3MA97Q/6BMF0iZWIXpEnlV52HPkY5md7QXDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9ZxS6h0t5d/S9v0FEIH3IKDOQlXCrypqzPev7inZMA=;
 b=hxogl+KSGHweCIDficwkoLe7popn5UAJUBxMiLYNZTjT3UYksWucNyoTg2h/84qVAl5xEnY6YK4DFpbS45ajdQUliAwxYa/pudnbFSPVSOZEMeK0D+9mJGdJDsi7IwigCPef9W54oU9GbaSkjmuMzBt+Eei7Kd5raTRLjS8ZXWjLRYQp7ttwdNt8zTyQoRa+hkTyMa2gmO7s65W1P9RMuT4HtIrZDxFOsKQCDMFCrIu1HwDbSRPkYyWkMh4ipEi4VO/RWsPIMXlidKNmkwc8Sw7NNZsh+kdFjfXJPHteSuXbkmuNKGCrAorng3IEKRV0mPy9D41S1N7kGAPjnmlQqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9ZxS6h0t5d/S9v0FEIH3IKDOQlXCrypqzPev7inZMA=;
 b=ekjBDWBXD+WAVmHB8pfQ81Iqnj0KcBEAhHJWlWrBXwEfMmjkfq8YnEfJK9kbEm0mDno/iO7aTzCn2crq11+oxUnT3MF0GIRmjnDOCDgMyKdfoTmCYi6MXkuy+ye5T2FKDeRlaL/bvgDee/hdnbMqeZD6y3NvrjeY13MatAXlslY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB6302.namprd10.prod.outlook.com (2603:10b6:a03:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Tue, 26 Nov
 2024 12:21:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 12:21:28 +0000
Message-ID: <7c95b86b-68a0-41f8-a09c-3cb4b06fe61a@oracle.com>
Date: Tue, 26 Nov 2024 12:21:24 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Don't wait for completion of in-flight requests
To: Qiang Ma <maqianga@uniontech.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, axboe@kernel.dk, dwagner@suse.de,
        ming.lei@redhat.com, hare@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241126115008.31272-1-maqianga@uniontech.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241126115008.31272-1-maqianga@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0311.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: aff1c4be-1e94-41fd-325f-08dd0e14da56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UktRRnMyZWt1QkJjNCtvTXZCZFoyUlFJRGl4c1d3WmlManRXOWlzUmp6RlBX?=
 =?utf-8?B?Y1NZUmFvU1o0aU9qaWQxY0grQXhSd1FkTWhGdXE4c0lic0Z1OGpFUGRSR25h?=
 =?utf-8?B?b05iT3R0RWEwS0JlMlpXbjdxVEtLM1dENFFLNW5wUDRaYjVhMWFZWlh5Wk1i?=
 =?utf-8?B?TEJQVUVrdTJSUVFpVklyR29GVW1Vc3cyaW9BaWlHcGhIemJlYTNUblV2R0ZF?=
 =?utf-8?B?K3ZKY2h0TXcxOGx0czh2LzBaVVhUb1RJbVJRNmwxSWhZQkc0MUJmZG1RMmRW?=
 =?utf-8?B?VXUvUVoza0lHTVcrMTNQUmpoOENuOG95b2djZDd2bGtZaDhTSlNaazkxK1By?=
 =?utf-8?B?QUZ4bUp2MjM3VEpzQ3BlbHc4UXMrWDRPRVpOWVBUb083cFYvU0NSUWt4cjdr?=
 =?utf-8?B?aXR2VDFmSThicjlmaWhLR3lPMHo3K2tLejJhNGFvblFDVE1uaWFObiswWHVI?=
 =?utf-8?B?MDNUdkJPc2x1WXF1NjFnMXpTM0d2b2ZuSjhWMWx4VWdjM0dzUStSVTBkRnYz?=
 =?utf-8?B?a0pFWnBGaWU4ZDZTeitSNzExaDRQQS9Va0tRaTZlZzFWdzF6L3pVZlFIeEl2?=
 =?utf-8?B?OEhmUWptRUdhTXd4SStMU0NMOElmdnhxdU9UU1BXK0hNRTd6dWZWSzIwbHpo?=
 =?utf-8?B?a3gzSkVKdnpDeTB3MWd6QWdOWmVlWnhHTlRkMHhSZDhUYjJWMXArQjhJUVBG?=
 =?utf-8?B?N2dNOUNOVmZFRjdqY3NybFk3aHJHRjRueG5VcXFsMWloNGtxdnQ2YXRRc3d4?=
 =?utf-8?B?eGxxS3FXdE5kUngzSkFaTXIvWTlQblVBU05qcWhYcG1tRXhXT0lvRElZQkQx?=
 =?utf-8?B?UnRhZ2lvZFRkSEhzTmNxNjg0anJxMWZYVEp6Vi93dkhkeTA5d0FjL0g0UGUr?=
 =?utf-8?B?TE41MVFScjhpeUpUdFlobGVNQ05Iaml6OWdnQTBFeE0rVGNCVDNSTGVYQXBj?=
 =?utf-8?B?aGdBNnZ3aERTLzB3YjBVcitWZUMyVURhMFRBR0d1OXRkUTBzcStSNCthVE1Q?=
 =?utf-8?B?UGFkQkU1UlkvS0hkTkRTQ1RwenFYeitNMURCbkxoT0hiMGc1d2d2UHpJY1N3?=
 =?utf-8?B?YlpPc2luK05RN0lYanpxU21DN2Rhc0ErY0YxSUc2RDAxbklzek1Rdi9mdno3?=
 =?utf-8?B?bW5MaGlZcktIaWZQeXVaek9WNzJwbktNZm5OYUNjVlhiUUtBdkt0dGpEenN6?=
 =?utf-8?B?UXBiZWViNWdYeFlQNU9qamJWWDJrOHZCRHJKVENid2NkV0gyWXRvQ01hZ200?=
 =?utf-8?B?ZFljRXF6YlpnMHFtVEVJcW5LM2c1NFdaVXpHcDZyZ0lXbm1WWmJnQ0h4dElr?=
 =?utf-8?B?LzY2ZUpHQUo0WkZFNS84Rnlhd01zMnRZMXc3R3FNdkRwSHFuMmtuNWxzekM4?=
 =?utf-8?B?SnkySlhUN0RSRmN3VXFWNndobWlIZjNyeHZGRGs4WUlGYU1zQ0xuRTBZRjZi?=
 =?utf-8?B?RFJjdjMzb2xQRWtMZGdWQXhoVXhhVGhOWUlxaklLeVJYTVBJRXorZkRsMldR?=
 =?utf-8?B?OW55cDR3VThqeURaQU1IS2JPWm5vcTA3QytyNVNkK3hCdjdxYVVKb0ZkNTAy?=
 =?utf-8?B?R3I1cUVLd1JCclRTSk5BNFpwZThxVW5sMngxbE81QzIzZFZMblFJWFA3WUhW?=
 =?utf-8?B?dVNjdnRiSlExQ3pKK2tQV1BGN1dUWlczb3cyL0N3TG5ldTB1NVFTLzNaL2p6?=
 =?utf-8?B?T0pWUTlNcXo1dUJYbTFxTFhZaWtsWURtSXluaXJrMFFpNkw4UTR5NHpDM0pt?=
 =?utf-8?B?Wnp0eW1yZm1FUEJCaWRvSDJXSUJXVEREZ0hMd28waXdiZkhmS2cyM2NTVVhG?=
 =?utf-8?B?Y2hFODhOZVZVUXh5V0xIQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVJtT0lrRGxVd3ZzanlZZVl4ZWtrOE0ra2Q0NzVMNXo5WnM3cFd5Z1NFYzVz?=
 =?utf-8?B?bUVmcERQa3ArOWF1ZTIxK0hJR1hjclliazYyelp2R1RYd004aGQzRHZrTVZm?=
 =?utf-8?B?dEQ1eDNLcDBLdnh3dldWeElOL2JzTU5ReE40YVQzdHFMeHVWdlhkOElmZXE1?=
 =?utf-8?B?RHEvaDB1d08yenc4M3JQU0pBdnpHc1MxSE5WVU02aUhPUE5oRkc5dStWNURV?=
 =?utf-8?B?RWpYY1I1bG5UU3RkWEdkcG8rOUI5d3RLQlJEdGswS3FiS2FMWGJuWk9hMUZC?=
 =?utf-8?B?OWdDVzVlM3R2azhMUm5VeGNUSkUxR1Y1c1ZEUWNhZWc3VFdOOXFxVUcybGhl?=
 =?utf-8?B?OU13YTNJbmhEQ0M3Rml3V01FYjdYTDJZTzhwOUlVaEVCeGkrK256dk93ZXZV?=
 =?utf-8?B?dk5Fc0JLVjBGRllwWWZMSEpUY0lvTDhzY21jSzZjbVp3R3ExYWtPWGFueVlR?=
 =?utf-8?B?OHFmM2c4NGtSWU01bHd0Y2JVOU1MbGQxMnNCcWJSeVR2MmtQM3J4SUE5Vmhm?=
 =?utf-8?B?K0FMcGh5eWp5aUdDZlFFQXhqUjlsZ0dMeEZZZmpvVEdIQ0c1RGcwSTNWNUlK?=
 =?utf-8?B?c0ttWnFuUlpvS24rdXdiUnRRS3dqTFVtWC9UNTVnVndjMFNMSlBreUtwS3Ez?=
 =?utf-8?B?a1ZIM3RIZWVNb1ZkOGltOWJTRysrb3cxdmpOaFNZVGVHSmZrVklnM0xra0da?=
 =?utf-8?B?L1hKZmNnc24yZmhKbmhnc2NNR2MwZVJ1OEs5c0doWFkxSXU3cXc4STcvQWww?=
 =?utf-8?B?d05OZks1MnhvQnZNZTdKUnNHRGk3d0h5QXEzdEg1SDc3TW54WHMycERIOE9J?=
 =?utf-8?B?cU1JeEQ4OThXeHMvdVlVRkFEcXdmOG5CVTJQejNoUHBzZlpFUEZtK0M5aTBI?=
 =?utf-8?B?R1oxdHVJRUJST0tCdG5GdlBUUklUV2hEeFlKTEpPOTkrYWl4TSt4WjBudTdx?=
 =?utf-8?B?V1JkbkZ2RmhiTWcwOTBYdFlKdk1rWUZiaGQ5Z0pSYTMxSWJtNVVYWXVRSStT?=
 =?utf-8?B?MjdxQzY3V0FyQk9NUWdGbytraTJTaFhabHpsZityUDNTcjVXUkRpVVVueU83?=
 =?utf-8?B?S3Nqay9lSTYyT1hJZjNyTTNLMzVaTlA4alh0SmNlc01vd0NaV0ZHYlgwK3pK?=
 =?utf-8?B?c0FVWGNKWWVYeTFXVkg2UG4xMUpqeWNWRzl0UUZuRTRiOW1meExBRFp4SUpz?=
 =?utf-8?B?ang0TTlBY0Nsc0xIZzFNSzBPNnZaWXd0NEQ1cnlGS1pHOUFXZk5PVWQ5R1Zn?=
 =?utf-8?B?WlVacFRrQWYrNUNoY2ErMk5XdS9rMEVobUM3UVdaWGc3c1c2UDhCRElOenZM?=
 =?utf-8?B?bVltTGkyaE9rTHhFMkZqRkFPaW1STDVrV2RJeG1Wb3paWTJVL1hWb3kzQW5J?=
 =?utf-8?B?Q1R4dFk4Rkk5bi9WNVBjNThvay9rM0hrMWdMSnNJRWxlcnY4TDZzbThnR1Vj?=
 =?utf-8?B?VWdkcG9GcjJUMC9RZUY2eldwbjZTb09ISUNZNDFpRkRFZU5FYmJpRnpmRnJC?=
 =?utf-8?B?dFVBZEtRSGtpQ2p6YmlpanNSZ0dVYzREeVZ2NDVYMnFkSHRNL3Z0UnhiUG45?=
 =?utf-8?B?MzNPRkp6TzE1K21BVXpzTyswU1JzU1FEVEs2RTJHWUYzZVlKVUhPRlkrVzNs?=
 =?utf-8?B?UWxBQ3I3TXZiRzFWWjhGMEppTGx2cFVscmNxSzVsTS9ZRFNVUTlQUkNwU3JV?=
 =?utf-8?B?RC9jdDJQTENmeWFVaTNpb00rQUJFK2JseldPSW5qVVBqQnZLMks0WVRnMitm?=
 =?utf-8?B?cFEyUDNuSEV1clUwdjdvNm52eUtlNWRVQWU0bHJqSzVXVHVRL3MzZS9HSE1U?=
 =?utf-8?B?ZHptSlZ5M2pxNVd2ZXNQQTZvSzBXeXNURzZDRnloNFZRVUNHaWswbEIvVU13?=
 =?utf-8?B?VmNCbEJlUGg2T1lOSkhVZmovNGZ4aU9tLzk4ZkllMXRpdnVrdEVlQjdUL2N1?=
 =?utf-8?B?d1pwQXE2L1duTzZrS25ZaUdWWS9EMWM5dkcwS1kxcEdaMTN1RzhrcTNYTnFH?=
 =?utf-8?B?VmU2TGQyNENnZVpWUUNrSXJ3VGVjS1ZQUC9WenNyRk52OFNISldFSndValJC?=
 =?utf-8?B?a1R6bE1FeHluVStTdFg0Unk1YzlNbnBKQTAwS3FQSzNyampQTFBCVmNvUzN1?=
 =?utf-8?B?T24wbndKSVhVWnp3MlJWTnMvOW14LzJjNk42N2tYei9mVTQzam5OOGtCUEhq?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8EJL1d9FMOAaAAwYzFcu5F+E5TqEFvrSdmdb4w7ght33ra1bNDmrGFBlCqByTVOzjsYOBqn1b5CyCphGfH8olFCdpNAjMXfcxCy8/H/8d5LtcIZu1hH1fX6vElJYooVYgki3fSmT62CDSGAM5oI2mn0ocLlfOj0PQjptJDpeMy0W0MqxWUKXCJNhDopcYUyO1ae459nA33A9bs06kMxqD03pOpe+6RN+6KBE6WtA6KCCkauomyAWGBPxfu7Rq+OlYN0yzMz9aLnEDqwir0mN6kKNJtDIhlHyP1m5EMz6HnOzFKRM5gKLBkaRH2WhT2rmvG/VxAYQDs86/o6bYK7dOZoA4+KoUnSxJmmxJAd5pc+db94xncoWJI7ZqByZsDwrbaKhj6ZthpRpz4U5J3lrMG/lrws0HbWPy+qGwIeeXQWm5fc8gPaEmWx0/56DmTrSJeI+oTetIjVt7nB8eIQATyjYeX6ujXIwAkw2/yBHyYKU/8rBlICi+pymM2BdY7GQmADFyVSXQwxJY2UeiKEsE9N0nyCr6di+EZX69+yV6tBGtvk9DNopRQBor/g1T3+z/LhjylEzfdViP+BESZFY0yCEhGlN/KQBTDYstGa698Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aff1c4be-1e94-41fd-325f-08dd0e14da56
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 12:21:28.4240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PoARfYDdU6iSh0Dp8COh3agghBGlofD9mqm87I877nE/iIR1glzRtNQV/4NTas/Hi1TqC/dC5s2dnWkaw8zoMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-11-26_10,2024-11-25_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411260100
X-Proofpoint-GUID: cxXE0S5OhphDm3HTf8eGnGcUjrSyXyev
X-Proofpoint-ORIG-GUID: cxXE0S5OhphDm3HTf8eGnGcUjrSyXyev

On 26/11/2024 11:50, Qiang Ma wrote:
> Problem:
> When the system disk uses the scsi disk bus, The main
> qemu command line includes:
> ...
> -device virtio-scsi-pci,id=scsi0 \
> -device scsi-hd,scsi-id=1,drive=drive-virtio-disk
> -drive id=drive-virtio-disk,if=none,file=/home/kvm/test.qcow2
> ...
> 
> The dmesg log is as follows::
> 
> [   50.304591][ T4382] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [   50.377002][ T4382] kexec_core: Starting new kernel
> [   50.669775][  T194] psci: CPU1 killed (polled 0 ms)
> [   50.849665][  T194] psci: CPU2 killed (polled 0 ms)
> [   51.109625][  T194] psci: CPU3 killed (polled 0 ms)
> [   51.319594][  T194] psci: CPU4 killed (polled 0 ms)
> [   51.489667][  T194] psci: CPU5 killed (polled 0 ms)
> [   51.709582][  T194] psci: CPU6 killed (polled 0 ms)
> [   51.949508][   T10] psci: CPU7 killed (polled 0 ms)
> [   52.139499][   T10] psci: CPU8 killed (polled 0 ms)
> [   52.289426][   T10] psci: CPU9 killed (polled 0 ms)
> [   52.439552][   T10] psci: CPU10 killed (polled 0 ms)
> [   52.579525][   T10] psci: CPU11 killed (polled 0 ms)
> [   52.709501][   T10] psci: CPU12 killed (polled 0 ms)
> [   52.819509][  T194] psci: CPU13 killed (polled 0 ms)
> [   52.919509][  T194] psci: CPU14 killed (polled 0 ms)
> [  243.214009][  T115] INFO: task kworker/0:1:10 blocked for more than 122 seconds.
> [  243.214810][  T115]       Not tainted 6.6.0+ #1
> [  243.215517][  T115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  243.216390][  T115] task:kworker/0:1     state:D stack:0     pid:10    ppid:2      flags:0x00000008
> [  243.217299][  T115] Workqueue: events vmstat_shepherd
> [  243.217816][  T115] Call trace:
> [  243.218133][  T115]  __switch_to+0x130/0x1e8
> [  243.218568][  T115]  __schedule+0x660/0xcf8
> [  243.219013][  T115]  schedule+0x58/0xf0
> [  243.219402][  T115]  percpu_rwsem_wait+0xb0/0x1d0
> [  243.219880][  T115]  __percpu_down_read+0x40/0xe0
> [  243.220353][  T115]  cpus_read_lock+0x5c/0x70
> [  243.220795][  T115]  vmstat_shepherd+0x40/0x140
> [  243.221250][  T115]  process_one_work+0x170/0x3c0
> [  243.221726][  T115]  worker_thread+0x234/0x3b8
> [  243.222176][  T115]  kthread+0xf0/0x108
> [  243.222564][  T115]  ret_from_fork+0x10/0x20
> ...
> [  243.254080][  T115] INFO: task kworker/0:2:194 blocked for more than 122 seconds.
> [  243.254834][  T115]       Not tainted 6.6.0+ #1
> [  243.255529][  T115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  243.256378][  T115] task:kworker/0:2     state:D stack:0     pid:194   ppid:2      flags:0x00000008
> [  243.257284][  T115] Workqueue: events work_for_cpu_fn
> [  243.257793][  T115] Call trace:
> [  243.258111][  T115]  __switch_to+0x130/0x1e8
> [  243.258541][  T115]  __schedule+0x660/0xcf8
> [  243.258971][  T115]  schedule+0x58/0xf0
> [  243.259360][  T115]  schedule_timeout+0x280/0x2f0
> [  243.259832][  T115]  wait_for_common+0xcc/0x2d8
> [  243.260287][  T115]  wait_for_completion+0x20/0x38
> [  243.260767][  T115]  cpuhp_kick_ap+0xe8/0x278
> [  243.261207][  T115]  cpuhp_kick_ap_work+0x5c/0x188
> [  243.261688][  T115]  _cpu_down+0x120/0x378
> [  243.262103][  T115]  __cpu_down_maps_locked+0x20/0x38
> [  243.262609][  T115]  work_for_cpu_fn+0x24/0x40
> [  243.263059][  T115]  process_one_work+0x170/0x3c0
> [  243.263533][  T115]  worker_thread+0x234/0x3b8
> [  243.263981][  T115]  kthread+0xf0/0x108
> [  243.264405][  T115]  ret_from_fork+0x10/0x20
> [  243.264846][  T115] INFO: task kworker/15:2:639 blocked for more than 122 seconds.
> [  243.265602][  T115]       Not tainted 6.6.0+ #1
> [  243.266296][  T115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  243.267143][  T115] task:kworker/15:2    state:D stack:0     pid:639   ppid:2      flags:0x00000008
> [  243.268044][  T115] Workqueue: events_freezable_power_ disk_events_workfn
> [  243.268727][  T115] Call trace:
> [  243.269051][  T115]  __switch_to+0x130/0x1e8
> [  243.269481][  T115]  __schedule+0x660/0xcf8
> [  243.269903][  T115]  schedule+0x58/0xf0
> [  243.270293][  T115]  schedule_timeout+0x280/0x2f0
> [  243.270763][  T115]  io_schedule_timeout+0x50/0x70
> [  243.271245][  T115]  wait_for_common_io.constprop.0+0xb0/0x298
> [  243.271830][  T115]  wait_for_completion_io+0x1c/0x30
> [  243.272335][  T115]  blk_execute_rq+0x1d8/0x278
> [  243.272793][  T115]  scsi_execute_cmd+0x114/0x238
> [  243.273267][  T115]  sr_check_events+0xc8/0x310 [sr_mod]
> [  243.273808][  T115]  cdrom_check_events+0x2c/0x50 [cdrom]
> [  243.274408][  T115]  sr_block_check_events+0x34/0x48 [sr_mod]
> [  243.274994][  T115]  disk_check_events+0x44/0x1b0
> [  243.275468][  T115]  disk_events_workfn+0x20/0x38
> [  243.275939][  T115]  process_one_work+0x170/0x3c0
> [  243.276410][  T115]  worker_thread+0x234/0x3b8
> [  243.276855][  T115]  kthread+0xf0/0x108
> [  243.277241][  T115]  ret_from_fork+0x10/0x20
> 
> ftrace finds that it enters an endless loop, code as follows:
> 
> if (percpu_ref_tryget(&hctx->queue->q_usage_counter)) {
> 	while (blk_mq_hctx_has_requests(hctx))
> 		msleep(5);
> 	percpu_ref_put(&hctx->queue->q_usage_counter);
> }
> 
> Solution:
> Refer to the loop and dm-rq in patch commit bf0beec0607d
> ("blk-mq: drain I/O when all CPUs in a hctx are offline"),
> add a BLK_MQ_F_STACKING and set it for scsi, so we don't need
> to wait for completion of in-flight requests  to avoid a potential
> hung task.
> 
> Fixes: bf0beec0607d ("blk-mq: drain I/O when all CPUs in a hctx are offline")
> 
> Signed-off-by: Qiang Ma <maqianga@uniontech.com>
> ---
>   drivers/scsi/scsi_lib.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index adee6f60c966..0a2d5d9327fc 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2065,7 +2065,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   	tag_set->queue_depth = shost->can_queue;
>   	tag_set->cmd_size = cmd_size;
>   	tag_set->numa_node = dev_to_node(shost->dma_dev);
> -	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
> +	tag_set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_STACKING;

This should not be set for all SCSI hosts. Some SCSI hosts rely on 
bf0beec0607d.


>   	tag_set->flags |=
>   		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
>   	if (shost->queuecommand_may_block)

