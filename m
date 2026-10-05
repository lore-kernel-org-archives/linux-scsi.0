Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D304570DC;
	Mon,  5 Oct 2026 09:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193323; cv=fail; b=R2urxPILiqUZBvxGp3xvzNitovcxUuThrYPOrYNceFLaTEafoGVXxY089ePfZ2yQRey0RZHeNOv0fLegKKkmZN2k3UObnUDRoip89z756SHzTsmKMRmhGuz48TuWlDg3PlHdcdbgJ2NrdpTxSvvZC6VuuNcLvyjAFUx6hKca+CY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193323; c=relaxed/simple;
	bh=zEGtqhNla7RBGInUnSqSvSkiFL04FVKmyZ171xdgtUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IgYJyxGv0yLS6yfi8TDC0FADmqmV2LMOqg6sLt+gRUDkribZbJ2G/8oe1rd2K5xlqFN0c8q0gljip0XviU9c0Pk8yAH8lTOboSsfy7n53vWMS9KRGPGf/VELqeK6bLWYBL+JHB7OolyEk6/hPvJgeKV4ufB/SK6Tyz5EvQWzpRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=GbljLg5G; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="GbljLg5G"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6954bVA61462658;
	Mon, 5 Oct 2026 02:35:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=IMN2NkiFO/e4RljHV81cNJ1zw6zXBNcU96wMfbsDoN0=; b=
	GbljLg5G7xV76DQyeawCa5g9JSehmHh75e3FXkSKv8TaqPS89fcs1U25iZWVHn0i
	iMKmuxCepzvp3ZqbB2yOh5nfBo9tfIhUsoIvz8g/28R6o1nL9JOJhpK+1S7KaSfS
	to2jljNEbsPxq1oKbFWhz6lgyEE57srEvVcdt2hPx4GHZlSS4RDJT2iI7gyItFz8
	X3TbLZWon4qvwhMqioYqzGMgxwsNgy/ahgtFiMXMVqg4k7lQbHdOuyquz79IpTB9
	CDfO7KFhTqIdiofE56ipjo95k8hpT14aYxB/ESeHrUkk/cCuwGw20+nqcNYyMlwn
	BUDbbmA+yWRYmsrO70vi8g==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023134.outbound.protection.outlook.com [40.107.201.134])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4h2w011xbc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 02:35:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pX8L1WM56YW9qfRlIWgyApG4ZfeAnFmUD8al7g1OV/jSjGFGOU8e9A8jZk3f3+lOr1RBooKfOvosQ4ZnzNH+s6stjFHZ2r2ZUrovRubwAHN+nVKUapmtZEeUvw83iHY34Ux/EfesI2j+fyi4ofUN7EJ1HXRZvrimuo+jpieVFuyOFS4sLdN8sqFd0M6HDQNnoN3c64zPlCZK6raNPIGb4P5OAI5Lu0hNKo+ckFPUPPDjxEq+NCxZc9yhfJ/fzVU/fado0SppevJVuSC0fbC5s0Z/DtHHzXpwc1urMlN3wLMD+f0rJCkJXH6xkmJB9y28Q/zlc3SGS0a387HaIm9ZYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMN2NkiFO/e4RljHV81cNJ1zw6zXBNcU96wMfbsDoN0=;
 b=wpWp0WcVREZyQbOCw093WSbNO3dpiQkFxWZXGXFA8N5ln+KGgnfxljKaengMUKGVcD1ddrNyqVKgGuSbzPtYee2CrgUBjvs6Iz43pqdiSF9qY+lYIBKFTRSN2xFmhuuz6gHHHCx691RUs0ujBZuAL9kc/i+c4/nZE0wHbXjuA4PCSVoDzyL4R1uk2AEYWg3U9LA6BRCfMGo8cQ1YplRMlp49m7M/NKapEuL73cMc8+TSfCVKaEQV7d+/NTiRmxinXYTBhscV1dWr5kxzRYGGQ7cZGFC58nAJuFkDprCHjPBwX4w9elgVeLC7euPJdHkGObtgJZkgYW7CH/9ncbS1NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=windriver.com;
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by SA2PR11MB4987.namprd11.prod.outlook.com (2603:10b6:806:113::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 09:35:17 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 09:35:17 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: atomlin@atomlin.com
Cc: axboe@kernel.dk, bigeasy@linutronix.de, corbet@lwn.net,
        frederic@kernel.org, ionut.nechita@windriver.com,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        marco.crivellari@suse.com, mingo@redhat.com, mkp@kernel.org,
        neelx@suse.com, peterz@infradead.org, tglx@kernel.org,
        vincent.guittot@linaro.org
Subject: [PATCH] genirq/affinity: confine reserved (pre/post) vectors to housekeeping CPUs
Date: Mon,  5 Oct 2026 12:34:46 +0300
Message-ID: <20261005093456.137013-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ul7xqsblqnrzx67s7urmtc34qpemuf3jeduxmsuwxwlnky7eli@mzdpwwgug3hg>
References: <ul7xqsblqnrzx67s7urmtc34qpemuf3jeduxmsuwxwlnky7eli@mzdpwwgug3hg>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0223.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::6) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|SA2PR11MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e6b862-7a34-47e7-9f19-08df22c3f75f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|52116014|366016|23010399003|1800799024|10067099003|56012099006|11063799006|38350700014|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Cp+HowwHw+0qPXEwj4ed/wkCAiFxiwiNh5NSmRm5+bkhKkarg/m8JZ6v3XPIdZIV7AM4j5xhE2jrTU9rymwL5Ce45wuOzFZE0zMDZ5TtmCUXBNpBKGi45Gw2NraMaep5XL0fnIPOMZUFvOt8aogqhksVLuXzmEaIN7biAqfL2yWqGallu0Xc+h14pTdDF8D32VhWaXHKKioNSBpE4hP0mbmxRD6CFL7KWNpBve6IBKGVD70yCKTbqfrsw7f+eAJiHKeQscyZO/lfzkc8AalfVortMqTiI5DVmmbyKs744FcM1lkik56SMV0CCmCH2c0iAzTkbc+sKd4JNB813qhFEbr8x86SmvQEhCzGMTOTh8XDJF6Ko/Vo4R9Xnxl91ErKmz/VVYkSstDehsfiwpSLl3mK1zyfsFcBBzaS7DKFlI6+uijKPfMcs7EPuTxa46wBaFZ29ndckahcNwORb7NMT6lS21M6grR5kDLNFpA026qmj2lDBfyuUpF9+jvN2TAMh07MvWaKsjN6U2N1lQVPzmoevb4SB6xOqe8UMgaThjV3V8pR2YLJ4YO1o6Fk42tigRJj265awyqbi9nKiVVkxj632xR+VknN6G+Xk5Fz3csMCXfTAl/9+u5VP+EsA0hZGyuYFjhr14XA3Rj0yjkxBsSbsiYl7VFA1zEL8a5Cfqu5wvpmJ3kWxRvDffjLtcYwRv0NaNO58spYi51PuJU4n5BJsiR+xuF0W0w6ZUnmUsw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(52116014)(366016)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(38350700014)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rf64Pal77KKFijfFhbTs6sXILWkDCv4UgvezVXwtfwlqvmKMRADtM6K0XkFz?=
 =?us-ascii?Q?IwCM/mkGwQaxzvsywcWdG/r2BMfJH49N4nvSX5bNsmVb4xrmnITUmBqPrPNP?=
 =?us-ascii?Q?PHFclpf3i9f3FGUvUZuN9bmCKOkDH3879EmxrweKC3FH69n8LQy7rjQteKEX?=
 =?us-ascii?Q?PJagyd0PGXOZGIUs22LWqRjkUfnNt2hSAc+n01MUEexM3OPZ+PocjgZtS4uI?=
 =?us-ascii?Q?x7sULMnzNCcJCla6GMyyTGBe9mbyqBfBrXfaE4wyYpJMvyEGhavRa5wZNang?=
 =?us-ascii?Q?HbG9LmSAROTaDZHlCbgJ6sIyJMCeWrKISlwUKROcWcNyFqbRhPcB3TRdEw6B?=
 =?us-ascii?Q?liciy9taLKBYtOaWgVC5soqg9TdRQQo5JUCvJyzRYMeD3dGrFQfAnujlThOb?=
 =?us-ascii?Q?xb/rfTGYC5gJS2YRE/qKCN+YfqOCOfUyQpqjpnpXDk05ZyT5MpOZui6TcN36?=
 =?us-ascii?Q?YJBAA4ov51pPG4v9FCmtG4eVDq53wuicbKJiMr4sTU563CLt6voXSGu8ZiYO?=
 =?us-ascii?Q?AEImeAIiD9Fzv+kFA7ErpgQsvR4k5iyMwigLeRDz+h3T3rxC8qDcBBWQY+FQ?=
 =?us-ascii?Q?Nz2N3JuIb+AFFzSKruam4g/hiMkG7OLXyE0iLIwNr2oBWrBbo2g1PTZlFjJJ?=
 =?us-ascii?Q?3HBxi9+VLoMef2kS6cDjbcwhFxiRZa7w2VdhmIPSDLvFg4i7VnwVGoVJTPeF?=
 =?us-ascii?Q?YUZ4Q88cHIQijSgJO0vsiKbs9KXTv8hTMWm0XpQ14AFf/36eAnsiE3OsqD3k?=
 =?us-ascii?Q?ZR9lWgxLPFjlq7B3AFt1lJNoYsLSFWYID9bmzaBpEkFvxqfJXWgdrhIJ1uXk?=
 =?us-ascii?Q?mLNR0qJiNcnTu2x5yl2ElVcvSNCoG8+V9ZYcSmedAMRGq3cfzzLrWuplG7XL?=
 =?us-ascii?Q?00o4ofqONXnkDqlxgIXHlcnVlJNjiEk46iWB+41qH4oSdZgO63cPLY5zV9jb?=
 =?us-ascii?Q?CkIPZKYRYPFadpxLcPBz21YZJWOCNhGkcRMNQDw+IX9qWiAz4ZPTcy7MuiDZ?=
 =?us-ascii?Q?CqNHO36uDKuKRCyXY7NhN6tgMlUubdlibDYcN7cLacTB9Ca9p1xhyZm2kZIo?=
 =?us-ascii?Q?fDmCAKF+/lrztLHtnWuByZJGhORJF330w/DZZrQnvSmlezB5oAh7U69uNtoN?=
 =?us-ascii?Q?4umtNm46V4d86oWVCMcgjvEITQ07/GkFQJFb9T23JKoF1UByPnZ221xqqRPS?=
 =?us-ascii?Q?QQyGRnHy7w2oUkWQgw6gsRM7xI+bgRZPyfSsedPQiUGKOc7hTEROB2kZMjE4?=
 =?us-ascii?Q?mlo1NdeRXqAbbI6jB3R/XISKLXaz9vEp4dFCZHoQtWjsiLoqPF+n46e2VI6v?=
 =?us-ascii?Q?m54qjPY7+Lj8Oh3iaA6UrKjpowb6n3NOOh8/hzrUaEoqxJouEl0FMwx/HVYq?=
 =?us-ascii?Q?BxGoPNVnOtS7S9G710a6muZQ2nDw9MMeKI4efmKaVlAGuKAVS6GoGBe8WAGP?=
 =?us-ascii?Q?lgthz+qS2mKbKhGWj/LakkZmIqLtx0qhdPbpt0ifqTnNLqlEl1bAmSRUrY1B?=
 =?us-ascii?Q?Eve5xPKiobdg0GCLgTA9lwgDBYrvTP6Gf0aHElETgbl1fCrBWqA3J/gEVIqW?=
 =?us-ascii?Q?A+wqoH04DwbXcCQTEis4+/ajOwsQTCCDFPHx1ALi7yjdH//iBrhd3kg34eT7?=
 =?us-ascii?Q?5j8Ji6KrujTbY5yReqCht1vHufo0a6Gm+BClbtW8g/PMAovc7KodzmaI0guO?=
 =?us-ascii?Q?/qpu0BQPi7oc6BGWJSCyh3cdWweXYyySER5Qr5/abunlIuItMQm6jbbeqJC6?=
 =?us-ascii?Q?A5Dq5vR5K96slisV6/tn1S9Zk+wGBAg=3D?=
X-Exchange-RoutingPolicyChecked:
	ln3EIYB2NR8PFdTN5KjK/7pHdDIZMhUg+wstoAO3orY5pax5G//l1tglCIEX1nOnJBmIoR8vI5emB1Crs0uhF/8U8oIcUga3NBgD/UHee7VzTSuDb2O1oXT5lb9wJw2SMIbBBDifzQ4DQBE/Xjz12BxLmeXmhBpXKHsQvFDgXUTFUJEvhwlEaWccfJf5lncJ7BrDbyRYPhqH2mWzPiLo8y7wd9vX5x9MSciaMJGe3PAjUMDuF3m6gGD2UO83qjJekmN+Ys8ibhLWKt1iApRlfaEFdcPsqL2ZpDtaVOxCkrOcSQs3ypK2nDncrshMkJ78UVl/CijruS1WPBdVqmQorg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e6b862-7a34-47e7-9f19-08df22c3f75f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 09:35:17.7278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rqUwJ5yN/vpuyYhAH0FCv4+Ht8lt+/kzpHKzp5JgxtrlZPK0se9oNYF936J/KQWyNYlV0AqvkwM2fYE9r16wZow473OO2W3oqbmNWdqkkJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4987
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDAzNyBTYWx0ZWRfX0IUVWx4ozMLM
 woCtcwC+SYxCjr0piTnc2u0tK8YDuKYfwp3MEWWfNU8OOpBv80LU5Kb+3ZqqIyN2yXxzhmfmzMc
 y8rZc8lI9I2sR+xVS35J/Zc3LJmDA2nmPfOgmZ5iDpAUlVgZ0Mq4
X-Authority-Analysis: v=2.4 cv=fKesTpae c=1 sm=1 tr=0 ts=6ac36f58 cx=c_pps
 a=1BOVGqFqTWJq7wXoTNd6ow==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22 a=t7CeM3EgAAAA:8
 a=5TcbtxgV-5memk7g3QMA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDAzNyBTYWx0ZWRfX77KYxT2SbR5Y
 o0fZsFuHdpK++a+cRJY+k/WeyIOwL7+Va3n9WpsD+y9ELjsydsXm3zm7F12hno9fToQT+QctUI2
 sFQPUma8Yqzu4mSPpeR21jM1BSGuU/7pIZ2cJidG+UmucPkj/+y0CRdKKQ8eGyOFGFUGLEJQh8u
 HT6xXP/Je0FyWk0YSXF7I42yw7QHvKkN47yX6YobCyxo6zm1TmhhtT0uw8l1JAJC9daAUk+ppSS
 5Fj1r1GBMF5VJT8Qzx3e8KGOXhgDp3A4DgRgSFTEF68M6KE0CSGMl/h/+IrH64Xe789962P5NEM
 MWIfkA5JWNIRt+oHOio5w4URGZT3UiJ8mN+mUHQbyQZeZZAfF7k0+tgEB2+66DAFXNpBAfsMveM
 0KCmSui+mDpG3VyE4ZyPW6is1n4K+ttodTusajNZSjJgHoS1bQU2uFoQbisYxYUf8AEpnVtS0Ju
 tOeNwJ3t1GgLPdT0tGw==
X-Proofpoint-ORIG-GUID: k8IgG1sOnWeLlg6KBrU9pnxlWv8USGey
X-Proofpoint-GUID: k8IgG1sOnWeLlg6KBrU9pnxlWv8USGey
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_01,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050037

From: Ionut Nechita <ionut.nechita@windriver.com>

The managed IRQ affinity spreading introduced by the isolcpus=
managed_irq_strict series restricts the affinity of managed interrupt
vectors to housekeeping CPUs. However, the reserved vectors that do not
participate in managed affinity spreading - the affd->pre_vectors (e.g.
the NVMe admin completion queue) and the trailing affd->post_vectors -
are still initialised with irq_default_affinity, which by default spans
all CPUs including the isolated ones.

These reserved vectors are not marked managed, so their affinity is only
an initial hint. Still, on a freshly probed device the admin queue
interrupt can be delivered to an isolated CPU until userspace (if ever)
re-steers it. On PREEMPT_RT this is especially undesirable: a stray
threaded interrupt waking on an isolated core directly perturbs the
latency-critical workload, and there is no clean boot-time ordering
guarantee for a userspace fixup.

Confine these reserved vectors to the housekeeping mask when
HK_TYPE_MANAGED_IRQ_STRICT is enabled, so that even the unmanaged
admin/reserved interrupts are kept off isolated CPUs from the moment of
allocation. When strict isolation is not configured the behaviour is
unchanged (irq_default_affinity is used as before).

This closes the remaining admin-queue gap left by the managed_irq_strict
series for NVMe and other multiqueue drivers that reserve a pre_vector.

Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
Hi Aaron,

This is the follow-up I referenced in section 3 of the v16 test report
(the one applied as "0010" when gathering those results). It is
functionally identical to the diff you sketched in your reply; the only
differences are the local variable name (reserved_mask vs def_mask) and
an explanatory comment.

Posting it here as you suggested so you can fold it into patch 8
("genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs")
for v17, or take it as a standalone patch - whichever you prefer. Feel
free to adjust the variable name to match your style if you squash it.

The pre/post-vector affinities shown in section 3 of the report
(nvme0q0 eff = 79, nvme1q0 eff = 39) were produced with this applied.

Thanks,
Ionut

 kernel/irq/affinity.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index 8a7e68843c161..29eb22725cfd5 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -29,6 +29,7 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 	unsigned int affvecs, curvec, usedvecs, i, j;
 	struct irq_affinity_desc *masks = NULL;
 	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_STRICT);
+	const struct cpumask *reserved_mask;
 	bool hk_enabled = housekeeping_enabled(HK_TYPE_MANAGED_IRQ_STRICT);
 
 	/*
@@ -63,9 +64,18 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 	if (!masks)
 		return NULL;
 
+	/*
+	 * Vectors that do not need managed affinity (pre_vectors such as the
+	 * NVMe admin queue, and trailing post_vectors) default to
+	 * irq_default_affinity, which may include isolated CPUs. Under strict
+	 * isolation, confine them to housekeeping CPUs so that even these
+	 * unmanaged interrupts never land on an isolated core.
+	 */
+	reserved_mask = hk_enabled ? hk_mask : irq_default_affinity;
+
 	/* Fill out vectors at the beginning that don't need affinity */
 	for (curvec = 0; curvec < affd->pre_vectors; curvec++)
-		cpumask_copy(&masks[curvec].mask, irq_default_affinity);
+		cpumask_copy(&masks[curvec].mask, reserved_mask);
 
 	/*
 	 * Spread on present CPUs starting from affd->pre_vectors. If we
@@ -104,7 +114,7 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 	else
 		curvec = affd->pre_vectors + usedvecs;
 	for (; curvec < nvecs; curvec++)
-		cpumask_copy(&masks[curvec].mask, irq_default_affinity);
+		cpumask_copy(&masks[curvec].mask, reserved_mask);
 
 	/* Mark the managed interrupts */
 	for (i = affd->pre_vectors; i < nvecs - affd->post_vectors; i++)
-- 
2.47.3

