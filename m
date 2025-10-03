Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA866274B3D;
	Fri,  3 Oct 2025 03:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759461079; cv=fail; b=gvt65+N04aKSZvwOEGJwpv/Y4naoxGOo1VlwYFMCEEhKVXF/rxfbC2X97AcvL4hT9LlSTNbRrpM+yPMsnc+Ubb8rqjRoUUQ82b1JxqBVi4ozeImtocfBQiMGtd4Vy1rckpj2b9K+pcnSDQtBALmCtbJD5wiuhJ+zDjC7GQjpd70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759461079; c=relaxed/simple;
	bh=GpplCh6Gi5zF+lc29OrkCHlLBM0u+Y7Wt0soqRqPhX0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Za2s6x59sD9wScLfHCDa2O7BrCCvO7tlNp+KnZpT99ppgmmdilu6WkPW+OfCt8cA50MJlzbPXdNjIyQVDB9fxp7MKch7uo5Dzrn7kfH+Hq39M3CgqKWU9yoQVnkX7Q90o+lrRgYkVWFs/Rh6jAPyA4lqRJsHxIWpP9nrSipwUyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Dsupx/oh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=vtglR1Jf; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Dsupx/oh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="vtglR1Jf"
X-UUID: 9a7a78aca00611f08d9e1119e76e3a28-20251003
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=GpplCh6Gi5zF+lc29OrkCHlLBM0u+Y7Wt0soqRqPhX0=;
	b=Dsupx/ohYJJe5MH6SeXu11SCoBB6AVITGteo7eYPRgu1VN3PCwpLWRrM5dwlkmx/e2pghmT5f3K1bYpzD2s2rJxxBcNuVZDem9uHfhS+C/YBDX03FNoqOZDiGo+DoL5+PikcMvliAMmX6vs1Nb2nf5weeTnnkufIO6lX7oF65tE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:b67635b3-f9e2-4927-a69b-c800a3bb911f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:da2bf0f8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9a7a78aca00611f08d9e1119e76e3a28-20251003
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1559818784; Fri, 03 Oct 2025 11:11:07 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 3 Oct 2025 11:11:05 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 3 Oct 2025 11:11:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o91dT+B0q2gmFixWd0aasnH55Txq1ZfN57E+jkZexNyUEkUzb0ex34XATcE0WJecYpeiKDOhDtYlWW/J26aj1+MlTvECMad2Iod5Mm3zuE7UlzgXo2l0MrSgz63rAbciI+yatES3QBOkfJdUSnjKtxjuIjBUko5zf5FP25rfvvfMjDQehy5/3HGZXgK7IHdLlAGmUAgc+ENlBl542xbyr+e/vDBB5EjSaY1qh+tSIM+PcVaeLC0V2rt5YLu/sDIyssehdrI71s6un6Vy4yLRf1KxkeA+IhFfP/97wEe+NGerl2xniuJSdGysr6c3oEIzYC9dTUmZjA6ihuFd2khiqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpplCh6Gi5zF+lc29OrkCHlLBM0u+Y7Wt0soqRqPhX0=;
 b=Vf3tmGbzPnbTLakdHgRIxFU3OW9wnEFblnYjgn/cW2thy76AKCM3JQ5T19Qz5vewAqFFBrSkhFuPx317RSLb2m7rfk8x3rfwSoKTBdYtIEOYdLWUMTrozOuIbwEVrtS7i/z7Big2RkYmprbwGEgrnkS4dgGv7gpJofXrp404UhCTxcKuTrie0kGVQzRq5kemLtucL33iOzlY9+SqTifj9LuldmEq3CUJkaGT7uzeuR0ZWvl4JAOxxcI+k15kHocAhKuMz0EVOrd27CoyGRKLoYH3xApl/jXf9nTJ6pDoKiyXbF0rZjyR50VxiuQXZL0tLDDBGvc6llKyyjUqzHJCYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GpplCh6Gi5zF+lc29OrkCHlLBM0u+Y7Wt0soqRqPhX0=;
 b=vtglR1JfN2vO2AIr32/J/0IE6pTYlOurobhJq6YxmU5qoAbDFB/4yAsMcrdz/t8PlkAkmL2ssh1HPPxRf4oFqunVdD7LIjdjQ8U6L0L8IIrwko93hXdffE73h0ZMtqqs9NAoauQgzhxzJbrlGkhpIen7wsRyAJ5KhYr1Yhk5oDo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8219.apcprd03.prod.outlook.com (2603:1096:820:109::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 03:11:03 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 03:11:03 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Topic: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Index: AQHcMxYfazcJy3COe0ibj/0v49XMcbSufr+AgAC4nACAAIkrAA==
Date: Fri, 3 Oct 2025 03:11:03 +0000
Message-ID: <4943d9d6e31b2993ee0563722b8bc38c3b1ef069.camel@mediatek.com>
References: <cover.1759348507.git.quic_nguyenb@quicinc.com>
	 <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
	 <c12b15699ad8176760c220100247af15954f30d8.camel@mediatek.com>
	 <a1eaae1e-3e10-4512-bc83-ae25eacc43d6@quicinc.com>
In-Reply-To: <a1eaae1e-3e10-4512-bc83-ae25eacc43d6@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8219:EE_
x-ms-office365-filtering-correlation-id: 97ea0a82-02d8-48c5-0186-08de022a7c89
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OXowaEZQdllsYzEwSEFYL0xDYWJvTUhFaEI1bmJUYWhwcDFSUmZ6Y3lSNmVE?=
 =?utf-8?B?anNGZVRNVzhOSFVvUUJINnJ2OEMzZVpWQnhCODR6ZThIQ3NDbWlHaG0wdnVE?=
 =?utf-8?B?SE9YeEloaGFJYktCZnluL1ZkTEVZMlA3S29SSm8wSDUxc0Z4MTJoOVphUkNx?=
 =?utf-8?B?UXB6K1dsaWVLYzdUTUMvdmVJTGlOVy9tTW11bXlKYmU1NVM5cGM2UWE2cU5H?=
 =?utf-8?B?OHJKc2p1eXFGaUFXRzF1cHB1UlZyazhHWDBQdkV6VGxzRy90RVhSMEM1QXY1?=
 =?utf-8?B?Z0lGRDF4TmN2VUxCdVU1bTB5TU80ZGZ0ZUU1R3RKTGZYTWh4Q3ZNLzBURDBG?=
 =?utf-8?B?UVVQRzZGNWNvSmF1R090dHFuMTFTcXcxRUxneExwL0VudExLeUpnVXFQRVA0?=
 =?utf-8?B?V2RiYVIxMkNBcUVPVFVLcTV3TXJ3eW1EUStnVllwRWhMNVNkbFN2TzVnWEFF?=
 =?utf-8?B?L0JSWnd6VURMVHhLbGEvUURObVpsMVpIMnlQSEdGay95bjVocnNXS01FTVU5?=
 =?utf-8?B?YW9CQmZmRy9wWUV0aTlFY3NPTXp6dXNQcGVNY0NCMm5CU3pVNU9vYzUrVkhO?=
 =?utf-8?B?U0dod0lvc252TEkyYmJjMUQ5Y3F0aUNBZVhMWWRsZ2tpUEZBY0dGZHFudmcx?=
 =?utf-8?B?MExibVNhcytyZUJDbU1mdFZHY0VkaVdRUjI0Y3BXWGUxUU1LT3Y1VlhkYUU0?=
 =?utf-8?B?amQ2bGE2a2hJNVJpRHdVdGxBaVUweHczMVUxRDRHYTcxOERFTmpJM0l5d1RI?=
 =?utf-8?B?UjF3TXozVVZhQUNPRHFvNXpCZzlhcVp1WFVSYitnZS9aMTl5TDYxcVNha3A3?=
 =?utf-8?B?MjNYc1dtanF1ZVBMKzZrcTEyQ0hzdkpiSU5vN3VRTlRsQVZZaXVrVzdQdExs?=
 =?utf-8?B?ZFVpdFlmaHA0eHZkOFRzUGlCOE5MZnlnM0FzZ2NmNU9oZ3JQa0V5WVl5V01l?=
 =?utf-8?B?bTlHd2NUQkllM1huaHZkVzJEN1VHQ3owcm5qeFExclBKMHd4RHcxazlFTmRp?=
 =?utf-8?B?ZXNMakFERTh2dFRXRGZoNU90UHNNSndFNE53R1gzd3hRclQ2RGloc0l1Um9n?=
 =?utf-8?B?YjNhM0VmUjZnQitnNEhJNFd4SG8yWXJ3MFNtRnFxa2RCLzRncnU3M3kxSFY2?=
 =?utf-8?B?bVpUZ1F3NE00VnNoa1NQMUVIN2JTcHlkOXRFMS9wUHdZbEVmYXd1M3IxaHdp?=
 =?utf-8?B?WVdqVXc3SXc1N2NNaFg0Mk1GMWtJOE1GNG9COGdkbjJFVnltakI0RGdMWU9I?=
 =?utf-8?B?YXRYd2ZpeVJ2R2ZWTWYrcTU0VnlISmRqVE92OVJ6aE5tS2c5WTBWT0VBNVdY?=
 =?utf-8?B?RnpHc1A1V2I1TFF5andyYTNzQWpZcEpYVHlFMmh4QVpXQk9xb3U5OGFyRzAw?=
 =?utf-8?B?K2srS1BpWjZGTVNHcXJqNkJKeFBKQVhrQVdhZmJsVFNvbDJVVjdLTWF1clQx?=
 =?utf-8?B?TTVnVXdFZ3N4L1pCM0VNdmxlRVkrQXMzRENYWWczZGVUbmI0TjhaODZKM3Vh?=
 =?utf-8?B?Z05LWVVuSGhQWS9VNHdYYkZ4enI2VXQ1dDNLNHFPem8ySXROSEc1T0hKNUcx?=
 =?utf-8?B?UGF5RWQ4WG5yc1hjN1p5ald2SHNqdWxOS2dHWUFIK1FGd0FENFYybDNUYlhm?=
 =?utf-8?B?Z0Z1bVBzQXFNN1JrS0tETjFXT0tHcm9FUTAvZzl5cmhVb0MzdGc4RU1Td0NW?=
 =?utf-8?B?eVZUSFh4NkY4UGZMOUJBNkpmT2VGa0tYbWVjUEN3TVBHSUlJeWRucHVJTGRO?=
 =?utf-8?B?NHphUTZrVVhzNyt5S2pGcTk0UHUxbk04K3FDakQ0cVVxVmlONHc1UmxWZEFN?=
 =?utf-8?B?OTNibUtrYTc0Y1picGg0cXE5clNBVGFNcENSMnBZQzNZVDF2SDhqeFFWQ3hR?=
 =?utf-8?B?RGVKVUdhR1A0ZjMyZDA4cFBtTTQ3bWl3VnBRQnhNdHhlK2ZHaG1EekZpaHNZ?=
 =?utf-8?B?Z2pvVzFPN3o3Tk1xRjErUHUwdjVaUmNOWWY1MXAvbjd5SDhoRUtHRkFlbFFS?=
 =?utf-8?B?VTNSWXNidFE1RHBpLzk4UXFuTk9qR0F2bS9sZDhLdWQ1alZ3czdLclJGeEVC?=
 =?utf-8?Q?V40ltc?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1NzSzhIQk05OXZCWExHZW9WRUJGNFVMVTRhQnI2cUdjdzZPcWtiL1dveEI1?=
 =?utf-8?B?YVZYOTJNVHNOQjJ3V2xIc0Y2YXQzMnJzUW5DNzkveC9mWG9YSHplYms3dmF1?=
 =?utf-8?B?enZ3MkNlTnZwWTZqR0V3ajlXa3JodmRERGppRXR6RGlLc1V0M3hFT0tTL25s?=
 =?utf-8?B?cHQwY1pZcVV0RUd6NzB1OUVrNklCYXJLSmhKMEdoUHk0NUN6Q3FOeWlJSUsv?=
 =?utf-8?B?bk1UU2tWOTd4aFg3WnhxUVYyQlhZamgrN3pONCtMMjlBQmhlNzN1Q3I3ajZw?=
 =?utf-8?B?blhDSnZ4Sno0eC9RU2xjbXUwTDd6dVFxeHFXMXJDc0hualI2S2h5ajZ4U2pH?=
 =?utf-8?B?M29MSUt2RjhHajVEVFBrTUd2YmJ3Vnp1bktSMnAwQWlmS25MbHNiV2lQbnRL?=
 =?utf-8?B?UEV2YWdYaXJQekVwN3JzYjRGSTVWamFvWUtvSks1UFN4dVdVOXRlemg5YTdI?=
 =?utf-8?B?OEU2VDd0ZGUrUzh0aUh2WTc0NlVwU2NwemN0VXNKb3RCNlZRdEhSckFGYmhH?=
 =?utf-8?B?U2JuZHRjUUsyRzFBTllndWxJYWdnM0JvMlJ6Y3BFRUdFbVp3QlhhQlFQS1lQ?=
 =?utf-8?B?bXBHM05wcS9RTWFBWUlPaVdKZ2ZOMS94dVZRbGRNZk1LZDd0WEZ3dFV6VDMr?=
 =?utf-8?B?a285SG00Y1orSStqQzNCZGRoRjc1WEdUWkZuY0FtZ0xtRFJOMm9TdUNxdTUx?=
 =?utf-8?B?cU9yZXh6VVhUczg3RkZrcU1CK0tURVRqMVVqcm0ra0Y3M3RMRi9VdVFYTmpC?=
 =?utf-8?B?TkN5YkwyS3VvNzZ0TkFuUEdzZTVHaUk0ejJWZFdZSFdkdFNXK3pqNWZXeTlx?=
 =?utf-8?B?b2MwbWVuUVNGOGFnc3JJbG1YdnJJa2JRUnRxYWtLdVFVVFRtblV5ZmVybU9v?=
 =?utf-8?B?YlhsaGhOOG5YWU5taVlyVkZXNzREOXVCekVJekMyNWhJcTBzSG8wUXR0UXNx?=
 =?utf-8?B?T084aiswMlZVc0VvU05hVDluczliRjZsYnBIOTU3QUZMditrSTh2L2tOTXg5?=
 =?utf-8?B?THM3dk9xV1VkTXpVKzVza2FJRHNuUUxnTGVzU0s4dkluZHdScHUyU1crZzRQ?=
 =?utf-8?B?bU1CYXY0U2MxcE9kMnUrZ2FZVHZVQlpjNDFFTnViVlpaNkU1bHUwMUNYekUy?=
 =?utf-8?B?dmx0MkdJRzM4cFBaT0tQVkxmSHVLd2JSTjY5ZGhVTDRMMmV6MUhEQnZtL2ox?=
 =?utf-8?B?a0hwWldMWTRUUlFhRmR0ZnRlMkFwNFRheDJaWXhQUWp3bmdGSC9TWW9xNHhQ?=
 =?utf-8?B?SlgxNTcvVTltR2dkb0xMZlRpQXNENnpPRkJaVkhGRzZXSllSeVV3b3hlUXFU?=
 =?utf-8?B?eC9xWTZORnlPNzdyUjdETmN0QjhtQXB1ZDA4aXRCVjBWam5NWlZBeGcyUDZX?=
 =?utf-8?B?eENya054WVV1YWh0Q2pxY2lGYnhld3AwdUZBUU1WZHdRSlJ4aUo0WTNRRkJv?=
 =?utf-8?B?Z3VIdGhiT2xWMFZ4WVdUTnhHSWtocEJIa0JxZWYwVU5IYUxjSHhwK25KM3RQ?=
 =?utf-8?B?dFJuQ0loNkRxTHpkazNOdWpvaXl0NDBFZE90WERLZkp2VFc1MklVY01FWGNq?=
 =?utf-8?B?WTNpNmdsdHdKVHJDT1VPNmxic2ZLN1A2M1lBRmlxZk1ENDVoZThLYy9hUE9S?=
 =?utf-8?B?RCs1Z1VhTHBGZFRtYnFrTGN2Slo5SkFsWEs0K093ZW15MWpYNy9HNitGUU52?=
 =?utf-8?B?RUtyb0ZHZW9mY0xLa21paU9wYWVJZUp4UE1ScUlOSEFpSE03aWpycFowYTVv?=
 =?utf-8?B?aVB0S2lRZnFVdmxKYnE2TlZzWWJMTENtbUR2VW9WUlRkdTFLdjliUGhCS2ww?=
 =?utf-8?B?WUVGNmh5eWZoNEwyR1h6Q0dJQXRwME5lMys0aGZQQ1BuNzk1OVlreTJVQVhG?=
 =?utf-8?B?V2JnU2VZSEp0WFA5Z2tOVVhTeE9CdlZsZGgxN0phbDE0cTlZdVo1dWl5UTFI?=
 =?utf-8?B?dW5CcmZnaks4L3lrd0pIMFdTZjI0Sk4wQXExRk1YUCt5NXVvdWV4Ym1WMDlx?=
 =?utf-8?B?ZFJERFJKSE04UHFDQmZEdW9jZ1dNY3ZFbVVFc291ZWw2eXorYkdnbENUVnFU?=
 =?utf-8?B?SWhFSXhLMXhuRTVuaVE2MzBkblZVWmVBTjlvT0RqMDlTdjV2dlAvdG9NU0VT?=
 =?utf-8?B?Y0tHZ1prOEY1N211WGhxTjBtTWxOcS9obytBWThLKzVHNEY3aDJDaEh5NE5h?=
 =?utf-8?B?b1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E4F31797BEA114AA2061D1BD151DC8B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ea0a82-02d8-48c5-0186-08de022a7c89
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2025 03:11:03.3991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jiDbza2fSyQsUPz48cZDRlVCWlF5gZ3FtSyHMreXG38HtIaRqX/gGnv8Unl9o4w27pFexc72XL2E4xML9lhx6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8219

T24gVGh1LCAyMDI1LTEwLTAyIGF0IDEyOjAwIC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiANCj4gSGkgUGV0ZXIsDQo+IEkgaGF2ZSBkaXNjdXNzZWQgd2l0aCB0aGUgbWFqb3IgdWZzIHZl
bmRvcnMgKFNhbXN1bmcsIEtpb3hpYSwgTWljcm9uLA0KPiBhbmQgU0sgSHluaXgpIHZpYSBlbWFp
bHMuIFRoZXkgYXJlIGFsbCBpbiBhZ3JlZW1lbnQgdGhhdCAybXMgaXMgZ29vZC4NCj4gSQ0KPiBk
aWQgY2hlY2sgdGhlIGN1cnJlbnQgZGV2aWNlJ3MgZGF0YXNoZWV0cyBhbmQgMW1zIGlzIHdoYXQg
dGhlaXINCj4gc3BlY2lmaWNhdGlvbnMgcmVxdWlyZS4gSSBhZG1pdCB0aGF0IEkgbWF5IGhhdmUg
bWlzc2VkIHNvbWUgdmVyeSBvbGQNCj4gdWZzDQo+IGRldmljZSdzIGRhdGFzaGVldHMuIEhvd2V2
ZXIsIEkgdGFrZSB0aGUgd29yZHMgb2YgdGhlIHVmcyB2ZW5kb3Incw0KPiBlbmdpbmVlcmluZyB0
ZWFtcyBhbmQgdGhlIGN1cnJlbnQgZGV2aWNlJ3MgZGF0YXNoZWV0cyB0aGF0IHRoZSAybXMgaXMN
Cj4gZ29vZCBmb3IgdGhlaXIgZGV2aWNlcyBhbmQgdHJ5IHRvIGltcHJvdmUgdGhlIHBvdGVudGlh
bGx5DQo+IGNvbnNlcnZhdGl2ZQ0KPiA1bXMgZGVsYXkgcGFyYW1ldGVyLg0KPiANCj4gVGhhbmtz
LCBCYW8NCj4gDQo+IA0KPiANCg0KSGkgQmFvLA0KDQpZZXMsIEkgYW0gY29uY2VybmVkIHRoYXQg
bGVnYWN5IFVGUyBkZXZpY2VzIG1heSBlbmNvdW50ZXIgZXJyb3JzDQp3aGVuIHVwZ3JhZGluZyB0
aGUga2VybmVsIGlmIHRoZSBkZWxheSBpcyBub3Qgc3VmZmljaWVudC4NCg0KRnVydGhlcm1vcmUs
IHRoZSB2ZW5kb3IgY2xhaW1zIHRoYXQgMm1zIGlzIHN1ZmZpY2llbnQuIElzIHRoaXMNCmJhc2Vk
IG9uIGEgdHlwaWNhbCBzY2VuYXJpbz8gb3Igc2hvdWxkIHdlIGJlIGNvbmNlcm5lZCBhYm91dCAN
CnRoZSB3b3JzdC1jYXNlIHNjZW5hcmlvPyBJIGFtIGFsc28gd29ycmllZCB0aGF0IHRoZSB3b3Jz
dC1jYXNlDQpkZWxheSBtYXkgbm90IGJlIGVub3VnaC4NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
