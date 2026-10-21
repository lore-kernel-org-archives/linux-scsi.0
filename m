Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.7.82
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792606693;
	b=Hu8r8VG+HLZX6qE6QkgrI3hsym9RocBfVaslVrvi1jyF87m7fD0BTG72niqZToSCSV2+
	 hI0wIxOiA/JwUylYVz7Pjen+iik1z6YrJcGnieNYuqMRNH/2p9cKrAiFxgupVPGjleAmm
	 yTx7DUCsoXusGMmnw4wHpSotvjK38mndJP0968wKVxAH/Fi17NRokXUG194bnAt/TsZ6u
	 Gc6h9sNSZKfUuUXphfTiKFIofNc3NWnc5vC5sywgkY8Yq4jEAY2Pm8ujTZiywl+UR37Yt
	 vlOJ0EbRHss4kh+eB4GXdDneyMnWxPJyYGa9a2d1WMvBfth+bn3tC2E5AY88I49xP1w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792606693;
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
	bh=YsVBv70gasaMvhBOBgE74GigNOjvYXoN58icmABjKt8=;
	b=dsjdaSiVYYl/NXXBSgtUL4Rdx7ebph9ewcHY/qTAiZHh5eI6JhkTucRmZufKEo8vC9Bv
	 13JE3pRI4cioe0W8r4WunHj5YAzCy/txyl9K48OFOP9FCaeJ1rfc88RCCTG0e9adIf9ui
	 El1U1eVoIbE+yLQJRBBWUubh5irKnxmHKu/6cFtrVF25kEkhgY85UqW0RGHxwHzofdddk
	 ovXqJ/2nnI/B2W50yD2dkQgws3MayEhcVHF3ut03HtwW82KBZ3e8qBS+A0lFybRyBygWp
	 YSh5xVQyiuhF3okBav0+RG73WHzfBGiuSZIn8K7hDwx4By4sqs+NBbZnof98vNn1+OQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ppErAAFK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.7.82
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazolkn19013082.outbound.protection.outlook.com [52.103.7.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E95606A319;
	Wed, 21 Oct 2026 18:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92E95606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ppErAAFK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wqf01pFSuLQ03UmDtAxjmoxNfte+qSkAALs2JWplHh0FbYuqNtB6mzSwdjdN3Jg8i3hXr8CsV2izd2WuyHYsNMkEUonF9/+haNEut0A+m1X4fWKcx6QuRlWaUu81d33q9B7lxNyHWA0cxvFG7T9rFTbPv+YOt/it9dUrjFinilymWrl1XjGfwmYBBtb7WgJDQ0KsBhWLpDusfvYPec07xrXD7HODC4wreeSQP8XH/XofGDUW7YAZU3avWRyXALX5/1tUzA/xuIpQLSvXMY8Dg3s27Yptd9b1ZWUHP71VzQBE3B6cjTuHwrWwYyUeBgeXYoSxZHLWeKaWihzrReJtOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=YsVBv70gasaMvhBOBgE74GigNOjvYXoN58icmABjKt8=;
 b=d3y12oBs2mDsLEdMFa6YInT99jxUhiYZSJEjzb2Vw/S883LjZJ4NyC+a2kuEecv/7MihoyPTd8vTRW/PjmbS7h65B3w6vFxf626X2nN3LNH+40CsV3GfE9WDoatpIFNJa1LJTJf57KKx/UPZ8Sl+4LD756mI9E8Pc2J6hVN2HmcDt30WlHJdjT79XCZWmgoq4rPcQTjxSkTn4furSmQmHx+2kLBJNlSwMX0CkCc9/7dTSq1agDY3rwtOnkmCTy7ApI76abMaiRdUq0IFXbgFyHviPgaj3HO9Don+zbPg5LbzB3MEA/hHa8z98+C2r4a+EEYyxuSG4orCee0O4VUM/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsVBv70gasaMvhBOBgE74GigNOjvYXoN58icmABjKt8=;
 b=ppErAAFK1RQmaoOnSSZy6QWQ7FYVGQNmuu0DXtk4y08J7u5SeYMFQPUOrezmmZ4KXCCPlx3bB/AzGjP/fEamgGyAWB4Sq8k81/ab/oV4o11DTKQcOcTeNSyaePC6ZwX8aoKwFsr/8BSwb+vvMrH8U4KjTx0fbRkEkO9KpjvIOjseon47+4mk2Dj8EJdp0dOaeY5Nbeb7fKNBqop5rl4++fEg1ShabJegU0imRewq948xJ9SSAJY4EfhMMfwWWeIVlFUZTQblxQ8Zt1GevJ+tn1cg+H3qC7TPwQxNVEUpQmh+TizIPrxIJmz9agIILxkDtxH0ZmVbYfROBL5A3f0ysA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SN7PR05MB9769.namprd05.prod.outlook.com
 (2603:10b6:806:34c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 18:18:09 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 18:18:08 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "mkp@kernel.org" <mkp@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "bvanassche@acm.org" <bvanassche@acm.org>, "fujita.tomonori@lab.ntt.co.jp"
	<fujita.tomonori@lab.ntt.co.jp>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2] scsi: handle out-of-range SG_SET_TIMEOUT values
Thread-Topic: [PATCH v2] scsi: handle out-of-range SG_SET_TIMEOUT values
Thread-Index: AQHdYYiFy+2t1tHIoESjUbICwwGunQ==
Date: Wed, 21 Oct 2026 18:18:07 +0000
Message-ID: <20261021181804.136336-1-x-professor@outlook.com>
References: <9321a59c-c560-4742-8b71-5b0ec1f30c2f@acm.org>
In-Reply-To: <9321a59c-c560-4742-8b71-5b0ec1f30c2f@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SN7PR05MB9769:EE_
x-ms-office365-filtering-correlation-id: a5efb948-eef5-40a8-e1a4-08df2f9fa854
x-ms-exchange-slblob-mailprops:
 V85gaVfRD4/uZtbPKQiHMaRLDxOOyjp2OadIj0sEcOcEaymq1w8jtV8nqSku0tzVKoXWJmN99M+mtwCRYp2ph+RF+xmGff1g1ohsCsZgqisPdiKkXW57YkEfZHnVF/jPfHJV66EYPKHccRIv1RFRdP/435O83Z2cx4ADE0Dr9LBzMG6vvC3Qt3W49PBnAb71SBIpS9P/KCjFUhP7L+tnSSWsCBkkNQe5CBXTR48SEgHHu8UJPv5Xqo/bZ+c4Zh9sdLt8ffZRXzwGM9ETryVnd8GcQTgPwEh6X22C3i0GN7hZ1owKkaGPfQqoHbdiiFInQUgCsXRL9OdrjcJRjtCUzveTPeDdvVD29VTDIdqmZbmqIFMVUKr+6fHAe+r+yp30MWURNYbCeBRMBrP3VvRylK6SqzGiXyJdUN6zBEl1fg7/IuO4cWvJu7sB+FLlJPnsblBnXo8XSRCuv/tV3KGs0FDTXzmjFCjK7VW2brRz1IBNHv30cdx7VUODJj3AaqxUjBCD6tHE0tGkqn+5Oq5jtyqdTD2jSqoM7s20d2OMnHA8lyP+FCLYpozzbHf/1mkuQTyFSJPv6kCp05szQr0HYCBgTDC1k6Io2elVu9WRLOBdT8U77lvJ2EEhKMXIaDIEYxgtIcH1Kdggfs6iTAwkymjacb2OtDVd7YgN8RwzDxTKPvqjf1lLrRzN/ffieIFZ560AvhUMVOwZdyewajOCTNjko0MA02NbCziuDUD3ftTExDviAcSkJOoqv7uGHPpZLu8JVC4tOOk85n7dalcP419yZTaGwxEt2mjTV+D82vdZDdMSF+vt2hqj88yKw4w8iRN3iGzhut2vIJTVUhEiZQ==
x-microsoft-antispam:
 BCL:0;ARA:14566002|22141099003|19110799012|31061999003|39105399006|15080799012|24121999003|22091999003|24021099003|8060799015|25010399006|8062599012|4140399003|38102599003|41001999006|4302099013|3412199025|440099028|102099032|1602099012|26121999007|10035399007|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?4HnmTYnGkxX1xBLf+unQtjkjzxxYxOcmex7ajfWC/mPE49Gwj18F6/HEBX?=
 =?iso-8859-1?Q?ow8ipyV5XrPYPoTBw9atjprTVz9d9J6wO+6T9hyLh1Pc2G5IK7HBpbi7Ov?=
 =?iso-8859-1?Q?3aro5BNoqQSLZuj4xgqyfv9LprakaWGgwG/IVvB3b8QRlBYXbhe03CVOmC?=
 =?iso-8859-1?Q?4cJ9zVe7yI7xQWP8KSEUnLzCi9JgRhvzxVcbFRogul3hPXbjsMPsJQoC97?=
 =?iso-8859-1?Q?ecTDA4fl3p7u11Oah2En92j+P4Gw3VVgzEB8V1pWxmbed2BBPHN2aLJhxR?=
 =?iso-8859-1?Q?XRAa71kQNd/kGl8P/I+8Y9IAE4xwqUnkR4IBKKVxGU7aE+5T0jJon0Fq/u?=
 =?iso-8859-1?Q?q9JkSF2RLzY9MkG3pYz/2s6qM4HXTA2Lo0yY8ZFtAfiyoGHvjNH/gTcH56?=
 =?iso-8859-1?Q?v/hpp9rs6453Bf/I8x2u9oypujQ25PjkC2OvOLp3BB1yOjDIQLjyjCvl5n?=
 =?iso-8859-1?Q?CHR4ALgNl/2lAL6clcRoF585KeYpESuhE1YCfLtRu6ExhKvtMktKfQ6Wtn?=
 =?iso-8859-1?Q?vYz2PuLlpLo8uWGHKIJgnGtnpogB7K/T1MvfytZ9k6hF7jz5y6kDiXz1LI?=
 =?iso-8859-1?Q?wWjE1XZY/ckrWbY9YQoHD8Gteg3bTM9eANpHjqFuIUlwLm0KNwDheJPjJv?=
 =?iso-8859-1?Q?/IxOKaXr3bB4x2GKDldzO5RqU1/vrF77t7rF2NaJH6B3iarC6RxfZJtsdT?=
 =?iso-8859-1?Q?CFqzx5FJqGCbYPDpW+2Cd3054Hi9T8PWd84F4dxj/NRpqzs1pAk8Bkv/Wo?=
 =?iso-8859-1?Q?tKLnNUTGNh8hKgc4RgP/eWMK3LegnNujC6Q5tXItxWUxBWzwyl8lAFx7Of?=
 =?iso-8859-1?Q?KyqW4sfw44v0RLQEgmTLRwcrdgJ4+Ulw5rdAzNwroNyFbBnlnkcvgxO0Cz?=
 =?iso-8859-1?Q?f9IwHuNMh5JJF9n6uGJ3nx1sUY3mBgAeyJ85Oou+9KvwSyoC6mYlZ03rZw?=
 =?iso-8859-1?Q?lS1HnOtqIFq1wrNvVVU/2P6TWH0vahThKUE2wqt9q+j0ajaJVAp6iSHeTE?=
 =?iso-8859-1?Q?DeGJWDP16dRalQdsFYwW63K5we+UlRGxOlRIPvvXbZ3lLFe6ZlnX2xACMq?=
 =?iso-8859-1?Q?UFh2yZpyOXiUCYPs0DbAxhUziWoCSGO1UVCFM75PV5wj4/Zce/j1uPEi0+?=
 =?iso-8859-1?Q?4rf48ytjPsAMU6/5op4oIbSD1P/mPujlAQqQjSoE1lXx4KRr0Cff/GXxCc?=
 =?iso-8859-1?Q?ixMYRzmEZkCYgb9CfxBr1cm4dp/tKogFHx0=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?HO1wDrN9LtSahE3LAKu79sfDinms+oTFLwXWNC32HCtp8litLW0buHz3ks?=
 =?iso-8859-1?Q?M8QBxI0YaXsJnUkNwRVyy5mWRO6ALlg7tqwPhB40jlG9o/4TuMIBlqn9AZ?=
 =?iso-8859-1?Q?CBgdzN6HXffhL+qqBcNNbbv4MSgdLcRFDfRQRZyXZoBcmMXbf1o04pONpP?=
 =?iso-8859-1?Q?TsLYYcbycYid6N8/ZRK/1PWtRos5QqTxSTqGAIR71zgI5QD2ArW7mDHRWS?=
 =?iso-8859-1?Q?JvWAYrCd3mOxjdc/1sD0CDi60e7F7YwEx5BVlSyJgnzTO97uESrjPnPcoN?=
 =?iso-8859-1?Q?Msv0A2OR5I1qo+5SZ7q85zbbTy2WKHZwo2RvHCdtjzbMoDBcx9h5gyInUG?=
 =?iso-8859-1?Q?1uR4GPKJT/Dl58HIWwTxkG0rAJQhtqIOsgCoex1Uh1Gh2/MyzjsZt43fzU?=
 =?iso-8859-1?Q?s1npb4PcDbhfn3aweaGGWXuBb1r9lDkBqUKjlJ1Tycy7cKrohA3JPNbwtg?=
 =?iso-8859-1?Q?jg250UbsBWahuG7Uiqx3GIYlmqotAmZx2sawQf5s1RR9Zq+/GPbeqO9L0M?=
 =?iso-8859-1?Q?agLeQygpIHvxGPCs+E1qTQbTzTx78YH5kFQVI0CYKcO1uJY8Z2aX6gZ/qL?=
 =?iso-8859-1?Q?AAe7dsHlBpGZ2wycmadhb7ohIVPeZxpqjZq6ejfGt/3MA9b34CJeHNyS+Q?=
 =?iso-8859-1?Q?WPpgylWc3QkIkNDFsNeFJF+Z2VuOKKZubF5Ty+z1dP0hE1gTAPASfq1D18?=
 =?iso-8859-1?Q?NOlumKvxEmeImJhm8d1suGS0FNjy+lf3RgJlXxy3+fslclOH0Ic2try99Z?=
 =?iso-8859-1?Q?+FD1jWOHOHjHIs+JJkWRWYLAQHP5OIpYWeCtMVp8ByWWKRTFEg/LAQp6Ze?=
 =?iso-8859-1?Q?dMyhCfe7JSia3Iui/dlcEX0sZz/eHXACTadQDZ2JAfKH3nGOEnKgcqSgry?=
 =?iso-8859-1?Q?dmIFUazNPR4Ic8CKTF/01KIUMX+dWhInZgaeN+xXw5BH5VMo/lLDZvwqQn?=
 =?iso-8859-1?Q?oAwbnJndjWMoIkA98KOMXrsut5CBflZAH7pGm1olNxnghmn2Cvci8ovbtJ?=
 =?iso-8859-1?Q?T2tfhfwe9pff+ii7GOfI1digg67xO+ZsY2aFQ+9HBzaSKaJYp0yVmYh2vc?=
 =?iso-8859-1?Q?tu3agL+2OfU1YKH49Pw4vCAjSS9a7OjDYj5kiE6JjwPHdq1c8pgVmpke/g?=
 =?iso-8859-1?Q?NA+mkOjHtsItWR/ZSv9HMfw6lGe5G5ihR4+sURMMSGtZAf0YcI8XnESms0?=
 =?iso-8859-1?Q?cPdFFNHS+YYVsGYQnyR5HPoqmf0/FPv5PrQ9Rz14z07RCYYWHMDmpMP8Up?=
 =?iso-8859-1?Q?pg7+VQxL4Fp3BvoG6KQcyYoSf5Dwej6/i/41v+EB6o6nGvRIpWgsMx7pow?=
 =?iso-8859-1?Q?xAKuqYOpnl+j6FC9VRa1CLH72RH6bAsC89/uyUUNbJElxUfKes4O683Jhv?=
 =?iso-8859-1?Q?zfRNRWRaS4L4am/TQBv0Ty7GM009S7+b0WINSmyX32TQeewgOkhOruxRgI?=
 =?iso-8859-1?Q?+AIlPtNzc8viV/5r?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a5efb948-eef5-40a8-e1a4-08df2f9fa854
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 18:18:07.9923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR05MB9769

SG_SET_TIMEOUT accepts a signed int in USER_HZ units. The sg character=0A=
device rejects negative values and limits positive values so the converted=
=0A=
timeout fits its destination field. The block SCSI and BSG paths instead=0A=
pass the value to clock_t_to_jiffies(), which accepts an unsigned long,=0A=
and store the result in an unsigned int.=0A=
=0A=
Negative values are converted into large unsigned timeouts. On 64-bit=0A=
systems, large positive values can also exceed UINT_MAX after conversion=0A=
and are truncated on assignment. With HZ=3D1000, for example, 429496730=0A=
clock ticks become 4294967300 jiffies and are stored as 4 jiffies. On=0A=
32-bit systems, an overflowing conversion becomes ULONG_MAX, which is an=0A=
unsafe relative interval for the block timer comparisons.=0A=
=0A=
Reject negative values with -EIO, matching drivers/scsi/sg.c. Saturate the=
=0A=
converted value at the smaller of the destination field limit and=0A=
MAX_JIFFY_OFFSET. This preserves successful ioctl behavior while avoiding=
=0A=
both narrowing wraparound and an unsafe 32-bit timer interval.=0A=
=0A=
The block SCSI behavior predates Git history. BSG has exposed the same=0A=
behavior since it was introduced.=0A=
=0A=
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")=0A=
Fixes: 3d6392cfbd7d ("bsg: support for full generic block layer SG v3")=0A=
Cc: stable@vger.kernel.org=0A=
Reported-by: Bart Van Assche <bvanassche@acm.org>=0A=
Link: https://lore.kernel.org/r/9321a59c-c560-4742-8b71-5b0ec1f30c2f@acm.or=
g=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
Changes in v2:=0A=
- Add the pre-Git Fixes tag for the block SCSI path.=0A=
- Saturate large positive conversions at the smaller of UINT_MAX and=0A=
  MAX_JIFFY_OFFSET instead of allowing narrowing wraparound or an unsafe=0A=
  32-bit timer interval.=0A=
- Expand the commit message and boundary testing for the positive and 32-bi=
t=0A=
  cases.=0A=
=0A=
Tested on x86-64 with HZ=3D1000 through both /dev/sr0 and BSG. Values 0,=0A=
1, and 429496729 round-trip unchanged; 429496730 and INT_MAX saturate to=0A=
429496729 USER_HZ ticks; -5 returns EIO. Zero-timeout SG_IO requests still=
=0A=
complete after setting the timeout to 1.=0A=
=0A=
Also tested on an actual i386 HZ=3D1000 QEMU kernel through both /dev/sr0 a=
nd=0A=
BSG. Values 0, 1, and 107374182 round-trip unchanged; 107374183, 429496729,=
=0A=
and INT_MAX saturate to 107374182 USER_HZ ticks; -5 returns EIO.=0A=
=0A=
v1: https://lore.kernel.org/r/20261017084547.2880694-1-x-professor@outlook.=
com=0A=
=0A=
 block/bsg.c               |  6 +++++-=0A=
 drivers/scsi/scsi_ioctl.c | 12 +++++++++---=0A=
 2 files changed, 14 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/block/bsg.c b/block/bsg.c=0A=
index 82aaf3cee5825..632b3f6d98b29 100644=0A=
--- a/block/bsg.c=0A=
+++ b/block/bsg.c=0A=
@@ -132,7 +132,11 @@ static long bsg_ioctl(struct file *file, unsigned int =
cmd, unsigned long arg)=0A=
 	case SG_SET_TIMEOUT:=0A=
 		if (get_user(val, intp))=0A=
 			return -EFAULT;=0A=
-		bd->timeout =3D clock_t_to_jiffies(val);=0A=
+		if (val < 0)=0A=
+			return -EIO;=0A=
+		bd->timeout =3D min_t(unsigned long, clock_t_to_jiffies(val),=0A=
+				    min_t(unsigned long, UINT_MAX,=0A=
+					  MAX_JIFFY_OFFSET));=0A=
 		return 0;=0A=
 	case SG_GET_TIMEOUT:=0A=
 		return jiffies_to_clock_t(bd->timeout);=0A=
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c=0A=
index c14f81403a09e..8277e6adf497e 100644=0A=
--- a/drivers/scsi/scsi_ioctl.c=0A=
+++ b/drivers/scsi/scsi_ioctl.c=0A=
@@ -9,6 +9,7 @@=0A=
 #include <linux/blkdev.h>=0A=
 #include <linux/interrupt.h>=0A=
 #include <linux/errno.h>=0A=
+#include <linux/jiffies.h>=0A=
 #include <linux/kernel.h>=0A=
 #include <linux/sched.h>=0A=
 #include <linux/mm.h>=0A=
@@ -195,10 +196,15 @@ static int sg_set_timeout(struct scsi_device *sdev, i=
nt __user *p)=0A=
 {=0A=
 	int timeout, err =3D get_user(timeout, p);=0A=
 =0A=
-	if (!err)=0A=
-		sdev->sg_timeout =3D clock_t_to_jiffies(timeout);=0A=
+	if (err)=0A=
+		return err;=0A=
+	if (timeout < 0)=0A=
+		return -EIO;=0A=
 =0A=
-	return err;=0A=
+	sdev->sg_timeout =3D=0A=
+		min_t(unsigned long, clock_t_to_jiffies(timeout),=0A=
+		      min_t(unsigned long, UINT_MAX, MAX_JIFFY_OFFSET));=0A=
+	return 0;=0A=
 }=0A=
 =0A=
 static int sg_get_reserved_size(struct scsi_device *sdev, int __user *p)=
=0A=
=0A=
base-commit: 58161ead29e50d70a317ea26b472e0c7508e69da=0A=
-- =0A=
2.43.0=0A=
=0A=
