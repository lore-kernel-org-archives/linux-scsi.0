Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795249640;
	b=ruIT/0Sni1oQXTcbV+fhNQDHornr5+/BeCocznVSsQKc4hqBOAafml2QP/0qi3bm8/e/
	 e0s2hXk21uFTp0zDHkyutpmRlp4+PIiFz1yFihVQlE1Ac7A2sEleyTSf9sB7niDvRbO+K
	 0bSuFGvkAntcn95Fr0qtGNQTtp1viuzffpnZeyPT42wvIVyq8Ju+yUvhE3PXa3qH4aMFG
	 Zd0jHBLDExhiVrxKFJ8ktqN8V3w7/FkMutlreEjoNaniIuSgZF4Zv882SI+AWCvcyIpOl
	 1/GG1Fzf6RdNwq6QLjrxEClbkghWT+m/VxzWyJzTaaeAKxaE3f0EfdLlmBbfw707r6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795249640;
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
	bh=y4VB9L96lRlTgRwgo2z4vQuMgyirzC7jC6fTJL1tJV0=;
	b=PHhqzZuXq3C7x4sGfepoxNxa5g637hkib0lG1bmX98A42DWC8sb9Mw1Lx3yQgeM/qLk+
	 jw887XMDrs+7yuTAMyMJlo/U4VKZVNunUFyHeAoBdKMEPhoJP/k/NHq0DOx+FMyBj7DVw
	 b1+prA7fswsaPvVEDH+3psLunUZksZfGPE52HZWo3FovGum197CmIBFZqipo4f1+kOj4q
	 t7fyscFWKRSvREQjQGsWDf9XpokLmZA6Q5KCSEOqvWC4KG2rysKbNRQT0e+v5zlie/q6C
	 4UQKj+dxjfSnbwDRT/JyTQf/FKzibPYw0u2els2crrEtPmpCUX1q7waE81F5/dY4n2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=eH7fOOrd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.3
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazolkn19011003.outbound.protection.outlook.com [52.103.1.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9B3606A331;
	Sat, 21 Nov 2026 08:27:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB9B3606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=eH7fOOrd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Td8XUaPrZ7xlJnmUoLhQZmyQ4hc6US3pIDYVz9/wMgiwig56lcBFv3awVqjMpgiNV5LWic3B+cWovyp7Ws1py+XVozdrnBpN4B9Q9e6rNo9KCqEDqhyz14mmyGtsZomL2hRZf6BnaFVdMKf/GAowzCrU8QWGUGonmt4S+L93zEz+U6gGmdmLa5dvBEVEtwltrDVV8SfGzy7x9yVUk36V+YtemUXjPPYLOlM7I0u6jmxsWqGD8jSvnEjENyg+uSL+gxPqLwtWJS5Mwd83ArHFU9qcQ/0GvuAX2JgZzJuQpk6zpaxWmKvqkXhk0x1RWVcBETre8wRrFmDym5+X5c4jpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=y4VB9L96lRlTgRwgo2z4vQuMgyirzC7jC6fTJL1tJV0=;
 b=HDgDdiYeN3RXzNHKTieW08jMuPtk+dMsmICkKz0YOukgj0QEYZiuGu4VBOKIhjHdKMoHKYVyzp2BbMDDjk8LU2uMpxOh0yvoD+n+2kqf+77Kf7KFGGOSgrr5Ac4wYHINveWN+dMg2c6Od9+T4u5AeecDyPSq3oIji5IKBLv0T3YYDFrySt8v9Ff8nM/LbkGfWjxmFuZN8rGl31rkVcxoRXU8ZNwiZg2mjWZWly3X9bZyLq5SG1sEsTW4s0fLIFVJPLT/vB1OdFJ+pz9yFOb0LC/PSIfnUYvavpwzydli1ATVQYPgHVfaUbEDplgZEBCnmQwx3AG8QOtczCxs3sFhfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4VB9L96lRlTgRwgo2z4vQuMgyirzC7jC6fTJL1tJV0=;
 b=eH7fOOrdplI/ChfD38wjfDTZtKLC8h1o3s5GjKOa0gs4tZNmz99vH6tX1wBJirhP9oGicuw+6OSeD12KOthOnK4NRQyN2DNvapfU0FeoP1PBEdSGY0ws0OVZOIEDpgREai7H+5IxxjKfCdql0jqBcRFyIVJLEni1aq0mkjMD5YnhcasukU86CXu+kKZOwqcye5q3QHBq4W9w7p/eN9IAWnt6ZgfaKgygoNP6pkNQA0pKJkGschUorRtGl3eNhhnMxOs+kD+knVh4dwc2I+wuF5yrgfHumm/1TqdzqDuRQjlEcKJKeqGHa7xAyaz29g4kxNzEjc810Yvg/6AVsT5w3w==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by SJ0PR05MB7838.namprd05.prod.outlook.com (2603:10b6:a03:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 08:27:16 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.011; Sat, 21 Nov 2026
 08:27:16 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v5 1/4] scsi: core: Release SG_IO request before user copyback
Thread-Topic: [PATCH v5 1/4] scsi: core: Release SG_IO request before user
 copyback
Thread-Index: AQHdeZIdTZPw+qM98kGZSgtermfN0Q==
Date: Sat, 21 Nov 2026 08:27:16 +0000
Message-ID: <scsi-sync-v5.1795249365940711260.1.x-professor@outlook.com>
References: <scsi-sync-v5.1795249365940711260.0.x-professor@outlook.com>
In-Reply-To: <scsi-sync-v5.1795249365940711260.0.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|SJ0PR05MB7838:EE_
x-ms-office365-filtering-correlation-id: e05dcdbb-5beb-4af6-0407-08df47a9405f
x-ms-exchange-slblob-mailprops:
 a+H6FLLcF3oArmUeIqZHaFYD1WEyA+la2PAKGYkJPxGaxqN+TUa8ASYZ6tJ1UhmquISV4Tiv/OhaLh5b4BuxhRT0w8jGOx7vqajob1u284TAbSmsaBg6cFd4m8OlihBUDiZHehoxibPNKhvw+R/JaHwLXkJBtjkI4Wb2e2Z740h9tp1X8tuwLfhKzZ/s9gzl1gozyK+Nhg9SPIu9Y+PB6dSxKRzewR3W03vmlUnxCYwMhPRIKyM2eTt2pFeiOR4PMZ6dujCXKDIjqeTwS9WGq5jOeB+jJXyQbyKlZIxye75gZw0H6LwKdQ+nFqPCT/W/os63cgX97F85hsmw1QYec2GN1S3FUoKJMjDAV4+6Agx9jDmCj0b5EIpBeUroyp1/nchtmLlqmygpVsYnfklDc+MIqFngEGZmmuwMmP/vDMht5u/L+rU0VxFpTHLpOnjrI1j35xfiJw+Hz9k4hWMaWpsFnjIF4MHdJ/5D3sFK2MIi5ZFE9rQrBIGe1EPQlUEHvIRWzOdoh3b7ABkqt0DzEWd9GQnAH/UNQ1B1hmKROhJfnvECm4OkkFrqjp89TI6c6CRfLh4jS3EOZVXw8M29gVWjXqHvDMRNU49wJdFU/FCS+VnRS0N3eeZLbN9xjL+UYBugCz7tMTxrGnx55o1sWi9KTPcBfb69stbFONyN4S+YiUDuQQwVRMttvkEULeXV+THMRIwfDpM2vn4WzKTGxhIVtNkJDlt5tSBREfkzjadzp7MUPNN1z6F1fkR9NUNsquzKg1XpF3/KYCrMa05XKu66TpTyepnVhUNNt3WgWe40rgyuDVMJR4A4cY9ALw9e
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|38102599003|41001999006|22091999003|15080799012|19110799012|4140399003|25010399006|8062599012|8060799015|24021099003|31061999003|440099028|3412199025|4302099013|102099032|1602099012|12091999003|10035399007|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?psWmk1PDvaSwiV5O8ykZpLWrAS2cQCkQngPYVwgAsmaqL+okmzXIfiwiWh?=
 =?iso-8859-1?Q?BfGXoUX17/o6Ab6bahJTe23YY6RNEGCOgdM3YO6Y4k0OyNmhMDiuPxb9o5?=
 =?iso-8859-1?Q?ScJuAaU+rmXSDNdmc2cH6LI49EHiOzAVsSqxS3/8rqoilpYYAkQQWV59Uy?=
 =?iso-8859-1?Q?dKaUf4m7shiswdKG95Tyn0gVRyBjo5sZb4cgCoGCKiKaS8Vk7LUBlnWRnx?=
 =?iso-8859-1?Q?R5kl2busEFJxMz+FRXTYVuqlhy1A0jskLkOiUeEhw4R3O8gAz2xS7rMpzh?=
 =?iso-8859-1?Q?i895J0BEg7ZKU2V4SLmtlFyj8vyDdygfBZJRBZHzHK96VdUdIrGBO+bNac?=
 =?iso-8859-1?Q?Fo9nP10rP3lD7xzrj1pu57IQ50rYkis2736zYHIoJboApF6RcIgVWzWvIg?=
 =?iso-8859-1?Q?kyYo6AipW5M8cBHwy3939m+CjuBvYmOgdEKofvsRFgTBNlBnmrQ3+p1S/e?=
 =?iso-8859-1?Q?t8DyARsXACQs27vS9cehoSvzUtrEYEkXVi3kasdqAOjU89h+XwsPpCpMjD?=
 =?iso-8859-1?Q?OwJml4NeZW7N0kYieHziUq4wJY5yuRMqvNcbWBX7fWHykLWodMXzeLUMWz?=
 =?iso-8859-1?Q?Xq2+zENAmpRJsmpwqotQcF4OihGuNRoF3WXUvIW/lmrPaAi7GJyP3hTaue?=
 =?iso-8859-1?Q?21UcwBgvk7nN07g6qShEEIQ/RjYc6ZLrp1wnWghfZG3neNrPKY885UCc/M?=
 =?iso-8859-1?Q?TQuqHU9QoDpG1KnWKHyliXYyq+usaEStxHFMRHhHAeSKaMr14iXs34r3zU?=
 =?iso-8859-1?Q?C71E2KaRzAPtzFwuo8kVedgAV2GZNMH1wg/GfFxKuTMTmpxxzCmuANzpLQ?=
 =?iso-8859-1?Q?a40PInO1gb8lvXYegLtuYa9+S4uBJZf/NMOdo2t5hiDpgg7S5a9p4Forpo?=
 =?iso-8859-1?Q?Ui+qX/ApA/tQYG9+c4b/1y8HeYv6nJupGrAocroQIyJmf95+sK63BHEVyT?=
 =?iso-8859-1?Q?I3egbBd3oeZc5oSAcaPdTIdNZFntHvxiyGSPMoeCU6NyfaDfVdDnQz+fNk?=
 =?iso-8859-1?Q?t2j1g65ReO1Lqw9aXDKvSbXfGriSjIGIVJxyD3Go6NINIgtHMWwB6aMokP?=
 =?iso-8859-1?Q?8PK94VyiDI81EU9IM7tIjPn1LsjFN38G/TMdpKECDClTRd9BbzBKwxsMNh?=
 =?iso-8859-1?Q?ROf/EGEjeJkEKAaNsHT4i2OHG5/2otGMscQcr6qERy8dDjUHfu1O/QPwLf?=
 =?iso-8859-1?Q?FbIqAF5Nb9pPVZe1hCkPKaSUvMDxTpgLOCs=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?LwXiXT9Fz8ZGT8U7nCSn/rGs5k/1cCzHNPZ4HHlxrD8GUty9wpabukaX1v?=
 =?iso-8859-1?Q?YFM7ND0HFeK0BMN1l/fLjwLdnRct+bBNSu8DqrhLYE0k4h+5VUVi0WFsqi?=
 =?iso-8859-1?Q?7aRbBQDg7dZcVCETeSwSYkmaCtsldlazy5H1EC2wplzPzJn3Of3zHU4IDM?=
 =?iso-8859-1?Q?YQJHkuJ3fq6dp6PE18N9UxtFwqAnVtcKcImsXqdtJWkwBH1p6jggkjvAF9?=
 =?iso-8859-1?Q?sEOVqmIQ9Hli7GXUCq7rOVLv0wWOycBKsP0JRfrX5BTtNl5UkRZvJzf8CI?=
 =?iso-8859-1?Q?axfc3dB6AAEk0rO/NoSAndJPGn4HDzepW8N6jsFcxJDSE3+PNIMEsSVjOx?=
 =?iso-8859-1?Q?D1T8BSAhS9Y/9Y2AWnYilxnD7OqCAVgJI2SVXFVCXGqCR0X70c+hVIGT0f?=
 =?iso-8859-1?Q?VHpC2ZYTP1R3NzcyKeY1+QFLK9pJhhEuNZ2IM3A+1CuBtB6LW0H5xsn1hl?=
 =?iso-8859-1?Q?NE49pHS0fDgSMqITaQOsdb6XihFcQ0UTYikDlNC5pTEcy2yS0M/oE+wCe3?=
 =?iso-8859-1?Q?xN+8kpGCPbyn7YXuWmJWMdrVN40to4ENpIbRGuXeTJKCeB3AUPq7IOKzQJ?=
 =?iso-8859-1?Q?mwOLNcZ6Vuu86pOOKwxHC3y5dE28OGqHnpWXCc6pf+bQgnhy96hJtb/fh9?=
 =?iso-8859-1?Q?BkbWwEX/gIRnvj9NApOEhGc4FNKSkoQs3K/oZGs++shhgFdbfB76qrPN1q?=
 =?iso-8859-1?Q?dlbxLbSNS2byb7QQu1IETQR3E3nS5lswavJNkUQFRyb1Y22SzG7FDqTF7x?=
 =?iso-8859-1?Q?Rewh7IGfkh2ND4127bvmmt4a7GreONHV2n2yAswQn4lmRWQenNP3FY1SFI?=
 =?iso-8859-1?Q?3Le22cyHA07IlR/k33iyO6JyNg3f/Ck8gDvK16MyHKgtID2Sw95DJPynZ8?=
 =?iso-8859-1?Q?III80e4S4sowJks2qVrztcuIVtEjqgH5GzRkZkc6pqDEGaCwlzi8h5Ugay?=
 =?iso-8859-1?Q?HugeOR1w2AV99AwSZqg0Rx9ENYoM1pVNloccfYCSOj3IJIcfsUP9dSl+5I?=
 =?iso-8859-1?Q?wQwxF4085ssbwpgw6tUc69Qrp+Tq1B1aerQ7JvX9W2Z0P8fx7WX9U0kVtG?=
 =?iso-8859-1?Q?VQ7AYS4mkZ+vBBBrfwokDzWhZBdXKsbzJwzoXRVyO9e1SePIoVRJ4HgKBs?=
 =?iso-8859-1?Q?YkT9w/oWm3i85qgeMSHcgxQ0uzonKgFI0Peq50+9JWX/I/ZlrAPzur3cz9?=
 =?iso-8859-1?Q?AQR9Cixy6L278b1LI0xRJi2KWgXamqYec4bzYQzM1qv5+eH+d/cbNdv/Xl?=
 =?iso-8859-1?Q?UKPW53zFD5XrGJBeFUBIOJ6mKiZkF56JmFpbvDgXr48a0KUDSPLCZ1PjhA?=
 =?iso-8859-1?Q?3uGUN0q2V5s2fGV1lhYhowjPuULgk2r9rk5eXUmFpDAv0uNbjk567Nj/yv?=
 =?iso-8859-1?Q?FTZ6cc11PJ/P4KsGrmw+COWESdKi7GUfxSgwtDF/7YtEIf+DwcT/OS9ChQ?=
 =?iso-8859-1?Q?4U36uoEK2Wh3XQhw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e05dcdbb-5beb-4af6-0407-08df47a9405f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 08:27:16.3794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7838

The block-device SG_IO path retains its completed request while copying=0A=
sense data and unmapping the user data buffer. Either operation can fault.=
=0A=
If the fault needs I/O from the same queue and completed requests retain=0A=
the available tags, the nested I/O cannot make progress.=0A=
=0A=
Fill the kernel-resident output header and save the bounded sense data=0A=
before releasing the request. Then perform the user copies and unmap the=0A=
original BIO chain, preserving the existing sense-copy error precedence.=0A=
The saved BIO chain holds its own references, which blk_rq_unmap_user()=0A=
releases.=0A=
=0A=
The finite number of request tags introduced by scsi-mq creates this=0A=
dependency. The later move of this ioctl implementation into drivers/scsi=
=0A=
did not introduce it.=0A=
=0A=
Fixes: d285203cf647 ("scsi: add support for a blk-mq based I/O path.")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-copyback-review.31b8d6a70f4c@=
outlook.com=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
Changes in v5:=0A=
- Document that scsi_complete_sghdr_rq() frees its request (Bart).=0A=
=0A=
 drivers/scsi/scsi_ioctl.c | 20 ++++++++++++++++----=0A=
 1 file changed, 16 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c=0A=
index 91525103d074..16a0b6bf573e 100644=0A=
--- a/drivers/scsi/scsi_ioctl.c=0A=
+++ b/drivers/scsi/scsi_ioctl.c=0A=
@@ -408,10 +408,16 @@ static int scsi_fill_sghdr_rq(struct scsi_device *sde=
v, struct request *rq,=0A=
 	return 0;=0A=
 }=0A=
 =0A=
+/*=0A=
+ * Save completion state and free rq before user copies and BIO unmapping.=
=0A=
+ * The caller must not use rq afterwards.=0A=
+ */=0A=
 static int scsi_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hd=
r,=0A=
 		struct bio *bio)=0A=
 {=0A=
 	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(rq);=0A=
+	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];=0A=
+	unsigned int sense_len =3D 0;=0A=
 	int r, ret =3D 0;=0A=
 =0A=
 	/*=0A=
@@ -431,10 +437,16 @@ static int scsi_complete_sghdr_rq(struct request *rq,=
 struct sg_io_hdr *hdr,=0A=
 	hdr->sb_len_wr =3D 0;=0A=
 =0A=
 	if (scmd->sense_len && hdr->sbp) {=0A=
-		int len =3D min((unsigned int) hdr->mx_sb_len, scmd->sense_len);=0A=
+		sense_len =3D min3(hdr->mx_sb_len, scmd->sense_len,=0A=
+				 sizeof(sense_buffer));=0A=
+		memcpy(sense_buffer, scmd->sense_buffer, sense_len);=0A=
+	}=0A=
+=0A=
+	blk_mq_free_request(rq);=0A=
 =0A=
-		if (!copy_to_user(hdr->sbp, scmd->sense_buffer, len))=0A=
-			hdr->sb_len_wr =3D len;=0A=
+	if (sense_len) {=0A=
+		if (!copy_to_user(hdr->sbp, sense_buffer, sense_len))=0A=
+			hdr->sb_len_wr =3D sense_len;=0A=
 		else=0A=
 			ret =3D -EFAULT;=0A=
 	}=0A=
@@ -507,7 +519,7 @@ static int sg_io(struct scsi_device *sdev, struct sg_io=
_hdr *hdr,=0A=
 =0A=
 	hdr->duration =3D jiffies_to_msecs(jiffies - start_time);=0A=
 =0A=
-	ret =3D scsi_complete_sghdr_rq(rq, hdr, bio);=0A=
+	return scsi_complete_sghdr_rq(rq, hdr, bio);=0A=
 =0A=
 out_put_request:=0A=
 	blk_mq_free_request(rq);=0A=
-- =0A=
2.43.0=0A=
=0A=
