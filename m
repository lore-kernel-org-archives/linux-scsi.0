Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012005.outbound.protection.outlook.com [40.107.75.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6B51EB3D;
	Mon, 12 May 2025 13:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747057017; cv=fail; b=V6WUoL4d3+H7fInWjt0pjYat8aGgLpW9A6PUh8OuJjl7IuCd3m+Tt71hJ/W46AnAlD/RF2On1lFMXxdQyxKlflvDb2XiBlwNb3r5RhMln7Dw/laJiA2Dlbc6h5XSGD/2OANBHeVgTor2rZ1m4SO7hUyhDGWLXgw9XweCdPZQu3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747057017; c=relaxed/simple;
	bh=+oxB2tZdcJTL0NFZOm6e8G5iBS/6PD6gemfxmm2U8BU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q+SVtUrx2NGYdgurU8d/fgo4g3Kc1QA6c5pgFtbIink+vC56W0wPn41GhOEHhoRss4+cSYrLVZrJjHBLBSahwo5sOmLsp3/i8jhA4NykUGGvcqOw8SIleT/UUaF6qnVZY8UevrNzY1pjKHYAKHhbrfz9KT+T+vZl16W3YZ28Fxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=GLKliaNL; arc=fail smtp.client-ip=40.107.75.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="GLKliaNL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYnSYbXL3VvFgq+hoN8sT4bQv8cF17l7UqNZ8lH834z+pjdvrdY9IxmBYlDTJW1BoiHOFb5KqsWSLWG0/NaftTLgOeFy8qvY0hJaufyeKiyU4L5t9SdMWJ/xf9y+reEio8vxBCx4YOmgiWDCFccfzuLWxbluPpEfLXRosHVhmPoaqCiusecE3dH13IAmG5wE5WI8UddVZ8qCPQViE+QRKEkDfFZhq+vgfSAPrfoz1HPGUo8L2W/Yc58XUWkhVWFJGc4pqOERwrpoh9xlSkhEN9xtEdR+iaMZYLbZ8cL1HmZ057vUNQRC8QONTuXUzvEyAtdRnLLbmmMKlKQpgkUZ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+oxB2tZdcJTL0NFZOm6e8G5iBS/6PD6gemfxmm2U8BU=;
 b=g1nV/+XqAUvMfkOXd1pkQMM2MkDdmNYS0a0EvPLDdMPP2j0hfdQSPzp52jVtC9YpJ9Sk2DdJtml9G9JxM+uHD15gvvor2qP2/iP6cUAo7F14t0YlkdqaiWH00qMV2Vlu6FosxzDAk0j1ZtEoqIYxmmMfdOkmpZupFKLs0ZlBSd3Krz1GpaENJRy5/XlilfdK08tq0Wzb44sw1F8+MePEnsOTJXaKVbtHNCYH6XAqtdq+5f9ZAxPQEWbeWVV0R3tI02tfGy519+QeX5rRI8OVNZ71Bxk74MsQlHmctS6n+OjTLkBfHujMIoWF5ks81KfYzj/lyuuBeI1YFrip5DEdRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oxB2tZdcJTL0NFZOm6e8G5iBS/6PD6gemfxmm2U8BU=;
 b=GLKliaNL72F5LeNVgFqWinOfBtgy6ShDTW6t1j+/2khvFM9jX/iYoAMXwKAXoHFrBbs5gauyjzcHUOCfxgmvkfd8za/tMqGGOt2i/8zrDZtUiXPRleIWSbxNXL09pIucM8NxQxUusPrF6ezC5V7GK4uN2UELrELquIX5bO5PjTB+USBJJXz59dt7i1EEyVTI9qLODYFBASrUkUh4vj1VKx9zvv3fuTp8rqIimsf0VebuQ8q7cKnXCBQXntaqJEN4bWwhJiV0hx7AlXldlDn62a3HusogUHLH0MYb8UACTBq6OaaHbATYOAPbCrpwOC7cgMK4HSNY5boktMdvMzF15w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SE1PPF93ED7187F.apcprd06.prod.outlook.com (2603:1096:108:1::420) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Mon, 12 May
 2025 13:36:51 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 13:36:51 +0000
From: Huan Tang <tanghuan@vivo.com>
To: avri.altman@sandisk.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	beanhuo@micron.com,
	bvanassche@acm.org,
	ebiggers@google.com,
	gwendal@chromium.org,
	keosung.park@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_cang@quicinc.com,
	quic_nguyenb@quicinc.com,
	quic_ziqichen@quicinc.com,
	tanghuan@vivo.com,
	viro@zeniv.linux.org.uk,
	wenxing.cheng@vivo.com
Subject: Re: RE: [PATCH] ufs: core: Add HID support
Date: Mon, 12 May 2025 21:36:39 +0800
Message-Id: <20250512133639.238-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <PH7PR16MB6196FDEFFF1041EAD0668AC7E5BF2@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <PH7PR16MB6196FDEFFF1041EAD0668AC7E5BF2@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:404:56::14) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SE1PPF93ED7187F:EE_
X-MS-Office365-Filtering-Correlation-Id: d811fd86-a061-4453-0a1f-08dd915a0d0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uqDTBV9bd55a7WpXZ7cuaHpuJiEpQFGURrhZ1YeuJL9+oLaFvQP2E+B8ZjkW?=
 =?us-ascii?Q?5qe1ZRRvvnuf0boaoqVbt6WSeBj4XgfhuQTOk/ib0ccziaZfdf/wcb3Ase/b?=
 =?us-ascii?Q?30kw1aVOTeLrYo5PV04z8FFGJCNVszgfqZgPc1xc8CSnHFUQglgye6pINeou?=
 =?us-ascii?Q?RPUCv8xdQqDxh4+1LqxMtAZypfN0EFQtxEv7Scmpb9QjfyDd/53WcQ0ZmP/v?=
 =?us-ascii?Q?1hmy29owPC68mB25DLlRB0TeVWNGWdhEP5njGxqBoDVrvHC7Xq/AVln/kl/2?=
 =?us-ascii?Q?jlGyn28ZXkWs1sktZN34+K7m2+RS1Bt5dzcw1ZuoNQngNIdQCGHAEHE/L7xr?=
 =?us-ascii?Q?3Im6PuiGAF1ZG/fIgeZZI80IzQdLW/Wo+pnATIz+9qeIDNVmOm+sb3q+Yl4J?=
 =?us-ascii?Q?3edMXhfaC7H73N/mE9v1SvM67MSKMpnizFDMp4YHoy5iIA7TXcBH9YNsrn+X?=
 =?us-ascii?Q?/GPJm/7arjAiaqn1VEdHxOuuKx0iDcD70/g9HeOUVUXU4Uxg/rnRCJi4vtvh?=
 =?us-ascii?Q?UwTN+ia105uUB9MeHdIUj6i+VPKbP0hEi/70G3eR7dIXSP80ToZDFiWPJJim?=
 =?us-ascii?Q?r8Vi23s4U/lE9SOvl3DvNSpI1VLh9ytlvOhre9eFYQHfBVjKQVyoA8R4PlEX?=
 =?us-ascii?Q?PkLNeRhAnS69gFHpgnS4rW5/B45hYQKrVKf5RlqUmI8I76BWj/4t5wy+AJs7?=
 =?us-ascii?Q?80h/Bevf69rGTuzMulXi0eXKlpiPPRXkEfa8kWfQwdVjHD2Ch+lCwbI8U45e?=
 =?us-ascii?Q?en/MixvpWn+3Itm6NVYclPwjZHfqMdOse3b2INTDv54ue6KUlFjYg5Vq3u+9?=
 =?us-ascii?Q?WK3f0mqqEP0RO+z0QoDa1YhoHGw/ZFS8FOA7jzNGMXPk3jCAP6HxBUTTr01e?=
 =?us-ascii?Q?bYB8tzw8OWHA+awhJjBAAQeXIZ4flVbLL1vZdRIALm2ywKzYThlAVWDg1Gs1?=
 =?us-ascii?Q?kibpGoOZjxAwSRY6simEcSQ9DbS98K9fJxgA1geFnjtuKKq/qeKhd9eJSd3I?=
 =?us-ascii?Q?pnEJzYQ9yrgkutXhUdQK9DfS3/YjWeEIQPY3uzlBwFT5DNVlmqYxSyFQIRnf?=
 =?us-ascii?Q?n0C1FdSjUYmkl83+kLxjb9i3H3SlbVglzN7UbAfI+9+i7aUsHM0sujCn4Qfq?=
 =?us-ascii?Q?NCJFNnkw4P0Yx1/fs39Tnl5xVz11kib8btFahT3KA+83cId3cPRMR7TTho3Z?=
 =?us-ascii?Q?5Mbx8G2DZ2Rjj4zKcAkH8ZtY6DEy4i+NjPIqSme9TEMsypJZGd/olHvGhyTV?=
 =?us-ascii?Q?idj/bPopzrzlkacCPfpQwjBCFaQAt28+JRhuFXg2gj52OtMJXZhtM/r6WSip?=
 =?us-ascii?Q?1Wf5jK7qrjJN2Q4XmXHRJMxU7YbaNrFvK1r+XB4oma7ME37arFp6CKHbofWt?=
 =?us-ascii?Q?zrLshfShPWHrdxN0R0xomXFtWkYmGtsaAlUixyQIucK5un7wd5GErCIdKCmF?=
 =?us-ascii?Q?50Tk1nHCV5/TlvdhGQxJuvu2qYAa4eZZnug+6m/DN+3LCyQUnM+87bkpB+Lq?=
 =?us-ascii?Q?SIpEXudpbslVR04=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I7b/66g4b4alJFpRl/62esxSYEffuTsE5osIWXAa/ner7xXjSlMsapyi/xOo?=
 =?us-ascii?Q?1C3SW+Z2zp4EBgRDsQWkkCrsSg8fgWiwHdGodH/p6ZQYzoNTKmvgKlPZZwJi?=
 =?us-ascii?Q?RUssDfH4mfLawUXdDi3F00RSInryJr0hBm4MbDANxOyGBG2PsDHH7ozUQJXc?=
 =?us-ascii?Q?GTzE/jOIjEP0fMvcuThPz2V5PMmZvu1QWLnyc9UkeHQGzyNuxJeFsk8o7TuD?=
 =?us-ascii?Q?Fyg92gm8N8cPSMmam/VzW6Pd2j2xAHZ+LMHuhXX/86D5nc/Lio4AEY4hewRH?=
 =?us-ascii?Q?jk/nPGTo4CHcgv5CTePSx+h4T307GUgdDfxHiYYcsxM7mP0yKuDByuyqQ0fZ?=
 =?us-ascii?Q?RyS3sYjxfCF29Vo7o/qHbfOi5yzR7njqFIVtabNCU4GAHixGcupJiTAXx9B/?=
 =?us-ascii?Q?PceawXS1laBTmhbDDkFGFIiKcJ4fEEq7vhZlicuaU5UnIvbzjOgbsTo5yErZ?=
 =?us-ascii?Q?9C8xuhz2PXbOOwKyIMppXwRtRWnCFbmewyIjuIwSrS0sKLETaj1k8Gjl9zbh?=
 =?us-ascii?Q?5EHS3yWj+vA2HEbA3dfXauC/T7/goPhIK5ltATNZknUDqQdUxmJEWieftB1O?=
 =?us-ascii?Q?uiqdt/hgCY5jDR7quA95LAsRpAAPJvE3j0J+CroIZ7B2L2sTprOiCtJVcWeW?=
 =?us-ascii?Q?nGAct6t6C+CiROnZHUNMwTzd9FnFaEbjwFxLtnmc97Nb+tnm8cNbjJII9U0C?=
 =?us-ascii?Q?28LqYSpm03yjmKfL9sv4p+zkW+w4ZjQjh+QrCCP8zyB0wZL7EwSmzBZ3yTAL?=
 =?us-ascii?Q?Aa/E/i6opwWgZvEo1VTEqWOGKsm8keqKrhtAy2Fb0lwvGsHr1COXa/VcAFw0?=
 =?us-ascii?Q?ko8TwqFliBVoL6+TFyy/w0l/RG2+Ohky8uj9cAJvGxcL7GP/AY+Nh5p7bJuR?=
 =?us-ascii?Q?bckJG6GQW1EKPPUkmQ4mNa6kxI0i5QUDPRbNiRLJW0Ybf9FSCnSM/RnsTF03?=
 =?us-ascii?Q?+ISun1mvrFB/V2BIqkFaFPLtlY5lbXfPKdaH4lU728vLN4D1F6RuTm0exIil?=
 =?us-ascii?Q?PI1GyQBvG7KtEVskGtJ8Ih0YpdUaDawSXSKZKiik0uC8A/qAUNDfRR4TNUOO?=
 =?us-ascii?Q?E17z8iRxTv8iPCCXdW0UCnaaNON3kjSMHwj/NothRD+K0nSpaWD9qLPSn0SK?=
 =?us-ascii?Q?58PyPuj51wQQIN/xupOMrtiHBChb/xzBzgDnjVt0QZyXNXGqVf2opygSjCTL?=
 =?us-ascii?Q?DpMdanageGl//GNrsBpo13sdZEEFo4WUJOj3lHSl4zN1e+/5KYWLGXwEEXPa?=
 =?us-ascii?Q?uLzJZr5/IF2TFD6WW292wzdx9m7WXsfSUAMeyORtpgwy/cEdKkw1YAv8mUFn?=
 =?us-ascii?Q?rubEfQmhqIASIrzEcvgahxvjEr93Pw4b7CIAQK4iFNNmhMlIEn90YgpBqfxT?=
 =?us-ascii?Q?lhBRiAmVHIYv55gU7GIso5oblaUQBbymjs8Y16Bvdl+VxP2FiEzxcrxXlHYm?=
 =?us-ascii?Q?LZNsJbltUK/8KehG/kb7jMnT7n3h+CX84LwKXp84hQzTJQIAGu7ZiAjfpjhc?=
 =?us-ascii?Q?j6Li7u62/WoNsIs5UwZcHK8kLeVJ493n5Z4gS0voQn9liIGUQ1Rgnn6gia+t?=
 =?us-ascii?Q?Ba5M6r3eZnQZtgPT5d9q2rNutI6lXVQFakZgYcmS?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d811fd86-a061-4453-0a1f-08dd915a0d0c
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 13:36:51.1659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PoDQlTBPL6IJnIBqfYxVrFECBShabUwQbbt44+DzNLsrwV/Th7PSFwrlQA2TCikB/7hQADjEys9SF9hoSjAQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1PPF93ED7187F

> Maybe have those entries have their own hid directory?=0D
> Which will be created if (!hba->dev_info.hid_sup) ?=0D
=0D
> Is this mean that you need to re-initiate the hid worker, if not complete=
d, on resume?=0D
> Then if you are polling the state from user-space anyway, maybe move the =
entire logic to user-space?=0D
> It will simplify your implementation and maybe you could give-up the work=
er altogether?=0D
=0D
Hi Arvi sir,=0D
=0D
Sorry for not replying in time. Thank you for your comments and guidance=EF=
=BC=81=0D
Based on your, Peter's and Bart's suggestions, I submitted the v2 patch:=0D
=0D
https://lore.kernel.org/all/20250512131519.138-1-tanghuan@vivo.com/=0D
=0D
Thanks=0D
Huan=
