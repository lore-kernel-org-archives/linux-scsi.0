Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022132.outbound.protection.outlook.com [40.107.75.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFC62D0C8F;
	Tue, 14 Jul 2026 06:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009822; cv=fail; b=SkyXAbQDwmy886tWbXUMGurjClbJ/EttagfKoAVWGqgt1pYUve7JdWPpooCuB7UPAe1aAdeb/uf5I4IpurMOxVXd8MqSWQaF563XS5eoGOSqxeNgNkv1FxrmTTtayMmLqX1pv7H9/F9gGHmpyHyNSEBbri8Au9pTHAASzICNP8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009822; c=relaxed/simple;
	bh=saFaNbL+ahlGCQDnoFct2Goz5m8uMjbMraFauY+HVR8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hSGKQDYPeNdclmETkHDnvffL/5aQjNKjdmgpGAyO/m/LsTHYraDp2F0fSfRoYbEASPtXMvhtdLp208dN1rhuNZv/QZ+z37cOac9uJoewi4BaDpk32XWcqsoEnoik4FWu/BRlbBKaT81QBiaJLECguyo9w49DAmhN038pP03Aijk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com; spf=pass smtp.mailfrom=transsion.com; dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b=LSSfG9xP; arc=fail smtp.client-ip=40.107.75.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=transsion.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b="LSSfG9xP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x7Zdy0Fp2QOYFggH4vpW8bW1HESrhtAG26eSSwCWTpylIcP8AguWw60VwcIRNTwBjb6CRE1GJgxHuviZsOu3Aofs/uycWnNoTTCQbAVuEHVMMfNmWBYzw9qmMzHDCdnRTFFphnfJnosxsA7BscnAEd+4L0VtU1hj9VKDncdM6kNulODEEyv///EDUVmpBWqR1RJdOlyiq/E3Y17XJBAtYBKJ8X6Zk0igg+IZ3vRgD/6TUMvE27pnia0RivvbcmE+gKd9ZW9UMuHgHZ4DhhX9CmnF/aUFT+C+BuqqcP9kimbH/WO2L54pp9DVyaGRH/b+kV9XhyD3COKzJbgEX8m0Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0NvpfWUkVl2AwpNAwr+SOoT6PkpvWdBsazuCSpcWVM=;
 b=nMrUYOKeAtMlnpICh5S4xMVzmK0eKM3ma8n21H/SldyB1X6T2+wHlyQeF5mVknCQVCRGEhocNxdliqz6h9OeiOBZGNN6BLqMYJD1S3rFPGPdSyuFrvFLb1oBqYx+s6FZMO/xjPdUBbnZ2DWuAw/780IYrZCRtlBZcTedyz+NfLjCensrn83Tb+Z0c6VyAgIv3tgoYykMK1d8mvTNBpZDqk/3OBE4ZQEChBdLaLRumm+2icEq8tBOpZyYvbCe47uqPqhrvlF78S/vDWu0qusLOyXhp7F0qPlDPelBe/YoNbbA0e/D+bzHAbYjUOSlmki7rzU6wQ5aTGjdcLAGAdQ+tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=transsion.com; dmarc=pass action=none
 header.from=transsion.com; dkim=pass header.d=transsion.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transsion.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0NvpfWUkVl2AwpNAwr+SOoT6PkpvWdBsazuCSpcWVM=;
 b=LSSfG9xPsPv06pqAx7c2Yo3r7ArdbYVh70G733ZicpwSJzPCHIwb1oBrmhCYPomiRJ4LTraM99cDxHAaigVPbGP6DZypXDy6vR10mhXDaRnuniGZZxvwD1S7YNcYf5JsPT3FD5XE8rhQzBSaRQ2+2VAltvcvOvZyF7pg+EfHfdU=
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com (2603:1096:101:2e8::6)
 by KUYPR04MB9557.apcprd04.prod.outlook.com (2603:1096:d10:9b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Tue, 14 Jul
 2026 06:16:57 +0000
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2]) by SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2%3]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 06:16:57 +0000
From: Ao Sun <ao.sun@transsion.com>
To: "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "beanhuo@micron.com" <beanhuo@micron.com>
CC: Jiazi Li <jiazi.li@transsion.com>, Hongyan Xia
	<hongyan.xia@transsion.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Ao Sun <ao.sun@transsion.com>,
	"sashiko-bot@kernel.org" <sashiko-bot@kernel.org>
Subject: [PATCH v2] scsi: ufs: core: Fix UFS RPMB device teardown order
Thread-Topic: [PATCH v2] scsi: ufs: core: Fix UFS RPMB device teardown order
Thread-Index: AQHdE1hfM7wJFfm5WEysrwqxkRiHCQ==
Date: Tue, 14 Jul 2026 06:16:57 +0000
Message-ID: <20260714061532.167-1-ao.sun@transsion.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=transsion.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3PR04MB8921:EE_|KUYPR04MB9557:EE_
x-ms-office365-filtering-correlation-id: 9e5db008-50db-481b-f282-08dee16f81f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|366016|42112799006|1800799024|38070700021|6133799003|56012099006|18002099003|11063799006|5023799004;
x-microsoft-antispam-message-info:
 r10cb4aqf8rmBf8B7/+IQrrMHhg6etove8CTDrnAl1inSYzWzKXwxHhUHa5cuCLF3+EHc0EoPEU+oZ3IqHRHB+lrxOZIB6yRAPrtBUQEEHaBIjF9w7HjeOHXs69WesaD4i8LnrsCbmBjXC2bLOofzRSEr3CvkuXgls16xGM/ArLJIVMWNfdlQfmu4RURdGOAhDGf0hmsRkhNV8yS5a+qMLskxIkDqU5GenIIHfnJxcuHhej2vzn/eA1PX1938AsTO6JXlipu4CnVhI0dhq5a2MdMQwYKkLZ8PDMN2gF4IKutE3ahAuf4NqU26fczFXG6QeACg1RVFgWxGJ/5EA6JscgzoI1ctL5da+AtrXmAwGAWqBpEbUm8jC5cpWoQPvTVb44LnvqiUBMcHdHC4SCQh1e4Hwewm3tCUmyFwC6JS/SN0keMALfXlRv9rNg4fD5Gf8vmpGRIQqhCYGHCG6lzTXEL3/os53q2dhk1UlbnUUnPZI0pqudWrEBqRa+EGkvHvnMeutdXZY8FHOlMi1mIaX+3cKCy+vxE9WwysGEZWwOz0IhwnhONR8djxn6dw1vymw+Wf/bXr1kM2z6WtI/4KOJK1KYGkdBwrXZTF8855YtPQL5qxeKwKb986fCUz4CfQPWMgG43TWIlp/u4JGMEGCQG4WLAgtqNDvs2eyUbz595RsI2IxroAm44VD1o+SKo4drTsfmTBqjPd5YKUUs5GilXESUAFqoCzGHfap4YCiU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR04MB8921.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(42112799006)(1800799024)(38070700021)(6133799003)(56012099006)(18002099003)(11063799006)(5023799004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?WHhIGrA/y8qQvActE1Jez2YsVmhcfBe3/a/2Mjh0y8O5Zeuy7kO267hp/h?=
 =?iso-8859-1?Q?B6UUDWp76ZMB+xgQOcyP9Eeqn90jaubAB2qYUJTB9ylFliLGp3JWqA/JLZ?=
 =?iso-8859-1?Q?o1jgeGCtBCkP5a0o0+/Xq/Ax004OfNQwwtz+jthFoXZi6pS75c6KOnyKW7?=
 =?iso-8859-1?Q?FoKO0UyPW2y7zQVFo8voRh+zkAcZxV/BUuSMFNZz/l32OCAwcT15qZ9xjB?=
 =?iso-8859-1?Q?przbzFTbfezpqWgJ7A0iGRMwlld8SlJ3Iv/s9eCsYJ4ESXjZdJuNYtlQFk?=
 =?iso-8859-1?Q?pShTf+eNStLeRBGtFFSfB7karUP3GjJSIJUIsBYlHVrE7VIZGUe3+ZOcU7?=
 =?iso-8859-1?Q?hG1a+TpDATSR+EgX2JPrjNmFWMCjisjsRjgYsRghKLJ3Dx2BYuyb0vV5SI?=
 =?iso-8859-1?Q?BZlTLbYy2ZCViurURPo+u57KVN5Xpb1zOEANTmuaQVCxgcGQUsKxiaSWjd?=
 =?iso-8859-1?Q?l16ppNUdiSDEb7qAJwlk5hLTt21PEFqIDjuO9TlroLaRfle6UHuhPok5Hi?=
 =?iso-8859-1?Q?5nrT4s/A3iwCb3SXRckhdF7yp2NuWwzc6OL3v6Xmyg/FISCaRJyvcj52X6?=
 =?iso-8859-1?Q?T3jaJuYORFMFEQVCXR7Tr0GUIQ95gUvuBU8+enWl9IWf8JRKAiHq3BwtYa?=
 =?iso-8859-1?Q?JVjs+vMITtXakR1BFaLnKduul9tRcZjSc4EeXmkN/UwmelNePdE83LueSG?=
 =?iso-8859-1?Q?cnDOew/mgzIJLAnHMxrhe/ytoSDDifoD1gyJf1U6R7pQAJIRhouZKrAvxd?=
 =?iso-8859-1?Q?i+4bAiSJwikiVMMUmPJ6gGwlGhgWEIhTV6netWUUnB6TDg7z8MjUlUOTw4?=
 =?iso-8859-1?Q?kY0HfJj9o6p5nlLVySyyzVzJtUWkQegt40IWNpBDT9438+eb//eEGC2n17?=
 =?iso-8859-1?Q?bQC0WSErzWC6KIVVCWs2a/rjC0aTEsnbhUCqS0l41MIS9Z6wswcBGQ8zkP?=
 =?iso-8859-1?Q?41b32Su3j+I+IpJEN//gruk6prowA7bkxm6mXmcpxYTgK9AN4Tqc3qxLVJ?=
 =?iso-8859-1?Q?Eg1EoVRrbtF6Dip84tdnoFwamDE8BG7RQXTxdOAxH0ikwO/Rwsi+qbG8Oc?=
 =?iso-8859-1?Q?YJ+pcY10VwNAnWYUzG5HJ7IprLCy+RMMX554au/Wlwl8IpGfc5geMIC8Sk?=
 =?iso-8859-1?Q?fBRD/QyKDwd0m/v2UTcCNJzMNkoJfP5gYF2guJz9aWHt0hApCTLuUFIAsU?=
 =?iso-8859-1?Q?dudoQ2Nnjaf7pB+gsWLJ4XFHWbj3JGAbeDYe2IuKJEvx+1154kctTD/65Y?=
 =?iso-8859-1?Q?UbPg2YwkDMnISHvTs8W4Q5jNOcN6CH1Hqbej6I3DdPjv/BgaSzKvlrmaRU?=
 =?iso-8859-1?Q?PHW1FM0As5iwLmBlQODrmry7KtGFhATXMuDddEf31wVZJAYsBk5fu71/Tq?=
 =?iso-8859-1?Q?eoUN4LEYAl0KsZy1lMJ67qVqQ1o0Wilo2BhMq4WWGDrgC9uOoY6gff5h3s?=
 =?iso-8859-1?Q?pnWbh80yMpbHtF9Zpz2t1LcwW6uIHMZA3eeen8tL4ZrLR53P9Umv220dsI?=
 =?iso-8859-1?Q?ccmqStEo2GUWsjS3Fs0PTQtiE/aciXiaK87AAE53xp/x4wzNa8/DTOj4BN?=
 =?iso-8859-1?Q?wsP3e2C75moYn2HTrg0QOa/IsUyz0wei50LhNsPmH0p6GmLuFajl0OU6uI?=
 =?iso-8859-1?Q?5/9Cp9PJD38a2C15YxuhvxrN4R8J9JXhC77P65I1nCRt24qbG5Dg/xUb8m?=
 =?iso-8859-1?Q?f8WjfAdqNtQyQxp26TUXMUf7XOl9NXENAyGa7E/mySdlZHkq8XEqQbD3fZ?=
 =?iso-8859-1?Q?x68aH0BsEF3ryTKxmX47cvxY+JEIZ1V9oqXhyhEiJnrA5jQpTSkQx58jhm?=
 =?iso-8859-1?Q?XKna2AyZ6w=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5db008-50db-481b-f282-08dee16f81f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 06:16:57.0816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xXT6g8yhro6tWcQYi7tz6b610AxwaLRoUrYeEgEuZaHNXdXNJh8vvR8NdnMPB0uoyONFRNhWign+1zfQkED8ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR04MB9557

From: Ao Sun <ao.sun@transsion.com>=0A=
=0A=
The child RPMB device holds a reference to its parent, so the parent's=0A=
release callback cannot be invoked if the child device is still registered.=
=0A=
Remove the rpmb_dev_unregister() from the parent release handler, and=0A=
unregister the child RPMB device ahead of the parent device in the remove =
=0A=
path.=0A=
=0A=
Memory for ufs_rpmb_dev is allocated via devm_kzalloc(), devres frees it on=
=0A=
parent remove, so no extra resource release is needed, and remove redundant=
=0A=
release callback.=0A=
=0A=
Initialize hba->rpmbs at the start of ufs_rpmb_probe() so the list is=0A=
always initialized, preventing NULL-pointer dereferences in=0A=
ufs_rpmb_remove() during driver teardown.=0A=
=0A=
Reported-by: sashiko-bot@kernel.org=0A=
Closes: https://lore.kernel.org/all/20260623121840.300121F000E9@smtp.kernel=
.org/=0A=
Signed-off-by: Jiazi Li <jiazi.li@transsion.com>=0A=
Signed-off-by: Ao Sun <ao.sun@transsion.com>=0A=
---=0A=
Changes in v2:=0A=
  - drop the release callback=0A=
  - init rpmbs list early=0A=
---=0A=
 drivers/ufs/core/ufs-rpmb.c | 14 ++++----------=0A=
 1 file changed, 4 insertions(+), 10 deletions(-)=0A=
=0A=
diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c=0A=
index ffad049872b9..8c63913f7c39 100644=0A=
--- a/drivers/ufs/core/ufs-rpmb.c=0A=
+++ b/drivers/ufs/core/ufs-rpmb.c=0A=
@@ -124,13 +124,6 @@ static int ufs_rpmb_route_frames(struct device *dev, u=
8 *req, unsigned int req_l=0A=
 	return ret;=0A=
 }=0A=
 =0A=
-static void ufs_rpmb_device_release(struct device *dev)=0A=
-{=0A=
-	struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);=0A=
-=0A=
-	rpmb_dev_unregister(ufs_rpmb->rdev);=0A=
-}=0A=
-=0A=
 /* UFS RPMB device registration */=0A=
 int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 {=0A=
@@ -141,6 +134,8 @@ int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 	u32 cap;=0A=
 	int ret;=0A=
 =0A=
+	INIT_LIST_HEAD(&hba->rpmbs);=0A=
+=0A=
 	if (!hba->ufs_rpmb_wlun || hba->dev_info.b_advanced_rpmb_en) {=0A=
 		dev_info(hba->dev, "Skip OP-TEE RPMB registration\n");=0A=
 		return -ENODEV;=0A=
@@ -152,8 +147,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 		return -EINVAL;=0A=
 	}=0A=
 =0A=
-	INIT_LIST_HEAD(&hba->rpmbs);=0A=
-=0A=
 	struct rpmb_descr descr =3D {=0A=
 		.type =3D RPMB_TYPE_UFS,=0A=
 		.route_frames =3D ufs_rpmb_route_frames,=0A=
@@ -174,7 +167,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 		ufs_rpmb->hba =3D hba;=0A=
 		ufs_rpmb->dev.parent =3D &hba->ufs_rpmb_wlun->sdev_gendev;=0A=
 		ufs_rpmb->dev.bus =3D &ufs_rpmb_bus_type;=0A=
-		ufs_rpmb->dev.release =3D ufs_rpmb_device_release;=0A=
 		dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);=0A=
 =0A=
 		/* Set driver data BEFORE device_register */=0A=
@@ -224,6 +216,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)=0A=
 	kfree(cid);=0A=
 	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {=0A=
 		list_del(&it->node);=0A=
+		rpmb_dev_unregister(it->rdev);=0A=
 		device_unregister(&it->dev);=0A=
 	}=0A=
 =0A=
@@ -244,6 +237,7 @@ void ufs_rpmb_remove(struct ufs_hba *hba)=0A=
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
