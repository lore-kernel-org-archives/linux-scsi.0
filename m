Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844753;
	b=oJs+QALRf5XBJu3Y55I1WTf+b6WIc73FohgMZWtynnPp/uawK9U64S+y4b6J0+FjiOnW
	 Oo4b+do0M0SlkpbBROTN/bzdp0Nz2MfEXWFNTiGmNAaiTIUMFK+R4VVVfmnlj8JBNzm3F
	 tkbqU73U+5hXAHN05eDiuFsvkQI8CclHojYSimDsRCyCaW71Z/XsA51oujWbDAlGUcYgz
	 fbSm7hke8moj2O99d3IZqfDlrGK4AwsaNCppghH5FItWLaj+DpySPFGcFF3HgPf37gcPk
	 LElk0Xx/yCvpB7iTrqVQyjVIJY8+viJ9pWK4J9G6BotG+QVp6ASu2y6h2JUZQLtWIIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844753;
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
	bh=n808LUO7hZc3iBFM9GehHYcjkZE1kYzlCA18MxY8334=;
	b=TkeiA6VZsIosasRnHXr83JeSz3z5NhszUMRxpf5b6uVjws7muJ07/mVcv69/ZC/DVFLH
	 L0l33ebUP+sawX+0CtgnhDFq/GYgXpdAWRklPIEs5Bxevd06TPpX0dB1u020KPCkDg3O4
	 5H2EcyLCnEtbrIA/erwveC6TOjb0hzDQdoTYB9g/MYR76LeIOOhRo2570nSKo6MwXrp4U
	 LuSDc9wxTboC0hbJ2FKUb1Vg+pui82rWZQCpU0nDN4mO9o7Yl6LX2r2KWNdmLgtvkV4Mp
	 mjCsYJH/kTXmZ1/BUJ4nh5P/rkAc35JEPv/lNvkbvU2wwSQClV1g30NHi3QqsNm63sQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Mxa2vBQy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.60
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012060.outbound.protection.outlook.com [52.101.66.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544BF606A31E;
	Sat, 24 Oct 2026 12:25:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 544BF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Mxa2vBQy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EJ9mcnuLCMXNYEAy0ljU5XpI0HD+VfGmBOWt4nMKvQMppNaNFUwsN618CAVynZ+zRtE8xrks5oM41pAb9hPhYGUmSBmPRahfmCZ3J33jOusebMMMrEyKgcVcp9z/rohfJxf58+D3QkH7rCO7dVnphYBWRnyafg9T18b/6qR0SkjbQJn7TQftiFDp+VAhaQB2kEQSLH7F/ryYXhMluwINyT/wZzcw59KnIA7eklAz7HgcsJAoUxCbAFyWoLhhhElmSFNqf8GrTLeb4mAzRosVVBNE0/3/vpNIEsNdmxmpcCp0xGsoCB/GTX+ujqm+nLARxh2SO1ompAs8WV5QLO2Ukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n808LUO7hZc3iBFM9GehHYcjkZE1kYzlCA18MxY8334=;
 b=ruOYJgo8svy9xMVpxHTxFEFj/rfGqYkYMSDfP1Y1x7nZK0xVtDaLpFN4o/CLSTGiB98t7FJ0iNZlQ1G0/SWiqGC808OynNmQ82gxjDNboJDM2Yu1XsaU9YVL7fw8JC+5/Ers6hfenMfq2VonYYn9AAfXNENGD9m+5bM04vMaTsXiGXDYQllpPgZwasb2OpUvihfWKd2vcVsx/m9Vfzr0UwyUR23ZsIrQ6jnriuYqoAeRTD09i5u3y4PRB4qvL9CpKgOHkHybGUrv7nAEtOXoEOBZMCJS7LPkB9eRFCHQIU69bWBcSWNRB8H3WT4/tWcFslxu29q0fVoZTeC8fiqlug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n808LUO7hZc3iBFM9GehHYcjkZE1kYzlCA18MxY8334=;
 b=Mxa2vBQyHUkq7DAa3gthG5Oo1gLNOiMv+kwIgq/8ZXI68/xZVIqir0eEd03F3DQjA3X/I2xK1Jh/8762anKa7G47Wa9nySYanbJKZ4MIoyFStZga8MJcHs2gYHxiyhmJ5ES2hHuIR5CerCisCHLdFGaeA+ChF6A6bNxgsgZvT9W1rFR1TJGsMo1B5UaHQq6TFn9eRzBKtbt+WWsx4bok5e72X1/fT/fe4tF+7VyHUp3O6luaE43EJSZtDIGPwfkuIvJLY2nQ2KTA1K9gioSxwbyZ1iQ9PttCJdqxJiJwA9S/LUGeOogSf3fQ7qf3T5oyi8/9ml9chMPUTiJ4uoxFww==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA1PR04MB10294.eurprd04.prod.outlook.com
 (2603:10a6:102:44d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Sat, 24 Oct
 2026 12:25:47 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:46 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Joao Pinto <Joao.Pinto@synopsys.com>,
	Hannes Reinicke <hare@suse.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 02/10] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Sat, 24 Oct 2026 14:25:25 +0200
Message-ID: <20261024122533.3609180-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0002.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::11) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA1PR04MB10294:EE_
X-MS-Office365-Filtering-Correlation-Id: df08dfa3-1b70-4958-d14f-08df31c9ee17
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|1800799024|376014|7416014|366016|261021121427099003|6133799003|18002099003|22082099003|261021123027099003|261009223027099003|921020|11063799006|10067099003|56012099006|261022075727099003;
X-Microsoft-Antispam-Message-Info:
 zB8nzSvlJD3x3aGzDBc3ySeKP2y8/sr0B1ja8RDZkPfx3UJFTDlII+7kQ+YL1zQYEKhTaXyfA+Qsj2ECFmv+MMGVNFVPSAN3X0PFB1LdE+lEhwvjmhTsenJBdLNpTaGwBTEijSxlTJU6KOL+FUvZwGINaw2WZv0vxsxbgsl+l6tQIiqd0aHv5/Qp6sQPhh7RMwR+jNlifDAX+UNTLiTqU2aAiLv1POY90T9yhXs+cntvb+cbtfvvkUTuUyRuHXpxR545ZNyrMVA1q35Ex3dzdCnLdAPuhMT9PS3Pqo9YQ3+rqM1Hc1+LQB+WdusGMB6B1KQqyAnBlWQGatHxsmNTGptxgS1JD3qzroVnqGD3sbbGA01rOj7uWXu/1KIqF5M2OIB7yJvUGRNOPCY5+fKGvSQGeoahxsgV4uegrtkxMvj0CDU0L0SJTmJlFkexfFpc4No4ZMrMI5C2PZHx/T0JZeVcGvR8sNeNtfPJ0UgAkDGo+1eAKxr4aVtZ6fbhuknoCoZ7C592zH1duj6Iv5T/wZbjJ7BHjWDwyHqvv5h4hq1IK8BrYVeHIlSP4mmnD5NNhXwP4b3jYL5i9QH7W0UhqhQVw5rZnGg7zRqh5ROSu0NMzyGxIJ+nveaIYPwUY3P9oifkLEy5QhVPNiFjgItiCBV7cYggwzXCTkCmnwBsMK42Q0JcJvYvqp4XGxelRNoQ4kaKY0Jj0tV6XiXzEpFhvQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(376014)(7416014)(366016)(261021121427099003)(6133799003)(18002099003)(22082099003)(261021123027099003)(261009223027099003)(921020)(11063799006)(10067099003)(56012099006)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TDJCay96WGFJZjFPNVVRdWRKTkloZTNCczFFWitwa0JnRzdyTUhqenF3bW1y?=
 =?utf-8?B?MEZlTWszOC9tYlZBaHFibFpwemFHc2F2azJhUjdoYW1tMGJDRlBqVjZvcEFZ?=
 =?utf-8?B?YnRZbkY1L0FRQlg4YlNIUUk3cXczL2pRODNBTHB3cFNrTFdBdFJlQWVHQ1JP?=
 =?utf-8?B?VjN0N0Z5cndPZEhIR2MwY0dET3Vxbk55RDNsdW1LNEc5ckdHei95Yi9tdHJz?=
 =?utf-8?B?NUx4cHZLZmlYV3BlbkNZaThac0psQjYwSmVWT1F1QXRXOWlRdXR6eTVQWVpS?=
 =?utf-8?B?T3l2QVBrWWVZOGlIU3JWMVdxc1hrdDlIOThOdGVsejRKQ3hmWGprZjZXa3NH?=
 =?utf-8?B?bzlDRmcyRW5xQ1FkMW1BTHkycldERnpHR0JBS3pLaUIyNERvVFVQU0JsZWpE?=
 =?utf-8?B?aFE0ZGVrSGZFOEx1TGE3VG1TQi9QL201eDIvR1pSN1o4dGN4TFAzTC9JM2Jp?=
 =?utf-8?B?Vm03QXU0RktMY0ZGQ3BFM1oyK1JQWTdTVDcwMC8xM284V2p1UnZXTlAwdDBn?=
 =?utf-8?B?L2pCZ21HZWxuTDBxL0pEKzkyaHQyUG1WN0p4a2ZnV0g0ZUowTC92TlZJZGFQ?=
 =?utf-8?B?Z3BBcnlNeGttOVg0d2h5eFhXWlBUS3U5dWhnblpUSVd0dnlwcFNYblB5elBQ?=
 =?utf-8?B?Y0FMTG5KcXdCUEs0L09iRjhydk1ZTnlaK3lkdFBoaFNBWVZ2SCs2TEN4cU9j?=
 =?utf-8?B?L3VEQy9YVWhDbllTNGJFSWlDUGUxalp4czk5UGQwemh1VXg2eGJKYUs1T1ZC?=
 =?utf-8?B?dXc1MCt3ODF6QktyZHRReU8wKzR0Z0lZYVJ5MGY3Nkh3aWR6SnBlU1ErM242?=
 =?utf-8?B?ZE5nRy8rZGlTcXpEN1hyVkpsSnFlNmFod2lSR053bXYzY2xteURxd0dyZjlG?=
 =?utf-8?B?RFlFbk1oMVpESGgxbUhsZDlPMmpmTFVHdHJHWkc4aUgvM0pWRjcvS1FJQ2lE?=
 =?utf-8?B?RTQrVy9xeDZYaGdFUHhSVG1TMTZEN3EvSThsRTJXNElKY2tEOHVjRmVZanFn?=
 =?utf-8?B?UWQyTEMxMzJzQ0V1Q3RCNXYwVmdXTTkzMllHcWl3VElCWVlIVjZuRjREa0Vk?=
 =?utf-8?B?dlpSaCtWOEovdUU5NXJxMERybXl4VjZqeTF3RjlnTFZzdnBxZU5UcThIdk5s?=
 =?utf-8?B?NElWZWNzQTNTa1BUb0dabndjK21aTE5tU09FNVpUd2NwOU1tK1VKU3B3TFdB?=
 =?utf-8?B?OWxkbTZRdUxwRzFUbmlHYW94UGo1M1g0NUgxM2puQ3pYSmlmR21SS2twcTBv?=
 =?utf-8?B?cWo3RVpXY0MzejdpdTgydTdqVnpreGFUMW1ya2JpSDZQeVYxZVlhbUdITGdG?=
 =?utf-8?B?Ty9EUGRaWFhqT0daZ1E1bkh2c3JrVStuN3RiNkFZa0dUYmt4MTFmeU8yTmgy?=
 =?utf-8?B?QTlJMzVGRVFDTW4rc285VXNCekM3Ynk1NFpQcHd4RHFKbURaa25qOStBbFo1?=
 =?utf-8?B?Y3RJcHZ2RDFDU0hBZFdnT3ptekozMVZqRVZYK2w3OWhoM2VzbGxRWnJ4dzRn?=
 =?utf-8?B?eS9JS2l5K09USGNmK0FoY2xFYkx2Mi9IcGo5Z0dLc1lvUHNEOVI3T3MyYlgv?=
 =?utf-8?B?MVBkNWhkSVVwOHF3dDU3SHVDWXNXbW42bVJnME5WRTZhdW5pRDNodFRzY25l?=
 =?utf-8?B?RWI3TDFob3NRb3FPcGUyWFhLek5vNXVqdVFPc2JLdFZEOVQwZnozR2d3djJ4?=
 =?utf-8?B?QUlJd3NvOUJqOUdwUkR2N0VyY2tKajJhUVNJS1NyVnE4aytzUlZ4Z1E5VWw2?=
 =?utf-8?B?cnQ1bis2aWdwRm5oVTFiNXUzUVM3emJDb3o1Q0NjM1NrcDNvazg4UnZGNVNo?=
 =?utf-8?B?SElIaEh4TkRWTjhOWlg3SThCRk9Oc1NDU1NTYnNBWmJYOW9tOHlqUFFUbjhM?=
 =?utf-8?B?MTQwS2lBejl1NlJNWlVoU2FJcVp1SlN6cUJsRVRtT082WWlvT3Nta0g4M25r?=
 =?utf-8?B?Y1U5V2lyVFRIT2JMLzNBNzQ1RWtFalI0eHA3cFdORlY5SThSQ1pZd0U3ZWpt?=
 =?utf-8?B?dXZkT1RrbHE3cHpaTVc2UGM1bm1sWEVSY0l4UkNXRzd1Rjl5aEtTR05scWN2?=
 =?utf-8?B?V01MVnhQcG5RWCtWSGxRdC9oNHg1UG41dDdXK2psQktIS1M0L0dSWkpjYWQ3?=
 =?utf-8?B?R3JNclN3OVI2ZGRxa2dTMGlhenFiM25PU1YzMi9ZRjhXWUtkbkpDUVZHb2Vl?=
 =?utf-8?B?TnVySXBvYnRVUHVSaUtPQy9MdE9CTGRYMGVNZ3VJT1RQTTdpSTc3Z3EvQUt5?=
 =?utf-8?B?QStPQXFnLzlhVjhlUkhOdER2Y0Zsa244TURLQlpubnZkYjUxdVFiYlRVRS9h?=
 =?utf-8?B?blVET0ZtVWdsWVQyaWJtWDEyYXBXRkwzbkpWWVNBS1BNWVlFdmZqZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df08dfa3-1b70-4958-d14f-08df31c9ee17
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:46.3331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /PYxGFMSUeq7eCa/4U/0dkQiDHoyOqtWA5a21lCKIS2ocVSpI01Pjs1P71CBju82qihg7KNN9dMZB+9K0coo3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR04MB10294

Move the Tx/Rx FSM state definitions from ufshcd-dwc.h to
include/ufs/unipro.h.

These state values are UniPro/M-PHY related and are not specific to
the DesignWare UFS host controller implementation, so unipro.h is a
more appropriate location for sharing them.

As part of this move, drop the driver-private TX_FSM_HIBERN8 define in
ufs-hisi and ufs-qcom and repoint their Hibern8 checks at the shared
UFS_TX_STATE_HIBERN8 enum constant. This is a no-op change:
TX_FSM_HIBERN8 was 0x1 and UFS_TX_STATE_HIBERN8 is 1, so the compared
values are identical.

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
index 954be9343f42..69ec6327843e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -393,7 +393,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
-		if (err || tx_fsm_val == TX_FSM_HIBERN8)
+		if (err || tx_fsm_val == UFS_TX_STATE_HIBERN8)
 			break;
 
 		/* sleep for max. 200us */
@@ -413,7 +413,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
 				__func__, err);
-	} else if (tx_fsm_val != TX_FSM_HIBERN8) {
+	} else if (tx_fsm_val != UFS_TX_STATE_HIBERN8) {
 		err = tx_fsm_val;
 		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
 				__func__, err);
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index a5ad5ce44a19..3c6cb2281af0 100644
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

