Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DA71411EF;
	Mon,  8 Apr 2024 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712591176; cv=fail; b=kkVChAOvSq6aMc6bDSelvsL9EnCSe3GXs98RupljXITEX5t33jT+t1SGBmutwTnMetoN10yQTd7l9NMP2O6IICVN03jqZwwJYh5J8ed9n334DvLvCYZoqbhystwrp+sW5/wLfwOJQJlWmoOpuFd+fi485HKF8sSaJuMZZ3zo3vY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712591176; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aNfE64TOAxh7bvf5cgezs3lg+OTPCucYX5yRAngznYD7rt2bhVPBA7o1f+zu0aIPztaM88W4EXu2+cx4WIRdbl5cl3GtUPMq839ZRqdXkd00rAlTHkV21vcWVLE/jzFiivtabNb5eclMi4WJ7rhmNv+GLKRZGGKY3FVN+TEKCHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=h1Ii/Ch2; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=NJJjIYhX; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="h1Ii/Ch2";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NJJjIYhX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712591173; x=1744127173;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=h1Ii/Ch24XniY+8zQxv5QkNDu5b8/CHCHqFA+rqzchi68v7tf547n7H6
   dUoeLKVSsmxqSPScxGVK9n2F72dgpQ8U+inF6iu71riphw2DB+nGMTUe/
   a+lF+QgXbJ9LRGwjuaCZXTtuZw/4GmA6SwWQAIV8LfrnzbcR285au0/BU
   YHfP6a36LjiSdzOiF/cUtlkC3mQ0EvtAIJtJ0g210Bn1HWv6ThZ7spGNM
   aOxewR4OjmlFmTVZ8AlIw10EeoYS0Y7dC4TcAL9eFJO3yLUOCgz/F5lSk
   PYp6x4kiUvg1bYU6RO2bP6jCJVe1m0HsY5QDHUUayRSgYuWlmUX1rtqbD
   g==;
X-CSE-ConnectionGUID: 4he14fT2RRSN/AsvWaKf2g==
X-CSE-MsgGUID: VYm83k7xT9yDkHLIjJoC0w==
X-IronPort-AV: E=Sophos;i="6.07,187,1708358400"; 
   d="scan'208";a="13764819"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by ob1.hgst.iphmx.com with ESMTP; 08 Apr 2024 23:46:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gx4LHi3DH3SR8O7T0bj24LqLFirfre+fzmsgTDUyYLkvaMf7/4ED1X78uY34Dlkbz9OESzLVJR2OK7t114BVWOybm0rSqTFOe+DKj5fOr/SpGxYQqAS0WB0dPFzX8s97ah6HMGsud83YUp/+b6q+BRDt2iJ7MtdS7bh9Hnn0hJ0AbjbC+EZEjPrzFLisUPx5KFuBr250VsTskwGJmdpnYPk+2fx18jD+EPjqKBfTqOX6BrWQCk+OJeFIrzxalQtzCgQceHVEdO0v4j79aoPr3rxz5Z/8SQ5nBp6NSyBRPuWk7QyOBJjznUYXJ+YjznFpGGT9R5FV/VJtskKZn1elTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=hgttpY+e2LLWQ/1W/uxrhe2gX9jd70qdQtk/K1/M6zv5AkvriTS4MxTcsiHg1txWH8dqB2oHZzLfGQMBkXsM60Zlymnc9tTDtdwNHFHLOq3sCJymYeDgyGOCF+2LoWraibiogQ4sU78Lw5b/ufU05wOmN0D5Zf+uJftu+vGvmkkwFY+h0yVVQU3p5pbqAJusRXfvsye17DTjI1CA/zbhVsAOpxt2c8RKMt8ao7MHI9n2pbf9iyG+PVKN/qi+GaysqfUvNzuyuBKkZaO/l2vH38zcHE9C1GulpgG6qX05Bp+Xivl6Y/KfSnZ0aOIUdadepGOf8zV872n7GkpW75ZW0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=NJJjIYhXEOoSH8mh37dGIZHoVPRgtl2YJHx5LxzZBkvfQQ4M/b/eOFJYxdH+MyxMMFvXLrY85DuOCRscWpKYU6j09jJ/49+QHqHEnpBtYsM/gWa6qtv1dEfErOgMUs7Gu/NFdvjB1VJJS2Pn5Tk1POcwXMuRPNRxMFL+C8uK4gM=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by LV3PR04MB8944.namprd04.prod.outlook.com (2603:10b6:408:1a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 8 Apr
 2024 15:46:04 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 15:46:03 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 02/28] block: Remove req_bio_endio()
Thread-Topic: [PATCH v7 02/28] block: Remove req_bio_endio()
Thread-Index: AQHaiVXyqiQELICHPUWIipE/24WVobFehQyA
Date: Mon, 8 Apr 2024 15:46:03 +0000
Message-ID: <20fc55ee-7909-43c2-814e-0d205ef0ce59@wdc.com>
References: <20240408014128.205141-1-dlemoal@kernel.org>
 <20240408014128.205141-3-dlemoal@kernel.org>
In-Reply-To: <20240408014128.205141-3-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|LV3PR04MB8944:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 pNNkC55CmlnFyTJhWRdi++Y5rXRH5UoZQG2m1ondmcta/wHk+2Ksyc/nrR7roB48xqSWp+nv49vaeyaPgHqgGQsOb3LpiUr2fgnUhsuNrJLQXG8RPgTDGn06WK1t+kXhhsUPuQdz4Ton2i9UrgkWqnnRA2WqZy2lJXRTQ26aAH+XaVWfhrUCqze5DhG0eEsgehoG7aQT/9ozHwb/VgctwhlL5CoHhG0GYhATEbP1ckX7zedp38RRV2TqYxaAWkEW6IU8D2sqDacMH6Wx8iCoyD6xTNHBiFgpv7ZSqeTAvG+tR/nk8CoHEVaGS7nNIkPUfw1otFIw3e5r+AZAJaR4tp7Fb36TOFOH0bsLzV3mn969TmqDxWsqTuQ4dhf8dt+LpFbFEqhgb7Gkv7Il+XqD8KkQnsEeXiRKYHxGG/rDEbmvkXwradeMU06i+goUt54ggFKd0I0Zl81/a933w5EpxmYkC7licQAlWXpmtqh6k2evy7zpBU0DLCB0TBMDaNTUHWbxwrMni0voxsfgL+icv+uSLo3sahub8/4p6kdlXuorDDBZC75KuGxOy7gfMADAZQhPlUcbaSdxjtuucl1LBupaiFbdC9gtTLbRfrO3mWEellf8f9OSDyyb6Idy8BoMrHLrToKznQHH5Im1qwcFFeiMK/fDYzRyYLUglYgiQ6ak2oBpyYYyyEihIZXMIVYWIUq3DgxS+YSHnIREoEqvKg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aFVWTW92SlNVM05ZM3ZJY2xMSDROYm55Wjg3enZqZjhORmsvQktxREl6V0pK?=
 =?utf-8?B?cXQ0S0ppc2FYQVUzd3lpTXJrSk9WUFBPN2tka2JMbUdNZWI0bHFNV1F1c3pR?=
 =?utf-8?B?OU5XeGE3c25NYVg3bEo2dnpuY1ZaTXF5Y3UzSW0xZ0c2dnMxTTVDNExFbkRm?=
 =?utf-8?B?WUo0ci84VDlRb3p0Ymc2enJlL3lkVllPL1RJU0lCTVdmejdDbi9UeXhLQ1Z1?=
 =?utf-8?B?VE12N0IwTis2dE5YRlZGcUtMM0xodUlOQUpwZnpTQ2g2ZTF6bTVmdEErcGFj?=
 =?utf-8?B?QkZmTThGY2R5dEVIOWdNLzNKcWZ2bldsbDc4bXVlTlBLbnV5L0RiNUV2NlJt?=
 =?utf-8?B?WjZxaUhlZTVWMnFuUUhlSmFqSFRVR1gyTHZmYmQzT2RtMitROTdKNTFSK1du?=
 =?utf-8?B?N1dyNTFEZWo3Vyt2TmlkSlVDMVR5RFNLVjFsT3g0QzNGVEFPNkhNNVcrN3hO?=
 =?utf-8?B?YVY0dk12NUsrZW41UElIakRxTzhING9HQUxBSCtaNUpCV1BGbmZRRUpRTmY2?=
 =?utf-8?B?dVV3WjRadkRQS2IrN0kvM1RJU1lrRnFBM25HaWJUWW9JaTZXK2RsVXh6SS93?=
 =?utf-8?B?dzh1aFAzN0RIMEs1dE1mekNqWkMvc0pHRTJFZkF4dyt3dFpLSm82bXN4T1Jr?=
 =?utf-8?B?c3lmem5XZjVpZmNKaEVCQVlKakdUQVp1Z05DZnczRFZaOWJHc3dIS3JkMWtp?=
 =?utf-8?B?NjJqdlljL1lYUkxCdm5ZSXFnbHhQMlN5MklOTWNxL1FkK2Y1SXRHZkRJQWZE?=
 =?utf-8?B?aGt2NFVpRHpDdWVveVk5aUJLT2ZVbGdPbWZLVlFkU3lIQzU4K2lRa1M5M0RR?=
 =?utf-8?B?elFSbEtOc1lnTEhFQWYxakExa0ZIdWRxbkpFekNUTGVnMmw0M1E5SFJBUGpP?=
 =?utf-8?B?eDhpUlA1L3pVajN4NWxnU09nT0JYbFI2dGN3TmR5cUs5Y0xkQ0V0eHRYSmhk?=
 =?utf-8?B?dnBFanQ5UncxY0NiVUMvYS94ZGFUOGErUVJmeStqYktwOW5CMlFZRjN3L3Vv?=
 =?utf-8?B?VkNLSStIb2U0SXV2RDhkT3lmUHVsaGU2ZVNBSUJNQ1ZpVFNUS0lOaUpDMUZs?=
 =?utf-8?B?M2xvdE81NVlNdmMxYmx1ZXV4U1NJL01HdlBnMXJCcUdCTnFzOEk4clAwL2hE?=
 =?utf-8?B?eHEyUlQ2M2tsbUhUTHpxbTRlTEpTUWdhUGxYdGdRbkV3K2k3d0NEMG8xUlJG?=
 =?utf-8?B?WDZtUWE4WHB4alJMSDVqSzdCbWVGWEU5RllFYTBBa25NSGZHUWVzRGR6Vmla?=
 =?utf-8?B?ZTZRa2Z4azIyYXlPeXFpR2dsa1p3eTNxZDhndzdmelZtR0tPVFoydnRnKzBE?=
 =?utf-8?B?YnZJckxWUVhmTzcvLys5R08vL0s3SDFCTGhxZUZmbnR0RmYvRU9XaFA1K0xl?=
 =?utf-8?B?NTVDU2UzYUdPNTdRbEtuWG9Rc1hzQzVaUU1LOVRsanlvdW9OS1dJeGxrdUhi?=
 =?utf-8?B?WTZoQkkvZ1ArWVc5L05tTmIwOFlqOHdqMWlrUXZtYUZWQ2lUb1FicEZjc1da?=
 =?utf-8?B?QkQrZTNDOXYrNXduQVJ1UGhLREpKSU54MncvaTBlWXV3RURTTWpXRmh3UnJk?=
 =?utf-8?B?R1BzTlo1UFVZWEtMTEpycmg4MGZpWTBiVkloazRRRGdJcGh3VHMzaU45SzVt?=
 =?utf-8?B?SHJQd0M0cWcwNHhQVWZPY2Q4S3JaejhGZFh2ZEZqWnl5SENkaFJmQ1FDR1J6?=
 =?utf-8?B?bC9RZHROaTROUXg1akh3OFlLN0ErcVU0YXI4L3VqSFYyWFVhWURSRXEvQnc1?=
 =?utf-8?B?cEUwWFMyQWdtK0Q2QUdCS1JJYktCSFdHcllIL1pYemFac3Yzc1lJc1BQd1pn?=
 =?utf-8?B?V0ttRHVqWTMwSngvTmZoamo4M3NjaW5DVjJUZGpSTjNnUFMrSVdwdVRJSi9O?=
 =?utf-8?B?MnZtK0k2d1Zzai9zeEFPZnMzemdjaGdsS091T0N2QW5aNkowVHozMTB3aTA2?=
 =?utf-8?B?U2ZJdkdqNWFtaDQxaEQ2YTVjWlJkSm9NV3hwbjN1NzVrOE1vV3gwUFJWUzdv?=
 =?utf-8?B?WVhXeGRvc2pobjVGUGJTbFZYVVZZaHUrVzJocjF6KzY2OWs2VTl1NzhOckpV?=
 =?utf-8?B?dXlrcllHM1krWDhtaVlYK2NNTkVTeEFCWEp0QS96Vy9JVkhOM0N6T1V4TDNt?=
 =?utf-8?B?a2ZxV25MSWNNNzc2TzVxVnBwNDlCRVVKVitqa0VsWXZrZVNIbFZ1U1V3MGFx?=
 =?utf-8?B?R3QvVk9wSW90a29qYnlNWEN1NnVtQWhJUS9BWlBRbUhBbDJLbnhWeWlLLzZX?=
 =?utf-8?B?ZEZpVHNSbnRCRmJhQTRkbUFNSnpBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97CD4EEEB2843D43BF6A23C37B209C15@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F1aE41mlw9feXjr35WJf/5qMOnXx0cCmHW+VGzkYmg073NF6o0dWJqi0F3l1Y7TZ+yhI/eCewX2zKJ7cXrL9KCL+6n6jzWwx+s1tkD/4z4+g3KJiScV70p7AXBXb72Qp/hgKHI/aAtL9o5CIgSMESeRGb+l55bpC7ytQ78NbCh51GSdnH5enUyYSCCPXx2iNWrGiCNwJV9vXb5Y8La3u15rIHqzRBHXSi117/KYrLgZS6G40Fr4XiqZdFzKDFIsSkcX0m2xGeXN2MAkZulqe/R5L/GU15tswHmhd2ouO7xeupFnuAdFWneB8jdehJtVzTWaJ1la8bnP4c8iyj1I6RK9B6VaDU8cCfYTsiJIoR6DK01KHa+Hf5CeKNHnhAOxUV5K7rRNl814v/lZlYzLjJO7Hy7vyojGxph/JQTRUt4diQnMzjwkhPU7jJHP7wYpdVAUU7Y2goGkHfGGpiiCoFOn7S3F2cwzLvegIUW6IXXsPCg8LLu/R5mBKZXf+ZAUeagYgiGgymb/5XthS/Hn8IVGjnlmJQMORHu0ra8mzNu6dw6Z53p2jcmWyhHMXmGBH7p4YP1ZIcYpm4I5P8+r84qMP1OhMKpnaF6Kp4p76co9rrBAcw7Ct1dcKnOaaWBS8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fe0909-5499-4bf3-e0b5-08dc57e2ff1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 15:46:03.3770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jrjZ/2OGpah+K/fv75KCzCp2CeYhUZYmi1ILLwnwQlezfO0EWjINzKdcMuEPdOgfv/I4dPu4bkzPiIRF6anNhi0N7XQ6V/F7ljrfOHThhdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB8944

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
