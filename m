Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794221781;
	b=PgXVRmdZ2jKyBAtjZaQxhN4rJexrjwu5nkRffT0dKjfAdqtPeHP9XvM1309thqb66Afa
	 CAN4AZWaKz0iWFieIGKTAPBfyORd5hb5rMycJePVTo1F/Y4JONIvHl/p8ITFNd2SQbW0B
	 qEiDlLylsog5hRY2WpBYDnwiOmnLZJGTwa5sh8fHwkLeqxcfNNzOI3HhhElJGcMWfAMnW
	 hrp0z9w2hccv17gI/LXXRq3NPqQ7PZ6qFfoxrrUc8d+87I0y/b2MOC1xxWfv9+v/06ASm
	 oQB9dU9w6318rGX5qBxmLzyRqJrkuASboSeKYiHxhnk0MJEMFtR5X1+/mLX1Cv+7frA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794221781;
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
	bh=1G+4UQ7mHJ0FfY4QH361X/eCZ1GoBx6Ud/WEDTINhuA=;
	b=aHG5Tubg6vEdKDTk07GzJUEI6obBY2TzwTm+gHifvUX2xdOzbBmtIp+u40a3r5UGwQwZ
	 ANLY7rzrzb545olck3G1Kr2bvtokKsx+P5rFOHN9qwustevo93h0qO0J5p+EjazsW3agm
	 YWvVJLRlztyxpvAtdHbdzHDhhmLS7wiVYxtjZS9iH9GBa1rs8SR27dep2ojpUxNb5N4c+
	 EwwV86wm/QffendfU6QnSeA6TjPUiEB6WQwGTXMbU2xyuSmRv/WpQ6Fb2UsKzL/JuIWBR
	 7xDtNDmHfAmA37UFi1sQlPNkyeBKuWCFnngX7RdWZE1d4HCVaCs0xxOpNmV6yH59t8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="zHnJfZ/5";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.44
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012044.outbound.protection.outlook.com [52.101.48.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F279606D802;
	Mon,  9 Nov 2026 10:56:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F279606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=zHnJfZ/5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JNMhfjUgNLQAav9n5sMDVkPcAa8E3Dt9EkU6fjpcKxYCZ0FBAnkDum+qCwDlBedzvQEbgpuVd+l17oXVD9vTnnvPwSsoqILcWj9qpGeL0CIj6egyry3OokiZ5kgeFpzLVT1PEtptZxspBncmhHbIzyYCXoEKsrMgRmQLE6QZb7cPzeQTXKrSxsMOKqx+rboiT36dB6VQy1z2VqDlj/CE/3uJ1Zae5oUAG9ewJryyRtEfr2SINtMvLd7IZbX1dnkWano2f0wdrkHqf1CEzNLpqfJTu/RC95Pq5lprXHzmz31xFJf/ml4HkTRj6NgUSLUAhtzLbbmu+dXqPx8Uw0+HTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1G+4UQ7mHJ0FfY4QH361X/eCZ1GoBx6Ud/WEDTINhuA=;
 b=HXeZuWKmTjltPbLNtmREqIla7BZuNTjHnJdZ5vJe7AoPwKQS/34nOf0HBRbasEkE8xjBxm88gqfMTQOmQMhkVeWnZI6Y1g76mSSnHjSjb9pfpaa83H8Jp6Az+yHQMX5uK8KZFoh34rZj3fSJqducDfu1kRxgycR8ga6CSa7sZlNySTsdGP10TJI4T0OeHNyUvBBUmvXc0pLnScr+0RTpYX9WNeiEQbAfGFTwWfT1H29EFSU8sTmup0NgPOEmgqXuqp7aTc2hlYIHK+3FZdbYK7zmR+jlTtHHEzEkcU5PzTzXdCqG+JtOoyP1FibE8BrGLeBmxqO0M5DVKEmpbtC6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1G+4UQ7mHJ0FfY4QH361X/eCZ1GoBx6Ud/WEDTINhuA=;
 b=zHnJfZ/56wlbK1rQwka4gYtup2ittnN9vy4rwhEhf3ibcStZHkNss0jRp0mdKhMSJJPAML3W4waxFabcBOHBfwt4K51nj4+cM5aMQAczi9jv4Mjfj+qLrWNxphyJDj0247IKIzv46qQBMT9O8K71T3MOOCVjcrFMIm0aDXTqRBw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by BL4PR12MB9535.namprd12.prod.outlook.com (2603:10b6:208:591::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 10:56:16 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 10:56:16 +0000
Message-ID: <b0f530ef-bbfd-4112-aa51-82fdad6c4ba2@amd.com>
Date: Mon, 9 Nov 2026 11:56:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to
 memcg
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org,
 dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com,
 jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com,
 mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org,
 vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca,
 kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
 James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
 phasta@kernel.org, joro@8bytes.org, will@kernel.org,
 linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com,
 robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com,
 harry@kernel.org, vbabka@suse.cz, Albert Esteve <aesteve@redhat.com>,
 cuitao@kylinos.cn
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-3-cui.tao@linux.dev>
 <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
 <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0388.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::17) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|BL4PR12MB9535:EE_
X-MS-Office365-Filtering-Correlation-Id: d00351dd-fee0-4d66-2bf7-08df3e50140f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|11063799006|4143699003|56012099006|261021121427099003|261022075727099003|261022105027099003|261026140227099003|261028144727099003|261026121527099003|261102123227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	k5v1S8AS4zWotcYJ/nhJUFg4E2b0rgmX98soCxjpcnO7LVlofM86eDQLP4BV5HvWVBiWWTYib6vjQ8X1m+5DqUqrWfIdK8R960upM5qh+mD7PMQCCSFABKj994zG11gP39ixXp1jegnhpUSXVtEf9r15avOTOAOwmJB0LXsWiQ8K7aGq1dNP4wd7o290cn6Xv3hrIIV+HkppZp3bpoAiNdF7RSStQxaY5KBpZOykFWHxisNUVjbpcXv/8KmTUrHWosSUSITyeBZW8N2l8+X7JakM30JdO/9VSg8BwHvwlm4Ff7rYaAD7ZNs2kN7yQNEcfJazxive+CJQ6Ur1P4m7RyTMuv3BHDjJBFqU7ZLjNDZlrKsUF3hx/1wQGMgDzQWuJsiVxp3+4SQ8kIOn7xurDrrYH6r1TMTepxbnIlXbWXypmKq8Jv7B0in4KPX+HAAj2SPvKYI5eRHb+zy9ArWd8Ki5ia5CowjVpk9B9IIJUjG20ENbJMattfthUl0gI+bZTNHxJ3sx+909NtG/IeG/snBShfeO9r5j/VmTAWiuRIXgZOH1QX6pb+hg1EW2SbNK8IKgNu1Tbup7ij4BqQUNcgwcUIARYEL7/6xS+NDT4a6u30xaYTghU4gKB10B997wqEK7k1nFelJIanAqJXjPvLwjoKSt+kHJD1ONYIPr78I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022075727099003)(261022105027099003)(261026140227099003)(261028144727099003)(261026121527099003)(261102123227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVUyZnJKLzRudFo4UVlUZUt6cmxnT3M0Y1pSazN0ZDkwTXBzK1cwV0N6VmpO?=
 =?utf-8?B?a2tNNzYxbmZXVWlGV2Y0UlpqaUkzT0ppOHpBWVg3c01vT2J4Wmd4ZWJHWTRP?=
 =?utf-8?B?Q2xVQmR2NnZFN2xnVjY3bzhJMjI0a2NRaFpUOWRjRGxJdVo0SWxYby80b0c5?=
 =?utf-8?B?TUlOcDBMeVJJWjR1WDhQbDNPOCt4SjBSOUtVWkNwV0Z4RDB1OGw1N3R6SU5m?=
 =?utf-8?B?ei9pUmV2SzUwY2JEdUFMWXZHU0VRM1AvSjVITUUwaFAxdDZIVGpXWU5KeXZs?=
 =?utf-8?B?ZnVKbDJQTU5OUjNEd3lIUFlzWmlIc3lPdnJpaHhNK2RlZVFRSjMzdGo3Vyt2?=
 =?utf-8?B?RHRyMnMzUVVvK2NUZjg1b3o5VGdKdkwvaWNkNWlBUXBFeVJURitrdDFzQW95?=
 =?utf-8?B?djgwaTNIaVFkeVpuVG5OVWZVMytJY0xaRFloQmxLaDZmbmhHQzlWaTd0cVc1?=
 =?utf-8?B?VlUwMjFVRGRyMkRBa1Fmd3UrcW9PdWVMMGo2SFM1blVGU2UycUNoZDBNeDFI?=
 =?utf-8?B?RytqTGxmMmZqcXdTdUcvRjZ1bEkxMWpTb08wVUc2bllUVER3d1ZUUVdDT2lu?=
 =?utf-8?B?VjRpRmNBWFB0ZGJFd1VJVWFna0xhM0ZiVUJUaTRkcjBySFpadm82N20wcXAw?=
 =?utf-8?B?Q0JuUUpkeE8rSkkvZVA5R2c1cGhDdllaUU9ybUV6MFI3RUNmdC9wMFNWaXRv?=
 =?utf-8?B?dGNNTTE5VVhOSjBrY2NJOGxmb1FJY2tnMnBPRkd6MS9YZEtWdXdIU3liV1RI?=
 =?utf-8?B?ZWpLeUxSc1A1Z3cvYjA1NThMSnNNSGNpQmlNZjZoNld2aXJkUkxzSGZmWFEy?=
 =?utf-8?B?Mk4wNnZ2eDZKRTlRODdNcG52b1FzQncwZ090OUNKTkJyRTh5ZmJ0NkdnVVFG?=
 =?utf-8?B?T1VQT3BHYW9Rdm5oeUNpNWxycjA1Q0VoVzV0cUp0MWJVYlRHbHV0KzJBRnMx?=
 =?utf-8?B?TW45NEFKT2lFNUhHUElCWWdhaXQ5VzBmcDhUVXB4Zy9RenhXNFg4MVpRV0hz?=
 =?utf-8?B?eG9uVGhEcEJUTDFQSzc2RE9rY2JTVnQwTGV3bGs2dnk4ZFdXRHVBRk55QjBI?=
 =?utf-8?B?U2JuUHpWS0xLSS81SnRDTy9mU2tTamF0RTNDNEZuLzl3NGk2aW85OHVXWFor?=
 =?utf-8?B?aEFZSk1IUWNVNmduY24zNEZMWHpNdGNYLzh4Ynd6clhnVk95NlVoSk9mZlFS?=
 =?utf-8?B?NElTTWdoTEwyT0VlV2g5UFlHZGhQVkRlbjZsaFZ1bW9pUDhNZFNRbGMweVJZ?=
 =?utf-8?B?aEJzOWNadDVOditZcWIySURYaEE4R1JzTHBLdUJsdUNlMFp2eHBmckdrOTcz?=
 =?utf-8?B?Slh6WCtOUHFsaVE4cmNLM2t4U3o3ZFhDZ3JFVnJmNFZZcTV0QVc3TEc3MS9y?=
 =?utf-8?B?K1duNmdPaEc5MEhPRTlUN0t6WEpYTHY5QktBOHRZYUlmR1lMZVR1MjRVSzAz?=
 =?utf-8?B?ZFp0M3FMMGxhM05TQ2RoamlUR0VRL1ZZOEl2aE5FZm0vRlA1YSt2VmhmaXRw?=
 =?utf-8?B?Uis4eE9XQy9yM0VBcmdZcDV6K2xaYTQvNHZZWktBNXdvNkdxaFhqNzhHTXJR?=
 =?utf-8?B?NFoxelJObE5ZSDYyQUtZTXVyQXBHL3lybHowc3o2RHhlaVNQbUNoUytIcVJx?=
 =?utf-8?B?a1FJTHFucXF5UkNOVktSdTRpNU1ZL1V4TXBadmhMaG5yYUpxSWp0Z0JXUEli?=
 =?utf-8?B?NXJoOEVZanJ1bkFRWUpHZFpZRmJCZ3JGKzczSXBsNkp3TWJEdVA3cDh4bGRo?=
 =?utf-8?B?aVExVmVNQVdWMEdCZ29HYWdnbjVnc2c3K2QzZjE4bmtXSDFmTEtnRDM0VDJN?=
 =?utf-8?B?MXQrcDNmcmh0dTZHTzZ3MFZsdExvTXVUbURLVE5kelBqK3lYRnViWHBkSnBL?=
 =?utf-8?B?eFhKbEp6VStadXVWeUJva1lJUldZTW1iMndIejRXL3VTMUNGb2tKbmk3eXJ1?=
 =?utf-8?B?bWUraDdTZUE4dmV3elpsRjZzN3N0UCt6Z0hmd3ZNZmRkbGxScXlzdFUvanFK?=
 =?utf-8?B?a0JKSENtWmRwQXZhWUhObURhNG1BKzdxL0U0Nlo5T3lGcVZxVUtzR2lmcWJj?=
 =?utf-8?B?LytveVlzSWJOMVVaM1N2UzhIb0pFUnU3azVkenhpNVRKU0pNcjFrc3BiT3FH?=
 =?utf-8?B?bkhYdmk2U2RHM1RqUWc4djVjRGRjektKL2hLMGV6VXYzY3krRjhSaWprSDN6?=
 =?utf-8?B?VjhwQ1NrVkJPYXl3OFBkMFIrYzRxL1Jjc2k2YTRQZVM4bjVaTHJ2cW5yc281?=
 =?utf-8?B?RG9lWUV1U3lJQnB3QjJ6eU5TTnJ5UERscUdqc2NtSTF5cFR4Nzh3YjQ2M3RJ?=
 =?utf-8?Q?BmNGAbaK237SDbqCFw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d00351dd-fee0-4d66-2bf7-08df3e50140f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:56:16.6770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vDIN17QFG/90J4re2i0bT4E7MPnbihJnG+VSBsBN8eORLYlUUoSjrmJOTMD5Nb8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9535

On 11/6/26 18:25, T.J. Mercier wrote:
> On Fri, Nov 6, 2026 at 5:23 AM Christian König <christian.koenig@amd.com> wrote:
>>
>> On 11/6/26 14:18, Tao Cui wrote:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> udmabuf pins the pages of a memfd and hands them out as a dma-buf.  The
>>> data pages keep the accounting of the memfd they were instantiated in,
>>> but the bookkeeping around them does not: the page pointer array and
>>> the pinned_folios array, both sized by the buffer page count, plus the
>>> transient folios array sized by the memfd folio count, are plain
>>> GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
>>> memory, and size_limit_mb defaults to INT_MAX.
>>>
>>> Charge the three kvmalloc allocations so the creator pays for the
>>> metadata it induces.  The system heap in the same subsystem already
>>> accounts its buffer allocation;
> 
> Only if the mem_accounting param is set to true. We (Android)
> currently depend on it being disabled because system heap buffers
> don't have a single owner for their entire lifetime (ownership often
> changes immediately after they are allocated), and the kernel doesn't
> have the ability to switch who is charged for the buffer memory quite
> yet. Albert is working hard on it at the moment.

Good point, making sure that Albert is on CC as well.

So basically we not only need to charge the backing store of a DMA-buf to somebody else, but also the housekeeping overhead.

Mhm, this here also complicates the charge transfer Albert is working on.

@Albert not something we need to take care about now, but please keep that in mind while working on that stuff.

Regards,
Christian.

> 
> Could you update the message to note the mem_accounting param pls?
> 
>>> the data pages here stay with the
>>> memfd.
> 
> memfd / udmabuf is a little special because it uses shmem for the
> backing store, which is already tracked by memcg under all conditions
> (except hugetlb). We don't currently use udmabuf, so the lack of memcg
> charge transfer for udmabuf is not an issue. But once we get charge
> transfer working for the system heap it'd be good to follow up with
> udmabuf.
> 
>> T.J. needs to take a look here, but I fear that this might break uAPI.
> 
> Thanks for looping me in Christian. The buffer allocations cost
> gigabytes, but these metadata arrays are only 4MB per 1GB of buffer,
> so I don't expect charging them to break anyone. Leaving them
> uncharged is an accounting gap though, since someone could spam many
> udmabufs from the same memfd and only pay for the memfd pages once. So
> this change is ok with me.
> 
>> A lot of the DMA-buf resources are intentionally not charged against memcg.
>>
>> Regards,
>> Christian.
>>
>>>
>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> 
> With the commit message updated to mention the mem_accounting param:
> Reviewed-by: T.J. Mercier <tjmercier@google.com>

