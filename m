Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712781;
	b=2eHf+4yb/jFQjyKh3vQqWWzRA0zJ5tv8H7uvNA5OdZQLBBnK+V7xZIFLGo6+tl/vOp7f
	 lGt87ohcxoVMspvkjgL6v7prXeote4m9wcCOpivgm2AXt4L1q0nBgXw0iyzHZL7M83g3M
	 TBmHHzXNjcCVTl8FySCntzssF7ePzINaP+V0qsoU6Kl7wY8B96SU5T9j+jNyjUX/ym5lz
	 p8PT8kh6gqEmjmmiKiuLToUqZ0++4dCew659PIsuB6CxvPiHbTwQIyG9IMo5dKGVDGbHE
	 jHvSCNr7KLh9/H1RgOI/4wW3U6X7B800Jc3sOdoXCPuKMlgLWLyY+pd4tNNZkHfqgPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712781;
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
	bh=+nuoepDxyOaeq3fTTIAEL3DCpYUUcz/wyHRk/Z8GeAw=;
	b=woXpH8TSyfxdWZWlj+0SbyXasbwj3SWxlk6WR5DnTW3BsIr/NJ5Mkl96cdDeWZtk8MzZ
	 d2MUEG5N1MAqoQfJnS2OAxFSTk4zEUNuuBFAC6MWvqSGHu7vtE4xo/I1+uPaYuRNhY+LX
	 xoX1/P6wwJYb7omKAOgEdNGeP0xEhLFGuHi255mFW5k74hVxtpOZWOT0GakfEigbrwaYd
	 0K0tZTzqCoiWeLA+QAVQPo3hNJqIoTe+m76BGTjo0Ttq6KkVdX/CgcJNOMqhmRGiEzCoL
	 u+6F7uxREQdrrvfh51omlEW8MX+C7zte2IVV67ElaIWjg7xV2Y7GT+cIx5SwrmSicmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=UTBmgG1X;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.30
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011030.outbound.protection.outlook.com [52.101.70.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811F3606EEB4;
	Tue,  3 Nov 2026 13:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 811F3606EEB4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=UTBmgG1X
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ABJyqCwmd3VFNq2flqIfX7L0c3tx6W/FVMv6wka7nsTO5CEfAEmDcLLTfoyDO/c1WpkBRRG2MVDAmF2DUg36gN7RACO16B/lKglPYqGqLQ/5VpbXFekgM4KWKp1A6ZbjJ71p3oBQWuZyJQwrXNcHNJn5u34/e3FJ7FU8OEWnyOBe+LZedHwianjPpBjhdpyLmXgPFZMEiUUrKxcHNzpBJMf+7MtbZ1/qfPHYgO4kPahHfbDZiXrPB/pchD8CWPGP4ZBCVLmbC/TUNyshCMfcfTGCEAFHWbFGQs36D55T8xoR6ZhGlXm3kJLWnioWM/6SO+Q+h63JrlYK8pP9iRcJXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nuoepDxyOaeq3fTTIAEL3DCpYUUcz/wyHRk/Z8GeAw=;
 b=KLd5lnnp+yCjoh0E6aciWmQ8pLuTL+I512G/TYFsnG7dznxP9+Bh2jRcpO1kbsVLA1BHHl8UyxhYBZ0udu4pmOkKTD7mP8evyp1EqbQb/CsFqG5+22yZIJwcCcXy6QgUdI1eXwi5u1oqsu9sqX3rr5Nwr/l43mpebYYFbk7roqiN9G5PVK1yMzZ6Si3M6w3roQ5wIEoivYZT3uS793BOmgjro36u15LKdgbmnUJXPdn6C7VcV08tzF0VQOdF3wzbPWnKQCcdVWrZRG9Kb7Tlib5mdxrSmVCPAmpgYPDUC+lYQIyFnVYtMHOaWumaCOEzJoBXf5i2NsJXoMAyvf4QkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nuoepDxyOaeq3fTTIAEL3DCpYUUcz/wyHRk/Z8GeAw=;
 b=UTBmgG1Xl72suI6fTM6MwtJ6JQ29uxoQP7LNq8h+YIFvkESQz5Xgx86Aq+RH7tBQgwkVroI6UH9/FpXWy1nlM6lSz8i7lgYHLSzwcRRWEUt9+lQ8mRsQGoOmCQwWTQZ/hRVDr05PL95HOhPrwgk/6I4p7R+ZQlggi6Rw/RWUed6LX+ssvsT7/xZts9Z9Vo8oC5YRwoZi5HoJWQOoRrJ+4YhXPZr3LPEZ5xICtGz21G34AgrSBteFWFhMCH7T2OHluvJ4i1QyeVVfdcSqx6q6vybiUtZwF2xMVm76FPGAAyNdu8fgpLxBPyGJXDeDH9JGPHEwN1rwGDKtiver/94Q8w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DU0PR04MB9394.eurprd04.prod.outlook.com
 (2603:10a6:10:359::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:32:53 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:53 +0000
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
Subject: [PATCH v10 07/11] ufs: dwc: Export common clock divider and link status helpers
Date: Tue,  3 Nov 2026 14:32:11 +0100
Message-ID: <20261103133215.1385823-8-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0535.eurprd06.prod.outlook.com
 (2603:10a6:20b:49d::33) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DU0PR04MB9394:EE_
X-MS-Office365-Filtering-Correlation-Id: 212c413e-f811-4abf-b02b-08df39aef6b7
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|7416014|23010399003|1800799024|376014|6133799003|10067099003|18002099003|22082099003|261102123227099003|261102130727099003|56012099006|261028144727099003|11063799006|261026140227099003|921020|261022105027099003|261009223027099003|261022075727099003|261026121527099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
 4iswm/H11oyVtH3w59E8jRWi/ANiNr6gfdhBHFuDyLAqnGmKP4SAcMvsvkoELTSETfNiHQ79r1E4MYoEyMvDrMzkugd54ujRkMqRm9lAERhTMwkYdxv2CUuzZVEB+r3nwRO/utg0BuOJQB0nAHenh9jmAUY2TkrcfTUYficZ1D30BxjsKKMoq+eHRgQzJzEdWRGtu8a3aHIaldADQSmKIyH4MIOwYwI8gAreIvSPppbJE5KJp9FmQ+YM9Drg+mVf1bZxJN3mm87K41ZWoPWERY1t71Ji88oDWWNJ9li8wOtWNk/XnVKgKnbni7zMq1AExp3Rj3FeixpZfFVd0eqLI6xhtpDhICTn3//iFacjhH7Eoepp4CwgVDUqdSCOtrex6YpV0SGnD/JQBelas8ec/LgongitdNuFSEFCHXNcompnvE1mzBRhFkrvpt/QeVY1JA31DZ9ylxkFBSanrVJPp0p/AhcnIyqV9nauGZJQWVd56rRQQeAnb+ktrf2mqOMOixMQC0nI25ogsjmy1mDgMmBUIPQktIVJ7tGHtUg8Pbuozu8Xwj2JanI7fnENivt4ZDEwo/+aqnwF5HJVxMMq+zq7m/1CklKSKaVlvu97GM8SG4FRIqyy78dilS7gv8jE8+AFCBIc7KKoPVttlvRfxMc1N4kgLBfZ2j+Rj58ZnVRL1FcmaeI9aQwcZrBKhA74AdCiJXqFmh5PsCHhIjBEqg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(7416014)(23010399003)(1800799024)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(261102123227099003)(261102130727099003)(56012099006)(261028144727099003)(11063799006)(261026140227099003)(921020)(261022105027099003)(261009223027099003)(261022075727099003)(261026121527099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dmcvQUUwcVB2SFhqRk1KVXAvTWh0QkNxUG5jTjBYMG5JOW1SakpDYnFSMG1D?=
 =?utf-8?B?bVVvWTFIZWlqaHVuOEFVeDNlOHJuV2h5eWhId0R6RHVWY2pVcGVSSjJIcVRH?=
 =?utf-8?B?VnpMSGIrbThDRjhwK1pqK3F4MFFFK0tyZGFqSWx5QXNoSXgwREtnZ3EyY1lk?=
 =?utf-8?B?S001NS9QSXFERVl1WWVGblBUdDZkaVV0NnkwNVRQMzBYSHA0YTdXZ3dUa0pF?=
 =?utf-8?B?OEk2cHFlYW9ja1pwNWpXQzJaREJhRXV2eHlXUVhqdmszeUVzVjdPaEJ3K05s?=
 =?utf-8?B?VDZ1OVlTZTZ6VnIxSHp6YmRJanZJMUZHczlzVlJIV24vZHZVT0pJNjBaNlo4?=
 =?utf-8?B?RGNaL1ovZ2FNR1ZON0N2T2hVOVdVWWxBWkNzQjBTL2JoOGsxYTNRdU45aFRO?=
 =?utf-8?B?dTBlaHlUUGN3T0h1R3VYN3NBeUxzT2tNN3JyVXhab0d2ODRRVlRpQU1rUndX?=
 =?utf-8?B?cGJFaWlxV3JRQUo2dXpmbHRHYlBHdjhBekZoQUh1blc3R2tjekNPUDRYWENr?=
 =?utf-8?B?K2FzM2JFYW5HNm1xamJpdVhRZFI2Ymx3TkN1VlB2Mno0WFJ2L3NFeEF6c0Uw?=
 =?utf-8?B?Ym15dkhlSDExTTkyTWtNUmdHcTR0VndNcjBvdUx6KzFsMHdWelpiRmdJMENo?=
 =?utf-8?B?TW5TbUhCbXdMNUVCK0J0UGhJZ1dWYU8vMEt3VzRNdHo2ZnFGK0dMN2ZyM1NN?=
 =?utf-8?B?THhsY0RwQUlRSGdpb0k3bWxNUlRwaFBQbjI2NVJJZFJGZjJ5Uktkakh6Z3h0?=
 =?utf-8?B?VUkwVTVmbDVQRGM2L0hpcmtWaDR3N0RDd2R6SDhzYkF5SFRQNWFtWHZNYlEy?=
 =?utf-8?B?QWdNL1lCVUJ6STdwSGQxNDlKRGZUUUlZZFEwWUEvUDBGMzhnSU1tbFpTWE41?=
 =?utf-8?B?SlVoMnJKdGVSa2Zpa0s5NENhNzlMMStQbWNXOStjVnRGWUtrTE9FZTh0Q2xI?=
 =?utf-8?B?N0xLYkROY0ErSWRFT2tTQ3ZLTDdZaTQ4eUowYmUyNGVpOVM1K1F2WmNHSXdD?=
 =?utf-8?B?amtaay9JUWNoVlBMK1FRczZNNk5YdUk3d3ZOVzlpUlBqTGJrYWpHZXJmR2hS?=
 =?utf-8?B?OTB0Rm9hK2p1ZHhrbk9tcFB5KzlLaGppZDhUNUZLZ09ldTIvMnh1NkEvRnBu?=
 =?utf-8?B?Q3R6WGRRWDFBeTMrUUw5NWxUeENDUWtuOWw4S1JkNTJUa2xmRXhUSUdPMzhK?=
 =?utf-8?B?ak9WQnhsbEcva0ovOUt4Z0tkZms1cDRQTGVyRWkvTnQ0TGNpOGc1ekZmb09J?=
 =?utf-8?B?Ykd1a0xlYlNtRUN1bmNUVTZmUWlkOEI0RUQxc0dQN2UxdUhPR2hYaUpZRFZQ?=
 =?utf-8?B?TG9DTUovcit3aWhQZ3VPT0dvcXBpcTRJUjVubWsxckt1clpyTHY5cG9oNXR6?=
 =?utf-8?B?cHg3S2ZZRitaVjhpaGsxWVlkb1ptYm5Ud3VucEVTU2EybENEbjY3UWZqZGRC?=
 =?utf-8?B?d3cyanhibmlDd0dBUFZmc2lGZy9jWmxGcU9HMFd0VzZoZS9Tb1d2V3dGUlYx?=
 =?utf-8?B?b1lKQU5ydEwyK3ovaGJxMk5vZlYycVIxUFpLQTQ2eXRwRWVhQmQ2RlRVUSs4?=
 =?utf-8?B?VzVwMldPKzg4TTczdDhxZXZwWXFmdkpoVUtUb1NxVGtmWld5OXFyVHVNcjl6?=
 =?utf-8?B?S1JxM2pZeFNSUG5veE9rRjh4d1J3bkw5a0twaVpSdUdkNU1YVnRGREVqU1Er?=
 =?utf-8?B?MXFHVWRoMTVYdXJ4UWdqVFJrQllZbnhONlgzdTlIaGwzdTJKL0RDblEwTFE3?=
 =?utf-8?B?K09yS1JaYk4wUFRzUnQxd2pNSXJTQXl2ZWxnTmd4MG5vRThuZHdqM1lzTkZF?=
 =?utf-8?B?Si9iRVhmSzlvK0toQTZibnQxY09iVjVGSm1SYlRYNUZqYnB5TnF1REgvZEk5?=
 =?utf-8?B?L1hyWUsxZWZyanhub3VSYTFFbndIMU5IeEw0bUxqRkROd3B2enFqbXVzajZP?=
 =?utf-8?B?bGtMdTJtNkRmVUlFdG5KQ2lodzdDRDlNbUUxWUdjMG1Jd2lLOFhWa29Kc01G?=
 =?utf-8?B?ZUdzU2NlVkVTZzN6NFNwVS83dTM2dGkrTi8ycjZwRXFGLzVyZlNueitOb3RV?=
 =?utf-8?B?WDdVUCtxblBWbGI1dEFNdlZHOTRxbGFRMVR3WGcrblhTZzUweGRVMnM0WnNQ?=
 =?utf-8?B?dUNuQkNpSmV6TU9seWZ5M0lhTExOVmdSM3pIMWxRYkZjOGxYR3lZZVM5ZC9x?=
 =?utf-8?B?clp1M0pIbjVHTkdIU09FRThYYTY5bUo1VHN4M0x4SVRNODJCRUxBN2h2Q0R4?=
 =?utf-8?B?aGVBOFRQeUlvall2OW9UVnZMOWM1dHZpM2FQbWFpVFJRRDI2SCtRdXViMmNR?=
 =?utf-8?B?TjBOb01PNS9JcUM4UkwyUnpWOUdkMEZPRDlldzU1QjhzT0ltNXZqQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212c413e-f811-4abf-b02b-08df39aef6b7
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:53.7083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNLpV3UVbUlvVaHC0O2ulKgCRksGHNFt2Nt2iPf2agjn/sE2y4qR/33k2CBU8A4MZNoVHB2dgvNnJ0u8Ge4YdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9394

Make ufshcd_dwc_program_clk_div() and ufshcd_dwc_link_is_up() available to
DWC-based platform glue drivers. These helpers are needed by platform
drivers that must program the controller HCLK divider and verify link state
during their vendor-specific initialization flows.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 6 ++++--
 drivers/ufs/host/ufshcd-dwc.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 37876e863672..a8c3d9b47de8 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -39,10 +39,11 @@ EXPORT_SYMBOL(ufshcd_dwc_dme_set_attrs);
  * @divider_val: clock divider value to be programmed
  *
  */
-static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
 {
 	ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
 }
+EXPORT_SYMBOL(ufshcd_dwc_program_clk_div);
 
 /**
  * ufshcd_dwc_link_is_up() - check if link is up.
@@ -50,7 +51,7 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  *
  * Return: 0 on success, a negative errno value on failure.
  */
-static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
 	u32 dme_result = 0;
 	int ret;
@@ -66,6 +67,7 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 
 	return -ENOLINK;
 }
+EXPORT_SYMBOL(ufshcd_dwc_link_is_up);
 
 /**
  * ufshcd_dwc_connection_setup() - configure unipro attributes.
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index d8673cd54d4c..53b523ef59df 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -47,4 +47,6 @@ int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
 int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
 int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba);
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val);
 #endif /* End of Header */
-- 
2.43.0

