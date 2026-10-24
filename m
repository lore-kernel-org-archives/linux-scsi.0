Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844750;
	b=yHtPBUkPQXUQE05zBZnbZkrYdMbcGLuRSbiWNXUGHJFtj6/hftJubScPmtz3kFaTseSA
	 KvDOBH7zKkrRziZAj0adzAJjdDkEYP/DMKY7HMQt8pba87dibbdf9pXtcNq/1G9QWwJGF
	 Wloi5qLDNKAN4I1BinEThvs+r8p56H+DvRqHAfeCfOzIJdmxfm72JqCFLUxgWKQn9UXNg
	 KbwkXJXkOiUGyxSkAy5j0G4yOnuG7pOgJX62yZwX+fbbQlx+FssPHMO1/rjBIHHG4NpG4
	 +S+uza7dqBURg1fLjYqgOdrD8f9DRU1o8c+IPAg3Y30fHgAFsGA8qX3kHcGWN7MYBdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844750;
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
	bh=Mt4MM2b+kEda7XeWiXcjklx11vtEoBsUUQ1dFr4um50=;
	b=OVdiW+4ZWmHxKVE3D5FgRQ++925idXbvUgjV52LZc/S2f8uDIJoCguYCBFia7vKLM2A1
	 LwWIx+B8URhLd3PGj8Ml8kwWgAxnp9JxhmLPQADvRjbJCiUXMX+rTt1i2ipWxOxXig0zp
	 hvw0Y9ArddcgsZ2Q+8eNNcVWw+ZQpQww45A75bg0RZL2wxQRjMox8CMso/g6j+i94jqB7
	 VhnO0/ivNyiVxsvn8quijalD2k6MM0XZWmiJcKfrZPZSgS2zjsfcTk/uuw+f9CUKDdjdd
	 aCiTN84JXSB0l4XBPZDdJTHTICu7nzGLlN2HVtKzYtMwGuGBG6R070G/5+WAHM/6X0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=QLOwrLbH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.69
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013069.outbound.protection.outlook.com [40.107.162.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3F1606A31D;
	Sat, 24 Oct 2026 12:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F3F1606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=QLOwrLbH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G/lMBHTzcZdHLCZ3oedHyie2/daZHCkVj8ns9Xh1VvtoF810e/YlaBv4+AtP4e5b5t7RhHEjWmmBh8dDZzjZnKW7nRXbW+P3aa/aGJm+vdlpdr4dWkYX+lsdr3MyDLI+6svUtig+xSg9jJXuoclimciiAHBjcJ/etqL5mPUPGzjCDH5hRc+V+ljvTAcQlzMA+EFRU+IrVeLIF4Wm+0MlbubLKU2jAXx4iHhLqRHJHR3t/gh+iBvDkU6hMERsVPmbysMRHLkPH5pCDB0HJJ48dLbJg98OBzneS/zkUZru7WwLymQ2rudusudqcH6EwNicRc5octNWS6/8E3bz2dNVSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mt4MM2b+kEda7XeWiXcjklx11vtEoBsUUQ1dFr4um50=;
 b=cPMkl0oMzg1cI+8/buGkbpq2/d0L+4ciZqZIE2e2fMyaxD26979xQ0b8KL+ny2D599KuuKG95fr9HLayw1eYebPKX3dkfBb4Lru24z3BzTIjBtc+pcpSGvRkLxAhXnq8zyk1BH2u/oZb3zRisu0XwMjj2DvImDrkwZNrarBUWL0CkGAPFXuyLPErkXWjJ91AZ7i8TxlXD/UJH8QnnQsku1G8s2cXHLPbcrop1GbY6pvrkprl59W23uJRFCaXrtAUdF1J3Ri0TB311BjJdL551YddrLPtpyH9e5+LNXMPNaVLEEIqhQeqjMsUmPyqrcVm1KqnheTOkkSbTKTkwDrBlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mt4MM2b+kEda7XeWiXcjklx11vtEoBsUUQ1dFr4um50=;
 b=QLOwrLbHbjL8r+b3XsTuPiQdtrl59GwnCpfdMeebKV7eBZ4pD/d01LQdn90TWKQiXBSBGtoCi6kJs7gh6H+kdkGSBGE/OzE1ErlS5frZuiWulO8JpB9gvLY2m8N5EJbuoQfENRuI+v60j9Edna4aLmRy4uwAZRVqyE6KEhDOcxhHfASBs8ewZDq7NSgWdprfAtnOE1+4/IKt3vgRzQXr8pR2KKlus0LY4UmvT4W0ECHL5Yu/S7/Xp6kTi9bZL6u9qN49733BBeqkpfB5/Mhnks0Zuoa7MMMu9n5ToSKL7lzxRUxFzFgcYU2AgnibtzmO7jo+hOQzj8O4TkkbyZrEmQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by FRRPR04MB12572.eurprd04.prod.outlook.com
 (2603:10a6:d10:1d0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Sat, 24 Oct
 2026 12:25:45 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:44 +0000
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
Subject: [PATCH 01/10] scsi: ufs: dwc: Return a negative error if the link is down
Date: Sat, 24 Oct 2026 14:25:24 +0200
Message-ID: <20261024122533.3609180-2-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::18) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|FRRPR04MB12572:EE_
X-MS-Office365-Filtering-Correlation-Id: 75215b4c-8c39-451b-11ce-08df31c9ed1a
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|19092799006|1800799024|23010399003|366016|10067099003|18002099003|22082099003|921020|11063799006|56012099006|261009223027099003|261022105027099003|261021123027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 KCK5cSYsH3M0+py63DyTEL9wTysJFXaLjnmymvXIgBFEwguzAgalUgpbmlCLUkEycPulSheLkGKYYMxvyBlAfKFtpSImYSJ9TKJzLo6AXxz1dvmpEgFOhnFsp1p4o3ioewSQfeJswkd0dJ1iPNjDEtiQN9R3yc12/8vB1eyYL4LrfSgSzyTWv4tKmiKp5o88b7sGXh5MlNQUvpANHie8jDLw5hczvE9YF/eCuu/IV2Q6aPo4LIDo6OoSpSC/y4twzGnCkTMlRqjWuGSMkeXRuxItAZKu1qJzre0XbKu5DfF0LK1PrICUJkj9arpTLVaNJ1HeCEBSTz79b2NQ2UgOZvNT8XQvIyrt48aAT4JfB00YsOzmEKMDxfpX+8Hr8Ie3I2jcUO9LjgGMBQj9ElZvD9+MwHxmqsLSnGGU/OpuPYN0qyP6V68U/p4nAcDAPkI4HfxNQNpneSJaM6qKJIruFjPfpZDwLfhaeUmc/7BDIEuaIQ3TPDHNYHs9XdA5ShFVpIAPJtkXtkeDC+d046M1lovsT4OGs1fhJrvuof/hX6KVoHbKALakyrdefSD5KnJ9xEc3qvQmrGS3RWsgBbS8WCsgy81/oyNoRyXcBPlwNkhpGql4cd0ZGDO5k2cFwBtOGlKjV2AkDyf7nPFWflsY2fv6Ge4cogjCP9RrPm5Gddv+OF3DzgzipydMZ2Ai+YaTALuMmsaqU2sCgzJ3ANscZg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(19092799006)(1800799024)(23010399003)(366016)(10067099003)(18002099003)(22082099003)(921020)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261021123027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bW05cDBtd0dFUEtVbEtZS09hb1FlbEpMcisvLzczZU81eFN2bE11VENUTFF4?=
 =?utf-8?B?SXU2dE11U2JJM2JPRElGUDRxaERXM1UwY2VJOUF2NUVKeFlFUEUvQXR6TUdN?=
 =?utf-8?B?WW5GYm16emdsSGNQVm94ZU5lNDgwWXJJR0ROQUlzRWRTejNWcDZjdU9hRTUv?=
 =?utf-8?B?aEF3RDEwbm14ZVc2dkZPb0FzUFVHcW02Z3NjZEFlZ2oweUdyU1FFU0xuRWY3?=
 =?utf-8?B?OEp3eUhndWVYT2s3NlRhTHlvTUUyZzF4ZGl0SGpaOHpCWVlWR2FDL2QvcWFy?=
 =?utf-8?B?L1RodFVLZUpKOWoxbWNuOXNjN2ZyNzFJSysySVlSRXcza3RpVmFDaDROSWJZ?=
 =?utf-8?B?a3VLTTlYcU5vd1VUZ2tOdnhyRWtMMndUUExmbkFmNE9neTB0azJRSkxXU25Q?=
 =?utf-8?B?NkM0K0Z5d2ZlN0RVaDBGVWRJL2hjcHRJY3BPT0ZNTE9IOHpFeEJyNC9FZHU2?=
 =?utf-8?B?eTZNSnJCMVdvZnpidEVSY0EzMFUzNGorRnB2aXcvR1ZQU1BVeVNFR2E5UTdn?=
 =?utf-8?B?c0RQUHUvOEMwYjdrM3dybHhBRlVWQk5STG9HZkMra0hqZ216clZBdlA2d1R2?=
 =?utf-8?B?YVArWFhjY3Zjdzd6VnUvNEJwb3dPaWVLcVg4eFA2U203S3R3Y1VBaTZBNjdD?=
 =?utf-8?B?VHZZM1ZDSHZEMTFlVzBCTFZjNlBEU3NkU0Z1T2FrZVUzTEV6K0dDZXhGclNW?=
 =?utf-8?B?eDYwWHJjSTl5d21DSnlpdGRKaEIwWUlXMU9xQ3BRTmpyeGpyM3FseWZOMENL?=
 =?utf-8?B?K2U1MFNXRzBqa1QrUzN5M0xYSW5LL01xaTJGV3JPYmFNZUxCNzVTaDRqdWZW?=
 =?utf-8?B?K2krMVZ2VDFwQlFSMWdkTWlTV3JNclVzZkd5UiswbTluSFZubDhEcGJXUG5a?=
 =?utf-8?B?ZjZNNjdCcVhKWDM2RTA1NEtLNkZRd2ZOMGxCNXcwWmJUemVWMm4vTEd2bGVu?=
 =?utf-8?B?dDhwR1ZBZ1RQVmxRZGh1akpxUkRRcld4MjIzZE91cyt5OGoxQ3RKNUpUTEtJ?=
 =?utf-8?B?eXYzNXdwcTZLVGE2NjRHOEkzMnF3Ky9MVXBjWjFMVXlvNy9SWFJ2WWVlQWxF?=
 =?utf-8?B?ZUFqQnNMbWV5blpTR1g5VmwxUUZHaTNOSkVLcGNYUXlIU2ZpQ3N2bTFHMDk4?=
 =?utf-8?B?SEtoSUhBczAydHlWK0hUUm1nZ3Y0TkwwRWkzeXZvOWdVSWNZMXYzRi9IRkN5?=
 =?utf-8?B?cDZoaVNOOGpXMSttWXlQSlBFc0hJbVF6WEhwWE9kalZvdkxhWmkrcGtJdCtx?=
 =?utf-8?B?Ykp2R3B0eDJGaVllR2xCZE5KOWJ3eUV6Q0g3ZjNBbFp2TElYa3VEYjZxWjRH?=
 =?utf-8?B?ZEQvM0JTODV2WTBNZFBHemt2Yk9PL0FpRkJ4aEtVTUJRVjV5K3RMeTB4R0FG?=
 =?utf-8?B?Mis4YWQ1SmJQN2dPdG5FWEY4S3JRZ0x6TzZBSzUwUjZPRGM1c3dtK1VXY3JL?=
 =?utf-8?B?MmRzRjVkcDZIUnNhdzU5N0JISlh6TWJnR2k2bmdNUzMxekdtdUZZdFMzQmI1?=
 =?utf-8?B?VVR0WkRuU2FCU1JRckZOa3dIQWRIeFpzaXc3eFd3ajZ5ZWxHSDZBRGQ4Tm9V?=
 =?utf-8?B?S25uWG9GMXNjeFl4WXBGb0dqaG51VHgzQWtnNUorMEtoT3R3RzRGN0UrdHEz?=
 =?utf-8?B?eHNSL2R5b1ltR2JWMmpKM2t6QXNFYkw3N0pjVU5INTFUcmxCSUZBRis5ZFBr?=
 =?utf-8?B?SUxBeUVOTmk2Q3M3TTlXK0pXdFJkVWtFRlp5MS9BcllscEM0b3hJenAxb3l6?=
 =?utf-8?B?UXBPbnJ6OGFVRTdISGpxaVQwUERYU2J1ZXVnUDU1MlNmZng1R01uU2tYWGx5?=
 =?utf-8?B?VVBzSmRyc0s3a2VOdGxzQ1ZMQytMejRudStCR3VwOXRiS21HdmErY0ZXUXo0?=
 =?utf-8?B?WXhIL0tCdkh0d2UrZGFkblVJQ1J1YTJOYXZyUDhWSE5IdlBudHN0blp6c2hu?=
 =?utf-8?B?b1RqSmQzMTN1K0NkT3JoSjAzbTk4REpCL0lUMmlqSllicGFORFYxV2crbUhX?=
 =?utf-8?B?QUI2OTVDNVc4SjFDWTVuZk1WZ2ZnQTlFVUpvMmlqRVdaa1dRUFdRMjgwMEZt?=
 =?utf-8?B?NEs5Q0s3bWFnckcyQ25ROGk2OHluWnkrcXJZc0pUOHl1d1JZTGZ2ZDVBSXNF?=
 =?utf-8?B?aVROa2ZjUXpPa091blUvSWIxTXJYTW5hR1pnakNWVFlkRThXTDJ2VE9yK2V1?=
 =?utf-8?B?Vjduc3ZwRmZwSkhNbVZ3VmdxNE5kNEhpUnZ2aWpieVdGWU5QL1RMK0ZKaENr?=
 =?utf-8?B?ck81UE9pWlBiRmVJeGxJQVh2cWxLME92dkJnRWdOcVVTMWJYZGxESXBwZ01G?=
 =?utf-8?B?bThoNHVwcWFpWEJJWlVBRHlvckFHbEhGSzRreFFqbUFBa0kyY1JqQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75215b4c-8c39-451b-11ce-08df31c9ed1a
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:44.6700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6GwfuPxkJTDfK53ciBQ1GiHnyZtSOlucZr0OIFsmNE5hon1GBlzXF0FgFno0KcBkMTn/4eiQCEiqtj9auAXfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRRPR04MB12572

ufshcd_dwc_link_is_up() returns 1 when the UniPro link is not up. The
value may propagate through callers that expect failures to be reported as
negative errno values.

Return -ENOLINK when the link is down, and report a failed
ufshcd_dme_get() as a negative errno instead of its positive UIC result.
Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

Fixes: 4b9ffb5a353b ("ufs: add support for DesignWare Controller")
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

