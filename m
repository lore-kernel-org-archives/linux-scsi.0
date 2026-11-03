Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712780;
	b=QOIP19sRcDjGAu1jqMZryso3RFHQZIXhYPdzjG4P3YLNRCHyt0ojFtoj6R5DLPP5NRZX
	 xQwhcFrMD5g+NO/CEBTJl898M/t9Rnfq8NgrpNTsONsB1j8W9GOPC/RD+Rdna2CLic50e
	 8U0ay/MxkckSCZKdQpQLV40tCMSNi1m+YN3beeIrGX4k7wfZfWgRw4HXEutO+6ondH23B
	 nh0FrRn6YXRcMBCGLSzXgidrRb1zn9RQ1sv72+rahFDL1fY0ybakNfuJ7yo5vZKXpXkjw
	 zeRd3dDJudIEosQRiiGvWwYWfqVEonWdNsCs1YKrhy4+fq1Zw64U8CR5z2d9Wr3s3HQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712780;
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
	bh=NLHkbrhBfty+IU4nHwWUGRmQUkXkQ6W8pGl4hrwXork=;
	b=2N8UKpSewAxXbaen9Mv1Uo4Cq74rKk2HRt4KhM/IKFSoLz1DzD4fEOyhfxN8X02zzwoP
	 yP0CKaSvHEtsx+nMLNfmY3XCm0u8rwBz2f8KCYoOFO3E1xs4dhabgJjYmNuLaJpWqrBRM
	 BWEdCNKGwtBARlpM7iLn9NYRs11w0gb6T0fIm9WwZo9Q5X+NK3+ud1FFWLI3ZupG1QTFJ
	 hfkFm4G7h89UrgEgFP/F7VH+9Zq3E0vAHbZPpSaWAcXKM8dqAzRpzoUCPuakRnUbB/FUZ
	 JaOJoQSZmos4Bi99yDcR1zxDOwkw12u6RSF5+DB399/ZWqnwpOIu6XAZAi7hEnzg1Fg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=YfUSV6hS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.30
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011030.outbound.protection.outlook.com [52.101.70.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DC0606D82A;
	Tue,  3 Nov 2026 13:32:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74DC0606D82A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=YfUSV6hS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A5qXLiwtpQ75Ej8NBBm3BoFXAd9BuWqKBD43ZUYTMogodMVq7oDrPM+QxwVMPLeQkS0bPj0hqfNhcVIcgww3PBx/N1Us/xvISiNy7jAc8dN/oYUEGTp11gyBJ4a3gU8iJX0bX4mDgyQGwFIIud7uHmaZSPHKklnG31zNiP24B3/0ykcw7rE4p+EebygSdLaLFesJSSQdmS8R+WQy2fw/19QXBYOwKkWPzeuwz8YdvxFhXqS6w+xhrD1kcxegV8BlpTJc4tZxU5cQ7ikZAw7+eVetKFp9Tf3dmTH4TWN2AKOs9qoeH6tGqrA0bTJxaXAuQ/JhyRpn6FrcYQBt6hzpHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLHkbrhBfty+IU4nHwWUGRmQUkXkQ6W8pGl4hrwXork=;
 b=juMBqj7Xr0xPg6ciQI21ts+EyMg/xzfNEBMBsMJp1e4z3TWYsyIANBKsUpRkfvTOpGPBE5huO34PmBb937pxg6TGgUoAL0kGs2PmoI64YZ3nVKAcU2zrYq2sO6QvcoUSmbaQjL73rON4fHLkQ0vWAWCKyA9re6mHCv05S85YrNr0DZ1gY+a2FofCruAKlRhQoIFZZLXtpr9+RtDTADarVLFvleCM5M0vX2fzyhNoYMdAHJECfU/BeO3B7KhipF/Axcz4bzeUWMby3HE0HCiWEYzON1b5qFr8s7v1tOIXNNyIBEfjUfDDmUS3McDDo2q/symfJ13Ny3ha4H3Pjs6uwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLHkbrhBfty+IU4nHwWUGRmQUkXkQ6W8pGl4hrwXork=;
 b=YfUSV6hSbEzCYAB5OmqewI/XKJnzrutoK94VIEa+ROCOOpMIamrERov68VRjYAsOeqTn5xTj1uTpYITotKjcGmhncMJjncOz3VUjnXAj1HsPk5oHtlt68nSoQJStuVB4dcFFtfpxU6RtdfTOL8lqidp3Nq5xXGEIVF0iYcusaPJA57NeXOX22CQwDKV5URF3a4s6+c24Et0pSN3iCOe4ZtrtZaYZOqldOmOhqOg2MzwRv+SY+AFCqunrf/L4bH5a0oULpuYy0rq3MxYONjt/UzSeOB95bpB+etqfS4zhYtUo+bJI5ucsJaPI+5TQp3v4wybRg9+Lr5qKoUJ1+pG7eQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DU0PR04MB9394.eurprd04.prod.outlook.com
 (2603:10a6:10:359::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:32:46 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:46 +0000
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
Subject: [PATCH v10 03/11] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Tue,  3 Nov 2026 14:32:07 +0100
Message-ID: <20261103133215.1385823-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::20) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: aeba1621-e203-4755-17a9-08df39aef21b
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|7416014|23010399003|1800799024|376014|6133799003|10067099003|18002099003|22082099003|261102123227099003|56012099006|11063799006|921020|261009223027099003|261022075727099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
 SX2M0z+yWVAx8dqXHcSu9dBUIP3semgV941HAh5b6UKLXYjxupC4VhWKQ2mYOu6kZzilGWxepvQDSaLwkZUzImFjPdbK2d/0Z2Lhev04vk2fUVrJEm54+7uy7tEm1zEXV0RAxuEXGnvC3Y7Lcfs0rIkUnOAmuD+rt9VewUzGRudRvyoEUcKYXlI/kXLeHMJsOF/DswDzWMmg9hiLzxoGcMpMS1qAs+RRAowKDxqf5ayskQKsssmy15MbTdz5MaJ6s6jeX3sIXYsvmz6t7pENvSD236PC/Jd/rreZ+J232LR5AZrU2mXI9hTgblA8P0uCIrLGzzE+P+kMSpmeg82VV8Awhdz6j5iFHFsFg5vlKGUjCq+W8Ndgvnw+9ZKuwTVh+sbzP30VuIBnfiHE4uF87JoeCSBG8SBd0LDLr0vkVNwWmPnvhOv+4azT/6m3Jda5PYe1KnV8ewTmllofOm/vyQzLOmURbvGlQCHELt4qUNZ6r5Nom0cWyhIUOOcwPdmF7wOFZUUbKIvzYo3Qy1ONyXyfNb04EUV/KOLz2Ixj/NzotDPvec78juwLk1wyBHzq1goUk7+ouWVTjRFS57X8YATC6tTYUkD/RIAcwovX1jOMZqO/Ik/Hk81oku55vTnOQWGAeytyyHXV0NLCmL4DfOGIqN/VgwITW+n2eHW4t8P6S6RD0LLyhR1DBL7kM4o4O41fAQUvCIIWEs7NGFE6qw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(7416014)(23010399003)(1800799024)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(261102123227099003)(56012099006)(11063799006)(921020)(261009223027099003)(261022075727099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NXBRaEZwcndqR0t2cTJHU0trK2RYbm5aOFpya3ROcnhmVzZ3WFFRSHhtTUZJ?=
 =?utf-8?B?L2lqNm1tcWVNQy9JdG1ZcVdXbklpNWFxNFM1OUtoS2RiWFJHNS9pYTdwUmVm?=
 =?utf-8?B?akMyNlJhNjlUVG9rTlQrc3ZmbS9XZS94blVlcVRFL2Z4Q0dFcmZNV0pBSnV6?=
 =?utf-8?B?TlpvdW44eVRkMmNkemNCcHVScTd1L3p4MGdMWFFOblNvL1NyNnFKTmo2VXd4?=
 =?utf-8?B?ckVwc2R2OUtlVVIrSXdYaGoyUG15YUdMS3kxcVl1TU5yNFFtbUo4c2V6N1Bs?=
 =?utf-8?B?czBLZlRzUUlSNjlXN2lLUCt0TEtxSytlbm5xbFJ2ZkxQakptTWRLWm1CeHB4?=
 =?utf-8?B?c3JsUTNMTEwrOG52Ym10N3gzb0tLa0QzS2VjaXRLMWVGUktMa29lWjZBeVJT?=
 =?utf-8?B?RUtGanhKOGc0cnVlVWZwNWFMeGZicFNiZ2xSTnJBNndEL0M0U1IrNm16TWRD?=
 =?utf-8?B?ZU43NWQ0MUk1UG9tdTJ2RVhqUnUzdWtOMHhJMFRpVFBGd2ZMOFVFd3JEaVNo?=
 =?utf-8?B?TG9KU2x6WlRKMlplT2Q3dEg2V3BKQVcyOWlCK1EyWUJLQVpEd0kvNFZWSFlr?=
 =?utf-8?B?VVZiVk9rSlZnejgxNHdOMzVxZTROQ1daamUwRGMvQWJOWmJPNjVmT2l6NE5M?=
 =?utf-8?B?cG1mRXhnUTRXQ3hoZWt3RlMzdml1WE50bWs1MU50ek1ycDJuZTkxaDlVbmY4?=
 =?utf-8?B?enlIMUJjVjNzR1RWb0ZNeUhlQldacEozTWhTbEY1Tm0vNXUzZWJJa0lhUmNw?=
 =?utf-8?B?dWk4ZXRGdmFLaWpvUUVmeFZMKzhyekg1VWg4bVlxZUVTQk8xRkxkTkVEZXhn?=
 =?utf-8?B?TTNMRGhheDkyUmVzZ3MzYnJlbHlnV1paV0tTeEdUZ3J3dFdjeHhJMEJqcG5B?=
 =?utf-8?B?cFhLaTNGTzVXNU1mdXpHMkRPUkw4aStSRmZQUHZ5WmorUDFGcGlQS0ppVEdB?=
 =?utf-8?B?WUZzRFdLR3d2VnBMSXlnMnBKN1FibXMwWHRURWVLRzFabmNZMk9VTHc2Q1NN?=
 =?utf-8?B?ME9Yb2s5SGNwOVJ1VmJRS2lJeE41dFJvMVNGQmFZN2hPRkJjZ3NlMjU3aDFK?=
 =?utf-8?B?b3JadCs3UVM5UEU5M2xnT0JUbUp4cWxhajlGUVVpdUUxMzRJbmZva0lVb2w1?=
 =?utf-8?B?c3NwZjc3cUlaZU1rUHBnRTRNVm03ZDVjQjRUM2Z2R0pRUVdXbWZNRVRMamJw?=
 =?utf-8?B?YTlsbUZ5YXQyZVNkOUxoR3d2OEYycHJVUXpuUERveU93UVNvZE50d2ZnZ0U1?=
 =?utf-8?B?K1Zzcmp5Rk5XVWkxRWRlMkpaeFNUQmQxKzJHaTBYSjNEbmtMeUM5blZpU2dp?=
 =?utf-8?B?SW9SZmZLM05tN0pJczc1NldvbzJSL1NJTXdTYWpDR05XL0xadll6R084SFBw?=
 =?utf-8?B?Z0RMa2ZUTzJ5VWhWYXNKYWF1d256VUN5eVJyTkxXcjgwQUtSdWVnSzBXWHo3?=
 =?utf-8?B?UFFteG9kY0RkdjFCZ3YwRmRybEkySDlseTIxYWZKckRLQlJJZGlYMDYwYk8w?=
 =?utf-8?B?NkdLVXhKNEl2Mi9RcFhPQnNINnlwZlRKd051aWV6YWE4VjhtMHhaMkdQcnBk?=
 =?utf-8?B?ZGI5SG5OSHdRbmdHWWh4Q3BpbHU3WDZNRmc3bTU4Z2VybHNXSnYycVora3BZ?=
 =?utf-8?B?bmJPSG5yY2d4cTBrYXRJbzNuYjJoT1NYZFBhWVArSnlLRkJFNVFNaTNzdU1T?=
 =?utf-8?B?U2ZMbm9iOXd1cWwyU1Y2VmRzS3VOeEZGUHhzT1ZrN0lTZXk3SW9iNkI1WHBW?=
 =?utf-8?B?ZDBlckVlQ3pTeVJhb3lPajRWQm5PL2FIa2tScU5aU1JBUGNDeXM3NVZBRllV?=
 =?utf-8?B?c0UrL001c0JxQ2dxdkpGWlVUQk9OeGNmd2puOXJ5TzdDREFvQ3Jid0VHaGdT?=
 =?utf-8?B?TGpuSTE3ZS9GVzBJTlVnalB0a2VlNzh2R29IaVZwR1R1c3pOWTVBdTdOdnQv?=
 =?utf-8?B?bGk4QzNWZWliUitGZWt3aXAwMWd1TnIyQS9pRVpzTXlvc3EveUV1NGN4c1Vj?=
 =?utf-8?B?U2gxS0o0UFRTWWRvUEZOeXk3ajJiSDNwdXc2aFRlb3Jjc1IyZHovOGwzM2RH?=
 =?utf-8?B?SUlyZmt2TmU3L1NjejdrckQ2ZSszSUJRZVA0bk1BZnFRVVppVkcvZHBFQXhK?=
 =?utf-8?B?UTZxODVKUEJwWjZ6R2kxUTFzODExMFkwNkorZDY3aXprQ09VeXBMN090aEZa?=
 =?utf-8?B?M2ZqT1RGMW10WTlSY0xBQmkwWVB4aUx4bEhOQm1xRThxZGNwZ0VjOE1jMm5T?=
 =?utf-8?B?Qi8yUVZjWklIVU96cE5XRjZpS3BWR2ZaZVRsamVEYnllVFp2TDlHMjhYV1VG?=
 =?utf-8?B?S2FvYjNZRzlhaktrdW4wMHlPS2gzZEdybC9FMG1DMlNyQjdXcElmQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeba1621-e203-4755-17a9-08df39aef21b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:45.9903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2HMSolSJuN+gOGEAik7NvBuZaa/zbJcvyzWfmpI50uIweoIvjCVB/HSAlpKbgRQZXEArPHTwyHYiYxe6sjqx/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9394

Move the Tx/Rx FSM state definitions from ufshcd-dwc.h to
include/ufs/unipro.h.

These state values are UniPro/M-PHY related and are not specific to
the DesignWare UFS host controller implementation, so unipro.h is a
more appropriate location for sharing them.

As part of this move, drop the driver-private TX_FSM_HIBERN8 define in
ufs-hisi and ufs-qcom and repoint their Hibern8 checks at the shared
UFS_TX_STATE_HIBERN8 enum constant. This is a no-op change.

Since the definitions become visible to every user of the shared
header, prefix the enum constants with UFS_ (e.g. RX_STATE_HIBERN8
becomes UFS_RX_STATE_HIBERN8) to avoid polluting the global namespace,
and update the existing AMD Versal2 users accordingly.

This also prepares for using these definitions in a subsequent commit.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c |  8 ++++----
 drivers/ufs/host/ufs-hisi.c        |  8 ++++----
 drivers/ufs/host/ufs-hisi.h        |  1 -
 drivers/ufs/host/ufs-qcom.c        |  4 ++--
 drivers/ufs/host/ufs-qcom.h        |  1 -
 drivers/ufs/host/ufshcd-dwc.h      | 19 -------------------
 include/ufs/unipro.h               | 20 ++++++++++++++++++++
 7 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index dff0c2c95486..7c0f102ffe7b 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -118,8 +118,8 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 			if (ret)
 				return ret;
 
-			if (reg == TX_STATE_HIBERN8 || reg == TX_STATE_SLEEP ||
-			    reg == TX_STATE_LSBURST)
+			if (reg == UFS_TX_STATE_HIBERN8 || reg == UFS_TX_STATE_SLEEP ||
+			    reg == UFS_TX_STATE_LSBURST)
 				break;
 
 			time_left--;
@@ -138,8 +138,8 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 			if (ret)
 				return ret;
 
-			if (reg == RX_STATE_HIBERN8 || reg == RX_STATE_SLEEP ||
-			    reg == RX_STATE_LSBURST)
+			if (reg == UFS_RX_STATE_HIBERN8 || reg == UFS_RX_STATE_SLEEP ||
+			    reg == UFS_RX_STATE_LSBURST)
 				break;
 
 			time_left--;
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 993e20ac211d..aaf66bfc3e70 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -34,8 +34,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
 		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
-			tx_fsm_val_1 == TX_FSM_HIBERN8))
+		if (err || (tx_fsm_val_0 == UFS_TX_STATE_HIBERN8 &&
+			tx_fsm_val_1 == UFS_TX_STATE_HIBERN8))
 			break;
 
 		/* sleep for max. 200us */
@@ -56,8 +56,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
 			__func__, err);
-	} else if (tx_fsm_val_0 != TX_FSM_HIBERN8 ||
-			 tx_fsm_val_1 != TX_FSM_HIBERN8) {
+	} else if (tx_fsm_val_0 != UFS_TX_STATE_HIBERN8 ||
+			 tx_fsm_val_1 != UFS_TX_STATE_HIBERN8) {
 		err = -1;
 		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
 			__func__, tx_fsm_val_0, tx_fsm_val_1);
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 5a90c0f4e90c..6af6a268458d 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -43,7 +43,6 @@
  * M-TX Configuration Attributes for Hixxxx
  */
 #define MPHY_TX_FSM_STATE	0x41
-#define TX_FSM_HIBERN8	0x1
 
 /*
  * Hixxxx UFS HC specific Registers
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 27c87e62f8e9..8a2e0c63fb03 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -424,7 +424,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
-		if (err || tx_fsm_val == TX_FSM_HIBERN8)
+		if (err || tx_fsm_val == UFS_TX_STATE_HIBERN8)
 			break;
 
 		/* sleep for max. 200us */
@@ -444,7 +444,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
 				__func__, err);
-	} else if (tx_fsm_val != TX_FSM_HIBERN8) {
+	} else if (tx_fsm_val != UFS_TX_STATE_HIBERN8) {
 		err = tx_fsm_val;
 		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
 				__func__, err);
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 944b2e532a09..1bda960c1d87 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -11,7 +11,6 @@
 #include <ufs/ufshcd.h>
 
 #define MPHY_TX_FSM_STATE       0x41
-#define TX_FSM_HIBERN8          0x1
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index c618bb914904..a5e40e7604a1 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -39,25 +39,6 @@
 #define RX_AFE_CTLE_IDAC(n)	(0x4001 + ((n) * 0x100))
 #define FW_CALIB_CCFG(n)	(0x404D + ((n) * 0x100))
 
-/* Tx/Rx FSM state */
-enum rx_fsm_state {
-	RX_STATE_DISABLED = 0,
-	RX_STATE_HIBERN8 = 1,
-	RX_STATE_SLEEP = 2,
-	RX_STATE_STALL = 3,
-	RX_STATE_LSBURST = 4,
-	RX_STATE_HSBURST = 5,
-};
-
-enum tx_fsm_state {
-	TX_STATE_DISABLED = 0,
-	TX_STATE_HIBERN8 = 1,
-	TX_STATE_SLEEP = 2,
-	TX_STATE_STALL = 3,
-	TX_STATE_LSBURST = 4,
-	TX_STATE_HSBURST = 5,
-};
-
 struct ufshcd_dme_attr_val {
 	u32 attr_sel;
 	u32 mib_val;
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 9c168703b104..16b2051f7241 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -466,4 +466,24 @@ enum {
 	CPORT_CONNECTED,
 };
 
+/* RX_FSM_State encoding, MIPI M-PHY v6.0 Table 50 (M-RX Status Attributes) */
+enum ufs_rx_fsm_state {
+	UFS_RX_STATE_DISABLED = 0,
+	UFS_RX_STATE_HIBERN8 = 1,
+	UFS_RX_STATE_SLEEP = 2,
+	UFS_RX_STATE_STALL = 3,
+	UFS_RX_STATE_LSBURST = 4,
+	UFS_RX_STATE_HSBURST = 5,
+};
+
+/* TX_FSM_State encoding, MIPI M-PHY v6.0 Table 47 (M-TX Status Attributes) */
+enum ufs_tx_fsm_state {
+	UFS_TX_STATE_DISABLED = 0,
+	UFS_TX_STATE_HIBERN8 = 1,
+	UFS_TX_STATE_SLEEP = 2,
+	UFS_TX_STATE_STALL = 3,
+	UFS_TX_STATE_LSBURST = 4,
+	UFS_TX_STATE_HSBURST = 5,
+};
+
 #endif /* _UNIPRO_H_ */
-- 
2.43.0

