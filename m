Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794976059;
	b=v37LyiBq+gBMtUE0fJhS7Qo/v0miC8L7Oo9/IeHI8T3GfdFozjpy146HR1Pr9FKB/dk5
	 HcHHndJFG3eT7u6IWGsGxfHXkSuxtsz5t3sZWWY0/i3mwL01ApLZb7fL296eDUvDBLHhF
	 OQMeZgyeTZ3nB28HR73x3VZu/HtP9o09V8dHgeSPfk2PR/L9uAp64aH24F2zgmY6XIG7o
	 4OaU/xCqToJHyJBxC6sKaWOhphcKMNnoUlhLzL/YXJ5dxDEoen+UiUAxpjd7ZWZn/AEdH
	 ivVKnojqUEiWnzpg/oho+4MRPDoa2vQj2xki9I8r22EFYPdTLOX/WhSPd96PMe2CpwA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794976059;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=owym6zXy9Dmr7H8cfb4zJZ6aGu8gl2d64J2k+LHAL48=;
	b=OvYyqrlwXOfj6B0r+Vi7cuvS1wSWCWOlXRzFCJuI3eVjhQ2FFzUb8ngtOs2FWSNcfyNy
	 f/FwgvozilDIgLReojX+jJ90PefwRzMNwE4JbfiN4bXvSN98a+Lvn9dxSNj7oY+8DUr7q
	 TR4zwZ84QbrJm7K8LMCKjhIK6iMYuugbZx84+5KKQ1Zd3ZlW+BhGRwcN18uJUQP3B+U9E
	 B0Da9bj+4h/e9y5ylP/fWKQ2o/2mgR8G/ksNtvvmPhWkmRPRxuVWOYnducoRspVGrKTn5
	 yiM+zWAGTuxUkVcM2mYAoLRP+x/Vdbx1NZYZ3i3YNoqanInBfBs2fk9B+kFTanGirkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=C5TpWYlG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.3
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010003.outbound.protection.outlook.com [52.101.46.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E1D606A31C;
	Wed, 18 Nov 2026 04:27:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65E1D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=C5TpWYlG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EUKgwomAI7x7om+IgLeJzjHU+HxsTYepVotiRcPwRbS32U17PAQk7DbOEcaWf+1xXI6PKLsGekAeJqUFhUljRflSYJbMj3EP7SHsumjXw2UiVzTP7m//AgiOY5BaVNbMeA9Rp4khGldBryrWWaHIGgmwTv3n7rXv4gJEAmanykFlU4cyacR0Zj/spGirTkjrcKfxc3VdQ/KmjewVLUs1wOaoxGaZSKWSkbt0MBfMXy+ME5gJRInR2zuLzrSQ44WAzqBlbxD7WTkqM9yci5TxcrGL7XxnAfu8kwBybExBxTz49+TzwxMkfoxlIifQYOec/bdQ6ldsN1P+0BEQtbEhiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=owym6zXy9Dmr7H8cfb4zJZ6aGu8gl2d64J2k+LHAL48=;
 b=y3xbZOnDKP0ciYfD/LtXhyzhWWR9kXIJ1p75db0D2/MVSaCOoWEnFZj8Sz7+XyKHOKyqGVQVOPY+JJeyEy44zw/uyEgj0kpsKb09OnS+h1IZTqzfSZAr1JKxhCALm17T+V6QYmYeyist+RYe2YZjkYp3Cfy0JyUiaafygItqD3W6CZa6sP0VYKZ2L1UsfIptj0c9p36EZ5G3qRj/mO0aD9oIS+IcKvi/JkjbZOEn5SM4pW21pqDLOBD63J16O0AEqq9cf7qEzRipNS3x+A/dIAZkhyaLcyVDs6nIFSn/rn4cmvlWLg6nxl6+IR4V86O4Kg1kziukmLmzZSaOkLWwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owym6zXy9Dmr7H8cfb4zJZ6aGu8gl2d64J2k+LHAL48=;
 b=C5TpWYlGETn5qy5czgtBYkTIEJpA8uDuOehAi89uX8WoI5G9Rl4ksEtsef6APLodKabOsJmerS0A36ux+i2vZ8yOhk+m1kaAw/AT1NFvR/Ox5goz975FQZrzDzl5FhwM8sqKP6FWghp/XgC4J4ZbX9BqbHaZgDnP9Fb+OSpsVNs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from FT1PR12MB863618.namprd12.prod.outlook.com (2603:10b6:170:e::18)
 by SJ5PPFDF5E260D0.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 04:27:34 +0000
Received: from FT1PR12MB863618.namprd12.prod.outlook.com
 ([fe80::9c1:e17d:1a5d:e5fe]) by FT1PR12MB863618.namprd12.prod.outlook.com
 ([fe80::9c1:e17d:1a5d:e5fe%3]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 04:27:34 +0000
Message-ID: <3fca691b-f265-42b9-bb7a-384f487e74ac@amd.com>
Date: Wed, 18 Nov 2026 09:57:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dt-bindings: ufs: amd,versal2-ufs: Add ref_clk clock
 property
To: Conor Dooley <conor@kernel.org>, "Neeli, Ajay" <Ajay.Neeli@amd.com>
Cc: "robh@kernel.org" <robh@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "Potthuri, Sai Krishna" <sai.krishna.potthuri@amd.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "git (AMD-Xilinx)" <git@amd.com>, "Simek, Michal" <michal.simek@amd.com>,
 "Goud, Srinivas" <srinivas.goud@amd.com>,
 "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
References: <20261111043840.906301-1-ajay.neeli@amd.com>
 <20261111-facility-pristine-82e76afe8d8b@spud>
 <cca85186-7e00-4fbd-87e6-25c4155c6b72@amd.com>
 <20261117-grout-selection-ea8910fe96eb@spud>
Content-Language: en-US
From: Ajay Neeli <ajaneeli@amd.com>
In-Reply-To: <20261117-grout-selection-ea8910fe96eb@spud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b9::6) To FT1PR12MB863618.namprd12.prod.outlook.com
 (2603:10b6:170:e::18)
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
X-MS-TrafficTypeDiagnostic: FT1PR12MB863618:EE_|SJ5PPFDF5E260D0:EE_
X-MS-Office365-Filtering-Correlation-Id: 8324b185-bda8-4471-0695-08df452c442a
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|261102123227099003|261022075727099003|10067099003|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261021121427099003|261021123027099003|261022105027099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	rwlTq0716LLMkqD6psu3ifVjqZxuCE9tlt4pQfUo8tt8ZSgz77zWh7MGvnQChOMbCd/+iyOyewWOzQeoSKGsvIzF5vKFV8qPvhlrh1GR+98US+hoLvlo9cmuIBzRooWkU902JHFunEaOVO+MJMchUblZKVixp8WO1eVDzX2YTcsN5KwxakyaP/c4iAAoM9Wd89jfq84O/K4iDuSuqaJdsJRvFbvEHCf5d80kaZqSxMinWHbAS+CXeri8nbxxRoyglOMFmGDtWG14+oSW72fQhDj2lb1CgQQop2K/9V4j1aFZX1o/VGHK2c0+XoVYz7X8nLA08+OCFMqaiEGhRDvhwEMuHNtW3oVO8dsdSiQRVF4wfppuddFm7VSufnlq3lFrp0mAF/YJ2hhqXvAjed0G+ZWnczFSydxETZBW8dvPzRXM3QhSWvfrPP2We49y+zLl4C1mPpfhbcI1/BdhHK6pa9iT1pHTar55a6+8br+ZwMSA6R8ACXv7gLtIxwNtFijWkxIrN42U7IgA/OJzv/7oPEgyslm0AY88jmSH+3qcYu7LmIZ8gqiIj4mjtK+C5fKjg9NiNXNmTGQQbL4ZsGtsatNe8BpdtFRq8s/kBoTtCEp+w8iVa1h4TTiZ4h2bc+Aks2qieHdOYqh6gyM6u56q8v9rGzw9C6UsPZimd41e5+c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FT1PR12MB863618.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(261102123227099003)(261022075727099003)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261021121427099003)(261021123027099003)(261022105027099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnQvY1YrdXlyUm4wYzJlcFFkbDNmTitIR2V6M1J1UHkzL3dkSENkTExGVU15?=
 =?utf-8?B?NEc3NVMxSHI0T2FWdXJaamltUlU4VUU3Yit2a3lyZHZTV05kMnViL0QyZWhq?=
 =?utf-8?B?ZzVaTUR0MWFOOFhjZ1NGTEJ3QStwckRmb0pWekJGQktrOHJ5U3JMYzZlaU1C?=
 =?utf-8?B?VHBBVmhMYlBpZUVvbFBFU3ZOS1VJbEtKZmZlZ2EwRmdzQWxZZVAva2lUVmZT?=
 =?utf-8?B?MUJ3aVVvSGNtN1NpWDRWQ3VvOUxla0k3R3VMM2RaNGEwTCs5S0lLMTlQZmFE?=
 =?utf-8?B?RHlJaTdVMFZ6SW9teHE0eTRRNE01TFFjMkpTRDJBb20xWmFUSFRxWHAxdm9a?=
 =?utf-8?B?NDlKZGNqRnlJTEFSdXJvbUQ1OWw4ZUhTekQ4TzVMbjh4MFV6cmE1K2RNT3dr?=
 =?utf-8?B?c3VGaStaRDJ1Y21sc3JIeWpMeGRMZFppcUNGYno2Rno3N3BReDNuWFVRZThK?=
 =?utf-8?B?TVgxYTI1WS9hZlNGcnJEUEpUQzJXUnVzTGtMa0F0M3RDZ1NMM2VnNjVaT1Jp?=
 =?utf-8?B?d2t4aUZPRjd5d1I2VnYvdjhITlZoS3dXK2llTmV1UzFUdGZod3hBNDQ2c2RG?=
 =?utf-8?B?VG0wckhLc0tvTVZyMWlhNjB3ajVMZGFocm1OZjUyVlc4UjFSNk94RjJiWlFW?=
 =?utf-8?B?YmlhUUVVbWlTNkUrSUorbloxV2JYcVNBSTZXNDFZVWc5dW9yRk9qdHVjbVo4?=
 =?utf-8?B?dG1sb2RLUTc1eG96ZmNON3pJNllnaTBOOVFqMGJpOWVIdHZPS01kTTIzYjc0?=
 =?utf-8?B?bmxOQi92VUZpVlhCS1prM2N4UmxsUytJd1FwT3B1V3A2azExVmwydGo3RGFX?=
 =?utf-8?B?NHZ6ZkRGcjNrVDZPTjNJQVhhSnJHYUV5KzVaRElDcGk0ekorQlNvcU5lU1pU?=
 =?utf-8?B?VGlVblprbFJlaW1iTmFZTis4NHhvVFhjKzlXWUFRZmlNUmhNRGttYVVrN2I2?=
 =?utf-8?B?N0VFdlV3OEQyMmVVMEduUmMrTk5XZFB3ZWhRVWxVNVBUeU5YUkZpcitXcHBx?=
 =?utf-8?B?ZEJkbFJtZ2M0SlA2YlJMdGU5blNNWjlEY1psaFE1ajBydy9mMjh3NS9ZQTBl?=
 =?utf-8?B?R1RNT1NabCs4Y1ZyeG1MYWFDb2t2WWpkbEVZZUZ4Y2QvNTQxclZ5UHBxRDBR?=
 =?utf-8?B?SVRITDRNSWdJMTA2cnRQN2tuUmZGYVpOcVh4TUVFUjNFYzZYU0dJUC9mdmQ4?=
 =?utf-8?B?YXFQUGpqT2JmYUpXeThGcHdxV2MvSkFPbnR4OUZ5ZGhhZ3gxOFR0L0VXRFQ3?=
 =?utf-8?B?Rm9iUUxUcVdxcWRYeGtldUV6QTNoMWJ3cWRZWDU1YTBHWTNaZXo5ekRWT0Js?=
 =?utf-8?B?b3RBcVlBY2JJUEhTekg2RENDVVRJZUFVeWlNYTVhR3pZOEJKTDhlaDQ0aXBx?=
 =?utf-8?B?SnNiaTlRdmhON05nM0ZaaVRyN1ZVanVSUHZ4Sm45ampiQUpiMWc4T1BYZ1lu?=
 =?utf-8?B?SDdEWEpmNzFEbkJoa1piZEJ0eHhFdk5tOTZrUjdDYUNkbGhFcUtpSUx6TDhm?=
 =?utf-8?B?OVVJWVN0akI3MGltMXZOa3NHVGVKOGZBOFkwczFPOU9qTUhTY1l5U1YwMjdQ?=
 =?utf-8?B?L0dGc1pzNGcyS21KbE5rK1NYY0V3R0dQN2NyaFBtRUxJUjZ0bFhPSHdRYndR?=
 =?utf-8?B?bEh2c1Y3UHQrdXZzL0xHWTFLYm9OK2NoMjdzVFJicGhuRmVyU3kwRWY4T2Ri?=
 =?utf-8?B?SmVBQWx4c2dvTTRUcTQzWHZpMThsZkc1Q1FYL05tSDlYa0lsdHcyanIvTE5s?=
 =?utf-8?B?eFJNMC9QS0FaV1dlK0JmNVlqM3RNcjdFMEN0a292TWxHSUtlcFlIUW00dnZp?=
 =?utf-8?B?WlgxY1doNXNmTU0ybldVL1FQUXZjbDhvZ3I4VGVTMHhUZnJvTEdCOEh1Q2xB?=
 =?utf-8?B?TnNoUXpXUzFwUnFRSlhUWWE4ZVdmYnhHOGVoNG1Xa2g5WVFmdlNaVXZZYnlG?=
 =?utf-8?B?VlhSQWpXZE5jK3JPdW5oZCtmY0xvV3hWSUhQUjBVOEFOd1o2eE9MTEFyNVB0?=
 =?utf-8?B?M0I2SHhNREVhNk5TSWc2ZjZyTDd5YVBUN0FibWl3VVRnd1FOZ2lXSzg1dFN6?=
 =?utf-8?B?TjQwc0xSSmhwYmxUbjJxVnoyM0FZOGR3NTJiakwyb21aOWJZTkxXV1pxUnJo?=
 =?utf-8?B?ZlBjZ2kzWHNLMFk3b1U3OERtSXdjK2FUWEZVZkc4bXg1aXpBMGs0SUpBS2xi?=
 =?utf-8?B?Zy9vMlhXb2dOd2JFdjdBUys5QWhOdURhL050anltYjJkNEVrOTU0ZmcyTEpD?=
 =?utf-8?B?aEVPb2x3TERWVDVteXFwczIxR3dGdGRjejU2dW56RzM5SEhMbitmV0l4YnpR?=
 =?utf-8?B?MlNUVlNoSU5xRDZ5QlZPNnA5aEFhVHpha1VtVXJLVGx6TnJLZmk0dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8324b185-bda8-4471-0695-08df452c442a
X-MS-Exchange-CrossTenant-AuthSource: FT1PR12MB863618.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 04:27:33.6410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5CioFSYVXGVJsxtkzefOazsShC5ftvlNUIPuYcHVFSe728TVijsHKAh6wo46acEY8PM8hZD3lTn889rOHCEZHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDF5E260D0



On 11/17/2026 11:03 PM, Conor Dooley wrote:
> On Tue, Nov 17, 2026 at 12:27:35PM +0530, Ajay Neeli wrote:
>>
>>
>> On 11/11/2026 11:43 PM, Conor Dooley wrote:
>>> On Wed, Nov 11, 2026 at 10:08:40AM +0530, Ajay Neeli wrote:
>>>> Add ref_clk clock property to specify the reference clock frequency
>>>> supplied to the UFS device.
>>>>
>>>> The AMD Versal2 UFS controller operates with a 26 MHz reference clock.
>>>> UFS 3.x devices default their bRefClkFreq attribute to 26 MHz, matching
>>>> the controller, so no explicit configuration is needed. However, UFS 4.0
>>>> and later devices default bRefClkFreq to 52 MHz, expecting a 52 MHz
>>>> reference clock. This mismatch causes timing violations and link
>>>> instability.
>>>>
>>>> Adding the ref_clk property allows the UFS driver to read the actual
>>>> reference clock frequency from the devicetree and program the device
>>>> bRefClkFreq attribute accordingly during initialization.
>>>>
>>>> Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
>>>> ---
>>>>    .../devicetree/bindings/ufs/amd,versal2-ufs.yaml         | 9 +++++----
>>>>    1 file changed, 5 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
>>>> index c00ec342d574..e294c0f1b0ce 100644
>>>> --- a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
>>>> +++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
>>>> @@ -20,11 +20,12 @@ properties:
>>>>        maxItems: 1
>>>>      clocks:
>>>> -    maxItems: 1
>>>> +    maxItems: 2
>>>
>>> Please add an items list here.
>>>
>>
>> Sure, will add it in v2.
>>
>>>>      clock-names:
>>>>        items:
>>>>          - const: core
>>>> +      - const: ref_clk
>>>
>>> its a clock by nature, don't restate that in the name.
>>> pw-bot: changes-requested
>>
>> The generic UFS platform code currently identifies the reference clock
>> by the "ref_clk" clock name in ufshcd_parse_clock_info().
>>
>> Would you prefer that the common UFS code be changed to use "ref" as
>> well, or should this binding retain "ref_clk" for consistency with the
>> existing UFS core convention?
> 
> I'd like the core to be changed so that every new ufs device is not
> forced to propagate the pattern.

Sure, I will update the common UFS code to support "ref" while retaining 
support for existing "ref_clk" users, and use "ref" in this binding.

Thanks,
Ajay

