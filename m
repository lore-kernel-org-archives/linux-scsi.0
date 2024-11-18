Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9884517BBF;
	Mon, 18 Nov 2024 07:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731913242; cv=fail; b=Kbc7CJd3PogqrTmmOPEYSqWbGR8xRXE0FsJri8TpZIYPII2J5KslQF/xEZRyEaoE+FFkXEY6MjHWavKZR6oOdeHU8dIz1MWyq5R8Uh0truqpDOOBoDeB9rjaRM37W3Pq9Sjxs01TyC03N7RRxxXOGmgHKRcvz0FbTb3lfFkYI3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731913242; c=relaxed/simple;
	bh=4SRsKa0EpWTAApLjWn1UueOoYENA5cCdCxMfuyL+9CQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ALwPTpyQYyv/1Kdh4bkYfDNNcZoTgwnTXnmjKFNDrRtDepUCgBBJIBP/W9niXD+gt6aU1ffV2q5sV0bLPtJcYu4YTshJOqbGpmrQ5CBMl99LCaAQS3c37v6PvJeGI1cCdiidRTE7LEGsVdh68An8k4wi+HfcMVOTG+aoAHFkfB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oaDqxmGz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=HaBW26/z; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oaDqxmGz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HaBW26/z"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1731913241; x=1763449241;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4SRsKa0EpWTAApLjWn1UueOoYENA5cCdCxMfuyL+9CQ=;
  b=oaDqxmGz3v03WJlNBSqS6tqNRNsDwvmrekarpubfQ2Y0JbSZM8wurktR
   tJaDbElvOOxqpd1Nq++zN7NeDT7ZL/jtMCBmeUKoAIVGCV6dGgxPFIdny
   h5mP9tLAEqLCrD8grC7wry7sQTmHsgtiXxwHLCuB1r08+iSE7wS+RQEaK
   FTM3xipZDf82nVb7xSFxkE1CJenFvIOiGUgT073GCSDrFkNUGQqJXiUPL
   f7ev7kPIEnc4FzgDfnUfYTCgSHy5VPm5nUYXIvv+A+v9WJeRNycCvjsuX
   e3dxghc38RfenYK8NnMfajz1vu3hN3UT6k8Duiqpbt9uPNo/e0uo8HqWy
   g==;
X-CSE-ConnectionGUID: cPY9HSPGSNiGoFx15ApWFA==
X-CSE-MsgGUID: jxxrgZ+zQ2Sh/TkvG67hjw==
X-IronPort-AV: E=Sophos;i="6.12,163,1728921600"; 
   d="scan'208";a="31795919"
Received: from mail-eastus2azlp17011029.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([40.93.12.29])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2024 15:00:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ptOQvdHkA5eS0eGeGp8VgBF/ichXFg/bSavyEinno9WhHjZisclt2C5dwjfnkZukQx/wYkP/p5tVxjQoTZRY5BB5ADSXSqDceauQ1RAaRSI2ZE0vLWpppHrpUkF4nr8qAEPOZGObCmaEmOYKOq+Nt/cAfn0OsK3u15wYXqbv2PtG/rp3BO4FJbfcTKf/9LzV5UYJHdLftWMVdRiAVAjy4rw3ZyonDm8hL3p0YNTQAZE+WuXEOcT+SvI9Qm2nZGHGOA5vV27QQdHn/BlVme7wuZumxHy4GoaTxLPHL4nQS6aBt7TDSZr6B+aI/egCCvFg7dW5HTNzXF8niprc++Is5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SRsKa0EpWTAApLjWn1UueOoYENA5cCdCxMfuyL+9CQ=;
 b=VCb4q3uw4tjTKEDOX8Xsh0SgPQCgwD+iIWeguT8sm2kczxB+qSN3UTXrvvp3g9+/RsZsLHf8quz/dPZXvlwdbfniQ3faVq+zWAdKUe2uwb1HFYuANkzQFM6eS7F3tY2jpw5SL3jKpTnHIUwEZ+IBWT0y2oslnQ0t0QQLhcVkpxF4lMnF/oHVyw7EeqzbUcwGnA2yP/9YceIFFPdQtnD/F7oMH5fvaFwcOrGcVnyjaS4ml7OJPbLtZr8rSQ+OnJrPBhXrEyrBWt1uxfXt6Ztpuhs1wrG8y1kIrhdFnUfqMpLdI5BiC3qBek3TisfSjaFiAVdAw0gUtrG9QftwkfHqSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SRsKa0EpWTAApLjWn1UueOoYENA5cCdCxMfuyL+9CQ=;
 b=HaBW26/zSTU1vewb5KC5IZyp5+eB18N8hMTBnZONeYUut5PzVfzsKlO1mlWNtbad0okpd96ofvm1EBqL8m1A31VbbD5Ez6c67a1HDl4vswCoKYuw+9e2bNV3M+QB8aOQ24IHnM03mYbkXNEWqyohNttZCbeMxJTo1ybwUj6JMAA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DS1PR04MB9286.namprd04.prod.outlook.com (2603:10b6:8:1e9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.23; Mon, 18 Nov 2024 07:00:31 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8158.023; Mon, 18 Nov 2024
 07:00:31 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bean Huo <huobean@gmail.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, "beanhuo@micron.com" <beanhuo@micron.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
 Assche <bvanassche@acm.org>
Subject: RE: [PATCH v3 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Topic: [PATCH v3 1/2] scsi: ufs: core: Introduce a new clock_gating
 lock
Thread-Index: AQHbL3WvpQA/mYZcmUibUopLvxMna7KywLAAgAnuMIA=
Date: Mon, 18 Nov 2024 07:00:31 +0000
Message-ID:
 <DM6PR04MB6575A35B9478BB93DB426BFFFC272@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241105112502.710427-1-avri.altman@wdc.com>
	 <20241105112502.710427-2-avri.altman@wdc.com>
 <2d9aa1f9ed2e63d29dc2a7745fdd4f6db45d8db0.camel@gmail.com>
In-Reply-To: <2d9aa1f9ed2e63d29dc2a7745fdd4f6db45d8db0.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DS1PR04MB9286:EE_
x-ms-office365-filtering-correlation-id: 7a9ef0ab-8d39-43a2-0a6d-08dd079eb11e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ODVzQk4raW5DeVB2Rm1XdnhlT3FNby9yYnZvNjdXbThaaXRXaFk0bHZBTW11?=
 =?utf-8?B?UEpKLzVEVHFZYXNzV3BTWHd3cHBMNmM3UTJqZlBXYklvdk1zdVdBb3pEY0xS?=
 =?utf-8?B?eDNRczVxRDFwYUdRZEtwSWlkelNpeStTeCtaVGdVVFRKQXJURzBoaW1Ca3FT?=
 =?utf-8?B?d0xHUGlROUhhUGIvSjBaM0pDUllwMktyUCtUTnNBYmx3bWlweEZZb21uakpx?=
 =?utf-8?B?alQyTG9aSzFlMGh2WnBjcms3aDgvQXRJSHZ4aXdRUVQxTzk0UTRzakFBb29B?=
 =?utf-8?B?U0gyOUV3d1JpNnJyOFdvRkR3SjM4d1hLMWdEcmpyeGt5bjRUdVNiaWVVRWMz?=
 =?utf-8?B?bjhpMDMwU3NCZ0pjSHdFR241bmU5NlBONCtCaWFDMG1pd2Qvc2M3QXIyV0kw?=
 =?utf-8?B?QUpDc0YyWDZRSFNhaUR1QXVzWU1GeHdyQ1NnbUlNVlliNFdwMnJ2Sm95ZlIx?=
 =?utf-8?B?TXkvdHEvMVFEcTNXSllwdnRoV2pGS3hMUllpc2s3WWVva2l6aHY2cEpQR1Yx?=
 =?utf-8?B?MCtlRml5eTFtK2JlTnc2d1dOMjVuR0hibUx3UFdwNHB6bERnOXVEUWFIa29a?=
 =?utf-8?B?ZXZvOGNyaGdSR2VETmJITnI5SHhjdFFoVjRkNFUwUjFNQmt5WEgxd3BxN0Zw?=
 =?utf-8?B?Nk1xcThCVi8raE5Sd3Q0dE9LRUM4OGozeEIyRFo2dGpoOE13ODZtWWR3SUlM?=
 =?utf-8?B?OWNMMXI0Uzg3Q2h2WmZ5S3RYOGZHeGFrRHZuV0xLMEtmVk1FNjVxWnJqQnE5?=
 =?utf-8?B?MWJiOGRrYUt6UGV6VW81anAyMDR5NzRBMXlBR0o5U1NPUmlFeVRZbmVQK1E0?=
 =?utf-8?B?Ti9RN0FZNVJ2Y0l1SUdvRVEvQ0FnTlRLSTZNZ2Z0SHByNmo3SUNKdkhTTGR6?=
 =?utf-8?B?VWRmcnI3bk1RNXBLa3ZBWEJWVjBvVUFidnFIaXluS2lDMEIxTlpUc0FuN2dD?=
 =?utf-8?B?czdDZEN2aGhpOTlLWXorWEIvZDYxV3QvVHJCaGExaGFRMG9nMm5EYlBhS0ZB?=
 =?utf-8?B?QXpWbjREU3ZzY05GQ3NDQStyalZraCtoMFVFRHRjOGRGTGFaSWlLK3FJUVJu?=
 =?utf-8?B?Y1MzWm8zS0hpcXg5SDVmZVNoME03VS9KNWNTL1FTc2RvcGhxaVhrazMrMGRQ?=
 =?utf-8?B?Y1g1RHM4a2tiZkxwTkZlWWZBQzJ0TFprakR3aElhQjdvOFNnOVNGdk81d3d6?=
 =?utf-8?B?cnRsZVBTNmR0Q3ZFcVBuV0gzenB4Tys2bTF0Ui9iTTl5clErUlpUWVh6cEl6?=
 =?utf-8?B?T0FWc3VlT3NSY0ZGVkRjK04yeXFscmYvS29INnBUUGJFbGRNZmU5U3NyMlpt?=
 =?utf-8?B?UE41Smx0UlF2cVdrekRiRmEyWGRwMEF4QnEvMVJVVWx1b2NlMGxaSlVqMFFF?=
 =?utf-8?B?T1BWcnFLQ3FLSXpmb3R4aXBIRVNQRTdhbHg1MkVhYTl5ci9Qcko1UnBNRTY4?=
 =?utf-8?B?RUNQNjRxaEZBMFU3MjhLamQ4TkRjUXRpcDhoL0hzUUczdU9yUktXejdoRnA5?=
 =?utf-8?B?ZkhQMmVwRERsK2lJbmVNN1dkNFlEcWpIVytKZXd5T3pGUDFSUkd1dVEzRmtS?=
 =?utf-8?B?bE9LeEdkbzdJQno2QmRUT3JvWHBQV1dtdzBuT0JmclhlOEVFUzRseHN0NGpG?=
 =?utf-8?B?VWRVeUVMRTE3VFZvaU96b242MnhFalA3OFRBMG53UlB2ZmJYN253WkpJYkZa?=
 =?utf-8?B?UnYyOTNaZHl0L2VSaG9VazYwQmNSeSszM2lUa1NMNGw3Ym4xMnFPK3dUVzdZ?=
 =?utf-8?B?QTZCZ1Y0QlNFNVJkM0xQWXZIOTRkMGEyb0tOV3R4eUd0cjgvYnJ0RnlDYlRU?=
 =?utf-8?Q?D54/K1iTr1rcbPnorjMfStzmG+0w2yr1n7/Y4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZVIrUHIxbEc1bWl2RWgxMlZyb2NrZHI3a3JweXdJNEtwYmhGWUh2ejhWQWVa?=
 =?utf-8?B?VElLM2t4d1dEVitZN3NpRUFCK1d5cllPR2tsWUlFSzB5QjN6Y2VrRU5sY0NW?=
 =?utf-8?B?NnNTbGV5RHIrUWNWaElGMEQrUHM0dWdwVGxuN1dPRlJqanBCRDVNc0I0Q2l4?=
 =?utf-8?B?aWNoS3ZIRTE4RG9wekZRekdWQU4xeDh3b1JvSkZ3b20zbmF4VlJGOWk4WXFa?=
 =?utf-8?B?dUJla29oU0h3NmtUd1pobDVyRGJzQVE0ampvQy9TS3BjKzhlTFB2R3ZUZDhR?=
 =?utf-8?B?L2w5amNXV0ttT3d5TmV4dlQySmdSajBhZEVDdGtBQW1OcDhtYzdYZFNZdzYy?=
 =?utf-8?B?T0FaMFVYSWFzTFVPUms3R2pHdkdkakhqN3BvWU5IWWk2cWsraDMweUZJRWJ0?=
 =?utf-8?B?SURDczVNcnM3RUJ2dWtPNG42QkR3S1NpaXN6SllENWRJSDFFcmFodExYVjRH?=
 =?utf-8?B?RGZJRFE2dlZnSEpHZW5xL25VZzU3a3BiQURXVk9veFUrRUFGaDRmM0ZDbGJF?=
 =?utf-8?B?azA4ZHVVcVM2YjZkZkNOWHJNeGdUaVVpSEJOTVNzZCs3N1lpTkNrTm1LbEdH?=
 =?utf-8?B?ZjVYY0lIeDFXRXgwSGlCWncxZEswR1VMWjdFbEFPcE9pbzlEak1uVVh0a3hQ?=
 =?utf-8?B?QVNsWk0wMmRBMXBMMmpHUE9UNlltUjBIQUpsc0dTaVBIdUFCemtxZ1pmdXo5?=
 =?utf-8?B?Y1ZMb0p3bXRFeXZCTGtvOEtDRkFtSTdMZHM0TzI3UlY3WHNXcytOZU9rZnM5?=
 =?utf-8?B?d0tGYk1XNmRCNWVDSEdRRk9teDZRNzN5UDJuLzkva1lHbHFXMldmZi9FNk05?=
 =?utf-8?B?RVpLeTJiRDY2Y3p6VlVCQUFWT25TWUgwYjY1S0Z2MGpmUFl5ODlEYlNZYitz?=
 =?utf-8?B?UDJWNTlLVDM3YXFQTldKK2Q2NzhDY2w1ZU9hRjVhR0tMb3d0VXJWWUhJTnZX?=
 =?utf-8?B?bXpaMWViWXNmcFZwZ3JCdVJyTUdBRHVBOEwvd3BVSThWL0lja3pkTjhaS3Ux?=
 =?utf-8?B?ZkxpWDM0dGdvUTNTbkNwTzRIWmFuTVZNeFFMVW85ajZDK2FxRTVUNm55aS8z?=
 =?utf-8?B?QnZaUXMxWllCRVNHVWJ5N010d3FrNHQ4VWp6UENMWEZ2d1EzL3ljOStzSUpR?=
 =?utf-8?B?UU1ZQTUySTlFSE1XTWl2YkhnOU1vM1BNb0hzc3l2eFVzUVZZSXNIcDRiR2dp?=
 =?utf-8?B?UzZSR0hMMkI3R01SZWc3Z1FoUXFCcFFPTDBlRnhCME9LTHZFNkM2NjN5Y3U2?=
 =?utf-8?B?dTJML0xNb29pODFhdzYyQ205OExzd0RkS2IrelA4aGVKeVVNbEk1WW1FaHl2?=
 =?utf-8?B?c1FrM0NRaU5pbmsvcVhqVkdFclNkRGw2V2dvOVV6ZmJ4Nmg3L1lSWFFWbXp1?=
 =?utf-8?B?WUpOUVdWNU5ucXNmMWRuZmtFd3RkNmV4VXFEaGZFQlcrYnlRdlZ4dnJ4NGlY?=
 =?utf-8?B?d1F6OFlmK2RxaG9aK2l5dDdOc1NuVUFHOXdFUjY3eTBOQVRMLzRJa09HcERN?=
 =?utf-8?B?c011SWdRV1hZcEVkYlQyaEFBZTl4Q2Jqck9CLzNEWHdxdGpNbzFyZy9IRkJV?=
 =?utf-8?B?eTltbWpLNy9tcUFOb3FYci84c28vRHRSc3hwYmdxbi9tSGdOYVdDNldrbFha?=
 =?utf-8?B?UUdrc2ovQk4xVzVUZTNWbXlJeDlBTHhhMHlMQzk3cjlST25ZcHBMRHpGYW9o?=
 =?utf-8?B?UFZhZUNBcllOT3hLa2NTOUF3UnlHcmRyZ1BTWnpiUlZIMmtWdnR6VHYxZWZC?=
 =?utf-8?B?ZnhGbXJ3aXAwU0l0blJ6M3VwblZmb3IyNk1uc0lKTjM4RE1VR0FOY1poOU1Q?=
 =?utf-8?B?UmZTTUxaMHFpNUJ6ZzRVZ1AxYVhlalNZUWtlZ3MxTVRNdTJCMitqV2RCVTQ0?=
 =?utf-8?B?eTlwSHU4U21JWGxkWGlyaS8xVk5HTDh3UzdDWjgvZ3R4ZVk5dnFCZmpEUmVB?=
 =?utf-8?B?S3BtQ04yNHBORlU2ajdDeVcrcENyRVBaRmxobGcvZWN3Mkt5N2s4MGN1L2N6?=
 =?utf-8?B?Y3hRdHg2dkZoTXZ1TG8xbFcyeW5HMTc3V0M1WXZXN0oyWkl0eitoY09JTzFx?=
 =?utf-8?B?Tlpkd2RlUmNHT3ptMVhNdEtlcTBqV2FuUzhWRkY0NmdPQWVrSE9Hc0haU3Zj?=
 =?utf-8?Q?TSTzbklZhFWJGB7HaZnWU023v?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WnsYenciR9pwMcI0g4szRvKBf6f5B9P9aZr37d/NXK9VOMwSWG4F5JQmIi/Xg1cE5rveGAmXfzvEPxOg6IkvIgaK3OHxVCl2XlUVJ7HuzM4cyU9xPb9LfUR2d9cIXTXP5lhVW9YawADFCCSoVx9/MjB6M+E6uBD1+bBEYwFZlYcYHBmT4TsdyafelE79uxv33gqCFeLg17eth9d4ppOn1+ydVAN5iB0Gev0GmOwnfSVdJPx8dRs/M/RkIT6jP6f5sVW+JmPge+3GuOKJcsVNDnt9xsWBv1iroazp3iuILlyLqdFCkeZSpesNYTDxWSHswPiKHighqJYta3K+x6wZhTudLTAmYMI0PjkK3mIQ7wfqu6DDXx5Y5HcFHbRbkIgscVtkWmvU1l1TvRQBokhYjmXc+7Br+NJUrNjlWeDlfO4Nd3vofObWbiY5EF9cEbKvRsYOgP/xMhpW5pI4GGW9myDLWnm6FtVy2gJk3GXXUF70cYwFTKVjEk7eykLgv9IfKRjCRR/3rw4MPRGVDoaImz4Nur+f/I843NrhfikslivFpI78+B3W/ZML8aM9kGGERP7SmJ+u+1q7hrI0zZ1VNrVfV7vlSZOq/oqvGRNksYnc5G1Qz119BqcegOfZrXM8
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9ef0ab-8d39-43a2-0a6d-08dd079eb11e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2024 07:00:31.4191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X6W7lX9z9L3iDSBQ3GJXMFxdzq0/K9s6XUTzvQ2pKcJtGZ1m6L82Ahs4yM5h9aaoso9a2qEZ3PbWfpr8+JJFIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9286

DQo+IE9uIFR1ZSwgMjAyNC0xMS0wNSBhdCAxMzoyNSArMDIwMCwgQXZyaSBBbHRtYW4gd3JvdGU6
DQo+ID4gLSAgICAgICBzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxh
Z3MpOw0KPiA+IC0gICAgICAgLyoNCj4gPiAtICAgICAgICAqIEluIGNhc2UgeW91IGFyZSBoZXJl
IHRvIGNhbmNlbCB0aGlzIHdvcmsgdGhlIGdhdGluZyBzdGF0ZQ0KPiA+IC0gICAgICAgICogd291
bGQgYmUgbWFya2VkIGFzIFJFUV9DTEtTX09OLiBJbiB0aGlzIGNhc2Ugc2F2ZSB0aW1lIGJ5DQo+
ID4gLSAgICAgICAgKiBza2lwcGluZyB0aGUgZ2F0aW5nIHdvcmsgYW5kIGV4aXQgYWZ0ZXIgY2hh
bmdpbmcgdGhlIGNsb2NrDQo+ID4gLSAgICAgICAgKiBzdGF0ZSB0byBDTEtTX09OLg0KPiA+IC0g
ICAgICAgICovDQo+ID4gLSAgICAgICBpZiAoaGJhLT5jbGtfZ2F0aW5nLmlzX3N1c3BlbmRlZCB8
fA0KPiA+IC0gICAgICAgICAgICAgICAoaGJhLT5jbGtfZ2F0aW5nLnN0YXRlICE9IFJFUV9DTEtT
X09GRikpIHsNCj4gPiAtICAgICAgICAgICAgICAgaGJhLT5jbGtfZ2F0aW5nLnN0YXRlID0gQ0xL
U19PTjsNCj4gPiAtICAgICAgICAgICAgICAgdHJhY2VfdWZzaGNkX2Nsa19nYXRpbmcoZGV2X25h
bWUoaGJhLT5kZXYpLA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBoYmEtPmNsa19nYXRpbmcuc3RhdGUpOw0KPiA+IC0gICAgICAgICAgICAgICBnb3RvIHJlbF9s
b2NrOw0KPiA+ICsgICAgICAgc2NvcGVkX2d1YXJkKHNwaW5sb2NrX2lycXNhdmUsICZoYmEtPmNs
a19nYXRpbmcubG9jaykNCj4gPiArICAgICAgIHsNCj4gPiArICAgICAgICAgICAgICAgLyoNCj4g
PiArICAgICAgICAgICAgICAgICogSW4gY2FzZSB5b3UgYXJlIGhlcmUgdG8gY2FuY2VsIHRoaXMg
d29yayB0aGUNCj4gPiBnYXRpbmcgc3RhdGUNCj4gPiArICAgICAgICAgICAgICAgICogd291bGQg
YmUgbWFya2VkIGFzIFJFUV9DTEtTX09OLiBJbiB0aGlzIGNhc2Ugc2F2ZQ0KPiA+IHRpbWUgYnkN
Cj4gPiArICAgICAgICAgICAgICAgICogc2tpcHBpbmcgdGhlIGdhdGluZyB3b3JrIGFuZCBleGl0
IGFmdGVyIGNoYW5naW5nDQo+ID4gdGhlIGNsb2NrDQo+ID4gKyAgICAgICAgICAgICAgICAqIHN0
YXRlIHRvIENMS1NfT04uDQo+ID4gKyAgICAgICAgICAgICAgICAqLw0KPiA+ICsgICAgICAgICAg
ICAgICBpZiAoaGJhLT5jbGtfZ2F0aW5nLmlzX3N1c3BlbmRlZCB8fA0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgaGJhLT5jbGtfZ2F0aW5nLnN0YXRlICE9IFJFUV9DTEtTX09GRikgew0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9IENMS1NfT047DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgdHJhY2VfdWZzaGNkX2Nsa19nYXRpbmcoZGV2X25h
bWUoaGJhLT5kZXYpLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGhiYS0NCj4gPiA+Y2xrX2dhdGluZy5zdGF0ZSk7DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICsgICAgICAgICAgICAgICB9DQo+ID4gKyAgICAgICAg
ICAgICAgIGlmICh1ZnNoY2RfaXNfdWZzX2Rldl9idXN5KGhiYSkgfHwNCj4gPiArICAgICAgICAg
ICAgICAgICAgIGhiYS0+dWZzaGNkX3N0YXRlICE9IFVGU0hDRF9TVEFURV9PUEVSQVRJT05BTCkN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gICAgICAgICB9DQo+IA0K
PiBJJ20gd29uZGVyaW5nIGlmIGl0IHdvdWxkIGJlIHNhZmUgdG8gcmVwbGFjZSBob3N0X2xvY2sg
d2l0aCBnYXRpbmcubG9jayBvcg0KPiBzY2FsaW5nLmxvY2suIEZvciBpbnN0YW5jZSwgaW4gYWJv
dmUgY29udGV4dCwgdWZzaGNkX3N0YXRlIG5lZWRzIHRvIGJlIGNoZWNrZWQsDQo+IGJ1dCBpdCdz
IGN1cnJlbnRseSBzZXJpYWxpemVkIGJ5IGhvc3RfbG9jay4NCkhpLCB0aGFuayB5b3UgZm9yIHlv
dXIgZmVlZGJhY2suDQpZZWFoIC0gSSB0aGluayB5b3UgaGF2ZSBhIHZhbGlkIHBvaW50Lg0KSSB3
aWxsIHJlbW92ZSB0aGUgc3RhdGUgY2hlY2sgb3V0IG9mIHRoZSBzY29wZSBvZiB0aGUgY2xrX2dh
dGluZy5sb2NrLA0KYW5kIHJlc3RvcmUgaXQgdW5kZXIgdGhlIGhvc3QgbG9jay4NCg0KVGhhbmtz
LA0KQXZyaQ0KDQoNCj4gDQo+IEtpbmcgcmVnYXJkcywNCj4gQmVhbg0K
