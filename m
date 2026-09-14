Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEED3317164;
	Mon, 14 Sep 2026 10:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789380189; cv=fail; b=KEAV5DAEo2JTyXWpcNhGh6w1YrUVKM0Gg7Fy8c0ut3PZeu6HQINhs/1La/FP7BL7eIf76QN7JNx9lukLbWbnDd/JZf3XVVlhTisY2I9TLg/gFQxhZRMWRRUqhjVNl7LCf8S1GGJCummqoxAn3tg7qjKaT9QZP3rYiwV5KLQMveQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789380189; c=relaxed/simple;
	bh=k9AlaIxtjDlybbeN3Aj7kvQ/43iwJiWFa2d4ooIGXo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CyaZwZ/0DsHwOmo4VdgPZZe0pSH7U7pvuBu0uO8eXOmy2JoWaq1cFcHfByHMCrqAma/NWCZ6wjFQ6pnWiA/ZlBj1vcN7bAsN50UNa+sLcqq7QKSrgTAqdg2c3jqQbWv0DEd2LM1O2/ySuNsqQQU/OVuAw3AcCM03Tuy5ddssznE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hQPQBAON; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=XEE7jGsU; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hQPQBAON";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XEE7jGsU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789380187; x=1820916187;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=k9AlaIxtjDlybbeN3Aj7kvQ/43iwJiWFa2d4ooIGXo4=;
  b=hQPQBAONTeha/sZjOWP66uWy6YNk/UiXKJ9nPoIKLqkktXgkiydacr8M
   8w7MNVS64gi+U0MwxSHHAFg3pjBF0ekj+IOMVB1FVPNLYyLn9qXZsVWyN
   CWd+N+3pz789D6AWs/tBtiqcWZuaMWvVeSR6KhRdgtp3zAesu2zzkMXWI
   bbVf4cThng/dZqrugHABBjV39PvrGOeGRrtRTiX+5sWoPe2rjHWHmOmRb
   LMSbtGAA1rjA9ZDAlCPwng32gHluMC7PF/9uNsq0VTTCzffPfqBluTBYj
   W9xQcNTN9nvOd2VeYl0B6e37UfOIEO08uEHj0VxNADVxsjE7yquJaG5Zx
   A==;
X-CSE-ConnectionGUID: w0LaU6DfTE6oaip8YlI6AA==
X-CSE-MsgGUID: rHAKUxIcTMWJiOUtrSIEFQ==
X-IronPort-AV: E=Sophos;i="6.27,102,1786982400"; 
   d="scan'208";a="154657820"
Received: from mail-westus3azon11012063.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Sep 2026 18:02:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+YOMbCZh9rtzvQMdXYPJ70L+A1il/vN5XCKADlFJjEEpVZICihOZMpdhrnH1Hn92dSLSe6JM4sDR2M0JdBW7zpfqLC9dQuGB///jGbzY4dA1pwyk0r/ch854SvBw18EzwRC2ZcuGoHcNzcnOrlE0uH2Mg2xzZFMhMBYEMwQzRXVPga/egH//N03QCCYbGMQbAzD6N5LkL6zsIWi4iUWcE7PDtYAtj/DuzFC05GvCmct4pHdHWqJyvzyGexVOAguJCsIVPkYLcKaxYXo1TEGyOqBQPUPfecsilvChYieL4yGfLNyT9IymNkoNBHQ4qc4josFzhh5N8Cv9tq/ZYvfJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9AlaIxtjDlybbeN3Aj7kvQ/43iwJiWFa2d4ooIGXo4=;
 b=oCm9W7bX0JP8LPbATbZMPowUZsu+zvzty/5Rovl1YRG44Z91erz9HczvoUvxPTiOS6W5y+2HYnJFZshEB0PfIXokIdVe4CslSyfMtIOIGQWL2RS8vqJqT02JAWuJjzj50Pt7tSoEOWVwOyhdUYuUNvPi9ic3BT0BnkbI+GuXjC0wzhTApZo0bLMK1QlF+nGm3pttWL+RFPea8rtXNNDFrFNsukcb8X8cU0Em1rZSHxTH/D6Enj7HzP2f4OWh8KhHLsHjJ3gBYglX1diWg+lVms1bv0IsvAtsZg0YYmMq9iSYdafyBwOepR0WhhskREdJnysx2GHMtPtkbH1Gwqd4Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9AlaIxtjDlybbeN3Aj7kvQ/43iwJiWFa2d4ooIGXo4=;
 b=XEE7jGsUYdd84c1KIWPCVLc/KuZjZaZWb8hojJqbjHON7ZprJ8kHqaoSTmKtu8vajQGcSki7EPlamUdogEndE4U8PxxJ5xAwFtiPwxOHhepHzQIiT6z3ylUKE6v98tSv9gMu5UOxibYXdXmGl/1KkOGgOpMz+JnEFUruKipyj6I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV1PR04MB993618.namprd04.prod.outlook.com (2603:10b6:408:3f5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Mon, 14 Sep
 2026 10:02:57 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 10:02:57 +0000
Date: Mon, 14 Sep 2026 12:02:39 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Greg KH <gregkh@linuxfoundation.org>, jaemyung.lee@samsung.com, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@iokpp.de>
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
Message-ID: <aqfF7Nm4jizolq4o@mayhem.fritz.box>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <YKq4TcQM0v2dXF4wTHEvZKwASII6PDd_R7_UiHWe3NRnR4JsrC_ZS-x6jA_Kl7P6ONehU0REHYk7WaLz8Xv5gA==@protonmail.internalid>
 <2026091124-treason-trickily-bc52@gregkh>
 <87mrtmvioe.fsf@kernel.org>
 <6JMwZ4EuSfQ8V4TGaPwatQ31m30TceLJblORsuILQmy4VV8Fx2lHbihL8ARsRUuJmaSUqek8L54y4Nk6DuZMXQ==@protonmail.internalid>
 <bdcff6a168e6d4b8e9c9524bd598281817a7df2c.camel@HansenPartnership.com>
 <87eceyvdnv.fsf@kernel.org>
 <RJ3H-1s-vh5YR7DRuPZ6p050ld3umNGcKNeBigg7n3KUQt1WJ2C-sR9kEqrF6f4ubj5AHoHNvB0MRGJyw6tf_Q==@protonmail.internalid>
 <77e00073a9254d5ea1ade771590da81a859b75a6.camel@HansenPartnership.com>
 <87bja2v5g6.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bja2v5g6.fsf@kernel.org>
X-ClientProxiedBy: FR4P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV1PR04MB993618:EE_
X-MS-Office365-Filtering-Correlation-Id: dfcd6f1e-8b4a-46c6-4e9b-08df124759dc
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|19092799006|23010399003|366016|7416014|376014|1800799024|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	X6Okthew46AaU4h3JFHt2CZA+RZB6tsoACG4psPoqiM/9o8ESprzrENFFGkhR3SSX/KY5KHXTyrWlSqcM+ypUoI0VrkMrpv4MlGXTcE4Km+V4tAn1WU0slwtZYaim7Kmapc60mWS6QTn9KqSQRUSX+musJuZMuxodIoxERWmIMNass3zGz+70r9cQ2Ck7vjiULGv1XP7Asyo3Jfc32ZhvYW0+XII48mWVkUE/SH1CgWk9MynE9C5eYZiX5wV2vDHRxJQpWrxwU93ac+DgAbXQ1ZYLEq5DHreC3VnHQeaYlkT6xTN5KYSd5JbneMCCm0e4okyW90gfuCBbOJHoFSCGorqKsD+a1XhMxTDmcGkU7QrWREoK8hi0xDn34xAKYp1+vpEgPXt7bwyWK1o8rHEu8g78GoOgA4BMOY3WB2au7cp0ijJJdtYIggaHnd0mweu1Y4PeHOHgQSoEAB3npsrUXiA0pfghshEblJLnvcevDBCKjiWTAq1MfD1ChyI8GLbAMGyjLTJjVnJ36or5cMvukQOI8OAVnbTug5Qh2p0NmoiTyhwaWCy932UTOiLG6OpFVIlfydCHlgKM0KrtNtQDLSkNlkt3I743baNRtfdfz9KFpFNwX8L0dDV89dVHSDJIG4RCv5/aAeyb+uevATQkYwtdXxnc7EKATQ1b6mCuGg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(19092799006)(23010399003)(366016)(7416014)(376014)(1800799024)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SfwyQXekdBRXa1q80MJK9v62hfYzd72AVeOyRpwWwviGs/ebJy/senHxvPta?=
 =?us-ascii?Q?kJ/Fw2X71vhawUvw59f2X647wQXM6Wy3382OAefY+IQGh6vBjDaDWdrdMG73?=
 =?us-ascii?Q?H/LUMLz82Cemk7KYeT7XKyRQgiaPktEjY2VPAalzHR2s7Y0XxBPOfICe7VW5?=
 =?us-ascii?Q?JiY1xVEAkkJg1FpJXQPFekWs6uUpKmFKoE1S4CmBSPIHkwpz6dJHN92ejd39?=
 =?us-ascii?Q?Er9BAgf+UWboWdRGb6wW9S9vdvNwORe7rg/0YhUnzbH4dHxCBybrLYoGJr23?=
 =?us-ascii?Q?DBjGg/RJL60LdYKlPN2zth/JG5O2f2hynNhsT405XASCFPCEuBjqRME1EWlz?=
 =?us-ascii?Q?MoDRFo7ehKnlbU4eBmkhflYmeu1NaHa3XTA/QPVrDTPlDNYsPZmlKAK0RiD9?=
 =?us-ascii?Q?hP5kGU2OjGYplqzLH/YLJ2xnC+bb+n9gcfpy61TMLnY+gcxTYH6NHGo9I23W?=
 =?us-ascii?Q?VJkeDRiWAS6ngNiQ1mn09r0V5/5Rs5kwCjxy3AAEdFTj64yaX/YJ9txrQjnz?=
 =?us-ascii?Q?mGnZjtnWxyELqhdCX1sVVUcaFXdksblA9chqLlOD6CjFhpR4nK5YZhEgmM8s?=
 =?us-ascii?Q?94uQX9P64RV94YSYRSU5e42+g7wqzRHiUAeG3n4LMpD3mL0oA2DHX+pfmyeT?=
 =?us-ascii?Q?iktQ/Dodt95bt/DGt+RRqM3L5ZHZTejZktAkiMSPY2ddnmn+AUQZMdVLo070?=
 =?us-ascii?Q?unLOlrj/kAJu1bmWJrmw52GSnQYOzVjR8+4ltx20isF7kPsHm/WsOFj1kDq+?=
 =?us-ascii?Q?KcMEGvFzDQKp9kKSpb38Ka+c6HcgkmlGpiR5XOIGVn3lE8WW8rynnBxgcBhV?=
 =?us-ascii?Q?sd6tq5InfqPEFUCVZYtHSYU0v+Qu9PZQC6BaLheB3sJlaFQ5IETuhGQHdPKN?=
 =?us-ascii?Q?SV6V1XEtne3INAuBFUxMT0PTr+owD5XH8FU7lb9HQtTuseamRS/vI0pxDA2R?=
 =?us-ascii?Q?c9uHz+Ww4yovulrRJEN9mERi32FrzKwzuDyJE66L6nV83pT3BHlzW20DDYyg?=
 =?us-ascii?Q?w6Tu+Z02L8ayE0Nhxu9pIkzVZ59QtiGgXPSw0M3rHvFlQqjA6nQRDsIn9Cv2?=
 =?us-ascii?Q?X+MRzvz/V4dzwYtDsm85luZLFRSoGJDrguyQ9cvS7/MAE11j7w/9DATUTrRk?=
 =?us-ascii?Q?t6XDCOkgDwIfxgraa9+LrUSoJ440vzaKYLnv9YCA3KOZYoGV9WMtqVd3UGgn?=
 =?us-ascii?Q?vheRac17fMXDO7ykj363TgXXDdo4swJnSMZ++rfqLUKs7boROakw+PR9rCoF?=
 =?us-ascii?Q?OTWlQH9rkbUjtAg5MtBKHJJ8BuTr3FBP98edFT10hEohgS2NbHqRSj0ExIa1?=
 =?us-ascii?Q?fHkE0ywdWt98XMVTn2F2CdbzW9FocJl3uNEGFK34TuRZFCC4QL8yC+MpWDob?=
 =?us-ascii?Q?m23RAA8TOPjEjJFtelBPxlijzuF+ZfUDGZFj1gQyOyNJY4/wnOEErJHQlz2n?=
 =?us-ascii?Q?wQ8k0YQVFU3Cc7R5cYQ07ogUhNd9LcKWhQjzgoyU95eKehL6AFtXRQud7zIK?=
 =?us-ascii?Q?zDDoT7kDzsAo7KfWRzNB1xhBQb1h8SCht4YnLre/x07jHeE53xHqgjm7XqSZ?=
 =?us-ascii?Q?DsoTHkPI/CrerEhHgVVgppj6Oq9XnpBCnJ6p2eo4fKVC2UqhaksvA+rNtyMQ?=
 =?us-ascii?Q?ei5DeQhvxGEF1Hq7+OgHdGotrIrluyLmQNF9yySKnIZW4Eci3rj5j9nmm/bu?=
 =?us-ascii?Q?YGdc/S3VOK01yHt7vEZpWKsiA9UWURCji9XbZDd+hLElrSN0DwGN82woZJmq?=
 =?us-ascii?Q?g6OfT6n5+SBrxEemg+pR3lGA2CEoWZ+mqHLoeh4IUFiWjydXNfXRcy4DdAqF?=
X-MS-Exchange-AntiSpam-MessageData-1: ZKEh9PuTmlhmPBVziJGlhHoCWPXIJcyNftA=
X-Exchange-RoutingPolicyChecked:
	dut3r/7o9mLD1exvVTRn2h+20CsGSzRJqCfKvlkW5wvytYvsgPmZiyqGsDb1mJxklo+UISXNRgwn1U0DnHcJo/hyOefuxYXhBVAc+HZWARrzpup4vUt4ey4UwJ+w1trpjdEjCxC0DWqIHisXGGHgiGVn+c+Ywi12Akk31wnbgvrJqZvCkUEFDyv3t54M0lrL+JcAoKrJeFwnYiW/CO467p4kawF5AlQ5B9qEFzMR3Y8N8tiVse9n44GmhrUfWk+0aSuo2vztCHJwrDaZ3U0aZWWDCuxuo8yKMujtQGmO8byTmvu5TcxAzWEIuC0ppul2EMb3qCraRC09U0BwRSCoMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SJa5okuHNj/WYeWWXm65MkGZkt7sz9qi3McR0O95C+JwIpPtduIkaCsVD3qfjGtopjXEEUdmzjxY6GfH//e0MLjeODtjRgm2dz64/XsyhNXdH0EPKI7C4DXfNNa2o5ZTvhJ2N0yn6asUV2qiiJtlAsXjrEwAf7daSmawd0BHPotYfkKz5miiN+quXRdCyrGstkXI225fRE06kx6lXWVlgj3MWWbQxTavntV/baUj4M6d42QlCYpKCphycDSLNNjjkAQWrZQvYfBRBfjHFobVJFwCwfgPblBJYghh/IkLTyWVxoTa/AW4y62gAUNkROV2KpFerQGsvTvNE044sYKs6J9clwhbmbl1iiuljF6ku6AZlZPQWUr6Q+DakZfpj2F+6moVae137n5aekomOymFLe6kGMxgyASoZM/csC+lmU9f/7F12ON5RaXgpqMpylZIVthHMjSYC1dq5b9yP/PlNfZgFMgb0KYW6vUmjUjdLbyQe6Rg4isIyngv9x20fb/TtY+yY8Zf2vEgTyvo7wAzFAH3YMRWtN4EF0b6BwdilGnVuqQJQGruLl8P9d1+4HiUWHGKVIoevn3sTSGZJkEJPv3Gt3OR+/5xVlwQXdLYOfV+KP7bWncrLYwYKngkQCzf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfcd6f1e-8b4a-46c6-4e9b-08df124759dc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 10:02:57.0705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /7KBHz/DrKm5roMwg0Gg/6ufDGki3XV20LpuD3L/pc/cqQ9kwYBTBAFjlawMyI+0zBZEAfdTaxHTv8mqePDp8gGC1L3GlmCEci+wLI9cBts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR04MB993618

On Sat, Sep 12, 2026 at 05:45:45PM +0200, Andreas Hindborg wrote:
> Here is what I count the midlayer doing for UFS today: sense to
> retry/errno disposition (scsi_decide_disposition, scsi_check_sense,
> sd_done), the abort to LU reset to host reset escalation in scsi_eh with
> ufshcd supplying the handlers, the sd device model (capacity, write
> cache, UNMAP, runtime PM), and the SG_IO ioctl plus the scsi_device
> sysfs tree. Which of these is the part you expect to take years?

I don't want to be the party pooper here, but please ask Hannes about his
multi year scsi_eh project ;-)
