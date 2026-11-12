Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.48
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794475878;
	b=b11Ej3UBrjmnXgNiP2wKFdMLgQWj/bDtFKWpecQiEL5HEX2CpX16I35JMVg1imE8TLl6
	 Y5PWeItFtbSiDsDOR11vH1p3L7m3Uc6ZsIMmrhvdnBGKW1JkOOvvj9T7uI6qfYlxE8a4e
	 uUZwegRNNyMNPCG9sX6aaY/xZMV8wHWNcPS9TF97Eu9Oj+0AqGLjTEbx2erZoLm1r1DO3
	 iqqNcb0jDCeT/4iOTzJqZqWfPp/xTmM9nUUVeglSf5ER1gMC6y8WfG+LlrA/ArdDNF59D
	 bOW27IkJp2vziJGlvUQJh4OSj9Sonj7WmMK4h3KWN96fitMjSU+xoaWQ12XRXmOlrBg==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794475878;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Authentication-Results-Original:Received:Received:From:
	 Subject:Date:Message-Id:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-ClientProxiedBy:
	 MIME-Version:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:x-checkrecipientrouted:
	 NoDisclaimer:X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam-Untrusted:
	 X-Microsoft-Antispam-Message-Info-Original:
	 X-Forefront-Antispam-Report-Untrusted:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-EOPAttributedMessage:
	 X-MS-Exchange-Transport-CrossTenantHeadersStripped:
	 X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id-Prvs:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=JeeTo1MjKv70DzSTDivqMn1e6x0VFy+ZiZPO54IltdA=;
	b=yUHTcndm6ecv5lShv2xRQNrIe9QXiBhOMv7NEqgbusrtxo3+M8QMY9V4Dzrfj5Z++buZ
	 yPjFDVm2KzTNEhfzWMTh3aMQlR46C02y6HCArA0yCHG0I2xLIJCKBWRwcEnI0n/h3c6Gn
	 Thf7k/NOPmACfCMJDEHK0127yzbB0Fe+JpAcRNZLL9/XIUvdSuJ+tnqhlwvgVsWYYyJxv
	 RYOv9ZzI61KkKKp2Y+Y+CTlBBXghgE1a6sWtFhKARi8qGDWLJzUa38PEtPWNdbRHCK58V
	 rgZQx2nocTB1/QeRVBN65GdW784XKRV+fRqWYLuWEtgOiMkwNGojmVcHcuWB9pcPmuQ==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=F6jBaCrb;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=F6jBaCrb;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.48
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010048.outbound.protection.outlook.com [52.101.69.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0FE606A32D;
	Thu, 12 Nov 2026 09:31:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC0FE606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=F6jBaCrb;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=F6jBaCrb
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aS0h/LAOFanOYSbhMnERCBNgAj2Ke37o1b+nIItJJYX6xQMD0jH6b9GPYzWoXbvUCCu1aBzaplN6fe9uGZfY2NicYRB09Z/hkwZ+TVBYZl18SiHe17KPCcq2aMvgX1kwsp+PrZsT4vtHFCjR3arQ4mUh+ffPePBMoabUB01EqjVQQVWzxl5dmJaEq7vKQSwY0IpWhR/ukEJiugQv4f5CKqbKyPWtbeKq/D+nT5ilcwUvCcJRLwrfNb1ms84psij9pttZV9UGgDIJQOzQxebxja9vePBRq+j5S6R2YLZNlbD0cO63190EOMhyVl6dY9yNQs+jeZ7U+Os+bWmZryyZug==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JeeTo1MjKv70DzSTDivqMn1e6x0VFy+ZiZPO54IltdA=;
 b=G3RhrKLvvxR9iKpNUcCKnW5N8MTEriVIztUMMm7UiGch+kI8htQGrtd+PhArLvdwCK5Ovvahl9Wryz6l9Q7OiGAqVX/qgv9k+pBBUPPwebnGxXDfOTUHzUcqktehThuBYXrgF3cfI4WsDE+iZ8zAhk/7tAsAgwmSwAHyHlnWLZWc1wcGhxNDj8pa+XtxVMOGMa2MYlLXHiqt8/ZqiTkrcxymj4ewyd3HAvi7safkOP74t9Oxy+3S/opGOPEKGX/1fMEN7QfmF6Fog+X8S8v3O0nifsF3g231/6uFQmuYmROSXLrUXtW06i60wppOfN6qivj4GTuRcCd+UkqhjSndIw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=davemloft.net smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeeTo1MjKv70DzSTDivqMn1e6x0VFy+ZiZPO54IltdA=;
 b=F6jBaCrbbfnWcRhUwvsDL6dWgahL9GlGX14BTT5tKyXmiLcfbwfuI0i2HDwNT4WTN6SQWiz3UlujFm6roOgZginM70Ytjvmg4c5xXOakpYzcIMn+XCMZ+3iFUGtS3wDcvr1wFOCcA3d2OuCM0axQIsj9vxrl6E/lbOPTv632jhU=
Received: from AS9PR06CA0384.eurprd06.prod.outlook.com (2603:10a6:20b:460::25)
 by AS8PR08MB6133.eurprd08.prod.outlook.com (2603:10a6:20b:298::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 09:30:51 +0000
Received: from AMS0EPF00000566.eurprd02.prod.outlook.com
 (2603:10a6:20b:460:cafe::60) by AS9PR06CA0384.outlook.office365.com
 (2603:10a6:20b:460::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 09:30:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000566.mail.protection.outlook.com (10.167.242.116) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Thu, 12 Nov 2026 09:30:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BGl30QnMOengROlkSs/nZ09NnXRWRIpXHWd+LfFl8yBvBt3LP3NQrzHJhFW9onjtl4+vwUuhT3s906nmA4Yl6THe2ORwPkzQsnxPsvNmrr1U8yUC1tJxtCOnjCTIQ1NC7EQxQlia3DTcJW3Y1e/tTkIAea0nIc8EMBLML23STz47knRIAB4jQ/NeebpCsFUMyA0F6cCJ3FNZMjwbNkbIAYrqy0JaEHZ6putYUgM5ROgyl1C+8gxEoNDWOT1An963jlaP2jpux29kW977v5Wv9OIKZD8yELnnF0ajetuCbSAA9gm158XpkPPHwDcdBuowD+rxn3lWtSnvoLSeAg5JhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JeeTo1MjKv70DzSTDivqMn1e6x0VFy+ZiZPO54IltdA=;
 b=xvnDGkQBfaFG+5hYPTu/A40xqiBQBgvwHW/JI7nR4XzG4t7Eak9eas+VGk/+uvc0WyBeI+nUowyFTGVtFm0RY+S9janr4BUJpXI6qFmdA8OtF2mVPpE6d3jWur/k7Lex2a1lg6TaeZmsNFPP45S6ynufjREwkdkKtPZXayhMow2yenNyPNapHtkyokneMRp1a2tjP+64a11vuvyboPlCpBBg5xO5EBHLCcq83pVCBa18/jtP9VzYrFFSDnOMIPZYZnIlB+bS6IdghMTGySLgO5i6vewIIsKiCIilPbcYDoHpeTqXCJHAqRdD6ucaIgY+N1MHCv0PtcYsmPGqyybYhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeeTo1MjKv70DzSTDivqMn1e6x0VFy+ZiZPO54IltdA=;
 b=F6jBaCrbbfnWcRhUwvsDL6dWgahL9GlGX14BTT5tKyXmiLcfbwfuI0i2HDwNT4WTN6SQWiz3UlujFm6roOgZginM70Ytjvmg4c5xXOakpYzcIMn+XCMZ+3iFUGtS3wDcvr1wFOCcA3d2OuCM0axQIsj9vxrl6E/lbOPTv632jhU=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by GV1PR08MB10402.eurprd08.prod.outlook.com
 (2603:10a6:150:15d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 12 Nov
 2026 09:30:10 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0615.008; Thu, 12 Nov 2026
 09:30:09 +0000
From: Bence Csokas <bence.csokas@arm.com>
Subject: [PATCH v2 0/2] Add struct_offsetofend() for pointer arithmetic
Date: Thu, 12 Nov 2026 10:29:32 +0100
Message-Id: <20261112-offsetof-v2-0-276ede839967@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAP2G9WoC/22OzQ6CMBCEX4X0bE1bfmI8+R6Ew1J2pSZQs1uJh
 vDuUrx6/GZnZmdVghxQ1LVYFeMSJMR5B3cqlB9hvqMOw87KGddYa2odiQRTJE2NA2jK6kJmULv
 9yUjhfVS13Y/l1T/Qp5zPjh4Edc8w+zFLE0hCzocxSIr8OUYsNhf8+bdYbXRl65Jqbw0O/gY8n
 X2cVLdt2xcn+3ZNyQAAAA==
X-Change-ID: 20261105-offsetof-f62aa6348f0d
To: Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Philipp Stanner <phasta@kernel.org>, Sudeep Holla <sudeep.holla@kernel.org>, 
 Cristian Marussi <cristian.marussi@arm.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, Lyude Paul <lyude@redhat.com>, 
 Danilo Krummrich <dakr@kernel.org>, Zack Rusin <zack.rusin@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, 
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
 Hans de Goede <hansg@kernel.org>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Benson Leung <bleung@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
 Guenter Roeck <groeck@chromium.org>, Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: Bence Csokas <bence.csokas@arm.com>, linux-hardening@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, arm-scmi@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, intel-gfx@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, 
 linux-wireless@vger.kernel.org, chrome-platform@lists.linux.dev, 
 linux-scsi@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: PR1P264CA0162.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:347::16) To AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB10291:EE_|GV1PR08MB10402:EE_|AMS0EPF00000566:EE_|AS8PR08MB6133:EE_
X-MS-Office365-Filtering-Correlation-Id: 040772fe-4224-49c0-01b2-08df409fa3f2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|921020|10067099003|11063799006|56012099006|261022105027099003|261022075727099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261102123227099003|261009220027099003|261009221227099003|261009221727099003|261009223027099003|261009223327099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 F2lMfknCP3z1AucWQuGarVjTDHVW5ARJ1Le2MfBRXdYYsZY0XPhmBH0f8zCmw3TxRL+WjWAn6dMjFtnbXJntWM2Hoev0NrIdRp4uzV4hprcdKC1EA5dmnmCqMsvBZaWK+U55QVlejY+rKnzfPuNklnNpXDNaqT5lYVUc/SwBNHrTiBb9oO0ZOPFL+/dJFocfobEAiyXnJB2twV1xpNQTCxT1Fzfr6paY5UBdD8NYvnCGrKHKUmnpF3Q/SwwmOSIrVD5UcIXJiPKP0B+p4H0VvUGXiUZF/FJD5r4GCHCY0PhJOUZmN0IVTrQm8j2Kq8KuVDPuAV2/uHCJWyZAz3W1XEWIlwsrJsvFCMwfR8rRXCLJU/AfhMFPcxRtNTx4pe+o0mrSpxlfQD4gXD1785AZFUEW51wySOGr6sIDObmK3ndSx5KQwXL42JNNXbe0vFfGhlS7jKwNrhnL8p1pjkq9JtbwV8hyJPUPbcpngCKJXEipeYaY+20P7LkZ9brxQM2P+37E2iddKKQrHm1F98M5exe4+AIw3M74/1oEk6u0w5vGHkA3dCQe8ZDQKZaz4331EuwpGwOjXqw2m7QJSmx9dxiqD4zMa7gGOl7OP/Rr4OfWB9N1mknpBg7zLvOTt5dYBab6EaHzerhUXAYDkwOYno41J0pix9Hp+sMuk2lPFvs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261022105027099003)(261022075727099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009220027099003)(261009221227099003)(261009221727099003)(261009223027099003)(261009223327099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 1bmMsFiWoyBAT8vv8SB0shTGPv59xgn2Alb0xteuSSQsKOx/l4ZYryd+pomzHtN4yw6hl0j3Q9YTXSN833JT7KfeNchcSVzpcIMva+JRcLUDvf/nawshOJUlgHEbNYFhGm3nLoDQeu+rgmvOX+76TnGL1gwol9d1I7hEvI7d40B5nusNyt2e8yDPoBYpPiNQz7sdzbgjCJiyIRUHhVOX+7KUGOCG7EdrwJG5u1UCrLLEofzypfSvS4PpnhMgwt8qQi57SkmaZiywXHQHrdALJPMr0ZksiQrOk9ZLUU/MKvpJ+Xh/qwp6RH2YzmqeWGkoBRKwr3QolD1xAtkXgoplNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10402
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000566.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1280c9fc-f198-4074-b374-08df409f8b16
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|14060799003|7416014|35042699022|23010399003|1800799024|18002099003|261009220027099003|261009221227099003|261009221727099003|261009223027099003|261009223327099003|13003099007|921020|11063799006|56012099006|10067099003|261102123227099003|261022105027099003|261022075727099003|261028144727099003|261026140227099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	2WrxZtMxtekqiSDZfJ3wNt0boTcjrYvdV+sFiq0ojA6m2v/EiwDKE3N/sPA0fNtYXg7spYVOXHwKowXoOUUQ5WKf6Kl0GWIdtA99neKQOOdTEEn0iLA3+CsAeJgxVFjoj6VNnyXkxWUTjEcECg1svxPV6Nn8vZwVC+fXY775x1HwTOgqJ++VfNqdG/oM0dv6kx3yrC73KbT2SYJ0kOFqBfIHIoyY2+hm7lw4raY+8u/ud7w/1a/y7w0K+/ev/XMNqn634PejHp4i1xT+F8HkJKE4TQONm5FR6bKuQmEsZQos9+rjnQyAZ2Le/U3w0q8HbdhXmioDrYyIgZGtTpd46GfvZpU5dkG6K7iwAiURiZAbHuHZnGUSEOdQcByWhUNScVV3C/oThUTfnmHc3BT0AciUHhNuS1mPYLZQ9lDYTpS4045Zy9/3hcq4/pdqCFfhgarZTo4QMLSSSlMZDc05W7WTTifno4eokFtA2mRb3tbBANi3cd4OhLEZVE6+iF371ixliY10GzV6/SFnQZJiydFbHttPBNO4ZCXE43GkIOZXur5/kivpAUQyT0/dkZCG6UW7vr/js8vFZu/C3O+swWHNyCisPxsXHrclex6gh5KDVFbi1PlYcgi93p0ZZKlp2Ec/95CJiiRH3Gp1gz1aolf2QZZAWUDdJZ0fSxWokgDCqAUlqWJqH0XvaltkupdpRUn+npDCb9sOphfrP+Kjhg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(14060799003)(7416014)(35042699022)(23010399003)(1800799024)(18002099003)(261009220027099003)(261009221227099003)(261009221727099003)(261009223027099003)(261009223327099003)(13003099007)(921020)(11063799006)(56012099006)(10067099003)(261102123227099003)(261022105027099003)(261022075727099003)(261028144727099003)(261026140227099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gLYUTbVz5R6r2CzyWrtiDoqcmFHVSGHkxHC5qhwTzDQ79vhj8U3QtGZ6RNpZ06fNgejOfmcCBNVo2afqEPzcUQa+mXalxvKmm5E2fh+ijIT8qZarVyHQT88LU/7/QBYwLJe9J3T8Hhbg0s23ZTl4Q7nPqJMSi0bKHLyXAraWM5Y9R8lfgoOE2mgTwMKb4IdJ4hs9HIkY7I3yiChKm0ZG2hK7Im6wiT2Z/EfHWz7iz/T5MlKDXRC0x9Ci6ikVjyQu+WjKmvfavEHnkcGsGy/cM0p3s783jXQqg1kHjcXPqarZrML1jovgk0GqKA3dfrSsj1hNyBUE1XVCIHgeqgRarvFYkTu5wEbBFNYGxRPMBn4CRzJpnbu6OocnkZMJnFYkNfLgFCFhEMw4F6zK/PJJYK5EDv7FZ9p+nrDwByFjkTAKe8vPXhBDgcufue09OYQ/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 09:30:50.3535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 040772fe-4224-49c0-01b2-08df409fa3f2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000566.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6133

A common usage pattern for offsetof() is the following:

  offsetof(typeof(*ptr), member)

This is exactly the definition of struct_offset(). Some call sites use
offsetofend() instead of offsetof(). Add this variant, then replace all
call sites with the corresponding macros.

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
Changes in v2:
- Use struct_offset() instead of reinventing it
- Rename offsetofendp() to struct_offsetofend()
- Merge the two treewide patches
- Link to v1: https://patch.msgid.link/20261105-offsetof-v1-0-4153f5c10edc@arm.com

To: Kees Cook <kees@kernel.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
To: Christian König <christian.koenig@amd.com>
To: Philipp Stanner <phasta@kernel.org>
To: Sudeep Holla <sudeep.holla@kernel.org>
To: Cristian Marussi <cristian.marussi@arm.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
To: Maxime Ripard <mripard@kernel.org>
To: Thomas Zimmermann <tzimmermann@suse.de>
To: David Airlie <airlied@gmail.com>
To: Simona Vetter <simona@ffwll.ch>
To: Jani Nikula <jani.nikula@linux.intel.com>
To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To: Rodrigo Vivi <rodrigo.vivi@intel.com>
To: Tvrtko Ursulin <tursulin@ursulin.net>
To: Lyude Paul <lyude@redhat.com>
To: Danilo Krummrich <dakr@kernel.org>
To: Zack Rusin <zack.rusin@broadcom.com>
To: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
To: Selvin Xavier <selvin.xavier@broadcom.com>
To: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
To: Chengchang Tang <tangchengchang@huawei.com>
To: Junxian Huang <huangjunxian6@hisilicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hansg@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Haiyang Zhang <haiyangz@microsoft.com>
To: Wei Liu <wei.liu@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: Jes Sorensen <Jes.Sorensen@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
To: Johannes Berg <johannes@sipsolutions.net>
To: Benson Leung <bleung@chromium.org>
To: Tzung-Bi Shih <tzungbi@kernel.org>
To: Guenter Roeck <groeck@chromium.org>
To: Nilesh Javali <njavali@marvell.com>
To: GR-QLogic-Storage-Upstream@marvell.com
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: arm-scmi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: intel-gfx@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-hyperv@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: chrome-platform@lists.linux.dev
Cc: linux-scsi@vger.kernel.org

---
Bence Csokas (2):
      stddef: Add offsetofend() variant of struct_offset()
      treewide: Use struct_offset()

 drivers/bluetooth/btmrvl_main.c                    | 12 +++++-----
 drivers/dma-buf/dma-resv.c                         |  2 +-
 drivers/firmware/arm_scmi/base.c                   |  2 +-
 drivers/gpu/drm/drm_edid.c                         | 26 +++++++++++-----------
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |  4 ++--
 drivers/gpu/drm/i915/i915_active.c                 |  2 +-
 drivers/gpu/drm/i915/i915_sw_fence_work.c          |  2 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c  |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            | 12 +++++-----
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  2 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  4 ++--
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  6 ++---
 drivers/media/usb/uvc/uvc_v4l2.c                   |  4 ++--
 drivers/net/hyperv/rndis_filter.c                  |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c |  5 ++---
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |  2 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  2 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  8 +++----
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |  4 ++--
 drivers/platform/chrome/cros_ec_lightbar.c         |  4 ++--
 drivers/scsi/qla2xxx/qla_gs.c                      |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  4 ++--
 drivers/scsi/scsi_transport_fc.c                   |  2 +-
 include/linux/overflow.h                           | 12 ++++++++++
 30 files changed, 75 insertions(+), 64 deletions(-)
---
base-commit: 9d66f26fefacebfeed15de31c1123451a17ff119
change-id: 20261105-offsetof-f62aa6348f0d

Best regards,
--  
Bence Csokas <bence.csokas@arm.com>

