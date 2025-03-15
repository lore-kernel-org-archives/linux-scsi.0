Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945712AD25
	for <linux-scsi@vger.kernel.org>; Sat, 15 Mar 2025 08:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742028407; cv=fail; b=F43ZZhOYwgozqWfHuOCiV/KxE6Mnlq1//U9WZWE+xrkzTAdB/2pAfvte0q3MdYfeczkz3rb9umFN1kh/cj0+9AylRPiOb64YUQwLPdfKfSnSpsdlOPAOcb69/64hbH9xjDgnq1s4U6lagUn7CqT3omRNXSSQ6JcR/D3RTRM7Lmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742028407; c=relaxed/simple;
	bh=WJdgkxv6UHthH0UlmvMNt+PLGu8sueCiHCYaiYFtlBc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c2qMZFK1BF2x/XtfZc4Lt8hM8zT+7T6bGswHe22kzU1YLrVCRcoylp9FqbvzQNwSxPdp4DasqM2//J+SAcZI597zQ8i37/lPw88nALH3U3BiaZjIMgXe6YIim8xbEAAWD6KtmOIzKuIdYE8IqTmfkxrSTotGIy5o8Rvxc+TbrP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=z71zR2y1; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="z71zR2y1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1742028405; x=1773564405;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WJdgkxv6UHthH0UlmvMNt+PLGu8sueCiHCYaiYFtlBc=;
  b=z71zR2y1ZtwUlgFpRiv/tZil1cSmGEIJPblNnDR7QYAKP+N6vF05uusO
   U3AAekFJnHwD9MH75ovGv/LPPB48EVJzPwBccFfy46rpO2lxmN4ulfvCv
   CVRNn2orn2hdGhGcTwBogdAyWKoR5rTvXFZrmG3bBiSOCAqt+PGPxfLyC
   VhgWutrE4TI4ab7Ox/MCwe80fykfgBmsUP+V0vVTeUEfRCmwn4G26Z49X
   KqIXHy/oUXSTwhL0OvCXvPwh2n/Co2zWwFId3PsW/KgVUM9MWvVUHlGOa
   /xbN4CAzVHs8CRswJyEByPlriFEuk6KQsWXW2iNc6FcGGgwFZg3Vw1r+E
   Q==;
X-CSE-ConnectionGUID: b2docV98Rm2I9xSlEvSrzQ==
X-CSE-MsgGUID: iiALXK2IRcmJg8ttyJQ0og==
X-IronPort-AV: E=Sophos;i="6.14,249,1736784000"; 
   d="scan'208";a="48732765"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 15 Mar 2025 16:46:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLIYqUav54wy4bvsTJI6B5sEqAC5G3rPzaobzXTXzjNVbjW8oMMhqN6GY6Pavy/U7H9qGp9vU20K90gpag7OdqQlwUAmdk57PTDMDDeaYQxLopgqgGBu8T7J9lICzvE6K2J7dQx+hf6XrgNRgpX7fQZlbbPnfOstYB5Z1xMvoEtKnmN39Ry0k5ucLEqNnyesjYRXUsLhACuyykCZj1EZlcjAbC7LrtGLrOPNlLpLUB6ojdBIrWd6wLwxHAFmk7OO5MVwX6dBkMcxHSZ4Hp5ccpwwGlLNP0v4Y6kwS3EknTuU6FxBssnahExDQTnxy8MDTuPMc+HcWF6uIvl36THFhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVurBm330l7EkY91e4WDdcNta5p5aFMhdfjCTfjNLcI=;
 b=WkdcXQlwOoRtHCaLgWkKlyA7RPYWZzitmP/x9F0cJAeIiz8rk5ASRpKbUtYzW1PT+w4Cuk1pHMXi0dmoXbF3+y6Zk7LT6QnYo4n5jhL5RwVPuzQAErZU1zsRszc4aeehjMtmtpCyEM5aLN4DetwYHGpmbiYd9l1s1u5wQS9Qj8Yj2RGEaNC08Ly4oZz6Mu3OKtCZ+lNmroDQX13lrErmUatquqdygNg8b1KrBiZQN3XYBurU3g+/28LflaUov2bbhsddfBWMrG9XbrmVWV0/1KKDNkhtaQIwqy582Vi/Wa6fH9VDrJXAruAISs+FXiE5Ygmh5XP8C/ROZVOLsxEf0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SJ0PR16MB5058.namprd16.prod.outlook.com (2603:10b6:a03:434::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.31; Sat, 15 Mar
 2025 08:46:32 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d%4]) with mapi id 15.20.8511.026; Sat, 15 Mar 2025
 08:46:32 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Avri Altman
	<avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, Eric Biggers
	<ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>, Can Guo
	<quic_cang@quicinc.com>, Santosh Y <santoshsy@gmail.com>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>
Subject: RE: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
Thread-Topic: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
Thread-Index: AQHblTPZP+Dh1Ni0TUGVLr7xOkq6grNz4Zpw
Date: Sat, 15 Mar 2025 08:46:32 +0000
Message-ID:
 <PH7PR16MB61963DEE199FA75742C2A47DE5DD2@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250314225206.1487838-1-bvanassche@acm.org>
In-Reply-To: <20250314225206.1487838-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SJ0PR16MB5058:EE_
x-ms-office365-filtering-correlation-id: ec7d68a4-8dac-49a3-5f66-08dd639de304
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?vJvc6L3+OdSmqdV59/T0BxApBokMXBTWgqYArRtI6ufGgTgaJ+VR5Q1bgaFR?=
 =?us-ascii?Q?Bmyz04L/Tmk+3aIvLFhdASyaMvJjhsC97hGke6loTSAJjBMiSqXhhomY+wlQ?=
 =?us-ascii?Q?VPd6mNOT30XAd3O4IQ0pKHVdYqAGeKKTkBoWrflgeOXcQyrIph2v41Uks7fV?=
 =?us-ascii?Q?2MBamc9VwdiEulzpkMtCD1VA33gVED6WKRQHSd3M6Cro9rNgmcKy7akhiOAT?=
 =?us-ascii?Q?SHaDwwc0W4GGX6KEyivM2EAWS1PQqUcPZCLNnra7KSXWQH/ceS/+iCWX6tVj?=
 =?us-ascii?Q?T7uADtqOjA1wyqwjtJp82ZlGjtc6mVG7QNa92gDLwD5G7E0wzkJ8pxo+IQ9y?=
 =?us-ascii?Q?oI8Ddp9MIDzxiCUHv2TiUwpP8QOPngaknA7bjf7ECpoCdfTqQ9h5XsMTubdS?=
 =?us-ascii?Q?/i8aNPyYWd6SHskgwqgk8S3knOc3zPuwKKakXX1mxyUDOno+i7Afg7DqKWoO?=
 =?us-ascii?Q?uGCo6R3cYs9l0X5pPr+bEWkCsQs+IMVK0vepnX/CGUxbVhsaATpXiqHFp5dn?=
 =?us-ascii?Q?bVtru2I/+MtQaqex9YZJL/MEZOzpDeo3LZJYE/wf3IONo9WxG+yiL0dzOsPL?=
 =?us-ascii?Q?MXFg8KtvBvA1biAqtMnS8UhjhUqkn2MNah/AIUn9GcZqYwADU1uw1dv8RX1b?=
 =?us-ascii?Q?O7y7MaAXOowPrfYuN/Q6Y6tMnEPJQ/318hwFighXo/yMhKihrEqk5Oaps30R?=
 =?us-ascii?Q?Vz7/NAGtu2bq2IIRE++WbwOaHCKZVBk6l+idn1GCNMgkTB26qsoQ40bTJ49q?=
 =?us-ascii?Q?ipdGCIpz0BYNF3BvjgxwXd8tiWEq6cYLkhnaeoqVW2ej+bhD1mTo6t6+EP9l?=
 =?us-ascii?Q?3I3zVv8i73H56lRQ1K1AY6dyIzT8QBYC7f2H580hOw+kZCyGz4bXLAfvVS5y?=
 =?us-ascii?Q?nQNIY+rKp8lUSgYw4UflD8bZDueV/MbiYQd+QBZjs3L4wDlZ1740Hu8WEd8J?=
 =?us-ascii?Q?1FFTmhXSxqCJn2Z5VAViMefnrZtrz03AasKqA9nCN30yYiaf+64cC3eRdV5L?=
 =?us-ascii?Q?OA8Vj9krWCXMEd4albit7ohQiahFVsQMygMgjJNuGLHVLUBdgLZE5vjOleyc?=
 =?us-ascii?Q?ZXIskDrbHOrztMIHvoLoo8ePbVlSDAHp51lAm/sDVg/2+r3H86WPX9AKZ133?=
 =?us-ascii?Q?CXME02Ojxm9GBCStoaqR5GkEMzZAMPOB0ugWSA2MOVtXlf6WGhoUgx7MSFiN?=
 =?us-ascii?Q?WxiICJyyZY58q2qAgmZvIHQygngkBhM70uZni4SFOVf5W1Mh9HsfhMwapiIM?=
 =?us-ascii?Q?FfhsHqFHRTEfIdUYp/vTv/B5K8Y6laBD3Ff7I2Jxzjm7OglngvMWU7+TYmlH?=
 =?us-ascii?Q?XsCfsBgrhov4mS2GoOPPpcW/0Gg6+EI9yrWF3oJTArfjkymKZ4TshhdJ3Pkt?=
 =?us-ascii?Q?Lnqi5Udc4brPTATHcR1kHgrPoM9aovaGsi8DSh7JtwtCNCQUKzDto9qGAuN+?=
 =?us-ascii?Q?ej+qCHWsPiBHS8Py1b7Gb+vIPCPwpluN?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?hmnDUexYNi8KQ7TB9X3uTopYNFgHnFAy5LEOikg21OHqR5nNv+Eaz0YBiYqs?=
 =?us-ascii?Q?mfqUbDA8zceaLB1Z6zFo26ts8QosVGh8+m17otSg2svn/2CUcUF1ur6EzCLU?=
 =?us-ascii?Q?GaGTdRirUGYkNDXgsVkBs+jeytWoBkRYU0WOxQmGmq09YCYwqT/ojNfjxuzJ?=
 =?us-ascii?Q?Jtq4YwR5BU9Kh0wDS1rDe4PXmfzS2ieUYdQ+EY7TYcw7cVh9OeG1SD7hAALN?=
 =?us-ascii?Q?ski0cW0sCNbu68PI3DQh8r5XEGijG+z0pH/M16eVlLrYCjhADn8LDE8A09+j?=
 =?us-ascii?Q?TBT+h+Y1+iMy3gWc3QkUkHMRGlFxRap9oTslyOfIk+Sm0rYXKOaUozkLWLyn?=
 =?us-ascii?Q?qVPgToQMmm7taWPzBMYRDNTrweeDEnoM/lzu0620MjLgCsnEIxuA5TPaSYBr?=
 =?us-ascii?Q?CnImvIKMH6Uojz6A2e6YWv/MmtpNxsK8R3UScx4TZU/23CfFiONpiQHgNMp6?=
 =?us-ascii?Q?ydWBHiDydq/vG6qYfxBICw7wIuWihsrYT40BEtGj5GqaKhciagXszbYASVgV?=
 =?us-ascii?Q?aXGRKZmNj8SoMYMt5wu1ZnwTjjprMyWm+nBG3w9DpDKQHUp6iWgpUWqzvgoo?=
 =?us-ascii?Q?EDvSRM39L6Ybr7IQPUGTbpxBNp0AtEdxn7fOywer8Ihdyd0QZ50NdF/xChDa?=
 =?us-ascii?Q?AtJcONRmUzVOwDUuUd/rikjhztHA72L1wSyhCKDE4mwNVTcmIzz6YB6rbVl6?=
 =?us-ascii?Q?oSPnSZVBgGwYfMeVwjPRHv4FKNAqxDZaAgvI+/m5UTyfelMJzz21rOhEPhIU?=
 =?us-ascii?Q?XWh4ZjQLCuS26r9U6LS+mpTFLCcl+vPP9jdviw/1LXROpnA4PLAGmdTdXKLA?=
 =?us-ascii?Q?u2Vw2TkK9y5xh2iV0TbHm9GsiB7jtQ/t+UXgoR34hU8f2nfwszutXbjpsuXh?=
 =?us-ascii?Q?lAWRMnOD/3TOi+7tuE29FfxncLWLIYG0b4/cSHOnq4eILYnAs4mUk2A2pDqF?=
 =?us-ascii?Q?uiS+ua5CLp7WMHEQrYG9QFcT35186Ot64CY+2JA2sHYYhaRX4lHAHlzDTua4?=
 =?us-ascii?Q?NShqJB1m4pGpPGesQlv5vyudg5B5e28/JJ3bN7m4ZpflV6LKtfVpZtuFpCCw?=
 =?us-ascii?Q?KKf8ui2qIMkaczOx52dCZ2k9EB8mSsWjVjWoxALt4p57Bs94XFW99XewgrpP?=
 =?us-ascii?Q?2Va1H5DFU5TvRzRYk9jGCxW+Pv2q16jLwe/HPpi1lDG4Xa7CddQ4T7GHMMjJ?=
 =?us-ascii?Q?qi/29QDsVrweN80aQlnLxRgyD5MvNSsdeabtSsdNkGV0dmFSKGbA7DwrtUDF?=
 =?us-ascii?Q?m5xr3qZEWHcKTgVKXd142PqrvVLTQyFoKedQu/2yoiSjWQL7WAWe3b2eqlsn?=
 =?us-ascii?Q?ocOyYH5tJ4UzY7V94JgWyAQCmK0UGpG0etS/KTlp67KO3jXMm7S+YYyLMjlM?=
 =?us-ascii?Q?mkygZYE2tAzlUWK9MVcRGXhjEZXIZ/btCgy+JBuNr+aGANhmddl5C0FZFza9?=
 =?us-ascii?Q?i07JSUMdTJ0iMZWWMZ1KaUmDtsdk7OHUz/kGoQFS7qnud6wWP1Xn7AnfkVAE?=
 =?us-ascii?Q?8cZU/9U/eNrjBtMFZTwXtDTh+it7R/V8yteuoE1XlEy7Dj4hfkIEkHaW8eC+?=
 =?us-ascii?Q?74ddi0MCGJPMc4Bo2AH0t+XjhXFRkuBwUTTafCMUuBsFFx+ToQ4vvq455eZE?=
 =?us-ascii?Q?SVs7zu4gsjnglIITUMeDHqE2BnoWNsOzoqm6gK4skt8x?=
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
	TjSdsWa4ecn2zRP+s1o1S+RGH3+Z2MwicZ07T8Qjc2QgnH6OnBJEJFQhllbz3jl9Vqdnf20lu13qbc56E6vpYJ+M6c5A8XdiMJ2UQpwYB/qNjplgc7Fu36gzyLd0i3863o41FU/f0oPX6a17wcmONIsO6DZTWp2S2b4+Hti9J6FWxBTrOXZB8J82CjHzKIdKmn2FPstMo74Aj6FsDczEasGOiM+SFFULIsW1mwV1cTYJ7DepuHtJQ99sijegFzOAhLbXYfi0+Btt/DHfYrBnq+X8d7pMcFnbmhVvxsAeDDQqqST+8UbT+hlfQV7HEzaHJOtlem+UzY8JsdXRV6Uy+uZsoYCFlyUly/cntGvBnnwfxY2hVjf57u4lw15E9aGajw+ShRxm/nwHFnPjJ51mNfdszORfmjug093P46ZTCtgcs5QbryIQ4H90vn8iswu1bYogorHMPLIc7DcZ96GovUL54FjlUIg3tJC9W6a2pRXr86WLXdhVVh0yvfG3Zs46EPfKBZBo5dLBZ1Lt4cDTyaGnw6M1RUi2g6FDqBhUAyFH1xEFSCYYEaWbWqAWREOqfDBPD5PfR5QXA9OmmU0s+fXvJaYi1NhPHw6XwcdB7uhS58I6Po6pM8a3ikFaevcfsx5vgaWTH9/N0VNYJbDG2Q==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec7d68a4-8dac-49a3-5f66-08dd639de304
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2025 08:46:32.5870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UJL5OjVq/QpAivx0YpLL83Ae50jih6Zeaq8nAUZGUw/MBAutLYq8jYxFjq3RQMUZsWDN6OZK8O61EabQqzF8DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR16MB5058

>=20
> There is a TOCTOU race in ufshcd_compl_one_cqe(): hba->dev_cmd.complete
> may be cleared from another thread after it has been checked and before i=
t is
> used. Fix this race by moving the device command completion from the stac=
k
> of the device command submitter into struct ufs_hba. This patch fixes the
> following kernel crash:
>=20
> Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000008 Call trace:
>  _raw_spin_lock_irqsave+0x34/0x80
>  complete+0x24/0xb8
>  ufshcd_compl_one_cqe+0x13c/0x4f0
>  ufshcd_mcq_poll_cqe_lock+0xb4/0x108
>  ufshcd_intr+0x2f4/0x444
>  __handle_irq_event_percpu+0xbc/0x250
>  handle_irq_event+0x48/0xb0
>=20
> Fixes: 5a0b0cb9bee7 ("[SCSI] ufs: Add support for sending NOP OUT UPIU")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>=20
> Changes compared to v1:
>  - Call init_completion() once instead of every time a device management
>    command is submitted.
Shouldn't you now call for reinit_completion now?
before wait_for_dev? Or at ufshcd_dev_cmd_completion ?

Thanks,
Avri

>=20
>  drivers/ufs/core/ufshcd.c | 25 ++++++-------------------
>  include/ufs/ufshcd.h      |  2 +-
>  2 files changed, 7 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 4e1e214fc5a2..3288a7da73dc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3176,16 +3176,10 @@ static int ufshcd_wait_for_dev_cmd(struct
> ufs_hba *hba,
>  	int err;
>=20
>  retry:
> -	time_left =3D wait_for_completion_timeout(hba->dev_cmd.complete,
> +	time_left =3D wait_for_completion_timeout(&hba->dev_cmd.complete,
>  						time_left);
>=20
>  	if (likely(time_left)) {
> -		/*
> -		 * The completion handler called complete() and the caller of
> -		 * this function still owns the @lrbp tag so the code below
> does
> -		 * not trigger any race conditions.
> -		 */
> -		hba->dev_cmd.complete =3D NULL;
>  		err =3D ufshcd_get_tr_ocs(lrbp, NULL);
>  		if (!err)
>  			err =3D ufshcd_dev_cmd_completion(hba, lrbp); @@ -
> 3199,7 +3193,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba
> *hba,
>  			/* successfully cleared the command, retry if needed
> */
>  			if (ufshcd_clear_cmd(hba, lrbp->task_tag) =3D=3D 0)
>  				err =3D -EAGAIN;
> -			hba->dev_cmd.complete =3D NULL;
>  			return err;
>  		}
>=20
> @@ -3215,11 +3208,9 @@ static int ufshcd_wait_for_dev_cmd(struct
> ufs_hba *hba,
>  			spin_lock_irqsave(&hba->outstanding_lock, flags);
>  			pending =3D test_bit(lrbp->task_tag,
>  					   &hba->outstanding_reqs);
> -			if (pending) {
> -				hba->dev_cmd.complete =3D NULL;
> +			if (pending)
>  				__clear_bit(lrbp->task_tag,
>  					    &hba->outstanding_reqs);
> -			}
>  			spin_unlock_irqrestore(&hba->outstanding_lock,
> flags);
>=20
>  			if (!pending) {
> @@ -3237,8 +3228,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba
> *hba,
>  			spin_lock_irqsave(&hba->outstanding_lock, flags);
>  			pending =3D test_bit(lrbp->task_tag,
>  					   &hba->outstanding_reqs);
> -			if (pending)
> -				hba->dev_cmd.complete =3D NULL;
>  			spin_unlock_irqrestore(&hba->outstanding_lock,
> flags);
>=20
>  			if (!pending) {
> @@ -3272,13 +3261,9 @@ static void ufshcd_dev_man_unlock(struct
> ufs_hba *hba)  static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struc=
t
> ufshcd_lrb *lrbp,
>  			  const u32 tag, int timeout)
>  {
> -	DECLARE_COMPLETION_ONSTACK(wait);
>  	int err;
>=20
> -	hba->dev_cmd.complete =3D &wait;
> -
>  	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp-
> >ucd_req_ptr);
> -
>  	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
>  	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>=20
> @@ -5585,12 +5570,12 @@ void ufshcd_compl_one_cqe(struct ufs_hba
> *hba, int task_tag,
>  		ufshcd_release_scsi_cmd(hba, lrbp);
>  		/* Do not touch lrbp after scsi done */
>  		scsi_done(cmd);
> -	} else if (hba->dev_cmd.complete) {
> +	} else {
>  		if (cqe) {
>  			ocs =3D le32_to_cpu(cqe->status) & MASK_OCS;
>  			lrbp->utr_descriptor_ptr->header.ocs =3D ocs;
>  		}
> -		complete(hba->dev_cmd.complete);
> +		complete(&hba->dev_cmd.complete);
>  	}
>  }
>=20
> @@ -10475,6 +10460,8 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  	 */
>  	spin_lock_init(&hba->clk_gating.lock);
>=20
> +	init_completion(&hba->dev_cmd.complete);
> +
>  	err =3D ufshcd_hba_init(hba);
>  	if (err)
>  		goto out_error;
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> e3909cc691b2..f56050ce9445 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -246,7 +246,7 @@ struct ufs_query {
>  struct ufs_dev_cmd {
>  	enum dev_cmd_type type;
>  	struct mutex lock;
> -	struct completion *complete;
> +	struct completion complete;
>  	struct ufs_query query;
>  };
>=20
