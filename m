Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0F8390234;
	Mon, 27 Apr 2026 07:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777273374; cv=fail; b=CRJKvjI6keL4TdJkzrdgez+0lqQ0p0N2q615tWeNFgzDMNi+damPkxpWAGCk7bFEStXf641LLWpPUk6l6tcdmKqNa42VfUabF7AR3yEeZdBXc9P6FCqRmE3OF40A1PfUXjG2oh+NNjxjJtdVNkyk49cdaw8Kv7kbyIF2iiRbGQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777273374; c=relaxed/simple;
	bh=H8q3o40hQhfwhsYpFZOrC+gvajizVAX1diPNyM8Hc8w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YTO/N2nWKoMx1RB1JgRUgjylQUkXUjRHlB4PeEXmRouiqx37dT72+XNkNjfz/ifPOyvKLpn7FPcvEs8WPpY7n4a81/oagIXx4as5Sv+Pntl11HKMNVfypi/h3wiYLN9f0cSJF2AFE0YGzGo63RAcsO7TSq9HV4c9UQT9C6Mi4Rs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Tk0NdvfE; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=MvfhA84h; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Tk0NdvfE";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="MvfhA84h"
X-UUID: 144a9b1a420711f19781c1a04af40193-20260427
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=H8q3o40hQhfwhsYpFZOrC+gvajizVAX1diPNyM8Hc8w=;
	b=Tk0NdvfEgVsOrRPTzG7lARkmHm4+fxS9ezHxw93oitkp0joKtEyA1K2/QqXOOOSFxdV9ASTmIS8qpmuek9tkmKGBZ6scpS/IHIccjywQTpebOLTECWESoO253cr7xftK/UXcQ+2yYiMqwQhAtBRfr0JmopxgLp7W3AAsViTCZRA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a8497a80-9d62-4b9f-acb1-68f9fd9bcf2a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:a7afa764-469e-4eb6-aeb8-4b21454b0f32,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 144a9b1a420711f19781c1a04af40193-20260427
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 829533642; Mon, 27 Apr 2026 15:02:39 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 27 Apr 2026 15:02:38 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 27 Apr 2026 15:02:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AX4oFrh7wbPbizOaR8ypjNhZGazcRGxkbYvpkVIVa7w6eQsK3HEDGGfX6Hwy8WAT6pJo2j0DXoTCSfxSPfCRn3t7OJvrgMW69kyhNr2F/8VdF0eIRzWBtNjX6cmjo6tcgsQIea/OAvNfLpWJMi2cwUXY4tRllTMFL0dR5zcF71rM0Iye1Jvkq3wgnyLf8T+IJLflBcccHrJEhgPGN7KpU8AwuETCp6Jh8zkrUOePdbc3mbLrEexRLFDX4RCPs4FnUuPLuPB/P79XDwauULyhaoMAwl4TP/QyUoPIHFUKMXuf3vPt859sedSNBZqtfQ0fdWgEa2AOb7i6G6WLy7avpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8q3o40hQhfwhsYpFZOrC+gvajizVAX1diPNyM8Hc8w=;
 b=TvYEro7iTFAxbl5PEDoxbFDNXoOS6pCeP2lP/uVvzYu9BfCeH9ht3ePKaGWE+CJhX0s7am2XOuhFxW3wS6Pv5Gr57B23oWnyMNwHOn2usNdR71ry7rbyibti7sBt2ZiV/Q1RUP4LzAXStoEtVIxRmMZMZnmZrYh6pFz60Xj+FIMX/tAr72DtSBOycZMcn1zsOTDOwhrRhLzb8Zsqm7k3L07EXW6GDVr2jbGXVbdpE25Nx2/gSFMslOcH3ChPBdTsaNaKtBue7YpWQ+mpnls7Nen6veBa4F1t1gquXo7zZysdNfe1zXecl75u4AfSYt245oKDVQLvytpQCYAD2CoZQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8q3o40hQhfwhsYpFZOrC+gvajizVAX1diPNyM8Hc8w=;
 b=MvfhA84haBmtXbY2UpPtdfiNIWPVr5UsS5aPk8q51dJcmkLo6AD4MheX/5o8ktTmaiHZZySoh/QLz6/zP+bOPYUWNsIeekeIkIJEet+LBZ+bMj9cfZZcX59b96HQX19QHn+RJ1rzy9/juOxvK9Hpgy28qlfrBsRPgY27nVaX9K0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8261.apcprd03.prod.outlook.com (2603:1096:101:1ac::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 07:02:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 07:02:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"vamshigajjela@google.com" <vamshigajjela@google.com>,
	"rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Add support to retrieve and store
 TX Equalization settings
Thread-Topic: [PATCH v2 2/2] scsi: ufs: core: Add support to retrieve and
 store TX Equalization settings
Thread-Index: AQHc0/1DKYYRHzV66Ue2ZOuoxjsgH7Xyf6eA
Date: Mon, 27 Apr 2026 07:02:32 +0000
Message-ID: <39639798e11b3b1b6366ed2e7a42ab91c8840761.camel@mediatek.com>
References: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
	 <20260424151420.111675-3-can.guo@oss.qualcomm.com>
In-Reply-To: <20260424151420.111675-3-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8261:EE_
x-ms-office365-filtering-correlation-id: 90b2c36f-e1fe-4f92-6653-08dea42af3e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003|38070700021;
x-microsoft-antispam-message-info: zIM4xPHmvtuRHRWvts5zD5rMOt7hJeCzgGdljlf4mts86bcUyEooUIGDQKDa+YdYIKlels06A0wlC8N6R/yBSW0S+dy8mtqriqW9grlefZf68l4cVkqPmnf1UDoXGJaR5Gp6ZA9vH/tFqJwX+pqflXKH1XHaLxip8vnAOGzpe/RPcbQ1BL2Kn7zOBdd7bPUiCmZS05p/VguuXKPYfmUT23P6aeSxWKEZVuXi2qBdWQdwpGy6p5LxIWXXtnK0zNnvLTmO7Eh0MiKBwKsibckcOGe/iPZIc4RubKubRFD9/nSp3ssI52stSIcFhcYbmI+XTkeDkI5PDIGp5R7peJLCA/GS2VIt9VIdRLGNjUPQcvez9OvFdIbTlvx8Dpn+YXhBPvKn3e5CoFRH+hMHQc4VS3uXk7F4opdxkO4W0uZZk2d8o9mnyWbzEg/k1nlVWZ/0ZRTlQCPOGbb9maJUgzkZXVcLngj1ysU7bFiTBdeg2EXRxkY1wOUbxlwCM929xHdXnuZVpCD6zOGJB/kBsICgHv+0mXZHf7dEgSU4DwsI35ygHvxdeHamV6Sw/xWOZr2ffklWSjybfSdRuS2mpu8KpSJcl4zjHK+suiyV4jV7ENZdzNqMtvfhi74LL56p8v1P5oMBtLspLFSEWtU5S+mtgoEXUq2KYECJ+gjuirqLM2xkeq2rLFvP27yTkcJSpUTsE0DvhGRa/9trUOjkI/ejrObaLFMKXlbf1X8lwqA5HcuwCLBBirgaNeipF6ODgHg+LHsTXwMpBrbOLtUD2k6i/FQ+qOFcJHks5Ej/Es4Fxq4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blArWThadjB6em5TVGlFeCs4TDAvdC9xZXpsVU54bjNKS0pkVzYvT082SERi?=
 =?utf-8?B?ZVpJWWJVdXNMMDU5WmNTZTVmQjJyWVNqTkt0Mmt6TUtwRndOVTdXbTNITXR2?=
 =?utf-8?B?RXdyVW13VGpOMFJ1MGIzanFYeE93VDB2L3p1REdxSWs0Qjc1aWRUMCtnakQ3?=
 =?utf-8?B?OGJFU3JtSkxOcnpKOVFnMDl1c09rQ25FaXAzaGYwZE5uSGE3VlJvS1VFU3dK?=
 =?utf-8?B?dVFxUDdRMG1hNDNsS3RKYWtiWkpnb1JoSllPZ0J4NGJFTzRYcEFEejI3TDBT?=
 =?utf-8?B?TE84TjJ2TnVVeUdCamlqaXVubmNIQzFMMkUrTlJ0RWxWWXMzTkRLUllkY0VK?=
 =?utf-8?B?MHQ1bVVWQ0M2SUVWdVIzMEZOeldkdkpkR2hJTm9UOHpDZzdCdjhlNEJITHRE?=
 =?utf-8?B?YWNrQ1RKd0VZZ0NNYWJqRGw5eTF0cVBGUlludzVHOFNXQ2IzcWlCR2wyMitl?=
 =?utf-8?B?UUVRWTE4ZHFEajBrTVAzU01pQU1zdGFFd0VTT3o1OVVCUURFcVE3N3hlYmgv?=
 =?utf-8?B?VTdPOXlpK2ZCK0JtM1FZbUowdmZoWVFTWkl3eWxybEJFb29UYTl3SUJIZ0wv?=
 =?utf-8?B?bHF3QkFFblhaeksvTGpmWXhhOGQ5MWxVamNNdHBnT3oySHZlbmM1UlQyWExl?=
 =?utf-8?B?MU51Umd6QnRDbi8zaGo4cVZucHlWeFhxdFFDLzJMb0dNcG81d014c1BuN2Nm?=
 =?utf-8?B?MHp1WmRlRkJKMEVyR2dxcGowekZDYkVZd0VQdFhrNGVPUHZobVJ1dkVaWm8z?=
 =?utf-8?B?dzRqOWhFNS8xZXVzZFZuclpNR2gyYlpvRjlVRTVtaFFDOUhIWUdNQnhjcmtY?=
 =?utf-8?B?NjBjeGRNaVNOYk9uK3dUbWJtNmJuRkdMTFZMYkprZ3FQOGs2dUg2QjVXeHUw?=
 =?utf-8?B?T0NpQnpnbENaekdlekh2c3NtT0pxa2Z0Z2FXMmRDckVjQUZDWGw2SzJVVkJx?=
 =?utf-8?B?SmY4OHJmSWwwMWdLbUxNOGp3U0hMQTBJVk9vL25WMHJ0KzlCZUtvMURRZlVk?=
 =?utf-8?B?WWtnb05MK2Rzdkk4ZTEzL2JqV2FxV3h2RnAzYWhBQ2pibUhMck95bTB5aS9T?=
 =?utf-8?B?ZmYxcjRWSm5SeFZmOWdLbkpLdFIreHpsY2dKelBoaHJ0UkxzU0xLV1JDbGt1?=
 =?utf-8?B?WmUwWUpyVlJXRmtkcHkzSG5PR1U0YlU1VFl6VzRKK0I0SFBtRGRjK3o1NnZa?=
 =?utf-8?B?NEZjVjRrZko3b2JaeWxLOENEMEZBUHYwYTNUcTRSQkxwZ1NnWDdwSWQrQUVy?=
 =?utf-8?B?YjdLdDliMHFjU1BnZ2VGdG9pL1ZOOFk0RmViWDJWMEIwSjE2ZEtMckhwNkQv?=
 =?utf-8?B?dXhCYU9YMTBraHFSMnhlaE8xL3d5WWZpeVMvaWVMajdxNWhPNWdFUExWVFJi?=
 =?utf-8?B?VHFMZjNFRVlTMnhmQkVMZ3FzV3k4cVZRUTBPRWo1clozL3ZYbWFpQlhodUdG?=
 =?utf-8?B?OGJKK3JUR2UwVGltNXVteHAxdHJ0dEdUVHVHQUZLOWVkWi9IVFUxWjAwUkJv?=
 =?utf-8?B?elZuS2lucUpMSTh1TGNycmZqN3lOcnJ1NUhDMnR1bXJLckVFb2R4b1lPOVho?=
 =?utf-8?B?THFIeWhMNTV6NjFtaUJsN21ZT25tUEhZeDl0QklYaGphL3pqMHovUU9RYW4w?=
 =?utf-8?B?eEhOeTg1RGIvYnQyZTJhRHZVcHNjeEFZMy85ek5sMGlpQ0ZidXkvRFQ1QjhE?=
 =?utf-8?B?Vi9KMzVZRmtZdWhFcXdhTFAwTlU3REQxdk1wcEFHRVFJY25uZGFUcWlrcTB4?=
 =?utf-8?B?ZnA5bUtCQzk5SEtjVXhvalU1NVQ4RTJoMnAzaHluVWdnWjYvWjdXMTJhS1JE?=
 =?utf-8?B?Y0dXTUVEZTAvV1d1dzNVeUc3bUFhMURGTk5hVSt1eS9tOGNCcFYzZlBmVG1t?=
 =?utf-8?B?ME5zc1BXdmRXVU1QSFB2aS9KbWNQemxVNUR3Um45SWJJeStUWjFpaEQ5Z3dN?=
 =?utf-8?B?ZjM0WDU3VzRZNEtqd0syVUs2bVMyczhyZDlvN29QNWYwMEVNSE9FMXM4c0Jk?=
 =?utf-8?B?YjZxeXBTQ1BDamtDZ0RTNUFMWnBVZTNDRVBzTUVzRzRqMUxodDJTeUpEcXo3?=
 =?utf-8?B?VmNtNTRZMlZ6eWp4ZlViV1lJRG8xQ09veXlDRXd1RnBMcC9NcjFkY3hndlVm?=
 =?utf-8?B?dXMrMlBmOVZtMmxMR05BTi93eG1wcCt0OUJSV2tOcGtBNFhDMUIvdHVwRUFZ?=
 =?utf-8?B?UUtLbEpPb0hJK1NpNElxVGZvNE5Ba1haRDdWcFpXNnl1NWdTbVR3am9YRmNt?=
 =?utf-8?B?bTcrckl2RG1zMXpIbUc5OWZ6L1dkUDY2YytzeWZtY3JoODBMN3pxTGdZRy9U?=
 =?utf-8?B?ZEI2K0w1aVlIWDBzV0p1eTFwNWxqNERVcmJPdC8rYThTV3FBbkdNeWlwc0Zt?=
 =?utf-8?Q?nVbBjobzTdmUAVFU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50B19EDB008C04439231009CA0746E38@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Slpi5jZadE8PDPTAAQS/Gj7gqmWu7b6VQipoEro2mg7vBBQNNYmq0kcKd1L2IYU8S9uQwBFGVDsKoxe00zxef6ueXuSdslegAi/Iy32Co8J3a1tEyp7Lw0bKu+7URfrB/no7VPj4TEk6ulDutcLFOx7yiyoEbiXJSkR7qCxdrB37TxlLcGpA6eh5LZllmv9p85oU24KRjRXI3yo553A/jmjW+bCOtY6qoRvrU59IOb5lO9kAEaZwU65oNmYiaD552WdcsZkQVx6oaO4Jaax1IOVcytm19KfZIA17T9dXHMS+w/1o3QmwZT3TI9PvDmK8bWY4ogDbURP9hnRDv3XiWw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b2c36f-e1fe-4f92-6653-08dea42af3e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2026 07:02:32.0446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3l5S0RVJQ/wVMqEjstKsynWpe1zHpJ7oj95LL7v+oIyRpORt1b+ETF731u7UXHHa6AaKKfMPcCb7NdHkcQRY/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8261
X-MTK: N

T24gRnJpLCAyMDI2LTA0LTI0IGF0IDA4OjE0IC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBBZGQg
c3VwcG9ydCBmb3IgVUZTIHY1LjAgSkVERUMgYXR0cmlidXRlcyBxVHhFUUduU2V0dGluZ3MgYW5k
DQo+IHdUeEVRR25TZXR0aW5nc0V4dCB0byBlbmFibGUgcGVyc2lzdGVudCBzdG9yYWdlIGFuZCBy
ZXRyaWV2YWwgb2YNCj4gb3B0aW1hbCBUWCBFcXVhbGl6YXRpb24gc2V0dGluZ3MuDQo+IA0KPiBU
aGlzIHByb3ZpZGVzIGEgZmFzdC1wYXRoIGZvciBUWCBFcXVhbGl6YXRpb24gYnkgcmV1c2luZyBw
cmV2aW91c2x5DQo+IHN0b3JlZCBvcHRpbWFsIHNldHRpbmdzLCBhdm9pZGluZyBUWCBFcXVhbGl6
YXRpb24gVHJhaW5pbmcgKEVRVFIpDQo+IHByb2NlZHVyZXMgZHVyaW5nIHN1YnNlcXVlbnQgUG93
ZXIgTW9kZSBjaGFuZ2VzLg0KPiANCj4gV2hlbiBubyB2YWxpZCBUWCBFcXVhbGl6YXRpb24gc2V0
dGluZ3MgYXJlIGZvdW5kLCBmYWxsIGJhY2sgdG8gZnVsbA0KPiBUWA0KPiBFUVRSIHByb2NlZHVy
ZXMgYW5kIG9wdGlvbmFsbHkgc2F2ZSB0aGUgcmVzdWx0cyBmb3IgZnV0dXJlIHVzZS4NCj4gDQo+
IFRoZSB2YWxpZGl0eSBvZiBvbmUgc2V0IG9mIFRYIEVxdWFsaXphdGlvbiBzZXR0aW5ncyBpcyBp
bmRpY2F0ZWQgYnkNCj4gQml0WzE1XSBpbiB3VHhFUUduU2V0dGluZ3NFeHQuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW4uZ3VvQG9zcy5xdWFsY29tbS5jb20+DQoNClJldmlld2Vk
LWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
