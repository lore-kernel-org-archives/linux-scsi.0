Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012024.outbound.protection.outlook.com [40.107.200.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8449327F724;
	Mon,  6 Oct 2025 12:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759753887; cv=fail; b=j9aRgMZd5FXsHzQAxI/UGmKWnB4AF5XDr08HlbnrQaQ1qqdnCbL8oY7O3KqE4uo0kYwSNSKTKVKscLe+9yyAxQsQqDssvCOGZtRhOO/5lZRMn8PAcGoKouBeiW3lstqLGGvqgG0O1WcwtdoQ4Vj1YpU7oLv4cm+mpCk0Tqzm9uk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759753887; c=relaxed/simple;
	bh=3p1rd6nfH1ttP8Qv5HbT/8evWioCrSLs0YdfNsJ0TWo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iCKlBlr6y9qEN+wJDoMsYOqMDZbXAonMXxuEo+CywI/7w96o9gfNrYm1ZxfdbNz3ev4zo/T8N6xGGJD6fjVgzpo0gRtvYbLVSVsTkIp909YFwo37NtyKZd6U7Y+v+w2+omhknEHBglVIwqC2jFafAmMpeWlspJRcW//ctzM3ykI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KzFbvkEk; arc=fail smtp.client-ip=40.107.200.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KzFbvkEk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mASpqiToMVWrxg6xyc+BjrvAEfi1dCs/dlTaq4WcUiPRuWu2mMbt93P1RAfXcGFZXl+JunsxtD6RkJffELkrkikwtQBc6Ks8zB1mRcgNjf3Xm+wtL9zlYK89cQFphj19Reh4Cxi68/X481HvXPQqx/EwHmg8DZOJ0QU7uw8LXfN4kKLEup8UQB91/Af2e+iLCj/qgi5yDmaDW4qhED5rt89v0pi2ZZO6EPLwyF6fWsZjALEeF5JBDPQH8l23xc49sODF97D79fNGWcG0Cflsqqeqwbp8FE/+aYrnMEHXqJ0IFgyPTSYEcuvYTI9TF5JW5/ZGyRkDhkBivseX9HKEDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTLSbQSYcJ5qHpFqiIFyPB365jVGOClnjWCl7SkeTZw=;
 b=lP5CujUTe2UAXDkAccD/iOVUiYe3hDw2ON/dtp0UwBgZBbLkWGjVKNl/TDMyz7nKpxE+e98ia+nrNSc7uBG/EW9P+ccrqrIfXr4KUCW4JtM0WdbZ2oRqCWywFl2OyQM1A7C9v/BOvrylLM4RPZC2zGhPoP4nxUwSIuBGATkXIg51f7F+N0pVMtfDzcewPgksrTo73ono2du/jI/qWaW/tjGha3Bn098j7CdYfAx8D5HYCOG3EkjwYhskGC7Pw4PWdZLDQBJ77ZonHaCIeKNQkglp9QJdO6A2Zzkd/Aw83hWpkZoB9eP/uh/Lk12NspLCvtDvZPN79aPTbMEU0+j42w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTLSbQSYcJ5qHpFqiIFyPB365jVGOClnjWCl7SkeTZw=;
 b=KzFbvkEkaThx2EwI8j3RS7puKpeTi69f52Ca8AtsnYOs/5SztfSjsz44Wd59QK3wS81bJkEKmum3GvTVZk/gOxk6rgjQvOdI4iLqCsBNjzEh/U8XTI8SxRghv8VL3UnElI2qxKU3DyUg4DYKF4yEw901haqQKU6HoSsGypqM0VY=
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6933.namprd12.prod.outlook.com (2603:10b6:510:1b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.17; Mon, 6 Oct
 2025 12:31:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b5c5:3390:35bc:eb9f]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b5c5:3390:35bc:eb9f%6]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 12:31:14 +0000
From: "Neeli, Ajay" <Ajay.Neeli@amd.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "git (AMD-Xilinx)" <git@amd.com>, "Simek,
 Michal" <michal.simek@amd.com>, "Goud, Srinivas" <srinivas.goud@amd.com>,
	"Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>, "Potthuri, Sai Krishna"
	<sai.krishna.potthuri@amd.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "robh@kernel.org" <robh@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>, "pedrom.sousa@synopsys.com"
	<pedrom.sousa@synopsys.com>
Subject: RE: [PATCH 4/5] ufs: core: Add vendor specific ops to handle
 interrupts
Thread-Topic: [PATCH 4/5] ufs: core: Add vendor specific ops to handle
 interrupts
Thread-Index: AQHcKWJ9b5i0WPMCt0iGPes4sWMS6bSaxKqAgBn6y0A=
Date: Mon, 6 Oct 2025 12:30:59 +0000
Deferred-Delivery: Mon, 6 Oct 2025 12:30:00 +0000
Message-ID:
 <LV2PR12MB5869608BE2879DDEC30014F08BE3A@LV2PR12MB5869.namprd12.prod.outlook.com>
References: <20250919123835.17899-1-ajay.neeli@amd.com>
 <20250919123835.17899-5-ajay.neeli@amd.com>
 <d2a66ef0-1f01-4ef2-afa8-8ea6f392c365@acm.org>
In-Reply-To: <d2a66ef0-1f01-4ef2-afa8-8ea6f392c365@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-10-06T06:23:36.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR12MB5869:EE_|PH7PR12MB6933:EE_
x-ms-office365-filtering-correlation-id: 44ad1cb1-9ac8-4f4e-533c-08de04d43da8
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ROapt04mtdEXklgS6JeogN0hmEE3PXEOPhjuLcm+fOjGoeRjNSHQF8enLvLY?=
 =?us-ascii?Q?gtsRkfxLcWcH/yVSi75CD6MTYgGWC7D3rZUSyg/u/7d2j6hvFQjK8KWn7885?=
 =?us-ascii?Q?dthiPt88BEWY/gdtHCsuOtELFBClkVhUUY9WzgfAdzYEEaHeW9UbvnLcZfH1?=
 =?us-ascii?Q?t7ZJu5+1g5wp9GavRFVa6K1hu8J6j0HYj/8xnyTZuXpCZnOSL77FIBHOT0vw?=
 =?us-ascii?Q?1p/EYF8qXSqeUfoPre1Of5JeRpxSwG1ifC1qSwxX69c8Vef50MVaZNZ+Se5i?=
 =?us-ascii?Q?Y7dTDnb4MFtuV5Rj0yBxunwL2wP7GZ5LMGZqw4EKgpJ2Aq5zFpmfFH1iS3YE?=
 =?us-ascii?Q?C/lc38U+gq2OppGXdr4jWDjtHlRUArwf0goze9vUcWTjOuwkQpH1QhAeBg4S?=
 =?us-ascii?Q?+CLUOYvWH6STFtSYsfhwl2LkLSodZAlwj+ay1zltA1dxpDWP0BX3klXmLNpS?=
 =?us-ascii?Q?6ScaRYXJqMC7ZSA5WSUx3ahTBej6tU6ETNxG3cNA0wEGNaDbPOsmOEU5hjex?=
 =?us-ascii?Q?wVOg6nxY2wETWzToCfrrnDWRU7iOZm7ruTpNbg/apVsoOF1NfJy/ReryuJju?=
 =?us-ascii?Q?ZoKn/tsqgvpPRWKavlzZuIkCymYQTxKmYAbffsdNMz3IQqu8lKdtjzh7mapx?=
 =?us-ascii?Q?LiWnNJKfBfVikdA4W3pEPsX59NXZXljc/SGzs75ZYVBeJ31n4L+kk4Z5DCYm?=
 =?us-ascii?Q?Jhy4laToHKRcBT+XTXyfagKQdh7yWFW+QdirECKaxVxtLpLtMg8SJ/9qD0ug?=
 =?us-ascii?Q?IkcBBV8Gyg6aBy/eiA6hivg26kpCV9az5Q8V+8F6tl8+rHOR8o0qKDYoqqs9?=
 =?us-ascii?Q?lFMYLVQP+R6Bs0+6FNXzLCpLT4Vb1+/tI4qUg9Whup+FpjLvAq7a2k1Pexm2?=
 =?us-ascii?Q?5SW/oNeb5f3GEpARL8MeMfkXpqS76v35Sjv4j75y8AO5OjWAKN+U00eKnAOM?=
 =?us-ascii?Q?zyEvIqsnSE8HpNA9wdSoIMhi9hZggRhjXQYcF64rnGczBB/upA8pqmTeH+h8?=
 =?us-ascii?Q?88MCrHQz3+ul8ByykZocLIl4RvPDL+uTUhCAlbKCONiJ2lTBxs2jDTv1pDIl?=
 =?us-ascii?Q?l5YO2mku7Uh1J0jMZypfOhDyDAAL+3o6JQ40det6BBgg5l3vAe8/8a/Q2/BI?=
 =?us-ascii?Q?lUrmRRmPs0L/Wl2BUm/y0biAb7ViUxr0hp90nSDdct/kb17AV7tyfaalUMrb?=
 =?us-ascii?Q?vqn1XsW3I7svjBI/ceq9w8+tFVo/pQxvNskxHHv+pwI1dPFGK3oLoMRsKGT4?=
 =?us-ascii?Q?q/MnfrWcDPF7mzaQLMB81i1F1DBoRtK93N+cLsTQ2jfPOgCvMGCZ3/YjzQHY?=
 =?us-ascii?Q?o9k0xt/G9JxNsGyoApp0Lgp0pkWxJkCkCxzY0o6wNrFOb+g6hCK2E7DX8IAE?=
 =?us-ascii?Q?p6GYn+yMGoDtnR2Ue+0i1/CRxK9Kanuy7goX7L+hmgp7pzsd2Ts0cnWLd1kf?=
 =?us-ascii?Q?gIBRa8YZ+SPwN12VlNCnVgbEjToh1/StcbnfhiYFYxRi2BGZh3Tz6yqHPesL?=
 =?us-ascii?Q?vAtTWnaF9mpygFyJ+zMcw0NVTzRYvtW2To1h?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?lOmCTOL4rdy9Wm7+muFaXkLKK99jedQb4YgBgB9w+IP2ZhNzV4AHhoZ806TD?=
 =?us-ascii?Q?UAEc/yHHIAyiycQzUNQG9BvQjJZjljgWSZVPHn/PqjzP7uU51PF2b/A+z17d?=
 =?us-ascii?Q?K5Kn+d2G8XMJmYlMTDIW0mLb3tJN9vdT5uSbRv1vTUc9ZlmmeAUzcrgZ1DN4?=
 =?us-ascii?Q?jK3XyW3VcZmEbpnuhuUi0bTrH6jjo7NloPJKG3CxGuR02D/yDNwpAAU16olM?=
 =?us-ascii?Q?eeLv2CkOfZSL7noMq0JryXsD6yrzS7rRhvRPGBNuO++XopYXBtzhv9PgXe70?=
 =?us-ascii?Q?/rixwUz9f3ItYE+ezKBHPnXx8W7F9HFeBExrPE32yYEUWf832q7t/G0nFfon?=
 =?us-ascii?Q?KHoVFJSfJAp8Sw7HZdsrnXImPsYgM6iBDG7HvkEYt1V5eWu7L0OVbljnCyoc?=
 =?us-ascii?Q?g4sTD+fcjnzZMV9y9KiqhblAg8A8ShQNyOFvoV+dFvcc2HM5dBf0tlitwRQP?=
 =?us-ascii?Q?8G+huqoKjHKI0ArbxaXj7wkc5+00TMWVVcUYEJuic1fmabzyHEuf2B6TU3Ur?=
 =?us-ascii?Q?YVT/Nhmi5gRNewNKpAaJlaPaHA6iWTAFIPFKYIY+OnZ9+UFe+LSNhBoK8uWI?=
 =?us-ascii?Q?+0ONzaQova9SnTqV0UfoZCjDjlvX2Nx6OWrZ130o9u/8DoaVWpzH3lf1LWJ4?=
 =?us-ascii?Q?8EIFURBXOg3BhTn4LciBRt3ldT9i5qDRQb4T4VgjnLwx5rvv9ZkppLJM5Vdq?=
 =?us-ascii?Q?qfQWD14P5H0ovpx0tVqp4+RYxUqHyGhxsu43QAzKDS76wUcaF7j5TAL3PqvK?=
 =?us-ascii?Q?c/o0JcFa1QMO3ADi2UU4mXnOTN2+RDIpGeC0mswC6vs0Lg/vjMzhaNWcwaoA?=
 =?us-ascii?Q?sHPl1N15lcaA0x+kLqtIbbEZyMKwIPUC4hqqEGm+RUj/PwT5ZmMoZSh6tB0A?=
 =?us-ascii?Q?QKtv4DHGsJobAGdudr5+gnfwWkT/b4N2D4lQmmbCF1UXPmAla/OqhLDkEF07?=
 =?us-ascii?Q?0ZYh/eV+T4Wwlj5QfsYSIuCVSAOMzHXHKUPx/Nz7FE5TOeeztPv85zLXf/TL?=
 =?us-ascii?Q?Sx22wLksaLOWE/oNDErSC6hOCzYCpVX9GENKRctR3Q/ovapHRQRhOO+l8Eoh?=
 =?us-ascii?Q?/0yNUNXkrLcUFr2kG6ctMUEa4d+3K35EKmJHsOvTccMa3rlBQSJxuHQu3AMS?=
 =?us-ascii?Q?pfx6DvpcJ2enIursryOKPB+WUjtGEio3x51sVAtHYtFtVe4l0nDmKi9j96nl?=
 =?us-ascii?Q?Nd3lFn8+kaGo1/tujEvpoEEVsjhssqls8m1VZN6SzGEnjmTrF+7SMWVUfKwa?=
 =?us-ascii?Q?NNUER73THi00jlD+osks6YF2RMbZYruoQ5/pOId3/Buc5fATgxXUF0oHffCd?=
 =?us-ascii?Q?xVMv3t+cEQpjAUOLjpPllljwzW/ZXVKQqhMbIzO6jyOhuP7FzU3aXPyWCGRb?=
 =?us-ascii?Q?OnXoE8HSA9h57oaNlnvlaYl4e2i9/NtxIluxVj94EihabaWgPFpSkU1NEaay?=
 =?us-ascii?Q?29iskk1AZOz+JuHlOed08YUurZlLIJnJ8PbNd6Q/mk4+/lOqa1wkbHN4RHre?=
 =?us-ascii?Q?xRMhA/cAAV6csxE+Qo7QMCrnT5zD6aV9OmrBsngJ29zsCuGU3Sy8yIWD0njB?=
 =?us-ascii?Q?ekMuparA0ptaHiM4af/L3vloeb2YAkfjG1RnWLMi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ad1cb1-9ac8-4f4e-533c-08de04d43da8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2025 12:31:13.1247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z9pehENPewahEdePAZ/Aa5STM3xR5y53PBEwWZdy4HJ8mklaOA1GQKOxKPFa44BOxXtXpwnMqWjn0vh/8rfokg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6933

[Public]

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Friday, September 19, 2025 11:05 PM
> To: Neeli, Ajay <Ajay.Neeli@amd.com>; martin.petersen@oracle.com; James.B=
ottomley@HansenPartnership.com;
> robh@kernel.org; krzk+dt@kernel.org; conor+dt@kernel.org; pedrom.sousa@sy=
nopsys.com
> Cc: alim.akhtar@samsung.com; avri.altman@wdc.com; linux-scsi@vger.kernel.=
org; devicetree@vger.kernel.org; git (AMD-
> Xilinx) <git@amd.com>; Simek, Michal <michal.simek@amd.com>; Goud, Sriniv=
as <srinivas.goud@amd.com>; Pandey,
> Radhey Shyam <radhey.shyam.pandey@amd.com>; Potthuri, Sai Krishna <sai.kr=
ishna.potthuri@amd.com>
> Subject: Re: [PATCH 4/5] ufs: core: Add vendor specific ops to handle int=
errupts
>
> Caution: This message originated from an External Source. Use proper caut=
ion when opening attachments, clicking links, or
> responding.
>
>
> On 9/19/25 5:38 AM, Ajay Neeli wrote:
> > Some vendors will define their own interrupts, current interrupt servic=
e
> > routine handles only interrupts defined by the JEDEC standard.
> > Add provision to handle vendor specific interrupts by defining vendor
> > specific vops.
>
> Yikes. Please comply to the standard or contribute to the standard
> instead of using reserved interrupt status bits for vendor-specific
> purposes.
>
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 5442bb8..7a6dde8 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -7069,6 +7069,9 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba =
*hba, u32 intr_status)
> >       if (intr_status & MCQ_CQ_EVENT_STATUS)
> >               retval |=3D ufshcd_handle_mcq_cq_events(hba);
> >
> > +     if (intr_status & UFSHCD_VENDOR_IS_MASK)
> > +             retval |=3D ufshcd_vops_isr(hba, intr_status);
> > +
> >       return retval;
> >   }
>
> [ ... ]
>
> > diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> > index 612500a..2844772 100644
> > --- a/include/ufs/ufshci.h
> > +++ b/include/ufs/ufshci.h
> > @@ -185,6 +185,9 @@ static inline u32 ufshci_version(u32 major, u32 min=
or)
> >   #define CRYPTO_ENGINE_FATAL_ERROR           0x40000
> >   #define MCQ_CQ_EVENT_STATUS                 0x100000
> >
> > +/* Other than above mentioned bits are treated as Vendor specific stat=
us bits */
> > +#define UFSHCD_VENDOR_IS_MASK                        0xFFE8F000
>
> That's a violation of the UFSHCI standard. In the UFSHCI standard bits
> 31:22 and 15:13 are marked as reserved and hence must not be marked as
> "vendor specific". Please either drop this patch or remove the
> UFSHCD_VENDOR_IS_MASK definition from this patch and remove the
> "if (intr_status & UFSHCD_VENDOR_IS_MASK)" condition from the interrupt
> handler.
>
> Bart.

Sure, will drop the patch and avoid using reserved interrupt status bits fo=
r vendor-specific purposes

Regards,
Ajay.
