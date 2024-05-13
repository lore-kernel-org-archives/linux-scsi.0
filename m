Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318361474B1;
	Mon, 13 May 2024 09:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715592772; cv=fail; b=ETgeI/KPRjW1c+y4MGZ4gvU8fRVzGuURz5EekM6R7E7SZ1UqUotHOc27Ido1V3aGPp5i91rqp+OyAxtc/OTkQ3lPmBVS9ovFvRAj14BmM5FjplqQ+iBiwQvlhmyTZExZzLrAU9I+IzJ036z3samKDGjjSMInGYyzpvQh430SPZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715592772; c=relaxed/simple;
	bh=4xt+CtooHcFHb3Ks1uxwLKLvvtgwFEuU5TOV6sTs47U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aicL/DaIr5oqJ8N8mGeT4Fyjz3pLWnpJInKA/v0MudAG3vk0re+IQzsvSRhfR8Z33emoStT0RAwQZj5zcGWMZNX16TZNsJY1zxoEM8o9DLqnaWrpbdtj3X8qzTWNSCOryWnfWtrIXxLrnVgmYo9KTCbZ/Wi1BEehvA9PJ773WmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Y6rsFLQr; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CCdJwoHm; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Y6rsFLQr";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CCdJwoHm"
X-UUID: bf6db7cc110b11ef8065b7b53f7091ad-20240513
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=4xt+CtooHcFHb3Ks1uxwLKLvvtgwFEuU5TOV6sTs47U=;
	b=Y6rsFLQr4OUmASL1moSA6uGVWL4hDUUGXCj0StsSEV46+G8wCvDbRtSRmPgFt8zzflpPQmsQCenF+3p7vHK38XUB+272cXzRtVU1t5vxVYzmgvRWwtS8vCAkcYx5YXNMuOhL9DtssEDU9sz+/0QjG12yMo7QhjeNjmRGROO+97I=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:0330a417-ad8a-4cb4-8447-64d2051ee166,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:82c5f88,CLOUDID:25f54987-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: bf6db7cc110b11ef8065b7b53f7091ad-20240513
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 233137109; Mon, 13 May 2024 17:32:42 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 13 May 2024 17:32:40 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 13 May 2024 17:32:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbdulFF6Bn45x105U/0dYYeVTqHGwhImyrnvqIDKUTAQu7GtGZyhMHQbX2gp++UonhZiAEmel78aVYmRafa9icDIUnViNSrKaJi50f8qK0238T3vkW5NCskyqOcuHKSGzKgPGe28fsx5a6v/GgsKFSz3Ss9H6FBshkR1fZwKWxzWVauN1Q8tLTJlLc/KuTc7NKDip+4sdHaRUvamNhoyzBGgsc8qPuJg1cXrlm1xqwAYtZK6bhLu1VqiE/kFuCr7Mui2VseOjKfo9r9NNLtunCzKilll7Xw0UgUdh/rRyUeo1nQrbj0WKAnI52KbIVN+cbt9tsoJYpGVU9/PLDn23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xt+CtooHcFHb3Ks1uxwLKLvvtgwFEuU5TOV6sTs47U=;
 b=NGnMYK0uDVNmeeQ0UJ7h6qRbRmdnC76XWxXqJwPsJYOwGIaQF2Xh4HhmMm2IsNtXaHNHbwvBycInXKzWLZehftoadOl5gNtJUzJrghevE7cMSJ06EsIuw+VJx5tcAyLSl3yd5UjCl6ACmYX2JXW0upYBocrWILFzpRahDTe/AQbMuvcaulyv0pjuG3XqL1kVpijicUdkPbXSVi+ZIGp3vrSejSJYAEgbTzpDbpEm4lAUsuRoq4/jx0NbXLyhExvtTWqkYRvbhgw9kfvW4nPknRzesFLAtAZa70eCQLliNn+HsLFxk/gt7zzxnyyQliWgxGEB3KwZWvhbT2ofF3S2kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xt+CtooHcFHb3Ks1uxwLKLvvtgwFEuU5TOV6sTs47U=;
 b=CCdJwoHmwr3Pp/ugHDyEWsFgQ+9bwZJmhJWeNGzBPHK1WZBuPeN+Y1Eoay27HWHlSmxVIUgb/R8a6wKZGHNgN5T2XC9KUhzZJm6fPAYesZj9o1fo77O/S0IOKrIAVL+VwzXl/a0uO00kpg4bSUQ2nRdq5Cz/JPrv6cjp01YLATE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7001.apcprd03.prod.outlook.com (2603:1096:400:26a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.22; Mon, 13 May
 2024 09:32:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7587.021; Mon, 13 May 2024
 09:32:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>
Subject: Re: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHapRdgi7aurfXIZUWjZ6lAEDvMULGU5syA
Date: Mon, 13 May 2024 09:32:38 +0000
Message-ID: <95c026bdb884a27bc6f954e3c01113816723c999.camel@mediatek.com>
References: <20240503113429.7220-1-avri.altman@wdc.com>
In-Reply-To: <20240503113429.7220-1-avri.altman@wdc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7001:EE_
x-ms-office365-filtering-correlation-id: b8b09392-d207-48d3-007c-08dc732fa13f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?a0FsNi9QdmZUZVVpNmFQSnpkdWhDRXR3UTZVN0xOaEt3dE10QThMeDJXY0dz?=
 =?utf-8?B?UDVzeXNJbWtIZTRhNFVOY1hPLyt5cllrOGxtUTFzT25JYlFwYUVmVXhmSjVx?=
 =?utf-8?B?SUdkR29VeHhReGcva2dTa2x0bnZIakxZeExGNU9vMWF6TXo4Q0xkakxnZlc5?=
 =?utf-8?B?VDZlTW1xUjRVN0pzQ2lySTIvRmdRVnF1eWRTZW9KUUFrV3RGNmxKNDRJWno5?=
 =?utf-8?B?NzAxeDNzMDIyNDZRYWsyK2xEYmcwQWdqSnNUL2NHTkRpcUFsZ2NlY1RTcEY5?=
 =?utf-8?B?dm5zMFcwRUtOL25WcndNM2ZpbzcybHo5Y0txUnI1TksvbHMwVndWN1NORHBn?=
 =?utf-8?B?SmxUc1pGa1R5bTRjQnJRQ3pZUnFCUWN6UHBtSkNlMmNVcDdCVHorNmN4cGlu?=
 =?utf-8?B?OHJOMllRaXo1S1VpVVllOGY3aEs4b2RValFzU0IzTXFydG9NQjR3L0IvOEV0?=
 =?utf-8?B?TUx5M0VJUnNWRDJsMHRVZzFPWFg3bFMzZmg5VXFHd1FFU3pvdFBpM0s5QW11?=
 =?utf-8?B?d3BZMnUrdVcyM0Zkdk5PQzJlZGg4NVo4cG5KSElyN05xQ3hSdDFPanJSL0JZ?=
 =?utf-8?B?UEFKYm1pV2hyVnpKRmNkdFNEcWx5aE5WMkkxZzQ3czdpMXh0MEJJanExd0V3?=
 =?utf-8?B?Z0svZ0FWQWd3Z0VOMlBHZno4WEJieENpLzkvb090WXRycWh4WkJGbkhFU3FB?=
 =?utf-8?B?aExEOFArbXdIZ210UjZCUW85SUxNZDNsMkxDcUhKbUwyb0tmbVRlOGRxVEg1?=
 =?utf-8?B?WjJBN0NUaHlDRkFwOGRZa2s5VWU4U01kTXJTby9xcEdqK3FSN2ZXdHptRmVH?=
 =?utf-8?B?L28weENWbncyV1RSLzlyT2NLRUhtRklSbDRrWjMvVE96VGlnWmZ0aW9pdENX?=
 =?utf-8?B?NXM2WlA4U1BjQzZYRElRcnB0Q3hhSWpHSWZISmJIQUhKSko5TlBPajBENmNi?=
 =?utf-8?B?dnJpY1Q2ZmNwZFAwS1FDL21FQzBodnJlTW1aTjZEN0V6emhkck1XcFM3YzJM?=
 =?utf-8?B?R3JXeUs2QkNMdXBLaUU1azU1NjBIcWpRVkFFT0VrVisyN2Q3TmtQeWFEVEs3?=
 =?utf-8?B?Q2F4ZC9MVGQzTW5DckJ0SCtFOUpIT1UzbDN0Nkw4ZWdCWEEyQThVUkd6NUV1?=
 =?utf-8?B?SVFwRmV6ejRIRlF2cUxldjVUY1E5V1hVV2NGZ0RRVlZKczhJSC9zaUFlY1g5?=
 =?utf-8?B?d0dYS295RzBVMnhtSUZLWWx2NUVOWEx3WTRuS3hyL1RJUHpZYnZKb2Y0dGVa?=
 =?utf-8?B?UHhCY29kUTByUnhHSUFuVThDQmk4UkZDK3BWMjlBMnQ4K0NnRWo0TDg5Smwv?=
 =?utf-8?B?ZzJ0N0h5UGVpOFl4QmFsN0NoV0w3WkIwK25KTVRXYnMxYTdxdnI3aEUrNE1Z?=
 =?utf-8?B?K0ZvQ1N3b3RsSkxZMHVxV1ZZekJDZC9qU2tRTUE3ekd5dTZMY2V3UzJlNkk2?=
 =?utf-8?B?T3BhOWlsUXRCR1RoUWJ2V3VwbGorVTBuMzlnTG5FMFZqNlJJOFJ2Y3hORDIr?=
 =?utf-8?B?K3huUmk1WlJ5OTVkNjJlcjJVbmgyTlAzdE9HWXpOTlNzQlAxeTZlV3RIVHhW?=
 =?utf-8?B?cjJ3cUJJYUtxNnRTR2NPN0RLSkFsLzRYMmEzMGxqbW9ObExyeEhUaWpmTWFC?=
 =?utf-8?B?TjhEUS96MzN0ZVJqV3l4RWdCZTVVTHdOYXFKRSttR1RhT0Y2d2xTZ3VqZkNi?=
 =?utf-8?B?azdYaVo2bmR4YUZWMVpDQjN5cm9OSlh3Q0U2QzUwcXdVMXVUYktBTGliME5w?=
 =?utf-8?B?Wlk4SThReTF1YW96VkdINDRmdzJZa3hlRURraTcrVkU5SEpRTHd6dEhpVmx1?=
 =?utf-8?B?dHowcGwyMjRnRkRZYmFGQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVVUYW51K2dMb0dDd3hZNElZSTRub1RlQmJENWlBTWhqaEdjYmZVSytkWXdV?=
 =?utf-8?B?Sm5BdGJHSEQ3b1FnRUsrWlJ5TDVBWnJyM0V1RjNEQjY5ZG9nazhQWitTd0Rv?=
 =?utf-8?B?UitjTjF2c0R3RGcvZkxQRzVUb0xVNkRuNVpySnFLUlgrTVd2S3BMUTBEUjBm?=
 =?utf-8?B?aDMvcnZOS2hMdEtrVng5QkJ5T04zbGRzcFJCN3JPTEw0b3crOEl4TmtqZWV2?=
 =?utf-8?B?WHNWaGZzZC93a3RmMFgvdHoyTkdnOWpMdmZ2TFUrdk9RWE4zRENOSUNBSGFI?=
 =?utf-8?B?K0p3RnFlMmhYNFFaQmQzYVhJbEJCSy8wMThVaU1KamxidE9JNkdXWlNhVzVh?=
 =?utf-8?B?WHNhQWsxOUFQVENvMlFFb1ZkV29uZDI4VjU3anVKUFNqQlBsK3NJOGpKQ0JS?=
 =?utf-8?B?S2pXWWdWSE5CQmdPVVlPRzVkUHdBV1UxSi9yL1l6U3JmeGJYVGMxejQ1Q1RP?=
 =?utf-8?B?UUhDNlZ4UE1yYmVlZVNVUFNVUCtER3Z2d3FHWnRBdlBnYTVrYTU2eWlGRHlX?=
 =?utf-8?B?SFFuV0wzK1FFTHByWWVUNFAwNVc5QkprU1Vva2VCT0FlVmg0cDBJUkNWdzUy?=
 =?utf-8?B?cjEwRFBJbnJETFRYMGxNTCsyclVFTXhaSTBDSXZBWVNSbjBpVUZBVGRqMjNo?=
 =?utf-8?B?OUdhNHVZMVZXUEZYdjVvMGhBeGJoajArQk1LSXdpRDhYVnd4Y1ZDeEdjQkpk?=
 =?utf-8?B?MkJwZk5yQzJHQVJVZUFhSXpORVRUcGV2SElHZmp4c3NlZjBCV1dGVmZRd2Jj?=
 =?utf-8?B?TEQ2R2RBWnVDQkJHNklvTkZPckw2c3Vhd1RKSVpqQTZyUFVHYmhqM3A5YkdT?=
 =?utf-8?B?OEpoUDh0M3V6OVZDN25GOHBGV3NkL0Q2dnUvZ1IxWU85NEYxTnFoOTNCQTg5?=
 =?utf-8?B?aHF6MitUYUQ0UFd2OGszemlYdTAydmRVQzFoL1doVEUrbEtMQlQ2My9HNDFC?=
 =?utf-8?B?ZUxJcDNZRjBOK2dTQ3NGQVVKRXBiVlc4Sk9HYzNCU3Y2OVl1SlQ0TFM5QzVL?=
 =?utf-8?B?U1V0WlpEVlltOVRHd0lMRzlWK3U4c1pYMEJpaFZkdkovTTVjTFFOdk9waFdm?=
 =?utf-8?B?ZzdsSHYzcFQwWjFSLzJCS0FVeDQ0NzR1L1ZqSnJPZDFBMTFUSW1WbWFLcGVi?=
 =?utf-8?B?NU9ndFRUV1hSWVRNT1lzcVh6MjJLVHVLK0thK1lyZkJ3Q0tEdGZ5RXVUanJU?=
 =?utf-8?B?OHdnQzRqWUhQQXRzU1Y2cTVsd1p2RXZ3c3V1OVhWUDRKSUxOSDV6M0FaTk9s?=
 =?utf-8?B?alZ0R2ZXQUR2SXhIT0xDTFRDT2R3R1Ura0xUbTRoeW1zVUVINGoxTE9ham5E?=
 =?utf-8?B?ODJUY25XaXd5L0dBS3ZOTlZQQllFaEdtN1lPTlBacXlXbEcxTEh0TWxlbEZH?=
 =?utf-8?B?SmFhMUEya0l3YlRsWFV4aUY4Tmp1dE1XK2MzcDkxY1RXcEtoY2xJSXpEY0V2?=
 =?utf-8?B?eCtMb2JRdXBsZmZWNEdpcFF4aThwL1ZObDQveGRGMmRMSVBoWVFlU0dUNUxT?=
 =?utf-8?B?NTNRb3NFUE5CQ2pzbWZqVHpVbndzNU11elRFN0lGSGlLRFVSS3FtbnlPWmxa?=
 =?utf-8?B?Y0Y3ZUQ0VndFeXlOYlAyNkpzcHQwVHhhaTFIRnFwOXUybG1nMnN1aWlLTnU0?=
 =?utf-8?B?SVZFeEZCbzRUN21qVFUyTVR0SllxalNVZkNFODJZbTFSYmNSN3hFUCt3Z3BH?=
 =?utf-8?B?azhhWXdoNEZvUjJLbmFhaDBsSUFmL2ZYbzVOcjl0MmhBVjZqaml0aG5sZzdk?=
 =?utf-8?B?dWVQVWhLS3ZaNDJzcWhCQTU2dXFHcy9vRGd4M05aQnBoOWErSEVScHZmVWUw?=
 =?utf-8?B?ZWZGVk1WY0VRQndxR1V2ZHNCUkdLWmRHWHo1N2lNZTVIM2p1OC9pR1FualE4?=
 =?utf-8?B?eFQ1K3g3cUwrM0hHR3ByVHRjbkE3ZDFUWVUrN2wwaXl4Y1Jld2RzQ0tEYUpN?=
 =?utf-8?B?QzI3MU8yMk9SMVZWcTE0MHlnUE82N3RmbkkzU2JOUFdnc004Q29NcmFFdmVp?=
 =?utf-8?B?Z3VIR0JPUTZaWE42S0lwMUJ6b1RSakFPbmxnMElEanJPOEpYa1J5aG0wY29q?=
 =?utf-8?B?a0crc20zcW9KSTBvSCs0aTdvbjFmMHhNYmZVcHl3UTRnN05jaHBFWDdRVHAz?=
 =?utf-8?B?MXZ2NzdVRURlQmxiSmd3SDA2OGozbVI5Z1VjcmNlTnoyNlgyaEdDN3ljRmV0?=
 =?utf-8?B?MWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F938F007255504D94347D92A56E46ED@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b09392-d207-48d3-007c-08dc732fa13f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 09:32:38.5251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1kd8bubha+Aw1y4SQEX4uSgL7Q9gh1/0BzZ+P2SEN70qEN4CDxtUv2i48L/tcAAWg58crIZIJMann3Rz5YhKZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7001
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--18.374000-8.000000
X-TMASE-MatchedRID: F3kdXSFZYkfUL3YCMmnG4ia1MaKuob8PC/ExpXrHizxUvqB5o/LqcxNd
	IpBI9ywrV+lCDzhvoi3V64tjqwYgDQc88Enw4tySsTcWkxuDrdJYZxsDgIE4rft592eq2xoT9DW
	kSSY6B2zIVHHfFalTpVy73h0Je4yJ9pSZB+rA6OPN+qWlu2ZxaM6XjCcGFXerkE+z0+1vMALB7R
	xJsavfmLGceC2clcYJWincjUU2jZmXv2xdWsrNkh+WEMjoO9WWTJDl9FKHbrnxxaAXDrCns6sjO
	70attN9pQLC4JySCaWyGmxrciT9PFkjerhrCeCp4pdq9sdj8LVQCOsAlaxN78i9AjK6C8p1rkUi
	zQo6JhHv/BaQxVkqMAAqXQcYZ7iiwp/mM9QGaq28coKUcaOOvTGZtPrBBPZrZ5yuplze9puYhfd
	aCXquEoMmUcN/l8E7kZOl7WKIImrS77Co4bNJXVZ0V5tYhzdWxEHRux+uk8hfNjF5BHUO+6Ok9p
	73aFxBbfY6ecJVusQAKPILWgx10YJTNn13/KomSnMauDM+COU=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--18.374000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	38F3219584AC05C72821F89E25090E35E9EDBCEBD10BDE3DFFF42A70BE267E022000:8
X-MTK: N

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDE0OjM0ICswMzAwLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4g
VGhlIHJ0dC11cGl1IHBhY2tldHMgcHJlY2VkZSBhbnkgZGF0YS1vdXQgdXBpdSBwYWNrZXRzLCB0
aHVzDQo+IHN5bmNocm9uaXppbmcgdGhlIGRhdGEgaW5wdXQgdG8gdGhlIGRldmljZTogdGhpcyBt
b3N0bHkgYXBwbGllcyB0bw0KPiB3cml0ZQ0KPiBvcGVyYXRpb25zLCBidXQgdGhlcmUgYXJlIG90
aGVyIG9wZXJhdGlvbnMgdGhhdCByZXF1aXJlcyBydHQgYXMgd2VsbC4NCj4gDQo+IFRoZXJlIGFy
ZSBzZXZlcmFsIHJ1bGVzIGJpbmRpbmcgdGhpcyBydHQgLSBkYXRhLW91dCBkaWFsb2csDQo+IHNw
ZWNpZmljYWxseQ0KPiBUaGVyZSBjYW4gYmUgYXQgbW9zdCBvdXRzdGFuZGluZyBiTWF4TnVtT2ZS
VFQgc3VjaCBwYWNrZXRzLiAgVGhpcw0KPiBtaWdodA0KPiBoYXZlIGFuIGVmZmVjdCBvbiB3cml0
ZSBwZXJmb3JtYW5jZSAoc2VxdWVudGlhbCB3cml0ZSBpbiBwYXJ0aWN1bGFyKSwNCj4gYXMNCj4g
ZWFjaCBkYXRhLW91dCB1cGl1IG11c3Qgd2FpdCBmb3IgaXRzIHJ0dCBzaWJsaW5nLg0KPiANCj4g
VUZTSENJIGV4cGVjdHMgYk1heE51bU9mUlRUIHRvIGJlIG1pbihiRGV2aWNlUlRUQ2FwLCBOT1JU
VCkuIEhvd2V2ZXIsDQo+IGFzIG9mIHRvZGF5LCB0aGVyZSBkb2VzIG5vdCBhcHBlYXJzIHRvIGJl
IG5vLW9uZSB3aG8gc2V0cyBpdDogbm90IHRoZQ0KPiBob3N0IGNvbnRyb2xsZXIgbm9yIHRoZSBk
cml2ZXIuICBJdCB3YXNuJ3QgYW4gaXNzdWUgdXAgdG8gbm93Og0KPiBiTWF4TnVtT2ZSVFQgaXMg
c2V0IHRvIDIgYWZ0ZXIgbWFudWZhY3R1cmluZywgYW5kIHdhc24ndCBsaW1pdGluZyB0aGUNCj4g
d3JpdGUgcGVyZm9ybWFuY2UuDQo+IA0KPiBVRlM0LjAsIGFuZCBzcGVjaWZpY2FsbHkgZ2VhciA1
IGNoYW5nZXMgdGhpcywgYW5kIHJlcXVpcmVzIHRoZSBkZXZpY2UNCj4gdG8NCj4gYmUgbW9yZSBh
dHRlbnRpdmUuICBUaGlzIGRvZXNuJ3QgY29tZSBmcmVlIC0gdGhlIGRldmljZSBoYXMgdG8NCj4g
YWxsb2NhdGUNCj4gbW9yZSByZXNvdXJjZXMgdG8gdGhhdCBlbmQsIGJ1dCB0aGUgc2VxdWVudGlh
bCB3cml0ZSBwZXJmb3JtYW5jZQ0KPiBpbXByb3ZlbWVudCBpcyBzaWduaWZpY2FudC4gRWFybHkg
bWVhc3VyZW1lbnRzIHNob3dzIDI1JSBnYWluIHdoZW4NCj4gbW92aW5nIGZyb20gcnR0IDIgdG8g
OS4gVGhlcmVmb3JlLCBzZXQgYk1heE51bU9mUlRUIHRvIGJlDQo+IG1pbihiRGV2aWNlUlRUQ2Fw
LCBOT1JUVCkgYXMgVUZTSENJIGV4cGVjdHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBdnJpIEFs
dG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEJlYW4gSHVvIDxiZWFu
aHVvQG1pY3Jvbi5jb20+DQo+IC0tLQ0KPiBDaGFuZ2VzIHNpbmNlIHYxOg0KPiAtIGJNYXhOdW1P
ZlJUVCBpcyBhIFBlcnNpc3RlbnQgYXR0cmlidXRlIC0gZG8gbm90IG92ZXJyaWRlIGlmIGl0IHdh
cw0KPiAgIHdyaXR0ZW4gKEJlYW4pDQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2Qu
YyB8IDM2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgaW5jbHVkZS91
ZnMvdWZzaGNkLmggICAgICB8ICAyICsrDQo+ICBpbmNsdWRlL3Vmcy91ZnNoY2kuaCAgICAgIHwg
IDEgKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LmMNCj4gaW5kZXggMDgxOWRkYWZlN2E2Li5jNDcyYmZkZjA3MWUgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2Qu
Yw0KPiBAQCAtMTAyLDYgKzEwMiw5IEBADQo+ICAvKiBEZWZhdWx0IFJUQyB1cGRhdGUgZXZlcnkg
MTAgc2Vjb25kcyAqLw0KPiAgI2RlZmluZSBVRlNfUlRDX1VQREFURV9JTlRFUlZBTF9NUyAoMTAg
KiBNU0VDX1BFUl9TRUMpDQo+ICANCj4gKy8qIGJNYXhOdW1PZlJUVCBpcyBlcXVhbCB0byB0d28g
YWZ0ZXIgZGV2aWNlIG1hbnVmYWN0dXJpbmcgKi8NCj4gKyNkZWZpbmUgREVGQVVMVF9NQVhfTlVN
X1JUVCAyDQo+ICsNCj4gIC8qIFVGU0hDIDQuMCBjb21wbGlhbnQgSEMgc3VwcG9ydCB0aGlzIG1v
ZGUuICovDQo+ICBzdGF0aWMgYm9vbCB1c2VfbWNxX21vZGUgPSB0cnVlOw0KPiAgDQo+IEBAIC0y
NDA1LDYgKzI0MDgsOCBAQCBzdGF0aWMgaW5saW5lIGludA0KPiB1ZnNoY2RfaGJhX2NhcGFiaWxp
dGllcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgCSgoaGJhLT5jYXBhYmlsaXRpZXMgJiBNQVNL
X1RBU0tfTUFOQUdFTUVOVF9SRVFVRVNUX1NMT1RTKSA+Pg0KPiAxNikgKyAxOw0KPiAgCWhiYS0+
cmVzZXJ2ZWRfc2xvdCA9IGhiYS0+bnV0cnMgLSAxOw0KPiAgDQo+ICsJaGJhLT5ub3J0dCA9IEZJ
RUxEX0dFVChNQVNLX05VTUJFUl9PVVRTVEFORElOR19SVFQsIGhiYS0NCj4gPmNhcGFiaWxpdGll
cykgKyAxOw0KPiANCg0KSGkgQXJ2aS4NCg0KR2V0IG5vcnR0IGZyb20gTlVUUlMgd2lsbCBoYXZl
IHByb2JsZW0gaW4gbWVkaWF0ZWsgcGxhdGZvcm0uDQpUaGUgTlVUUlMgaW4gbWVkYXRlayBwbGF0
ZnJvbSBpcyAzMiBvciA2NCwgYnV0IGFjdHVhbGx5IA0KaG9zdCBydHQgc3VwcG9ydCBpcyBvbmx5
IDIuDQpQbGVhc2UgYWRkIG5ldyB2b3BzIGZvciBob3N0IHRoZSBzZXQgcmVhbCBydHQgc3VwcG9y
dC4NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo=
