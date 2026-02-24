Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC52E555;
	Tue, 24 Feb 2026 12:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771937271; cv=fail; b=fLEdnSfI7sP95lq4pmVY3ywANWarYOUylxSLHvTpd1wbIZHDvBMIk2z784MpsOYCXd4En0W0uSKszqEOnbnDpcbnYOePQYWGYlsEtxJNnRde2CpFniIWvhOWMovYBZxpwUc5W0Dm+4kwe7X6spC0eIrhQuImFFFwgQ3Lpj1YKCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771937271; c=relaxed/simple;
	bh=yf1vfqd7si9x+AXJXHNZqHScX4TkP/eGhsVyWA3nWKw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FonHeIKHMM7Cpl5U/97hfLnjNxWHeitD4FpLUP79PPrlTD89dEMF4kiyBuvpeQmcNhTnOy2fCPGBCKGDwkzUHk5lXuzagygQFl2ttwWRx0nbeGxa5xFj0/qjQyLzV+q0czsgw9TCoNqlCD2MOQceyy7ribweFFRla0lpkdNiwGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dwnZnxdg; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=sj9yuWRR; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dwnZnxdg";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="sj9yuWRR"
X-UUID: 03b10edc117f11f1b7fc4fdb8733b2bc-20260224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=yf1vfqd7si9x+AXJXHNZqHScX4TkP/eGhsVyWA3nWKw=;
	b=dwnZnxdg8N1odiLSYGE3Fs/NRv3GWwCN6pulYnAvuOdV75ZIRb8YMdwgrxQUoTH7/AOjMLMNTQrAjKx1Y4k2u9MPc4rES+9et6f0HcfNupctWzA8AX22d7L1FvbyLtIJ0Pns+3ugAg8IhbZbuA3JTzgr4HHiONMSirXg2CQIR/Y=;
X-CID-CACHE: Type:Local,Time:202602242047+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:85c25203-5d85-4a8c-af41-06cd98138b98,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:7153377b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 03b10edc117f11f1b7fc4fdb8733b2bc-20260224
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1610089201; Tue, 24 Feb 2026 20:47:44 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Feb 2026 20:47:43 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Feb 2026 20:47:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m0BY0gl1Yr8SgvYcRzDlSF6UlM/8IQIAqvw8oIuJL/NxGuTqC6xD0HMRqvZb6ZiUGUHOTxSTH/3pEUoVoYJlqF9QF6162rY5UUtz4+1GeWRSwYLHBQt47AkTQ8KvWbpVM5q9sGT1BqqNZ7GT9sTU0rfF1WO6l3bHw90XyEefYMholVmyG8k2uznTjBXZbODc3ihhPWGaZIN2o+bXiEBlP77M6HUzGCcZSS3GzZKom4h8kIJ2C7Yzjq3a+kOfKY5Y2ZjXDpIef9GMbz5lHgOUuE97qMS3vMDncqvHa6uBZQ6kDaYFRCpCJKcnwhJI0HEDO/HPxrT/jyY14qJoJdgflg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yf1vfqd7si9x+AXJXHNZqHScX4TkP/eGhsVyWA3nWKw=;
 b=F584TY9S7igzkoNqtIdfDWK0RGE4PJBvXDKCCzyA0Q2EvEkxPHrlfqlPMh3ipI84NWkq1onGooGGp9EVDb+qJYbJg7aQaGtkBvoP5/+PKzuX+U6fUINpULaH0BKxXK9C6KalIHM+AqvDSMWCrGT1HOxPevek7MuSnD4P7KBoTtn6+ARpBwhc7HGjIBmF8Hn0SHe6YE81Ii3cJKTjLQrQRjSrfNcIJecNtfnJycSntdVKOUBrg8nJeBwFQ69rzor2RlvCUDqsJ5JxoE7KKl0VYi5uFdxX1HKFa8PDKCDW5MvhZ3/GEZVpBl43B1o2Tqra+gM0WuTeRVTlEKFD3DVqEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yf1vfqd7si9x+AXJXHNZqHScX4TkP/eGhsVyWA3nWKw=;
 b=sj9yuWRRQwWL2GqkKBsr1yh9o1KAD+rnJ19DsVqS8yQES+5UwihabvEdNaOj34I3OnOaiJjkeJSkS+3vYpvBC0OdrIlnAm1HLG5GYUcudGJeumQwoatUChqKcKadkmO1ogInPGTN0DrG+5hQSbq7IyQ06rnrUm4iV4lHz1A4azk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6470.apcprd03.prod.outlook.com (2603:1096:400:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 12:47:28 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 12:47:28 +0000
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
Subject: Re: [PATCH v7 16/23] scsi: ufs: mediatek: Clean up logging prints
Thread-Topic: [PATCH v7 16/23] scsi: ufs: mediatek: Clean up logging prints
Thread-Index: AQHcn0ncDWW9D+zkUUupEOV+hOFhPrWR2OKA
Date: Tue, 24 Feb 2026 12:47:28 +0000
Message-ID: <c333898413d249c017430d4ae98bc7be3bf33a64.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-16-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-16-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6470:EE_
x-ms-office365-filtering-correlation-id: 1053bed0-fb10-4ab1-bb8d-08de73a2de4f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RTEyREFTMDErV3MvOEVieVh0Tk1ySE5NZlFqOGNoY3l6aTBrRzlFVExxSjBT?=
 =?utf-8?B?c3NEcE05MGE0SUlzK0I1bHNZQUluYjV6YkRKdldhZTlIdzAzKzYrMFY2YXZt?=
 =?utf-8?B?RDA4MkMvK2dyV2E5NG90MDNGZmdDUWlGMnhmeHAveTF2M3RBT2dkZWcrM01S?=
 =?utf-8?B?K0hWalN5U2VCWmlrNVBFR0lBV2wxTm4yczlsb2JMek80RmJZeXFud0ZNNEo5?=
 =?utf-8?B?alRVSmxLelNrSGdwcEVJNGo2c3VrVTF2TU1OanVxSnAwRVczQ3VqV1puZ1ow?=
 =?utf-8?B?SUZ4d0YwOGFCMVVVVVkxL2RJTDRSQmF5ZVlXMURJVWRkWGFuemhLMU11MFlW?=
 =?utf-8?B?emgzVnVnMDlBeVZCS2VoMTI1OThGU1NsOFQ0ZmVzSnFoNjczbmdWZDBjL0s0?=
 =?utf-8?B?MzBSOFh4L09TTGZ6TVNGcTlka1VJcElwVHM5c2V3ZTZiYndjUUI0bjhoR0xl?=
 =?utf-8?B?b2tZV3F6bkxwOGZzeVd6RWNvWHhwdnAzWTZJN0dWL0d2RnpmcUlxcHJDTTVm?=
 =?utf-8?B?bTRRbmhtZ0JCSkRNcnYrREx5SVZ4NzdYMXFaai9BMVFhcWtiZXNFMjVKRGVy?=
 =?utf-8?B?ZnF2cHQxSWlaOFhuMGZZemwxR3FjTVNmTGlnMVpNbjBDV2NaWFRoVXB1VmtM?=
 =?utf-8?B?SDcyVnpBbmRoUHBuVVRaKzNiaDg3QlJZdWpSc0RLYWhPc2RhZDZQanpnTGx6?=
 =?utf-8?B?Z0tZdk9mMUUyNzQyN0pad1E5TUxpYWpVdEZpelRTUkxxdXJtL0orbmdLSkMy?=
 =?utf-8?B?ZVkyWEtaQVhSa29sblBuSmN2d2VzdVdhVzlwVFJ5WUlWYVJTTzllaS9mbGEy?=
 =?utf-8?B?aFpJd2F2bVVGZXZ6U3JWamJySzdaV2MvK2lRbExENXN2UlYyMmNpbXNTblZS?=
 =?utf-8?B?R2xKWGk0TG5qV0pWR3MxekhuSExKY2c0cHZ3SHE2cjR0cE4zMTZReTBGMHRE?=
 =?utf-8?B?ai9uSDZYbWp2QjFibVg0YmhDSUlFTFhSSlZxN01kODRzeWNpT3lMcC9HcWVX?=
 =?utf-8?B?ekRFZkxKTlR6NXFxa2tibGxzbDY5R0xkZlVxb1AvbXFJSTdIUzVwZW0yZ3dk?=
 =?utf-8?B?L0ZNNWtIV0RWdmhzcFQxdWVNR0FQNWtWMGNIRGRGZEZJc3FDVFA0b2RXeklh?=
 =?utf-8?B?d0dIUStLOHZaRjMwSVhtZHl6S1p2UWFrRUQrODhlMmRNTFQrcDhRbjZNYThH?=
 =?utf-8?B?WS9QU1NGS0w2NW1HcXlzVUpmc3dJQUNwcU1QRDdtYXJJZEMzRXNobFo0cXk1?=
 =?utf-8?B?b0liRmdacXhTNXVMNzhmdndZTWpBM3lwSjcwcFZ4TStwYUt0d2NmTVBDOWFQ?=
 =?utf-8?B?Ny9aWFRYS1VxWkhFTmczM1BtYWJHQ2w0ZXVKWlhCcEEydDhoWk1XM2hMVHAv?=
 =?utf-8?B?WEl2U3ovNEptOEFBZnBBQU4renA0YXpBNDdGT21XYTIvZjVveTBkTFF4RStt?=
 =?utf-8?B?QkVCVXl3TlJCdFhjb3FVUzFjRmNCbSthVHFDOEUrQmh0NUxtRHpoSHRPYTR1?=
 =?utf-8?B?Szh4Z0RQTEhUSE95cWZnTDBJQ3FMR1Q4UWVOa01MWUlCNUdvcGMxOW5kcnFS?=
 =?utf-8?B?dTJUNjUyOWNHUzdYUlE1RTUybUdEU0x0Mzl2c3AyR09sREVUdldmNjZhVkNB?=
 =?utf-8?B?c1JieE5xUDlXU0xGckt1Z2FCOW5GbmZQL21mRXhBSklVUDFFNDdBY2I1Y2Ux?=
 =?utf-8?B?TGxGUGQ1KzdLWGg5eThGbE9xSnhEdjNJWjlVUjA4VjVBODV3aXA5MW5uRW5C?=
 =?utf-8?B?K2VpK1VGZjduMXJYTHRFMldtVDNUYzBoR3ZTVEtCQklRZzl3MEVxWE1DMEhQ?=
 =?utf-8?B?TEt6TmFRT0lGQXliZmd2UjYram4vRGFNdHUzeEFNemcwOHBZcm9lb21UYWxK?=
 =?utf-8?B?NndjWUhuS2xhcXViSXhzWlN1NXdoQ0N1bzVMTEJuQjhMUlk4am9MaVd0RUV1?=
 =?utf-8?B?R2FsZ2NuK1hsQ1VtQXFzV3RNR013dWZ3bktnbHpPMDNRbkNTR1JUMG85dEpS?=
 =?utf-8?B?OGpCd3Y4Z0V1aU50ZEVsSFEvSjhzZnduVUNpZTRQU1BzNVVVUnZOMHE5Zm5J?=
 =?utf-8?B?OWdYSFZGeFdGV0xaSS9FVEliUUNxdjdlWjhOS0FWZUtJakhrdjdEVWJ1VFZV?=
 =?utf-8?B?VytySERSZEdMaS9ESjYxOGJleXM1bDU5alF0VDNKdDhDczNLc3lRblY0bVdE?=
 =?utf-8?Q?yXhia57VUMWQrJL8k0AiiBaspjgyG858/oM5XMJT/sQD?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RExmTWhteG96VXQ4WUI5RS9kOEpQVlI2REZpb0UwUWJSVXJZRTNSdERLNVZL?=
 =?utf-8?B?cGFPUXNybmVQcmJEZ3duV2JNYXR6a0hXYjFVNDR2QlVMQzFzdXVldkVJN3VV?=
 =?utf-8?B?dloxVzF0WFFndEwyVFNzOEowL3JWLytDQkFpaW5MTUZ0VFh3b1lnWndiNVNj?=
 =?utf-8?B?eHA4UkxmYmNDSzc0R0wzdUxGUDhxRUhjaU0zeGF3cVp3ellKdUN2cmNFSjNs?=
 =?utf-8?B?YWUwWmdKYzhvWDJIYU0vNUtnWjQ0V01uYVMvY2FXaG1zZGxIWDc0QWtETURQ?=
 =?utf-8?B?bHNSZ29obG5HYlZXeWwrQUh4aWwwVVZKNjczRFZvOWt0UldNRFNuaHpOT2t1?=
 =?utf-8?B?b0ZHdFJVOE41SmluMnc3QU02azhXU1lzcm91R2ZHMkkwYy9xRW53L1BaemUx?=
 =?utf-8?B?MWdINzBKSnhoaTZKOXNTeTc5VDdpRDRKcmFmaUg3NW9kQmZiYU92d05JYmZK?=
 =?utf-8?B?b0hRNmlUbkd3QXYzVVphVWpwOU5EYnpCVnZ0eXUzcjNwZ3lWb3lTZ3ZKZ0lM?=
 =?utf-8?B?TGhFUmhMWjVVTGpJZ3FlSmFzTDZIUFJhckV4ZXNWaFJ4bjlVK2psSEF4eWFJ?=
 =?utf-8?B?WTZxdHREazdWNWNnZnVyeUl6S1MwRmdySTlvc21NWWVUakdRVTBBUkluVi9I?=
 =?utf-8?B?NHVMRFZWaVhDcWZUSm83OFVCcjFYeXdnRHlQUXZyNVRKNUZ6UWRmSS9TZTVK?=
 =?utf-8?B?M3FKQ1RGTThLck9LM2FIaFpSeElod3NTZGc3ZDJlRnB3WmpVd0QwSWhLME1t?=
 =?utf-8?B?c3JLVkFSdEVRYVRDSE5nQ2Z4Wk1jZjgydkFlV05FbTg0Q1g4Q0RtRDduQlRI?=
 =?utf-8?B?UXJJV3M5cDRKM3FCVTJxRE9leUZqMUZPaUJzNVlGUTZsdnZHSE40cEN0ZDFG?=
 =?utf-8?B?bFZmd2lXdVNPbUNkaSsxNExYVWEzVjQ2RFN2NGdvK3dXVkUwZzE5ZFp6Wk9X?=
 =?utf-8?B?QVNVNnFyQm5tSFZzWWViaHNTRHNhN29vbngwNHp3OXk0YTRjTlFXcFVNRVhk?=
 =?utf-8?B?dTl6TDErWm03Zm5laUZqVHRxY1Z2dmZFUGlDN2NaaEJWQU1rZCtocWFTYWpz?=
 =?utf-8?B?Q3V3MFFFd0NENE5YZDY4azI4MjdLazBnNU5lT2hXdkxVdk9xV1U4UUNDOGl0?=
 =?utf-8?B?ZlNPMXA1a296VDVkSWV2V0U3SjNzekpGLytlQ281SHVRbUJ5RUJ3M3N6VnFP?=
 =?utf-8?B?YTVHQldIekVzeHpZR3NCSWV2L0JrbzF1YkV2eS9VS1duM1NiUzFrTW92MTl0?=
 =?utf-8?B?VVFMTHR1THFac2JNN0pBNFp5dWJSYlA5NWRhQjczZlg1WngzcVEzWXBZNGFu?=
 =?utf-8?B?WWNHZDYrWGZpZ0JSLzFPWDh6a0ptVHhUUDFvTTIrN1VQa0FQME9BSVRMczRo?=
 =?utf-8?B?ekxma3dZOC94Y1Nlb0pGNzIyTkI4NzNpUWF0a0hUOEFPaXVoMmhaKzVSUHJa?=
 =?utf-8?B?UEtRYXcyeDZSbGtvbUVKa1I5eVFVemJQek1heTluQjRiZG5iMFBUT0N2T1lz?=
 =?utf-8?B?K0lWbHZFSnhoWk5mMWo0OUdvTGhCVDFZWEJIQVk4UVlJTkovTkZuYW1YUjQ2?=
 =?utf-8?B?K1pUQkxqd2lXR0RvSzVnZXFJTnpnV0dLY0RzR3haTlY1NGFMYkRUZXZMcTc2?=
 =?utf-8?B?YXNUQUpQMWlRTEFjMDJDZUhrcW95U1pFU2NzM2RNM1Z0bkYzVDJvWGM4dUtz?=
 =?utf-8?B?VjZXdHRRVUg3Y3Zva0lxR1BIK25QL3JmTmdlSXM1NjdCenc0S1FXVG9VTFhm?=
 =?utf-8?B?QUFZZmdvNFNORllOM09ON0x3d3hqL1h5UE1YSHZnSHlYYUd3a3FmTytsYXZn?=
 =?utf-8?B?aG9VMlNwVUlBdGpkVjZ2TnZWY2c0OEdtL1B5UGJVVzVwaWEyOWNCL3k0UUZE?=
 =?utf-8?B?Ukh5WitMVDVyb1p0NFBsWEFPUHZPR3RzalpCaUtYRkdTMDhRMWoyVjdDa2py?=
 =?utf-8?B?bnI3SE5LK2lsZWV5cnZ6QjZOY0FtL25MakRRbktUaXZxTkNIMWx1Mk1NTDRJ?=
 =?utf-8?B?YURNa3pySXRjTndmS1BzNVZUSWhKZkxBdUdaVWMzNHJoZWN0a0RLMmpXVlVj?=
 =?utf-8?B?VlhPbTk1SDAyQzkzc01Vd2MyNlBXNFd1MFRYcks1WmJrMDVMbXdKeXVSY0tj?=
 =?utf-8?B?eFY4V2pUd3A4Q0hFMmg0QTJFaVlOTUhGR3JVT0VFaDczaU5ZNDJydEIyZXpU?=
 =?utf-8?B?eThGREZTbWZmNHJZOUo2Znl4SjFCN0lqM0p3TmxBak5WNnBJY1plWFVIOG9o?=
 =?utf-8?B?QkFTdVQvVFdyYTRzenZjQXRRYmlUR3VKdE01UjFwSTl2ZU5pYkhKWWtPOGUw?=
 =?utf-8?B?WjJoRURNSTBuVXRXN0lDdWxTMEgxWHlYeDE0OGRzellnMFl5QzViOGlYNGxm?=
 =?utf-8?Q?lJKcofpaw1Ta/RiU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E821017E70C92B45B37D0F1FF3CC6EB0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: TFheWQkKzakCM8xFrs/Z2mFgxww8Gl0ftW83hyjZkAAe4Y6Pbx/jlrLKq5nhA/bzR8V4lObNKwNj0t1PXVskH3zhFNItAxfQtl7QkYzRWoNpIFzONB05v4bHAKOKmPHrqeHAb8zK1Y2I1SquGzNYGIsTA8JSnp6YbSFLPhkcPIM6FzaJODHybKvzmBTE3zVaTiqEPLvDit6KrKIAH5IAdGfRvZ2M09iTmD1ZR0R7Y2A6B/WsOCHDj/7TaPq790Pwdg/tC55okchX4+88eHL1zw2XOb6/sfPpABSKl+R4Rf7YiDIoO6ee1hYca2okXwPm2RrRgIRXBvV0HOV8tqlnIw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1053bed0-fb10-4ab1-bb8d-08de73a2de4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 12:47:28.4625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JBL0KSd2W/19idMoJnH8rIQl9qHMryeGfbWWjEj4d1LZiDGADa21Rm+0pldaZivgHeaRqGH9OUd5hukdRaZ64w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6470
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IMKgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8IDk5ICsrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0NCj4gLS0tLS0tLS0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA0
MyBpbnNlcnRpb25zKCspLCA1NiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1l
ZGlhdGVrLmMNCj4gaW5kZXggZWNmMTZlODJhMzI2Li4yYjFmMjZiNTU3ODIgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gKysrIGIvZHJpdmVycy91ZnMv
aG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiBAQCAtMTkyLDggKzE5Miw4IEBAIHN0YXRpYyB2b2lkIHVm
c19tdGtfY3J5cHRvX2VuYWJsZShzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiDCoA0KPiDCoAl1
ZnNfbXRrX2NyeXB0b19jdHJsKHJlcywgMSk7DQo+IMKgCWlmIChyZXMuYTApIHsNCj4gLQkJZGV2
X2luZm8oaGJhLT5kZXYsICIlczogY3J5cHRvIGVuYWJsZSBmYWlsZWQsIGVycjoNCj4gJWx1XG4i
LA0KPiAtCQkJIF9fZnVuY19fLCByZXMuYTApOw0KPiArCQlkZXZfZXJyKGhiYS0+ZGV2LCAiJXM6
IGNyeXB0byBlbmFibGUgZmFpbGVkIHdpdGgNCj4gZXJyb3IgJWx1LCBkaXNhYmxpbmdcbiIsDQo+
ICsJCQlfX2Z1bmNfXywgcmVzLmEwKTsNCj4gwqAJCWhiYS0+Y2FwcyAmPSB+VUZTSENEX0NBUF9D
UllQVE87DQo+IMKgCX0NCj4gwqB9DQo+IEBAIC01NDIsNDAgKzU0MiwzOCBAQCBzdGF0aWMgdm9p
ZCB1ZnNfbXRrX2Jvb3N0X2NyeXB0KHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGJvb2wgYm9vc3Qp
DQo+IMKgDQo+IMKgCXJldCA9IGNsa19wcmVwYXJlX2VuYWJsZShjZmctPmNsa19jcnlwdF9tdXgp
Ow0KPiDCoAlpZiAocmV0KSB7DQo+IC0JCWRldl9pbmZvKGhiYS0+ZGV2LCAiY2xrX3ByZXBhcmVf
ZW5hYmxlKCk6ICVkXG4iLA0KPiAtCQkJIHJldCk7DQo+ICsJCWRldl9lcnIoaGJhLT5kZXYsICIl
czogRmFpbGVkIHRvIGVuYWJsZQ0KPiBjbGtfY3J5cHRfbXV4OiAlcGVcbiIsDQo+ICsJCQlfX2Z1
bmNfXywgRVJSX1BUUihyZXQpKTsNCj4gwqAJCXJldHVybjsNCj4gwqAJfQ0KPiDCoA0KPiDCoAlp
ZiAoYm9vc3QpIHsNCj4gwqAJCXJldCA9IHJlZ3VsYXRvcl9zZXRfdm9sdGFnZShyZWcsIHZvbHQs
IElOVF9NQVgpOw0KPiDCoAkJaWYgKHJldCkgew0KPiAtCQkJZGV2X2luZm8oaGJhLT5kZXYsDQo+
IC0JCQkJICJmYWlsZWQgdG8gc2V0IHZjb3JlIHRvICVkXG4iLA0KPiB2b2x0KTsNCj4gKwkJCWRl
dl9lcnIoaGJhLT5kZXYsICIlczogRmFpbGVkIHRvIHNldCB2Y29yZQ0KPiB0byAlZDogJXBlXG4i
LA0KPiArCQkJCV9fZnVuY19fLCB2b2x0LCBFUlJfUFRSKHJldCkpOw0KPiDCoAkJCWdvdG8gb3V0
Ow0KPiDCoAkJfQ0KPiDCoA0KPiAtCQlyZXQgPSBjbGtfc2V0X3BhcmVudChjZmctPmNsa19jcnlw
dF9tdXgsDQo+IC0JCQkJwqDCoMKgwqAgY2ZnLT5jbGtfY3J5cHRfcGVyZik7DQo+ICsJCXJldCA9
IGNsa19zZXRfcGFyZW50KGNmZy0+Y2xrX2NyeXB0X211eCwgY2ZnLQ0KPiA+Y2xrX2NyeXB0X3Bl
cmYpOw0KPiDCoAkJaWYgKHJldCkgew0KPiAtCQkJZGV2X2luZm8oaGJhLT5kZXYsDQo+IC0JCQkJ
ICJmYWlsZWQgdG8gc2V0IGNsa19jcnlwdF9wZXJmXG4iKTsNCj4gKwkJCWRldl9lcnIoaGJhLT5k
ZXYsICIlczogRmFpbGVkIHRvIHJlcGFyZW50DQo+IGNsa19jcnlwdF9wZXJmOiAlcGVcbiIsDQo+
ICsJCQkJX19mdW5jX18sIEVSUl9QVFIocmV0KSk7DQo+IMKgCQkJcmVndWxhdG9yX3NldF92b2x0
YWdlKHJlZywgMCwgSU5UX01BWCk7DQo+IMKgCQkJZ290byBvdXQ7DQo+IMKgCQl9DQo+IMKgCX0g
ZWxzZSB7DQo+IC0JCXJldCA9IGNsa19zZXRfcGFyZW50KGNmZy0+Y2xrX2NyeXB0X211eCwNCj4g
LQkJCQnCoMKgwqDCoCBjZmctPmNsa19jcnlwdF9scCk7DQo+ICsJCXJldCA9IGNsa19zZXRfcGFy
ZW50KGNmZy0+Y2xrX2NyeXB0X211eCwgY2ZnLQ0KPiA+Y2xrX2NyeXB0X2xwKTsNCj4gwqAJCWlm
IChyZXQpIHsNCj4gLQkJCWRldl9pbmZvKGhiYS0+ZGV2LA0KPiAtCQkJCSAiZmFpbGVkIHRvIHNl
dCBjbGtfY3J5cHRfbHBcbiIpOw0KPiArCQkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBGYWlsZWQg
dG8gcmVwYXJlbnQNCj4gY2xrX2NyeXB0X2xwOiAlcGVcbiIsDQo+ICsJCQkJX19mdW5jX18sIEVS
Ul9QVFIocmV0KSk7DQo+IMKgCQkJZ290byBvdXQ7DQo+IMKgCQl9DQo+IMKgDQo+IMKgCQlyZXQg
PSByZWd1bGF0b3Jfc2V0X3ZvbHRhZ2UocmVnLCAwLCBJTlRfTUFYKTsNCj4gwqAJCWlmIChyZXQp
IHsNCj4gLQkJCWRldl9pbmZvKGhiYS0+ZGV2LA0KPiAtCQkJCSAiZmFpbGVkIHRvIHNldCB2Y29y
ZSB0byBNSU5cbiIpOw0KPiArCQkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBGYWlsZWQgdG8gc2V0
IHZjb3JlDQo+IHRvIG1pbmltdW06ICVwZVxuIiwNCj4gKwkJCQlfX2Z1bmNfXywgRVJSX1BUUihy
ZXQpKTsNCj4gwqAJCX0NCj4gwqAJfQ0KPiDCoG91dDoNCj4gQEAgLTc2MywxMCArNzYxLDggQEAg
c3RhdGljIGludCB1ZnNfbXRrX3NldHVwX2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBi
b29sIG9uLA0KPiDCoAkJaWYgKGNsa19wd3Jfb2ZmKSB7DQo+IMKgCQkJdWZzX210a19wd3JfY3Ry
bChoYmEsIGZhbHNlKTsNCj4gwqAJCX0gZWxzZSB7DQo+IC0JCQlkZXZfd2FybihoYmEtPmRldiwg
IkNsb2NrIGlzIG5vdCB0dXJuZWQgb2ZmLA0KPiBoYmEtPmFoaXQgPSAweCV4LCBBSElUID0gMHgl
eFxuIiwNCj4gLQkJCQloYmEtPmFoaXQsDQo+IC0JCQkJdWZzaGNkX3JlYWRsKGhiYSwNCj4gLQ0K
PiAJCQkJCVJFR19BVVRPX0hJQkVSTkFURV9JRExFX1RJTUVSKSk7DQo+ICsJCQlkZXZfd2Fybiho
YmEtPmRldiwgIkNsb2NrIGlzbid0IG9mZiwgaGJhLQ0KPiA+YWhpdCA9IDB4JXgsIEFISVQgPSAw
eCV4XG4iLA0KPiArCQkJCSBoYmEtPmFoaXQsIHVmc2hjZF9yZWFkbChoYmEsDQo+IFJFR19BVVRP
X0hJQkVSTkFURV9JRExFX1RJTUVSKSk7DQo+IMKgCQl9DQo+IMKgCQl1ZnNfbXRrX21jcV9kaXNh
YmxlX2lycShoYmEpOw0KPiDCoAl9IGVsc2UgaWYgKG9uICYmIHN0YXR1cyA9PSBQT1NUX0NIQU5H
RSkgew0KPiBAQCAtODEwLDExICs4MDYsMTEgQEAgc3RhdGljIHZvaWQgdWZzX210a19tY3Ffc2V0
X2lycV9hZmZpbml0eShzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhLCB1bnNpZ25lZCBpbnQgY3B1KQ0K
PiDCoAlfY3B1ID0gKGNwdSA9PSAwKSA/IDMgOiBjcHU7DQo+IMKgCXJldCA9IGlycV9zZXRfYWZm
aW5pdHkoaXJxLCBjcHVtYXNrX29mKF9jcHUpKTsNCj4gwqAJaWYgKHJldCkgew0KPiAtCQlkZXZf
ZXJyKGhiYS0+ZGV2LCAic2V0IGlycSAlZCBhZmZpbml0eSB0byBDUFUgJWQNCj4gZmFpbGVkXG4i
LA0KPiArCQlkZXZfZXJyKGhiYS0+ZGV2LCAic2V0dGluZyBpcnEgJWQgYWZmaW5pdHkgdG8gQ1BV
ICVkDQo+IGZhaWxlZFxuIiwNCj4gwqAJCQlpcnEsIF9jcHUpOw0KPiDCoAkJcmV0dXJuOw0KPiDC
oAl9DQo+IC0JZGV2X2luZm8oaGJhLT5kZXYsICJzZXQgaXJxICVkIGFmZmluaXR5IHRvIENQVTog
JWRcbiIsIGlycSwNCj4gX2NwdSk7DQo+ICsJZGV2X2RiZyhoYmEtPmRldiwgInNldCBpcnEgJWQg
YWZmaW5pdHkgdG8gQ1BVICVkXG4iLCBpcnEsDQo+IF9jcHUpOw0KPiANCg0KSXMgaXQgbW9yZSBh
cHByb3ByaWF0ZSB0byB1c2UgZGV2X2luZm8gZm9yIHN0YXRlIGNoYW5nZXMgb3IgZm9yIHNldHRp
bmcNCmNoYW5nZXM/DQoNCj4gwqB9DQo+IMKgDQo+IMKgc3RhdGljIGJvb2wgdWZzX210a19pc19s
ZWdhY3lfY2hpcHNldChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1MzINCj4gaHdfaXBfdmVyKQ0KPiBA
QCAtODMwLDcgKzgyNiw4IEBAIHN0YXRpYyBib29sIHVmc19tdGtfaXNfbGVnYWN5X2NoaXBzZXQo
c3RydWN0DQo+IHVmc19oYmEgKmhiYSwgdTMyIGh3X2lwX3ZlcikNCj4gwqAJZGVmYXVsdDoNCj4g
wqAJCWJyZWFrOw0KPiDCoAl9DQo+IC0JZGV2X2luZm8oaGJhLT5kZXYsICJsZWdhY3kgSVAgdmVy
c2lvbiAtIDB4JXgsIGlzIGxlZ2FjeSA6DQo+ICVkIiwgaHdfaXBfdmVyLCBpc19sZWdhY3kpOw0K
PiArCWRldl9kYmcoaGJhLT5kZXYsICJJUCB2ZXJzaW9uIDB4JXgsIGxlZ2FjeSA9ICVzIiwgaHdf
aXBfdmVyLA0KPiArCQlzdHJfdHJ1ZV9mYWxzZShpc19sZWdhY3kpKTsNCj4gwqANCj4gwqAJcmV0
dXJuIGlzX2xlZ2FjeTsNCj4gwqB9DQo+IEBAIC05MzUsMTUgKzkzMiwxMiBAQCBzdGF0aWMgdm9p
ZCB1ZnNfbXRrX2luaXRfY2xvY2tzKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEpDQo+IMKgCQl9DQo+
IMKgCX0NCj4gwqANCj4gLQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNsa2ksIGhlYWQsIGxpc3QpIHsN
Cj4gLQkJZGV2X2luZm8oaGJhLT5kZXYsICJjbGsgXCIlc1wiIHByZXNlbnQiLCBjbGtpLQ0KPiA+
bmFtZSk7DQo+IC0JfQ0KPiArCWxpc3RfZm9yX2VhY2hfZW50cnkoY2xraSwgaGVhZCwgbGlzdCkN
Cj4gKwkJZGV2X2RiZyhoYmEtPmRldiwgImNsayBcIiVzXCIgcHJlc2VudCIsIGNsa2ktPm5hbWUp
Ow0KPiDCoA0KPiDCoAlpZiAoIXVmc19tdGtfaXNfY2xrX3NjYWxlX3JlYWR5KGhiYSkpIHsNCj4g
wqAJCWhiYS0+Y2FwcyAmPSB+VUZTSENEX0NBUF9DTEtfU0NBTElORzsNCj4gLQkJZGV2X2luZm8o
aGJhLT5kZXYsDQo+IC0JCQkgIiVzOiBDbGstc2NhbGluZyBub3QgcmVhZHkuIEZlYXR1cmUNCj4g
ZGlzYWJsZWQuIiwNCj4gLQkJCSBfX2Z1bmNfXyk7DQo+ICsJCWRldl9pbmZvKGhiYS0+ZGV2LCAi
JXM6IENsb2NrIHNjYWxpbmcgdW5hdmFpbGFibGUiLA0KPiBfX2Z1bmNfXyk7DQo+IMKgCQlyZXR1
cm47DQo+IMKgCX0NCj4gwqANCj4gQEAgLTk1Myw4ICs5NDcsOCBAQCBzdGF0aWMgdm9pZCB1ZnNf
bXRrX2luaXRfY2xvY2tzKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEpDQo+IMKgCSAqLw0KPiDCoAly
ZWcgPSBkZXZtX3JlZ3VsYXRvcl9nZXRfb3B0aW9uYWwoZGV2LCAiZHZmc3JjLXZjb3JlIik7DQo+
IMKgCWlmIChJU19FUlIocmVnKSkgew0KPiAtCQlkZXZfaW5mbyhkZXYsICJmYWlsZWQgdG8gZ2V0
IGR2ZnNyYy12Y29yZTogJWxkIiwNCj4gLQkJCSBQVFJfRVJSKHJlZykpOw0KPiArCQlpZiAoUFRS
X0VSUihyZWcpICE9IC1FTk9ERVYpDQo+ICsJCQlkZXZfZXJyKGRldiwgIkZhaWxlZCB0byBnZXQg
ZHZmc3JjLXZjb3JlOg0KPiAlcGVcbiIsIHJlZyk7DQo+IMKgCQlyZXR1cm47DQo+IMKgCX0NCj4g
wqANCj4gQEAgLTk2OCwxMiArOTYyLDkgQEAgc3RhdGljIHZvaWQgdWZzX210a19pbml0X2Nsb2Nr
cyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiDCoAlob3N0LT5tY2xrLnZjb3JlX3ZvbHQgPSB2
b2x0Ow0KPiDCoA0KPiDCoAkvKiBJZiBkZWZhdWx0IGJvb3QgaXMgbWF4IGdlYXIsIHJlcXVlc3Qg
dmNvcmUgKi8NCj4gLQlpZiAocmVnICYmIHZvbHQgJiYgaG9zdC0+Y2xrX3NjYWxlX3VwKSB7DQo+
IC0JCWlmIChyZWd1bGF0b3Jfc2V0X3ZvbHRhZ2UocmVnLCB2b2x0LCBJTlRfTUFYKSkgew0KPiAt
CQkJZGV2X2luZm8oaGJhLT5kZXYsDQo+IC0JCQkJIkZhaWxlZCB0byBzZXQgdmNvcmUgdG8gJWRc
biIsDQo+IHZvbHQpOw0KPiAtCQl9DQo+IC0JfQ0KPiArCWlmIChyZWcgJiYgdm9sdCAmJiBob3N0
LT5jbGtfc2NhbGVfdXApDQo+ICsJCWlmIChyZWd1bGF0b3Jfc2V0X3ZvbHRhZ2UocmVnLCB2b2x0
LCBJTlRfTUFYKSkNCj4gKwkJCWRldl9lcnIoaGJhLT5kZXYsICJGYWlsZWQgdG8gc2V0IHZjb3Jl
IHRvDQo+ICVkXG4iLCB2b2x0KTsNCj4gwqB9DQo+IMKgDQo+IMKgc3RhdGljIHZvaWQgdWZzX210
a19zZXR1cF9jbGtfZ2F0aW5nKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+IEBAIC0xMDYwLDcgKzEw
NTEsNyBAQCBzdGF0aWMgdm9pZCB1ZnNfbXRrX2luaXRfbWNxX2lycShzdHJ1Y3QgdWZzX2hiYQ0K
PiAqaGJhKQ0KPiDCoAkJfQ0KPiDCoAkJaG9zdC0+bWNxX2ludHJfaW5mb1tpXS5oYmEgPSBoYmE7
DQo+IMKgCQlob3N0LT5tY3FfaW50cl9pbmZvW2ldLmlycSA9IGlycTsNCj4gLQkJZGV2X2luZm8o
aGJhLT5kZXYsICJnZXQgcGxhdGZvcm0gbWNxIGlycTogJWQsICVkXG4iLA0KPiBpLCBpcnEpOw0K
PiArCQlkZXZfZGJnKGhiYS0+ZGV2LCAiZ2V0IHBsYXRmb3JtIG1jcSBpcnE6ICVkLCAlZFxuIiwN
Cj4gaSwgaXJxKTsNCj4gwqAJfQ0KPiDCoA0KPiDCoAlyZXR1cm47DQo+IEBAIC0xMzA3LDEwICsx
Mjk4LDggQEAgc3RhdGljIGludCB1ZnNfbXRrX3ByZV9wd3JfY2hhbmdlKHN0cnVjdA0KPiB1ZnNf
aGJhICpoYmEsDQo+IMKgCQlob3N0X3BhcmFtcy5kZXNpcmVkX3dvcmtpbmdfbW9kZSA9IFVGU19Q
V01fTU9ERTsNCj4gwqANCj4gwqAJcmV0ID0gdWZzaGNkX25lZ290aWF0ZV9wd3JfcGFyYW1zKCZo
b3N0X3BhcmFtcywNCj4gZGV2X21heF9wYXJhbXMsIGRldl9yZXFfcGFyYW1zKTsNCj4gLQlpZiAo
cmV0KSB7DQo+IC0JCXByX2luZm8oIiVzOiBmYWlsZWQgdG8gZGV0ZXJtaW5lIGNhcGFiaWxpdGll
c1xuIiwNCj4gLQkJCV9fZnVuY19fKTsNCj4gLQl9DQo+ICsJaWYgKHJldCkNCj4gKwkJZGV2X3dh
cm4oaGJhLT5kZXYsICIlczogZmFpbGVkIHRvIGRldGVybWluZQ0KPiBjYXBhYmlsaXRpZXNcbiIs
IF9fZnVuY19fKTsNCj4gwqANCj4gwqAJaWYgKHVmc19tdGtfcG1jX3ZpYV9mYXN0YXV0byhoYmEs
IGRldl9yZXFfcGFyYW1zKSkgew0KPiDCoAkJdWZzX210a19hZGp1c3Rfc3luY19sZW5ndGgoaGJh
KTsNCj4gQEAgLTEzNTYsMTAgKzEzNDUsOSBAQCBzdGF0aWMgaW50IHVmc19tdGtfcHJlX3B3cl9j
aGFuZ2Uoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwNCj4gwqAJCXJldCA9IHVmc2hjZF91aWNfY2hh
bmdlX3B3cl9tb2RlKGhiYSwNCj4gwqAJCQkJCUZBU1RBVVRPX01PREUgPDwgNCB8DQo+IEZBU1RB
VVRPX01PREUpOw0KPiDCoA0KPiAtCQlpZiAocmV0KSB7DQo+IC0JCQlkZXZfZXJyKGhiYS0+ZGV2
LCAiJXM6IEhTRzFCIEZBU1RBVVRPIGZhaWxlZA0KPiByZXQ9JWRcbiIsDQo+IC0JCQkJX19mdW5j
X18sIHJldCk7DQo+IC0JCX0NCj4gKwkJaWYgKHJldCkNCj4gKwkJCWRldl9lcnIoaGJhLT5kZXYs
ICIlczogSFNHMUIgRkFTVEFVVE8NCj4gZmFpbGVkOiAlcGVcbiIsDQo+ICsJCQkJX19mdW5jX18s
IEVSUl9QVFIocmV0KSk7DQo+IMKgCX0NCj4gwqANCj4gwqAJLyogaWYgYWxyZWFkeSBjb25maWd1
cmVkIHRvIHRoZSByZXF1ZXN0ZWQgcHdyX21vZGUsIHNraXANCj4gYWRhcHQgKi8NCj4gQEAgLTE0
MDksNyArMTM5Nyw3IEBAIHN0YXRpYyBpbnQgdWZzX210a19hdXRvX2hpYmVybjhfZGlzYWJsZShz
dHJ1Y3QNCj4gdWZzX2hiYSAqaGJhKQ0KPiDCoA0KPiDCoG91dDoNCj4gwqAJaWYgKHJldCkgew0K
PiAtCQlkZXZfd2FybihoYmEtPmRldiwgImV4aXQgaDggc3RhdGUgZmFpbCwgcmV0PSVkXG4iLA0K
PiByZXQpOw0KPiArCQlkZXZfZXJyKGhiYS0+ZGV2LCAiRmFpbGVkIHRvIGV4aXQgaDggc3RhdGU6
ICVwZVxuIiwNCj4gRVJSX1BUUihyZXQpKTsNCj4gwqANCj4gwqAJCXVmc2hjZF9mb3JjZV9lcnJv
cl9yZWNvdmVyeShoYmEpOw0KPiDCoA0KPiBAQCAtMTU3MSw3ICsxNTU5LDcgQEAgc3RhdGljIGlu
dCB1ZnNfbXRrX2RldmljZV9yZXNldChzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiDCoAkvKiBT
b21lIGRldmljZXMgbWF5IG5lZWQgdGltZSB0byByZXNwb25kIHRvIHJzdF9uICovDQo+IMKgCXVz
bGVlcF9yYW5nZSgxMDAwMCwgMTUwMDApOw0KPiDCoA0KPiAtCWRldl9pbmZvKGhiYS0+ZGV2LCAi
ZGV2aWNlIHJlc2V0IGRvbmVcbiIpOw0KPiArCWRldl9kYmcoaGJhLT5kZXYsICJkZXZpY2UgcmVz
ZXQgZG9uZVxuIik7DQo+IMKgDQoNCklzIGl0IG1vcmUgYXBwcm9wcmlhdGUgdG8gdXNlIGRldl9p
bmZvIGZvciBzdGF0ZSBjaGFuZ2VzIG9yIGZvciBzZXR0aW5nDQpjaGFuZ2VzPw0KDQoNClRoYW5r
cw0KUGV0ZXINCg==
