Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.70.53
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899077;
	b=gUF398OVP7BpasXI8in53N2VoXKfyFVgxiogu6LJR2hkxUSOFraNj7Q2vmEEUSWIXXW3
	 v0mjvkHlc44SQZ512UauF3ncou29w00XY6zaswbRfKTrGtJJmSxJ3K6bVLDco4xaBgpXn
	 g5hms7LXARGbFo8qv8ZGS0FUynofz7ZfFfX1TeRgWD1F5zr+9VC4pC/1xHNyV9DTpnaZO
	 lDKxhNEMVRXYJQt9cDgXwnDZ7wXjhR8HNmZWuXT4Rf4Wx1puy8ybuemvWYQqs3fIaIc/A
	 0rB2DSfb55inUyv1t15pgXbbhtquBV8ipOOdbsKgsGRLXDLzGCYNHpb8KP9MzoLDpsQ==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899077;
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
	bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
	b=xyVqhE9K3uOjlA5U8+jyq02usjSt2ZA4mjoJlWmRY2nuSpZcgg3i0ksKqAHCtrZK9JtX
	 00Gnbrq6dAmWmvYm4kvYaZNPJDufJt7QtmQ8BMbmWdKI9zbeQu+dsfROM9Pv1tFGzofcx
	 BRFz+k63r4KnsYfEK0TwHC+/G9mJpstQloFM1znny++qjfRj/T2iFQJZp6oszCOvU1hEP
	 rFO6z8eTzkYAozOLCLXNoBtMGM6bTbvKlaeutr2ryrIAVArvNr+3/Vsai0neeq3G4UVR9
	 K5Ul7iududWl8Qa6S35emMhVtQEk+8ssWCbW5Y/d8MF7TKzRAgQv3ezyaFGndvA6Y/Q==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=FSAvztfE;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=FSAvztfE;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.70.53
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011053.outbound.protection.outlook.com [52.101.70.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B468160A3822;
	Thu,  5 Nov 2026 17:17:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B468160A3822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=FSAvztfE;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=FSAvztfE
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=mM2RsxXH5Gvo4wDjWTh2iT8vysvkksHuaqyzoKkAHO08sPgqkzJ1i+d8v3o2PkA9hTH5BoTC/C0LRVoo+MhMfVsBAWJgkitk1WqvvAyXk3uosHmzoioner9fGO9XnqK4+EUeL0ZrRNAe18bL4ziKXDTHeV68GDb3Op+SlIYWgOc9SVmcL/YHOoux8FbU4mMmPqGpbx1VYdrJQb7C8a6rSQtTUfWP/dMkFdT4Rwvu1/tbT0+gyO9NORnfsum7g26mmAzsRWBp24JeYvjppuseeWSRDJbB28PqfLr7vbR1DFHx+ouRp/9BaP8BU4xe896NoewDOXEXAxtrZRfY28oV/A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
 b=aW/a0Mp1u5MXKpVqmK1hE2A3Ovx4bgvz8RxuLI6iC7STUEtuklUWluap1+ml1QExyxsDXpvbYXvvT8MronfvRtDHq2XaTLaTG9COI2H6M/VOnz0ZRmcSUnJquI6y3aUOE+baG7sEQjV6dQ5iW7NlFOC4S0nFEq9bOl1TNFSoZjTSw3dNXBtDtRsKdqM98y9nrH8bU4iZ6Eo4moHeynaCkcqSIIqsuuJxr+mzh43a2zgZJ55DhNthiADGCgQwwYIbbC2cdh9x73JWwhR55KpoAFlEpvcw7a47CuRtUbqVzP2A4PX23cOV/EtyuI16CEiMjQti+6/u3M9b/yAL9hHPbQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=broadcom.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
 b=FSAvztfEPnknaC/TMy3ESjhRBjjRXq/zp74UI0MrAnJj7FITg+55aSuRjoVG4owmEIiL0L3oE0wVskuug2uVtjVZjaEWIXiy0LgDR7UC1xFLYYON2o9oqNdV8uI1m8QGdPPKCWSgH/9fYPHdSEuApIdfPjc0KxYkFGmREC1m3zY=
Received: from PA7P264CA0022.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:2df::10)
 by BR0PR08MB637335.eurprd08.prod.outlook.com (2603:10a6:2c8:64::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 17:17:50 +0000
Received: from MI3PEPF00008491.eurprd03.prod.outlook.com
 (2603:10a6:102:2df:cafe::12) by PA7P264CA0022.outlook.office365.com
 (2603:10a6:102:2df::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 17:17:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008491.mail.protection.outlook.com (10.167.240.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.5
 via Frontend Transport; Thu, 5 Nov 2026 17:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ylgddM04/VpwnH9LjtAmsAH9Y8XtIOv3v882jdIzqIFg288FgiJWlYx0C8n3SGvCiRsqR0sxvX4K276CApFuox/5K5cH2L4igyP1FnF+QUqDRyd7h9/aYumPr9sQdWtU3uzKfx/0dNhuYDkNbvv0qnmBfbWnfgtRDYVnzAm/1k4uSHyDuw6WVcp8laiZUxT5A9t5Z29Y5xvSSfNrf0c3BG0eZhY3SEbdZTNdvWSLUlLhgr1XbTqZa0VLWIExoCxxIgefTOe/V4ZIPDC0oZcq4zlcioZAXqjJwiQsca4dn/9BeSL80tKS6mfrSLfXrkIRJ446uupm6/aFC5dLDlxerw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
 b=XuwnLGQDwL7b0bd9imEGYO+LROwrlwX68atkLYWusea1mgDRNtXFGqvpom8Q3zP2/OaL9Njkppu13XdpwEwiPewguLwDVeBPzeeBQlGS89/R2AAs2nQZ4jlq6UFbkW8WKXWE4oAtQg59bbsp5Dul3XAG4onbNnfF0wV85ODW600rM+CvAx1iL+x0M2tP5J3av5KX9H73M3JWBWwPNrKsoGWo6GFLRRTYDUxpYe6JrEVoAwSfpOpI6FvDwh4f5vvrN7GAJSVmBM5wYQ4i+n/HquK41ppHRczPar2uV4NwnA4KoCTngFbMHCQLWcNPX6u8+zXCdLD8ECQbe5KJjxo3/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
 b=FSAvztfEPnknaC/TMy3ESjhRBjjRXq/zp74UI0MrAnJj7FITg+55aSuRjoVG4owmEIiL0L3oE0wVskuug2uVtjVZjaEWIXiy0LgDR7UC1xFLYYON2o9oqNdV8uI1m8QGdPPKCWSgH/9fYPHdSEuApIdfPjc0KxYkFGmREC1m3zY=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by PAWPR08MB10897.eurprd08.prod.outlook.com
 (2603:10a6:102:46a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 17:17:07 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 17:17:06 +0000
From: Bence Csokas <bence.csokas@arm.com>
Date: Thu, 05 Nov 2026 18:16:16 +0100
Subject: [PATCH 1/3] stddef: Add offsetofp() and offsetofendp() for pointer
 arithmetic
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-offsetof-v1-1-4153f5c10edc@arm.com>
References: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
In-Reply-To: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
To: Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, 
 Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
 =?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Vineet Gupta <vgupta@kernel.org>, 
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
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
 Hans de Goede <hansg@kernel.org>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 Benson Leung <bleung@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
 Guenter Roeck <groeck@chromium.org>, Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
 Bharath SM <bharathsm@microsoft.com>, Carlos Maiolino <cem@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
 David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 "Geoffrey D. Bennett" <g@b4.vu>, Jaroslav Kysela <perex@perex.cz>, 
 Takashi Iwai <tiwai@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-wireless@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
 linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 arm-scmi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
 linux-hyperv@vger.kernel.org, chrome-platform@lists.linux.dev, 
 linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-xfs@vger.kernel.org, linux-sound@vger.kernel.org, 
 Bence Csokas <bence.csokas@arm.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: PA7P264CA0148.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:377::20) To AS8PR08MB10291.eurprd08.prod.outlook.com
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
	AS8PR08MB10291:EE_|PAWPR08MB10897:EE_|MI3PEPF00008491:EE_|BR0PR08MB637335:EE_
X-MS-Office365-Filtering-Correlation-Id: c95f7fac-fa98-4f15-103a-08df3b60b84c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|18002099003|22082099003|10067099003|921020|11063799006|261028144727099003|261022105027099003|56012099006|261102123227099003|261026140227099003|261021121427099003;
X-Microsoft-Antispam-Message-Info-Original:
 mr5OB7YJkX4sA+UAoD5rIJy3VTvVYYdViPg9GzAW7Tq5jQNBv5IpbZJMaV/vr4lw6bNREXCtAuvO23wv5lboaGb2iyHxKueczHoZaLQruXjnJ4YsCWbLpTEYbaLN2b3JvrgYbeggZrgBqdNLIpGvM0KDUI/1Y2SuF4oHsDFUPNwtOd/2FLXh1QbEv73jXLyrVk7IWKQRsxMQyKYZF5QyCPh2HS3n1cmt4i6rX7DLoZNf9ln06GSM9GUJZzgZ9bqKU/aX5Y7Kop665I4/c4mR/yqeN6QA/MtQ4AHgb6wdpXFSZyraqBC11X7fdax/7ceQntHlN9bu9h0G4M85891n9S/oHiGnfiA+SwRWOJIEYH9ht3/94aPp8GdFObuFMlJjR9WRsVwhddQCTzRxi6NoJYQPREiL0F6SmYlaL5uwXNcrhzCeKzLeUTKfj4Fw3AL7XHfiCwpX9Jf/ZHlovSnr6Kg8NeVaS1won8b6DFaSYRRFdbvViur7VcgJphgovJ5nBuCAkXqOE0Z4lMc09/q5khyBH98Zu4ffavRIyp5gqu/c0oWEcxjDv3FpUyVNkzPANuxvwxTF6b2vxulqsbgGivqeVmRNSqfUlFyr7hL3hNZbvJums5toHYZtNQYVdZFx5mbIctvTAZoX7OmZbmBex426aM+aO0s8jTJNsdnA5fLXxFg2wvIN0XC1qJh8+wQi9EH5FRzWFRAL2zpsu+jvug==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(10067099003)(921020)(11063799006)(261028144727099003)(261022105027099003)(56012099006)(261102123227099003)(261026140227099003)(261021121427099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ET/QPDjVBSYkB8BUfVvcUDBeNRCOk2q3Cf2mO3C0HiuTAFVggj+y8VTqq6VaDo9mhlFYEEM4ZKPI5OCip1bcAZaPjBdAfEGNZKkBeeI4/g8jDco4K3dFDZ68IgTGyXZFh70/3fz4tfUqbMN9OLpR6s0kwCdHgaYyHjyJMJCqjFHz6mwxuLnanowdZomKxYxXNMKPdIdVgT0/PowPWsbP+M//dYvR2MIfHFaoeRUHiZaHcXqhixWJvo57kZjhyJCpZrE1WXDjjIhOHdXt+iT+2cpJ7P1DskNvUgaqafnjFSIhNLZNth9Z36G1pOdK2ZnP9Yx46uPe5cq4WiF3Rdz5CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10897
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008491.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a755c22f-cf8f-446b-21f1-08df3b609e27
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|35042699022|376014|14060799003|1800799024|82310400026|36860700016|921020|11063799006|56012099006|261022105027099003|261021121427099003|261102123227099003|261026140227099003|261028144727099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FVxtmx0RVhe2Oz7PMTgsAQd5MQUsMtxuvogiub8A5ICAemH/vngvqLe/+4hiBXm9ylYOxneIikN10c03I1ilTby+yAML+b6Bk311xtrFDKsAJpOi0fW1prdcTYsXOlenotkxNO+kViv4ZjVD0b4LjcwWWmKwW1z6HDtgp2OVRs+hh9t14lr8RVVrq3gsSDQr0zcqxlOcp4v/JI2WmjIH9apa/C3QOPvNPHuJ/oLzAQWk1e8spxTrDU6HyPiS+4M4yUOrygmMM26Qssz2fZD4hLu9AiimSeFrxOJKQpgJVN6QGtMhwGjCMZUBki5rfl0x6rsy1NiyGapS0G3Oy6SAv7jUPjbStlkQJuPfT5uG49o99aXSPVleD3pnYqpO5upRh6tuYIovPOGcay+Ro9obt/tnB2oCOb+x7AHcMLTh97ESY9NHHE1gITFO5qgaApTxpWVXJELN+n5iATf8Cg1rzv8nJy62YaljDVJutgbPykgr7yROC3E/kr56emjnDNT0p/XSX/9VG9x1CTxME+ICF//H1WqoA7ZADyVljJYvyT93LiREePT4Fw+vPVb4rop6n9+FBUbnxC7MpOqvhI2DlCdp0av0MSNJbM4aM6Wr2DM4U0dF/EX0l9UgiZ/lAIJ3o1rFVe31O6fd0Cx9y/k1ElkkzZIUQ7ygvrLsotXeNJD1YP5E1iMzTCAaXF97Zrh31ZYBQWHRupULediEFQoVax4KMZc6isF0AoRI2RCicx2uAcbMOqkPhj8ehEc456Dm
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(35042699022)(376014)(14060799003)(1800799024)(82310400026)(36860700016)(921020)(11063799006)(56012099006)(261022105027099003)(261021121427099003)(261102123227099003)(261026140227099003)(261028144727099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	doEdW0Ovwo/fozcW/icqAlvMqQIY4P39gqyuCIcktJZ4E8dxSg8hjxdqGP58ApxS5EtLzaJ8g6ozIkaIYukSVK9KXiCc2xzbwkwkBnZEex2QPXPpniJTjYPLbBqJh/1jW6e0szpHxdqptIdJdku0y+PJsVNMrmf6x/FbskrN8L6r+oYpUZyrqWjSQ/23x1+ac85ni5qWZDcKiLZfTRDuumNkFWuxF7Z6RVt0uuiNiuFUUcjdv7Jg4fSz6bmjQoyJYONw7via7NaFIpjfQvD4uehSLxojXsDi0PWVxkVOZQ3Yo2vdKdFLWevQ/BBk+Di7LK6RzeC7O3qLAqxGNB61Ga5yq7XBgZ3yCRHsaCWd5tISEnSaP7Gtn7vTERjVgagDMa8x9wV/2HtaivXIzlMxPNoEU37s8v3GAX7GSkpd1igKo9e329GalsMWQti/fJvi
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 17:17:50.3134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c95f7fac-fa98-4f15-103a-08df3b60b84c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008491.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR0PR08MB637335

Many call sites of offsetof() use it for the purpose of pointer
artihmetic. Thus, a common usage pattern is:

  offsetof(typeof(*ptr), member)

Capturing this in one macro helps keep lines short and terse, while
still making the purpose clear. It also helps discourage spelling out
the type name on every callsite, leading to more maintainable code.

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
 include/linux/stddef.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index e1851c50c89b..87f0e131d235 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -32,6 +32,22 @@ enum {
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
 
+/**
+ * offsetofp() - Get the offset of a struct field from a pointer to the struct
+ *
+ * @P: Pointer to the structure
+ * @MEMBER: The member within the structure to get the start offset of
+ */
+#define offsetofp(P, MEMBER) offsetof(typeof(*(P)), MEMBER)
+
+/**
+ * offsetofendp() - Get the end of a struct field from a pointer to the struct
+ *
+ * @P: Pointer to the structure
+ * @MEMBER: The member within the structure to get the end offset of
+ */
+#define offsetofendp(P, MEMBER) offsetofend(typeof(*(P)), MEMBER)
+
 /**
  * struct_group() - Wrap a set of declarations in a mirrored struct
  *

-- 
2.56.0

