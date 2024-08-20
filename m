Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C10BA4D;
	Tue, 20 Aug 2024 05:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724133432; cv=fail; b=QhRTKQPVfgt/wpGufpmkJtXbPHURoJHhKjPdheqvVzSP3ubs7wCvlVSl33W0f862U0vXy49LqHd7QQQRu+tePj2rSYzTVJPed7YKdoahDblKsPgs3Cz79aWWfzZKZdAA/sdfiCjZVKDTIASVERFHy/nbG/ZvdqB7ENBzF/ZEQrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724133432; c=relaxed/simple;
	bh=ZG9avqGDGgq7ez0yCiT4nCUkr+dFxk1jh7budooNLAM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lBasEQMUaTrKDJ7xXFThm1xqtXw1RC1GuLdmdrOe/QcUH4eQidnWJGew7ykWsUUahPu9+TtE5se0nCuFEvOnIg8qxAtEeoxFQZpKzZ6V6dQ6DyLgkIJahO6hruWga54xHzbbJQBk+3ysso8hytG9M40uVfqvdviwaRRWSWJR9o0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=CVkiMhyN; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=uEjygnfT; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CVkiMhyN";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="uEjygnfT"
X-UUID: 0277006e5eb911ef8b96093e013ec31c-20240820
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ZG9avqGDGgq7ez0yCiT4nCUkr+dFxk1jh7budooNLAM=;
	b=CVkiMhyNmAIp7V/j/xzs4X/+HCxAlGLL3GCqmwOjoguFYjD39g1UuVUHPebdGVIdszEZ3XpfjN1RQqa9POjwqIx8n0Gq8bmhJIrfaXQd7EXfclZAnZtIKY0F6aSX6z176E0VOQTNZHlY5UCiM7lcqfgWU2MxdpTjadC2koc0+kg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:5bfcefd1-c072-41ac-a417-f663747afa77,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:7275dfce-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 0277006e5eb911ef8b96093e013ec31c-20240820
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 983260754; Tue, 20 Aug 2024 13:56:57 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Aug 2024 13:56:57 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 20 Aug 2024 13:56:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ryyl/FTdplEibD0P7JehvRJU5KmRJQzYB3Srxbhwh7ESewQoT/x0XvyppcFPd2T+bSqX95VHEUjnWm8ehX2OdVnJoQpq0v9OTHNjyJzakhBjjniH9/MeiqTLTgRL6gHA9FkuNGxAOtbJItLQ0AbN/B/uS9XS87gpPEzsctpIiBqmjQTACH2yfIHq8i8pgk7Kkl++MjcB2RJEFbFPfM3/VWArFlPPJbOmtAG4Gv18vWlgt9CAOQ+AeKOoRI675GgqTLlUg/U4VH+v3XCiMwo9oR71vsoi7txxLYYU1I8HfT6te3CxlTj65og+vwLIEBT1piKHoQUBbmAnetmQ9C7i8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZG9avqGDGgq7ez0yCiT4nCUkr+dFxk1jh7budooNLAM=;
 b=irmIaB6fxtQ2CDYWe7BdNGjaRF1DQSDrq9PSZMDTmaUJ0+I7Pj9SMP8A5cpFcRxvHDm4Kv6XqGO9UPKEvpjzGwHYZYjFnGM/+DUn7oW+DHvtMEUxyxtrY2+5ZXN7ESK7RDOt6StjYxkYJf8XB/DYJx/nMI6EyimTTaBbapQ5JbmoNoew1pzQ/6z0gpsjJWbum1RwSKE0Sizhipvsq4/X6ZlTqQVTRdIctWqnGcttaTkR4YHqm/BoUTeCPpuoQlYeys7AZhZHN9bNctTfhuccFY93jJZQUldpgkbgZl8ZOlSdBiGHGcR9lN5fg2+87TuBOfEw1wPeMvrTK5xgJdRTjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZG9avqGDGgq7ez0yCiT4nCUkr+dFxk1jh7budooNLAM=;
 b=uEjygnfTGFYX2d5/Aut0yCnBprTwJJlk+zK9qZghHyeR5Ne8LtnxGL/tnyGo+S7qW3iLGTLq2fmb6p2+0Tg1f87nnegVPBZTfLHoExLI1YfNssWTsRLy96NedUwhQPvBkZjMj/pVeiqZNyv2+RMF8Hy5VzpjD4zMk3wz0+GvKXU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OS8PR03MB8825.apcprd03.prod.outlook.com (2603:1096:604:289::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 05:56:54 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 05:56:54 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "mary@mary.zone" <mary@mary.zone>, "manisadhasivam.linux@gmail.com"
	<manisadhasivam.linux@gmail.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "angelogioacchino.delregno@collabora.com"
	<angelogioacchino.delregno@collabora.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Thread-Topic: [PATCH 1/1] scsi: ufs-mediatek: Add
 UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Thread-Index: AQHa8b2XhFsZSWSo6UWUT/pmOicOc7IufaEAgABm5wCAAMN/gA==
Date: Tue, 20 Aug 2024 05:56:54 +0000
Message-ID: <59503540293f6d640809e24b43ea5102b3119853.camel@mediatek.com>
References: <20240818222442.44990-2-mary@mary.zone>
	 <20240818222442.44990-3-mary@mary.zone>
	 <20240819120852.tdxlebj7pjcxjbou@thinkpad>
	 <ZsOJKMg8xlpdgoi5@kuroko.kudu-justice.ts.net>
In-Reply-To: <ZsOJKMg8xlpdgoi5@kuroko.kudu-justice.ts.net>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OS8PR03MB8825:EE_
x-ms-office365-filtering-correlation-id: 8f36b225-ad6d-4b75-d79c-08dcc0dce4a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MW1KM3lVRlpESTYvYWlZZUZrZU9GNmtEdGhEMktsN0l2eSs4MjA0RzlGWGQ2?=
 =?utf-8?B?d01tSUo3RkJrdXEwVXZvZzVwNVowR0Qwd3E4T2VQMVpaR2NSWXUzc2l0aHV2?=
 =?utf-8?B?NFl4bXRFcUxvMFJNQVc3NlExbE9SbXpaMXU4amdFQzZxbEZzNVNXYlRXTEdF?=
 =?utf-8?B?NjRhclEzbU5FZjFYOHlxcmpNNE1XSnBZQ0tyci8rT01hMXV6T0crNk50a3Nl?=
 =?utf-8?B?YU93R2VEYk1wUUl5NUFvU0hLZGpXaUJhQ1c1dFFad1B1bEZXb3BCQm1sLzdV?=
 =?utf-8?B?allnYS9ZOVBLaVFoV05SVDNNN2F3TzR4cTJma3pidDg4Zi9odzYrU2hvT0VP?=
 =?utf-8?B?VWw1U0c0UHJsaGs2TzJzRGx4cFRvRGlqU3FWcFhOYmRkOVVrOWs3Q0ZqQUxw?=
 =?utf-8?B?bXFyNXkzbVFIQUltZEljalowV2FxUGZsYVAwOXpJdlFvQ2p6MUl6R1FRQzN4?=
 =?utf-8?B?R3JqSFMwUWs5Zmd6eGEzRXB5MWF3T2g3R1YwWUExZU5Ta1QvU09EZjZiU1g0?=
 =?utf-8?B?N01LMGNOUEw1eHAxeXF4RWNmWWxESDk3eXc2azdwSFlSVWVBLzFOY1VZVHpq?=
 =?utf-8?B?bXdrSVgzN252UklIelB0QnRyeWMzSFoxZldQdGtOby9wOEdBQ0lSeHlqMVZ4?=
 =?utf-8?B?RGVJK28waDVsVWpUZGZoVGxUMkYrdUd5RXp6OW1Ga0xSbXdlWXRKYy9uN01M?=
 =?utf-8?B?Q0dDVEFZQTYzVExSMnZhczNiN05lOUN2ajBxWjViK2NNcURBaG1MRVd0YUhH?=
 =?utf-8?B?U1d4WHZFR1VMeEFYUzZORWRQU0xLY0hzdzl1TUl2YU5IMThaWGpadzJ5VVR5?=
 =?utf-8?B?c2hVRjNpWSt0WWlPMTZ3aVk2dzRBQ0FMNlVuNTJHSXg3NTB0U2gycnlQOG01?=
 =?utf-8?B?V3hxK2s2dHRoRWlBU3Y1d2hiY1hLVHNRRmc4aGgvSTEwSnZiWExJUlgyWFpC?=
 =?utf-8?B?VTJRZjUzaVEvcXk3K2hRYzJ5ZHRjWjlyMER0RXN2Y1IvUlVKOEhyV1NSOXBC?=
 =?utf-8?B?RVBLektCYmwrTkFQNkZraENSK1F6KzdJbThQeTBIR3F1azRLUDNSTjYzMnJa?=
 =?utf-8?B?Z0NNck1Ha00wd2tzOXpWc0hZVW04MExrWllrbXpUQ00vYzhuSy80Vm1Jc00v?=
 =?utf-8?B?MXU5aG02aEhoN1B2ODMzdlVRenY2eGt0UmtkVWNVSWpxRzVXaFVoU0c1UjY2?=
 =?utf-8?B?VXpGbENqYkttdVNnWDNqem1wRVMvemhGd2pnSnBlcmo2Skg2UldQVVlBc0xX?=
 =?utf-8?B?eWU4cjVZMVEyQVc2L0xrV3hqQW9yZ2xpOUlJWnpmQ1p1ekt2dkNDY29BOUZq?=
 =?utf-8?B?QUZoelBSM3VoMzRiUWE5MWRzSTdWYTJrNlc0SkVza2haK1k4SkI0MGhQVEZB?=
 =?utf-8?B?a203aUxwRlJBbks1T0N6WllCa0hkbXNzelJyVDhhNFdDcnFJOUt3QnR3Z3JZ?=
 =?utf-8?B?alZFSGkvNGxkVWVZd0l0STFwalk3ZmNBbFcvM2g1RGNNaTF2c1czZU9LQjJ6?=
 =?utf-8?B?eDRUYXZrUm41TGhucy8xajUxWms4YTNmaGJlZ1NJV1ZhelA1OFZ6VmtWMWZK?=
 =?utf-8?B?ZmswZDZNdGdPMGVjQzkvaEkwcWZQeE1hN0FFNkxRcFVRSDkySUdpcUVaNWVj?=
 =?utf-8?B?aGlHSEhMcEN1cS8zWStGWDNYdG9RTUJ4Y1RRdkd3T04zK1g4c0xRRWJzRFdI?=
 =?utf-8?B?YkovTHo2cHV4VTMybXJyQ2hvYWZSWXlsKzVWNzBtbUFFSlo5MzA5N2dzOVlZ?=
 =?utf-8?B?anJ4S0hkckxCamRidHUwYVdlYnltYkcreUdDTjlhbmVtclFZMW11THRGaWNm?=
 =?utf-8?B?MTZPZ2JTUXpuWG1HeFhtckhaVEFXUWl5SlBkNk5KbEFDL1Y1YjdJb2NKRUZI?=
 =?utf-8?B?NHJMT2hnem1Wa3RXaWNET2lMbnZPcWljQ2pRZFYrK01XZ2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFhYdzVINVJMRitHZFB3SW0zcWxtZTBkS1Z2MUV4TXlveXNKNDNvL1JpcVpk?=
 =?utf-8?B?M1kweGdES2N6YlRSRC81QXZFQkhpNDducmtNYStzdFlIc2E3am9Cbm5RMGpj?=
 =?utf-8?B?djB5bXZNTWJoSjEwTmtHUmh4V3VEZERreW9YbEZFVHJwU0FZc0MyVDBqeEFY?=
 =?utf-8?B?aDJONzRNZm1rcFJYRDQ2Ym5qTmRNVnRSM2xaZlZwTGhPeE96S3RjMlBkaTRF?=
 =?utf-8?B?NStWMlJQVjRJVXRIRTlXVE9td3h6bE9yZXdGbVgxWFFzNERVejZhUEcrTVRr?=
 =?utf-8?B?aHRreGVqS1E1YmNCa0R3R3l2S2piblQycGRSQ1N6WjJwNlg3eldGVitlQmRv?=
 =?utf-8?B?U2RhbkJNajFkbVg3K2dnaFVrRHE2NUtwVnhzSDF1Z2Q5K3Z0aDV6cDJWZ3hK?=
 =?utf-8?B?Z25ad2VqSHhzRjJmN0ZGa2VmeHVpci9QUXB1cW80Ulp3NHRwNzh4YnRsNHJ1?=
 =?utf-8?B?T1NQdHRNRGZxU0R4Y0hKTkt3c1h1disvaXRoZXRHQkVXR0ZDUncwbUFhbVlS?=
 =?utf-8?B?V3VzM1pYZXZQRUJRTnppQ3BjdmMwdmxWS0FTakJzbTJDd2hIMkpPZWVuQW9H?=
 =?utf-8?B?U2FBd1Iwc1oxRUViM1FZRzNIV25pSkJuaEp6ZklzeTVLK1kzQ2lpS1QzVzha?=
 =?utf-8?B?bFp0b09kbTV5V05iQUNNT0NVRll5Qm0wc1FwSUpPWW9IVHpuaFlvallRVDZw?=
 =?utf-8?B?dkwzVlJJemdtZk9VWTIzWncyOFFOT1NJY1phMWJVMGZxdERCdW5iLzZyNzdt?=
 =?utf-8?B?dzBpUDZLRHAzeWJ6cmxpZm4vb2t6TlB1VHFoZDZ4SUdiL1ovR0RFcUVyd1gz?=
 =?utf-8?B?dCtKbEVyeTM2VVdKWVFtV1RSNStwUE40SHduTzhMNnlpZC9tdTV4WTVLUXp5?=
 =?utf-8?B?Y0crRW1uSmdKK0c0YVdabGZsRWMrbXVHZU1NTGpObm4zMDJBdCtCd29XSXFl?=
 =?utf-8?B?cDRHalQxNjlNNWdKMXFuSWJzMUxwL0NpUldLKzdKV2xhT3dGZy85UVBDdnBN?=
 =?utf-8?B?Qlo3bTF2ajZJbFpVZEliLzdOQ2paYmxqOVNUSW5lMmkxVEF2RG5mUVlNcnpt?=
 =?utf-8?B?ZHBPZWJXSTNZR1E5KzRhUTRZckZRWVNjdFFYNkhlcEVTNm1OOUxpVXdDZzA1?=
 =?utf-8?B?a3ZPeThSOTJzZ1F4eUVEczlNNGp2QnF3dE9yeW5FWi9wTXlRdGZQeUU0aFhK?=
 =?utf-8?B?azVBNkZsUTkvaGV6dDUzSGQvUFNLMVIxM1BXWDJhOWFLbFpWWGs3ZGx3Uk02?=
 =?utf-8?B?czJBdWlqSGZHRzhudVRLajBYMGtyOWJlZzFRNm5aZVgySHV3bjVnUFVvek50?=
 =?utf-8?B?S3JFaDVBTkZqVW1oYnNpK3U4R2p3Z1BLL3kwaGFNWUpHUUJwSStLSm1ueGxV?=
 =?utf-8?B?cE0zckl4WG54Z1RweFVvSGRDZTc2NmZLZk5KR1QwNFY0U0xobGJRYXloVHNi?=
 =?utf-8?B?bHBMd0dCTXJJNTZ6RU9iOERQWHQxVjYvakcwc1pCMzFqWFc3VWVtSXdZWG9q?=
 =?utf-8?B?WWdxQm84ZjhNb1lMK0FxeUh2MmIyaGUrQ2h6ZEN3NkdNYVVWUThFZm1KenJB?=
 =?utf-8?B?STAyd1FaaFp3SHFxcHFWcG1NcGVFT3VoMmlSRFB6WUhwaU9IdzF0cWFDVms0?=
 =?utf-8?B?d1JXcFFCbUd2VjZqSDhseEgrV2FiZXF0REJDSld5UFRIa0ZzempyWEwyWll6?=
 =?utf-8?B?K0grblh5d09CdkxoN1o2cTRKVTVOeXRlWHhaWjV2WlZOcVFrUkhLcmNYZEp4?=
 =?utf-8?B?NjY2U2lGNWNJMWFsZWJUN3BqaFFGRUxFK1B3UUhOYnVReEF5UDhnYk5Yd2NQ?=
 =?utf-8?B?bWxObVZoTmtWUUJGdnE2ZlJ3ZTBUMzVlUnpXVjEyY290RXNXWURDMi9RSCs0?=
 =?utf-8?B?TGFMYmF4VWJFUGJMdnJnSHVNYWVSM29idnc1M0V3amp2N0xHTlVCbnBoeWxY?=
 =?utf-8?B?WFY1TUFNUFY0QW5VdTlTYjRsYVd4Y1ROR1F0TG90RjZjTTNQbXlIbjQ2T01V?=
 =?utf-8?B?allqVnV1NmhCaXpXV2x3WFFrbHpGZUlTK2ZqZUJyYlA5Ry93RGRJdXRsRExM?=
 =?utf-8?B?dmdNYXlHNHQwSHdBTi9rZ2NFL1k2MWdic2tpOGphWG5MNEdnZ2x5eWE4dUNI?=
 =?utf-8?B?anZFTlU3dDFHQ1V0NEpEMjFDRmhMRWpHM041U2V5QXd4MlRGSDFmcm14SHND?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0156A030A718C34CB2307BC40BEC4CE5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f36b225-ad6d-4b75-d79c-08dcc0dce4a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2024 05:56:54.0970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ccL31yzyDCqAR6kBSRCF4S2gv+GWHQ1Q8AqXBrs2+nFaVe1YcvQpUM+3w+BPgztGe2qxFsmtBODwKs7iOLPacg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS8PR03MB8825
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--33.653800-8.000000
X-TMASE-MatchedRID: yxAmdCLMIs3UL3YCMmnG4t7SWiiWSV/1jLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2mlaAItiONP1VftPGBTR0rkPwIAaSXEicckR
	bqTJ8x/FYBJuFcGGWnmDP83Vem3nwR7anGgF8KHOmQhbcat5/fSGi0ftsSkQy+QYBHm2fyHc8r4
	ljnzWjIJR0/TJZAy/xgMfjt8skNrRufzckypRuvVMpUiAxJvjH7f6JAS2hKPhfXk0kfCOnbqqc7
	CYVY4LI9J4YisFxtmhW0dXWLEHfMC0kxsNYPyneSHCU59h5KrGAZr6hinmLqkJqedX9vt/ZrRGi
	aFY8lpATFpfVJhj8uKw+3mC9M1RIrRlLslggfyq4jAucHcCqnQXAhAGZB7BnZOV3cNsnUIaTATZ
	hRxAwROLzNWBegCW2PZex/kxUIHW3sNbcHjySQd0H8LFZNFG7JQhrLH5KSJ0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--33.653800-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	9A87C26079163DE175D6B59BF5A81ABC455BB95D6E14765BC551B49B4963BEAE2000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA4LTE5IGF0IDIwOjE3ICswMjAwLCBNYXJ5IEd1aWxsZW1hcmQgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gTW9uLCBBdWcgMTksIDIwMjQgYXQgMDU6Mzg6NTJQTSArMDUz
MCwgTWFuaXZhbm5hbiBTYWRoYXNpdmFtDQo+IHdyb3RlOg0KPiA+IE9uIE1vbiwgQXVnIDE5LCAy
MDI0IGF0IDEyOjI0OjQyQU0gKzAyMDAsIE1hcnkgR3VpbGxlbWFyZCB3cm90ZToNCj4gPiA+IE1U
ODE4MyBzdXBwb3J0cyBVRlNIQ0kgMi4xIHNwZWMsIGJ1dCByZXBvcnQgYSBib2d1cyB2YWx1ZSBv
ZiAxIGluDQo+IHRoZQ0KPiA+ID4gcmVzZXJ2ZWQgcGFydCBmb3IgdGhlIExlZ2FjeSBTaW5nbGUg
RG9vcmJlbGwgU3VwcG9ydCAoTFNEQlMpDQo+IGNhcGFiaWxpdHkuDQo+ID4gPiANCj4gPiANCj4g
PiBXb3cuLi4gSSBuZXZlciB0aG91Z2h0IHRoYXQgdGhpcyBxdWlyayB3aWxsIGJlIHVzZWQgb3V0
c2lkZSBvZiBRY29tDQo+IFNvQ3MuLi4NCj4gPg0KPiANCj4gWWVhaCBJIGZvdW5kIHRoYXQgYnkg
dHJpYWwgYW5kIGVycm9yIHNvbWUgd2Vla3MgYWdvIGFuZCBub3RpY2VkIHlvdXINCj4gc2VyaWUg
d2hpbGUgbG9va2luZyB0byB1cHN0cmVhbSB0aGlzIGNoYW5nZSwgcXVpdGUgZnVubnkgdG8gc2Vl
IG90aGVyDQo+IHZlbmRvcnMgaGF2aW5nIHRoZSBzYW1lIHF1aXJrIGhlcmUuDQo+ICANCj4gPiA+
IFRoaXMgc2V0IFVGU0hDRF9RVUlSS19CUk9LRU5fTFNEQlNfQ0FQIHdoZW4gTUNRIHN1cHBvcnQg
aXMNCj4gZXhwbGljaXRseQ0KPiA+ID4gZGlzYWJsZWQsIGFsbG93aW5nIHRoZSBkZXZpY2UgdG8g
YmUgcHJvcGVybHkgcmVnaXN0ZXJlZC4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTWFy
eSBHdWlsbGVtYXJkIDxtYXJ5QG1hcnkuem9uZT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMv
dWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgfCAzICsrKw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAz
IGluc2VydGlvbnMoKykNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hv
c3QvdWZzLW1lZGlhdGVrLmMNCj4gYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+
ID4gPiBpbmRleCAwMmM5MDY0Mjg0ZTEuLjlhNTkxOTQzNGM0ZSAxMDA2NDQNCj4gPiA+IC0tLSBh
L2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvdWZz
L2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gPiA+IEBAIC0xMDI2LDYgKzEwMjYsOSBAQCBzdGF0aWMg
aW50IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiA+ID4gIGlmIChob3N0
LT5jYXBzICYgVUZTX01US19DQVBfRElTQUJMRV9BSDgpDQo+ID4gPiAgaGJhLT5jYXBzIHw9IFVG
U0hDRF9DQVBfSElCRVJOOF9XSVRIX0NMS19HQVRJTkc7DQo+ID4gPiAgDQo+ID4gPiAraWYgKGhv
c3QtPmNhcHMgJiBVRlNfTVRLX0NBUF9ESVNBQkxFX01DUSkNCj4gPiANCj4gPiBIb3cgY2FuIHRo
aXMgYmUgdGhlIGRlY2lkaW5nIGZhY3Rvcj8gWW91IHNhaWQgYWJvdmUgdGhhdCB0aGUgaXNzdWUN
Cj4gaXMgd2l0aA0KPiA+IE1UODE4MyBTb0MuIFNvIHdoeSBub3QganVzdCB1c2UgdGhlIHF1aXJr
IG9ubHkgZm9yIHRoYXQgcGxhdGZvcm0/DQo+ID4gDQo+ID4gLSBNYW5pDQo+ID4NCj4gDQo+IFNv
IG15IGN1cnJlbnQgYXNzdW1wdGlvbiBpcyB0aGF0IGl0IGFsc28gYWZmZWN0IG90aGVyIE1lZGlh
dGVrIFNvQ3MNCj4gdGhhdCBhcmUgYWxzbyBiYXNlZCBvbiBVRlMgMi4xIHNwZWMgYnV0IEkgY2Fu
bm90IGNoZWNrIHRoaXMuDQo+IA0KPiBJbnN0ZWFkLCB3ZSBrbm93IHRoYXQgaWYgTUNRIGlzbid0
IHN1cHBvcnRlZCwgd2UgbXVzdCBmYWxsYmFjayB0bw0KPiBMU0RCDQo+IGFzIHRoZXJlIGlzIG5v
IG90aGVyIHdheXMgdG8gZHJpdmUgdGhlIGRldmljZS4NCj4gDQo+IFVGU19NVEtfQ0FQX0RJU0FC
TEVfTUNRIChtZWRpYXRlayx1ZnMtZGlzYWJsZS1tY3EpIGJlaW5nIHVudXNlZA0KPiB1cHN0cmVh
bSwNCj4gSSB0aGluayB0aGF0J3MgYW4gYWNjZXB0YWJsZSBmaXguDQo+IA0KPiBBbm90aGVyIHdh
eSB0byBoYW5kbGUgdGhpcyB3b3VsZCBiZSB0byBhZGQgYSBuZXcgZHQgcHJvcGVydHkgYW5kIGFk
ZA0KPiBpdA0KPiB0byB1ZnNfbXRrX2hvc3RfY2FwcyBidXQgSSBmZWVsIHRoYXQgbXkgYXBwcm9h
Y2ggc2hvdWxkIGJlIGVub3VnaC4gDQo+IA0KDQpIaSBNYXJ5LA0KDQpZZXMsIHRoZSBNVDgzOTUg
aW5kZWVkIHJlcXVpcmVzIHRoZSBMU0RCUyBmbGFnLCANCmJ1dCBub3QgZXZlcnkgTWVkaWFUZWsg
bGVnYWN5IGNoaXAgZG9lcy4NClNvIHNldHRpbmcgdGhlIExTREJTIGZsYWcgaGVyZSBpcyBhcHBy
b3ByaWF0ZS4NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo+ID4gPiAraGJhLT5xdWlya3MgfD0gVUZT
SENEX1FVSVJLX0JST0tFTl9MU0RCU19DQVA7DQo+ID4gPiArDQo+ID4gPiAgdWZzX210a19pbml0
X2Nsb2NrcyhoYmEpOw0KPiA+ID4gIA0KPiA+ID4gIC8qDQo+ID4gPiAtLSANCj4gPiA+IDIuNDYu
MA0KPiA+ID4gDQo+ID4gPiANCj4gPiANCj4gPiAtLSANCj4gPiDgrq7grqPgrr/grrXgrqPgr43g
rqPgrqngr40g4K6a4K6k4K6+4K6a4K6/4K614K6u4K+NDQo+IA0KPiAtIE1hcnkNCj4gDQo=
