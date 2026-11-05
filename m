Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.84.20
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899080;
	b=TBSa3CIiEzd5VRimCbr8ewp+LQqoQJ/LV8UfvL2/X5oNbMemCk32HOmwcq5hIe12ArxI
	 P+hzWU2XBCRN9nuzdkp/Ibxh+2bIRM78nocGU1WfT0mbr1YsBd6TMl+t4w5ogk6ORwaOZ
	 JjquKKDfpG1UKIWutWXSVuZbZbIi+v2sSU+dJkcGrYLxi48AN+KB5L8lxor6XwwLxTSh0
	 2cdY/H5yt1WR7I4u1SOeJunxd9TZbLyqKKeql/OEnmEg4/xJVx+4wYrxXRte6xCtcSZa8
	 gyHceJFoZ9/bSJaWu1l6dRXyquirj35QyBH3WBVceboaHCl30EelppW0f6eV+vFH45Q==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899080;
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
	bh=nXTsHjQcnnMdoXEbEGISSMv9ToXiMyeq9T2Li3jSvgg=;
	b=jX9BT5hDpVkY2fgjTlU/NZBQ/vUoP9ANvh0u7wHc6ltU+ZGSZuNPmivn6cBoKGtSM44a
	 k/QGUDZBHKkn6xwBWkMzcyR28J0ARgutDyeoMwxAhjYt9a5Ohb84pAgs0nvs/4YCkmtTp
	 EQgTmL5lcLLrEHsA9/tmi4L5k/nq7M9rjeaEVcX7T0ss5FHeIIZ+pn5keNPLCbcb68w16
	 zi0NLRsCecXu85/CVay2pNKqeNHVZHsYwRxYS3BkcYjaHzBxUYwfogfmlwG1Zm3xhuD/g
	 tcUHgdTSltVO/osqdit3zbcXTqQBdhrGxgXm7HoXaGyjqKSuqEKB5qn7vuafCWf6TNA==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=b+EBxRGG;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=b+EBxRGG;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.84.20
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010020.outbound.protection.outlook.com [52.101.84.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ED660A3838;
	Thu,  5 Nov 2026 17:17:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4ED660A3838
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=b+EBxRGG;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=b+EBxRGG
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=EKs6IX7u9KW12NwrfQaUjCrgvA7ZDdiIfXiZ9K9b+O0fWwVtbe4Qbvnb6G9V67UiTl+xavjG4b7KYwotjgBegh1S3NeCxeO68Dm8AUetWgy8Cb4WatbfKjOHoH45+h8oirznMfyrkrhe05TEBahi93YEyS2dDi/TCFyZNYBJr1149dhvmszYr5RsdBaHGURbEvVtMFTuPDQorOU7l0rU2Lpr8uLPoELu4mCvVUGkmN7rA3jID+E1+suWa4VrEQzCUq9fJ3nlNT8PaRqSTNMmyU2EjcwVuebLAdLC2JDlwE4WonSMQQZUuandaOUYPLfnqwZcc9Dk0A7o7WGNurWw2g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXTsHjQcnnMdoXEbEGISSMv9ToXiMyeq9T2Li3jSvgg=;
 b=wTYbbA+3gRl/dzUGGFDdGCPdMg8O+vOLM64x4X1ekxaeyzLVFBgbVLu9QemM15ptXrWMH3WjGQ/FTIeGnMYxWrupNaEiy5mVPl1VF2EcRN5lozReOH26JBIoZOmYC6eEvVjsZhJj3wnR7ZWzyoeAqZoCiq48d5LceZsWbSvSxyXA/5emXUNjx+9zFAJFCG3FZaU6ZbWwygVW5oqEqnUf9KlPGJbEScBx0xRIoNOuDiieC9oXmaCXNqqwkXvI+8UrMRLQHSzLMm3J/OIo2jo9I71GdQz6Xvan7qDCHs2TIYgc183B21pja7u1aphOyzglFKtxjGF9jnIcPp5pCnsv9g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=broadcom.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXTsHjQcnnMdoXEbEGISSMv9ToXiMyeq9T2Li3jSvgg=;
 b=b+EBxRGGNUugQiZgKExrNKX/wZHJwS8Ikal0IIf+H30uAPr+dFGexrE32CQpHyy5//0ejYNv0mjLRrpnICwC46igN+sgNsT+LRqPH5BLItMh6yqJjVLBQbFA87eqGdzwLD9XLd+JT0IyRvphRkZ8NfYtUoqnpskdM+JKSm82TVs=
Received: from MI1PEPF00000AD1.ITAP293.PROD.OUTLOOK.COM (2603:10a6:298:1::4b7)
 by PA4PR08MB6207.eurprd08.prod.outlook.com (2603:10a6:102:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 17:17:51 +0000
Received: from MI3PEPF00008494.eurprd03.prod.outlook.com (2603:10a6:298:1::5b)
 by MI1PEPF00000AD1.outlook.office365.com (2603:10a6:298:1::4b7) with
 Microsoft SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id
 15.21.592.10 via Frontend Transport; Thu, 5 Nov 2026 17:17:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008494.mail.protection.outlook.com (10.167.240.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.5
 via Frontend Transport; Thu, 5 Nov 2026 17:17:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jqFHE1hrIpud2bkDR3aFFjt7lE5VjDN/bqqxI+ia3CIrKGrgaq/zoNbe0+OiY0KKfqpw5QrJ4006JIFEdppyTUvtYE0o3Cx2Gl4W6oCcW5QcEhMOHHmhHZx/FMNDo8jjCJjIs59t26V5vG1wJ3e/xRQOS+ExP3V9Y64RCX/S/8miLvgva6ihEYXIb5H/a1Mmq2yPMHhRn7YYW+f5IHeUkI3H777cPvBt2JV+Lwl1YANw7hVgGO3MFtD3Hi87D9ddwcYzZfsb2dql/a8fL9FeFJIa+8shjQCSPblFgjzQRraDy1KyTUXBWe3V/8SgbXxWksJkzUpZdFvgdqGt71+idg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXTsHjQcnnMdoXEbEGISSMv9ToXiMyeq9T2Li3jSvgg=;
 b=vI8TtUQa/IsE6ZlSiRm86q4fhCxDImit/M3FkR1AFJwFjpakVUVPStXV6mLLNz4WJa6ESnrw6Foakfth8uAkugBktW0r95AgH2l2OejeMFqrrGEMKR3Aq9eUMeqOzfidOCwo30edw8VJWBpPrAwpy62zLIWSBwCTXx2HiKe2l7lyyT9i/F4ZdzVMZp7Izlyk7qz1Ojilm2Gg0ivgSxc2/2gpiWDiZTMIRbL+j7TnGFu6XSUwumGIXyL4EJ1bk+j8TnANJ4FMta2imxOEhurcZR6GaeyjZirumNKheK41xxD8uvE98V0ueczSMUsaDALoGOOS7BkRN8jdT/9ivYLNBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXTsHjQcnnMdoXEbEGISSMv9ToXiMyeq9T2Li3jSvgg=;
 b=b+EBxRGGNUugQiZgKExrNKX/wZHJwS8Ikal0IIf+H30uAPr+dFGexrE32CQpHyy5//0ejYNv0mjLRrpnICwC46igN+sgNsT+LRqPH5BLItMh6yqJjVLBQbFA87eqGdzwLD9XLd+JT0IyRvphRkZ8NfYtUoqnpskdM+JKSm82TVs=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by AS4PR08MB7556.eurprd08.prod.outlook.com
 (2603:10a6:20b:4fe::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 17:17:11 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 17:17:11 +0000
From: Bence Csokas <bence.csokas@arm.com>
Date: Thu, 05 Nov 2026 18:16:17 +0100
Subject: [PATCH 2/3] treewide: Use offsetofendp()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-offsetof-v1-2-4153f5c10edc@arm.com>
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
	AS8PR08MB10291:EE_|AS4PR08MB7556:EE_|MI3PEPF00008494:EE_|PA4PR08MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: 961308bf-bca2-4f17-66bd-08df3b60b90c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|56012099006|261022105027099003|261021123027099003|261021121427099003|261009223027099003|921020|261026140227099003|261028144727099003|11063799006|10067099003|260925022911599003|260925021911599003|260925021311599003|22082099003|18002099003|261102123227099003;
X-Microsoft-Antispam-Message-Info-Original:
 WF4Gfekt5TE7hUIy5BEk55160yV11Vhz6McZmVNQI016ZTr1MN0Rqd66rWFJLHUjaKwl+MvvIG1SXd5eUrY55ovMpFTFhL3v0ipt/VNSn2StuLOS9q15Uj5eIxBJ1Zjkqr8x9Hl6JljvISbRl4bGwJ+DxOJ7zLcK2Z2DqAvFT/sc37J7GGTXkIas/N2/OE88UIX3Gz+YUiZrPMnw5q5EzUkb8/IyVPmnoAuZUmNxCjSQHMwbV/laeJj0JSaI3BxV/v2sQ/D9GnSs/I+vYd2QDdu96Qy6cSbIi/jXbalkZIV+EkSr/UJvVAxeLvIcXlBJJqti7Cg6c1hZeoKHWNT/kH6DepXcZNzxZBkIM9zcXIzjfDGHSmWjb57cqQJvxMKnkXWMZvyQ5Ql+/6pOD3J/cXskKbXUmzDLEubbwvpRDXBv+rWvDLDlC3ZXdPYLHitG52FPx/mS8+Onc8OB3+qV9K8Sp/f/pBmycKQW9tmhThmcx9dAcFcdYNSwqGoEWybccZ/7a6Uy/Vtz+WdFV1tOSKDllXWtG5v7BcyJYEAtF+oXHkF+7lwdHLmh0SUvP/7RBzKN+b2T05nHJeFwMbDt2m7C5JLkRKNHANMiYDZMWr606q5TPpoqdvlwYRnWsOQGpLGudwZ+YcuHSatDAmiJIDPt6fa7oFlM/8TZDJhb8PFn5Ago9QwLQYTIpDJngeyBUKChR+R4hNCD/9id5FrVnw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(56012099006)(261022105027099003)(261021123027099003)(261021121427099003)(261009223027099003)(921020)(261026140227099003)(261028144727099003)(11063799006)(10067099003)(260925022911599003)(260925021911599003)(260925021311599003)(22082099003)(18002099003)(261102123227099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 mBY/MOAhuNr81hr8LztTgQ+08lGKmUY8Cd6lhy2UQijkULaLb8jxeCFYxViYn+EjKjGXx6sS3eLzUUuvtY/3wDSo33Bo0dBEyKneVXrUHAXEDVHjf4n9Qj6Tut1KKog4u9GmnIc9RO+6ovZ52ghAm4WVQ4vY5W9lQmhTmdxLuHGUcOIfySEeG3gxch8S5Jk7LZfsO/JIKqm4eXkpwi3pH0OGLbFg9cqPN0Mbz7trqzf8AvOJAO0edmPNLppyLrdtScoY8dmPOaZtoMXXQ2T6WnEKGrNVOTOrHDM1SvFGqWLg+Q4O88+tkRHVXSjae+Iw3E4rbIUsfgpxXDGY1JlBAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7556
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008494.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ed70a0bf-e17f-4a66-95b5-08df3b60a0a0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|23010399003|14060799003|1800799024|35042699022|22082099003|18002099003|921020|56012099006|11063799006|261026140227099003|261021121427099003|261028144727099003|10067099003|261102123227099003|261022105027099003|261009223027099003|261021123027099003|260925021911599003|260925021311599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	30vxGvg4+CzrJ9w30csliaEfA/1lotic1kyphNMX4oIJqMQQJ4OIjyyxBpJuu+YlY2CU2Ylwe8oPD9w9roBX1dbZl/p012RQ2p+/IeB/nG0IhXnAGMvJmzIAX3GobcuitZGRvGlKsqwoHAfMgka6nOWOYAkydYaDluHpA56oyUBPaPplqeibQEPb8yzuSDUUAN7yTan18/GntB4g1C/y1pQONsG/jTMaLF2rk2HQQS0+hx0yCr/vLxzZB5YWSP57f5Cpnve6hfuUfLo1ARRxVLmk/lUeaOiHcLtUOFbIGeEKoQoV8vf9ScdMFHy+kJcPuJM12nlb8X9w/TNaKVIi0xHw7t+j+ryPSTxWGdR0v3lDufKgsnnXLYKp6Gga5S+WR/FjLRsDZQQjqUPOYfS/oVv0mS7pxpTIw9B3lO9RsYf5gDHIJWlpgkDUpxiYdJAVba+4q3WBPgu4itIerkxYFHz4PCzh4oebI1eQdDloRNivZZWTB0hDVRcJ614aiQOk7TfAEmobtx3SGSWoUmgcUUzoWMJF3QNxaZrXSwNyKWPYBIsIxy7RSQPU/J1bDJ5e93J4a7tHdXv2gB1EKOqO9p2heEvb7t8ezhhRcejWZQGf7gF2iH4QCNDtc0YWo1M6rSUy4u8JScY7SQ5JRdzoi6+8nqXkEp10TIsP3KjM+uzxZvTDrd72rrwOPCc3Wd0P4iI/1Y0GcvJwP7MjLT2a4TZwo8rfwyucQYi93U9rUIU+wzCG4SQOcnk8q7kC0zXj
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(23010399003)(14060799003)(1800799024)(35042699022)(22082099003)(18002099003)(921020)(56012099006)(11063799006)(261026140227099003)(261021121427099003)(261028144727099003)(10067099003)(261102123227099003)(261022105027099003)(261009223027099003)(261021123027099003)(260925021911599003)(260925021311599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9+2Z7hUYb9gmql8TbgxWsaf5lYPB2ygy6YkWC1ApAbUdR4mdXWt5KpDRHpFLPpn52p9Ke9sMn1AguJwHWwQ48/thFuoJYUHTtEHKINaLyKdzQ6JHyJvyHOEtrBk0kh9dup1heIDsY0wVGeIFbO3EFYHMY2zen8nbC77qwEFEr6qNgLXgN166D685/hPy4yEQaDVNfFugAhp+dtyQfssNrD6rwup0vgTurrtYqZE44qqZnfQZ9sk1LUh9n/WRLvP9sZuGX+RehePAPwcaEdqNtqLzr9CQelCbxWk3+R14gFnmb0QMn86XDBdYdW6uj2sUvHCOjI7LSy8KjkrgIp6hGNdrbIimr/Mf7g62N5SoD5zlOgV6MzTGn7b9dGKmf+LT4qEmyjJDYogi3Zw8KpnIl6dm9bY+rwtrOahJgAEnbNhIjFPHFi09i1l3dhvNxPaa
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 17:17:51.5677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 961308bf-bca2-4f17-66bd-08df3b60b90c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008494.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6207

Generated with the following simple Coccinelle patch:

@@
expression ptr, member;
@@
- offsetofend(typeof(*ptr), member)
+ offsetofendp(ptr, member)

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c                | 4 ++--
 drivers/infiniband/hw/hns/hns_roce_qp.c                | 6 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c | 5 ++---
 drivers/net/wireless/realtek/rtl8xxxu/core.c           | 2 +-
 drivers/net/wireless/realtek/rtw88/fw.c                | 2 +-
 drivers/net/wireless/realtek/rtw89/fw.c                | 8 ++++----
 drivers/net/wireless/virtual/mac80211_hwsim_main.c     | 4 ++--
 net/bpf/test_run.c                                     | 2 +-
 net/key/af_key.c                                       | 2 +-
 net/wireless/nl80211.c                                 | 2 +-
 net/wireless/reg.c                                     | 2 +-
 net/wireless/scan.c                                    | 2 +-
 security/landlock/net.c                                | 4 ++--
 13 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 7dfaa01cda67..0755f365873d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -287,7 +287,7 @@ static int alloc_cq_db(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 
 	if (udata) {
 		if (has_db &&
-		    udata->outlen >= offsetofend(typeof(*resp), cap_flags)) {
+		    udata->outlen >= offsetofendp(resp, cap_flags)) {
 			uctx = rdma_udata_to_drv_context(udata,
 					struct hns_roce_ucontext, ibucontext);
 			err = hns_roce_db_map_user(uctx, addr, &hr_cq->db);
@@ -378,7 +378,7 @@ static int set_cqe_size(struct hns_roce_cq *hr_cq, struct ib_udata *udata,
 		return 0;
 	}
 
-	if (udata->inlen >= offsetofend(typeof(*ucmd), cqe_size)) {
+	if (udata->inlen >= offsetofendp(ucmd, cqe_size)) {
 		if (ucmd->cqe_size != HNS_ROCE_V2_CQE_SIZE &&
 		    ucmd->cqe_size != HNS_ROCE_V3_CQE_SIZE) {
 			ibdev_err(&hr_dev->ib_dev,
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index c6c0dfdbdbc3..55781c1833e5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -836,9 +836,9 @@ static inline bool user_qp_has_sdb(struct hns_roce_dev *hr_dev,
 				   struct hns_roce_ib_create_qp *ucmd)
 {
 	return ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB) &&
-		udata->outlen >= offsetofend(typeof(*resp), cap_flags) &&
+		udata->outlen >= offsetofendp(resp, cap_flags) &&
 		hns_roce_qp_has_sq(init_attr) &&
-		udata->inlen >= offsetofend(typeof(*ucmd), sdb_addr));
+		udata->inlen >= offsetofendp(ucmd, sdb_addr));
 }
 
 static inline bool user_qp_has_rdb(struct hns_roce_dev *hr_dev,
@@ -847,7 +847,7 @@ static inline bool user_qp_has_rdb(struct hns_roce_dev *hr_dev,
 				   struct hns_roce_ib_create_qp_resp *resp)
 {
 	return ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB) &&
-		udata->outlen >= offsetofend(typeof(*resp), cap_flags) &&
+		udata->outlen >= offsetofendp(resp, cap_flags) &&
 		hns_roce_qp_has_rq(init_attr));
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
index 0009a05511af..533b41fcd1c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
@@ -241,7 +241,7 @@ int iwl_pcie_ctxt_info_v2_alloc(struct iwl_trans *trans,
 	 * optional; old devices _should_ be fine with a bigger size,
 	 * but in simulation we check the size more precisely.
 	 */
-	BUILD_BUG_ON(offsetofend(typeof(*prph_scratch), dram.common) +
+	BUILD_BUG_ON(offsetofendp(prph_scratch, dram.common) +
 		     sizeof(prph_scratch->dram.fseq_img) !=
 		     sizeof(*prph_scratch));
 	if (control_flags_ext & IWL_PRPH_SCRATCH_EXT_EXT_FSEQ)
@@ -249,8 +249,7 @@ int iwl_pcie_ctxt_info_v2_alloc(struct iwl_trans *trans,
 			cpu_to_le32(sizeof(*prph_scratch));
 	else
 		ctxt_info_v2->prph_scratch_size =
-			cpu_to_le32(offsetofend(typeof(*prph_scratch),
-						dram.common));
+			cpu_to_le32(offsetofendp(prph_scratch, dram.common));
 
 	ctxt_info_v2->cr_head_idx_arr_base_addr =
 		cpu_to_le64(trans_pcie->rxq->rb_stts_dma);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 3d0c22db30a8..289e0068d7eb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -6167,7 +6167,7 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 		case C2H_8723B_RA_REPORT:
 			bw = rarpt->txrate.bw;
 
-			if (skb->len >= offsetofend(typeof(*c2h), ra_report.bw)) {
+			if (skb->len >= offsetofendp(c2h, ra_report.bw)) {
 				if (c2h->ra_report.bw == RTL8XXXU_CHANNEL_WIDTH_40)
 					bw = RATE_INFO_BW_40;
 				else
diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..f3b45666fcb5 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -159,7 +159,7 @@ static void rtw_fw_ra_report_iter(void *data, struct ieee80211_sta *sta)
 
 	rate = u8_get_bits(ra_rpt->rate_sgi, RTW_C2H_RA_RPT_RATE);
 	sgi = u8_get_bits(ra_rpt->rate_sgi, RTW_C2H_RA_RPT_SGI);
-	if (ra_data->length >= offsetofend(typeof(*ra_rpt), bw))
+	if (ra_data->length >= offsetofendp(ra_rpt, bw))
 		bw = ra_rpt->bw;
 	else
 		bw = si->bw_mode;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index ea7dba077f5d..91f8cefc0226 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -8067,11 +8067,11 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 
 	if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V0, &rtwdev->fw)) {
 		ver = 0;
-		elem_size = offsetofend(typeof(*elem), w7);
+		elem_size = offsetofendp(elem, w7);
 		used_len = sizeof(*h2c) + elem_size * ch_num;
 	} else if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V1, &rtwdev->fw)) {
 		ver = 1;
-		elem_size = offsetofend(typeof(*elem), w7);
+		elem_size = offsetofendp(elem, w7);
 		used_len = sizeof(*h2c) + elem_size * ch_num;
 	}
 
@@ -8350,10 +8350,10 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 	rtw89_scan_get_6g_disabled_chan(rtwdev, option);
 
 	if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V0, &rtwdev->fw)) {
-		cfg_len = offsetofend(typeof(*h2c), w8);
+		cfg_len = offsetofendp(h2c, w8);
 		scan_offload_ver = 0;
 	} else if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V1, &rtwdev->fw)) {
-		cfg_len = offsetofend(typeof(*h2c), w9);
+		cfg_len = offsetofendp(h2c, w9);
 		scan_offload_ver = 1;
 	} else if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V2, &rtwdev->fw)) {
 		scan_offload_ver = 2;
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index e53714b81ec2..8679c8758ee8 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1622,12 +1622,12 @@ static void mac80211_hwsim_write_tsf(struct mac80211_hwsim_data *data,
 	if (txrate)
 		bitrate = txrate->bitrate;
 
-	if (skb->len >= offsetofend(typeof(*mgmt), u.probe_resp.timestamp) &&
+	if (skb->len >= offsetofendp(mgmt, u.probe_resp.timestamp) &&
 	    ieee80211_is_probe_resp(hdr->frame_control)) {
 		mgmt->u.probe_resp.timestamp =
 			cpu_to_le64(sim_time + data->tsf_offset +
 				    24 * 8 * 10 / bitrate);
-	} else if (skb->len >= offsetofend(typeof(*mgmt), u.beacon.timestamp) &&
+	} else if (skb->len >= offsetofendp(mgmt, u.beacon.timestamp) &&
 		   ieee80211_is_beacon(mgmt->frame_control)) {
 		mgmt->u.beacon.timestamp = cpu_to_le64(sim_time +
 						       data->tsf_offset +
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index d6c9dc62182e..3862cfa041fe 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1613,7 +1613,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	if (user_ctx->sk)
 		goto out;
 
-	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
+	if (!range_is_zero(user_ctx, offsetofendp(user_ctx, local_port), sizeof(*user_ctx)))
 		goto out;
 
 	if (user_ctx->local_port > U16_MAX) {
diff --git a/net/key/af_key.c b/net/key/af_key.c
index d215b33b7492..736f42e37fb1 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -384,7 +384,7 @@ static int verify_address_len(const void *p)
 	int len;
 
 	if (sp->sadb_address_len <
-	    DIV_ROUND_UP(sizeof(*sp) + offsetofend(typeof(*addr), sa_family),
+	    DIV_ROUND_UP(sizeof(*sp) + offsetofendp(addr, sa_family),
 			 sizeof(uint64_t)))
 		return -EINVAL;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d790e204aee3..31fe2e78762d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -333,7 +333,7 @@ static int validate_beacon_head(const struct nlattr *attr,
 	unsigned int fixedlen, hdrlen;
 	bool s1g_bcn;
 
-	if (len < offsetofend(typeof(*mgmt), frame_control))
+	if (len < offsetofendp(mgmt, frame_control))
 		goto err;
 
 	s1g_bcn = ieee80211_is_s1g_beacon(mgmt->frame_control);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 50f50e768f01..51d2c2052d88 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -704,7 +704,7 @@ static bool valid_country(const u8 *data, unsigned int size,
 	unsigned int i;
 
 	/* make sure we can read len/n_rules */
-	if ((u8 *)coll + offsetofend(typeof(*coll), n_rules) > data + size)
+	if ((u8 *)coll + offsetofendp(coll, n_rules) > data + size)
 		return false;
 
 	/* make sure base struct and all rules fit */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ac56338f0f43..0afdab4722c1 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -587,7 +587,7 @@ static int cfg80211_parse_ap_info(struct cfg80211_colocated_ap *entry,
 		bss_params = tbtt_info->bss_params;
 
 		/* Ignore disabled links */
-		if (length >= offsetofend(typeof(*tbtt_info), mld_params)) {
+		if (length >= offsetofendp(tbtt_info, mld_params)) {
 			if (le16_get_bits(tbtt_info->mld_params.params,
 					  IEEE80211_RNR_MLD_PARAMS_DISABLED_LINK))
 				return -EINVAL;
diff --git a/security/landlock/net.c b/security/landlock/net.c
index 8fd73cf4bd15..b7405327630c 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -93,7 +93,7 @@ static int current_check_access_socket(struct socket *const sock,
 		return 0;
 
 	/* Checks for minimal header length to safely read sa_family. */
-	if (addrlen < (int)offsetofend(typeof(*address), sa_family))
+	if (addrlen < (int) offsetofendp(address, sa_family))
 		return -EINVAL;
 
 	/*
@@ -382,7 +382,7 @@ static int hook_socket_connect(struct socket *const sock,
 	 * should never be restricted.
 	 */
 	if (ret == 0 && sk_is_udp(sock->sk) &&
-	    addrlen >= offsetofend(typeof(*address), sa_family) &&
+	    addrlen >= offsetofendp(address, sa_family) &&
 	    address->sa_family != AF_UNSPEC)
 		ret = current_check_autobind_udp_socket(sock);
 

-- 
2.56.0

