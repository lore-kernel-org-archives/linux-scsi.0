Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844757;
	b=SBJZORiiNTdvrBWUFY/e3l4AhED/IUpdOl/Owfo0JSKBKjgZT/Fe9XxS9ihq/1QV1chj
	 Wfr+S/hW8RtPz7aDTSEF8K+VAdIPL5gRiuYx3PWr/pwoK0aAHMMV3/M7pvbBl9JefOCGk
	 sZDMrVBzCXMVJ/ydict3VTey2qfQeQU3y/6uHVxkIJ0/AQ37M0WyYtutpCE/I1SiJpALv
	 fhoVb3DGOxX47gbOpC/C7lso4FMzEDWFaZmFQKvspfUU+QoDpv6En3gvFhs1hPx2IHMDD
	 lgCMF2FdmVi9XCDstRnp3Rq6T8Bg0N6HxHXEF1jAOlwiUBLYnjjoLL+KFIxyxGDMklQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844757;
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
	bh=ATEJBQ3QKi6p6vij2hODOpt/Cax8Wa3jHEIgW8thTfc=;
	b=WiuYKiNPbxdyun7PBCSrTEwhN7Vz57t92xhn00axN+r6tP42xRInsb1As8tcy7IT/BQm
	 OwGeTLjHr0viXzDkd2QSQUZAfnCQPjDEfcY4h4E42BxW4KJ2Xjvdua5c3Fj10hmgeLQ1Y
	 Lp8uOAGlA4ZH2X5tc4YLnSHzbBRlimsLwmJp7DFvPTwG4PSDEnn8CBR3I9TN5gt9XiFgY
	 792m8V65hl0ykR7gHOMxea64aIxX0Rt4INt1xQHRO5ZS/q9fwkAsmGcxcZbx4cyi9UNVw
	 97MIf8EfzrMtn7wfB5CVFDJ9GdgTiBsUu8051CLk5MwQ8WB+zNSZNMcrBLQIvWiRLdA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=IZOYJpCu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.59
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011059.outbound.protection.outlook.com [52.101.70.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5120D606A33A;
	Sat, 24 Oct 2026 12:25:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5120D606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=IZOYJpCu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R3N4/YuAd7fNN7IrDus2zrTaAE7BErpb7ZiqQ//7b50THST2ChQ3uBtebxRKTTCh2q4YoY1t14OphgXo1Re42XRDuUGgR8WdXEUuS4FvXizlm9am7uuFgtHPZ+EUEOdC54uEHlofpOaX9MampmKZafPlvj9BACgg06nk4wY2SHGbrS+yYQu+nUHQ41jYl0ci7eThMxRN8/gEg6ABGnpo1gx4wSt6zdmjX6lWq6PfDVQFgUtxEoMNQQurmonyTjB9xyi1aH/qeoQQ4TwGf40+VzHNNABA0llURbACleR4wYKSPkWjAsRYgRKP26CfDaH+NO81CYPj+WPT4lwUzqze5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATEJBQ3QKi6p6vij2hODOpt/Cax8Wa3jHEIgW8thTfc=;
 b=l3P4SbjjmfA4EqZ9w3w6DfxOosmkKqI9Wb0QuHRsZOAMfpYe19ouBGdxUSnUIiHUq8c0Vcw3d+seLsQBSOwR0r4kBDdL4a0vW27Q/ivpEYXAPOamzG5ZGF/LmvCvVYJpTwm6JMsvBf5rm4C+Ah2XtHuMC+2rJEwy1Fk9GEt2GUyk4Tbc0m6MUUxEf697z5p4sgCjoL7TlF99hGbqYNekPicyulATF2T75jQtHxpZwTTzsGCBgPoZ6gWadtlL9axYB+Ar+B2pZu3gAMPd+twlTHF2PQzH6ns6/QCZcbkY1J9fXXIYaW9vU/4HL4YAo5ns2mzZQTIavTqAWwD2h6A/kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATEJBQ3QKi6p6vij2hODOpt/Cax8Wa3jHEIgW8thTfc=;
 b=IZOYJpCuxXo9ktwysTCK/kiNQB+lDNMQFRFSi8HijTOwWB4etzWafbK/6mfgeHMslOB8zv0imWPjiRXOSFbaJnnMfwNNyx2GUAnCafvU33yu6tCE51dh8XiPvPJi1MRaEzL30wZo40m5IiTyj7qGP52aNP8La1gQuFl00y0Xyn5Xli2mfGRCzIuPD4NH5fMuWyx1ddb5smWaMOgUc/sYl5nABKSuuxdq+jQm7yi+0VF7+arLOn/07QuUdNn8uDztHGcnak/k7AREh4zXaVMPNrZtMXX4/atN+nryXXvTLSyzNLOKslQeMal3ih71QazDIXOqP2HsfjmXd3W8VqhnFQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DU4PR04MB10338.eurprd04.prod.outlook.com
 (2603:10a6:10:565::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Sat, 24 Oct
 2026 12:25:52 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:51 +0000
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
Subject: [PATCH 05/10] scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
Date: Sat, 24 Oct 2026 14:25:28 +0200
Message-ID: <20261024122533.3609180-6-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0015.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::19) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DU4PR04MB10338:EE_
X-MS-Office365-Filtering-Correlation-Id: ce252e09-dc48-40f2-303c-08df31c9f13d
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|19092799006|1800799024|23010399003|366016|10067099003|18002099003|22082099003|3023799007|921020|11063799006|56012099006|261009223027099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 C4cjnGKqGOHc8a92FbJ7+OwQC0lL7k2EfWH4JuVLn5smmEWo1zc9pqq5K9OnQ79iKZ6JtO47CJ+4RH011bIXqItMG2+wuLROUjn9X8zgX1qXZeEdESvjzqu8vagUAHRhSDpIRpMa3JXfzjrrJgc4DkuHchPzY4H/QXWo/2lrUo+UpWscWkifd8bii1UvA0QgdE6ZZ1+SMUUlpfdWaZTFYzrPW3JSuunTYQY9/fdkScUil7IU/DIKnxYx9mN5iofhGtfTxzn6+0kVupTGhaY61kz6B7eNgLptQnz9ofRVvrnTGrS92QUI97a2b66Xlw9uMfiPUwNlj8aXbXITBe+XNoYfiMYBySOGxDkyrO6d+uGTPbPmY7xBJSL6XnGEnroDckUqEi2wGIUjwmWHXLGIqjkcVOcyUmp1EFUanDmE8wDjkLgqYZUsq4t1UrFzpthMfA3Zh99Hg894ER8gBSdapCTAjajOODA7msj1OMh14WAr8LmIzFkIQ34g7NKF16gSX2hbTdWrIpeTWfNNwBRJT/aV329RcnnbJh7ui09Yp80d/Abq+kK5XjdgcN2VBPohJtwWJsQa8C1og1zoq+2AdkiSGosV5iguaE4bNaFRkHTGN4vHOWcuRnPapJF8h9dJy62KiDAGtoRfqomS4+PTw/NkIqm61XdZDqNwi6jKJvy3FDoY/xeRT1gTRmcvvEF6/XtFbmEB6Orhu1jbTeJ+kw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(19092799006)(1800799024)(23010399003)(366016)(10067099003)(18002099003)(22082099003)(3023799007)(921020)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RFlaNloxMk96WlJ3SXJNN29LaG50ZWJieE01amU0WjJuSndSaGlHMDM1dXcr?=
 =?utf-8?B?NWF6WVAreVBVNzVEeHJBSG9pTURJcEtJb0FYRWVIVFlETkM5Z3BhOVRsUUo0?=
 =?utf-8?B?bi9uMWlHUXZ5M0N5bVZyUHZ2Sk9NWFg4dVVtK2JPLzBjWGcwbmRVcmVXOHN0?=
 =?utf-8?B?STdUeThnZnJQODMwcGtneVBnV0IwL3Zna3hhcldJQi9oK0FMSll6M28za28y?=
 =?utf-8?B?MWFKL0d2L1c0ejRPQUkyK3pZeFRsZTFtSjBVZTFMLzAvN0xwcUhTM1A2Y1Ja?=
 =?utf-8?B?RVF6cTAzVld1OHRRRjdsOWpGMHZpSXNCRUhkQ3ArbkJIVjNxSFRzUmh5Rnhl?=
 =?utf-8?B?U3AzWkhHYnRCNStzQjV4RWNIdXNaT2xuUkhoeU84TmJWV2FWL1g0NmxzSENi?=
 =?utf-8?B?T01SMGJZc09MaHp3enFGTFpuVVIvdk1NVEw4MC9NbFR2WWFuRGxzK2JVNEEy?=
 =?utf-8?B?QkgwQlRMQ1ROd0tKdXZsbVF2T3J1V3hXNzljc0xYMVhWVHR4VDR3U0d3aXJG?=
 =?utf-8?B?aHdvSEEvaUJPTE5Ua2RYRTJ1dEVjZG1XS1Jpckp1dndnajArcjFLMGVHRnpq?=
 =?utf-8?B?eXc1blY1cWtuYzhTOGh1c2JETW80MG5OM2pLYWc4aDFUb0hYZUdjUGZhb2Zr?=
 =?utf-8?B?anJNN2E0bVlpeHNSZk9WeGV2OUNEbS94QmNJL2hlbGxqbVh0d2RSOFdTdDFz?=
 =?utf-8?B?bEZnMWVCUElRQS9ndkpycDBhNTd0RXkwSU9rS2JFd05LeVZtSHlhaWVlT2to?=
 =?utf-8?B?KzNpTlgrcEFqZVlPZnRsYmlzRzg5YjB2ajREa1I3NTUxVnMvMjErcURMd2dn?=
 =?utf-8?B?VG5ORmFvcmkvUW83VnJRbjk0Y25LTVNoanc1a2dxU0lxSHlEV2llaGNFc0N6?=
 =?utf-8?B?YVVJaGgvZkhRekUvZmZ1azNnb0swWTAvVzg3VGhFa0pSTW44MmhZTklEREk2?=
 =?utf-8?B?RmEvcTN0N0kwakZBNHZJZXpXOEs1NHRJaXh3QnR2eWg0Ny84cjIzcEw0eU9X?=
 =?utf-8?B?RHN0Y1ptTk1PL3A1VzZqR3UzbWc3clNSMDNXMURIaWVKdXQrTHl2QlBXY3JG?=
 =?utf-8?B?ejZLNklHcG9pNWdVbnFLTXgwd2t4V0lndHp4b2s2Ym11VjY4WnZkdE1NVmlR?=
 =?utf-8?B?MTU2VmNZeERIODdadms1c2V5V1lUQkY1YjNOeWJReWlVMHgyS3VybVV4bG5a?=
 =?utf-8?B?UzY5YWRtMHljSFNsaEFUUnFRVmRHVDlENis5cDFxNEdSSVZLY1VrSm9DM2sv?=
 =?utf-8?B?T2pYVHNZY2NtZ050UXBvWGJuQUZvUkFrUU5sZnU2K1EyYzFJeVRNNmtiNFNT?=
 =?utf-8?B?NWJFS3Z4ZUg2V3Z6dHBZVFZFUHBXS0hiN0NlUTJPY00vZ09Cald0MlpFcitK?=
 =?utf-8?B?YzN6TkRQUUh6K1hmbXI3ZWhIeXhpaXVFT2poZWM4cVJvOEg2c3d6OUFCQjI5?=
 =?utf-8?B?U0RxTCtQcnY1TFdwa2c5eFFuYnV1a1REQzJzcmwxeGJwMytVYjFha1hwdHJY?=
 =?utf-8?B?YUlDbjl5Vnp2M095cHVlRkR1V3EyUEFLc2EyTEU2cE1NN0syeVdJTGFaZnpu?=
 =?utf-8?B?d09TdHFxTlZBM2RZaFJMRU9NY2RNZEFYTEx0OVJUVnhha1JQYjN6MStkWk9V?=
 =?utf-8?B?K2V5YXdQbFlmMnhnS01ybDFCOTBITUpaQ2V3U2QwYVFvaFlZU3kveHZhWVdQ?=
 =?utf-8?B?VGFnbHlRZmoyWTYrRXpuWndOckNVems5OWM2Tk9rSGpxZnd5SWtJSm1jb2JG?=
 =?utf-8?B?NXVtTWhsT0EzUUZQUnZVV2dsTFJGcFBhYmFGcGpTY1JJNkZvbDcxbGdhTDU3?=
 =?utf-8?B?YUVjVWZCOGg2QjNyQ0Z6WWFCby9HVEpFb2pCQ095SUlKTUQ4MjY4alRWcWRD?=
 =?utf-8?B?MFU2ZXNrYmlTcFR4dDMxbDNEc2w2TnhFVDl1a0FITkFjVzRFbkxCc2lQMXNC?=
 =?utf-8?B?TDBOVDRkTVBBVHp2VVRmL2t4cW1xbk9iOWdBdnltZ1gxdnlPaVNVb0NYY2VC?=
 =?utf-8?B?OUJSclYvdjFOemRZcVpOQ2NtZVRmU3ZmVjhNTFMrRmhZWFdmZnkwaURBb2RO?=
 =?utf-8?B?SDRiaDFMbVp5UjFGcDQ5TlBMT0VXeFR5dEpJaWwwSGZOd1hQNEZWT0M2bDE2?=
 =?utf-8?B?RTVlVkFkN25zZ3NsTTBaNkRDbEhIeHVFQUZmQ2V3d0Y3VmhJUTQ0cy9iT3Vw?=
 =?utf-8?B?UEduQkZNaEg3Q2JneFpHMDZRYllaZ244QzNqRE5CUHl4dHR6d3ZteGlXb0ww?=
 =?utf-8?B?ZXRKcTFKS0hobDlNYklDaGdXVC95WGM2SVRneEVhMDFqdy9xM3IzTmh6ZjYr?=
 =?utf-8?B?eFl3WUNvUzRQOWkxT2VRaVRtemFJbUxueDR4eXN2UzUxK3VDWW4rdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce252e09-dc48-40f2-303c-08df31c9f13d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:51.6341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CEMziULkEpV+DJ5v1BwH3rdxsyUKyUPPz65Fqf8WK5XWLfVayS1BvNS/oZn9kb8eIww5/mYeYciQCkcod3mhkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10338

The AMD Versal Gen 2 UFS platform driver carries local helpers to access
M-PHY control registers through the UniPro CREG interface.

Move these helpers into the common Synopsys DWC layer as
ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
duplication in DWC-based glue drivers and provides a single implementation
for future reuse.

Dropped `static` from `phy_write_attrs` and `phy_read_attrs` since there
is no benefit in keeping them persistent.

Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
 drivers/ufs/host/ufshcd-dwc.c      | 69 ++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  2 +
 3 files changed, 88 insertions(+), 68 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 93755befb880..38ba155ce41a 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -43,57 +43,6 @@ struct ufs_versal2_host {
 	u8 ctlecompval1;
 };
 
-static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
-{
-	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_write_attrs[0].mib_val = (u8)addr;
-	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
-	phy_write_attrs[2].mib_val = (u8)val;
-	phy_write_attrs[3].mib_val = (u8)(val >> 8);
-
-	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
-}
-
-static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
-{
-	u32 mib_val;
-	int ret;
-	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_read_attrs[0].mib_val = (u8)addr;
-	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
-
-	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
-	if (ret)
-		return ret;
-
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val = mib_val;
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val |= (mib_val << 8);
-
-	return 0;
-}
-
 static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 {
 	u32 offset, reg;
@@ -162,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
 	u32 reg;
 
 	/* Bypass RX-AFE offset calibrations (ATT/CTLE) */
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
 	if (ret)
 		return ret;
 
 	/* Program ATT and CTLE compensation values */
 	if (host->attcompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->attcompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
 		if (ret)
 			return ret;
 	}
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
+	return ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
 }
 
 static int ufs_versal2_phy_init(struct ufs_hba *hba)
@@ -384,7 +333,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 
 	for (lane = 0; lane < activelanes; lane++) {
 		time_left = TIMEOUT_MICROSEC;
-		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+		ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 		if (ret)
 			return ret;
 
@@ -394,12 +343,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 		else
 			reg &= ~MPHY_RX_OVRD_VAL;
 
-		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 		if (ret)
 			return ret;
 
 		do {
-			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
 			if (ret)
 				return ret;
 
@@ -461,12 +410,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
 
 		/* Remove rx_req override */
 		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
-			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 			if (ret)
 				return ret;
 
 			reg &= ~MPHY_RX_OVRD_EN;
-			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+			ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 71433b4d04aa..20b7174e9498 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -144,6 +144,75 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 }
 EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
 
+/**
+ * ufshcd_dwc_phy_reg_write - Write a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: value to write
+ *
+ * Write a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
+{
+	const struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB),   (u8)val,         DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB),   (u8)(val >> 8),  DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+
+	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs,
+					ARRAY_SIZE(phy_write_attrs));
+}
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_write);
+
+/**
+ * ufshcd_dwc_phy_reg_read - Read a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: pointer where the read value is stored
+ *
+ * Read a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
+{
+	const struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+	u32 mib_val;
+	int ret;
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs,
+				       ARRAY_SIZE(phy_read_attrs));
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val = mib_val;
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val |= (mib_val << 8);
+
+	return 0;
+}
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_read);
+
 MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
 MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 0406f2bb576b..d8673cd54d4c 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -45,4 +45,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status);
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
 #endif /* End of Header */
-- 
2.43.0

