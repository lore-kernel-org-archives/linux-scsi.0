Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06028345CBC;
	Thu, 11 Jun 2026 10:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781172681; cv=fail; b=NKlJ1KLhYfuFOmZfu7oXx1n2tMMOrZLpIlTHgN5u+FtzcfLDqov+/1v2hvlK2dyrWu/krBWuEBNphxO7vFArx7y1TcjNsb1trvym9JPdCF9vOa4ioNffoyj8jzaj3Yb8y7fXJaDYX0JWYK+iduPYhjTBD8D1v7+fuguZ6eyx+eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781172681; c=relaxed/simple;
	bh=FkJZjCsq0XJKkFqwWf72+UbaLESxdPD7nyekwoULC9Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E6NbKHyq3zQTtPo+U+gM7jJ0IIWPUK/Y463q65LgpmcBF92zbWdva2JXwYM2syz3Qc0Yb8lYUbZMht1Tmk4jkJwRgQHkrSADX1D1zvoIF74gUJ1K3pB7uVnPrrOpqt3vPOdMtS8VezbE046O6jsINlQz7VqPL2WjqlJRldMXKLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DbLcP35H; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=DCtxMuei; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DbLcP35H";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="DCtxMuei"
X-UUID: de050258657d11f1b1788b6acf885367-20260611
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=FkJZjCsq0XJKkFqwWf72+UbaLESxdPD7nyekwoULC9Y=;
	b=DbLcP35H0QdJGoXN0X1KtaUz34mMr6yruWJOHB6HuVMefs08g+tMrGo/A+/iN6IJIMQYzxQbZj/NvYqqfGyw2okslgjtzh13oV+5o7hkmiYafaT1eod1bGmap2FsEB8BYigbCZavsOpxi0Zm3tR2PJDhgMnhjrfubmm388bZNhE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:9865c24e-7762-4051-8095-93a179f0bf97,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:129768a4-7b17-4c9c-9453-88ae4be61918,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|136|836|865|
	888|898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,Q
	S:nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: de050258657d11f1b1788b6acf885367-20260611
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1774574411; Thu, 11 Jun 2026 18:11:09 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Jun 2026 18:11:08 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 11 Jun 2026 18:11:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mr7vMQrMebaJWHZGN35h32cjyYcq8Fh8UiDVEQhOeKPGuFiy1plF905AJhQySXXfpOGLXAzfX0C+LIlpN4UiHPzshdTF8U3woq734RndsrauziwgbgtDp9xV5nNuoY9OBAqRxVUxl8JMAAUrQ5j2byZHE8TPG/GO3deQpDTy4WU36+OI2Ip44iP7VSVu+ZAuVlZe9Hgrk21FFwUl9AxSj78Jd1HdLdiymePPFYP1kQQtdgLh2XLVpW3Gz4PyoByqIBDo92r1pUaGtE7iPBLSi2Mfa/v1E/PxsP9yADPWKkT0Pmb8nPx1zuozEfLupTw30oSfFExH5xboXiPDuHctyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkJZjCsq0XJKkFqwWf72+UbaLESxdPD7nyekwoULC9Y=;
 b=YbFUX+mhzFMShRkcbCaJDmeMhG5sgZov8HwEDPNsy9rNlrZOrmx/ou+nFpO9tHAY1GwGGTBWu3dIG+ooqirTWN02elL4clihXr2b9PKxsjZVXZkkRl5fTOBx97lUhow5pSe9XbFWGri0FBMvtXyn3swjgB9H5wKIvwHWUT7yatRTqBOVwZExdBsmuMugqA8Crhh56GDCj7R9VY1Ax3Sp1tTrEuAW9B4UTHCfqJEJSMcIO4OWYQgkKsm4f81NCQubIYDP9hKqDW4RZAwvroG+wKy8cHwfoYVV/BnTaVz0Ain0DAZyeBIbS68MpPmIHM1amcil50s9Jsfruho9cwALTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkJZjCsq0XJKkFqwWf72+UbaLESxdPD7nyekwoULC9Y=;
 b=DCtxMueidetzBk8w3FskYt9IanJJvEmVG8YZUhHvneTO9XS4M8FPL7CpuI5QSSe6GXoWeR27NhoI3t0CcFtlpflb1bBRuQZVH70cXcscf2ujAEy6TKpO9kcuDGpfEERKeKei+LYR3HJHW29RXL780DlI2vXjooKPrgowM5YIiMU=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by TYPPR03MB9519.apcprd03.prod.outlook.com (2603:1096:405:385::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.11; Thu, 11 Jun
 2026 10:11:06 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e%5]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 10:11:05 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "krzk@kernel.org"
	<krzk@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_rdwivedi@quicinc.com"
	<quic_rdwivedi@quicinc.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v7 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Topic: [PATCH v7 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Index: AQHc+KkLv87BTuTPxUmcK7HuJdQPW7Y5I+iA
Date: Thu, 11 Jun 2026 10:11:05 +0000
Message-ID: <5a1e01dda55af091204c430ff383c97c8dd69ed6.camel@mediatek.com>
References: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
	 <20260610071516.3763916-3-can.guo@oss.qualcomm.com>
In-Reply-To: <20260610071516.3763916-3-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|TYPPR03MB9519:EE_
x-ms-office365-filtering-correlation-id: b69107ec-093c-4a39-a003-08dec7a1c002
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|4143699003|11063799006|56012099006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: MdK/TLfuxJDxNJ3Ia8Q7o8fwE5OraLN3mfiLt5jjt9kWHnEkkJXn3dPgBi1GoUmNhsV+4vTUwHzPen8Z1fuXtnpTjBcc9C66WvVBPqQfIW9rV7qbv1RHvrwLLHq1oomJCPfgt3priSwH3gP4AMJZhoto6RyFeF3+BxK1VUbGYTJb43ZJlzKNYShX4YzvmtFcaZ0A3+D7gh6213jCtP6mApf2XJLWnK7kpJZaRi695DTF4FOiVY7xXfeLi1qExCtfYHvaqbt3Fo64k4qFcfXOGDFEvSsKJHAnIac5oZAaxH/4siqAkTTG97Rm8b6tz7kHryaYSPOk6S5YwNvSPj2uN/6Ggci3fGj/hzI/wIeuWNJrMyxMQg8RlirOfGGZndNwaN6woP4391A1r3Re9T1ZZ9U++xjCoRe1vuCteO1WUURNP34OjzCwb/iai5p0oUYiR59Z9HMhKQ2XfvnKV3caqHehQQnS+fzEnHwZY+4Dr+JXkD0qBfB5LAko3ToF1fN+jSPERLsVUnoUyCjygNRa+sWIULmWFQbVY/Nr17P3XX+nr2CItgZP8/Fz2uc1ZKPQoQjyx8XczUSPSe1KsDgPr8Fmnp65RcEwwJ1clz+hcAZ48Dl8WE4lxIhZQVg4ElXYR98YWwBAZ6KoafQ08GjBhBVGTb72y3JcdGkDQ3TUAzROdEtNqKaI+cCqCSM99jJo717EgrgSb3UO5gtiLrKgLTukC8K09NP7yLXZH7lvUPd6nFUbJhhmIoYcd9sUeb95
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGRISElxaVJjM015MWRBK0ZnZU9LRytXRjg5UWV1SE1oTEdHcit1bzhFL3Rs?=
 =?utf-8?B?THB0QzgyaXhHeVJ3SEQzN3J6ZjhITUxoUWdCZ2hUSk1Wd1Zla21Ua09hMWs2?=
 =?utf-8?B?ZEVURFl2ZGRXTktNejk2cXRTRHdDMmZkUGdJRnQ3NWt1WkUwVjhPVWFMN1Fi?=
 =?utf-8?B?UHZXbDh5Z2lQaGdFeHlEbFA4akRueDd4eDZFQXdqZUJ3M1h0bE9QLzRkaFhj?=
 =?utf-8?B?YUM2eXpYc2t3TkFzN3VyZGJmQ0RLYm1PSmRnbTkvMHpFQ0tmcWJZSEVrVXhV?=
 =?utf-8?B?ME9lTUtyMFZncW1qdkRodnhjS1JrK0R5OVliTlpTdS9paUhYR0U5emZRanVE?=
 =?utf-8?B?S2Fpd0VvUkFlVUhueTZpUTRHNTZrVExFZlEwWXdrb29RUGlCcDRLUkNqenBC?=
 =?utf-8?B?VVB3ZjVpUFpjZFMvZkx5RFFoWFk3T2tHMEtKSTNLU3FLZTRTRUMvUS9pMndK?=
 =?utf-8?B?Rk9FUmJvT3V1TFQxd3ZzQUJlZGV2bjluNTJmMFhtTy9rWVRHMDdaTmxrS213?=
 =?utf-8?B?U2xYU2FqVnJabzh1Y2RTMlVkRzliVUhncGhhMmVidDFQUXZFejZjemhhNzVa?=
 =?utf-8?B?RGhwMGdkSmw0TkkvUHFWN0MxNWtYUXRFT0d6WVRjMWkyam1wUldoNDVKVVBV?=
 =?utf-8?B?TE9mTzhwTnM3U3d4Rk9hcXdRK1g1dk1qOUJLbnVGMTh5OEx2cXFvVlFmWTR3?=
 =?utf-8?B?YVlxd3dJaGJEUlZKdk9PcDFTdXhlWVBRSVY3U2ljdEZHTlJWdldDNWNxYmxa?=
 =?utf-8?B?NS9CYWFsZjVvM2lPQkFOMy9nMUJHMG01TFJ0b0tRaUIrdFNMdFYxQ2NGYTNv?=
 =?utf-8?B?eFhNYUZISVFpdmF4Nyt2bGVPalhuZklHaHVBbTRyK0dYR01pMHA4eVJlR2s5?=
 =?utf-8?B?ZGlnRStSRE1WekhwVncyZW9Mdjlua3FLYU1HYmRPYlpWVDF5UEpraVg0dzAx?=
 =?utf-8?B?SkFVSFdGM1pSYndEcGM4NHJjUWtoQ2N5TXord3MzdHJmQ3RMSXZEYUYxNXJp?=
 =?utf-8?B?a01TTE42T3diWHpWQ2l2ZWVoKzdqOElWY1gvcTRwc29tcWFpZGt1VWFNV0Fm?=
 =?utf-8?B?RFRBK1NZdWV4aDZsZm9uYXpidXNLUXA0S0JURW1odXBSM2hFS0h1UlpEVk05?=
 =?utf-8?B?N0hUdC9URkxrRTJDdzlHc2RidkVHRThncS9rR3JYdmtRcVBTWmpxZjRyWHJQ?=
 =?utf-8?B?VHdKWDNrbUxjVCtDUTkyMTdwd28xMGd4Z0VQY2drYVp1bGlna1NHak5mWDQx?=
 =?utf-8?B?M2NVbmFkU05RMnppeTJUUTY1WFVLK1NWcGY4TThSTVI2ajBGNlRSTUtWYnFJ?=
 =?utf-8?B?QkR6SHRHYWtnTEoxWHJSYTNSOGdqenJSWnNwbVkzNXpDMUg2VUIrYXlyY3Y4?=
 =?utf-8?B?Wi9zWUtEL0locnFDNXducElCdm8zMHpDYlBRUDNYSlgvTXZZeWozT1BDQ2Rx?=
 =?utf-8?B?cDhXSVR2V0QzOEdaN0pyY1p1UEp3MDFpVkRCVVREZUVxQ0VDdGtSZnUzV0Zu?=
 =?utf-8?B?Mjd6T0Jyd09WSnRLUHhoNzRMWnlRbm9NOEFRblFPeWJZYTBabHV4TW9VNWtv?=
 =?utf-8?B?aC9qMFdRbHdBOGhpNjlTZFNIVUdJa0dTSjFnTjZoNVhPZUorUUdrdEVndW5K?=
 =?utf-8?B?dG1qR0hzWU5jSlN5Y2FGWWNzelBUU1ZkK0VOZDU1K3VNaWppWHhMdzNCeC9m?=
 =?utf-8?B?c2pUZGNYeVRwdWRIdTdIMXRVeGtTT2VVa3E5ZWZLTXg2WVJjV2JyT0VNbjMx?=
 =?utf-8?B?ZkFuRHYrRk5yc3ZCRlJUb3BLeSszbHRzRXV6ZTVob0J3MXF5WHB5TzhRSWRG?=
 =?utf-8?B?OU1GWUsyZi9HQmk4ZlJDa1p5UVNTTEhxSmVsTzB4Yk44MnFBeUpjbEFRUjdX?=
 =?utf-8?B?QXdtL2NXWGRjbDNFa013L0VkcXVmczU5U2JRc2RQbDgxRU4rSzVvME1ITjBJ?=
 =?utf-8?B?RnpIaVZ2NlA1YWRGNFR3WUtIZE5BSjlLQjlTZERmYjltVVgvQWNTTlhiRVJI?=
 =?utf-8?B?OEFyckpYa3JaeUhDVmp3Ukc2OXBYS2hrT3FVb1dHc1pqTUpweU1mUjVrM1Nz?=
 =?utf-8?B?RmcyQzJ4ZDRtdG9rb3RQbEk2eStjQjZTa0h1MnVxV3VOWmRPemQxdFZxaWVU?=
 =?utf-8?B?YXZ4eHVJd3I3UzdhTUlRc2NsL3JGT0tOQ29taWRyby83UVJhTUM2WE4weDVr?=
 =?utf-8?B?YllFak5aOTJacnZMTFVMRkhqd01qUDhvSUJNWEdXRVNvVXFtdEw1M21CSC9G?=
 =?utf-8?B?aXRlZ3lVNjB6b2VnRXFmZ2l1L2VvSkluQXJ5UklDMjdGRzdmYzhRSnVUa0dO?=
 =?utf-8?B?MkUvZjJsNFhHNTlUb3ZEYUhVU3VoNGFRUG1uYkRma2x1dmN6a2x3VWpTMmpj?=
 =?utf-8?Q?u9H4rC4OfvZws+dk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3FD0088AAA6CF4D9A56BDAE77842D7E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: CykKu0gcbWivi8kId6Bn5k3Kywoq+VXXWHhiA0N1rNKgX0RHn7D3tPpenhuWgTMN04D76cAQu6ItcV0VObQcW8yosqRSEGGrvrgBSxve+3+S+sjZ/Abz5/UoAiwdWH6OG49/KB9rHtEUpOU1rbPlQ8UP+Pcskc1DWs9rMIye6TiY9vUMpi2sK/p+NOdQIHDL+vq/wvs3rauCQZjNjEDJFZSB2NIgF/WZiiYV/cZ2L7RzYHTLXTfNOPDLXu3NoWr3a61Qr8FrC5QSHyiH9G0PjjuXf53FKwWu9XhjtZHfpl78kz2O7pC1JpGWYtwYatFpvlMWxsBNqL1piN93ZPz/Fw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b69107ec-093c-4a39-a003-08dec7a1c002
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2026 10:11:05.7690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7+7mK+g/5eG6+DQ82Y4+mF7rng7RyuzzKi1qrsdEmD91G5OLpqSCxInvQJncJXmTr6Tci7s6A9p436z3ODH1bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9519
X-MTK: N

T24gV2VkLCAyMDI2LTA2LTEwIGF0IDAwOjE1IC0wNzAwLCBDYW4gR3VvIHdyb3RlOgo+ICtzdGF0
aWMgaW50IHVmc2hjZF9wYXJzZV90eF9lcV92YWx1ZV9hcnJheShzdHJ1Y3QgdWZzX2hiYSAqaGJh
LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25zdCBjaGFyICpwcm9wX25hbWUsCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnN0IHUzMiBtYXhfdmFsdWUsCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHUzMiB2YWx1ZXNbVUZTX01BWF9MQU5FUyAqCj4gMl0pCj4gK3sKPiArwqDC
oMKgwqDCoMKgIHUzMiBudW1fZWxlbXMgPSAyICogaGJhLT5sYW5lc19wZXJfZGlyZWN0aW9uOwo+
ICvCoMKgwqDCoMKgwqAgc3RydWN0IGRldmljZSAqZGV2ID0gaGJhLT5kZXY7Cj4gK8KgwqDCoMKg
wqDCoCBpbnQgY291bnQsIGVyciwgaTsKPiArCj4gK8KgwqDCoMKgwqDCoCBjb3VudCA9IG9mX3By
b3BlcnR5X2NvdW50X3UzMl9lbGVtcyhkZXYtPm9mX25vZGUsIHByb3BfbmFtZSk7Cj4gK8KgwqDC
oMKgwqDCoCBpZiAoY291bnQgPD0gMCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gY291bnQgPyBjb3VudCA6IC1FTk9FTlQ7Cj4gCgpIaSBDYW4sCgpSZXR1cm5pbmcgLUVO
T0VOVCB3aGVuIGNvdW50ID09IDAgaXMgbm90IGNvcnJlY3QuCmNvdW50ID09IDAgbWVhbnMgImVt
cHR5IHByb3BlcnR5LCIgd2hlcmVhcyAtRU5PRU5UIG1lYW5zICJwcm9wZXJ0ecKgCm5vdCBwcmVz
ZW50LiIKSSBzdWdnZXN0IG9ubHkgY2hlY2tpbmcgZm9yIDwgMCBhcyBmb2xsb3dzOgppZiAoY291
bnQgPCAwKQogICAgcmV0dXJuIGNvdW50OwoKYW5kIGxldHRpbmcgdGhlIGNvdW50ID09IDAgY2Fz
ZSBiZSBoYW5kbGVkIGJlbG93OgppZiAoY291bnQgIT0gbnVtX2VsZW1zKSB7CiAgICAuLi4KICAg
IHJldHVybiAtRUlOVkFMOwp9CgpUaGFua3MuClBldGVyCgoKPiArCj4gK8KgwqDCoMKgwqDCoCBp
ZiAoY291bnQgIT0gbnVtX2VsZW1zKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
ZGV2X2VycihkZXYsICJQcm9wZXJ0eSAlcyBoYXMgaW52YWxpZCBjb3VudCAoJWQpLAo+IGV4cGVj
dGluZyAldVxuIiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgcHJvcF9uYW1lLCBjb3VudCwgbnVtX2VsZW1zKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiArwqDCoMKgwqDCoMKgIH0KCg==
