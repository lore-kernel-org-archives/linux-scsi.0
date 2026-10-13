Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013030.outbound.protection.outlook.com [40.107.44.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E39E3CF1F9;
	Tue, 13 Oct 2026 09:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791882876; cv=fail; b=An9OQnhIua4zuASWmP0G5Ufez46/neUf71hyHmN3Ss+Q31YJLBZbTfhlSIX8CpQFfUviGSBnedJUrl+QACu9tG9nPyRAUXvDWhtLnXKJ+wgvSpnan7IJjOiI7eU18W8Ym1VSNwEtCzdA6BOCIhio06Mi1zi55xeG3XZPCqS3EpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791882876; c=relaxed/simple;
	bh=Suf/DBxqALNgat3vAnDcdNsmdjf7DWh5tsJkmipE/sE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nL1wGYD/vcuVgyej8AEp+jYn6S+01Lq2Q1QxNSekwi76KDrBB6CIoEyKBSGb49naLb1fDBDBgRRvB9MCjJtnEP9lIbHQhsPAvJtQk28rZo2qbQ6ZGWgimnQyKLaAx4/IRot5bBZVrsJLaW6fyGSG/vVv0FMWYCzWA5cgv8Uot8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=eRWV4f/r; arc=fail smtp.client-ip=40.107.44.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="eRWV4f/r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YlRcawqNUE2skRfZs9lJ5TK/2KgtFFfiv/2Oo6i+Dsaj1nSUV2uUVoDM9U7tFrpiFkuPtCUSMlWXrnDHXlcZng4BB72FOeaPS6ZTib4LDWyMmaKqRr0uimS5OK0PiWjfyVMdVLdVzr6hWiWJM/pKCoHsxgw1+QbFalUUVfOKUXB9wefgCHve4dM0C5ckaJ0v/DKLIQmn/LE4/xHNwlCCr6hP4sqJ2pF+NUCN9G7drozvZhVitjBl/5BQZQWi5/XX15qq6l+9Jl1TBjKFo3lpk7W+rHxirHs5aazzwVWHN6kOAcUUbJZ7khC33V9pG40SwK3V6sTcwQqm/ZSXRPmTqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Suf/DBxqALNgat3vAnDcdNsmdjf7DWh5tsJkmipE/sE=;
 b=mk6qaW1HJ6NbWsrAiFDFdi2PBMO+fJbBEJfyOr7EJDBcp+MsFlMHtUB+at90c96E/kVFm7ztzliPU5Q0DBXGvRFy0sFo/5r4gegkjCEKApKEK9Jws8aGpxLUtLMA+coZbwPg0r0hyo2GHgaQ76rAmTGhp+KVUNoruR8E7MyDrPjX9QycjVZIai4F2C8hHZq21Gxa55OBzO+VkvON9gMMTzK5Z+J2mXlNSLc37T+5lPfObQgd5NB6UZszrYeYdX3PJP3jnxPfJCCHRUVDbtE4bxsXUlZbvcr4R+aU0qzWTUKqcoNGAd4BnY4HSgd9KbzKfpLdVmDdCQhG2u7RZP69AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Suf/DBxqALNgat3vAnDcdNsmdjf7DWh5tsJkmipE/sE=;
 b=eRWV4f/rld773DE52uZ4qxVCKIVrIm2u213lcWoU8Ii5PWFsOAiKSZ6HtgR6NcQ3qnCGgS3V35kLZcsvOVHfeezP9YR+S1bzerpkHWYcKI+QwA23C4jC1octfisex5Cg3sBaNVMvjkcRIzsVAimSJuxh5niLveDDqbRES713bpzkPeKfFIiI4J8Q9QC62gyBE3CdgHXEbNO3CRBUDbA0pH/gebkRdsJCIytbORS5FusbjlMhymkGEZuy2AI4OARn0omedTSja4UAxgFpTLXJIEyn1UllTBv/Lgmd8mfIr4f5x9GoGESaGBxuZxAHVq64FCknmv0OLY0Ifh2A4vuhIw==
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com (2603:1096:400:358::7)
 by TYSPR06MB6541.apcprd06.prod.outlook.com (2603:1096:400:47d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 09:14:30 +0000
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc]) by TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 09:14:27 +0000
From: =?utf-8?B?6IOh6L+e5Yuk?= <hulianqin@vivo.com>
To: Oliver Neukum <oneukum@suse.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<mkp@kernel.org>, Bart Van Assche <bvanassche@acm.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>
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
	<stable@vger.kernel.org>
Subject:
 =?utf-8?B?562U5aSNOiBbdXNiLXN0b3JhZ2VdIFtQQVRDSCB2NSAxLzJdIHNjc2k6IHNk?=
 =?utf-8?B?OiBtYXJrIGRpc2sgZGVhZCBvbiBzdXJwcmlzZSBob3N0IHJlbW92YWwgdG8g?=
 =?utf-8?Q?avoid_I/O_hang?=
Thread-Topic: [usb-storage] [PATCH v5 1/2] scsi: sd: mark disk dead on
 surprise host removal to avoid I/O hang
Thread-Index: Ad1X4Nn5DvzfrXBnSoCZVyBu705+6gDCfREAAAIEKFA=
Date: Tue, 13 Oct 2026 09:14:26 +0000
Message-ID:
 <TYUPR06MB62178F3E7055CE043CF1147DD29E2@TYUPR06MB6217.apcprd06.prod.outlook.com>
References:
 <TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <2207cca2-89e7-4694-b903-aca15cec1edd@suse.com>
In-Reply-To: <2207cca2-89e7-4694-b903-aca15cec1edd@suse.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYUPR06MB6217:EE_|TYSPR06MB6541:EE_
x-ms-office365-filtering-correlation-id: 84417a05-aa01-426c-d1e3-08df290a6117
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|42112799006|23010399003|376014|1800799024|366016|7416014|18002099003|22082099003|10067099003|38070700021|4143699003|11063799006|5023799004|261009223027099003|56012099006;
x-microsoft-antispam-message-info:
 VwVMBIeQWEhb25BAL58Z6r+x9v6UGdIR6mtgm3CSaABdIeE5GR5Vlfnl3hYxZWqbCZkBZ+LYSusMymLBJcCkv60169gNUCl6BnBcIeHBj3dXGwGiaWHVqs9qkckIxuVy202MgFOZht45J7925bhJbQI0ASFGJlcWR2RgeOKr2bTan3UiNeioKI8o86wxi/QhPXF4qgUhICl967+T8bitEK8GMCHU/3hNB4LxqPn5gwkPaxKaZJBBloBGsmwT09ENwlDqxIsZ39iVbyuQ/rbSeXFLhjxn7uhz2s8UyS4+zidUFdlJqfKHYe8kIVIYe7M4IQsHRerB3Bhanfef5GqoR8NzRvnmfbFPNtZeWsiyHt7wsW0XHo+KN5tqvgz0ZXVvwKjmiRjqx7LMPrnVDrQ++h8rIDgf2okTh8ur06DqTfOa8jyfiIy6/Tr4RmD69sIHYipad76wLvNgA1X8g4oiLxZLXjEbhBOq4vcrAybbQtVGIgvyGXGGihQVQf41Vc/G21th2HaO9E8QjrfaIOisRemxxpJbmL1/ebn8GFK69mUFy6+Z0iHp6RI6mXdVyie/oyu7wKNDdcZlf20IqlnOU7MFq7Pfz+M7nnlxR/SoNGacJh4yfwxqCA8SaXRPQsRBeOaxKIZR1Pm6210M7MyhOSvuzPFYPzrt0PQi5uyeoPewmeZQD2bH/PipK0LYaWKINiM0En5CCubQ1lBBpuCcZumKBvHG0jvmlf82f5IrIvQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYUPR06MB6217.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(23010399003)(376014)(1800799024)(366016)(7416014)(18002099003)(22082099003)(10067099003)(38070700021)(4143699003)(11063799006)(5023799004)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b25URk9wWjZrRlhiZWtnYlkyT09QcDAzM3podWFaUDNMNC9SUUxoanQ2cnlG?=
 =?utf-8?B?Slp6OG9OWXhkMXB3TEgvN2FKU1VuU09GRXd4RmhjNG1Wd2ZHVS9qa2pXdmNK?=
 =?utf-8?B?N3c3NmRsb0E5bFJ0TVUzeDJDcUVMNEgydTkxMkE4aUJpR1dqN2UwVzFtcE82?=
 =?utf-8?B?S285WXFwTlVGRXU1b0tQVSttWHloZXlqVFNRTDQ1Mlhidis3UlpUUXBwYWhZ?=
 =?utf-8?B?Q2RoZkdJTncwZi9oT2dXdVlXZFpUMzFXamxUTHIvTzRxd1hzTktRRkhRQzFi?=
 =?utf-8?B?a1lvbFpxZmJyL0hTeUhPTXJpRFc4ekdEcDB1SXNKQ1BGQzdDY1Q5QWxLQ1Ft?=
 =?utf-8?B?YWJrMktqOW5uNTFmTUJMVzFBUUZ0TGRVK3Y0M2FZSURGeFhDSW9WWVpmSDl2?=
 =?utf-8?B?SGtkWTZGNTVZT0VId3R1bG5wa0hwUU9PRTR2eDJOdEhzUW94Y24xeDdGdmZ2?=
 =?utf-8?B?S0ViamwzZFNaWndSQ0NYK095eXkyczYrcHdvc3FZZW90Nlp4eEVuVWdUd3VK?=
 =?utf-8?B?VDNjKzdYOWhmQ3RwWGthZ3RONXYyL2p6djlqTTJrR2RxVHl0TXhqSDJVOE5B?=
 =?utf-8?B?NXA0ZGZCZ0dmMFJRMkVhUFVFL1JMSlU0MitKYVdwYU1lcy9DeVRYbmVEdGhW?=
 =?utf-8?B?SloxZTBJYVZuV2VZc1NENVhieVVWa2xMTFBCR1ZaUkJqTXZvNGJVdFJLdW93?=
 =?utf-8?B?OC9ZRlgyR2Z4S1pGRHAyMDUwODRBZVJXdWpodEVvb2xXYVhjU3ZCYVRxWWVQ?=
 =?utf-8?B?R095Q2RweHNiRTU1QjRza2RWYWsxaGRPVm5nY3crejRiMStNTFllOHltSUZV?=
 =?utf-8?B?ZWtxbVpYY3hPKzY0VkI0YVlvUzFMMU81M0t0VjZSdGY1SUd0RkxVd3BRUDJG?=
 =?utf-8?B?b0IyMXIyWUloZytuOE5BWWpUeGRsTTFUV1BjVVZHZG1sbmVCbU03MVhhWWhO?=
 =?utf-8?B?T1V0UDVLTEI0K3czUnRzVVovc051RjJUQm9kSWRSZmJKR2diUUhuTGF1U3U4?=
 =?utf-8?B?WDRwL0Z3bEo5aFJjL0JFTHZ1SENLZjczVTZLWXh6b2NYcUpqNkJjS2VaS3hC?=
 =?utf-8?B?NGkxWFpYNlhLRjNOZExqZG5BT0J0N0RCVXRGOXJaWGFMV1ZzaG1MUzVRZXFJ?=
 =?utf-8?B?UTFDQVAzMGxyTjZLeWFjWHZFcVhTb0tHczlUNUNld0lPdWEzUUY3RE9MR3lV?=
 =?utf-8?B?K1llVEN5SGlGNEc4eHo0aW96cnhjSGl1V2w0STJ1cnRkTmUwVU1BdjFqWDZK?=
 =?utf-8?B?eUtUaXIzcCtCVkVCRGdWRVgvKzFIcVN4RmJMaU5FdGVKZTI1V01JVW83OFF3?=
 =?utf-8?B?c29qWTNud3dvbnUvKzIwWk5sbUdhc0pPUHVZN2dPK1RCM2xKeURidmFsUkxE?=
 =?utf-8?B?eGgzTXlreXVYbWhNR0QyRjAzT1Y2RTBpcmVDVmxBRExXTVFoVmNSdjhsY1RU?=
 =?utf-8?B?SVV4YjU1NWlzdmZGYUdiL3pmbk5JL1l6UWdmY3JvNlFnTEVjeEZWY1BRaDRU?=
 =?utf-8?B?dU83ako0TzFLMFV1akllcExLUzUwMlZiZHRsWDdIMndaUW5PK1VmcVdvcFFO?=
 =?utf-8?B?NzNLUUJxT0Q2eFNBdUpPMWRzM1RGS3BJd1o0S2Yxb3djdFFQQnpoZElOaks2?=
 =?utf-8?B?OG9sYlhQKzE5SmplTmU5SE53OWVVZHZVWEdLSmhIYVczN1pUMTJBK2R6OFhX?=
 =?utf-8?B?bFhwZmphRmFZUm9ERWdMdUxoS1hPWFg4dG1rUitqb2YwZzdWMFJ5R21zOFNt?=
 =?utf-8?B?MjlEbkFpNVl4K3VNTStYK3hGRzhyblVaSi9GMkJUZys5ditObS96cllGRnZM?=
 =?utf-8?B?S2JiSDlCOHZXSTVTbkVKWlhTSzlWUVBFL3dPekYxck50alpya0V5S0crMHJo?=
 =?utf-8?B?a1pqNE52OGtITVlpYk9XaUZ3NGNpZWdnb3RmekVtR3F2cWMyT3NkYlJKbm4x?=
 =?utf-8?B?V1c1WDhPSzdNR0RhRHRXVTY1NW0zRjA0a1E5WHM1MWMzR2pZZEZJU2Rmb2tx?=
 =?utf-8?B?K09Rc3JlZnFQRHhkd2t1MTdGa081eTYzQzVReGNpNE93b2owSjRyaDhERUNu?=
 =?utf-8?B?ZXp1a2NEYkRiTUxzaWJCVS9kc1lXUHBZWGNZRHk0OCszeTF4UVRQSk9BSXhW?=
 =?utf-8?B?cS9pUjdBemxCVUlrL0ZBOTh5M05ZZFRGVE5yYlczbXZyMmFGMjlHT3p0NWlw?=
 =?utf-8?B?YW54elBRRzZ2Ky90bEtlTXJZUkJHQVpyVHQxZGRNZlpsbW1VREtGTTVLeDFG?=
 =?utf-8?Q?eI0IUdNc+O3d+8bZmbU3u8l/bgYkD9JCcLcOH2Hm30=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 84417a05-aa01-426c-d1e3-08df290a6117
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2026 09:14:26.4584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ePojsADo57R6v6eUA0pb2gaAs/pqh6We3/LgUQ8rIlIoZMjKRAk2yDmASmaiPZOcHkR24zoT0/svGiPKk1qHCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6541

SGkgT2xpdmVyLA0KDQo+ID4gaW5kZXggYTFiMjFlYTE0ZTU0Li45OGY4NjFmYjdlODAgMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3NkLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvc2Qu
Yw0KPiA+IEBAIC00MjcyLDYgKzQyNzIsMTAgQEAgc3RhdGljIHZvaWQgc2RfcmVtb3ZlKHN0cnVj
dCBzY3NpX2RldmljZSAqc2RwKQ0KPiA+DQo+ID4gICAJc2NzaV9hdXRvcG1fZ2V0X2RldmljZShz
ZGtwLT5kZXZpY2UpOw0KPiANCj4gSGVyZSB5b3UgcmVzdW1lIHRoZSBkZXZpY2UNCj4gDQo+ID4g
KwkvKiBEZXZpY2UgaXMgZ29uZTsgYXZvaWQgc3luY19maWxlc3lzdGVtKCkgaGFuZyBpbiBkZWxf
Z2VuZGlzaygpLiAqLw0KPiA+ICsJaWYgKHNka3AtPmRldmljZS0+aG9zdC0+c3VycHJpc2VfcmVt
b3ZhbCkNCj4gPiArCQlibGtfbWFya19kaXNrX2RlYWQoc2RrcC0+ZGlzayk7DQo+IA0KPiBIZXJl
IHlvdSBjaGVjayB3aGV0aGVyIGl0IGV4aXN0cy4NCj4gDQo+IFRoYXQgc2VlbXMgYSBiaXQgaW52
ZXJ0ZWQuIFdoYXQgaXMgdGhlIHBvaW50IG9mIHJlc3VtaW5nIGEgZGV2aWNlDQo+IHRoYXQgaGFz
IGdvbmUgYXdheT8NCj4gDQoNCllvdSdyZSByaWdodC4gSXQgbWFrZXMgbm8gc2Vuc2UgdG8gcmVz
dW1lIGEgZGV2aWNlIHRoYXQgaXMgYWxyZWFkeSBnb25lLg0KDQpJJ2xsIG1vdmUgdGhlIHN1cnBy
aXNlX3JlbW92YWwgY2hlY2sgYmVmb3JlIHNjc2lfYXV0b3BtX2dldF9kZXZpY2UoKQ0KYW5kIHNr
aXAgdGhlIHJlc3VtZSBlbnRpcmVseSBmb3Igc3VycHJpc2UgcmVtb3ZhbDoNCg0KICBpZiAodGVz
dF9iaXQoU0hPU1RfU1VSUFJJU0VfUkVNT1ZBTCwgJnNka3AtPmRldmljZS0+aG9zdC0+ZmxhZ3Mp
KQ0KICAgICAgYmxrX21hcmtfZGlza19kZWFkKHNka3AtPmRpc2spOw0KICBlbHNlDQogICAgICBz
Y3NpX2F1dG9wbV9nZXRfZGV2aWNlKHNka3AtPmRldmljZSk7DQoNClRoaXMgd2F5LCBmb3Igc3Vy
cHJpc2UgcmVtb3ZhbCB3ZSBza2lwIHRoZSByZXN1bWUgYW5kIGdvIHN0cmFpZ2h0IHRvDQptYXJr
aW5nIHRoZSBkaXNrIGRlYWQuIEZvciBvcmRlcmx5IHJlbW92YWwsIHRoZSByZXN1bWUgcHJvY2Vl
ZHMgYXMNCmJlZm9yZS4NCg0KVGhlIGNvbXBsZXRlIGNoYW5nZXM6DQoNCiBkcml2ZXJzL3Njc2kv
c2QuYyAgICAgICAgIHwgNiArKysrKy0NCiBkcml2ZXJzL3VzYi9zdG9yYWdlL3VzYi5jIHwgMyAr
KysNCiBpbmNsdWRlL3Njc2kvc2NzaV9ob3N0LmggIHwgNyArKysrKysrDQogMyBmaWxlcyBjaGFu
Z2VkLCAxNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3Njc2kvc2QuYyBiL2RyaXZlcnMvc2NzaS9zZC5jDQppbmRleCBhMWIyMWVhMTRlNTQuLmRi
MDZmZTY3ZjRjZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9zZC5jDQorKysgYi9kcml2ZXJz
L3Njc2kvc2QuYw0KQEAgLTQyNzAsNyArNDI3MCwxMSBAQCBzdGF0aWMgdm9pZCBzZF9yZW1vdmUo
c3RydWN0IHNjc2lfZGV2aWNlICpzZHApDQogCXN0cnVjdCBkZXZpY2UgKmRldiA9ICZzZHAtPnNk
ZXZfZ2VuZGV2Ow0KIAlzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwID0gZGV2X2dldF9kcnZkYXRhKGRl
dik7DQogDQotCXNjc2lfYXV0b3BtX2dldF9kZXZpY2Uoc2RrcC0+ZGV2aWNlKTsNCisJLyogU3Vy
cHJpc2UgcmVtb3ZhbDogc2tpcCByZXN1bWUgYW5kIHN5bmMgdG8gYXZvaWQgSS9PIGhhbmcuICov
DQorCWlmICh0ZXN0X2JpdChTSE9TVF9TVVJQUklTRV9SRU1PVkFMLCAmc2RrcC0+ZGV2aWNlLT5o
b3N0LT5mbGFncykpDQorCQlibGtfbWFya19kaXNrX2RlYWQoc2RrcC0+ZGlzayk7DQorCWVsc2UN
CisJCXNjc2lfYXV0b3BtX2dldF9kZXZpY2Uoc2RrcC0+ZGV2aWNlKTsNCiANCiAJZGV2aWNlX2Rl
bCgmc2RrcC0+ZGlza19kZXYpOw0KIAlkZWxfZ2VuZGlzayhzZGtwLT5kaXNrKTsNCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL3Njc2kvc2NzaV9ob3N0LmggYi9pbmNsdWRlL3Njc2kvc2NzaV9ob3N0LmgN
CmluZGV4IDE2MjQzZWMzNzZjZC4uNjZhYTlhZTYwN2RlIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9z
Y3NpL3Njc2lfaG9zdC5oDQorKysgYi9pbmNsdWRlL3Njc2kvc2NzaV9ob3N0LmgNCkBAIC03NTcs
NiArNzU3LDEzIEBAIHN0cnVjdCBTY3NpX0hvc3Qgew0KIAkvKiBEZWxheSBmb3IgcnVudGltZSBh
dXRvc3VzcGVuZCAqLw0KIAlpbnQgcnBtX2F1dG9zdXNwZW5kX2RlbGF5Ow0KIA0KKwkvKg0KKwkg
KiBIb3N0IGZsYWdzIGZvciBydW50aW1lIHN0YXRlIHRoYXQgbWF5IGJlIHNldCBjb25jdXJyZW50
bHkuDQorCSAqIFVzZSBhdG9taWMgYml0b3BzIChzZXRfYml0L3Rlc3RfYml0KSB0byBhY2Nlc3Mu
DQorCSAqLw0KKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KKyNkZWZpbmUgU0hPU1RfU1VSUFJJU0Vf
UkVNT1ZBTAkwDQorDQogCS8qDQogCSAqIFdlIHNob3VsZCBlbnN1cmUgdGhhdCB0aGlzIGlzIGFs
aWduZWQsIGJvdGggZm9yIGJldHRlciBwZXJmb3JtYW5jZQ0KIAkgKiBhbmQgYWxzbyBiZWNhdXNl
IHNvbWUgY29tcGlsZXJzIChtNjhrKSBkb24ndCBhdXRvbWF0aWNhbGx5IGZvcmNlDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy91c2Ivc3RvcmFnZS91c2IuYyBiL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdXNi
LmMNCmluZGV4IDA2NGM3ZmM4ZTM2OC4uM2E1YTBjYWMyYjc4IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy91c2Ivc3RvcmFnZS91c2IuYw0KKysrIGIvZHJpdmVycy91c2Ivc3RvcmFnZS91c2IuYw0KQEAg
LTkzMCw2ICs5MzAsOSBAQCBzdGF0aWMgdm9pZCBxdWllc2NlX2FuZF9yZW1vdmVfaG9zdChzdHJ1
Y3QgdXNfZGF0YSAqdXMpDQogCWlmICh1cy0+cHVzYl9kZXYtPnN0YXRlID09IFVTQl9TVEFURV9O
T1RBVFRBQ0hFRCkgew0KIAkJc2V0X2JpdChVU19GTElEWF9ESVNDT05ORUNUSU5HLCAmdXMtPmRm
bGFncyk7DQogCQl3YWtlX3VwKCZ1cy0+ZGVsYXlfd2FpdCk7DQorDQorCQkvKiBEZXZpY2UgaXMg
cGh5c2ljYWxseSBnb25lLCBjYW5ub3QgaGFuZGxlIEkvTyAqLw0KKwkJc2V0X2JpdChTSE9TVF9T
VVJQUklTRV9SRU1PVkFMLCAmaG9zdC0+ZmxhZ3MpOw0KIAl9DQoNClJlZ2FyZHMsDQpMaWFucWlu
DQo=
