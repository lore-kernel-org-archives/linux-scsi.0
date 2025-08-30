Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A711862A
	for <linux-scsi@vger.kernel.org>; Sat, 30 Aug 2025 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756562811; cv=fail; b=M51NEeUK5eeXszoz1AVD0szVQpdrm/rW1An8+MA0AdayFDaZfyZe8EcwCqeoyK6SmIdt/ENowEGy1uvKOlq3Xb+Jv0MOXAjfz7qRTf+76G30wss6y7qK/5IoObZfEq+FPOyA3kfVpd/Gsgz+FwJbkeU84tsAAcv/gP9XKT46KdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756562811; c=relaxed/simple;
	bh=Vqwimc9ZZJP3Ot2nDC04nHoTK0NyrsXKxlSMpCrh8BM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=prriJGqyQj3kVn/ESGTZhzPl6/vS9LYnIN1B/y9wCJczKxOp+n9CpuO/9BW8aMt2C0DqB0yDjtlp8RdOpnWfoW0DLyTPgQB9ll5oKEB0jWkPPmRfjBtn4G67OsSbTuM6QxmLN1Nu6Y9Nz7nGBAJ3h8F+zguYp1uvxkYG4sXlA6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=wVxjaYyD; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="wVxjaYyD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1756562810; x=1788098810;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vqwimc9ZZJP3Ot2nDC04nHoTK0NyrsXKxlSMpCrh8BM=;
  b=wVxjaYyDIO20w2YFEaTazAHCqXxucZr3H7U76Hw4yeDVgdDwdeC+kxxC
   edg0ZvQkYGHpArN/dGmGVipBrfanzMWAAz6GCX9B0sliVbLR7OJQMJzoE
   g4SzQQp2t9bU6wsM74/UpGXTYk5HojmCsYY6ugtLphP6xpzpkKxGnjjLZ
   jN1l5HNlIaDrVseCzboq0j+MfcUJMsWiVLjsL1srpPJif71HaDMQFtAwg
   uD65J4GyG10UxJHXmQS6/lidFkqL0lrqxotkyi1E5XVxpPjmsUCCsC5wX
   I1rszQywTHiHCf1v5kCDT3ExL4aHZPJK4M5I0d5prM3OVuLjTqrZzA21R
   Q==;
X-CSE-ConnectionGUID: PqitDthiSdKg6dA9KVbAwA==
X-CSE-MsgGUID: gkd2mDrYQGCUOBz4wVt+/w==
Received: from mail-bn1nam02on2127.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([40.107.212.127])
  by ob1.hc6817-7.iphmx.com with ESMTP; 30 Aug 2025 07:05:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TzZ2tS/0TwMuKTsrHNfcRUvclF0600mUmfvcaOz7VPJDZGdocR5955aKxXF1jKZw7HVa5TtwhI5+qVtmkYwYe6N1IYlhwIjmhGsfnyJkoQPJC3nkciC8WBUZucc8EnhXwo+kKENh96K6wJgnJBTrrpiKtJ+yotnWKQe7kMIaBMCzvdqwx9M+K6X4KwAuLB3h1Q8NAKtOz5Al6lW1vmuV4NpSJ8WoJ4eMn2N44vAKjaqFDwCARjgpnJ/yKNrdUUZd1M5xWJJohcocP1CUgvhytwv+k6iIpIpAIhyu7AZ3NJduq5uHxhTtWWxHSoeeHGghuS5wCyQWl3hU7YojxTes/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vqwimc9ZZJP3Ot2nDC04nHoTK0NyrsXKxlSMpCrh8BM=;
 b=VlxMBzfZlAnks36JuV4CQ5xIfkKNkKUIDrAxoRNELqRbegSlD3Uvwq0ynMVG/eSKS8mbFcrNmtjp4EnCEKN1nAb0zxT8jyDfG802CcFCrM2E2ZURhzCAEQCrBbon3ywhtr+hG1u+YLmtpR89S62rswz8lvmtLZXQPfVp7CKcMrL3ijjV5Il7Bcdivtd6KKYMLI9cyYRfK5WneOm5m7HESL8KTx4SACSYrNa19iRW1axE1NPxMgih83Ejqwr8ikn/KjMvTm0Z2TU/wxnzRLHDvjn8OqM+p1V1BJY7Rd4Mosq/bGR602+hZ3UoSQedWd8mWZEY/ODDvqOTYoJ+4R3hWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA0PR16MB3776.namprd16.prod.outlook.com (2603:10b6:806:87::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Sat, 30 Aug
 2025 14:05:39 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::d65f:a123:e86a:1d57]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::d65f:a123:e86a:1d57%7]) with mapi id 15.20.9073.021; Sat, 30 Aug 2025
 14:05:39 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, Huan Tang <tanghuan@vivo.com>
Subject: RE: [PATCH] ufs: core: Move the tracing enumeration types into a new
 file
Thread-Topic: [PATCH] ufs: core: Move the tracing enumeration types into a new
 file
Thread-Index: AQHcGPsTvW787BGReUeV+UF8MTKXH7R7PCWA
Date: Sat, 30 Aug 2025 14:05:39 +0000
Message-ID:
 <PH7PR16MB6196D4196B51FA9FDB206AE8E505A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250829153841.2201700-1-bvanassche@acm.org>
In-Reply-To: <20250829153841.2201700-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA0PR16MB3776:EE_
x-ms-office365-filtering-correlation-id: 42b2028f-dc89-4856-9726-08dde7ce4cb1
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?xC+DrIbwtw80ChJrBgExmkopLazX2/ibfTryzgJExtmvCUneMa32ATFD1YkT?=
 =?us-ascii?Q?WOyL76winzuBqaSzhtDys5PlaWMU/l46uymeNoX++iI9SKBSl6ke7i1sqvxl?=
 =?us-ascii?Q?XudDBRh/M2G2/QLNYgK8/Gmb3kNRaz88aHigdH30HRaMW2MOVKjMaOlI8QIn?=
 =?us-ascii?Q?abBSyj+ivpr1u8yazxQazBd9cPVPiiQ7v0aPQTD6nwCf5Vf/mm5EHTgTkP6v?=
 =?us-ascii?Q?K33YZuhnG6XI6H0vDZg55Tg4Bazx1aakRvTWVr58infa1P12KrWw3xs9ZO5k?=
 =?us-ascii?Q?Vuz2lgbaFglxW1jCkipiRZrUJhOiYoC0a4nV9My5rMai5EJD6ANLiccZCxxK?=
 =?us-ascii?Q?n9oT3916Q7k7hXGpRa8D8Udm6tpK+f2n1CcxcAONEkpNW92NHH63ZgmTkeFF?=
 =?us-ascii?Q?8m7+cqN3QK/akAM5mug8dZ66rf/z5hHiIO2ankBpOMZgp+bWkC69Oc8jvyey?=
 =?us-ascii?Q?RC3dU+pjMC9eg+4u4sBp50dMHwleDDm5KdVr1OcQ86CKHEx/AOZ5inGeC7aO?=
 =?us-ascii?Q?XfdowetHs4XedoTik7zta/lNXd21rCdcyZKV8yuZeU4W8zxoBEbinnAVXRpA?=
 =?us-ascii?Q?vrvHEZf2adTe3w3CPuOk4zcX7cWJ/F7isyZBEdhGhMIBoMnBHJj286PaEC/S?=
 =?us-ascii?Q?jYcFkesQJi3TMRD6+8dYuHKEVAQsLbnVz0J1XFxPBZBiEoegAke8ky2JSE32?=
 =?us-ascii?Q?pJadJd9DAtEURL17/cuGXbPlM7s/79VkfnqaJWgRIvub1NZn8PzV1b3KstEK?=
 =?us-ascii?Q?FI8sQ++cRxv8z7EVbxykYspDmt/LTTuCmvGSU/LJ/MHhVB3hYoMxUw6hisyF?=
 =?us-ascii?Q?FwXxAJWzYzDePF5hDUO9GiL8UhcounafJ52gbB1OZfz8f+U1lAuHCV4CMF+b?=
 =?us-ascii?Q?G5rAQt/DqpwCobtpctey8EpQJnr3SGkITijFRk56598BD94I13tatB375+ig?=
 =?us-ascii?Q?B8N5z9SFe+we1n/ISC9in5oBf3vQJAV6lZekoONHiUH6EpYrzjeLX7tbzMSH?=
 =?us-ascii?Q?sOtyQxeq2licmktUAz5n/oUtlZ3S1wNemDE8PVHFhsQ6EBAhnSFthQQXiDxk?=
 =?us-ascii?Q?eOrll2BcPmzF9dqdHZ1z7hlgEzRKFHFy0DagS/FcUFxjF2SS2unwQA/LZMSr?=
 =?us-ascii?Q?x+uE6UMzE9tFCWKSV3wrz0sGc+NeviUwaVdmDC6bz0jgxbanuPgFUYnsPDys?=
 =?us-ascii?Q?dZNhcnpiJRtIAUQcuc4OUogCgwG5kVdtKE2V2jVgY7lOBfjUlRgegPZh1DcQ?=
 =?us-ascii?Q?juS6uh4jDfjC292cDupNlgnQLwhlvWNlVDY/k/Z1LM+0oolus85CYVFv6W2R?=
 =?us-ascii?Q?rwbwLUl7tQ/irSaNeomy2V4Jw6dAOmFeVhLWJYJ8Qudzzv7Fpk1ZOxmUBCVk?=
 =?us-ascii?Q?iYE6u+oaR1pz7e8tfj8fuN87HCBk0gGr0O6uCsA7fOohnUD0bAecHVNYD5Vi?=
 =?us-ascii?Q?/0qmPUuKFZJuFP9ZwFRWMrBgl3hIzeXnElp02w9K9LC9wz39M4H7NQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?rFAR/7ku4OC0dX4Jx++sugyBvkiQ5b4cqXvpwSzQASn3Dg+WOBB2/YXQFXp1?=
 =?us-ascii?Q?wLDJe9gvGso4O0kNvg+/RtoFlKF9+nBANVPLg2lmdd9SxQngP+rR+rlcPCjp?=
 =?us-ascii?Q?p8eRlx1tezw08cGTTtt2gc0Szf1hx109bug6HVTnF55DxTxqr4SXTkslS9jz?=
 =?us-ascii?Q?JbrpKDFcyB4uWGe47gJgiRVVWT3pCVAUXSOk5opUAjkkLKWu7gzydsy34ox7?=
 =?us-ascii?Q?zPALgZ4C85l+N/+RSIgpDVnnTgK8j+HoOUKiaqvDMaOpcES5MP56PH8X/6iA?=
 =?us-ascii?Q?YfQmNYdcyNMXuGqrFW0f1/7IiQks867/eB4n8lhgqxFmw+9r+zjdI3uqDHIr?=
 =?us-ascii?Q?7z3Glkxe2cvXhiB2V2U+49aZUZ0rzUZ5OTF66Ey5lZ89Wt8vmT1llMz0aBhU?=
 =?us-ascii?Q?LFfwLDtNyC4r5fjhTs1GAkzIwZ82aNaWZ2+w15N1LxldzKko74XgoW1/BOsK?=
 =?us-ascii?Q?xTCeZVDWPMmx2vT8IwPEoN8PAy3pObyfaUg5AsG4O57DybCLmYS2RH3AFk28?=
 =?us-ascii?Q?WmqddY/5C9GHScKuNCRh0CFGB9+2UUwjii1CYXWMMbdFiE6M6OmedSr4k1Nt?=
 =?us-ascii?Q?osVSG3IinbiTiVVyQryHxz3VQ6jJx3jrdwZefhWo826C9znDURIq0rajCTp7?=
 =?us-ascii?Q?vGInSozCJ2v0z6OJZDPR3tVxzL3kI4/BntUdiAEVvxVM8pmYiYTmQ+kEz6nB?=
 =?us-ascii?Q?uv5eLO2UWIpvrNxDMSfCS0+6Gs6eMOJBvEk2YaTt8+q/TVB4bxARUNP6aUla?=
 =?us-ascii?Q?cbTDi0BDhVMTjPhTy+KsZtr5+45XVMFy68hano4I0FZvVlahTmfppBmQOXep?=
 =?us-ascii?Q?a5kRDZ/nGnN1fXJ5y2Rbspl9tPn/sGIrNdVa4BiDGlygP9XMC6RcppWmZpQz?=
 =?us-ascii?Q?8x7R+p13DcdQd8IhEqMFJQNjBzRZrymNWHQITvYZaOQOLFFM46XzzIGcCGhc?=
 =?us-ascii?Q?ucf+/hW4b43flPIeulx+jFUyojq6xb4Dt6YUZbJjpmni6OjyxT9nnSdhCP7u?=
 =?us-ascii?Q?3XIQg+Yh51uc9hFYEvSvVLDeoktZcK5xVunEaojXtBF/KXSM/w0RHttO9+VG?=
 =?us-ascii?Q?rm3YF/9yFRN4o4cZYiYySSqLbUIaSEt9nQe9tgymDak2Afgi62wA/OGFRk98?=
 =?us-ascii?Q?SknRSwOilGTllmuLpOcAtV48fM/0xV2zTQqTzBIpY2Ow79qQnAqZWmoE6YhX?=
 =?us-ascii?Q?hXo46STJWW4aOeL+NOaAtZ1LkUsaT6f5kRXOozEEo5xhPlmuwLHEojbxEIq4?=
 =?us-ascii?Q?yJgUKSrav6dCI1aLAe6/2Fs6aNav3+4lEfn1uMZaUmV9wijzKpUPTS+cpyfV?=
 =?us-ascii?Q?ug9auICJku2nCWrw+No9HiiRhcre3OfRrH6bGFnJ1e9r6u4pVjjWfpq/UusB?=
 =?us-ascii?Q?CyDrohzWZW4E5JbguyFvpvQ/kXvPvLUGZGc45lwaWqMMHNeW6PijD/2IlPth?=
 =?us-ascii?Q?6yEn615dqitYw4+ttp89yxBCMD/nBf7GV5O3+JZJrqqaqiYkj1M1Y+t1ub+1?=
 =?us-ascii?Q?jU9TRshks5nJr5Hyn7Xsq4Ajm9CTtC5EkWB04jGOhg/Hi/hTFjcJnfc3+Mu3?=
 =?us-ascii?Q?lVrXSDn8BS9XhZURDUHLK8HCKjzlYQX72fjzQY1J?=
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
	qSGICW5DEZUqcIIPK4oHFl8QN2hON0xXBXpm+SmE6JI5r7BeW4LIqM7KfvZDFUhvFpUulA8XtZWpdpmWY8pc5AN88YKBi2hK2YaiQKfoSSwi8kV6c0HWxnyen5liOeXcJtSbxwliHLFSRjxhMmsXTyabtAG5QxvrAgseU/bXVvzOXrhhRKZ1t8JJ4AzxwL1deEctwS3jA1La1zUAsFHcGgcMN5XrkV6pV7JhXcH0bsoS+1Xu4w1T3vlZi3Du7l7o2aRF3wEdWQYXFymUwWQHnj2uCo8EpMmJRCKHBX4Hnm2Uc5ABYcQsgSlNbkibjfnNf6DALReV7chswvXWqyn5brDdVqA0TC8I77f3CSvc+1ISLbPMCOgrXVcKBSh+xIqT+tiIwRGBbgH0HKYojsDoqnbHU1dbQzRTi6e5SwKdhx3MQbUrl7DslXlWXigkcXG98WePIZBtocaoYkkysie+vwQwI2lhFIJH5CPLqCtit36OOj5mejWGgX9tHZnwQOyUGasYnMaPgsHj+ykRTa6LGGHVnVRqPmbXIYM5cy4H//9CVybl1y+uVGdm+eh6MPsM2evvVqo3Pyz+oRQEWqiaMNJdlU7FrmTfIqm+ICFpJH8JVbIjUk5tzo12avRNXKzax6528aiUXyvg/fbn2eayMA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42b2028f-dc89-4856-9726-08dde7ce4cb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2025 14:05:39.2024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rl7Vou6pOle70qgptIsP9l8WbAAof4gnztUBRiVzJolKWxEIk2F5r5BE1m2b1zPrkpCCiyzWnJ4Nl0YKO1Doxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR16MB3776

=20
> The <ufs/ufs.h> header file defines constants and data structures
> related to the UFS standard. Move the enumeration types related to
> tracing into a new header file because these are not defined in the UFS
> standard. An intended side effect of this patch is that the tracing
> enumeration types are no longer visible to UFS host drivers.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
