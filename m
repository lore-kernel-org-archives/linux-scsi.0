Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51C3152E02
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 06:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744180341; cv=fail; b=oDHMheWFnplJCpq5sk+a6t8nZZwUXsug8s2g2f+ESLYgsCc+FRudba5zG2pV94RM2BjWwAqT4mKzv64Q4hEje0f7lVfCP//k7FALOqAz2dnVD141MPTCVVjbYzNCiP0XqtIyftDm8NAMAZUvxnRKdM9//ah3/u4pJCtFVBBC2SQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744180341; c=relaxed/simple;
	bh=ZfnRzURCr/LvcWn1lYhkHBoh7KjZzWFvLXwGsTO/zcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qK7yaD/gBdlMBx7wbaStnwMgpLjZLdeh8Whuowpe7O3MxCkrDSVlCcUPlUWyIBvHpi2bPPLgbEJsLhGcj/ZPVy8ZYMKQ4j6vlAvOvKOkS7c3xjVPooL6WUASPExq3IHRwIsLmvWNoAMELngN8P5yXSRBeb0Ppvh67aQpSbyfY3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=WUAbbYeV; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="WUAbbYeV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1744180339; x=1775716339;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZfnRzURCr/LvcWn1lYhkHBoh7KjZzWFvLXwGsTO/zcY=;
  b=WUAbbYeVvxyVl8dqpePFK6zVjMcGUl+UCYHg/Kt7CZestcT+Nmzt3+u1
   csbTNG2UUxwAqVoLtiu8odD3tEdP7GIRBn2ElBwoxQqCQoVMGzHZlSZCH
   HTEVzt4nUeAeHPcZbH82TojL//CweCdnZc74yFLfNljYFBw6tYckWh+LS
   DNA4hv0kkvZItJjuiYO9XioUYxt+NkT1i3JVlNHW1VtKWntBRRlZ4h8Qi
   8KT1+xV/tnMwSPcvioICKqgxANXATmeKHRN3AmOpgUSD/VbudVSZe8Ekv
   58b2nML3Ax78jSX0B8M4gxdCywssKp78nxSD5P2HMgev4a/xc1yGSh0BP
   A==;
X-CSE-ConnectionGUID: +XX4ZDzvQGellNAAWPYu7Q==
X-CSE-MsgGUID: fMmfBI0gQym4cGBsxTH4Aw==
X-IronPort-AV: E=Sophos;i="6.15,199,1739808000"; 
   d="scan'208";a="80369015"
Received: from mail-dm6nam10lp2044.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.44])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2025 14:32:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hbO44miTx+/eIXFEq5D0bQTG++xTVdSPw/Tp+F6BNqxgBX9KDvxr0cJ/+pT7CUfD3L5j0zj44urlGhtGRlcTR6db9QGO0izO62fMhgdChdMzErB1fBpYQlOSffT0XqpKlFDAir5iwYd8XOLVXKQBcN+o912nEh9EYPK6ZkFoWu+W6M3EWfQXrznE5xi7c1nab1/m9IkqfT0npUoNlVlirgEK02eMSVWi7HvTM5eol6aD7WkljklB3UwDgFVge5tTuzQpk0xkesc8489ekzQ2X4BVlxxsCrLf/FFGvyCrR8EjW7mxVzZDxbA7e1HcwVXGVEu/FRUOw7dbmbLn7YKT0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNXNPRNaFnbaOs0v2ve/JE4xWBCchdP4cezvyHxD8s8=;
 b=D4PDgmOqDhxkk11PtK/VWIShaXse86uqN+52XNvxZNkMCOFpQKl74v5mVgg7YCXmuXsvSVrht/dSlgpLYBWXduk3AinzYMRFDjjNTKMtSvFR2s1VoFnpLhDgpsQwxoH2GkCbEH3wD9hqg+ujRm0NIqSxghvyAbcMza31bveryFcI2hnEUGXTISLXMDJ4h3IMExN1+OBwtYWXLJU4ssD+/wyctv0+UyqIvvjjxmUpiZKyP8m111G9f2HT50LRLTABoe7byfpEwWmorCr90GaAyFsc1XsQA4ExnN98eONV/pkLxgCHPsrVtDy14f7VEkYJh7WmO1kON8xz4UhqrBRFaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA1PR16MB5152.namprd16.prod.outlook.com (2603:10b6:806:330::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 06:32:16 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 06:32:16 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>
Subject: RE: [PATCH 08/24] scsi: ufs: core: Change the type of one
 ufshcd_add_command_trace() argument
Thread-Topic: [PATCH 08/24] scsi: ufs: core: Change the type of one
 ufshcd_add_command_trace() argument
Thread-Index: AQHbpN5Q/GFpoWX+aEaY3C/uLNCVnrOa6BUw
Date: Wed, 9 Apr 2025 06:32:16 +0000
Message-ID:
 <PH7PR16MB6196BC1DF13A4270EAF98251E5B42@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-9-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-9-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA1PR16MB5152:EE_
x-ms-office365-filtering-correlation-id: 9ea5c638-3257-436e-12c6-08dd77304557
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?dYvgvEHkcd/wsA+aVYwMWH+a75qEsMlZifXx5x2NyBJ4tXW/ZZVimwAG2fEt?=
 =?us-ascii?Q?vu6qWyHQ1s59uOA0UzwlYLLzI2ScZMcrtdGgiz032qep04Pub9JRYALqRzdc?=
 =?us-ascii?Q?i6z2Qc2NOCIDTgM9vKhQkAfAKRly7kd6Rz6Fh7h53F2JEIKIR/ukhPpokwdC?=
 =?us-ascii?Q?cIiRad8QpImbyCTxzMEQM+IZnj4HBoYewwe55Ea0j/hgnrguG/pMnfu3luOm?=
 =?us-ascii?Q?fTeDAHI4fhrr2fPh5f3VhdkiN2OAzXq376CkeCxKuFJU+QKw/sI8SPDVfL0q?=
 =?us-ascii?Q?fGMDzxYRhXA7wn/gjHkVuHBzdINwfqQNjUnpuDe0nk6uLcV+N92OdKWbIKJT?=
 =?us-ascii?Q?GwuaArszd1pa7i1H4y2H2qZyEx65ehtxdON98j8SSq9Mx7DylQcjIMNP4wN9?=
 =?us-ascii?Q?w/gMxThiFj86a6FaY0AZLZQ1u5HOy135hTvmf5H8PUPNgnTG4XX1bqczI+Cj?=
 =?us-ascii?Q?0QJ84lSVjEBUlPzOL8fg7T2hn1g3coUim3wIjQBNcGnHXCkfu+OuEWYM/jDQ?=
 =?us-ascii?Q?rNddkWgHgt4K+qNFkP1KoWVjrWE0iVOKRkeOxchtZ21ZakgJSoyVJzm6iO0k?=
 =?us-ascii?Q?6xFJ8YURvSpXAMZ7WKBJl2phn/e6n5+tUdPpaEh3uXSZ4S93Sr1v6xhKSPfD?=
 =?us-ascii?Q?mHSpf8Hi5rDEM+GJp7JjO2nqQTWEIrOwjIexymYnrsnqL/glJ74jmitIpRIR?=
 =?us-ascii?Q?zRlg0eMtY7wagrmbdHTrB6ncKU4YMkcYckhcSjpfLhUARO+Cv3mcwy0d9b4Z?=
 =?us-ascii?Q?4ctpG247GK3INp0Rz/6vr6ky6NqoEuZ7A5YCKynwHHgvNFdtkR3J8ejdyC7e?=
 =?us-ascii?Q?oc9dB7iPzmsfTAq9U0YmbKcfPd2g9x2XYcXLL+F/nDaoHPxjOVIWGpzYeDQt?=
 =?us-ascii?Q?0qLtzGTOVItLRT/+N3fVFU+B4N2YH/G2l3huQk2TW1wNJFhV0k/dPlEcPcI8?=
 =?us-ascii?Q?73/qjaECDTdBG3KcCmy+Z9/6YO0p+1IX+HXV4x8btvzkTY6bth2X18QufMF9?=
 =?us-ascii?Q?2Dcg5vdSEzVuSmKdXw/JKdC0ivTxU+OT7MTab86DpSbqlA/0sxTupNHuVgYe?=
 =?us-ascii?Q?yf2SUIdMo3kj2ttAs+J3gO1IXXnFFP32KmmJXvvxhSolzFMhDuyUHMSBAAb2?=
 =?us-ascii?Q?KIXbeyLo9fc4DCqwETyjdXG0TnSB7M0mOAXuWb9U3XgeL5hWLe9pUoqpyCmJ?=
 =?us-ascii?Q?L7euknRtll8Mkyj4RDVyS7PjvEvj4wT9vR1QrKdvEh6LtQjUofIZGHO3sOmK?=
 =?us-ascii?Q?BT3YRFZ2joyfzEaN4YznqDeEsCHb00liaA6otTXmc6XlqqDmI98St/8iW1pK?=
 =?us-ascii?Q?d3oxvcfbdpMyu3P9DX1MjQnlAU8zp7ocfE+ffewQTSXU4O2HH0hq4BXdPFZn?=
 =?us-ascii?Q?qXvw6OduxDsO7a5CW3n7dXQqjTi63HUhpCoUTUDGbVYeAY+blTp4z0+aeImj?=
 =?us-ascii?Q?W/6/d+CpylEuGo1u0i9hadWxrpuVZvY2?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?U0c6TAkyd1ReCfu1mFqPqU9UcteVHau+/3I46wJcVTlXkqlOn0p1V42zXkz0?=
 =?us-ascii?Q?ABTHETixC7o+n3Qw+uGD6HLBVutvADdkuM14F4WU0FCUdWb1x/o8ghjKviEJ?=
 =?us-ascii?Q?fYRQmccge+mmyjEECd9ZII0cwb1T4XAkbWzgSLkq3evysEsKGlp9Ayu13Y8U?=
 =?us-ascii?Q?cdwAL0WW6xBCa0ep+ero2z4wrlkmMCLxHS/9yDttsitPm5ZBnvT5C1ooVlYn?=
 =?us-ascii?Q?qOkP8SMphlLG8Eqt/mQVYgm7tuzFmJqP9moqLDp7m0SpuCOsHp13dKqU2XPB?=
 =?us-ascii?Q?hN36BCA9YlqFA/OuCwyX2G3LzdqTklhpDALkUi7fI4emTBrjh2Gzv6eQPzLm?=
 =?us-ascii?Q?UzJQN1IyMfhlTLegY2nR+5twngkmTemnS0W/VF42U1nFu/A9QCN4KbgubH5U?=
 =?us-ascii?Q?KULuT9RzHqtr9Ki9NtxujsqBs1b+iUdlehV7AsZa5k4dY0Fh3owVvI33m6ut?=
 =?us-ascii?Q?LI9G5qkJxB2glU62PV61dJSBkHg5DeSNJFQK92EiLl1XTLSyyy6nfPgQCx66?=
 =?us-ascii?Q?9H5bZuV9QhMvsO0wU2ssXkw5CQOUxmIvDa8mK/rpwXHrjRRJBo89+Xg/ehoC?=
 =?us-ascii?Q?Ea88XXT4kqtqn312b0EAmhqWK9C+ps6YtYUX09fCDQwH7w1VRooG9gMdwuDh?=
 =?us-ascii?Q?GjFzn5kU9P9HruI49z1o4VEuuVDNfmQ8rrA0PcB/lxcqP7VXFHbevqo9kGK5?=
 =?us-ascii?Q?UhQPuPOR7Xpu0Bt5ZFtNPzZeUK5+1O7QxQJIxgSjNV7RuE5buAMs40O+e3cb?=
 =?us-ascii?Q?HEPzcWpHomerE7WLGCgptrMg8IXqvVTkP8Hwzb0N2dROsdcL6uxU1vVb8FRC?=
 =?us-ascii?Q?rYTspptkBOR5rZ6z+EgUnTDwQuwcnhQZZGuizoHb+BJNCGXOSeg0PRZE28dH?=
 =?us-ascii?Q?6vcNm3nQJaWqpIatwiIe8OgdfHrFY9dVpUcVleO9TEdp1NV/jD878TCiWAHe?=
 =?us-ascii?Q?hzH8BMek7vXY8rLeyWD7iyRvfzein87RjgRdphVzZfi2DKPWXP+ohRft/ypc?=
 =?us-ascii?Q?FpW0/SEbHabHuuZDF0wNZlUgMPOFuInAm7/He8koHKEpZG3y/HmQejkDAjpv?=
 =?us-ascii?Q?Kk4+e9CrgsSQjqUL1jaT2ecj98CEequbJNThI0SVzi170eaJMhPBstvqIBxF?=
 =?us-ascii?Q?u85aNNZuu+0sHqbkX6WI9ft4Lbl0T5k7KpYCeRxi8Yx9l5iqmQxI28SjU2i8?=
 =?us-ascii?Q?ePFvr2gtxP4jjX8I3qTbeV6q59k1JXeci8M5VDL8YFMQsoFVHOmhx+KyQX5r?=
 =?us-ascii?Q?BFFirKiYt9Nq8IaNkjD/PAAQeplIWiQhD/DwFshU2kb8tcoVzVp0VxJKKaOi?=
 =?us-ascii?Q?cakC2JrbK+3Ux48yAihPUiOkF0+m8v+pqsz1lGRm61G1tNprwkGyZsQ6wcLM?=
 =?us-ascii?Q?r9KcVAhJ2KWgQ6kQTvYUzqt2rcaRCXDzs0NVC0go9oOURpFVYM1wYYBJCRRl?=
 =?us-ascii?Q?K/zAfhz/zep/W38IE5tMN033ZRsjwdA81RoZiAhsIzM/zYTXVnZw7cEE3J40?=
 =?us-ascii?Q?av44CV31Z0zSbinpUVJsUfOdN3BaYRWi/Rz7x1b1PXcTeSaV4tg+edim1sxc?=
 =?us-ascii?Q?jePAnZ998Yn66JV2lZeuYdeYfGp7UJAafkgHWNYX?=
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
	XNRv7IoXMaK1ylcwJwrWH/gqzwMWWbLefLg9zZV3jtqtA535C4kHYkLBAL7kiI7Ps7iVv1afkNaaAQWeomjeMiFfZAsrPnBv3t/F268thhz7TUBorC4HW9wuWW9Ao/fLIRiRC0iDhwZ4JDq1ekIgIjciIJ6jeZrseKdQBJQ9iH3nNIg8QiStGO6BeLpSm7Q+hjd7Z+IyNV4oMOnZUfN18I5S9rTYIbanTSC9tAOalFUNG3MQ8VX+y0a0yY/AhAN2QAKnW5VT3ZTJkrq+UkuyvvzXZWJ69lKCxRCRh1wbjnPSD24qE5SB0Aap+q24XfNnpCWH5CklTJqu9ZNLXH6j08RxNeE0Iio4j9V2MeDMu3xXRrdFxPrfkdKXG/wP8pmCOXqOzg6tJoqusmg+Ue8C1GSmZJPPvtxNdOGtFZjoma+evfKne5V7KCNbznehLbS47GZ7BJlaRpd6mxnKyVxwVTaPN/YNtmryNVH8bMK2Qzc2z3o8+5iH5TZqX6/7CyMVyHggxiXbxcO9aP3FNllvo/w5TUOeoGYQS7ZQCL8mcWGs3ceBgPKYNFLHCHIQZDYrJlZg0tx5ZaRMmKafWVR5v6c3GvibgAM9Oe+AsChbC2I1p0NE15dgIu5mX0F0houJ
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea5c638-3257-436e-12c6-08dd77304557
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2025 06:32:16.1736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fnfnBrpt1LJ67hm/IvnjUU7ETCkukKohZUKlZjdRVv8iZe1098n8nZ3wUqLI8mP2xrpQ1sYnel3ZimMvhy4aJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR16MB5152

=20
> Change the 'tag' argument into a SCSI command pointer. This patch prepare=
s for
> the removal of the hba->lrb[] array.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Why cmd and not lrbp? Seems like a step backwards.

Anyway,
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 94cf864ac62b..f87526443d8d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -425,7 +425,7 @@ static void ufshcd_add_uic_command_trace(struct
> ufs_hba *hba,
>  				 ufshcd_readl(hba,
> REG_UIC_COMMAND_ARG_3));  }
>=20
> -static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int t=
ag,
> +static void ufshcd_add_command_trace(struct ufs_hba *hba, struct
> +scsi_cmnd *cmd,
>  				     enum ufs_trace_str_t str_t)
>  {
>  	u64 lba =3D 0;
> @@ -433,9 +433,9 @@ static void ufshcd_add_command_trace(struct ufs_hba
> *hba, unsigned int tag,
>  	u32 doorbell =3D 0;
>  	u32 intr;
>  	int hwq_id =3D -1;
> -	struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
> -	struct scsi_cmnd *cmd =3D lrbp->cmd;
>  	struct request *rq =3D scsi_cmd_to_rq(cmd);
> +	unsigned int tag =3D rq->tag;
> +	struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
>  	int transfer_len =3D -1;
>=20
>  	/* trace UPIU also */
> @@ -453,7 +453,7 @@ static void ufshcd_add_command_trace(struct ufs_hba
> *hba, unsigned int tag,
>  		       be32_to_cpu(lrbp->ucd_req_ptr-
> >sc.exp_data_transfer_len);
>  		lba =3D scsi_get_lba(cmd);
>  		if (opcode =3D=3D WRITE_10)
> -			group_id =3D lrbp->cmd->cmnd[6];
> +			group_id =3D cmd->cmnd[6];
>  	} else if (opcode =3D=3D UNMAP) {
>  		/*
>  		 * The number of Bytes to be unmapped beginning with the lba.
> @@ -2307,7 +2307,7 @@ void ufshcd_send_command(struct ufs_hba *hba,
> unsigned int task_tag,
>  	lrbp->compl_time_stamp =3D ktime_set(0, 0);
>  	lrbp->compl_time_stamp_local_clock =3D 0;
>  	if (lrbp->cmd) {
> -		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
> +		ufshcd_add_command_trace(hba, lrbp->cmd, UFS_CMD_SEND);
>  		ufshcd_clk_scaling_start_busy(hba);
>  	}
>  	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp))) @@ -5564,7
> +5564,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>  	if (cmd) {
>  		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
>  			ufshcd_update_monitor(hba, lrbp);
> -		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_COMP);
> +		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);
>  		cmd->result =3D ufshcd_transfer_rsp_status(hba, lrbp, cqe);
>  		ufshcd_release_scsi_cmd(hba, lrbp);
>  		/* Do not touch lrbp after scsi done */
