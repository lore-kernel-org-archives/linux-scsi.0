Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.42
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794475860;
	b=t6cdNIBrEyuzaIFcnE63dnm9c4QIRio3VudbUKpf7W03UqiLB4dzUr5EveMZJM9Vj0w9
	 BCUOKPV04ekU+VFkgUkH0dXaAq1ookUSYQoh3J2hBa3aj76sO6y6HINyGYPmWBsvIiDhq
	 AUeYUOVGCD3G2Zm6nzTFUhuLu6fWi4GEeLG2Gu6mn6HD9YhfKl/U2lsZqY7hcdwEcC6IT
	 qdoLHrQLizWWdG6u+Nyf2bUnbg12vkrt5qm+oOgJxaFCLafN+VPuGRkrrErDMXKNDwBGk
	 Ls11Vf2xCtwBv4iYDfWzD8OQw3uC5XR02Lw6L+jecuew6DwIFLoFNki+BBmCfIbo2WQ==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794475860;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Authentication-Results-Original:Received:Received:From:
	 Date:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 x-checkrecipientrouted:NoDisclaimer:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam-Untrusted:
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
	bh=jZE7IhtX1NmUiFMMT6bvC9A/apAk2w/Gp6I00CiyWq0=;
	b=B/S6buKgU/BZuHPoI35iI9N//Gk+wealdrFEdx4LNgT2XqK8szdtVeLa5+cxb9XVRrDX
	 HGqjsq+Gdi9XeFDvAyLGA0hNkM3AUcWtqyMJX+rhDl6720gRaJttrOTMNmcfg4auouVIR
	 h6boPkTXLO3y1JsX2lWoCyHvavMuxmXw1IzkCKmAoednXmtsPzFd5P6rf4IudiZAgVgad
	 AdxckI6rJ3x01iCsVoxzpShITm4r1q7nBLkO8YEhQWJ7nDjNRtn9/0EHvlZ0K+j2VuaaA
	 MUwIsAFCg0hNOuc82rt3H+hyYiqHWjIm2iJGuLK+IOYCVz4G/CEXlwammw9w5CquLjQ==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Ez6XqCrV;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Ez6XqCrV;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.42
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010042.outbound.protection.outlook.com [52.101.69.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0989606A31C;
	Thu, 12 Nov 2026 09:30:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0989606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Ez6XqCrV;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Ez6XqCrV
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TvOwNqFpRRPCiD8tX69pr41Wfa6NaQHesLhh8/x0GBH+jGztrsTPmuAU2S+s901QqTqO3YVIQu2ukBd9Catu0svgwIWxlSGnM/Qvv5+rVBferqVQNRDR7U57IOoh85RcsKfYE1ptO/HNef0lTZb/BtNRIkj6crN6xIWnIUcX46wlIifaJKCwPsWBcC5/QsOG47LAYDfgv9zsb0KK6qaAd1J3SfCCYJB2LiclTEGgw0ZUQJEDZP+b5Toz/zEyvBwOI/9oWbO5qtQQwHP6DNVu0NbFftw0ioI9ucsG6PaQXE1eUHZqSl2zINW0eZ4X5Yri7nReUCGo7M7WWs0JjwmYdg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZE7IhtX1NmUiFMMT6bvC9A/apAk2w/Gp6I00CiyWq0=;
 b=GBykGHRuRi1WGOUvImgchNb3AdrzKUSYfDg7Ak82MSOGcJnoT6vTRmcFcIRe13KKzskI+AKpmf+roRN+sAWqL8EOQ5Fl5hnKrYwp5yc/U9COVEmgoVfSd31x4hSFXuCJOmZnHALSQHXtfk6fGyhxNsbRGdiPFi5NTa/VJSy62aRvCrG7UPtXcT9uH880L/OIEntFmzX1COjmFmtFhwkUpGQlc2cPMDJLsvKal0gb85aG/24MwLff5lHVNvYhZrkZsjD4m+uwdKI0HLZ2WaXOHq391Ad1i0pumlsQVMZ43e72KGIqAtdUiqmVx7sD3lSmRsnEWJQgmC9FjdJ/YEZ4AA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=davemloft.net smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZE7IhtX1NmUiFMMT6bvC9A/apAk2w/Gp6I00CiyWq0=;
 b=Ez6XqCrVkAIrs3uf/Pvphnn80ty437AGFP0mArLZLa7WvoiPlPadRJ3yvQc100KNfCA4UljxBVKbMNLDOJdNNfNJUnI/3afHQC4vNImwu0AHKLqocTTRx2l8IdkZKPObdJv0cne3NMQMOciePvzh+hJyIhuQfKGZY6Y1bmn9awo=
Received: from DU6P191CA0016.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::10)
 by AMDPR08MB999845.eurprd08.prod.outlook.com (2603:10a6:20b:70c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 09:30:52 +0000
Received: from DB3PEPF0000885B.eurprd02.prod.outlook.com
 (2603:10a6:10:540:cafe::7c) by DU6P191CA0016.outlook.office365.com
 (2603:10a6:10:540::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Thu,
 12 Nov 2026 09:30:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885B.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Thu, 12 Nov 2026 09:30:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YAMNLFUf51JW1Pr8evq98Jpt/X0t5lmajKOVqo77sabRBdepWj7409IvXxLc2RSXBN8lC0PS1s57yFzU0p0RJv/QgvDTdWKPk63VfFeEk+Q6/vK0wGj27EiUlRw6TEJWITnvalmx3bVcVqML/EgxfGg6DyY56UiaFjOWq2zcEl1FhkOXQbMiei4xf8Cj0AEIN+nKEZ57Aj5dZcsD6ROp2Ah86771vNeouYtqZUYIOWEjZPCSAXPOhVQjpTEm/n1pMetL/zV5v2OU5/OcaHgnWzrC5wcgW8Q5ochAL5biTBQiWl2k6BuAfmcNIk5yT+NiJSTtRYrBZJ2eO1SgZKppvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZE7IhtX1NmUiFMMT6bvC9A/apAk2w/Gp6I00CiyWq0=;
 b=eRGA+XXe7aCNm4fArp6lYrQ7QxjQW2DwT31Vw7pXkV2UoxI+OzuEhy7MsNblIaCKT3k+HodTy0n0vRWWecOaxDKVHXVesOxMFGpkdN+6VzvrenOiFCmN8f5TEAgMhyia/JjFji0y2pZp1TVnWq9zYeZHBxZVAVpi5zlNLvy8g7YbJC31R6IuRPhtxWR2EAItD7lBsLhDUJLdqhZxOL9ldS4exMARA3qiPPAwTDGjbQx7lZyQGFVyIHmxm+MjP2Q9r1KL8FIWLK32A8YwPwxNAKl+mKRnyKlQ8jmcSuBXaYzCwmngv9xxNOGSULKRYwBTq4T6I4mS3CNVk8Mc81G7sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZE7IhtX1NmUiFMMT6bvC9A/apAk2w/Gp6I00CiyWq0=;
 b=Ez6XqCrVkAIrs3uf/Pvphnn80ty437AGFP0mArLZLa7WvoiPlPadRJ3yvQc100KNfCA4UljxBVKbMNLDOJdNNfNJUnI/3afHQC4vNImwu0AHKLqocTTRx2l8IdkZKPObdJv0cne3NMQMOciePvzh+hJyIhuQfKGZY6Y1bmn9awo=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by GV1PR08MB10402.eurprd08.prod.outlook.com
 (2603:10a6:150:15d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 12 Nov
 2026 09:30:16 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0615.008; Thu, 12 Nov 2026
 09:30:15 +0000
From: Bence Csokas <bence.csokas@arm.com>
Date: Thu, 12 Nov 2026 10:29:33 +0100
Subject: [PATCH v2 1/2] stddef: Add offsetofend() variant of
 struct_offset()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-offsetof-v2-1-276ede839967@arm.com>
References: <20261112-offsetof-v2-0-276ede839967@arm.com>
In-Reply-To: <20261112-offsetof-v2-0-276ede839967@arm.com>
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
	AS8PR08MB10291:EE_|GV1PR08MB10402:EE_|DB3PEPF0000885B:EE_|AMDPR08MB999845:EE_
X-MS-Office365-Filtering-Correlation-Id: ae20ab5a-52ec-49b3-1d47-08df409fa438
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|921020|10067099003|11063799006|56012099006|261022105027099003|261026140227099003|261028144727099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 LYrzVCPn8lc0cEz0ZiK1qU8q5Fm7Terg3KHUapkHS3OcyhinZhvC5qly16dLoJ6tll/GU3mQIGyHrm4UEH+G+NnA5mhS+URwDRJSWAv6yWBZJ61q8oa+w+qMWMlRgvnaP/CsipLHMBCKF38X2HBAxaAJ2EouAmgjKRMQ1PagdixempUC8NEoeZx3pmguAss3Fx6nnhp1pBUlDP58RMSQUg9L99SfNZQV1bxDfO1jyYapb7Khwif400DjsrYX+vuIVQ+QW59F8ZJCfsY9sRkNpDTh9TM3HH8ts8MpAGtA3Ch3QwnyOqb6ZjYe58G+LSowOhR/nGIYB6o+DOUwschlUKP4q92zUtRfIX7ox9v4KD/VtrYv7dcK0BZhGfMpyOyBTEcsM5jofJNJU1XrjylfhP/5ePVcWQsz86vXvXR2y565adBt6ojq4tap3FRKd2Jhbq2wKFpD5wOAXE3LV8EhnEFzhld/Fe1S+Af9AgE7zz8b+1ygmF9Ht4aZa2gnjRoA9Nd7uxifeoyVhxcGHHcSjbgqQr9kE0Mc7HNBQ6rJCkMQWT2hfqZudYe9niZ3i2hi5Ot7fpKfQBWhjmAZ8QGd7K/59ZlU7T6srPgKVP84/a6oBG8q77mA3xhHJBKh8xSYCmYIzWFxpVIspANW1UwAM3Mf9Usra0pOwq8m8GEHvPJ+uLaJlt4P5LLAB7ZU78rna8Hi7VGpZy4qWwqyIUIIzQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261022105027099003)(261026140227099003)(261028144727099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 R/rlwNVpSEeJejiroqsZAyJowDGmRSfl1BEpUU8snN4aklEhgAFEWXUI+5XRZwcv6SA/hnas+52SOpCoweJJwsCpvFsyX9IlbVFcyZkJOk1AFg6QFLPJMToP/KIp8YAMkIFLg00lVKn7147Mwar3R7IPNEQXee9jEH/4GvWCguOWcK0fjHwoELkkbSWz5BJ8V2uLHkHVdTNBZFDLp/wI65B7MvdG94k5bbaRoSDGdevz4gQBKe9E7hXN/PTwQubn1OlphMDwljo9UW/arA5vxMKHVvTdA59Q+hpk1d2pTDJ4QIILbs94/NkZKgrrlHmWa5jKiLZwmTIG1BMPYZGHeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10402
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3cf24f41-17f3-434b-b2c1-08df409f8f06
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|7416014|376014|36860700016|35042699022|23010399003|1800799024|22082099003|18002099003|921020|261026140227099003|11063799006|261028144727099003|261021121427099003|261022105027099003|261009223027099003|261102123227099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Mi41iVFS42Y4ijkOcEdLtduh04au3Ctaa8x11V1VAXo32pknKPcTPMXzQN/o4py2b56J567tAvY36cKtKiSNKmw1eQAxzXh80NyTLMkY7f3vTtM+KQtBzVeq3bs8ZV6Tvkkx2pOBBmqkKr3pffW0nCNarP1oKy9OPO3Cx0OQUHdn1Sa2YWwuEq0+NQVD2uQtaD3ANeAIRVAQwrH3gex+vnpMjZSC0aTC20d7tyXTZ5iGV6Ui3mKVhSv1jQ8XsPDDnE9L2vBxMZs6RixJJkW9nNUehwmoxSKx1WrUtqgslZ85TETQBPUZAMpLYnL+DEI5z9V3FZOhMNA4gvd+LhPY7w3MF4KWKEegAwq46G9JbnUz+Dbr8L40kwb0LNY8LNTk/PzHETrUPgYCw6OQfmIgj8I0UjZEUj5n2nxdygwiMmrY4lFvmph+msDELQH2uVAK0lOiSGlU7ErNvbgj56MPB7XjGWZYLoDTMAbfiWNoeW6jDlz5C5xktqhyO9WCbsHzcQXnzCuwHc639HiwrGelyia7jV85VvGEt0gaIYiAqnQdI6Oygr5ioZq3+pcv1mXxF1aV+NG9Cl+Q3k/i3Ki03cHOTVAFWY3G9vu+s4rLFIKdbgpGwlQIgV4wjToBGrLmyrXcMqx2y5O9maAdDDXd/WzgC9aPbRxn2nSaCpGaYOk6arD6tK8p117qDScXXeK/gN0Wtjk74Ktr3yKJ09G50vs5GvDDaFee30P2qopyx7MCTUG/kKjrItPLjuoIkgOZ
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(7416014)(376014)(36860700016)(35042699022)(23010399003)(1800799024)(22082099003)(18002099003)(921020)(261026140227099003)(11063799006)(261028144727099003)(261021121427099003)(261022105027099003)(261009223027099003)(261102123227099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yGup8012UgHlLQucFmNHZW0exhtlj1DSp5MlK8/Ce4QkOttAbtsrlBHoV8+WhYgIbjBvYmBXJNrfw9lBh3KQPoKtJbp17e2D65f/Gh3wjPlOn+E0vZxD8Kq1LRVfpihWQwMF/4gHPlg1j/hE/MSZS+odm/N6AtpkTQC9IELnSQDu7TvQ7L2PuOdihLbaGO4XRMxB2aKcywhG2KlwZsn8vZ8Z17E+Bivtlxq8aYuhSTCvWOoUnsqUqG3VVB3aZUFrTzbJ6mzP2laDoRU7ycUgx5/hy2TT+mxdm26r8/EQz0u80qMQusMcyC/w6XRhAP1xbRtjyMtkS3LT/8b2UOTnYDjw6MgBAtYcP1ENnCn+U1QjADggbHsEh7S32MFxGO5QvQAOzd8CzTypAZRqEwE0INSbJEcwvADf7nbiuX152tn7WPHSiAQp4AxIXWQjPfXw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 09:30:50.8346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae20ab5a-52ec-49b3-1d47-08df409fa438
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB999845

Many call sites of offsetofend() use it for the purpose of pointer
artihmetic. Thus, a common usage pattern is:

  offsetofend(typeof(*ptr), member)

Capturing this in one macro helps keep lines short and terse, while
still making the purpose clear. It also helps discourage spelling out
the type name on every callsite, leading to more maintainable code.

A similar struct_offset() macro already exists, so add an offsetof()
variant in the same spirit.

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
 include/linux/overflow.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index d0f04436343e..060dad4b6f3e 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -464,6 +464,18 @@ static __always_inline size_t __must_check size_sub(size_t minuend, size_t subtr
  */
 #define struct_offset(p, member) (offsetof(typeof(*(p)), member))
 
+/**
+ * struct_offsetofend() - Calculate the end of a member within a struct
+ * @p: Pointer to the struct
+ * @member: Name of the member to get the end offset of
+ *
+ * Calculates the offset of the end of a particular @member of the structure
+ * pointed to by @p.
+ *
+ * Return: number of bytes to the location of @member.
+ */
+#define struct_offsetofend(p, member) (offsetofend(typeof(*(p)), member))
+
 /**
  * __DEFINE_FLEX() - helper macro for DEFINE_FLEX() family.
  * Enables caller macro to pass arbitrary trailing expressions

-- 
2.56.1

