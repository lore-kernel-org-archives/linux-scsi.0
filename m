Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794839918;
	b=QPGGC8K/RvvaV+OuWV9iL3tpKE7Wpo87tkJvReK8gEYOpAEWUaYvtrkFP8hERQSKq9Ws
	 /PCfGfBROOl23JtuGxT+MHBw02EeSZRPL2vEXM+QTWbUwjjJQaRs2am8k8wvhNQBMHVdY
	 u2gNt8lheO6oDmBNXbPIoWPrMQVWTte+xcu9U1ya9j6LEgcK6Bhqk3j9wepLW0MbI9l0B
	 MvJYKtz5whwbvT4yH1XU7eIZTD57VgKSLlG84cLlgtgjoAXFHa9MRBUeIQ4Vp4d1qJ63f
	 He7wD34hQ65aLxhvfAZNRW1U7FGqTLvyqVvhxZekIlsUst2cjwb22LkvqJtsEEmafIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839918;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SharedMailbox-RoutingAgent-Processed:
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
	bh=xwpWcgRm7qer0bIxGSmM3z4aZzr8WzaU7mJaPYvWRno=;
	b=FbEllkR5SmG8MfVtEzgksoSuQZrUoyqEaVWLuNPm0l3/bznTKtVe6V76ixH2aY5Qo6Xa
	 8hp6t+7/zBJgneE6VzkiUHebvIQPvvPtGxz883ZEA+peGce+9qWGNP4hZ179wz0im0SMG
	 vWt4ftLRTtEupPFBNcMidAkinmDHo2QvtXvqGVOmazNMsZts25kyl8fHfKgOz17nVNufg
	 xXjnZxeR4m83f+VupOHub5gqcL8Q72kpQJ9dEgMYJgMrvqx50kKi5F5gjnEn/sqlhZLTJ
	 xVRFkLDULeSp7fkxwvRlYieDh/Au8AjKEtugJYaT0e8Sw3OAobjQdCqSJOsxSfhdXRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=cljvtMEF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.22
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011022.outbound.protection.outlook.com [40.107.130.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF4606A32C;
	Mon, 16 Nov 2026 14:38:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68EF4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=cljvtMEF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eyr1T76X2qfdAn9S99vvnE9eHaJNY53vuvL58xizxwjK4tQkYfGOFdoRKaO+zBIH1svLyZtN/e1mqxGZB0HdxMTfUdA4iPGxKgp2Xc79Ckzng8c2LBjNH2OkEl/sA/eULtjv8KSP6unQZ0vIy7ojnZFnnt8WV8k8Lubwd0cpJJy53AaCp+Th1iTYn5vWTuD1L1jQOItsF93OfOZhAokByKsaOvyIlGNpK1LigMe3FTNlRgxUPPNxt5elUz4JTR0jaYY0GYlHkSZxGG+9KMUtGurr6vEL2i5humXRj7WRuReyTU8BFnRySms0bhr6UU7P+NUoJeENntnyzplQajuQWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwpWcgRm7qer0bIxGSmM3z4aZzr8WzaU7mJaPYvWRno=;
 b=vVqS/5WQC/QxVWdUk3VaPmjIqoJLMc2Hi9TdRAPurXYqo4HOWROdSOPs99Hki0nPX1MUU1+aFozTU+Ns0BxljX7c0+S+zBEGHVfhekkopCL1MOvelenb6jc/PWHpL5/q1Zt12COfU5G89mSLp43MDS4oae+betaUtmFePlpjwanZL3MhyOIjYxbh/qNcU0q5NNmTBHhWyfHWiuAiNG8o4C8l7s6SQ0rsMbP2fva0PMXl4H1FUkV5aSJ5qPWdsIR+iJqv8xFMmDW8NnRgCU2PPHfdBo2HLDVTDpF6oW7oOoBHeAKaaRuhvM+BZrNKR/eau04Um6Oou1g0reBo58j/vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwpWcgRm7qer0bIxGSmM3z4aZzr8WzaU7mJaPYvWRno=;
 b=cljvtMEFPmTjSwvOjvOKG/s8U/3ueY6kCJHTPVdm1KG7A5O90ITG3Q4jkYyLyln4/HidNqwa1ijQBdBw0bhQBeTG7Le+rOOOZ+waG1hB3DnM2TlanNjM5VxsN5q7IMCDxuK2Zxn0omP2WR1+w5MW7Ew0Qy7REHlcIQy4c5wvAFt2oZ1iuRbWDpje53f+EnG9huLfIScM9ySxO77Kr2i+jX5LoG1B1WJq80KvzMVKYhLv2iOHRPMOvfcCIuuARfeJp1bZ9qAMxBwXStbQGnTPL3YyopRx47QYwZuxUQKBoTWEo13FH5/4B5+ABKELvIMw/K2OBTTQDqr2wR3Wf1b+/Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by GV1PR04MB10967.eurprd04.prod.outlook.com
 (2603:10a6:150:203::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Mon, 16 Nov
 2026 14:38:33 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 14:38:33 +0000
Message-ID: <1fb7c21d-6852-4930-828f-c790ee49747c@oss.nxp.com>
Date: Mon, 16 Nov 2026 16:38:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Use ufshcd_query_attr_retry() for RTC
 update
To: Enric Balletbo i Serra <eballetb@redhat.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>,
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Mike Bi <mikebi@micron.com>,
 Avri Altman <avri.altman@sandisk.com>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, NXP S32 Linux Team <s32@nxp.com>,
 linux-arm-kernel@lists.infradead.org, Frank Li <Frank.Li@nxp.com>
References: <20261116-ufs-rtc-query-retry-v1-1-4de69b175e8d@redhat.com>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <20261116-ufs-rtc-query-retry-v1-1-4de69b175e8d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0044.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::8) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|GV1PR04MB10967:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dd56249-10ec-4363-1bc5-08df43ef49f9
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|19092799006|366016|23010399003|921020|11063799006|10067099003|56012099006|261026121527099003|261026140227099003|261028144727099003|261022075727099003|261022105027099003|261021121427099003|261102123227099003|261021123027099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aGusbcFg/r05Ir/4B2JvUtpZ3csbKrA35m67FeZY6kXom4GT1AHyFBTvh0dQOOsC99ndjanTaztu6Eo1qrzQSS7+Z9FBgX/8suiWRFilFrGMcuYkQLuacXrkandtJZXb7QBmxcqKVNwMrMD3MSb9WmX7JrQIiPf7r2F/OgHgjjQqenCv8m9e1yYWITsnrKpIBglLAffOlQV9wiotSVqgQhbDS48viG0wSdekqvo8TS27HL+1oJTxebuvVhV3/clzQOlU9ir5kxtjiLvsn+5t8o5k3PrMWjqtmpLQBxoULDiXWLF/x2sRPsUIdl+MNyKx36ZC7Hh//TgP2Lz8poh2ZzCvS+O88zkg7KzbKqX3j6B+7YPlMhvYGIo6fMlNam/OP9vQpILcarDApoCABuvwgJq41lESO3512Ub/o4ZGfHnkGqQwZM+JpxNuivMvzfPb496vhqbRu5aZ1jkQDEuwcHPNkWv44sYoC/wyMt6vo8BVCnm5iQAiXLNRjX6bU+fjYBGX9IdGvzdoZ1AnW8BxlQAfrmkw6FxN0Hokj/Vy/bT7ayyuL9lNqH94Geimrl5789M9Lhc2eL3poCdYWKn5OU9YTjINYzGQXMvQhUYjk+Ko4XbOCilys5RbpD/Du8AZ3Xu5Em86ukG65pncFFNVqFiBQDMz3Cbd4bCm/Qv4fHLsn1W2xAWbcyXKhSpOM9Jdp9WOmz0UJ3OyTR1aMwWB2A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(19092799006)(366016)(23010399003)(921020)(11063799006)(10067099003)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022075727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261021123027099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2hYemF2TzkzbnR6dFNCSm9XV1pyRUx5enNLNHl3K0JsSDZ4TWR4K3ZjRUhS?=
 =?utf-8?B?VWx6bEh1QmVVUTNhcFVwMTdBUGJMNFVQVWNKMm8zb3pzcjRQd3Q4OTRCV0g0?=
 =?utf-8?B?WnJBN0o3Ni9tRHFjY1p4ZXcyYzV6QURhK2VCME5tSVNNWlZpcFJFTGt6Y3Vm?=
 =?utf-8?B?MU1CVEEzWk94VVBYM0NkMllBMUtVbUxsalRNSnZSdTBLaGwxSVBQT2xMUTc0?=
 =?utf-8?B?QnFxaExvVHl2bFA4ZUg3N2tNS0FzSjhGbzEyUUVMaGlVazJPU1lwN1dieEY5?=
 =?utf-8?B?RlNrKzB0d242UTYxaXVlcDFIY3dyR2htSFV0TEt5bVpuS1ZXTExwWWlBMllZ?=
 =?utf-8?B?RFdRS1RGSVFMbnRRcTJleE01S0dRTmlITmdBYnpWMXlrWGhub0xzWS9melJO?=
 =?utf-8?B?M1Q1Q2hiVVhWa0NXWGhuWStKU0pya0RQZE5nNlJKaHFvVWd4VzFOM3FXRWtv?=
 =?utf-8?B?eDRFNVA0WGNoakdkZlFxT1h4TFdDQTJESmVQbHpkTVg4RWswRjZNYWtLaEk0?=
 =?utf-8?B?MUlVMGtMNU1ySTlDN1BMN1RaMjZ6N2pJQlhHbVl3NnFMblBwRDZGaEd4Uk9F?=
 =?utf-8?B?UkN4bU9xWDNzNHJ4R2xsNDg3d0txMnNJRGFtR1dLSzZvT3F6Y25qWCtZYUZD?=
 =?utf-8?B?S2ZmSHJLZDhZYUpQbXV0Y3Bpbzd0RGVHeVhiTjRvK2FUUDBiZmRodEFEV0hN?=
 =?utf-8?B?TktUUHhXWTZLdjRrWFhrY2N3U2dPZVdvWVd6d2pVdWMxYnpjZlZNd2FyaEdQ?=
 =?utf-8?B?YlhhaTBDamJzdzZYUFVtVVhVZ2JkYk10UFUxdGN3djUwZE10N2FDL2lHeXBN?=
 =?utf-8?B?SEF5ZFlyRzJiT294dHhPZXB6Ni80UnpVNkJtY0dxbXBtYXAxM0J0Ym4yaktY?=
 =?utf-8?B?ZDIrNkxySVpZMGxqcGdqU1hnZ3JnOVI2TVhNUVlDSTdNbnRORzBGRkRDWTBp?=
 =?utf-8?B?TFdzNDJBeFV3N3k4QU1IbHJKL1JLck5lOVJ1a1FHQmtSWk9jYzIvKzYzaSto?=
 =?utf-8?B?UmU3cW02MVBrS3NjL3ZuUkE2bnoxTHkyM0FjVVk3T2tNM3FXa0hwRFNlVTRr?=
 =?utf-8?B?b0RsczJGUjlsQkllRXpSK2NnLytPOGRLa2FWMGtUQ1FFQ1Z1NTNEMHJNa1dM?=
 =?utf-8?B?U3RjSXhXeE1LclFVSDJjTURrUjZzZUtmaTR4dFVzVlA3MzZKZlltY05za2ZC?=
 =?utf-8?B?dzZiMm95RmJVMFRyVU9yR01valVzWVVKNEtXWGwraHh5eGNETzNiSDlWb3cy?=
 =?utf-8?B?a2FucFRTanZ1aVVlZHhOeExMeXNDZWVINVVleUFXZzhaYlphbitMakdxb25r?=
 =?utf-8?B?OSsyWkxLb0ljK014YlBaVSt2NXBlZWNhaVhBOHFNWXh6YmFxWlpoVzZaMkRs?=
 =?utf-8?B?elY3bFc4a09td1F3OUJlN1V4b0lHNFBZQTk1dDZXRkM1UVZ2d0xYdUE4eXRo?=
 =?utf-8?B?ZlNySzFqNTh4OUFTQzJIREFFNmoxWGhFUVNXMU5YaDdVVEpPSXIxQkVyUE4r?=
 =?utf-8?B?SzJteGNteG5wK3FDS2dOVkdwbzhGQ2l2TUowTnBGY2FXQzVHYW4rM0J1T0lj?=
 =?utf-8?B?YmNpajB4QjA4RW5UdnY1UGpGVE1EU1VVVlJTRHp2dzJKVjBOOXhSVzFVZGg4?=
 =?utf-8?B?UktERkxFRDhPY3YrWFNHT0VsaWJVNVB5amRDbGJjRWc1dlBYUTFXeitqemZP?=
 =?utf-8?B?azcwZW9Wd3NCRksyRE4zanI4ZlZGODJ4ZjhvT2pvSWFHekhIUjA2WXhSYU5x?=
 =?utf-8?B?YWlpTGlBL2NJRk5xemJIT2t4VldlM0Z1dm1RVUtWM3paSHovcXJHdjVBNEhh?=
 =?utf-8?B?d0FabU5NbVlMMjZ5NXFpMnlZVXF2N0FwcVltMWx6OVVCcHVMS1hmbHE0enhE?=
 =?utf-8?B?eTNDZFh3OUtKRjFlOTNZd2VML1YvYTlTWDBwNWtDZXZJb0MxOFAwNzlEWHFE?=
 =?utf-8?B?c1piNzB1eEZVR0F3WHJwWlZDbzFHOGFyeUxWU2VXRkxkb1NMWVhuY1hGRmM2?=
 =?utf-8?B?TSs3ZUprMFZqcmVOWWlXblRPOWRBRnBjQTVERVUrME9NMEYzalBPQ3htelhv?=
 =?utf-8?B?SGd0OE5jRUc0SVdlRTMya1RkL2VwY0R4V3NXYzJ0N0VJODhjbml3L20rSU1i?=
 =?utf-8?B?eVFoOUxVaElVck4ySC9wTHZMUnhxVzcxTjc0Z251SThYSWU0SHM1THl2ZjhB?=
 =?utf-8?B?VHRXeVdyMmVXdUF2cm80bTQycFBVQWo5N0EzSFFNQnl1ZElOaGRpUG9RRFVP?=
 =?utf-8?B?MWErTHd1dCtKdjh6L2hPWTNtU2JvNVhPdC9pYUV2UjYrU05URHd2WUZLeDd6?=
 =?utf-8?B?UkhhUzA1RkIwRUdON3Vsd3MyeVkwQnMxOFFFYU9HRmtkTFVQNUV2ck1IR2VD?=
 =?utf-8?Q?5G5nnQ5FGdn+r4QM=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd56249-10ec-4363-1bc5-08df43ef49f9
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 14:38:33.0115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AT7dF1C32Zy80Mi8f2d0RIA1zRPYPbH2EElT5sDN2891yS5rATSmZdzAUmtuYB2pqDiis7Mec918UBigmOle5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB10967

On 11/16/2026 3:39 PM, Enric Balletbo i Serra wrote:
> ufshcd_update_rtc() uses ufshcd_query_attr() directly to write the
> bSecondsPassed attribute, making it the only query attribute caller in
> the UFS core that does not use the retry variant. All other callers use
> ufshcd_query_attr_retry(), which retries up to three times on transient
> failures before escalating to dev_err.
> 
> This causes spurious error messages during boot on some platforms when
> the write-attribute command hits a transient OCS_INVALID_COMMAND_STATUS
> error:
> 
>    ufs-s32n7 4ac80000.ufs: ufshcd_query_attr: opcode 0x04 for idn 15 failed, index 0, err = 15
>    ufs-s32n7 4ac80000.ufs: ufshcd_update_rtc: Failed to update rtc 15
> 
> Switch to ufshcd_query_attr_retry() to handle transient failures
> gracefully, consistent with every other attribute query in the driver.
> 
> Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
> Signed-off-by: Enric Balletbo i Serra <eballetb@redhat.com>
> ---
>   drivers/ufs/core/ufshcd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3c28bc67c65f..1cd32b7cc967 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8821,8 +8821,8 @@ static void ufshcd_update_rtc(struct ufs_hba *hba)
>   	if (ufshcd_rpm_get_if_active(hba) <= 0)
>   		return;
>   
> -	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR, QUERY_ATTR_IDN_SECONDS_PASSED,
> -				0, 0, &val);
> +	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +				     QUERY_ATTR_IDN_SECONDS_PASSED, 0, 0, &val);
>   	ufshcd_rpm_put(hba);
>   
>   	if (err)
> 
> ---
> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
> change-id: 20261116-ufs-rtc-query-retry-3f27084f878f
> 
> Best regards,
Hello Enric,

Regarding the OCS_INVALID_COMMAND_STATUS seen on S32N79RDB, this 
behavior is related to known errata that will be documented in the 
future. I plan to submit a separate patch series to address these errata.

For this issue, OCS values 0xf and 0x3 are expected.

Best regards,
Larisa

