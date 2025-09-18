Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013052.outbound.protection.outlook.com [40.107.44.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8E224468C;
	Thu, 18 Sep 2025 03:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758167611; cv=fail; b=hMQmCFYNqlDsqM9qGpWWqSs3lzRAP888EpNhfMgaC574ttEJ24nf+ZjeHi0z7ntmoToQm06q7PnFTP1ftrMCHD4D2Ps/QOREj/Nd5V5VXoGqdC7J5uCLcEhQMyefH63H+1toiX/68pqDw76dQmEjGo18ljgPIWtiKRQMeqz2Ql4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758167611; c=relaxed/simple;
	bh=jjgEWXOmiIZUgCSjwpLbmxsSH96vmsBLnRREVMbwY2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=szxJcnYzRQERB91Sv6zeSw5zwEn/hT8b30Prpe58pC0ZvWB5utvz26kREpEIrtxLA+LnX4bORpCoXTbQZYb+KuXdLedOoTY7uAQUVpBBZdDyfyiaiKXPADSybZ9/Tig33jv3g+wKw6z14zPgqjvBoxh8kIU3pf3VBEIiFAsHxC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=ornXkOYW; arc=fail smtp.client-ip=40.107.44.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="ornXkOYW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PI9uvZ+rHgi7GD6PkAHGKNhgDE6v7T01F6D3DcYoYjwfOQtJLcQzhhA9lqox0iWjG8soBwy60gcKPKNT3wYNZT6XxtvqPu2jO2XFnOeULLmAenXuOSOQREUR5D2ZtJ+iT2en5ptZ2a7mrv4qXptL9Xh/65HCUB5No4zriZMMLaj8nUJyit5DDCKp4cFkS2fATns2LGuo7WE/e4C9VzlJXc+13ubd0fRnMc1PJQr0PgUK6Z9G3VHNjf1xaF8+DgknVB/Z+VHEWgyILohPrYvZBc+Hgify2tqqaLE3Yhmli3N3PJq9kAnlClgLw9iBpPzjrLQeCmXX34V3Or41a09IgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jjgEWXOmiIZUgCSjwpLbmxsSH96vmsBLnRREVMbwY2o=;
 b=PZIU1AaZ5Jij3BU2I8hPxUPjpBUrqwIJ5fIGd7dUGFCcUbT/PIoZLGz04yssZHkdz2i1eTIyc5yxnzyTb8GeiMn0LMGHpx+KQhWJLXis7kvnF8Qqt0JGH1+525zcM5/pGo4gy2TjVhjPgl+iEBgJFH8HnIMqzj7JlyKz76n547YviRRH4C2YAf2XXN9SPzRr+Xmu18saTNyGFr5XGdzzpQ4K6Ki+StEOgYpyEu9Epz9xT8O997ThmbD69S7K+F6aI//igC9odKaCTzTcY0jr2NStTfMGL3Ounv6GDz/xZ29Rhe0hTJCjyT579CmBx6WLGJ46fFkGP6QruwH2G0KhLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjgEWXOmiIZUgCSjwpLbmxsSH96vmsBLnRREVMbwY2o=;
 b=ornXkOYWRhKGKyTtjTt8HdatCiGCceujoj6AKon4mcd2ihIa4VguxsKnLO414k/cWWf1wKIwXBL7xXc89CsDUgqYp8iNvNKmNUBVtBqsrE2f52k/bJPbu0l0JSGpwvwVNf6PxiUn6mxikFd5DSWRPKrmV1rKkX9DQYaK6yWRnoIyaP2HwdmUt3dJOcn4hyTRp0CCh8VuBzxJOajvRd+WGcJnEY87J3kruhr5+EIVQLl9GMEdk06Sa1iqKFrmZ8pq2uKXtyk2ZjXGsDP0BvT67OFUnrw6abqJx6ZUuU+WVwRe2l4TCjmCLO3uH07X3U4oen9j6964SKdYTeqWqAG+Dg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEYPR06MB6864.apcprd06.prod.outlook.com (2603:1096:101:1b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 03:53:24 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::1f06:daf8:cbb3:a0be]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::1f06:daf8:cbb3:a0be%6]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 03:53:24 +0000
From: Huan Tang <tanghuan@vivo.com>
To: zhongqiu.han@oss.qualcomm.com
Cc: James.Bottomley@HansenPartnership.com,
	adrian.hunter@intel.com,
	alim.akhtar@samsung.com,
	angelogioacchino.delregno@collabora.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	can.guo@oss.qualcomm.com,
	ebiggers@kernel.org,
	huobean@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	liu.song13@zte.com.cn,
	martin.petersen@oracle.com,
	neil.armstrong@linaro.org,
	nitin.rawat@oss.qualcomm.com,
	peter.wang@mediatek.com,
	quic_mnaresh@quicinc.com,
	quic_narepall@quicinc.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com,
	viro@zeniv.linux.org.uk,
	ziqi.chen@oss.qualcomm.com
Subject: [PATCH v3] scsi: ufs: core: Fix data race in CPU latency PM QoS request handling
Date: Thu, 18 Sep 2025 11:53:14 +0800
Message-Id: <20250918035314.188-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
References: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0216.apcprd04.prod.outlook.com
 (2603:1096:4:187::18) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEYPR06MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: 66704c15-6235-4413-5b51-08ddf666ea81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|52116014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mIUC8jvivaOSm9Qo01cUollZgyYG3bByBto9nxT1W9M8MdH6ui1zkSWxsHOJ?=
 =?us-ascii?Q?tEoUt3JikAFLKJkDKhm2ed8qZAXzLPPHD/PFhmbsYGX6guy5PyvFrNm7I/bF?=
 =?us-ascii?Q?iRZAkxn5IRhKoeNEowYg5Dh6/S0F379BaPyYBO0WbUBWtv91GGrizgsY7Sh0?=
 =?us-ascii?Q?9H/wuPb5dhFOs+ajAx+rQ//yVzdO3gxiYwu4QiJ6+RXm8MsfDzt8C+dnfZDZ?=
 =?us-ascii?Q?rVWrzY+JAOHN6K6iwv6FyC4A89YIGUrybJ6C0AuWsaIa0jYsjR3mPJgPmeo6?=
 =?us-ascii?Q?R/YguoLGLUBmoxIWb8Zvf7dZIRtOJVV8bkIdmFdmbeUgtLtvnoSPkhIAqh5g?=
 =?us-ascii?Q?oiEoQ6Zhdg2a8qpoCssP+LyxKIP5ELhTv2IEbqh0SQLVaTcPLOQ07NfEtHGM?=
 =?us-ascii?Q?6soy3PXD4i8c1PY0QGq4NTmvWjVyqYRHt4tzyb37C8ne0PBL1ldW6wStUIGj?=
 =?us-ascii?Q?mFCrmy48CEBRkOM18E/M5PK5RsAVXfEIiXGDhTcf7G+zAoNxss1IZWyEVgSD?=
 =?us-ascii?Q?RNqM4JRZiSFnXxxwOUuMdmwNRYrkcNwEY6W5ffYPYQ1mUC/3UdE8ReteQNnP?=
 =?us-ascii?Q?Psb/rKdsHufSIEGmovx+I2Pn4nORBFYumJIv9D0DOMLicLx0rs/2CuUMzNp6?=
 =?us-ascii?Q?9A6B1qUe6UC43gsWE5Vx1ZrZRrCPwfP8CcVNHaQ6ZiWMpV7h8P0qhOFLHak3?=
 =?us-ascii?Q?OwcjKyyJ8NPRyqb6hwPED+gMJNs0frGU8HQjWa8VweWrHlJ34fsxCa7O8zhk?=
 =?us-ascii?Q?IAioTQBheR2Q6H/Ju54Yhd1C2iaMRAoC7RUE4UKLQRLejhbzmOtz6h8aDjn9?=
 =?us-ascii?Q?H5JVNoj6OMN12bWOScW1ONxFVnoy7WNYssyNrrU3Cg3z7pCKb94OGbxB/Pnq?=
 =?us-ascii?Q?SC0cU8Dt6GeDYcbOwv7PP4kRxWpaDov622obdkDML8BlTwl9p4Imi1o3sRNC?=
 =?us-ascii?Q?TziNVOVkl9wK1gwfHi9mWwnYtSo7R3g2P8Lriza3pefRnBdTC1ViF7ETHutp?=
 =?us-ascii?Q?3n13HjHeDU5zR2qYlI6L0p4hW7NgBs+qhHv3mdFKT5CZegi4onyuxhWaWcng?=
 =?us-ascii?Q?vhYA8jo4LKXoccAjkMh3CiMJxOoFcUN69d90ZlojJzMty0Q7+r6XALANIxwu?=
 =?us-ascii?Q?Dd66ASoC+UYvRLq/Vu8iCrQMZJUUbMLTS17tClLYEcmRjR8sNR9QNC8ZNIyu?=
 =?us-ascii?Q?6wHovYk9xnbrZCrfw3rYfgYgGcGOx+3SEVxOLWbTslCWq94PS1OqBhtl61Ez?=
 =?us-ascii?Q?2/cG0b8s9ZSYfRA0/cBVpxrfTVMgbGP7R2M9T78QkLaYZ+z9xLkZX0x52p4u?=
 =?us-ascii?Q?UoYxdFD2TfafwW8gLBiIjdlhmy55sIlyOPE+G+Kq4EI+LhmOpKfO554jxcZe?=
 =?us-ascii?Q?XY8SgTED5iXV8X+u2A06Cu9RziFEJElEYhvvNe+6dfr5I/BNmIIXQqQLEFC6?=
 =?us-ascii?Q?REmwtAG9QhqBny32qiLtf9KY9vEkwDuvRcdnhgsn6tNj7NakoIVTPg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(52116014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NZS5Z0lBOVL+J3FEbxL3743lGbogglFv7IB2d88UCiPhsophEnpWlhibjO5Y?=
 =?us-ascii?Q?knsZgybU+OGsAvda4eMfj9cotz+By7wDBAOtzPhdALdvYU34rXmY6mO2mA/a?=
 =?us-ascii?Q?HQ2PCf5gfVcwLuH3juwdgdW5cS1esZqEAQTPmW7uGMZGHr9YTP2nM2h9gB+9?=
 =?us-ascii?Q?yTO333j4LYmYKxM5WO8ryLluR/Wg34uYeQy70QIle4xd4hwIMg8TR89ZiqeS?=
 =?us-ascii?Q?GlY5wog9IV4blmR0PGWJz7MRw98UFgsGXo7PrOSsJyThUiIzcZvUPg2RSQUJ?=
 =?us-ascii?Q?g9MdmFtTuGVoS3gIi/LQBddc/H/FTAVXetYndsCa3YrdIMbE1XxWp7sIKgIj?=
 =?us-ascii?Q?KaI3Yu1YZrsgB8LgN9nreFcBDmzjYkVsrO4ikxNpk+yia+QKLdQnDPob2BJ7?=
 =?us-ascii?Q?3KIjsYnTL2CP8SpdV3Wi+gCuvhVUlu4b7iEXhwfj632toeMsNQkyx5yiYxRq?=
 =?us-ascii?Q?J/hBxTfm+5xG+0M3OzgCCk6d9HE6i5OdCsghj/77L8lLQtqXCzYNcdBE/Lr5?=
 =?us-ascii?Q?vmc8fpAgys/IuX6mWC8gg3tAgAhvJgH2V2jkGH1RlojuhsJoXW0mywh3Q7am?=
 =?us-ascii?Q?zp+s766MGRTYb9TzzhdVyVXZB72i5l9x8LsO8nfpPXmrZi0S7DLfcAg8luep?=
 =?us-ascii?Q?2J4XyVMItbMgYvtI09fCAUNiS+ePG1N1/QgZM3Z0H+IOIK0A4ZVmZg+WgcSO?=
 =?us-ascii?Q?xbVwPA+GDVjHZB2Uy0uf5+VkYfB0Smm4FlEs1b3VeuJ7mnVDRMuh3UJje3K2?=
 =?us-ascii?Q?QiYd0w8BTPsSoJfMXnhb2g3lNikm7rAejMWUAXgdNK2kK6DUkcyZFF5cu8aq?=
 =?us-ascii?Q?KRP9HlCPmcTCbijA6IwSgcdvo/dVP/L7hs4EGgOLYWzpPN+rLQPzXHrFFVdT?=
 =?us-ascii?Q?fmTejUzG5l73SfQPUfF11bVgjv1l3ug1gOxIADPluw+BHFvKCFp6aspxtIlD?=
 =?us-ascii?Q?I8gJVmT3lhjFGB/QhTLWHiE7T+asbDudWQ/80XU32LqCLN8BubuuMXuzFZe8?=
 =?us-ascii?Q?f6OaDyIKQRqZtd+7XRBshiUTIv4iKsluTNU6jPBcoZflJAWvLEaHdWRb2ma1?=
 =?us-ascii?Q?9ZmQdXr802At7fN/MnjOO0NMC/maLkcCIEZrNEXbCXTbdUf6b4GBG2gXYIEs?=
 =?us-ascii?Q?OlPT4VyWkBwnWlqOB30BLATSsIvOAohj6Jj0sngAB0aOeQp7HF/KuS5kkNZP?=
 =?us-ascii?Q?xiu6UG89wCQojKqVjtWkS9chzcQXGtXXexuuGQEr4utOP0GmRlz6gsIrzSpL?=
 =?us-ascii?Q?SHbjuLZvjuyzniLUNnUCX92HspRCoLhCkFQrRS0tQBb4Zd42KOXS9skPIS3T?=
 =?us-ascii?Q?au+yLPKYx0ETNdzmnvo45nPqLYUTUYCSwKO9DlXtlgVWtpvLNz0KMjbelpOw?=
 =?us-ascii?Q?L9KttOy4Fx7ZZjLuhT2G6QO4RZ3RBzufSnYlbknt0867/gAQehyEupXZnAxJ?=
 =?us-ascii?Q?uCiJyyCp4Wlc6xIk7lI0UvaQJYE0EQtGMBuF945Hbj33/v0reAFpXwCuSU8c?=
 =?us-ascii?Q?TtSbEZXX7sL1/QA6Jp/VS0SsVT88G+6Qve/AvGHcbdEZY0uPiKaO3F9inhrb?=
 =?us-ascii?Q?O8+URTYANIlDkDIx2xQRuJHoCz4b/uzs0cEQlt1P?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66704c15-6235-4413-5b51-08ddf666ea81
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 03:53:24.3451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fd6Grhhb0+nAaxfEhKdsNbcNySxqOQVyT8qf3tkKwO8IGbgLVPh30gubPcPkIVYz62DIpfBRGPFJWBVm03PTqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6864

> This patch introduces a dedicated mutex to serialize PM QoS operations,=0D
> preventing data races and ensuring safe access to PM QoS resources,=0D
> including sysfs interface reads.=0D
=0D
Reboot stress test on vivo phone:=0D
without the patch, fail rate: 11/2000=0D
with the patch, fail rate: 0/3200=0D
=0D
Tested-by: Huan Tang <tanghuan@vivo.com>=0D
=0D
=0D
