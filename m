Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83081288C3F;
	Wed, 25 Feb 2026 10:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015806; cv=fail; b=dV8IHTPlnjOBvB0vMZ4gAQHfTFfae5Dze4ZFLLOetLRDRwMIdV7Ot1NvgFPvoCwjzt6iLNlyZj5PJLe9dGg+opg/l6DCiPs+SJvfUAlGsKPCb9dBsqU661md1ry7UblDSe1E2bDFAI+GrNGUi08kbYj8ULv7fzlNhoq2DwFE1ww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015806; c=relaxed/simple;
	bh=56UCpyQjpViK1BgMTElb6L6zXVinACCE3qolBTCHvBY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AxEUpBReGYpzTUy/b7/xG55exlBn6SY725QftG6ue7auHyhlxuukyzC1mbRdaQWsPJ2AsKtrnD+SQEJ+f/i34DoPXHLUnIv//b6FXik58NHzIElxQV81KXyNlvf+9zIM2HsVMpViP8E7Ij1msWWoyiB+fv3lBi7cxBLQjEUI0qQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EFIK4WBj; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=KjRfay3n; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EFIK4WBj";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="KjRfay3n"
X-UUID: dea8391e123511f1b7fc4fdb8733b2bc-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=56UCpyQjpViK1BgMTElb6L6zXVinACCE3qolBTCHvBY=;
	b=EFIK4WBjVenYKc3XPXg/K64AJ0TxASKXzY16XE9y/JNxoHHJ8OEaIEnXzHcxViupKJmL05lOSaqFsE5ADxVnxEtKc7GGvoC1Co4layL+2WskI6K0FZaRuQo9i6O9yNLadryKjqiqB75gSGTTSMTvPgK1t4a1R9zcyV3o+U9E5dA=;
X-CID-CACHE: Type:Local,Time:202602251836+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:9b2f61a1-c043-49d2-bf39-9305b2ad91b9,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:ad97417b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dea8391e123511f1b7fc4fdb8733b2bc-20260225
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1507607263; Wed, 25 Feb 2026 18:36:40 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 18:36:39 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 18:36:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EJSNw9l63ww8mEQrulLwJjWVkIQWKFx+hdAIgnLCNff+NMYOVwn5DNSQ1+z9GMVCBUjBCZ3Xa/kXUQYkH7vvxin4HgB2tRHA/DYS8JxFnn1I8MFZlwsAAs9RSmIACW5vuM9R/vz7OW0J0jOXN6aEzrs6w86NzSmdHe+Gvok+xXuMViM+s453aASiBhOqSBIQIDl14b99RXRfIKL0Cy+p1SXm53QpmlSyvuT2jJWTP80Iaslc4ajhhSsMh7wYCXOdlqKuY1AVR6VTd3bSaRRkw/NgyEw7u7sbIuyRvhfTyBSSIUS0ye/BWgh5rtZwAdlICerRwr8ylXKNmhtNmSwVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56UCpyQjpViK1BgMTElb6L6zXVinACCE3qolBTCHvBY=;
 b=g3igt35JRtIUdAEpe86Kb5Gjc5GJvanzg4V9KRtAZ9X3Fu5gSoz4GTAHg5NFFYN+ZSFz5r/ntEkuh5hbt1V0myDkWPFIjP78jN+h7o5WQEEuMLoRiBXDzmMs9c9z1oC/jANmskUanCCJMSl3xTAYcjvIDvoDZaHwVecEx/u0vT6ovyIjNfHTnjTZLvSBA/CMqGXvMr1ySuB+uUBQ+EcG1lFOldi6kRO4GRQC0QkKUbct6b0HwUCr/UZVdIg6fvwrtNILa2PhA7CxmKX+dcOLGRSbUAa9ZcDM0DeVHheRjtWZZoZFXiV7MMZKf4IDbQlz/d6qFPixph3PMjs1OoH53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56UCpyQjpViK1BgMTElb6L6zXVinACCE3qolBTCHvBY=;
 b=KjRfay3n5EJSbnohIsVLC/y/1lLF+OQgQ2x1ICp2z4uZAnfb6SOZC0rOFnJ80V6gTCOZwfSk26aBNfgnuu3qCHpPGx+Oyw1YlRb5rr+eNGz+FkJ9CmRNd/H7dWtBlwu/eAiV5NwLE+L/BNmLgBiOU72qHly7wisAlm7LTmvSyiU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8472.apcprd03.prod.outlook.com (2603:1096:101:21c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 10:36:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 10:36:33 +0000
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
Subject: Re: [PATCH v7 21/23] scsi: ufs: mediatek: Remove ret local from
 link_startup_notify
Thread-Topic: [PATCH v7 21/23] scsi: ufs: mediatek: Remove ret local from
 link_startup_notify
Thread-Index: AQHcn0oOgA4PDoB8VEG5CRK2/ZVimrWTRqIA
Date: Wed, 25 Feb 2026 10:36:33 +0000
Message-ID: <cab1bc1b72d6a367de69d713c82426f9e6024dfd.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-21-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-21-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8472:EE_
x-ms-office365-filtering-correlation-id: 28ac2e61-41f6-4c4d-2e79-08de7459bed3
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021;
x-microsoft-antispam-message-info: 1aQQOCq2b5t8laSNE55d11h5bPu3At3LWR2c+U9tBUbTzImv9+7ubfdtF2v691zwy0ZAWVOz/rPGgNw7KiBVGbPTQYQOKmux3d5Quka92nk+r3Iq1uVmtTsp2l0kSF+Vu8tsrRXz3Lr6PMn0VOAEARrb/h3hZ1tWsKSZNqA3D4GNdbGvLZIojwTCSpysWjx2QoCCcaIkKD5y4hwer1A5yXwwrkHN6gxskm75bUOTkrZW0eb2nRY6jZ/maa5Z7ScSFEF9UZEBTVQbJVxYaQ+v9IEYxiv3OfCvLXy3gBs8Yy+YY5drgt+ztGnEqk+ggGwgDp7Cr1/GXhnS3QzfE1thGooZ1/GI4R+XMjn9gJkIk565zsna80c57SfPCx5NDRCze44dcHQILA5fZmTl0tjSpI6NuI2Nl/2nqezCg97HZZAHnNvCQCHvPt+ky0hLd3oGIu+waLWF0D4jaPnkRvbPN5Q0JCSH1IXW7gm/uNd0n1dfMX8ItnqoGfyPxtDkKKoDnW+wJk8MqnH0PnTwtTcahBU701bcjMohfIuhRfPi9u/D9zJcU0QAIMYFUjrMVpYx17jhPKlxHc3FfJ0nTrJ7sJm9zcAfrfZL3GPkG2ifgfWjkjL1af9cAhL918Jdx7C7oPxGtFI/WZDmnKnFQhFcIra/0oiXfC0ScsfO6I5bQnrz6LaGFvoddG1XT9g5p0f1hogHaQl23WFd/4rX1EZ2iuGtSec/gV/J8MQCjAF2EYzGyd77RajIY3QIigh8MS1fzW8lxnJuNBuxgeSRjP81sdMvW4uobubaurZ5LYqOcLwLu3bPYtih/JVix5ci18Wv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXNiU1dTK09ZOU1Ba2hrdWF6WEtsdUNOUWUyQXJjbWRNK05yR1JTUWZtUHZS?=
 =?utf-8?B?MWZiN1hzaFZBcmxkZzB5YTJWK0JldmxoYXM3WnhxalRXZGIyRHlUeGF2MWhP?=
 =?utf-8?B?R3NmTDJsNERHY2o5V3NrMFdDN1hDeU5WaE5qb1hzUUhGeHh5RWs4V1pLbDZn?=
 =?utf-8?B?M0h6SXVtMEdNTUt6bE1NQ3l1UHFQTVZCNWxRR0ZSS2RpMDFGeWsrODhtQWcr?=
 =?utf-8?B?TDJXdHRHZzdnKzZCUWVRNnNBYWUveEhDSnpHbUl4UnM4dDlrem5hcWd0ZjRs?=
 =?utf-8?B?cGdYb2lXcks1a2luMVRNNmMwUEJNektwdTRBUUFERitwVUVlZXZyUHR5Q1V3?=
 =?utf-8?B?TFZYUWZkQjZoSTVSeHNlNDBYaVpsQ2FnWVgwQlB5cEtJUElrbW1wcDlNNmJ2?=
 =?utf-8?B?NHMxSXFwdU8xcitFdkhGRVpCdzg5VmZoUE1hUjMrS1FSRGFhV0xhdDNOKzJK?=
 =?utf-8?B?bUtGSGR0S0tpd1IwM2xPQWppcm1RMEEvMGh1M0ppNTJhSDUxWjhDUDJja1pi?=
 =?utf-8?B?ck5OL2lPYlJBdU4wcVdQRVIyZCtsOHpXM1lHYjVuVkYxVk5CZ01CVHZiUGJx?=
 =?utf-8?B?RTdlYi9jK3VLTnpWcHpIV0UzNENJWjBJUFBleFRSekRMdkJKSlEzMFpxaENV?=
 =?utf-8?B?enVnNm1ZckhER3c2ZjdzcC9wQ3hmSElQMHFxME5NKzVnY1FrcUJrSjRIdlJo?=
 =?utf-8?B?dFdBMTJGblorS3RObUY2aGRnbzFDNTl4b25BbnFIV29nZ0xIRlBXMXMvbmJr?=
 =?utf-8?B?SDM3RVlrZlYyU083L2JXb3BoNkJiNjhPN0E3Ty9YSG82UGNISUpwdEtQdXlz?=
 =?utf-8?B?QzI2d2lwaWxrejhQZU9tYkczUXZYWTVoNzVSbDZIL0gyVXA5Qm5EclJZK1Z2?=
 =?utf-8?B?NS9kTzkxWGZabFBybkpXMWg5UUdVMkhtb0JhMUJ3U0tFcVphdmYvU1Zua0k3?=
 =?utf-8?B?TVRWeHovTzZNSDIrdFl1L1ZObWRlUXFHTlA4ZXBiVG9TNnVMZzdsQURlRkNO?=
 =?utf-8?B?SlQ1Q1JMa2Z6RkVjOXo0aUV0aHJETlF3d29aQS80WnIzRmdBOTRsbVFEc0sy?=
 =?utf-8?B?QWI0cXg4Q1Zjc092Ym1Rb0JiVVIySHBFNi9iNHFoTkNhY0FiOGxQcnd3MWh0?=
 =?utf-8?B?a3FrOUhBOXRxeFIyNUNRK3FQOUxJTmVhcUhQV2Q3TmlUWUd1Y2VUMWdRK3Ax?=
 =?utf-8?B?T3pGNm1DRmF6YmRoWDJabFdGTjZtbXFCazZERS9oWER0cHFOZ3RvWmNBMFMv?=
 =?utf-8?B?TzhJS0pCdkFqTCtsdnBpZ2tHVlNkeExDSm1Pb0RVeFRmQUs0QzFNY1Z1cTRO?=
 =?utf-8?B?OEJCcU05QUI3a3E5UyszQ09sNG1CeXpZcnIvY1g4by96WU83d1FlUjlSYzZl?=
 =?utf-8?B?ZmZrT1UvbjhMK0M5VnBSVmxRTTIxSmlZK1hNWnBRT3I5VUZ3NFJjOExYNjZt?=
 =?utf-8?B?UGt3Rlk1TTdrTHVqdnNrWVBYckhiRFAyalNmSW1DYUJmOHNGVnlsVEZxVjFD?=
 =?utf-8?B?bDZpYUJhOE5ESDhGeUlaVDJEa3l4QTF2ZWp4Z0FEcmI0ZVE5T3FFamFPR3lr?=
 =?utf-8?B?RkN4N3RHck0rbExzV25xVXROSWhySUFuemc2YXVnZEtBSGdrL252MU9RRnFE?=
 =?utf-8?B?cklGdUEyYjNHVno3TmZIZjVRR0FWZ0UyU01xa2Q5UGlhWXNYTFJjdVc3MmZl?=
 =?utf-8?B?RmpabzNDUmxFN3dYekhOQjJ3TkEva2ZGVFdjUTZmbFRJd2pHRGhxRkdkT0pV?=
 =?utf-8?B?V2wrTXdEcXNpQVVKOG5ZNEc5d1BXRnkxQ0tsZFVGN201NTJDSkR4NmluVFgw?=
 =?utf-8?B?TC9Md21rZWhMSm5ZckRYVyswdkZXZElqQ3hCUS9MT3NQWlBVNmgvS0VhVDVw?=
 =?utf-8?B?dGRPd2xBNityMDUrbFhqYnNtYVhJZ2UyL1hWcGl0TksrQUVWTXFISW1YeFN1?=
 =?utf-8?B?Y2JCN240N2FLY2J5TkphSERzNTAwdWVtaTVzUWlUby9QbnlFakR5ZVMrK2c0?=
 =?utf-8?B?MDBaalA5NnErS0MzS0YyVlQ4c1lMRllqRzRTL1YyS1cxbjFDcU8zbVFiejhi?=
 =?utf-8?B?YUZENndKckFxaHlkY0pVYUs3MWZ1akJ1dGZvblFTdnBUbDVuZXZzZGpwYWRn?=
 =?utf-8?B?bzRVSytPTHAyYksrb2QzOVNjL3BRVjMyUkhhSEtFUGE5NzhUQnVldkdMYTQ0?=
 =?utf-8?B?eGNSdGk1cExHNngva2xzaE1aUC8vUE92T0pDb21GdjR2OXhCNHZsZlYrKzlM?=
 =?utf-8?B?YkZkVlVpdVUwSFVhcXdmZkN2aHQzMUI4TnhiM3JXbHFpcHdhQzRpWjcvVlc3?=
 =?utf-8?B?YTNrUnh2WXRKd2pRcTRta0JlRU1yYm1hSThvTHZob1FmcTBLNmpxVFI1ckpD?=
 =?utf-8?Q?EsxGjfv/d0qW62Pw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A3962534E5E1F48B840908E1E7A9833@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: bE8tQ0i2vG5TuWEu2RNB/AVPlFCUPumxDi6u3jniRDl41o6E8YZVH/E06CVhgaAqZEzKxeM8JTXNPge8BNGdugE6zXIwRTsR+jPTnj/UYnRvppsf7B4xylIXkqzBmjcFVlhvwdtg9+azI6JPaTocjCZ1RBkgxBqw4MZUTguUKafs0KUPEtM7K45/c1jerynkt7gUr4bnWwAj3ud1t3Pfy0VLBq0tqEdkjJyvj1W1C9fLuq4V747IRHW/zy1BZpIZ1OOSIvdqX0Gfx4DK8qfE5fj3XYtPxMMIXujbmXH6n6qlKkeIIy3rqJkRkHyDmNNyTrHR8HMuEwGqXJ3mHCIT6Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ac2e61-41f6-4c4d-2e79-08de7459bed3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 10:36:33.5379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8qWIQrt1R+m5pEFGize5eKBTv8IjnlVFjylSPPle/uzGSjm1MICmAsyX+66IRNkyoBepjk8PFW/poUzLkH4H2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8472
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFJlbW92ZSB0aGUgInJldCIgbG9jYWwgdmFyaWFibGUgZnJvbSB1ZnNfbXRrX2xpbmtf
c3RhcnR1cF9ub3RpZnksIGFzDQo+IGl0J3MgcG9pbnRsZXNzOyBpbiBhbGwgY2FzZXMgaXQgaXMg
YXNzaWduZWQsIGl0IGlzIHJldHVybmVkIHJpZ2h0DQo+IGFmdGVyDQo+IHdpdGhvdXQgYmVpbmcg
cmVhZCBmaXJzdC4NCj4gDQo+IFJld29yayB0aGUgY29kZSB0byBqdXN0IHJldHVybiBkaXJlY3Rs
eSwgYW5kIGdldCByaWQgb2YgdGhlIGRlZmF1bHQNCj4gYnJhbmNoIHdoaWxlIGF0IGl0Lg0KPiAN
Cj4gUmV2aWV3ZWQtYnk6IEFuZ2Vsb0dpb2FjY2hpbm8gRGVsIFJlZ25vDQo+IDxhbmdlbG9naW9h
Y2NoaW5vLmRlbHJlZ25vQGNvbGxhYm9yYS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMg
RnJhdHRhcm9saSA8bmljb2xhcy5mcmF0dGFyb2xpQGNvbGxhYm9yYS5jb20+DQoNClJldmlld2Vk
LWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
