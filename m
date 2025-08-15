Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C923221265;
	Fri, 15 Aug 2025 19:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755287985; cv=fail; b=MuBpIJVIGY/QEkH+rQAabe6z90mrRdFdaWq5qEFjQ6oQaa7qQm6wQOWJWhY05NAJeqR31l8oFG8TLZcHsIGce4fB1x/7qV279uKNubHuzIhK4OcwBLOcKzntVg0V73fRCQUY3vOGL11E1K0q64oT5gSITo/SANK9QzAzQPugqjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755287985; c=relaxed/simple;
	bh=ERMsXUlox6MAVzqWwbqWPAG3riS+Lir5dOyKFb0Fs7s=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SEG6cddUvC1ksmE00prnwO9EA+QPdEkQ3ZyjvCojIs7PKf3tbEz2E/VIR4U6ychA1rCBiBSNtcjHTMn9tNjrLTPp1lsvziFB7wFJ+vudFa5luQ96vqpXfyFknj5A/pjk61HN1iXucaIKQ8woQvutvIOhsXVx3uR5P5nn1DXGTu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=bzF0Py6M; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="bzF0Py6M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kUAo9cmZwvDB+OpGmp3IPy1o9Awh6v0T4zNmWGEvOZvHgCPhuR0Bh+NJIrt5KbCNbsMUgoJdJfNnFhrKlMXsj1IwvW/w2ZaDQ/h+cRuvFThUv79Lg/CxKg4zWSANFSJWowjzXAnzviionmsCNCLmKRCSiXef624NA8yXCM8PWOLLQcvR5DCt1lDlJlq+sc8agbfYAukyaoTHkmYb1pFLP20vJgxx2uOjF8Ob33ymWDgnNDAFT/XCu2b4Qawx7jyGi5f1JzPktc8X76Tr45nrKjf5LQa0w5fVAKs5QVAXifQ+b7aw2ZOLW141DnY+rldXPH4yrs2DhqWXYBMA/W3KtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERMsXUlox6MAVzqWwbqWPAG3riS+Lir5dOyKFb0Fs7s=;
 b=TgfCcN80ywTo1LotqXFhulCdBuZDTxJFgLcegisOlnWssVpqdm0n0dxGWvWheKv13fM3CSKRhH/pHF56ZvHgKTBWeOJU9LwcQxPHyV6cdHbjGdI7twHA4xTNxvVjM5pGEm/Eebi27L3cE/ZXpboguMK3KSwnYI9b5KjU1BRcskNKe/Luf3NsTOHqqYXo6emQ1PshzRCm2ORetgb+bloQ58MLdOnG0RzdiGvlqMXIF4FCNPunuLCTMyV0tmQ2Shpz2/86yA6LOvB1YieDmeyWX5xE+1EYL+Nhuq8PL/ETDB+sUpjNQU4EVaOSR0IwiTqbwhF6jFg6kAsS4BMwSJjkXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERMsXUlox6MAVzqWwbqWPAG3riS+Lir5dOyKFb0Fs7s=;
 b=bzF0Py6MMkjq8cjt7jRO2oh/eStJ6FLWwKLuCmcRsnOHY7KC7idNm4ySTjI/cy0toIhuiPXOxKf8PLCV7fNkaPPmOXC98adjmo03jpPwUwPREO/y7qJzqiu1r0OY9zBt5r9qIQvViJ3FNYbVcBSIhBUNGuQBrIgrD8+rqnUmW7tjVWBiRyEJR6og0/V26TGlxHAOIn2L8G/Vf8raKVeiH1QEfHC83zFuDtJT7Qn+HQn0xjZ8zFvqAWEKIdRrQhijdBcaWE0NVBCyTrLdanr58mf8TMjOW3NYeQ7iHdFCxGKXsX9l490rzoz4W7F/nNpLE0xGS2HUr1S+IPEzYyoi2g==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by PH0PR11MB5207.namprd11.prod.outlook.com (2603:10b6:510:32::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Fri, 15 Aug
 2025 19:59:40 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628%4]) with mapi id 15.20.9031.018; Fri, 15 Aug 2025
 19:59:40 +0000
From: <Don.Brace@microchip.com>
To: <rongqianfeng@vivo.com>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <storagedev@microchip.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] scsi: hpsa: use min()/min_t() to improve code
Thread-Topic: [PATCH 2/6] scsi: hpsa: use min()/min_t() to improve code
Thread-Index: AQHcDd5ykpIBbsf4y0Ohanr7I4cGULRkH5DU
Date: Fri, 15 Aug 2025 19:59:40 +0000
Message-ID:
 <SJ2PR11MB836949CCAE5EC72772790233E134A@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
 <20250815121609.384914-3-rongqianfeng@vivo.com>
In-Reply-To: <20250815121609.384914-3-rongqianfeng@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|PH0PR11MB5207:EE_
x-ms-office365-filtering-correlation-id: 7f7deddb-fe58-472b-fd05-08dddc364558
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?x4md3zL9bJWijLgymt4HvRRobGBS2aFumK9ndOfBXaPXV+i4LsPe8pfznp?=
 =?iso-8859-1?Q?CuUztHOAJpX6zfZ8S9jnTrLnCgyvWXnnZq0AqNOKNR1j4Z4nqcLEi00LZC?=
 =?iso-8859-1?Q?WEAYCQ7i0RxpRaACSFXi8TgOMWPBU96k3jGZ2plRhSXIiIhlb8Z+d1dwlX?=
 =?iso-8859-1?Q?/wHyjI/NYhMdGBwF0dpSTMeXWs/W2pJoWrUvwqo7CTyOiN/7qAsW+pyG9Y?=
 =?iso-8859-1?Q?OCZfADV03y+VTQTKF0LkMyRuD2C0q/SVaXkkYNIQ66o4WyPBmic+9Byr/n?=
 =?iso-8859-1?Q?l7RRWNSlXy48zK85JqF1xlwgdP6Ns3uzCwvkIS6HJ+pdqdgaDMKiT+ggbT?=
 =?iso-8859-1?Q?NdVS0ALNhBgKT95/aLt3NFlu8px6WNPeRfdjttyYVwF59IYePHPS2Dr1TQ?=
 =?iso-8859-1?Q?fg0xFRSRxnbS+RYmXE9rNfq2hE/FFUxn1TaMpp2gu5zSOlHyI7Hz9Q9YBY?=
 =?iso-8859-1?Q?VI6d1NTGpmRBCZUXEYvsaUbyyXuOOypiKD81Wbq5Fr6BqlFDatRB+AOb4e?=
 =?iso-8859-1?Q?SSTvbS8g3KBPNftsO5q3BoPL+7HTWhbRWqnT5ouaRtW+GTM4pdOb1ipY6Z?=
 =?iso-8859-1?Q?417qdyob1dZSeeNZ935xcfG5uuXBwHyyORGnjWSScOyV529nJYBmd8NPFt?=
 =?iso-8859-1?Q?CsKn6NF6ChubmOK/Sc3pB0MCqa/4d7V5z03S04YbjbmsJvTdXoi3WNmdJt?=
 =?iso-8859-1?Q?ZT8XADlKz1zTAHhltIgMAtbikqvUaDtnDRgftJX+0ek6K8KoZRhPy/6ThG?=
 =?iso-8859-1?Q?Ck1vg9ruYiSXtkjFaedC/UvZclvC9qexJsoSxEtFlQF/3hA1nVGDLmlUyd?=
 =?iso-8859-1?Q?fzcwu+Dve0urkKSBhJ3qg+dxOrvgm54DD4/LnvsS2/4nI+EviKrnAlHHM/?=
 =?iso-8859-1?Q?Hnbjqw9x21TMccInXWRnUc27AmIR2xebOdzO36kwAEXMtzK9K1jS8zdvFO?=
 =?iso-8859-1?Q?/G+LBATauWpf3pxZb8dhIGdlykOMGq3wPWMHEVokbj12qIK19rq/9gAFPZ?=
 =?iso-8859-1?Q?DXwa7DnSCMLcm4F79vod/cZFkgBwkvSRwNrZ3rZejZw4SASocAKcZdGDRb?=
 =?iso-8859-1?Q?SSSkywd+vDrQ3oTQStJJVAlZsKSCphWIbC6jBLcDak9ApBdtEtvf26wW5N?=
 =?iso-8859-1?Q?SuxzYpOL+JjefNKZuizjAHo05P7fzRTWq9t9dzGtq/DiTFXTdSinGNxHnU?=
 =?iso-8859-1?Q?kpeNnLaOAoG9O+jBKgkC3xruiIDjT9qcGZubpbNsD3Y/ah2CaJfBXLc68e?=
 =?iso-8859-1?Q?2qbApgE6peusrBJZqsXKduyT439RYhwVe5ZceBlxgMTKl5MMCN4ACiqI5i?=
 =?iso-8859-1?Q?itVdkiHPBOzgnREkokpJ/0DdJkRufrTKj8rLVdJY5c604mzn7LtbkKODnH?=
 =?iso-8859-1?Q?m10UhAuvSeRBx5sSyaqDuJv/murh9VWCtIJXg//luWByr3f/kp/RH0Iu+j?=
 =?iso-8859-1?Q?5H1T/NUG8pPA9x/jZYvI/sH08ZOiQ6jXRjHFMGzVRcqRdQZZod+2N31Nyh?=
 =?iso-8859-1?Q?0VxvAdUw5YRnlN25v+Whzs76NfgZMkWxlMVu0+dyFnxA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?jqVvYxzIxsI+bYOtxCjuXyZqHRP8hfcY36uuS/6Z5OfJqznBppbsnLJ3B9?=
 =?iso-8859-1?Q?o24AK7UIwrfcuehLlZCh+BCCF4GMPccIEmCTR4kqaHqfmEVvcelG3Xp0P+?=
 =?iso-8859-1?Q?e9jCQ4TjkZ/ib5fF2IH3Bangkyr7lUsW5phmmOwcxlXttQNwbwB0utzqiQ?=
 =?iso-8859-1?Q?26Rllc4q2kPfeJMg8yitwz192KcKmz49zItg1pINQ9NnYduqnQutxL4Mw0?=
 =?iso-8859-1?Q?nrc7lvkKSI3TuhZmIcZjtM9AzpYvVlkEehK+3IqR9F9Z+6G98MUTPRj9M+?=
 =?iso-8859-1?Q?Ds8tJzRINaDm+Kx8FmJnTfQetIeKgv+NxWbjirLuK8kD7mKKjvseDeZmvA?=
 =?iso-8859-1?Q?kaMMHgsbGDL32eeno6nYghEEJlyYJg+0BQtRJ7+5CUbjJgPzgiSxANBTA/?=
 =?iso-8859-1?Q?DhMLVCoV0lfCimvvelsInsCPc92/uPrySpQYh+rCVjiUr4OMevxhu4u5ji?=
 =?iso-8859-1?Q?ldrNYwqvVgXwwkgo0+w5UQwcU4vVTsbQ8JLeZUIEd+qMPdGG/GTZ476Tn4?=
 =?iso-8859-1?Q?DuL9uXtRgtKc5Sppqx2vf4qZ/2Bci2CSzD8IPN+t1OFeP5y6yaTJYe7A8k?=
 =?iso-8859-1?Q?7r8Jsbo9noCEtpP6ejerxl/dsiWDKUe+PFGhCUY5JJlSL2/adBNiGsMgPw?=
 =?iso-8859-1?Q?h4NYtPoyuQUMm5hL710rsISWQKFwWLal4sy0pE0OsfVMbv4WM1zuujbvCA?=
 =?iso-8859-1?Q?7hxMyzyymjlb0aAI4GXoGN2wjzYv+tUaqlfIRsVBKYMM+141z4BCm6vN6j?=
 =?iso-8859-1?Q?N4VSpu1jdojUHIXxt6LJvUyuZIj+Jhz5v3kl5Q5eIIcdnmkqc7gQ1wXGtq?=
 =?iso-8859-1?Q?CEMa/9Seo60QIErmwctMR2xMXTgRwnNrK/JkL9QR4nZkvRoyYRTwR7ZRMg?=
 =?iso-8859-1?Q?TilpzAu0pUyiEYZkskENIkTYoIQKHodjyXkydLs9uBqgD2Lpdk4dlHVubr?=
 =?iso-8859-1?Q?pAzWarEAhJ55RpXJCJM9XId9l24WtWH+9TdqiQNGou7g0Lzzn9d7jMOcyy?=
 =?iso-8859-1?Q?7Jp6+WcKzTillBKQAooxAahhMzPAimotByNm8+g+csBN4ElVf4P4C30uUk?=
 =?iso-8859-1?Q?UIMzHZs+bj3IcDfpG+he+CKBLb9M1ToHe3d1FHW4mYa1CfhkNqHoSlG/X7?=
 =?iso-8859-1?Q?X1TAEJBV7WYDlk8ND80FkQX1nLjONYDfNBIpi51b+sWsB0rF/dp8jjgmcW?=
 =?iso-8859-1?Q?6pOm4Q801rNyxnDeGRqcgmcBJy5NSwp0qzqOytwWKkGee08Px7G6Dvraiu?=
 =?iso-8859-1?Q?m3rWdOjbELvwnuSvjnfkNOMcv6LDGqmxJobaFf7x40r5154crMCnNVUSWK?=
 =?iso-8859-1?Q?xZs/eZw3IjSkHjORaDQNshqia1jhytgXI6480C/3UizRyzoN/SjBqZO/Xe?=
 =?iso-8859-1?Q?l3y5U6wcUVncdN5GhjRCR2JlRphtkO+gFvqhmt4kg6HC/VBf+1G+/TlYir?=
 =?iso-8859-1?Q?M9u6n2qtG+Penyj3WKlNze7FddnhE8VQAtLOH6oMLlBOSDtf3rksLyeO5a?=
 =?iso-8859-1?Q?9AkO8ODokq7QfpbOW27nRUdLaPuGRHBUaV6/xd/W+cPeWSa5eQRo85I3vE?=
 =?iso-8859-1?Q?RWsSGkcrM2asMK9seeLYZdvzwebtHM8I3HRzuspOP+i1lJRfjzF8djqqSf?=
 =?iso-8859-1?Q?MvpfvOvn8xAlSlutt3jBY6G+uyuSU7v4/U?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7deddb-fe58-472b-fd05-08dddc364558
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 19:59:40.5786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 38BuEB5Y3jBkqkeybdv3uOt6Klbx+z71vwpft3eKkmTMCyUTdUL1Kh4mGTlK//G3yc6/3rXybt9wzkLC6of9TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5207

=0A=
Use min()/min_t() to reduce the code in complete_scsi_command() and=0A=
hpsa_vpd_page_supported(), and improve readability.=0A=
=0A=
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>=0A=
---=0A=
=A0=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
=0A=
Thanks for your patch. We do not normally update hpsa anymore.=0A=
But this change looks OK.=0A=
=0A=
Thanks,=0A=
Don Brace=
