Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.70.50
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794475873;
	b=bE3M3diHA7t9orLh0ATgmVgi7Dr7yV5XZGaxwHRz3lWp/Dq1NzrOJOwN0vs/jWLrh58b
	 A98ORl7Ic4wHqnN5gVaRra8KjT5gtC9A9/BjhG/r2YIxDQzrKiULt0KBHyq9PvEksJ/Ii
	 ko+qKdo8mSFFHPbvtvAA7b13VBqmwyVSIy4rBGN+i9HLZnvYFCk7oNEnPFpCKDxAkskk2
	 CcPcoJ4Ho+U4IlqQ7KLRCpaxWCsy+A7yo4AsuPVcYt/3vIHEB/HTZouXwGsjvYFzaqyZb
	 sfRZzUr9MahnK1NeIJv8eAwdmuaejGQfpAdiLf3ZiPbYuvmVS/RMCvZ0sh2i2+d527Q==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794475873;
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
	bh=mX4+TcNVvzP22P55FR4eEra0gGwX3xlT8XT7lZXXtfk=;
	b=yFO2W7i9iarlgbbVFr49AtfdN7HWnwZ3O1YvjHQ2bsHZwMw5mfymC0XR0L0IVudEp7f+
	 0upCcrRSIKedHpDxTHb76/gT/2g5iXH76Lvp9SQaWjFzqlnCycdYZhwsUXFH4JDace55X
	 XOabTbmBWaESV4HINmGl1bP+sd6tlbW2Bq9OYNTQqW1R0WcHjvyNn4ks8Lb/D3hQ7aFfE
	 Yn7Giu9CZq5UoT717BZ4DlM38UEG7JNLWA5fg27a/G0bWpqbc4Z2589o4GAKX78+VucV6
	 MshDIWeWczfQQH3b+sGtCNtWdqyMrWeo7+PzHhWBw+Im1w0tHACFqkOmJZ9D27/jBjA==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b="f/qRwwXy";
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b="f/qRwwXy";
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.70.50
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011050.outbound.protection.outlook.com [52.101.70.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C3A606A881;
	Thu, 12 Nov 2026 09:31:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14C3A606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=f/qRwwXy;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=f/qRwwXy
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rFe8DOopYAbqS0cEseL0PFyvWssQoZbiNpVSkkve7tAHUTOaljZHNphf0ORHkViOteX0EJ05DEXEe51Q/b6Z5xrwEg3AR/cu+mAoFLmpBDcdKYW4P067mu6EX1+RnmZMG16WfRwKJM4LhPdIejuIFMYowavNfzNZsvpqaGrdWa8V5E7uncwguqp+GbBu+Rb7yD5dWMrv8TIgSyqdm0ZKqxyQaCYQknbOrGQCoiPO6ZnpCXu18IKQ2QXzbAIk8otoBeDV77zPoeEl7rMELxq3XUrDMdHFijOSskdDZ079CPcVMuj2joIrm81lFZUpHD7ub/B5fjQ6GDEZ8iUJ2WCAUA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mX4+TcNVvzP22P55FR4eEra0gGwX3xlT8XT7lZXXtfk=;
 b=aQUA+L7eKvxVJQ8frawYNGgBo0ACWoRivISaU51T8syDFo0gcwGNxf9mrsYyk0gsvwF/4Zpw2wh/e8Kn+fOqKYnLbao3naLiT/HyY6AT89HKHAHKWVgfanNYZlQx4TmLFEWD14CwZH2uwrGokrtFgpn0aen2O3REbJBXgvSPmXEz9avktva+jDFjdyY+3OQ/WyJIXAiIOMYUi8cLTt4sKCPNvFicLLGR9Y7aDpXnkDQ2BhB7hbfZaYRgZX6NZpohad33LEThhmTIUIlZiNmjbPkl7Mlj3l+t57+WSgz/kRP+Dx/FnIlvG7p//aummmigaS2b93nUI3Po8+j6pOfaJw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=davemloft.net smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mX4+TcNVvzP22P55FR4eEra0gGwX3xlT8XT7lZXXtfk=;
 b=f/qRwwXyb9slnNXiG9CDqDeR+mefd/y72OQ+jwu5A2vp8gZvd98u+wp6ud9gDWx4xcKfcm2CdHQOyMXMmPkUcHBcgXFXeO55y5i4op8UGlIE8BchH/fsVv+F4eo+iFKsi0PUwOMK1DdS7b/A95JuHasFqBaiUau+WXLUTuVLI3w=
Received: from OS6P279CA0159.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:39::12)
 by MMZPR08MB019395.eurprd08.prod.outlook.com (2603:10a6:190:28::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 12 Nov
 2026 09:30:58 +0000
Received: from CPH1EPF00000530.eurprd05.prod.outlook.com
 (2603:10a6:e10:39:cafe::a3) by OS6P279CA0159.outlook.office365.com
 (2603:10a6:e10:39::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 09:30:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 CPH1EPF00000530.mail.protection.outlook.com (10.167.241.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Thu, 12 Nov 2026 09:30:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cMd+YMaCkkhR88nUcX1ZT7WnX0tQawOTe5CvhO+nwiXTqyXev3vjeIPhgFrBjPnuiX7rwA4OlNAQBB6QBNYPq5RaJHqfRune+jU6K2HuLBHzoe6bznCiLoBHsoUKwglgKP6DBq0cjbrYQoLZd39h+f5uPAg/m345bqtW5QkAc9fEVKJJ2gXV6YduPtZkNCt1F2Vyf4045Xvq7R4ETJ76DctrP350jMtX/2x898SdHLlNOwrjsnc7AjCFA1qoj2J76SJ8yq5kKsE/OUegKEetdLNk5KtyL8qlv2vbZaFe9E3wmLMcemz48uzZ/Wjq0zsNZ4bF1NOx6aK8ALN/Oq9CNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mX4+TcNVvzP22P55FR4eEra0gGwX3xlT8XT7lZXXtfk=;
 b=GoH5CqOQY9mOKzEIN/ra+79ccUuExOeWrxQimeVEADn1bM4DNpNeQfMPMSjmK32rbOhMPGzeNerTySVnzyrSg05iePOpEktBfARBzaPzSArokHkmVC1Xo0O2m49tvObM6aG/34EPQYsfVtI5e/rIr3EUyDqEQJ6ihgtyMb6m/L0yb90s866zpyTn8f+pVVvJVsD2jumIcqogAtIC0kr7kD/mT0pah5gHKypYMBWF2+/QYd1rCZZoZXhO8IAh5J3SLojEPjIRmtqnZj+jsgMGHQURfu5/fAGDgUe7Mydgq0eEkrISEPVyi86IkX9ars0pmlbh2wf72rblhLRicKRKfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mX4+TcNVvzP22P55FR4eEra0gGwX3xlT8XT7lZXXtfk=;
 b=f/qRwwXyb9slnNXiG9CDqDeR+mefd/y72OQ+jwu5A2vp8gZvd98u+wp6ud9gDWx4xcKfcm2CdHQOyMXMmPkUcHBcgXFXeO55y5i4op8UGlIE8BchH/fsVv+F4eo+iFKsi0PUwOMK1DdS7b/A95JuHasFqBaiUau+WXLUTuVLI3w=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by GV1PR08MB10402.eurprd08.prod.outlook.com
 (2603:10a6:150:15d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 12 Nov
 2026 09:30:22 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0615.008; Thu, 12 Nov 2026
 09:30:21 +0000
From: Bence Csokas <bence.csokas@arm.com>
Date: Thu, 12 Nov 2026 10:29:34 +0100
Subject: [PATCH v2 2/2] treewide: Use struct_offset()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-offsetof-v2-2-276ede839967@arm.com>
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
	AS8PR08MB10291:EE_|GV1PR08MB10402:EE_|CPH1EPF00000530:EE_|MMZPR08MB019395:EE_
X-MS-Office365-Filtering-Correlation-Id: c5bffb8f-62e9-4c9e-d4f3-08df409fa82a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|921020|10067099003|11063799006|260925022911599003|260925021911599003|260925021311599003|56012099006|261022105027099003|261026121527099003|261022115727099003|261022075727099003|261022113327099003|261026135527099003|261026140227099003|261026130827099003|261028144727099003|261021130227099003|261021123027099003|261021121427099003|261021135927099003|261021133027099003|261102123227099003|261102130727099003|261009220027099003|261009221227099003|261009221727099003|261009223027099003|261009223327099003|18002099003|6133799003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 wlwM/PA4coYIjNVSyVyxYOzT+SfyNgzoRmyq/x/i4AkF+sCrccH1SgmMU2i5jXS37Qj7sa6GqisNdbxMs+5+J8xBhCcuQz9SeG6ms8LK5KKrQiXfTnupK/iVYX352E4sOIZgNfXldue1EmvJhwaWqp5veSyHS7LYvM1Arr8vvXShmWcfndRz+BmxEjg5IgOyoDn9O9biPBOOMIdNyJ+TgwBicAJIOTSDq0SrG5EY04Q3QcB4xGYqTd2exltIXeDhujRbX+oRTM6EDjUrEQpLVYj0JES1UsBfeu7McgxdfBCw5BlPzI58oW01uAU5fKiE3ZTVQm6rgzPzPsino5kD8i+SK8EbfbS9v4lM6bgJ2k5l4hXfjhSjYxWpLvHxgiEWGwg7ltDaz5NyXuoRMkuS+6vTrPt63joR5gdvxT2ItcJFbNn+JC1vmDnuVF2iPXEH4Nk/TbVbvz/FMGl+2xJa6FaNYK53gb5VFtcpOZIgIOFyx2g4Islv2JfdzqiCibAeKVeqFlV4wdKxG8CjXQ/QKBK9xcxsZkaGmrzFBr8zYeS4YdYbOblwEbFHMsCjKKgQ69BcsaRM8I9cy5KsHviKpp6hWgYu2wzTdN3uktN2qgojRANVHEjCXDvJJ1rlls24z4J6Y8mBhuzbDTFZjg1Rqf3SLFxTePNd2VLMfW7jLeG4SVnr+7Ktm8q3oX4Zr5F6ztJwhutGqGF8G14w4JRYfA==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(921020)(10067099003)(11063799006)(260925022911599003)(260925021911599003)(260925021311599003)(56012099006)(261022105027099003)(261026121527099003)(261022115727099003)(261022075727099003)(261022113327099003)(261026135527099003)(261026140227099003)(261026130827099003)(261028144727099003)(261021130227099003)(261021123027099003)(261021121427099003)(261021135927099003)(261021133027099003)(261102123227099003)(261102130727099003)(261009220027099003)(261009221227099003)(261009221727099003)(261009223027099003)(261009223327099003)(18002099003)(6133799003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 E2OTJxV5dDaYWBemBk+iBg32pz55mN8CUzfOSzEucBjGIkCbb4Oj02sQL1YvToW/SeRbzpcK+OIsjpnX7H5/drcqEwDW35BNAdYRw9vkFZ6YatwqKSCAXPRleXd5I9/aU8SP2V/9NWg69cWDAR7OpNdQfY96l8wgFn1Zat9dEfvp9nV6D26RrVrq6dDMwaC+DbuAhQtex1kDEAZRv8ZdEaA8aADIBrlASQjT9xSAZq51AbJc0A74jlpm7G8gdy9thIY5e+53hIfCxtkDUpTLcy1+Mwag7lqPML+/NMgsyEU368cvLlagjodi7CBFDMgT/BXd2hjy3JVWx8pBaYgXrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10402
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 CPH1EPF00000530.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	25b56842-26c9-4c43-b926-08df409f92d5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|376014|7416014|23010399003|36860700016|82310400026|921020|10067099003|11063799006|260925021311599003|260925022911599003|260925021911599003|56012099006|261022115727099003|261022113327099003|261022105027099003|261022075727099003|261028144727099003|261026135527099003|261026121527099003|261026140227099003|261026130827099003|261021135927099003|261021133027099003|261021130227099003|261021123027099003|261021121427099003|261102130727099003|261102123227099003|261009223327099003|261009223027099003|261009221727099003|261009221227099003|261009220027099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	G7EWwm5e3nGIRJYGx9cw5c1m1/2RcTZU6Sb5vlPfl2hBtGzECG1nutaBNT7SrjOgNgsapDoHtXNjjkv4NDsUenG2/v3jNDENwWEfMDdJiVcKdVYDOPwWwNDNi9iD9rlkQVJBMoyXR/94P0klQtBjyx2xQuYrzBmXc5uW6c+hS8fBQPLzz5Iyzt0/tPZmFYDyUF258rfHoIvtpuOEu6qg6kDbgKF57bfSdrjoci3TyKGevLoEEoDiixenb2C/JVusr0EyP5kcW3mQNVUx/lSuZzuCjCPkbxM99UKq4i+F6eLqsPN4Lu3E9fzneX2GYKMuXk/he5S816PjK42Yh5zi8Oi1RZSh2UQgYlD7s/15ar/Wl7czwzyiW92QTt3kMl2JqKWQcYxqPoRL4ZglqwsGYuTXjaBXzqeYKR5eroC27n7AZgT1imxFDUXVy0UauvnyIz4fhPUJiXqObWll606I8xyY3bSSaWtAvs5Y7uydTH+LCQ6cyIvz0nTu1UFFbsoykrPRFk4KvRJ61DzLIoPy7eG6l13DNbKkqkSoFe8Z0v4TlvVgArV6hzKZBnzQK5LwxpTUY1UzfiEhehnsLzqXCA+/CSpnVxJhYeYrG2AOHoxbyxZB78nihfloGDUF0vtSajSbR9NV5zSoTnxjTKpMuDRUQhtHIp/b/e/pqLooaUoDtVAtEcWErVJMsbPTaPyin+y7xEII4uyHIq6/PxN8mIzhZXkFYMrPMVqiIwULEqZm0mLPYuBvIfsu4dzvNz3R
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(376014)(7416014)(23010399003)(36860700016)(82310400026)(921020)(10067099003)(11063799006)(260925021311599003)(260925022911599003)(260925021911599003)(56012099006)(261022115727099003)(261022113327099003)(261022105027099003)(261022075727099003)(261028144727099003)(261026135527099003)(261026121527099003)(261026140227099003)(261026130827099003)(261021135927099003)(261021133027099003)(261021130227099003)(261021123027099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223327099003)(261009223027099003)(261009221727099003)(261009221227099003)(261009220027099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Pl65sijD0mrv65KDncxrNgv0lTCFW26renP2NtosuNRHSoZwYbznGnYdn8HLnJ5LMcP6jaySGNHepgYN37lF+uCaBirDahjD3U+LkuVPGEOq9ByclZcBLk2cGRpjN9jf0YZlKT1qltsw9pxOjRMx2v6uETI46QtxwxBPASLrAUT2JgEyHqL7X19F7wAnQHRTzF/NPi+1vT/gWE00tQfs7XQZvLkKjyVW1V3Fjce6rW9rtuiWDoQBxI1vkWJZa5GRvw6YMAudL1dqagzAR9ViUg8nOxo4PZkPl0a4rnQSjT2vmDr7yEbThrhj5IFgEwNrLeXG8c9doRn9+ndD7txArtcQsLgrRPx8HtBAzdHXr99HvDut6IL05lI8vg/mqrsUCpufxBL2zZ4x2L0p+KZzJ2DKtV6kEPimaV+rD1I5V4ApUdi9ChxKkEbTZn2UIbS2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 09:30:57.3873
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5bffb8f-62e9-4c9e-d4f3-08df409fa82a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF00000530.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR08MB019395

Generated with the following simple Coccinelle patch:

  @@
  expression ptr, member;
  @@
  - offsetof(typeof(*ptr), member)
  + struct_offset(ptr, member)
  @@
  expression ptr, member;
  @@
  - offsetofend(typeof(*ptr), member)
  + struct_offsetofend(ptr, member)

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
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
 29 files changed, 63 insertions(+), 64 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index d449fbdde464..cd98beaf6cb6 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -81,7 +81,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 	struct btmrvl_event *event;
 	int ret = 0;
 
-	if (skb->len <= offsetof(typeof(*event), data[0]))
+	if (skb->len <= struct_offset(event, data[0]))
 		return -EINVAL;
 
 	event = (struct btmrvl_event *) skb->data;
@@ -92,7 +92,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 
 	switch (event->data[0]) {
 	case BT_EVENT_AUTO_SLEEP_MODE:
-		if (skb->len <= offsetof(typeof(*event), data[2]))
+		if (skb->len <= struct_offset(event, data[2]))
 			return -EINVAL;
 		if (!event->data[2]) {
 			if (event->data[1] == BT_PS_ENABLE)
@@ -107,7 +107,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		break;
 
 	case BT_EVENT_HOST_SLEEP_CONFIG:
-		if (skb->len <= offsetof(typeof(*event), data[3]))
+		if (skb->len <= struct_offset(event, data[3]))
 			return -EINVAL;
 		if (!event->data[3])
 			BT_DBG("gpio=%x, gap=%x", event->data[1],
@@ -117,7 +117,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		break;
 
 	case BT_EVENT_HOST_SLEEP_ENABLE:
-		if (skb->len <= offsetof(typeof(*event), data[1]))
+		if (skb->len <= struct_offset(event, data[1]))
 			return -EINVAL;
 		if (!event->data[1]) {
 			adapter->hs_state = HS_ACTIVATED;
@@ -131,7 +131,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		break;
 
 	case BT_EVENT_MODULE_CFG_REQ:
-		if (skb->len <= offsetof(typeof(*event), data[2]))
+		if (skb->len <= struct_offset(event, data[2]))
 			return -EINVAL;
 		if (priv->btmrvl_dev.sendcmdflag &&
 				event->data[1] == MODULE_BRINGUP_REQ) {
@@ -150,7 +150,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		break;
 
 	case BT_EVENT_POWER_STATE:
-		if (skb->len <= offsetof(typeof(*event), data[1]))
+		if (skb->len <= struct_offset(event, data[1]))
 			return -EINVAL;
 		if (event->data[1] == BT_PS_SLEEP)
 			adapter->ps_state = PS_SLEEP;
diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index 2365a6d8ca15..a751a972aea1 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -108,7 +108,7 @@ static struct dma_resv_list *dma_resv_list_alloc(unsigned int max_fences)
 		return NULL;
 
 	/* Given the resulting bucket size, recalculated max_fences. */
-	list->max_fences = (size - offsetof(typeof(*list), table)) /
+	list->max_fences = (size - struct_offset(list, table)) /
 		sizeof(*list->table);
 
 	return list;
diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index a9cea09355ff..12b8cceb3d20 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -340,7 +340,7 @@ static void *scmi_base_fill_custom_report(const struct scmi_protocol_handle *ph,
 	if (evt_id != SCMI_EVENT_BASE_ERROR_EVENT || sizeof(*p) < payld_sz)
 		return NULL;
 
-	expected_sz = offsetof(typeof(*p), msg_reports);
+	expected_sz = struct_offset(p, msg_reports);
 	if (payld_sz < expected_sz)
 		return NULL;
 
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index b8f882a17c8f..b48c06134276 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -3124,9 +3124,9 @@ EXPORT_SYMBOL(drm_mode_find_dmt);
 
 static bool is_display_descriptor(const struct detailed_timing *descriptor, u8 type)
 {
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), pixel_clock) != 0);
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.pad1) != 2);
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.type) != 3);
+	BUILD_BUG_ON(struct_offset(descriptor, pixel_clock) != 0);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.pad1) != 2);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.type) != 3);
 
 	return descriptor->pixel_clock == 0 &&
 		descriptor->data.other_data.pad1 == 0 &&
@@ -3135,7 +3135,7 @@ static bool is_display_descriptor(const struct detailed_timing *descriptor, u8 t
 
 static bool is_detailed_timing_descriptor(const struct detailed_timing *descriptor)
 {
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), pixel_clock) != 0);
+	BUILD_BUG_ON(struct_offset(descriptor, pixel_clock) != 0);
 
 	return descriptor->pixel_clock != 0;
 }
@@ -3207,8 +3207,8 @@ is_rb(const struct detailed_timing *descriptor, void *data)
 	if (!is_display_descriptor(descriptor, EDID_DETAIL_MONITOR_RANGE))
 		return;
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.flags) != 10);
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.cvt.flags) != 15);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.data.range.flags) != 10);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.data.range.formula.cvt.flags) != 15);
 
 	if (descriptor->data.other_data.data.range.flags == DRM_EDID_CVT_SUPPORT_FLAG &&
 	    descriptor->data.other_data.data.range.formula.cvt.flags & DRM_EDID_CVT_FLAGS_REDUCED_BLANKING)
@@ -3237,7 +3237,7 @@ find_gtf2(const struct detailed_timing *descriptor, void *data)
 	if (!is_display_descriptor(descriptor, EDID_DETAIL_MONITOR_RANGE))
 		return;
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.flags) != 10);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.data.range.flags) != 10);
 
 	if (descriptor->data.other_data.data.range.flags == DRM_EDID_SECONDARY_GTF_SUPPORT_FLAG)
 		*res = descriptor;
@@ -3251,7 +3251,7 @@ drm_gtf2_hbreak(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.hfreq_start_khz) != 12);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.data.range.formula.gtf2.hfreq_start_khz) != 12);
 
 	return descriptor ? descriptor->data.other_data.data.range.formula.gtf2.hfreq_start_khz * 2 : 0;
 }
@@ -3263,7 +3263,7 @@ drm_gtf2_2c(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.c) != 13);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.data.range.formula.gtf2.c) != 13);
 
 	return descriptor ? descriptor->data.other_data.data.range.formula.gtf2.c : 0;
 }
@@ -3275,7 +3275,7 @@ drm_gtf2_m(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.m) != 14);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.data.range.formula.gtf2.m) != 14);
 
 	return descriptor ? le16_to_cpu(descriptor->data.other_data.data.range.formula.gtf2.m) : 0;
 }
@@ -3287,7 +3287,7 @@ drm_gtf2_k(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.k) != 16);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.data.range.formula.gtf2.k) != 16);
 
 	return descriptor ? descriptor->data.other_data.data.range.formula.gtf2.k : 0;
 }
@@ -3299,7 +3299,7 @@ drm_gtf2_2j(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.j) != 17);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.data.range.formula.gtf2.j) != 17);
 
 	return descriptor ? descriptor->data.other_data.data.range.formula.gtf2.j : 0;
 }
@@ -3312,7 +3312,7 @@ get_timing_level(const struct detailed_timing *descriptor, void *data)
 	if (!is_display_descriptor(descriptor, EDID_DETAIL_MONITOR_RANGE))
 		return;
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.flags) != 10);
+	BUILD_BUG_ON(struct_offset(descriptor, data.other_data.data.range.flags) != 10);
 
 	switch (descriptor->data.other_data.data.range.flags) {
 	case DRM_EDID_DEFAULT_GTF_SUPPORT_FLAG:
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 9e01f8b2079a..598c1271cae1 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -101,8 +101,8 @@ void i915_gem_object_init(struct drm_i915_gem_object *obj,
 	 * A gem object is embedded both in a struct ttm_buffer_object :/ and
 	 * in a drm_i915_gem_object. Make sure they are aliased.
 	 */
-	BUILD_BUG_ON(offsetof(typeof(*obj), base) !=
-		     offsetof(typeof(*obj), __do_not_access.base));
+	BUILD_BUG_ON(struct_offset(obj, base) !=
+		     struct_offset(obj, __do_not_access.base));
 
 	spin_lock_init(&obj->vma.lock);
 	INIT_LIST_HEAD(&obj->vma.list);
diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index b2442f05825e..48a773b3cde9 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -263,7 +263,7 @@ static struct active_node *__active_lookup(struct i915_active *ref, u64 idx)
 			return it;
 	}
 
-	BUILD_BUG_ON(offsetof(typeof(*it), node));
+	BUILD_BUG_ON(struct_offset(it, node));
 
 	/* While active, the tree can only be built; not destroyed */
 	GEM_BUG_ON(i915_active_is_idle(ref));
diff --git a/drivers/gpu/drm/i915/i915_sw_fence_work.c b/drivers/gpu/drm/i915/i915_sw_fence_work.c
index 366418108f78..c059bb1e9492 100644
--- a/drivers/gpu/drm/i915/i915_sw_fence_work.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence_work.c
@@ -70,7 +70,7 @@ static void fence_release(struct dma_fence *fence)
 
 	i915_sw_fence_fini(&f->chain);
 
-	BUILD_BUG_ON(offsetof(typeof(*f), dma));
+	BUILD_BUG_ON(struct_offset(f, dma));
 	dma_fence_free(&f->dma);
 }
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
index 63aa30f94747..67dab90119bd 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
@@ -1169,7 +1169,7 @@ r535_gsp_shared_init(struct nvkm_gsp *gsp)
 	cmdq->tx.msgCount = (cmdq->tx.size - cmdq->tx.entryOff) / cmdq->tx.msgSize;
 	cmdq->tx.writePtr = 0;
 	cmdq->tx.flags = 1;
-	cmdq->tx.rxHdrOff = offsetof(typeof(*cmdq), rx.readPtr);
+	cmdq->tx.rxHdrOff = struct_offset(cmdq, rx.readPtr);
 
 	msgq = gsp->shm.msgq.ptr;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index a9136a6523cb..247f6d9b4494 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2609,12 +2609,12 @@ static int vmw_cmd_dx_check_subresource(struct vmw_private *dev_priv,
 		};
 	} *cmd;
 
-	BUILD_BUG_ON(offsetof(typeof(*cmd), r_body.sid) !=
-		     offsetof(typeof(*cmd), sid));
-	BUILD_BUG_ON(offsetof(typeof(*cmd), i_body.sid) !=
-		     offsetof(typeof(*cmd), sid));
-	BUILD_BUG_ON(offsetof(typeof(*cmd), u_body.sid) !=
-		     offsetof(typeof(*cmd), sid));
+	BUILD_BUG_ON(struct_offset(cmd, r_body.sid) !=
+		     struct_offset(cmd, sid));
+	BUILD_BUG_ON(struct_offset(cmd, i_body.sid) !=
+		     struct_offset(cmd, sid));
+	BUILD_BUG_ON(struct_offset(cmd, u_body.sid) !=
+		     struct_offset(cmd, sid));
 
 	cmd = container_of(header, typeof(*cmd), header);
 	return vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface,
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 5301e4f21ade..1662aeebf134 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -780,7 +780,7 @@ int bnxt_qplib_post_srq_recv(struct bnxt_qplib_srq *srq,
 	srqe->wqe_type = wqe->type;
 	srqe->flags = wqe->flags;
 	srqe->wqe_size = wqe->num_sge +
-			((offsetof(typeof(*srqe), data) + 15) >> 4);
+			((struct_offset(srqe, data) + 15) >> 4);
 	srqe->wr_id[0] = cpu_to_le32((u32)next);
 	srq->swq[next].wr_id = wqe->wr_id;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 7dfaa01cda67..df4d57c4e85e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -287,7 +287,7 @@ static int alloc_cq_db(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 
 	if (udata) {
 		if (has_db &&
-		    udata->outlen >= offsetofend(typeof(*resp), cap_flags)) {
+		    udata->outlen >= struct_offsetofend(resp, cap_flags)) {
 			uctx = rdma_udata_to_drv_context(udata,
 					struct hns_roce_ucontext, ibucontext);
 			err = hns_roce_db_map_user(uctx, addr, &hr_cq->db);
@@ -378,7 +378,7 @@ static int set_cqe_size(struct hns_roce_cq *hr_cq, struct ib_udata *udata,
 		return 0;
 	}
 
-	if (udata->inlen >= offsetofend(typeof(*ucmd), cqe_size)) {
+	if (udata->inlen >= struct_offsetofend(ucmd, cqe_size)) {
 		if (ucmd->cqe_size != HNS_ROCE_V2_CQE_SIZE &&
 		    ucmd->cqe_size != HNS_ROCE_V3_CQE_SIZE) {
 			ibdev_err(&hr_dev->ib_dev,
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index c6c0dfdbdbc3..e46c6cc1e3ee 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -836,9 +836,9 @@ static inline bool user_qp_has_sdb(struct hns_roce_dev *hr_dev,
 				   struct hns_roce_ib_create_qp *ucmd)
 {
 	return ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB) &&
-		udata->outlen >= offsetofend(typeof(*resp), cap_flags) &&
+		udata->outlen >= struct_offsetofend(resp, cap_flags) &&
 		hns_roce_qp_has_sq(init_attr) &&
-		udata->inlen >= offsetofend(typeof(*ucmd), sdb_addr));
+		udata->inlen >= struct_offsetofend(ucmd, sdb_addr));
 }
 
 static inline bool user_qp_has_rdb(struct hns_roce_dev *hr_dev,
@@ -847,7 +847,7 @@ static inline bool user_qp_has_rdb(struct hns_roce_dev *hr_dev,
 				   struct hns_roce_ib_create_qp_resp *resp)
 {
 	return ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB) &&
-		udata->outlen >= offsetofend(typeof(*resp), cap_flags) &&
+		udata->outlen >= struct_offsetofend(resp, cap_flags) &&
 		hns_roce_qp_has_rq(init_attr));
 }
 
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 644c2f1cd8e6..4cf876f4b7ea 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1108,7 +1108,7 @@ static int uvc_v4l2_get_xu_mapping(struct uvc_xu_control_mapping *kp,
 static int uvc_v4l2_put_xu_mapping(const struct uvc_xu_control_mapping *kp,
 			struct uvc_xu_control_mapping32 __user *up)
 {
-	if (copy_to_user(up, kp, offsetof(typeof(*up), menu_info)) ||
+	if (copy_to_user(up, kp, struct_offset(up, menu_info)) ||
 	    put_user(kp->menu_count, &up->menu_count))
 		return -EFAULT;
 
@@ -1147,7 +1147,7 @@ static int uvc_v4l2_get_xu_query(struct uvc_xu_control_query *kp,
 static int uvc_v4l2_put_xu_query(const struct uvc_xu_control_query *kp,
 			struct uvc_xu_control_query32 __user *up)
 {
-	if (copy_to_user(up, kp, offsetof(typeof(*up), data)))
+	if (copy_to_user(up, kp, struct_offset(up, data)))
 		return -EFAULT;
 	return 0;
 }
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 9b6e974c4102..5184007008bf 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1041,7 +1041,7 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	set = &request->request_msg.msg.set_req;
 	set->oid = RNDIS_OID_GEN_CURRENT_PACKET_FILTER;
 	set->info_buflen = sizeof(u32);
-	set->info_buf_offset = offsetof(typeof(*set), info_buf);
+	set->info_buf_offset = struct_offset(set, info_buf);
 	memcpy(set->info_buf, &new_filter, sizeof(u32));
 
 	ret = rndis_filter_send_request(dev, request);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 0982e60842b1..01bdc0e9635d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -736,7 +736,7 @@ static void iwl_parse_dbg_tlv_assert_tables(struct iwl_drv *drv,
 	u32 length = le32_to_cpu(tlv->length);
 	u32 addr;
 
-	if (length < offsetof(typeof(*region), special_mem) +
+	if (length < struct_offset(region, special_mem) +
 		     sizeof(region->special_mem))
 		return;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index e2382be8edd7..5faa97a420d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -625,7 +625,7 @@ void iwl_mvm_rs_fw_rate_init(struct iwl_mvm *mvm,
 	cfg_cmd.sta_id = mvm_link_sta->sta_id;
 
 	lq_sta = &mvm_link_sta->lq_sta.rs_fw;
-	memset(lq_sta, 0, offsetof(typeof(*lq_sta), pers));
+	memset(lq_sta, 0, struct_offset(lq_sta, pers));
 
 	rcu_read_unlock();
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index d1619a229d8f..da0669155a3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2939,7 +2939,7 @@ static void rs_drv_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	lockdep_assert_held(&mvmsta->deflink.lq_sta.rs_drv.pers.lock);
 
 	/* clear all non-persistent lq data */
-	memset(lq_sta, 0, offsetof(typeof(*lq_sta), pers));
+	memset(lq_sta, 0, struct_offset(lq_sta, pers));
 
 	sband = hw->wiphy->bands[band];
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
index 0009a05511af..a5a065275f18 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
@@ -241,7 +241,7 @@ int iwl_pcie_ctxt_info_v2_alloc(struct iwl_trans *trans,
 	 * optional; old devices _should_ be fine with a bigger size,
 	 * but in simulation we check the size more precisely.
 	 */
-	BUILD_BUG_ON(offsetofend(typeof(*prph_scratch), dram.common) +
+	BUILD_BUG_ON(struct_offsetofend(prph_scratch, dram.common) +
 		     sizeof(prph_scratch->dram.fseq_img) !=
 		     sizeof(*prph_scratch));
 	if (control_flags_ext & IWL_PRPH_SCRATCH_EXT_EXT_FSEQ)
@@ -249,8 +249,7 @@ int iwl_pcie_ctxt_info_v2_alloc(struct iwl_trans *trans,
 			cpu_to_le32(sizeof(*prph_scratch));
 	else
 		ctxt_info_v2->prph_scratch_size =
-			cpu_to_le32(offsetofend(typeof(*prph_scratch),
-						dram.common));
+			cpu_to_le32(struct_offsetofend(prph_scratch, dram.common));
 
 	ctxt_info_v2->cr_head_idx_arr_base_addr =
 		cpu_to_le64(trans_pcie->rxq->rb_stts_dma);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 3d0c22db30a8..79b4bb78b17a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -6167,7 +6167,7 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 		case C2H_8723B_RA_REPORT:
 			bw = rarpt->txrate.bw;
 
-			if (skb->len >= offsetofend(typeof(*c2h), ra_report.bw)) {
+			if (skb->len >= struct_offsetofend(c2h, ra_report.bw)) {
 				if (c2h->ra_report.bw == RTL8XXXU_CHANNEL_WIDTH_40)
 					bw = RATE_INFO_BW_40;
 				else
diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..d1a1a492d146 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -159,7 +159,7 @@ static void rtw_fw_ra_report_iter(void *data, struct ieee80211_sta *sta)
 
 	rate = u8_get_bits(ra_rpt->rate_sgi, RTW_C2H_RA_RPT_RATE);
 	sgi = u8_get_bits(ra_rpt->rate_sgi, RTW_C2H_RA_RPT_SGI);
-	if (ra_data->length >= offsetofend(typeof(*ra_rpt), bw))
+	if (ra_data->length >= struct_offsetofend(ra_rpt, bw))
 		bw = ra_rpt->bw;
 	else
 		bw = si->bw_mode;
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 5220f74d15d2..85b04a610920 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2605,7 +2605,7 @@ static void rtw89_vif_sync_bcn_tsf(struct rtw89_vif_link *rtwvif_link,
 {
 	struct ieee80211_mgmt *mgmt = (typeof(mgmt))hdr;
 
-	if (len < offsetof(typeof(*mgmt), u.beacon.variable))
+	if (len < struct_offset(mgmt, u.beacon.variable))
 		return;
 
 	WRITE_ONCE(rtwvif_link->sync_bcn_tsf, le64_to_cpu(mgmt->u.beacon.timestamp));
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 21b548c63c78..a4b6514a0ce5 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -8067,11 +8067,11 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 
 	if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V0, &rtwdev->fw)) {
 		ver = 0;
-		elem_size = offsetofend(typeof(*elem), w7);
+		elem_size = struct_offsetofend(elem, w7);
 		used_len = sizeof(*h2c) + elem_size * ch_num;
 	} else if (RTW89_CHK_FW_FEATURE(CH_INFO_BE_V1, &rtwdev->fw)) {
 		ver = 1;
-		elem_size = offsetofend(typeof(*elem), w7);
+		elem_size = struct_offsetofend(elem, w7);
 		used_len = sizeof(*h2c) + elem_size * ch_num;
 	}
 
@@ -8350,10 +8350,10 @@ int rtw89_fw_h2c_scan_offload_be(struct rtw89_dev *rtwdev,
 	rtw89_scan_get_6g_disabled_chan(rtwdev, option);
 
 	if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V0, &rtwdev->fw)) {
-		cfg_len = offsetofend(typeof(*h2c), w8);
+		cfg_len = struct_offsetofend(h2c, w8);
 		scan_offload_ver = 0;
 	} else if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V1, &rtwdev->fw)) {
-		cfg_len = offsetofend(typeof(*h2c), w9);
+		cfg_len = struct_offsetofend(h2c, w9);
 		scan_offload_ver = 1;
 	} else if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_BE_V2, &rtwdev->fw)) {
 		scan_offload_ver = 2;
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index e53714b81ec2..23f9712d1be9 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1622,12 +1622,12 @@ static void mac80211_hwsim_write_tsf(struct mac80211_hwsim_data *data,
 	if (txrate)
 		bitrate = txrate->bitrate;
 
-	if (skb->len >= offsetofend(typeof(*mgmt), u.probe_resp.timestamp) &&
+	if (skb->len >= struct_offsetofend(mgmt, u.probe_resp.timestamp) &&
 	    ieee80211_is_probe_resp(hdr->frame_control)) {
 		mgmt->u.probe_resp.timestamp =
 			cpu_to_le64(sim_time + data->tsf_offset +
 				    24 * 8 * 10 / bitrate);
-	} else if (skb->len >= offsetofend(typeof(*mgmt), u.beacon.timestamp) &&
+	} else if (skb->len >= struct_offsetofend(mgmt, u.beacon.timestamp) &&
 		   ieee80211_is_beacon(mgmt->frame_control)) {
 		mgmt->u.beacon.timestamp = cpu_to_le64(sim_time +
 						       data->tsf_offset +
diff --git a/drivers/platform/chrome/cros_ec_lightbar.c b/drivers/platform/chrome/cros_ec_lightbar.c
index 96dde19b15fa..df2a0dfe7cc3 100644
--- a/drivers/platform/chrome/cros_ec_lightbar.c
+++ b/drivers/platform/chrome/cros_ec_lightbar.c
@@ -460,7 +460,7 @@ static ssize_t sequence_store(struct device *dev, struct device_attribute *attr,
 	param = (struct ec_params_lightbar *)msg->data;
 	param->cmd = LIGHTBAR_CMD_SEQ;
 	param->seq.num = num;
-	msg->outsize = offsetof(typeof(*param), seq) + sizeof(param->seq);
+	msg->outsize = struct_offset(param, seq) + sizeof(param->seq);
 	msg->insize = 0;
 	ret = lb_throttle();
 	if (ret)
@@ -508,7 +508,7 @@ static ssize_t program_store(struct device *dev, struct device_attribute *attr,
 		 * Bound the payload strictly by the maximum value the structural
 		 * size field can natively support.
 		 */
-		extra_bytes = offsetof(typeof(*param), set_program_ex) +
+		extra_bytes = struct_offset(param, set_program_ex) +
 			sizeof(param->set_program_ex);
 		max_size = min_t(size_t, ec->ec_dev->max_request - extra_bytes,
 				 type_max(typeof(param->set_program_ex.size)));
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 20b1aef455c4..159daefd249e 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -185,7 +185,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 				    comp_status, ct_rsp->header.response);
 				ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha,
 				    0x2078, ct_rsp,
-				    offsetof(typeof(*ct_rsp), rsp));
+				    struct_offset(ct_rsp, rsp));
 				rval = QLA_INVALID_COMMAND;
 			} else
 				rval = QLA_SUCCESS;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 59ec5605930b..665c3d628d45 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3225,7 +3225,7 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	uint32_t *iter = (uint32_t *)stats;
-	ushort dwords = offsetof(typeof(*stats), link_up_cnt)/sizeof(*iter);
+	ushort dwords = struct_offset(stats, link_up_cnt)/sizeof(*iter);
 	struct qla_hw_data *ha = vha->hw;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1084,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3c412c7fb6fe..8e6a953dc3f7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6263,7 +6263,7 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 
 	if (qla25xx_rdp_rsp_reduce_size(vha, purex)) {
 		rsp_payload_length =
-		    offsetof(typeof(*rsp_payload), optical_elmt_desc);
+		    struct_offset(rsp_payload, optical_elmt_desc);
 		ql_dbg(ql_dbg_init, vha, 0x0181,
 		    "Reducing RSP payload length to %u bytes...\n",
 		    rsp_payload_length);
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index f96b9eb15126..288239644ac9 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -7,7 +7,7 @@
 #include "qla_tmpl.h"
 
 #define ISPREG(vha)	(&(vha)->hw->iobase->isp24)
-#define IOBAR(reg)	offsetof(typeof(*(reg)), iobase_addr)
+#define IOBAR(reg)	struct_offset((reg), iobase_addr)
 #define IOBASE(vha)	IOBAR(ISPREG(vha))
 #define INVALID_ENTRY ((struct qla27xx_fwdt_entry *)0xffffffffffffffffUL)
 
@@ -722,7 +722,7 @@ static struct qla27xx_fwdt_entry *
 qla27xx_fwdt_entry_t275(struct scsi_qla_host *vha,
 	struct qla27xx_fwdt_entry *ent, void *buf, ulong *len)
 {
-	ulong offset = offsetof(typeof(*ent), t275.buffer);
+	ulong offset = struct_offset(ent, t275.buffer);
 	ulong length = le32_to_cpu(ent->t275.length);
 	ulong size = le32_to_cpu(ent->hdr.size);
 	void *buffer = ent->t275.buffer;
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index bec6ca38375b..09ee87ebd5d1 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -570,7 +570,7 @@ fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
 	event->event_code = event_code;
 	if (data_len)
 		memcpy(event->event_data_flex, data_buf, data_len);
-	padding = len - offsetof(typeof(*event), event_data_flex) - data_len;
+	padding = len - struct_offset(event, event_data_flex) - data_len;
 	memset(event->event_data_flex + data_len, 0, padding);
 
 	nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS,

-- 
2.56.1

