Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011060.outbound.protection.outlook.com [52.101.70.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3C450C287;
	Tue, 29 Sep 2026 10:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676677; cv=fail; b=tA3mPwByGgTTK+4EUI9fyJai2qzLn6tyZZ3UuItQzPWgqsxOIFszUdmpQ8/q0/Gje72SiIZ1JxpSUnse12TT9BBXzxnoPc6DrLav5MuOMV5U8DhsCJfQJ0IooDa1YmChFWykLunbg85R4oA1Pz02RmB2orbS6u+6BJG8uqk8eDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676677; c=relaxed/simple;
	bh=Gzlh2+HUuz6t4sQYdpgSTd87AHMOxQytTKDCMSPQmkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cvTPHOSKLMiDH4LJuMAmuAXilTSo0Y/UGRJVyTJtT3mwoITT9amlji560i8XmJ2HWs3E+PYW9VKykIEtXc76T1cDLp9PZR2WP7VBIKj5x6+Jj3kz4EA7vyb113f0qSg6qrOqKLiJ7stYBPz0WSn/dfWkSqYp3UfGOEdUzR0iEs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=IduDZlQF; arc=fail smtp.client-ip=52.101.70.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="IduDZlQF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CkKU7Jmxw/7nA8EBB9IwjM+ts2nFgqOY9dmPbMBRL9Zcnl1f59jAXTV5y4uMsprwkGPeNNHU+hEAN7BBmbE+X4YtvhEIPmY3ic3dHxtJZk0TOtz0dC2Z2eanXJC+GeF6QlVH/CC9WTGjz9vvQwj2CQOB9YAfde5PyIFuUIzi8DfbQTZZum68yZPRu+ocQl/QuG9FlaKym0UM+pN9ya0w+gas/T6b6wNcD1PrevCxyJhEf01ohMpM9OicNkgJtq5jO0an/E4GWtkKaFJWOt/ff1vu6c/Ha5WZJK42BW4jgdbhz6BWbgTKtupN79PdnRyWIeCD4o6jRER758+BZK9fbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ave/1sHBXSjhiWUhM8uokopPQrep44H0HHJpXF8zpR0=;
 b=xs4hEKtyDTOFF08ZAwewYBU6jEbNN5pIA1Y7hdR39Nm59nofZzP4k7BxpvBzaHlH3OMc5DC3I8AugY2+9jbZtQQUWuyga7KbYhx1S7D0i+B79Eoj2mGcgvQU3c0FmTQ2utqgC9xzJk87UX/IpKAzJV2oZNE6iBpz9QQ34H+fIpLL4l2ghjpnG25wQmSVzCtthQ+YYnGq4UG6JFqC5BsLvOKd7Mui6/wVHHvxPsIwZkXvlbUC8jR2VbBRuxONXw41mKEwH4z6aapslq/ffE0l519dfOevZXFmRVGm81sDNNS4GfOYMNY2MhAvE58KTTa+THTe6Mz3JbSrxw/5bl3O5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ave/1sHBXSjhiWUhM8uokopPQrep44H0HHJpXF8zpR0=;
 b=IduDZlQFVDISQr/1ZfcYWrKTXAO88oreaOuzsREfwcZJSTO9rHERpFuWUMWQjMJfcopC3zN6DJ1LWIVFSCwLvrwcpNyRM+9HhwrJtOyQYs63k/QIh7HL/hfd9jZFBuQ7eII7fS/t9LqT2kIDGEIcXX/n7TWWbMJynPLcP+wPvBsHI6X6QZy/2ddMcJ3Fb45NYLh9L7MWgw5gpdQc+EKj/J/5ljjO5J2/zO74tfkFiH5LUNs/5oRr0yaAJGSpVZu02ep6JN5uCWVJ4YTSOAWjyylnBx7epfQOaesnUXxeycYhOCpooPkLdfacdPjVS1OmvVRdXkuKHJXUzqTRIX5SvA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI0PR04MB888289.eurprd04.prod.outlook.com
 (2603:10a6:800:366::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:10:22 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:10:22 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Hannes Reinicke <hare@suse.de>,
	Joao Pinto <Joao.Pinto@synopsys.com>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v7 12/12] MAINTAINERS: Add NXP S32N7 UFS host controller entry
Date: Tue, 29 Sep 2026 12:09:46 +0200
Message-ID: <20260929100946.693962-13-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P251CA0013.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::18) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI0PR04MB888289:EE_
X-MS-Office365-Filtering-Correlation-Id: c122bce4-ee0a-4b2f-d5ea-08df1e11dfb8
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|1800799024|376014|366016|7416014|11063799006|56012099006|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 e4PY69HtyXueQZui1nZ21Ao16j346g7NNSvmlCD5lu84NnyttdxVQZD2oDqe0pGpURwo+KLnnmtVNmkNxti3xETo5e4lAe9II/PfY02+qm38kKWy6KxTmg3klT9ke7cWLNiio/AUpFuI1dq3KfYtL/1dYbmtOjtQCQYAUamrKfEvspWsHR9IS1wQOzf3Lhr37v0eZt1RaDmQeyidqeVhPgti0ZDRGVb/3c34sqivlHOvVWSgd6/Fzco0WBwoiq2aOfaVrsW40uIP/ptEEMLPhg3GwDkNWoCy4hfnVuuEtDN1GK87u+FOQ4/pBO+nyaXOMjPpgMSZkT5GMm1XGJCEAjNdsDxS21h4JEdXE8aB4d+B/YAk76jDhxNyVKLXm0LX7QBeO1UbfxccwKcsEdT7CL7QKNGCjoDkN4XcP8Qc40kl/0JJfGmr52cfiToJnf9PLgCadk0LRz4E9l6009SRRGiNtKQVmpZjbD+0WfpuUYs4LmtExK/gq50cYT9lzfMioQJQHQzSjussZfi9BpLX6dJBcK+m80D/fvK/njPxiFyCr1l2evCOLhVFM0Mv5h/hsqaYV/dNkC1QY9pOmKM8QJr32KcKvyqkVgmCpm9F+iUmasVG9kwObEejqYdoiwJXeajKrZIW++t/J70Z+6WhvcWwOEDW1e6UHoKAVFzhJGMf8Sy4DDS7qJeecbwUr0LG2/j1EJ85VliOAQvLALoBMg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(1800799024)(376014)(366016)(7416014)(11063799006)(56012099006)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MjViMXlLN2Z1ZlVXTFYzeDBWMWlKbDRKRGZtcTNTZC9UaVRmdVp0eEJ5dzRY?=
 =?utf-8?B?SXE0MEJwSFhTeDdpOHpHREhiYmJJU05hRmMxZ2xWY0JWRHpMTy9GSXRhVndV?=
 =?utf-8?B?MG9JNnk2MzJlLzdBS0hmL0lzb1hJa2diRG45RFFMMHppalk4dDRRck5hbENU?=
 =?utf-8?B?NWRWVmo1VHduY1N5VHYyRXh6U2dRRGMyaXFDSU9XVmlhR3plaEdUbXhqOGc1?=
 =?utf-8?B?MkZ2TWR1UTFjZXlBcXN0NGhGNTZnUXY4enRlWitNOEhGNlk1MU8wc1lNenVm?=
 =?utf-8?B?MW5lbWhsMlpLejV3bFFDaHVEMHBKNDJZUHJITi9iQWxreXRrNGV5a2ZjaUtM?=
 =?utf-8?B?ampxQnZrU0psM1VmVzFCVlBudGZ3VmQyZFNUbG9xUzJFZCswK1dxb1AremIx?=
 =?utf-8?B?TVg2QnBtWWwxa0ZOa2FSV3h1TjlNN3V4eWRKZzNtanBXWjE4R2dQYW1nU0tL?=
 =?utf-8?B?Ukd6dFMyVkQxVmpkeEZnQkg1V0pHbHlyQzVkbGZKbmZkRDZlWnRTMFZuZURL?=
 =?utf-8?B?RGhTNUxTTWlNanBsWUpybnorMmw4UzdzV0xsUGg0L1krWFJIVmR1SzM3VGs2?=
 =?utf-8?B?RmkxNGhwMnkwNG56b0lpV2trVTdMc3NWa1J3SEtDaU04M3V6Q1VkMnZpNEdT?=
 =?utf-8?B?KzFOeUxlOVZhYngrYjZrMHhqbUVwaEVGR1FqY3JMQlFiczQ1MUhJZlpWSTRC?=
 =?utf-8?B?N09VY3A3aFB4OHk1cDJFQ3pHclprdW5WZThidW1EdDQzRWpGaFc0WVFUU1pU?=
 =?utf-8?B?cGNRU0ZaQ0RCS0ZpaXV5eFVPN21mc1FXc0xic1E5b2FEQ1Q3N0s2SHE0aVhB?=
 =?utf-8?B?WFg2UTFoVndRakk3SHhiWjA1eGpZeGQrTUtjQ3Q3UmJqMFNBUXZGOW9ZejhX?=
 =?utf-8?B?aU5rSWdsSmFNNnQ5QmltdHZSM2FHb2hNY1ArUkJ1R3FXR1FWNVdMWjYyMUVo?=
 =?utf-8?B?c2NJMFJKUndIVHh4NEZEY1JsWFp1c1N2K1NqN1luVXR5bnJpWmxyUGRBTVVw?=
 =?utf-8?B?TXRlVEpjcG94RERPejVlZEtlTVVwM0RxZVRDSFN5U0dla0kwd3hiY1c2dlZN?=
 =?utf-8?B?SGZkY1ZEaWVkYWUwaWpHWkNGRWNzL3kxTUFmR1ZUSUZZSnVYZ28yRkpiR3Jk?=
 =?utf-8?B?VmdpelI2MWFGNml6WXJDajd3RE9YZlFMT2kyOWc3bEpNaS9lbmF6bFNJYlp1?=
 =?utf-8?B?M0pPQUQxMWovaGRFKzF1Q1lrV3BHZWswZUViYlBpZjdmZjk1alg0SFMrQUl6?=
 =?utf-8?B?czRwRXRKekttYTVGYmx6Q2I3NlU4MmFYMkhTTFZhZ2ZJdUJlcXFBVlhwQXJR?=
 =?utf-8?B?Q2VEbTJESitIYWphdlE5MlgzNkJxRXk0M0FvU2NDWDQ4bzJSZVIvV3d3cW41?=
 =?utf-8?B?Wjk4OG5hTksxR1ZVYUZYVHZNeGxDcG9wWWVRTllVK2NpNmVSb0xmV2p5SWJG?=
 =?utf-8?B?dS8xL3J0ZnhmRi9TTkROeWlQalc3ZVJVZGlOcnpEWHp4dnZkRzhyT09KYU5M?=
 =?utf-8?B?Vm5USVB0UUR3alVLNUFhYVdZQ0FINlJ6TVFHVTlsY2xuRkJiTWdsSTFoRVoz?=
 =?utf-8?B?cmZUOUJtaHl2QjZMZEN1MENNUlBTeVZMQmo0a3dJVzBvTjlZMENWdzdUM0lv?=
 =?utf-8?B?enlDWitIaGdZbHRjSk51WTFCL2RuVnBFMjZTcnZJVHhIcXhHRDFZWnkwMTAw?=
 =?utf-8?B?WmdEN3dhckh1cFExT1lod2pEMzRyT0QvZTNoZ0w1WG1VNlN2V2FqeXFna3Nk?=
 =?utf-8?B?QWx4R0lJbHM4a3lRdGQxandjQVV5aDc1SFdhRmlvZjA1WFR4K3lmRWlNS1lC?=
 =?utf-8?B?WWdESUs0bjNoTjYvNVBxM0ZsdlZGV29wWFl2cWFHVXNwQS9qOUJjOWxxUERW?=
 =?utf-8?B?WGk5ekRZVlUvV0h2SDE0VWVpL3NVaks1dG5FOXJhd0tlTXFJUzlzMGtuekpi?=
 =?utf-8?B?N24yZHBvcUYzbjM5OUZUNDNaVTBpVEp2N2wvbFU5WGd2Um9vRUVFLzI4cnEr?=
 =?utf-8?B?MUMzTEI0M04rLzdMSUlBNTI3dSsvS2ZnSm16Y0JrcDB2QklwYVZuQUtXdlQx?=
 =?utf-8?B?VEc5TFNhUlZ5QWQ1YlpqZ2tGdVdhZzRQeFJYSWJuSlVvUFZ3ak1nN0h6c3FT?=
 =?utf-8?B?cUhuK25IYlpGbU5KWFBFdTBXOW1zekZ4MkhIaSs2ZjdOTG5NT25xZWVZcEN0?=
 =?utf-8?B?aVFERzRHRmIrOWdnTHlGS2ljaHRDS1RqTGVLODJtaExLL2ZzMWM2Y0gxQ2RH?=
 =?utf-8?B?WWhKWUFQMEMwaXBzYk5iNlNCMTJ6WlFUeFdCN2VwU05US3hPVjltK2dwQXBz?=
 =?utf-8?B?ZGhDWENIa0EyemVib0wzM2ZqWXFWUjhHQS93N21SRFlJQTFraWFKQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c122bce4-ee0a-4b2f-d5ea-08df1e11dfb8
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:10:22.7398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvFP9u7uvE1lhqib+ZZ8Q8M8BoIMec+Z/SSAnW7pzRXOpIUvggyMRax1TnYQmnmCvFK2hGoQ5t0PjWq+3r5dNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB888289

Add maintainer for S32N7 UFS host controller driver.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc3cae2e378b..6757d6af5dba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28097,6 +28097,14 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER S32N7 HOOKS
+M:	Larisa Grigore <larisa.grigore@oss.nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
+F:	drivers/ufs/host/ufs-nxp-s32n7.c
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.43.0

