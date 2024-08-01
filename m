Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229AD22097;
	Thu,  1 Aug 2024 00:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722473740; cv=fail; b=Id/1pJ4FPYp+KJhHOtYdGcBM2fBzjJmE1Wh0sqVNiRCFlpxteSsxH4JtUlrKvRBn6rbWrhq01o4VxF1+BYIM4XcmXMXBkgfiQcN2E1EaNmZWm44rcqrt1M9tGN3oEC8yNUK0LgQTibKn1Z/g3LUwdRR9gyOCn3UOI2UiJgqviM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722473740; c=relaxed/simple;
	bh=851bzgLxR5dA3BFSX1vW7nvcOgbQ4QTGv0sSKtwtXhI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u3bin//BJ8hPGT234+heXlC7HeQv7/kIskwCEy2C1IksJUJt/bXs57oCjKZlW2z20jnITjyXrxnniCAq8p7EAS8IeG9AZ8CjLCpN1pbDEHO36IlA7rxGi2ZHHz8WJHcxkl/uqJhYksQbtWGoUvI3RR6D3e/RsPyRu20klwOq6Jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TCGU4wJ6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jFcmbU23; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TCGU4wJ6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jFcmbU23"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722473738; x=1754009738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=851bzgLxR5dA3BFSX1vW7nvcOgbQ4QTGv0sSKtwtXhI=;
  b=TCGU4wJ6yAe8ykuNMC/Nuf2+pGykV9DR7GbCWdETfC5SjeL5uU7M/dat
   f3uQ/S30wLjGXCK/RQkDMGYKWmRuTlavUB3ykmijc2Z+uEBblqZapKGyA
   RW0Yjp+93akBUb1zA1Eds+5YZE/UVztq0eri3hu46aMoFW7wpBEuTyM8l
   vURwh+roQb0qA6eEitiHAeKMqnvAVTp/L6KDaXSQmDBshps7g0FQsviO8
   jIDmwaq36+q8e6KlLv1RersqSo5+x9g9HXAUawi1qwvZ9Zw3QqjwQ/MBG
   yp6wbUepu8T6Sg5zQjK4G3vX26vBhP2ZYo64+mj49HUXgTZTmHeQXq4YG
   A==;
X-CSE-ConnectionGUID: 0d1vu9ehSza0eNmpjn7mAg==
X-CSE-MsgGUID: zTJn79P8T0C71dTi24oEDg==
X-IronPort-AV: E=Sophos;i="6.09,253,1716220800"; 
   d="scan'208";a="23473745"
Received: from mail-eastusazlp17010001.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.1])
  by ob1.hgst.iphmx.com with ESMTP; 01 Aug 2024 08:55:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QC6mpIjepTj8QkaRRo6BuTPLnvztThYZFn1wpN1QBJ8kt9ZnKjK30T4RyIQ2qCFhAjer5iOJ82poyYN+p1AVz/mTVrkYCrKNCocVhuvayRZ1iu8kImb39Ex/rrMEyTJeNbrmprh5PJDj4VaA3oaQym8RecvC/jVhePPHmjtJj1v9RJOYnsQvx5hFjGHG2aiNT4iUYEPTLylb3Uls9WYf3rNBrATcQj0be/1b+pmxDuUosXVTtfE/5If3XdH8yPy8HfbIag+2kf2hsowJyd4zxyT8tS+ArPDXQMnUhkoK2DfGVtYfYznFcvyBJzMDNvY5Z6CHYl21NL02BZE0eh+ADA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/m0xrQgy7MIdqefRkahZQHVWNLfvK21C9aY331Wvd7s=;
 b=uZ8q/CseuR1P0Erp7lQc0PMsbIDYxO0eL/aD49muv28xZfzk0hkKrfAnJXQ9wApSirK856b0lQuBNh3YDcyjQGXoEpmdIkXaP6ybAr7Zcmdkpsb++LpBkpERXjr2rOYn7sR1D86DnkTH1TmxfuAv1uCUuwxip10/9ZRxkdun2eJURfCN3qFk+Hh/rJJgv7DQ9IvR/gy25rZXyxWNbRh9ha+NOzgMzvu+csO6s6bt020j7fWsJabqv3h9EZpdPozbdJ31QFJeZ8nADc7qk7UJQDdx5ePTXZhY0NLaG2FBkGh83cUAgm8r+N6hTWG1ihj50LT0FeeHkw0xRtGCiLY3bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/m0xrQgy7MIdqefRkahZQHVWNLfvK21C9aY331Wvd7s=;
 b=jFcmbU23Vn2srt5ZUM0GlXlJ+OYSw521+uaQmg2pG4y9j5wYz688wbNB5i9rzKhtEi+uj4FLB1l2cnSOttUzL/D6AHvhVa9jfERx1TJcO6n0rwb5JTDPds/DP9lkJ3KHl/u4H7mgSNpXr9oEsAB01bVclhb/wmbTZOvXKuJwkZU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH0PR04MB7787.namprd04.prod.outlook.com (2603:10b6:510:ed::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.21; Thu, 1 Aug 2024 00:55:26 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7828.016; Thu, 1 Aug 2024
 00:55:25 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Saarinen,
 Jani" <jani.saarinen@intel.com>, "luca@coelho.fi" <luca@coelho.fi>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, hch <hch@lst.de>
Subject: Re: Regression in 6.11-rc1 in scsi/sd?
Thread-Topic: Regression in 6.11-rc1 in scsi/sd?
Thread-Index: AQHa461+eaMMAJeR/UyAg6TrGYYORA==
Date: Thu, 1 Aug 2024 00:55:25 +0000
Message-ID: <vlmv53ni3ltwxplig5qnw4xsl2h6ccxijfbqzekx76vxoim5a5@dekv7q3es3tx>
References: <b123b699569f3a85bcfa521b2511e9e2698f31b7.camel@intel.com>
In-Reply-To: <b123b699569f3a85bcfa521b2511e9e2698f31b7.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH0PR04MB7787:EE_
x-ms-office365-filtering-correlation-id: 7816f559-4e30-4507-1ad6-08dcb1c4a15c
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?SbMBknT/dQPZQyRNpiRKxCaoqyDghMyOEfvhVtdPHkeYKF3ntAtidxdNv/Fb?=
 =?us-ascii?Q?60UfyruovlI6k7diytLkS8F22e2jYA3YbxdObZlGUatWje5fY0d5lYaQqgpQ?=
 =?us-ascii?Q?sDnFFWxAYUWpWKDFW/93uhZ7N/Ur06YgOJmox54cJQJwHfnL6Po5vFlGGS6U?=
 =?us-ascii?Q?Sk2IVByYLA7Oj2bKGl496PYcrt4r4BWZm9xWpR6glYvFBEJlDODBVsR1h0ZK?=
 =?us-ascii?Q?SMYkpLA8c6EHAOu1scQlb6PlX2f0Opob1P1kkV+ZKq3QF6YysZ3EDPimjXUy?=
 =?us-ascii?Q?JcEO5dLqW2MJ4bkpsrdVEi+AdPmgS3wgo4pZHdRrbCjAWTTEDgvH15oLzkiX?=
 =?us-ascii?Q?8HuOnxm2xCG64cFU+rDJ8bxxevBGOV364pZNNVZmLUQ37QFGJ41MGrZrTSfB?=
 =?us-ascii?Q?E+ApmqK7M8Ra4FYr0KiEuXj8VuZPvNxcn1c49rB0AmY7mKwwR3O2eeNM1XFw?=
 =?us-ascii?Q?21MNQmk3KnTehWzHVc2FG8KntCCa0z6l8FNUuFcIIx9KueQeeIpab1w+0taD?=
 =?us-ascii?Q?oBUsloxWjNRca6giVPNBIDlbglwV9LhENXuSMr2SSZkTUHXXfMRCDr0GFjas?=
 =?us-ascii?Q?4H0+w7z6YmL0rjUlHpViQF5KZW7dtPywhTsZ+usAZBQQgPWwX63zfP/Bx4a8?=
 =?us-ascii?Q?SMmL2KZax5mqze+v5cxACUInXekOtclmrq6856z4JRRnxlEeccNUVnhZG2Gc?=
 =?us-ascii?Q?hCBoVsgx7QmE39pqfldLDzu6uy8zSHwfnwJ3oiMwnZGwlBj1Sy1MVoHZk7OU?=
 =?us-ascii?Q?3yjbikMKHijm1qAmr0WfB8T9Z8E9jJWdl25mnZmBY+OZjgRMlRCjmeHkACRv?=
 =?us-ascii?Q?TUccveYHLikvnN6vej/DV2C3mMun5bvryT2M5MvTUZlLY9HtGFXVcBzHdN7m?=
 =?us-ascii?Q?EIZ4KI/G9vkwm87D/X8rD5WeQSDxnpbJ3L74xuWW9Ztbxa01p84Nj4JbkZpg?=
 =?us-ascii?Q?I1sYbh1HCNVNp1ZcxQzgE3Iku0oE5GQgO4NO7r1f/QraTed1d/2ZaDYwzC1r?=
 =?us-ascii?Q?WfBG7cIUHYwlAm+DlH6M7mqVysPeWAgACknlNrXsWUYK6l7ryuHpvDXKgEwj?=
 =?us-ascii?Q?7QGWeaFVUFRd62nebs0rcEZOCOjc70w61+1642dNe/hAC6SpQJa6lZlDuRx/?=
 =?us-ascii?Q?mkRpWNlMwFaG9aqiydAWDlpmt+LoAzgGRMwEA1YT6sNZarHTwqiYtFLiuV0o?=
 =?us-ascii?Q?ZM4brOHez0zua6tFY7qRfo61qo5c40cNeyNuRfvnEkCsbz7f+cMNHGlY4ojz?=
 =?us-ascii?Q?3iBClKqlmKimOreO7WfL/PnDOVQ8x5z8Bd0xios+xgP0pPjnLh7+RBfy5UMd?=
 =?us-ascii?Q?JjBftrcfpsbCMZeO2mPlk8s7TgRWj5YhhcCr2GqmNcRDpMCJvgqGAxX6UDSb?=
 =?us-ascii?Q?v9EDq5Q=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?fQQNaJqJZPYhzGTDHAFKnq/IVSah2OwHjreOlME3GL4/yUQk08erpN8HmLXE?=
 =?us-ascii?Q?XX7ITQGmrwQIZvpBP2nIcwzAOZoMEr31AomnhZSY9H+Yz/XbiA8RaPjEU1gG?=
 =?us-ascii?Q?/T7rpdPwEIDIFIZzoD4Nt2x+9mdoT6Jo3VAz0z2M8UINDkhgBLLifIm+03HQ?=
 =?us-ascii?Q?0S2KdkMV7HmKetYSFN1Jys68coMbuHyXjiMovlOOaRfEAjNEGlDwwEzoiY0s?=
 =?us-ascii?Q?tdaEUO5YzNPms8m2c8h9Xt0MgE0hbJW0ZceYlkCKUGfDNv4l577iWV47G3ks?=
 =?us-ascii?Q?44jEGWJG5HsEeQA7JRI8KBwxd7yah5wn4uywQ1I46KS7eNyperM6pGdKPkV9?=
 =?us-ascii?Q?9ESgpHzcvvf5LaBcFKSLNSnRSajmkm8xNuTlOb3SVPRTjzjQAR5lDhOjPpPL?=
 =?us-ascii?Q?N6Dtv5W/yJlBuameCNNHEOHa7mOzK1+bRBHyk4cofuq4wg/DZq2Y8l85tn/E?=
 =?us-ascii?Q?qbaKQ3qbeuW7nAbxvI1MKtkbew5NhDpE6eKRKDXaBooYPSt8yV551hcewgDz?=
 =?us-ascii?Q?/h5xdFGcKZ7PMq2LUtZ5i1najhH6SuSRpoc8QBe1vfoYY7r1E6Pg5zHLUFpx?=
 =?us-ascii?Q?VqHmPFvVU9WvSk842RD39QziyqpkDVdziicEEF/QFzf2mk1kEgaLC5uUBO5I?=
 =?us-ascii?Q?axO278SAkWgp4yREe0jkh04ZdsglshPM3zoU5dZOQNS7yt+RTt17NvMB04e3?=
 =?us-ascii?Q?HujBfEK27sbi2XvS/HEILh59fk+NAGtI2epMBxQvXZJp4z6W3o+E0Rtip93y?=
 =?us-ascii?Q?WnENnxKOw0z3u0OSGY6SgeCJ4SfRQcCXsKu8cnr+/CU2atcuYVP10uOkUcxx?=
 =?us-ascii?Q?/cagQ25O93t+kDHOGrHSrqGxOuB4xfqY1sm1XMhml2QEEPmmGq63W6bC5Ia/?=
 =?us-ascii?Q?qzF/h3v+3zYGENlL6Ijrv0EqQaSMelBMJEmGbTzWelZZ/wpU7dH6/clBVBY/?=
 =?us-ascii?Q?RuR2t+M0O0azb/5uL1LMfWoq+fRoGlcrNzuvp9n63KJXU6eZ4chAcsMLmgH7?=
 =?us-ascii?Q?XKrFQcyUlDq4F4cCVfAI0yYTpupSdmqfYViChm7wrV4/J78So3aOTbE9t2S/?=
 =?us-ascii?Q?eRtV6IKxn1Ua3NPq+H73QrZhTrAylKusLDG4BAV39rEwqosCXKfSYmwFyryV?=
 =?us-ascii?Q?oJZRzl5ZQQ/lRfLhDMl1Z/eI1nRtCw6QtvMU251j1X1tvSblPSN4L6NzRzRA?=
 =?us-ascii?Q?i82Hlzik1oYcqLHLLuRgFpewR0bYgtAW0hcSpZB1u/oYGB8t0RoI7W57oNLv?=
 =?us-ascii?Q?nUPDC/4Qys8ehl5QTTVKwrpaqMDQnamH9TCiHs9DZQkafnZX0HasOmCUR+da?=
 =?us-ascii?Q?gvgnQcHsyvRA86PfHwD0ebeTI4Hql3DSzGeKTrRR0Wog0PLxUj7/OCwRU67M?=
 =?us-ascii?Q?I6T4L/84ySHRZB3iAAuhd6t9ZTGhtRuNfjVVnD7yfIoYZB19J8IFZhUSGe35?=
 =?us-ascii?Q?rjZDB0nHnZUFQaqWsGsN2fJmd8PCfdjS6DSZRF1WrtpTBU15Jw4jB+WsRkfs?=
 =?us-ascii?Q?45swvjs4S7OMrp7I2KA2CnM4KEvCV6B+WWvBt+iqnjXSgo6CHxlG9zGaEwOG?=
 =?us-ascii?Q?mjl16aWhIa3ooUrSrvM2dMsWRhkevMh+X+ckYGE5FY5pMw+QMjlX042vd15+?=
 =?us-ascii?Q?7lSOgFZoiArZxqVvhWabWxo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23DCAED63111324EA6113A17AF962361@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	15zxIJA5TRkZcdAdfOgdkv5nJPwi1udjaAK/LwCxdOu3VeeH5CrdF4sH/2IiGCWnJ6qUVlg4vGBoCDo1C4j5cqe1gGYb6VQ6YGfwJ4DxGfQbborXh2HW+kujvUT+yZ93Y1N8+DQbKurynpFEM4/h78xKmaeo+ytOz0YKlIw5Bpf3nmd8GZc/rWspA3X1/7WwO3NvVL38qxXS27TbLnCzea8zrtLCfKRhJB0GioJuPaInhT0NU6ITKPlRiiNZ+OB8put2sq/R09TMya725kzuZxIeNEK7Y78YQj2+PD032XaT0xxyc9RB8DzRYffPh81G2ZGp/oJlK7kAvg2mNINU7l41bKXttGeJlO+T99aXdCxHqyusb8xrMfx/fSB3CYiH1QsWpbrx7cUp+aBZzo3Z34hkkCLJ9qQ2Q35Rx2Ks8dca3JWOXnw7otdyXnFjNHUZC3S/qiUGhJJuyJKQW140+esWEDOgKNfLvD0PKpY0hK2+0IgOBmuZZ9kdVWumYNqdjOf/8NUbnvc18IlfZfEawaxwVJFng95iWKPwXX5EWlaZYsEX/GYxI0g4Vxz76fRTqjJk6xxJPS5zLfESH5D+xJgMLtO98ch2boJouuJDF8LHA3e07/3wXXC3J27OriCr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7816f559-4e30-4507-1ad6-08dcb1c4a15c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2024 00:55:25.8627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aWb9n+MCvpBQXbvqsz8AwgmFwjSX7ULb2pJ0UtrVEFhEJkGCFvyPQJxkmsMGo+iSFAQ903kmriMRzb0Ef+roi37pgQALa4vICS/J/63cjIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7787

CC+: Christoph,

On Jul 31, 2024 / 13:22, Coelho, Luciano wrote:
> Hi,
>=20
> We're getting some lockdep splats with 6.11-rc1 in some of our older CI
> machines:
>=20
> <4>[   25.357106] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> <4>[   25.358383] WARNING: possible circular locking dependency detected
> <4>[   25.359636] 6.11.0-rc1-CI_DRM_15151-gb6f9528c7fff+ #1 Not tainted
> <4>[   25.360902] ------------------------------------------------------
> <4>[   25.362184] rc.local/609 is trying to acquire lock:
> <4>[   25.363450] ffff888102358670 (&q->limits_lock){+.+.}-{3:3}, at: que=
ue_max_discard_sectors_store+0x8e/0x110
> <4>[   25.364798]=20
>                   but task is already holding lock:
> <4>[   25.367410] ffff888102358550 (&q->sysfs_lock){+.+.}-{3:3}, at: queu=
e_attr_store+0x45/0x90
> <4>[   25.368773]=20
>                   which lock already depends on the new lock.
>=20
> ...during device probe.  You can find the full dmesg, for example, here:
>=20
> https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_15151/fi-bsw-n3050/boot0.=
txt
>=20
> The stackdumps seem to point to sd_probe() and sd_revalidate_disk().
>=20
> Is this an known issue? Does anyone have any idea what is causing it?

I also observed a WARN quite similar, when I ran the blktests test case srp=
/002
on the kernel v6.11-rc1 [2]. I bisected and found the trigger commit is
804e498e0496 ("sd: convert to the atomic queue limits API"). The commit
introduced the pair of function calls to queue_limits_start_update() and
queue_limits_commit_update(). The functions lock and unlock the q->limits_l=
ock.
I believe this caused the circular locking dependency.

I took a closer look, and found that the sd_read_cpr() is called between th=
e
queue_limits_start_update() and queue_limits_commit_update() and it creates=
 the
circular dependency (sd_read_cpr() is called in sd_revalidate_disk, and cal=
ls
disk_set_independent_access_ranges). I have created a fix candidate patch [=
1],
which moves the call out of the two queue_limits_*_update() function calls.=
 I
observed this patch avoids the WARN on my test system. I will do some more
confirmation and send it out as a formal patch to get review on it.


[1]

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 049071b56819..7c5d681d234c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3666,7 +3666,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 			sd_read_block_limits_ext(sdkp);
 			sd_read_block_characteristics(sdkp, &lim);
 			sd_zbc_read_zones(sdkp, &lim, buffer);
-			sd_read_cpr(sdkp);
 		}
=20
 		sd_print_capacity(sdkp, old_capacity);
@@ -3721,6 +3720,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (err)
 		return err;
=20
+	/*
+	 * Query concurrent positioning ranges after releasing the limits_lock
+	 * to avoid dead lock with sysfs_dir_lock and sysfs_lock.
+	 */
+	if (sdkp->media_present && scsi_device_supports_vpd(sdp))
+		sd_read_cpr(sdkp);
+
 	/*
 	 * For a zoned drive, revalidating the zones can be done only once
 	 * the gendisk capacity is set. So if this fails, set back the gendisk


[2]

Jul 29 18:27:12 testnode1 kernel: WARNING: possible circular locking depend=
ency detected
Jul 29 18:27:12 testnode1 kernel: 6.11.0-rc1 #208 Not tainted
Jul 29 18:27:12 testnode1 kernel: -----------------------------------------=
-------------
Jul 29 18:27:12 testnode1 kernel: multipathd/118209 is trying to acquire lo=
ck:
Jul 29 18:27:12 testnode1 kernel: ffff888107094740 (&q->limits_lock){+.+.}-=
{3:3}, at: queue_max_sectors_store+0x12b/0x290
Jul 29 18:27:12 testnode1 kernel:
                                  but task is already holding lock:
Jul 29 18:27:12 testnode1 kernel: ffff888107094620 (&q->sysfs_lock){+.+.}-{=
3:3}, at: queue_attr_store+0x8b/0x110
Jul 29 18:27:12 testnode1 kernel:
                                  which lock already depends on the new loc=
k.
Jul 29 18:27:12 testnode1 kernel:
                                  the existing dependency chain (in reverse=
 order) is:
Jul 29 18:27:12 testnode1 kernel:
                                  -> #2 (&q->sysfs_lock){+.+.}-{3:3}:
Jul 29 18:27:12 testnode1 kernel:        __mutex_lock+0x18b/0x1220
Jul 29 18:27:12 testnode1 kernel:        blk_register_queue+0x10a/0x4a0
Jul 29 18:27:12 testnode1 kernel:        device_add_disk+0x646/0x1010
Jul 29 18:27:12 testnode1 kernel:        sd_probe+0x94e/0xf30
Jul 29 18:27:12 testnode1 kernel:        really_probe+0x1e3/0x8a0
Jul 29 18:27:12 testnode1 kernel:        __driver_probe_device+0x18c/0x370
Jul 29 18:27:12 testnode1 kernel:        driver_probe_device+0x4a/0x120
Jul 29 18:27:12 testnode1 kernel:        __device_attach_driver+0x15e/0x270
Jul 29 18:27:12 testnode1 kernel:        bus_for_each_drv+0x114/0x1a0
Jul 29 18:27:12 testnode1 kernel:        __device_attach_async_helper+0x19c=
/0x240
Jul 29 18:27:12 testnode1 kernel:        async_run_entry_fn+0x96/0x4f0
Jul 29 18:27:12 testnode1 kernel:        process_one_work+0x85a/0x1400
Jul 29 18:27:12 testnode1 kernel:        worker_thread+0x5e2/0xfc0
Jul 29 18:27:12 testnode1 kernel:        kthread+0x2d1/0x3a0
Jul 29 18:27:12 testnode1 kernel:        ret_from_fork+0x30/0x70
Jul 29 18:27:12 testnode1 kernel:        ret_from_fork_asm+0x1a/0x30
Jul 29 18:27:12 testnode1 kernel:
                                  -> #1 (&q->sysfs_dir_lock){+.+.}-{3:3}:
Jul 29 18:27:12 testnode1 kernel:        __mutex_lock+0x18b/0x1220
Jul 29 18:27:12 testnode1 kernel:        disk_set_independent_access_ranges=
+0x5e/0x690
Jul 29 18:27:12 testnode1 kernel:        sd_revalidate_disk.isra.0+0x5872/0=
x8c70
Jul 29 18:27:12 testnode1 kernel:        sd_open+0x33a/0x490
Jul 29 18:27:12 testnode1 kernel:        blkdev_get_whole+0x92/0x200
Jul 29 18:27:12 testnode1 kernel:        bdev_open+0x640/0xd20
Jul 29 18:27:12 testnode1 kernel:        bdev_file_open_by_dev+0xc2/0x150
Jul 29 18:27:12 testnode1 kernel:        disk_scan_partitions+0x18c/0x290
Jul 29 18:27:12 testnode1 kernel:        device_add_disk+0xceb/0x1010
Jul 29 18:27:12 testnode1 kernel:        sd_probe+0x94e/0xf30
Jul 29 18:27:12 testnode1 kernel:        really_probe+0x1e3/0x8a0
Jul 29 18:27:12 testnode1 kernel:        __driver_probe_device+0x18c/0x370
Jul 29 18:27:12 testnode1 kernel:        driver_probe_device+0x4a/0x120
Jul 29 18:27:12 testnode1 kernel:        __device_attach_driver+0x15e/0x270
Jul 29 18:27:12 testnode1 kernel:        bus_for_each_drv+0x114/0x1a0
Jul 29 18:27:12 testnode1 kernel:        __device_attach_async_helper+0x19c=
/0x240
Jul 29 18:27:12 testnode1 kernel:        async_run_entry_fn+0x96/0x4f0
Jul 29 18:27:12 testnode1 kernel:        process_one_work+0x85a/0x1400
Jul 29 18:27:12 testnode1 kernel:        worker_thread+0x5e2/0xfc0
Jul 29 18:27:12 testnode1 kernel:        kthread+0x2d1/0x3a0
Jul 29 18:27:12 testnode1 kernel:        ret_from_fork+0x30/0x70
Jul 29 18:27:12 testnode1 kernel:        ret_from_fork_asm+0x1a/0x30
Jul 29 18:27:12 testnode1 kernel:
                                  -> #0 (&q->limits_lock){+.+.}-{3:3}:
Jul 29 18:27:12 testnode1 kernel:        __lock_acquire+0x2b90/0x5990
Jul 29 18:27:12 testnode1 kernel:        lock_acquire+0x1b1/0x520
Jul 29 18:27:12 testnode1 kernel:        __mutex_lock+0x18b/0x1220
Jul 29 18:27:12 testnode1 kernel:        queue_max_sectors_store+0x12b/0x29=
0
Jul 29 18:27:12 testnode1 kernel:        queue_attr_store+0xb5/0x110
Jul 29 18:27:12 testnode1 kernel:        kernfs_fop_write_iter+0x3a4/0x5a0
Jul 29 18:27:12 testnode1 kernel:        vfs_write+0x5e3/0xe70
Jul 29 18:27:12 testnode1 kernel:        ksys_write+0xf7/0x1d0
Jul 29 18:27:12 testnode1 kernel:        do_syscall_64+0x93/0x180
Jul 29 18:27:12 testnode1 kernel:        entry_SYSCALL_64_after_hwframe+0x7=
6/0x7e
Jul 29 18:27:12 testnode1 kernel:
                                  other info that might help us debug this:
Jul 29 18:27:12 testnode1 kernel: Chain exists of:
                                    &q->limits_lock --> &q->sysfs_dir_lock =
--> &q->sysfs_lock
Jul 29 18:27:12 testnode1 kernel:  Possible unsafe locking scenario:
Jul 29 18:27:12 testnode1 kernel:        CPU0                    CPU1
Jul 29 18:27:12 testnode1 kernel:        ----                    ----
Jul 29 18:27:12 testnode1 kernel:   lock(&q->sysfs_lock);
Jul 29 18:27:12 testnode1 kernel:                                lock(&q->s=
ysfs_dir_lock);
Jul 29 18:27:12 testnode1 kernel:                                lock(&q->s=
ysfs_lock);
Jul 29 18:27:12 testnode1 kernel:   lock(&q->limits_lock);
Jul 29 18:27:12 testnode1 kernel:
                                   *** DEADLOCK ***
Jul 29 18:27:12 testnode1 kernel: 5 locks held by multipathd/118209:
Jul 29 18:27:12 testnode1 kernel:  #0: ffff888135f35ec8 (&f->f_pos_lock){+.=
+.}-{3:3}, at: __fdget_pos+0x1d8/0x2d0
Jul 29 18:27:12 testnode1 kernel:  #1: ffff88811f7a2420 (sb_writers#4){.+.+=
}-{0:0}, at: ksys_write+0xf7/0x1d0
Jul 29 18:27:12 testnode1 kernel:  #2: ffff888105b57088 (&of->mutex#2){+.+.=
}-{3:3}, at: kernfs_fop_write_iter+0x25f/0x5a0
Jul 29 18:27:12 testnode1 kernel:  #3: ffff88817438af08 (kn->active#210){.+=
.+}-{0:0}, at: kernfs_fop_write_iter+0x283/0x5a0
Jul 29 18:27:12 testnode1 kernel:  #4: ffff888107094620 (&q->sysfs_lock){+.=
+.}-{3:3}, at: queue_attr_store+0x8b/0x110
Jul 29 18:27:12 testnode1 kernel:
                                  stack backtrace:
Jul 29 18:27:12 testnode1 kernel: CPU: 1 UID: 0 PID: 118209 Comm: multipath=
d Not tainted 6.11.0-rc1 #208
Jul 29 18:27:12 testnode1 kernel: Hardware name: QEMU Standard PC (i440FX +=
 PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
Jul 29 18:27:12 testnode1 kernel: Call Trace:
Jul 29 18:27:12 testnode1 kernel:  <TASK>
Jul 29 18:27:12 testnode1 kernel:  dump_stack_lvl+0x6a/0x90
Jul 29 18:27:12 testnode1 kernel:  check_noncircular+0x306/0x3f0
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_check_noncircular+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? __pfx___bfs+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? lockdep_lock+0xca/0x1c0
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_lockdep_lock+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  __lock_acquire+0x2b90/0x5990
Jul 29 18:27:12 testnode1 kernel:  ? __pfx___lock_acquire+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_check_irq_usage+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? __pfx___bfs+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  lock_acquire+0x1b1/0x520
Jul 29 18:27:12 testnode1 kernel:  ? queue_max_sectors_store+0x12b/0x290
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_lock_acquire+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? lock_is_held_type+0xd5/0x130
Jul 29 18:27:12 testnode1 kernel:  ? __pfx___might_resched+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  __mutex_lock+0x18b/0x1220
Jul 29 18:27:12 testnode1 kernel:  ? queue_max_sectors_store+0x12b/0x290
Jul 29 18:27:12 testnode1 kernel:  ? queue_max_sectors_store+0x12b/0x290
Jul 29 18:27:12 testnode1 kernel:  ? __pfx___mutex_lock+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? queue_max_sectors_store+0x12b/0x290
Jul 29 18:27:12 testnode1 kernel:  queue_max_sectors_store+0x12b/0x290
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_lock_acquire+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? lock_is_held_type+0xd5/0x130
Jul 29 18:27:12 testnode1 kernel:  ? rcu_is_watching+0x11/0xb0
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_queue_max_sectors_store+0x10/0x1=
0
Jul 29 18:27:12 testnode1 kernel:  ? __mutex_lock+0x433/0x1220
Jul 29 18:27:12 testnode1 kernel:  ? queue_attr_store+0x8b/0x110
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_autoremove_wake_function+0x10/0x=
10
Jul 29 18:27:12 testnode1 kernel:  ? _raw_spin_unlock_irqrestore+0x4c/0x60
Jul 29 18:27:12 testnode1 kernel:  queue_attr_store+0xb5/0x110
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_sysfs_kf_write+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  kernfs_fop_write_iter+0x3a4/0x5a0
Jul 29 18:27:12 testnode1 kernel:  vfs_write+0x5e3/0xe70
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_vfs_write+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ksys_write+0xf7/0x1d0
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_ksys_write+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? kasan_quarantine_put+0xe1/0x1f0
Jul 29 18:27:12 testnode1 kernel:  do_syscall_64+0x93/0x180
Jul 29 18:27:12 testnode1 kernel:  ? do_sys_openat2+0x125/0x180
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_do_sys_openat2+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? lock_release+0x461/0x7b0
Jul 29 18:27:12 testnode1 kernel:  ? __pfx_lock_release+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? __x64_sys_openat+0x105/0x1d0
Jul 29 18:27:12 testnode1 kernel:  ? __pfx___x64_sys_openat+0x10/0x10
Jul 29 18:27:12 testnode1 kernel:  ? lockdep_hardirqs_on_prepare+0x16d/0x40=
0
Jul 29 18:27:12 testnode1 kernel:  ? do_syscall_64+0x9f/0x180
Jul 29 18:27:12 testnode1 kernel:  ? lockdep_hardirqs_on+0x78/0x100
Jul 29 18:27:12 testnode1 kernel:  ? do_syscall_64+0x9f/0x180
Jul 29 18:27:12 testnode1 kernel:  ? lockdep_hardirqs_on_prepare+0x16d/0x40=
0
Jul 29 18:27:12 testnode1 kernel:  ? do_syscall_64+0x9f/0x180
Jul 29 18:27:12 testnode1 kernel:  ? lockdep_hardirqs_on+0x78/0x100
Jul 29 18:27:12 testnode1 kernel:  ? do_syscall_64+0x9f/0x180
Jul 29 18:27:12 testnode1 kernel:  ? do_syscall_64+0x9f/0x180
Jul 29 18:27:12 testnode1 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
Jul 29 18:27:12 testnode1 kernel: RIP: 0033:0x7f6908e1989d
Jul 29 18:27:12 testnode1 kernel: Code: e5 48 83 ec 20 48 89 55 e8 48 89 75=
 f0 89 7d f8 e8 48 69 f8 ff 48 8b 55 e8 48 8b 75 f0 41 89 c0 8b 7d f8 b8 01=
 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 45 f8 e8 9f 69 f8 =
ff 48 8b
Jul 29 18:27:12 testnode1 kernel: RSP: 002b:00007f6908914620 EFLAGS: 000002=
93 ORIG_RAX: 0000000000000001
Jul 29 18:27:12 testnode1 kernel: RAX: ffffffffffffffda RBX: 00007f69089156=
ed RCX: 00007f6908e1989d
Jul 29 18:27:12 testnode1 kernel: RDX: 0000000000000003 RSI: 00007f69089156=
ed RDI: 000000000000000e
Jul 29 18:27:12 testnode1 kernel: RBP: 00007f6908914640 R08: 00000000000000=
00 R09: 00000000ffffffff
Jul 29 18:27:12 testnode1 kernel: R10: 0000000000000000 R11: 00000000000002=
93 R12: 0000000000000003
Jul 29 18:27:12 testnode1 kernel: R13: 00007f6908914660 R14: 000055da2ccc80=
c8 R15: 00007f68e001d3e0
Jul 29 18:27:12 testnode1 kernel:  </TASK>
