Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9131F0E38;
	Thu, 20 Feb 2025 10:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740045693; cv=fail; b=HYhH7FV1yJxLnE6fgwaPQAoHi8sGqbkmJrhi6WlOl2usvD1mTVHTpi/xVrXRs6oxtKcQ3ltE5yaQbKwXK3CFOwEmKGuBIrILmA/UNd1G3kJZ6Y+JWnu8rcWbeS5lLT92Df7sdbycYwBqKc+D5dxWJNMF38n62PcRiESyiZZCyTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740045693; c=relaxed/simple;
	bh=25b4acDKSQGypqYqGjKWdaxXt+wahA0pfZcZl3Yz0Qs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HSfSXx1FKKyRPRQdgF5d0IoLMe5XFqwGd/D2ZZHpdLMjfGi0ZydTMqEnlLASIwm/mecDVF+lDiF0epHxqItrYjV5Flh0XUB509JpdlNNvp8XA6M/sokMgGgMCuukgxPd1ThDdkx9enHaVOYF9Rim1QACUecCjAGaiLHxEUvAClU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=LvmegjyI; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="LvmegjyI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1740045692; x=1771581692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=25b4acDKSQGypqYqGjKWdaxXt+wahA0pfZcZl3Yz0Qs=;
  b=LvmegjyIwI3XF6E3DYRT+Ufz9+nWYWnJ8ZzdJ2elfMonWdhKLo8yffDj
   VnqK3iVOO39D19qT6M6Gpf6U1PR4d9UGKr5R5n/FPrxUFCTh7YhwCRDvl
   xmkCS8wExJ8ZqUbeUJfHmc9O22dDP1A99mnGOPOVIyEmTWFVMMGLByuG4
   8mjacpj0h1OUxc2J0eXo2HPaTA6RoXeZK2dL3RwBqHeV0asCJv5822fwu
   6jNGjPCMrQu/tEFH1/1BMERi0v9LlWq08DV+ZBP2a/z4ak2K3NIDEtAQT
   ElPYqxO2DhuZPUX4NuibBhqkqpmqLSUDm6pxUgOp1rKbdshjEVJ5sdMD0
   g==;
X-CSE-ConnectionGUID: 7UWHRhlRTVaRtYAg2h7oiA==
X-CSE-MsgGUID: q9DOUYHYS9yjLz78RgbITw==
X-IronPort-AV: E=Sophos;i="6.13,301,1732550400"; 
   d="scan'208";a="38961232"
Received: from mail-bn7nam10lp2046.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.46])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2025 18:01:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMnJ8OUQCjBD7zRiAEvVVYJJGYiTggRLZ59oJE1Rz/3IrC9dfQxLBlEOWh4D0zC4G3IGd10RlapcEeykg1lFK1witPWpzLVoQFTE3a/lQmwr8Gt/zqi9FyneoAwJ+XSyvw5xn+V8mlek7g8J0qI84CRYe3IWkOpKgbp2UuzjOEAihW9fqQcvecWdINz7pRciAbBaj1c6AAH4NgzgeZ3ab3La91zYZHel7rYTvsLSDOFQn0Z386tdb/xXaAid5mg+iAyASrDr4PAJH83dVpB5ghDpKG9/jTA4BO3ChbsnCSAM3LXdKq2HtsyRGV7CJJXMsWUAXwhxBoXmnz6XlHqMAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcDl7yLVjEmqS6ECdwUAptVi/rkdJzfuB7M/F7bXIhU=;
 b=DUiYQoeQZ+v/54sghY/SWqRQiKvWRlaY1kfiYzq9GA5W3na9o1JuuKRe5qSoyobyttSqd2J+PLIwopDTzneRfJ8ytIy7/Q5UUPfOiDg3rLQG+J/ywMdHxZ1eq+IHpgCjMAkyPA+gwrtM5EIM8C3TFstslhGcjXW27IWFOT+iARp9EhT+V4DGiEJbvUJLjIitNDqIum4P+D39q8QxaZc22Qk4Pkj0q86uRPO4K+pK2whdfENhSsTNWJIIkATmD1PVklLTrTeQ1hZp1oJTRrBKQ63on3Vkv/ZjJLbV3f2JCGjrk3h15tbzxlHL5+KJJLMj8y098Bxnf0jdpDXtzanZqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by CO6PR16MB4148.namprd16.prod.outlook.com (2603:10b6:303:ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Thu, 20 Feb
 2025 10:01:24 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::e087:8329:baea:5808]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::e087:8329:baea:5808%7]) with mapi id 15.20.8445.013; Thu, 20 Feb 2025
 10:01:23 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Keoseong Park
	<keosung.park@samsung.com>, Bean Huo <beanhuo@micron.com>, Al Viro
	<viro@zeniv.linux.org.uk>, Gwendal Grignou <gwendal@chromium.org>, Andrew
 Halaney <ahalaney@redhat.com>, Eric Biggers <ebiggers@google.com>, open list
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC v1 1/1] scsi: ufs: core: Add device level exeption support
Thread-Topic: [RFC v1 1/1] scsi: ufs: core: Add device level exeption support
Thread-Index: AQHbgzoqkjnv1bsx10+FyWCC/0dgxrNP9cUA
Date: Thu, 20 Feb 2025 10:01:23 +0000
Message-ID:
 <PH7PR16MB61967197DC9C471F95536229E5C42@PH7PR16MB6196.namprd16.prod.outlook.com>
References:
 <fdebf652abb4734d37f957062a2b4568754db374.1740016268.git.quic_nguyenb@quicinc.com>
In-Reply-To:
 <fdebf652abb4734d37f957062a2b4568754db374.1740016268.git.quic_nguyenb@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|CO6PR16MB4148:EE_
x-ms-office365-filtering-correlation-id: c29ef235-58d5-4a12-45c6-08dd5195888b
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?cAi6DaWtQXK1dfAVUQOFpn+1hp+1qx2eNpWgAiINXCXiO8pfUDYPhHcjMzab?=
 =?us-ascii?Q?sS+2kDxcUWOuKayL4vg+He4zRkqYtD2ylLrSbbpE4R1GmhM3ymQK57Bal00m?=
 =?us-ascii?Q?iXHK+EchXIy8I2J8crW5u+LTkLhAY5FWsZp71N99xfoOruMvJ66jRPN3FsuN?=
 =?us-ascii?Q?wjWY+T1T2z5U/3eyk7JyW+YvFT/7ORbeTHmzMPdXNgSedHApJCNMXCyR0dUL?=
 =?us-ascii?Q?TOUwgVchPBwrvI6z38pBjTrZbjbQPPNW0D33N+EMjHNcDhfkSiVsTeHAIAvU?=
 =?us-ascii?Q?XZ/wxT/I+q+DTjBhUvbKNsCejOMsBn6UD2W3dr+k7SkTfGu+C6OlJa3g7HnN?=
 =?us-ascii?Q?Kg1dZusPLtlGoc7NRZll2Q48jkHw7ff1qZNyfN7JTOz42dq7miC045Khjg1I?=
 =?us-ascii?Q?AWcRnX9ei6Rdu+tdikIn0o4edZdZ0ekiSisFKrnAQq/MiSaeZsE+hWXSxL3q?=
 =?us-ascii?Q?GMlB5eg/vL71x+UnTMMw2upONqwBC1y6eZ20dK/uYVacehKgP1Z5cAG6vHDx?=
 =?us-ascii?Q?mRv3Gjjdhz53VSXhz//5MeYYT3GyAc3F86w6NS5wBoKZDdqfgWOz/d1tGoaT?=
 =?us-ascii?Q?/Ohb2DvO61oSFp+aIfBUAFEr2jT8ze82rjc3n/tfnbMqksPhlwK9nwnhOkPX?=
 =?us-ascii?Q?f8sk89P3SJetErfk90AgR1jTAH30q2WwJlk/oud9DsZ9anjn1ORD9ofDUSb1?=
 =?us-ascii?Q?c8rcr47E7ByKN37Py2qhAtilGswEKjnuM1AJxv+rdiwpS9o0PBvIQccq7zIS?=
 =?us-ascii?Q?6rMG+ePq/7TomBevxCkyeokskbyl5x38vL0jd5s+9FxOGA7KpJ7hDr606nBk?=
 =?us-ascii?Q?TQsvStsTf6SGX1tozTtnKRs1ZOeCh/XlTZYWJB7KTUdUXJ2opYxqSsX6xwfs?=
 =?us-ascii?Q?y9g2jkh86V2JBSRAPJ+CxRoG9a0KhiAEipQWCuSxMrS2F+3vg1Pcx8IQKeay?=
 =?us-ascii?Q?VEvx8GaRv162OaPq1rSVc0Y/HTNJz8FGwY8PzzEn2+ZXzlSeFHDpEkQ597lk?=
 =?us-ascii?Q?3DVRMWZ5U0hY9T65xGbh1iWsgkKbyCkax8/FGkgbLFqEJYs4v2YN9evczTLo?=
 =?us-ascii?Q?FDys1fRyo/UjMkMSSEpRID2HQkQf2i8Sr0f6yVrntDdYR8xCwFToH/ME4VRc?=
 =?us-ascii?Q?kfnsiSx0fIeM3oi+4kYvVxWMI1zEgED5pph4w5Zm7Rf+din6/yyaZxuhgxag?=
 =?us-ascii?Q?KjqZdbJqRq3a+5HsANUj0ZVWAwlfGepk1CZxiK2VvBDo1O883A1NcwPvjqCL?=
 =?us-ascii?Q?gCNmykUx2TUCHa/genrUP/BkZ74NVL9PWJ7ff7kLWxd+pDcmOMrCxBveUb7j?=
 =?us-ascii?Q?Z6WxcOsOfkXktPwhxmvApAO8nk6mo56Zf26h3oM+vQ+oQmtJIFuvPG+c8Iac?=
 =?us-ascii?Q?w4sj5JxuXbFeos+XTqnxII6y+yNHpwoWoFJRtJi8Hz65nZWrZjIPm3pjsyRF?=
 =?us-ascii?Q?48L+2i9PRSCXPTlYE+6syJVHO+L6c9nU9XmGhTKLAEaPF4ezrRazpw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?9FU1y+b+6eqPUK3z1emGbazHlIU6IOTSZ4FQkT+keir0b4syFOlCmtwIBl6x?=
 =?us-ascii?Q?6hP6+BnMsGoHU/NNUChVe9dUKF7czPQwtF+d7gevBdsStagpmOHQ3n9tgL4Q?=
 =?us-ascii?Q?gYG2j5tkyYSRQZKeW9rJmsnHfcqeABI2h34lcYwh/pQe8JpiZTCRwNugmqkO?=
 =?us-ascii?Q?+En9Rtl6TDLeWuoDnvJooizVP6U7EZEZwoWs3CSwRu28uIGz3lFlDYPLojzw?=
 =?us-ascii?Q?KnY7/cPA3/zveo449mQdJ0F7NKsG1JrPyhuoEOZZKr6R9yYzqHu33Th4lV0e?=
 =?us-ascii?Q?ix/uQ89x28iwoVY4bW+jzZwxQdiwww8/ulzRYV/AF7i2tRJYIWjR7v5M5xIr?=
 =?us-ascii?Q?2w+aGxa6UYOtJ7WFa3KpiA0d/iqQJpJub834nHhtsjA3mefkOeOvQ5DX4kxa?=
 =?us-ascii?Q?0NwKikMJNcaIX6LRUED10u/ZI0XM1h/J9EyH2yXCifJj5QnPEgUq9F/r/DlH?=
 =?us-ascii?Q?WFg6ARIKlIlDujQjKe7PZdBBgNPcXylEsBXze/9tdA9BQMJZBWDSnSo+sgQN?=
 =?us-ascii?Q?A3JQGiL2ZEHMS71FwvuA6JlPRSD2ccC5wEpkIru+Y795PyKKaC+2gIY+Z7pA?=
 =?us-ascii?Q?IdbEMPEsc0zRFp5aUIDJ+24X/jcQq4a55jB+s+aog/NurzopBYcuU6DTT8Se?=
 =?us-ascii?Q?/9dd068EmIWvTBc9/rEMVO2HOOI80mykbSCTxYSxVLMIh5PVF6sEEm47BH3x?=
 =?us-ascii?Q?MXYUpspPtYgi4iWBf2prcwDkwD28zpY17P/XvqEUAy3qyadCN9QXfB908+n+?=
 =?us-ascii?Q?3c40JMUMBR064W65ezrBPDphK0vtiZbFlFFqBLbzkT8oCFqM6ab/ZqMXMI0V?=
 =?us-ascii?Q?wl23p/pOC4KsvuA9iPNP3NtAeg4PTE2OzgE7aeyvfIB7Av/TLihlFRa1gsSk?=
 =?us-ascii?Q?LJnCHfhgLzgZdPjqNzO7aBhzj2DM4vS09zF+gIuPFVDg8ybQ9hF8GGwoDnlx?=
 =?us-ascii?Q?yHC11K4NRZRQ+Sg0LmhsGw7qTRMwW1cOqdaLtoLW+7YAXPGJJI5ljBW21ykI?=
 =?us-ascii?Q?rmTGR2CnL6QLhYsO/9IUwT1eyRX7rW53HFk3NjhtZAF9E6jYtVlwPNEkaMbI?=
 =?us-ascii?Q?DtYtLNxfoz+yPdcnH+Vmd1nVYvg3/Em+EYKNa9CEVyXoIQilMA/aBKzSJQB9?=
 =?us-ascii?Q?odgbC2/tUORXom4xotE4U0G1YRYJisuzBaLJmClGhJNcpSKWtN6NDiElIPK7?=
 =?us-ascii?Q?TUelBvHUn3ohpZc//RDuuIhWqRUP7mKGWS9aO5gG28F5llp90NMp7tf5nokz?=
 =?us-ascii?Q?Uf7cKZjBEnuv4NjCM7lVpAqSSH6APqM//EA3Yxcg9/VyjTOOZbFBOyGfrJCw?=
 =?us-ascii?Q?TvQeWqP53VZFxJWlGcbYYvF1WvaPQdR7Mf2v/RRQEEUxm/CW7D0KBMu2m8Xg?=
 =?us-ascii?Q?+Y6L1SnRf8u+TdqKgFOqMvIuB4asADLS3Fpj8LSLhPfNtyCAyQB8tBaZAqDK?=
 =?us-ascii?Q?BoBXxAm/IA0WmzdAYWmnEmnnjABkbSZehzuoKfq3JHgCkcyMgFsl09WKVwaa?=
 =?us-ascii?Q?TJ5V/xwDv86KNkbXSci2FmHg3Kfc3DNNyze8EgYuuKlkigGtH67BNg6ivboC?=
 =?us-ascii?Q?+7kohGKyLGHE5gEz4qjMBzLeNXKkKboPFPnQaBpp3vWV/5k60sksGrZYs2im?=
 =?us-ascii?Q?TWDVJD5rDlr9InE3JkYFzH7Q9oeYqRyI0c63OgGtjHz9?=
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
	r3rPHdJF5M++LozzhfY3VEb44ALcKPAkndxNgwSUisjbkMcahTL6vWSgjeD2uEte+JGoXHjUuE44lRLl+ddjao2jorHVX659jjdyV5Efo+G7oIEmkHAaZquvKQu0ObFIOmIGEBYP2B4urohiGwH4UUqzfJpRv3Hdms5+HiQ0Vdu//pl6qWRTg5qtm1ktjOFHRpr4iwjF3AWWzs7T0mouTFS9Dh1Yy+MB6x42cYkzZBNBJBQz9zofCM0oRMcVTQaV5yP+/UbfTbg2XcvAut3xzDDXs/4OZ/VKMRp1PWX0uQuAK7LcbKCZXO3N6+ERzDwiluPuXwBtk1SiW+ZkzYhhiWy08WImJT3jPkpsUUKXfbbGjxybrObVSDQfcd29O6aOqf91l6EKmkW1dJi9Zzu+bAEKO8oBCVKeyfXF77r8/2YS2j8yLeTLA8s/9PKLod0Rk4kDW4QJG40NonZafur1FFn/IANTCXU4g2VckiQWirRvUV+QqYrlCKitAXvuZAqyZPCZVBpnHp2IdP6r/aeYbnhAzX/PJpKAl99Q9pVnWSna0pFQ84UKugd63JHFV0/9eSliMDvR5oTiIJEA9lrmFE5VlodG+dXabugY2W1k//QsexhFJkOpujAm2u5GkmkPuqmWyZmjgsGH9GNG5s0hqg==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c29ef235-58d5-4a12-45c6-08dd5195888b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2025 10:01:23.9197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HZdYvTkJxjcwbA1FPQ5wfXcvMq4h15DbRMiteEzZaTAu+TL0Gmquepbj1KJERUTDSgZW6mo/u+mT0R7xZ8czBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR16MB4148

> @@ -419,6 +421,7 @@ enum {
>  	MASK_EE_TOO_LOW_TEMP		=3D BIT(4),
>  	MASK_EE_WRITEBOOSTER_EVENT	=3D BIT(5),
>  	MASK_EE_PERFORMANCE_THROTTLING	=3D BIT(6),
> +	MASK_EE_DEV_LVL_EXCEPTION	=3D BIT(7),
>  };
I think you need to rebase your work - most probably for-next is best.

Thanks,
Avri
