Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712769;
	b=185krYssjwFhqMycLW53JilPg47bWxcz2X5nhGU1w99GEMhhbsOe46Mw24kLUe/Hgcgx
	 7sx3aPy0tqiHQSII+r3K8UfQ0nBWhDxwc02Al6DpAHzOiX9RQxsgNPBIF1r4CfEVwFV3T
	 wjNMXmscT1lxSAUzOLsbicy1cjvN0tnAT45X2ZFqgXYmGxVi5i11jyfpE3xVBZNUpKqck
	 8hOUAExZjsQSLvRHGXclJAGSFic3eeo1VcnKlXNQeCbKqWec2tnSP5QvX973TeipqmBGc
	 SPXfsOaO9CqlvlhIK4t282Zx51StDCL5ne7RVWlw1CDXO6zCU1tsUzqApfuhE1LY7cQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712769;
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
	bh=QgNSMyscZyhkKnhMQ+seCPeNjUMMWoqULJRwj9c8MgU=;
	b=ARs7lWC5ilyZxEX4Mi+KO51Tb9gKbAbu1cZKmjz8eWHnzDzzd4Pie5nCoVg/AwU0vamN
	 vWQUd+1BMw2Dm6qswv4qe14Z+z+2PtRvQY4k3n7lXeqzAiVhVnC/rBFzWkJqgQimNVhlH
	 AHeb7cxfB0udjBsugz9aq1ySgAPv9vG0wxKj0bYZtUqGGoU5Fz7NGGoTpT3B51kXb1spp
	 Bvou6THtiAwd19jAIi06H7OtxPkg7L1h3Iy/lnCNwkD5PQrWyerQVMg1eBOACy+ja/How
	 K8c6JI7qfQYiDKY201J6irjD0nXc1GNL/vxuuf1N/XvmJiUKaG/pTftcWu0L+e33qOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=XF0XahYN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.18
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012018.outbound.protection.outlook.com [52.101.66.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF82606D80D;
	Tue,  3 Nov 2026 13:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BF82606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=XF0XahYN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLhcVz3qeK5h/ucJ5C/in4wv448obzuoV2tCwG3BOlxk0i8K8tBusncxZ1hcuQcxyRIMYKudswDPbbhGiHm8/hmNHzMS22wdfduED96xAFfceFN+S17QrKNesjN2tALeahCLJWpO2UuukeAd3BixG+jaH/X4D5a12HHOfCejzXd2r8/EzjbwpCqMBSEMVE/j7MDkNs6rpfqeJguQLuXm01YyOUDhDTESkeOzT7JdTC2j6XG3MO7/SHlAxxLNC3tdWyb39bc4CD9/vXTaKhvKzrq/DjNg8r1vZNA71y2PPgcxYX/arzzo0POTZY3V/FWNvGt7iYkkBdsx+KSKqub/uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgNSMyscZyhkKnhMQ+seCPeNjUMMWoqULJRwj9c8MgU=;
 b=rJPgxPDVJWGQLDS8I4HHtJzQZmOG7Y2/o8rlAhGhxlEM+l1eI4o3MpRXV8oKltSOByIAbP5UXY5uhm5ECFimzKOcF1C8XSFEaV3yRCf0iUwd+ifhrPOZNRXiannwp/KfUB8HcrFSU9LNbPTpAwt6TpOWgcwgcB+e2D1pGOCQ2zEoaDNqcxrMFtMNnhPBAEviupxbHQylsH05Zk5AyjqmpG63kkJL1/zCDA0irxEz56guwQc5Rn22E4EiEl8YMR/7rLE5q+TxlxGdvpUNt1xBizw3NF2hPm3BD1h/aoNbjO+YkVvTbA7RFY56/Va+9eKuDwTz2QXZeCaW5LCEnqT2KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgNSMyscZyhkKnhMQ+seCPeNjUMMWoqULJRwj9c8MgU=;
 b=XF0XahYNavlvJDifd6PrtFkY3LP2oDQJgZkFR2hLdqctlX0HruTPK6G754C29GQCCzgYjwa6QXP05KJ4xuatkcUtrFJxmg8T7mf9BgC6zzSEhxhCy+eOGWeYRqCR6ydk+U+syFBADFiXkPdhSVxmczUHma7HxqxwD3zZh+RjERNMhJbcefjpucsoA/Uav8ke7dGd0+WLmR+yD0L5kH0yf0jqfGaX8t35VqxMCnb/Yv7umlx70TOw1JiOWGtbgBn4L82fwEq5l6ZxZqzjIAtQPXbKRpjGeTjtdMWpFitarAbqpRK8FddV4VrPflSQZPHjy+Ou24LdkorazRupRYcNsw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB8777.eurprd04.prod.outlook.com
 (2603:10a6:20b:408::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 13:32:44 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:44 +0000
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
Subject: [PATCH v10 02/11] ufs: dwc: Return a negative error if the link is down
Date: Tue,  3 Nov 2026 14:32:06 +0100
Message-ID: <20261103133215.1385823-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P192CA0011.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::8) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: d11c0faf-714f-44b0-5e78-08df39aef101
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|19092799006|921020|11063799006|56012099006|261009223027099003|261102123227099003|261022105027099003|261021123027099003|261021121427099003|261102130727099003|261028144727099003|261026121527099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 JqmzSbaFweUDfbzCjV1uMAErXblC/AQhav4rA6gr908O/dScTgeiU2PRYPQHH0uPiBKxC/eiMcmMvANAvgF0rf4KwEpHl61BQV8KcCpZ4pFPbxZHDjLcXma6CM6EmjirLRFoxz3pg0amWX0Fy6+xZEgTsUTYNde6wFwSxT6zEQhPpTp36KjTRpSd9lqlo9rVP81st2t4uEP//fjCTgSYs+scRpAR37S/vef7jj+cLSTsfSWoPvJe//kH+Tr37aGwDzgp0dhm+Yd9yEVxXK/57FWHGC379ilrEylCIkUh5ygSDL35aww7mC798hgzk3HQW18Io4UScf3GTFbBeupqoIUnlxkW2jjRxIxybE0G6PDAHRDlR20domoi4G/EHX7YYd+WqIzk7O0aM3Y6YLO0Lt7VESEITHa7E6QF9iGtviw+09OPdqrk+3o7m4a4FyozZ+ahxY8Df19t/XuRmEDfCdcyURE6Vf01IzMtYXFGNQuXJ93Zyl/7XwXCZ68Y5UQwBM0uC1R4UfYFV/Kt+Ig2n6KEJ6zYYz+WQH+ASW6E6oixjKXDn/Ie4Acj9MU/66mAFBPzN+Z2PzxZbvcH1hb0t8zzpl6W3PK4ebbCrlo9O1F4nkCKIykAndyAY2KuxG/ZJqoJCBlAAHxkg4iho87tpO4fgwbjnX7pR6Z2OTtKYLIOT00xq7ftKVtSCr/ZJZNU6coAiL/F4h5kcU58KioJdw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(19092799006)(921020)(11063799006)(56012099006)(261009223027099003)(261102123227099003)(261022105027099003)(261021123027099003)(261021121427099003)(261102130727099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bnJrOFpFdmk5dm9GLytTTWhEcEdSVkhTdVhueGtWY3hQa1hYV3Excno1Qngv?=
 =?utf-8?B?TVhaWnlMT0lKNSswYytYTDl3dk9PTENydFM5Vnp1d2tndTJMZTVuSUovWFdU?=
 =?utf-8?B?SDhaZ2VrTVpFOVpzQUErLytOcHg4QU5WV0ZBZU5tSU5XRWttU0hOeXl6bVRp?=
 =?utf-8?B?c2t4UjhPTTJhWlR5VnI4eFN3Z2pmcU5RS1NDVzJpRnB2TFNKdHpsSkVyczhI?=
 =?utf-8?B?cXVURFNkVjA4SDg5cGpTZzYvaUpyYXZzZkJTSXBGSDNkRVpqeEZtR0V1WXNk?=
 =?utf-8?B?cEVJZ05lbFkzdmRRNHVDTGVJOE5wTnhFR1l3SGthSlUxVUZJT0dMdDd5THlr?=
 =?utf-8?B?cnNnRW0rM1RBRE9LWTJhSGtxNjVheDdLRVo2VDJrMFJTVGM4K3dsdUFHM0dR?=
 =?utf-8?B?OExCQTZFWGliejBGM3BTUVFyT3ZmWU1vSURIN2d5aWhxc2k4SXZVVmdkaVBh?=
 =?utf-8?B?S3BYVzFZeTdkbmdaL1hkWTFLdEtFdGxsV2lsdUVSMUNOY3JFL0dYM052WmdF?=
 =?utf-8?B?eE5MQ21oYkw4SWV5WVhmZTdWUXVETnY1eWpwM1I3K1BkZEZFNkxRTXNlOUlG?=
 =?utf-8?B?Q01vUXJBRlNteWQ4WDlBRWZLVnhsUWk1Q2xvZTJtd0RjSG5LMmQvMHVCZjJN?=
 =?utf-8?B?SysrVVVqTGJXTEFKeEpnbjF5TVlJand3MmRnUEUxeXFlMnFOdnNaWEd4WE5o?=
 =?utf-8?B?L0ZOL3Q0SGdHQk14V3A1bVpqS1lZQjhRMmpnR0V0RUswcGMvNDBUK3RVcnlr?=
 =?utf-8?B?QjZIZTljdTVhZ0ZUcEQyYzlnZ25zUkt4UHFtUlpwR0ZTbFZCODFMNW4rTmMw?=
 =?utf-8?B?SWxtTUs5RS9VVXFscWFYblRpamNqZVJkNG9MOHJwSml2K1lCcUVsUmR1aEd2?=
 =?utf-8?B?cXVFZkhjZmNpVXAwTDRabDVSWUNocmFkQWFzN0NVM0NJRXZHV2FzdzRQZU8z?=
 =?utf-8?B?ZnRuaVBVTTRFUlIvZXN0ZVljWVloMC80MDFpdzhwZzRxSUhKaVZZUW1xYVZB?=
 =?utf-8?B?Q0h6N1ZzLzFCeHh1Z05jeEJNWU1md3BXamh5TkpFOWRWNU13RVR1dE5ZVTdD?=
 =?utf-8?B?WlU1Y05abFgraUpsdit2Z3puaEdGdXJjVHJSV2VWVnZWY1huZVpBdldWR0V0?=
 =?utf-8?B?Y0JjSk00UUQvMEF6dWFwT2tpYkg0TC9UaERFSUttZlBTOE1jeVd2aEZvdXJE?=
 =?utf-8?B?b2ltVkRST1lCSkVvbDNWQzB3UFBqZFJnMzJvS3ZvK0ZxKzBHTXg2NE9YL1hh?=
 =?utf-8?B?Tm9kc3JvSGUyT1lIelZ6dWdRS0ZZZVhiUTlNdzQzWE0vZXZZV1k3NU1XaTRt?=
 =?utf-8?B?YXJUbWRGblJTRWFxU0IvaDFEcXExSmJna0xHRi9OU1VCcVpqS1JreUNJZzVh?=
 =?utf-8?B?QmRWNGh6QzZOY1QvZkhBci9zRWNEKzlmcFRlUVFYQVU4NTR5dW9FOUxuMWdZ?=
 =?utf-8?B?YjAwbGdvSVVHTVMrTEJOTGVNZjRpck5kQWhhK0pRNEVTS1hVS0J1eGJ6M0M1?=
 =?utf-8?B?elhWekpVQkF5cXU3RTIrMWFKdE9QMjl6SitHc01JM2ZHVDlCVHJreU9iZy9U?=
 =?utf-8?B?MG5aQUdvZ0xabGhkRHlSeUs0bGRDS1lVY0w4d09nOStUck9KZmlIaGJsekha?=
 =?utf-8?B?djVTRjVBOUFhTmFOL3RjYlkwR1VpRXdteVllWjBTdHdneFFnZENRRGFQeksx?=
 =?utf-8?B?Y3hCZXZZMGFEaWdKR0FkZ0lVUGhoNEdtRC8wR2dFNTc4WG1iS3Ftbkt4Y09X?=
 =?utf-8?B?WDdpdkhRZzVzWWQvTHNvdGZvUjlxdG5xQ2RQOGNsbzFwZHpQd05PYWJtNVAr?=
 =?utf-8?B?YVdBOG5ZNExsSEJEUFlFbUl2VkdTRlFGT1VrVjd4R0dZQ2V1YTRDREFmTUEw?=
 =?utf-8?B?YnlnVkZHK2VBOHJFS081MkxpaFBlbVN0QUdFYzQ5UzNaSlFjMkE0eVRtbldY?=
 =?utf-8?B?c3VmeUQ2a1VsL09kME5mVWxzSEc5SVl4SVdPNDBxWEtnNUk1cnFONzFNSjVE?=
 =?utf-8?B?UTRYU3JmVWV4MWx4dktmc1VJWWN6MDJGZ3MraWFCSGdQUFUvZDhSQzdaaEYr?=
 =?utf-8?B?ZjFhR0pzd0FaRFhURnNHWE1zbnVJaUxXWnFrRlI0RnBvUmpOVnRtblZya1hX?=
 =?utf-8?B?UXRUMFVWNUR4NEMrVkgvZno4UG12d2RHcGlHZnZnQXR3YS9INmp1UE5Jenl5?=
 =?utf-8?B?RkVqbnFoa3dzQkZheGZZMSt1Ykl1cDgveEo3VG80Qnl0Z0xneTNtaHRZVndq?=
 =?utf-8?B?SjRBWnZ1cWc3UGFONjJyYXUxeXBVWmxWZlpDcUxqbWtKbkFMK1BRZ09KRmNz?=
 =?utf-8?B?cVFyRmpzdk1DSTR6UlltRld0UTdtaGhCSjJPRGpIcmlSOGpITzhTUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d11c0faf-714f-44b0-5e78-08df39aef101
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:44.1187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oeZ4XzznmDEKJ3++qubFDLhYSuAkBbmGQ11NUIVwcDzKRv0ccVqxgfakyKAMKKLQrMcoWLH2LhPzW4Sn4LLTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8777

ufshcd_dwc_link_is_up() returns 1 when the UniPro link is not up, and it
ignores the return value of ufshcd_dme_get(), so a failed read of
VS_POWERSTATE is also reported as "link down" with the value 1.

A subsequent patch exports this helper for use by other DWC glue
drivers. Before doing so, make it follow the usual kernel convention:
return -ENOLINK when the link is down, and report a failed
ufshcd_dme_get() as a negative errno instead of its positive UIC result.
Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 21b1cf912dcc..71433b4d04aa 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -48,20 +48,23 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  * ufshcd_dwc_link_is_up() - check if link is up.
  * @hba: private structure pointer
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success, a negative errno value on failure.
  */
 static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
-	int dme_result = 0;
+	u32 dme_result = 0;
+	int ret;
 
-	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	if (ret)
+		return ret > 0 ? -EIO : ret;
 
 	if (dme_result == UFSHCD_LINK_IS_UP) {
 		ufshcd_set_link_active(hba);
 		return 0;
 	}
 
-	return 1;
+	return -ENOLINK;
 }
 
 /**
-- 
2.43.0

