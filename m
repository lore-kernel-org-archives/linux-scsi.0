Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.7.81
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795249644;
	b=luU1ZmVoIbyeoDIjNJJZBe1zqnjINQs+HtFRm7Wgl535wqNCQ/rZGuWsW7lMVqQOb4DV
	 kdx9eWKf4dqbrOALPO2oj2Q6RKPBNTzxamq3mPO7foflkwE6iFqUBoBX9vPCoz2NQOZWg
	 dkC485QevG0ZAcJwXAerlqJZ03WVU/btJ3St4v3VYQi0iqv8KPKkORhwZfNWgncYuv8EK
	 CjI9i2ih+GQF1mFZ/Q5y3CKMPIb5lEk6K3YuGYeu7jdSSaRjOo6ucpXlJr/BJ/xpy4gMR
	 0iKvGRtXrFrlsDCEWDqHzb09IEnT4Q0SVh5E+G/omgKxaCCyFJcR9Ma3RTsVnXLG/8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795249644;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=qV3WVoS4dzzrMOS55utp9Ebby9MXsjhiy5SfKTuAN1c=;
	b=qFD6FO+tHk3YDIP6KATvcvoXt3OOu1SZyFtTO58vC7vbN+g/Qmb1L+Rm63trNl98ai+Z
	 GMipUx0qJiKuudzk7YROngPGogZtidhnrrEzB8u7hP2PHBJRK9rvuLzy/xxaDU1+zlE01
	 Wgip1e2YcWUZA0JMiqTo58Zz17hF0okeEzq1uX2kT2HnWIxKHNWaa75n1/KEuP6hZ9f0T
	 qWwn8cRynrv4Xe1jRbFr7hC3oRQ7Xj1+ncKE8BN47OVQSk0UmyqWWZufvb80flGj/UvZe
	 l7iDSWsaFpzMqZZPXPDvg6p2AONfmk4KPuddCRY0Oas7dPMR/LF6D/vR80cJ3pM/oGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=metFdvCI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.7.81
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazolkn19013081.outbound.protection.outlook.com [52.103.7.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AF6606A330;
	Sat, 21 Nov 2026 08:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17AF6606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=metFdvCI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZODFMPLEd3ij5kQDk9+hP3I0kr3wGX7uX2UwzWlNX78NOJChLffhRo27mmJyJEXkuhCLBq9sIhu8YNUC0Qjt74/6U7TZ9IXV0PYjJPxpdTt282F2TCa/gQEXtpmcpSJtp/G0VmG5ttXTZZMdfcjCBn/ffr9pFS0QWM9EZbCGWp0mq9vMu9s99s857ltSvhuRvZfNk+n7f2mY00To7Gyr44nyEoaZjQZ6xoFFGficRkKXBULA0VLC5D4wCRXw9HdzeuKQ/q1msNt+6gNk3aRAEJAnZ5jW1iiDm2J8R9L1eCRX9NqN4PoSGWDMk/PVXcHd1qARF//0Rx6F8D/6GcYeUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=qV3WVoS4dzzrMOS55utp9Ebby9MXsjhiy5SfKTuAN1c=;
 b=CtwBXR8xGYA/GnVg9N0DBMpj6zXJlnD25OvMTSxb+mVehEaacvWHvggSxxw3MztTcbJOdi3v1sK7bOy0imNEttI8gjtzv9pNh1O0GTbs15NBI24pjzra6VjbcAkuUFBK/OZF3YkS77e93Cys5dRv5w9+s8osG+dekx03m9ntlA0qJ1pmSbhMcTekLujAP+yMWnKYxb3ogD1PdO6EyfC6xjA9vOOKEkoy3AsdNSrOBSfbIoCRd8tXX4sa1/7F1bN20dgYjaN1c0/A0RMeVw/JxB9GrG2KrG39+nTqeh++5f8CT21n1lfJia/eb2h+pvu+Lz/Etf3DfTMF5PWqHMwusw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qV3WVoS4dzzrMOS55utp9Ebby9MXsjhiy5SfKTuAN1c=;
 b=metFdvCIHKeLKtEC3P6Mz6jVidkQID3fitjDUd4TjsBPCvMUvnuvOjHSmK6KbDduXN/I6qg9PGFDYUBBoFs+RSieiqt38L0niHDREpocD+Fa2SVjbdu24y6M+SWR6XkGIpiqYm7756yQo42wYCe51FLt0a5hIqTkbNXrzjb9rZIwQn/Z5WAjLS2KhG5HANF2QdsQnmF6fQQsi7+2vOHULuVh/Fu1JEUOwBv1vQfiMS1KWT8SMtrOaLjJV8H10imcjcfcZdsHq0PPquNpZdbBNd7upNa5aTR4BTCmZ0fiTaWyoApuLHQm050ctlxXM7ctW7OzjmVvX8mQzz1ZAqGN6Q==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by SJ0PR05MB7838.namprd05.prod.outlook.com (2603:10b6:a03:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 08:27:21 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.011; Sat, 21 Nov 2026
 08:27:21 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v5 3/4] scsi: sr: Release CDDA request before user copyback
Thread-Topic: [PATCH v5 3/4] scsi: sr: Release CDDA request before user
 copyback
Thread-Index: AQHdeZIgcu/jIp5+J0GSSrDxiP6gDg==
Date: Sat, 21 Nov 2026 08:27:21 +0000
Message-ID: <scsi-sync-v5.1795249365940711260.3.x-professor@outlook.com>
References: <scsi-sync-v5.1795249365940711260.0.x-professor@outlook.com>
In-Reply-To: <scsi-sync-v5.1795249365940711260.0.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|SJ0PR05MB7838:EE_
x-ms-office365-filtering-correlation-id: 860df887-40a2-451f-f2ed-08df47a94375
x-ms-exchange-slblob-mailprops:
 ZILSnhm0P3mCYd7/icPJlj+s+m08RC6kiGL7oxeGQg3nCdIaccq9JDAHBuroA9EHPB4SVkXiOWsdZUiEqtPRz/CX7ec+DbcLfdJ+GNsUG0t2LUXGNBvHCiEsUXprj++Rdsu30eGKqGQTzQQbBhSzMHUBKZLwty3kNWm2iIhsPwirKzU6FEhHK/M7w3x8w8AxLlduAwWYV6MUFq9z8snANiooMOOQjvijuTg57Rk0Qdtq3R+alkB/gbiBTQiVYGFchxk40hlOSY6e5AnE9je5g35MXAMFX+/JyICgcB6cmdy/SgxEiGoVozoxC4wH0prb3xFEokf44M9pceEjdaAGoD+4XCaPoYOVPvNvFi4vYFSgwj2PUVMTPVaa4PtbUOMHfuYZ/OpN1jyOKiEFEUNL5NxZ/eVWZVr3wQaRC3nLgTL/rfM3BupOzssdO3dA1zaNLJBL29RHmVNlMFEZBovJNVaF2EvHYcV+YlQAH5jsSg85TihV9ol2TWqUnGDlsDSuT0rn2O9VJV+jqCffAlxlbvoBAHFiFohINQvrUHCGN0ZvsEju4p4InlLlPxxH3oktvjeRhgQHOpxcjT708POPQuHaATI41acZws+bu4KtQ37sV5uzQphsGIfeFxOW8ae/GioHLI/XhnMam8pnrCZrpqqNtPDYpxhVgXGQSO0VeGcUi8uAaXprKIE/EB25DAswgZLA5+Apl2DY54EQGZXmN2EA6LBET/FCmSOlhlu2vvGd3Ue6qqp1V2E+hl9Ds66WiPs31t62aAjGWTULYp3BTsX1WBrfXLOE
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|38102599003|41001999006|22091999003|15080799012|19110799012|4140399003|25010399006|8062599012|8060799015|24021099003|31061999003|440099028|3412199025|4302099013|102099032|1602099012|12091999003|10035399007|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?MATdQYm+T8YA8bTnpn/U84vHIt3Ivi9LbI41wvWeVTvqSKA3FKlQUIPx+J?=
 =?iso-8859-1?Q?2MvAYeBvdNC7vBWfV2ECALdexh3vgG73V1S+S0Nu+ESGf6EABKnQshwLzr?=
 =?iso-8859-1?Q?AatFpPiwQNR3/+bo/VALiyjDF6UALRgQiNvAcGNtM7nVDQolBtxBHgXeRP?=
 =?iso-8859-1?Q?BsWObAML5ra+d3wFnEwb3UU/lX8KcoZtkfmKq3UpfkGr5gz0ilVWmcbD28?=
 =?iso-8859-1?Q?Rewp5KFEADg54o01ikycuslIExB2AWImuJJM5JCeBEe4ssSCFe/66/eFjh?=
 =?iso-8859-1?Q?2PSCOSKHV2vH9i4jU/A1lq/zn34dQJirFfjcpCoqL7xg0wI+Jnloh4a01u?=
 =?iso-8859-1?Q?O4PI4BB2zINFpXyoAi/vj9uxgA5aIBdxlcLKcrJZUd71OVh/cDfKAg4B48?=
 =?iso-8859-1?Q?mZOAPfnSZOaxeg/KaTcnysSuNY0HlPPimnRy2DZpWghOaSkbXJrnhY+8Jx?=
 =?iso-8859-1?Q?9gdpfL/K8TaNrC6QOktOXxwVvgHxULeHA9x1N2FsyLblp0D9NlroM28AL6?=
 =?iso-8859-1?Q?ZkGDJW7YfhYKgdUMvJRzBrL0ov2mdUFkxxWNki+9qvEirVTppvfM/Al4Vp?=
 =?iso-8859-1?Q?09E4tI2Np+aC5jbVaZ+4G4kbKezOcD4bsAQf/6ZaQoC69rGViNsx5pcjjG?=
 =?iso-8859-1?Q?z9ttZRC/VbuE0D5Sp0pySHOHktf3hK25hW+1Q9iF3J6VkWZhzW7VlUj/bc?=
 =?iso-8859-1?Q?JCUIVAXRCBctiNTzc5v/cbAiZnP4OvviSWWYrkweiEyl3OXp9VDL95aKNX?=
 =?iso-8859-1?Q?hv3HBspqmjyLXom5C3zVpkYRQErBP9iHLWrnpOq21buCFehKb+jxSEOhsA?=
 =?iso-8859-1?Q?CvqjLykEjPktVwbWhVjUnjjjME9F7c8BPNEgWWtDaAgB7KXDajZL3pG80D?=
 =?iso-8859-1?Q?1ZkiFmo52yEHdcvHP9YXVSj357VahEmnD9aWCkLJunt6abgutB4SQ10Wkc?=
 =?iso-8859-1?Q?nNF+GUpOxjLCJIbZ7xrF3MaZ51o6TcB/PWLNIBbvobSoU1mOaCc5US4/aZ?=
 =?iso-8859-1?Q?zcmu2oMpVqV2UUs6hG6lMnM49LtKEp+GW+4iksmnC1BFz3TXPLImdwMMuv?=
 =?iso-8859-1?Q?0ZMEVEO+YwPZJbeBtTUzhaztxWn5FkljET3uwYAZpRrewGsXFyhLimH/Be?=
 =?iso-8859-1?Q?j9WHdaxLTNjigiYG1r9WbM7AIP3Soc4YwV3uROpMUBjNej1udaPQd6Dilo?=
 =?iso-8859-1?Q?qc8QDMY1B7BSKwA6/GgiRlwH2L/8ptqQh9Y=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?cKSMbGqldw8T1MONHcNVAq/JUqqj/UYNRJ1+/ggKHa0YUd+o+5byokz6c5?=
 =?iso-8859-1?Q?qc6Rndj97anM2Vf+2gk3+ksuHUSryQt7pWinzYkZrYk8KM5LidwG0+JP9x?=
 =?iso-8859-1?Q?u1vmhJsa1Pme0NLYY8TGrsKHdYCz5s1EhSRMJt5EWpdCQG0lNSJQx7b4JX?=
 =?iso-8859-1?Q?h9JiKs6gvbq2VEICTzT99VUYnebXul7n3ndDJ2toWRIh65nfya4pUHvn5i?=
 =?iso-8859-1?Q?iry/lUxB3wpm4XXJz4Wz+5zuN1+XOlBdNa0pJ6OfuTaYW6Q8JK4RHT/WXw?=
 =?iso-8859-1?Q?Gjfjn/csZTfwn3lcRTa60Alr+34MWmJrhuOU/EaYRR+3TpZXLeD1zZ5JoY?=
 =?iso-8859-1?Q?I39Zi/ge2n6JrGxuEau+4uEfgL/ciiFUo3HH7VFT24yZOilp1oyQEkt4eW?=
 =?iso-8859-1?Q?HvsS5KfIi+B6gqb/X9EyAoFs+lj5ovdDVoovur2NWJbWsX6XvnDf5oz8Lr?=
 =?iso-8859-1?Q?hZ/c25w7lvLslOmLfd6wkzEZG5jno4NOi4VdfGQJwNtkMB8qPpiC6qtzCg?=
 =?iso-8859-1?Q?emDjavrMJmNW/usDI10mrYZG0ZlAXt6t7fWtgjciKHrnhJyiHxws3t5hf+?=
 =?iso-8859-1?Q?T+8011WppIX3DN6WVXdPhXyG7eH2cISsqexWqFL0HkJbsbZqDM92BJBGAa?=
 =?iso-8859-1?Q?UI9/TZ84DN4iXyLBHtX4igagVURlwf3ykeOjHthn7kiSgri8a1cV6jsnSL?=
 =?iso-8859-1?Q?3AVFvmqAKZLIOBFxQnBZpqbW25c2uECefi2dmCkxWAGlsBJUtcVkTGY+wL?=
 =?iso-8859-1?Q?VsBxkeqvP6OJpOqFx2PnqG2out0fUKm0zEAjgvWsbBmiDacGJ29HEHEVVD?=
 =?iso-8859-1?Q?DBCJ6ZqA1zwcm+Y+SqZS2XZDgbgwvyFXCO/rsNYv6qkqJf3BWiuK+kaphE?=
 =?iso-8859-1?Q?ySZkiEs34S3TWKsYsY+H5fcD/96Q+ctt7fciICR1D8Q7Pb99IG9fNNbo6z?=
 =?iso-8859-1?Q?sJKUiZa3FzHUE57vhDC3/vecyB1XVZha2uJueDo1M0VbP3UpurN6T00U//?=
 =?iso-8859-1?Q?JoOxpSPAAMxxeaHUeN7d6EYfoXKl2DIITg53QiL7k7et38EVpEPezr8GSi?=
 =?iso-8859-1?Q?qHG8htLqjFqQk6+M8cpoKWpTKolL85eLadxRu55us4QYXrFOEzimQtpmes?=
 =?iso-8859-1?Q?JJw6m8UYbBqRhmsYIdA036EXtxYLize3FXjV9yNC9x15wiRGl3+XMCiWEW?=
 =?iso-8859-1?Q?eKWmvpE9F2r4rTW14q1sfHx4CEeVZ+SMiBvdKJBGzbtv8zp4/bQvf8vIpi?=
 =?iso-8859-1?Q?bJWWYkB8id5mmoXwk3i/pvWznfZ07m8ytQX+IKui33+lHtLaL/rua9O28x?=
 =?iso-8859-1?Q?0HUSUqAr7BOXkmmW04h2ELmTLlT08cw7lYLOPLeBGGXwV5CD7VW6iQsjAd?=
 =?iso-8859-1?Q?JAkvJY+OALRFzFHTqRqgCf4WSd4h1UrFkBRcdCPUBvjsBC/sdBQ9G11Lbh?=
 =?iso-8859-1?Q?PGP91hxhTPy1yfwb?=
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
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR05MB3281.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 860df887-40a2-451f-f2ed-08df47a94375
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 08:27:21.6140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7838

sr_read_cdda_bpc() retains its completed request while unmapping the user=
=0A=
buffer. For a bounced data-in mapping, unmapping can copy to userspace=0A=
and fault. A fault that needs I/O from the same queue cannot progress if=0A=
the completed request retains the available tag.=0A=
=0A=
Release the request after consuming its command result and sense data,=0A=
before unmapping the original BIO chain saved at submission. No request=0A=
or SCSI command field is accessed after the release. The saved BIO chain=0A=
holds its own references, which blk_rq_unmap_user() releases.=0A=
=0A=
The finite number of request tags introduced by scsi-mq creates this=0A=
dependency. The later move of the CDDA implementation from drivers/cdrom=0A=
into sr was a relocation.=0A=
=0A=
Fixes: d285203cf647 ("scsi: add support for a blk-mq based I/O path.")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-cdda-lifetime.8f31a2c97b42@ou=
tlook.com=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
No code changes from v4. Clarify BIO ownership and the tag dependency.=0A=
=0A=
 drivers/scsi/sr.c | 3 +++=0A=
 1 file changed, 3 insertions(+)=0A=
=0A=
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c=0A=
index 4f2e8d1be6da..c64c25e9f404 100644=0A=
--- a/drivers/scsi/sr.c=0A=
+++ b/drivers/scsi/sr.c=0A=
@@ -969,8 +969,11 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *=
cdi, void __user *ubuf,=0A=
 		ret =3D -EIO;=0A=
 	}=0A=
 =0A=
+	blk_mq_free_request(rq);=0A=
 	if (blk_rq_unmap_user(bio))=0A=
 		ret =3D -EFAULT;=0A=
+	return ret;=0A=
+=0A=
 out_put_request:=0A=
 	blk_mq_free_request(rq);=0A=
 	return ret;=0A=
-- =0A=
2.43.0=0A=
=0A=
