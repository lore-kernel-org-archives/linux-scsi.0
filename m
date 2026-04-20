Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B571339FCAB;
	Mon, 20 Apr 2026 12:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776688303; cv=fail; b=pIMCR58ss+j2N85PHOiC3xOmZyBRjn7mX0XoZHQJjv0UMVoW4IDVxApY0o6euUafR3BuWtWIYCzQNl5c4LemRvMwVHocgmsMGfq+XAHZsnawIMJvoSuwoo3eOW4rHKp3RlNg9V7dVzmV/EdgZ5Jdi4Wmu/67VAnL7AG9NE8n4Q8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776688303; c=relaxed/simple;
	bh=Lf06MqKvMDpstK5ZLp17WwToMkHdIUqaWh55/I1JvF0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fJVPdi0veHknN8HNb/DpaVJO6I4c4AIj4VY+aE3xYG4AZj7waQBlOgrIK1S++MxIMSczWswwoASmTpeHXe2JQCv8+hAk1CIgSA4j1+nx6wZMlF4NXsrSzFY5xy4NgV7NhC33QoavYcyc1HNVkdgiW4R3ID1gXNYZ/ueKqynEvdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=H1Z/NcUh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=wRr5VWQN; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="H1Z/NcUh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="wRr5VWQN"
X-UUID: dad9f21a3cb411f19781c1a04af40193-20260420
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Lf06MqKvMDpstK5ZLp17WwToMkHdIUqaWh55/I1JvF0=;
	b=H1Z/NcUhrlcr5FUHLXdQBk56I8IN/HJxiSO5YuUaPBnK+W3c06bmi59LDoy+68y0ymiCYYn9xHLQJRBmd7kFbmN6PIfLoKbKhy06C/vULPIubg53agIoUjWovJagY8s0ip+9gnHt/tbR90A7KDhcoPr8K/P8KyvZM5J8Mp1+pWg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:77a6947d-b682-4ce2-91f1-2bcec4760f81,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:b4f811d6-060f-4ecc-9ee0-121eeeb4a682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dad9f21a3cb411f19781c1a04af40193-20260420
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 955092177; Mon, 20 Apr 2026 20:31:28 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 20 Apr 2026 20:31:28 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 20 Apr 2026 20:31:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BdAp7v+048Gu4fUUmyDvZi9hpZw8BuiCySUKpJD7G6ULHnFDGv6x0GSHEnmay9ee//vWGzXpU1/7zFvDnCzDdwC0owPDpgRWx8l0fo+V8ROIyILjyJjobjHtYveOx4KegrFwtkLVbXzOX7482+mdNuyyGxkl5jwtcQt+f22EERnSwynbnhxJn/qVLeZoR11eEdZ6pzZS52cYkPt+6MiKoBaS8Egbw7cQCUcR/C1HxafZncrgvwPCLxkNEp/lj08Wfd/7V56TUtXnwj5hjU3JXxyjbyUBUOTQSE1R22xgUtNjFtL0wmlghTzbAaUQauNKiMpMT6cHTAhG8n9PFuXpMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lf06MqKvMDpstK5ZLp17WwToMkHdIUqaWh55/I1JvF0=;
 b=dKvUhs72okVJMoMLesj4eh7DpuvwdcC87YPtU/Tgj2Ty3+gAhg7stKLcecnJSYU1PCoDhR31lz536hSHHGYqhI3PTPSMUAg/sBLReiJ3FToR1XYeLRuHsAoHaEeYKXNIX9lGOCuNCZNt1b7/0gW9nRTisg//VoeMRwxzW0JqcWSN4avZ9vvazZlGbR1Oh934/ApTfnjFQob2zbadC1FcsTHxvArO6arpB/CNRpc6Ls1OMuPtFxOQfAhn8HSdVQTZwM/LdBBXcSiqd444c6iYI3utQvG3JgnqiCKXhmmIYxSu0eFbCF8mb+VcFLPbfWBj5cX3e7M3DCLr7cPaSUc5xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lf06MqKvMDpstK5ZLp17WwToMkHdIUqaWh55/I1JvF0=;
 b=wRr5VWQN5fTd4FnllQYD6d0XThdgNYlvpvFKTa+PrLmOAopUxk9twIaXoBTleP2A2RavE9Buds3eF62ol2LWVmDmHtm/yUCDzDCJccCCw8uBIBtZTGmsUu6xkoQ8/irkhDMy6H8ASVBcrXd+Dm3897MTSPQMpZO2QM5yNs7J0j0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8575.apcprd03.prod.outlook.com (2603:1096:604:279::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.31; Mon, 20 Apr
 2026 12:31:25 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9818.032; Mon, 20 Apr 2026
 12:31:24 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>, "huobean@gmail.com"
	<huobean@gmail.com>, "vamshigajjela@google.com" <vamshigajjela@google.com>,
	"tanghuan@vivo.com" <tanghuan@vivo.com>, "ram.dwivedi@oss.qualcomm.com"
	<ram.dwivedi@oss.qualcomm.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "chullee@google.com" <chullee@google.com>,
	"keosung.park@samsung.com" <keosung.park@samsung.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "rafael.j.wysocki@intel.com"
	<rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Introduce function
 ufshcd_query_attr_qword()
Thread-Topic: [PATCH 1/2] scsi: ufs: core: Introduce function
 ufshcd_query_attr_qword()
Thread-Index: AQHc0AQTIrhxett7D0u6LCIW/Z1VirXn4yqA
Date: Mon, 20 Apr 2026 12:31:24 +0000
Message-ID: <184ed567d8a54828651d2dc5828fdfb88343173f.camel@mediatek.com>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
	 <20260419135229.1036926-2-can.guo@oss.qualcomm.com>
In-Reply-To: <20260419135229.1036926-2-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8575:EE_
x-ms-office365-filtering-correlation-id: 76e90ccf-eded-4130-71cc-08de9ed8bc53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: bJ+xgEOc3Wv6BvCYoCdzv5wcX3YkxKzHpsQjjkh2QHfN0gXzYAzzTNCn40HqxsbJMn+1CDWXNMvH77cGGuUAh8kUKMxhCsoq4O+qveu+UrQRRidSVN4iWAcBZSyN4Lto7MU9HVBPhIVSP3U771S6zJK9cAoBRv102B55rszaqW0Q1qALUg8bioa4y+MGOvaNifPZwlk/0eUeYDKpRb57XfYUy498x+Ny3aVY6x5XCVceopS0QSiaOKQonyZpNG6tEBfhe5nDGONYl7p/oDf8XGsBOBs0z5AEf33Rx5YaA+nBK3fpAfpvujMS84hSFm1uCx84QZOZuuKsDnHwbmjmCtbuWYhdPww/c3SYw9B7a/eIPPOwnjqibrYzTEgTkQnz/DaPnslODnyG3j8UvIYm3x0SaB8H9eWXHRBpCcVlbqVxktoKToMzCvpA9f+ZAwNuEDXVTCUk35Bg+Wa4vW+5/IbKhZy3lRIvKTxQMMIohMwfXLKbhA2kYXopzuq+FgVEIfB5Y2gyZrXZBQv7zXuXq3rEw6vhR42jj8DChXsnfI8uODnukGmCh9xqUiHSo/xSkE6GqrfbJTrZY23EziXi6mmNJusKXFbHe4Q0biFHcsiiqmY1ZeduAlyJeWyilQw+1GClrUAHVx2ONDx1RtUhpJ8Q+E9TeBS3nOXc/SQXvU+DbtkNwvBM9OvSB9lbjX0oAeDkuYSXC3AJP6/fyKBEaDTqP6gDw7UOflFVLZXGanbEiegZtzCUvUW6TkTrXuuDQL2uYsp6K9W8Fed4h8VWZ7GoqScrzF4qdvSFTkq7Tmg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alIxV1dIcy9COWYxRkRSQ09oc250ZEMyWTVSaUhDeStLRlh5UXRmSjdZcTFy?=
 =?utf-8?B?S3BWdmt5cjFmZ2xIbjN5aURBU0tNR0ZJbkhKZlF2VVJxRkozWWdBQWFiN2pC?=
 =?utf-8?B?VEFYTEw1K0U0Y0ZnZDQvTEJja2Q0TUI1Y3VlaUtMNkdVVDY3OU1Zci85dUZL?=
 =?utf-8?B?VGFFVFhOZGxUdklncmtZYkcrWXlyZW1RNHN4MjFsVnFQZEpVZzYrWE5xcWpJ?=
 =?utf-8?B?UUxsKzV4b2NleDlIVjg4dW9QYlc3RHI3YnY0NkZnc3hCZWtFZVR4UVBIaTV0?=
 =?utf-8?B?SVg4cW9Ob1VEbG9DcjIvSFRQVExrVUxtK2pGMmk5K0I1L0F2TGY0anBoRENF?=
 =?utf-8?B?bGo2eW9LNmtFQ1o3SlRvUjlJNFFzNkhKbHhiOVdFeGZNbUJXWnlnbEZ5enJH?=
 =?utf-8?B?c0Eya1NuZ0crUDRyck9WYWhKYXBzZ0JMNXpxSjgyd0hiRTN5NS9iRzg0ckFD?=
 =?utf-8?B?eGZzVEUzaXp3SlFSUEpnY1MyNENNdE93MXNVdy9CZlBoa0V1TFFNWnpxb2Va?=
 =?utf-8?B?cUxZL0ltMFpHbVRScFRCVHhuc2JvTEVEOC9VWU5kaDVmbERUYlBQODkzdktW?=
 =?utf-8?B?dU1GSFFlMkh2S0QzMVFNVWl4cE9WL2hUVXkvclFKdVd2RXNGbDVtYjJwVUlT?=
 =?utf-8?B?d2EyT1pyNCtHZWFDbTAwR3BLMllKM0t4MmxtUG43c0QySnMydUtSS25qTmZt?=
 =?utf-8?B?QWhFN29ud2h4aVpGWlB6c0szbTNHeHZUQnM5aXU0K2xpSThTd3VvRTliQTJn?=
 =?utf-8?B?SDMyUWEvLzk3U2tRNEdyUkVPbVpJeW1aQjJxb296WHZYUlBqKzRmYkE5TTdU?=
 =?utf-8?B?Ri9IWDdoOUlWT0JGcHJQc3REejEzWk4vbHBJT0M5WCtNeXMzNVpXemhPaWxF?=
 =?utf-8?B?a1pLNFk2dTJKd080UFpYWStBcFZYYk0vamtXa2VMMnpCVC9HS2toQmo1SmZn?=
 =?utf-8?B?aFNsT0pPWTVPcnhvbmpUeWY5eUdSL3hZdnZEVU42ZTVManlLYTNsSFpoOUdu?=
 =?utf-8?B?ZlY5TkZxYWJWdVVpZ1JVL0lZYXQzYVJnMnhJYWJPVEkzU1FBTWlSM2dMYk9M?=
 =?utf-8?B?a1Ewd0hRMjV3M2VpVlBkSmRIL1dQcDJRdk1IQi9yVHNlS2VPWVRNRTZnUmpU?=
 =?utf-8?B?bDVPQVQ5dUp6VE9NNUwvcG9Sbi85TTRlV3NsTEU4SFl3Z3FhQjQ3YnJSOFBD?=
 =?utf-8?B?czVEVmo1WW9BSVQxS3JYRTNMMDRNcVdSQnc3WDN3blAxenpRRDJtdUtzK0Jj?=
 =?utf-8?B?STNRQ1NBWUJ3WVhwVG1HeXBpSk1aSGdSQzIxeHRReld2b1hYOGhZZUE5elpE?=
 =?utf-8?B?L2hiVUY4Y1JzeWdzZExUd3NxQ1l6d0NXQ2VpMnlOOXRIUmRqaVA5WU50NllP?=
 =?utf-8?B?SUd2bkhtWE8zSUlIWkpSakVIY3JPOTBYNXl6bG5HOFU4ZWdWOTRHSWYya2FR?=
 =?utf-8?B?ZmRWNnlZZGJMNmVVRm1yZDQzOE9CQUJ5NEt4T1NTVXhGM0VuQVNKRFc0ZHhN?=
 =?utf-8?B?cnF2NTYyWEN2N1p3dU93UDBQTDUycmtjNGpodFl1eC81TFVJMHBoaWQ2b1B4?=
 =?utf-8?B?ZXBZeStJTkVjeEUrQ3VOQitQNHl4cFdFT2RiUHdUckFFQkVJTWdMNFVidUtz?=
 =?utf-8?B?YkRxV25wK09tcnZ1cTRtU3A4Ym9TL09sM1lacnJiczdhbCtkRkFhR2lGNGxq?=
 =?utf-8?B?NjFYUEVQcGUwUk8vTWg4ZGlkOGJDcDVCRDljcUZaL0FML1gxQ3h2M1pIM0Qy?=
 =?utf-8?B?M2doZnJmRE5pM2R0RERsbWczTWczNFpiVi9XTUUzNXpCRkw4RjlGdXFNRWZw?=
 =?utf-8?B?NzNhNzFUUXIwdzc5cUUxd3JtYVU0WGRtTHJqMXByL2hBMFZqNk0xN2I4TzY5?=
 =?utf-8?B?TDJjYzBpUG8wSU9XaG9WSkJueGNvWFptM2R0QmJLbk5MMUZlTEFwQWQ5L1F1?=
 =?utf-8?B?ZlBhQkFrTFBCSmpEVlA4M050WmtJTVliRndYYmRmNlFvVTJoSmh3ZU11RjJ4?=
 =?utf-8?B?ZXRieGtsUkxsUk9razdMV1paTU9zUzNXNjBQUm9OOHNWVWNJN2YzdGpLMG9x?=
 =?utf-8?B?QUVkVkRNWGYwdEg3ZnZHcVJaVFhKRGkwWWZPV3E4Zlh2d3gzbjlaN1AxdnBV?=
 =?utf-8?B?MEZCcG0wQ3NnT1J4K010MEhvdHZPNmVRSkI4OHVUb04xUGFvQkFmRFVyY2I2?=
 =?utf-8?B?eTREV2RPMjdwSXM4cTVpRDc5elFGK0ZnWnJPT0NHTCt2SjVMbWV3SDlMY0Rh?=
 =?utf-8?B?OUhSSzJnZml0dS91YUsrZENXOWFDSWxLZ3ZpSTlrYXNGWFVsdmFONGhvOU52?=
 =?utf-8?B?SEI4K21wS0FlZ1JxQXgzWktlOWVHQkxaRDM5ZlhBRDllSElycllxNlpmdG1t?=
 =?utf-8?Q?grv7g3aH4jAlqteE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76F8BE80E40AE04BA4DCB897FB5E4CC4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: KaN/VChXnBD0b0PXDW7+Y4fp9EWMtpoZBBYg4kZHRzkarcc4V2UlXhSJpp7/BflO9mVn81N1T4iRoY84cDMv4buXY/O2FQuCwIC7qq4/ncqoUbjefeR+0QFJy6ZdO22fUU5wk2PqEOzuxK46xnVOqBRF6oWhmOds6d6562C/6S/DidKogNAKBqfJXHuDuwP8soJy9sBIwPKp5kwT6juYe+thHjP5R+ePZWItmGozmI6Wnwep9kxumdlY4Di1rd2uTE7cXvJCvj7tnweTE95qoGT8UxOtM58xHyg/xtNnwRinP9Zj+MNBqcshff7GEa4QmkV5JpnY6aCi09R5oPEn6w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e90ccf-eded-4130-71cc-08de9ed8bc53
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2026 12:31:24.2714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VtCWO74Mfc1V0cxg6F5lEYV/d8rrJuXf4B1Ax6eUTnBgvR1PeX36M8yhh70c61lvPCcdZdaN3tL4m5vm8g97wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8575
X-MTK: N

T24gU3VuLCAyMDI2LTA0LTE5IGF0IDA2OjUyIC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBJbnRy
b2R1Y2UgYSBuZXcgZ2VuZXJpYyBmdW5jdGlvbiB1ZnNoY2RfcXVlcnlfYXR0cl9xd29yZCgpIHRv
IGhhbmRsZQ0KPiBxdWFkLXdvcmQgKDY0LWJpdCkgVUZTIGF0dHJpYnV0ZSBvcGVyYXRpb25zLiBU
aGlzIGNvbnNvbGlkYXRlcyB0aGUNCj4gaGFuZGxpbmcgb2YgNjQtYml0IGF0dHJpYnV0ZXMgd2hp
Y2ggd2FzIHByZXZpb3VzbHkgc2NhdHRlcmVkIGFjcm9zcw0KPiBtdWx0aXBsZSBzcGVjaWFsaXpl
ZCBmdW5jdGlvbnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW4uZ3VvQG9zcy5x
dWFsY29tbS5jb20+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2Fu
Z0BtZWRpYXRlay5jb20+DQoNCg==
