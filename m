Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82E91624CC
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 05:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744176909; cv=fail; b=Z2SljdSDjWPyxJSCllL+Z6t4Xp7C02JAB+yrA5Rr5y9vlGl1sf7Zc12jhUIxUwFH9LhbTssuAG0vymDqj16OAB+c0QpOGswcMxdrD6cQkakR0JK79/L/Wcfz2HwBJuHuMl/i/Jnf7t+dmjUPYsR0C3V1vmoDQzCa+iyDTXd7NIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744176909; c=relaxed/simple;
	bh=dsW8szGScQFZ8/kHtrNeMSs3rKZwuUOQeMzKoT24kKk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qK7xT/3XqnK/nV4ROWDvxRvC7XgrAF+/SKwCWX0FO5ZFHE+9+GatXT0wEtiVbEeriw4AfDjIfxm5EMUIeXJBrSRXw5DoIa0tfsQt2VAfEAIZWGbNx4l2Zi+uUkQSOBP9PicWyXlYYJ7O1xsDgYj9x4d+L2p15LDT0oSqkymA5eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=jk0F/HYI; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="jk0F/HYI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1744176907; x=1775712907;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dsW8szGScQFZ8/kHtrNeMSs3rKZwuUOQeMzKoT24kKk=;
  b=jk0F/HYID5IMO63+r5wAY/wgjSwFSq+jWV+oRxNkWqz0Up0pgYI1vgTD
   GLnozbvMWvDOv7vsO2ZjZ0XiZXfpinbnhzhliXL3ZSevQRuvBK+mipe7M
   kbBmUZ/sNNf/yhL6/76IO0YVV6BJozXxEC73hmx7XeouJG7PPZLklmTw2
   mx2hcMJXNu2CwUHvSAOGycQFecotfRfA9VIF8XtEI55aGVeMy/IYfDHVu
   BZV5QKsXvu71OT+kkulP8ewpPuidOt/ivw0a/XKZjjrBAxJ3IYWbf/ijd
   Qnc4/Oj7ZtwVxZUXJY5LF/Bq8PwWXsLMq++E/MHUobuQstFtUxkZyEwHL
   w==;
X-CSE-ConnectionGUID: CsH9SOGwR5W+qPXIngdhtQ==
X-CSE-MsgGUID: KfQJssu9QS24Orl4KgYV0w==
X-IronPort-AV: E=Sophos;i="6.15,199,1739808000"; 
   d="scan'208";a="74550211"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2025 13:35:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EzOG6KOlrQf/iZVT6YmLPebk9KgLVpH5/Hb/QDBbU+Iym4j8QeHoQV47wtSNCm58ImoxqbSINmo06mk0apCBAmgBVY3qG7ZqLh7pOCoIrGYH+d+RaCy1cXyT9uknhSNoGcOIQ0NmzayLdZWEzUPuOS7HWPaORmPMNU6eik0HxpBXeF21MFrFXKk7c0I0/FQm6B5NF6S2ZcxeqyzHQaUV4IMnv1yyH6m0kxcTGRRU575ACveFzQgeuR061Wko6n05J5ItOl9GPjdABe/IXT0wdZrvL1sWa3NDyzoVVVtBNZaGTdufJj0SYDl0w1Rkh16XKc7dxbtdNurLWg7GiHi78g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtuXScSRgoAbdQtV0vbVzyjDB3G9rE5VrXvAS3JuH8k=;
 b=A/LftrC6AxR11chWIrPoAtrT4rCHTQN60ErS3R9D5WKOe+1+xtVFX4+LQxre0yfrhcJJ9Rl4Rcb79HTr5ivI5T/swjoFrwmjsBSOtCyZq8XEVE14BmXpdyCdPSZ2LlSXXW1T6L4Ut0t6PGHCgYyjnig4XX067Iyg8M6UZMZKAftes6weRjUUW5ELVNqdckidKxVXmZ0bXWHtINqz4T+iWZaYpfjp4nIWL97dkhci0I8Kv75eW+yeBW/QMaFtNMYyUFulyW7f2loXnrAD3HATywwWPY9S7W6qUioEEFqDvm0EjkffBdN5g17ztulrPbieXu+Pl1H0lePtDqE6LhxT0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA2PR16MB4076.namprd16.prod.outlook.com (2603:10b6:806:135::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 05:34:59 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 05:34:58 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>
Subject: RE: [PATCH 06/24] scsi: ufs: core: Change the type of one
 ufshcd_add_cmd_upiu_trace() argument
Thread-Topic: [PATCH 06/24] scsi: ufs: core: Change the type of one
 ufshcd_add_cmd_upiu_trace() argument
Thread-Index: AQHbpN5TIKW+MzF0Vkqrcoz8RR3Yv7Oa2FBQ
Date: Wed, 9 Apr 2025 05:34:58 +0000
Message-ID:
 <PH7PR16MB6196C344D671900408E48C1DE5B42@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-7-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA2PR16MB4076:EE_
x-ms-office365-filtering-correlation-id: 71a208e0-5fa9-4f34-773d-08dd77284493
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0kDSGto8uWAIOFQNqhfNIYxG1mX9NPoD0LuSx56U2TkCJ8B/njZgspCeKd6Q?=
 =?us-ascii?Q?khwxWZ3NifQp3WaldvGVtpaaQeZVhP7+I5ONGhDzSrnZEf8PrU/045CT0KxG?=
 =?us-ascii?Q?HpGxicgU5ggeWmdfhBUjUMX6gihrdaxwlM3sD/OMDmg7aoCYuuVTf+Uh9Rer?=
 =?us-ascii?Q?WWEJWn04y6T8RfWiI6essjhm1cwfQ9l2+IVOrw9772bTI9vNwRL8T8+4aVgd?=
 =?us-ascii?Q?JC3TpDJogKMmfIO4gedbd2KuWsvGKe91zSLqESmG5b6tdgsMj6bvrwTTZuv/?=
 =?us-ascii?Q?mGioOLNloFIOsFnnCFx+fnFiHvhVJ3+UnJmvBgPg6RucORStM5GrvWyeCs/k?=
 =?us-ascii?Q?4T/dJTeaWtPslyWQwvgMzDsBaIGK/REr5motRNIFtytFtshnu5ZGmkRMBJ21?=
 =?us-ascii?Q?lyZm9ZQGVUgb44XVe292iuL3DGmCbdsIqVR9WXOfWAE+psTeeObuabO3b4yP?=
 =?us-ascii?Q?6TzjIefBmgGTTymtFUqBirwMaHaxS8QBYw5uJ0actbvpJurv1cgFyXFPTbVL?=
 =?us-ascii?Q?OVSGniy2WVMzXmbFJeEXjE2XFuLuSRx+oXyysil4D/JS+EjU7gI51P1HZC3C?=
 =?us-ascii?Q?bg3cttYwbf+7HWa74hhlQuO4y3inDq/1t9JDqQct3Jen+25c+aaGGnvdUAkd?=
 =?us-ascii?Q?4UW9hzZBXv0HGypafZ9hvQQtrtwYEvOFedJqn8FFQV8LjUl9qqEoSUgqRoPr?=
 =?us-ascii?Q?2BJUGeV4imK/2/loSAAMjNNzkZJv2zORgJqdi01FB7VBKGi5YiZZvpM9/MCs?=
 =?us-ascii?Q?gbX73anOBHxUZmNw+dCk379nw39LJNwVlo4GAQBr2YPT8jWkVD+OvUzv7pcE?=
 =?us-ascii?Q?6OEA8o4MVxxzUI3ba7J2H0RAjEpKPMqKHk3xrfE1vbgstzFCmAP7Xd5QMkiO?=
 =?us-ascii?Q?xI7ktPa/TigbzdE03tNe20EUgN66h4FMx4TzmV5nR372FUYVqJejPfD+bjon?=
 =?us-ascii?Q?1tC3mCI0FYUGF/pkT1Qe4J0kZe1sNvQHJ7C3C11iWUCgUQHb1ekGBJJyI8Uz?=
 =?us-ascii?Q?ZNpf/lNhEWIOgLwVv+L1YydeONyLYd3uYXr5wgEARWrL/WoF729A9tB3CzyP?=
 =?us-ascii?Q?PTDgyezdjQwn9POU4FHb1HcscmIw/JDRxCX5KyNiwg2BSqCaloi6FF4GHm/J?=
 =?us-ascii?Q?1HehFvy2OnZvo9oqZ7/JShNC7KX2CQxGdeD9Cy2Qy7zoSsvfkc86/1btrV03?=
 =?us-ascii?Q?evm//Z/KN7iiUXfaXcPXCCtSER1y2SZsss2i5MxwFViXo/1lXwDWZcXpIVbr?=
 =?us-ascii?Q?dRzKDbTTIu8R19lVZTh/gXPzM1icZxLAVikeK2jJJllWw4YWFUWRZxYDseWm?=
 =?us-ascii?Q?Lul9aJgnNyS94/tFKtvodQkTvJwCB+l/A/JXhKzDcrWEX0KSBwkLPyoYpYTP?=
 =?us-ascii?Q?sbi8f1Roq4nZ6racWldKikFqRr4wN3mAjJ3C36smj+FvGYVnaea1yddo18QP?=
 =?us-ascii?Q?sMPB/rGjXqDqUpUCofABEsxk+sUuSfSG5Ie8tVIpkMk3r2y3Rsjxbw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?nWaw6U9plxSf8isFGhjbhT/TIGJTH2yyaRTKlTobdioIzzlq9whboGHQt1cZ?=
 =?us-ascii?Q?R1HmV70IFeTdHBif3cF8Yj/Ul2T8rD7T4tyRCyS5PL3L2AjgAPAGQ+ivCa0i?=
 =?us-ascii?Q?U55oawy1sUiRguttFMETcJTWQRbZfIlV+ManvEwN2RwSbk0larCIA5NvTra0?=
 =?us-ascii?Q?IxZg4ydmmlifg0j+kz87XYlkm0M5uPvuks7T9k36TCTc2pCHxpIEK1vNQeYp?=
 =?us-ascii?Q?r2Qc6oX6m1+7DF7+KGl+qtHh9ijbSxw8HPMhHWcXcNA3q7tIrVh2wqWsdj3s?=
 =?us-ascii?Q?P/zl0xMkgn4DqvnRjA6hyPvt5oOCambE9nvwcGc2OigOdLegVvnZFu6eh8k7?=
 =?us-ascii?Q?lsmoAgrchau1IOlx+ySx1bxxglnH5AS6MvgMIDC7n/XroeG/tA/5+PMMbgLo?=
 =?us-ascii?Q?i36i7XSOnH/C6XJPyZKKDC3a+b63cozeI0CXmOWMaUTD+wIyCfjOa2QQ9ePZ?=
 =?us-ascii?Q?J5kM5siIjD2rO+0vCrnBsVLgAzpCQk3/Nky7MvUH8Fi0YDQqpkP7EWViiK+n?=
 =?us-ascii?Q?gXi4QAHwhp+4LlElzPf9s/hubINkl6cDkpl+FO2Gf+RRddyl/nF6ZQyFw5DO?=
 =?us-ascii?Q?BFDN2sD9v4yRHzXAwcrC9+MTjekAQwvAvFQkT+r1MvxjxgsVYIkS/m2+/2OW?=
 =?us-ascii?Q?8RGfnJoy3YfpE02Y/ZsGbdWpb3ae16zjWSHtCvKs4gmqj51rG8wgfqip1hC2?=
 =?us-ascii?Q?TP8yGAYEXdVNuCodv/EGa4nDYhkml0lOuC4sTEvDKh9QxegWRSN02y23FxWj?=
 =?us-ascii?Q?TdVlvqRc8Lzdt1uqLxv+d41Wwm+ikIamtmCna4FSA7wRUPjrOoLFD1pkO+fm?=
 =?us-ascii?Q?KS7TRKI/LWORlE4M2A4TXaVrwK43YYqm7hPfuGyq++Okn90BAO8i2SXJCjU5?=
 =?us-ascii?Q?li4GJqBhExCVzcGRUzjGv7bGodV+7/UBMEQU0MYeRVVnhyPrCX3WWbZioYbu?=
 =?us-ascii?Q?ltgDwsyjV9yaLDg0kboW27TxQfUkXT9Ep0x+B5P3EDF2Z0w2rZVWl6aiVVIE?=
 =?us-ascii?Q?EIJvDAaOTurWMchJ6uK9UGdT6WE6X517zJ0vDduHBpmyiUrU6MFMlH4R9c3u?=
 =?us-ascii?Q?SR4cvWFSWree/XgFT6EELp+ctYGFYMUgNYSdLHLg5/3R0we0ZaXt+5VX5ktd?=
 =?us-ascii?Q?oWxCIm6K7ovxLZ4AgwtyLSJnd1tfDGxf2STeRBkuRql1XZttAh79YYM6KXvf?=
 =?us-ascii?Q?A8vYj0yi2tQGd6vIkuFU9OhhbIXbcXk1s5flJtud4rupgeElwunE7fS6P2a4?=
 =?us-ascii?Q?cmCzlqIR0QeFtmFHMk60QbKbLGNsQoXPaI96kTzhqrR2DN3BElLdQjz6B0lR?=
 =?us-ascii?Q?Xv0SmPfI94A9bwW+eVLr8qIGeeVrwh8/iz4HAzPWkBgFYz9zSunU06r46S8m?=
 =?us-ascii?Q?aNS7QS5rBA/jfDE77TaoSY8sMFxvRgArGwWx2rAOvonw4kvvl+6DoEbqMQ3l?=
 =?us-ascii?Q?2E2eF4w9oGQi+4aLnxGmmGGYCq+YINVLZwK0VhVRkc2X/dnr+G/B92fz6JEv?=
 =?us-ascii?Q?axA/fZPBBa5Bf4T3HlxwY75uKfsyU+CU/mdWFKmae3SgVWz5079r38rFsq0g?=
 =?us-ascii?Q?pMhKNFwj2f5FxqpaoeY+hK+Fo41Xm0ce8N/fHnWh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KmynCrqGdSMbKZvhnePWhka5oeQiz0RBTX99E7lUTDFREJVxMDu2IR7LJ+vaKD9UXG4WX3Pgj1rxiR2SmCWFD3CkxxjeqGZVbekFmu6w8ky8LT5gpZ2uuXTJSNFAjto2NJsCN16O0y14QbGNfdhKRM+2rNddBP9MwYWUGJvn6pOmzF9yAL5JCJKL3+dgDDMhrZpw6CW4YpL7QNia9xrd/Y1jnASnalVjC91Ce4ewniY4eqJHnqjLT9nJ/Vl7exXzQVFtb8T1QyBGPbHtIrN4JmqfFIuZI4WW9Ye2z6NW3kDCwUjdBTVA0lQiCrVMrt1s9GfB1AuFLbqFAo1enqgh00fWP95n2pE3DbsccyFhwZVnX2jG2aQMVKpOFfFRhQPzk9kuJpWs8ZEUizl+FHW+Uy6muiqNoObUAUvgj+C7iavv5sWFXPg3CoPm7WMjPP1P8or+lxu+71w70qaHgMtiJTyTHgrXIO4C6yA9Y971FKbudDLTJs2LfEPVc7IFNCnnejvkGZv/BcN3kstcyQy24U1zWwjs9xspKs9STGcYH1TgP60+cBjMu6K5/R2Pf94o9vBERWC7jChgM9jEB28oqRATI1zWTeBVLAzgN3/EU4AoK8VnjQjAcq+TCwRp5Odx
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a208e0-5fa9-4f34-773d-08dd77284493
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2025 05:34:58.9093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hochHtWICqnlEHp4/LyyxzWseD1Nxt2hqzcMBCy805xm99N9kXfDt6Kv4cWF401l/KppHoXrVKGYfiJUw7g5qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR16MB4076

> Subject: [PATCH 06/24] scsi: ufs: core: Change the type of one
> ufshcd_add_cmd_upiu_trace() argument
>=20
> Change the 'tag' argument into an LRB pointer. This patch prepares for th=
e
> removal of the hba->lrb[] array.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> c4448b94092f..3b470f564313 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -355,10 +355,11 @@ static void ufshcd_configure_wb(struct ufs_hba *hba=
)
>  		ufshcd_wb_toggle_buf_flush(hba, true);  }
>=20
> -static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int =
tag,
> +static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba,
> +				      struct ufshcd_lrb *lrb,
>  				      enum ufs_trace_str_t str_t)
>  {
> -	struct utp_upiu_req *rq =3D hba->lrb[tag].ucd_req_ptr;
> +	struct utp_upiu_req *rq =3D lrb->ucd_req_ptr;
>  	struct utp_upiu_header *header;
>=20
>  	if (!trace_ufshcd_upiu_enabled())
> @@ -367,7 +368,7 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba
> *hba, unsigned int tag,
>  	if (str_t =3D=3D UFS_CMD_SEND)
>  		header =3D &rq->header;
>  	else
> -		header =3D &hba->lrb[tag].ucd_rsp_ptr->header;
> +		header =3D &lrb->ucd_rsp_ptr->header;
>=20
>  	trace_ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
>  			  UFS_TSF_CDB);
> @@ -441,7 +442,7 @@ static void ufshcd_add_command_trace(struct ufs_hba
> *hba, unsigned int tag,
>  		return;
>=20
>  	/* trace UPIU also */
> -	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
> +	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
>  	if (!trace_ufshcd_command_enabled())
>  		return;
>=20
