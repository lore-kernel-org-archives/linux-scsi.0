Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61592364E88;
	Tue, 16 Jun 2026 10:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781606132; cv=fail; b=MiXVN8pOSsULOTK0muv9TwAxNkH6MVq4Ot8s2yS1i+LA1xEDLGH2nyiRgdMmlOx9Zg2EiGTbx4ZT7eB+TVcAIG/Z3sNkIVe9c85MPq3Y/NFwXAriSMEY3/Xoiprx+M7CJr4QzoRdxhLbBZAJ924Xly14+XcKkP5zwywmdqy5AA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781606132; c=relaxed/simple;
	bh=3zOPLlY92QFzZchTpAXHP3IdTk3EwXS8Gat5qFj7Sp4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WK0Fj/UguZWSk7UoV2bZinp9f/9MvOQ6ekncT9+BviBFDtsJLuhwj/OMfiuY7ey5ZvMIeN+f2VJCZ9PMUnlkBnE9DNyP/ywdIDja9HUwv/IKxVrpAVOzK4yzNuCgE1UxbP0h2orsSM7ye7nP0BKSiFu/wzywB4mn/eyQQ4xxgzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=amzaZ29F; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=UaHejccP; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="amzaZ29F";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="UaHejccP"
X-UUID: 15b19654696f11f1b1788b6acf885367-20260616
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3zOPLlY92QFzZchTpAXHP3IdTk3EwXS8Gat5qFj7Sp4=;
	b=amzaZ29FkOolGX8L/U8Ls2VFd7Ir7KIQIVSvlG7Y4MYnkYxqRKb+KwzQVhvA0p6xyHd7t2uJb8IV0kLwXx9QKshX8UtFeFhoTqwerHG6kJptOq6IurKnUsP2ioJhQZ/XEgB66pU+uvv6osZr3N74dA33B5y7KV5M1ZzAEs8bjSc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:10355ca3-738d-4f3f-9761-5689ebb39500,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:a87bbaed-45e6-4692-a476-3f71842ee83b,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,B
	EC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 15b19654696f11f1b1788b6acf885367-20260616
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 751662930; Tue, 16 Jun 2026 18:35:25 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Jun 2026 18:35:23 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 16 Jun 2026 18:35:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bYDFXpKmZcFruRVqQ4Dc+XJ51xCdYEkhQQ2/+PpYS71e3nrUEoIDn83JoQra5aJvvK9FFLsm0UK+aDrjsFQfpXQ4pGPABfiqGC8TIjb/c2hyD3ePtF++JRBNZr7Xw/JkMR8bEVBAITXaVQ1Tu2GTe403/IJC034f2w2mZXwmockERiYNC6YG50BpMClCYuofk5wVEWqCp9uOYjz9qGZ5dKBuAgbBUiRTDv76GL2k9j6WVPI+XKdYm5WG1THiWiLjthvw5wBKp1XPLkjUJlu5AQWgJIuH/G3jeSX5ZSrnNtZY0PnSsixmfm9c6fRiu54FwF/ibZiU2MEEzSBM8uEOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zOPLlY92QFzZchTpAXHP3IdTk3EwXS8Gat5qFj7Sp4=;
 b=jMV+qEXsnbbad1EY/0K6+vTymAE5OpW4WqRmFXnsHXBnIS0DG2e94lpHxMxuEupofqRsJsLNypLvye37pu+fj6PtNrlzErTsF5DwfxQIwPLjpOuWtzR2YPiuy/La9Jgk1h+qRuv1WJ1sF4z0XE/dFyMbmS+ZwvnoylFyG28H9t1bZyTkUUs0SjKmbR6dEvN6v2n25z3u1ZNZo36mSvyXKAIFwjX29ZS9XGk1xnLx0MW4eCEMBDjE154yVkAy+iFaSgiaANeLQiaHBnb0Gs1/OefVQTICuzEkiXRrbx/tORNRKPaF3QXHkCMi/sPyjmgUFzlsKIqVgQrYwfEaONP0Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zOPLlY92QFzZchTpAXHP3IdTk3EwXS8Gat5qFj7Sp4=;
 b=UaHejccPqwl/UkwjTOkF91EVh9RRFaLctZfMPq6KxFmVM7JlzapFMRzBkuA8IAfglTS/fDMvrlW7ntxmmpe2v8PZpx+bLlpeXXiwyTGc4lwCOo8aM5Y/b2+AIx7JIW3kkcN4b9i3Oji4IZY+lqrwS94wFxM8z1Smk77k3ygcLiI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KUYPR03MB10553.apcprd03.prod.outlook.com (2603:1096:d10:78::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Tue, 16 Jun
 2026 10:35:19 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0113.013; Tue, 16 Jun 2026
 10:35:19 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "krzk@kernel.org"
	<krzk@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_rdwivedi@quicinc.com" <quic_rdwivedi@quicinc.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>
Subject: Re: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Topic: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Index: AQHc/MsDOEy0+RDZM0u3KzUGsIxSRbZA0/uAgAASAgCAABgTAA==
Date: Tue, 16 Jun 2026 10:35:19 +0000
Message-ID: <5caf0295b2a7c9ebf2076b7b7db3e0a94212a092.camel@mediatek.com>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
	 <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
	 <e4590bb7dcda6bd8b20af2e22a18111b998b9efb.camel@mediatek.com>
	 <bf4d2fd7-2a8d-48cb-9f50-67b6ae4f2163@oss.qualcomm.com>
In-Reply-To: <bf4d2fd7-2a8d-48cb-9f50-67b6ae4f2163@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KUYPR03MB10553:EE_
x-ms-office365-filtering-correlation-id: 3a238df7-aa09-4ec9-aba1-08decb92f670
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|38070700021|18002099003|22082099003|56012099006|11063799006|4143699003;
x-microsoft-antispam-message-info: igopQw7jghk1aL6xI9kzGg6NlltCj1z4Qi8Da76EsNesol+farjJ5cxznG7B/FypeLF9xC8x9A9n3WnOlKWVaarx3yMZr44+dIVlHG7zcv4Y5ZS9iQlnXy9+hrjR23zIMZXiSvuujHpRBdALD8jp/8EZzYADNxhgWvgBfIdRs8DJlT8fEiy7gmJtn/CXSDWPJOvjSwre5+b+++pGfkyABFaXxDN6EC1TywGLl1SbtzI+sNeNq8KU/gK8I0zlLdXzNCxvcREWjwpaUbGuWp34bvg2xf7IP53wRdrAnogdSYLcNTTLyfHN6VpTGuB6lMPWmzoYt1IS7YPxxrZKYnmTvIqbFheZEsSRecqtNl7qdh5nx8ROdcrKh1r0hO2ZPDu9YGGZFj2vtll26632LvMMnc07RQAtRbXgeYeENeiRYUhhNxu2QpbYWwj1AmpOo8g1Rn6kaV1AknSW/KezWxMxP4mRKO/laFy7IORHzhAmbUHlSXIw8B9uXqbXrgwcfc9PiG2DE13Jdvi+/EuZm4Y8T0hRmikuTmfWrolKXItFDXd8aqtYhmCL45miA8vxZpdyoRK6NozJF5yIzhQib+52+IZmhWmH9I0ll2AwpFA/i46b51BvD7/buycTZxJzv1tAV9cdvM9hnFnphNHaCR/BVItbxzLqru6SfvzX7uLZGXXnE40Fv5uv180B6kVHHNJuV6GJ82h7KL4dfaokfTo//weOn7WrvIdrCXIUK4wYzS9Ah/Kbh1J9Zd8jBCJZkv9C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(38070700021)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGp6a0xKNVdzV2R2bHlZcXNRb3ZyYTFvWC83K2NkVlBkZkwvTHRpSVN4bVEz?=
 =?utf-8?B?YjhJZWRKZ3dHRzkzSTlISG1yNjRORFhnRXprcXo2ZzFCTG9kdDdqQTlLYkNm?=
 =?utf-8?B?dmZBUXVsVTJkSjl0VStWdEU3MW1DdVBUOU1qVnIvQ09EK3NtQ0dKbFhVcnI1?=
 =?utf-8?B?bEoyOXVHVThLTTdKanExcnRKZXRVUk1LVFNuczArQjBNOFJOSTBKTHZQcVdK?=
 =?utf-8?B?RjZiaDRNQ3RlcmhUTFFWMHh0bnlKWnBjbGRMb2lXVXFpckxENUduVHAvdVAv?=
 =?utf-8?B?VGdNRFRtbFhEREp1VGgxc0dMUWFvd0xjYkovdTRadVdmd3VnVjQrTGRvcnpJ?=
 =?utf-8?B?RWdJZVYxc0NHZ3loVzRPbUVSYTdneHVnc0Ricnc4NzJWYUljRUxmZTg0WkxW?=
 =?utf-8?B?U1VzbmNoSCtuOS9qUEFRUklPb1FOZXgyT09yYlovNmYrZUVVbmNjd1ZiV3N6?=
 =?utf-8?B?cWwwL0s4ZGRTV3J3K3lqUFRQQzNiS3UwTHNvbUlrRk0zVFR0RlQybkhyVElW?=
 =?utf-8?B?b0RNOFBSWEx2QjFvbS9uNzJrL3lSbGgwd1FibHhFZHN3bnVicjBOQ2w2eVl6?=
 =?utf-8?B?Wnh0R0hOVFlQNFMyS3VWWml0NVd3dUVXZlJMWHl3Q05pY2VjZm9Sb3Myc1BS?=
 =?utf-8?B?cFcyRjQ3b3A2TGQ2T3JOdUJQLzJPSFR4TFhMN0VmaHBhaVlXSFpEQ1FFN3di?=
 =?utf-8?B?c2k5WXFpSzdwTzgyakJHOXJqYmJBMDc5enFUMERsb3ZZQzl4VmlhS3A5eFRM?=
 =?utf-8?B?YzFjUExSRUNRVjJnV0ppcDQ3aWp4MVk0MStRc0g3aFhjSXBuMG9Bd3U4TFE4?=
 =?utf-8?B?cUhUaTJIeWVPaE05c0hzYTcyeGJLeTBUYWlnWHVNNk5yUDF2MHIwQ3dPM2U0?=
 =?utf-8?B?UmVhNmlORkVpcjEvWmhsV0FmZ0w3WnM1S3ltNUxFSzIwV2ZTUW42TDY2TEMw?=
 =?utf-8?B?U0xvTW80ckdwUGhsSW1HQjZIaldkSUpUR1NwRzR6dU1yMldadVNaVlc5cHRE?=
 =?utf-8?B?SkVOaEhhVUN4S3NJb1pLMURvajlFSDloS0JOUkk4OGc3eGN5aWJlNGtTT3hT?=
 =?utf-8?B?T3doYjRYR203R3Z2ZkZaTjhaTlZpWEloME5RTXhROVJYaWFxTE9SMXdjNGE5?=
 =?utf-8?B?MFlxRUIyYWRLeXVTc2VSY01XTHg2dWloYTVtb2phS0RjQlJmakJ1Z29wSG5V?=
 =?utf-8?B?OGJGQTBYWlBWN3NxRjB0dy84bUtRVERoSGF3eHkwaUhkTmRWdEw1NkE1QzZ2?=
 =?utf-8?B?cDRtUHZGNTl4YnR6enVqS0ZSZS9MdTJib0pSaklhVzZ6Tjl4TW1DcGFzN253?=
 =?utf-8?B?N0dhZGpBV29vcnliODlpZmJmZFpSYjFRMlphTlhNL1o4UFFxSjljZnF1VGR1?=
 =?utf-8?B?VlZYUmdOSzBlaTMrSzVQV0s3b1owS1IvVGVYOU9OTkd2SGYrWGtNWGxGaTN0?=
 =?utf-8?B?d1ovRnNqSXYzUG1TTCtZOFRIaTJrb0g4NDY3dTRTR3BLY2Zwc3pOLzM1ZExv?=
 =?utf-8?B?YmFSOERTRkhNbWFONFU0U3NmL1BKdUhCazN2SzFVaVdaRkpud1JyM3ZFb3Nj?=
 =?utf-8?B?Rnhib01BazUzT2RJUk5VSWprMnEvblRoL0N4bzF2NXdFbnVzTm41ZVBsb1NQ?=
 =?utf-8?B?eEREOFQzSnN0YVdpKzlPUjJybHRvdzRkZzVEV0lWZDMzQmhHNTlGcXFzTUFH?=
 =?utf-8?B?aDJXdUQ0RFNRcWNFZ1RUdE1uQ2hHWCs5OEROb003VWdhMDBzS2dkVEVTU0lr?=
 =?utf-8?B?WU5ianNxYm9xQnZKZ3NVYjY1QzF6bC9XSFZIY0ZpODBnMU4xbWFxUlRXSHRM?=
 =?utf-8?B?b0hyVlMrQ3ZFV29udFdXT0tPSmFsdTdDQ25WOUE2bmxyU1ZVVnQxditWR0Zn?=
 =?utf-8?B?VlhPM05TblZCRDM0VWI0TnVOdVNhbmljd2hPY0p0ais3Wk5uUk8rd1Q5MlFC?=
 =?utf-8?B?VzU1QVNJQk92QjgwUWhnYXBaSFZXRi9mZi9Tb2hwTk94SjR6SEpjcUxicjVr?=
 =?utf-8?B?RGFrYTFRMkJOd096cFBZb0xsbnhBUFRJY2RuTUJIOWRmWC9xY3B6VXJVOGFY?=
 =?utf-8?B?T3VWN0MvWUlrTU9TakVneEJtbFVsejM1Qm00RXViMDQwTjBsMzRvWnY1cmJD?=
 =?utf-8?B?WThDTGZhSHlHSEsxdzJtMHBwZzVHaXpZTC9YQmJhLy9HQk52bDVwRTBUeHBU?=
 =?utf-8?B?dkRWWXEzZU00blpiTUd1cE01MG4yOEo0Ky9PQkw0M3N2T21GUCtXbmJsTU83?=
 =?utf-8?B?ZkpyL0d5ekN4aXE2Yzdib3RNTGUxTXZJRG1MSXlpbU5KckJKUVFYOFQ3OHVs?=
 =?utf-8?B?T3RjTndZMXg2cE9Oei9TNUVIQnVlRElKRmZ5NmZvMnJsUXp3ZDBFdUlLRzlQ?=
 =?utf-8?Q?a9vCqR2/4VJbdXX0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9398C2A01F45524BA2EB13CACE6DE606@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: AFNDuyParnZ8PbS5nm78oqcI1kKOiPJHgujEIEzmHztaKSitQnyNLxtcMF3H6KuntV2ygruVvA8haV61XYiWlHq4I3C7m4WR+aNYAxGeztcFctgGLV+H4VxTmllx9TzhgcR184XrNEVE0tpwrro/lQIWEXr+t8k6oztcDqv8hzSRWpnn7biGz9u5wAgT1To1HCok517xIpcvqU633Dev9kNbZWiQyVYfIWKZ7JEddOd/NCsJiC06yBnk/DnCmOhnipJrEZrSsYK0allq0FjSDhvd0iImct0LwM4XAOgFaOIf/s9ux7ahxyey2zOukEoX2irjowDKtkKEdNiOV+2Ulw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a238df7-aa09-4ec9-aba1-08decb92f670
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2026 10:35:19.2787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9gfRWCMqzZ54oyqduc6B5YEUN9yO0tn4/PsEMYEQKR07uL+3pInyCce0DRbu/R1UdiF92BdF73KwxDM2LrTXyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR03MB10553
X-MTK: N

T24gVHVlLCAyMDI2LTA2LTE2IGF0IDE3OjA5ICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBZZXMs
IEkgcHVzaGVkIGEgc2VwYXJhdGUgZml4IHRvIGFkZHJlc3MgdGhlIG1lbW9yeSByZWNsYWltIGRl
YWRsb2NrDQo+IGlzc3VlLg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYw
NjE2MDkwNjU0LjQyMTg1MC0xLWNhbi5ndW9Ab3NzLnF1YWxjb21tLmNvbS8NCj4gDQo+IFBsZWFz
ZSBoZWxwIHJldmlldy4NCj4gDQo+IFRoYW5rcywNCj4gQ2FuIEd1by4NCj4gDQoNClVuZGVyc3Rv
b2QuIElmIHlvdSBoYXZlIG1hZGUgY2hhbmdlcyBiYXNlZCBvbiBCYXJ0J3MgY29tbWVudCwNCnBs
ZWFzZSBmZWVsIGZyZWUgdG8gYWRkIG15IHJldmlldyB0YWcuDQoNClRoYW5rcw0KUGV0ZXINCg0K
DQo=
