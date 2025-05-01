Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D79F1A314A;
	Thu,  1 May 2025 13:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106534; cv=fail; b=uwMT5a7Gg9fdShW2B464Mv8N5Rw0cgvomjrBpLnQ5Dz/8bDgkVQ+pC7cPJxHXq6fEpeVmPM2353/J8Ls/BL6BBRAwNe+ixFqZA8ss0ZpgHvWSONPNs+oUxmhiDOoEpc9FKJ/MrZymgFDE6GZ8Ukchyi/JBGj2orMOJdocq6tcE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106534; c=relaxed/simple;
	bh=IBpNFoTaLLvHUJ3PztuJAJnBhccmYeFtZGBXi3aApU8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JMCqV8AohfUGQhbabNuyykyz61z+CAbjEq2kftqtwojHLM4cYlfZWC9cO+ouH51ImhE0IdpcGo8Q3JpgaFF4VYrV/Pv5ggD/eClJ8b3Xh2aZEvI8OlKlsKVGZckLoaRnDlMgRFsOSeXiiSE8HlnQIEzDW1rwSCZStynfvmLUEmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=jh3PkeLf; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="jh3PkeLf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o2PuLlKk2ZIQmYWVdwTXVHqmav4y1uzeY4pQ1a+BLZMMxOXAQ3AefbzkSbAQEM2TjaWMLx9UJkUz1pLHcdVwuW3y/7F+iasZUoqsMwmfIlcPNZz1FRiLor+vdbMt+zaAIflb93ltxojKfsxhWgUOpKrYEzIfTZjsKKeIJciFY03H5DzYt1KpwLQkENq6Sf1wpksu6HCwPaOq+BwsChUupZikNDF/NF8fdUD+ChaSuQi04njdhZZmLAsUbm+YPeKv6t4cg6HFCJ30RoIjJYwc/ZHc0RWSlFRJSWQr6DDJNaGTX+KpDjTeIDV4tv7ulu9/CylMoch8n4jKzh4Xyu2URg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBpNFoTaLLvHUJ3PztuJAJnBhccmYeFtZGBXi3aApU8=;
 b=atKyW7b/MNHrXDWKlwytfKnHHMvqvT6kOYAqPdi9auJ6ojAnmAZE/B2TFtkd70EjhLWET8WLYZi2brvutXpspYAb7n0UTnN3dWure0bRW4hW5DMMenJPXba4lHiNI4xJp8nShvjXgD/g8Cky1QE2jlG+mEcm0Wkhfxct0FbUcdX6RkJ9QQp288mYzk+LKXKzesLas09z5fra9anpyQZ4Mpjd/DiJY3XxtrJhlDAXbB2tEdA08HfsmyIhf/e8OC3RpWITiM0ZtVY8hIndG6FzPBIZK7+VC8LrdmuC47+anR5y3UiTwEscBFITTN5o2ZNUKGKDxXbX5gxsMX94vYPi1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBpNFoTaLLvHUJ3PztuJAJnBhccmYeFtZGBXi3aApU8=;
 b=jh3PkeLfWjstXYQjQiI+M3hk4oiACM8maYUx94kBkjCEHBnodI9yX7qhLdijwy3Ebk87/G896cqn12kRcHY3h/D92YeVGIpDaSn9AXYKDJ2uyGR1+Ay/J6FJ3dN0mBgWzQIiUzgVztxAzXNfo5GeoNOcMwz70YnAlrIvPgTbPz7/HZQUvPcsYH7zaRkNzZmTzhK/JbG+y7jyrriV+q9eRKSgHFcXH6hVIqPa7zxu72/2RrAak7dbDn+LARk5dNa6tvkZWHLIS+AuXfsjDu3Ls430rkDbS/GXHv7KVvWLtYqmNHcC753mmkY+1Cr/w5qJokj3uTlpiFJje8XR43R4ow==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by SA1PR11MB6992.namprd11.prod.outlook.com (2603:10b6:806:2b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Thu, 1 May
 2025 13:35:28 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628%7]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 13:35:28 +0000
From: <Don.Brace@microchip.com>
To: <dan.carpenter@linaro.org>, <yi.zhang@redhat.com>
CC: <James.Bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>,
	<storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] scsi: smartpqi: Delete a stray tab in
 pqi_is_parity_write_stream()
Thread-Topic: [PATCH] scsi: smartpqi: Delete a stray tab in
 pqi_is_parity_write_stream()
Thread-Index: AQHbuacxzx8dFyy6P0CS3+3iv209/7O9x+H4
Date: Thu, 1 May 2025 13:35:28 +0000
Message-ID:
 <SJ2PR11MB8369F6648B1B4407735D64C4E1822@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <aBHarJ601XTGsyOX@stanley.mountain>
In-Reply-To: <aBHarJ601XTGsyOX@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|SA1PR11MB6992:EE_
x-ms-office365-filtering-correlation-id: d44cccf5-1cef-4c10-2486-08dd88b50949
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?YqEtgMIDi/8XO73lwz02GbIaKmZpcJTY8mNaYVujyxFuinTT+hIrsxjIhD?=
 =?iso-8859-1?Q?ZnZN/GbGoUeqVjRp5b1JBxz0AGP1AFD254EFw1LWODZggX3GM0H9guufLU?=
 =?iso-8859-1?Q?qa0mxHSikamTYPjVi/WWXLfo2Xra1odOHWAcPl6Z7bSFqSJ3iXeNLI3U8B?=
 =?iso-8859-1?Q?n7mDL+JH7lXJBJF3GtRmjauuoYHtO5N6SRMn50YPYYtvn9kxCMgtUC8N+E?=
 =?iso-8859-1?Q?z4WEI/3OI4gygzEywpWeSfSjg2C6PjJZ0ovhajWsQw8LyTbHJtLugNdkuM?=
 =?iso-8859-1?Q?q9QgbCcmzxA8D2YHBXaLB7Ee3pyLa1lb8a1YziqvUje9qX8nsySTA+99M/?=
 =?iso-8859-1?Q?Rl/kH2zjdomeNXWyd53L/2R/dWZSpN/mEv+96UcDhq0idIzHqsD2CNuBWp?=
 =?iso-8859-1?Q?9xGIpaBGfwxCIBVmmH/UbLp0X1TTICmWGi4QUTMaURAlpdHOQJLVIV2+9/?=
 =?iso-8859-1?Q?R7HIwpYh2EE7yyTpqyt4rWpqGRoqefaz2H8MoAwxvyZXGkw4B2c3E6vpi4?=
 =?iso-8859-1?Q?7gdLT/807xb3eVZ/22QqRoObs8YIUOiLcZaxCiPjSUkrmAXLR8cW2crzpi?=
 =?iso-8859-1?Q?zWKMdJ+PY8Uq/LqowRU04F3vEGYtL0GG4VmqbI0rJwW6SVopbXnZEKLSlq?=
 =?iso-8859-1?Q?l6UnUgJFXvrcuJblCl6KT8KYElPw9qxmYxmKIMUF8sKuAiIM7AQNnw7VQG?=
 =?iso-8859-1?Q?v0P66kad64GmRPEO2YNfsIOVVIYEH4bSBAYhaZlF0kmgPJXIqD3U0xi4Uu?=
 =?iso-8859-1?Q?lHE1FHOZg5JUI6l7icqlQM7RgqJscSdTNBDtVy74uiyPJQP3bXOItMlKmw?=
 =?iso-8859-1?Q?6H/isk+c8i81R1gtRgUpf38s/qvhwNCSzixnCbrgQ9VO8nTQQDgyGDu1sn?=
 =?iso-8859-1?Q?Klji4xsY3GrAzRWwGp1zPnQnvVX7X2U3+yz1PMQ7Zmg5nQP5ZsjFZcCajq?=
 =?iso-8859-1?Q?OYedWlTHIryMhVzZV86USp2H5hFoa2gLozrEdqtzPtWm2t2N2PSCqjw/kQ?=
 =?iso-8859-1?Q?KzewHOs/5DJ8JOW/U4iA945aGOlAmyC6R05lGwXWlnO8DI4G7NKPnG7CYh?=
 =?iso-8859-1?Q?BIvlvp8m+y9AdNQkEgx8HTDfb7m+inVixQsbrJkDwx3B4fNC7a5aKvwJ+S?=
 =?iso-8859-1?Q?0uL1Hr7JgmDh3otbYWVXEcBA8kln6S1HnmblQQoh1qTqkb5JEVtMF8AJS0?=
 =?iso-8859-1?Q?Tx4tM0EH4ZXgiBouZol01UmQuh6hGdOdtuCBV6WP6e/PksG5tsGhOrk5BR?=
 =?iso-8859-1?Q?XyxXT9S9InWUaVj0E0QqDP0ORd+CVA72a5BMrcXsf1PXou0xTmQHW6mihT?=
 =?iso-8859-1?Q?gHZivEViqBK9pArQ3tEVePWQFz2xwUYj2YPzfbzuv+s7Ua0CZMWgRtM5mg?=
 =?iso-8859-1?Q?mtILL7hbRFzNMgoWFjDjKFeFGHYu7W/kA8xu6o07nXsyzC0FuS94MqpGXU?=
 =?iso-8859-1?Q?ikTjvrSaT43lBSu6u5IoGLvkmWuTJ2pWdE/UWCp6ZUiLtzSqhRo/NPZU0f?=
 =?iso-8859-1?Q?0orp9tfxs0oIcNpM4FQIddsyzqj/9yTavt1N6UdDU7gg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?MtobPTc5G58ivRwPcPdy6lMW8p//gUIViUOU/L3/kOP4hvwUy0FO7fezex?=
 =?iso-8859-1?Q?TpFNyxKc+OfUlyuxCGe5CVw8IlEpgEnl0CoXB9c7Hi448qKX4PBomsK2tW?=
 =?iso-8859-1?Q?TbSLoJ4Odn9/oHStx61nzV+l/2JlOtpo/HPTjHH2Jis3qgrRAQKtezEYI8?=
 =?iso-8859-1?Q?pPPOyGhrGhsq5HC2d2K6Um4R2hkpJs66zaZEBeeMmtXzA+Ej78/mVuXq15?=
 =?iso-8859-1?Q?09XVkWfapD58z4hL24F0acsbEHg5MnyNqQyfNT3bLCc6OR35ix/k8oTVzc?=
 =?iso-8859-1?Q?nkz0lXTr5e1Euw21KiPztLSgZvBSUEth4J40YMIoXQ3vQzSDdJyEhSR+2n?=
 =?iso-8859-1?Q?25K6NzfKkEvQJiFwR/h2X7EdHSoD6ZnFk3mx1jLosJ0xvwhFYLD7gh3sUg?=
 =?iso-8859-1?Q?pSOJxFErfYZ89C0Ratref1zhwrBNX7CLnZiimeylDp1aZ6JkYGfePaGnUs?=
 =?iso-8859-1?Q?6cWcFqQ32H2pbKVuZDNybOBx2UJlFpTcEBIEZ5n7cZfdzd77DdgV0cfLGg?=
 =?iso-8859-1?Q?bii8LlVWJnx0agbJX3gdCOTPeAlVLj/D5KZFrODICg4pUmFkTSg0IaDucm?=
 =?iso-8859-1?Q?pvsw2STWBYeUnqX8DvRg7K87DSPCKtxQrJ1rJzze5iVeHKU/ZxuyH4doL7?=
 =?iso-8859-1?Q?hqnYGaTt0DeMq+Mpq7OMNNXL1HveOFWtnslIDq285aKLy2c2Sg/aYMvsH8?=
 =?iso-8859-1?Q?j57nIpgBGtisPZq9Uhtg3iudUo8Do6PAuMsawSJ15xQMZioNYuVep/v0DV?=
 =?iso-8859-1?Q?7vvnXaW7jzDo6GuNriuY/9+R8MT/a271pdHedJwOrzKcGUlTzTxtlnGflT?=
 =?iso-8859-1?Q?G1oPTw288m+RA0uym/XLwfaviGekdhDsh9ZIdQawqsQ/eRSUNYbfpzWiy5?=
 =?iso-8859-1?Q?VfLeLyvtlgDVF46OGujdiN22sHAPV6INw0902xBNIlA9eV3jZ+QW59W6C4?=
 =?iso-8859-1?Q?lWW3i7PPP0orCRF7803a5W/8/uZ70lCcBdxUsuenDfUXPU6E0Y2e1MyTjQ?=
 =?iso-8859-1?Q?xUC8JXN2U9Jq8jin4cwpTfLCs1ercifIm0y+Yie4W0QVZ4H7BBXMdbZvaR?=
 =?iso-8859-1?Q?L88/osp6ynZHusONCPx3zn6+vtoMGOPqZcmAowZTqsbHsD90iaFvBdE26E?=
 =?iso-8859-1?Q?iNBKAhPPCESU4KP0eCkR4Mdh/Uw3Q5bJWTqetAQFfy8w/gMCsJJwci37Ug?=
 =?iso-8859-1?Q?N7umz/4XigQPJZArjkRSQp7XZZlmJFO26GN9LUTN0R9zy/jLyr8NbKCyVP?=
 =?iso-8859-1?Q?OkkLTDlhL3kPyuI809IzyNe/n6Mci8ErD5Eh75QCQJtHu2l9m4NgzGSNNP?=
 =?iso-8859-1?Q?JEhsVff6BoTN3tUtYtxXhrfCNafddexDsS7UkXZmDput+HdFuGhNr5ns5T?=
 =?iso-8859-1?Q?ENB5RoyOeOceJxogaVK4jg+9ntSk4m/dqjJsP/WyAwSsD82mRoeGblkqLt?=
 =?iso-8859-1?Q?6ikpFRhkSRpQvK0tkxLbWF1MKIbGWsip7h2QujkDfC//nRK2tRvUNi0fA0?=
 =?iso-8859-1?Q?3arb8ICe5kukCXi6sYOpjg3Kpben+wP4vTl+ECLDdgMukDbEe3P9NyGKzr?=
 =?iso-8859-1?Q?rjCJMFnNFCzwD020hqpcpidOwb3jFOwPD43hZufPtolTlmT3URjfokLDBG?=
 =?iso-8859-1?Q?G++lcJmqMGoV3mAcycKkcs3OhEy2zcDRaP?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44cccf5-1cef-4c10-2486-08dd88b50949
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2025 13:35:28.2141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hAlT5zCoLGR7RktqzbR5CF8GpnhD0TIgTw888966q6xA4QUHYzN8sYyaBNt3FDNWLPoqB3YThKEjNsN7GLg8bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6992

=0A=
________________________________________=0A=
From:=A0Dan Carpenter <dan.carpenter@linaro.org>=0A=
Sent:=A0Wednesday, April 30, 2025 3:09 AM=0A=
To:=A0Yi Zhang <yi.zhang@redhat.com>=0A=
Cc:=A0Don Brace - C33706 <Don.Brace@microchip.com>; James E.J. Bottomley <J=
ames.Bottomley@hansenpartnership.com>; Martin K. Petersen <martin.petersen@=
oracle.com>; storagedev <storagedev@microchip.com>; linux-scsi@vger.kernel.=
org <linux-scsi@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-kerne=
l@vger.kernel.org>; kernel-janitors@vger.kernel.org <kernel-janitors@vger.k=
ernel.org>=0A=
Subject:=A0[PATCH] scsi: smartpqi: Delete a stray tab in pqi_is_parity_writ=
e_stream()=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
We accidentally intended this line an extra tab.=A0 Delete the tab.=0A=
=0A=
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>=0A=
=0A=
Thank you for doing this Dan.=0A=
Don=0A=
=0A=
=0A=
---=0A=
=A0drivers/scsi/smartpqi/smartpqi_init.c | 2 +-=0A=
=A01 file changed, 1 insertion(+), 1 deletion(-)=0A=
=0A=
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c=0A=
index 93e6c777a01e..1d784ee7671c 100644=0A=
--- a/drivers/scsi/smartpqi/smartpqi_init.c=0A=
+++ b/drivers/scsi/smartpqi/smartpqi_init.c=0A=
@@ -6004,7 +6004,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctr=
l_info *ctrl_info,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pqi_s=
tream_data->next_lba =3D rmd.first_block +=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 rmd.block_cnt;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pqi_s=
tream_data->last_accessed =3D jiffies;=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 per_cpu_ptr(device->raid_io_stats, raw_smp_processor_id(=
))->write_stream_cnt++;=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 per_cpu=
_ptr(device->raid_io_stats, raw_smp_processor_id())->write_stream_cnt++;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retur=
n true;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
--=0A=
2.47.2=0A=
