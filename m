Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022099.outbound.protection.outlook.com [40.107.75.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8A0346E72
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 12:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782216321; cv=fail; b=ZmZp0giOno+GqeYA9DAjuRAKZpWGK6mu+z8T5rXFzExnMcKkHkPjNTt/6DCitYEJuVV669OgJRze5S6JOifatXsabP6cJbIoBGkqNj6plJumYPYJiarOnKlLGiBqKuQv08P9lEga5Dyv3s13yuSH5phvL7ckpdOWJt6OVD7kN0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782216321; c=relaxed/simple;
	bh=GfPJi+WMotCykaPdbwnncLGeV/UY7aESlKXEiP/VjYw=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FOnt6ZNpn/dVrxDzmC5mAIUM89kBO5vMyctS0ocfNNE9qbMEE6zcxi9wvX/YeUywBvU0PHd7VLZKmSpcPT3U9pW/Id5afwpNxWKFnpGbJqhWqpAEb4y3YGGovlL6sDLd/iZNef06g4Tt/0dWZsEhlA0IqVwUMQQKXJeniiRDA2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com; spf=pass smtp.mailfrom=transsion.com; dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b=ZXA9vwtS; arc=fail smtp.client-ip=40.107.75.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=transsion.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b="ZXA9vwtS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K5MlWfxJU5xzm/kLynhKBM8QU22b6T76twL6elPZ8/t/gnLmMvA/5xCS1Roxsate7n3LCDuOi3rfruBXcySiAelS2kANEUv1GPfQ85NP+YU+oNOP9RNAxRDPDJ2V3L4WLYWL9lzI6P+a6mY0pGt9F7ocij3N4cuX42JbpU1PBD7UucPPmECqq5aJDN9SZgFBRzyhMSC4kHx+B3iOolbapwDRXSWuA3d1bFZbZkwU3hQpdQfpF73SsQsFak0Q73gCG91Qmzl6r43LUxv73Rz3BcyyxXxN965bWkBDk3LC7gfJa+8j+D5MC+qO3fzf9tiDyoq7SVRRQWD2wnYm/ry9gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvkAeBjtwdrmXRQ/tVn0v8vxSPd1ZwjZZH/hS2TKcss=;
 b=wAF1Ajkm2Q+PjVkWtjLE1lMsCa+2V1klN4nslAePJpmRVsTmuWkN50sKbciOiZyH2oVtJRvHLlBxMr7bKhC/uMJ8H0k5BBJyI2Zde8cG8geh1UK1lTFrnkW0qa+GJxluHfhYjYPRAexaERO5gOUNOFJyqa7FA0riPypzISP5fpHlrx/pzdtomwmrrpPqDKcYtl3H/9MdrN8JKEfgdjeQfdYjwmt2uG4a8C0R5idReixIk4DLyHswcz9NcKSsd1GmjEPveoCLZD6YoaxzDbGY7G/SQKYdC03GXFh4e2r55+9s2ZafxuWUDD6ObLO/Osmhz2KXpmrSBiiMd6sxxsLgFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=transsion.com; dmarc=pass action=none
 header.from=transsion.com; dkim=pass header.d=transsion.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transsion.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvkAeBjtwdrmXRQ/tVn0v8vxSPd1ZwjZZH/hS2TKcss=;
 b=ZXA9vwtS2AGX6RYl439YVpsWWDTSMI4XPK/yI7v3ZvDBUPfJMjxqG/iAMvjshcoYRHl7YVHiCawN4fgSLzz1WIovWfsXRzGnOvL0af9ExZKYu5K5VPJgpCM3OCJAIpaYiTR1gz/SGQV0xIW6isEdDqvzIGDA1CCgbHXP82yczkQ=
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com (2603:1096:101:2e8::6)
 by PUZPR04MB6464.apcprd04.prod.outlook.com (2603:1096:301:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Tue, 23 Jun
 2026 12:05:16 +0000
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2]) by SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2%3]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 12:05:16 +0000
From: Ao Sun <ao.sun@transsion.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "beanhuo@micron.com" <beanhuo@micron.com>
CC: "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jiazi Li
	<jiazi.li@transsion.com>, Hongyan Xia <hongyan.xia@transsion.com>, Ao Sun
	<ao.sun@transsion.com>, "sashiko-bot@kernel.org" <sashiko-bot@kernel.org>
Subject: [PATCH] scsi: ufs: core: Fix UFS RPMB device teardown order
Thread-Topic: [PATCH] scsi: ufs: core: Fix UFS RPMB device teardown order
Thread-Index: AQHdAwiNEemv/jdcCESLfIjFqLUR7w==
Date: Tue, 23 Jun 2026 12:05:16 +0000
Message-ID: <20260623120440.13883-1-ao.sun@transsion.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=transsion.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3PR04MB8921:EE_|PUZPR04MB6464:EE_
x-ms-office365-filtering-correlation-id: c06648d1-1cd1-4628-d90f-08ded11fb076
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|42112799006|1800799024|366016|23010399003|376014|38070700021|18002099003|56012099006|11063799006|5023799004|6133799003;
x-microsoft-antispam-message-info:
 ptrrD5jnCI30aPfXVP5IMlQKTYluKZwz/nSq9WPoYhsnn/gJlQd1Bey08ke/q9ViLIIE8y+R3v0NwnU+WU+3FEdTaiMcPtFgsKj8PELXeSmRwVl4OGXVNLHdIk0OfSF0S5at3zMxOZyLHsN+YDLv7nZckPpv+tscIzU7x75UKiaMkBzJ+RqsJslfCfsu8J4u/zSwged7tBflWFyusiT9kYoen7jx6rV6r7lcnVkWhOktTHw0EgCf51vHvPB8sJtpBWie2YMQ9pxZLu2dkAOhs1WRwVCARTJOlLxcffr/nwjjqyckyuWLvf1ADGMk9/i0UsmWbq3lcEHnAGvXR0Ada6BIdFhq3i0hl9NHunavtILuwQB4yPs6VbRNiGp2xxdGbuW2p2LZjAikhBnxhYM4OEWC2pImDUcuMABwo3+INFNNWwvMu7jyRpqIQrBAvU1CQm+AqjyknkDOAv6fbN/o5ayl/fHD/14wuDQnotfDjuL8i1FGBpk59KvTQYkWvZygq3nEH3FLcajFaaST0ALZbV31xHUdnFxIXdpC9nuAfV8tv44HYmCLBFGAqLTi6gQdAgf5WuZZZpg/eXeMf/ucCJmtydKzBJfv6lF35+TP4/5nKPUWkxB8S52ApVdlvwyvHyRazIURXkp/B6xz4btLGlyYKB6Y+whyQbgqOcNNgMP/Tw2faovKo++Q/rC9uhWG/UT+hdbCAX6N5QgicEEerx/WZdk3qbO/berGntTiSOw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR04MB8921.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(1800799024)(366016)(23010399003)(376014)(38070700021)(18002099003)(56012099006)(11063799006)(5023799004)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?1R3gULl80WUTHDp6xkMwh3bNzhr34Ok8+0IwBYqwDcW6zUJm1t/9cQOo+o?=
 =?iso-8859-1?Q?qwQCAOY5uut8H7L0ZMC0cj8DMXIqOlwGz14kUTe2EJ1p7NnUzPV2ehmDOr?=
 =?iso-8859-1?Q?tZUFa+bq9OrNTMKQYohUya26iiEX8H1YAhHJ4AkwHcNCPvRCfZ+tnFB1ZT?=
 =?iso-8859-1?Q?bubH3reMIesxp81lKoqqYDOoGhQjmZ+kJRrKUicqHQrfFdLymjuVKgLzP0?=
 =?iso-8859-1?Q?5ahWRd5BT8vAjgjVE4UBzzoZvRMMLXzJQy6ejUBV+hBAiAY6Lgjn3oEyEE?=
 =?iso-8859-1?Q?Xj6Fnmdi7Tke7/FDv2YrK17PZ2RwNi21B2/jmOXjBSIwUPuYz+TJLOpnEW?=
 =?iso-8859-1?Q?L2velLYHqeU6I4E58ueZT2nSq6UzV2UB08APgty6QGZIiGcT/6Ca1txR4Z?=
 =?iso-8859-1?Q?FKBDHz17nx2uHaR+6oYR4ixxm79jT4vh3/3sTYiMaxm4A3JEgJ8EAo4dZe?=
 =?iso-8859-1?Q?nUG0kOf+sdvPGlDJvlK5idqigyzRU+Sw7sBpIYlLI7Tta8Ptf9pwHSf8SQ?=
 =?iso-8859-1?Q?ICxQ5Lc0M3PHcMZWSxx5ZHpRkdZi4UsZOD0+cY8REQC4Va4RLjNdlBxt7j?=
 =?iso-8859-1?Q?E0FxChGLYUTsFYcGPK//y4kiSKOXtAVl36pJf08uouIVAQW4Nr49tbANpR?=
 =?iso-8859-1?Q?xgMkzxXbopivkDpF2XmszuHKbiWdiO/3Rpc1n5Pma/fO0w8hbWYvZwOEc2?=
 =?iso-8859-1?Q?9sVrWAEVRQBYHofnlP11NLAvhJtEzNI5lvHPq1UZWnNkpTORHg1AKFB6Hv?=
 =?iso-8859-1?Q?j26q/Pu4xIP0kbAtazEWXWfuXshzHDdltaLJ+LCRTp32IKBizvrS0HkY5l?=
 =?iso-8859-1?Q?NVK/cJUxK45YB4vLQH9vqf2k6+YEwPGsoU1Hou5UZS1p6x3cavyi2ZNeJD?=
 =?iso-8859-1?Q?A4+rZOQWrx9T3AI53yf3gibwGAiU1cRK454EXFyGueGX3IQJVP7HhlUn7v?=
 =?iso-8859-1?Q?R/4QQ/g3SJ4d/auc2u8fVvkPPOA2yr+Rkkcz36R4hLgLkx9gF1hKPqhx1I?=
 =?iso-8859-1?Q?2UKWRVyaIjUMNItQKAj2v6k7GyIcCTRPz62L68anKEDK1Evm4SEqIz/zO+?=
 =?iso-8859-1?Q?urDdjGSZ9SX9X40MwUvvcl1wk2y4IFwFr3y/fqTE84AH+NYo5Ch+vuPt00?=
 =?iso-8859-1?Q?hoRy+vgcVKcgaNGDJ4WZLpGJ+56vw4X0mHu3ZANCrahuRZy+U/GRZslZAo?=
 =?iso-8859-1?Q?TtDqLhbcdPvI39XJiUo/hjUs6tTQL9b5gUQirSxD5NPEJ2Iw7bM1sj5Wag?=
 =?iso-8859-1?Q?bchUhJVrIMa5c5vtGHb1boqA4iZtKIyR0bkPu5p5c0WRFbtVGGAE9JWmRA?=
 =?iso-8859-1?Q?RJf+82m55AjHudbqvLXyE1z6xKc9onPynh5vHUzS/zJyaJEHwqIYWLcAoG?=
 =?iso-8859-1?Q?AFuAhFbvBlE/VGumkGe3CD1A0JbidA8NPIhetaRJBNp+VRX9YGJvDany9f?=
 =?iso-8859-1?Q?Iw4u0jM987RU5U/1CKQrW2hxvDvS/A2mvl4ZvaT8w2Pt0fLDZ7QvJe/wTg?=
 =?iso-8859-1?Q?nPNYl1rR+H3m8PYgiI9DCo/w670yFFt4DoPjBU9QfOLGwA4FaMwC0IAT3M?=
 =?iso-8859-1?Q?gcI8Kag3gm8TK9upfsH+JAlNBfuJmDwlktFFnzGe4QtQY3JZlOFIaDNggi?=
 =?iso-8859-1?Q?Kh4o1np3+pg5UDcz+eEeGfhRrYgubpiJQNH5/012kWQsnO+qrzTuAEWAtC?=
 =?iso-8859-1?Q?6x6lWGM+YrBLEfWfFbNAdKa/bUtBE4vM4bEqBlaJh0HqYRS/riJ7mJDYPl?=
 =?iso-8859-1?Q?M6K3INEnRvifg+6P02KrhmoeIx5cspStj87pyeWhfYCOD++J/sc2chk/WI?=
 =?iso-8859-1?Q?E7CWkBhLqA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c06648d1-1cd1-4628-d90f-08ded11fb076
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2026 12:05:16.7578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1fP7yhEMWPU/la1E2FKrzBCC4UQ8SVTziCsYkGRGXdS/S2w3VSwcBlXS48t7KQKQNpCxJHlFmzejrse42P8+Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB6464

From: Ao Sun <ao.sun@transsion.com>=0A=
=0A=
The child RPMB device holds a reference to its parent, so the parent's=0A=
release callback cannot be invoked if the child device is still registered.=
=0A=
Remove the rpmb_dev_unregister() from the parent release handler.=0A=
=0A=
Unregister the child RPMB device ahead of the parent device in the=0A=
remove path to allow the parent release callback to execute.=0A=
=0A=
Free the memory allocated for ufs_rpmb within the parent release=0A=
callback to avoid memory leaks on probe failure.=0A=
=0A=
Reported-by: sashiko-bot@kernel.org=0A=
Closes: https://lore.kernel.org/all/20260618064142.8C30E1F000E9@smtp.kernel=
.org/=0A=
Signed-off-by: Jiazi Li <jiazi.li@transsion.com>=0A=
Signed-off-by: Ao Sun <ao.sun@transsion.com>=0A=
---=0A=
 drivers/ufs/core/ufs-rpmb.c | 4 +++-=0A=
 1 file changed, 3 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c=0A=
index ffad049872b9..dcb7e521284f 100644=0A=
--- a/drivers/ufs/core/ufs-rpmb.c=0A=
+++ b/drivers/ufs/core/ufs-rpmb.c=0A=
@@ -128,7 +128,7 @@ static void ufs_rpmb_device_release(struct device *dev)=
=0A=
 {=0A=
 	struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);=0A=
 =0A=
-	rpmb_dev_unregister(ufs_rpmb->rdev);=0A=
+	devm_kfree(ufs_rpmb->hba->dev, ufs_rpmb);=0A=
 }=0A=
 =0A=
 /* UFS RPMB device registration */=0A=
@@ -224,6 +224,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 	kfree(cid);=0A=
 	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {=0A=
 		list_del(&it->node);=0A=
+		rpmb_dev_unregister(it->rdev);=0A=
 		device_unregister(&it->dev);=0A=
 	}=0A=
 =0A=
@@ -244,6 +245,7 @@ void ufs_rpmb_remove(struct ufs_hba *hba)=0A=
 		/* Remove from list first */=0A=
 		list_del(&ufs_rpmb->node);=0A=
 		/* Unregister device */=0A=
+		rpmb_dev_unregister(ufs_rpmb->rdev);=0A=
 		device_unregister(&ufs_rpmb->dev);=0A=
 	}=0A=
 =0A=
-- =0A=
2.34.1=0A=
=0A=
