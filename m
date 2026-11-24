Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795524131;
	b=DAS6tHTQC9yiDs5Js86b+Ebj8Om5o46bPItNRMkC/tKo0gf4ukm5xE+nZnuMJdzkIgEH
	 FCGfoDalFF0m2Um3B0Cf2qpwKAbP9rSM25uhJWbLPNXrayNYUB5dqaCc9T0NmEH2mFUK9
	 Ou4QAaRv7E6PxELKg6JkNmFlO99i1GkfY9M9Az3AMgmNd2qqZrpH1tXWGn6D+Af+OiLyi
	 Y/LyUVbJbv5ezYYZU+BrcmZX1EwCc4SwU91FCODb7r33CDQS9ljnI3ED0czepqIYLbCRA
	 Dyl//7ojDg/J7qDygyNh95MxV498tcTnSeG+GltWxfTJh4w1b88nZ27YY169pDBy4FA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795524131;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=S/+6Wt2blZByAZwtyd4AgHeUKwvyjj5q2Iu1fRjKB4A=;
	b=Atmu11NF/UkTvsjHB5ux92EpNIX+PU+NkZd7cijdzL9BEDG+KIPC/UyrjsGi0UliglV9
	 Dxx4DvIWooVZDou0Cd7X+P8jDvU9awWAQkZMUSkv1FD/fprxdDz/YMLht0TT4otM/mrHE
	 lOTwo+1COvmKXW3W6tjHfGQX1VMG5tXt7Fty282ML1XP/kwzAHiihgGKMzWp4KymYganZ
	 s6w9m8lK0mvXeX9wUMXeWCV/SeT+PBfs9dgLmxsOSgCqcHket7VkRrnpbygM0wZsmRijP
	 2++gDrT2P7lNZXQls1rzvG8rsA0sh68nuR+km6KNyqoQ8KN42idVkw+//jABNGWi3Pw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=WfGPUhVP;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CvPfWnP1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC85606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 12:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EC85606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=WfGPUhVP;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CvPfWnP1
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795524131; x=1827060131;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=8WwGjtJp1fXJCcftWwn3LcU/A80zzjh3HIq5Af1ywro=;
  b=WfGPUhVPXYFH0jQOwMoqjRqzKhikTXoF3eotdxw6oHPPJjktkOoizBQD
   A/lfnarPXG7x+Lq7qvU6b4Ku//ZK8WGnxbe1rByQdh0kfJlvEgiR0RfHz
   6ndrcOtjo7eVvMKafiXA1R3JIpZS8a5TO+xCtBdKHsiqYAKm1sBfUjVMA
   X4D8/AGRLa2Hu7XMyNFDn5OM2rYPSL4XjVRTEx3p81Gv13bnIrsc0fUtd
   ljXPF49cfO+kUFxNphU7E0ChMFKjtU8IuHMraUQYUy8P7zrgbxF0v/SiO
   YjRmmTbpyz9ypGeTZ2B5wfUzxSo58mobxrARk3+iThd7yUbu7cHFfof3V
   g==;
X-CSE-ConnectionGUID: m5t86+2VSfehzvg8tj511g==
X-CSE-MsgGUID: iVUxnrcjQzq+zHWyz5iyXg==
X-IronPort-AV: E=Sophos;i="6.27,230,1786982400"; 
   d="scan'208";a="161646590"
Received: from mail-eastus2azon11011030.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.30])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Nov 2026 20:41:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L1VGSBDqMeuIentAfnLivu50Dqg0zr4D4LMDd2p+RWRRdZQdNwgz9U7cHkY9yt/F+9MLxOhENS7M/ixiLGcZQhM0QTqIqKxhYfSW9+RZH2C6HRuM7bATyHHnB8TsnUS7bcXMQF5xa/5nNalElahf/g0O5qRsHKDIE8hyhEy5FYRqfaOvivD+HioUiYzBDZEnNRNXpGzd1j9YXw9zf2VNVCzYHpL93qw4Y9tvLlfvE2LbnnZRkv9/OiqSOVncFk707VicPazQiffPABFC5o+ooIzt2RDYlbBbQFkruWHWEIE8hPvQs+QbQHE6cdrq2pO8CoVP2fV5MHHV58WxIU+hTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/+6Wt2blZByAZwtyd4AgHeUKwvyjj5q2Iu1fRjKB4A=;
 b=X5RPqhajxCAWqd6HxEFR1zJDEilb52yc7jlqJkotu7Rdycv6v2kViPq6dcaVXjyJyqYQ0v6XCs3GwelJmaeXy2UxkkPebPvhw+JcpLR/1r1WYA6t2B2+y1/oRJ4Je/TH4vhYWY+Fah7nQth0iDv6gJbvGLWPP6ZNrbKhdpWY9xSCGCDZbXGEmjjxjewWJPUV2D7zG3cnUIHuXNmTloNjgsXPfmKXFYJIZxRQPvVtaSN8LWbaJRXLcDIcmkuLTcEwU607h9//mQWGwPZCNNF3lwDD/+L51s1Fjvt6Ga1K2rmoMgO8/aABGbFc9E3YCth+OOJ7Ct75BXWm0NQIfAKF5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/+6Wt2blZByAZwtyd4AgHeUKwvyjj5q2Iu1fRjKB4A=;
 b=CvPfWnP1C4dxVHu6OhEPlTDkSdXBVCW5QrGh6a17KyDyTQwAf/EKMTFNsO6tayQsL/2Z9PEJgc2IO7Fkuq1N4H6tP8+sW7kRS0ODQD9Lo23fjrU8er2lr6BHq5TNX8FpgyljsD2fvX4yU7N79Syua9L+ux6Rl/KnkPwv2VGNfbI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA1PR04MB9873.namprd04.prod.outlook.com (2603:10b6:806:49e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 12:41:55 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 12:41:55 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] scsi: trace: print the CDL duration limit descriptor index
Date: Tue, 24 Nov 2026 13:41:37 +0100
Message-ID: <20261124124137.146673-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0192.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA1PR04MB9873:EE_
X-MS-Office365-Filtering-Correlation-Id: efd2401f-5b54-4d83-a109-08df4a285272
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10070799003|19092799006|10067099003|56012099006|11063799006|261021121427099003|261022075727099003|261102123227099003|261009223027099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	QwlNHa5spy9y9TKa8cO/neqYlBkmkAGbnW52U8TjGmAcBOWc1wVX/iYBjQqD4OIatw5aOTKfNlT7nebhZx3cCabITMzlioWwYDkpOhq6jiaoFaSjiHZLCRCEZtuXSHSP93MkgDLEo0cGbO9TOO42Y8C/UcRtwbGl23FPDJEVRLRLlQ2cfgP71rfnfLsnSDgXTFsAtO61rOUGG0NXqheU6kvY5JbBIXtQ1sO07igAwGaJJ1kJK3M5H+QD1U8/Fr8HhETET1XDOAvinh9c7x6qhQX/JIJTB5I2Am37GWtzdBF4aXSAU9vohy92qZXn2uwfjIrKHoQcdZtGcov6ffmI9KQWLn5dAVhVoqS8CpSRC23yskxhpqBXJQHturZ5fnVUuaKF5CuUyWZCbRNLzLfFcHM3ifT+ZkQQ/5f14OZUu0fE1fANF5QPr8EcHk7LwZcGtrKirlxKHUVYfsfNFRxJvKLHhZS8/j3z0en/Czjcq5ayxdZI9aRvx76qzL2M1y+vw70TM7npY+CsgakAqRFJKeUO/chzh4XhiHBkomMt+ZwMWr7Zw0dWb9C+FDoTNu2RaSlUOdLTF8gsAbIS67qZ6Jt7QovlCZZeetOpKYQlBVbqCIatmWqg+Bp+DyMvaH+K2Gi+BqpgpnAu3unH6xkHHLyBIucI6kfuux+SyWkKhjo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10070799003)(19092799006)(10067099003)(56012099006)(11063799006)(261021121427099003)(261022075727099003)(261102123227099003)(261009223027099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CWEOrAlNsjjpjdfCYbPbTnrzzfbyqbbNJauj+UZOJEF95nVqyT8Onpxucu8H?=
 =?us-ascii?Q?R5nZz6SoNYes+8/rJLyASpMqs9PZCrNY7puGF6KCL3UZjcnUg+62ivw0r5uz?=
 =?us-ascii?Q?uD05iwahBvhw85YLLQ8KRFOXfzB/IPgK33ZFlLP6REESAYq0NMG3yyEGkuQL?=
 =?us-ascii?Q?66JpRJ/3xmxVP1rA2PlPmGLac69yUgzu6Cl844fmdL7uaazXKOCzfflUZ1Ay?=
 =?us-ascii?Q?e6iIkDajpfVRodC2uiD/r8RGwNJXEfFmGGSwW0Aip08MMhIW8AuRyf0W4xp3?=
 =?us-ascii?Q?DhHLI7dy9d8q+Qy3ka/Xs0RrIXDhQEhKYOTirnOc6uQdHJV0UYjgqYV7Wz4E?=
 =?us-ascii?Q?dmk5O3rEl8t4r6k4pOgj9H2nLRcOeXsImBgZojUtpCrIX/qPoEOFM3OiZkQ4?=
 =?us-ascii?Q?Iyxi89okxEkZFn5+H4ZI++vOjUVg79EUXJR7w69sGTnpNVbcGTtsceO8cJQ7?=
 =?us-ascii?Q?DOB4ZaOasrTHtHiBZeo2dWM/LddUvXuwe2+LnaBs9K9VojrfDlQUWhNTyn9o?=
 =?us-ascii?Q?C4/yehp4nI+PUh3x3YyZ3R8Jre5tvsJdu+yz3+H4X/aknu4ciHL0SL7zpLdB?=
 =?us-ascii?Q?4r+NLd/oeZJSolpBzeIIAbYeoHzwwkAf/59TxyfUZmZ0ua1/e4mhNgDIIR8J?=
 =?us-ascii?Q?/uWOGjDwALn45GrO3b7TIBIPbIKGWN37cGXbZuESUYJIdevRp67nC5VkP0ZY?=
 =?us-ascii?Q?0oDe/OqkYxQ/OozNOCjRbWZFj/trr/4HQql23m8KnB1tHnNytNXujqR8LR7e?=
 =?us-ascii?Q?GQT5HJ4c1kzdFG6D8vshv7fajrkByU6jxxTr7Er4kDToYwC3jQCo0CoMMnCk?=
 =?us-ascii?Q?hOQrGsLLapqvfpdx3WIKJfc+S/i/cPG38UZLOE4TpepmHZK425h6W8ZuFfj0?=
 =?us-ascii?Q?P44kHWttK9+yZHkBJWpcQf6eFb37tECKeGDTGdy3WpXedarEDHHllxhW4Etn?=
 =?us-ascii?Q?XumvX6Y5Vzpr1mxD5FaSzEudH5jxhknPpi/i5FxhMvAH1KhP/khmZZn0SkLb?=
 =?us-ascii?Q?SQkPr0+p7Xg1ktIFiw6YmJRKU08Oy9FSqO/Lh7Yt/7sLtvkglu01VkUAu4KO?=
 =?us-ascii?Q?J26dVw1Dvj6xNAjVTJ8pJKHYIoUwz7RdRoGxyvRlbVquspzZb2PzS5aqL9rg?=
 =?us-ascii?Q?110JpZJr4M/Gf2Ji5ofO/e7zyxfWHM2T+QhuS4B0Hkv1VQsANIE7iLi8/4Kb?=
 =?us-ascii?Q?LLThulM9bd4a7Jb7efpa8g2reDfVRS3pX+IN7gGwlFHXXxzwHqTEk/l8imp+?=
 =?us-ascii?Q?23Fso1sT5wfFL/4dTvFiGJf45AgeQy9Qrw3LcZQkdveA/h7HSaLYpskdnypV?=
 =?us-ascii?Q?w3J43wX3IiimnwxRmp3jGasV3RKzK9/Bm140ROJp8KHGFgobFVXPOvDjUYNG?=
 =?us-ascii?Q?SGN4SNemK8fyLASiB5hDUPxUYtRG1HEGNN3g29hIlZmyCV4pw8+wDceUFhxV?=
 =?us-ascii?Q?Nb6cpndx8XVH4Tgb3M43NbxQTIJ3UOKe6mOXD8RqnWFm2iHg0wlHuch11aB8?=
 =?us-ascii?Q?vl4FnHOwOQR7YFyuqRJrwdi0wETi46j0wpERXKQ/KWowr+JOC2NfQjuButsE?=
 =?us-ascii?Q?JuSICfRtavHnEf7XhaHtletGQ9MOp1PQlEAL/efnHl86+VRTxXrjDNYhOMTy?=
 =?us-ascii?Q?N8UVjEpUOjl70550eUuIaCGGNEK00qWDl/VO0rWGAa/74ADzb6Hhi+BHBoUU?=
 =?us-ascii?Q?LjUsRmgp26y61U87ee6nb7WKfTxwAIu1358jWfgUg8Gh9BLtmV2lONFVVNFA?=
 =?us-ascii?Q?sJxVSAwoAgOwxsx/U+5x+DUbyJVOHKnS+AtTPNWmfENQ6XmIE1fTkMB0PVvd?=
X-MS-Exchange-AntiSpam-MessageData-1: Mnh/IqMji/KWajS09ByGSjPNqBpuSWtoFrU=
X-Exchange-RoutingPolicyChecked:
	Jzmigsjt84qr/zKfHnxVeFbmKgvQLUxXaUpeidLlnCBdqq/sNS3ErxyS9/fycI3B3u0jUdoD+BZ6f/ARNJ3BNc/DavXJ8aqPAUt/84LClHiaMI5I76WQNlJduwVR3Ux4du5jXIFrC74F3bF9cXyZ3PpQA4eZnkXlV8XuXYBg0XZBlrb2hmcpNjQlciHPCJ+22tCAZF3UbukgPzugklPmSFNX4bwwMj3QfSVpYHmIXpivK03xyqqhaS3r4pkCEcDEXI7SQJJqP/sODeC8NewbuIEyHoiwXcMWxkIRRlrSdaUDBZYrIL2sEBhaVzxIi4F2zJZDg0WRZ/qVGDI3u8MC+Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	azk0NF50Yx6z531Kjek0HR8f58JxkRuKzmcHZvALWpMN80abLt0EbfOErFObe56LmhxrLW4SeSWvFbH94aGRdQD1CzPljoUzsCevWZeTdPdGv8KsIkx6lzF8KIjy02sDi/VqhKsHVRCTr4UOCLMs5vnXrpPcebWCOC6hFyHT6GealBsDGSSTOChGSLRxlN+axVEk67VswKj6912RBInUFeOoUzQ3QMmRC0vDAGlLL9/yn4J9KpWaqkyjRV1mPH8s4R74ZpY2SaUPH7OVGhUyuWMKfRdvrnOqkAGDfCARMDYf53/yQ7zTk7cDP09kBWx8BBUQ3RZhWypgvQ5/DsZSL8RtUddZFaEM/sGgWyMYIbexOnaENq8c7jAD/hwQyyRlD+cbc7ikYk90pM7bRH3UyHYPjJr9YWBa4q9nvTvRA7M97rjATCxQQXZUT8ppbZfYRoedMrCYi5dNU8Le9csOTcmbAnWS6UodSpu3yrt7IZxeCqF155rCjx/Bn30uYniPnikq8eia5CFxM5JVwKkEAPBKPA0YCFgYhvp/MiKajk8eG6dBvvQUgcpWQ7nXYRYeThTE3+R9YXxOkNDaEia5ftsATPEE+og5QZGEJ3Hg5rxVmMlVd0p3+iCYCexWe/q1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd2401f-5b54-4d83-a109-08df4a285272
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 12:41:55.5248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UaJMIi5/Px2IFA0oz9p38zPZZMMLQT7RBX9os4ZO6/1s2ORtO3pv/wXzSblxuNmecPYSzPebTDfCkBZDPxSWtr5dLFoejj678MThhirmrFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB9873

Print the duration limit descriptor index (DLD) of READ(16), WRITE(16),
READ(32) and WRITE(32) commands in the SCSI command tracing, so it can be
seen which command duration limit a command was issued with.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/scsi_trace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index b3baae91e7a2..bd3ed38e14f3 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -82,6 +82,10 @@ scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 	trace_seq_printf(p, "lba=%llu txlen=%u protect=%u", lba, txlen,
 			 cdb[1] >> 5);
 
+	if (cdb[0] == READ_16 || cdb[0] == WRITE_16)
+		trace_seq_printf(p, " dld=%u",
+				 ((cdb[1] & 0x01) << 2) | (cdb[14] >> 6));
+
 	if (cdb[0] == WRITE_SAME_16)
 		trace_seq_printf(p, " unmap=%u", cdb[1] >> 3 & 1);
 
@@ -122,6 +126,10 @@ scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 	trace_seq_printf(p, "%s_32 lba=%llu txlen=%u protect=%u ei_lbrt=%u",
 			 cmd, lba, txlen, cdb[10] >> 5, ei_lbrt);
 
+	if (SERVICE_ACTION32(cdb) == READ_32 ||
+	    SERVICE_ACTION32(cdb) == WRITE_32)
+		trace_seq_printf(p, " dld=%u", cdb[11] & 0x07);
+
 	if (SERVICE_ACTION32(cdb) == WRITE_SAME_32)
 		trace_seq_printf(p, " unmap=%u", cdb[10] >> 3 & 1);
 
-- 
2.56.1

