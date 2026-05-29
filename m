Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BE13B530D;
	Fri, 29 May 2026 08:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780044048; cv=fail; b=QSAoe4GhRvIprZyDyoifNF0JGf15gw7V0lbr7GY8b4e1nRQrDpZPsvgxkz/BJsJCj3nUmmUXnoCCn7VuAJWzHZ6MLReDcOT/1kybTfVJzgbGDj/eXVNK0d9sYs96NrvcYLM1YEYd6StnaoK6LLIop37OtisuFYWcxwIweJMTZNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780044048; c=relaxed/simple;
	bh=O0dovzUDA4MUsK5YbGz4ru3GGqNAYH1VV4De8pCeR04=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c+arE60+6zNEu/0wRDZS/ce6gzpiAG11jnqDeV0LohIelpQPjEYkS+dEgHkVvypkG8HRSjVNb3Qw2+mpej5INrovL4Lu/c8vx2isSA9xSf5fwIzuIJbZhqo0Hrg4dH2pipZPbjlMJo5q3xLEF/DnH1P6urYtxz4A6aZ8ZVwAg2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=OGJ+2rkg; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=cTDXmZJ/; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OGJ+2rkg";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="cTDXmZJ/"
X-UUID: 1178b4fc5b3a11f1b1788b6acf885367-20260529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=O0dovzUDA4MUsK5YbGz4ru3GGqNAYH1VV4De8pCeR04=;
	b=OGJ+2rkgo4WJ1/ewK4GW+d/s0r9E6M0IUCWZMzs81UrRftInbYyJ3BAQ14ohNbdiZ3juUluL4RXZvHe3b+3ynmj8fzq76hp+6KJDfiR4KQH/peLxSW/TSeKh2QBqHdTDtEfCWMZ09HlW+imEOz4bQfAa49a95uAbyAsOMJd2D5g=;
X-CID-CACHE: Type:Local,Time:202605291604+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:e38ac99f-e4be-443b-9bdf-c8cb49540af0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:cd96864e-8d42-4275-b2ca-0fdb78df1774,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|136|836|865|
	888|898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,Q
	S:nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1178b4fc5b3a11f1b1788b6acf885367-20260529
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2029333822; Fri, 29 May 2026 16:40:38 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 29 May 2026 16:40:37 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 29 May 2026 16:40:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XE2BvT6m1VRjlqjRGd4z5bFWMn5PuQzkrETMB4nMwTrnOUsi18IfwObQWLAKJRmY0i4L+pcjWUAV0qVVGuGb5QqYHUMeRXfamqS3CGRmoZ/1rTLfHjEC1rpz/EfKwZJwSG58Zhptw0BZB+EdzkfnuSCQzy/S8bR5aTFkcHXO3Ol83t7XorSVAG5pjAVH+Jq675VMGiJBm76eRJWW+Z778BYRIm/pcYfsZdgCxy+1yTGa2GmMFPipBLRjKUqaadsyXz2S0rR4LN0UuqpmHPh9Ttw8g/JhH1rvpsqC46eorgkt5EgineqojlW2LJlqgxaBc1qrCygO5p9lwOgnVkyS2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0dovzUDA4MUsK5YbGz4ru3GGqNAYH1VV4De8pCeR04=;
 b=QqDmzvVq6C6I//OxXqGoA+zBjtQbRyKcSZ6TbCewJPXZ7bt2jdq6eQdzRkcBZWsI7UotZFW+6nj6a87mh2nZQL5MlN1iDiZj86f4QHTSuzeLTaucxAONs34gI57wEtfHtkZUM9T/ip7mvhrK1O1OCj6npUGHnJtIGz/Tcg4aKRuYMt4KkqOp10WtFWeWCYgRRWyhqVWKyQzhS5W0k1YEAlmiOTSfbUHOFGhAPS4a3pT0qtN2lG777B6RiEV4QLgcVaMD0u3YJoDUxHWki1bxeY2Lq4aTuZaRJVn/WPD3UNpqjr+Pj9bAN1jJZYZ5frfU0td/rOGALqM8tbVdPFobcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0dovzUDA4MUsK5YbGz4ru3GGqNAYH1VV4De8pCeR04=;
 b=cTDXmZJ/QPGvQhHE0V0UbA06cPqnLRk5Zb7n3Fd8ux6BaQ9uRjaduel5PbuYflaS93JwEfk6h84PMmZTlS95HrKNpuNyHvNtwq2Hg7kRO3FQKRyrFGaF0NeBOlt8LA7iBzRd2w1rp/RqLqN40ALYSFsJxdxNQlWqPFyQ+uqgaKY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7608.apcprd03.prod.outlook.com (2603:1096:101:122::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.4; Fri, 29 May 2026
 08:40:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0092.004; Fri, 29 May 2026
 08:40:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "quic_rdwivedi@quicinc.com"
	<quic_rdwivedi@quicinc.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>
Subject: Re: [PATCH v5 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Topic: [PATCH v5 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Index: AQHc7wiYvGaU9LCfpUOGYkJrMMRzDrYkpV8AgAACSYCAAAflAA==
Date: Fri, 29 May 2026 08:40:32 +0000
Message-ID: <f2e1a0335a7c05ca7dbf48c17e9662e9695ded51.camel@mediatek.com>
References: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
	 <20260529011421.462046-3-can.guo@oss.qualcomm.com>
	 <1e432db04abc12c4109754788ab36a09111cf3e9.camel@mediatek.com>
	 <7f2f9a0a-03e9-4a0e-ae57-2b0c557e029f@oss.qualcomm.com>
In-Reply-To: <7f2f9a0a-03e9-4a0e-ae57-2b0c557e029f@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7608:EE_
x-ms-office365-filtering-correlation-id: 2eb6a58b-7a45-4c8b-819f-08debd5df234
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|38070700021|56012099006|11063799006|4143699003;
x-microsoft-antispam-message-info: KFAq0k4h9Tg6NHOZuTgrwLPhoeds/ssXF1v3MMR8a/dwxQ4uOOgy5GU1UiE6movMjNvfX5KU2X8gGVJjwUT3aFoqMVrVlMt5jYqNvZbZbjzI0hYLELKiIFvpKtZBp5c174qHdxVNMiYDnww7gFT1wlj/mokqhXW9fDkrylpWOpe4sfi5TfEYmtzAM7PzZSJqsXF5VnF9mYs8CF/D8xcG5wEiWvfOgKazkqRtVL2CNh+beLZZJRURTNqRMWUH3WdXTZ01guL5R3E9QP/oHFwOF2JRxy1EtAsR+VistE6opU5SucY2MdBn3QA+uSoXb/61RslJvzGzZl8y99N/JBGRfKDKYORNzFBW19bZhNcgZ0Aaj8h/q3FHiu94coGJYrrSBdjYqwCKAYlGj9DB9IpEmh0xfBWUws63yFHAPj2e5uWGDwZd0JeTCdo1xeiG8bf4+/n7DzKc1hWgTWg2nJttBwqhrMi22NZcd8CwMv+SNVPfszP3Rx/RQ8sziVI30oEPWv7avtDBL4qevPlQ3oJTVnZcAI8pP1cta5nOleThml04Dn58xR/yB6tkydRJQXo61ex2GnVg4YtMkA7hRb5fR+tU88r2BSZaETXHRsYqv+5Z5MMydtnf730ACjch/OxFgeZHIXjSYob2vyXl7SqxxzPF6dpNeUxcfBn1hlHO+hnCI0wazQQhK/Qu82kHZIkr9RXQ2f8VqkaaYu4waqChsm9mdmeTLX29MtvWE/qhRx5QraM2ExGWiKvLpvJp4pxm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(38070700021)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDgzQkZ5WDNpRUpHeERpOGpDMGZQT1lmZW9pS2dURjdrVkpjMjZ3OE5YaWpq?=
 =?utf-8?B?T2pxdTY2RzBTdlFaSUFzaC9ldWs3ZERlNk55V25mUXNMQ1JwdE5rRm93Rncy?=
 =?utf-8?B?c2tJNjVyZXIwSGZqcVNvZklDc1dGL1o4UjRzbG1vRUdTcFplS3FlZW41U0hm?=
 =?utf-8?B?QXJMZEdlOFY2UDg4Wkh1R1lPb2QyUG1ZSXNrZXVldEJoaFBSdkxLYUUxZDlm?=
 =?utf-8?B?TTNJUTRXMVRTcDc4dVVDTkhJTDFPcU4rT0ViSEw4THJFUFlPNGZOcm1ra3BY?=
 =?utf-8?B?SDlUaER4M0RLeWNrc3hBYVFNUzZSWkFJTk9rQThpZjA1dGozRmxRdXFrWVJk?=
 =?utf-8?B?MmtWQkFlMXZaT3VYMTNsZUZnVEEzU1luYWRDTi9ZejZtS2I1bThXTkpxZEZF?=
 =?utf-8?B?MkU4a2MvU2RuNlRGZkw1ZHIvWkUvMmZiQVRqbm1sVDNENGxPWTRJRDRucUhZ?=
 =?utf-8?B?dkxoVWxicUpCbkdXc0MvbDFBQWxZaE5FTGc5Q0pFMHFiTE5WMDV4RHlBMnZ2?=
 =?utf-8?B?YjJ0bnlTa0JkeEg4MDhhK3dDbmYzM1pwOS9Sa2JyTjYrcnd3U0lIVHVVb3lx?=
 =?utf-8?B?Nmg1R2FMbVZ4cUJDOU5DSjRiNnFxOW55U2grNDdLWDhDWHd0Qm5TY1V6Qkdm?=
 =?utf-8?B?RXBoM2dqVG9mUlljcUo1TjdzL2V2ZEYwT2t2ZVFtWmtiU0lyTGh6RXBjY1l0?=
 =?utf-8?B?MXNHcVhNMVZFL29BY2lIOFJsa1Z3RDFxTlRGQnk1dUYzemcwMU1IcVVJdStw?=
 =?utf-8?B?WjJnZ1J1TFpHTWh5T2RXcFcxVG5XWWtncjVGWDdFZ2krQjJvUlJOWWtRdHVs?=
 =?utf-8?B?KzI1RkN3RTBoWUlVY3pZblpKWlc0SGlFcDFpdE1iM3dqOTlWUlBhdUg5U0Z4?=
 =?utf-8?B?VXFIWmZVV0w5YlJxRDRVN2d0WHBma2VXVVpSejlsT1o3NThtU2RJNzlGNHVz?=
 =?utf-8?B?VFUzZjJVY3BGVVh4RWsxdFNqako5UXFZcy9EeElRb0kxT0UxNnd2SzBJRWNm?=
 =?utf-8?B?cFAva1VtOHBFclVzb09wZ2luUGkxclFZUmJ1SEpPa1RZR05HMHJVd2FMREJz?=
 =?utf-8?B?Z2tsVk1VL2FGUTBvOWpWOUFXc1Z3ZjBoOXpaU3hHZzE3aWxJNytBVjFyUy9y?=
 =?utf-8?B?VEVDcW5kZFdsRVdOaFdvWk1OMjQ3c1ZQeGVQZXBhNUZDdTJER0FtMmE1RDQ0?=
 =?utf-8?B?VXBIZVh2U2JKdmhYR3Z6TEZZYy9LU3dOUlA5ek9vekFGb0ptMHNVanRKYk1q?=
 =?utf-8?B?b09rZUZZcGR5K295RWo3SHhYek5MTGZVWDltUnQwZzh3VDNYWjVRb0JMS1RH?=
 =?utf-8?B?RVM1UGlSdmlGbldVSE12aHNrVzBSd2pjRC9jRTZvVUFwTlV0ZTJHODU4Q1lD?=
 =?utf-8?B?d3gzN0JxbG1XendCVHkzdTRxL1hYQmJjb3hubUIzUmR4OFBpTlJIVjV0eENj?=
 =?utf-8?B?Z2pCMXMwZkVNSWRYVVo0N0lucTNlaU1JaXl0RXFDb2g1L3hDS3JzVmJWMDha?=
 =?utf-8?B?bHM0VWFHd2ZDSU12cnQwNGF5OGM0YnltNjFnUWFKUko1bmh5QzlGeDliUmxL?=
 =?utf-8?B?NDVZZVVKMWs5amhNdW9OeUEva1M3bkV4VlMrck1HMlM0Yktta2RIbFVhNW5T?=
 =?utf-8?B?SUZybHNKVkFHZDhBNlF5clQ5UXlVenRnQnAzUEhEMmpOYnM2K2J0bVgxcHJ3?=
 =?utf-8?B?UWh2aXVQNEtMcDBRb0ZUOWp6T2dOelVZcnMyRDZ5YitRVzhtWkg5TGJwM0xL?=
 =?utf-8?B?K1p6S21rbDRVcmgrSW9wVnRwQ1VzZTdPOC9XTGZxdFFDMVZqeUdsZDdkaTNh?=
 =?utf-8?B?YldZYkd2UXo1U2ZFVmRnS2wwd1NLVy9jWFZCSDV3S2N4WWxZVFNnRm81dHNR?=
 =?utf-8?B?Z1daNURGREUvNVlqbEJnMnlxT3NmWUJEMk9sWE1tNUIxd2Z2aDM3YkM2SGFy?=
 =?utf-8?B?eGxuRFlXaDNuNGsrYWZXZ01BUXJNOFd3SDVHU1BPb2oyYkJoQXpzcWoxU0dM?=
 =?utf-8?B?cFZCdjJpcGZ6ZlI5bllmbnlBc2Y3NHFlSUVHNUZ0TzZ1czN0bnZiYVc0TmFR?=
 =?utf-8?B?eE84K21ZenJaK3JmS1pXMENuMVdLeUNNWXdBclpjZk5GbGlvaSt0aE5ReGpo?=
 =?utf-8?B?V2ZhV0dJcGtVNDQvVEhWT1dkRUwrVmUyWHJBRXhDVHN6NUtxYWJyR0FnSVRV?=
 =?utf-8?B?NkhXZGEycXk0M0xpRkUwRDg4d3hUUlo0VnllVmk4b1FFN0R6TmtVbGg2L1ZU?=
 =?utf-8?B?U2JyL3QvS2VBeE1YbHNFZno2blgrZ3N1VndEcm5OZFVXeTA3cmp6dHhKMjNn?=
 =?utf-8?B?QVc3S3pUbEZtaWN4TktIblhoemhUTS9KR2dWT0tlNDA5cHVQTnExQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <096FF941B0BDE64F8A8D9E251D527592@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: pztmsctajRx/X8tV9i31iB7LyFzwLADUcpCg7aE8CVz2UuaKxyEnOf2VMz1VYr6TLbtRXsSR3IeeHZFgykiJHG3Q9ylEqPD4J+rShNHpln9uZn36vxx8Pmeavaw9S4FVCgEAcsyitjzVI/FlnsvQHDmcWfS3ul5MNV7ocnIm/ftrTvF80vsrNMCLoAvoMZG5K5r/CNDpBhKL2gXmQm/gxzj6Y18YOUhOQ46Ex+4+X2Q7IIXDnFXBlULMGtKUaCP+BgvR/IHuLtTsi4VRB0Hdijle2k4DZ8u9CAckamOciJ9uILx/ZR6SljLcV2i+co2J9AE0FAl5HRzRQU1FkHv8bw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb6a58b-7a45-4c8b-819f-08debd5df234
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2026 08:40:32.5760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QLWYd+u7uJP50v5cRjvMIEYUleYn2XghNwfYEe1MFEvVoNv4cVzCAV56Ckp+pB4zxS+S1wlwBasbJG+fjVS97A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7608
X-MTK: N

T24gRnJpLCAyMDI2LTA1LTI5IGF0IDE2OjEyICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiA+ID4g
K3N0YXRpYyB2b2lkIHVmc2hjZF9wYXJzZV9zdGF0aWNfdHhfZXFfc2V0dGluZ3Moc3RydWN0IHVm
c19oYmENCj4gPiA+ICpoYmEpDQo+ID4gPiArew0KPiA+ID4gK8KgwqDCoMKgwqDCoCBjb25zdCB1
MzIgbHBkID0gaGJhLT5sYW5lc19wZXJfZGlyZWN0aW9uOw0KPiA+ID4gK8KgwqDCoMKgwqDCoCBj
b25zdCB1MzIgbnVtX2VsZW1zID0gbHBkICogMjsNCj4gPiA+ICvCoMKgwqDCoMKgwqAgaW50IGdl
YXI7DQo+ID4gPiArDQo+ID4gPiArwqDCoMKgwqDCoMKgIGlmICghbHBkKSB7DQo+ID4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm47DQo+ID4gPiArwqDCoMKgwqDCoMKgIH0g
ZWxzZSBpZiAobHBkID4gVUZTX01BWF9MQU5FUykgew0KPiA+IA0KPiA+IFVubmVjZXNzYXJ5IGVs
c2UgaWYgYWZ0ZXIgcmV0dXJuLg0KPiBZb3UgbWVhbiByZW1vdmluZyAnZWxzZSBpZiAobHBkID4g
VUZTX01BWF9MQU5FUyknIGFuZCB0aGUgZGV2X3dhcm4oKT8NCj4gDQo+IFRoYW5rcywNCj4gQ2Fu
IEd1by4NCj4gDQoNCkhpIENhbiwNCg0KTm8sIHdoYXQgSSBtZWFuIGlzIHRoYXQgdGhlIGNoZWNr
IGJlbG93IGFsaWducyBiZXR0ZXIgd2l0aMKgDQprZXJuZWwgY29kZSBzdHlsZToNCg0KaWYgKCFs
cGQpDQogICAgcmV0dXJuOw0KDQppZiAobHBkID4gVUZTX01BWF9MQU5FUykgew0KICAgIC4uLg0K
fQ0KDQpUaGFua3MNClBldGVyDQo=
