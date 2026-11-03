Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712773;
	b=qDrtfV3cGpDoOYIt1sjvl0bK7gKZe4KxvpBg4isi41xFUQ/Ui6JPphsf0AlUNcqn6Kt9
	 Ax8doJq9P5npGxPxKRRTQlZFvDNlg7sa3a34/gQDN2g4Ffikd9Q2ZFiNBmzffyLkyif7e
	 dm5K1lXN0itabgu6b/5WlUaE8SIFu0QTm3dTlofrArXqKRyHW7y8O4hlrVjTr7I3EWcT4
	 8NO8Fp5D+uZ1ikdZpNGESLOkeGmuRosippWmh2axlnAnJHmntIcXnGD9FI7t/DoaNJ2yz
	 N5lNFbrdWj02IRGXWFhdQFu2QUqxMlaQFMhVzS+36/ujV3PyMlkgt0Cb65+Scjc43FA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712773;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SharedMailbox-RoutingAgent-Processed:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=UoMd/l3Ll9kT2JDl/tRludiPudWCZ7eJlyHHN28IU5s=;
	b=zmDVSp9goZ65mYDGhSC8C4pQ8kiIe3lAmaDXUbwj7MEZwiL1W1GOk7zB1u+CjU/IVYqT
	 7CfhbfdB90tnaap/g3FjxTMQrHxA4qSX6mAak4+bHYuPW5vgvz/KKAVvQjs5+U4boCS/j
	 xwA4+KiNn/DJ6jkH+EUZumXT2or0bXyZO4w4DW+3qmen3YC/ZHoibZsbe61QNRI9nPPdB
	 advoG82K0arlLH7gfYNEN+mnWsnrK3F1mS7q51CnHUn9PginX/mgPvZkriwNEp94pf67K
	 J8KF9RoPmXdvUcW1EiHp49ndZSdTTTtPGArb4r2KQ2V6SGXA8d9nW5BjA1HSUbPv2BA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=oWr+eiXO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.34
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013034.outbound.protection.outlook.com [40.107.159.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522E0606D818;
	Tue,  3 Nov 2026 13:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 522E0606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=oWr+eiXO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xa3ICEQi7vUExfo9p1Zq3/NWGN1RpEEjcFnuoyAcszBd6/B4nQhTDJyU9aFLAJGfzM1pDmR2fUUTjcXE9CJZQChcskB5s6EVNugY7Jw3S9mEaWWJCf3yKxMjOkkx54pVStiqBOk2IN6dak8dWpNd2OEyndYxzJzZmX6MUPoaHO9+K2YKhCNzTCQhtKaPbgRp7UYP9pF9MbIF4k/1y/YEIJ4iO96TOk8eDOkNVlABnwi3WJfoCu8I7b6CHmQKbW8mdzw1UU1CiO/aZRUUz2DbVaHBgvcd8h1hHpSpbE8LCrrD2WIA83VPBDDHVohfHHs239WYPScNAHkR/SG5joIJXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UoMd/l3Ll9kT2JDl/tRludiPudWCZ7eJlyHHN28IU5s=;
 b=yR9I5eWuw2JhYOfpDs+GczGAPBoC6PeeaR559RgoRmZT0BPs7jxgdBp1D4Y2oZTusZZMB+jYJGBsUiTl5hwVR4o1iV2uQQb7QvBRXwxLOhwYnZb+5Vt8nhOU8imqyJTz3ZH0KZzwolaVwB3yEO1FTnjT3smd/Q/XdiSttuTK2tC5ZKed4u0XGMzBl7JnPXFiBVCgGhZCJOabOZGhWGSqaHuxqv+WRC61RV8GHcI1XOgvPxm4FqYE+WrkExRQyXr7RrSS4tmLLSv1hpMsN1gPD6u76Sht0ZZni+bkzhIahPBKij1T62bgBidqt5bdLsu4k2zipAue3F3u31X8NxwZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoMd/l3Ll9kT2JDl/tRludiPudWCZ7eJlyHHN28IU5s=;
 b=oWr+eiXOJiBvF7CNj/+ztcRzpqrHOEziZJIlVVqUAsTDgTlU5s65XegnQAN39n5bqjs55WvZka34XHjxYkXUHlmLMd5gFbpxGH4pDWDrLrsrz20pyClhNpQEGjFIaTMathWspwWA61eDrRO23OmVl6lnlgt4DHN62NmNoiXBH0PBxVbxlaQvotnhwpuNuC/sIOGwq0nL4mNtNUtjgYp7s+XI02saSJFuyyAtM8S4Rga6XagKzCvx9Ls0pOmEUXJapHIZll9TxPma4lUde+krLPKxoCkMOJybics5X2Awc3rQcitG0RRARYxj+pet5c8EXDBRVOfzsIn6AUBFmjhmfA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB8777.eurprd04.prod.outlook.com
 (2603:10a6:20b:408::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 13:32:48 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:48 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>
Cc: imx@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH v10 04/11] ufs: unipro: Add TX/RX FSM state attributes
Date: Tue,  3 Nov 2026 14:32:08 +0100
Message-ID: <20261103133215.1385823-5-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P192CA0001.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::15) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM9PR04MB8777:EE_
X-MS-Office365-Filtering-Correlation-Id: b9f8a36a-a1b1-47bf-c254-08df39aef355
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|19092799006|921020|11063799006|56012099006|261009223027099003|261102123227099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261028144727099003|261026121527099003|261026140227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 fwuUb6tce5ZAnilKMVfp2usknBM9g+UgU8JqWBIrRqwCxBgs/3EZ7LaUgEnTjRL76ij9vjDZpPp/Z7DlThW+r1Wq/5+6eA1aetMbrsIlg9UJyJqJQsnEY0JfGhtq1yMOo084y0Gqw31fuIca64BDMWJx7HB8QLaTXFz9KmhuGu60aIYY7c0kFFtznHNTrBkyoBL4k3GxHPKVSsIa7zbgmzfqpt6WK+ylM0+QE/0w1zSWt6pR6e8lxuF+XlPn4/cm8NCCdnZEaKUgEj1yYr/SoHAlVzyJ1VVYvJ60W/OXxP/VrFHLa1orT+LsEgTE/PWB3hKfbtL6PCnlQp6WRI1TD/aBWsyl92q7DagM/GzWKI0CqmwW3AyEIZTKLK/qTEq4tPEJCUbtOQT0Q9WEePHfo+5iDEKDpM0iAvttaH/WZmZmmYo5lY6SuSH/vALGEXdWTJR7nbPWu69povd31JgJQc3FGgeabsd8O80y3lWzvzkZtPfJTAAsnJSivfvDDUb1BG2iYr/y8DySVGdK+6TS93feT4HtUyhpCbUnVMlxd0etaBIKnA7j39P1UweSdPwmjRHeakqKqNg+ga/5NkC6iGpNUDp3C34TY9gjLQw28TuL9aYzBRgSRCb6yYtykWVApA74b6/yLcdcKqYbamuse8Nl5l5i65GRzz/iFwIoCLU2l2O4MT29Pl+2wnrKbYlBEkaTkWuMPkPAuojrQxqbSQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(19092799006)(921020)(11063799006)(56012099006)(261009223027099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TUEyZy9OWjVYRDZncW9BMGxDU0VyTTBjWFRGNlBVRy9CT3hFeVAvYzI3YTBC?=
 =?utf-8?B?KzhCaWQrM3IwQThnc0tGSzd1Z1drajdXQ2tFSnNCMjBJbmVaNVF1R2JmeVZo?=
 =?utf-8?B?cjVFcFhWYlgzdEhNeGRZalBsQUdpS29OdmwvdUlRZnRLUisxa2E0R09kSG5Y?=
 =?utf-8?B?ejFLbDB1dnhkTi9FM296R0Y3NTBlZjdiSmgrTEc3WG1Kd2xCK3JVTjN1bWZa?=
 =?utf-8?B?OGNCZ0VVNmR0c0JmZTNXZ1FrY2lYdTRDS3MrdWtGR29YVkdnNUI0Z0xUQ1NE?=
 =?utf-8?B?WFo0RnhsUlBJTjlqaHJ5R1BNV2FEVHlOT1BuZ3orRkwvZWxnd1dPR0s4SWJx?=
 =?utf-8?B?NzltejJNZENvRjhGMjRRZjNWWDM5TlZQMmh3cnM2YlVud2RBY1RSamNRZGo1?=
 =?utf-8?B?V1hKRFMwSEZzS0xWaXRMTzFrWU1nMWVWaTc4RExpZWhXR1hpUmpRM01JTVpP?=
 =?utf-8?B?ajRMTmhUNUw0enBPYkFqZ0tiQ0hPSFdJTHM3RmcvWVJ6Q0xZV2NQUkgyTHV6?=
 =?utf-8?B?M1pTRGM2L2c4ZnhSNGhzRm5iQlRvcWRUTzBhN3ZTQk91U1VKSVVwdU9PclhZ?=
 =?utf-8?B?TjcwdDcwdmVkbFZvMm03OXFGUDhjaG1mZWV3WUl4c0ZDTHpQSjg0aVRoa0lR?=
 =?utf-8?B?TU5ZalRyZ2lMOWlKbGs5a2ZBWnZta0hGYTVYRkdRTU5lU0ZnT0RTWWpQRE1C?=
 =?utf-8?B?azFWczV4TTlDeG1vY0xSNVYzaVRLZTBqMStkWW9xMnJ3QUxucFNKMXRXd1RP?=
 =?utf-8?B?ek1zTjdMeVRzVGFXbHQrNW13dXB0ZUMxaldMdUFxL1AzZCtaa3FLUEx5RU5o?=
 =?utf-8?B?KzliZkUyendhQzRCUk5GYXhYRnNDWUE3dGZwSUFkMEhxOXdPaEVYZWF6cFlL?=
 =?utf-8?B?dm45eU1KTmpBSW0rRmRiL2hlTTFCck93aHBZekFYeFlaVVVCRFh1eEJjb1Nk?=
 =?utf-8?B?L2w1bnJySkJETnJyL2N5WVpydEI2Ymd2SlFEaE1sV21hM2orTFhYRWp2M1Qr?=
 =?utf-8?B?MXUvUDNvUGdFY1VFeXdBenZybFFmMThkYWZKOEpMWFMrNS9FTkRQWi9SdEhx?=
 =?utf-8?B?VVJnQ0ozQ2JvbmgwN1BGWHBtR2F5eDFPNkVQYmJjd21WZ1dzMW9OUEFPcW4x?=
 =?utf-8?B?Z2hJZTZuQTV1STBLRHIxRzlHVmdwN054eVZLNzVTaWJxQzlJUTZQdDZ4MzFs?=
 =?utf-8?B?MVIrcHdNdnNQSFJVZStMaVRabzdUUGlseFZVY3FCY3ZLdGJiZGNsTm5lQW1q?=
 =?utf-8?B?ellyanU4M2hTelByZWF0d3VGUVhXQUZ2SWNGTTNnUTNVNTNJRHRKVnBXZ3I3?=
 =?utf-8?B?clJJWU40YXhBWUxEWFlpUjVlOXR6YTRLQjloVm5zdExGSitYV2p3WUdHNkhq?=
 =?utf-8?B?SDVxai9JTUJFZU01eFF5RlhsQjBod3RYRkcxdDYvTjFHSndmZUk1L1Fxd1gz?=
 =?utf-8?B?RzdyU2pLWWQrNTIra0xzbHBuMTBGUFJCSkgrUWRwY0ZtL0VRa2VqcVczQ2RH?=
 =?utf-8?B?d3RRVnUvOGJaQTZtY1lkWE9KajNhM25OdVpLTWZKUy83Wmc1WjkyK2RtU1Rp?=
 =?utf-8?B?SzBGV0x0OGYvaGRHMUx2c3F3TTQ3RnF1V1FqaHRWOHJXeEhKUGNKOXpjSjNr?=
 =?utf-8?B?SGw0eWlzc1lvbXhVdyswSEhBK0pqWjNUOGp1bGZSNzhKMGpSSUVLOHFIV25v?=
 =?utf-8?B?TWlkMzNJeHpaaFkyWmVnRW90UWI1dlFZZ0VRenZ2Q0k3UkJjL3YwOW9lNUVV?=
 =?utf-8?B?WWlYUmRuaUxJdDQ2NjA4UFFQT2ZoZTdubWFhTHJ5d2FvalRjNGtkWFlHTDNt?=
 =?utf-8?B?bkxlbHdha2hKVlk3QjRnak0wdnNLb3o3SFVodGszVTRjQWZId1F3VjJOTVp4?=
 =?utf-8?B?Wm5BY3RVTHcyejBSMXZHMW41dUNKMWR6U1dVSUU5Ync3UTFDMEJaMDZ0WEhS?=
 =?utf-8?B?NVBDU0hrVjI5TWl1RHB2ZEZjeDE0VlhjdDZKSHRub1N5ZG9xSldibzlYTjNE?=
 =?utf-8?B?b0JWQ1FtUC9nNFRYYUphK0F6R3VqT1R6eEtnU3NuSEI3T2lmOFQyRVlmR3lH?=
 =?utf-8?B?Qzh3UEZhOEhabkhWTkpmS2hDYzlQTlErcXRjNFpYUjdIaXBiKzRQbjB0SnVl?=
 =?utf-8?B?RUEwNEt3R0Fxc3hBZHVHRjB0WThzaSsvclRGT1FQc2ZiMTBFeHVDTG12WmhH?=
 =?utf-8?B?NFBNQXQ0ak5qcHVNRFpKcEl0dmNqRlhMamYwSUd6eng0RVpCajFoSUd0Ryto?=
 =?utf-8?B?UiszOTR4Mk9kdUg3MHk4Y09yNjhVc29IQmFRQnpTN3h4bmhYcWorMmVBWFNk?=
 =?utf-8?B?eXVpYUFCcHBqTy9xbzVnUm9wd1psZUZHRGREK0srUkM1VEVHeUNJZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9f8a36a-a1b1-47bf-c254-08df39aef355
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:48.0282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C39gUJZULOEJDj7YE1u18dOSCr1PAB5gK4pJsgdQ2O9tnxY/eL9hLY6xE6zIbnZECd37RH9VXoX5/XWFMwtNXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8777

Add TX_FSM_STATE and RX_FSM_STATE to include/ufs/unipro.h, as these are
UniPro M-PHY attribute definitions rather than host controller specific
ones.

Remove the duplicated local definitions from the HiSilicon, Qualcomm and
DesignWare UFS headers, and update the HiSilicon, Qualcomm and AMD Versal2
users accordingly.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 4 ++--
 drivers/ufs/host/ufs-hisi.c        | 8 ++++----
 drivers/ufs/host/ufs-hisi.h        | 5 -----
 drivers/ufs/host/ufs-qcom.c        | 4 ++--
 drivers/ufs/host/ufs-qcom.h        | 1 -
 drivers/ufs/host/ufshcd-dwc.h      | 4 ----
 include/ufs/unipro.h               | 2 ++
 7 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 7c0f102ffe7b..93755befb880 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -112,7 +112,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		u32 time_left, mibsel;
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MTX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(TX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
@@ -132,7 +132,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		}
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MRX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(RX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index aaf66bfc3e70..fb44a776e9e7 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -30,10 +30,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
 
 	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 		if (err || (tx_fsm_val_0 == UFS_TX_STATE_HIBERN8 &&
 			tx_fsm_val_1 == UFS_TX_STATE_HIBERN8))
 			break;
@@ -47,10 +47,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	 * check the state again.
 	 */
 	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				     &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 	}
 
 	if (err) {
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 6af6a268458d..08dccfbec404 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -39,11 +39,6 @@
 #define MASK_UFS_DEVICE_RESET		(0x1 << 16)
 #define BIT_UFS_DEVICE_RESET		(0x1)
 
-/*
- * M-TX Configuration Attributes for Hixxxx
- */
-#define MPHY_TX_FSM_STATE	0x41
-
 /*
  * Hixxxx UFS HC specific Registers
  */
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8a2e0c63fb03..e5676b86de23 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -421,7 +421,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 
 	do {
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 		if (err || tx_fsm_val == UFS_TX_STATE_HIBERN8)
@@ -437,7 +437,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	 */
 	if (time_after(jiffies, timeout))
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 1bda960c1d87..0b062cf912c5 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -10,7 +10,6 @@
 #include <soc/qcom/ice.h>
 #include <ufs/ufshcd.h>
 
-#define MPHY_TX_FSM_STATE       0x41
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index a5e40e7604a1..0406f2bb576b 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -27,10 +27,6 @@
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
-/* M-PHY Attributes */
-#define MTX_FSM_STATE		0x41
-#define MRX_FSM_STATE		0xC1
-
 /* M-PHY registers */
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 16b2051f7241..7adba11f4700 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -34,6 +34,7 @@
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
 #define TX_HS_DEEMPHASIS_SETTING		0x0037
 #define TX_HS_PRESHOOT_SETTING			0x003B
+#define TX_FSM_STATE				0x0041
 #define TX_REFCLKFREQ				0x00EB
 #define TX_CFGCLKFREQVAL			0x00EC
 #define	CFGEXTRATTR				0x00F0
@@ -72,6 +73,7 @@
 #define CFGRXCDR8				0x00BA
 #define CFGRXOVR8				0x00BD
 #define CFGRXOVR6				0x00BF
+#define RX_FSM_STATE				0x00C1
 #define RX_FOM					0x00C2
 #define RXDIRECTCTRL2				0x00C7
 #define CFGRXOVR4				0x00E9
-- 
2.43.0

