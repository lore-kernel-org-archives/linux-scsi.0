Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D683A453F;
	Tue, 17 Mar 2026 13:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773753856; cv=fail; b=b8bVvS0y4s0vs5nlgt0ynQTfm0p9O2X8qUDHN+rvGQJr4jleeHWatgAxbbSNQ2bEj86NSGV1EwfGqCcLX329fEnPXXu7LtcfVAvReG+I8MXqt55xGFufH0nMfvDZ+ZDCR5yDE2jBRoJ92zObsROhDqkp/S+OFy1xeMrn/2KDhus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773753856; c=relaxed/simple;
	bh=DT7ClPLhWqrFZ0V3l2VpX/3dIM+b5qx2muBOOpRpobQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u3VhJvLfmK32N3we/cEG97Gv7B33jtJ/NUD4iX4GOHnmnx61P8/4C3rKMFDlgRKD6/wKAzWE14wL7AoZAlpRMvsZP0OwCHim3hIfWdMb+fPUbb04XeJdfi3nGymmhukOQ/NWDwuaeybbiN1uxdQo6hFCAzuBfChh6imyGnDu7dE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dbA0+MvS; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=uN6C/3Mf; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dbA0+MvS";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="uN6C/3Mf"
X-UUID: 774b73d0220211f1a39cd589f645bc18-20260317
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=DT7ClPLhWqrFZ0V3l2VpX/3dIM+b5qx2muBOOpRpobQ=;
	b=dbA0+MvSnQS1zu627NFy5JeSzMnJGEf9sWI29hk0ACbh1utkFZ54iYM3isul1okTyEHBW+DNsMI4tesBUYr2JgE6fEtKV4RbpA4U2YybucvutBUoqf3p/unJejXq1IilyVB7369WdoUmgrA5NcJ8mGw5AgiCzMwwAgpLbc5VDh0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:0e9a2350-e93c-4cec-b225-81139e919c77,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:1b607a16-77dc-40b0-853c-db53c3132fbc,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 774b73d0220211f1a39cd589f645bc18-20260317
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1124405163; Tue, 17 Mar 2026 21:09:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 17 Mar 2026 21:08:59 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 17 Mar 2026 21:08:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TOpL7V0Ug6IhLdhRggQnxYnYeBOd3IMFAb4HKWzEXwJ0tbTVSKQCqhZD+EdGfkOjnEDy3Hz/X0eh/zFEZdh2XHIx6FXwkB4I1R8XerUzuVkg7gs4BrM+BRhkIQXTn7bwGliJoDPRbTkSKoeduHJUagCAKP6a2eN1g8fySkDExVDp6TvJu1KvVKCgFFStZoMkOA2qe3SRUKNXMcMXdKxKvQDpXsKIEsS9p9620YNzJELKKg2x0SokWgPDsgbBZRa4N2WfuCNoetbKxhD2GqmMhhhIqSsTzSpIbeB3bmW/YErj0KAINTB4k5zrwI+rr4B7GKs0tSyZESlon59USH4mSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DT7ClPLhWqrFZ0V3l2VpX/3dIM+b5qx2muBOOpRpobQ=;
 b=kJH9FIY2/jqdzvYbX2YCMU7BuqQKjlcizhiyD52bItrkij6M4apFuNgqpZEUKn5Z+hUuQlNPP+eQOScdliwNmKOmWSicxZeAQa3NOxtRbvMS9Oe6CfWhB3FHiMMg9s++HHh0Nhxz1sUP6GyOmlnFE44HKRAAm6GYk1dZOeoDsgj6efyCkOvmhS4gevL+/IGvzdRnnpEASMBThHDsIpU1O1VWOz5Bb+HG8WajJ7cxE84KmnsaZMIZIoUdxAxHcFbSSnYPuNPX4pjt8ftFE/xQXKjF69jRPb41rxiVEtZIfIaFvtNRW3AV/fm49MPnhZcRFzSlZ+xZ5UQe2e8IUr8iuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DT7ClPLhWqrFZ0V3l2VpX/3dIM+b5qx2muBOOpRpobQ=;
 b=uN6C/3MfNJPh41ZAKlH1PXziGfKaIwOQNpIJKorS38qVUH4wbVXNAJBso9xkmP2OFCqusXUlesph0PgCgXGkF9oFE57eMl/YtJxtX8zRkf3Dayh8paCW9vEzI+M1lBMf2AM8U7+5bsMznLaN86f/wmdkg2g1JJXgMuxHu5Z4a+c=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8413.apcprd03.prod.outlook.com (2603:1096:820:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 13:08:55 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9700.025; Tue, 17 Mar 2026
 13:08:55 +0000
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
Thread-Index: AQHcrw5m3AJ+eCzqYEGMTPJE+YMrfLWyVjsAgAAJRgCAAGDLAA==
Date: Tue, 17 Mar 2026 13:08:55 +0000
Message-ID: <1318f77eca87a01815214e7fb0178281871c9b1f.camel@mediatek.com>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
	 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
	 <42587e16218f1c51dbcbe6bb1639a843e10bcd80.camel@mediatek.com>
	 <fa2a97fd-e17d-4314-b5a7-011b6b16a622@oss.qualcomm.com>
In-Reply-To: <fa2a97fd-e17d-4314-b5a7-011b6b16a622@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8413:EE_
x-ms-office365-filtering-correlation-id: 3e05fd97-dcc3-4cad-442b-08de84265849
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: /4o3VgGg8z21sTfyMcihh5Bvxm19rEY5rbD/BAtYcnbqSkaLgBd4efQEdGhitkGQLCKHecEcEaDQSvHULCG5X0vLfBsbJ60Utt3tDXZmYpBz+v6ERZRrQ5UP9kOMBEhocVKm5VjL+y/vHKnygneI2/HJZt4EmeItKz6OAyUeP/2Y2p6NvvN3sic2aUR3m/fqWxoQn1Lj7owpf6rLgimrJXeMShwLjRdYMvzFIcNcfbcqNt6+Qdct6u1hAGP/r4G/3umX8fdLf04w1JIE7YjbL+dU38ahwxxtEcFQgTZdmYgYSIf3bfJiyh/lGRUv48HMHNtbIQc3fweWU0T7ZfcDFp6PUCUJcIsO/1LA95tEnuh6xMO/o2cbnUUD/MYvudl/BGcJAmdNLXE4ixZVu0KbkwzqOWH7QeFXaFzRCyuc1C3RMLdRgKLcRhu6/ka4KgVkmBjzyht9dDx+IJ+gDRg1+mdV2Ncgg2M00NOnx1kTXISJkAV2VCf2VwoEh0gt5GIKgdrMV4L5pJs/Lp4VKR3FgKAS9dLnn1UQPxttOr/fXqhShu0nRY39D6gP35oXBAvHtQ7ErznqBhS9w3oTTeZ7va7rneJa4T2/dbMF0swAyApw0COPFz2Pc6sVgz43EIl3a/hKc0rcrE0X2hDiXluxCH8mcE6r8+HLX9N5OULbHCQlpPK8aYKH5dOjk9m9Q8lnfU1eMi70rtoXHGjwsuFSYuoVw4CUqhxtl9xAwEHe3p/RssiKjnPi5NlC3UamfrhT9qo3SswD7q9itw25tfCK8eG7W8ZuPd80WNVg3nPKqf0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VElpbEVQeTJuOVVGS0dSSU9GRXlEakc0Wk8zRWFsRkpKM2ZZRzVyUnhHOHpR?=
 =?utf-8?B?bmhPUkhFTkNtOENzTWZmMTdUYmx1cW1BVE8zWW40OTI2ZVQ1dE5XMDIyTXh4?=
 =?utf-8?B?eEJqQmNBTkxyY1BrV2FUQkYyUkhPU3dMOXBqUXpFbFoxNGc1YUJqcWk0dTFO?=
 =?utf-8?B?UnhjSFZTNzgrMW5LdlhZOUhEWTc5TVQxK0c2Q0l0dGpCTVcwdGNiVlJVVEUv?=
 =?utf-8?B?MU1WOWxCMDZ3Y2ttUlp1cmlsS1hiTlAvK2ljOWZjSG9FZFcrMWJCdzVQVndG?=
 =?utf-8?B?V2RoNlBBSGt1K1lHOGJYMFowVjd4ZVdaM2Rhb2xtRmh5YTR1VXhYcmlQaEJD?=
 =?utf-8?B?V3dGeCtqa0R3SGpBQWkzUGp1TVp6NWtpTGsxOTNDTTh0c0NDdGpQaDlpbkpK?=
 =?utf-8?B?b1hyYi9JczlnNXdaSzZuK2pHSzl5Nk14R2c1dFNZK1FESndYbm1GWU9tL3RX?=
 =?utf-8?B?YjBKS29ySld5U29sSll4UVY2OE40cGxyVkc4U2dYTHdWbmlTYlA5SmVlSDdo?=
 =?utf-8?B?VXNENkxkb1ZpQ2pHQVNFakxmZlRlekZtenVFZWN3L2dyMUNUTC82WjA0UzJO?=
 =?utf-8?B?MEpNMFpsak5Zdml1UEZIWHNLYnRYSGt2QlRFQ01YcTI4TVd6UXJueTBkcFZF?=
 =?utf-8?B?WG5SS1ZyS2loTXFGU3AxV01oT3ArR1FGR0VNQk5TQkUxRVBCK0VhcEFuN2xC?=
 =?utf-8?B?QkN6cXNpVkhGVy9QZjlmRnU0Nzk0dVlXbUVOcW9ZS2pqV05zYWo4OEZtRGpo?=
 =?utf-8?B?Qm9Uak9lVEZjb0N3WFNXd3V0VkJzSk1ldm1pc2VrY3NVUk1IUnU4YkFlNGxs?=
 =?utf-8?B?ODlHQnFmNG5nZzljb29CMWN1bXdmREIyQnZYZVo2bndUcmVtdnBtOWV6NDZ3?=
 =?utf-8?B?MDNaeHZoenl6ekwzQkxTeHZ5TDRmOG0yd3lmWkVTcEFrRWt0Q2x0ZFZLNFNn?=
 =?utf-8?B?OUZtbE12aW1vVXUzNzhCQWVlK1pQT1FGandmUEFlMmcwRXZFRytKdjFFanFY?=
 =?utf-8?B?aHZ2OEZEVWpYNkxjRzZDQ2pPa0diaEZhTEZWM09HM1lGWWN2RjJoaXpDcEhh?=
 =?utf-8?B?dlJLUDR1ZWpNQkE4ZzQyTmpIU1pad0hCbUVtMnJZYnBNQjJUSDRDaUdQK3Vv?=
 =?utf-8?B?My9pS3gwZUtXeXAyVnBTVWFKR3RBN1hBSTBIcXUzckkzWEMwempXMVZlb1pV?=
 =?utf-8?B?TjU4d2JJTjBXa296OWQ0MkVjZ0xsMmtFczBJSzFBQnQ1VE9vbE5Qc3FEa1pW?=
 =?utf-8?B?dFRBSzF2VERwU2htdVhSY1Q3cXNaZVM2cnNVQW5TaGhVSzdwcWRaV2oxTW9l?=
 =?utf-8?B?bXZxeTA1VzlVeFN6dFpabTc0ZUhQZ3k1NElLTHFrbHY3ZTRKV3RzWWZMVEVn?=
 =?utf-8?B?dFJRQUEwUWUwVVgzWGY5WktDSHJ4MW9iM2QzbjM2QVkvUjZDdjFQb1hMcWI5?=
 =?utf-8?B?ZHpOV0NPZHJQZEpNRHUvajZMNkZYd2tDRUlZRjhaWFY5VXh0SHRvaytOSkMv?=
 =?utf-8?B?OWk5eHZaczl6Z2NYVUoyellEaGk4Z0tiZjFzMlk3MHN1YVNWR3NzaU9kU1hy?=
 =?utf-8?B?MzgwNFF1UHpHdFNGTnVSVzNMNGswT3pxcEpVOStKVmtXak5NSTMySDJvQStW?=
 =?utf-8?B?L1ZJd2ZsV2E4bmg5d28vYVplK2YwVkp5QlprcTEyUEw1TGU3Y2RLZlVvZXVJ?=
 =?utf-8?B?YnZGamFDYkhJQkloL1hlYktRd2drVFdjenM4L09Ha2QxUDRuaStwM2hSY2RM?=
 =?utf-8?B?bm1oZ0d4ZnVoTXBLSzN0cEFDaFlQWTRvVWptMzIxa0VEbjdzVXRmclA1c2ZV?=
 =?utf-8?B?K3dCcCtJcjJrTnQyYzd6SEFobjQ1dW9jY05WRGUwUEZMRitFRGNyTlJyTWxs?=
 =?utf-8?B?Rm1JUXNiODd0UzZWcDNFSE11VFoyU0xrR2NnTkkzc2ZpQTFsc243K0ZXb1oy?=
 =?utf-8?B?Zm44amVJUW1Ed0hlQkd4TnUrVEVKUFdtcVhBQUxPZHM0bnl3aTZkSjZjcTk2?=
 =?utf-8?B?UUYwTkcxcUVJUVlqNWtrVkIrTjRXc0dwZExTZXdub05ia2NESXNUZFpBczZC?=
 =?utf-8?B?a0FDSmdrcFA0Q281Nzl5V2xRa3IzL3A2UllRMnFUcklST1J6aXhXSTBMWm1a?=
 =?utf-8?B?My8yMXdOMFZ5MjYvejBZTnJ2eVZKQ2c5QllZVlNTTmF1R1FMdEVHa1JJcUI4?=
 =?utf-8?B?WEs4TE1TOFB0M0dIK3FiZ3pFZEJEOWRtYUtGaFV1VWNoY0pVNitkVDdiak9w?=
 =?utf-8?B?NEZOeG5RSy92YndlaDFuMjdYSWlMdTJNeDg5eWpoa2tyZkFBWERlK01nMTRv?=
 =?utf-8?B?d1JlYVJFNXh3RHZUS1J1QnIwOFpnQ3d4b2xQUmJmMEJEdEtNTnRZQ09mczBi?=
 =?utf-8?Q?v8ajkLr70o38DRhc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <120F1DB417391E489E29178C28080808@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: W+DpYOnZAgYInF69AQqeM2nPKmSlKtQxTgaqe3rtb3isCTDO6Sob/0AcMLc30ji5+Vd7Uxc9WvbsYYehMOCgFMZVq4dnFBif8DE/ix1OEos5P0uZYNVCpDLmfnwwjYX69Lcj83LPTV0v1SRLID2oexLkeAhVwcSE24gZG8zzacA+vszZp6VRUQzP72zEOLQkQGPoSocvbzes0tfiPQ6g0GXWGqiQwu7+DrbendgvWAZe/HXcJRuxOofOjtrzuYNOCC2Qkj6K8i/4AOLw7Lwp7/tVSnC8+tNwX3aBIAK4BVl2a3aDxm1fRXGBaD8SBot1YYomBtIdGTGMW+iTuWvtoA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e05fd97-dcc3-4cad-442b-08de84265849
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 13:08:55.6843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eByMY2WCkjqhgCRo8A4NmyYJfM4P5m9BS3UG5hvPKu4ROsBbKvX+j2xBmXLw0pl4dVSf38OtxAANufq7Pkn2WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8413
X-MTK: N

T24gVHVlLCAyMDI2LTAzLTE3IGF0IDE1OjIyICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBIZXJl
IGlzIHRoZSBjb25zaWRlcmF0aW9uOg0KPiANCj4gMS4gU2Nhbm5pbmcgYWxsIDY0IFByZVNob290
L0RlRW1waGFzaXMgY29tYmluYXRpb25zIGNvc3QgKG11Y2gpIG1vcmUNCj4gdGltZQ0KPiDCoMKg
IGEuIFRoaXMgY291bGQgaW1wYWN0IGJvb3R1cCBLUEkNCj4gwqDCoCBiLiBEdXJpbmcgVFggRVFU
UiwgSU9zIGFyZSBwYXVzZWQsIHdoZW4gb25lIGNvbmR1Y3RzIGEgcmUtDQo+IHRyYWluaW5nLA0K
PiB0aGUgSU9zIGNvdWxkDQo+IMKgwqDCoMKgwqDCoMKgIGJlIHBhdXNlZCBmb3IgdG9vIGxvbmcu
DQo+IA0KDQpIaSBDYW4sDQoNClllcywgaXQgd2lsbCB0YWtlIHNvbWUgdGltZSwgYnV0IGFjY29y
ZGluZyB0byB0aGUgc3BlY2lmaWNhdGlvbiwNCndlIG5lZWQgdG8gZmluZCB0aGUgYmVzdCBGT00s
IHNvIHRoZSBkZWZhdWx0IHZhbHVlIHNob3VsZCBzdGlsbA0KZm9sbG93IHRoZSBzcGVjaWZpY2F0
aW9uLg0KDQoNCj4gMi4gQXMgcGVyIG91ciBzdHVkeSBpbiB0aGUgcGFzdCBmZXcgbW9udGhzLCB0
aGUgb3B0aW1hbC9iZXN0DQo+IGNvbWJpbmF0aW9uDQo+IGlzIG1vc3QNCj4gwqDCoMKgwqAgbGlr
ZWx5IHdpdGhpbiB0aGUgOCBwcmVzZXRzLCB3aGljaCBpcyB0cnVlIGZvciBib3RoIEhvc3QgVFgN
Cj4gbGFuZXMNCj4gYW5kIERldmljZSBUWCBsYW5lcy4NCj4gDQoNCkhvc3QgbWF5IGJlIHRydWUs
IGJ1dCB0aGVyZSBhcmUgc28gbWFueSBkZXZpY2VzLCBhbmQgbmV3IFVGUyA1LjAgDQpkZXZpY2Vz
IHdpbGwga2VlcCBiZWluZyByZWxlYXNlZCBpbiB0aGUgZnV0dXJlLiBIb3cgY2FuIHdlIA0KZ3Vh
cmFudGVlIHRoYXQgdGhlIG9wdGltYWwvYmVzdCBjb21iaW5hdGlvbiBpcyBtb3N0IGxpa2VseSAN
CndpdGhpbiB0aGUgOCBwcmVzZXRzPw0KDQoNCj4gMy4gRXZlbiBpZiBzb21ldGltZSB0aGUgb3B0
aW1hbCBzZXR0aW5ncyB3aGljaCBmYWxsIG91dCBvZiB0aGUgOA0KPiBwcmVzZXRzLCB0aGV5IGFy
ZSB2ZXJ5DQo+IMKgwqDCoMKgIGNsb3NlIHRvIG9wdGltYWwgb25lIGZvdW5kIHdpdGhpbiB0aGUg
OCBwcmVzZXRzLg0KPiANCg0KQ291bGQgeW91IHNoYXJlIHdoYXQgbGVkIHlvdSB0byB0aGlzIGNv
bmNsdXNpb24/DQpGcm9tIHRoZSBzY29yZXMgcmVwb3J0ZWQgYnkgZWFjaCB2ZW5kb3IsIGl04oCZ
cyBoYXJkIGZvciB1cyB0byANCmRldGVybWluZSB3aGF0IGEgZGlmZmVyZW5jZSBvZiBhIGZldyBw
b2ludHMgYWN0dWFsbHkgbWVhbnMuDQoNCg0KPiBTbywgc2Nhbm5pbmcgdGhlIDggcHJlc2V0cyBv
bmx5IGlzIG1vcmUgY29zdC1lZmZpY2llbnQuDQo+ID4gDQo+ID4gPiArdWZzaGNkX3R4X2VxdHJf
cmVzdWx0X2V4YW1pbmUoc3RydWN0IHVmc2hjZF90eF9lcV9wYXJhbXMNCj4gPiA+ICpvbGRfcGFy
YW1zLA0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHN0cnVjdCB1ZnNoY2RfdHhfZXFfcGFyYW1zDQo+ID4gPiAqbmV3X3BhcmFt
cykNCj4gPiA+ICt7DQo+ID4gPiArwqDCoMKgwqDCoMKgIGludCBsYW5lOw0KPiA+ID4gKw0KPiA+
ID4gK8KgwqDCoMKgwqDCoCBpZiAoIW9sZF9wYXJhbXMtPmlzX3ZhbGlkKQ0KPiA+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOw0KPiA+IA0KPiA+IElzIGlzX3ZhbGlkIGFs
d2F5cyBmYWxzZSwgY2F1c2luZyBhIHJldHVybiBoZXJlPw0KPiBJdCBjYW4gYmUgdmFsaWQgaWYg
d2UgYXJlIGhlcmUgKGFnYWluKSBiZWNhdXNlIG9uZSBjb25kdWN0cyBhIHJlLQ0KPiB0cmFpbmlu
Zy4NCj4gPiANCg0KVGhlbiwgc2hvdWxkIHRoaXMgZnVuY3Rpb24gYmUgbW92ZWQgdG8gWzA3LzEy
XSwgd2hpY2ggc3VwcG9ydHMNCnJldHJhaW5pbmc/DQoNClRoYW5rcy4NClBldGVyDQoNCg0K
