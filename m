Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28564316192;
	Tue, 16 Jun 2026 08:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781597100; cv=fail; b=laouAqdx4iEKEx1VLF1lCvkm+9Ay5YM8TdTwbK6ygqsQu9rxZoI/+8YwmjMElHtediS6VDlN28V3+qNdCUbltpOvQUr4l4aa3/7Ez7DmrPwak9XORt7pC5Ylt1fneK3bvlJc4Vn7x4UlO4SMDHCAqMJXLhdJglgcoKy60xXXNBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781597100; c=relaxed/simple;
	bh=0KvheHDHHV/xSZYIpEU5pkxoAHjFt5vIw0Jy0Yn5ONA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pBy2nJRIrf6TNpmFZSHDIyBird2hczJufBfjwbtu0VjAsa0xAx2CJxOc2F738wuE/IklNRuqHH8M7jHUkflnx/aV8dEIrCJXlq0nVWzpUStG2A6Dve0hcbbT0QfWnWVFw5uePU58gsYYVgqU1kgZq6SPTrGg0F0dYFA7pRvnjgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ByJF/yfL; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=IIpFAuNd; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ByJF/yfL";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="IIpFAuNd"
X-UUID: 0a53a28a695a11f1b1788b6acf885367-20260616
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=0KvheHDHHV/xSZYIpEU5pkxoAHjFt5vIw0Jy0Yn5ONA=;
	b=ByJF/yfL5ereYFtGVjR4XA4WHjYS0XdVPynLn5NL0zUkgC6lsgGSLlvJZxseSyBWPXqZ0GxtNnMkBPIJ01Q9AI/g9pEe/QxdZG41zaxH7tJHGWnRpgDu1JOFFouWDAR8vhXA0DCMt+0wUqm6ZB2v6l+uJHWIcUVLKGvBG0MoLXY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:d46d174f-87ba-4507-8a19-d75cb7aabc05,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:06d224a5-9ef7-4489-861a-e83b251ece46,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0a53a28a695a11f1b1788b6acf885367-20260616
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1197091824; Tue, 16 Jun 2026 16:04:46 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Jun 2026 16:04:45 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 16 Jun 2026 16:04:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eu7LweklBCWYHasg6H4e1EkL33eK5Ucn6rsQ1U+KpT3oYaW+ACe+BtKXCVK9smQk76RLZxxBNXFiRDF+FwyS2M362cIdTxVRKsQoZGnpjHFq0fIVmYsAmx7rRUx7FZanqODYNEOXjDKfSVsbEuAI4t8b/fRoM5dO9FZfjTOeSYtYdii10ZiawC5643cfendDPiVVMcHTb3IcV1Rrr4xt0umcIZz5UCzw3NgUtH24NgM3evaC8aUabBG6U5Gy4MoiMEXYIbOfqiEVLx3hvioCny2BZTaSXhR/d2+fHm0Set+n/8+9k/AqGkaEDQbTO5abAwt2+E4+E0nC4XqBpQZLCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KvheHDHHV/xSZYIpEU5pkxoAHjFt5vIw0Jy0Yn5ONA=;
 b=OV2wslcFkqnpcY4QuoqsoW7SUNPUS70W7p1GBxdafPEvOMAfFYFP1xKKCv5VIXLIJEuctQ48INXCq31AXIFUh1dGFvBaDS7tRzkY1ZEg0FhlqofyvAzC1A+iK4XudZBsJy7AshDADxS8qu5TkZWc7u0xfn/7xffz3tvYusxkt521kCJ51UUCJpCQHre5j8IvPQblW5bi/JatIhZpiQRBrKMYAoAIQ3V5egDWD00nwqdLnl3u5y4CvqV6hFe1TQ+A1VTpnAnH1CxMfBpxztM5yWvSgZ0TgaPSQbRCv/ji5TsUCudqBfKCmrzIxyAWU6T9JTSWEVqplO7XVqv5rSwzLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KvheHDHHV/xSZYIpEU5pkxoAHjFt5vIw0Jy0Yn5ONA=;
 b=IIpFAuNdCYaTQGlPzPhTPIUQW9lMfb0VEH5SA633pMfa2q9ACTm90TkXNocw8G58TwFC6xZnoNhogcpqpWsdPJ401ldRWNTsbXI9J46ijtRjcZgind+8L9n8YCpLExLj9RYmCN4KZiLoijVJmQBjoGMZ8nOl2AGa9TfQcl21+xE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB6652.apcprd03.prod.outlook.com (2603:1096:101:80::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Tue, 16 Jun
 2026 08:04:42 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0113.013; Tue, 16 Jun 2026
 08:04:42 +0000
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
Subject: Re: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Topic: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Index: AQHc/MsDOEy0+RDZM0u3KzUGsIxSRbZA0/uA
Date: Tue, 16 Jun 2026 08:04:41 +0000
Message-ID: <e4590bb7dcda6bd8b20af2e22a18111b998b9efb.camel@mediatek.com>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
	 <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
In-Reply-To: <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB6652:EE_
x-ms-office365-filtering-correlation-id: c2d7d13f-7c21-4c73-f194-08decb7debc1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|11063799006|56012099006|6133799003|4143699003|18002099003|22082099003|3023799007|38070700021;
x-microsoft-antispam-message-info: Q2c2kyWs1FUu898vCCXMaNwl5LsGAcpVpUMXl7hT0uQmrdncFyudFB0H7V+7crXsLWIimnox9fsxbuyzjDJKtq2Lrw4NZrJ8pbZcAFGgjStg+z2/RhxIXe+xxZ1UoYZbEB4reGh1m5hmW46geaCCV174UG9xjbVH4a+eElHnPjPwJ9Ko6bWC5gFKMiK6n2rn4bZ4WU2N+2qryq+WovGo+u+PqLr3kjXlPCLU9Fw4B+luLAZc7AOZnI1uekxkk5LgB73HRLQSir4GCsMCzG+8s8VL2kFEhOys0eqvDE391wkmcGX+E8Lyj+t28NJSpMI+mHNQS+m3jHGnoDEk3OSSEFfpxlqz9S2jUe3HxdJ3oBGq2GaeSNlly/YdBkaZ/dNQvKwu+e7PaBZIXrLo04eNICnvMQ8fcB54kSxjZdX+vlCI8BbbgpgLDNyswXM3qZZHN7s9vs9kG46DlyBCwSLlIMLnLp2oO8ib8zTtP1iXZFTza9s8ynga92g0YaNcfEJAhp0ebMEYRPdpJkEzq2lT4yF+YxoOWojWKew4wSqb/TZhtM0IVwrwAkLoLLseyk9oqq4XcxdQdcZ3kTKHwJW7i3TPuVnCYDLiJYTQTQtYTC1D5sJ77XZi1++EcWBLOwe4CdR+W3OSzqKUhKN5zxWN4eN3o1mMVIo9psaLXYKJHLQq3zdSUVPU1hM6MZ67eVu/VxzeuvM2BWO/RKJ6Pp9d5Q9FM4ilH8lUvK6s5mYhKm2V+T2vvisLsorxQNyQrL61
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(11063799006)(56012099006)(6133799003)(4143699003)(18002099003)(22082099003)(3023799007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tlgwd01uektQNDUwdkxZOEk4MjkwTW41bXNnVmg5ZDkzWXB4dGRieURVSnpI?=
 =?utf-8?B?Q1RZZ0dnSUtoa043TXJDYndhem9XaEFVSytrcEFOQ3VsZEZ3TlJoc3o3NnJJ?=
 =?utf-8?B?VmZYS3BkY0UyWnNIZnAxSDFoRUJyRFR4SXBPMnAySGM2a3A5WVdFV0wxTGYz?=
 =?utf-8?B?OExYTGE2eERsS3VvaGlXUld6VVc2b2poSkpNNk9nU0hzdEhCK1dxY1V2SjY0?=
 =?utf-8?B?NFQwOTVvRndBa1p3UFZ6T0d5R2tmY2Njd1pZL1ZrVFZtRE1xTlgzVll2bjdR?=
 =?utf-8?B?RnV3KzlucXpnemcvbXFma3Fkc1ZQUEhja2xWNWQ4Y1R6VjdRbHU5cVhqcDNt?=
 =?utf-8?B?OUZYNThKaFhTa1REOWRGL1ZZNG5QdmZ3MXJIbXhnbjhUMlVsN0pxV3ZSOFh4?=
 =?utf-8?B?QlZUZWNqSTk5QjFBVmVsSHlhd0ppaGRxNmFLZW1aZDVvSTBIdUtqMDZRenVQ?=
 =?utf-8?B?Zk85b1duOVJIanZMeGxTWklpVkMwQzh3dnFZVHRNcHFOYk1ZendoU29obFMx?=
 =?utf-8?B?NlhtUWIxbE1tYlR6YkNIUFNpQjhWUUNvWjJpM25oNmEyTVlraXJ1aXRFMmRl?=
 =?utf-8?B?dTUyQ1lpclRmTCtvZnRkWEtCVWY1K0RkMWE5ZnNyVHBPbUZmNXVBdUZXT3lV?=
 =?utf-8?B?TDhOMW5YZzRZUzVCWW44emdwcDBhNlVSaEk2enRWcUFmZHE4QWl3Q0l6bGVj?=
 =?utf-8?B?Um4rZWRZMXZreFdIVFNZOXpvZXRUV2V0dHBMMzRXUkV4aUF5UXR5ckRXaVdz?=
 =?utf-8?B?VVIxd0ZrQzZXb05sb3FxNndYaldkaUpIMnNlYnJ6dVBaUHM0azBsOHovQ1p1?=
 =?utf-8?B?MFo1Zko3bW9xeFQ2VUhpS2NZN2pCZTd2dmNRdDR0YkNndWlBMWFXS0lFNjQ5?=
 =?utf-8?B?dW5NcWVsL003REcvQUhXNEpnYW03Uno1Qm5ISjNxWEFySnJmU21qd1RLTWYy?=
 =?utf-8?B?ekVnbU0wZFQva0ZmbW44U2ZjZHdjYlhiZUV4OEE3aUR1MGhPY05tT29sdXVJ?=
 =?utf-8?B?UFp1OWNySEZhcDcvM1lEbDBlV09sUFJZbVZjZ21SSnh2TVlJRlZIMHRDb0h3?=
 =?utf-8?B?Q0xRc212YUhLRThJKzdrQjEySytkemFIM0dONjJ5QVVYME5nejZSWkV6OGUz?=
 =?utf-8?B?OFF4aU9WbE90cVg4c2hBbjVVNzF4VS9ETkM0QVByV1NKZXlVaklUc3ZIeGlo?=
 =?utf-8?B?a1lJUGtMeGZSSlBTS2Y3ZWlZT21MWU9xVVlzTVdpdW03em1xT0t3R1ZNSWt1?=
 =?utf-8?B?eW9kSUl5UW9uU0FZbE9mZFRZYzdoNVZNV2oxWHVaYmJVRkdNa0RMKzM5Ujd0?=
 =?utf-8?B?eXpKSTZtYmlocXRkbTJxY0xRZXNLRU1TWmFxN1Y5TkdRaXRhcmQwdVRrZFRq?=
 =?utf-8?B?TFVKS2pwemg3bmNjbzE5d2gwNFQvQ2x2bklPbnRRR3JSNndwYXhvRmxmVzNF?=
 =?utf-8?B?eEtrNE5xenZNU2pFbW9XLzN0Mk5PVHpZSHYvZ0wzc1RpSWZwajNxMUxVRXl3?=
 =?utf-8?B?eEhiNGowWFVlUlFwd0pmYVBvMkdzbmxzVVlQVVRnbCtvYkxWUnI3ZFAwMnpN?=
 =?utf-8?B?UFpLTTgrbkRlVHpPMjlUTnpRZU1uOG00b1VXYnZnTlJBeHdoOHZFTXBuSTdv?=
 =?utf-8?B?Z2Jmc3EyNEtHcjRzc3VGS2FsZGRlSjc5RlgvNWx6TmZCclFCeHZBUEVtUiti?=
 =?utf-8?B?QXIzQUlxT3NKUnhiK1B3UXZmVnVCeWludVNndndEN1lHdjl1ekg2b1ZOdE10?=
 =?utf-8?B?cWkzS3ZHK3dMa1J1QzY1ZWxlNjFWY1pUTEp6aUJSdVVxcHAwL0M5V29UWFU3?=
 =?utf-8?B?NDhxRGRuenYyQUtPZEhVMzEwS005a1ZkTmpkTksraE5WL2ZDR1ZqdjJXbTZW?=
 =?utf-8?B?Y21MNlR5eTZpMVRHaFdtTzdQVEZXK1hIRXlxdjRTbEtPUlFGQnhJR1VFd0Q2?=
 =?utf-8?B?VE0zZGNHOEF4UWJ1V0pieW8wR1FkOWpaMUh5TCtJZ0JudkROaXB1SGFZY2Z2?=
 =?utf-8?B?K0pBQWFvQVQxN1dQMFRpcnZaTTdTc2hYWFdiRHVkeWlxWGhmVU43bGluU3c1?=
 =?utf-8?B?bnRlejZhOFhydEJhbk1kaDFGYU5jb2lQOTUxc3lyempITHlFUUUyUGJhRDY0?=
 =?utf-8?B?ZXh6TmVpNTlQalAvN3ZSV09tNEV3Vi9YNUpKbU1GQlpsdFhPT1ZKTXV5NnlW?=
 =?utf-8?B?MUhHTW1FeFBQYTFaY3Y5ejNqa3JudTNubldXZFhtZkZXMTllMnFKaG81N1ly?=
 =?utf-8?B?M0p6cmlvYmdUdGhYNkhPSDRCTHFmTmw5K3o3OFRqYmlUczBHcHg2UUVEMnpz?=
 =?utf-8?B?Z1ZpTVpFaHpiSVEwWTdKcUdoV2ROYmpPcGQ3VkVEa3RBcjJGNFNMNHphSjk0?=
 =?utf-8?Q?3qVBvDeqVnqHKaqs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E1779758C3C6E4B95CEE7F10CB0C85C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ecppRQORaDvU7AFi6Q4eae/12MN2fTFT6m477iMmv107XgikD0AF0THgISjuHiROtZKHyQ7GZBKmmAFRqbMpes5RxWykGFBoW5RJY2AFSGhaC5GanDt8if7bnVb/UKKvYgGzVFcMgLyP+UzC405I0hYsZbyuClCiDWxafyWoE0Iq6PY3rtoRPUrBjsVhqpH8wCD3jzb1NTxtNyZBercnVygSwWPeOge0imScxoZ/lono2v+MoJKJRjVgGbT1SKKfNUkzMz8EltInnDGMu30KJDV6eVUPb1P5/XH5SELumAqfTFxXWMfqLmwyp+h3GDNM+mqsxrvU1s+hCimBq7Wdig==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d7d13f-7c21-4c73-f194-08decb7debc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2026 08:04:41.9865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZD5GxRFVFUCqvglvoHLxNuocQuL6ob84rRFh6eOI3FswdSS6KO/k37Nq3vftJNVQ194xGzz3tvgCvOZ7ra7PvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB6652
X-MTK: N

T24gTW9uLCAyMDI2LTA2LTE1IGF0IDA2OjI4IC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBQYXJz
ZSBib2FyZC1zcGVjaWZpYyBzdGF0aWMgVFggRXF1YWxpemF0aW9uIHNldHRpbmdzIGZyb20gRGV2
aWNlIFRyZWUNCj4gZm9yDQo+IGVhY2ggSFMgZ2VhciBhbmQgc3RvcmUgdGhlbSBpbiBoYmEtPnR4
X2VxX3BhcmFtcy4NCj4gDQo+IFBhcnNlIHR4ZXEtcHJlc2hvb3QtZ1sxLTZdIGFuZCB0eGVxLWRl
ZW1waGFzaXMtZ1sxLTZdIGFzIHBlci1sYW5lDQo+IHR1cGxlczoNCj4gPEhvc3RfTGFuZTAgRGV2
aWNlX0xhbmUwPiwgWzxIb3N0X0xhbmUxIERldmljZV9MYW5lMT5dLg0KPiANCj4gRm9yIEhTLUc2
LCBwYXJzZSBvcHRpb25hbCB0eC1wcmVjb2RlLWVuYWJsZS1nNiB1c2luZyB0aGUgc2FtZSBwZXIt
DQo+IGxhbmUNCj4gSG9zdC9EZXZpY2UgdHVwbGUgZm9ybWF0LiBJZiBwcm92aWRlZCwgaXQgbXVz
dCBjb250YWluIHZhbHVlcyBmb3IgYWxsDQo+IGFjdGl2ZSBsYW5lcywgYW5kIGVhY2ggdmFsdWUg
bXVzdCBiZSAwIG9yIDEuDQo+IA0KPiBJbnRyb2R1Y2UgZnJvbV9kdCBpbiBzdHJ1Y3QgdWZzaGNk
X3R4X2VxX3BhcmFtcyB0byB0cmFjayB3aGV0aGVyIFRYDQo+IEVRDQo+IHZhbHVlcyBjYW1lIGZy
b20gc3RhdGljIERldmljZSBUcmVlIGRhdGEuDQo+IA0KPiBXaGVuIFRYIEVxdWFsaXphdGlvbiBU
cmFpbmluZyBpcyB1c2VkLCBzdGF0aWMgc2V0dGluZ3MgYXJlIG5vdCBmaW5hbDoNCj4gLSBJZiB2
YWxpZCBzZXR0aW5ncyBhcmUgcmV0cmlldmVkIGZyb20NCj4gcVR4RVFHblNldHRpbmdzL3dUeEVR
R25TZXR0aW5nc0V4dCwNCj4gwqAgdGhvc2UgcmV0cmlldmVkIHNldHRpbmdzIG92ZXJyaWRlIHN0
YXRpYyBEZXZpY2UgVHJlZSBzZXR0aW5ncy4NCj4gLSBJZiByZXRyaWV2YWwgaXMgbm90IGF2YWls
YWJsZS92YWxpZCwgVFggRVFUUiBydW5zIGFuZCB0cmFpbmVkDQo+IHNldHRpbmdzDQo+IMKgIG92
ZXJyaWRlIHN0YXRpYyBEZXZpY2UgVHJlZSBzZXR0aW5ncy4NCj4gDQo+IE5vIGJlaGF2aW9yIGNo
YW5nZXMgZm9yIHBsYXRmb3JtcyB0aGF0IGRvIG5vdCBwcm92aWRlIHRoZXNlDQo+IHByb3BlcnRp
ZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW4uZ3VvQG9zcy5xdWFsY29tbS5j
b20+DQo+IC0tLQ0KDQpIaSBDYW4sDQoNCkkgYWdyZWUgd2l0aCBCYXJ0J3MgY29tbWVudC4NClJl
Z2FyZGluZyBzYXNoaWtvLWJvdCdzIGNvbW1lbnQsIHdpbGwgeW91IGhhdmUgYW5vdGhlciBwYXRj
aCB0bw0KZml4IHRoaXMgcHJlLWV4aXN0aW5nIGlzc3VlPw0KSSB0aGluayBmb3JjZV90eF9lcXRy
IGNvdWxkIHBvdGVudGlhbGx5IHRyaWdnZXIgdGhpcyBkZWFkbG9jay4NCg0KVGhhbmtzLg0KUGV0
ZXINCg0KDQo=
