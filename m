Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.72.47
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794586118;
	b=PDbX+lhRqn+rbhu0dkmCCwsSuRaptdkXTJom3FWiEv2ERrMCvZdh0Muu21X9/dFDtFte
	 /ENFZkPk7bd7LnUgZBqI9U+5C0imoRyLeGe80FMQm7di2SIanKmNz+NOvFz4N//2KZQcf
	 7WMq9jmgV9YJhiLloWijOk8uDD6iHmme0Kw+Mv/Nihd9h8wPXwbjuVEE3+C8c5dyzzW0d
	 fEHXl63ZJXCJa037D+0mYh4KhkaB/eMJSV483E3GpncWJzkw4lhy1tEGI3mjyJaVAAcah
	 NKi5YxWk02gN1uMnLGdvxYqZous85x//Xk/xen9OY4z92ZwI9MPVzArwNzpCpAQcgow==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586118;
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
	bh=OFmn5D1w/9s9cA7yHY4Wcn1s0toNXyKoWVPSKmaAm1M=;
	b=pXS2ebZbsnHg1neTbrqjB7lJj/k4tPVjVgorp6h7obmS+Uo2GfGT/D4Ff1YhcuekH26i
	 b8DTvVg8bgZNMJZ2J11VDsvRtuBaS/XDlUusHhInKshetGWJXgLiibozph7IJ6AY2Fytg
	 MDO4Szab9l7kkJtBiXay+lOf2vKOcyR5k1gEdtZ7wRIMkg3j2aeYpM5iwo8H3898Z/p1C
	 U3LTc8aN7KZ/9vcMfvYpCpekUjjGTpzlPAyYPv0W/mHPBQJOvUzfsW+cc9SbKNx8OrliY
	 WFuoy1WObdOuAXIWUyB8YrP21yhTY4H2tEFLt02HTtOHdj6cMsbB179d3+ul/fR+jCw==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=V0KNpKp9;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=V0KNpKp9;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.72.47
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013047.outbound.protection.outlook.com [52.101.72.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAF0606A884;
	Fri, 13 Nov 2026 16:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEAF0606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=V0KNpKp9;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=V0KNpKp9
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=U+xc/Q3omfwsEnYC9DslNPFow6NBD6IwHzUdTboDIMCEltQbuAGrTSQexQQ3m0ntbuv5Y+8sejAS3yLxLKPfugajW1yiFaBXWT9CmDayN6B9MJlXOqlng0SD2D7VsdjmSX6H8cPNxwSBirb2tNnITWhHPqL60bUAAh9BqnbWCTAsXsWLMSQVd3QDGMyd9ylWxdgyE7aBHhWmv0bDc/2NTJphXn4oNfJJWlljdPJukjh27Si4RyQM1LQaxBUo0ObKByhoYqosbUByMbPj+YvRugpW/CrHHGVOfpVu89i/I2ohXV963sUHtGMn7266Sh8UE1IUWaSvyIoaaelCNpG7KA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFmn5D1w/9s9cA7yHY4Wcn1s0toNXyKoWVPSKmaAm1M=;
 b=y8AUhkVFxCaUv+NrC+WbATepwZqRj6UvK1jr+4u/Eab2KjRDVqHScXdJXFNHtZYVJ4GZvSeintc6+B7syD0mtkrQetw2CHE8+xHct8cW9rC7H/0ciNGcbn2R19G81oNWd/cB0Ju1ryRftuXbY190ZZtyHwHCT02OITaNb3bVwVT8atmgMsLbKKUvvmcKxGuo7PpwudoohxjeVuPi1UbPEPA6qekwAG5mQS9iAxxl8GUgrHrwl49B6VrpYdmGFu+aV7idX0iKgr1Ag7SKHSIYgmFEvTrMBZ+oAOkrERD+VQ2WtJuW5+GrC0/1u7quw9R14IsFF7XasKB12Ryr7l1EjA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFmn5D1w/9s9cA7yHY4Wcn1s0toNXyKoWVPSKmaAm1M=;
 b=V0KNpKp9YDXoO4hcPUzkAzn4mU0IaE7cZ9DwqkMGO/QzNu0zlNPt3XtOGsLCgC9R8vd0r5DMTEhCVP+xMssXnFnWTwVkNkJKpVKIVknhxgSOITMm3Pjh1S1+n+umLLjRBD6RCu5fbE/YdmJllzJMYLuD9FE060RPewaSMJOmKH4=
Received: from DB8P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::40)
 by PAVPR08MB9209.eurprd08.prod.outlook.com (2603:10a6:102:30a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 16:08:25 +0000
Received: from DB1PEPF000509F9.eurprd02.prod.outlook.com
 (2603:10a6:10:130:cafe::6b) by DB8P191CA0030.outlook.office365.com
 (2603:10a6:10:130::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Fri, 13
 Nov 2026 16:08:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F9.mail.protection.outlook.com (10.167.242.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Fri, 13 Nov 2026 16:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uFlJHGaiadeYi1AaoHU+Iq3wVZrYNzIJ0XxGvoejgZkFz3ZVzQoGPXyvbK2ijab6ldLR2zImB2eRlNqH0QteNpg3Enff7TLuLhwRoV0pfydSg6CMun7gqOgmJy5RiW8cq9sSR4v29g7EUqyOcn1t7ox6ICJjrTTPl+Wictb8ymmCn7AqXd2L6tKmmywwoguwy93EGlz027W3jB+s9RYQzn2PRADxojpJN4+O46Y89LSwhBaZ+AVEkY056p/HLwiJpWHJycOj6LEIZxrndFGoDl8ANnaQlgZzBXHwnbRAUJAbpQsuSLAAYGJsMqBIfqIWRsH5HiKtBcRlvIxQkGYSVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFmn5D1w/9s9cA7yHY4Wcn1s0toNXyKoWVPSKmaAm1M=;
 b=lCej6tIo2YqzNd0clf1CEytJ24wKPpjXuRNooMomUz40WSi/cLUgz7N6l6LvbHqiFmX7MProPiWmy2WC9hbD8aRhfKnQQkBdSXD4eG54eSh1gPyUfWSmRdRR9Ip6SBXlVLbR6SaC8Nlf+dA1hZMbRGmCL69w104LeljiJpKCEN6UfoZ/ax1dZK0lM3D24FZLxtJHe5AVv6NXwhXuLzb5o43qqHqeGm75DpOjGDDDFBZkG8cMEgprachpvDR67HhS7YrxgtZ2JY8o6jPJLqzy6KIt/z3o8GVLxhb8f3dX0aJq09rVjhi4UwPdvnq8lgK0ecIa9RjivITrwlBw4WfYgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFmn5D1w/9s9cA7yHY4Wcn1s0toNXyKoWVPSKmaAm1M=;
 b=V0KNpKp9YDXoO4hcPUzkAzn4mU0IaE7cZ9DwqkMGO/QzNu0zlNPt3XtOGsLCgC9R8vd0r5DMTEhCVP+xMssXnFnWTwVkNkJKpVKIVknhxgSOITMm3Pjh1S1+n+umLLjRBD6RCu5fbE/YdmJllzJMYLuD9FE060RPewaSMJOmKH4=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by AMDPR08MB11367.eurprd08.prod.outlook.com
 (2603:10a6:20b:717::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 16:07:51 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 16:07:51 +0000
From: Bence Csokas <bence.csokas@arm.com>
Subject: [PATCH v3 0/2] Add struct_offsetofend() for pointer arithmetic
Date: Fri, 13 Nov 2026 17:07:30 +0100
Message-Id: <20261113-offsetof-v3-0-714df7053893@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAMI192oC/22OzQ7CIBCEX6XhLIaflraefA/jgcJiMWkxgETT9
 N2FerAHj7M738wsKIC3ENCpWpCHZIN1cxb8UCE1yvkG2OqsESNMUEoa7IwJEJ3BRjApBa87QzT
 K9ocHY19b1OX61eE53EHFwhfHIAPgwctZjeU0yRDBl8doQ3T+vY1ItAT86UsUE1zThptGUQJan
 aWfjspNqLQltsMo22EsY6wVoKHjfS/aH7au6wfYxw++AAEAAA==
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
 "Martin K. Petersen" <mkp@kernel.org>, Julia Lawall <Julia.Lawall@inria.fr>, 
 Nicolas Palix <nicolas.palix@imag.fr>
Cc: Bence Csokas <bence.csokas@arm.com>, linux-hardening@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, arm-scmi@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, intel-gfx@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, 
 linux-wireless@vger.kernel.org, chrome-platform@lists.linux.dev, 
 linux-scsi@vger.kernel.org, cocci@inria.fr
X-Mailer: b4 0.15.2
X-ClientProxiedBy: PR3P193CA0037.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::12) To AS8PR08MB10291.eurprd08.prod.outlook.com
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
	AS8PR08MB10291:EE_|AMDPR08MB11367:EE_|DB1PEPF000509F9:EE_|PAVPR08MB9209:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dc51c60-4a3c-4582-a8fd-08df41a05850
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|921020|10067099003|11063799006|56012099006|261022075727099003|261022115727099003|261026140227099003|261026121527099003|261022105027099003|261028144727099003|261021121427099003|261021123027099003|261021135927099003|261102123227099003|261009221727099003|261009223327099003|261009221227099003|261009223027099003|261009220027099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 0GqxmAlMIXtyeH7PxXVmri8kRG8z7DrPE99+VFM/M9YhLgxgI43m+DCi64tgSMBPy7Khu2V1mDmNEdB8ylSBOv3lk8ruIJ+kvIBnz01NT42ALaL3J+REErLpZWjD3HckeOOCEY1ZYJGFME3HnlBWnXp5At09pSj+POqMUxC0Ya8pNAcNi867CAU0q2Qe9aQErK1nDs4PceazVWxuHjl2JJvctu5mos/DE+ByBYKzk3KlTvNAMD5BZ4LZ354sJehIjweohNSqA8kutEqLnfb6OUfAeMSgXtG6LYCKnVIO7h0M0uvYR6rIz/+Y+edm3xSYsbfQ4QqA6glRkgo7f4q2LTcBzt/EJCtgopGS/OM2Hf2WeA94XO0ZWxt16X49OehRMM1RSuIgxH3JIXeEZvy0JzbRSazRkQMyoS9n6UaQJtzpClApOpilpc4XMXzAJ9btC1dr+Kog24iZZIj94Z+QLzrCZIrB1iQtqNgNPsb9uLgKjdX/LGjwucbtTgyKa6cOuQV/rbQT+EmTh+ZYI3vzezl5F3j68gzUG8x4C85Yph9rTj4jzqbVM9McUAY6DykP2nRD8JHgNodU5NDhg4MwhhPOSc8gGx9sEG/x+E814i4kOcLpz/lMIF6nUPFENXZDbuVTUQOkITqwcG/TIsZtvmpkmJ9vBmAs/GDmP5doLRg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261022075727099003)(261022115727099003)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(261021121427099003)(261021123027099003)(261021135927099003)(261102123227099003)(261009221727099003)(261009223327099003)(261009221227099003)(261009223027099003)(261009220027099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 pxeCfIZBP1VabGwKwB+kksErX+diPKbSFzRb8XWSnkwcYzMkMnS4wLOc6dAqNnnP4HJWUR9wPTF0Ln4CSvbdDYVqvSRH0Q5rZQM7f3J0JEfEKj7tPBQr1B3rBXOiZrTnjTzzuKYLtcQX2rC3TIK1F5rt1HM3iTtqmjl8YgmM4ixsOwNvNOwFoAqkIth2v7Hgcg9wKQecIvO8jmHdRU0P8vcvfaK1XB2ug7DzqhkI8bJ+9xKrJTLHriXqTtyR37XYD+BMerb4qX9wFxpLdtM3c/d8sFFc2rZzKgDH2j/psOHi8Ra4Xj+WFglN2eBk9HnuZQdiee3Hy93cO+euuaFq5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11367
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9cb5beae-4aae-4c78-f29b-08df41a04471
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|35042699022|14060799003|1800799024|23010399003|36860700016|82310400026|921020|10067099003|11063799006|56012099006|261022115727099003|261026121527099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003|261026140227099003|261021123027099003|261021135927099003|261102123227099003|261009223327099003|261009221727099003|261009221227099003|261009223027099003|261009220027099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	w3oqt/nbwQIBZYgeHjkiGa4X+wBoLJAkrp1/sn/jOnQmFmo9Fs+gzv7UJnWDxL+u0dGqatwtVjWjJ747aNhz9vpL+DNQSU6CUojB7xyKqoPuzKenw1KtHMxHvTJaa/NPNjnK1h/LFsiOwj1c3QucTPtDBe6qZyrSTq4duAsq4TTZRP6Ll8KhghMt6PL6kVlb8/rFFrWq3i2Nj5pYtcx0gyBJ0z4GbTRPM46PKtCIqjvxY0rxGrUUGiwIxcPfe26V9UAeu44ZLE3nLg7fab1y4TvqqUxJENC32kyp6ca9cHfMc3lf73tEIQX9oUbBi4+3e2LbRVEKen/QjMSOIAZiu6EglODZSpywUywm2hk0QalxezcguLngVSLCrCpG0ZyeH3zILXjg7wUkaxj8Fthw+sWv6IK+3xuOtgsVsDBEto48yXvYEKBRJvFKDozNuu8kpB1uVLK+DlD+Zl+WeEukhrYAgH2q02ZiI0XDkNpaKBVriatnAOqIJLI1q/N9nWcevVkypjCvMeyRDHJWt1lI8ImF23y3toQ6RWJtTMKPKFgglQV5EoFGS3NKGh/JM74xnB6cv+/1aLB94nvmrdYoVvMqYcVb3ms39/0wzNaG+AQ0pY9JmFY53x7gPBagy4fEA25qNERKRyjljkv0Nmd06NwFO6Fok6CBkCUA1vri21L5KClUgldY4hpG5Ah5w6+HXlspxGwAqwpG+soSU4pUQQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(35042699022)(14060799003)(1800799024)(23010399003)(36860700016)(82310400026)(921020)(10067099003)(11063799006)(56012099006)(261022115727099003)(261026121527099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261026140227099003)(261021123027099003)(261021135927099003)(261102123227099003)(261009223327099003)(261009221727099003)(261009221227099003)(261009223027099003)(261009220027099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	c+Cd+wBN1h8uQDWVDz7lRuAQvZSa1ptb9esLUmYSZrmcRQNMOooq1G0y3onoL43atP18UfTa7RKC3CdrsSRL6tqOVBuPz4Ms8fL42/qlKQSx1lx1XWPSYoag2JKMlQh5k/YgZoQ8NRNNDItPzo6M5n8tGH35BB+6y7Px2jx6aGEsqxPbIW3hAGjTKbyJK2mOM4p//mUbSfxnDE+4cUbJ52vJnVSvFibscE39i3SCCLrzKC3pMyyXQ2MRVwI27rfQyWjQln2OanqzUGMuWSwKdD5AToLSLUWOHbVQsGXd3plfqqqRP7Y5Pn+ihFiyJW+Tx8FYr94Tnl5mLufjH4yDyr8Kb0A1q/i3LFN2c55cTcH4GWiVSaQNzqDGc7HTLJ2GsILTOiuOaBQjihaGFcsmx7Vuck9gnw+YiyHxxhofiJlEsGt+0ZJxDmdNbSn0JMsB
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 16:08:24.1326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc51c60-4a3c-4582-a8fd-08df41a05850
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9209

A common usage pattern for offsetof() is the following:

  offsetof(typeof(*ptr), member)

This is exactly the definition of struct_offset(). Some call sites use
offsetofend() instead of offsetof(). Add this variant, then replace all
call sites with the corresponding macros.

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
Changes in v3:
- Add Coccinelle patch to tree instead of just the commit msg
- Fix Sashiko issues in prefix, commit msg and doc-comment
- Link to v2: https://patch.msgid.link/20261112-offsetof-v2-0-276ede839967@arm.com

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
To: Julia Lawall <Julia.Lawall@inria.fr>
To: Nicolas Palix <nicolas.palix@imag.fr>
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
Cc: cocci@inria.fr

---
Bence Csokas (2):
      overflow: Add offsetofend() variant of struct_offset()
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
 scripts/coccinelle/api/struct_offsetof.cocci       | 14 ++++++++++++
 31 files changed, 89 insertions(+), 64 deletions(-)
---
base-commit: 7e1392a42ea288d70a266f6553fe06f57f8647ea
change-id: 20261105-offsetof-f62aa6348f0d

Best regards,
--  
Bence Csokas <bence.csokas@arm.com>

