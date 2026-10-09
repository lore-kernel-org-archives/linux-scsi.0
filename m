Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012014.outbound.protection.outlook.com [52.101.126.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36CE4C9DEB;
	Fri,  9 Oct 2026 11:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791545517; cv=fail; b=SBWQFu016Ty6sv5wH5d53vmcW/y+ugBSqUbc+ZjCrdmWtFe0C55l4BdV98+TluK2zL1pemBS0sx1PfskHvOqsD32NLkkrliU/ou6XuS6df/3GR9pcy0wWcOZXcYmHTnaPVOg1RF1jeice0IFQ87FEolagtjtHoIUgBrOlVTzOXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791545517; c=relaxed/simple;
	bh=YO0gWLTppHSwViyvbgmWcbubcG3bomK5FCp+eFBgE5I=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rS00Buc+97f8zi1D53U/gtnu70fb9kVpNwilaEBUBzn1BS13SB/Wl7BW7vObQRe4C73By88nebftM+u4xubF1eXAvG1iCQBpAce0FtqJXmnNpXI+kZTpkfZhH223JjTywpKCeR0INz5qq/nc5K3MdIUHcNz3p0Q1z7L19LKBs0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=fu1CXmJQ; arc=fail smtp.client-ip=52.101.126.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="fu1CXmJQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s56xgh9iL8DPtWPlXr163zHot55AWaPdvvEMyvD3cLGBYEovct3k3jjAgRVbvmlaDPftuWjdGYiyAMfHAe+7ARAc5v5GXMB7HKmYsXgm7qsdyeTuuthJuidrmIQz26hMoZN0a2xBusl5fV4V3q4aNKsSlhlVUjzACSjwFYIY+sOSphhuifamX9AK4dN5LqUb1x1ooPWG51PDsnwtLDmOFwE/xoV9aN71vLkRKWCO0shaz9KqFyi+7uHNr4oY9LjVNDzSYu/bDe1SmPl845z1T7TgwJzLrDipGNjG+Bose/RsvkKqhuguoo7mDSy/EhiXF/0AD0vob7pTnSknCPlG2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YO0gWLTppHSwViyvbgmWcbubcG3bomK5FCp+eFBgE5I=;
 b=WR3Z6Qu8HHW1aJb2XAMeNeBDc5P6SnXTWRdlSIc8CVoKothiFcLDS2N6PVo0aUrKbXMazdi7yWdG+qJKyVFfdPrRi25nrwo2D5h3iOVYdXi91SA1xJj3p6X7YvLSTmY0uF/kTWLTn6acIU85lXui8kaROiAeS8Rk/W8xPjCwCTFKw5LYNspn9hnd8iofnhJEeR/NIWeIrZqKhlLZt1o6pGEnfDzOVQ82s4FcB6h3FgiP1JsEQ+hsh0O2sdrLWw1m0yfq1ZF8ScVD978894Wk0DjSW3gPSFDWknDsQ4B8wvNcIz0mAq9k5Nug/WnUAluJ39klkZ3rD8+ttPfsAouKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YO0gWLTppHSwViyvbgmWcbubcG3bomK5FCp+eFBgE5I=;
 b=fu1CXmJQ6XDPtTCAWzbB1FC8biJ4jrAOpewpIadnUMIKUVFtchNQilbdK7UFDBYfDf4065SGxIic1xBST5EVtS3BN0nrMgIGuYrNm5iKiuqwpvPqbYuCz0wJRyIe+b+S3d9oPuebIQ+jxi0eLWSN71cfLdFNoqU4XcyWNdzJ8P0JmC9V3wn62poYCZfR9lReCuKCtKvxyDxOPM+pnitUcotYNGObV+GBtmt7YQzZKNJF8/DU/1CRdIG4S/GQPJOq2HNHa573EyYOu9uP/xrXlhqmnmOQtZxzDmkjvhrDr26FMzEJlx3mSuS56OFK9dnHSXFiJZbltJFvrt+VY2F7kw==
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com (2603:1096:400:358::7)
 by TYZPR06MB5805.apcprd06.prod.outlook.com (2603:1096:400:26a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Fri, 9 Oct
 2026 11:31:42 +0000
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc]) by TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc%4]) with mapi id 15.21.0496.015; Fri, 9 Oct 2026
 11:31:42 +0000
From: =?gb2312?B?uvrBrMfa?= <hulianqin@vivo.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, Bart Van Assche <bvanassche@acm.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern
	<stern@rowland.harvard.edu>
CC: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes
 Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>, Damien
 Le Moal <dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, =?gb2312?B?uvrBrMfa?= <hulianqin@vivo.com>
Subject: [PATCH v5 2/2] usb: storage: set surprise_removal flag on physical
 removal
Thread-Topic: [PATCH v5 2/2] usb: storage: set surprise_removal flag on
 physical removal
Thread-Index: Ad1X4bFxAfyJakusTtGaliW161FLLQ==
Date: Fri, 9 Oct 2026 11:31:42 +0000
Message-ID:
 <TYUPR06MB621711053AB2B701FECC73FED2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYUPR06MB6217:EE_|TYZPR06MB5805:EE_
x-ms-office365-filtering-correlation-id: 20b09a88-4a96-406d-f42b-08df25f8e44e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|42112799006|7416014|18002099003|10067099003|11063799006|38070700021|56012099006;
x-microsoft-antispam-message-info:
 dU0Y+a6BuJlE3mntuLWPhZm27ltD9U7sNHnp0ui8LlvvdfRZdmHFX7XN3+zV/wO9KfH7glv7CjWgBaHj04TyADcZwv4VpCAW3WWHj3akVg3VREKen/8NX5mfUhOJBZtUWAwFERV8tTxnDGDuPA65fqZ4HCjz/9KO6Wr8YXBoBcLwAUh0Rif2DDp99F1rtTjvZ29ZsJm9rg8xGfnQ/LJE8npD71vzCUS9bakc3B1IFzoF93D4V8bLRoLA41rMCP62N9pJQCqRTEmwYq7aMWz102Uh+IN5MMqsClMxlh4rrv0V4RqI8CUsPh8EvYycFkOPk1xJmM/rjlJnOVwoidRhm88eCDTaoNfJdlOQsUB6r6Wl3t+6dpa/GswXZdnPSzlNWTPkz1gMGZQhe3kWNNPzqok8I7balamoS/JMVXagHtaGy3vIfRdWPDASiAO+hZgwMXxm3M5BZ+HW3Na9/dPJjGsxiGLHQbHhpqCEbWqn2zMZSMGqdW/3xXL8smMDd+fnrGZYjWi5b1lE7plFJ6gCQnzYoV2s4Svi+zDnXMS4Yfa8YrDf3ye2bHK3mR1E9QJf+U8oMAYFNnNuGBbh/DxpQ/9shkAfvMms0/BEuWNWX78uT06ssDULhBrKrekhNpxwQgUcly6YOkJ4HcyWF9PzFkfqqPyJlri6tDjTUJHJOsNnxVy5AStqIvJBfcAS1rZxLXOUJdUJXNU/CJLydEzzSYFeOtXhhXHC3m55rVs4jm8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYUPR06MB6217.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(42112799006)(7416014)(18002099003)(10067099003)(11063799006)(38070700021)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?RUVEaWZnSzVmWDduQmo2WmFyTXI0RnQwUWxNQTRaYW9aVlU0dHBLMHJEbzBT?=
 =?gb2312?B?RDRNeDVwODBNK05FcFp3Q0hzUytCdUlJRUNKZlBnVTB1YnFUZ1ViYmRUNXZz?=
 =?gb2312?B?ZGhMMHEwSCs4alVoRSt6T1ZJRUJhdTNjTVVFY1RMRnVWcEpsRGNUdFh5MnVD?=
 =?gb2312?B?bVlHRFlhUVFQSDhmUzRCa3dHTkEyWmQxMUhhYnVPZWNJNjZNR3kwYUtVaEpx?=
 =?gb2312?B?Zk9OUS9RVERZMGRhQzVaUEh1TDBHUG0vVVU2QUNKLzBJQzQxeWFlTndEaGFD?=
 =?gb2312?B?Z0Z5MU1zbHl6MDBwRi80N2pjQjVLd3lCM2RGU2xDS21DMmtqclQxb0JDZFZ5?=
 =?gb2312?B?YXQyR1BXUDV1UzZSclVTRmpVNEFHNkJTTmpXaXZuMmdYWDIwdmkzRVhrbE12?=
 =?gb2312?B?enlKYnZmakdWUTBzYVdYQjRLQzhmYzdkaG12L3p4VTQyUExZeXZOWEZVYW1I?=
 =?gb2312?B?SUVyblUrV05KWnhsUVJjdExqMG5zMkFxdXJVelNOazRjYlU2Mit1UDJYa1Zx?=
 =?gb2312?B?M0hTK1NSY0RmS2QzWE5QY1BWa1Z3c08yRE1wTGdQUjRkVGdlbGRmamNYTTNN?=
 =?gb2312?B?bzNGWk5YT1JIdS9LK1laeGxDam9GVzBvUE16aGpRM2J5ZHQ5OHpFNEdNdzJL?=
 =?gb2312?B?NllrRC9tSUxSVklEcWFXcFBKdlM3akZJci9ya09LeUY0ZDhwSUt5STRMaDZ4?=
 =?gb2312?B?T295VmR4MzBkZVhSNFBZOTBybi9uRjJQanZFSjBoWjRJdFhEeEdyeEh4SytE?=
 =?gb2312?B?TTN4bDhtdG40NThPMksxdGJITzdDQVZPczJpRkNFKzdsaVJIVGozNXJ6S1ZR?=
 =?gb2312?B?akxGY3g2ZjZGUkI4LzZPZk9aRGd2U0luZHdjL3lMSGc0aVNIRzRVRFlSQUhI?=
 =?gb2312?B?WnF1K0YyejZqT1lla3ZkSE1iMjQ4NmMrcjl5RkcySmxCcHl6V0ZobldRTmxq?=
 =?gb2312?B?SWxEeWVKWVNOYUtxT241T096TEN2Y1RRdk9VbG1PaFpVbENhaWRERXljODBO?=
 =?gb2312?B?SDNLVU1YcVVBcEN3Z0wxM3N0d3ZTbms5bUhkRHQ4V2hudENuMEQ2VUdwdEtB?=
 =?gb2312?B?TFEraEs1L2QrelR6NW51QVZpSkRTa2dIb3B6Q1hWeUFNR0dnVDN5WkNvT002?=
 =?gb2312?B?OHc5VXFha0ZwQkNEQTZoSHNaVURBa0luZlQ1QVNjUzk0cFFxNlo5U3Q3Tk4w?=
 =?gb2312?B?cWVaUURtMEFONnpHRVE2TkVwZFZSTFFpSTlqNit6V0gwRVlRK3hoWUZ6UW1v?=
 =?gb2312?B?VU9TWmREWkRvbVNPbE1YcjVLMG9vK2hSTXowNE10U3JDMk5OeFk0WFRQQmlN?=
 =?gb2312?B?RmJuV2JGcDJKTW1RZmQvaDNDTklBcDdVZW5EWWxHY2xTNmZ0b0pNZmxFZnBl?=
 =?gb2312?B?QVhWMmtrbTM3NHh5d2NrQTNtUGhsUkRMa09yZTQ1UjJlRHYzZkg4Q1o0SFU0?=
 =?gb2312?B?SkJsWThHanBKWnlwTjJMRWFaQXErczlIdXJGelhWdUpSN1Z2M3ZIVGVOdmdq?=
 =?gb2312?B?M0l3ZkE2d29VUE9Xem5HMHpnMTRYWHZLVitLWURhL3hHYURvZVpOZXhnZFpr?=
 =?gb2312?B?Z21tcVJpc0VwMnJBajd6OU5nTlFUL3BqYUUzQnVoUmMyUTlnWHNPK1cyUEtL?=
 =?gb2312?B?bytiSTZ1dTZRQTE4eDFFOUdvMGcyUzhBQ3dKcUJJSXlHV1VPb2kvZ2ZOcHha?=
 =?gb2312?B?cldFeHlWekdqUXdWMytMKzQzV1lGVDhoTVBrWUhhbzg0dmdZMXN5Y0hBTUtN?=
 =?gb2312?B?UzlTQS9LRTB0TDRHOTdFMEZqeGwrdUsyaHdjQVNTNkIxRE13aXZzdjg3SGlz?=
 =?gb2312?B?L0dib1hPaTdLL0hselVyWlNEb25ZV3JLOVFaVndxQW1KMmxEakkvQmtUV3dJ?=
 =?gb2312?B?N3ZCZTBKeUI4N1VLUStpT1FEVXJuSk5lem9xZkFJWlZUUEhqdlU1ZktGYkMv?=
 =?gb2312?B?UWVEejR1UlFlcm9tb2dvVnhKRkIvU2d6c0pzU3NicW9ka1VxdWdTTU1DS3Nz?=
 =?gb2312?B?Vkk2bUZwRzRXaWQyUm5xSUkrbUhlbWpwMVBhV2loeGE1bG5ic0s0YStMWHcx?=
 =?gb2312?B?ZWlkTW9vaHZqWEthY1JtUFArMUlkdW5iOUxGUnRrWXJEYUdudVV1MGVlNUE4?=
 =?gb2312?B?MjFMOGxCN2tTZFNCM0hQY2FuSXY5d2VlV0FZSGhiMlFKVHN5dnpQSkR4Tmcv?=
 =?gb2312?B?d2sweG9RNzF6STdzZ2lCd3NGL2ZpWTAxaTU5QlFvbXlqRUVxM2IydHNKZ1ZE?=
 =?gb2312?Q?vLZSjMHoElBvz6B6ueBqNFjOfMRjsyE7f8pM8WZMMk=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b09a88-4a96-406d-f42b-08df25f8e44e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2026 11:31:42.2115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hlKljKT6VpDs0gHfQlF42hyuWTLe1OSkIYf+IrETOyjZg7PRvyrgESKQFiRovUDBgTJPQjVaEc5Ei/mT1OBP5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5805

U2V0IHRoZSBzdXJwcmlzZV9yZW1vdmFsIGZsYWcgaW4gc3RydWN0IFNjc2lfSG9zdCB3aGVuIHRo
ZSBVU0IgZGV2aWNlDQpzdGF0ZSBpcyBVU0JfU1RBVEVfTk9UQVRUQUNIRUQsIGluZGljYXRpbmcg
dGhlIGRldmljZSBoYXMgYmVlbg0KcGh5c2ljYWxseSByZW1vdmVkIGFuZCBjYW5ub3QgaGFuZGxl
IEkvTy4NCg0KVGhpcyBmbGFnIGlzIGNoZWNrZWQgYnkgc2RfcmVtb3ZlKCkgKGFkZGVkIGluIHRo
ZSBwcmV2aW91cyBwYXRjaCkgdG8NCnNraXAgc3luY19maWxlc3lzdGVtKCkgZHVyaW5nIHN1cnBy
aXNlIHJlbW92YWwsIGF2b2lkaW5nIGEgaGFuZyB3YWl0aW5nDQpmb3IgSS9PIHRoYXQgY2FuIG5l
dmVyIGNvbXBsZXRlLg0KDQpGb3Igb3JkZXJseSByZW1vdmFsIChlLmcuIHJtbW9kLCBzeXNmcyB1
bmJpbmQpIHRoZSBVU0IgZGV2aWNlIHN0YXRlIGlzDQpub3QgTk9UQVRUQUNIRUQsIHNvIHRoZSBm
bGFnIGlzIG5vdCBzZXQgYW5kIHN5bmMgcHJvY2VlZHMgbm9ybWFsbHksDQpwcmVzZXJ2aW5nIGRp
cnR5IGRhdGEgd3JpdGViYWNrLg0KDQpTaWduZWQtb2ZmLWJ5OiBMaWFucWluIEh1IDxodWxpYW5x
aW5Adml2by5jb20+DQotLS0NCiBkcml2ZXJzL3VzYi9zdG9yYWdlL3VzYi5jIHwgMyArKysNCiAx
IGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Vz
Yi9zdG9yYWdlL3VzYi5jIGIvZHJpdmVycy91c2Ivc3RvcmFnZS91c2IuYw0KaW5kZXggMDY0Yzdm
YzhlMzY4Li5mNmM4MWY3ZmY5ZjEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zdG9yYWdlL3Vz
Yi5jDQorKysgYi9kcml2ZXJzL3VzYi9zdG9yYWdlL3VzYi5jDQpAQCAtOTMwLDYgKzkzMCw5IEBA
IHN0YXRpYyB2b2lkIHF1aWVzY2VfYW5kX3JlbW92ZV9ob3N0KHN0cnVjdCB1c19kYXRhICp1cykN
CiAJaWYgKHVzLT5wdXNiX2Rldi0+c3RhdGUgPT0gVVNCX1NUQVRFX05PVEFUVEFDSEVEKSB7DQog
CQlzZXRfYml0KFVTX0ZMSURYX0RJU0NPTk5FQ1RJTkcsICZ1cy0+ZGZsYWdzKTsNCiAJCXdha2Vf
dXAoJnVzLT5kZWxheV93YWl0KTsNCisNCisJCS8qIERldmljZSBpcyBwaHlzaWNhbGx5IGdvbmUs
IGNhbm5vdCBoYW5kbGUgSS9PICovDQorCQlob3N0LT5zdXJwcmlzZV9yZW1vdmFsID0gMTsNCiAJ
fQ0KIA0KIAkvKg0KLS0gDQoyLjQ4LjENCg0K
