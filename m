Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022133.outbound.protection.outlook.com [52.101.126.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5990C34E766;
	Tue, 21 Jul 2026 08:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784623292; cv=fail; b=aXE+cwrbjRS1F+C8EX4F9hbS1YtulMCSkXaGsU7ZaH7jRPdn4ZJJLoFrDN71xQdducjlmX+itdjb7/1gaWFV32SIuZKZJWi8RY1AChVIpd0lWAFbrfslxh00FPwYo6mN3vNweZHgo4OCdotAGE6H+wxkZpK4HI3WWgpuXtJSsxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784623292; c=relaxed/simple;
	bh=rmUyP3VJxvijmJJJux5JmEE5P19WGCD466kiLoz5370=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LTURKSgc+aFwRToBD3yi6Br72pzfyeeR90HdA4cDXtqPD+qiiBdU32EkCSPrfKa13PYbY9E9xLoh4qLuBfkiqpvF2YXIT1nkgKm6Lg1b6QRtW0DUgDX/EnrfBXfyEqCW+c0slnzNgC2TqjFKqRMrTltnAeJyNWSi088WQRbdIUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com; spf=pass smtp.mailfrom=transsion.com; dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b=GLMkEQZs; arc=fail smtp.client-ip=52.101.126.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=transsion.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b="GLMkEQZs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h0mrskcI+UCaRatef39A6Lw5pOUIvip1OL8nNaVktW2R0arzD+ILRq9l9sIXrhZFq+viP8yXmsCJgyGoXOpjVG4iqQeOVGeLXfON73o/ycZObG1Vl3JGzRZCiW4VPeFhzUtvMGR+ZbbjB9+ukPyyPGOQrulsdWBatXSyFRh8f/mgtKVtPeuXJWJgayDAmEo41A+jdqwlAy03vKNjt03VQhevZ8qGaGH3Vcup5a+6Msiq2Qf7+E3VQ5ztzqmvnQSs2wWLOHNmPQ9GWHSutK5reYovYmHbqc7gNdqchOwEsxkTwuU52M6PcEpLPTHV1G7+FBfWDEmIEc2d2BcFpedqgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+oGFM1uUMhsm7QDlfb12GfHfIqayYtSmZD2Ncpw/2k=;
 b=kaSCqBRtDNp5vG5nwJPC6bJCMXHFLRxKNKyn7j62ZP3yJ2xQOHSo5ySuwR7bBQ+oWlCxAFtRryuf9UVVOe9werentp85akWBHr8uQVwF+2Fj/Hur33cYggjGZ6gqXr5KH8+g02ZR+1gzXKYJ2kyNh8pG3LhPbAOgHKj9M762veRMyp9rmfE/wDapi5rXF28mq61M/Wrd6jx+Un0NF8wSOmz8hM8/JGExxaeuPzrq6QQ4qjGopuUtphD8iiT6Yu7dCewNL2FjYbSD3sNgVzUl21hVYRCLWrMLe/gXG8k8uAmdkOLZSPT5SWIwuJiQ6Q0LhYS4ObRcf2Z7/r931PZ+Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=transsion.com; dmarc=pass action=none
 header.from=transsion.com; dkim=pass header.d=transsion.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transsion.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+oGFM1uUMhsm7QDlfb12GfHfIqayYtSmZD2Ncpw/2k=;
 b=GLMkEQZshhPXgFi8YWfCPwKjQyh3di0BTJOLFS+Aqii8bRWkj2n1XPk1kUBsYvwoCab8k04yW8c+/FNtNncLuJ2xdFG+luoR1/Chnsr7ZxsC6ezmQe4xEOzsg5rMs2+4CxW8ncyf6UO6Xc+6Q4GHtpARMDXlEwwz8qF5QNei7FE=
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com (2603:1096:101:2e8::6)
 by SI4PR04MB9377.apcprd04.prod.outlook.com (2603:1096:4:29c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 08:41:25 +0000
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2]) by SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2%3]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 08:41:24 +0000
From: Ao Sun <ao.sun@transsion.com>
To: "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jiazi Li
	<jiazi.li@transsion.com>, Hongyan Xia <hongyan.xia@transsion.com>, Ao Sun
	<ao.sun@transsion.com>, "sashiko-bot@kernel.org" <sashiko-bot@kernel.org>
Subject: [PATCH v3] scsi: ufs: core: Fix UFS RPMB device teardown order
Thread-Topic: [PATCH v3] scsi: ufs: core: Fix UFS RPMB device teardown order
Thread-Index: AQHdGOy2jO5MRWIl3kSyAJcKl5i7iw==
Date: Tue, 21 Jul 2026 08:41:24 +0000
Message-ID: <20260721084015.319-1-ao.sun@transsion.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=transsion.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3PR04MB8921:EE_|SI4PR04MB9377:EE_
x-ms-office365-filtering-correlation-id: c069ead9-f3c7-413d-ed0a-08dee703d93b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|42112799006|376014|7416014|366016|23010399003|1800799024|38070700021|18002099003|6133799003|11063799006|56012099006|5023799004|10067099003;
x-microsoft-antispam-message-info:
 sBuq/WOnSLuK0a3bPbTnfJCSpk0phFOBq9DNVKEEYGk1dUj84NZEbCISYCObaBVq+FTi2V/a2Ybbk5xy1dagz8coZepNM3sL1aiZKLdFoh97bvYk/+OpUknYKi0+LgLyOfxxDk4/yDWb/36yr2sj0HC/v3eUpFgTSIdwPdTOxwvyR00khL+s5TSPv8z2lB/8fPvtnyhoRGaGVy7k8JUUzapq3f5QkQWRAsbXlHN2PGLzz8u4mN1k9hHN8J9lnlRgrtQtSjPw/qv8lnmcTvuisnWz177wDHFtMbXzrCfwxlE8K0iPgKPDPaoOvxohIh4Xy8V28L8fqULSihj/tFyazHs+Xwkdgu0DCVqA2CJ5JRwZ9yFEcQZu+MVhlpchgVbbTEFk3qv8gHnqldWlnrI80aZdN6TNVpTXqVL/iMEqkeA2PirxLzslcBDzZzruenOagAGB0gZEBqq+tdK9aKfs0mqRQWIqJzyRS2+kysCermnyyJF3ctWMJsTRSc4wgmYJZ0aTCE2sCPoAlWNGJ3Hdcl5ZWmBpJCSuvlMF9Fi1BhhYRZNs6zRFL/XpNdBlXr9EJfNZuJarptXpV8ZYL+YtJbGIzqeONTbYrFP5rr3HCprTgBTeWIm+JQbrvTU+rwt2YyVw9LcrO5D0i+78ZHLwn5OM+Cm6sYBo4R3ev2HdI7hbYkNtgJwz3vjguh9W0FCr11kJ7Zc7kug0hySNbjL+nBD84pzEr21sJizbDbr6oI0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR04MB8921.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(376014)(7416014)(366016)(23010399003)(1800799024)(38070700021)(18002099003)(6133799003)(11063799006)(56012099006)(5023799004)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?rH6cpZqZc11TFhbkcUdtrQq13NWy7FN4TzIYGwImdlceaUbdcKrAtk++of?=
 =?iso-8859-1?Q?qVXjzVJdOj9TXrQCDSAj+dDSvPwzOTj8IVADTiUv0ZJLcZvLqPKBNtksDY?=
 =?iso-8859-1?Q?4S7j9qIyt6sci+KYgjIpvsOupEg5RnG0gRQjYQXh9GtJeNVgVApqIw1Cmy?=
 =?iso-8859-1?Q?pVzn3OPVuMqL8M8bj+9Yll5YjyqyhKV6gfc0Pg7aF2hh3n2+ONBflGUtRD?=
 =?iso-8859-1?Q?hSFmgpyzS2hTBcCXV2862Dg9mCmiaPo0a6P/6u/X++25UWRYIL/iWLY/W8?=
 =?iso-8859-1?Q?uNy5wJEAo1NzDNoqcL/wMebsyu9zcuCOdC8ZVZ2NRFJPwDjyM6eprRRtlk?=
 =?iso-8859-1?Q?p0Vp3J+m/5trsn8MM9mjY1ZFXL8zPLDip97rVNRAZsHpGAlQojeaXRYW2T?=
 =?iso-8859-1?Q?PeFyamituGG/tdkkJ6ZNsAB61ODi732mP1Jrj3BX9eByA8P8zU5iNAoSrY?=
 =?iso-8859-1?Q?/G4L83P/vassamJuLT42/lgodOWNgEAH8z4FG0vrEGKU+dPMSgDgyqEkz0?=
 =?iso-8859-1?Q?VJSoa+wO3QdL6cohIIEoRjjIGyCJ7mHpDENbgQ4SBhyO4FOr59nTzzWgRm?=
 =?iso-8859-1?Q?QLtY6RpjHMfnXAg0E5sXMjpmBdNPpqCCRZMdzPUoa54DZaxN0y0W3EXCX/?=
 =?iso-8859-1?Q?4aVBQheIBIB6D/9SXLfyQ3e+X2WHxOzvYa2q1I9QpKkpsGG97H/VuI5ltC?=
 =?iso-8859-1?Q?boxstW/cb4uqGcUf3Pw750bD+UdprqcuBGB5UVy76a4vjXiuQjIyp57fu/?=
 =?iso-8859-1?Q?oRw+HyNlzo/iH+j1DAvcJYV90BI10Taf3rhGB9ombEvaavcVi3/B2wKNRW?=
 =?iso-8859-1?Q?TdCDjmio6BUl2F5AovwU82D7pDc5WKr8ttSlA0ePzw423IwG7uqkQjwZAy?=
 =?iso-8859-1?Q?jNbqSf9qFkh7hobVrjAlTgZ9TgFyZcTcWXTt7jCQc7ZbYHZGJMMT/wdGi/?=
 =?iso-8859-1?Q?/9QGfqNq/2OWbx75HuGzoljERanv2/HcOLeDxQIHPfv7pqYL/sKfHXzetW?=
 =?iso-8859-1?Q?fWgBZMd2lzfGLAsqzcqRhI12yccer0tVG/SE5EziTzGZYsF9uzN1u3VA38?=
 =?iso-8859-1?Q?DmLh8eT7LH3BMP5IAs9LSoKKqfMrKnwpswIqfXYL2qjDCB2o57n1BUB+go?=
 =?iso-8859-1?Q?tzAY69fd7p2Ja4hX7kS6iUAmGdfUvKo2UuvxDw/mYLyDErogJ/P6PUqF69?=
 =?iso-8859-1?Q?tCzbpkK13JZOCgXMxB395FGGkuHfx9TlgKMGA0ouqe40kkRTUA8VcL1AQJ?=
 =?iso-8859-1?Q?q7VWfFr6YxI9FujzcHC6mHi59d4UyNveZrPJntNGz0C70nASSdlHYMAIXt?=
 =?iso-8859-1?Q?KaFuwVKmcMZh2L3ab2s3heppyIeriG7ADCaHsAP/1JWjruAByk4xTwpeOm?=
 =?iso-8859-1?Q?qZhafzQSuRS5xzaTJA4ORucqoC7zcKN3FNtjkmBR7vMWsXbkLELlMUTifX?=
 =?iso-8859-1?Q?gOugjbmsttkIPmt8me77A7LjQ9Dhn9QhX2VwscQvTpbNppAUphKowpRgsM?=
 =?iso-8859-1?Q?nsSsh9XqTGdF/PMTXwFNb/pv/0lIq5EYa55kFrG0GtlSk2L1B1qKAahCEu?=
 =?iso-8859-1?Q?7CGEG2erjKR8aTFD+0wxVJmsoNsKCMYPkQZc7WiW5TcwyK8xrXemYjmtv/?=
 =?iso-8859-1?Q?P8xNHPbUmgjEkwuefkuCQNaa0XOXbG47BZRHhAOyMmIi4CSCBYf7CB0L5U?=
 =?iso-8859-1?Q?AjPv4aoX9pRKW38/ujir1pjgNrf4sBpxBjZ9CrUaVlykQe6uPZ89L8flRt?=
 =?iso-8859-1?Q?5nmbigiSzPeP/4wN9bUpa0VTYEQBkxJMh/NIZDStEf2zaP2JvX/ZTVklGY?=
 =?iso-8859-1?Q?KQFDqPUoeQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c069ead9-f3c7-413d-ed0a-08dee703d93b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2026 08:41:24.8413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F5Pafdg48kkoqCbXxUWM4cRXkILe23sGTISZaiLxPzK/LW+IMBv9RscvhrfV70pXGkuC30LRl2QXf7mFm5oibg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI4PR04MB9377

From: Ao Sun <ao.sun@transsion.com>=0A=
=0A=
The child RPMB device holds a reference to its parent, so the parent's=0A=
release callback cannot be invoked if the child device is still registered.=
=0A=
Remove the rpmb_dev_unregister() from the parent release handler, and=0A=
unregister the child RPMB device ahead of the parent device in the remove=
=0A=
path.=0A=
=0A=
Memory for struct ufs_rpmb_dev is allocated via kzalloc_obj(), and free it=
=0A=
from the device release callback, following the same pattern as MMC RPMB.=
=0A=
=0A=
Initialize the hba->rpmbs list in ufshcd_alloc_host() to prevent NULL=0A=
pointer dereference in the device teardown path if ufs_rpmb_probe()=0A=
fails.=0A=
=0A=
Reported-by: sashiko-bot@kernel.org=0A=
Closes: https://lore.kernel.org/all/20260714064356.CF7101F000E9@smtp.kernel=
.org/=0A=
Signed-off-by: Jiazi Li <jiazi.li@transsion.com>=0A=
Signed-off-by: Ao Sun <ao.sun@transsion.com>=0A=
---=0A=
Changes in v3:=0A=
  - switch devm_kzalloc() to kzalloc_obj()=0A=
  - init rpmbs list in ufshcd=0A=
---=0A=
Changes in v2:=0A=
  - drop the release callback=0A=
  - init rpmbs list early=0A=
---=0A=
 drivers/ufs/core/ufs-rpmb.c | 8 ++++----=0A=
 drivers/ufs/core/ufshcd.c   | 1 +=0A=
 2 files changed, 5 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c=0A=
index ffad049872b9..cfd1f074d004 100644=0A=
--- a/drivers/ufs/core/ufs-rpmb.c=0A=
+++ b/drivers/ufs/core/ufs-rpmb.c=0A=
@@ -128,7 +128,7 @@ static void ufs_rpmb_device_release(struct device *dev)=
=0A=
 {=0A=
 	struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);=0A=
 =0A=
-	rpmb_dev_unregister(ufs_rpmb->rdev);=0A=
+	kfree(ufs_rpmb);=0A=
 }=0A=
 =0A=
 /* UFS RPMB device registration */=0A=
@@ -152,8 +152,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 		return -EINVAL;=0A=
 	}=0A=
 =0A=
-	INIT_LIST_HEAD(&hba->rpmbs);=0A=
-=0A=
 	struct rpmb_descr descr =3D {=0A=
 		.type =3D RPMB_TYPE_UFS,=0A=
 		.route_frames =3D ufs_rpmb_route_frames,=0A=
@@ -165,7 +163,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 		if (!cap)=0A=
 			continue;=0A=
 =0A=
-		ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);=0A=
+		ufs_rpmb =3D kzalloc_obj(*ufs_rpmb);=0A=
 		if (!ufs_rpmb) {=0A=
 			ret =3D -ENOMEM;=0A=
 			goto err_out;=0A=
@@ -224,6 +222,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 	kfree(cid);=0A=
 	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {=0A=
 		list_del(&it->node);=0A=
+		rpmb_dev_unregister(it->rdev);=0A=
 		device_unregister(&it->dev);=0A=
 	}=0A=
 =0A=
@@ -244,6 +243,7 @@ void ufs_rpmb_remove(struct ufs_hba *hba)=0A=
 		/* Remove from list first */=0A=
 		list_del(&ufs_rpmb->node);=0A=
 		/* Unregister device */=0A=
+		rpmb_dev_unregister(ufs_rpmb->rdev);=0A=
 		device_unregister(&ufs_rpmb->dev);=0A=
 	}=0A=
 =0A=
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
