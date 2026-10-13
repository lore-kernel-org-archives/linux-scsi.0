Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013000.outbound.protection.outlook.com [52.101.127.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128AA46E01A;
	Tue, 13 Oct 2026 02:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857655; cv=fail; b=QIStUMOnRhagcEpus1dTvAhgrWRV3Jq//0hiEUzeTaBCJSjX1czbJquhQwU93kGcpprjEpaXLLdxX5soQn/nArjgF+yqWgnWh6ybf+CY/BQl0wAj1Xq7zsKZzjJR/ipF90BYZRxxajsB5L96wOaZYauH4lPlo2pnhDGOLsNDEec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857655; c=relaxed/simple;
	bh=r8kZwsCpUtE6U9UnIToW5dgjPoew652r/5ZAPNDjBck=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OzawxJ2FyNfQ5VF0GyIFJ1CsoW+f0mD+pjbk7wA6t3wCNiU1L2f8iJl1RY2DRfwFtT4DL9HvLMw1gGia6EjTtolCkiEp4c6EiVGnOm1KmiCUhwSBrl9zb6WTnEC14chm+Poa4BhIQ4G+lQrebDW8WYcI3A33XR+xS7wV50+DIoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=iRNcoRlH; arc=fail smtp.client-ip=52.101.127.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="iRNcoRlH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HXmN+boiCBoW/eX02cZ8Vu+GcHb+gZDuI5m1Z9NW40ynj4mB1bYYIwq3yTRiIPSCFh1ZHPGPKnmerZHuAxkc5pbM4oGckcNHOz4SR67iLmILdlSlUaLLVaLvkxYGlhRk4ROp91T52JFEU1kvFV/3tSfkFrJNDoK5/HPNuWW1YEOIfWHsi8/10ek6lVffT5WsYyHIB7Kf/Rire/mqEEs+1RXqtTUgpxsmthCr8B+4o5rVdQlgvRmqt0UbqZaRzxcDZH3/H67X6wUy1FNlEZCANMDIeEwBGOsrk0QqSikc9P3KnkRRD3T4oeC02C0FoL4FTqFhK8WgQgLXP7NrlTyPUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8kZwsCpUtE6U9UnIToW5dgjPoew652r/5ZAPNDjBck=;
 b=LavLGhax9z49rP/nNuLt8VxooccB8kmPVecMuEvlvHTt8vpGRd9Mw5SCOYT62Qodqwfv6Ja1O3MoL2x0nJoLYkEcGyVBQPOVC1GkJzRIH2Z2nKCH56HXEFwQjt2SPZHnZhWpMnVaRN6fZv/OySz8k6GRtNIWEqnPuHLveZmB5Df+qajHXmu+STI0Dri9qqKaQh8477Rft9NyJzadJ8wyqh5nTuCWUvMkEp3FQK2dwMX8LeAu63iM0bTo8x0YDWIcgFQ1RMIPyTJ2Czv0OKhv9TQuUY/fX9GYVaX4ClQkB+HABYM0vKek7GADgNTp8dr9vmW3vZrhtVZJMhEoTY4AtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8kZwsCpUtE6U9UnIToW5dgjPoew652r/5ZAPNDjBck=;
 b=iRNcoRlH3UJgfUf0L7GJTQhZ2nRXllh1oLa9/Nv6xSXaiX/OQoo01sQlSgtcFsA56jC/qBvSkIat2f52k2IawHDo8x4FuU+pJ5jM3EsoFo1M/nQj2C79uZ3k1UM6/C48scMk6F8jEYZduJeB16p/yPatuo6ieA+7DRTSqMlAJ8J+rhqXjur2zYhi5arssH09bIkNo81SdET3t/b1X8J392ylafKAXMclmqrEEHWvA9V/0vzwStG5r9/oKV9ebjMbmMrnyF7e1jgfh8IT6zlBJMZ6zB3faoh2VnfIzHyXvHa0qBK9uoYDPjG/0lLVM8PZQYMx1Ax8zNU4VKTOKTGEZg==
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com (2603:1096:400:358::7)
 by KL1PR0601MB5486.apcprd06.prod.outlook.com (2603:1096:820:b5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 02:14:08 +0000
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc]) by TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 02:14:07 +0000
From: =?utf-8?B?6IOh6L+e5Yuk?= <hulianqin@vivo.com>
To: Christoph Hellwig <hch@lst.de>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, Bart Van Assche <bvanassche@acm.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern
	<stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke
	<hare@suse.de>, Mike Christie <michael.christie@oracle.com>, Damien Le Moal
	<dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>, Shin'ichiro
 Kawasaki <shinichiro.kawasaki@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject:
 =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjUgMS8yXSBzY3NpOiBzZDogbWFyayBkaXNrIGRl?=
 =?utf-8?Q?ad_on_surprise_host_removal_to_avoid_I/O_hang?=
Thread-Topic: [PATCH v5 1/2] scsi: sd: mark disk dead on surprise host removal
 to avoid I/O hang
Thread-Index: Ad1X4Nn5DvzfrXBnSoCZVyBu705+6gCeASuAABfIUFA=
Date: Tue, 13 Oct 2026 02:14:06 +0000
Message-ID:
 <TYUPR06MB62172FD04314EFE34D8091EAD29E2@TYUPR06MB6217.apcprd06.prod.outlook.com>
References:
 <TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <20261012144923.GA10852@lst.de>
In-Reply-To: <20261012144923.GA10852@lst.de>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYUPR06MB6217:EE_|KL1PR0601MB5486:EE_
x-ms-office365-filtering-correlation-id: c7419515-31df-4fdc-79ee-08df28cfa8dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|42112799006|1800799024|23010399003|7416014|366016|376014|10067099003|261009223027099003|38070700021|4143699003|11063799006|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 Y9A+qnIP+YpPnQ+SgiWJJJJaUdbbD24yCfOogo4ZCvXGFhFdHwLf1izpE3hupMG6n7fnFko2PNZoZdWH7s/rgzA5/Qskn4n5xJOPecP2Hv3o3OQBntb2QjQ8w7fu7WsAwoQ0zbfm/HrGnHIPJVWiGrGnmXZUhrzILJl13FQKmlqJijNoDEXKFveXYIbK0R7kl92l/bt7AOEXdLcz4zeUymUtVwS8Na1+FjokLDMdR9OiF4H8wlRXGU6xAIwLN3cN85iKdR8tivmy5ocnVRNEMoIiCB7beKc4yhTjibFcgxhxd2a6FGUQb/OZ6ifZtRpokq+/R9jpcfl2W/aOr6oai05jkS0vvjq/4aEl67NhR0XXq76cMmbgjbaGC2Sx2X1YN+n7XOWaomS6e272caRMxsGlXpLl3npSjggSP21ZJ3rLHUbGpBjcF5A8WjzcDvCIFknlIjxh9hCPwkv/K1ZiSposljgmZneWSTb6VwZi4tdEKORmlYyjVv7JKlV5aDl33dmJbdv4vVgDYQ3Itajluq5dd/8J8R0e/59EoNIjf7Q5153EXT1DcrBWGEJsEzOwwE039GI+oe2x9fv0q8EdMJ3IwR5H8bLEHOnEMytsoHW5VelMEHIudfJOlfaFM33bo5JKoFmyeZoESbXsGgrxsVo+R6BQoT5Ak06+rdGnKQFN1pd8HpA3KOrwirs0Yut0R8+SIJsCUb20Q1kBHKYX/krRHdMUl+XepP9p3gdhJL8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYUPR06MB6217.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(1800799024)(23010399003)(7416014)(366016)(376014)(10067099003)(261009223027099003)(38070700021)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cjJTNEhyVHhxLzJFcEhoYWw5NDlUV2l0Y1ZVUC8wUjRXcDVHWlBaNUw3N1hs?=
 =?utf-8?B?THNxcVFiaG1UVUUvWEl2KzFSZnBCNlB3dHU0ajhQRHJRQWZYTGM3ZXFYVS9M?=
 =?utf-8?B?UTQ3VnBpOG5XMlIvUGEvbktYYU5seXkvMDlLcVFiVVh5RUM5MlAwZ0Z6UFFS?=
 =?utf-8?B?VFJKL3p1U2d6WjB2K2luOFBTWCtGNHNwVDNwTzFGbHM3OTdTNU0zMXVmUjgr?=
 =?utf-8?B?WEp0MjZsWkhubzQxdGRKZFg1UXFNTkdSWWlRb3poMXdtTTRQUUs0U3JPdXJW?=
 =?utf-8?B?YWJXdFdkcWxCTlZ4Y1ZoSm1mZHZlSzM2N3NkaDNHaVJPYnFGeGhXT3dMWXRp?=
 =?utf-8?B?VCtrRklXenpVNXhpclY3ZnRUSkVxZGRIQytCYlAvWjdyM3ozRFMwTmY3aDlW?=
 =?utf-8?B?QjlrckNHc2V0V0pReWJNWDg0enNTSTR6Q2kvUXQyVkF5SFd4TitnYVRUMlVO?=
 =?utf-8?B?Um9GL3lQVDB5NmpOM1FqWjVSblJMK3hKOVBld293YUFDL0MwNDVwVnEvQmU1?=
 =?utf-8?B?bDF6WlFUWEJqcmw1WGhJd3lRZ3MwN2c1dmRSdnhnMGVnWTFYY3plcCsyLzRv?=
 =?utf-8?B?ei9JMWJDaVlwM2xRbUVJRThsc2lBT0Q2WC9BN2x4Q1duNTRJNWt4WTQvaDFH?=
 =?utf-8?B?Wm1RcFY4SmsydUNRUHJCL0NYTGxqV1Z2NitrZEd4WlNiZnFPaExoRXgwRjN6?=
 =?utf-8?B?K0twNGk3UGlNckdaY1dKbW8zQS8ySGM5emJvT3RCTEJGdUpockpyb0hiMzJk?=
 =?utf-8?B?WGVFaWYzUkNlc3d3RDR5VFZSVkxqQjEzTUtjMmRTcFdpR2hIT0Nkd3I2bnRQ?=
 =?utf-8?B?aU5KOWhWL0FoUDRjRTM5d2I3R0dVenpMZHdrYlgzQ0VSTFBuWHpyamVFZkpP?=
 =?utf-8?B?K3ZnbitHTXZGS1VQVDFmaWQxSFBkdDFqMWh4anIvdVJkMnJqanI4WlBULyts?=
 =?utf-8?B?emZTU3NDamx5TlBYWk5ZRUJBTDdobXFuaVlRYTJKL21BaTFjUzhXWnpFNkhp?=
 =?utf-8?B?UVgwd1lEa3piUm5VVFZHZ2o3UTRoeGpxblpWZVVJV0VzUE5EdGFNRnN5TDkz?=
 =?utf-8?B?a0UyWk02RGJtYXE1WG85UlpPalFva1VWY01IWmVUOGxzaFVVK2NObm5jQXlm?=
 =?utf-8?B?U2NTVVRmT0MrNnpjcThmcmU3KzNmbi9HTHMxZDRwdEVaRmdoS25MbjBvK0dS?=
 =?utf-8?B?R3A0YklLYW9tYURzNUtHL3Q2Z25TaFJzaXlML1dHNnJoZDY3OTM4cWllbU9z?=
 =?utf-8?B?UTlSbzZIeW1hbFJ2MXZvTUNnVkNpQkJ4bWlSNEN1QUYwYUdhN1VyNWNFaVps?=
 =?utf-8?B?UlQ1cmVzcUVPMGx4cVp0L2E4Ui9CTEgxMWZ2bDRqZUdPRTlsRklWZkp0VS91?=
 =?utf-8?B?UktHS2IveE5KQkRGUlJqRmMzSlhJRlkrU0h5NDZPQ0kyVXNDZDFzMVNsd1Fs?=
 =?utf-8?B?dkE5M2h6aGw4YjlMNFQyd01EdEowR1ZEcGlrOElaWmx5R2Rkb3ZHWTM5eHpv?=
 =?utf-8?B?eXE2TjY0bnE2Z2Y1Y2NVU0xlTlhnSHpCNU9TQkhjVks2VVJ1Rzh5OENTWHkz?=
 =?utf-8?B?eVFUZGJmeGt1RWF6ME1kZ1JhTnZDZFZBV1h5aHM1ZE1hd1FrR3B2YWNHejZX?=
 =?utf-8?B?bFRmSExVQTl2RkN2dm90dk9oTnZ4VmFqWUFCWkJEOXZ5c3BncnhWengyRXAy?=
 =?utf-8?B?OXFPY0ZSN0Y3Z3p5anZMZE5ua2g2WThtTnNzMHRVaVZGMzFGdTN4SnIrbWFh?=
 =?utf-8?B?VjE1QnRQSDNWSXphSWlReGp2RXdCTnlsLzlMdzRnTFFRUWhYMHp2ZlIwQWJJ?=
 =?utf-8?B?bjBlbUlaZHFwblVCU3JuL1o5R2U0SGRmVkR0RnJPdzBqd09YTlNSRUptSmxh?=
 =?utf-8?B?eUZKdjhtN3BVMGxGSUhNM2VxRGVxY05uM0xscUZ3M1ZDTXFSZjlEZEZkQmYx?=
 =?utf-8?B?cU9JcnJ2blI3M3hEQWZtS1dlb0VPYjVhV21xNXhkbVlZMlJqREUrZzQyQWtD?=
 =?utf-8?B?UWJGTEFqSHRhM3R1c0ZvcUxjRE1uWG5xYW1SbDFWTWl3b2lXbTdtL2gySG4x?=
 =?utf-8?B?d2VMdkNLOGFaVzNUYVNKRnJ3bG1nbFBpR2krazVoazBYTG5aaFdoVWcyMkdW?=
 =?utf-8?B?eFZnL2lDOCt4UU9pUUxzVTVTK082ZFJQNjBGVEJYUlFFdEJyOWFsWWtRemtH?=
 =?utf-8?B?cHpmR0ZEOS8vSkxudWNXUW9uMVlkdTdEbC9Ea0RRYnIrYnkwR3cyT0EzZ3d2?=
 =?utf-8?B?VWlxWjdrUDJTcjRtUUczUmhhSE43TFg0UjY4MlZzeDlXOTIrdUhnK1cvMGV5?=
 =?utf-8?Q?5UESdLWRbofVcCgpaJ?=
Content-Type: text/plain; charset="utf-8"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c7419515-31df-4fdc-79ee-08df28cfa8dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2026 02:14:06.6231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QBV0ZvduLnBaacufu6ze1S1XjKBaiK0ulHNZzcpQV6MrYN0PNu5g9hhmLn/tOVdm1TLMoEv4Wxb4cDf4FL3iyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB5486

SGkgQ2hyaXN0b3BoLA0KDQo+ID4gIAl1bnNpZ25lZCBzaG9ydF9pbnF1aXJ5OjE7DQo+ID4NCj4g
PiArCS8qIERldmljZSBpcyBwaHlzaWNhbGx5IGdvbmU7IHNraXAgc3luYyBpbiBzZF9yZW1vdmUo
KSAqLw0KPiA+ICsJdW5zaWduZWQgc3VycHJpc2VfcmVtb3ZhbDoxOw0KPiANCj4gUGxhY2luZyB0
aGlzIHJpZ2h0IGluIHRoZSBtaWRkbGUgb2Ygc3RhdGljIGZpZWxkcyBpcyBhIGJpdCB3ZWlyZC4N
Cj4gDQo+IE1heWJlIHdlIHNob3VsZCBnZXQgc3RhcnRlZCB3aXRoIGFuIHVuc2lnbmVkIGxvbmcg
YW5kIGF0b21pYyBiaXRvcHMNCj4gZm9yIHNvbWV0aGluZyBsaWtlIHRoYXQgYWN0dWFsbHkgaXMg
a25vd24gdG8gc2V0IGl0IGF0IGFueSBwb2ludCBpbg0KPiBydW50aW1lIGFuZCB0aHVzIG1vc3Qg
c3VzcGVjdCB0byBjb3JydXB0aW9uIG5vbi1hdG9taWMgYml0ZmllbGRzPw0KDQpUaGFua3MgZm9y
IHRoZSByZXZpZXcuIFlvdSdyZSByaWdodCBvbiBib3RoIHBvaW50cy4NCg0KSSBwbGFuIHRvIGNo
YW5nZSBpdCBhcyBmb2xsb3dzOg0KDQogZHJpdmVycy9zY3NpL3NkLmMgICAgICAgIHwgNCArKysr
DQogaW5jbHVkZS9zY3NpL3Njc2lfaG9zdC5oIHwgNyArKysrKysrDQogMiBmaWxlcyBjaGFuZ2Vk
LCAxMSBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2QuYyBiL2Ry
aXZlcnMvc2NzaS9zZC5jDQppbmRleCBhMWIyMWVhMTRlNTQuLjA3NWE1MGMwODQwNCAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvc2NzaS9zZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvc2QuYw0KQEAgLTQy
NzIsNiArNDI3MiwxMCBAQCBzdGF0aWMgdm9pZCBzZF9yZW1vdmUoc3RydWN0IHNjc2lfZGV2aWNl
ICpzZHApDQogDQogCXNjc2lfYXV0b3BtX2dldF9kZXZpY2Uoc2RrcC0+ZGV2aWNlKTsNCiANCisJ
LyogRGV2aWNlIGlzIGdvbmU7IGF2b2lkIHN5bmNfZmlsZXN5c3RlbSgpIGhhbmcgaW4gZGVsX2dl
bmRpc2soKS4gKi8NCisJaWYgKHRlc3RfYml0KFNIT1NUX1NVUlBSSVNFX1JFTU9WQUwsICZzZGtw
LT5kZXZpY2UtPmhvc3QtPmZsYWdzKSkNCisJCWJsa19tYXJrX2Rpc2tfZGVhZChzZGtwLT5kaXNr
KTsNCisNCiAJZGV2aWNlX2RlbCgmc2RrcC0+ZGlza19kZXYpOw0KIAlkZWxfZ2VuZGlzayhzZGtw
LT5kaXNrKTsNCiAJaWYgKCFzZGtwLT5zdXNwZW5kZWQpDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9z
Y3NpL3Njc2lfaG9zdC5oIGIvaW5jbHVkZS9zY3NpL3Njc2lfaG9zdC5oDQppbmRleCAxNjI0M2Vj
Mzc2Y2QuLjY2YWE5YWU2MDdkZSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvc2NzaS9zY3NpX2hvc3Qu
aA0KKysrIGIvaW5jbHVkZS9zY3NpL3Njc2lfaG9zdC5oDQpAQCAtNzU3LDYgKzc1NywxMyBAQCBz
dHJ1Y3QgU2NzaV9Ib3N0IHsNCiAJLyogRGVsYXkgZm9yIHJ1bnRpbWUgYXV0b3N1c3BlbmQgKi8N
CiAJaW50IHJwbV9hdXRvc3VzcGVuZF9kZWxheTsNCiANCisJLyoNCisJICogSG9zdCBmbGFncyBm
b3IgcnVudGltZSBzdGF0ZSB0aGF0IG1heSBiZSBzZXQgY29uY3VycmVudGx5Lg0KKwkgKiBVc2Ug
YXRvbWljIGJpdG9wcyAoc2V0X2JpdC90ZXN0X2JpdCkgdG8gYWNjZXNzLg0KKwkgKi8NCisJdW5z
aWduZWQgbG9uZyBmbGFnczsNCisjZGVmaW5lIFNIT1NUX1NVUlBSSVNFX1JFTU9WQUwJMA0KKw0K
IAkvKg0KIAkgKiBXZSBzaG91bGQgZW5zdXJlIHRoYXQgdGhpcyBpcyBhbGlnbmVkLCBib3RoIGZv
ciBiZXR0ZXIgcGVyZm9ybWFuY2UNCiAJICogYW5kIGFsc28gYmVjYXVzZSBzb21lIGNvbXBpbGVy
cyAobTY4aykgZG9uJ3QgYXV0b21hdGljYWxseSBmb3JjZQ0KDQogZHJpdmVycy91c2Ivc3RvcmFn
ZS91c2IuYyB8IDMgKysrDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy91c2Ivc3RvcmFnZS91c2IuYyBiL2RyaXZlcnMvdXNiL3N0b3JhZ2Uv
dXNiLmMNCmluZGV4IDA2NGM3ZmM4ZTM2OC4uM2E1YTBjYWMyYjc4IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy91c2Ivc3RvcmFnZS91c2IuYw0KKysrIGIvZHJpdmVycy91c2Ivc3RvcmFnZS91c2IuYw0K
QEAgLTkzMCw2ICs5MzAsOSBAQCBzdGF0aWMgdm9pZCBxdWllc2NlX2FuZF9yZW1vdmVfaG9zdChz
dHJ1Y3QgdXNfZGF0YSAqdXMpDQogCWlmICh1cy0+cHVzYl9kZXYtPnN0YXRlID09IFVTQl9TVEFU
RV9OT1RBVFRBQ0hFRCkgew0KIAkJc2V0X2JpdChVU19GTElEWF9ESVNDT05ORUNUSU5HLCAmdXMt
PmRmbGFncyk7DQogCQl3YWtlX3VwKCZ1cy0+ZGVsYXlfd2FpdCk7DQorDQorCQkvKiBEZXZpY2Ug
aXMgcGh5c2ljYWxseSBnb25lLCBjYW5ub3QgaGFuZGxlIEkvTyAqLw0KKwkJc2V0X2JpdChTSE9T
VF9TVVJQUklTRV9SRU1PVkFMLCAmaG9zdC0+ZmxhZ3MpOw0KIAl9DQoNCg0KVGhlIGZsYWdzIGZp
ZWxkIGlzIHBsYWNlZCBhZnRlciBycG1fYXV0b3N1c3BlbmRfZGVsYXksIGF3YXkgZnJvbSB0aGUN
CnN0YXRpYyBiaXRmaWVsZHMuIHNldF9iaXQoKS90ZXN0X2JpdCgpIGVuc3VyZSBhdG9taWMgYWNj
ZXNzIHdoZW4gdGhlDQpmbGFnIGlzIHNldCBhdCBkaXNjb25uZWN0IHRpbWUgYW5kIHJlYWQgaW4g
c2RfcmVtb3ZlKCkuDQoNClJlZ2FyZHMsDQpMaWFucWluDQo=
