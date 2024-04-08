Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F804144D01;
	Mon,  8 Apr 2024 15:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712591615; cv=fail; b=OogWe4ClryiZnC9lxs1xejF86/KWY8HmsXR6E2+R87mTeGY+LMfnMCTBlUl/oq9eEvF2wIp5Os9uO0/F8YnGN6P1ikgPyLFGzANqasUmidf5iJZe3nEW4jTls8TNQzZiPCGzMTuHrq1bFyC7AJ+K2Q5U44PMALETO2GkEMiibCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712591615; c=relaxed/simple;
	bh=lMFIPg6mhHZwv2iacAybXZxquy7n7qJJEfoDMs1iKNA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nIP/vJQMs/ru8tGrewl80BU9vvIHu2Pln0uJUh3k1Ms6UYRCxMRBdzbegXEM1xrWpMYc1EZjVFKdisR5L6Jq3w6fFSv2PRKRcssx57U2Nk3SM4cpnspAvPTvaHaPcyMIMPwaLxO4qlVvK2CVDHZpjZ+70FXu+6gzYD+3v/t/J3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UNAlUl3i; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fYDcRZXU; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UNAlUl3i";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fYDcRZXU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712591613; x=1744127613;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=lMFIPg6mhHZwv2iacAybXZxquy7n7qJJEfoDMs1iKNA=;
  b=UNAlUl3iC8S1lcpOJz/XK76ogkPosa3jefEIMQbP1d+l2MAhhKGE2FgD
   iaftgTaGj2N9kvCNqjCML+eyUsfPeWuZUyx780nvFd4sKneixXGktkf28
   8MGV5LDFWRfL7gf8CnOnbVqltAX9TJojtucPuj2D1T6Mljty8dwy8N1tf
   LwLHrtq8G2rnmMXLh6ZT6zBBNZCkwWeNeTp1V+yZtbfWKlAQxZykaqKAU
   FDOIV39cqVKytTjiL1gU+Ew2TDN4ODcOEfWxeLfr1uS3EdKHLB9rcLe3Q
   8nov7YcsV23Pfd5G9tsZHJ9IqvmqFNTCduWj6i47gMrq2D56XNMK69j6R
   A==;
X-CSE-ConnectionGUID: 5KuxrYhKT1qRGsqD88ZaXw==
X-CSE-MsgGUID: XCYMvtWkS1KENf8xjtzxvQ==
X-IronPort-AV: E=Sophos;i="6.07,187,1708358400"; 
   d="scan'208";a="13521922"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 08 Apr 2024 23:53:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlZmnCamwQMmJR+MU97QEVW3vaYVETOdRT1WQtUwBVS/j+e+jCet4cLrQq7aPbBJ4S5pTI4boaKv9Fhp3q/7nmRmc+4iuDJfmNWOZXeHUYM5ppPMZxHgV6RKKdMU22wxOdqRK9BWE7TUvUMsmUHZGKP8sTvN0VKgueUmow024hKRrSzjvDLQXFv8GHMhpsLtjwtsnGkSW93N0kakWN2Kl9HJSO0r8nijifB4AF+ZyxQrW86b8IK22dr2z6FCrZVY8xU3t0hpgF3/D1AIvv1MgLDSPfReoKhgrOmordOEhu0N0tmtjopZBCZO3PUZ4lRHrASBM3KLVceNR9a7YtHpBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMFIPg6mhHZwv2iacAybXZxquy7n7qJJEfoDMs1iKNA=;
 b=QJVio2HayaS0qPpNQ8MxClQPsABGYIek3n2IcQIYBxldysmYZ41Nngs5AMF4NfAwuwQiTiIlAnf1bCLuYIHZjNKrX3WFPqACgAjQ/xEFsLpwsIr2k+IJzg5aBilEhR6kWtXQyjMeh2G+jACxeNIfMSMjYUwO5pRsbT0q/3uQ+7ZQ6IgcxUGcsxe/JSxF0gfP6sutO0+BPmH5qU4MYbaAeZLgwGvgLWWZ1rWl81BYT7a48HVBuzeRvxjnkFdeEVXGJhoex44twANoH3MFRP+YMmLeDIMcrSpGM/cOuOooLdDDAeeEEtNgm3hZ0ZgpYqNM7G4D2zAa1BCCd0ePO6/j8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMFIPg6mhHZwv2iacAybXZxquy7n7qJJEfoDMs1iKNA=;
 b=fYDcRZXU5c2CI5w9U00qgnMkk3/NoBOrGy8G2QEP9Yw/xL7jF7OO2tkmwYKoMa9YJTq+QlPWMdRQ9hdedunVRUodyq/h0i0Fco6K+Yc55CaZmLZgUNtHhQDO4cPp/nmSQCMuDuDVCbeEtq983nDNR0Yu7btPgjnAAHgBME3Tnj8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6584.namprd04.prod.outlook.com (2603:10b6:a03:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 8 Apr
 2024 15:53:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 15:53:29 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 06/28] block: Remember zone capacity when revalidating
 zones
Thread-Topic: [PATCH v7 06/28] block: Remember zone capacity when revalidating
 zones
Thread-Index: AQHaiVYDKI2H2jzD10ySlTG1mCt8GbFehx8A
Date: Mon, 8 Apr 2024 15:53:29 +0000
Message-ID: <f2fcb31b-8594-4c0a-bc4c-7a662cc4c51b@wdc.com>
References: <20240408014128.205141-1-dlemoal@kernel.org>
 <20240408014128.205141-7-dlemoal@kernel.org>
In-Reply-To: <20240408014128.205141-7-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY5PR04MB6584:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 dxUpRvQ1DfQlDCzDgINcsGUZuDdHmLDDfdJj1kuoNIoLHA4c6RxGzRUhCIpioF6EAICG229IpHf9uSmv14N1X1NZtnv8oraN7Aekss99l1Qf8A9jEPuIqsBa0sQC/wfghZGr7Z2jbv6JyAfEml5LBZetS6BZ0Snb2Nb2wankR6Lz9ZACZAcYbhxydKJbqiM5Xm3RPP1ebiwp6r+0miC0oUCmWa4vILQKpcFI2dsyFSsJihmXQUzCPG6+AmwmT2fnF+NnR8T2a74kqxhGEdWaQdxSM3koNfzKdRBzHxsNYPfNH2qxL8wIdFF2Mhk5nPN52bOeqXl4J+EEb7LgxG5O/3c3hvY9mScao7nc1hai+wSn7mriiDvc6J4VxTelcW4TUMd9H5MgOUr+mpMWNF0y0pNcUd3XM9fCZnbcVe0tuFJ3N91La35/2ksjgVR02ZvUXkEy503O0CqxKEK/bCsgPsNYLh6ocd8LS3fBEtom/IVIMEsnqPaagBqVwsAd2Omo36D1iDMc2JsloQQnXle0c7xO42mBwlu7ZIeOSHZdJaXz5SSeCdXx+23p5dytBF5VK2lE8rM1tIo1gABZBs+rv6I+jLg+2EsJwlPyEj2yAFPyTrKllriqG0iak4yjFrh6rzO4CQPhs727zAUILkpLR97zlEjYS38t+UCm3uGyA4iRZLC1cIPkWDu3cedIzay9tqMJnBssI0pGRf2Ekibdzw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YkJBU0cwZ1NhSDZKZW9od3diTCsrRzZTNWlweWRWck8wWERTTit4WlBYK2x0?=
 =?utf-8?B?NnovVE9BdzM4eUUzVkQ2Z3RuQUlkbHFLOUl5OW4yQzNDRFVnREN1Vm15VnNw?=
 =?utf-8?B?eG9kU0lsOHVCcDdGNFFzYTlvMUFtcGc3N3EzTDBNZXl2ZWhqVVRUR0N5NkU2?=
 =?utf-8?B?WmlOaVFIbytQM0dQSVpGaC9wRFNodUxGL2tSb2FMYXdvV1kwNW9OVTdCT2xP?=
 =?utf-8?B?ZkozQ3BEVmhwRFNTam4zTGhGaHJyYndURm5oUlpwaldqKzRHRGwwQUN6RHIx?=
 =?utf-8?B?N1JpbVd0OW1IZ3NsZU5mUkpub0xUY0pMSTlsSG95NWdGVENtczVPaU15SXlo?=
 =?utf-8?B?NWZmeUNZR3E4U1ZNZzA4YTE2ZEZDajdzK0dOT05TbVdTa0FLWkNnb0hRa2dV?=
 =?utf-8?B?U0ZmSHVQdFRFaG1PdkkwZDdTYlF4OXVXNHRuWTRScTcwbEdjb2wzOTljQmZU?=
 =?utf-8?B?Zlc1czBIZ2RuYm9XTGcydk0vNVk5T3ZMUXNZdFo2UDdpc3NjQ3ltVGlEbHIz?=
 =?utf-8?B?cm15empIa0kzNlJpMHZ5NngrWnJmckNRbkxKUXFxNk9ibkJ0OHl6blNJZ2Fn?=
 =?utf-8?B?MUduVWxidDREaG02M0d3TFpMTHpxQXdibGE3T2RWaFE5VHJJaEIxWHVaYzEv?=
 =?utf-8?B?aVhNTFFoL25BV2tuUjBkSVQ4ZTJwQ0lwMmM0WjkyOE5RSlJOSTRLajhpNnhH?=
 =?utf-8?B?WThONW90czFEeTZ3azBJRnhUbFF3MWZaTDNFZUxxbEl0R2F1bU1nK2RqTlpz?=
 =?utf-8?B?RWZvU095MGowMGQ5ellrMWhhcnZLSzloM0NhYmxRWWdqN0VadEovZjNTSGgx?=
 =?utf-8?B?YzZtaTNIclMwR2xuZ25ob3U4YVFOK3VxYVlNQ05rMWhwcTFRQVo0TzZEZEZi?=
 =?utf-8?B?VmE1VS9EcW1QZktjN1BaNUhpSlBUQUh1cUlQZklmbEZCbVloUG5ubktvY0xE?=
 =?utf-8?B?QkZHaStjUTZkNVJsc2gxMm5pREx4dmEvYnllSEluT1plc2hkQUVkcGlweUMz?=
 =?utf-8?B?Ky8xM1J0WWszZVphNEF6Ym95NXlaUU9udG9aeHYxbUl3Smx5SVlGOXR6Z2Fq?=
 =?utf-8?B?c09IMjR0UEZ0V2Ridmd5OWV6RCtvTGN5UUNoeTVsSnZNQ0JBZmpONTlFdVFa?=
 =?utf-8?B?RDVZd0NxWW9PMm9VL090Um93NlhYMUdPT1pGUXdtaFJPRVlCaHJYaWhqTzFq?=
 =?utf-8?B?bFBudDRQRkxMbWJiSmxJaXk2Q2R6dTQzUTVIMjlUeDhEQUZ3WGsrWnU5b1k5?=
 =?utf-8?B?M3BxVTFjRjJFMTdRVUIyTm82ZG1MVkpsOXRudnNPempYVDJ5QlVKdi9qN2Z2?=
 =?utf-8?B?a3ZYTXA0Zm9wR0oybURDL0QwZThNdXZUOFoyVUZJOUNscGR3ak45TWtQV3B3?=
 =?utf-8?B?Nk1vR3dPT3ZCS1FSemNQdWE0OTNoTXhIcUxBelV0K0FWV0hUd3IwSUlBajJp?=
 =?utf-8?B?eU5GUmFYYnlqdy9QYzVQdmxiVENuWlJVU01HUlpYMGNXYzlYSjhYQVVSSjFs?=
 =?utf-8?B?R0xSOGJ0Z2JERXdRWVBlNEFKSDhpb2pHd1FPeSt4bjJxa09sTEh0bHNlRkhY?=
 =?utf-8?B?V1hOQUhpaEFlZnoyeXlnTG1tdE1JdWF2LzhzVUNSQXdWcVRJZXVZZUZrczAr?=
 =?utf-8?B?djYycVA1MmhKcGQwQzlyVnV4YTNFbm9LM3UzUzBrdlNGT1RGY0NNVXlnSXF1?=
 =?utf-8?B?a0dOd2wrSXplYVpRR2tVRUhRQzR0ZmhQSHVlaUhHWktOV0JBbnZ6SmRrbHVx?=
 =?utf-8?B?NHErdEJVakl3QnN6MkFadjcyVEdyU1pxcnAySDRnbExVK1IwUUVNUTRSVGZm?=
 =?utf-8?B?WVJMVFM0bHVxeGZzVFZVV09aOVptZmErT0g1SVNMeFRUZWNENkVEYXJFc200?=
 =?utf-8?B?SUVVYy9jNURhNU52UmJTSGdvQlJlOVZaUC9VcXBZcnB6eWpvSHBmdUpBaDMx?=
 =?utf-8?B?THBtekNJb3NzQngzQXJpQVV0UStxUmtabEZxS2hwVStjd3hFeWMvYVpkSlZJ?=
 =?utf-8?B?aUIyVGZzcjdVUk9QRTRLckxDTW9ydTJPbVB6R3ZVQVppVVN2aWg1QjRkRWg0?=
 =?utf-8?B?ZTVySDZob0IwZWtMalozN2xNa0toc2JwQUprdCtnSlk5Uk83Q09rZmFVSlBR?=
 =?utf-8?B?QjNaY3M2WlR6dkZiemxtZ0Y5bWR6cjQ3K295TEI3Sk5rbmplMGE4WitQNk02?=
 =?utf-8?B?NDhFek5qOE50Vm9MWEpWU1RDOEIzc25naTFVUWFrQ0dTQ2hKMG02OGJ3Mk1T?=
 =?utf-8?B?Y3hFZkIxdEwwTzhNYlp6ZGFrTkZ3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B914A2BA9F6034A8129A47D9011A23C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZI9amB88n3OOYusptG0ZU5geSagf45SpyrSV80LwSiTYo4zEBvRrTEPkvf1Tbz5wL95ZKPDNlReIJvbGJvpLcA5NN6elGMtRM9Dio989nE028TCKreRTHK5JgA2/6jUYWaK8TFe54sxkt/QLHeurLF8OrAl7gn4vX88wdmKm9xRwc44L6rc3GGyScawGpPWMwnsdj6MiN3vuNCueSQTF78qA0zjz35M7RZ2qJ9q8cvVYhoDM/ni6ZywSAMQyZ70F4V+7DSE1fQPnw4Jg5pf3JKqx1BwzYROfazFV9Pq9Aj3EHGnkveFEaftFwuy6/LhAF2qT4BXCxuu8M7pO+MUXHLsV/CZIp5QX5iLTDWH0TREBctjqYN9U5TXmYn2bNusKiCKapqarHIEF87Cbj0CVYR12Wf8fwc5RxFKKi6sf/VchHJAZLOCVAdl07u8f5s98hc36/OOj67tNLTuqHbBIcM5KNFRITeEkyScJjgnWc0SenFYlIhsfpytGIBDz5przrKXE2HvdfPDL2HsHk8ZDoZrdF/ePra4gR8ivfhiSjUJOLoS9FE5/pPAP7on3QlglAcrPmWewOK7I/Ay3sZ8UQ64FMJHNLRDP54tmwWYkY/8Q3jSu7FSoVPcW3cCNg542
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0899508-9771-4410-49d0-08dc57e408c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 15:53:29.0501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AULlyvFhOQIhAYJ6kuU0U0V5J3XapSPA0GPoxKS07PrbLkqqoymStHz11h068SlqwVXIDJNS7Io1QyjNJGIss3btC/tbyuYzyATrREXX28s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6584

T24gMDguMDQuMjQgMDM6NDIsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiBAQCAtNjA4LDYgKzYz
Myw3IEBAIGludCBibGtfcmV2YWxpZGF0ZV9kaXNrX3pvbmVzKHN0cnVjdCBnZW5kaXNrICpkaXNr
LA0KPiAgIA0KPiAgIAlrZnJlZShhcmdzLnNlcV96b25lc193bG9jayk7DQo+ICAgCWtmcmVlKGFy
Z3MuY29udl96b25lc19iaXRtYXApOw0KPiArDQo+ICAgCXJldHVybiByZXQ7DQo+ICAgfQ0KPiAg
IEVYUE9SVF9TWU1CT0xfR1BMKGJsa19yZXZhbGlkYXRlX2Rpc2tfem9uZXMpOw0KDQpVbnJlbGF0
ZWQgd2hpdGVzcGFjZSBjaGFuZ2UsIGJ1dCBubyBuZWVkIHRvIHJlc3BpbiA6RA0KUmV2aWV3ZWQt
Ynk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+DQo=
