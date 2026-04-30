Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F70C2D5925;
	Thu, 30 Apr 2026 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777563943; cv=fail; b=kiO+Gt3CtZGMVowu/e/mlwZKNojOI2zSdRJhQINyTSD2UajgQ8JOjDfX+JR7uGaUew8ge9oVHK3TstW+LNBqKkgDu3QfDBS4atDWpxLHRybBj8t3On7z86i+aW1kziBmhZQ8onjMvbltehqlbZ/Mb5wC3DOOMT5EBmstT7AgIWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777563943; c=relaxed/simple;
	bh=su2K4yzWYVLBdivOBUwO5u4NEQaLh/0XVBSyxHu7YyY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aRLH9WOGFed3wNoG2NXSYrgmehauc7Wg8Vzfx0Vm0CZIzQmqzpO3zXBLFdJt4wQ7zZZU1wV9x+WZFFZ8QnhKg02l0f1+OFfQw/54asPSCY0iRJtPv1IEagP6oDO4Mv/0lL43xi/XsoWfV0uhaba0M9EYmLYz2vtuN1Zob1FamwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=H1JKReqL; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="H1JKReqL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jROVe6GMVcF0oTYpldGUrB3LurYHQUsombXHc/bBPmYpLHgiL7MRbmi1R0HmZqC6Cx4kqrUEYaTSrzZW0F5/caUq+fSMMfzFL0A++aFQldKocKV8Rc9GHBjecD4aA9reGydwQP1qUiKdtO+47fFFPOH2vrYPz1HpQLiUZ1FMsbUKwR4B2P0T1WsSV/L6vhcOAVcH7iglMbrpQYIl7lUjRx1UgkC96QgzXkjztaYqEQOBpOcxJMydwp+DiRHC71W1twT1Cz9kXMfpMtcfG29OLdDJ/HsInhiQICcEcryplz/usMv9MY05egsDEOz1m5529r2HmnWL7nIycHny8Hg1Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sl7TkyScM1VKXBf8R1RgtL7d1sbiIL653f9kAORdAQw=;
 b=A28mgL7N74nm9rVeZ26sSfILC7FmW3MjAYxHtyBRQflMqw2VQ6lwU8X9P83qJfWqOR1C+n5fg8YB8WLm5dKGvsfbqXqiR2DcAkSUujPB9LDK/j/uBBaGKSh2NQ3xXrVPvPrbRh24uyfxW8ngTsY0OsCmh9IUZ+4k3QZqE1hNmHIT6CLd35Dk1h1GJ93ow1O7mNbkNOnk4h1h9zlhrNGWf7wE977RqLE+2gj+vfVXh1FCMGfwqoj40MTzC9uFbRUdjXkBIboMDiGyXWlfVRjzUap7myRJ1MXyZmnwKTxzRCw1rMrJwkpgfxWC47BX3nl+rUHeEvZxKLq/Qm2HNVuoIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sl7TkyScM1VKXBf8R1RgtL7d1sbiIL653f9kAORdAQw=;
 b=H1JKReqLQX6bIYyQYQPQxv6+oeGTfZQs+w/wyw3isUVLblrGy/qhQGjpUPSY3PFD19tORHHYQeA6LWhJDnbl+Gv+bCD6zU44Q9gPz8Cvy+Gl83kVetTw7dFAxFmImGZ/gGgcjO3wVx4F0uvxOlnnndNPTT33swIL2J/zI7FwA9vh78WCdDibQd/tmyVdafNpb1jPd25qFTS94+YBOx0nqQ5MKi+cgJgmnJ4XWwFTT3IqNCpre4e/YuSHhoYWP0ZnNNpRUoZX1V1k1DsNL9M0lG2NE5y7Zq7ZLKLduZiA3IBs3CE7PV4EWo8iN/q9idug08dkeySrwGCvYBvulehJ7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:588::19)
 by VI1PR10MB3599.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:140::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 15:45:31 +0000
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::be9f:e8ca:ee9:83e1]) by AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::be9f:e8ca:ee9:83e1%3]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 15:45:31 +0000
Message-ID: <f1dc5c3d-0b0b-49a6-9f07-8e5624fddbee@siemens.com>
Date: Thu, 30 Apr 2026 17:45:24 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/13] blk: honor isolcpus configuration
To: Daniel Wagner <dwagner@suse.de>,
 Florian Bezdeka <florian.bezdeka@siemens.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com,
 James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 liyihang9@h-partners.com, kashyap.desai@broadcom.com,
 sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
 chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
 sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
 ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, tglx@kernel.org,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org,
 ruanjinjie@huawei.com, bigeasy@linutronix.de, yphbchou0911@gmail.com,
 wagi@kernel.org, frederic@kernel.org, longman@redhat.com,
 chenridong@huawei.com, hare@suse.de, kch@nvidia.com, ming.lei@redhat.com,
 tom.leiming@gmail.com, steve@abita.co, sean@ashe.io, chjohnst@gmail.com,
 neelx@suse.com, mproche@gmail.com, nick.lange@gmail.com,
 marco.crivellari@suse.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 MPT-FusionLinux.pdl@broadcom.com
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <e350389a5a635660267a7a13f06529da102a95d8.camel@siemens.com>
 <2d61b1f7-fc06-4fe1-8a6f-cc3a2f114ae1@flourine.local>
 <85415539137c61cdec145ac0ee299dbea7cdd2a1.camel@siemens.com>
 <8c074639-bb75-40be-a338-e80b93123477@flourine.local>
From: Jan Kiszka <jan.kiszka@siemens.com>
Content-Language: en-US
Autocrypt: addr=jan.kiszka@siemens.com; keydata=
 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
In-Reply-To: <8c074639-bb75-40be-a338-e80b93123477@flourine.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0039.eurprd04.prod.outlook.com
 (2603:10a6:10:234::14) To AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:588::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR10MB6181:EE_|VI1PR10MB3599:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e2918c7-ab23-4d28-e8fb-08dea6cf8253
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|55112099003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1rvFZzcMopZMFu1sDpE9U70GgrE30mm5VbhuO1bQG3dDCdfMNn2S/xSxA10jYd0KS0IFbAf1IP3mU6UYezmqUMRJdIZ3+atsASnbNBX37mxUA+CQu5d/rvrXjTL4KTD0+AD7cVEJzxPwBzbWdeX11KDSB/dmQ+9daZ64mI/ewVSLIEWl85aHSHPh1LZ5vhMTMih1eeoovzDj7v+UBcVkJ5jI4pzXj8Lmm79FVot+LiW3eTzZXE5amWNWkegTsrga8+8er5EbkFDM29j3USoOyAsT/oCihBrsz5bWDdq/GEPQPhNN2l1cyoR5OuUO3jm4ShNjAygijy7FxMhBkjBRV203yg6vqtfw9gB55iNdTQsO9HH8OcB33pYK+A849hCixtSYk+8N9BXUUHiQUWcWLLDi7/U7rNI636P9q4NJ0PUBzIyEKDEMHaJqpi1oRl7/CBu+PFRw3dOctQR6rjes/d1kR8+Kh5DjhzSsjYOibLLGtH/ThmKeuBlXVT6w1dL7IiU6Uo+Fko84GMkbVe11I27vV7U/qdqO/VprpUv35xgava5ZIGwiuGMee1akzU1KhUkLna5C1Xi4BXFLgbIqQDVNwng19wIyDPrYpVk1lyt9UNRGG8xKgIdNvjytfZEoRwssRQQr3IrNZbJaeVKtl0VH+4IVL4VVW6uFeU0XsTb1O2SwB0gdTn473bNsHxPuA/DV8iLlrck7k5oEDt5WhAw9W6fwNmRgMV7mt1Zj2iw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(55112099003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTNxQzJKVElYRE8wRDBISHVYM2VMcUFESEFLMy84N3hnd1kzZSttdUw2a1BZ?=
 =?utf-8?B?TUJaNWdLMnNJYzNrVmsrelN3QjVJRTM0bmkyb0dLbWZHS0pZeCsvYXJnZzZM?=
 =?utf-8?B?RkROVFZRSS9MTzV6OXpET3VHVHRJTVlFSlAvbmc5YWJCTGhLeXV2T2UyQUJw?=
 =?utf-8?B?UTdnWFo0ZVdsQmVQR3p6V2ZpcmJ4TWJFa3BaMFhSSHk4YUpxOGtzRHFjNUlX?=
 =?utf-8?B?UHMvRWZsN0xKbEJXbE03dHRzTTA5RmZDb2E2ZjgxL3Bpb3N3MzdCZTEzV2h0?=
 =?utf-8?B?WmNnVENMNERQYklBU2JzRVA3SjM0b0dEWk1IODRKR2FtU3NLRVFiTlZxMDhi?=
 =?utf-8?B?SXpHOVlZZmwxbXdIdk1RRTZRYi9QUFQ5VTJIcGFqR20rYk04Zm81SWhjQWdL?=
 =?utf-8?B?VFNjbS9ReG1paythVXlqNDUraTBOTTlCVDFVd2FBV2NURE9XdnZOU2lmNCtM?=
 =?utf-8?B?YndsOU5oUElwa2tERFBOeW9QeHplSndNc3IyR25zbUw1azN1R3JFOG95S3JE?=
 =?utf-8?B?MVdZTXpweGRMVHFZMEd5T24xQk41NjBWTFo1VGRSd3RNeVJicDc2Wm4wSkRD?=
 =?utf-8?B?bVg2OCtsSjZYTkEyQVEyQ1MvaGJ4YXR4ZElXM2VHdmZQUUFPQWlnWHozc255?=
 =?utf-8?B?ZFV1M2syUUdWVkZ0emwyYXZGZzJCUVl4SVZEcVpjZjZhZEtBKzVtajcwS2dZ?=
 =?utf-8?B?S3oyY3dxOVNGVXZkK0FOb0ZQS21kdm15aGh4VTRoSkFNWmJENzFUMy9NeU5D?=
 =?utf-8?B?T2x0UDBzbXBjU21lVEJrY1lZVTlmM2pwUnpqYWN0UWF2N3hMbEFxZy84SGtt?=
 =?utf-8?B?TTJzbjQva2d2VUlQU3ZsRmdRbjlKTVFBUlZMcGdRTU1aTXN2S2IzRUNQMmdR?=
 =?utf-8?B?SHIySDZ4RGlDdFNVUVFPeGJIeWRPRHR5bkYwYzl3NDQ4WmluTG9nS0FBeU83?=
 =?utf-8?B?SDVFaWhZTHVqdzY4S2RnbzBEMlJwZnVjalhaUkZPdnJ5NHJWcXNTMTc1TGhL?=
 =?utf-8?B?cDB2bWVOMS94c1ViOWdzUCtuQXlQa2grTWt3MkVXTmQvV28zNVZ1U052ckYy?=
 =?utf-8?B?dU5RbUlndW84Mm9jOGlkQ3pZdTZTWktHa0lER1dEblB6ZEdoZmFVZm5rVjZQ?=
 =?utf-8?B?Y2NyaTcvNUwwZUdJZEx2cWVTMUVJd2VBYnc0OC85UlFEMEF3SDNBZ1F5MjFz?=
 =?utf-8?B?QStocnAxTkVjRC8rQ0hpdTFZM0dlVm9TaGFNZDhWVWswaWlOeUVzay8xdjNq?=
 =?utf-8?B?eCtCc05ELy9EeEh6L2hqdURvVHVRZXMwL3Ftbjd0ditobVRmcy9OeU12QjI0?=
 =?utf-8?B?L0JjbVpxWStsVFovd1Z2NzNQSDlpMnhsV0Q0UlhxVEsxb2wxak1EdG5RNTZr?=
 =?utf-8?B?bVljdWlKM1JMeWpPS2ZCdVVJMGlBcTdZMDR6VjFSSDB1SmY2NjdXWGxmaFU2?=
 =?utf-8?B?WlNlSEJjMXZaeEQzMFJmVVppd2x3ZVNETmM4NHRaUzUyQ243eHBud3FDUkQ2?=
 =?utf-8?B?RXl0anF4U2xwN2MyTk9qd210QlNUTDlTQSsrdHBhd0RGekpzTENiNCtZb2JQ?=
 =?utf-8?B?eG1oWHdZRGk4ZFV4cnBEdzcyVzZvZUZTVmtRUEIxVkN4QkI2L1QzVnNwN0RS?=
 =?utf-8?B?UEVTaUE1L1pqdkJJV3hqOEdScGxPTnNiMmRKYmhrVWxYYW9tQTNyVlkrRHVv?=
 =?utf-8?B?eHBuS1d4MEFsM3dYc2tPaXl6TkpvWHVPaFhJR2tiLzF1azlScVp3NjFpS2sy?=
 =?utf-8?B?VU4wZ3ZnV3Q2RFI5MHgvQk13dC91U3ZkN083R3p6bHdWYjNrcVF6VWpEeG1D?=
 =?utf-8?B?YVhPNFJRRy9NcVpUb3dsdVZiYStyYWJJSnNsejNCY3hRNFVLckQ1K1kycU5q?=
 =?utf-8?B?eEJzVjZGQkZmSnVkcVZqSEl1anZkUmFmSmlwc01NaUt2NVlJemxGN0lFNjM3?=
 =?utf-8?B?ZS96MEFQeGdNOHdsdlZXeGp4UDNPMDJ1UEt4NDV6cXlUUzdOdkhlSE9GNXBV?=
 =?utf-8?B?WlAyOEV5MkNlM0lEd05WVHdSRnhQYUtlc2RlOWdnWFlNM3dGQTFRa1IxeXpO?=
 =?utf-8?B?enRkSU9KbVFtNlFQaFVBZ2MvQVVvWk45U3BoNUI1WGdDWTZESGVlaHllU1lN?=
 =?utf-8?B?NEFsSy9sa2FMallVQkdWVjF5K0FhUUFka3gvc1JRNHB6Sm54R3EzRDlmQkRi?=
 =?utf-8?B?Z3gzSnBocjZwOERqUDZhSllTT0UyOTVFbnFsUWU2dlEyRVZqaXV6UEtwVjdt?=
 =?utf-8?B?Q0wyeWdKN25NeXNXK291amRvMlpQblRSQnBob0NSajM0a2MrM1BqaVBhVkZM?=
 =?utf-8?B?TGd1aDBiUFdrcW9nZ3A0WE9GbDFXbXEvNi9rNko3OXlMYk1ZVDkxUT09?=
X-Exchange-RoutingPolicyChecked:
	gBhpk2YHTiVYHfL6CoSHRNjRBZRlril/xLHkJeNY8T2VsZuWHv2OwjF2HFsc1S341QS1kyxsVyOAOqp30ost2EVdlN01OQdyUpK7P76Pi8AbrZ72qCCaTXM+dkiOStPNzsccFlzCLpkxjC2GI7mw1hD++v4J+F020YSo3EnNrCpPQyaCybumFhd7x3Lmy1jGDzP3ULi2mLjhOL4j8TL2JbzM66yE1ZeOobGushzFYQcWV5AqH/KjGx7d4HfBbqLmtmt3KL0X3w9Owb5A6YQk7m7QInnpSM7lO8U3j765XBmHCQNqeb/7o/TlNW76RCsIaBCL1gwG8sva0+PoWhye+Q==
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2918c7-ab23-4d28-e8fb-08dea6cf8253
X-MS-Exchange-CrossTenant-AuthSource: AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:45:30.9619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32K+RU91U0DVZBzUHouBjy5VGmqN9poet5mdjfkHthQ8BFiovyt5LQ3yHdkkqPk4cml9YRqBwKZa2n9PcRH2og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB3599

On 30.04.26 14:09, Daniel Wagner wrote:
> On Wed, Apr 29, 2026 at 11:01:33PM +0200, Florian Bezdeka wrote:
>>> Which use case are you actually aiming to support? While dynamic
>>> reconfiguration would be ideal, the amount of work to get there is
>>> significant. I won't be signing up for it.
>>
>> The use case at hand is a RT enabled platform where the concrete RT
>> workload is not known at boot time. RT applications are deployed "on-
>> the-fly", nowadays using the existing container runtimes with some
>> extended resource management on top.
>>
>> Applications can request certain resources like isolated CPU cores,
>> special IRQ affinities, PCI devices to pass through, ...,  so that the
>> resource management on the system can take care of proper system
>> configuration.
> 
> 
> This is where I really question this use case. Currently, it takes quite
> a lot of time to tune a system to work properly for RT workloads.
> Between memory channel interference, GPU interference, and shared
> transports everywhere, you end up with a fixed split: a set of CPUs
> suitable for RT work and a set for housekeeping. This partitioning
> generally does not change during runtime, even if the way you utilize
> those two sets remains dynamic.
> 
> Furthermore, reconfiguring a system while running an active RT workload
> is asking for trouble. I wouldn't be surprised if doing so triggered a
> wide range of unpredictable side effects.

No questions that the devils are waiting in the details (and some
already showed up). It is a process of resolving issues and opening up
use cases from "boring", restricting boot-time settings to more and more
flexible reconfigurations. But if you do not hold up that goal and keep
it in mind or even act accordingly on changes, you will never reached.
Also RT would not be in mainline today without such a vision.

Jan

-- 
Siemens AG, Foundational Technologies
Linux Expert Center
