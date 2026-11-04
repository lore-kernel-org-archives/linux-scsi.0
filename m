Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793785275;
	b=K+IbK/CN7SjEQNVWI9R7lv1hNUAzEObpPLWu5TzKchQxljF44GWVJGQ8RBQx1II4DC5v
	 J+sUi2wh/XZHC9F/5h2JLVo3nWhfz7obT54nv1xMgvFPmJ4QtO2oXO9Xk+f8Bh1NO3b/L
	 xf/i7GxcLB9ooutAw+Q4U8NQloklRwETQwsaU1EcVGPNLSy5LtEMwTGP6Gk/HPA33MTOb
	 Yhpo75BKb+WzISZZF43iT2y6aruMDd7JIJeSEn2Ug3zaTJ7oH38ABN+YboVo5H4ha7fFN
	 vcylQuYKeiqteUjTXd1sxabvDeBkO0ax+F4OUji4C4PzaX8RWDt4Jqro88jBaHS5mOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785275;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=IE/TGRvKn0/YtSFKCUKrnVzRItXVJR0fCmqCcumnYt8=;
	b=jO7wnu5J50D6BKH4YJlqA3OMM6dCXsrmrTNePsfEB80X860ySSYyifT91NyQJpXzySus
	 lZmKJ2VeRJGdvqpRvLATdrKAlKZ4xjArvVcHigL+1wlW2tNaGOnuPs3IWzIq1oC1Jg/de
	 G2k6TmJmb6A95d3xeYIBZw1/JlPd4kMisTliWu9B1BqZJe8d8tlCoWuCJItZTu+DXgoJK
	 21HbGEmC0tU1Iv/pGBBv/80FSOasM0qP/zRNb/R/w/QOLQE22psFiVev7I+DRWtTW7CKY
	 dTFNAcQh4hF9X0YPfaXyBKmWh1Zg6ousLuZ0OEgwX64cz0/jlkBwhf1pokCUXzKBlxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=cMA3C2At;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.1
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011001.outbound.protection.outlook.com [40.107.130.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DD6606A330;
	Wed,  4 Nov 2026 09:41:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78DD6606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=cMA3C2At
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eshctsTEDIaS4R061d857StDKs955uu3MYwRTvUUCFMagIVVEbOvENUyn9uloH9oYwpfkcybXTNwLhjTvedC91XqA6AQrhldRPryYezJOWLjTuc1/FjGt60wPUaPyQPf+yvQir0paq2fcQj7pPojeotjBOXQpYT+9aTdGwJGY+bkxUcZdcG0+VqBJ/r4lCX/YSmoxjP90jBYS5nUD+fTAEDOT+ZMznnmLoQTfzjJi5Bq/ifTdTnojw/vE2Q7zXV8AslqnSPS9cr4nQhVEcWljB/L22WM9vfI1rAOQVpLWTeP/rCmKhfXOuTuqLvUz55owxjCE0bHrKu711lYU+NdGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IE/TGRvKn0/YtSFKCUKrnVzRItXVJR0fCmqCcumnYt8=;
 b=GkLvA1zPf7sSD7RJuBLN75jZ3jfTBLvGY7wRAqAJMXrqzB8om/eAHZoNnaSW6k/SDs88Vu+6UuMpOV+qaXWfFJDRet7y6E4TCNWhhhpTnlzxjCucy3JZAjOjGl9XspYZd93dK8QhYIeaw4EnB100TevIOC9DPKMMlCN4ipx1zGqHIZzeXlWLOnxRG5Vssif4ZWhmo9+MgGR8/hxQSq9wF3iGVRuPN95Huacgl65pIWtHaSDye58icnZ3CyovPBcC6K3qRCNB6WLv8ypbQK8DDMWePy1Nr671sGeXbATv49apRHQQmPI5mdCesOBjwgjnWLXyoKTwG/op8JUEToM+7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IE/TGRvKn0/YtSFKCUKrnVzRItXVJR0fCmqCcumnYt8=;
 b=cMA3C2At4Ftbckp5JHZCnNUlvHPLSrOUyxQG+aAxEmdWQllpggK03ElixGvxW7BfoJkrRpa9QPPvJ8I/nXziJmc9GJws5ctN2KJTbdIQqluNwTxmE+KXOVPN6bbzz+DZNjUn5myOtWl+wnB9v0Kf8/QtxtqGRSewgzUrxOSnEVK3hee3GuCXkwElD5ycrk++E20O4NcZTnS8Fm9eVlX1rckGA177/733ulaSsKfwr9hfKMuVD1tBPZ9HUlO7bp9/qG9QyUIeielCtiDOWaK7uk1hI2xXqItF1L4pNzb1xCiHikKU/qtezGcK6gNrd12+bxjMoha77t4fmTZxxr4aVA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7678.eurprd04.prod.outlook.com
 (2603:10a6:102:ec::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Wed, 4 Nov 2026
 09:41:10 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 09:41:10 +0000
Message-ID: <17b24b80-c3bb-40a1-ad12-06242ca09c22@oss.nxp.com>
Date: Wed, 4 Nov 2026 11:41:06 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/11] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
 Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Can Guo <quic_cang@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>, imx@lists.linux.dev,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 clizzi@redhat.com, aruizrui@redhat.com, eballetb@redhat.com,
 echanude@redhat.com, Frank Li <Frank.Li@nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
 <20261103133215.1385823-9-larisa.grigore@oss.nxp.com>
 <20261104-holistic-loon-of-agreement-db7b8f@quoll>
 <4e82a4bf-e2db-4a3b-bebd-9f9c473817a3@kernel.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <4e82a4bf-e2db-4a3b-bebd-9f9c473817a3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0185.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::18) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA4PR04MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cac9d85-841d-4a9b-2e44-08df3a57c1de
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|19092799006|23010399003|366016|1800799024|10067099003|22082099003|18002099003|4143699003|11063799006|261026121527099003|261022105027099003|261028144727099003|261026140227099003|56012099006|261009223027099003|261021135927099003;
X-Microsoft-Antispam-Message-Info:
 IpgNARSs6QplCyzUbFgFLP1C3DNZYzADEx8ureahaXWSBxLhxMwNMffPOY9ptap3u8keBXM84o68X3ulZCJA3JQXuQtk58LBdxAXFhEBDi4OFefDbR1a7vGBOBvPOLSoeqdVByDD8wyVjqi4HN2ZyhulLl7YFP746pwFF+18ffcSk1uWZPb2PMUTQdlaDI4voTAwudLtxeKBrPOoop1pmcmms0UVHgEVynS7k3j3eNL23O4n05NGPOCZWv+aspbwlvD6mhboWQ/9v/hqcyMyphOjyZUlHd+az8zeu/ZSIwIV51PUzeM48vTV3n+E66VUIYrphPCGABLHicZs7TbjpKJFMqFI6h/VAJ87o3TxqBAEn0/yXwiLuFc6IKTFAGmTSPPW+6Svp9hH+LD+hI9KkjbDpuU/V6ThsrKKKKazFsE43o/II/QxmW8kYjQ/8Ar2Z3EIlomVHWHU/DpD1TAifpAK+68aZJwI5OuGBdOqJS+YlLrI/qoIO3FPfzJIA1Fh2b5xDJ7s3kQC+RGw8avK+40ZCECkNYM77UpBir7HJ2l/492K+Ct5pIVR0xx87104yszkCMrCaVrY7dR6UabzjBRSLwIoRj7j+XhpEa0EajokbaLA1g3uVE65KmsDMrDf
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(19092799006)(23010399003)(366016)(1800799024)(10067099003)(22082099003)(18002099003)(4143699003)(11063799006)(261026121527099003)(261022105027099003)(261028144727099003)(261026140227099003)(56012099006)(261009223027099003)(261021135927099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SXFaL1ZjQnJyZVlGUTMzSnU3c25Kb0pFcDFMRWhsVTVkdFZ2S1VCblNabzgy?=
 =?utf-8?B?Sk9LcW4vTjVyNVdOazhwOTdKS3FsTURsLzczN1NaTGM3MHQvR00rVisyWSth?=
 =?utf-8?B?ZjNlSGRzSVNhWXJOMU1qQlpLTTJmVGttTHpIbkdVNXprRDlEVWI1NWcxdWJi?=
 =?utf-8?B?enF0aDB5MzJwdEZvYlBROXZ6ZmlWMjFmb2ZyNFZVelBramtDN3IyNVIxS21N?=
 =?utf-8?B?MlpjUXJ6UjFXUEZLNkRxbm14bHlkVHNTUWpBbTR0anJhUjFEa3JBM21GbHlu?=
 =?utf-8?B?RUNQU0JqdHBhV0xqVWVpcW50WWE0RW93SUF1TEp3L29Yb2ZaaG5Ga0dKY2hP?=
 =?utf-8?B?ZnlPSVpFUUpCcTBlaVVxUE8wWnY0ZVFadXNFOGxycEJEelZZYzJQKzErTU1Y?=
 =?utf-8?B?WXZBdUoxNFEwRlJqdnNNU2kyUlFwdlc2YTFXcGZyNnd5UzVKL3psNnFXRkpw?=
 =?utf-8?B?c1hPMWFqZEJSaXcwWWJVS3J5dkw0MCt4bldKOGtNR0ZMbEl4Ni9wT1VkOGt3?=
 =?utf-8?B?SmM4c2dRSFZHRThGQjBqa2NXenFNQ3g5WUdQa0dvWm1iTFozMU9jT1hSWCsz?=
 =?utf-8?B?cThSUkVUUDZzMEkyN0c0MzJIbnZRa3RIMjdPTjRuTWZHVWxPdDhCSGd2YTVx?=
 =?utf-8?B?R2lUWjZGZk5mbTV2WHU0WEhEVDBTZEt5aE91L25YKzVaRDNuZWltMnZ0d3hu?=
 =?utf-8?B?UDBoanF4ZHZOOWFTcm10SjRudXNYRXdIQzV6bklwbDlBSFNFZ0U3Y3BrSHRR?=
 =?utf-8?B?Q1l6ZXB4RjJYdCtzc3JlVFcvek5BS3hxLzBnb2cwYk56L3NhUnNHSDlFN2Mv?=
 =?utf-8?B?YVl5V0NFZ2U0TXJKYjFiQmNaZElmVVd5L0FQSFJJRjBWc3JiVWJxOEZwVXow?=
 =?utf-8?B?YlpkaUZnL0dnMGV1Rm5DQzFhRUlnd0tpQ2ZuZkVpT050d0Z1NUFOVldTYWs3?=
 =?utf-8?B?L0FFcndNNVk2QlFxMkFRelZWU29LVDBhMGV1QkNScFVyRExmbks5WVRNWXNW?=
 =?utf-8?B?Y2JKbllhakdzZGUzQW1qYVYyaFhWMXhhUi9nN2wxZ2o1M0ZRQURhNElCSEtl?=
 =?utf-8?B?MThFMGFBQkluYlczbjlkQTVrNm8zZ0JMZ0pKcEpMb2swZ0lyOUtOeWRLWG9z?=
 =?utf-8?B?S2tpeU1DY201REZZVDgyTDAzRTZlSTJxdWkrc0R2VjFMc3lqOXZ0SGMvamRU?=
 =?utf-8?B?L3J4YkRORHRrS1llbXNIWkJOSno5Ym5EYk90dWpjaHcyYTQ1TmhWTE9lTDNz?=
 =?utf-8?B?c1BpQ0ZsRTZDYkhFRHNvd1o1QTcrTFA3TWxyMVpDVEtCQXZhL3F4NmpHKzNS?=
 =?utf-8?B?cDdvaVNaVnFWYjZBT0E4RjliczhSekxxQm9vdW1aczczZEtsQXpHQjRGNmtP?=
 =?utf-8?B?Q3hobFdXSm41Z2YwdVVaRjdNWHhqOWgxdEVYYlhvQlRPUDFPcWt1bHdWRjFE?=
 =?utf-8?B?SVRMM0xvTk1WN284b3Jzd3NvaUNtd1V4UHVxVGRNcytZUXAxRUdaVk5VaFA1?=
 =?utf-8?B?Ykp6SnBDVFVPR1lweUVPcTJVMFZGWlRSMk5wdWRNbXJWQ2ltTzJQbnpqUEVP?=
 =?utf-8?B?Vnl6WEVEdWU0T1A5YVhyZVJQeW83QXdVeUhSYkQyK3NobE9HdmlJU2lUcDNH?=
 =?utf-8?B?cmF3bXlQd1FseWsrc3prQ3EyYnJ3V3FTQ0p4ZkcxSEtqKytKVU5LRUVYZ01R?=
 =?utf-8?B?UzBtam1jVGZFOVpHQ0ljeTNham1rVklBc29jeEpDZXNSMndwVFRIbkRlcWZz?=
 =?utf-8?B?U0UzK1hJczREWFJXNUlDWmN4Mk5Dcms5czVPOVhBMFFVcU9tTHZYdkp2ZmZ5?=
 =?utf-8?B?bkdURlpPMFRYQ3RYQTBWbDY3U0xCNnNpWmF0MWZxY05ySk50T1BLV21oc3lq?=
 =?utf-8?B?QjZYZVBlcnF6T1M5QmVKTC91dDBFYk5aWFQyV1FwYW5YTE8wQjRBWHBneWRk?=
 =?utf-8?B?OUpQZFJWZkR1WWYxT1BlT2JGcGR4UDArVFdjMkZNK1ByZ0txTjBVVWZ5bzJM?=
 =?utf-8?B?eTJnUkx0SGdJWkRXQXdsTElKVGJBWVlSYTUwUHpPUThYYUE0bTM4dE1FNlBw?=
 =?utf-8?B?emdQK2Urc0lhYjlZejh4QnRVdk9kUjVlWG5GMDVYdFhoOTdBMzliM2gyUVNT?=
 =?utf-8?B?MTFyT0lWMjJqL1hTUDl4Q2tnOW5BaTJkYkxoTmZSOGtzTkFYNmZhaEs1ZTAy?=
 =?utf-8?B?dlNlenh1ZEhqVG4wV2IxTlg5bDBjL0QySWxqTUk5cUE5RHMrMDA0eE4xSkwz?=
 =?utf-8?B?RFY3QWtZdG9tZFB0MUkwOGlmcjdUakxRejc1UnhvTmQ3T0t1U1dWWTNoZUVm?=
 =?utf-8?B?Z0x3eXJYQmFCRXZVckJLYWpvT0phVFhTR0FUSTVudEJyZCtWcWtOQmFwTGsx?=
 =?utf-8?Q?rRgc4hen+0Pn/KTs=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cac9d85-841d-4a9b-2e44-08df3a57c1de
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 09:41:10.1816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MoJXtVGxMU5dXL9SsdddqPBi+a/+oD9nLbdHQ7+R+it0rwCdUYhwmWLvZtG1I6nPcads+zZMb7ZksFNWPG+j2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7678

On 11/4/2026 10:40 AM, Krzysztof Kozlowski wrote:
> On 04/11/2026 09:38, Krzysztof Kozlowski wrote:
>> On Tue, Nov 03, 2026 at 02:32:12PM +0100, Larisa Grigore wrote:
>>> Document the UFS host controller on the NXP S32N79 SoC.
>>>
>>> The S32N79 M-PHY has two data lanes per direction and the driver programs
>>> both of them, so restrict lanes-per-direction to 2.
>>>
>>> The UFS core manages only the clocks added by the platform glue. Since
>>> freq-table-hz is deprecated, the binding requires operating-points-v2 and
>>> clock-names. As S32N79 does not scale the UFS clock, the OPP table contains
>>> a single 0 Hz entry, which keeps the provider-configured rate while
>>> allowing the clock to be enabled and gated.
>>>
>>> Reviewed-by: Frank Li <Frank.Li@nxp.com>
>>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>>
>> No lore links in the changelog and b4 diff:
>>
>> b4 diff '20261103133215.1385823-1-larisa.grigore@oss.nxp.com'
>> Looking up 20261103133215.1385823-1-larisa.grigore@oss.nxp.com
>> Checking for older revisions
>> Grabbing search results from lore.kernel.org
>> ---
>> Analyzing 91 messages in the thread
>> Could not find lower series to compare against.
>>
>> Is NXP going to switch to b4 or not? How many times this can be raised?
>>
>> Sure, you do not have to switch, but then why is `b4 diff` not working
>> on your patchset?
>>
>> Dropping from DT patchwork.
> 
> Ah, found now v8 and previous feedback was not responded to, nor addressed.
> 
> Best regards,
> Krzysztof

Hi Krzysztof,

Sorry for the confusion, and for not replying earlier.

The series sent on 24 Oct as "v1" was meant to be v9. It went out with 
the wrong version number, which is also why b4 diff could not find the 
previous revision. The revisions are:

v8: 
https://lore.kernel.org/all/20261013103003.373156-1-larisa.grigore@oss.nxp.com/
v9: 
https://lore.kernel.org/all/20261024122533.3609180-1-larisa.grigore@oss.nxp.com/
v10: 
https://lore.kernel.org/all/20261103133215.1385823-1-larisa.grigore@oss.nxp.com

Regarding your comments on v9:

Frank's Reviewed-by was given publicly on v8 [1]. The series only looked 
like a v1 because of the wrong version number.
The tag ordering was changed in v10 since the patch was changed.
The single 0 Hz OPP entry: as discussed on v8 [2][3], the clock rate is 
set outside Linux and is not scaled. The OPP table lets the UFS core 
enable and gate the clock. As you suggested, v10 explains this in the 
commit message. Let me know if you would like more details there.

For the next revision, I will add lore links to all previous versions in 
the changelog and switch to b4, so that b4 diff works.

[1] https://lore.kernel.org/all/as4_lVm9tvTeOkBp@SMW015318/
[2] 
https://lore.kernel.org/all/fa3a025b-0d82-42df-a4cc-e144d6a97b20@oss.nxp.com/
[3] 
https://lore.kernel.org/all/20261015-observant-nickel-monkey-2a38b7@quoll/

Best regards, Larisa
