Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712777;
	b=Y3EAvARZSX5G6lly/+/GEyG6gUQMHG1Phfv9v8D3Gv8ixNIzQroXcW1/A7OY8gpfrz+7
	 YYv2XkXqHucL6Gl39g/tigRn39D+8uWsRpx8ZVgQXXAPAekpNWAfLNC62Ci/Y5rbGCm3S
	 xUdTi/TXImBiIbbJWxjSGEFoROy0F8LhIGQmpr1zQAQAqfI+FFVUby0UDd8a5AO1OuOKS
	 I9DVn9d1YqYXc2f9WSBDsqlXPoncweInClMHMxwo371NhUp7rDCj6vv5HTPJ0kRiowYk4
	 QfURMpjsbxCBYo+q9GeL60BpVRUdtBDlzoz0ZgahwaoZQrfvOpE1FeBZ+BKPz/BMOrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712777;
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
	bh=x5ar6vxo9+wommmc0+i9s+s/2EHWLsEte25sJBpVtp4=;
	b=OhfDyh3NZnbAsdys3I8Nmtq0LVyHGIECPC7iYWAaU8uC6MkejZGACulFoQGFdVNtyHq0
	 JvTBnrzFTnSUhPvAq5bORRdtAeYpTbhXd+S9UJRMcdjozekVEOde3OV64YtiYd3ERjSRz
	 8odlde/+FnuRtQsCnX0ngXwm4FTMvALCsmciT1F0Y3LIV4wZJ5SEcfobm/5gF+YC5wseU
	 Q2lOh38ZGEyxwxq66xMia6DkklgpE03VEAlq0KpfiLLQBmXxXO+7I2qiOTek23mTugD4r
	 OVxQTTui3NU+MwpktpltH+5qO0I+CeLat393R0qWLxRXGf+TyGBwm4C1XT8ykheTPKw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=RE8O8dob;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.33
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013033.outbound.protection.outlook.com [40.107.162.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58980606D821;
	Tue,  3 Nov 2026 13:32:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58980606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=RE8O8dob
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jj13ijLDdPGuGkXXWUG5hYwNuLMQbpnxyuQE4vHiWJUJQVhoYONzhAnVe4VKARlNQwnbYBgUoo26hJTJoGcrOylGXhX0E1zJGcZ8DCKKOWdddGlxdqAkN/3gRFIwsWAt4APhxNbOA8YEj2OiZMfRS4EiU6R2P3IgYkLvrV/Ps7jZLJD2YQ+ik9NQXBuOKRqrM6FiAbxbcM3nkTdXoXD9uuTzh6kihlFo9Z4yznJFcqNeTfyV39gsfr13z0sMV7ZQtio7ylPAeeHNn6rxESjrbFlbrCdr0Xfq/kOE6Y/e/uiDjlKeM5o9Qz//D7oayYYfvGrsWs+GxrGahaZwcUSGDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5ar6vxo9+wommmc0+i9s+s/2EHWLsEte25sJBpVtp4=;
 b=vsimLAB38ipml7Fi3xPpfCHh+sebEQOsNxi6xCVKKTBVIUkzMdskoDvikDFij51sBORKYFNtvlaIunMa6HOsoB2zdihtCGdqLm1B8WWD2iHiNrw0HC7sL8irdi6Lg2+5kKQHuKKEB6D8h0QFkCRgWtGdMbzNQVmHUqcPxRcQRQrQbGey/csyh37nF6Eqmgd9svUzLfjglcs7kD/GTiulpq1TUdOtz5nrVVFnAZpIr8M0UAeSQAcrcwwo4qlv7wtJyau5kMVos5cVh/7d3jR0e2/PLKtm1abcvX1fI2YLDXHRHdBC/I3Qb5Iy715+V3cTR7Ytc7oxXnlCqwi399TG+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5ar6vxo9+wommmc0+i9s+s/2EHWLsEte25sJBpVtp4=;
 b=RE8O8dobZEVBCZGNm2lAT6OM8kceglwnzJZti/xWY0fWMqr4CKMrbH2rAxqJZYYY4AYOH2Bb1Zu8cNMadF6wAOx+ypqV7oZnw/3gyMaGbXAXUWzNTHq48N9AnTpVq7FDGcK46ZcJ30ECvg2nFZKu+reeEI2lRDdcQ0Fb3qlKBaoq3MCUFPxy0uIZlQok4fgk/xtu/YOcFGs5NIcszHBFBE7DkSZbfPxFWeFKpjvyCLf6ILEHeR6I25G9PPR/xSDBHOX3gnH2ywBoSl3Vy0hBFLUZi/cC99SANCJjo6MjdupuUl6ckSjowZQK5DJM+CzvK4vDeMRDozOfM1I0ADOefA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PAWPR04MB9864.eurprd04.prod.outlook.com
 (2603:10a6:102:390::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:32:50 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:49 +0000
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
	echanude@redhat.com
Subject: [PATCH v10 05/11] ufs: core: Add common Hibern8 TX FSM polling helper
Date: Tue,  3 Nov 2026 14:32:09 +0100
Message-ID: <20261103133215.1385823-6-larisa.grigore@oss.nxp.com>
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PAWPR04MB9864:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c1b498-20d9-4dbf-e094-08df39aef464
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|19092799006|23010399003|6133799003|18002099003|22082099003|261102123227099003|261102130727099003|56012099006|10067099003|261009223027099003|921020|261022105027099003|261021123027099003|261021121427099003|261022075727099003|11063799006|261028144727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
 531LopRioiZNl4/OmTcWPre/afzil7HHISmzGrMygAQXJu5xyhohm9OmlVQczctPmPRL8m43JEi9UfCabeEEPydClxMBBUta4akAlMG1OwwBdQcQKtFi2d3Lz8yBh46bG7TEnqEgxYiTHa2NeXcAxzyVK+5ztk1hAGHndvBvnoV5DcZ1nY4Avq13pTyyVH4XT4J9AZIXwS0Kf06huBw1Yc8JnqbxZ6nLn0dBkIaUEmZEZ4M6dVTURZwjSpMmAnujGiIVaDN0B2eDEud86Yl4lUcxzOtxoBR2Jkh9AvT52UJLQDks7aDj8aPClFG0bIUhW0C1tAC1U6S1LAzYjzz4M7hEKm5/jchBxOcjutGl3FcI++yu7idLwjo7k7RoI+SFTyg27uOuUzn1FpMDDrE4AXHuU3oMGdan2il+McF11jyaLMyQuOYB3DeboPRRMcyGRNNVxHGmwN5ZslkGjyd2NZUUSu0RdF5N7wgK22ZYYsGYlHvDbJ/YarxEeYRaOrcC3CgG0OAHljFyLFOeYh8UwK9Lr8Zil25wrRQDQq61eBLxznq0GJCnnTp+oWg6qO2UzjLFKmzDfJvwdhANqtydTED1hPTMxUnieJfD3WsFfDPGk9zMlvSPZa22Kg30sE0TyzDNrXF5Rjb08zIHkXnO1G8hTIBxAdB1KIti4Qc8hwCmUlLXyVp4GPuty9zZ+iLyp+rRLkP1MEFF+G40eqvPbA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(19092799006)(23010399003)(6133799003)(18002099003)(22082099003)(261102123227099003)(261102130727099003)(56012099006)(10067099003)(261009223027099003)(921020)(261022105027099003)(261021123027099003)(261021121427099003)(261022075727099003)(11063799006)(261028144727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?VVRjdG1mWTVSSHIrSmxGQmNTYm96VEppUFVZcWQ2TlVITU1wNnhlLy9IaTNt?=
 =?utf-8?B?clp3dmFFS3dlRkhxT0N4QkZvVGw2RWFrZUxPaTc5R3dGbHpRNE14dkRob0I0?=
 =?utf-8?B?SUtBYnppQ0JmRUI0aGVnM1hWbXMzSTNGejExQzN3UG1xN05wV0xBaDVWMHgx?=
 =?utf-8?B?VlhwaVNDUDVEZE5FbHplTGlYYU1YZDNYRzNjN1F3WlphdzJHcTZxV0hjNGZm?=
 =?utf-8?B?OWd1c0xnSUgwRmVqaDFYYlBVUlBlUThBSWVpVk9sR3ZvRjl6bjV3NjVJMnp3?=
 =?utf-8?B?YTM5NVRpa3hwY0VZb3ZoSGRpTkVaYUw2VUhlSnI5dU9SOEFmdjlzdE1hZmp3?=
 =?utf-8?B?WldNREJQSnJJamYzUkZ5R0JiOTdVQkdDcVVicXB3ZlRHR0prUTQydU5JM1JT?=
 =?utf-8?B?Q2FrMEN4a0lQUVhmd2tROVg3Ui95dHpMQTBCcTZ4OTduS1doZjJLUXZlejMy?=
 =?utf-8?B?Y09mZmhKN2ErU3pVb0NDZG5XL2k0bUQ5c2kyUk4wbEFGYWhobDZuOWN5UFhV?=
 =?utf-8?B?NmZvRWlxWTNVa0RZTWsrOFhQVU5MSGRmeGRZMVBwTDF3ZnVoWk5tNEtzN3o5?=
 =?utf-8?B?NEs4RW1EQ1FybGVvL1FHcjhweXM1T3k2KzFtaUZxMHdpRjN1YlhaNjB4OFht?=
 =?utf-8?B?SWk2MnRLcHU4K1p4Y2pFZkRWU3ZiWEdoT0MycE0xOTJFbHZwV3pIVXY4bS9W?=
 =?utf-8?B?RzlHWUpzbjFhdDk2azlRZXdlMEhndVlQMmZOcmZ0UCs4YXBuQVVLSUJmTHV6?=
 =?utf-8?B?bTNjT041RDFMeENvaWZYRmozd1hmVEZJMysxMjk2Z3ZRSmgvR1ZuREdENGQ0?=
 =?utf-8?B?M1JKaWZOV0Z6WnYyeFdyRjBDRUtnNWI2N0QyYUdRM3lqemJRUEV5YytYWmd5?=
 =?utf-8?B?WWRkVDl3b2pRZUE5U2Q0N0ZSRDZUc2d6bHNxeEVib3hjdS9ZR2NzTUtPcHBt?=
 =?utf-8?B?SUV3bjVjWHY1ZThDVittU1dmYUl6U1VWRGJ6V3F1NEV4dlBYVUIzdklxbkdK?=
 =?utf-8?B?ZUltMHdrbFo3Ymg4NUdQeTVnSTQ5amlUODE3S1lTemI1ZjA3YmFrRUFoMEM5?=
 =?utf-8?B?ODZGczNqYldMK1c4UWdodFpxcno4ZHErZWhOQXVxWnJpWTN3bzFYMU1EOG54?=
 =?utf-8?B?a1Z6VFA0WEtYNWkwRUwxRER5cHg3ZG1oUkZGdUE1L2tOclVJZjNWOFo4QVNK?=
 =?utf-8?B?WENwcVYwL21LT2QrYU5XblpUS3BMenJrMDFKbWVlaHFEVGV5SEFlS1JYU1Fq?=
 =?utf-8?B?Nm00TU1XaEFmVDJaSXRVME9iRnl3VEwxU0hqZ0U4TU9yWTlTVUh3WmVhUjV6?=
 =?utf-8?B?NXpZSFJiNm8yZFVqT1QzcXR2SURzYUs1UXNOSmdvdGpsRHZpQWwvN0VISjNu?=
 =?utf-8?B?TFp3WGR5T2dtYjFpVjlYY1o3NlF1OU9aZXFNUEZHbXhXU1hxdHIxWW5vQzZM?=
 =?utf-8?B?U2NHekE0cjNLdmd1TlQwQXBOc2NLcHBhWkJ4SDlUejNQSXJnNWJPMDE1VHV5?=
 =?utf-8?B?aVJ2akw2dGVZQkRTWEp6cm5LTHFETFQzRk82UEowclNrbmR0YkVqenp3Vnc3?=
 =?utf-8?B?K3g3V1kzenJEbGQwWWowdVUrTjAvNnhNTDRSaE1hRC9tSDdJbmxrTDdEQWRI?=
 =?utf-8?B?amQxZWdIMDB2Z3QrdWwyUmVmTlcyc3BiZVgxaGZyaHVBQno2OEh5TnNUc0FT?=
 =?utf-8?B?K2d6NEgwbkw1cFE3OC9aMmlXSFNHYm1kZXVDbExOajZkVjhPQllFSmhZNWl6?=
 =?utf-8?B?azJwMEFvY0duTHJOcjh3Y0hoRXNkbkJ0TEVuOXVYWXpraFRaVkU1aVM3aXho?=
 =?utf-8?B?QTYvamx0bjM3aGMzYjI1MjJPSUVhanNxVFJiQXhoallYbXMybU9TYW9ZS2Y3?=
 =?utf-8?B?OGNsUXdoNkxjSlhuLzVlOHJLS3BteGtqaXBnRjM1SXBHTVhjamIzbWdLMXk0?=
 =?utf-8?B?Y0ltZDNWaE53VjNhZmIrbmdNUEVQNjZPSXUyWUwxaUpWVUFpUXdLWXJWSkRN?=
 =?utf-8?B?cG5xUTJZTnVhV0Fob3dyOHYza0ViaVB4SElsTjZRWmc4Z3dJVGMxTkQ0U0M0?=
 =?utf-8?B?cVdlRE1oK05xb0VQL0RkSERhend2STlCbERPaHdPNVRoVERXZHdJemtwMFNH?=
 =?utf-8?B?b2NveVdLdTgyWWZLUVJMN0tFeTRTd2p1VDk3ZWhLS0NxeXVsNlZlMjFNUTVs?=
 =?utf-8?B?WHpNQTZ3M1EyYkVVdGVRZW15NVMyUU9pWTNndVd2YktEdmJkY1BDT0I5RGlN?=
 =?utf-8?B?MHNnZ3QzM0c2RW5VUFdQcTFkN0hQcitNaU5UdHJkT0ZSRkFJaDJ5Q3YyWm5n?=
 =?utf-8?B?UERPdjUyeXZ6aERjdm9NZUVTdjZBOEJRcHhiR1JxTEtjT1IveXJRdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c1b498-20d9-4dbf-e094-08df39aef464
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:49.8068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RswWTsXYQ6BSb9omht03MK8hmtVbOrH715zYb0uJvjJJWsZddlur6o0j65bMY4Qfn5lhCEEx1FKFKhxCUdZDkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9864

Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
enter Hibern8 into ufshcd_dme_check_tx_hibern8().

The HiSilicon and Qualcomm drivers currently implement similar checks
using the M-PHY TX_FSM_STATE attribute after PHY bring-up. Move this logic
to a common helper in ufshcd so it can be shared across host controller
drivers.

Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
their local implementations. While at it, normalize the "TX lane failed to
reach Hibern8" error path to return -ETIMEDOUT instead of the raw
TX_FSM_STATE value (qcom) or -1 (hisi), so all callers get a proper errno.
A failed TX_FSM_STATE read that completes with a positive UIC result code
is reported as -EIO. This is an intentional, harmless change of the
returned error value; the pass/fail behaviour at the call sites is
unchanged.

This also prepares for reusing the same M-PHY specific Hibern8 check in
a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/core/ufshcd.c   | 97 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-hisi.c | 48 +-----------------
 drivers/ufs/host/ufs-qcom.c | 42 +---------------
 include/ufs/ufshcd.h        |  2 +
 4 files changed, 101 insertions(+), 88 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d4addb7bdf7b..2779cbbfbc70 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4494,6 +4494,103 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
+/**
+ * ufshcd_tx_lanes_in_hibern8 - Check TX_FSM_STATE of all TX lanes once
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ *
+ * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
+ *
+ * Return: 0 if all lanes are in Hibern8, -EAGAIN if at least one lane is
+ * not in Hibern8 yet, or a negative errno if reading TX_FSM_STATE failed.
+ */
+static int ufshcd_tx_lanes_in_hibern8(struct ufs_hba *hba,
+				      unsigned int num_lanes)
+{
+	u32 tx_fsm_val = 0;
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < num_lanes; i++) {
+		err = ufshcd_dme_get(hba,
+				     UIC_ARG_MIB_SEL(TX_FSM_STATE,
+						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+				     &tx_fsm_val);
+		if (err) {
+			dev_err(hba->dev,
+				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
+				__func__, i, err);
+			/* A positive value is a UIC result code, not an errno. */
+			return err > 0 ? -EIO : err;
+		}
+
+		if (tx_fsm_val != UFS_TX_STATE_HIBERN8)
+			return -EAGAIN;
+	}
+
+	return 0;
+}
+
+/**
+ * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ * @timeout_ms: overall timeout in milliseconds shared by all lanes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+				unsigned int timeout_ms)
+{
+	unsigned int i;
+	int err, ret;
+	u32 state;
+
+	if (!num_lanes)
+		return -EINVAL;
+
+	/*
+	 * Poll every lane until ufshcd_tx_lanes_in_hibern8() stops returning
+	 * -EAGAIN, i.e. all lanes reached HIBERN8 (err == 0) or a real error
+	 * was hit. A read error has already been reported by the helper.
+	 */
+	ret = read_poll_timeout(ufshcd_tx_lanes_in_hibern8, err,
+				err != -EAGAIN, 200,
+				(u64)timeout_ms * USEC_PER_MSEC, false,
+				hba, num_lanes);
+	if (!ret)
+		return err;
+
+	/*
+	 * Timed out. The poll helper stops at the first lane that is not in
+	 * HIBERN8, so read every lane again to report each one that is stuck,
+	 * together with its TX_FSM_STATE.
+	 */
+	ret = 0;
+	for (i = 0; i < num_lanes; i++) {
+		err = ufshcd_dme_get(hba,
+				     UIC_ARG_MIB_SEL(TX_FSM_STATE,
+						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+				     &state);
+		if (err) {
+			dev_err(hba->dev,
+				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
+				__func__, i, err);
+			/* A positive value is a UIC result code, not an errno. */
+			return err > 0 ? -EIO : err;
+		}
+		if (state != UFS_TX_STATE_HIBERN8) {
+			dev_err(hba->dev,
+				"%s: TX lane %u stuck in TX_FSM_STATE %u\n",
+				__func__, i, state);
+			ret = -ETIMEDOUT;
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
+
 /**
  * ufshcd_dme_rmw - get modify set a DME attribute
  * @hba: per adapter instance
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index fb44a776e9e7..b84075dfe00d 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -22,50 +22,6 @@
 #include <ufs/ufshci.h>
 #include <ufs/ufs_quirks.h>
 
-static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
-{
-	int err = 0;
-	u32 tx_fsm_val_0 = 0;
-	u32 tx_fsm_val_1 = 0;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				      &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == UFS_TX_STATE_HIBERN8 &&
-			tx_fsm_val_1 == UFS_TX_STATE_HIBERN8))
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				     &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-	}
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-			__func__, err);
-	} else if (tx_fsm_val_0 != UFS_TX_STATE_HIBERN8 ||
-			 tx_fsm_val_1 != UFS_TX_STATE_HIBERN8) {
-		err = -1;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
-			__func__, tx_fsm_val_0, tx_fsm_val_1);
-	}
-
-	return err;
-}
-
 static void ufs_hisi_clk_init(struct ufs_hba *hba)
 {
 	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
@@ -224,9 +180,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 
 	/* Unipro VS_mphy_disable */
 	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
-	err = ufs_hisi_check_hibern8(hba);
-	if (err)
-		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
+	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
 
 	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
 		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index e5676b86de23..d53ead8e48ad 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -413,46 +413,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	return 0;
 }
 
-static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
-{
-	int err;
-	u32 tx_fsm_val;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-		if (err || tx_fsm_val == UFS_TX_STATE_HIBERN8)
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout))
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-				__func__, err);
-	} else if (tx_fsm_val != UFS_TX_STATE_HIBERN8) {
-		err = tx_fsm_val;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
-				__func__, err);
-	}
-
-	return err;
-}
-
 static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 {
 	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
@@ -638,7 +598,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 		break;
 	case POST_CHANGE:
 		/* check if UFS PHY moved from DISABLED to HIBERN8 */
-		err = ufs_qcom_check_hibern8(hba);
+		err = ufshcd_dme_check_tx_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
 		ufs_qcom_enable_hw_clk_gating(hba);
 		ufs_qcom_ice_enable(host);
 		ufs_qcom_config_ice_allocator(host);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index be62165b785e..09ad11f7165f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1505,6 +1505,8 @@ int ufshcd_make_hba_operational(struct ufs_hba *hba);
 void ufshcd_remove(struct ufs_hba *);
 int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
+int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+				unsigned int timeout_ms);
 void ufshcd_delay_us(unsigned long us, unsigned long tolerance);
 void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk);
 void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val);
-- 
2.43.0

