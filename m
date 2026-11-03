Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712780;
	b=ZFg6FKIHiFdlAHAoGC7dc8kVSMp5iO3dJY+aoF1b8Qz2Kj/v9lcMHVi3xnKoEehVAOSR
	 WIIMZ3NpSEfCLxdSLEAfdnP1e/FPYyyMzqKQOs36JShxbB4c0al9nGUGh2gLuIrIUnIKw
	 LXxWdeCkbGER+duNj2RBTsyLCPFqiWtSjIsWCi1GoG9eov4JY6GmsVkYq3U1Wh/rGwdHS
	 lOP97rkdbFa2ig1ZWpJQzHcIhMtlbHqV6yHDZatIpp97w+RVUJN+pWB/f9QTpSzTu/3L5
	 VDywy22KEU2Fb+TtXAWMYK2P4Ba9djn2NzGQAmhKGuou1UOh8KOaw03Y0PlaNcJ9PZA==
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
	bh=YcLbJGzAHDJUM+heR517eSuBTzXT3oPQ/X0W1jsRSyw=;
	b=NmFdbfVg+tdw9mMkZkHE/ZCuGJnWAHxR2dFOmZLxHoqjk4oNBvtJG2PNkOjwxtY+N46N
	 NcJFgE9Kk0m4AyeiwLqq5+Jyw37CPS8jxbsfU+CbfF2TaMHFwkCzqWMDuVjZ73Ge7wUzu
	 pg8qzM6EdRVzjMn2D3TgQxRhWcrRIgOcNq5HWDu6J569VqWCrRxUXH7e23yJFTOWwBzqT
	 MlswWca1BNGSKN4dNDAHtjvg4GUnSexdZ626xMhXMxBTdEKgk8ZuYfhRdaH6mwXB7Elsk
	 A92vKQRr8iqENHfp8/6pnnL6xjcRxvywPkKfNmNpcTvn8Aa/aYz+/mBddthA0w7hOuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Cw+YTSCg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.64
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013064.outbound.protection.outlook.com [52.101.72.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3275A606D80D;
	Tue,  3 Nov 2026 13:32:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3275A606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Cw+YTSCg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vaQB9TAZ/RT8oERKHu+CxWSZxyRjBcpsHgHGukPoXHpsUW//8O0sJfNFXDRdFcDUYrveyGHRWlk1XiEWJtFomdhqRAQDxRfVvJlQxqsoO7jSRZcKq8TR6BF8r//RaF5Ip8waO/zbR65KVwt/GEbTaY/Yqf4C3EkyodmnyPyLzrL+tqmGGGouDCH0XDt9yFjWa3sFdxLZA12M2I1iFIqPoqhx8ny2bvtdj/J6lgGNW65NahEDlv/qcULg1V0o1jLsnu+ECMR6zGUjL4zArmQbml5NrdEVK9C9Gm5fUxrGJzP8kxpc5aTC/b+nLFz666f7p5H9GjHrVglWFurNaEZyBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YcLbJGzAHDJUM+heR517eSuBTzXT3oPQ/X0W1jsRSyw=;
 b=xxgKr4dBSVRDkb/9SsxWbvSTVtln8WHvSM5zvw8GgaAtzBcoBTKBarJipbV00bjx+YsGkkVvWJpEGQBKc5ANW4OH1tiYOordT0K8qLzhpIDrYTnbS9V7ETZXPsSl6pXmKvJpmRVJdB01LpoV9ShJbZi0y9NA4E8ko8PnemAd+uQMY1YqxqrDijjMsBC0R8ik0pPpTsSBrsWSowgdBiDHIOmCuKuPKJQtQ9cHAFic3WKNEEwLf+LKA5U47enC4qagw2ssXqHOUoFRB58hChoRzwoMXLi567TypDMboX42KcOftteVZU6d350XudvTc0Prtkla/0Prm3LhSBP+mNdK1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcLbJGzAHDJUM+heR517eSuBTzXT3oPQ/X0W1jsRSyw=;
 b=Cw+YTSCgpqr0OD/+MoP0KLgiZrAip/DVzw1T48udphVj6lD3jtr14UoOWL34b/8kiWv7spyS8AICj6QdPEdHlyBYOl54WdmBPbSduI7ruxhDDLkyJE39rGMlshiwrVRjNXzjhX7BZdnAo0OF3G0gJiXT6tOmqqAQ4ENFqbPoDj7/rIBgtXDwb0IzFY6faoncidrX1N7Nrl3wpYpTx/ApWnsGTW4q5JcUpnMfog7I7RwzIoO/B72GaOJ2uL37p0Wzh2a4RtFPlZaRcCBTuBWoJj1RrgdSDxY19V5KbQ+5kPUkh452Sqq/1YpI37yA81k+mbdr4i/V0y7dfURkvYossg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by GVXPR04MB704257.eurprd04.prod.outlook.com
 (2603:10a6:150:39e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:32:55 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:55 +0000
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
Subject: [PATCH v10 08/11] dt-bindings: ufs: Add NXP S32N79 UFS host controller
Date: Tue,  3 Nov 2026 14:32:12 +0100
Message-ID: <20261103133215.1385823-9-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0532.eurprd06.prod.outlook.com
 (2603:10a6:20b:49d::31) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|GVXPR04MB704257:EE_
X-MS-Office365-Filtering-Correlation-Id: 477f5a64-23d1-4222-34b6-08df39aef7c9
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|376014|7416014|1800799024|23010399003|366016|3023799007|10067099003|22082099003|261102123227099003|18002099003|56012099006|11063799006|261022075727099003|921020|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261009223027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 kFxL3+U1vEq60JV6oEMeRu1Mo34rJQKYO78NsrDBUr8qxm2ynR8HzzgqiknM50WdhAZOiju1xkkIdYsen+E26aVkMs6C12Bc5fOG6KHOtuC3uU3Z2zVEjkLFqyMarDLFowY+C0BIWkhNVwvERmfizJRX/h3InVS2j8by0Cn2H2kO0dRzgzjmdVyWwB6hEbjdIfleAqrfIQkwVm6V3bKCcYEKtU0d/Cf2kns2CVQ8vSG22FhhQyLzcrusYHz1p82dcsDiI7MsOekE3sAlkyuvkH9Rccbro5d73zCh9fL/L9MsSjzVwBDMJcbGEJQIiRDzd6BrSfLr4aISBiwr7+1BGI5w2UEliMawJAhb9aal3jS9VixaG0zOxI4mGWngUjksRIMJFoCa7ZPdwoloRipiJsHDgL6tFkXfAgblvwZa/wFmcEsBTm/I6tV+G7I76gaWiQMeb8alSspeYoa7po2cB3Sk/5Aiau0rchW8+braX+OvH6Tp+yGe5hlwcm4j+cwj5Km9uzTdBSj2Q08vMahcBRyPvIMcYVEbfugpi7YOkAexRTCIfCoCq6qsX+zMfp6M3NK4bROgUhkDBMztQpR6gZeE3hUEQBFIETKhmz8v5b1IF+XLzLF0ZEdT/O21ICp+PLvqt5eChybZ1xSUnxf/UPr9WTnUe8jt/gtbOMDWYtk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(7416014)(1800799024)(23010399003)(366016)(3023799007)(10067099003)(22082099003)(261102123227099003)(18002099003)(56012099006)(11063799006)(261022075727099003)(921020)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261009223027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?alJLSlFzQjBZSEd1eGRiOWpLUytKczJjYUdjZW9GcUt0Y0VtWWJqYjAvdlpN?=
 =?utf-8?B?TCtuVFpMbTZVeXV0M3FPQVQyWVNMMWFvOEpLUGd0THdhamZkNU43TU1oUTRS?=
 =?utf-8?B?azVUYUtEb2M5eG5RL1lPRHV3N0J3TjBod0RJMktUYXdpOHFrME9wUk4rWEFE?=
 =?utf-8?B?RkUwNUdONlZFM1hQMC9NZ3pGT0xOTTIwRyszY0Z2dnUrZWoyMjFDdTJUTTc2?=
 =?utf-8?B?UzZTczFhNHg1QW0vcVdiOGlLK1RlaTVDVGtGWGtZVlhhVit1aHFvamxJMDFr?=
 =?utf-8?B?VnlGYXRGS0NvSklmeU4vdzBpbU1pZmVLcENTUnJuelY0K2NQN0hDMnVwU1dB?=
 =?utf-8?B?dllnYkVHS2ZaQUpwL1JuSGZNbVJ0YjZsbDVydkcxRzgxZEV6TVRGOWYvUlFP?=
 =?utf-8?B?cDRZTlBpOUxyTHczbVA1MjJERUh1QmJ5VERoMHF2MHp1WG5BWVV4aEVNNTB6?=
 =?utf-8?B?R3FCT0oxaFZCcUpWVGxpVmsrY2tGUDZkcmZXTFV1M3NhTWlmNGRudkhxZ203?=
 =?utf-8?B?ekI5Qmx6cW1VRmFlUjhKS0wwWW43YzRDc0VjZ0gwYXFYTUNjakpVaU1EMWhL?=
 =?utf-8?B?T0htUWE0c1V4Q2VwampSYkkrcWRyU0d2MW51bTcyRXh6WXVSNElKWkV3Znhm?=
 =?utf-8?B?Sm5EbEdtQnNIYjRLZEk5clBzT2R2RHpDenZkVExKZk1lSno1NjIzS3FSUGRk?=
 =?utf-8?B?Z1J2UTZFb2tJR2ZhREM0dXhZSUF1NkZCQmRyeTlvWDNVSkU4NHl4MWt1dk5P?=
 =?utf-8?B?MzVRYk5PbmdoSWdaREhJdzRxVEFvK1paZVk1MFhrclY3bC95bmNQZHlxQStP?=
 =?utf-8?B?M2VRMlJjQlVqWkd6QUJUMHFid3VXbE9JeE0wUm5SSzBPbDlTZGxlSjJOUmsz?=
 =?utf-8?B?OFBMazk1RE5PMklNejFrbEJGMDgrMXN0bkRwOVByeG0ydWxIb0JNeWdBZ29h?=
 =?utf-8?B?anNHa3A0cTQraTM3bjYvK3dZTU5zd2tobXhaUFlnalNQb1hLUC9NVW1RTWlu?=
 =?utf-8?B?NzZaY3dVZGp4b3FLaHNFL0FvVUMvSTdWUDY1d245SDllNDNUVWQwQTFLUzhD?=
 =?utf-8?B?eUdVVG5JdDh5N0VpSWtSMjVrQ3J6cjRoMEpFNnZxQlR4Tm41bGtsQXZmcjZP?=
 =?utf-8?B?WHhZYkV6RzhISWRya2hNeGpuQWFnQSt0bGUxU3RTNDNBUXJzL3d5NFhMWS83?=
 =?utf-8?B?YzJrSU5lRThyY1FlVWEzWmxBS20wQUE1eEdqSC9rSllIZUF1RnowYWJnNWZ1?=
 =?utf-8?B?RnQ5NnRsODFrRUJjZDFlcGxST0ljcVVFcnNHWDM4aXdCQmdvWWV0SmEwMUp6?=
 =?utf-8?B?dS95Z05IR3p5RFBBdm1CTFFPWE5vdHZIeEtBb1FFdUNxY2RWZXVLeUFMMlZo?=
 =?utf-8?B?MFBZdHdLSG9Sdm1vY0JCTnIyNVIyY3FrR25FMFQvSUpNMHRlSFJRNXdicFVV?=
 =?utf-8?B?c0NpN2I3UjZuU0pCQUZZNHc0aTdaajZHSkFFUFNQd0pQVXIvVmlIVUIvbitJ?=
 =?utf-8?B?UG9HUXQ1c1ZNK3pzOGM5U2EwMkYxeitFQkF4MWY5TGJrbW1zMWN5YVhHMlBZ?=
 =?utf-8?B?K1ZHeTFRbXcwOVU2RmllTzRReFZ2M1JEVGRaSkIxU0w3OWpKak1mRmxPUU4z?=
 =?utf-8?B?VS9NWWY0S1pWbm9mZmNJQmtYeHh1TWxLemZjcEwxeEJOQ2k0REFCdjJZUkVh?=
 =?utf-8?B?TUpPTDNlaGR4c0VzTVZGY3QzTWVaSGdWZ3pHWDZiSmQ0MGs2L1FsSTRqc1d2?=
 =?utf-8?B?N0l3NUZsNmo1eW41WnB0OG5IMEJJbmxlTmFVbytWaUUrNExrRkhmaDFOUnIv?=
 =?utf-8?B?eWt3eXBtZ2tVdXFUVUYxZHdkaVZFYUFwYWdJQUNINmFnN1l3Vk54K1I0SFhv?=
 =?utf-8?B?d2t2bUdsY2JqbytDYmRjWWdXekVKWVRPMjdqbStiQ1Ntc2hiUjFtbFpnanVZ?=
 =?utf-8?B?dmVhVTl2VG9VTmo2OGJET29nL2lwYVhjdjEwMVM1OS9YazZjcmxmMWx5SEgy?=
 =?utf-8?B?SkVRdlZXNFQrY2h2aC9WOExFL3lsTzBnaXVuN1RRc2VybGVUNVRubCtNZ1lS?=
 =?utf-8?B?TktDUUpwUDYwcllUQVp0b3FOT2tNSEFuSmI5dlNBQ3lZTFIzZUlvekhhS2ky?=
 =?utf-8?B?aTQxUWdWZ3VzNGFCUUhhTGlVOWprVDEvQjE4STEyR3dZaGRBeHVhZU84dnZY?=
 =?utf-8?B?VWhxcGVjMG9zMXl2cnlUV21idGhUVkpnZTlndHJDZ2l1a3pjelY2YnE1bTJk?=
 =?utf-8?B?UUhjU1pFRXVyUDJyRVFlVnprSjZHL3h3Y0RGQ3ZkMHVabWJxZTdpL1J1UGJC?=
 =?utf-8?B?NnAxNFMwRU0xQXE3NWpKSFhDQUQ0aFo2dkVaRXZhdUFkMDZPR1Npdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 477f5a64-23d1-4222-34b6-08df39aef7c9
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:55.4974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7MzKrbM9mU3GtxlaUK4eeYRSSFon657zA3mMz0k3vCCPEmhB1gnR9OFEAnFBurt0EPE49dMCXy9bRlRl/TdVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB704257

Document the UFS host controller on the NXP S32N79 SoC.

The S32N79 M-PHY has two data lanes per direction and the driver programs
both of them, so restrict lanes-per-direction to 2.

The UFS core manages only the clocks added by the platform glue. Since
freq-table-hz is deprecated, the binding requires operating-points-v2 and
clock-names. As S32N79 does not scale the UFS clock, the OPP table contains
a single 0 Hz entry, which keeps the provider-configured rate while
allowing the clock to be enabled and gated.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
new file mode 100644
index 000000000000..541b59b8c89a
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
@@ -0,0 +1,68 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/nxp,s32n79-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP S32N79 Universal Flash Storage (UFS) Controller
+
+maintainers:
+  - Larisa Grigore <larisa.grigore@oss.nxp.com>
+
+properties:
+  compatible:
+    const: nxp,s32n79-ufshc
+
+  reg:
+    items:
+      - description: UFS Host Controller registers
+      - description: System Control Module registers
+
+  reg-names:
+    items:
+      - const: ufshc
+      - const: scm
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: core
+
+  lanes-per-direction:
+    const: 2
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - clock-names
+  - operating-points-v2
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufshc@4ac80000 {
+        compatible = "nxp,s32n79-ufshc";
+        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+        reg-names = "ufshc", "scm";
+        interrupt-parent = <&irqsteer_coss>;
+        interrupts = <211>;
+        clocks = <&clks 0x92>;
+        clock-names = "core";
+        operating-points-v2 = <&ufs_opp_table>;
+
+        ufs_opp_table: opp-table {
+            compatible = "operating-points-v2";
+
+            opp-0 {
+                opp-hz = /bits/ 64 <0>;
+            };
+        };
+    };
-- 
2.43.0

