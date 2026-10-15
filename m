Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013051.outbound.protection.outlook.com [52.101.127.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AE9279DC3;
	Thu, 15 Oct 2026 01:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792028941; cv=fail; b=nkIKhae900StcAr0++M18gK9er3Ys8BAL+mDCCbl5tAa3UuIBWry3b8Ww04aUU6Rdd7B0R3VkoGc851b7/I1mYsZK/TUhdrBI2khE14E/MGwVaaIcoMyRIF0E8lu6SELc8XAxB1OTZTmYOZG8Vh0T3s31s88eq0D08EodH20oZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792028941; c=relaxed/simple;
	bh=CHlAKPGjJEFQk8L3avAjuAqQGYB/oG/p+/Z0ON1Rsm4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ot6GE6dhqAxakOy2gs+YN3ME0mqCPxx+9415LAUF7tNh72epoBVwXGfondy9FLseI8X99PfZ/vqXYp5Gz6ugnEIR+FMvUVlD3kxcA6Fc+6QDTzC2A8Yy1FiZ5jLa2c69MniMJw5sdUgQfY8hDNd4PpSZpkaL7Y9DkPniLwOGB8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=kumUu+Tq; arc=fail smtp.client-ip=52.101.127.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="kumUu+Tq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J83EUxS1Iuj4pM7XmQBJGKWimfxjigIHtD/h2JWS06T/Acj362K+0v9YQuA02JDdDn+NnpbzlqdgvMgHO+3sMLyrd+OBPI9oMH6FhSFr4P93xUpfurpDdCrroo1W/A4Tx1Rw4KfNYsQAksceCZk8cNq8+zvmVVWKrJhK+qysDTGK7/wrEvteqt59tOJWXiPYNOUJ1xflmYpnuYjq74F2RqNYEPS0L/vT9k2HRqU3+NkKy2DYXmXBiXkwq3rwH5rHYsgTO2DzkxZdII9ZgT1VSKkk7M/G2Isxa17Sxq0kqmqQ5g/oQMKlwxsaUQTu3uNj9GZacwGfFyKrCXSALhCwUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHlAKPGjJEFQk8L3avAjuAqQGYB/oG/p+/Z0ON1Rsm4=;
 b=a2qfop1GgLjvixgNB60MNsvUpAl8rw5dGaCwstHzlav7JFspQi2a4tuagmcKHLGRGTWSdxfkr0tWh+rP2DAEvB9REZY3djBnL39nJ0lRPSPsPjHkBwA9OfaPu4rmMMF6WZ6e7o0A7BfJ1X8eQu0CDlReYySqF3SRaBqnW7y81jzn/h8+ges33FebjK16K6ba59QIVGmXISaF2Lxkt0k0MXIInruxl2/qAh/c7IKWnJJ6sBJobYtHOunEbwjJvApR/U7B5B+Nie3el2zi8t0kHwe/8jF69006PcykX0Nop8qN1BZ1nIuuK+3R89KMzKw6GI61x5kHPuO4VHlxINctcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHlAKPGjJEFQk8L3avAjuAqQGYB/oG/p+/Z0ON1Rsm4=;
 b=kumUu+TqaXVsTezLZYi6jP4AAgaWtdyTKZZenDWteLQlpSgvGyRi+Lzb/lETlU2hFrS2riuVpPBUrlXDGbWlIFzFRgKFN++ZgYM8/Yg5vJ2EyVck5NTVcxx8LoRsdHms5vH3vpkcICYeJynJ891QwObBc9cVUUql1YeiTDkf+GNFAKkvK8vG+qc1cRc/S8/bA9dzNzU0dtt7KuiNEfI7hQkWx9JNYYALes5VO/jCuKxoFG/c077qO5Agcp/Na/3xehcleuzNRWp2Qil2IhVb+D9ym8rs/PtXqN5DH5OI2aBfhbdB3d3D51Gx/lLqlmsKAvEqxIFMAUVSLwkYX7UFSQ==
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com (2603:1096:400:358::7)
 by SEZPR06MB5366.apcprd06.prod.outlook.com (2603:1096:101:7e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 01:48:53 +0000
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc]) by TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc%4]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 01:48:53 +0000
From: =?gb2312?B?uvrBrMfa?= <hulianqin@vivo.com>
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, Hannes
 Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>, Damien
 Le Moal <dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject:
 =?gb2312?B?tPC4tDogtPC4tDogtPC4tDogW1BBVENIIHY1IDEvMl0gc2NzaTogc2Q6IG1h?=
 =?gb2312?B?cmsgZGlzayBkZWFkIG9uIHN1cnByaXNlIGhvc3QgcmVtb3ZhbCB0byBhdm9p?=
 =?gb2312?Q?d_I/O_hang?=
Thread-Topic:
 =?gb2312?B?tPC4tDogtPC4tDogW1BBVENIIHY1IDEvMl0gc2NzaTogc2Q6IG1hcmsgZGlz?=
 =?gb2312?B?ayBkZWFkIG9uIHN1cnByaXNlIGhvc3QgcmVtb3ZhbCB0byBhdm9pZCBJL08g?=
 =?gb2312?Q?hang?=
Thread-Index:
 Ad1X4Nn5DvzfrXBnSoCZVyBu705+6gCeASuAABfIUFAAG63OgAAVJJUAACZ6+YAADGEYMA==
Date: Thu, 15 Oct 2026 01:48:53 +0000
Message-ID:
 <TYUPR06MB621717C0153DFB5C495A93A7D29C2@TYUPR06MB6217.apcprd06.prod.outlook.com>
References:
 <TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <20261012144923.GA10852@lst.de>
 <TYUPR06MB62172FD04314EFE34D8091EAD29E2@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <9c28fbe7-089f-4d72-86be-5805bfebb213@acm.org>
 <TYUPR06MB62173975C70E0BBCE434475ED29D2@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <889a01a1-cae0-4038-b0ad-2ad29231152b@acm.org>
In-Reply-To: <889a01a1-cae0-4038-b0ad-2ad29231152b@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYUPR06MB6217:EE_|SEZPR06MB5366:EE_
x-ms-office365-filtering-correlation-id: 94d29cd1-5706-42c4-d94b-08df2a5e77a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|42112799006|376014|7416014|23010399003|10067099003|18002099003|22082099003|261009223027099003|38070700021|4143699003|11063799006|56012099006;
x-microsoft-antispam-message-info:
 1cXYmAE6F3AMiA0UdCHyWbgMrm+HRUbcXC7WYXdrU96aJqPmT8ZAf6y4gKTOchIFfFCeTVjDnfLr0eAWynsotu2TXHHateSmMHVw+610IPYlb+4Mzu5KsSwURvhdG5Ow0gdUnYi1C/e8G71b7HIxRvT1DwwndpmlpLuNjbVVuRPNDRNvAmTxN/L1njbzr/pmXUbLjpKTdAk2Ic5AKatzUsPU8YDS+a2YvvQs0wkPI3+ld2z150H/Zb/Qwa/V4SWLxgywXDDmW1hYgpnBR1Z/UJplYtoIwkekNCp+XAwKn7zg8aKRPCa2opbLzG8MTzdEF/38AV+3+XBoak8fwItJl2OWgGyXeXPUAOtsXisoWsrfGv6wonuvr6voSB404rC4rS+bQUL2IqH85NCcp+B5BLfnorzqeXWvfca78FRDdnSaLXLwall4USCzXJ/NZnF3J9MxxdbEGHq0WW38FV/lNagukvIKWif4FnlV1hePm08HoTFsPjXCaQbbI35ygT1nSRBsm4V/9sLNUaLmxz/XJSs4OWCTT1pIrdlBMpEU7MxO0UMxeyBcS55Gf/2wJM8IBSlh1+uKWOI58XRyppy5Z3b2+OeBTe0O2oPcrAUcucfQnnj4Cc7u4iQOCcEi4jq1LPTP9FraFGoF25Zu5fBpgXKcXSvlMo0cIw6/7GLlY1o=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYUPR06MB6217.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(42112799006)(376014)(7416014)(23010399003)(10067099003)(18002099003)(22082099003)(261009223027099003)(38070700021)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?M3kvTjRpSjVkR2N1dFdGVk1CWTJTdDA5WFhIdTczNHhxWThQNDhLV0JvS1Vu?=
 =?gb2312?B?TFRjbXJwL1RsNmFCV0YrK3lXa2d3RVZoMU1uUUtvbGhkdTlYQk80SkVnVnZW?=
 =?gb2312?B?anNSQ09wMVRIVmJJRzdyRW1YRWpNbEFUMHlkRkhTK2QzbnFRSWFmcWhIditN?=
 =?gb2312?B?Ui84S0RzanlKMjMwbSt3U3NrZE1GRTJUZnBPT1FsZzR4NVdQL1RqMSt3TU9X?=
 =?gb2312?B?aEFuQ2U4ZWRIWUhKVndIczdxeGI1QWhPeGx3dDZBNWNXeGpaQ2w1VzF4bFN4?=
 =?gb2312?B?OUlyL2ZZVVBrbE9mcnlsRTlHWXh3c0hBQ09BNmdEOVFLZzhzdklTeXFINTkz?=
 =?gb2312?B?TEtlS242ekF1WlJsS1YwaTQxQmx3RE9GdVM3OE1TOVlGWVdUM3BrM0trNFNI?=
 =?gb2312?B?UGt1Nkw0ZDBSTFhWcjZoRXVPOXRVWnJiaVV2NVBoTU9xbXRsd25BMFRhVmcx?=
 =?gb2312?B?V25hWHllZTdEUmdrK25xSGkvVE8wWndHWjIwdWQyNkVNUHdBbjJiWXJqR3JQ?=
 =?gb2312?B?NWdyTXVVVnBuSjAvWEV6QnNLVzlDOUZKVlc3MW5tTUhFbEdTbk84TEdNSDZM?=
 =?gb2312?B?K3BKZVNGd0Y4eS9FSGl3S3RFTjdkUE9qSU1qRUFBSTgvd3YyMk91cExDUVZP?=
 =?gb2312?B?ZzZMb1pUbUlqcTJzZURaNHBMUmJUQm5PSm9UVkRHaVByMkdNMSs4a3R5aVQz?=
 =?gb2312?B?ZG5iMVN1dVhtbGxraUZyY2NoTUJVa2VObVNUSWNzTnJCQ2I1KzQxSkVtbzB2?=
 =?gb2312?B?aXh4NXEwbWxma1FsRldWOXhuRjJHNlFJN1QrNGJmQmtZSFZNMnB4OWtHQUZk?=
 =?gb2312?B?eGNuNzVjL2Z1djlnRzJWR1NMTitWb1FmUzdPNXh0WDFWQlVlQmRCeDFKelhq?=
 =?gb2312?B?WUZGVjdSNHgvV0tyWnRlN3pibjJqaWdMSUtLaTFSbWFHV0pVMjlTSWJPakxX?=
 =?gb2312?B?WnVXYTlZVnpqeWxHN21YMGc5SkVEaGlvb0VrVEt1bDZxRkZFNW9xdEtYL3A3?=
 =?gb2312?B?dnJUOVhCYnA0enZlMkVJeUcwQlZjR3Vram1tS0xBdktFRXk5elFRUnZpM3Rp?=
 =?gb2312?B?YVJsMzEzalpGM29iMnhQamJzZjlNcjlWazVWZzhIajlyQTNNcm8rZVBUZC9t?=
 =?gb2312?B?dEtDZjBKMXRJMURFZ0kzdUtxRmtNK25kOFVsZ3k5am5uOUNucGVXQWp6ZmNz?=
 =?gb2312?B?d1hzcmFSei9hdW5CSDY4eFhEaytOTlZpb2NvcUJQY3MvWWVsVFF6RmF2bXRT?=
 =?gb2312?B?Y2dUM0w4anpUN3NId0dieTJmMmRzRkpBUlRJVkVjSjR5QVB1eW54eVI4WGpu?=
 =?gb2312?B?d0hDeVdiaXBnOFV6c21GRVBhK2MyUGYrSnI3UyszSlZsR0tyMXl6NmV4U0Qy?=
 =?gb2312?B?dTg4ZnpYYXk2TjJrOVRSclBqWVFZUEdoVno4M1pHbFB5N1VFMEZFZmNpdTlU?=
 =?gb2312?B?Tm1DWkRabDBMcXlYMXlPYmpTRHhPQ0wzL21yMk9ROXpubGh5SWJjaTlzS1JE?=
 =?gb2312?B?dXBMaEhtK05vbzdCUkxMZWZBMStUTzB3TDR6aFM0eHFKamdtVldKaEM2WHBE?=
 =?gb2312?B?ZlpOU3RGeHh2bzVaZXNUdU1YazJXMXFna2pZREs1cmZUYkRlUFlIY0xvYUNJ?=
 =?gb2312?B?WTRMbjljWlkyb1pyRTcrb2VPWU9wRUZVbjNXSk9sRktXN29UakVWb3VOYkQx?=
 =?gb2312?B?cUFVbHhwVDBrYnArajZUR2RXV21hOW5jK2lqQXhXbk9RNlBJOFN2V050ZGpN?=
 =?gb2312?B?dlBOZEdCQW1mZXJPbkNhTS9IaVBWcmgzSEF0UU5CK0hsOUdjRldNZExxcWFx?=
 =?gb2312?B?UXNVL083Tnprd3Jtc3hjKzFGRGlYZzc4b0ZwQzBtbHc5UldBUU8wZ1U1Q1Ni?=
 =?gb2312?B?WFA4TVJUZzd1WmozZEdSdEN4TnlSMG9tT3UwS2Y1THRVZ2RsMmRvTnpqZUR6?=
 =?gb2312?B?N3pjL2RLb2VlbFhYYk16MkgraFR6SDk4RVAwTkZKVENWUm5QMENDZzNWcTFB?=
 =?gb2312?B?QzAvNXM4WndtRFhhQ3lHM1YrK2xmTlVhbHEraHNvbDZmUk9VMzlXU1RMeDc0?=
 =?gb2312?B?NUh3M2xWYVc5MEI2NXAwejNHZWFQL3UvZko2MkNqWW0xd0RqWW9HQ2NrMDFL?=
 =?gb2312?B?ZnB2ajlWNDBSZ09wMnV6Y1hDYVFNYW5ERldrbXhncm45TzFXdUdNSGpEaTha?=
 =?gb2312?B?YVJGS3VrcXZ0NWdjUVlqMUJWL00vS25DMEpaRlpZK1FScHMvZWsvWnluZ1Rt?=
 =?gb2312?Q?PbFRiUWNIGp4IzYXB3TWb9/6ngDC7xY6+H1gL3yuiY=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYUPR06MB6217.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d29cd1-5706-42c4-d94b-08df2a5e77a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 01:48:53.1807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HX8m/OgKghXEIJEKeSUCx4G5ZV/W4HODrGuMEdf2/fds7guz1EzJK4iudS8RVHnDjuA5PYqf+ov382Cdxm7/rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5366

SGkgQmFydCwNCg0KPiBTdWJqZWN0OiBbUEFUQ0hdIHNjc2k6IHNkOiBNYXJrIHRoZSBkaXNrIGRl
YWQgaWYgcnVudGltZSByZXN1bWUgZmFpbHMgaW4NCj4gc2RfcmVtb3ZlKCkNCj4gDQo+IElmIGEg
U0NTSSBkaXNrIGlzIHVucGx1Z2dlZCB3aGlsZSBydW50aW1lIHN1c3BlbmRlZCwgaXRzIHJlcXVl
c3QgcXVldWUNCj4gaXMgc3RpbGwgaW4gdGhlIHBtLW9ubHkgc3RhdGUgd2hlbiBzZF9yZW1vdmUo
KSBpcyBjYWxsZWQuIFRoZSBydW50aW1lDQo+IHJlc3VtZSBhdHRlbXB0ZWQgYnkgc2NzaV9hdXRv
cG1fZ2V0X2RldmljZSgpIGZhaWxzIGJlY2F1c2UgdGhlIHBhcmVudA0KPiBkZXZpY2UsIGUuZy4g
YSBVU0IgZGV2aWNlIGluIHRoZSBVU0JfU1RBVEVfTk9UQVRUQUNIRUQgc3RhdGUsIGNhbm5vdCBi
ZQ0KPiByZXN1bWVkLiBIZW5jZSwgc2Rldl9ydW50aW1lX3Jlc3VtZSgpIGlzIG5vdCBjYWxsZWQg
YW5kIHRoZSBwbS1vbmx5DQo+IHN0YXRlIGlzIG5vdCBjbGVhcmVkLiBOZXh0LCBkZWxfZ2VuZGlz
aygpIGNhbGxzDQo+IGJsa19yZXBvcnRfZGlza19kZWFkKGRpc2ssIGZhbHNlKSwgd2hpY2ggY2Fs
bHMgc3luY19maWxlc3lzdGVtKCkuIEFueQ0KPiBiaW8gc3VibWl0dGVkIGJ5IHRoZSBmaWxlc3lz
dGVtIHdhaXRzIGZvcmV2ZXIgaW4gX19iaW9fcXVldWVfZW50ZXIoKQ0KPiBiZWNhdXNlIHRoZSBx
dWV1ZSB3aWxsIG5ldmVyIGxlYXZlIHRoZSBwbS1vbmx5IHN0YXRlIGFuZCBiZWNhdXNlDQo+IEdE
X0RFQUQgaGFzIG5vdCB5ZXQgYmVlbiBzZXQ6DQo+IA0KPiAgIF9fYmlvX3F1ZXVlX2VudGVyKzB4
YjgvMHgxNzQNCj4gICBibGtfbXFfc3VibWl0X2JpbysweDY0MC8weDdlNA0KPiAgIFsgLi4uIF0N
Cj4gICBleGZhdF9zeW5jX2ZzKzB4YTQvMHhlMA0KPiAgIHN5bmNfZmlsZXN5c3RlbSsweGE4LzB4
ZGMNCj4gICBmc19iZGV2X21hcmtfZGVhZCsweDMwLzB4ODgNCj4gICBiZGV2X21hcmtfZGVhZCsw
eDU0LzB4YzQNCj4gICBibGtfcmVwb3J0X2Rpc2tfZGVhZCsweDhjLzB4ZDQNCj4gICBkZWxfZ2Vu
ZGlzaysweGEwLzB4MmY4DQo+ICAgc2RfcmVtb3ZlKzB4MzAvMHg2MA0KPiAgIFsgLi4uIF0NCj4g
ICBzY3NpX3JlbW92ZV9ob3N0KzB4ODgvMHgxOGMNCj4gICB1c2Jfc3Rvcl9kaXNjb25uZWN0KzB4
NjgvMHhmNA0KPiANCj4gRml4IHRoaXMgaGFuZyBieSBjYWxsaW5nIGJsa19tYXJrX2Rpc2tfZGVh
ZCgpIGlmIHJ1bnRpbWUgcmVzdW1lIGZhaWxzLg0KPiBUaGlzIHNldHMgR0RfREVBRCwgdGVsbHMg
dGhlIGZpbGVzeXN0ZW0gdGhhdCB0aGUgZGlzayBoYXMgYmVlbiByZW1vdmVkDQo+IHdpdGhvdXQg
YXR0ZW1wdGluZyB0byBzeW5jIGl0LCBhbmQgd2FrZXMgdXAgYW55IGJpb3MgdGhhdCBhcmUgd2Fp
dGluZw0KPiBpbiBfX2Jpb19xdWV1ZV9lbnRlcigpLiBTeW5jaW5nIHRoZSBmaWxlc3lzdGVtIGlz
IG5vdCBwb3NzaWJsZSBhbnl3YXkNCj4gaWYgcnVudGltZSByZXN1bWUgZmFpbGVkLCBzbyBubyBk
YXRhIGlzIGxvc3QgdGhhdCBjb3VsZCBvdGhlcndpc2UgaGF2ZQ0KPiBiZWVuIHdyaXR0ZW4uIElm
IHJ1bnRpbWUgcmVzdW1lIHN1Y2NlZWRzLCBiZWhhdmlvciBpcyBub3QgY2hhbmdlZC4gTWFrZQ0K
PiB0aGlzIGNoYW5nZSBpbiBzZF9yZW1vdmUoKSBpbnN0ZWFkIG9mIGluIGEgU0NTSSBMTEQgc3Vj
aCB0aGF0IGl0IHdvcmtzDQo+IGZvciBhbGwgU0NTSSB0cmFuc3BvcnRzLg0KPiANCj4gUmVwb3J0
ZWQtYnk6IExpYW5xaW4gSHUgPGh1bGlhbnFpbkB2aXZvLmNvbT4NCj4gQ2xvc2VzOg0KPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvVFlVUFIwNk1CNjIxN0REMzFCMUIzQ0QwOUU0MzFDQzEy
RDI5MjJAVFlVUFIwNk1CNjIxNy5hcGNwcmQwNi5wcm9kLm91dGxvb2suY29tLw0KPiBGaXhlczog
NmY4MTkxZmRmNDFkICgiYmxvY2s6IHNpbXBsaWZ5IGRpc2sgc2h1dGRvd24iKQ0KPiBDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2
YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0tDQo+ICAgZHJpdmVycy9zY3NpL3NkLmMgfCAxMCArKysr
KysrKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zZC5jIGIvZHJpdmVycy9zY3NpL3Nk
LmMNCj4gaW5kZXggYTFiMjFlYTE0ZTU0Li4yMDhiOTE1ZjI1YTIgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvc2NzaS9zZC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zZC5jDQo+IEBAIC00MjcwLDcg
KzQyNzAsMTUgQEAgc3RhdGljIHZvaWQgc2RfcmVtb3ZlKHN0cnVjdCBzY3NpX2RldmljZSAqc2Rw
KQ0KPiAgIAlzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmc2RwLT5zZGV2X2dlbmRldjsNCj4gICAJc3Ry
dWN0IHNjc2lfZGlzayAqc2RrcCA9IGRldl9nZXRfZHJ2ZGF0YShkZXYpOw0KPiANCj4gLQlzY3Np
X2F1dG9wbV9nZXRfZGV2aWNlKHNka3AtPmRldmljZSk7DQo+ICsJLyoNCj4gKwkgKiBJZiBydW50
aW1lIHJlc3VtZSBmYWlscywgZS5nLiBiZWNhdXNlIHRoZSBkZXZpY2Ugd2FzIHVucGx1Z2dlZA0K
PiArCSAqIHdoaWxlIHJ1bnRpbWUgc3VzcGVuZGVkLCB0aGUgcmVxdWVzdCBxdWV1ZSBzdGF5cyBp
biB0aGUgcG0tb25seQ0KPiArCSAqIHN0YXRlIGFuZCBhbnkgSS9PIHN1Ym1pdHRlZCBieSBkZWxf
Z2VuZGlzaygpLCBlLmcuIGZyb20NCj4gKwkgKiBzeW5jX2ZpbGVzeXN0ZW0oKSwgd291bGQgd2Fp
dCBmb3JldmVyIGluIF9fYmlvX3F1ZXVlX2VudGVyKCkuDQo+ICsJICogUHJldmVudCB0aGlzIGJ5
IG1hcmtpbmcgdGhlIGRpc2sgZGVhZC4NCj4gKwkgKi8NCj4gKwlpZiAoc2NzaV9hdXRvcG1fZ2V0
X2RldmljZShzZGtwLT5kZXZpY2UpIDwgMCkNCj4gKwkJYmxrX21hcmtfZGlza19kZWFkKHNka3At
PmRpc2spOw0KPiANCj4gICAJZGV2aWNlX2RlbCgmc2RrcC0+ZGlza19kZXYpOw0KPiAgIAlkZWxf
Z2VuZGlzayhzZGtwLT5kaXNrKTsNCg0KVGhhbmsgeW91IGZvciB0aGlzIHN1Z2dlc3Rpb24uIEl0
IGlzIGluZGVlZCBtdWNoIG1vcmUgZWxlZ2FudCChqiBubyBuZWVkDQp0byBpbnRyb2R1Y2UgbmV3
IHN0YXRlIHZhcmlhYmxlcywgZGlyZWN0bHkgbGV2ZXJhZ2luZyB0aGUgcmV0dXJuIHZhbHVlIG9m
DQpzY3NpX2F1dG9wbV9nZXRfZGV2aWNlKCkgdG8gZGV0ZWN0IHRoYXQgdGhlIGRldmljZSBjYW4g
bm8gbG9uZ2VyIGJlIHJlc3VtZWQuDQoNCkkgd2lsbCBhcHBseSB0aGlzIHBhdGNoIGZvciB0ZXN0
aW5nIGFuZCByZXBvcnQgYmFjayB3aXRoIHRoZSByZXN1bHRzIGxhdGVyLg0KDQpUaGFua3MsDQpM
aWFucWluDQo=
