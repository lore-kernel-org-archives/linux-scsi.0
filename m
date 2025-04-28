Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022076.outbound.protection.outlook.com [52.101.96.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E24A266564;
	Mon, 28 Apr 2025 09:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833312; cv=fail; b=FhWRp/4h9Jur6DWe/8SDqI5YhIOGPDDoT7d147GHhmg0FuwZzDvYDTxKIfC2VMn6K66Uo65pCNHByFb3LSyiQSh1dafXPEASVfzhv4+mIy8KgMhTPKFsIcnJARb2WjdunQUE3q7YlJ2+yycKc0hEWeFSYenbaflu8VHNf1kIi6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833312; c=relaxed/simple;
	bh=rsfHHRHzXrDQw3PzTISQDcyON9KYyfmk7DgIBNegQ9o=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YDg+zVAsRqPjzyM3dfZ/aC12WcWHR6+pwFZF5/9JMMMM1QLdCXV2Tggj/7kO/T3ledwNVVc09mFzJdeg/g81BlkBr0XuJa9Y+vS+D1wr0bRjeIBOprQdbq0IXShkWEkukibc7byz75sjLzu8up5vgeNGKKI30Oo9yz5kj8izVXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vsTH4vayNMz9RBPPUa1fXHv8/+4aqzB9+Vcbr0H8HdTrOHJY0EtIfztr0qDwoxioghbRYhfF4SrFTNVL8J5FxMv++lyEUdS2x5s0PWCLa3iHvlOLzthjwruw1nOGvpxvj74xPV6v62/CBUU2FCT4uiMM1YYAjDCwnFtwancuOsehE5XU86sWyDMbvcCpKnFklDOtz+dKtsLFAGcwVhH5V9T2Dz41rSu0bp2Ba9cKLn7HneQwZeaX++7GzlueQVH1ZtgN5eGVkjSgyFLH+UtLig4vgZyKpiTI9PoWRqYGPuAYBuNRwduEZF9lRHeXM44xTrUp6f0goSFW7iJyxjUIog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rDRNyV3KN7bkuM/5yUuDjd5DsJt8Uc4VmcaSroQ4Zg=;
 b=Y2AnfqgBcheidWFDZHkC9XBpaXhTUP1sUKgvrLhENcZiGLvZSgT43twyoHrTXkLXbiVLHr1wWp5UrQaVobeYtOfDjdRUfDL+hoP5HzW6aINcaeNQuKNyVhiDVK0+bYWiFBwwupDlPSwE+7jNZFOWeiZ1GbOtBjpSFdY88K+2d5ClrC8cPrTqSAlsmDoQkIgEiiuPzTF8gwXtD5C3e1Tc1sTR7pBxpDC6GxwO7IJJUJHS2Z0vA80MUC6IXExKv73IAQfwCZbU//zVOgKx9WTOJEcvhFTI7UCq/S7mo0V2mSicdc07CFRhM3nDwCXJmRSqnf9XfHmE/qAWkv56X37sWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO4P123MB6498.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:27c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.18; Mon, 28 Apr
 2025 09:41:43 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%6]) with mapi id 15.20.8699.012; Mon, 28 Apr 2025
 09:41:43 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/1] scsi: mpi3mr: Introduce smp_affinity_enable module parameter
Date: Mon, 28 Apr 2025 10:41:40 +0100
Message-ID: <20250428094141.1385188-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.47.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0036.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::7) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO4P123MB6498:EE_
X-MS-Office365-Filtering-Correlation-Id: 4378c229-c463-4f51-e442-08dd8638e261
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?51vcL1Esce58DBvMYcyiVF3KRbjBbQyx+8rtS8o7uKJ+y+FI+3m2/3qGwquv?=
 =?us-ascii?Q?J1ZLYg1jKJsZl38jdaoh84sZ5U5umSV9TicyztcUIZyEg3n+VZIPB1NV7E1q?=
 =?us-ascii?Q?TWdfHxMxUpu/f/eIPriDJGAGpBYnR34i5PkBhYgLvEqr19szkEzW+TXISKxf?=
 =?us-ascii?Q?85vBWa/i70Z0jEb/GXG3fdiIK1Qli8N+obLFjKTp44sUtuZCbdYljNM2stqv?=
 =?us-ascii?Q?J7oTn61a3iRlXOnUivOTfDTvENaHQjxiLKGeF4TzPeCfD8a9SRVeV5R8p+BA?=
 =?us-ascii?Q?gNOsgNztMGnS2LB2vMMMh/05XzFxd7s8PqoY91HC6twYQjWZoi2nf8bPhE2C?=
 =?us-ascii?Q?cnueSLPgIsHwIbxrMS0DMzktOC3XnpydRi+lALIMxFuTFlZ1RQKvwnUMHlir?=
 =?us-ascii?Q?b+52TiXFEIs/KHbdL1czhrrg3FZpg7uZxwRdKm6DYsX2IF61ieJ7t3cMeJUC?=
 =?us-ascii?Q?xbzOkzz5tfWAv104W/R6/nDfNGcDXMppite7q+DBj8SemYiohIicphQStcmb?=
 =?us-ascii?Q?QfV40iRVGBEISRwI6a+LD+HJOGcuiFxrKgtu6LpH74wE7CPJCnO88tFxaUpN?=
 =?us-ascii?Q?0ZX/uOgI8ZL1gcKHndSBNrjpqT4NarWJI3C+GUuHoBAaM8Tq81EmSWSJ7bs+?=
 =?us-ascii?Q?xIrenW7PX5vDubyaXJ8hGUXCbi9kY0zKdJt3/3eiUjqSAZDDApbAKpKZuTTP?=
 =?us-ascii?Q?KWeVO8un5/RWdAXX4qBFK+2ib5TB/yoUztn0o6bxfO5jzaHSOGj2T/D/1ROW?=
 =?us-ascii?Q?nZRyczinvzs2mUUq+avNI5G6eY+uYi03mmoaQZxET1rJ9AhhuhBP+Mr4/NuL?=
 =?us-ascii?Q?vFLSQi1E+XKL59QICR0DoKS/2dpGRGuV+AuactRz4Uxr8vdN7CDzbkgACzsh?=
 =?us-ascii?Q?5It3pHUSVlGtIo2M6NGJnnLpTqaQ0lFA8eO39NacUYdRkpp000n1aL6P6kAD?=
 =?us-ascii?Q?f7wSZo/jiaTk7altPWek2iwFrBsI80sRwYrMn57J75I/9Zbl8K7heWOmD2RE?=
 =?us-ascii?Q?LI9R4XMlBH85rsXLgmu8UO5t9+JjM0K0Rb47IE5jAU3dHFRgab4z4tO0Sr4D?=
 =?us-ascii?Q?9Z8roeTOccMfslRKPEgwr2mLxQ7CYG1Xt9sT7RnTNMq7KFb0iczgbl+l2vUq?=
 =?us-ascii?Q?FSRgiQHoNGXQFw2H0dVcKiM5ahMSj+r+1srJsE3Ak7FBqA6CXjzjWup5nip5?=
 =?us-ascii?Q?7qPO7xH3esIo7fmjpoVQ86U5m3an/ClaK7VUJeR2qrAmoJbUWEPpxTFvrtva?=
 =?us-ascii?Q?42HMHTbpZO1qQBU/VZGVgPwSj9fzl0ftYPyPeUrDdnTbGtb0mHPaOFWzEsQ1?=
 =?us-ascii?Q?pcwNBKAqfROWFMcBTwb/2GM/MnjWgVKDMHddSIMBeAzNnMg2oZF5UxHsSMf3?=
 =?us-ascii?Q?1l/+9SkX9K5qJm+gxt1JeB0/bSgTjC/6wLfVi75o53Vms1HHCVTOsQ0e2SrF?=
 =?us-ascii?Q?XKd6378VO6o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oeQcDseuYONSJ2mD2U5QPxam1Cj5bviC3a3iLOM2mSWIVaJGZ8IFC4oQt23E?=
 =?us-ascii?Q?lKTJ6gbJjw2RUIc908t/wEVJxni+MPxNHXy47joU7tRon7SMNMFke7TNzhky?=
 =?us-ascii?Q?+GL8NVn3PMz4zubTFYvPhY/xQYwitsE+pVRSIExN6JtLQZsNkG7oLQ3ZLEWw?=
 =?us-ascii?Q?jxz7V2HAgj2RusaUHESatTu9TWyKydqyaEiXy6dvoZOLTNNu180saztgqObf?=
 =?us-ascii?Q?YI7hg5yer+JsVGaUkbGfGXZgaBKlIKfv5mcvgJl/vmuCayiRvF7kN8fNezzB?=
 =?us-ascii?Q?DluIERZVstsalLcxvNTvT1BIIptLQTPZBqU7NbgFVmalrPGtVgSRSMsK4CQY?=
 =?us-ascii?Q?rM4BSajthE1fLLRNyQsA8U8ApA/s713DZ1IFdEIYw3jDkGBdi4j5OXi5R28B?=
 =?us-ascii?Q?qlIBZmNolYKNywMY4MQfuR23AXQabb3Ek8DIMHRn+4p6ITu0oSgzEujJjXjH?=
 =?us-ascii?Q?8zxOyGQeNoECS2Ji8UHgj/gxBkAWblJ3/BLZUDcqBFOEVPoOppgW+8YcFd2u?=
 =?us-ascii?Q?xNX6k82MAqvaXQnLIMdRZr+Kg8zHvmVSkes73XTdBja6FOMqMyNdoO5YIZ7u?=
 =?us-ascii?Q?Qh7lgRcvpynjEE8xIhfugXVt9Y3oGkN/3z4XtzC8iEUiTw3Yo57azUSw+7eL?=
 =?us-ascii?Q?ZWK0IXWwOcefmJrZ46M0rTyEDz9IOudatRH2vtQGG8TGS8R59xWi0Ob9y1jW?=
 =?us-ascii?Q?P7ZaVrVQfISW/zRGSHlahE5AetRHb5Hc6w+TY3V5NkCtj4Fm1DwUWAGBK6rJ?=
 =?us-ascii?Q?cF8ar328D5LRD7AtpzVbb3Sa6y41qdrbTTrlVxzrfpH1tCy0AimT3RdxeJnu?=
 =?us-ascii?Q?Nr84yDyzpq3LTsAdUO2c0ZNF32tNnpGkDChRZV5jZZGjlUZC8ow8J9eTD+K1?=
 =?us-ascii?Q?OOBJCKOBcRhyF+xxhAhjSwYfqadmUgcTqoupmUWMFRN/DcKHbGBXkv4E1meF?=
 =?us-ascii?Q?DHV+ez+Cx7N6tvKgW23889uVVgfUV7TNEPURjVTT8vgdi5KUuZbZW7YZdpo8?=
 =?us-ascii?Q?3hbGLUXIi9qWT1G9tuQWWA4Ah/akjB/3Kbf7NVCAMcwGUclIX+tgHvyDXtjN?=
 =?us-ascii?Q?OBzkK5MWna/xJV7f00pLix8tocuZu662XGFqXSAmKZZBzqvOMGF3IlbE5qPR?=
 =?us-ascii?Q?IOBjb//7904xl3hO/VzLnrCnY0zW9kKssRLRyRW6lvXhNTps6KsWAQFDtjBy?=
 =?us-ascii?Q?J7/a43D5+Jj6KxeOb+n07Ewty/Nl0hsXmnLotwn78K9XX0cbApsUi+RoD+rZ?=
 =?us-ascii?Q?jc2cH3BbuOwJIlui3IZex0SmCf7iAN+vywqkXJwlMmSpoaEqeK49UcyrwUOQ?=
 =?us-ascii?Q?y3s3eG6RvPwUDtsDnEImWLaXFvtievZOTkyD0omf3zONwsuyhsOyO7p601wD?=
 =?us-ascii?Q?kZXR991MCNrrmmZNMY+vKfi/PGCK7IaQkcfJG0VsE85T0QQFiyYthQs9a618?=
 =?us-ascii?Q?nZG2twtSEYPh0W+9hRWG3YOsL4AWoXKuW7hn8FixPHqQeMGBoxqvzgiidiXL?=
 =?us-ascii?Q?onZ4rsnTXp0eAK64A4RzyLD948NgOXlWNvBH9N/dAJPWBZ14iJUKRhe3RjNz?=
 =?us-ascii?Q?lEgY8GttIRkOC05c1LjLXcVsrbJZPhHaDITRPoby?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4378c229-c463-4f51-e442-08dd8638e261
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 09:41:43.3540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1E/sV1/WT1LQRI0AqsdSvH0H5JzgNMrlCsWL54UxrxVzdW7v07DhVJ/wJA3MNJsOO8Ap0pN22MlajR8ye60iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P123MB6498

I noticed that the Linux MegaRAID driver for SAS based RAID controllers has
the same aforementioned module parameter. Despite the potential performance
drawbacks, I suspect it would be useful with the Broadcom MPI3 Storage
Controller Driver too, to respect the default IRQ affinity.
Please let me know your thoughts.

Aaron Tomlin (1):
  scsi: mpi3mr: Introduce smp_affinity_enable module parameter

 drivers/scsi/mpi3mr/mpi3mr_fw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
2.47.1

