Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4D533031C;
	Tue,  6 Jan 2026 13:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767705935; cv=fail; b=RAh7tJIZg7Zygh4fcyT6eW7pE5PBA21xR7XwpmVP9S07tHNVCy0mLseZlM+vANCOnN/GXo8HR+Bat6URUDb0jxCV0YW0TowH/fHMOoArjFIChgrNrDDmYHRxXn9wN1Xzxl5ACZbrwRnPL1b+LcQMhuzQfwni6lzNmY5fsjaxdCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767705935; c=relaxed/simple;
	bh=pGjkMA7wQGEMfGUM+mvAoJTzaf6AYcNmlCA1Vqho9Ro=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uQx7PnZbqvsRBP6FCKAp1LQ//as7R4YJoiT6k8q/Vr7CEnIzjnxvybg3Pe+wMUnBySIb7cJZtTB5etjuVvquw4HtiIg2V+EtOUHZvQIYVN+04CT/JwYNW/7bpx4yojpvIHtww8PDMRg8hJryWmDKjcIbnDBG/Ll51pjSwLDfC2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EeNfwn1B; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=D62Ksgss; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EeNfwn1B";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="D62Ksgss"
X-UUID: 298c2530eb0311f0bb3cf39eaa2364eb-20260106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=pGjkMA7wQGEMfGUM+mvAoJTzaf6AYcNmlCA1Vqho9Ro=;
	b=EeNfwn1BCrU7zcNkwFYSOHJYtom53cuqBEOcOwcczytZC+RFt9XekiIyriAS9pqmTFhfuxOECmbl7C9umDpUpsKmHNdNquBibznT1b8QLIZUhgP+UyWav6ViDSH73XBulPNFCR0RLQcqILohCKCz4eKmlvulZGKvQ0YNu1OLDKM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:711a2dae-0dcb-47d3-a50c-8da7fabc33a4,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:b6684a29-e3a2-4f78-a442-8c73c4eb9e9d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 298c2530eb0311f0bb3cf39eaa2364eb-20260106
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1987376554; Tue, 06 Jan 2026 21:25:26 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 21:25:25 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 21:25:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JMHc7byBjLokIfiim7GTJyfkFFOvK4/GeG9D4cDT5u+jbhYtg88wmHY/y07TApKMPusWsUSxTw9V7R3YxcSUj/t+AtY7e6kpixbRnW5YfXH82v9gyALj92XLJvw1GKxDukDExbDTGS/8uMJdosxwC/r7yZqm7CRFGgJ5iyEWzMnSvfOPBWdqO1reSzm0J2FxhMxhHRV4JKkckEUZOrsPthHW7d7XoN8igngpVWMlHG7e6GKUmyTaSpXSn3INrRyZYhYb3meBa0MBGxwYG7p6ayUZsml+qm0dVE6I4JXjoVp4vN/0GZ6HMEzYGtYN3XR7pFby0Sm7MjeEoFKJHJL9Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGjkMA7wQGEMfGUM+mvAoJTzaf6AYcNmlCA1Vqho9Ro=;
 b=N3Utp92kAPRMdQLCLeEgNB4HrpgBV5aNZBI2G/qYAZIoJVaO3vqsvDVFLv8k1Egs7FY8+5MpxG45kb2JOq58NPxzDa2DI1G/7QGm0KS3Ie/8y77AK74jZ0ZJZzJbiS64KT3TBTNkk9NXkzZtVPTow491ltyDnOl5JBxNXwRej1hJrH1T135832wWPDXFC6REPhEwO5ciwDaZCRNkUxNPGyb9zt/VNTUgdjI5BhEzALsWI0oW8gkY5FUojnlFUBb6DtAgzSSFg+vTC/PfefoRrQ5VVKdVZDv5ykT7SF+CVL007xzE/33zVZv/Su8fcSX9MLEUgJ8himInF11fU22oGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGjkMA7wQGEMfGUM+mvAoJTzaf6AYcNmlCA1Vqho9Ro=;
 b=D62Ksgss0Rke0P/eU9faByzW2ZRQMC9K5QWKdsFMQRoVRWsCqDLe8tuTQwoXtrCURJAjO1HVLw6nT4DXn3tiI9IscMvc5EdW455xR6aZ80+VTRWtB2rN6BgqTzum+dB5iuxPiezevxcQGvSFbnHS5W50eatR6TraKYr5Rkw7mfo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6826.apcprd03.prod.outlook.com (2603:1096:4:1d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Tue, 6 Jan
 2026 13:25:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 13:25:22 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v4 12/25] scsi: ufs: mediatek: Remove vendor kernel quirks
 cruft
Thread-Topic: [PATCH v4 12/25] scsi: ufs: mediatek: Remove vendor kernel
 quirks cruft
Thread-Index: AQHccB4E0xTGzVYV9kCvh5caMnfPWbVFP5SA
Date: Tue, 6 Jan 2026 13:25:22 +0000
Message-ID: <1bbc263bafe14343b2d60a230ae6ce5dadffbf7c.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-12-ddec7a369dd2@collabora.com>
In-Reply-To: <20251218-mt8196-ufs-v4-12-ddec7a369dd2@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6826:EE_
x-ms-office365-filtering-correlation-id: 0394fa6a-ffd2-4898-a061-08de4d270b5a
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UEtrYU1tcjd4YWZiemFZM3pXK0YvSWI0TGo3SU45SWRvUE82ajllQVhrcjRz?=
 =?utf-8?B?eTFEa1p0MG9mbmZyWmpiQmhic3J3WkNBTURjNVBTc1p1OC9GeGpZakZFM3hz?=
 =?utf-8?B?anNDSmNxLzA5MnRSTitFZUVoNHg3WE95Q2pYbDBheGpiMFh1akJpTVhpL0hT?=
 =?utf-8?B?aERoeTdFVlMvb01mdEtSalF5T0JBN3BSbUlqNVdFQS95WnBsdG5KUDkxOXJK?=
 =?utf-8?B?M0lVSnR6eVFrRUFCWm1TUE1PT1ZuU0dwYjMwcWIvczJyMllSYmJ0alpIeTV2?=
 =?utf-8?B?VUN1dUt0WW1EZzNBVWZJRTN2SzJYaURleVRnQWUxQ21Sd2JrWXNwSlExWjQx?=
 =?utf-8?B?eUZ0bFRJVkttUCtYWmtRKzRqSFo3N1l6RnRYdEQwakxpRzluZzYxN2dTY0xo?=
 =?utf-8?B?Q0lScS9IVS9oNldPUytPaHVZbldoVW1wZHByY3NmM2V6d284RWh3ZG8rYkYv?=
 =?utf-8?B?VFcxd28vc1pqNklFM0JJWXliRDFmSWZyK1hyV1dDdVpZbmY0UlViaC9MZ2dP?=
 =?utf-8?B?NVFabVg3RmJXdHNja3JHcFFmY3cvQm1rMUpmcUVjbzBrTXBDUkJwK1FSQW1j?=
 =?utf-8?B?eDFORHplME80dHcweGhQVTBGQk5jMmEzV2dhQkhtOVl6dEJSVEtiRzlreVhT?=
 =?utf-8?B?SlVDWWlSbVZwS0hHMEkrODdoZ1ZwNkRxdkFVUVRxTTcvdDQvY3hobzBvWUZy?=
 =?utf-8?B?eHlvWVFzNTJpd1pEekgxMUhJWVhJMjFMSktIOVhtOC9jTXRJMFpzeUk1Tk1q?=
 =?utf-8?B?QVZUWVVEc0prOUxXTVBGOWppUlIwZmJ6RVArckxxVGdLZHltT1RtZGxyZURO?=
 =?utf-8?B?dmErM0dHV3Y0eEMzM0hwNlE5ZEkwNURjQlJyeXAwWEUzN25vaVpaTjBpclds?=
 =?utf-8?B?ZzFKdzR5TlpQa1R2Nmx1NmtqcUFyMCtlSlJzWU9UNjQ4WFJwS2IxUDR4czA0?=
 =?utf-8?B?RkZKaTdSdFpSd0pXV0dxdnV0aVVzdmF2MW5zbVlJOWgzL3JyQXZ6cFhOc3hS?=
 =?utf-8?B?Nk5VZWNMaUxYNXNzOU1ZVE94MzBOSTJIU3JBRjNMYXdNSXJBUWNPZEZRVFVj?=
 =?utf-8?B?RDBtWHlLaVdEY1BjZWtDbXlRYzNlSGRrblBUell4cjRycUk1dDFUQWNodktH?=
 =?utf-8?B?QWNORUNwbHRpdnIrVTNEd2ZEeWN0aVhMMzYxazYyVFUxREdkSkFFNUU3UzZ3?=
 =?utf-8?B?a0haNk85aS9Xem54NUo2NEJ1eCtpcmhadWxiVXhtYzVTUlRVcC9maW9XL0Rx?=
 =?utf-8?B?Y0hseG1iS3luRmdNejdBam9NVHZWVk04d2FzMnBKcG5YakFqSGUzczErZXFH?=
 =?utf-8?B?UHErL2RBdXdXRzQvVDlGVVQyQ3E0NjN3Wkp2T0c5Si9rWFBLTHR2QXgxV05G?=
 =?utf-8?B?eE1jMDcyanJSNU9zbHN2UjNKbTJDcFpxbFhDS0dWYi9GdTNVL1FnaXlTL0NK?=
 =?utf-8?B?cXNDeVE0a1gyUlFFeGpqbGFHb2tvZ1Z5Y28wM3gwV2h6d1c4bXd4TDRwRU5J?=
 =?utf-8?B?NmNsR0ZVMXFHc0lJV1FxSUMweGRQSC8zMnZzYk5IS0c3OU1ycTNCMGtzbUEr?=
 =?utf-8?B?bFVMZndQczJ4ZzRSRXN4RGlSZkhPeGpuT3Q1T2Z6bzhPOUdnWkxoMk0vZWJo?=
 =?utf-8?B?RTJ4d05sK0NyRFJaQVVIaXpaZVl3V1kzK3BCRHBtMGpMQXJPUERpK0NRbFlE?=
 =?utf-8?B?eldzbFJ5K3U1UUdYeFkvcmt0ZXRMUUN0VjBaN0I4UkQzSWxDaFJGVVc0RENT?=
 =?utf-8?B?WXVYVjFqem1GTk9UeDdVaXdaZUJLdVI1R0t2YzJidERlTFBTd1Fmb1FockQ4?=
 =?utf-8?B?VkNoaStzLzdPclhqTS85ZkRIbkc5Z1JGLzhBaTJGWDNhNGw1NEs0NlR5cmlW?=
 =?utf-8?B?Tld4enZoa25ubHdCbkJmV0ZhbjJRblJUcGgvUkFraU9zend6SHh2NTV5cU1k?=
 =?utf-8?B?Q2s4M1NFaUczWlpGMnduWXVnVVBGaVJCTTVsTnh0ZjgyVDB0dXhSenBCZ29s?=
 =?utf-8?B?RVRmTGZRU1lremRIdUlDRURNOUJHQm54eHNvVm40cm5VMlNudG1GbjFmTG5V?=
 =?utf-8?B?djh0bFQ1NFJGZjMra01UUHFXRVZnaDFLRTVVZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ri9uTS9pc1BGTVZxcnhSOEhQdG8za1RHbTdNcFhraHpuZldFVlFWUzN3Tmsy?=
 =?utf-8?B?ZVZISVQ3VjMyeExScVBnVTY1Q0FMS01RN000dy9jUkkxM2x2T2RtSmN6YjBG?=
 =?utf-8?B?QkM5VEt3cHNMeHZqVkIreGw1SjcxWnNWSUVCVkIxT2I2SUU4U1h6UzRoOUJz?=
 =?utf-8?B?cWc5MUpDSlZ1eEEwVFZ6Y0x1WmFSUGtwSGdJUFRlZUkzcnNoNXlUN01zSUZ2?=
 =?utf-8?B?NWEzWWtXK2VtQUR1VitSenNkQjBCeEk1SlNSZXl5SGlZR040TU91NnlBelU2?=
 =?utf-8?B?dGhGZnZDZHVnNC9lQ2srN1gzUHZrN1BZVmtBSXFBUDlIQmVQUHZ2NEgwbjRN?=
 =?utf-8?B?R0ZPNDJyN1AwSjlVOWdGTkMwcFRacytMQkVpWGcxck9Yd1FXVW1GQ0JuTDNm?=
 =?utf-8?B?UUp6NzRPdmJBbVdxc2NTVHVQYlBYWGJuMUpSeGdhaWJ6MFQ1TDFPUWtKYzIx?=
 =?utf-8?B?MUczMURjR082T3ozZDlpZ0xNUmhHVEtScTF2VnNNRzB6bUFNVVR2cTNPMGJt?=
 =?utf-8?B?enpReXYySGU0OVU3cUo4UjZZQUI2SEJlWnkxckpUajY4VGRhemtEQ3YrRkY4?=
 =?utf-8?B?V1AwdERHWHNlNVRJK2ZOdE1yR0FuajI5Z0IwajFGaHAvVmRRbW9PY2xJODBn?=
 =?utf-8?B?SzN0ZlBvVTM2aUloRm14c1lJeENrVzBDWCtJRlBkRC96VjNsbWRPd0lVOUpy?=
 =?utf-8?B?UUV1QWg3L1BOQTNsU1pNQSsvNWsvVHcyd25pZ290ZWVyOE5YVnJlcmg0bVRn?=
 =?utf-8?B?SEZjV3Nkd2NYenNwRWRlOHE3Mkw5UDlqSUV1akc3OGlESUdMd1FKdjEvdlNI?=
 =?utf-8?B?cmhNK3d2eTB2K1VmM3V1NlFubWU0NXBYcEhSUC9HWU90Nm1LbmJYLzdnc1Jl?=
 =?utf-8?B?Yks0U3lmWTNoZEg4SytSYkxWNnFhRENMdDhPUUN1WkY0SmxiNlJheEI3YTNa?=
 =?utf-8?B?RENnV1p2QXViV3owQ3AvMlJUb0pmdzVmUnludWd3ZXFQVE1jWVc0VjNRL2Fn?=
 =?utf-8?B?M1BvRTJPMU14ZUNTa3UvT3RXb2xqTWZYWnI1Uk5kWUF1NkM4dnBQRmg4eGs3?=
 =?utf-8?B?eW9OSFM5RmFQSjhVa3Rrb2p6TzRxdWJFTTI5eHBFZjhuVlJ5OGFCeVpuM2hr?=
 =?utf-8?B?UnNMdjZRK0xyWU95NXh5bXdzcG9jQUdPcnRIMFRpWitrOGQ0S09KenF5dWhn?=
 =?utf-8?B?S09lSXMxMTlVcHRnaEp0TlRCeS8rV3ZIa0M5K0JNUlRGdVZ4UkgyNk1nYkpn?=
 =?utf-8?B?ejVtbG13ZktKaTFmT1lCOENOTWlJTFNRaGxRSzV1bS9RTjdPdnpROUlFaWdy?=
 =?utf-8?B?WVllcU91QXl2eVllZDJkNHpXeG9relpMaUFZUnhYbjl0Z0prbXdHQ3Y0anl4?=
 =?utf-8?B?ZFpOU3k0S1MwcDNRdnBLQ043VWhwMHZESWZMVStBb0xrS0FRdnRTRVJueG9E?=
 =?utf-8?B?b2NkUVRaTGN0YldhL0wrbE5rVE1yRTBXa1kxWjdmakQwVDcxTFpIN01oRmFS?=
 =?utf-8?B?RWFzbWw1OXhuVDY2Y2pnOG9JVTA3UUsyM01KUjQ3YUdnRjN5L2NxaVRPVWFO?=
 =?utf-8?B?bnJlV0JTOFBDTGdlNXFOTlB6QkpVaFhhN2lwa3Z2YkVaYm11YW04R0JFemN4?=
 =?utf-8?B?UGhWWi83enFlYmJSMVFPMmZsSlVQZ3pVTHlSM0MvZ2d6cktlSXFteERKa0Jz?=
 =?utf-8?B?ZXJvUVp0QWtMWUpraitmMTMyWURZbEtCNHpuYVUrN2kvY2JFV2N1NDlyNHVN?=
 =?utf-8?B?Z0phcXdhUHcvYnhyNFhTcEl0aG1RTnJwRHhJZ1Z6YWcwUi9PN1hhZVB3ZHR1?=
 =?utf-8?B?T0d6U0RpQXcySE5JbFpGR09UTUQzd0RNT0hxeEJXZ0FsZm1lVSswQmlSODZ3?=
 =?utf-8?B?UFA5QmU3T2RWYlpCekpDbEpDWVg2TUVlQzh1ajY4MEhqZElDSGJtN0RwSlFQ?=
 =?utf-8?B?VXVGdTgvZzhhNlFMNzVyL21SQ05tTmFOUCtXQ085TkxrcXhNOS94Sis2RGpJ?=
 =?utf-8?B?SFBPS0FGR0srMnBtWDRRZHE5aFJCVTZXL0srQTFRYnNVNmVyZkZva0FiTmN4?=
 =?utf-8?B?V0U0NHNmRG9Ca3A1c2pQYnF5RDNFemlUa3NBc0FnaVN1YXVpa2pYWGVTRXVL?=
 =?utf-8?B?a0ZlUG9HYXVCWElJNEluSmZnSHQvTkxQSjB4SEhMUVMvblRrTFR6dmYvekE0?=
 =?utf-8?B?aFY3RXNDS29kc05CMkt1dFpCb3I0MUxydzFwOXVtNFB1dDdqRHdjYWlpZ1J6?=
 =?utf-8?B?QlEwdzR5U1B5cDYrTlluYlRPM3VJSFE2eEFkSS9lQmZyWnFPdGY5bDNqY3Zz?=
 =?utf-8?B?SVFWRFEyL2VNMnNramNKUHgwYnJVdmQvT2YrZW9sVnRYNUVNMnIxMWI1TFA3?=
 =?utf-8?Q?I0Wx8at+n43+SfEM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E8EFC6D678EAF4DABE4B7A16CC1F639@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0394fa6a-ffd2-4898-a061-08de4d270b5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 13:25:22.2192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: okbQ3FNq7KudXHHko/FVNX/iZm2dP/TQWFqNZ8b3Tv5abG5LOlFYy9Fy+c8jVtVUqoMDLiGPY9FEcsSXpiK89w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6826
X-MTK: N

T24gVGh1LCAyMDI1LTEyLTE4IGF0IDEzOjU1ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IA0KPiBCb3RoIHVmc19tdGtfdnJlZ19maXhfdmNjIGFuZCB1ZnNfbXRrX3ZyZWdfZml4
X3ZjY3F4IGxvb2sgbGlrZSB0aGV5DQo+IGFyZQ0KPiB2ZW5kb3Iga2VybmVsIGhhY2tzIHRvIHdv
cmsgYXJvdW5kIGV4aXN0aW5nIGRvd25zdHJlYW0gZGV2aWNlIHRyZWVzLg0KPiBNYWlubGluZSBk
b2VzIG5vdCBuZWVkIG9yIHdhbnQgdGhlbSwgc28gcmVtb3ZlIHRoZW0uDQo+IA0KDQpIaSBOaWNv
bGFzLA0KDQpUaGlzIGlzIGEgZmxleGlibGUgYXBwcm9hY2ggdG8gaW1wbGVtZW50IG9uZSBzb2Z0
d2FyZSBzdXBwb3J0aW5nDQptdWx0aXBsZQ0KaGFyZHdhcmUgY29uZmlndXJhdGlvbnMuIEJlY2F1
c2UgeW91IGNhbm5vdCBndWFyYW50ZWUgdGhhdCB5b3VyIFNPQw0Kd2lsbCANCmFsd2F5cyB1c2Ug
VUZTIDIuMCBvciBVRlMgMy4wLCBvciB0aGF0IHRoZSBQTUlDIHlvdSB1c2Ugd2lsbCBvbmx5IGhh
dmUNCm9uZSBzZXQuDQoNClRoYW5rcw0KUGV0ZXINCg0KDQo=
