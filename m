Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BA417C77;
	Fri, 28 Mar 2025 08:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743150560; cv=fail; b=E5iN4mVWjwkNQ5An2aDnHRkm22qY1YBYJ63cSbMGFWqbg5LjRGQJANvkuGlOABXnbwNOURasYPqr/rYHbPMmiZgAdMIfnHC4GFTUTgTQl+xnAg8ApV/nU2qhZwLaihUxriUuJ+3h8fGmDNLV6ErDjgmw0Z/3yq+SCW4BZzc4phk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743150560; c=relaxed/simple;
	bh=Ol7m0o67xF+0VqOH0eSzrC5rlLXB5wN/lDvdZa7P6Wk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hj/TuPKq7ALF1neILBlskso4Rzwi7jIk7kkfbjacY8ZQ3xjOYcs4X/3i6kQ9/gI4jAsgT4kN/yui+otZbsOmYx3+3qz56lPAepYD4qIBWgvEdn97FypUmfI5Ji2faAu+eO3fbf0iRA46xvH+w/JrTF6JuKEHvfAmUHwUMzGMZww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=V7BtUpxV; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="V7BtUpxV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1743150558; x=1774686558;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ol7m0o67xF+0VqOH0eSzrC5rlLXB5wN/lDvdZa7P6Wk=;
  b=V7BtUpxVXj5I0x9bKMGmuOAbVx5dsZD9PlzhRjXvYleqjfEebQNTR1BH
   PQa69joXSXRCWtWRIacAgMuhWuhtFlIbhf24flBVO/KoiQHb1HtwlkosK
   +Q5irU1y4oR9OoBbKeJqMRzbnSxztl8vjQQkt81NItpSi4DluaHvTus43
   g0lm+ys2yO5fmC3AQ55YMHICmRwdnHpnW090kbsNcIGWOE3xD4e+NvQyA
   Dmvw0YrhvNGL07Toa9L3E6bhArWprIC4S6x8wxgPF4uuQUGCcMlurhxqt
   ZKI5UKTDM+tGPDTUac4c5I+GSa0k6Rc4Rw9ztVF/GQo9zk3zu/TKihASG
   A==;
X-CSE-ConnectionGUID: IJctyserSrGZOwJzn84Row==
X-CSE-MsgGUID: cZ3wIvHoSBeH7yz5hM1sUg==
X-IronPort-AV: E=Sophos;i="6.14,282,1736784000"; 
   d="scan'208";a="66700200"
Received: from mail-dm6nam10lp2043.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.43])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2025 16:29:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MADsWpFhmT3zsh0b7mK8Fjx65Cryz6ZYKudopb5lvj6EIGU5jt2gd/FO0nv0vN8H+ArcYCCSxdfGAxjaOS1LCakyXSm74jfoQ48eGuO3HRBYQ4amKsVS38UKTPzD77NVakV03b+vngwUxdPZt5ONKbai4QnHZdLvq1OHYonL4754OVIz1931NtbV0PGWbcC5vYMXvE8NAJ0YWO0FTHWMR4381d7FqZlDsVXKlmIe8hGX4O8rZhNoF2cpa+lod9zyq27p2DFd6WFStVCntn0+ncrgSgq93fFTr/RTrzg8I/uoZ9W1O9OhuaeuP931aOm1+099ItFuYVcEP3fyNpfn4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JY/qP64+mxWmERmiTxk8fH8jqyOzby/zwhdn1Q1aoP0=;
 b=wGq2xCz5rjD+8+O9Y/bqbuExA1Dfv0JdRbwBg8iXB4sgg9yhtBI9INQxBxx8AhBsTaQ/Pdd3CtWHPKDvylxGV1cg2rEiTiJ4ubAVFMsQ/1LgLDOqIF9o9nYmem2xppv1JgnrELxxf0dISQ0rjSfrCuOcjwXtOW+C2LeZp6nsPxB2k9NjAS4DdlxDwa58gEVjG0ExijUhtWojffwvwzgoPER4Jjo5nqA6Ns+aAt3A2YYRz5PCXENfndAYqh7fQrvBkR/bv8nk66leUQDdSgzJTdUEd6qem/TUNc5LPpJhpjxreUk/+oE13QaqE2L9DwVtSL8RZ66KcqtrGrLlA+HNoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by IA1PR16MB5334.namprd16.prod.outlook.com (2603:10b6:208:453::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 08:29:14 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d%4]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 08:29:13 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, open list
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] scsi: ufs: core: Removed
 ufshcd_wb_presrv_usrspc_keep_vcc_on()
Thread-Topic: [PATCH v1 1/1] scsi: ufs: core: Removed
 ufshcd_wb_presrv_usrspc_keep_vcc_on()
Thread-Index: AQHbnuL98BqRKlKSWUWxtjK27BqB37OIOJWw
Date: Fri, 28 Mar 2025 08:29:13 +0000
Message-ID:
 <PH7PR16MB619627C83309BDCE8BCB952FE5A02@PH7PR16MB6196.namprd16.prod.outlook.com>
References:
 <9ff613809e88496b5802a2d45984d2a8dddf92dd.1743057420.git.quic_nguyenb@quicinc.com>
In-Reply-To:
 <9ff613809e88496b5802a2d45984d2a8dddf92dd.1743057420.git.quic_nguyenb@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|IA1PR16MB5334:EE_
x-ms-office365-filtering-correlation-id: ab17a195-9d26-4a88-f7fc-08dd6dd29f49
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?YbE43bbVbXigcc+waAFAG1y+W8CLLw2k2sntGzVIcJ9r6upMuP0NBqFDp12l?=
 =?us-ascii?Q?GehbdVbB1zDCy3q72NO/N3RuE8XonRq7MQS1lc6rcARLBbaE4hTziizw6zS/?=
 =?us-ascii?Q?J86B0vLGqnr5Z6/B+3qSv5TEXltbbfozHLPhEwuI3fz7qV2AKNvVpzsrIXxV?=
 =?us-ascii?Q?R53PtE5vG/EhepOIQeHgDmlwZ8iqho1DP36SgqAb5arHgl6H7MrXCK67aGDG?=
 =?us-ascii?Q?s/PBNWB8j0d5VooX4YXkWzooNB7c0OsgVoIqF9ebtnhWhzt5Z6nDpjktNxiP?=
 =?us-ascii?Q?M0xy4UusCKs/g/AnjiZuja1oFdFP3RF4J5b827ACwHpe40ZmahWBX0n5g6E8?=
 =?us-ascii?Q?zb+/eWHn16z5lDCGLuLU9pcYEJiLaTC3mG3Uv9qbQc/8jUkxn6pVyVh4X0Cw?=
 =?us-ascii?Q?LPseZSyOXRUeX1ErbRDTgTw16A94YHD6AE415zLm6G+9wdCmU8KwevQiYR5k?=
 =?us-ascii?Q?iEz66zq3RKn+5VCkfh/AvHkDRDGVPl6YD1ACEqo8HL3OyxIH257J2eRtgN4P?=
 =?us-ascii?Q?xmxTSfwLm6aT1mpSmpGiTS3s50Z3OjGXnD1jwYyRnyEEnGT4FVhLv7ZdK3W4?=
 =?us-ascii?Q?roPCPwwWzcZb6nwkBTPn1IL9BowO1MYOoJydaEnJxFiB2EDdLXqbQiuAuCxN?=
 =?us-ascii?Q?xQXELTVVxm1wEo32exRH7ZXXIBNfc8qErjTwxq7lAi6VjrwIlahQZIOIK5wL?=
 =?us-ascii?Q?TVUN5cHLnQGfM5V5wE1GDwixPLj5KIJ/+lgBuOBn71datHPmrQCdXKolb2BE?=
 =?us-ascii?Q?dFFoEJ7rKCgT2TzxhO5+PxyRugeWFpIcMFBLO4QO7182pWpIQv6XUkIKfROn?=
 =?us-ascii?Q?hBKn/ayhuL7vldttvOKu7i3adP2AB/9DL92BEItL4HM9pOflqHQZWiDCatiV?=
 =?us-ascii?Q?r/HvyXuOJZq+Hu9n2zoHCuQwDv1+A5v1tlE/kJjLKY1PSGYdFyfREVZ8gTn5?=
 =?us-ascii?Q?/JDtbu/1Jq5LN40RN05hSFpYARU53/5CgK11yaqLP28sB1ymto+kdV8B1jpp?=
 =?us-ascii?Q?USyPww77dQp6Zh9bEzPhFvVMxns4HKz7xfmrTvOVwajW5kZPWwVvCni+DxKq?=
 =?us-ascii?Q?zpWYVEZ7/ct+D3t9N9mSBqJNF7RkrwkeOUuaYKSRwyJBTV025juccGy7kztc?=
 =?us-ascii?Q?r9dyEupC+F9LAEEiMwWYzymtj34IdeYUo8PCjtnl4RjKxwATVxPb/7Nhrldh?=
 =?us-ascii?Q?IyQqLYLjnF3C8I4WyXe5L4r7xjK4+zIGF6Qe6Tb4xGQetvIr4AXYqsbGHFxM?=
 =?us-ascii?Q?i6H10UMAVBWjuyuWCw7Wdj7Qcuqp++AJOHM4PR16ZaQmdks+nYF0jOuN/Q4H?=
 =?us-ascii?Q?4HY+LhjV6g0Ky7e2JJahBVtGmmMwR7ymQHmFOxJuIamGj1rXaWlDXW1qN84Y?=
 =?us-ascii?Q?8Xds9sCLd3gYupV6qYbnMeEXa03ThcBA2xyyyQRkPyoYZ/ETe48+6PaWAyJs?=
 =?us-ascii?Q?wcC9dWO0g+pETHqv1xZwNrEnhCdcsIKt?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yeJY7qY5Kks/kKvrNpT9/Z+cQravqTrKAyq8D6BqvoGawx+KPzx3xJbVXAas?=
 =?us-ascii?Q?762CdW87xAaf4gtn9gq2XzZsA3WTxW6StC7bZyL6qzI3hSsaYjojD4Tt6seR?=
 =?us-ascii?Q?aR1pp+mpC7eT3WrDAOQxQrAEi/pGYetGFaKOZJpJemz0vpqfrohasiWKEs8Q?=
 =?us-ascii?Q?GDL0lB3oFgd3dFMu8C9jXQQHz+/f/yvSpbPZ5me3E2ZX5x01ErexiFfROO73?=
 =?us-ascii?Q?njAQ7jrR3rsDrhmJqaQ07dua4H8Z1gxDVA432t4ohGpLfDeIAo5VHN0X06oo?=
 =?us-ascii?Q?Djxrf6xUaW/rVC2uM2McmaUm2DVXdm1qVwX58Zu4XrqGilu9rpbZiSClXhCq?=
 =?us-ascii?Q?P1DGwVt7nfqfIbfICr2sSJL9DVSE4eSGihx06V+YloKO2vyQMHIGUdq4I9L7?=
 =?us-ascii?Q?oa4cSjIKV8Flj0e+b0X8INBgd3tSJcBav/RlThKRgaGZdfPZN9vN64GD6gSR?=
 =?us-ascii?Q?tEbSd6lp+35zUerb12knWNEzKPH/IrrgXnxyUDkA2HDZrHvlp3evE3Q3sOuy?=
 =?us-ascii?Q?Bl6vSDJsrs4dt7OOeN+8WcQpeMzeDfYOe7Y/wnzPXpWxh2LJ38U0Ywy4hnlN?=
 =?us-ascii?Q?aUbKG/3A6qTlvDZnJ0ejUnXhRLeKHiOlCqKAGYTtuG9Uzlfo8Hk941dEt9Wc?=
 =?us-ascii?Q?yml6Mbi5jgs+RFQkMtQI2k/GyQNIblZYU+KS/2Gf3SUMvlempvlITdDfL6T6?=
 =?us-ascii?Q?9vqWcTW7OS3yU1Z9SWUsSd+O4klA0xIuwFv9j7C39O+u48NghYEWyfTp6msQ?=
 =?us-ascii?Q?51KD8OYUHugOJulNM3kuj++DWZu0ccs0gi9IRS4oEJnFlSTIyTWhCaNxRI/p?=
 =?us-ascii?Q?pV0qrzbh6o6DWnRfJKqYq61ukQBOw92FTXDyAqEvXTLtJhQo1wSKKGEzfOLQ?=
 =?us-ascii?Q?eMIEvAkg7eZsd84GZ+qHfa4NRF/gIap4cav+LKG2tX+l9zHdoMkSNSH2xiXx?=
 =?us-ascii?Q?q5MUABzr5sRWhE3SGMtKz217OLmU4qI0exlPLHptBW45qPCQXMOX58OlZqUs?=
 =?us-ascii?Q?sySKnFnU5mZIJgPnEHmS+WFnrCgl27p1ussbxAy4zYdmse4WpXcUpjiZQqGG?=
 =?us-ascii?Q?6N/gSVY8Gi7xSn8V+yy5/m79mm3wQZpLwP0K5A5mFkTz01p0fppGRcGLO8p0?=
 =?us-ascii?Q?jnduYA+B4z46t3wkIUHMvLNoFflhMDIqkWXJZ/suVh6LjShTcvJqxwhs2u3y?=
 =?us-ascii?Q?E8SJtChU0mUV9BZ0bQo8z+ccfC3tOat6AvR+JlNIxQhLHVlMU+day0BzahcW?=
 =?us-ascii?Q?IrWPnBiP79o3AKgS8vISiLwaOR4NrHoC0l3yBNkwRKK3CkDZEgywbxbho+gI?=
 =?us-ascii?Q?emP+di193HPbrgLToRJkaEMcJe10fKnlMTYtcM/jhQs/nWtASKpllf0R7rLk?=
 =?us-ascii?Q?sqbYJyEVvDGy2bPGJMbZoZ6/Lkpi8p5FU7HAVSnxRJomgD50xgMnLW7+wvf5?=
 =?us-ascii?Q?NxLYRfwMd6EKnKZAI1uI6oMSR2xfM2JLNp011ibxrGn5MntdtPfsu8ou++cn?=
 =?us-ascii?Q?MiLYD3X5t3zrpZGzsFVC2n8K5u/0CBKR9pPVDKzQlBcRHsLLEHUc7piAWG6t?=
 =?us-ascii?Q?PBaTz3OgnEgfACdSnrvMvdmpHftUV9A7GYwHP/gXKkaBPYUjnMouPiy6UmWZ?=
 =?us-ascii?Q?O1oqKGiNo7Am5Mn7OGuXW9K8fJ6mhQwh6fgc9U1DPiAt?=
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
	gLdc9e7r4Gw1dMUMYho5hIkhDeVIhDcim/zoNgWEUdR48EQPxAmgE6LKcXXqL6uZDFa6f/YM42qfqF2nj9e5FE6MjgHdxinfCalYafoejOtMBPD4krPFn1TKD0bXV4QbagmO+d4mpkQpRCF5Zkp7v6611ybi+kWldwlocqv5KiduebXZsnUfUzyQoaSuivU5f9I7ueZ7dfxIESMWQR0fXzv5Qg9tdR5yGud0TTpI1/J+jBauQP8A8MRte8KdqGCLGqh5qwScb0O0KEUp4bBrANmwQBVdipJNR5ewNqBAQqR2vUy7cayebxW2MS8pW0K0jxOCcAuEaDrWaKBdjmWZ0AkWNgIUWOfR0BN96wDt30VdboYifPTo+BZf7rM+a4uE0DXWnnrqBFvbFkQ2o58w4TVfwexTx6d1dju+HLB5FIp5cgkmFyNDQlRxupftHMjDTaLmCRPdpxc0KPe86Qzbz7kDgqSwZHPlN+scv/UD04rQ4eqf2Z2fgl1PkHe+VUcOopS/AkApYQFZC4TbaRzPysSAFZzlhDUsu9oh2FwjhG7TEgBzUsZEX41NgQJRnjJdZSpRdleEf/05lR9H9EzAanJfpmAVv8+pXrZuay0MUSYxI5hy8wqy0OIA6v0cyT+3T8cyj9pXnscou4hupzzehg==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab17a195-9d26-4a88-f7fc-08dd6dd29f49
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 08:29:13.9127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jO04pOUiisdOg0YfgwUfaPqDIZydb6gsDS5SDrbRagf9dAgGbPVDAjWYTjNmY6vlS647tT6HNUqbemT1EXz2NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR16MB5334

> Merge the ufshcd_wb_presrv_usrspc_keep_vcc_on() function into
> ufshcd_wb_need_flush(). The "_keep_vcc_on" part of the function name is
> misleading. The function definition may be deviated from its original int=
ention.
> This is a small function only invoked by the ufshcd_wb_need_flush(). To
> improve the readability, remove this function and merge its content into =
its
> caller. There is no change to the functionality.
>=20
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> ---
>  drivers/ufs/core/ufshcd.c | 53 +++++++++++++++++++----------------------=
----
> --
>  1 file changed, 21 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 4e1e214..b9272b1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6083,32 +6083,6 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba
> *hba, bool enable)
>  	return ret;
>  }
>=20
> -static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
> -						u32 avail_buf)
Maybe just change the function name to better describe what it does,
e.g. ufshcd_wb_exceed_threshold ?

Thanks,
Avri

> -{
> -	u32 cur_buf;
> -	int ret;
> -	u8 index;
> -
> -	index =3D ufshcd_wb_get_query_index(hba);
> -	ret =3D ufshcd_query_attr_retry(hba,
> UPIU_QUERY_OPCODE_READ_ATTR,
> -
> QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE,
> -					      index, 0, &cur_buf);
> -	if (ret) {
> -		dev_err(hba->dev, "%s: dCurWriteBoosterBufferSize read
> failed %d\n",
> -			__func__, ret);
> -		return false;
> -	}
> -
> -	if (!cur_buf) {
> -		dev_info(hba->dev, "dCurWBBuf: %d WB disabled until free-
> space is available\n",
> -			 cur_buf);
> -		return false;
> -	}
> -	/* Let it continue to flush when available buffer exceeds threshold */
> -	return avail_buf < hba->vps->wb_flush_threshold;
> -}
> -
>  static void ufshcd_wb_force_disable(struct ufs_hba *hba)  {
>  	if (ufshcd_is_wb_buf_flush_allowed(hba))
> @@ -6152,9 +6126,9 @@ static bool
> ufshcd_is_wb_buf_lifetime_available(struct ufs_hba *hba)
>=20
>  static bool ufshcd_wb_need_flush(struct ufs_hba *hba)  {
> -	int ret;
> -	u32 avail_buf;
> +	u32 avail_buf, cur_buf;
>  	u8 index;
> +	int ret;
>=20
>  	if (!ufshcd_is_wb_allowed(hba))
>  		return false;
> @@ -6165,15 +6139,13 @@ static bool ufshcd_wb_need_flush(struct
> ufs_hba *hba)
>  	}
>=20
>  	/*
> -	 * The ufs device needs the vcc to be ON to flush.
>  	 * With user-space reduction enabled, it's enough to enable flush
>  	 * by checking only the available buffer. The threshold
>  	 * defined here is > 90% full.
>  	 * With user-space preserved enabled, the current-buffer
>  	 * should be checked too because the wb buffer size can reduce
>  	 * when disk tends to be full. This info is provided by current
> -	 * buffer (dCurrentWriteBoosterBufferSize). There's no point in
> -	 * keeping vcc on when current buffer is empty.
> +	 * buffer (dCurrentWriteBoosterBufferSize).
>  	 */
>  	index =3D ufshcd_wb_get_query_index(hba);
>  	ret =3D ufshcd_query_attr_retry(hba,
> UPIU_QUERY_OPCODE_READ_ATTR, @@ -6188,7 +6160,24 @@ static bool
> ufshcd_wb_need_flush(struct ufs_hba *hba)
>  	if (!hba->dev_info.b_presrv_uspc_en)
>  		return avail_buf <=3D UFS_WB_BUF_REMAIN_PERCENT(10);
>=20
> -	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
> +	index =3D ufshcd_wb_get_query_index(hba);
> +	ret =3D ufshcd_query_attr_retry(hba,
> UPIU_QUERY_OPCODE_READ_ATTR,
> +				      QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE,
> +				      index, 0, &cur_buf);
> +	if (ret) {
> +		dev_err(hba->dev, "%s: dCurWriteBoosterBufferSize read
> failed %d\n",
> +			__func__, ret);
> +		return false;
> +	}
> +
> +	if (!cur_buf) {
> +		dev_info(hba->dev, "dCurWBBuf: %d WB disabled until free-
> space is available\n",
> +			 cur_buf);
> +		return false;
> +	}
> +
> +	/* Let it continue to flush when available buffer exceeds threshold */
> +	return avail_buf < hba->vps->wb_flush_threshold;
>  }
>=20
>  static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
> --
> 2.7.4

