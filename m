Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012032.outbound.protection.outlook.com [52.101.126.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029A92F872;
	Tue, 22 Apr 2025 06:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745303170; cv=fail; b=t+7Jz04uV6FSpFQEgIgm05BS1ncixCMCbV9uGLzj7iPGV468KaH6PcaGaIpduV1yOhbr+sX1vRAlaxLiWiynET3I3gEGzjK7sqk4tvyYlOkxKjxH6qDSpB8mXEt6YrhLJOdj6JgvDQ0Clyn/o+d76NFc5xDEtBCOK1NsDmv8KDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745303170; c=relaxed/simple;
	bh=qyouexE1bggNLz04VfWcX7CCSmI5yHkTXF8DsBVu2V4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TNsW1n1wTnl30f2RfiqbDRlW+rcdutCge6PAFQHrN4B2hYwFozg1bqWW9HULgJ7oz48J8M3KszHuO+7R0iAAK1rlvk287M5xpQkan/wycy2nqQR0BtCCf54Fu7j8rXG4CnirMOkI0FddOMJfYfn84u87yNXddHN/dQOTRroUg3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=pqRXFUcf; arc=fail smtp.client-ip=52.101.126.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="pqRXFUcf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xe3dF9yOW+LVHIHmia+YAI0q0CT1/aM8n763gJbICcdAcuNMnwnyuJWevfUNeH2/Z+DXiDfN2U2sfjNIVCDzYK4UN2jHuiMRohiFwyo9VEmZg8zeBsK9h0d0MPxwFTKrzCuCeq4QsCACjTeU3vzPSYX2pMby78MTa2+VLHHGlu5ev7wbtdka1JjO+BWa7QaenG83/fwXcIcYVQSYcuWdMQKBz9DxIyedNreuiTm78n2867DR76Ytq4MkBTTmsNbJKB4ypfv08G4qIfgf8U+UGxupH2ibnwVDxFBNtNyb4s/xXhyNjfJSWw84peguej0uhJdtzpTOu9Z8+I72WhXoQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qyouexE1bggNLz04VfWcX7CCSmI5yHkTXF8DsBVu2V4=;
 b=i/3LH51sKFqnzGiAb8Dr0SMC+iAmbgWUXanAY24GaF+02UGHOPn86+bh4aFvMnDfU4OU5SVuDCHltVcZ3O5ZZHfYaqqXUPFsJgwRZZVMZeibiWqErdws1n5ackyoazSjShPOR//5MncNOudwdfojq7dyFfIW25gOiJyjmlt2ZIp2O2o4lGFrYAS+UmY8VTt0c550inIojNtLfaYdfdcfNMcOKUM4Tu80enO+nKuwd2m2lXU9DFUTeQAZO5hF1buKjplge8bdOOcinuJKoKA5x7+r+9KJcAuEIut4Zw/wkz8AI2tb6eyTE4O4yCwfmWMS94YOFpIOVV+fKYhkhdYZ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyouexE1bggNLz04VfWcX7CCSmI5yHkTXF8DsBVu2V4=;
 b=pqRXFUcflNNbO8Y6ofGhlWsfckuA4iJTNqI9fljh7zVGN1vcZNnebF9H9O0TmfOLgsyBw/q3sQlq2IwKPtZ72p0DaobcZFievmZekcE9qEv1D3wTPFDyi2SB+jBj5YERetJfwHb1QudRlrIJwkOLSpYYAF9tzw9p4IB2qB3os6pZsGyzbTq7P0cjZ3lxYMPeRPie/FXVmkqeQ3x8N+YcopM+eFumKw/F7nC2zJNY5P9jXkPwlqF9LKK1k2ZNpSghfpWYk46wB1nxb0vvOtVtE+Cwd86eDAOzLaz55bpj4qqgHGPXHlbGQVeCAnMqeeg/gP8yLfX1qhxdh/Z3w7cwZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYZPR06MB6142.apcprd06.prod.outlook.com (2603:1096:400:336::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 06:26:04 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8632.030; Tue, 22 Apr 2025
 06:26:03 +0000
From: Huan Tang <tanghuan@vivo.com>
To: peter.wang@mediatek.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	ebiggers@google.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com
Subject: Re: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Date: Tue, 22 Apr 2025 14:25:55 +0800
Message-Id: <20250422062555.694-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <7619479cd692a5ef8bf3bdb8424d173b774dc146.camel@mediatek.com>
References: <7619479cd692a5ef8bf3bdb8424d173b774dc146.camel@mediatek.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0161.apcprd04.prod.outlook.com (2603:1096:4::23)
 To KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYZPR06MB6142:EE_
X-MS-Office365-Filtering-Correlation-Id: 3df08e6a-7e48-4ba0-12d3-08dd81668e7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|7416014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VlL7XdybW9gmsMOwWotiO1MA+xQ05gxIneTmuAlV/9gDPH3/qPD2ootdpdGi?=
 =?us-ascii?Q?hQgpisxW69ty/WGIw/FjaXKbyy99HouDeQ5DTknjmSnF1zjvu0ZFUSMjctEU?=
 =?us-ascii?Q?honvWV+wPQsl8d9o5YGzeF3eXdUCLshSSJG9uw9TCmbFsrGvXpuvYEg4kRrJ?=
 =?us-ascii?Q?DXa0sVI8i2L5dUBpiPreOQVEFXqXb6SdNWaouYZf1vWHp5XQgg5qAEGjRCNX?=
 =?us-ascii?Q?J2+cq+3U9uXV+1dd6ZFBcgfhqafomXf/EmmmJOgaqDEflcfrFr/rAl5bDIx2?=
 =?us-ascii?Q?PEL9fa2TufGePdfRXHd6h+BGhHVOGeLwmVbZSuoWK9Syg/KiKwu+u2FWo2zo?=
 =?us-ascii?Q?Ml3sRLEUGQgWxwJ0jW8x1yfDrA8DJ1+ptr5gmV/WXpYmmli1FS2Lg+QGW+3H?=
 =?us-ascii?Q?67WWfei1h9Z7dfyesbqxzgzSDOufbETSINMe5ErdOi41za9uD3fYHSRQNJjw?=
 =?us-ascii?Q?bySBJTux3/aJJF9CJoAJaUUzpe09NEO/JnP44s+btvhkcNw2gGiwIQWJXqj6?=
 =?us-ascii?Q?RYI2QeGSufjAND/p4sewb2DWgzdH3+4k91vjKcVKviWxwfmZkW5oIKgcuCen?=
 =?us-ascii?Q?XfiB5eM1AHvnpBiNE7zRP8C1Hlp8ReEDXU6GIAHlm58NvXLamx7k/m+hiG2Z?=
 =?us-ascii?Q?CLhnwSx2W1qaYdpE2GZyP1aRbW/asZp1MhOh/QNFScFLMoVSx4kyopjJ/pt7?=
 =?us-ascii?Q?bH6dnra47d1On4Q9PB6RNVhWyFXg/8Dc4LXVw4bpsvait9q50Faib5k9io5N?=
 =?us-ascii?Q?Tz+RuddBkUgP8MDr1yUBv4XYoE1y7dEst8Mhoinvm1pIEOsNt4vAmHPhi397?=
 =?us-ascii?Q?4zq4f1+v5vCxmkWAusM4TGxnS6YVuN8aZGV0xwk3iY+oBklvY3mOsMexd7CT?=
 =?us-ascii?Q?2hWVQX8UteI8cc0L4j+n6e/rKsVyitZpFVxXgLQugzyHNNnlsagDHfbEf1qm?=
 =?us-ascii?Q?Xktvr+yiFL9rHXvXIxiXictkXlGVPFgh3MUgCftDB0qDXuXC5tUiBecU8DZd?=
 =?us-ascii?Q?APJWfCxgvSZ++qYmyYpif+JbxgRYtJFlsG1SNtzTkOj56+V/mgxYp2mjh2P+?=
 =?us-ascii?Q?T/vp/mCb5jiW6UA6rE79xxc6AnrYfHCng+P0ESa84TxjQpSW7CEEg2EHr9mZ?=
 =?us-ascii?Q?xbeBTWjLXDCZ89D3JJN1yhGbidWX8vAUT1z7CsgdWLY6ALcbfJ00mZv+fIDh?=
 =?us-ascii?Q?kSBKjtozoEK2oEN2pZAqnm78g7llI3Rlj9lovL6PE6Nav4ByrdepDeOPeBvq?=
 =?us-ascii?Q?CIm03zHm/T48jkfDBrLz2X5ab9cpiEzlrQykubtGIM3s/zLR2jrBbcHX1DrU?=
 =?us-ascii?Q?4RgzG/4PXGvjOv7J0xns/6DYrl8fCVxjlfBvs7Zy/4gv6Awovwadde3WBIo7?=
 =?us-ascii?Q?jKy4xvQ3znNHa465V1OaGjt7yWvFpGzdXMLcGgj0n0G7oreWXROGqIKHQNL5?=
 =?us-ascii?Q?4E5YSO9cAXbyhfqnIclSEXGonj47heOf0dhFgUYwmFNV3JRMQ3fxiA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(7416014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QBpoTrxx+Fn6HcACFHH/Idfy/oAH3q77ispLj2VKKPsuE6wE/RP/TDtU1239?=
 =?us-ascii?Q?mA2OdRHGcJw86P+P2gjwKhihLu3ZQgn88sngf2mg/KIxUoMGBoJTh5kmbDgw?=
 =?us-ascii?Q?Sep1UNdL09Pm2gXbSwJcs0y+lRzmmt1hyNo+QmeQKUz58YQfCnrQRXc/jjgD?=
 =?us-ascii?Q?7y+H8onltzKhiW4e7ysaVrKYEyM0728a9uO988sq5KoCJ7J+EXf3XxGJnXff?=
 =?us-ascii?Q?N9+cJviW0Y74iYXs3d6I2vyeEpVMQLs8Jo5ihhzcXIyi6S2g3787NtJfHCZQ?=
 =?us-ascii?Q?NNg2D6xsqg4mEYX0ZTAIoz/vJ0JZC3yD1yDDZwgPtBTvPBMps+jTH+vvLhMu?=
 =?us-ascii?Q?7WwfmB2hpFqAh2r0LShqizwoLL/lQk0PQi8G32aNgjcsBxhL4CVzVoip34iX?=
 =?us-ascii?Q?Y3UF8cUZMenAoNNoy2NJvAmKCcMh9kvxvCNXG5JWpcaSqJUp5EXKdC64qv/1?=
 =?us-ascii?Q?9ir5+dFkONpkCr30PbdNUDnFWWEyJ5ghcAPi3CHFeV4riB7udjke5JlpIXc8?=
 =?us-ascii?Q?HLZYKTUhvH322x6YnVbQOKLl0Hp95m7ZAmfJo+1J2LLdlF8HFvCTuD3vJMF6?=
 =?us-ascii?Q?7JPPWkg3cTDECBRiRSDQUcTNREqjKEqnbg1Sg7veCnkR52EUHFmafny1cl0R?=
 =?us-ascii?Q?OHTQX88NyAxNoJJDs1GkyemIp5pf4dflqBTONiQw7urBgJQihz5zltwEZSza?=
 =?us-ascii?Q?urEydRLct5ZgTJage/xyTPUyrKxj96cCgWwszo+UJlXZFWPuvDqSeYou148h?=
 =?us-ascii?Q?Yykjv2hQY6ejY80DX/VM6K/tNgr7+xy3L/adjf/0NItCXEzII1lIptt5Tfd1?=
 =?us-ascii?Q?fhGIfK3F9scBdVIWOMEsoC0PLxacrfy8rD5l1+AY2RTYKlyeqRaUwgCJIjYW?=
 =?us-ascii?Q?vQiZ7ahxMxQeM9Pe900W3D8Ovk5VGGsFR0rgdgvjkh16wzQZWEF5/nLc6TIr?=
 =?us-ascii?Q?aIxB7dJakA6PPrGUqSgmqtRm/zvmMR7szSCZJfZay6PIYj5aykB1qXliWgvQ?=
 =?us-ascii?Q?MFd38nmrCfJ7FYSspm1P06mvuKbRv2fo9ETzCFWJLAAU5OtBpBjYYenb6vhR?=
 =?us-ascii?Q?RYfZfX6tE2A+ZE8pqFVcaFqIWWQxYkgJ0OX5QzJo0L0n75DkEFJcT9mcoXCC?=
 =?us-ascii?Q?Yy/IcfUU1nF9x0WDFbvatm6DIhJoGR4PwLNTXAE/LC4FHaNZ01kpW1txrQt1?=
 =?us-ascii?Q?hmE5S8nUCj3+4vc3yT3eLX7ZazW+jpMTCDg2OgFDhsbLYNA+6Nh3+prqrob6?=
 =?us-ascii?Q?4UNzqlaWclM7JmPap7nZZTFkCWF9tWRXTh/ycdR5nfcKSvF2OOTmVN9Qf710?=
 =?us-ascii?Q?q/c0cCfEX1yMyzWmw/NDwbUeeM/Gp5VxL+zlRcFIu9x9Hb8Wf2UC+2YboZmO?=
 =?us-ascii?Q?E41EMiuRVT4+GtZRqFETF3c/hfKU9fpHzgnxnxcg6Sut5D4uBEGKesrDX+x4?=
 =?us-ascii?Q?zwV8jTlMXkTJ+P9f1PLPNEK8j1F6v4C4IWkbXIe97KDM6hZn7NGgmU3nSifK?=
 =?us-ascii?Q?BOvDW7d/ThNtNxgcyA2oBMA+0jG3rL35fkYibMJgkMwJPad3AglZOFCiI+BM?=
 =?us-ascii?Q?ZVKDL3D5Wg6uyGoD8gYGrZBHDnMpf97AWOSqNubZ?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df08e6a-7e48-4ba0-12d3-08dd81668e7e
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 06:26:03.8608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mXG4qTtqO7L4gNu7sK75rXcGgffK6ou2+tSd0lXrsqC+kj37nDKlQPiqa2weEwuJoslXjYBdEkgyT1EF9pYjWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6142

> This patch of only add a flag and always enables this flag. =0D
> In other words, it is a meaningless patch.=0D
> Suggest also uptream the flow of the disable flag patch =0D
> as part of a patch series.=0D
=0D
Hi Peter sir,=0D
=0D
Thanks for you reply!=0D
I found that using low-end UFS in SoCs that support MCQ may cause=0D
device latency to reach extreme values.=0D
=0D
My idea is that after having this patch, I can add hba->caps &=3D=0D
~UFSHCD_CAP_MCQ_EN to disable mcq via ufs-qcom.c or ufs-mediatek.c. =0D
=0D
Do you mean to add a caps UFSHCD_CAP_MCQ_DISABLE? =0D
Or remove hba->caps |=3D UFSHCD_CAP_MCQ_EN in ufshcd_alloc_host, =0D
and then add hba->caps |=3D UFSHCD_CAP_MCQ_EN in ufs-xxx.c, such as ufs-med=
iatek.c?=0D
=0D
Thanks=0D
Huan=
