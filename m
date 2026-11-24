Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=173.37.142.93
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795563609;
	b=qRSyE9/7Jrs1yN1OthJx+UPu1j8GVofDaXM+IX2d5hW403IdmJF4i/gJoXcKIznWY2VK
	 97EPZL/w+Kf435QRAv8VBLKmgZKqJVcoWLbxXcanoyodd4zyFO1avMYjQi0hpzhACFjbz
	 J3IX4Dfz0r1uwK6qKAg6+0KOTVYQObMd7uCfUWG1OX3LazuNb/ODIEcpL9ggWTy3Ee78q
	 9hxQVTnb6nVWIuFn8KPOQKFevCba6DGEMirGJHtIMV3heya/5PpM55bXuwnWt0lb3x30c
	 I1XkQxCdZBTF6FYa3jfjim2bEfXNgYunFB3DsjY65W3oZZ9byTBXTfRL5bXsiYlm3LA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563609;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IPAS-Result:IronPort-PHdr:IronPort-Data:IronPort-HdrOrdr:
	 X-Talos-CUID:X-Talos-MUID:X-IronPort-Anti-Spam-Filtered:Received:
	 Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:X-IronPort-AV:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Outbound-Client-TLS:X-Outbound-SMTP-Client:X-Outbound-Node;
	bh=TQqqb5Ds/nROkor6/I1ZC+n2xye4sjpz+MrHXAcJcWw=;
	b=yCfcONiAzlPfQhwz1u80iMAtRD1CHCuDHRaDDndXkznR0dybsttr8DoNRb6Li3RtZauH
	 DpnwZu3E10g8xEzoqq9vEPCgfmOV4RBseiFyJcFAwm9xOSI8ALIkmkVUbxPMkJXZ5pkTx
	 kz5X4MV7QvJ80t3++AGc/OsKrXUAX1ToaRQFNh06WTdPSy9UDJO0SxKbeXcDKo4KN/v2J
	 8Fcr1kh+cM1SGfG/ar7uqNX+/WrhVxoSGjNkLC0agzyCH0O3EfpeCvI0MuPkPfYGsgXhO
	 vdegP/pcKyagcsK7hZbmG/wXKhUlnj4wfgPUltAOIEYFdiPIYn7CQnhOeCzxw8h35rA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cisco.com;
	spf=pass smtp.mailfrom=cisco.com;
	dkim=pass header.d=cisco.com header.i=@cisco.com header.a=rsa-sha256 header.s=iport01 header.b=gVeaYICc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=173.37.142.93
Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C4B606A333
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 23:40:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9C4B606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cisco.com header.i=@cisco.com header.a=rsa-sha256 header.s=iport01 header.b=gVeaYICc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2145; q=dns/txt;
  s=iport01; t=1795563608; x=1796773208;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TQqqb5Ds/nROkor6/I1ZC+n2xye4sjpz+MrHXAcJcWw=;
  b=gVeaYICcIBjZS2zA/8DfsrFztm8kTo972hsYLPD8ASbY71LNo1V9S/Hg
   Cud0S0cY+3lNlR4wC9HuyIpTSxSsRSXr/vWwtYqECW9OJabuJ/A3CdjA7
   lIah7go9rItgSXIm50U1PcUWJ3z9b03k6c7+ZZaKxfsTNAqqU8tWC3AsD
   rtaBelhLMIRAQyvW7Q1ld3SrWdn0/RN5aosOaU2MR2uGuIUo5MrEMYDZf
   D7qGZYVwbUE5kyEw6zmsyBRTCu7YzwOQIIYx30qTjZQWBxCk4Nr9GLaQO
   IPgj4/UvPJvyxkj+up0rHsv7inytLeKesyWeC0owixFYA8hOYkIowN5L4
   w==;
X-CSE-ConnectionGUID: h/ZprlsGQXywaASAPSnHEw==
X-CSE-MsgGUID: Vb/oOOxOSgqwwRYdlxTCew==
X-IPAS-Result: =?us-ascii?q?A0CDAgC0HwZr/5AQJK1agS6BK4FuUxZzgRMSSYgjA4Uri?=
 =?us-ascii?q?H2YR4VigX4PAQEBD1EEAQGFBQKOIgImNAkOAQIEAwIDAQEBAQEBAQEBAQEBC?=
 =?us-ascii?q?gEBBQEBAQIBBwWBDhOGXJASAQEBAQMSFVIQAgEIDgMEAQEvMR0IAgQBDQUIG?=
 =?us-ascii?q?oUbAzcDAQKva3MCih14gQEzgQHgMQELFAGBOIVCgx8BAYQ+gSOFFycbgUlEg?=
 =?us-ascii?q?VeCaj6EQwKEFIIwBIMujmcBAYFJiFJSeHgsAVUTFwsHBYElQwOBBiNLBS0dg?=
 =?us-ascii?q?SMSKRcRHlgbBgUSICpAQ1uBEoEDXYErKF0BAh9GLRWBdQKCUYEjXQIBSUEOB?=
 =?us-ascii?q?0VTCRYPPgUSRyQiCBIJARMaLAqBGjU8CSY/FQxbDAsaBRpHCAILAgx0KBEQE?=
 =?us-ascii?q?x0cJC8FGSY8GwqBDCcdHhkOAikGFiELMm09NxUZAwSBNQWUCYMbgQ6WF0CRC?=
 =?us-ascii?q?qF9CoQhohQXqnIuh2aQdCOodgIEAgQFAhEBAQaBaDyBWXAVgyJTGQ/gXnk9A?=
 =?us-ascii?q?gcCBw4DC5NmAQE?=
IronPort-PHdr: A9a23:ovepgBNmaD7bwdi9T9Ql6nc2WUAX0o4cdiYc7p4hzrVWfbvmptLpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgl0w=
IronPort-Data: A9a23:bf/Hb6JYogC7zGvXFE+RmpQlxSXFcZb7ZxGr2PjKsXjdYENS0jwCx
 jEYC2GOa/qKZjP0KtsnYIm38BxSucTSx9dqSlEd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZpCCea9k3wWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVnS0
 T/Oi5eHYgH8gmQoajh8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1uS3MuJ4kD1d9HEH5H3
 McxEAsLTj2c0rfeLLKTEoGAh+wqKM3teYdasXZ6wHSBUrAtQIvIROPB4towMDUY358VW62AI
 ZNHL2MzMHwsYDUXUrsTIJQ7gfypgHjXeDxDo1XTrq0yi4TW5F0pj+C1aYGEK7RmQ+1rlAGfg
 UXW2F/2Gw4FDu2TzSq52X+z07qncSTTHdh6+KeD3vprhkCDg3cYExw+S1S2u7+6h1S4VtYZL
 FYbkhfCtoA78EitC924VBqirTvc4VgXWsFbFKsx7wTlJrfo3jt1z1MsF1ZpQNcnr8QxAzct0
 ze0cxnBX1SDbJX9paqhy4qp
IronPort-HdrOrdr: A9a23:u2fBEK/RSFCu47UTyNVuk+Hedr1zdoMgy1knxilNoENuA6+lfp
 GV/MjziyWUtN9IYgBfpTnhAsW9qXO1z+8S3WBjB8bSYOCAghrnEGgC1/qs/9SOIVyFygcw79
 YFT0E6MqyOMbEYt7e63ODbKadc/DDvysnB7omurQYJcegpUdAd0+4TMHfjLqQCfng8OXNPLu
 vl2iMonUvGRV0nKu6AKj0uWe/Fq9fXlJTgTyInKnccgjWmvHeD0pK/NwKX8Cs/flp0rIsKwC
 zoggb57qKsv7WBzAPA12jc1pJSmNHw4NpODs6Bh6EuW3XRYwCTC7hJavmnhnQYseuv4FElnJ
 3nuBE7Jfl+7HvXYyWcvQbt8xOI6kdt11bSjXujxVfzq83wQzw3T+Bbg5hCTxff4008+Plhza
 Nw2X6DvZY/N2KEoM293amNa/hZrDvznZMQq59Ls5WZa/pHVFZll/1ZwKqSKuZaIMu10vF8LA
 AkNrCt2B8fSyLoU5mehBgt/PWcGlIuAxyBXk8O/uaR0zRQgTRF6nFw/r1Dop/Fn6hNFKWtII
 //Q/hVfL0idL5lUYttQOgGWse5EWrLXFbFN3+TO03uEOUdN2vKsIOf2sR+2AiGQu1B8HIJou
 WLbHpI8WopP07+A8yH25NGthjLXWWmRDzojsVT/YJwtLHwTKfidXTrciFjr+Kw5/EERsHLUf
 e6P5xbR/flMGv1AI5MmwnzQYNbJ3USWNAc/tw7R1WNqMTWLZCCjJ2XTN/DYL72VTo0UGL2BX
 UOGDD1OcVb90iuHmT1hRDAMkmdM3AXPagAZpQy09Jjv7TlbLc8xzT9oW7Jkv22FQ==
X-Talos-CUID: 9a23:K7LII213ifKo9dAtfU22WLxfGocXamfZ11jpE16nAE9SYYWuT3+95/Yx
X-Talos-MUID: =?us-ascii?q?9a23=3AfVaPeg9SHk/8bLhPiyBkKqSQf/lipKOJL1Aqqpo?=
 =?us-ascii?q?fpNa+BCB0Kwu2gSviFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Nov 2026 23:40:01 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPS id 49148180004C9
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 23:40:01 +0000 (GMT)
X-CSE-ConnectionGUID: 5BjwqI4yRkK9aiCGgaWWyA==
X-CSE-MsgGUID: gdhogZ7XRJihp1sRZPVXlw==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.27,231,1787011200"; 
   d="scan'208";a="93802382"
Received: from mail-westus3azon11010071.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.71])
  by alln-opgw-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Nov 2026 23:40:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N6JtijIeD+usYkvU4lCzWXAMaHMlVQkK/LCrWdQsMRczGjDkYKtVfClax7WtSeercRHMG+nsWLj+slmbrwqrgGHkgl2gD/woUusKWsFZeJsnO4r1qIzICivzGSPpsS9guQ3jJYP7kv6K9948qNIPPqSmzo1wRD2B6BgEzHtK5EPKNBY1QCaOqu70YSZRlqE/7MFpJ9Zwpm+PQjScUd2SpLa/oIwqRd2Pyv2k70vsjG13OsUhWK687yi1C+878Egflmgkg6eMzF548/P8ZfTi0NWYuNbgfJJMXjYdq2foLdasYcucwKSDNgEE9B0MtlschpGKFdBCkxgyEHF39BtChA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQqqb5Ds/nROkor6/I1ZC+n2xye4sjpz+MrHXAcJcWw=;
 b=CRNYvM8XWr1hejmRA2b66gezi2/meIWJfFbL6RF3SjnqtZdzoJNTmijO6TajcUKdEYARr0vS+13KqX9r9G7DELvVP9HyhIOvGSy70nuWxWKzaXwcTmAcQ27lBGnQwgkS1YInC262OHtST7scFhEs3d5eUbubHCJaTBSkchqFXZhyhhEGifzlBQVQa867PpbH7vVCF3wghe9Z7/vjy30JApVkfNZWRraSnEXb9zpWQS/yN+KQYKXmjr0EHm7JVXIm1iMfyVQV1pPNSKZ4SLIJglrwxVjicNFIoio1gFg8+LDUYKwC8P5x8QgfGidCbWkC3OQcz3s6aFpGJ5LTPbM8dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from LV2PR11MB716723.namprd11.prod.outlook.com
 (2603:10b6:408:3ad::19) by IA1PR11MB6465.namprd11.prod.outlook.com
 (2603:10b6:208:3a7::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Tue, 24 Nov
 2026 23:39:57 +0000
Received: from LV2PR11MB716723.namprd11.prod.outlook.com
 ([fe80::3d53:51a0:aea7:61e4]) by LV2PR11MB716723.namprd11.prod.outlook.com
 ([fe80::3d53:51a0:aea7:61e4%4]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 23:39:57 +0000
From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
To: Dmitry Antipov <dmantipov@yandex.ru>, "Karan Tilak Kumar (kartilak)"
	<kartilak@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin
 K . Petersen" <mkp@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: snic: simplify snic_reset_stats_write()
Thread-Topic: [PATCH] scsi: snic: simplify snic_reset_stats_write()
Thread-Index: AQHdeM12TMkGqiy/bk6eksosbWRLe7c96EaP
Date: Tue, 24 Nov 2026 23:39:57 +0000
Message-ID:
 <LV2PR11MB7167236A4876CD6D16FE760A68AB442@LV2PR11MB716723.namprd11.prod.outlook.com>
References: <20261120085910.630467-1-dmantipov@yandex.ru>
In-Reply-To: <20261120085910.630467-1-dmantipov@yandex.ru>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB716723:EE_|IA1PR11MB6465:EE_
x-ms-office365-filtering-correlation-id: 37401101-312c-4e87-cb8a-08df4a843f9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261021135927099003|261102123227099003|10067099003|261021121427099003|261021123027099003|38070700021;
x-microsoft-antispam-message-info:
 5NKumjKwvUha1PhDdbd1mwJ4ep9kKmbcBSJq8ozngGQGT0ywx5q3/0SpOk0ZfmORJ0KxrdgapOU39f1Set8kEPfU5PVRjqRnceL5bBuLs1AGp3Fy8gPV3zUnlL6iu6humTG5GF1zG0S/Jhh/3H5z6wZeYRly6LNgP7t8ukxELwllRFRwexnXy1j4GQ3pkaUJEc3JjuOtdxVeGq/5C5Wrw0P3IrH5X/h4sncloQ8cKSitT8KExe7oEfhtq+VtMeDtDvqL635qjwO8XDHkgvLugc91VLYdZyIO2LhqwjPM6gPUXFr2QkxqJ8/AsND/c0aTNZJ4JnIx+LFpTpMkSvg5GdkqRKcaPA2EpY0wiXuzxixE/xWpAaheHJGdyIBJPVYyboDyJHydfwWS3xybuMmruDqY5LyPa6sFUV7c6z8WgVEaLNw5RDVlO2fc9sur6eWJmp6blifYN10eosrH3TIQObyxW6yAUxkDxZXfrwPNYPeRVtE5QjeQhBVN3ZbgX2LCKjCrfmOo8DQoRhUMKJDJvyMWQcmIVmGlAUPLLSrTBDjSOzEJBHKz6OGFZs+bEdbBGkTOgSY2QHm7wvXk0lEo9ZWL7C3tsWZgOm13ge628SvawDaPegWItxaeTo3Gbg7blxsKtZrWIdenaijXNx8wju+NcaNe0EzFbR3sxc2UzfgGitEfjAk7c9/d5gCU0TNfUXHfpTvz5I4V17ZcqN2tiXECxe56W3D6/uMEfOW1oX4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB716723.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261021135927099003)(261102123227099003)(10067099003)(261021121427099003)(261021123027099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?46I/rLzxOCvUJGIBsaFVucECsjNsrOB2GVugkOinjAKCSG/7Bl4+mBUU53?=
 =?iso-8859-1?Q?vJCgW7/b58/Pf166OfSiV/T9u0R8CcrsNJI0SK/GlERfNnMiV+ceWII6Yd?=
 =?iso-8859-1?Q?DjWgsvJnwhiGGL+OHsGPjKEYNT8+5eokeiK3JYb8DIsJWjVCLhmUTeliog?=
 =?iso-8859-1?Q?FP5igaPDWyTaGb1az8nEX5H2grwUdzTcsGdBFe4338m3jXQ5QYn1BhU6N2?=
 =?iso-8859-1?Q?op+E7tM0BtftwHj0IMso961gCPUUjfwiCMm8FFavaEfhHtRmjlNND7DvCK?=
 =?iso-8859-1?Q?MgvtigPynAomrElG7RIGD/Qnw2PCs6/AFJqzZiAOY4NqUhjXZXMbI/o7ko?=
 =?iso-8859-1?Q?sPr086LVV6OAcWbSSvOQ2IC9c9DLziAaoX+USgCZ4G7VUChcrtHGAxuZVj?=
 =?iso-8859-1?Q?QSsAkxI286w/8lg9jV84kjy1xEltXwMwsC6c0BWFOOfdW00XsksoY+X1Oe?=
 =?iso-8859-1?Q?sY3L3DWEJZX3ZMWi7b1qQzcWCgro04mVJN0eXaNTZ522hvaIMZg/33bfZB?=
 =?iso-8859-1?Q?j+FLuF1p4l8XcG8e0gSyqrNWmrQ7UhsdeGiEdMTMi4H/xxNTPUij/na8TT?=
 =?iso-8859-1?Q?dUKQqNx3C12bVKHvsyMODtYtk2O9kR7a3tbEbVfZXMsJ5wKDDePzIaNOC1?=
 =?iso-8859-1?Q?eWWv4WVCMudkrGmn2QfyEUCN5pseqyVs9D/fkT9kxYZ3nluS57tpLbB5bm?=
 =?iso-8859-1?Q?VgETpfVo2C3rqjKnMhf++hYjZy6b/TdJQL5EAAjVIlbim2TXCqb3MCXK+w?=
 =?iso-8859-1?Q?t54U1GMWir3Xc5iLYEBGXRmySi1ZgOOIZ+pFMGbZ0FQuuzso8tts8h5lW0?=
 =?iso-8859-1?Q?U80rL+EBx8NF3p6FP+5V5ZIs2Nc5FSoI8dj8OFGlOyuBcXea1wfXFzBjT8?=
 =?iso-8859-1?Q?yGfzUOhgvOM0iDrKXq9KWdFWYlWwRf5YY2XpakbE7bNypC2FWHWKn/ARZs?=
 =?iso-8859-1?Q?qxGL0B0FNsX1HSRgI1Kc2DXepLygdG+X3dVhGoVMnuHqkbFzDB+udH/zWA?=
 =?iso-8859-1?Q?h6zP8MKk8SoszbZRcoD0jiOFNcL90KPeY2pAfLtZrOFLGEWxfnh5mwkLWJ?=
 =?iso-8859-1?Q?XF+ap6vAr/KZvhvHth/HFA8dgWlq76e4lH1wxSsU0gKX3j3xx7j6PtXdw/?=
 =?iso-8859-1?Q?rfziuOIiNs0vZoVCkfiORCpSKOAvzV79IiWGKPC2sDLmobund+wJM2+4v4?=
 =?iso-8859-1?Q?wpYFZdn9jg8hyAh2E7e7PeoiE3lA2BoeNF7fQh4TnRePxg5KlZy1mf9Kli?=
 =?iso-8859-1?Q?G4378Ryw+ZuvDiYvlCDiT3no5oxMWEZ2nAopcUy/nO1seHxvJ/5vV8NJlC?=
 =?iso-8859-1?Q?lxBKon/PkEcs7rFiTkc6GvuSYSfrzEowAPIBuvB/iS4IQbhpoXD5wO7ZPW?=
 =?iso-8859-1?Q?CcpkLtWZjjpS0uW00qAAC9poDcCReLt6MxfbRPKzEg1d4f185v/+NU0U1P?=
 =?iso-8859-1?Q?UQ1ovwaTqs2ZDoXi4LiroVV3U43d+c74Jri+a3AY3SSqqejGtN8/3ba3uF?=
 =?iso-8859-1?Q?mf78Rm0ttv63QgOr5/VYYeZ3zvONhyDPJBrhXVzL7mbCI19StOpAQGG3Nl?=
 =?iso-8859-1?Q?dKy/u67f/7PUaFZC08gOCEwEkZUvW04/ATJXCDaqYxHSLBr1kk0XQgmGae?=
 =?iso-8859-1?Q?5lygP6IjdYOaEm4yswVD/pr2xy7xhkmclyjdY8lkvhsQuTTAuhQVL7tWCd?=
 =?iso-8859-1?Q?7j1uvvOAK5YM2dY4Avl6IvKc3lzWjdtTZKfqp54y8VBUD7awvvyYeBz6jP?=
 =?iso-8859-1?Q?UUWxI+355DX94zJsLlzY6zAADmURP83GQ72bTRSRYDiBaeyC3ZgYDloFHT?=
 =?iso-8859-1?Q?cQUQ0ajqrT07cA3+vpgs5hhh/Yq8DmEKp2LfHy78IazC/Etr4Xrk?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	CzOTlvDWBsRP29NEQcJCLCmbVQYz0D8YF+/OCK3h91zE+Ior3TsSO0147J6rw0yjvh5JvHy8UTrfti42oaJRQRoEpQKAyUvUiUi2UVaOPrkHBYlAqjtVac+2v6bn6MuSV4eEglggG3PEF2A2zuf9unXk42g6o3TOh3xiS9s+DaMUlkbXIFzVFxPxJWLJI+0CtvFH87l2EeTh1U8Ua7QguTbh/H7SGVisrT2plzZi2Nn48E8cgIXWk7cFaE3K+q42ZxOkLjqOt/xaHL94FNR+7e10qzeRguJ2RLrI6AWAiYiukUR1CItQGJmrnvbBGRiOIVEC+fAXilVEea/qHzCzEQ==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB716723.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37401101-312c-4e87-cb8a-08df4a843f9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 23:39:57.1060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nR4Ax7crE2EGKNGyQt5+c2YW7R+OQofyB5ZLjj65d8niC+XCgOPU3GzAxBos5K2yPNb8CrNC/q3t71+O+Jn6LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6465
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-1.cisco.com [173.37.147.229];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: alln-l-core-07.cisco.com

=0A=
=0A=
________________________________________=0A=
From: Dmitry Antipov <dmantipov@yandex.ru>=0A=
Sent: 20 November 2026 12:59 AM=0A=
To: Karan Tilak Kumar (kartilak) <kartilak@cisco.com>; Narsimhulu Musini (n=
musini) <nmusini@cisco.com>; Sesidhar Baddela (sebaddel) <sebaddel@cisco.co=
m>=0A=
Cc: James E . J . Bottomley <James.Bottomley@HansenPartnership.com>; Martin=
 K . Petersen <mkp@kernel.org>; linux-scsi@vger.kernel.org <linux-scsi@vger=
.kernel.org>; Dmitry Antipov <dmantipov@yandex.ru>=0A=
Subject: [PATCH] scsi: snic: simplify snic_reset_stats_write()=0A=
=A0=0A=
Use convenient kstrtoul_from_user() to simplify=0A=
snic_reset_stats_write().=0A=
=0A=
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>=0A=
Acked-by: Narsimhulu Musini <nmusini@cisco.com>=0A=
---=0A=
=A0drivers/scsi/snic/snic_debugfs.c | 11 +----------=0A=
=A01 file changed, 1 insertion(+), 10 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debu=
gfs.c=0A=
index edf3e5ef28a6..b4a679d0c718 100644=0A=
--- a/drivers/scsi/snic/snic_debugfs.c=0A=
+++ b/drivers/scsi/snic/snic_debugfs.c=0A=
@@ -107,19 +107,10 @@ snic_reset_stats_write(struct file *filp,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0 struct snic_stats *stats =3D &snic->s_stats;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0 u64 *io_stats_p =3D (u64 *) &stats->io;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0 u64 *fw_stats_p =3D (u64 *) &stats->fw;=0A=
-=A0=A0=A0=A0=A0=A0 char buf[64];=0A=
=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long val;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0 int ret;=0A=
=A0=0A=
-=A0=A0=A0=A0=A0=A0 if (cnt >=3D sizeof(buf))=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;=0A=
-=0A=
-=A0=A0=A0=A0=A0=A0 if (copy_from_user(&buf, ubuf, cnt))=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EFAULT;=0A=
-=0A=
-=A0=A0=A0=A0=A0=A0 buf[cnt] =3D '\0';=0A=
-=0A=
-=A0=A0=A0=A0=A0=A0 ret =3D kstrtoul(buf, 10, &val);=0A=
+=A0=A0=A0=A0=A0=A0 ret =3D kstrtoul_from_user(ubuf, cnt, 10, &val);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0 if (ret < 0)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
=A0=0A=
--=0A=
2.56.1=0A=
