Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6D5279346;
	Wed, 12 Nov 2025 08:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762935472; cv=fail; b=dtHy15/xVoBVhvLY0qqTiLftHmz2GlOxATuyvx1o/3SZ2JSl2/86XSCw47o/gxzokyx1w0/WKqdd/d2qN7rp8PtSHrVQAjKUzmwQZvL9Rwa/MhVErZhGWIn7HgSHZaEXJ/4RMrmeHkwthCwEwfNKLACIaHAKLb5Xy0KMUNX3T84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762935472; c=relaxed/simple;
	bh=yDjWV9MZihJC9Hk4OzaNeFTfzMSRNhAqhGKc3t8hG+A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MhjI0cBD1QhG4HSsyHYp5gZxVkV9c3i4IHgXUEDkA1kDlr4xEJwW/XRqssv+tqUoacTl0taert22g7uN8lMzXeRovjjOcp1jF6jeM05eZa+QHt1Dk/RNu/WEVACnWQO5hAN4q+9Olhg/9eVs5+ZA9RhF4vuupkDRrNSBdl7zU9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Q20gbLwj; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=rPU2TP5A; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Q20gbLwj";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="rPU2TP5A"
X-UUID: 0da97d10bfa011f0b33aeb1e7f16c2b6-20251112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=yDjWV9MZihJC9Hk4OzaNeFTfzMSRNhAqhGKc3t8hG+A=;
	b=Q20gbLwj1HrLJGUne1h2R2tU2TmZ6IJTHqHr2cRQOAhb/bBs5W8RbwTLlEp0hy+SKs1XLFYA8s7z27QA6imLGqk8tU/DWk+37H52qlBWgB0j65XwCYeHOP+CKeSD556bOOaSE/dAIn9EERwBRNPRCbvbMhuf7IMWWy6PASGBalo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:eb9a8c17-1b09-404e-ad74-32d65456de26,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:66e6ce57-17e4-43d2-bf73-55337eed999a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0da97d10bfa011f0b33aeb1e7f16c2b6-20251112
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 490056142; Wed, 12 Nov 2025 16:17:39 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 12 Nov 2025 16:17:38 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 12 Nov 2025 16:17:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moX9rp7ncj4RdZjZmV+LLJemcwRnrAM4t+rL5gTCVEBPyJGjg0KKPQAAYgyWgCxKaDH5qIlYrPid0mgNHs+kE2SFDr5xxABbqo/5tu0l6hMVuikEc1YyiY+jT75os8HpGtLRIy1Bte72DOMasiGlHq/7xKGdZHWIyOKul/n+0OzNLAYMGvaTujx4F/tF8fjVo9ymeHNLzk7Dkhwii0RFRqo6GG97LzJgJ7VjSlvvLwAlQpWERASdg+MQx61WaHZGZ3nMTLRWQ0rertzF2BEamlsy5+83OH29/kL2ql7ZWir5hTLFmkgOd8F0nd5nIWyhA8kd7SLlV2qGd8Vg2+frAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDjWV9MZihJC9Hk4OzaNeFTfzMSRNhAqhGKc3t8hG+A=;
 b=LG/JAmWi0SAvk/bBclU++/zBboBET1pBTPCs6lMhsd2vlkfpz6ZYs4dpC0wJdd40Bu594ldBOUImIpP7p6KxkteSCqFFKkYMZJUB0WPzNX1UNkUTPh6IfHMZtbRfOB8mM/A94gy9yYKxwL9wdI1Foa3v6+TnuID7r8gWrk4cwjNM/zzx75Y3bP0wCL3REyd8APwY3UvfrpJtU1SKilFW5vNNduHHz7+veN2GrZYHj52SeHaO3XPv+szAImbV/oQQYdlhMfEzv6jtVuQWA+61gc+IWSnwLcXkKW+dRVgrufqydVyPc6SI5dbWd55B0mydUAIjjO8A5s3KU+IwfEd3Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDjWV9MZihJC9Hk4OzaNeFTfzMSRNhAqhGKc3t8hG+A=;
 b=rPU2TP5AjeIIkGUsPhDcjfAnsRnxFYEzoEKugUAlfHrb6LkmLRefOYMpTe18SJw8PpI80H4I1Csu+h/XpIRhIU/j25K/XAlL8qI7t1+edRruHGVflscpAzK4EtDTDFF4ACBVaDPlQSpaYwo8+gju6ZRx3EyZxsF+72rpu5ycLvw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7095.apcprd03.prod.outlook.com (2603:1096:101:dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 12 Nov
 2025 08:17:27 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 08:17:26 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "powenkao@google.com" <powenkao@google.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "mani@kernel.org" <mani@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
Thread-Topic: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
Thread-Index: AQHcU55F6G16JbOQOEePCVKNWnq4HrTuslIA
Date: Wed, 12 Nov 2025 08:17:26 +0000
Message-ID: <7d964e31162bf93f583e6e78a3044152894ecb94.camel@mediatek.com>
References: <20251112063214.1195761-1-powenkao@google.com>
In-Reply-To: <20251112063214.1195761-1-powenkao@google.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7095:EE_
x-ms-office365-filtering-correlation-id: 3a6eec8f-7073-496a-d36c-08de21c3ea6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?b0tqM0N3ZXlGdmlBenBhK0NiNFhOL1lUeERXNDVVRWFPQWE1aHZxaFk2Q3dy?=
 =?utf-8?B?WTVDWGJ4OWxNQWlxN25pQ241ajVCcFFvVkllMmZlRkdoYVRGLy9xbTdmN0Vq?=
 =?utf-8?B?V0xCRWVOOERobmloTlVOUTU3T3FMQXdIYXlrVUVSWFNTU1p1cEhOWm8yVmlG?=
 =?utf-8?B?MjhUSmdUVTl0OEZsUUJXL2UwZmVlQTh1d2NwZm5oQjA4L2JjUTc5Vm0yTDRm?=
 =?utf-8?B?MUs4MkNTWnRsQm5MajNjdnJBenpSYm44azJqV25zUnN0TW9DRExIbVhDMVBx?=
 =?utf-8?B?ZXluZmlmYXlYM0xJVjlyWk1Rek05c2VpR0ZRM3RlYlJvZ29CVjNYVWJENGQ1?=
 =?utf-8?B?RjBhck5hQ0VmVS9sT1BFZ1pkb0UwRVFHK3Q3c21YREJCd2k2QXB3RUZXY2hN?=
 =?utf-8?B?UFVGSFZtMUtKd1JxZGxTU2wvVGgyMmRpUU90TWF5NkI2UHNrZHdNQnlVOVpN?=
 =?utf-8?B?d01mOTJUc3c1N1BoMVJtbGJIek9WM3ljU3loZ1FKMHNSK09RK3MzbkJjYk5p?=
 =?utf-8?B?bVU5dlFpY1ZDQlk5bjlXWnozYVF5RTJZakpuU09QMXhEOVhJUERFZjJLZFRM?=
 =?utf-8?B?SitETXNhYjBGQ1dMK2wzdm15NGpkS0NRb3ZxYjVGb2NmWEVIRVNodjlNNlQv?=
 =?utf-8?B?bGhDQTJLTUViZWIrL25SNzdiMUFWZy9nbVdVN2c0eENqenhoZFFGMHhYL3gr?=
 =?utf-8?B?RnZ5K1pNYWpPalBhMFBkZS9jV2hzeFl1S3lZVU1temxLT3JWWVJiK0hkTGVS?=
 =?utf-8?B?RXVOSEJHcmxDVTgySGF3Wnp0MUxiK2NSRlUzd21JV2lEbDUyMXFncTRkWEps?=
 =?utf-8?B?ODQvcXNrbWlmZnJNMzZ0Q2hYS0dlU05nRnY2YUQxK25NSkpVekRsNzl4aVNN?=
 =?utf-8?B?OXpBSDZ5NnlHWlgrTXZiYUVyMzhKRCtRbS9NSnFTME9PNWN6VWtTWGlLQVQ1?=
 =?utf-8?B?UnVIb0FPdUk0YVU0VCttNCsvRzFmb09ZQmFkcG5nT0hqR2ViS1I5U1dZaWJu?=
 =?utf-8?B?NzVhQ3UxZGUwYnRwTGRiQ2UrUVV2M3lyVzBtZlhYcUNOVXQ5NC9UZlBIN0I0?=
 =?utf-8?B?bDRXYVpvNkMzREFQRWxEdjRWOTN4N0xoTEVZVStmRW03RUZaOTdHQ2tkZm5p?=
 =?utf-8?B?VmNBNFJ3aDhIaUwxTUZ5YXU0NEEwN3pZdk5ySGE1VGozVkVHZ1lSdmNSb3FR?=
 =?utf-8?B?UGd6WTFzaVNSeGtDaGhmMnNvVGc0WWNJTFA5TmZGUEt4WHk4UXBNNjdFMGlY?=
 =?utf-8?B?ZjgwQ3pCSk9TT3FjdW5MQ2dudzVReTJMU2dxalFvSThlMXM1TUpSRFJvd3RG?=
 =?utf-8?B?djNqVFNQelk1a1g4SUQxR2pUMmJGVWMyWkNtdk91UUF1QTlmUWJGOEpXd3ZN?=
 =?utf-8?B?VG1IN3M2Nlp4b0ExN09TZlIrRmZoL2xGaEhCVGJVUVo0d01tODVNd2lBU2JZ?=
 =?utf-8?B?cjhncFVCeUJZbWpmNVdyQ2JPb1U4elBnYTllMXFvRkVsWGpvTXJrOHZKcm1M?=
 =?utf-8?B?S2JVQ0l1Qmk2bXBEOC9jMXVOa2ZxaWFINVVzVkZ5ZXhITEx4S05KU0g1UC9q?=
 =?utf-8?B?NDc0SVEwWnBGV3BGTWFCZTlmb0lwRFZDVjRPamNyN2hvZ3lWVkc3dGZVUDgw?=
 =?utf-8?B?d2k3T2dXZlZCd240emdTbm1QZDFJYzZHZkFPNTdsYzZ1N3BpalVJNG5hYXVt?=
 =?utf-8?B?aEU5amJzYktvUlZzRll6V2FxUVFYaUw3WUFsWEZUSW8rM2k2QVFWYzNXcGx5?=
 =?utf-8?B?RTF5NFE0ZHNWVTNGY0pmclNkbSsrNTJUb2JER0tBWlQ5NnJZditIeTdIb0wy?=
 =?utf-8?B?bkVjZEpycno5OHJ1Zm5zd3dwcnNuVWVYT3BVeDJWREl3ejNnd2dibDJoa29v?=
 =?utf-8?B?cnltblllQWQ0YWRRc0IrQ2MrS3BzMzgvRTZZS2wwZ3JFMDhYUGlydFo1Rkp2?=
 =?utf-8?B?akJRZVZpNHBEOHQ5NStyQjRSNTlGclJFek1ETEZ0QUdiNUtHV1pjMlM0N3l3?=
 =?utf-8?B?UHQwdG1wcS8vOFNEejdUbVFKU3ZMWmszWmVvWjV3T053bWkrYUV6S3BtbzNl?=
 =?utf-8?Q?HcYnMW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVdsK0xINTk2Wm5ocDBwY2ZsYytvcDgxWmRZc2JKWDVlUk9ncTB5ZFJReEo2?=
 =?utf-8?B?eHY1cUxKQllLM0dTNHQvbWt4RWhQTkR6S1Z1KzJxd1RoZjh6aU0wTitTNHln?=
 =?utf-8?B?Z3d3T2hxRDh1WXFEWkNCeHhueFdqcis4R0RNTXdER1RjS1llVDBiOC9jL3c1?=
 =?utf-8?B?cEQ5WFgvTitadGppUXE4WThaN2grRFF2ZmQxTG1UNjBBVzVqcXVuM0xhUnhq?=
 =?utf-8?B?T0pic0hYNEJtQ1lIc2U2Q3QvWGRaWElGT1ZLRXRTS0xia0xGOU90SzcxcWdz?=
 =?utf-8?B?M2RVdVNQWkNUL0RoYkhqUEk1VlFYSElNclNGNGtNaTdkTXo4S0dTdkRjV2tY?=
 =?utf-8?B?eUhURlZlUDlQTUthK0lVYkw2Mkh4V0VQbktQa1Y0QlFPeVl0NHdZZzZPN25X?=
 =?utf-8?B?VUllcTZJTmVGN0xSTHZXcjNSVVk5Y1JMdHdGQjdsNVQ2aVJ6b01nVkpHV1Nk?=
 =?utf-8?B?ckg0MW9IWEQrQU90Nm5QZWIxcUVrWVVsM3luY2JzbVMrUHBSKzFLZ2sya3Ev?=
 =?utf-8?B?Q3BVNXJlTkNObHpvWmJJQ2UraHRNRUlBU3V4NFI5anNBYlBETHBMa1kyUUxN?=
 =?utf-8?B?Mi9QeU9NMHBaeHBwWi9uVzFtMnhFZnNsU2o3RVFjdUxqZ0hIODJ3andLTVM5?=
 =?utf-8?B?YkVmY2VUeERSWmd1ZVJJRHRGeEc0djlFZE8wemJ5bDlFMEZUUkRnWmdTdFp5?=
 =?utf-8?B?WENMRUY4L2hoeFR0NGk4Mm5lQnY0STRjMmRDVnRuTWRhU1RYeFNkd0hXTGlQ?=
 =?utf-8?B?Uk81Qm44d0w0Zy9jd2ljOFZxWG1SQU1lTnFQNW9rOS9yczdIYjhnTHp2NTc4?=
 =?utf-8?B?R21Id0k0Snc0bTU3NGd4bEpZZFlPVU85SmxmeXgvL0QyK2dYcHJjUjJ6SXho?=
 =?utf-8?B?V3pzcHlDVE04M3dNcHpTTmx6aUlzVEEyMzcyZmJFeHcrL0NCUXU5TW5zeWlR?=
 =?utf-8?B?UnpkRENxK3VNd2ZFbit2TzRER0lKN2RWVDJkcGNHRDRZSkNKcHUwc1RyU28v?=
 =?utf-8?B?TUovZFZMdU9WL2N5SXh4VCs5dWxBVGFxeWRPcFNqWWx6SFhjaVlJZDhjQ0RP?=
 =?utf-8?B?TUVIRmgraWlOS1hqMXVBNnlZUlR1RFcrUU9FTjhiWTVpU1drYlVrM0hFRXVP?=
 =?utf-8?B?c0ZJQ2ROdlp4T2VVYUJadmhYVGpHWnFkTEdqZ25hSVFJbGl6am93NlJZUWZh?=
 =?utf-8?B?aDdTV3c4N0loWWQ1a1R0YXNaOWdoUHZCWE5md2ZYYnl4N1VrZlJtajZST1Zq?=
 =?utf-8?B?U0pkaFY0aW1aODcrTXM4VDQwVzc1aUk0RzQ0ckUxN2lzclNYY1g0aUtPa1Jk?=
 =?utf-8?B?cWV6TlRJYmM2Uis4ejhDMlk4bGpYcVdYd3kxaU5zcVRSOTllczk0QTg0dEc0?=
 =?utf-8?B?NmtpampNZmVuY0JRMnFOOE1FREx6ZmFneFhmU091eDc0R3lTcUhDdGFCMEcw?=
 =?utf-8?B?eGRYb1JPd1RpVjkwN1YvVzhMNmZCSWlBaEVCd1F1cEFBQmtEUnhZTjJreWRu?=
 =?utf-8?B?RVhkQ1RQR05pK0hnRGZMV2dKbFZJUm5CSkE1aDhPTnBHMnFVb1RnR1I1OWpl?=
 =?utf-8?B?NUJJSkNDeTBtdUM3bExLdEhIOG1aVS9QVE1JN0JQa04zTExPdUxHSWxkUFA0?=
 =?utf-8?B?L2YzdkhkcitSbllEcVBGemFVOUhteDFxY0ppU09LeTBZT3ZIVnBzdmsxSmQy?=
 =?utf-8?B?akNSR3FrT0s0bEhROXJVL0VuSFNFaHJ1cmFOMFFHVFhmbWpkOHV4MUl4bDBR?=
 =?utf-8?B?THRZcGlTRFlMYy9YMFN2N1BUL2NsN1VpeUZQb29xcStaY3duSXBNUjBYT014?=
 =?utf-8?B?K2NPaVNBWHRZSnp1K1ROakRNV1RRK1NuZmNBMGxPWWNoeWRUUFdrTXZIamwy?=
 =?utf-8?B?L1NJQXE1SUd5eUtLc1lYU1lFWVA2QklMY0JZK0YzZXBOeCtQaVNHd2F5WHhE?=
 =?utf-8?B?dkkvWEJUSVprbElnYTlKc24vUHcwUzU2V3R5SmV6dmFwZTlPRGUyTG9aUGhy?=
 =?utf-8?B?aHBOL3JCdFp3VHRVeE96UFJJQnU0VzZQc0xpVXVNa2NJKzJnMU9zYWREd1lt?=
 =?utf-8?B?dG55aVlOM2ozRlNuN3p0Nk5HQ25WdTdTWlJtM241RHYwcEtxV0srSE0vK09V?=
 =?utf-8?B?VHBTbFptWXZzdFZPb1ZLbVpMQXkxcnhLUytZWTFrT3hxeldXOVBKU0liYmdO?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DF0C68D5B0F4740A77FAF7EFE1B0F10@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6eec8f-7073-496a-d36c-08de21c3ea6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2025 08:17:26.8502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ERX3b8/EouLSUhHOkc9yG5aAxCNVFEa9IxIjum9NnBlT7n+bCIxNCUpLgyCkKaF37QdJ1zgJb+IAsKNyQ9rn5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7095

T24gV2VkLCAyMDI1LTExLTEyIGF0IDA2OjMyICswMDAwLCBQby1XZW4gS2FvIHdyb3RlOg0KPiDC
oCBnb29nbGUtdWZzaGNkIDNjMmQwMDAwLnVmczogdWZzaGNkX2Vycl9oYW5kbGVyIHN0YXJ0ZWQ7
IEhCQSBzdGF0ZQ0KPiBlaF9mYXRhbDsgLi4uDQo+IMKgIHVmc19kZXZpY2Vfd2x1biAwOjA6MDo0
OTQ4ODogU1RBUlRfU1RPUCBmYWlsZWQgZm9yIHBvd2VyIG1vZGU6IDEsDQo+IHJlc3VsdCA0MDAw
MA0KPiDCoCB1ZnNfZGV2aWNlX3dsdW4gMDowOjA6NDk0ODg6IHVmc2hjZF93bF9ydW50aW1lX3Jl
c3VtZSBmYWlsZWQ6IC01DQo+IMKgIC4uLg0KPiDCoCB1ZnNfZGV2aWNlX3dsdW4gMDowOjA6NDk0
ODg6IHJ1bnRpbWUgUE0gdHJ5aW5nIHRvIGFjdGl2YXRlIGNoaWxkDQo+IGRldmljZSAwOjA6MDo0
OTQ4OCBidXQgcGFyZW50ICh0YXJnZXQwOjA6MCkgaXMgbm90IGFjdGl2ZQ0KPiANCg0KSGkgQnJp
YW4sDQoNCkhvdyBpcyB1ZnNoY2RfZXJyX2hhbmRsZXIgdHJpZ2dlcmVkIGJlZm9yZSB0aGUgcGFy
ZW50IGRldmljZQ0KcmVzdW1lcz8gSSBtZWFuLCB3aGF0IGNhdXNlcyB1ZnNoY2RfZXJyX2hhbmRs
ZXIgdG8gYmUgDQp0cmlnZ2VyZWQsIGFuIGVycm9yIGludGVycnVwdCBvciBzb21ldGhpbmcgZWxz
ZT8NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
