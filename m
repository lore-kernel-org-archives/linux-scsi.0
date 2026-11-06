Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.69
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793953816;
	b=SmZgxU/qvgmbLsvebGEX0tQhZQ5EUrzOjQFRLtecTBaYH53jsW39xOGD7/Hcqzq5xwwy
	 Tz+0UzF2AG4128hiMfac8dj5RAjulze25PxP3ZFIJajsYXNLbig3Ol2bt9Ahz9Dh/eC45
	 brtjy/RkTPbvan/0GyS1A7sGh4TT8H3NJzFlP8w0rcogHGzYHfWKeOlqsIZtQH74Oio0p
	 boYQvGsZrt0V8F9IpeAIKBDkw5+n6LqlXbtzJBtR1T1/ZTcbLVN4O9J22+aO0EFXoYqDu
	 +xL1B0lrk6oIzGHZUWT3FT1xAfwwQtLJSUy2Jmm71fmWI2xabqHIQf138uJn2q2iZzw==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953816;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Authentication-Results-Original:Received:Received:
	 Message-ID:Date:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-ClientProxiedBy:MIME-Version:X-MS-TrafficTypeDiagnostic:
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
	bh=L6VJsBBw+9aLUNmIbT5EOz+b9Lupz6euvihDRf+q8UA=;
	b=sMRPZC9B+U7bSej0y6DXkGpdzt3cHzdsZOrXPfHkUOXDor7z5zU7nTXE8iUyDIAPW6vo
	 aoaNyTJEyq7JT1Te/efnvuztpei4Ja4kJrvCrmTsmnMnHZxo+2V0G0e3lTgHU90oQENGr
	 jPDD8gIRcB71Su5e1gumK+kMO7+7C/X/hNCq4HQ6T2Li+YnyuETqDedsiKx1eZlnXCPxt
	 PybeolCcn7AK8fwz7e8nugtaSfjImNXAgM0iXWPOEqgPjklUGPABfCFFk04aPYRGQSbXO
	 ay08SnBnwywmShoWeSRlGemxym1ag4QRET91jSTCPURJFOb2cUNkWg2TMBnSSshJvFg==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=VTct3TJM;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=VTct3TJM;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.69
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010069.outbound.protection.outlook.com [52.101.69.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06491606A329;
	Fri,  6 Nov 2026 08:30:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06491606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=VTct3TJM;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=VTct3TJM
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OdCVbwH56MMbZNewyuT/pqQanw3xwV3kLkdIKEitKvnuem+nJ728pq7yohU8iSAdnXZEvKmTjh59DCXnqz4Yaq0kYmw7XN+QiDgJ9iaDmlrIAxL6u1n8bQTIXf57lEkiNf/z/wVpR92+QWKTu+jccm0nBIs+suKncDDW7lZuNrzFZVj8pzGGWB/kD7dCm8dI+hEF6M/pgqxqIliJgvgRlJB8WoLXTbhxmtJ79Vy1uarOPYBPyP5ZL2JtTzaaeevfEJS+FF7S1VCLZXSFVM4UaF7e9jaNuRnTxx0CCymT5edPqZQvj9vIofk5jhsWHhoasIw7UqgV54+I7Ochzv7ZvQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6VJsBBw+9aLUNmIbT5EOz+b9Lupz6euvihDRf+q8UA=;
 b=fJkVx2FTNpfQu6ContC49sJUkM1uWbN/7SQbVCc6br+M7qVLKXwFgo0tgYmPEqLKy9uGFpPPytrAeRPA8zPAvT2rjkHeEFtEJ4tO4EmI7EGBGvnsCGgM03Q+oenqsrVk83748H4u5SVoGpPUYY7yLISvUgSkGJmWU5YcKSQyuEdOLrCb/+VgVd5otYQmS/XYw84hT3F5cm72CC2of8ufs6F1CXkDfD/MtMNpyUtEpNH5MsQOfJ/MaYTpuVU2gXm53Q3/fIdbv4niOT+fDc2VtvHnOvEPq/IO3uVx6DJhD+66avmQ0TpMFAZo2DMtlTKIPf5zJBW08oT7fC2UK63TvA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6VJsBBw+9aLUNmIbT5EOz+b9Lupz6euvihDRf+q8UA=;
 b=VTct3TJM+OunBfzGKVKBs1bHWhwAuwIGQQLM9WyomdtBvDXcGitFSBsJw3rmK2+GxfFUf6PYXASw2g/WrvG280L9uw2yJf1eQhvxzypYk32uzbyPrrN0byTHHDvsZuwQX+qVQSenj0+RkPJOTkRgJhHTnr9L8zwWDV8Gyl9B1Ko=
Received: from DB9PR06CA0010.eurprd06.prod.outlook.com (2603:10a6:10:1db::15)
 by AM0PR08MB5364.eurprd08.prod.outlook.com (2603:10a6:208:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 08:30:07 +0000
Received: from MAD0EPF000008B1.eurprd04.prod.outlook.com
 (2603:10a6:10:1db:cafe::99) by DB9PR06CA0010.outlook.office365.com
 (2603:10a6:10:1db::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Fri, 6
 Nov 2026 08:30:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MAD0EPF000008B1.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Fri, 6 Nov 2026 08:30:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s0U5i4Rn/UCIlotiLo/VvUA1a6U0v7YRBf0h0qxbKixjoTDXolHKMHI+81ST2iSBij40UkhqXDsL+sYt4MCLe5uWreOA7SkVr9TWGBJLsh9uuHMbNo/9Hn49hzj17LP8Sp7Xwa+48BNcoeykitRg/I9krN35oK1HKLgn0IomDqmVT9K1NRIhqPItUFmZ4WSP5n37dMz8RoWaQGFh71bQMHlIvtJZaKs5GFCad9CbuGItn33hnXVXTkuLGPJExq8CMcdPGQqZKrGyia9tyh1WuZoTO2vQ5B3p5TMA1E+ZTUhddqj3KImydjuyu55+G+yd0AQPzip/TZ/koWdM8u3ObQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6VJsBBw+9aLUNmIbT5EOz+b9Lupz6euvihDRf+q8UA=;
 b=sljIyRyMiC/coR93PrX6AW9+zxGgQss9F5QGMweCfqgDQgcl07npH3G5kGJCC/ARACEbb/zVDf8AkeRr4g21mNI00hgprYqUmQfXaIePTPKaQOkxb+9FhJt8/Z8E9HLbweo6RmtWALMi0oa5NGTvcuzjGelY8BJKeIy0GEGb6zaCZ1tRXYgde7SEuzzvAKNVJC/lvlnKiCcQRWAss21cXrIokd1eVN2BHV+7EHqUX+j68pJsWkTmlAeJTOHE4iBZxShKge/EQwhRYYZIp1dEFEFAyorj6hRwkOY4+GQzRqql3JQ/TjO/PYVbrtW8xsWtrIsvIiTIAr+8wiFCFUMLyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6VJsBBw+9aLUNmIbT5EOz+b9Lupz6euvihDRf+q8UA=;
 b=VTct3TJM+OunBfzGKVKBs1bHWhwAuwIGQQLM9WyomdtBvDXcGitFSBsJw3rmK2+GxfFUf6PYXASw2g/WrvG280L9uw2yJf1eQhvxzypYk32uzbyPrrN0byTHHDvsZuwQX+qVQSenj0+RkPJOTkRgJhHTnr9L8zwWDV8Gyl9B1Ko=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by VI0PR08MB11199.eurprd08.prod.outlook.com
 (2603:10a6:800:255::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 08:29:30 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 08:29:30 +0000
Message-ID: <00152592-fd72-4413-88cd-c78a3722829a@arm.com>
Date: Fri, 6 Nov 2026 09:29:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Add offsetofp() and offsetofendp() for pointer
 arithmetic
To: Christoph Hellwig <hch@infradead.org>
Cc: Chengchang Tang <tangchengchang@huawei.com>,
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
 Herbert Xu <herbert@gondor.apana.org.au>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8?=
 =?UTF-8?Q?n?= <mic@digikod.net>, =?UTF-8?Q?G=C3=BCnther_Noack?=
 <gnoack@google.com>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Vineet Gupta <vgupta@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Philipp Stanner <phasta@kernel.org>, Sudeep Holla <sudeep.holla@kernel.org>,
 Cristian Marussi <cristian.marussi@arm.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, Zack Rusin <zack.rusin@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 Selvin Xavier <selvin.xavier@broadcom.com>,
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Hans de Goede <hansg@kernel.org>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Benson Leung <bleung@chromium.org>,
 Tzung-Bi Shih <tzungbi@kernel.org>, Guenter Roeck <groeck@chromium.org>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, Carlos Maiolino <cem@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>,
 Davidlohr Bueso <dave@stgolabs.net>, =?UTF-8?Q?Andr=C3=A9_Almeida?=
 <andrealmeid@igalia.com>, David Ahern <dsahern@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "Geoffrey D. Bennett" <g@b4.vu>, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
 bpf@vger.kernel.org, netdev@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 arm-scmi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-hyperv@vger.kernel.org, chrome-platform@lists.linux.dev,
 linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-xfs@vger.kernel.org, linux-sound@vger.kernel.org
References: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
 <au2J-lMcEn4p4KGR@infradead.org>
Content-Language: en-US
From: =?UTF-8?B?QmVuY2UgQ3PDs2vDoXM=?= <bence.csokas@arm.com>
In-Reply-To: <au2J-lMcEn4p4KGR@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::6) To AS8PR08MB10291.eurprd08.prod.outlook.com
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
	AS8PR08MB10291:EE_|VI0PR08MB11199:EE_|MAD0EPF000008B1:EE_|AM0PR08MB5364:EE_
X-MS-Office365-Filtering-Correlation-Id: 24d05a3e-000b-4f47-7812-08df3be029d2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|4143699003|11063799006|56012099006|261022105027099003|261022075727099003|261021121427099003|261102123227099003|261026121527099003|261026140227099003|261028144727099003|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 faF+axEssCynoG70FYMCePhIoNpODz8nUUte48ilBjAxzSF2ljdTx9FZ+6SAHTl+L2p2VXDJxSZLAuGF+8xFPD/wczlw8gbdBoL9FYDE/uIqKiUIVgMy9ykCSws2uLPnpBAK7V16FmgaDTf3NDZ4MRCgeh2p/ygbAULsuCjRiqxv58kWepRcOoaQ5ttqxnXxAXPKc2jvzHJmnczt5v2Kl8dZU8kI8J59iMg6p2A2UfEIkbd6esvii3NT0/PLpM3QpDXXGSib9e/FqsLftpDpwBHPG0ajxoEH77qdkiTImbxXmZaR+H7buSGy9nCBRwtkWF3EQzXzU8Un+j3LQ0ndbfjxrZXJuKFFb9qdo9vdlnYBzuYxZliIbcBCqGM8uEl08awDM9NgD4ISXI2Z8Fk9vjKO8IB+rDAACKMn7XVoXXn3aXYaoxFiC/+fU1rUjP9DJCuOdM/TNxWqW5sG/GIglVNr8u83u9+GzJGqGnbVLzt5toXnEiRGY02Q00lVU8FSmMDMgovq4aRgxyJtQSPVxatmi9SLwh4GF4wg+JPW2VuGA+Prl2qZeAir1/AyWcIbQEfeM8jN9f+XIQ7UjGHZqoolFhgR72yHr5Gwpsv/xmaYN35+U3vuTQYmWiwrxxEi2A3dMvf09/CGVjsdblkAJlBwzfpwxVdFkOsORGPVI/Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(4143699003)(11063799006)(56012099006)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(261026121527099003)(261026140227099003)(261028144727099003)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 NeCIiAyKEnvG3hV2ch//xgC4atks9H+CsONLPBStOOh8CG85CyJF+aQCcRm3+Ez54VEWInVKsHEWmfQrrnHjx6GKV9fAL09L5MGK+lgS0vVTtRHSlZub1CBrTbF2T1URA+C9/2gQAvxl/cpBCRA670gFqJRIIOROFz25Frpvk68WIa5CF9Z832T4xoZMom1cCsaSvT8hspU7R+kOxNryq7oFCYnDuEUv/9AOknzx7HFViRfLoJG5F3ZXvirXd0fxz5WgVPd0+JUsUzOsKiXYZvDW5EXdOgNkIDrg3X8Nd9FzJNwSSx5bCq41uZQbnmLUoMn5JwUmO/XCfEZBdMBkTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11199
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MAD0EPF000008B1.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e5a6ba2e-9dc8-46a5-9ba1-08df3be013e6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|376014|35042699022|36860700016|14060799003|82310400026|10067099003|56012099006|11063799006|4143699003|261028144727099003|261022075727099003|261021121427099003|261022105027099003|261026121527099003|261026140227099003|261102123227099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KtcyxRwdz3XBeacj4DF3DwNqY6a6d5Weo4tvd+TnltgcLhTsGMkL3kCtdI8UpoXpYAUwx/b2CmVjEeSh+JnJtf4N+dqfPw/n6ze1qz3MNi2yw6dXGemhnTVvKKR9M+vneL6+u9TGRH65DUOrJm8/OW0GhFlJnKhzoDX7XzhHLbRFVdr4iFTW0on0eCA2rEB5kcAv5E2b4Txm3phHfcX4RuRLaNoYRDzTiizAKs7cdfhRAFtPvesurNGwgYbo+QVAggNbuQ7rmyAp/xINx/de9dPDEZLqELMbLdvsvqGOGKeh/S2GCOSuSCGoknwDU7pBDh1yISojYHo0yTw0q2ckXqdqO8uQQSLrLgOOd7ul/Lyxjx+0Xq7saXt0fGTuiUAh7b2JHzfC3L/qIoR9gI5uBp5NRsyB58WSQeXjN/TDN5XhIiKIVc8OTUAzOmQQNe4G6Isb2orxbpEoFrkjyUeWkBbSE4vHO7PafD/jj0dlQjrMwtS03TyRHah0JC7uA6moqHov1eUiw8wCr6uxjs8HoYGzv70pLZsHd1FNI8lsnKrtxgu6M0bornoJa5WTag1CYsHQJWt9sW1lIELgFHbebJ9W+2kAel28FcyyKXefK13yN4XMUfzE/XkjCh6RrafaWwcaHcid8wPVYmFrxwRwudebPkkIAWWg1D4SOQvElM72cRSz1MH99QwFvxc63WjxHfRApR7T27LkYb/FxR7qiw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(376014)(35042699022)(36860700016)(14060799003)(82310400026)(10067099003)(56012099006)(11063799006)(4143699003)(261028144727099003)(261022075727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261026140227099003)(261102123227099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z71oRdmj/uG70Vv6dYtTt4jsBSPoaF2wcTw7jfAJ2b/QLyGBLwZJJNwdruOK7NeIbGuT5N7cIVdJF2TVV7I1f08Y5SHmBFQuhSBEFJtUrq8462moxunkngyB7S2Dc8clo2hUZeK9GBw/f2kYQDniZV+TZSDv3nijBPQNfbLz7vJanFT1YnluwBjRGmgalWZHmCDiMmM8yo+fURJhiaXOfuUVOdxXiGmibQgwih3BzdrHWrMrt9kQ6/3wdT6HK7bXyRH6wz5/B9mtZ0YH+D8WRvYn1J6WkzUTbgccmI01rbCw1EIc9i4ZL/GyO/bwnIB2RjtJ6WJit0o1LUIK3a5EnXrnKOPs0ve9DrYSIUUivyeJmlRM0e2LtDVKNx6fzX6CzrG1AxB3sD1LsmlLrQ4T52r1Q/B+EkC57F9bbfMHMTr6IbwBqox0mdYpGBYlovES
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 08:30:06.7787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d05a3e-000b-4f47-7812-08df3be029d2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MAD0EPF000008B1.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5364

Hi,

On 2026. 11. 06. 9:04, Christoph Hellwig wrote:
> On Thu, Nov 05, 2026 at 06:16:15PM +0100, Bence Csokas wrote:
>> A common usage pattern for offsetof() is the following:
>>
>>    offsetof(typeof(*ptr), member)
>>
>> Condense this operation to one macro for a more maintainable code base.
> 
> What exactly makes non-standard macros with no obvious safety benefit
> more maintainable?

It is written out in more detail in the msg of 1/3: it helps keep lines 
short, and as typeof(*ptr) may not come naturally to many, some may be 
compelled to write out the typename twice::

   struct my_struct_type *p;
   off = offsetof(struct my_struct_type, member);
   // pointer arithmetic with p and off

which induces additional work if *p's type changes.

However, as Sashiko pointed out (don't know why it didn't write this 
earlier), struct_offset() already exists, so we should just use that 
one, and probably add a struct_offset_end() variant.

Sorry for the noise, everyone.

Bence
