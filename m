Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB084CA770;
	Mon,  7 Sep 2026 14:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788792518; cv=fail; b=r04CywNrVRvxmQL8mWluVBXSYcT3P04YhfusFY0iN564MfPZ/ELaycouitn7qFApHy5RaTdYTphFD73Um0teq6F/GTBn46pRsFY4/GZxuvkWKBcQMMcP26ClLZtvIPqLdSotWk+LJa8jWurzcLK7ybs2OqOROkaeyJctY/XvEzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788792518; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XemDW3e9zeo9n3YFQOZ+VC3jKFvTSQC9DQGhdIFVyD0xYmnGULP+OvfybccD4VuuGcTj0RnfPfgH1X/4stIc48/SPzDNyyfNMTA/ZGLcDHqkt4AAiq/73F1Je0mBiLRMZCVKdRqlMkLe7VWQ0qPoErfNN5ivZPyGWQwwX/Jk6ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YL7MjT8V; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=n/CSmJZG; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YL7MjT8V";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="n/CSmJZG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788792516; x=1820328516;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=YL7MjT8VExACOP+OEwxkuaMavl0uKBC/yfOrTRVlv3bWpQnmusAi0P4s
   D8lMsetkwO3jMpVLjvvi3bOtzGzp3bEQ5Ggo/sTtLrIV5WTAjFBgscT23
   NNkWHlYRdkaIZiNECQeoyWGkPH9Q4JcVC+2MDAg+NV9qeCdiig9h3YpAC
   3DIOyygy18Es0XSaxsMGKNL1KwKXxt+IIDKBRgV2mowNyP2NUdO8UpEBl
   XLwGrJJ7S9OCyv6I8DkVrOqoz5TvsXgwdX3wnszyDFMyiKcuW4piMJnAI
   ag7RlOdE9lLeR0wOLLX62VTrpgUay9HPUvrtQgxv31ShKVEpGPtJyUG7J
   A==;
X-CSE-ConnectionGUID: NxVQYn7LTii2eALps2TCzQ==
X-CSE-MsgGUID: dUpMaT7NSoW6caD/VJYCpw==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="156048620"
Received: from mail-eastusazon11012018.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:48:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LbJNLivAytT3QiATORuVzK6qr0V685qKjwbm7igCI7G+bXw4RnxmH8BXVoIpOoHPzNmZrk6dk08DMSqsrU80edw94kis/fWG/8U/WU1Otr2iATkIsXRulV7zLJ88WVRpiUelvO3vnjuiUsCuvqqvKjP22hWpmxnICA1zPJBAJAyAbiajJO7ub22cMpx+gaXce5O24dOQEat8DQFfppzthZHLgYb2WxPGyAPSgZCfigwO0czOB0DmEDgBfSz0aaLToL4ISAxVU5mR/HcSJaULWH1SdYCmb7O3pDknDc0TtaebMA3TvqU5fMk9Rpp2SzhIiS040EHvuk6QP8PkedHIww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=t4+ZAc89w4WAxy0GaZ9MkJUUiu2TvSuvT0ZKhzEqjtSJHmVf7sY8BKWvro/NnfnFph1Zpt4KYhbA9dZ5oEDei1nlvvpVRVh7kYeXKHt0KBWE//OBJ80HTBgaiFmo405dXQ6TueD5oP84xXR3Hu6n5NnFvo08SZCyQZcwbBYS5TiFUjFyqrW+YENPl/LlYKtICtikTCTycRAVknIbwcM+gY9wB8mNkySqAHUNtsRou2lLDtVOI/Xo4fR5j3E6lRQnecrGn2JiTYYhBB9a9jDv08jbPadOV5r1aPInEVywvfcVXQDwlYFWL4D21/ZJFgYsvVHJNVF81XMYyQwxLS57rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=n/CSmJZGT1oJ3UsrYOzSllSZqo/8vFsLRoxbSBk6LKBrSuxPXJKSp6Rf9tMAUyz0v79TBCZBPypCQVQZnFNfqOCqU2dph5GgLc/6Z+/9SpW2T7cODvPLgatgQPC4daxhWCPlhbGIW3jk/z5UDn0tFqjhzvcMRRs4VE9uDTpxlI8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB7076.namprd04.prod.outlook.com (2603:10b6:a03:222::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:48:24 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:48:24 +0000
Message-ID: <c5c7e51c-1fa9-4411-b417-e810e8b47ac8@wdc.com>
Date: Mon, 7 Sep 2026 16:48:06 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/40] scsi: leapraid: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-21-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0245.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::9) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB7076:EE_
X-MS-Office365-Filtering-Correlation-Id: 254dd438-7868-4833-7787-08df0cef11a3
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|19092799006|921020|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	E7XmkWRe93uemCucBH9GSQjJPFDgr3TajjOZk8GfGc86GT2QWdVP4OM/pGlnrc2FYt4DMFuisW5c9F4xaL9eYoJUpUV1rR/0+PiI6HmFZFC6ssywlKCkfgxU4oXxgtYLvacJXmjRbZn6LAAPHVtragOdfqg3CrtaFaG5jt+M/iHmKRdrTl/J3bsvNUDO0vwvtXDJy/3sBFFrFy4QkyNIMkTJw2NLUiKtEAeVgnPFo5nMyYVy+0x6SCWj999xpPfL6XyI++NaocPjJn7qz0CSbUVrGhNUhoPgUBaC87uAfnwI6SMmgkPYbojuSFIYP7TRhMTxoZrdE97PuS7a1dSfkC4/CiOpsmGY510ltTBHGe/VrFJjrUwDj/Gs96/Z/wHxkt8E0ywdL+R4uZX8PZgOIN5Ceya+5pvshF7XRfuDkxlPSI0GCjjk2Yp8cYGc3NacHpcQDfXOSH1RuXUM66hGC2N4pZ4qXRCJnVQR3L4ELuJH6x3icWyWAWBp96K7TuITMs+jE3l3kI9CC7k8AO/XQ1Tfl4fs4ADGL3Wv13//tQ5FRo7ADnB9nTOYZsb3COBbOprdmsL3mDZaSp+q6hKC5wvKQjZtbpcqg96DeV95xfNZgH73OxFTuLIFZZJUCEGkMBJdxXXeHC7iTwx2zyaYwygn5pPFukdzENhXQYWTOhZDQ5YVn7c3+W4zhN9YAjr509H1qA22v5Bl/x2ccA+EjQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(19092799006)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXkrb0hvQ004Yk04TFFYajFqY05IbElhbEtXdkIwL2Q3RTZwMnM5czh3QVhl?=
 =?utf-8?B?ODZ0eXNpU3NKY1dpdVUvQmNwbVdNNENvNHNiZ216OVQyMVo0emdZQklXblVt?=
 =?utf-8?B?NVZUUEtJY1JYUUZFUXBKZTFvUFc4dFY1RmhXWTZIM0s2VGI4ZGtyUUVqSXIr?=
 =?utf-8?B?Zjk0K1pzaUFrQSt1OWUxd3NyZlcvem1VcWo3RFdLWXFHSmN1TG51MzRaTnR3?=
 =?utf-8?B?RWxWeTFiSGR5WXo0MXpISXEvYmRyUTVVM250NUVQRlZvV21DdFk5Z3N6YkV4?=
 =?utf-8?B?NmdUZnh2aUJGRjRNRzJnMUM4cjgwZzdxOWxuRnlOZ2tPaks3bjZkdTVqMXlQ?=
 =?utf-8?B?NGNyM2RWUTVDWDh1TEhzV0FONmp0WGZyem1zbHo0b3lsV3hBME9VbjJCY1A1?=
 =?utf-8?B?L1NtVWNSYXBlSXJDWG9GUUMwTTFsYjYvRUR0Uk5rV1d2SGl6N2ZQUWlhY3FC?=
 =?utf-8?B?S0FLWnEyREpMM2xlZ0xKeGtQU2FSd1N5UEovdUZPQVExdnF1T3V0b1hUU3Fk?=
 =?utf-8?B?dDVuR0c2cU45WnoydnBBOTVyU0dQNlREZDBEQUN5aU5jZUZpZ2xBakhUZ24x?=
 =?utf-8?B?YXRtQ2l1ZUhsKzQzNW1YZzNjbkhXVkdvdVh3SzZEQ2ZqZEhkdFZ6RUREMk9w?=
 =?utf-8?B?amxieVZ6aGtxcWJkZ3drYzFHRkQ4cVFmUGZpaTI2RHh5KzZaN3E0dEQ2Y0Ix?=
 =?utf-8?B?emJta201L2ViM2d4cVFJd3Y4RVVJSkNKVHNkZkVaREh2UjVQZ1BRUmMwTzBi?=
 =?utf-8?B?TDVHUlZDOHE5a0tNbHFUQmExNk9NTjg5emhUUGVZeGVta0tlajhobWdaWHFX?=
 =?utf-8?B?ZmR5Si9oS3RTVnZxR2l5em9iSUdTcnZyM01nQjJwWkU1NGpWZDcvaXllT3E5?=
 =?utf-8?B?TklRZmlhYWN2cFBMSnR3T01MQ1RrRlpkUnJVcTZpdjIxbmZvZVNhL3htcS93?=
 =?utf-8?B?dWVUamtFNGp3Wk1ZUlFpZmYzRU1HUXhTWi9hQUlWTUJQY1VrRGlLK2lyaGd2?=
 =?utf-8?B?anNURmZRckZLRGR0VC9GZzBqcHNyUXB2TDhtR003VkpJUyt3NTRVNjBHRldR?=
 =?utf-8?B?RkdIOVpUdi9mSGowOHJXL2d2bXBZU3VIV2szc0U0eG92MTFuZDlwaFlpaWg5?=
 =?utf-8?B?aCtrQWE3akNWdzVoSjdTaUJqRmVvYTkyQXlCTk1VSHpkZ0Rkd0VrczFOZUVJ?=
 =?utf-8?B?M1hReVZ4VnlwYzJnLys4NkhORXZrWFpOQ3Y0bXVHZG5JT21IK3NOMzA3MXQw?=
 =?utf-8?B?NmJZLzdrQUVHOXU0RndtZ1ZuZzZ0UFovTTZSUWFQbkE4SDBVc25qdFRiNllv?=
 =?utf-8?B?clRCTlFKUmZSSUN1WndiWjVRbWRheDZub1VMQkRIZWorM2JFRnRjaWl6U1Vw?=
 =?utf-8?B?WHJqWkZBR2pRV3ZIL0JnTG1tcVhTM1N4QXNXOHVESVRtTHJSaUd6aTROdHlz?=
 =?utf-8?B?L3dvbkVubGlKakxWZzlyUVZqVENwaHpHQmtiS1NKQnJRMUtXT2NhaFJSZXEr?=
 =?utf-8?B?NGFDVk5TZDU2VGx6UUFnSTdxaEVQekJDT0h6d2VvcnBUNUx0NjJoUzNnUTFt?=
 =?utf-8?B?ZzgwQStJeUw3b2czOGIweGpYYkZCSEkwOGl5WXFKbjY0NENVRjY5VEF2cG8z?=
 =?utf-8?B?L1NhWXNYNEliV0pKVGJWVFdmcDdVb1pXOEtNZjVodFFGTlROaVJJK0E4MWo4?=
 =?utf-8?B?NVdQTkJyejFQUUUvQWhoc05FMXRGdStGcjZHSURuTmVOVFNrZ3lBbVhjZjFn?=
 =?utf-8?B?ZEJFNTlVWnc3RnJ5ZTU2YUJlSExNSXVCZWxKb0lCZ1ZGeGZDMXBERGMrKzFK?=
 =?utf-8?B?VHY4Snh4dTFRK1FOV3hsV09HUC9tZnFBQWZjWTQ1c2I0VVVTZW42NGZmblIz?=
 =?utf-8?B?dlVWOWVZZU1ScDA5cVN3bHQxZWxaeWNkOEowcmgrVDA5QzNrZDlVQUxMcnNo?=
 =?utf-8?B?S1V2UXQ2enE5YzFjNVVFYkxQSlM5R2xIWjJYWWxtRGcvVFlYa3B2RmFrK0x3?=
 =?utf-8?B?QnF1UFkzZS9Fbno0RmZTaTZZNXRRWWFyWnNBekVxTmNZSnE1RzBzTlZqNDU1?=
 =?utf-8?B?UThQNzFMRW9KUUpYN0w1ZnBXNmtGbWVxZjVyS2lEL0szMmFxeFQrWS9aUlp5?=
 =?utf-8?B?UTRIVzBEeVMwRlJlMGdSdWtINVdDZWIvYlVEdGYrM2ovcVhRRkZ3Zm92SnB5?=
 =?utf-8?B?RlBJbE1PY1A0UndCUy9iakdIMDNrQmdqTFIydEovTTFiZXZKZlRRYm4vTm5L?=
 =?utf-8?B?RHliQU5oamRuOWVRTFdqbUtuUjhlNklvTUNNdmQ4RGtyNzdrNnJRbnNaeE1j?=
 =?utf-8?B?blJyRTNQZjlIam91MnVua3lzZWxTZ2RrcStheWJpbGtVeUdSL3VVK0g0QWc3?=
 =?utf-8?Q?3tB946aLGjch/yfE=3D?=
X-Exchange-RoutingPolicyChecked:
	w1DeImY0ZToNCziX4oKD5hS30Nv9EHamFqCGDXukmavUfy9+6kfIJGnenIHlCpz83f4/Y8joH9bXBidWFHhaIZdk303ZATA7Oz4z8rhufYpnisbkz8B081wZgNLanJ+0cjkBvFGWgMYTHDO0ZaeMPIL3w++ywaDcvAzDgatQHF1zRk1KV+VvJS+qiit5oQ4s5GHuD588B5N4GLWyyijoaZsuABaIXGy5THPrvC5HyEbb4V3CuOXOwZdSzpLAEoCfAgCzYgDD6/yzq2DrOznFtKxgBbZ2VV2wbxlJmHQDaLhTwef79t9QmGy0qzgi3xZvIdpGtG48NlfchqCDaMhgqw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kVn+O/8OzR56jmO2HxyWhtLfp/zwHYRtFBCSpHiTfplVGK3qC6yxiWQtE+qGFEWvbCq8ZnZoprfLXRrz7QFwiBBvdwy5NyX3AyjQZNFjIqdFIgVCpJmIm/8/AFqwCgpkVm/9npMuSDDMu7NOubEI5Z7WHQpwqDWpmD6NFLmzvL3p51MbN6Id8W92u16N7Elx0wONm5e38KYWAiUoA96Mrezol+jUO+3jDWLgf7Zr/HoBvNmH3BPFmfUf2CmaDVRQjyyekZQZ/YRhx7aIWHsSDYZ1Kt9qRd5tAKYTTcpbBuFv991umnfN5IGFoduojlcemSDI9/nl/nKwlPhpa9xBY3PICWiWy8LKC5KDRuhtdH+tIsp7NYX19yCoZR4Vz9mIPC/v2cz70dvqtED3SpgpNpuw6wbtS6an5aGsfq8YM+2N20Uex5DzyO51clkrpgQfbf8xWk1anPTDy2qz8TJ5Dr4WW1cyLmZTJkWn8bKQIP8P/ioh94bCTnzeiYXl9uAV03W/Zn5slaSEd1XA6F+3rkoJc2JxJC3SEbZFLWizKQgeY+uvHb2U0EcDqhX0+Oa+CmJuRHn0hLrELrHQu0p4UWxQ7bHlAu6rzICNWG2msferpuVQEIbnyV+AitL/vzCk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254dd438-7868-4833-7787-08df0cef11a3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:48:24.4762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mWUVTlI2WSpu8VY4fXdgytmqFaP+dUPXMqqY4lF+6/sBzMGQYW+UQ3mGGDlI1XpC7AEUS3wsAoudeWafDfi7SgKicNNomxTQ2zj5ka4iZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7076

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

