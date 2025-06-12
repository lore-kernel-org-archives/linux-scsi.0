Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF9F1EB39;
	Thu, 12 Jun 2025 01:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749690990; cv=fail; b=VQ+JpIkmRW6cXlTaSsXOcvB3oEC7ApAmdp2gaAfwgOvX9aw7dVF/d59Tkf5S7eJjgn/tgfcbLZPj5F8qW97x2gzPQPHb6KGg+jHgHsdcgaOBaTPHjmduboCGaKyPgk1Cw3b8d0kVrtKMt/BjXkRYz/kwWbaer1/rTMIPVakiuYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749690990; c=relaxed/simple;
	bh=NMFGBg97Tzh31oUo0fWzy2J6B0PoVIUhDF83etLW9Rs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WE5ED42g6dV3ya+6O00CVpjV4DhNWdNPQVGZwtKmT2YlhW1/Ivmi0+EY4JtwtfKbz6tLu97b1uev2s1FznHTlouvcAagjmhD2aLeM9lRiDTsKb2Z5ZPS35lys6kCC6eGuiYd0JIxJ7oMlJRgxEsH/TeUCfF7nriMsc6W1D5WOnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=HesrpYoB; arc=fail smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="HesrpYoB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=823; q=dns/txt;
  s=iport01; t=1749690988; x=1750900588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NMFGBg97Tzh31oUo0fWzy2J6B0PoVIUhDF83etLW9Rs=;
  b=HesrpYoBYqNyuEudvLShq8yvZBhFNrXIblAhU8S0K2/XZtZE2dCKM/Oe
   Wpmd78lF49nOpzOa8DDJeJL5te2r5oBpilxrcLzM2l07jxu4ofixZJX0N
   MZBh7liNkg0d4HuCDdnJjC07zp6TwfJvmEUhjmSaZi8DXgCRpd2U1rZeq
   TboAitYQ5TWPkj+l9K83r61Pjgv2ckne33T+L//lHs7G6icpNuk04nIUl
   BqKqn1q3qWiGySHMHJAoTSuWpVn2aJZWeJmvbYkLU8wfSr29tCKu44B6o
   M7GDtGEm2VE9qZAOCVoIVP8Iq+q4BwJGWz5Y0SzWPGr/PaA8bzdbiU4zW
   A==;
X-CSE-ConnectionGUID: FX682gAVTj6O9mvFvhJHXg==
X-CSE-MsgGUID: OyUgq7+GQ6itP/Idh+faaQ==
X-IPAS-Result: =?us-ascii?q?A0AoAAAqKUpo/5UQJK1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEaBwEBCwGBcVIHghVJiCADhE1fhlWCJJ4WgSUDVw8BAQENAlEEAQGFBwKLZ?=
 =?us-ascii?q?gImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZaA?=
 =?us-ascii?q?QEBAQMSKD8QAgEIGB4QMSUCBA4FCBqFTwMBpCwBgUACiit4gTSBAeAlgUkBi?=
 =?us-ascii?q?E8BhWyEdycbgg2BFUKCNzE+hEWEE4IvBIIkRFKNFpQIUngcA1ksAVUTFwsHB?=
 =?us-ascii?q?YEgQwOBDyNLBS0dgg2FGR+Bc4FZAwMWEIQEHIRihEkrT4MigX9lQYNfEgwGc?=
 =?us-ascii?q?g8HSkADC209NxQbBQSBNQWYAYV6gUSWebASCoQbogkXqmGZBKkNAgQCBAUCE?=
 =?us-ascii?q?AEBBoFoPIFZcBWDIlIZD8l4eDwCBwsBAQMJkhQBAQ?=
IronPort-PHdr: A9a23:20d+MRDcIsk4UQzzIm8AUyQVXRdPi9zP1kY98JErjfdJaqu8us6kN
 03E7vIrh1jMDs3X6PNB3vLfqLuoGXcB7pCIrG0YfdRSWgUEh8Qbk01oAMOMBUDhav+/Ryc7B
 89FElRi+hmG
IronPort-Data: A9a23:Y/yZha8e4OKFJwbggPUADrUD6H+TJUtcMsCJ2f8bNWPcYEJGY0x3n
 GoYWz+GP/uLY2T0ctx1Ot60oB4GupaEz99gT1Bo+S1EQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E3ra+G7xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qsyyHjEAX9gWMsbDtNs/nrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kYDdNIoOleP11Mq
 9tJLS4jcBChp9K5lefTpulE3qzPLeHiOIcZ/3UlxjbDALN/G9bIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2cMnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZC2YIqLK4zQGpw9ckCwg
 XP78H2mQT4jat2D8X2k/nLviObGpHauMG4VPPjinhJwu3WXx2oOGFgVWEG9rP2RlEGzQZRcJ
 lYS9y5oqrI9nGSvT9/gT1ijq2WFlgATVsAWEOAg7gyJjK3O7G6k6nMsRzpFbpki8cQxXzFvj
 wXPlNLyDjspu7qQIZ6AyoqpQfqJEXF9BUcJZDQPSk0O5NyLnW35pkunogpLeEJtsuDIJA==
IronPort-HdrOrdr: A9a23:EfDb0KFK+mhTTzUCpLqFp5LXdLJyesId70hD6qkvc203TiXIra
 CTdaogtCMc0AxhJk3I+ertBEGBKUmsk6KdkrNhTItKOzOW91dATbsSobcKrAeQYREWmtQtsZ
 uINpIOd+EYbmIKw/oSgjPIburIqePvmMvH9IWuqkuFDzsaF52IhD0JczpzZ3cGPzWucqBJbK
 Z0iPA3wAaISDA8VOj+LH8DWOTIut3Mk7zbQTNuPXQawTjLpwmFrJrhHTal/jp2aV5yKLEZnl
 Ttokjc3OGOovu7whjT2yv49JJNgubszdNFGYilltUVAi+EsHfpWK1RH5m5+BwlquCm71gn1P
 PWpQ07Ash143TNOkmovBrW3RX62jpG0Q6g9bbYuwqgnSXKfkN/NyNzv/MfTvIf0TtngDhI6t
 MP44tejesPMfqPplWk2zGCbWAbqqP9mwtQrQdUtQ0fbWPbA4Uh97D2OyhuYcw9NTO/54Y9HO
 Z0CsbAoP5QbFOBdnjc+nJi2dq2Qx0Ib1y7q2U5y4WoOgJt7ThE5lpdwNZakmYL9Zo7RZUB7+
 PYMr5wnLULSsMNd6pyCOoIXMPyUwX2MF/xGXPXJU6iGLAMOnrLpZKy6LIp5PuycJhNyJcpgp
 zOXF5RqGZ3cUPzDs+F2oFN73n2MS+AdCWoztsb64lyu7X6SrauOSqfSEo2m8/luPkbCt2zYY
 fEBHuXOY6VEYLDI/c84+SlYeghFZA3arxhhuoG
X-Talos-CUID: 9a23:I5/8VGwsXLAYPW6f3ZN/BgU6Kp51KHL08kvSfWjpDHhHVr23aW+frfY=
X-Talos-MUID: =?us-ascii?q?9a23=3AF/3/7Qy0ADCiEec3glSuZMG3umiaqIO/NU8UztY?=
 =?us-ascii?q?pgpeFKRQ3Gjudzzq+S7Zyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-12.cisco.com ([173.36.16.149])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 01:16:26 +0000
Received: from rcdn-opgw-2.cisco.com (rcdn-opgw-2.cisco.com [72.163.7.163])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-12.cisco.com (Postfix) with ESMTPS id C0A2C18000154;
	Thu, 12 Jun 2025 01:16:26 +0000 (GMT)
X-CSE-ConnectionGUID: smotTEW4TtmSmxyxRB3joA==
X-CSE-MsgGUID: tCkLHNNjRfKwC6eWDFf6MA==
Authentication-Results: rcdn-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="33702867"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by rcdn-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 01:16:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m/HWm93Vh9AOXi7S7tCDWb0GOkZeXayay7ch3+PDvI74lYx3O5pk8HXpTKOzLsF8mbz4Fxla6R4hGvlh8sqYdZnqLN3ogmuTgqZfZpwaE96EyGe0tBuluQTqxMdD9rH4Is+Zvcy9kG3UGyAj4fBNGTvERpXYpcsxELLF38Vcr7fwh/NP5ix0Fj8a1Q3P2WowUhnD5XPXzBtALPYbiEbexiOgce/yXNmRRpmTwzq2TfWALc9at7JEpNMDUwEG3tz0CZhdIflXB/8+xQVIEkyKjR2MqJ/Po3z+6s7XAUQDHwQSWgCtN7zhF4NEk7/+a8UsYWvwVZeGbtbFrj/IloTWng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMFGBg97Tzh31oUo0fWzy2J6B0PoVIUhDF83etLW9Rs=;
 b=hv7U0l+nQ0BO8CppqHetvKVnEUW3wHGbWSndrluKhaJlSnBKUx/Y1LFjDrBkwIzccy1LA38jfBNmUO+E4b0MkejccTLowcmtmCxm69b8yeOk4mIpLGw6zl+pEcYMKh7Y33Gc71IMOX820v/LBAlAlDPDjf3L6f5L8K2S9XiTu+cnMWgyVNRzmhojKDiJmBk3T14V4W646lpOHlpudkCfDyQ9PojDypKupS9CPNKYfqhx52vIYBSycO9z6aQ86S9oVCoQILOBd3ft1VavStvfz3h/BBvBF7Ekb4bN2ClsliczzXqaFndm/GktZH3D53ce0VlgfLXK7XERJ8MlI8IqeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SA1PR11MB8396.namprd11.prod.outlook.com (2603:10b6:806:38d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 01:16:23 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 01:16:23 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy
 (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar (djhawar)"
	<djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Masa
 Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
	"revers@redhat.com" <revers@redhat.com>
Subject: RE: [PATCH 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Thread-Topic: [PATCH 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Thread-Index: AQHb2v8hyfrpLxM6FkOIyCBWXxdgvLP+S6+AgABtDNA=
Date: Thu, 12 Jun 2025 01:16:23 +0000
Message-ID:
 <SJ0PR11MB589636DDA3D1858440717A9AC374A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250611183033.4205-1-kartilak@cisco.com>
 <20250611183033.4205-4-kartilak@cisco.com>
 <aEnOg5B0tYOQIuME@stanley.mountain>
In-Reply-To: <aEnOg5B0tYOQIuME@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SA1PR11MB8396:EE_
x-ms-office365-filtering-correlation-id: f442b698-bd21-4bf1-6434-08dda94ebf29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?p3conl3O9UwuMRWcFUMM5a8uyHvBsvTPDp1+NNpXU0uo5f92wqkxphipFJQt?=
 =?us-ascii?Q?FxZc9grFxkmqikuIo36CKXRI40jQc84UCpzRR1VhI3Km0MnS93ZkJyZoF/RW?=
 =?us-ascii?Q?FylmaMyQE6ZDRBGJXidcwZ2CMpaGdLPtdTsycGE3YYkcfzt1wY+TbHOCGjBb?=
 =?us-ascii?Q?GawADxQoKcwj986tII0IEhdyePjKD5r2/+jq7eB+qMLA5PG64Aq4QGQUFkhr?=
 =?us-ascii?Q?jIMKqVZV9XIsgXxuzroqKW4hya9HLzIeHCluZb3jVG5Mc2tN8LBG+49ahppY?=
 =?us-ascii?Q?izKsrp9x7VPc1M7L8jyBiZ8Mo0JNCeQ6Z+9BELSGuINInb+fRoq83gSMH4p2?=
 =?us-ascii?Q?syG5eGoHg0NibvQEpkqh++F+DQiBv3Sxs8HEZMLDsIIwRGNrkDKtSB+buwBi?=
 =?us-ascii?Q?wNWiv/EDdC2G+Mj0nVCUo82nFiGDclD6QAiuF3495gDLlcSDwy99OxiortR2?=
 =?us-ascii?Q?fJpzaRdmIDbYOMH8twFxpFDCB0//9aVPIv12rqJ0nAc5/Ees6RBtsmXSruB7?=
 =?us-ascii?Q?wHPdQ8U7H1JUK5x4CucnHy96VIYme0zvLpDK8OiVFb29UaenDlM3E6L93QbT?=
 =?us-ascii?Q?Eki6jXEk/SDCipYT8UPadnIstuz+tQC1dz0w1mQYJxzmyDxd9Tvuj6tlJ8/j?=
 =?us-ascii?Q?lUEfqXHZKfW5L+6R+xnAPkzo7bo1PkySY6yyr3C0IwGC9CvMYcAVpdSF+Uau?=
 =?us-ascii?Q?rq0BbH03ayKmkeZ2UPIcpaNCJw3t7+TAr39fSmI85BBvqx4BFkBz3LhLV/K1?=
 =?us-ascii?Q?m94X5vqDcjcS2QPhkajT5KF9kDdbDNA7lCH4MW7Esq2qJyAAVu4e+5FZoYSJ?=
 =?us-ascii?Q?TKANK2AXTW0lMzu5VD9LwvIiTv3vKBC5q6cPygv1DSTbkxwJQY6t8d8iU/4D?=
 =?us-ascii?Q?Ef9guDSxPhTdw2i5OXD7sZ+dyj0KHos8B5Zlxw4QSnENHBbYOibKxgdDhZKW?=
 =?us-ascii?Q?83wV+jL3J16FSJ7CnLI9a8vBDh3l4UzXXLtfM/TAdreXvWzu/mH1R4oafDlN?=
 =?us-ascii?Q?2IfBzMk35PBxwwxw6/KEl04qlHKp3Vh1/btNzwOlMd/N8SC7RsB6i3eNuNYn?=
 =?us-ascii?Q?mnDf9pwXDQcmnfvXic7EFcJqK+6tdjAzofsTkgPda99kyQe2D43VMlGGakp9?=
 =?us-ascii?Q?uUqsDlVoJRgMcmhSCZXC9R5YRmtdluvP1c1iAus1xQH7d2g8n+4Oixdt++5T?=
 =?us-ascii?Q?jglsERBKcv1JR7btV1GLZg6lvq5od68JxMISeyNbwf9PNvtHKyBC7s9Msupq?=
 =?us-ascii?Q?slVCtlefBdJMc/Kp5JM3J3z8E7rdAVbsIZsJMc5YD4f5ST//mH9TvdpHEavz?=
 =?us-ascii?Q?LxCfZ6a04lH+jyIbbErEhKdVmX6n5ENF+lKamKlajOOHPQ0uYaMa5CIZsIX0?=
 =?us-ascii?Q?WBJk+ynKV6ZJSj2h1DJvq4aHxdqoGf+NLEKr7wY3r/TQpRu4Q8a58LqtZ4Pf?=
 =?us-ascii?Q?PSQg0Z5xsZCd2heoGUTEiRBxt4PIfkzv3EhF6cbqs+gtUr1soXseHA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0IKRBmsBUj4XqFpGYJIAMXfsX5fDlz1KkqJcNQDpWnZGwIpkPqviy8O1AMNV?=
 =?us-ascii?Q?WontELZnQAJmQ8bajiZ+zYkk9BZlCXv++Gf47M7URMtBdLzxHgFYRrnFEdNj?=
 =?us-ascii?Q?xCK9Fv6BLsSAK/tfuIjgjJcDJzvru9eK96GKvq9xW8lrR2ccqh3xR51u3V4s?=
 =?us-ascii?Q?CaoEbMF8U62MPAPfeSbm2/1Q9D9MjZf9Rf8itSV2izQdZkB2zXLkc+5nomdW?=
 =?us-ascii?Q?POET/Zfdongo9xGmuXE0nPBlIfRZEtxXuVMqMAbGz//lZ2IiTse8avpo9fMA?=
 =?us-ascii?Q?bMh3h/OvxNJU8CGIrV7DFN/fBsBuTTf/3PQbT+bM+fK77sbDwQhn3hb4F27X?=
 =?us-ascii?Q?zQfl8HVGE+KYpkphc16+GBIM97RDQjNkzfV/0Xtny1x6slnIROXRPH5BdAPK?=
 =?us-ascii?Q?BDD1pcRXDkKA0Zp7A0MswLhaufNnCuM+xTaSl7civ6zJJx84aaoB7miIAEDX?=
 =?us-ascii?Q?3hzEYVbRGYxK5fzIFOKHBOYcTFZTM2w7ovul20tqum92/dFk5FphJHNdmokT?=
 =?us-ascii?Q?l0JT1KkAFI9N0SzFwjPC4dAJxH1BYjxbKv30rfZuw+4EqRP3ZOGym3ZYFp2b?=
 =?us-ascii?Q?2+gM/KkMD+SNHoJ/x9MMlV4s4iMudg0GPUGmDyIC9ctF3icQ2pJjtvm+xxME?=
 =?us-ascii?Q?c6flvoXhitZg6xE2KRG98uG9Hryx9J6q1uSH8VbmSbUiJUU+e7oLJxV5kd2p?=
 =?us-ascii?Q?tFDBr4hdRGDGtGQNLZI3LS5XJSuzCcJ+72o62aGUO/A/lRNlR/wHnUZMZx1h?=
 =?us-ascii?Q?/ssQV4CDBc+i41ivOmMAoazI0GsnDn95r5tRmnaU8aMgq81HkyMc8bfAA/KE?=
 =?us-ascii?Q?5sqdcZgO0eq4kaz6XfnAD07+VQJAdhK05gd5ld2jNf/qX2KeGTzvdIWDsviD?=
 =?us-ascii?Q?3CWpxcOWxCTZQf+B16s8u7Pw1ZskjUPBKW9x5AwfCyXnuniGg2uni+VyiFzy?=
 =?us-ascii?Q?kVS73DekOGe+okRrPVf8POKBAsiE2WcQbxuNF+L1oF7HRUuGr1P6/UH/2wyC?=
 =?us-ascii?Q?2fA4VrfpRPtfcWDUASv7uLNILkib4w/1q9wfzox+KahhRgKT+bqy+sPD2mXG?=
 =?us-ascii?Q?n2FE8xF5mda/VXKFCbWPL/WifjCDyBOyNV7cbGKTzfqPu73GjwykwCSRUhaK?=
 =?us-ascii?Q?N4ltafoDGLW6xbZ6fuw95UyIl5K2QXTECtiDIGmm1lXlDcPmpmbRK1fXq4Yd?=
 =?us-ascii?Q?U992S25wCDdL+IAhEYOuovPNrUJ5nf7XLZuDEb4SqtSTiKxT+HO1CwDciC34?=
 =?us-ascii?Q?2IgdOc4REh9Aqx1cUOFZAUmSI1a1uu1Oxp3taSXu2nIJCwllkgCCnRP263RC?=
 =?us-ascii?Q?tKaxogfhRPR5yFg362oXJPVHdUKaKyLV+jl9ixooZPPpkfWe9+aqb4AClS9b?=
 =?us-ascii?Q?8jvEb1f+viw9zMVSN/7geqzry2COIZhlysF046r37fyKVIH/BFO9I4R+Os92?=
 =?us-ascii?Q?IEsIDOTdp8nUwXAj3ghfUc6nL3cJ5AJ7Ym1EWDQGjn04Km+KiqB+wl5jU+TQ?=
 =?us-ascii?Q?xIMiv4Ux51BimkwSJk9rFatkC/wxdArLYwMuQaX7ta1M0g/6nB18KXcxfkqj?=
 =?us-ascii?Q?xJZdxk69aMH3nRT8njwUNK27bPtifcjZLVvTLr/Th8LwcuopYRt8VmLyymOH?=
 =?us-ascii?Q?44J6EaIgjITLl/yTdITfezY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f442b698-bd21-4bf1-6434-08dda94ebf29
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 01:16:23.5923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nc710vl9cjCaKjU29eapFmIu8Fo9ovxxCp6qw0S64Xmd6vy2/UPC2uJCCA2fblgXKta+2VLpncgJ0BOJEOBM7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8396
X-Outbound-SMTP-Client: 72.163.7.163, rcdn-opgw-2.cisco.com
X-Outbound-Node: alln-l-core-12.cisco.com

On Wednesday, June 11, 2025 11:44 AM, Dan Carpenter <dan.carpenter@linaro.o=
rg> wrote:
>
> On Wed, Jun 11, 2025 at 11:30:32AM -0700, Karan Tilak Kumar wrote:
> > When the link goes down and comes up, FDMI requests are not sent out
> > anymore.
> > Fix bug by turning off FNIC_FDMI_ACTIVE when the link goes down.
> >
> > Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> > Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> > Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> > Reviewed-by: Arun Easi <aeasi@cisco.com>
> > Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> > Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> > ---
>
> Fixes tag etc.
>
> regards,
> dan carpenter
>
>

Thanks for your comments, Dan.
I've fixed them in V3 version of the patch.

Regards,
Karan
