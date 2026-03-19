Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52638364EA1;
	Thu, 19 Mar 2026 12:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773924141; cv=fail; b=qC96+XjwQU+DsQjJ3Z6QAefHOObCZZmlpGOU+2SONGX+piCj5KZNdi0/R1KyrFZQHfE5rBRWiIHz4uKSLa3Hx8XXUY6K9X/husu2TzU4Y8ozXfVsVfLPC/9NKxwy2MrzKSkTcHXaqK+a3oBC7v9gdytcmMlAthitJGl697ybNNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773924141; c=relaxed/simple;
	bh=8mUk3J4caU39+Xbghv6vMlOjyiB/5jaXvQkP8TjtM50=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I2ar9+kgxotNK+FHRxrpyzlyNMBsyJW1ItLjRlfhOOeFBM07uOYoj+/Lqrr7dbzRdLjoEK/tIz5EksXp5sKgYge93L9BCZwkO9vD+ie2onF+h7BhPWa7VWuvfpX0SlY50244C/dYo7bOWZaGGnXRC8LgYNHYqumElGHqzSsLo6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=a83/2N47; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=fy3loVYa; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="a83/2N47";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="fy3loVYa"
X-UUID: 0f570b6e239111f1a39cd589f645bc18-20260319
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8mUk3J4caU39+Xbghv6vMlOjyiB/5jaXvQkP8TjtM50=;
	b=a83/2N47Vq0kj1EMsvO/JQK8bEcsFMinVNc42bVE/vRic6U5Tox8NYhkQmgHDS8Rac1eGLtOqSqWlGtbcT+keVdsqW7qfbjVSiU41uOcThkas4X2bvz2H8F+d7O2Y1QgGn4OxSHGKEQfqJWvZpL23UFijHthkl3hefdEMiP0y54=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c54734b1-8d72-4803-b8a7-598d317d0a2c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:cfadaf4c-9183-487b-8624-e74f2dd98990,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0f570b6e239111f1a39cd589f645bc18-20260319
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 29533794; Thu, 19 Mar 2026 20:42:15 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 19 Mar 2026 20:42:14 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 19 Mar 2026 20:42:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JpC06f798OcNIL5ByQYoX8yHbDph8YDcSO+YdM28Q/JimWYrrPCtNVstu26yi8T+9P+u183dqkMGnvhTaXEYsm0dPgTIN3VNlcxNMGgq5eww1AYjg6Uo4CrpaAl5GqcEUgsPKtMDgifq118v+51w3haKVJtgRqTnbqRac+cK2N5paVcHwVZiWHlAbzwo8Md6NLJwdklZSm6jylFKVWirU4vw8hNgnyihB5vGgYMO735PZgLV+xCPAGhbEknAODkg/aLCJj+4ea2/TsNj+9v3sLaEit8YcFfSsQc8mMwbKOIFEmQRn3+hj7i14BtErCT0FZscIrY2R8mpv+ndc7v0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mUk3J4caU39+Xbghv6vMlOjyiB/5jaXvQkP8TjtM50=;
 b=hY790KnsGBPtGG2/n4vVm0LVH+KIB9x7RwiS3coBsw19sydPen8sGky+kFnnOC0m14s4lIvKADZxu6QCYPd4znlheXBC581Et7IDDbdFlgOSaz3obI6u9kbdl7pWpFawICG4hYU8otH60usYhWtey2C3vZoYAvyRibR/hS1di1ZaFVfoOv84ImhdugjQAlQVcxjJWYZZ2hD0q18xyuoM2skzDZDpK8+/+62SbweoMM7f3n+y9MOaFPQmunbdNu5k2DkNBPZmme3snHARp5tYUEjt3xaaq9hiYsXZLiiu3Hra7bc4KUfIbbXS3AOC8FWNjUnAMBSnN2X1wUe9Z+OK2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mUk3J4caU39+Xbghv6vMlOjyiB/5jaXvQkP8TjtM50=;
 b=fy3loVYawbkN6U64dltAdo44WOSWh12kKDhYW0U8Ma2zulLcd9LOWedgZJj6l9ydzQC66HGEjMcncy327hwaK0wrxQUXIZTnub41Knak/1Ya6deq2KzG+0XgXdCAODhftRTeres3bkTGm/LJzWE9uZi/NKd5pzOkkM2mbTxlk8U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8648.apcprd03.prod.outlook.com (2603:1096:405:b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 12:42:11 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 12:42:11 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
Thread-Topic: [PATCH v3 04/12] scsi: ufs: core: Add support for TX
 Equalization
Thread-Index: AQHcrw5m3AJ+eCzqYEGMTPJE+YMrfLWyVjsAgAAJRgCAAAOuAIAAXY6AgAKphoCAAHM8gA==
Date: Thu, 19 Mar 2026 12:42:11 +0000
Message-ID: <ab94f19d6fbe8f987da118d2b84d45aa506d2be4.camel@mediatek.com>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
	 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
	 <42587e16218f1c51dbcbe6bb1639a843e10bcd80.camel@mediatek.com>
	 <fa2a97fd-e17d-4314-b5a7-011b6b16a622@oss.qualcomm.com>
	 <fb56d5f1-2b53-4627-ab7a-03db13cd76fd@oss.qualcomm.com>
	 <ead714be9dbe88ac66b3ce586498f7ffd734e328.camel@mediatek.com>
	 <6e2f03ee-6cde-48ea-9f43-6b911117fe4b@oss.qualcomm.com>
In-Reply-To: <6e2f03ee-6cde-48ea-9f43-6b911117fe4b@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8648:EE_
x-ms-office365-filtering-correlation-id: e1818a6b-2673-47bc-82b6-08de85b4f0ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: TPHkWIMORhl132t4IZcFf9sExdURMU3kgmXSf4D2pf8/B4N2oxSxThrg+texWFKdjCZcOtdHkrlDc2YWH2kMHVnYhL2qh32NvsuV4PqY3KrwY5SEHNJsuTY2Euc8gylIFSh0jFtdH68KodBJhzpc6tn2gttsfhZVEr5MBuotK6YU5xuvmC+Hdb4rfDV7J/TetbOI8QudJNXMXNah8G5KeQlNGmUH0plI55bWjFcxHO3FAYmfoyMU7iHzTtgrjCds6xg12aiRGcQs1EkrSq5EHSs6/VHopsRe3ljAYarMHo7CKn3r/7EelUmgnXnu0ZtZdgXHgLOLU3SvGK1NucZNWVE5bleT/OyUDgsLDDbxJs3J71aPBAxqIZKDJ1jp8C94e3FxSsLJzM7MVBCbzfBAdd30LXiiSSGFwffr2iKv/p7xUXOVv9jUdZbVtdjvd8SxmFKAdNkNPJemVOd8mKZVDuUc/+baao1H9LBeggyNxnfQE1Jtlccnoq8/FPyc25o/4nCa4Y8N3Bk83h++aqKsl0CRIapvhUzZFcyo+oitdaa6l7u/Po/6lG2l0t0Qb3QyMYqTVQzV5DaUYbmJt6ZSvoEqJQx2Mkkzkcr3erNS1ybmXryNUsX6Vak4TbMRrSwgM87Bgzcyvxm+V6eLsmZSUpw/kaXDGP68wJDQrzWRw1yhfHtHG7ogCsu3PoedpkmLeB9wb/HO3CmD+vGyp19SMgd0fuD+xbPjd+x9OP0VIMEqas447Dq2PRnqNHGZJ5Y03N8qKHlGMz8M6yA+JtdBxiv4CN9YkfgffCvFPrRzPVw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlFBUFRwQy90RTZWb1psY1U3ajQ2elhIYndBM3hjQ1pJRnIvRkgvN1VNYnpD?=
 =?utf-8?B?SURtQkxpQ2lzSmJKd1RNV1NabEMvL0lkVTJDZWFmL1NzMithZ1pZMXlKR0ls?=
 =?utf-8?B?cTcrTE1pb3hXdzR6cUhpakh0NnZHRDhTUzVPMzVSQVd4Z2k3cEQ2VVhJK2ZI?=
 =?utf-8?B?c2p1UEdzQzEzT1V5eWZCRlc2YlVaMnpCQVdrMkxwbWdXTlYrTGRlSFNuNzNN?=
 =?utf-8?B?UnRodFNKS0J0RjhoTFhHYXdlZ3pnZ1RPWFF3WE80Rk14S20yMXI4ZnBPUlZv?=
 =?utf-8?B?ZVBoVTJoRXJNemZyd3IrbEFrWS9ySW5nV05lQjBCQzRJam9GemFUM00wVFBF?=
 =?utf-8?B?S3o3TDFqc2N5QmJzNTRQNFF5WHZmOFQ3dXpZdmgxeDkxVkZLbUJyWC84NXQw?=
 =?utf-8?B?MXp5MU5lWnhpQVF4cTRsNXpNcUhXMlh0MzYzZ0hvOGR4UFNJZnh1NGMyVzIw?=
 =?utf-8?B?ZjVKenBpWmUxdE53aUJDakpvU3Buc2srUzVvaXhDekVYNjhSNmFFazhMUlZE?=
 =?utf-8?B?NUp0QWxYbml5Y25xNmFPWEdrZWdueFRxblhvSG1RRWd4bjJNdXVDZHJPZm42?=
 =?utf-8?B?MjBhcXliVFhsdUlIZ3Y1cU5rRDBtdGI0b0RwNXQyWW1vVDZiSndLQWJxVTBn?=
 =?utf-8?B?S3RDN1RUOEYyWFlNV0FyVXRzeFlmQnBNMXpYRThjSW9uY1dlQ0pUWnVkRkpp?=
 =?utf-8?B?TGVpT3dLTlFEMFg3WVAxenB4bGw5c3p4eERhZG1JdkI3a2RBN2VIQ29EVG5T?=
 =?utf-8?B?RGo1VE80L0Z3M2lSSUdEVzBERXpiR1Q5bWR5YjVFWG1NZnJZcHl5elhaWlJQ?=
 =?utf-8?B?TjNqSVM3R2o5dEpkWkNPcFZzZXliT1daNExibXhpVGVqNXBUR3EyVUtNemFJ?=
 =?utf-8?B?bVdQUlhUc0hpL1huQkZyWDY4K3FLTFNTcGNVdnhEd3ZKdGhMZTZ3ZGxTMkFS?=
 =?utf-8?B?UkNodjNndlVXSU1UTkdNN0I2REVSNUs1WWNhaklwdW5VdUlWM3BiNkpjRTgv?=
 =?utf-8?B?Uld0dmlBNXMyYW0vTEJ3ZDdWL0UyRHpGU0Y4dW44NWdNeGc2bHNYbFkyckE5?=
 =?utf-8?B?MHE1RE9IZy9lVzg4ZzMyeGdDaGpnRkQrQm83SGV1WWpRU3BXSTZWVWhoek8y?=
 =?utf-8?B?Z2pJakd3ZGNRekhrNFUxSS9PWUVRaUplL1ErNG54dFNEZVRsaDVKTlJMUk9T?=
 =?utf-8?B?RXMwSExsbTZnRUNjYmk3TjJKakw5VE1ocHMzMTVsNUUyRUFuMFZOMDdpcVU1?=
 =?utf-8?B?eDMvMnVva3k1TFIzWWkzb2x0ckVOa3MwcXlBaDZkQm5Na3JnQVV5VjkvVXdt?=
 =?utf-8?B?NVZhT2lEOGJTUFJPNE1Qb0NVQ1FUT0pYRGNEcCszUWFwVVkwMWNsdmRnM1BC?=
 =?utf-8?B?eWxSdFFTT2RUay9pd3ZoNVNVUUVDamNhMXQxdDUrWnVyM0t4V1dGVkg2aGxS?=
 =?utf-8?B?aEVUWkZRQmRpR1VNa2RWT1JMK2dvWElaQldDcDJUMlhCNXZkcWpOZnY2c2NK?=
 =?utf-8?B?V3k0T0hTZ3ROTTFOQ2hJM3B3ZGIwQkNVK25kU21NYjRaNG5XOWdQTEVHcDBz?=
 =?utf-8?B?UThYQi8vQ1UycUg2R0hYdmg3c2k2ZGtjZTF1ZlFwNUUvTE1DOW1GS3FvYXBK?=
 =?utf-8?B?THlJUlNKSU52QS94NU5PSVcyQWNuaUZtUUtzOEtScG9UQ1VuVUQ0T2U3T3lW?=
 =?utf-8?B?TndSRVlnamI1SUliYUpxV3Z0Lys0ckgvL1FRSlRwUHJXYU0xYTZhTUtDTDdT?=
 =?utf-8?B?RXFtbEx2QTgwSnNoVHQxWXBTVlJxQytWTnRNS1huQkluSDBOL3ZjaTZGQ25E?=
 =?utf-8?B?bHJ6dzdlZjVnVE5DeU1hWGdWRGlQS0NYL3NFUzI2ZEdyallKbWFqRy9wOUQ1?=
 =?utf-8?B?bVZEWmFqeTBBa3Qza3RqbEVWQVhpN3NPNU9BbUkwN0d6V3BZQWpncWpDQ2JS?=
 =?utf-8?B?VTNpNk1nSFFXNWRLbStPanozSHBmS3dBU2NiOGY0K3QzaytWR0I1WHh0UndN?=
 =?utf-8?B?OG9NYlp4aisvNFRKNFg2dWh2d2dCd2VXdnZYM2RCS2t3K28xSERaUVd0VHBY?=
 =?utf-8?B?bGQvMThPNGcvakhjNWxkbmVQdHdQL0ZJb1FQQ3R2MnZWMkZLSkh1K1FIUDhK?=
 =?utf-8?B?V0V5VGVUem1JS0N2S09XY3AvODVuOEJjSlMzeDRHRlhwaGY5c1NSeUZkazlQ?=
 =?utf-8?B?b2VEbGhMU0lNQmNOU3V2cllFSjZmZ1FpRTNhenlaM3h2U2oyN1I3bVp1TjVB?=
 =?utf-8?B?QmRKTFFBV1pEZFZmaXkvYnI2ZjlxY2k3c1dNa2JucDdTSmpKYUdaWkkxVHhG?=
 =?utf-8?B?cGNocTZ5UFhmSCtKMDVIVU5TWHdBZ1hLUUhHQWZnNDQvTm5qelBjekZyNjh2?=
 =?utf-8?Q?VARuO4kJaCGTMY1I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A1EC759E018014781872A0F70B04576@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: cjigvf3+5CHA8Hy7galY6QC5bZh8VFEcoAFHn4iMX6WTt5UGmqxKf/qBETl7h0VJQCqg15/me8aQE5bJpvsUXob6Yjq7GsjgsmIlQa9iGSvsNyNpxfjYWrzQG/k8HiNOAK/LHN0VMm4MlKinYpGFr61EwvZ+YioHnln/ryl+1UomSeyZH29HV0ZghrgzMZVYnjxc8jx9teqaeMqjx5XIC6WKydIiFxxnmd0fYEIH4lgF4/KtyJ9g9/BaPiBynoR/yyfR4GH370ffLAArgvSZTRgxQlq6GQah3NPjGHan4/nnprOzLlMYTSdVzStAFgy1yf7Dxm+yj+XhaeWnPRmHig==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1818a6b-2673-47bc-82b6-08de85b4f0ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2026 12:42:11.5908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3xvtBIxFkyQsx8RShHUn2vZYV+fheIT8r7Tr66Ftd2v1WIK2PQ6klOreAsuCwYW+ymDCqc3aSdB13iWC5IvIIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8648
X-MTK: N

T24gVGh1LCAyMDI2LTAzLTE5IGF0IDEzOjQ5ICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBTdXJl
LCBmb3IgdGhlIGxhbmVzIHRvby4gQnV0IEkgd2lsbCBzdGlsbCBrZWVwIEZPTSByZWNvcmRzIGFz
IHUxNiwNCj4gYmVjYXVzZSB3ZQ0KPiBuZWVkIHRvIGluaXRpYWxpemUgaXQgdG8gYSBkZWZhdWx0
IHZhbHVlIG90aGVyIHRoYW4gMHgwIHRvIDB4RkYgc3VjaA0KPiB0aGF0IHdlDQo+IGNhbiBkaWZm
ZXJlbnRpYXRlIGEgcmVhbCBGT00gdmFsdWUgKHVuaXQgOCwgcmVhZCBmcm9tIFJYX0ZPTSkgZnJv
bQ0KPiB0aGUNCj4gZGVmYXVsdCBvbmUuDQo+IA0KPiBUaGFua3MsDQo+IENhbiBHdW8uDQo+IA0K
DQpIaSBDYW4sDQoNCkl0IHNlZW1zIGtlZXBpbmcgVUlOVDE2IGlzIG9ubHkgZm9yIGR1bXBpbmcg
dGhpcyBsaW5lLg0KCWlmIChmb20gPT0gMHhGRkZGRkZGRikNCgkJc2VxX3ByaW50ZihzLCAiJThz
JXMiLCAiLSIsICIgIik7DQoNCmlmIHRoZSBkZWZhdWx0IHNjYW4gY292ZXJzIGFsbCBzdXBwb3J0
ZWQgcHJlc2hvb3QgYW5kDQpkZWVtcGhhc2lzIHZhbHVlcywgc2hvdWxkIHRoZSBGT00gdmFsdWUg
YWx3YXlzIGJlIHNldCBiYXNlZA0Kb24gdGhlIGFjdHVhbCBoYXJkd2FyZSByZWFkaW5nIGFuZCB0
aHVzIGJ5cGFzcyB0aGUgaW5pdGlhbCANCnZhbHVlIGNoZWNrIGZvciBGT00/DQpGdXJ0aGVybW9y
ZSwgaWYgdXNlX3R4ZXFfcHJlc2V0cyBpcyB0cnVlLCBjb3VsZCB5b3Ugc2ltcGx5DQpkdW1wIG9u
bHkgOCB2YWx1ZXMgYW5kIGJ5cGFzcyB0aGUgY2hlY2sgaWYgRk9NIGlzIGF0IGl0cyANCmluaXRp
YWwgdmFsdWU/DQoNClRoYW5rcy4NClBldGVyDQoNCg==
