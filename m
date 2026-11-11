Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794383728;
	b=sDi95w6JG9w28c33XlDZ+IntPQ8re/74+5dx4UGYSrus6hsCAAO90bIOQrcuY9bS9bxd
	 FL5z16LWAZHjlX0xk9CzruDmYMejr2QndpVKgRa/1ncVCdoHboQM+Dx3L/cHK0bzTv2AR
	 esHlfMsU/xmPooJdvG38N/7U7SVs0QiC1a09CWoW3dMvT0xlCEK0aQ5PPqRaKUj7rChpz
	 RkijEeMPLFQQMDfUJkkkw+U3yJk1/tubIHRJ2+dPC4feO42epkKw9/Po8uiMYdWR1JC81
	 DRyTGMR70dJ4jA8/pNIbL6HdUyBZowqrk00ap0S7/OqJNZWZ+rEG5nxR2pM50d97/dg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794383728;
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
	bh=dArPs2fvr1OxDi8udvgyAZkVVhW+18fCb9wFz5wTgjM=;
	b=tTKAFlCtM/ocyzLufYF8VMK0yEK+ZLkoOXMWS6qq3SZXRL/0XdGGOchr1Q8yyR0HsBiT
	 6zOdFSyTbDKemIvmFSxkISDlrskFBgTexV4V2++UUY1iwrboy2D8tzkFiNBImHGz3GRvl
	 dvWasPwn1xlpQC/K6ax+os4otuUgAasd5VWNWgegJzil9za29YbvflT1G8h4hRaFS9XOu
	 hEk0c2CrwRLLNzzOeOaqWbl/YC8IAevLomULI8rkQYKX0ScJbSR2bLfR6vuYYAUe431xj
	 mFwlqcih511W5J/7qRb3mp+KrzDYWDLndNFRVfIHvZ1Eh6IRhh0S9ycfWd3kNsksgKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=ctQM6ubb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.16
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012016.outbound.protection.outlook.com [52.101.66.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58400606A320;
	Wed, 11 Nov 2026 07:55:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58400606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=ctQM6ubb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tSgkR/6HDSwC3xC8A49woJlU/riijo298zrn+XapdiIACVDgrK41yZ5AMvYixch2QRM3GWDAqPDRn7k7Q0/9GQCecegbJtyM6fBlaSfREthKSsTg9vmoCqA2QpZYeoCGtwCOoxg5GXEu4AHD8xJceUvLggtamrlWMiGcJSa0B9Ssahwt8Q4OSxkuEOxL5ebldLfN6GAe9PanKFlUUudb2LzGZ8JvZshSUEB027d7r1YHzD0glVDVu+9uEtwIzey4ktt8KVIFJ/QgQTU00z7fo8GigH2NRkd7LHRyM17A35JP9uHmZAMqJTgz8uWcjfvI5y9TUXQEz0nqr3ebajM0WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dArPs2fvr1OxDi8udvgyAZkVVhW+18fCb9wFz5wTgjM=;
 b=GQx8DBK3KC1CVlbztneIJtaJo1FezOAbZrYmBxNQd7FFog1qVwJTzK4eETGEUqfj+bC5z57FsV7UUPQc4twc0ZsyQwbo+lsmSi4ydpkl/cd/GGaNoQuj98N1SG3fbLOc9QjJGYkst5Xg6BCbcADquryGakA5vEjnjXvwpW2dvK0Mmq68iq0dz9e3Sl07wtguT0nrgjF6VG3b2kwlhKfdaoLY1sCfEnrsf3coSlYF+9yjeSfx5aJPDqRGLpv8c0EBcIKhmBybFGj02XmRZgP3Ta8/yXvG3S3vD6DPdgh1numLwb6D0eiBUHopQ+YVrxfVPqiAwkLqmKuvPo/Qc/OSog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dArPs2fvr1OxDi8udvgyAZkVVhW+18fCb9wFz5wTgjM=;
 b=ctQM6ubb7Zqwtb2WZffWCcqOD3DjUWIii6673RQpE7bqa6oASYkTfG8I2oIGgZxG5KKPYymTYPVfdzjzlsp5mF9PBWHQpLkNnV+iDtSFaIWAy/5cDmvaIkVpmIwkF0zODUlYPk9+vZ5dVTiOXCdv5j9ObiDOk/IXubKOhfTIxbdGWJns82MVBd0oZ7ltKUe4VxzCM9l1zh3qzTKYcXrXOkvrPPfIb3Efch8vYs6aABIEkMJuufKwTeJkg1tN+Du8HLDnotAvJuwXflMa3LLpbOIHmnCPxxHChBP6oY7aZxinv6XOCEDTyNYz6g6YTw/MQIKA20hOmhrVpqceDDSPOg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PAXPR04MB8459.eurprd04.prod.outlook.com
 (2603:10a6:102:1da::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 07:55:24 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%5]) with mapi id 15.21.0615.008; Wed, 11 Nov 2026
 07:55:24 +0000
Message-ID: <44d59691-3936-4035-9b63-d49bbaad75cf@oss.nxp.com>
Date: Wed, 11 Nov 2026 09:55:18 +0200
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
 <17b24b80-c3bb-40a1-ad12-06242ca09c22@oss.nxp.com>
 <0820de78-679a-45c2-baf1-2905490ea926@kernel.org>
 <02fb96e2-391f-4fc3-8d41-ab8364a9b07b@oss.nxp.com>
 <52f8c2d3-de0a-492e-89c0-f33487a97dc8@kernel.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <52f8c2d3-de0a-492e-89c0-f33487a97dc8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::6) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PAXPR04MB8459:EE_
X-MS-Office365-Filtering-Correlation-Id: d4a78755-98b8-4ca3-3b76-08df3fc92435
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|376014|7416014|22082099003|18002099003|4143699003|10067099003|11063799006|261026140227099003|261028144727099003|261022105027099003|261022075727099003|56012099006|261009223027099003;
X-Microsoft-Antispam-Message-Info:
 EsZjQxDtJ2UclaW5LIzYUD8cx9+l6ATGFUtghV6CB++4HFvb2nfNTjRd+nwLRMOtq2Aw4cTsyNC9VbYSps9ll643I5+AlXm8PKBycCmbbS9/0YcizlTRWMjTbgewD1TjbehEnLbJiMi3TS3qsaoJ39PjJeKpG97mvTymUE5zh99BZIP55XDtMmOBmv9y8E1hW+9Hu0hZEhzhCQ2yYNJhx1W0RuH/wbWExSDUR//+g2oOHGUlqmAobwyMd6Vbqyw4nsTscCgE8xjMDaesQVVuKMpaPp3nZjeKbMG/naZ3rrKM0CDk/ki4EuteEKo+QtxQ814BFbIpQ00TD9ipnAYPqk5zBAm6jW3MwZdlcxDzmDSUG0TRkr5JUIAiPUys/JmcEpRdAAOGWRefEGBorqS67WV4Jw3aSwNqmLHhE3B1N75MTd9dCTmdKqIWAsSuZnh5O0K1BgeQY9GQVwEzWC95K5kH526TiQmL6w3qdfpDFkgtzzSQUUwEbU91YbRmP+8qAL/vI0CcALPVoQ0XG81zdxSmulB4kVaTwmVjBTaNTffvzJpx4yEnN4mtkrMW6QPoi4cJ/x2bILR8qb0J1y/Tcev4cLT6tfM2io+F3vVXaPzdWOuVmb/88Q5QYZBg/OGS
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(4143699003)(10067099003)(11063799006)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(56012099006)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c2xhMlBPcGNjOGkvRjB6SHFCUVk5QWZoM0l6cHBJOEdleXVzbC9tNmFrMUJS?=
 =?utf-8?B?YW5OQVJJNW1zb1NkNUEvZnBVZEpFVlRKKzFqbjVNd1Z1Zk1VbWZ0R2NsRHh6?=
 =?utf-8?B?UE9rNFFBa0pzMVVzRUgvS2pjNUhRQmRQbTR2QVFUdHdVSEFlbFY4a1J6RVk4?=
 =?utf-8?B?TlNhdW1lYjVBWDNTT244dmlDSXF3R0JTb1N5UGsySnp2R203c1kzZSszWm0y?=
 =?utf-8?B?MkZrN2dPMXVtd0FPUmtvK2RXMkFmYmFxYzZyc2hUbEpqNG1HQlY5Vm9rQi9X?=
 =?utf-8?B?akdKYWY5SjhOODlkcFV0L1lzcjNrVzFwSXpGN0gyQjVlbzZBUFlPZTVJUGds?=
 =?utf-8?B?Uk9pN0hSU01HeHcwUDF1T3lLeGtGdCtqckIrbitrOWpqM0NGZUlYN251d1Q4?=
 =?utf-8?B?bVJlR1lTamV0UnRmU2hXYm94VVJKS2dFR0dTYXAyVjJyZkd5YW1vbHJWTStW?=
 =?utf-8?B?SE16RklLaUhyRzY4OUZlOFZ5QmUwY0FraG9BY081MGhtZ1VQVG9mNEllOVJ2?=
 =?utf-8?B?d3l5TzlYY0hlT082bnBqUTlIV3FQQWpLWkM3NnF6aDNVSlVWNXpEejB1WjlV?=
 =?utf-8?B?V2xFa0FKdDFUaWhTV1hwMjhGSjQ2aHNDeXlKNHNYc3ZnU1BaM2x6ZEUyU210?=
 =?utf-8?B?aEdGbG5mT1lNSlJuc0RDWUxvMVRtR1hXSDM4NW1mMFRIbU5GNUNPdkhQMlhp?=
 =?utf-8?B?STV6c21QV1V3WGdnN2QybDdMc1grUTdxUXNWTnZsajlNTGNKSkI2bm5FL2JH?=
 =?utf-8?B?KzFySWJ2b2t5NzNacXV5dHJnQ0swRnVadm92bW0weU8wd1MyekZDQ1VjekZt?=
 =?utf-8?B?NjdxVW4xeU1kTG4rK2ZtYlNKSTZjSnhSMlZsaitNanpDc0RTZzVYY2JYbEY4?=
 =?utf-8?B?OER0RjVrbWNLTEUrN2FTaDBoOEIvamluRm5HL2xYTm1zbkIzNFRCSUlyN3E2?=
 =?utf-8?B?cUwrNW5jVVJVV2xhZjlPampnVUt3TnhXMnROcUtuTVNrYWVqUkswd0FWdVdj?=
 =?utf-8?B?UUZFWmg1Kzdmakx5dHhGaDVQcFhaeGNTL2djejFOQVE1QXFOemE4eDlDVlQv?=
 =?utf-8?B?d1JTaGJRSUcyZ1MxYUh0NHpiVE9KTzREOHRTMVNzYWRLaS9KcHI2ZGZYdFhr?=
 =?utf-8?B?UG9ad3JGTEZPZzFHYk4yMldJclFOSlA4Y0lXZnF6VTU1TlIxZkUwRTV2VGdo?=
 =?utf-8?B?eXpUbGRtWm5SNkhzYXNiNHV4a3d1c2toa2FPRFFSdTJYTU5yWitWZWRkZkls?=
 =?utf-8?B?SWIyYTluQUFLTVdsV0p1ZlFXRTBOUTVXQkFBVmhKVkwrVGl2bFNFaVlDMXpJ?=
 =?utf-8?B?Nm9xSnRkclh5NDMydVNUbk85V2s0Z1pkYmZwNzcwWTAzL2RFcTNSNXMyWkpn?=
 =?utf-8?B?ZmlDT1FPQkxSejdidHZMOXJaS1lrOGJLYWlxdm1HZ3JGMXdmV2d6aDRMTzNL?=
 =?utf-8?B?S1JnazdrQ3N1eDB0blg3bWhSajBycmdmc0FTZzExemdZZ3Ewc1VERFlocTZq?=
 =?utf-8?B?QVFIK2wwUlBRZGpCSmxnNFJ5L2hWRjF1RnRid3BtVUhlaUtpc0huREhDSDVa?=
 =?utf-8?B?WTVCUCtqdzNJaDlqbHNKblMzR0tWdDJCclg4NHFKQ3RqSkxUOHlEMHU2YTha?=
 =?utf-8?B?MGt2NmlIOTBCWXUya3RYMVBMTkpzWnYveElLdzJXdmpmR1d0UEp2cXErSXlF?=
 =?utf-8?B?NXBUdWdVc2tnYnlIQzhqaWZzc3JwSlF3d1FYb0lvLytTR1QrSE9Ob2hXU2FQ?=
 =?utf-8?B?UUNtQnQxTEZPY1lUSnVtZ2ltZkVQaWZ6K0hDaE1qOG1VK0gwZ1dvZzd1L0Nu?=
 =?utf-8?B?RER1OGtvNHVuMnFnRVpjaURzRzJPNHlIeVVYYzRNeFhJNTBCM1pGVFViMnFR?=
 =?utf-8?B?Q0xScDA2ZzU2Qyt2S21kbGNzRWNnT2lVcVJrbjdwbktnS2o3OW5DMEVCTmlN?=
 =?utf-8?B?MEY4cXpZdmFvM2c5anVLRHNpbVNUUWUzSHd3T0RhVWFPakFWeGRGZ1JLVTBj?=
 =?utf-8?B?dWRGTFdsQVpkekQ0c0wraXFzcm9nYzNLcno5YjFES1VGdWFqdTZLdXpuWVg0?=
 =?utf-8?B?NG5CYTk5Wkt5Q2tQMnJLT2lHdmx5MndVQjV1MXBsV0NuRldiellEbGFQalJV?=
 =?utf-8?B?MVlUU1dVMVozK0N2UnBCNGpuZGp6TFVGSUNjTTA5eWVVbml1WVlwV3NCOFJ2?=
 =?utf-8?B?K3djZXUyL1RReHkxM2xRemUvdWVmRmdQWXRaLzNNcFNwUEtwN0wyNC9wYzV3?=
 =?utf-8?B?ODExc1pPc0pjSkppVzhnQlZnMjNETzlrN0NoaW4zdFlFZzRDcXJ1SWF4bElq?=
 =?utf-8?B?YTM0aGlDbjlnOFZCMlBVbG5TR2E3UnFiVlplcVFNTHNTV1FrbE1wT1BzQkdU?=
 =?utf-8?Q?3eAXAWgbYhESO4lk=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a78755-98b8-4ca3-3b76-08df3fc92435
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 07:55:24.0770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkFDEV+VNaXZiakjZ6ANPFLklMEd90wp3Qb1YaZqP0rLMydC9NcBXCkU/JMg6RwStZ1HwP/ut7P4c5Gm9w55Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8459

On 11/9/2026 11:42 PM, Krzysztof Kozlowski wrote:
> On 09/11/2026 21:47, Larisa Ileana Grigore wrote:
>> On 11/5/2026 8:28 PM, Krzysztof Kozlowski wrote:
>>> On 04/11/2026 10:41, Larisa Ileana Grigore wrote:
>>>> On 11/4/2026 10:40 AM, Krzysztof Kozlowski wrote:
>>>> v8:
>>>> https://lore.kernel.org/all/20261013103003.373156-1-larisa.grigore@oss.nxp.com/
>>>> v9:
>>>> https://lore.kernel.org/all/20261024122533.3609180-1-larisa.grigore@oss.nxp.com/
>>>> v10:
>>>> https://lore.kernel.org/all/20261103133215.1385823-1-larisa.grigore@oss.nxp.com
>>>>
>>>> Regarding your comments on v9:
>>>>
>>>> Frank's Reviewed-by was given publicly on v8 [1]. The series only looked
>>>> like a v1 because of the wrong version number.
>>>> The tag ordering was changed in v10 since the patch was changed.
>>>> The single 0 Hz OPP entry: as discussed on v8 [2][3], the clock rate is
>>>> set outside Linux and is not scaled. The OPP table lets the UFS core
>>>
>>> That is not the purpose of OPP table. OPP defines performance point.
>>> Performance point of 0 makes no sense. You cannot use Linux limitations
>>> as reason to add some DTS, because answer is simple: fix your Linux
>>> limitations.
>>>
>>
>> Hi Krzysztof,
>>
>> Thanks for the clarification. I understand that an OPP table is not
>> appropriate here.
>>
>> Existing platform DTs, such as Hi3660 and MT8195, define freq-table-hz
>> containing only <0 0> pairs. This allows the UFS core to manage clock
>> enable/disable without setting their rates. With freq-table-hz
>> deprecated, there seems to be a gap for this use case, beyond S32N.
>>
> 
> Instead of passing 0, properties should be rather missing and that would
> be hint for Linux. Is there a difference between missing properties and
> some non-valid state (like freq=0)?
> 
Hi Krzysztof,

You are right, this Linux-specific distinction should not be reflected 
in DT, even though missing both properties currently leaves clock 
management to the glue driver.

For v11, I will drop the OPP table and introduce 
ufshcd_pltfrm_init_flags(), with a flag indicating that the DT clocks 
have a fixed rate and should still be registered and managed by the UFS 
core. The existing ufshcd_pltfrm_init() will remain as a wrapper passing 
no flags, so existing drivers will retain their current behavior. The 
S32N79 driver will call the new function with this flag set.

Would this approach be acceptable?

Best regards,
Larisa
> 
> Best regards,
> Krzysztof

