Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844767;
	b=y7bssn4HkYzaJmPHdLTSOF5lY0fzoPYPV5dQHlgoOAUB8bAH66XK28IJCPNpKmZ7pu4Y
	 zoS3sByAlqHTidph5rPTSWLmK6za5hoPb+ovICTMdoQRvF/zGTZb6/qd1ubX4wlqw9hzY
	 IX3C7ET+JfdjStjaqdsRLOtWmEJL1MBUEnaXijL+7MT4b7/EnQQ4UYt1p2HgMEDRvmHaD
	 cgNmjlW0bWzyiDAnUS6ryw1SzxRUv6AW7bCqANRjt2ld8nEklhFwo4/uB973mSwYW4yer
	 ttU4qYt9HbbpAnazihiZKOmHnRaEcDyZ8JYHm+2X7TnipS75hCbt2e/woJiwR47tMlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844767;
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
	bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
	b=WUL4H/dzvEhVzXRdgrDtwa5tReB2stTpsoFz8KyxGDlndM+3+NlmHTZQAzfM0+mwf6Mp
	 gAU841Kv+PweyhPAiIuHd0EeYqzzuIpaz+MbsJrYqVYipl0AV0X+tEZet9vTFMcUZwQGh
	 OMso9skoaqYroxtH6VF9QupHN+tbK1UM6WF9rA4nZMwU/WCq9Yco545oY/62QeCW37YZb
	 EW2Q+60kNKHuQTviW2WSkrrq87drqrFNU1qj7TdCr04EHlXQ+praX7vPL/DsHXi62iVM8
	 LuLUJM9IVzqG6oA3wVpsP2ska5kkhlYH+Pc68fvlplu/Jll8g7k3h9N+QnAJOGbXLeA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=ezbokuLg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.57
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011057.outbound.protection.outlook.com [52.101.70.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFA560A262A;
	Sat, 24 Oct 2026 12:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFFA560A262A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=ezbokuLg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fO88CFwVAOcipKVtYEzBg39xBuPAQRwgbJBGPnbmDmmnV+x50qfSVjNOIvrFMI3hcX8Bf222l1V+lfdRHRQQomKhkpln1az+ROa0XXwb3k8vxN5a2lipiDT++jVOBb/QajMFUNiLFeFF0eFJK2Bs32ODocZaZn7BK4fSGyKWHIo2FZskF8V5fsBtRYzc3mwplZMWJZfASxOah5GmdeG3sJpF7jnP8DgAY7gbXoNtCR8joINFjNSEYNcE4sJKRnY7mKvED7QkhjgY+wudv2onZ3gJEAlZ3d1EXQYro915VSzzpTL9qOpqRIt4i31M/hyQH2BKc4HvG0O+etq7pTZ1sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
 b=u288++tNa1US+Eww3SKstkOktlq9Ct+eW1CYg8i6A6kG0m031NbCESOX9rGM0M3scRaeObR5q1ySiD+NykKNfX6T+XvHBrKSbXs4QydBi2R69aJ/d9SDIBVTrHtHvqOOhSW7DrWEbz4g1XC9ZccYMqvxlIH9A8dP85XFPXw6t8zaWSLNEr1Rw0CI75hRimNCM7VZlNnNPxGNjchYEnHkTTRja9Et863aHO8nwa6VLcOyKKll+Vrz4/b93SlczPMl8srdFPUpwow9x+YVJYoSqzIoPKQHGl0t/bQ/fbgty6LwzA4jQF7haqSicDObDrMqhJzhpIm0d0ynq1XqS8F1PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
 b=ezbokuLgxUm3aEfktkeL0+klmXljclq089GgAehDsblxu/lgEmjwt9Vmskk9mQv+BVgMrap3OvXtVtoRt8A9njcwBf+TsFg3ItMcrGrsLS9cIQjDH1g4TVvCNLScdS3qcqFpFh6qHy6/AqaLND22AKBYAN84Yxf1QVH3DDDI+6Y1u++2p2CvkRMdZMfPf+RyYC1MpnRFzHVcNrzp0l7X8KMuKxS/KDmVI7CSfiAHGjU5v6bWrfeEXwipP4hSyMMN0jbE71zD2LLnZF6WWD5ppjzJ7k6F2Pv8AMNlX4mEkyRE33mRki7Yj1+GrRR+Fz6IGrExB+TTINKp/NC4lP0NxA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DU2PR04MB8583.eurprd04.prod.outlook.com
 (2603:10a6:10:2da::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:25:57 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:56 +0000
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
Subject: [PATCH 08/10] scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
Date: Sat, 24 Oct 2026 14:25:31 +0200
Message-ID: <20261024122533.3609180-9-larisa.grigore@oss.nxp.com>
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DU2PR04MB8583:EE_
X-MS-Office365-Filtering-Correlation-Id: d0108f07-a912-4043-4df0-08df31c9f455
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|366016|7416014|19092799006|1800799024|261009223027099003|261021123027099003|261021121427099003|10067099003|56012099006|18002099003|22082099003|921020|11063799006;
X-Microsoft-Antispam-Message-Info:
 opEgxrs1eiVFfgC2lgvlBKp/3u+TG+QDoZQ/GMwfXXApl1wbQNRTDl7BFdC/bxQkZMZcUFLd+jeh/xshn/q5LiwFa4VjJen4gKLAKOHXSj86yzLVXWSmptWGsZiNaGpUkL+6byMrQMP5H2Q43NDFkdp8kn8pLAxvt+bc+0N5xDBxP1FsRz+sCR4e80Xnwr+daOe06Ok9o37z+a8MdxAqWH301J6g2yQD0Jb/+pjF8ZsRcnSHr1YaWqGZyG9DF+SaZTizGF9CWRxBzsGT6lwy7z+fkXG+gJA0p9LxD3QcIcXHqqyL0ejKBD+lZC/EY/mZxVyqPTAIZLPoUKhDcWiEeKr0pDvtjwa3Zvmr86DswC1DnW9cm2yDZcTNbbXGIq9z/oUFkiJJnjlfWoXodKv1Cu8cRSMhskpALt/pTFoPUNPGky0VUfTh77YmA1lXsJq6esScXS+77iCuxT3OfVhbBocGHsE6V7vgM6Nzz8b1FSq0F/T32N0/1NINGbBVaRPA2F3NmkLCDXHdTNrWTeh6pUG0lZTMVtkuMp1OpVrL5R2w3Dls31qSSk80nTro7d/4G1qM2A8tqAaD7hBuYTwGNtAO3RxZ2jviENH2r3EI/xjLYNx69wHKK2Ye1wU7uvDJrMhr9ULq8TxzXjkmk2FgadSBUImNqqrNj6JiWD4v/i0fHGf1yUW2Pv1Jeh6ZjRkATnraG3FrMOJMdWptVdOm1Q==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(7416014)(19092799006)(1800799024)(261009223027099003)(261021123027099003)(261021121427099003)(10067099003)(56012099006)(18002099003)(22082099003)(921020)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TU5DcnFpMG45aStDOHBBTkJKSGlOcE1CSGdML2NEQkNQYnhFRHUyVmxhU1pH?=
 =?utf-8?B?WUdXM0FCWWZ5Y2M4RmVyUUJ3QVdSdEIwZTR1cWo5MnNJdUUyNEx6Mlp5djNK?=
 =?utf-8?B?N0hhL3JHN1ZFTlNPa3FYUlRzOWVyMXdDU2krMUNjUWU4OE10RklGd3lmVkRq?=
 =?utf-8?B?Sk04dDJkcmNyc1VMWlp1RzFidGxka0tSZHpNWnY4cURnZHdQL1U0eDRqM2FI?=
 =?utf-8?B?djJ1dXRMUXE4ZW5PRjZUSnR2aUFtQU4xZVJzVGhyb3BTNEROeC9UbGJrdnN0?=
 =?utf-8?B?VTk4Y3BwSCtsUTBETmJ6QkhuQ1JuOVd6eVJlL2srV0NXdVAxNGtFT29qdjN5?=
 =?utf-8?B?N2YyRW05OXp5bjkySEdJZGZvTVFKenJJNmlEYlNPMW9FOFd1aGUyV3gvZk1n?=
 =?utf-8?B?NWxFYWtydjVVSGlsQ0lTUGZiYUhVMmZ2YnFVeXRtZzJpeXcyNDYzM3NUcjJn?=
 =?utf-8?B?MnZ0VHZGOHc4TWFnK0YvUXVIOFZXaUNrQ0lLaVZNUWdvVjZCdWZrVW9EQXNM?=
 =?utf-8?B?NzFaVlVXQ1RSTmx3L0J2aUtvdVBzQUVNbnFUSm15R3drSDU1YWt6UHJ4VGR0?=
 =?utf-8?B?ZC9RSXMxOGhBZFMvKzBka2RjWmVBQi9LUVJOTEdjREpMVURuV1cwZlJ3VjFQ?=
 =?utf-8?B?K3lva1FwRmdSem44b1hiaHB6VDkvdzlQNFRxemxCbVI1bldvQ2Q5UlhEUHVa?=
 =?utf-8?B?TVVDSnFVenZjTU9yVWl2dWlJNkpQOXFaS0dhUUFVb2ZpTUY0aDdhd3ZJaHZa?=
 =?utf-8?B?VlJwTGhmdkdUcmdVdnJlTWd2OTg0UllVbFVPcmF4bURvdnEzVEtldnZyRU9Z?=
 =?utf-8?B?RUJUYk5TcWdZV2x1aUpNZjhwZzV6UzFJM2QzTmpDQTgxYU5QQUlMRnk4QTBF?=
 =?utf-8?B?M0RxUUxEQm5yTnZpcmM3bHp4M05Vb3RjUFN0dldWOEprSEY0ZGhFaXV1bXpH?=
 =?utf-8?B?QUZiQW5QZ1QzeTB2WC9vdktJOENwN2lHMkRWRE94S1YzSW14bjd2Yy9IUUxw?=
 =?utf-8?B?NElqbXlFNGExcXdDSnptT1QyVWdjaW83YnM1YnhHYWY4bXNOZGNPL0tsVldF?=
 =?utf-8?B?TGZNeURRemU5emUvVG1uR1BrUTFRSTMybnY1UWRGTTJQb0lvbVY0TVB4RkNK?=
 =?utf-8?B?YmFFNFN4dEUwWUdzUXlMOWxPUFBJaUwxUTAyZUxWNjRXYVN3RGRSZEVnZWYx?=
 =?utf-8?B?Z3J5MGZ2Q3FGd2c1OFhvWnloQmIyWTZtREgzU21vK0JkazFZZDVDenp1MHZU?=
 =?utf-8?B?VkJoenI5eGFKVUExTTJqZS9TYnRWU2UzZW5FWStzMWx2NmZhZmpIenVjRG42?=
 =?utf-8?B?T3NDcGkrQnEwSURWSWtHS3l3aEhNZklrRzN0ZklaMXRyQ0VHT1hYKzF2dktq?=
 =?utf-8?B?cU1XRDJjZjZpdTlsaUExRzByZXpid1QzT2ZjVXBqSHVqc3p2cytVWFFFUFMx?=
 =?utf-8?B?R1VNbDY0amVVa054V1dvdFduWWZ5NUpxK2hBVHorUzRtcWJjUFcydlAwdUJa?=
 =?utf-8?B?Z3FiNkcyWnRNcnM4N0krTFZxSnduRHc1UGJGd21pc3dkTWdsQzFqOHNvM0RQ?=
 =?utf-8?B?TzlWM1VuQzhOTDhVcFcySms4Nk04clQ4c0JOSG82cmMrcXNiRGtzdmY4R1dm?=
 =?utf-8?B?WUpDRW11VzF0a05KZlRETzIxZVcwSERNQzcxbmJ4cXpqWGNFa2N2WjEwRnh0?=
 =?utf-8?B?ejdWb2trSXUzUEhSOTl3S05wcmNFa0NTWmltVG9mbHVwcE1VY1BWbHh2M2xO?=
 =?utf-8?B?djZvYmVISDVralNwaVJtOXZiUWF5NHdlUTUyQzVPSGFXdHhXZnd0VWxQc1hO?=
 =?utf-8?B?d3R0aUc1MVRscDFJYll4Wmo0WGhqTXRtWVg0U0NQT2RJdGIzOEU2Mk9HQ085?=
 =?utf-8?B?TW9oMitpM08wcFVXS3kremIvdFRIaVFtMmdZM21SOVVJZ0puMVRQMXMwaWdD?=
 =?utf-8?B?Z2RIZEFVVmlsQXdGOENrYXQxTHNJOU1ZRDRTZmVVaVpSYWVyN3l4SEwvbWhm?=
 =?utf-8?B?bkhFMSt5ZnBVZVU5cFV1bnI5b2daK1U2NGV0Z1Rrby9NWjZnV1c4M0pIdzds?=
 =?utf-8?B?Yzk2d0FaTzMzUEdka0g1QnFBbGNyUjVQdmJ0VFFUMjdBMmU3K2dPbEY3VWZ5?=
 =?utf-8?B?NFA4SEdPVGFJUm9XTzU2SE9yd2liNVRWK1Y5TGprcndySnZQMkFTR2xkRHJ6?=
 =?utf-8?B?VmtLTTM1SGhIMVVQQm9RL1JEd1lWR2lNZUdoa1FvR3VGcEpkVHplSEltb2Zz?=
 =?utf-8?B?SndGNlN2bVlhZko4dmRvN1UyOW9YMklpcDduUmU4Y1FOTXA2OUozL0owV0sr?=
 =?utf-8?B?S1JFWXJEdWc2YWdpMjMxOEVadVI5Y1kveGhRdFN4aDlNYzdDbUpEZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0108f07-a912-4043-4df0-08df31c9f455
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:56.8007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gdJdbnqegs15P4aBPQIgYxgunzYjy3nW0nfJPzbucAyvJpeF+8tFFXd0NPKpSQjFwQFQAyqPAxzLGVqQqXVJKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8583

The RMMI attribute defines in ufshcd-dwc.h are otherwise listed in
ascending register-offset order, but CBREFCLKCTRL2 (0x8132) and
CBCRCTRL (0x811F) were placed at the top out of order. Move them down
into their sorted position next to the other CBCREG* attributes.

Pure cleanup, no functional change.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 53b523ef59df..1abf2b1deac4 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -13,8 +13,6 @@
 #include <ufs/ufshcd.h>
 
 /* RMMI Attributes */
-#define CBREFCLKCTRL2		0x8132
-#define CBCRCTRL		0x811F
 #define CBC10DIRECTCONF2	0x810E
 #define CBRATESEL		0x8114
 #define CBCREGADDRLSB		0x8116
@@ -24,6 +22,8 @@
 #define CBCREGRDLSB		0x811A
 #define CBCREGRDMSB		0x811B
 #define CBCREGRDWRSEL		0x811C
+#define CBCRCTRL		0x811F
+#define CBREFCLKCTRL2		0x8132
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
-- 
2.43.0

