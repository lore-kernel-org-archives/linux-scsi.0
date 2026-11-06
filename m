Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793971433;
	b=PtGKaFDINtHFfCvoUVEL1pYRVhjrveiYEIdpfRv72Sbk3l5CqtO5mNdFm5lDgMWUabp5
	 /g/1gFuRXmtNx9Q5fFDRmVgyq4YSwFrrKAilvrNhSvucVlBFHJoCkZnzkW6xavuALhyv6
	 wJuLrXbf03r+aey7t+GbEdrBR1X1NaFDRG95sNRU3Og/loG1eIMu5oCTkhnK9Ekq6rJbE
	 mSG641TmR82La9AoSdzzRGq9gbcRLHEacv8sFeBO2xNLga962qSVmamSPn+i7eZBZIFTz
	 SVlyKN5qeXf/8VP073jEMWxC7Tnqgv2ZfnBXlKBU5F/1Tfu3nT7yeq393N6/HHwCtrQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793971433;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=fOmaNonFZFAaWHDxBB2Vj3hDQfjhHvYYDThqbDxY020=;
	b=chGW0Dz6a8N2HJw5Un/QOD1vSkdtP6hU7btbFrg3+8+/jlRFdEIT0P2khJr6Sc5vt3KO
	 LcqoM6BOHm0YpjOhZlEwqHAU91OVIpNNM5905hJIUsWGXexP8uGrWppmsiK8YeJ52I2mL
	 cmNPCu3cM3t2erMD6+2DLTUxGNwVB3XncjGWUCW6P78JlzoL93yX6ZLJ102i4CKwnT83B
	 zde3HMdnBZ0U6vJrVt9x6suCweLV00nWzkRMVPXLGuc8GXH8Q2Le/57TpK7Tv2CxJIvbJ
	 +IELxSdI7Dccr7btT95IebOYeSKe5KfzrkDE0NcZTuds425zucoClPb88GCYdVyCtVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=AwPcqUUP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.25
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA9C606A330;
	Fri,  6 Nov 2026 13:23:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AA9C606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=AwPcqUUP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kWMIi/hU9ezwW87sGioNr6QM7bmy0JI6cQhqZ5D3QWQOzzbe0efQFVFShmyHl/We3yFy9MguV1AlDvTk5dksXW+ENh2j5eK4OiBgP3XuH2aBnfL/gTmdzsqqlEAOEcUTBjsKhoLLSrdq5tjJlnNDTcfQt5Ct10SLkpBsaOliy/C2mOdUKpNrMX20Y2hy9z+Z+zz9UACtIOWLB1t3AfOWTYj3LAEWFBoTImex7faRzH66ERdcHLBWjT/+KNAcnKXGifkfWSgMmjK8nqj9AggGqzslYCLOf89XNSrCJP4fB1W88sG2UR8kcBH3EEocrjM9z0I6iMbrUIcg2gx8knRFPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOmaNonFZFAaWHDxBB2Vj3hDQfjhHvYYDThqbDxY020=;
 b=DgAtjcJOECbF6jaGLwurHAJhZa+dmgLIo/x0jVms5XPxQEv6QbTnXjzE42jWPF/kRbqqTQnZ5XHK61YOZDVc+HmM43npsYhmRBjr8s3co2lsnjKjK+zf7lfgkNDpqLO1BtrAgLkVgDLluiuFjkX80y8laJQiPVKvHmWd4+c4rbu1jPye2T/i1GE3SX4a6wqU8A83A1NwrZc6b2tSbyu3MZb/DjEuDFYWBnmvsoAZQfTKaE74VDojAeUkhL+vf6LHNOaytxUL5DmmJ5jxzx0eCEjhAIFJ1xmb4rl5GLNwoL8BTXAapFbCeP7otbvDsSFylenTaUuRvNhVaJBjkUtgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOmaNonFZFAaWHDxBB2Vj3hDQfjhHvYYDThqbDxY020=;
 b=AwPcqUUPGt8QeerqNG+fQJcUxT7oEb5Wgaeut5c6GpvYBAbnPY/oLxP0NA9oAZk2A9gXEO4Y9tZmq+0F4OzsCaLpjKKeTMBGFVq3UTIMnQhA6b2t91wR3G/qJTDoqHxUi4/bazLykj0oz59BxxBHWnYUQYpp3z+x25VCBOKnk3U=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA1PR12MB7411.namprd12.prod.outlook.com (2603:10b6:806:2b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 13:23:49 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 13:23:48 +0000
Message-ID: <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
Date: Fri, 6 Nov 2026 14:23:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to
 memcg
To: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org,
 dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com,
 jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com,
 mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org,
 vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca,
 kevin.tian@intel.com, axboe@kernel.dk, "T.J. Mercier" <tjmercier@google.com>
Cc: linux-mm@kvack.org, James.Bottomley@HansenPartnership.com,
 sumit.semwal@linaro.org, phasta@kernel.org, joro@8bytes.org,
 will@kernel.org, linux-scsi@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
 mathieu.desnoyers@efficios.com, robin.murphy@arm.com, mason@kernel.org,
 aesteve@redhat.com, tjmercier@google.com, harry@kernel.org, vbabka@suse.cz,
 cuitao@kylinos.cn
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-3-cui.tao@linux.dev>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261106131829.3228926-3-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAP220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::23) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA1PR12MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb6e644-f33c-4419-fa35-08df3c093106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|56012099006|18002099003|261026140227099003|921020|261021123027099003|261028144727099003|261021121427099003|261022105027099003|261009223027099003|261022075727099003|261026121527099003|11063799006|4143699003|10067099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	yVehWQxb23fNlY6cZG25ymaM88tPsb0efFJ9cDoqVjMa1yq6YQlC3DHWB5GcV1dfNKuJsEZOUZwoRMqfdNT0yjZc4WgoA8w6dJGqxcYtpSFEWZv/a6leh3fJiFrVULWVxELiV0pEOCEm/7pgyf6R7I8cg+2wIvBwd9kK0H0Un+nDMLLRT1fc1C443DobJYnqW9Syv9toX4Wr4R8hB/W21Yj/zUi+Enf2Ao0QNb7K2wpdd2osMTBPwzjZHe5vIGVWYoN81Il3178JEx7U0ZqTPE4dsYVr00VSwnUl3yx/Z6jqvSfQ1Ap62w9VdN7WI9cWHaqbJodLbRTpV1tD6+FQ78MR+jyLJolacV7ZVv2HWdRLDrPBmRTqO5Gg0a8cRc5o9fDwyLf3qD11kJbUdcEtFHbFnVQZ0iDIOPyoXTBfcETF/CB8eLJhWnMeqdvknJTTjXOEyv4jYvCgU0ols+Hxai1VYchrYrnIFv3qoj9MjjWwMnp4jjTL9bZvuMqDvokxmViuajtQ11eAu8TI96oBz2eH5YQ40Ag1rL9wzK7wt/bp4dQ/KoA3oD+NfKRakGLHS1Ir74MuHjjfofrm3oGOE3d5LQoUyWumTcdCpUMQ3lXxBErpfvntHHdkLQvU0QMvGGPFI/L+FvZETGK9fd1FXGi6N4qjtbukvWx3dHIus2GCCW8fXE1x90zU2IbZprDTxZ4yt2FdiofLeFmJjDtVfQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(56012099006)(18002099003)(261026140227099003)(921020)(261021123027099003)(261028144727099003)(261021121427099003)(261022105027099003)(261009223027099003)(261022075727099003)(261026121527099003)(11063799006)(4143699003)(10067099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzhZa0U0STZpYXhyM29HWnQwYjAzdmpodG9OcXpYK1QzWnppVDAyMk1ENmkw?=
 =?utf-8?B?RjJ3L1dRVFcxTjRHekdONkdrY1AvdDVickFQU3Bac3BQV3NucmFLcklrZ0hj?=
 =?utf-8?B?NHF5VjhaRGJCalRGbWdQaExjZEUzSnozajJabUhBdmNIUTVRWVk3YmNoWXRz?=
 =?utf-8?B?TG91S1EyOTd3M0p2WCt1QlE0alhNei9TM2RuNjNRQUNBcVBwVUVZd2NoSFBs?=
 =?utf-8?B?SjNKV0NpSFU2QWNGamc2TUplRjh3T3UxOWIxbU4yZUxSK05iOFhtODl6bUtO?=
 =?utf-8?B?L2hBL3RZa1hCOHZvWlRUNnNvejBOOVpvc09oTUlhKzNJUGdhNWsxRnBkM1dI?=
 =?utf-8?B?V1lqRFFYa29MbVcwR1Z4ell6WU1LZzdmak1wcTJISmpFVmpSSUhyNlhMM1Fs?=
 =?utf-8?B?UDFBcFZBa1BXemE1elJWelVyNUJYc0FMVWtkRmh5cDByTEl1ZEUzUldiL0x2?=
 =?utf-8?B?am5hYmU2NmRRbzlJTTF6UTVReU1NZGZFd1pCL2hWOHdpaUs0bXV3RVl4QVNa?=
 =?utf-8?B?MUpDTDBqeUdTQldhOGFxbkRrWGVxTXVKSmlVSS9GRkJUcllqaDh2K3pDWkZZ?=
 =?utf-8?B?MTQwQTJIcVdha21sdkJUVnZpR0NLdWwxdDBHRkk0ZmpJN3g2c3laQlF2bmM0?=
 =?utf-8?B?S2dDWitxM2QydlV1WTBxYUx1TTVUOVFZcnUrYkluUjFYSEF2K2xXR05MUzhJ?=
 =?utf-8?B?emdPZ1l2dW05MTZkU21DR05DNko2c2taOVJ1OE1hSm4yTE00dUlsWGRtbTgx?=
 =?utf-8?B?MXAvTzVYeHFCeUM2eDFSTUF4SDhWWXdwT3FjUUZvbDRIZWtEUnozSkxha3Z5?=
 =?utf-8?B?SjZ0UGljc2NidjFLV1ZpVDU4b1ZkNUJpK0RubVE1Z3BqMks4V0VIZm1RZll4?=
 =?utf-8?B?MXRyQ0taWmIwZzdxK2ZPbVJPNnpDYktDL290RWkxaVBzcjVZU2FVRitvRmE4?=
 =?utf-8?B?cWRZYWtZdWhRa1BRdk5kVUlEUUk3Wmhla0FwMFBkMHNSdHdabjNNZHdtVzhY?=
 =?utf-8?B?OVhVQkZkdUFrRk9OZFBnTXN3eDNjUWdlZnpMRnFzR3RYVGN4OFhEMUtPcW9m?=
 =?utf-8?B?SUpNd1B5aWxIM1VOZzVkamNmbTlvdFlTQmhxZ3JFQWpuN21DOUhxOXZxZUpI?=
 =?utf-8?B?Qk5Ia0x2WFFIMHUyYVFLSDB3SjBaOExnbkZrenBkUDBDZk42ZHdLalk5dUZo?=
 =?utf-8?B?UHI5TnBwT1RMY1JCQUJjRU16bm4yTG12N0hpQmNZbGN2eTdSYlFKV2hGSE9F?=
 =?utf-8?B?OGsrc0lTK2pjSkZqeXF3U1NjYy9CWERUNlk4N0p5RnkraC9BN3hKdnAyTnVZ?=
 =?utf-8?B?T0FlVksyendkei9kYjFjdE9Nbkt6RjZnZ0l2bEZ6RVhsT05rMWRLbExPU3Ir?=
 =?utf-8?B?dGppZkkvaG1yUXVuRUFHU09YSEJreTFxc0tDM2ZHd1pPcWh0Q2x1Z0pwN01V?=
 =?utf-8?B?bll1VCtxSnQ1eVJSdmlOSXk3aTFPV0drTXpYY2pSYktZZEFjLzVpNm9XNTky?=
 =?utf-8?B?eXZQNmJwdURjS0tLR1ZvZTF5elFFS3V5K3doaE81dm5WTVhVMGVVUmxuUFhH?=
 =?utf-8?B?NlJTOWtTNW9CSXF1VHFTQ1hCYVRWRklmVGtLL2IzVzM2cTFqSTFUYWJpVTdp?=
 =?utf-8?B?a3RXUksrOE8vRktYbWVoTFVKZUZOd2hNeXdlZ3ZZdzlaMU5sVmlZa1FjTFBJ?=
 =?utf-8?B?bmF1UENMZTFmN3hkaEhHMmFRQ1phdldYampTT3N3S1NaVXp6RnM3RmN5S2xr?=
 =?utf-8?B?TXBjcEF5STB6clcwMFA0N3dnT1UyMjZJTmhySlR3WjNtdlNvVG04MFpVV3li?=
 =?utf-8?B?bmQwVWF5a3hSZzYwL0pyaFlBdnFxaDBPdi9DMFBwQkRKS3diRGsvMTRaWnhK?=
 =?utf-8?B?eUdYUzIvMHNINHc5eE0rM3NJQTAvZGJVUDBJR282WHlVYnljZ3czbE9PNGhR?=
 =?utf-8?B?Z1pDTFZzaUJyNWw5S0N3TGI2cnlhNFF4LzJzbXJDZzdWSWYrYS9Mb0p2K3pi?=
 =?utf-8?B?bWRuQ29VRHJoU3YxT0JseTRPU3lvbEFZYVVyR3cyTjBMNlN6bFBPM2VhK1lJ?=
 =?utf-8?B?M0NKY3c1MzZWMnNna3RrVTlYUVFFUjU3YXgzRkFpK0UvQ3BFL0FmbnE3YVJo?=
 =?utf-8?B?RVh4M21aUnNRN29lT1MxbTZqbDNpOWJTR1Vhelp5Q0V1S0E3SktyK0tCY2JX?=
 =?utf-8?B?V1NsVEQzSkx5dTB6VzBZbmJ6Z0lIZWREUG5OVUFYeVFuYkdWejVHa09TNTU1?=
 =?utf-8?B?VGRydUVHTEVpOFU1MVhQR2I3d2k0b0YxdkV3S2RyK0VUSGw2ZXpNeUY5QmFQ?=
 =?utf-8?Q?dorWEJ7Yg/YeCR+hXU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb6e644-f33c-4419-fa35-08df3c093106
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 13:23:48.7204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGqaZF9TFD5MGfLNY2M2aF8bGqm4/NCZncx/jRFR5z/Hbo8SG4BB1DfR00KRl979
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7411

On 11/6/26 14:18, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> udmabuf pins the pages of a memfd and hands them out as a dma-buf.  The
> data pages keep the accounting of the memfd they were instantiated in,
> but the bookkeeping around them does not: the page pointer array and
> the pinned_folios array, both sized by the buffer page count, plus the
> transient folios array sized by the memfd folio count, are plain
> GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
> memory, and size_limit_mb defaults to INT_MAX.
> 
> Charge the three kvmalloc allocations so the creator pays for the
> metadata it induces.  The system heap in the same subsystem already
> accounts its buffer allocation; the data pages here stay with the
> memfd.

T.J. needs to take a look here, but I fear that this might break uAPI.

A lot of the DMA-buf resources are intentionally not charged against memcg.

Regards,
Christian.

> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  drivers/dma-buf/udmabuf.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index df6dd0046242..40182c82df6b 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -190,11 +190,12 @@ static void unpin_all_folios(struct udmabuf *ubuf)
> 
>  static __always_inline int init_udmabuf(struct udmabuf *ubuf, pgoff_t pgcnt)
>  {
> -       ubuf->pages = kvmalloc_objs(*ubuf->pages, pgcnt);
> +       ubuf->pages = kvmalloc_objs(*ubuf->pages, pgcnt, GFP_KERNEL_ACCOUNT);
>         if (!ubuf->pages)
>                 return -ENOMEM;
> 
> -       ubuf->pinned_folios = kvmalloc_objs(*ubuf->pinned_folios, pgcnt);
> +       ubuf->pinned_folios = kvmalloc_objs(*ubuf->pinned_folios, pgcnt,
> +                                           GFP_KERNEL_ACCOUNT);
>         if (!ubuf->pinned_folios)
>                 return -ENOMEM;
> 
> @@ -387,7 +388,7 @@ static long udmabuf_create(struct miscdevice *device,
>         if (ret)
>                 goto err;
> 
> -       folios = kvmalloc_objs(*folios, max_nr_folios);
> +       folios = kvmalloc_objs(*folios, max_nr_folios, GFP_KERNEL_ACCOUNT);
>         if (!folios) {
>                 ret = -ENOMEM;
>                 goto err;
> --
> 2.43.0
> 

