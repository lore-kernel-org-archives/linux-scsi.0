Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F6A2AD20;
	Fri,  1 Nov 2024 06:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730442452; cv=fail; b=MBM28HeHiB0rO7Y3reC6ITC34jeX9BMOznjLNkwY7IrGxk8x7DI9Yzag4xgIh12gckGClFqh5oob3kcuAakp39tUP3cYrAoKfdrK1BEvFoCCxsMOv9a6X3FXNQVPT5ESwTiZl97je8j6dnvL4czRbTMT3KbYDBM2fdRnL4FASMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730442452; c=relaxed/simple;
	bh=N1SY6GjMmZiYCOkcI7huMXUrWYWTf1MwQ7iA4lMtRPU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UZolU+mMha3vZ9oe9knCfqtvcq5NQclI3f7ioXET8egQty6UAs30OU82boysbX0+bpomPHAKVjPIuH12M3SkbF/KXzrCgvmVLN9myQw47aULxECSyXGtsMRV1Z6TVFsiIQMgzbSc76PY9HR+1rkAhhyveIe8a68vl2kkiakZy40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GCRn+BQS; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=LMXMWAYe; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GCRn+BQS";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="LMXMWAYe"
X-UUID: 561f3ee4981a11efb88477ffae1fc7a5-20241101
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=N1SY6GjMmZiYCOkcI7huMXUrWYWTf1MwQ7iA4lMtRPU=;
	b=GCRn+BQS2gCOjqkF2eA35c5AuqXZ7ciZ16ODjeCYwkfUD1m6VZZIeFvAjR5JpiNv3scHmG6e7JtD3FGFsIswyRR3vYLa03DuZ6G+F1Dn1WOHLPGj1v+KQUQHKdKcAD4XpgprZdX2jj7hmbNt4Ps5mjYGmx++pToumaxj4d39gzk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:6592333a-d2c5-4653-8de1-580e15394066,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0fcdc3,CLOUDID:138e62e7-cb6b-4a59-bfa3-98f245b4912e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 561f3ee4981a11efb88477ffae1fc7a5-20241101
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 31057609; Fri, 01 Nov 2024 14:27:15 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 31 Oct 2024 23:27:14 -0700
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 1 Nov 2024 14:27:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVgEI4CaFroJ6tvt6IXB680hRlKNZxK4SYTYdANZS1OUspxHTu3iSkfNmj2jJ4s+FqwgSFmel9txza1WdmkhcAV9lHSR4awe5FJ2bGzLQgC5hiWL6h7oheiQMx9+i5CpuEYxs3g3xy6lf8m6X5BlmI97b/PLLCeGL6SVZtNb3tgG4hDMhC20Wq0K4N0UJwQskV9S9xk5sdoPIv7WTdM/9QbLlBPPXBe2TgjYiJr4oOYMZVfAJaVG5Yi0J+dpFJ6ZMMNfyqEYBazJhuTTTtJDixvbA/koCNouNx489Z8M5vsteFWkTQ4dKJbblJWXgBcdFGVlZHRuk9db8x3t1hVvBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1SY6GjMmZiYCOkcI7huMXUrWYWTf1MwQ7iA4lMtRPU=;
 b=SUK4AWqeDtzgXJZItsYnWkrY6QNmSnt9hKUBSWBRdNxH6wK52/7y7gOU4u77A+5hDBl7P0uYB0qrYaW17u4B8JMouhkk5ZMi+g6otvW4ZxcoLRZENb2sw2wKO/pgIEEnNwUXIwNaTHQWc0l+MYdxkrjIoNVBVQML/6qOmJZnr/MQJNEkoX5E4k+bUUgDUkl6jYWg07BZlge/T4xYDbP14i48aeCoptLZ/bjPHsESS5gKwwe5dYGb0VChbWH5kbggaIdrVOzCx8Az31PYVWYXcoix+EDgnmCMX/NS/v++EWFkvTKPA8ccfrumEVsHLjq8Laxx3YZqLhCcdSZ4/M28yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1SY6GjMmZiYCOkcI7huMXUrWYWTf1MwQ7iA4lMtRPU=;
 b=LMXMWAYe4qu6WYJX7gv4gLBz14CapVLz547njk4rQOnQG8apiqDuy1VqqETMh5NoZute81dQZZ4JHkcDQJybXah86At+4AYyz8ecHdK9W5AhGb+2ChduHC/XPUhk74dlNSZYjYcRvdrSB4HcWHRspAqw3EQn49ex84FaLDNSMOA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7058.apcprd03.prod.outlook.com (2603:1096:400:331::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Fri, 1 Nov
 2024 06:27:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8114.015; Fri, 1 Nov 2024
 06:27:10 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>, "mikebi@micron.com"
	<mikebi@micron.com>, "lporzio@micron.com" <lporzio@micron.com>,
	"linux@weissschuh.net" <linux@weissschuh.net>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>
Subject: Re: [PATCH] scsi: ufs: Start the RTC update work later
Thread-Topic: [PATCH] scsi: ufs: Start the RTC update work later
Thread-Index: AQHbK9uoHcBeIEK5mk2MhgTv3wVoz7Kh9nCA
Date: Fri, 1 Nov 2024 06:27:10 +0000
Message-ID: <a5a9bdaf7ec37002e9203532874d98ff1106906c.camel@mediatek.com>
References: <20241031212632.2799127-1-bvanassche@acm.org>
In-Reply-To: <20241031212632.2799127-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7058:EE_
x-ms-office365-filtering-correlation-id: 2098b85a-7cc7-4de4-2228-08dcfa3e378e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K3RLNG9nUldwOENXWi9OSkVJbG4wN3ZRTzVjUGZyMzdWNm84d0VFUlVOV2ox?=
 =?utf-8?B?bGhJOHM5Vk56M0hFZ003L3ltNTE0WmNFckN2anRndW44d3BGR3BIUmJ6bzVh?=
 =?utf-8?B?S1pVbEpFN0hxN2tXdUt5dlk5a043dmVieXAwajJWT2pPSzdRU0s2b2ZtODhu?=
 =?utf-8?B?UDF4Um11allSZU41MmtoMlhEOGFsWVluaWc5ODN3Y0lVaEtrUE5wblhEMmVU?=
 =?utf-8?B?a2szSTB3UDFvbW1TczZrZ2NuaE1yWGVUWkVEczFwZTRhVDRYY1g5QzV1dWd2?=
 =?utf-8?B?RHlsZ0trOWRyWS9MWXVya0VBWlZhVXVSMHRJK1VoTXMvVkdOTk51WnJTdTMx?=
 =?utf-8?B?SkdWdDVISy9YWmR0U2tFMFQ4a1dPTGZYZHlmb3hXSTZrU2h5S0dTUkloN2FG?=
 =?utf-8?B?TGdWNVpMNERJWEJDRjZpQzBkSHppMWYreHFjRnNrRXgxL09iWkpQU2IvbWRx?=
 =?utf-8?B?alVJTWlhN243TFBLenBpOUNCYk1xQzhtcEY5d1hhbTIvZDRKMEREc2gvV1RH?=
 =?utf-8?B?bkFkUmJQdTlXTml3cVpvbDk1Rkp0bDJLb2FoTHpwQ25zanJyU2I5eFo2RE5X?=
 =?utf-8?B?blR0YlFsY1pHVFlwMDR1WWdaSnpNL3J3WE9oRm9pMElqejZCOUdPK2xmRUZB?=
 =?utf-8?B?U2VQWFBNTm81M2lMajJUdUo3K09IUFV5eHA4aUxEckx2dDFES2NVTVUyZGZO?=
 =?utf-8?B?ditFUXQ5cFRLUk4wclJucjFXLzZnRklHckJjOVlqREtobXVzVnJla2lQNTQ2?=
 =?utf-8?B?b3lub0RCOXFLbWRISVVNZ1VRdXFqRk10cU9YOUI0RlBrNXJTU1JnMGlxSEdI?=
 =?utf-8?B?VFpVQVZCalBuN016aW9PcWpNV28wTEc0L3JlaGFHNVFBUVdhUnZVOTlkQWhB?=
 =?utf-8?B?QVg4a3NWZTNlWGQzT083WC9abTBRZGg2eWEwR2dET0ZuOVhwSC9GVG9NbmRV?=
 =?utf-8?B?NWJnczZ3cFpJcE0vdXNsZHRYZHhBMFFNekFuV2JEZEtQenYrRStGQ25RWldx?=
 =?utf-8?B?RC9JVFczU0oxcytSVWx1QWwzSzd3UVlidDNkaGowVHVObUdnVGRpR29WWVhq?=
 =?utf-8?B?cGQ4eGdXbWVCd1dxNFlEdkVRL0xMS2xwS3lmaW9HczBjY2toTmZPOXUrWklY?=
 =?utf-8?B?c3d4SGdLSzdJTGRMcnhPQjBUYnJXMFVBMXNCWStVbkxqbEx0RlRmTnEyR044?=
 =?utf-8?B?NmFtSkVWMDhnbEVVRXlwemVzamsreVBoUkhxZkJKa3MrcEFIVzMzZmMzUzc5?=
 =?utf-8?B?Q0VjampCcGVORTExTnpjZDJlRnJiZTdLeGNYT2wzRmlwWDZOYjNVd1VuNVRi?=
 =?utf-8?B?dXErM0k1VFBtTWkwYUt4eDJOaE1hUFVmMlRXT2JhbDJ2bEU4cVVWSUsyTUhS?=
 =?utf-8?B?c09JU2h4UEliU1BKNUlzQjlRcUlZNHpUR2ZxMjJXRUdwendVR2piWnlWbndO?=
 =?utf-8?B?Q0xvY0tXci9ibGlMN0MrMHg0TXRmWlB3eGRWdlpqR1RENjllYXhRTmdnMzVk?=
 =?utf-8?B?SE4zUlEzcGoxTzlpTkVaamhiWTA1NXlycXZESERnZFhSdFh1VGhWTjRmNWZ4?=
 =?utf-8?B?b3BFak5DT0pNV1EwRlBTSVBYRzlTOU0xNDREYjZyRzZlQ0F6SWRrMVBBdHZv?=
 =?utf-8?B?WEcwbXNVMGUraDNKYUxKVTVZZkhPYXZ4QlNTaFRUY1pvNjJzYWhWSTVxbTBu?=
 =?utf-8?B?RFJGN1FRanVRcXViSk42RUl0NkRwbjNsMG1hY3BuZ1VHUW05VWR5aFlCYzR1?=
 =?utf-8?B?TThQY1VxY1hpbUhDbU5vWjdkcTI4MmZwbkV2aTE4RUNVTTZiRW9NQWFOb1lu?=
 =?utf-8?Q?ZS+uvET/bSgb3p15+gmve9cXSyEHGuUyBk/6U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWRDS2NIcnY3OHJ1bHZUTHltcTJncWNoeDNadERYbnF1N2xUakJnbDIrNUVq?=
 =?utf-8?B?SFlEdUpEeHJGZXRYWGxUcDlPbEZqeEU1Z0huNUNnU1R0YTNaOEJYakZScjg2?=
 =?utf-8?B?dWtEY1V5K3cwaTV6YllOQ3BJMlQ1elRlMHIyUU95L2dPZ3IvTHAxQzdTSnc4?=
 =?utf-8?B?dUJOSDJNQXExRDZnL3hlZDVnOURNWG56c21NMFpxYkpRdVA0TVFsVDVLMTBP?=
 =?utf-8?B?WTROWExnSGwzZXBEbGtVQWZCZmUyRUlrMFJkVlhFaHRZbk9EVUxDK3gzeUo2?=
 =?utf-8?B?OFRMY1p0a1M5U0ExUVpOMVlqc0F2MEJ0MU1oYTRGTm9JQlhoVWwxRDFQaG1P?=
 =?utf-8?B?bkZHQURsTmFzcWovZ0t6T0gwOWk4TWtuUThmV1lkeDBKTjJ0d1JEQUpXZjg0?=
 =?utf-8?B?ZXlJWksxSHdBdVBlb2RzTWRWVlgxQ3dzTWd4MVI4RDVPK1FMWmZkcU9WWlZr?=
 =?utf-8?B?SmlKTW0ybGxlS0JPVkV1SVJhZEMxVDBNMzBsbTMrZFNwTDVHV29ZUWk0T2d2?=
 =?utf-8?B?cC9KNldweHo2Sk1GSFcveW5GOU16Ri9hUjdUaDdZeUw4Z0w5MzU3M21COUtG?=
 =?utf-8?B?ZFQyZVd2MWpYUTdIZFpRSmIycXBLZk1EdWJzOGQwWmI4bHBlc1Q0Vm9IaTZ5?=
 =?utf-8?B?N1dIdFpRZkdEVXZ3WDhOeWRVSUhCZEljZTNUOE5PRjhHTVIvVHdIZ00wSE5r?=
 =?utf-8?B?WE5lMXovY1haaGU5dVdWNFhGRUhUMi9mNUEyclNXR1JKT2FnVmhmWnJWT0VP?=
 =?utf-8?B?cXU4d3hJRkdzYjhmaVl5RUlUOTVoNDg1N05nODdKNXI1WGJGNFE5VStoOUVW?=
 =?utf-8?B?bHNRQzdHUlFoMVg4Sis0MVQ5dlpLQjJ6RHdjNjEzUHhTdThZTlZqMTVDV0E0?=
 =?utf-8?B?blFKVTJvQWxjTW9vTVQrR0h4VGNYeWkxZTBpcWp1L1lnREgyNXVGRFJwcDVZ?=
 =?utf-8?B?Y2lmeXF4SkIwdWpIUVExamMxRzVrdjRvcFpCR2svL05hanVjazNKOUNGMWQr?=
 =?utf-8?B?VnU2T3NxZFJVb1R3N1B4VHBoWnZrbWxKK1l4blo2UW5naUE1b0FZcERDTzlG?=
 =?utf-8?B?cVArTm9ITFBuMi8rMGZaZ3ZxRG5DMUpORElNcGJSd2xZbHlHUVNnNkxQU1dk?=
 =?utf-8?B?VG5mYW02VlI5TWRRKzhUMittWjlFamduUUlJRk1JbTdXajBoMWpDMXBtck9Y?=
 =?utf-8?B?cWNQR0psanlNOHFlT3Q5b1RDbjdLWGZ3LzZrL1ZFT2krcjVhSHpBVlVPenBE?=
 =?utf-8?B?UkxiOWY0RXVJMWw3WHorMWFhVnVTd0VwS3oybTh1OE5xeitEMWhnMGF1aVZD?=
 =?utf-8?B?K211c2U5Z2p4bFg3MWE5LzByRm5OU1R6SnVrNlovaW1OYUwzNmVLMmgxYUhD?=
 =?utf-8?B?UmRnMExvVGNNdE9tWWlGemRhOUpGdUZLVS9OcDhnQ0pWaTNMK1BiWmtaSnJu?=
 =?utf-8?B?eCtFK01FdnI0bysvV0cvN3cxSDZFdWg4ditkRjg1VFdQNUFZMDBNNE1uOE15?=
 =?utf-8?B?Z3AvdnBZcVFiZGYyMWVXeEg2TmV0WWlacERIUlpyb0RMczNpK2puRVcxZWlS?=
 =?utf-8?B?bUpqb1BId0prdlp2cVpVSW9VM3h5cm9peG0vZkdpT2ZlR0ZaUEEyT0tJUkV5?=
 =?utf-8?B?OHh0SEpSbThYWHI3SDd3RWQxT1ZVZzFRK2pxcXg4bUgwWk44K1lQa1VIVzVn?=
 =?utf-8?B?R2UrV2JDZVdSRnNFbXROa1hONTVZTjVtc0lsSEZMdnhDZm5kMlJSYTBuV0hl?=
 =?utf-8?B?b3BEMWVVaDlEam5IU3Y5ZU05UlpNekxsTy8zK2tFOWYyZEVjanZRN1NoOWpP?=
 =?utf-8?B?bm5lRWxyMmR3VHo5WnhnR21KTDlsWkkvVUFpUUIzaWh0d2tjOWRNbnRhdGd6?=
 =?utf-8?B?VThiS1p6cUl1RDIrbVVkd1ViRHJyQ2Y4RVVsQnp5a0pkQXJ1eFhQa2Q3VVlm?=
 =?utf-8?B?MGx5UWNUcW9TWXJlbm9GajBnbFF6RnVzL21xT1ltL3UwbGdndmpTWCt5d2JB?=
 =?utf-8?B?YzF2QjUwajN3YlNvdnRxR0d5L0NtVkp4WmFDQ09iWldFWE4xMVZKQ1V4MVBL?=
 =?utf-8?B?a2RYWWhadDZucGNxVHkzWFNHWDVNY0dGbFk3RUwxSWRZMVg5UjhkelpkMkI2?=
 =?utf-8?B?TXc1VXN6aTRLMXJUVTh0Zkg1Z3lWL1I1T0dNbXRUU0RHdzJiZFRzdzZXS250?=
 =?utf-8?B?Q1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3180D631FF7B94684BE5A41854077DF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2098b85a-7cc7-4de4-2228-08dcfa3e378e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2024 06:27:10.6453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dElYIcbP0Fkzzt5RMnSL/Onkkn9ysV8b8q1BTzYhTp+aEa3pcln58tGfsZ3iWFuVXVswL+85TMqARUHrZalUMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7058
X-MTK: N

T24gVGh1LCAyMDI0LTEwLTMxIGF0IDE0OjI2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhlIGNv
bnRlbnQuDQo+IA0KPiANCj4gVGhlIFJUQyB1cGRhdGUgd29yayBpbnZvbHZlcyBydW50aW1lIHJl
c3VtaW5nIHRoZSBVRlMgY29udHJvbGxlci4NCj4gSGVuY2UsDQo+IG9ubHkgc3RhcnQgdGhlIFJU
QyB1cGRhdGUgd29yayBhZnRlciBydW50aW1lIHBvd2VyIG1hbmFnZW1lbnQgaW4gdGhlDQo+IFVG
Uw0KPiBkcml2ZXIgaGFzIGJlZW4gZnVsbHkgaW5pdGlhbGl6ZWQuIFRoaXMgcGF0Y2ggZml4ZXMg
dGhlIGZvbGxvd2luZw0KPiBrZXJuZWwNCj4gY3Jhc2g6DQo+IA0KPiBJbnRlcm5hbCBlcnJvcjog
T29wczogMDAwMDAwMDA5NjAwMDAwNiBbIzFdIFBSRUVNUFQgU01QDQo+IFdvcmtxdWV1ZTogZXZl
bnRzIHVmc2hjZF9ydGNfd29yaw0KPiBDYWxsIHRyYWNlOg0KPiAgX3Jhd19zcGluX2xvY2tfaXJx
c2F2ZSsweDM0LzB4OGMgKFApDQo+ICBwbV9ydW50aW1lX2dldF9pZl9hY3RpdmUrMHgyNC8weDlj
IChMKQ0KPiAgcG1fcnVudGltZV9nZXRfaWZfYWN0aXZlKzB4MjQvMHg5Yw0KPiAgdWZzaGNkX3J0
Y193b3JrKzB4MTM4LzB4MWI0DQo+ICBwcm9jZXNzX29uZV93b3JrKzB4MTQ4LzB4Mjg4DQo+ICB3
b3JrZXJfdGhyZWFkKzB4MmNjLzB4M2Q0DQo+ICBrdGhyZWFkKzB4MTEwLzB4MTE0DQo+ICByZXRf
ZnJvbV9mb3JrKzB4MTAvMHgyMA0KPiANCj4gUmVwb3J0ZWQtYnk6IE5laWwgQXJtc3Ryb25nIDxu
ZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPg0KPiBDbG9zZXM6IA0KPiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9saW51eC1zY3NpLzBjMGJjNTI4LWZkYzItNDEwNi1iYzk5LWYyM2FlMzc3ZjZmNUBs
aW5hcm8ub3JnLw0KPiBGaXhlczogNmJmOTk5ZTBlYjQxICgic2NzaTogdWZzOiBjb3JlOiBBZGQg
VUZTIFJUQyBzdXBwb3J0IikNCj4gQ2M6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+
IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFz
c2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4gDQoNClJldmlld2VkLWJ5OiBQZXRl
ciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
