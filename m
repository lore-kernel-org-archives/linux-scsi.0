Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022107.outbound.protection.outlook.com [40.107.75.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFC521D3D2;
	Thu, 23 Jul 2026 03:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784778334; cv=fail; b=nUUkX/BaihbQLmJvU7NNqxsH9cDO592kmQdAdkZZy+KS9yh4imGfE9ezdpkBz9mLtX+BnXG/NwwkA7t8unPNigy6lIpc4/YcCNAI4FqeOXVb5WJR7nUDgqgrUer9qbzwY3IoSziETelouagLTB0WoH7WC9nbiGDSxrQXwrRFXi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784778334; c=relaxed/simple;
	bh=GtUN/mVI/C2a86CiO6mSHZ7y6WaLq7+gIOWw+SPyUgI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=s4w8/lgurIaEvpuHRAYD3eRQAsIxZqMuwDmdl9nOyDxdfJILkeXP2T2TD0R6SiKHhlb0iCiHTRub94BpnPoIMSReWA1IPVgX+/yomyXtlxHUpGeQMYMSwa2KQeTwGaLfu+5mlpfc/6E9HcMRrZ+E7NIDYBl+BUw9OXxThlP5iqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com; spf=pass smtp.mailfrom=transsion.com; dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b=ZoQGRt2x; arc=fail smtp.client-ip=40.107.75.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=transsion.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b="ZoQGRt2x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SjmS/S5KJjJju79/GnnRgDHriUGFWQKPbMPxIMJVOCckvE+R6jI8JoodClG/dlzBYG5QvGNF2VcRrpcodWJcHoZ13wif8nE6qRx/CTnDdt3ikvzCrAX7UAHzgwzZfTi9lsRDPDvlTXeJyURqH77xskX7sEYjVstAIG/h+no1oZ0SLCRJypfZTPime71EUm0BOU5vjRsQL+/p0lb1ZZ6maOoHkwN7uFmm13bAG2a31IeRWWM0kmzmCImZJngursMhpjkQdv0vrwlE3/RYnfF7wPz6erbovSYfCYQrQClkyMm6f/qFOOqHTTYUuFLg1zruryYFr4VfE6rdtJt4zgmmZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xiE1CRWR5SH23c446UAibqdnJrHraHMfG7IP5uU5aC0=;
 b=gwLhsPH6FSwP6YOFSkAFIHavntdGFZwQLL3rJuEDHS1gJ2kIUx2OoR9yXv4wbSgF+KLd3mcHSSdxf4QemWmJgiajtFJYEZBGr5d6R+1bMinIUfLcZyhyxXsUsRpM3NUMCPWtxbtU2HjLewuLu1N9999DslGzOiLFfV6cr/pkzW8WQgKDLlde2S0+rEytdD7jYro0eVfCI9hXpsgpqyzm9gzC8Lz+ey4J/QubIUjBgGb3SiUtO/xi3vAETNuMMHeUp26pc6I0mOllPC2Rr6XwUGa5teY6Snryh8ZgWVr/BzZgs5qwL7ua+olpupM9Cn/UJijZwfHl7/OusqXHhCIgQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=transsion.com; dmarc=pass action=none
 header.from=transsion.com; dkim=pass header.d=transsion.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transsion.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiE1CRWR5SH23c446UAibqdnJrHraHMfG7IP5uU5aC0=;
 b=ZoQGRt2x7N2XzbYC0f+/YpPT+dzip2raDXaWkRfS6M3ihS61jz5bMjRfvJ2RfdU3H0B12G6Flt0DOMN2OGauV2wg49XTLHm8X71lW2Y6u5i1ZkEJTH3/9DXDWWEWd7ezBjSSihfxGFLey0BrPpc0xzp9OpSYWWXsddZ8Rg1v/mc=
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com (2603:1096:101:2e8::6)
 by SEZPR04MB9579.apcprd04.prod.outlook.com (2603:1096:101:33d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.5; Thu, 23 Jul
 2026 03:45:30 +0000
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2]) by SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2%3]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 03:45:30 +0000
From: Ao Sun <ao.sun@transsion.com>
To: "beanhuo@iokpp.de" <beanhuo@iokpp.de>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hongyan Xia
	<hongyan.xia@transsion.com>, Jiazi Li <jiazi.li@transsion.com>, Ao Sun
	<ao.sun@transsion.com>
Subject: [PATCH] scsi: ufs: core: Initialize hba->rpmbs list in ufshcd
Thread-Topic: [PATCH] scsi: ufs: core: Initialize hba->rpmbs list in ufshcd
Thread-Index: AQHdGlW1wo2hLp5Eqk2xHdUBYa2g3g==
Date: Thu, 23 Jul 2026 03:45:30 +0000
Message-ID: <20260723034440.217-1-ao.sun@transsion.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=transsion.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3PR04MB8921:EE_|SEZPR04MB9579:EE_
x-ms-office365-filtering-correlation-id: 0af3d381-7242-4248-8e26-08dee86cd783
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|42112799006|366016|376014|7416014|23010399003|56012099006|10067099003|11063799006|18002099003|38070700021;
x-microsoft-antispam-message-info:
 qSIUkZgZVwJTEGERCtRcyNucQbY5LtrksmiexEnsX1CfsickNTTbKhxyR/61bd5UQkR7qeD7J85YMpsvhe4v2lKy9saYpPvx4CbBoyHWxeH2nVg6/ju8ZGArMtWY+h0uc+6NO5M2aJl0/M600lznDISjd4j7T6fy8Z9zxtRiAkKbJp/ZF+cOo+lEG5gPSpUggnVwZOQEQZzpx1cvW6YyFK1K7BoqG4lsNeYIWTkWMj1/RoQaujcotmsgLfbX3493duLW04XWX4+Xfbro6tTVIAVg3wBzr+B8AsUD76k3W9iomZl3U4ZIrFr1IsP6hNk9PftEa9NMUtBmKyfejNQjNZ6eIcYpuNMJlkkFbOI+gIQu1xv+7g9P4O4YEybdjxTclAQBmL3E3D85ttcT8aym55QbxjCt+cB8nPSqvV8dqgJAITlvYdL/+oKE2UzZpPQcfFus7MdiCXd+c+lc+vApxv4VIr0mjkULayMLo73fpw0Fd8cIma4Q8DV6yfL3KSeOZBt/YfGZZC7Ag3Azw0OSckJDO76y4eYwGagpgvJ7WgzJDFMYCtwQdPyee1gHT4+TpmfMx0mtaAUdnnYLtrpVcXdN4yx9sgkr1SAb9SZlo6cBNHFmX2DvLM9ZrHx+Eo1YsQuIev56OZ+kWeC9m/CFobxJThtkZ5o+n98X4Qe+M1t3KDT41m0/HkDJm5j+7tAKmRCvIk8E/F7X+vDaTCbn9Q==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR04MB8921.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(42112799006)(366016)(376014)(7416014)(23010399003)(56012099006)(10067099003)(11063799006)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?6hvSYugAKcCfKPFM00N4DScwqlfX4sSeJ7wDTfrCL3qkii9MrSH6SRojIc?=
 =?iso-8859-1?Q?bpvfRodS21dJGc85W6luWbOoH1bAVj/CgcMwMNe+PoaTHMbPPI0os75hRH?=
 =?iso-8859-1?Q?Xp1IwB6VWT3vmTiLtYJVgsEkahe8REsX54vEIY3g7njamClejQ28xl/oY5?=
 =?iso-8859-1?Q?0H5j/q2EjJbDXzSKxGI3wvAHCwuuNOlE6FC3vRWG+zq6JZZ2yF3EFLQSBz?=
 =?iso-8859-1?Q?JoL5CyoF5kliTMuvPIOQf7bhDDP+F6HxJi5SqQ6Qhi8QOT4cdosAvFJ+w9?=
 =?iso-8859-1?Q?cSo57Muo9Q+bttaxVsg4BvbQTtQ2AAUn8u+mmS/yxpw6M4r8Q1KaIq6Yl0?=
 =?iso-8859-1?Q?oo6LXGxpry9LBseiBrH0HMq3YKzlgoQuCmuJlmO5YO/xHoYLTTIGbQ7Wiv?=
 =?iso-8859-1?Q?laiLLsNrty4F6AHHdEV3GgP1epqYKTaCUppuyZR5hCdcikZA/I5ajhsJLd?=
 =?iso-8859-1?Q?uqlrYElqPrGHoehS0ovTvNCHIaPt/eh/bXFzBSqWX+N9eBxswcL/VGoglZ?=
 =?iso-8859-1?Q?9Kc24wB/Pc4YVn6N9hLEkhcx4BIGKf7Kxq79SaSZk0qOWr90lR4HuKrFKP?=
 =?iso-8859-1?Q?nd9Le4ATrCYmmUdPF0uAD+NuwL0RFMYMDvpEptEHNI18H/66t7dm0OgrcG?=
 =?iso-8859-1?Q?C/WbayMZnSIfZTxPXiHGVJ5uW3nuQrcVSPLIvTIHMAilap3B4OXwyGQlhQ?=
 =?iso-8859-1?Q?Qzk663s5Omp1SjKM9mk6Y+Y0M3LcP8Y1Oovt/DkgLG54B3WoRZHLW8o0/v?=
 =?iso-8859-1?Q?153Pj6xCFzFNU7fD395LlFwIai0Hnce0AUA3oTBXROloukyzB49nA+8b2q?=
 =?iso-8859-1?Q?0venSQ7VyfFmBjL/EgpmK1YM1T0HT5D9AYY4AWp8aJbQgkyJuHlDZ19Jdm?=
 =?iso-8859-1?Q?eA1rVKvr8QQB6vMO5wusklSaoe85Lp2+UmNQe8+H9DahyGIrH4vGnYh9p3?=
 =?iso-8859-1?Q?sEMYnfgbJTDuMcwmSycu7AVKXMp/Uk+0R2jauMlb9FC2GRHwhJREvZKnaL?=
 =?iso-8859-1?Q?0+p4iyMBbSF6P7fka5j6dth7+fQfn/+D9kBqbMFLB8IkFIqTawzrBaDQOu?=
 =?iso-8859-1?Q?Bw2nK6NyuO6+EKI+PDZt2pcca8xtBPunJnlO2V+bhVanF4m5R/Wmro90Vr?=
 =?iso-8859-1?Q?MEy88Bn/CKKSZvnPTNaDE1g6EVWwFNoUK0OA+CaD8iNoaQX2ChNUU4t4Fo?=
 =?iso-8859-1?Q?A7FMNdlbAG95+YX5xoEFkob8gm39AHxyUPxZJ1MQawH7SbVc5H50mKIxQx?=
 =?iso-8859-1?Q?IJH0dGvG+np/CxxKtzXGnDwU/6t9JrKmefbd3JJLtcw3bK66Myfa2Ycxue?=
 =?iso-8859-1?Q?qAvEwrSVtN2ocn3nd5GCaS4wKZgkXrIJ9MW8rStVLCMJiP5U0ReZwl2BUK?=
 =?iso-8859-1?Q?8pWzblhMr+VhfRgEYrYYYfgt8Qf9JJVdFMDbqWrikcg/zb3RrPSMjWVO9k?=
 =?iso-8859-1?Q?n2kWBY7JK8YNosOvngQT9hitBajRm2kZUjnTgZsyeDmJ0KHgrjUI+o2S5l?=
 =?iso-8859-1?Q?PIHBcO1CYMoq7DUUFYivSHZCw9+noXzBJujvFo7fTaAxzO7dUuJYNzF81i?=
 =?iso-8859-1?Q?+v7jpjjDEXC/o/MmH5KSafVkZjQG2oSN+zHe7kYsB0tZVF24B/rBUmhV2D?=
 =?iso-8859-1?Q?miu7QGFZ2Z1aS78SmW/JM3iw4Kbzps8VCz08YQ5tdvi5DggfYKIG0ksvop?=
 =?iso-8859-1?Q?+8Wig7b1eXTZ8QV+D33IcbpBqEvjZbzhu+OQGAaLqtp8rW3GIX3cuKF8aT?=
 =?iso-8859-1?Q?1s7qgAW7OGQtXpXsZuodU8vsAb3KlAKAB9aBfCZHIfjxdIMDbXZL8xwqAd?=
 =?iso-8859-1?Q?Q1EpZzWwbw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: transsion.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE3PR04MB8921.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af3d381-7242-4248-8e26-08dee86cd783
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2026 03:45:30.2917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vsXVwuzI6YxIzVxJnsvCibmu+vCij7LfcJDrNRKb0kTDwl3twGTcO7VbIRCRF5XKywHEhMMoyWzThjuT0rneMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR04MB9579

From: Ao Sun <ao.sun@transsion.com>=0A=
=0A=
Initialize the hba->rpmbs list in ufshcd_alloc_host() to prevent NULL=0A=
pointer dereference in the device teardown path if ufs_rpmb_probe()=0A=
fails.=0A=
=0A=
Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS=
 devices")=0A=
Signed-off-by: Jiazi Li <jiazi.li@transsion.com>=0A=
Signed-off-by: Ao Sun <ao.sun@transsion.com>=0A=
---=0A=
 drivers/ufs/core/ufs-rpmb.c | 2 --=0A=
 drivers/ufs/core/ufshcd.c   | 1 +=0A=
 2 files changed, 1 insertion(+), 2 deletions(-)=0A=
=0A=
diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c=0A=
index ffad049872b9..62120dc2e9da 100644=0A=
--- a/drivers/ufs/core/ufs-rpmb.c=0A=
+++ b/drivers/ufs/core/ufs-rpmb.c=0A=
@@ -152,8 +152,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 		return -EINVAL;=0A=
 	}=0A=
 =0A=
-	INIT_LIST_HEAD(&hba->rpmbs);=0A=
-=0A=
 	struct rpmb_descr descr =3D {=0A=
 		.type =3D RPMB_TYPE_UFS,=0A=
 		.route_frames =3D ufs_rpmb_route_frames,=0A=
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c=0A=
index d3044a3089b5..60227069db06 100644=0A=
--- a/drivers/ufs/core/ufshcd.c=0A=
+++ b/drivers/ufs/core/ufshcd.c=0A=
@@ -10988,6 +10988,7 @@ int ufshcd_alloc_host(struct device *dev, struct uf=
s_hba **hba_handle)=0A=
 	hba->nop_out_timeout =3D NOP_OUT_TIMEOUT;=0A=
 	ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));=0A=
 	INIT_LIST_HEAD(&hba->clk_list_head);=0A=
+	INIT_LIST_HEAD(&hba->rpmbs);=0A=
 	spin_lock_init(&hba->outstanding_lock);=0A=
 =0A=
 	*hba_handle =3D hba;=0A=
-- =0A=
2.34.1=0A=
=0A=
