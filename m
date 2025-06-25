Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8B91917D6
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 11:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.152.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750851476; cv=fail; b=hPZZZX4gWRi/yoGykMyPMBMG/8q6g/EjouVqN8J7abq1PN/Idsn3mOoQ53Bl4fYfJdomUbSY9j0gPTmJebCuPjHYNSDmpuM3HNRulTgAhWLItx+P6lyZVKLvL+i/AIKtrN3bWvMglBoTErbomCz2UuQGdceupKIu3dxlD11d1X8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750851476; c=relaxed/simple;
	bh=D6YEvnNnMYB6d51iw7cI4OgYr4BIpftJNN0lpMTv9ok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TS82ULNZBzlW/h5qWmhYASWkZNprKuM9QgRLgvw6TlMlLMVe7sWf32zf8kyp8pVjBiVOJ15JDmFgN502QvLoxURgPOkUElmEnaEq+A+9oIWu/eHm0r5+jeZhnjPvE9pa3LqzL7W0LS/gGT1l//pvHsD35pRfXLqKDVVxt39Qq1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=EXjCmxZJ; arc=fail smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="EXjCmxZJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1750851473; x=1782387473;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D6YEvnNnMYB6d51iw7cI4OgYr4BIpftJNN0lpMTv9ok=;
  b=EXjCmxZJb70SNIB1U9TckbFEvdCxWXh/jx3LFflLy7NXbOmZlmq8Uduj
   3FG904BhJXwFpdZX40QT/R+y0SjRjXfUW6ySDRd7AODsj8Z+/iqhr1PCH
   75SP+2Jg4alItTZLYgLKoP/LDcx7kU5JyPmb2O/sPSG1Z5lWiswM/gyu9
   RDp+RktIzWM8/6T/ZU/+DJ0XqSeBNLBfrISwRqI6WBW4Z0ugfSQtuABB+
   dF6Wsj7hj8gxnsp1hK6jx1vPBQO97+OUtUvGvonXNJu++1I6RchR12TT4
   uPQL2NlTSyh/qVBQLe7mMMnjwbfSDBWiycbzdGkYBKtbalILGhMA24XIH
   Q==;
X-CSE-ConnectionGUID: KDmggXK0Squ2bXRMk6vNJA==
X-CSE-MsgGUID: DhBbba3VTeKYOYD/xudEjQ==
Received: from mail-dm6nam12on2090.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([40.107.243.90])
  by ob1.hc6817-7.iphmx.com with ESMTP; 25 Jun 2025 04:36:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7q81f4HwFG9k1PKQx2zIePdQPKNlVuylcCNJBYyOmB2cDUqnvzgwiGAOtRj45TYe2MgC+vMQaycEAkE1XQxcVpVxtqljTToFxUSJLts7mL1pBX2L3uLm+ZpHCip7D01E6h56ZKk/S+tw2b5TYF3m6xiiaTwoekM6OkNKtV5DaOmRW2DzPPNmgb5ntA3HF+wlvkc8/8EfytupNkihzbhPdfsvzwggexRawn2QUOC7+FjFBg8Nk/Gk09rn7MocP68REVn/hOW8LMaCWNT3lEnrL+7uGBsUs+aD5R3mSX5P/jjkYQGQQmcpNMc0vDcFazrd+A0IzQrlXyhiWkIT6DS0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6YEvnNnMYB6d51iw7cI4OgYr4BIpftJNN0lpMTv9ok=;
 b=K/+x80dAe75nklq04IiAmZR8swhyfh2Xq8jvjeoEA7b8RTjYloY57KjDc8TFSrjmdsDJNZoqzfrHyqsNHV+s+tvOtQnmqbirGT5pPjgYmFhcRpXFlrL5aPerdP4uQchTn4wvNjwTiXcx/OBbrnBKjOFyDWkjt0hPtJyYn842mWKxZSIl9y1lResfaw4ppSJ2bje+yptnez93APnK3NY0+PTPMx7Bme1SQULBuopdAE3c/zfctl/JoORFjLpauMMpcuARnjMIwiPZvMWgroF92Ml5pPU6yzHNUinFFcEagSStaB+nqUsR9n/pqMiIBRDq8IlyuOKBy8DlXWAGG84orA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by PH7PR16MB4772.namprd16.prod.outlook.com (2603:10b6:510:124::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 25 Jun
 2025 11:36:42 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::436c:8204:2171:b839]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::436c:8204:2171:b839%5]) with mapi id 15.20.8880.015; Wed, 25 Jun 2025
 11:36:42 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>, Bean Huo <huobean@gmail.com>, Huan
 Tang <tanghuan@vivo.com>, Peter Wang <peter.wang@mediatek.com>, Avri Altman
	<avri.altman@wdc.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Ziqi Chen
	<quic_ziqichen@quicinc.com>, Keoseong Park <keosung.park@samsung.com>,
	Gwendal Grignou <gwendal@chromium.org>, Stanislav Nijnikov
	<stanislav.nijnikov@wdc.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Thread-Topic: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Thread-Index: AQHb5acnYKFFjqSKIEeGm1M/32S02LQTmMKAgAAMyoCAABl0EA==
Date: Wed, 25 Jun 2025 11:36:42 +0000
Message-ID:
 <PH7PR16MB6196C01BF33CFC6D7C56ADE8E57BA@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250624181658.336035-1-bvanassche@acm.org>
 <2025062523-cheesy-engaged-88e9@gregkh>
 <PH7PR16MB6196ED0C10AB89377E33F18FE57BA@PH7PR16MB6196.namprd16.prod.outlook.com>
 <2025062520-glitch-jacket-c607@gregkh>
In-Reply-To: <2025062520-glitch-jacket-c607@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|PH7PR16MB4772:EE_
x-ms-office365-filtering-correlation-id: 20f5a76a-4991-4444-05eb-08ddb3dc8e9d
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?IkzW3hkAbfcDPXXd06n5RhFAcspsowfqCuv9fxctrvFy320AmzmKJXDY7zx8?=
 =?us-ascii?Q?3AAnOcpTwTfL7Vke+Ih7dkQdeOTvd/XTwOr/vEqXqG7u28O1EZtnJhuVrJLC?=
 =?us-ascii?Q?gPqZaHKD2fbT8uVxfDYM3BHJOAAfrrKxwbJoZgQ4KXIHGQfhbIlINJ5o4UDz?=
 =?us-ascii?Q?85F5K1OSQ/ReE1yqOdUwjYPsg+pFrb8LWeGIOND9eSRUU8GSsnlG1CgvnIv4?=
 =?us-ascii?Q?BzMU+KJE2Cjnni6I2wn8xrMpyTsZDg/NRqjpdr/eHPrDynQssDaEdkaHWK9Z?=
 =?us-ascii?Q?eZrTvpdt80OVJADXGimA49mkBd1Dn8JI77jCflaZsckHrsDpkSREPGzSEMVS?=
 =?us-ascii?Q?cs0vd/8btp/v3JIdgAXuTWjfgUU0S9qO8S5x+ndP+7PR1sqBYtNXBe7sJdLC?=
 =?us-ascii?Q?8mK/FKZClvTnTJF/ysIMSm/PE9MSY4OhKJVs4+S1nhHseciU4sjper66rfbL?=
 =?us-ascii?Q?ns6EwWUcG1wPEUAVML3KSHeqFR1Eo3i5MqeK2vKcSozVjRvR4glj5HxUQKPh?=
 =?us-ascii?Q?g9LmEfig/dotYioZscLRSpYG/QuFjVSileHxpD+GHOKjCgblaZ56r9m/q/yy?=
 =?us-ascii?Q?KjqCeDM5Be2Fhd5/zOAegYDpYFs258YGkrRvOdVVeqlpzdOgXW3A0N3VXSsI?=
 =?us-ascii?Q?OeCZqBVjPaK/0IyrPV+Ouo7LNGDgOg4yJkZiGf3xGF7ALjkD5dCt/xczn8XR?=
 =?us-ascii?Q?jb0yV234ZItqPynScRwGbjxwYzEweNGk93DUgB9c7mZYmVi0AiQo1RrJZ9Tk?=
 =?us-ascii?Q?IxqSX+qTGy91gY86ldYsbw6v+Z6IlfV52m3lofF3e2/1DvacespPUKcmzp3s?=
 =?us-ascii?Q?ODAebFv6CQXtQbVhfxHBpjq8G5W8Z9Tgm9XeTT0xJoIc8Sp/TumWFc22I3sU?=
 =?us-ascii?Q?oN2wN8zDwjrbNSRwk2yQF2RlOiloUeLb5i3WvrTLXLodZEBEdj69l5Kegzg/?=
 =?us-ascii?Q?L+ax5TBRgi0wHVuK1FOAigTZfuHZaFiYKhqlkz9YHY2CoSEzbZo/QVUry9FF?=
 =?us-ascii?Q?0k7nii1PvxTbeL5ClM6kjEclRX5urjj62ABAY/0fQ0G9hPnQ6H4p5QD4DA3b?=
 =?us-ascii?Q?PVG20e6qbOPprG9Zp7WbOo9UMbPBy9Q7GDH7V54gkozztujmOhHQjHEfzjwC?=
 =?us-ascii?Q?a4Lk3+mA/AaoWOjst7tpX+XETDABVPE661X4fh2lo2aZj2x7+lek1Wq4AVz3?=
 =?us-ascii?Q?n20W8kfyWKuDrZu+DGOxs4SxRtbx+X6rf4f0OKzpEpmUwKVmcAvUW6FeIODk?=
 =?us-ascii?Q?OXylFtBYW7HxmaFDsANCezzK1iRIL5OYgGe8YPu8Ac05K7nkydtyMMdTYoWt?=
 =?us-ascii?Q?uukraFsXjRUdyfmmp0NQNEfCN64tj0PiVdKRxuF1Z2qhRRjcGVdWCnfDZzD8?=
 =?us-ascii?Q?/I8MFImtnGG6l0wTqgfgeNB3MmEaqFlLrfTfSC3jhDJAKn+38GUBRB9mCxry?=
 =?us-ascii?Q?4HmbhAWAG+eTgSnQQsl1dpC0TiA4RLv6s0GU/UsmmKeQMquapuOTQw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?wWpl8DRoHWAkHZp0kguk69mSTAnLx4LlUZT8qRn8KoEKuWzmdy2GnC3947mD?=
 =?us-ascii?Q?kZlocAltJWJuxlc/mMfZU/ue0hUh/MdNWXGF2SEkSkQFLriflVLKVF2v1KYk?=
 =?us-ascii?Q?mOCly8/3HU5Pur4aZOlxWLKazPRcScgp7lCWKUFSprN3CEREPs6zQp2RBA/w?=
 =?us-ascii?Q?UMLrgAAyT7icJYd4Ji+6l8LWQtPeHcVdhmRPBUNgN93akZ4w3kx4DVsQ0WzZ?=
 =?us-ascii?Q?xfJ6rSFl01vCdahtP7rmLRx8DexDd8WT5ucTAjts3t3xdj/xj1DbDkSRjqbR?=
 =?us-ascii?Q?7UXPwpS4v2j5n4qWUgwKqBd5FiIarUjb3P+64Y35o4lita5MKyD9Z2BaW8Lk?=
 =?us-ascii?Q?qJYFvWiImJKs40HzqiU/1QTn6JA0YDG70z9yfLwwZdjOBXiJla+Qh60p3wEM?=
 =?us-ascii?Q?n30iYkh9ARoKwKEtwl4cUtqMzMml/0SqNLmucH1wDzZHRgdSQX7iyaK49Tku?=
 =?us-ascii?Q?Ac6O92Ui9V/+nKJz3OlRI6/Iehj3hjNcHAUssdlaNiPLPhiWwIDAR4vnYNWV?=
 =?us-ascii?Q?aAu0M9LR6uoYP2eB5Cgj/Unf+2Kb3YG1mYEF29JUCUkoeH0AhrSavewYPk8j?=
 =?us-ascii?Q?UA4+o1mHlQfMSTRyoJGPs4jca57MJiRh6S9oL9EMtoOeSDCWBSh/XJhqsnpA?=
 =?us-ascii?Q?F+RxEbWrxkEVcgAEwbnHvW8WSxQbPakaLfA5Wzq8GvevgLKOk1yubDA3f8CA?=
 =?us-ascii?Q?Jwhr0+6S5dgxyI1jLLTQ4QG0OEZNusCKOmtl3iidnOIsrc4WKHisMvZXIdix?=
 =?us-ascii?Q?h+u1MuEdYzZwmnCAKMqhaJoe4yHaBN7LxytVqey3CCXllAA72rc8ppG3ghoC?=
 =?us-ascii?Q?nBstmzqcLSVk3aBWGL9yzAaq0fG/4h6KJRJZIWyHZPFeLfgDuGspmBb2wNBi?=
 =?us-ascii?Q?mOVFShdws6CYxKLq025+Z8edQnLDHIFf+jPb54erQDO0Rw/9XovDjuUoADf5?=
 =?us-ascii?Q?iLKhT6UyT+vUrGATVPDjotiIpkXy+CotPE/t1sP61jijxQTQa2wzGpgQAtx9?=
 =?us-ascii?Q?q9+nKkBQj+vhNQWB1wvk9Msw4oIKv8KeAWH+Q8yZdgDsUUlldf97wv0VRD7N?=
 =?us-ascii?Q?4hN2UY4CTmT49YaRJnPxLDAZ6mEST6WORhSq+aogAwmDrc8TS5ni6kzzg0EH?=
 =?us-ascii?Q?f2TodtkAozrVd1Eb2VBa0TA3qL7jmw9QhAZtZUxIcP8QzWW+W9t0i7O67/4y?=
 =?us-ascii?Q?pJe8HaJjWTzRmvdFu0G/nvwDky4GW/xmfSo2VJJVWgJ9/7vGuoiXnkU/W2jF?=
 =?us-ascii?Q?rohwnpfVbnNhQsc6mK8aE5o/Io21TP2cPWNWFc0II9hLf+3OPh3ZIIJH8Fr2?=
 =?us-ascii?Q?9kaCIa+Jhc2jHR5WU9r23ivloDN3nsl//Nq0lawzWLb4oFeXUINdpUp9LsfX?=
 =?us-ascii?Q?/FpfuVYTdSU/MU374ri8y0H2+74QGEGjedp/sr6OMqClo8AhgxIaTzgRiS4I?=
 =?us-ascii?Q?aijTIqN3sQTmtjIUmvg40ZI5gqh1KdoU7jA/x3Xmn/Exws4Edq0m8JbhneHv?=
 =?us-ascii?Q?SSQ1pcUr8i9TpHVReyqv6OUDlUorjCTJJkt9fQcL+ITWWuVPw+RNWN+CJdmH?=
 =?us-ascii?Q?b5n2wAVO4KMwbAhgnLSR7X1LZ/y1QgWeaZIurovT?=
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
	nRaGg6kko8/TYjLFgjFTx15aFa4Kg19eiSlTMwjDojEAJmuN9sdrYRuJELsBzZ82LdfoXhnhU3X6YWoHFBJAO6sMU1A9R8EpctHMqyFK424WKylI06wntZGbi2sMRd+e9ArdQTRiOtQzs/IzmtE9mvaX+93Qur09yFKRBihG9A7iv5QI6CrTrbZcVUcrWA+0Bj6P0xEF4T8j4/YKAKT5Oz6f399S5MYj7VIOsGrvAxb86PHa2HCt51mbPGRKC4W7a1XtrgzI3MhgkfK2cFRwVhPyzrhjLeQZIsyWLWgvhyNKIpt916IJh3hcDvC/4ChVZBdSX+c+nE0ohouuI8LxwPlhAE+NOD1709sO0Hng08ojb09hvl1A1z1NMBJKLghuHHCR7XVuDO7hZdslB1aXFBUXlpwTiic0bTRywtY40dQ/1MU86giA72ZykEdYytdZDR+mbNyPMMhKL/NWn/TJYdbO4fzFLGkvyDHBLDPeNuJokrg9qpdawQvCzruXYqmN+sz9dQ/sZlBxIm8q/M7NrhtsDBxgfbRALuMUwJ1MnzlTkgonEsQSiTM5qCXrjqEdPZjE4j3WohHppT/jL+puLli1APa7FMWIOjpdMgbRMzU/YTlxPGXDaURWivs1arY2XwNaukqnV5gaSz89PqOPKA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f5a76a-4991-4444-05eb-08ddb3dc8e9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 11:36:42.3015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tWISBwT8bPzQhXrJ413L98FCsG+3diaFoxYORYkpe35NA6iHtcY1L/uArFNDcqQoaIqA/HySp01D62W0QIFyXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR16MB4772

> > > As you are changing the name of a sysfs file that has been in the
> > > kernel for a very long time, what userspace code is now going to
> > > break that was using the old name?
> > AFAIK none.
>=20
> So if no tool needs / uses this, why not just delete the attribute entire=
ly as
> obviously it's not necessary :)
We can still read it manually should we need to.
We do that from time to time.

Thanks,
Avri

>=20

