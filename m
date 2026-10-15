Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021127.outbound.protection.outlook.com [52.101.95.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95D246C4C5;
	Thu, 15 Oct 2026 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072770; cv=fail; b=soalnYdRzyqzukTtJLAXvNADjVoqSvird8g/rJ1K4c8kIST6cQcgN3wGjniof012Z/cejzn0zGoiRPaB5hoiG8EzrEZg1Cdsx2n8mpP1fnU/SSNzZtPIKyI31biLLBIbhxiFN2aLzyC3MK2vIlt40mNXNBOZR3XEU8avTJDPAFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072770; c=relaxed/simple;
	bh=BZSi0ld2gCoX42OfOoTVcTNAJ+2vSIiqZAmwEYc8o+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pTBithgfy+HZdVeRhIU+FAyP0CT3kR7wGfCDvJyfyHJjm8JlLQaGya/cmM0Zo2e1L94s1kVR0416kdUM2Z4VAWTr5sCVd9pwjGv/sunC07hCzMpwcUY4qULfTLi5RG72oVgGtkT76KJGfPOuFG3NV1UCKN0jhZ90FU3/D9E5rS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uh9iRxC2QxcLYuNVoh9q3M/Nko4tE4zZbfMNieZNXtF3ruYSQaB1Fd+XIcBBP+0H5CpZhnPMKyViDZyw41D4XkXZDkUt7zRV3AkEFOpSfI3HMNxh1eJEr6HUtA+orR8rFV4mic7xfdgV1Oz87NEWgQNsRusJm9AlSvGA53armAcm6TpibFTVVXMM9twtQW869c0eQ7XaUvxvgDRVDcesSHZOxmBOiXfB9+dK93ky0ZnYu7rzRpLC67dARJyIWi9yfDyAClKbgv1y1xF/OpqNFpiW6MJsGvOu6i5EPkr5khRNuOlwHDO/xpywzKqVwRaB6YJKYUpbnR4jqhvU6vfPng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=zSD030KENEnt4QGLhDgc2/Evuby4Hdf6BCKyt1MiNP4=;
 b=gwWO8ORv3D5Ht2JRd1v7rbuAp2YmEvw3fredLGw4aaHWsz+ZxBKSOElAT9NLmu30Z2bP9c8nYuLbYQhLnq6JXGwHFcTsp1KQ4e1lrN5kV4KTVNSCe7e6/oOO8YsFA92Keq8sCbBhB7rbfddKKe6eT2XReaDYKFg4fN9RrfsjptOFGXGF7NaJuO/cPeKLmrhjQ+OoYm7nzh1SERCVivs/Ya53U5ryCcwjqSqL694M66mASVIBM3n02+Z+NoVKwGMESpAf8IchfVp8dgAMR48VBw3fJWs95eCRHN9k4AauinP0lptLVVJMryZBtc0Wmd5K5d3CRI2Sof5Tt1FAxxqRxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from LO6P123MB6616.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:2b2::11)
 by LO0P123MB7921.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:42b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 13:59:23 +0000
Received: from LO6P123MB6616.GBRP123.PROD.OUTLOOK.COM
 ([fe80::3975:c5e7:bc1a:f383]) by LO6P123MB6616.GBRP123.PROD.OUTLOOK.COM
 ([fe80::3975:c5e7:bc1a:f383%6]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 13:59:22 +0000
Date: Thu, 15 Oct 2026 09:59:17 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Daniel Wagner <dwagner@suse.de>
Cc: axboe@kernel.dk, tglx@kernel.org, tom.leiming@gmail.com, 
	aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, mkp@kernel.org, 
	frederic@kernel.org, bigeasy@linutronix.de, ionut.nechita@windriver.com, 
	corbet@lwn.net, vincent.guittot@linaro.org, mingo@redhat.com, 
	peterz@infradead.org, radu@rendec.net, akpm@linux-foundation.org, steve@abita.co, 
	sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com, 
	nick.lange@gmail.com, marco.crivellari@suse.com, rishil1999@outlook.com, 
	linux-doc@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Message-ID: <bzf6xwfaa64gcc6qi4u76lnwiawijwrrgsbn6mukawvwzur6re@nsfh3lq5bfi2>
References: <20260910164237.500196-1-atomlin@atomlin.com>
 <2f32ffb6-d889-4281-a612-d4185311ca0d@flourine.local>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2f32ffb6-d889-4281-a612-d4185311ca0d@flourine.local>
X-ClientProxiedBy: CH5P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:610:1ee::12) To LO6P123MB6616.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2b2::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO6P123MB6616:EE_|LO0P123MB7921:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a92126f-6a9f-40b7-f4e5-08df2ac483d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|6133799003|18002099003|22082099003|10067099003|3023799007|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	RPIy/JQRJ26BNVXJVlLL77nv4Hx2XvMR9lTjMZQlktqymeplS6HFXwcqrgWXglXMdYB3yK7OJU5pSy/+2S5h7xkVRNHpaOxx01gYrwitS203v/TIZkg/X3aHZMANuVuyao/C8pHj3RFsRM42aferlQG4WmTrCkMazUJo0ZpCqxBRSkbNpiERzdPFk2ekw6BX5QIpikSRm0RxuU81WT02sADW4DJzI5xLw9vd8GtXuxx+0R+oaOxr5jmWGA+nMZZJA97oXztX7e61/kAtdsy00SSIvwavjKDkVKW+h9VIZqh0BUBDTnjK6Qxu3JndFKfIbuTVaDnp21OImMr0cQ0Wrl+NHZ2/XimdL8G4Po3SA3HEupId7npoVCYXK07lFping2rji8qVZzzziZbONPbwiivjpKP4UjNguKoK8lJQDVwKjuG1eIffa+BCUW3ypAi4qlzpDIYJ1FOiKNU31JFWmunAN8Qz7eb24c2OfTYo1+D4uBLoE76eTzQAG28HBlRHJ9s7c4QR1bR9I1Hui9L19J1+JXL7xarB2uAwiKnxKuiK4xI41rljwbk2FoiKwzrKP8vkxStp4C3jzBo1eRiZNIqH38+4wTCSNF7K3idawn3YI7BKInm1mxz57f6MSzyqEc6jUzTFb/+bTIrSeMX0CxJYdVeaxXoeYjiQdcpPVvE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO6P123MB6616.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(3023799007)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmJRT3UrUWo0MWJEQTN0RkdwTTBkRGpkaExxckN5K1lwbk1saVc1Q3RZb3Jx?=
 =?utf-8?B?b2Z6aW8wdjVvNittOEN1UkxYVWJCNkNZSHI0K2c1THJhUUR2SlVpYVRaRVhH?=
 =?utf-8?B?MmliMXFNdDlZaUZDOUtlYVM5dCtXRXlad092d3F1ZGpCS0Z2UjArRFFVd0VV?=
 =?utf-8?B?dytGdGxucVB3dDAwSDlaTmFUR01sWjNEK3dyM09nbEl5aDh0WTBlTGJqRlJt?=
 =?utf-8?B?eS81U3JDb1N3VzlaWDFzK04xUGJuZ2RjMi96MjUxZDRiSlV1MG9WdWhEbnFt?=
 =?utf-8?B?eFFObWRGdXJTdE1LeHRHUE5YY1B3MGhYYmhMQWtBZ0hNa055NDY0Ri9Nbldr?=
 =?utf-8?B?Z2FVS0RLWXM0SW9aVkxKL1FVZW0xVytGd0ttVHBBU1MyMFVvNjdYNzZWM3Zp?=
 =?utf-8?B?T0pHVGpaQTZmSzYzOTVBdXBONmlwSnZ2SkNpTDBYbktLWk9KamNCdUp4NTdv?=
 =?utf-8?B?QjRCSnhGS0FzbEtIV0djWThhQlZ6WCtKLy9oOVZWM1hkcmdKNjVYcitjbXR2?=
 =?utf-8?B?aTN4dGZCWVhQZ3Q1VitySnpKc2Z2SldhcXJLd3BiazE4dnpGb2xVNVkzYlQ4?=
 =?utf-8?B?QXFOTWYyR0JqUUFMcWkrdE4rdWo1TWF3bXNkdjNhK05GMCtqWjNnSmtDYVVY?=
 =?utf-8?B?bGNYUDl3NmlPN3R4UlZkODV1S1kxMXNDallIMTdtMWRtM3J0TStmZlVXUjZL?=
 =?utf-8?B?TVJQZFZza3hLMUVJdmhJVUk0eXNaeUNuQUZQN3lFRkFmaHlrdTllVkkxVjVJ?=
 =?utf-8?B?T2hpOHR5b3JLNkhaYzlubVRDZTNpUkIxZnp5N0w4OS95WkdNNWZ0SEtGWE9z?=
 =?utf-8?B?SW9tMXFKUVNYRjNRMVVmMXFOa1VydjJ1OWpzcXdYald5cWwzdVhNYlQzN0VV?=
 =?utf-8?B?anJybUp5a3M0ZmpwaWVtT1QxU2hpWDRyaEtUbWNGWndmTGxtbFJKcU8zTGhw?=
 =?utf-8?B?NzU5SHFvMDBZMzF2aVRUeFFzdUdLRGtvc3FQc1liTy8rVDJDRGo0ZXJ6R2Qr?=
 =?utf-8?B?akI0UlJMemZRYjJFNzZoNTZ3MTIxWlR1bE1YZE1PWnBWVE94TERQUmhQOTNw?=
 =?utf-8?B?YlNKRmlUODUrWk9wREZhcnFuYzdscThUL3I4QlZEdGY1YVB1bFErZGczZkdt?=
 =?utf-8?B?UlBlMVlXTkZEOThFVnNvMm9PZkFHbXhzU2FacVByRGpWUGlTdkUwakdTZjFJ?=
 =?utf-8?B?QmdIN09DUmFFVU5PUkErblVoT2Q0Zy80SUVxcnNEWTVKRmdTNXJKUUpiZ0t4?=
 =?utf-8?B?S0FzcDFoMHNkdzkreE80elF0OUZYMHlUT0RPampTODdDN2VLNWFEOXM4ejA4?=
 =?utf-8?B?QkFXK09uc3JuRGVjWWRlR2RhSHkxaWJOZklzaWJpNXVDMnJoa2REZVdqcTYy?=
 =?utf-8?B?c0tSYW4vZEZpeHp3eUplejloZUs4Z1Ruekw4VktJeDB6SVg1a00vYTlhSWVW?=
 =?utf-8?B?ZVUybmZ0akh4ajhsTWFEMmtqNzRCTW1kVEM2bXhIdDM4YzNmSjJvdUhzejhr?=
 =?utf-8?B?RXVoYllHVnZVMDBDQ1U0L1BPNjNJWGQrTTVIcmlvd0lPMnFpbU13Mk5udjBW?=
 =?utf-8?B?R050OW5GdzE1ZEN6WCtMMzlxSUhBc3Jzb3FDSE9uRnJYL2hoRFRUK2RscXE1?=
 =?utf-8?B?WU9MM1RDZHljTUQwcHRkcGk4ZFpIdjFodDNWWGUxZmFuelRmZVF0TUJvWEVY?=
 =?utf-8?B?ekR3NFB6ejY3NWNjWERUUE5GRlRqSEVKSm8wdkpPb3YwNWhMV3lqYmtWbHFq?=
 =?utf-8?B?WStXUmRtb2dnNXBNQUw0MWp1YlBKUFBnTmV5eEtXYkFBanZtaTlLOGtYY25k?=
 =?utf-8?B?bzJ1RUxiUFNoK1AyajdmUVc2TGJ5T1JLTzNHN2p0K2lzdjJYaGNhWit2V3p2?=
 =?utf-8?B?MjFBRzZBeU1xNEZiSXdxZ0ptMUROcnFNRmpjYWwvN1pPeWpXT01NaS9uL1J6?=
 =?utf-8?B?U0dxcXVOYy9LSnBCZHFYa0lRenFZTFIwZTQwQUpnQi8ycitlNHhVSFBrSVlm?=
 =?utf-8?B?cUJBdTgrdDF4QU1ndk5nYTRCZldsalkxUkdNQmNJT0N5U280dS9PQWswcjR6?=
 =?utf-8?B?RWluVTE5a254WHNmcW9vaWZ3d3gvM0xkdzVGRVRUalZUT2l2eHdDMkpUanNO?=
 =?utf-8?B?OXJsZ0xJRG1Bc1VGeDJ4clV2d08vaS9vVkZzOVR3WHZzZ3M5SXNMck5hNWpL?=
 =?utf-8?B?cGYwbC9KaHR6WXc1cXZ5cktOcDl0MHI4UjZQSGFQV3Z3T0NINWc1Ynp4YWx0?=
 =?utf-8?B?RmNpTG9TMWZQaWp3Z0NtTW5uS2hYWUxRTzExcC9TRzNxZlllT0FNcXF2VVIv?=
 =?utf-8?B?V0ZKOHdJRklkWFIvQWdhNEJGK3ZSZkx1a2VpTWNiVTU4NUEvQjZzUT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a92126f-6a9f-40b7-f4e5-08df2ac483d5
X-MS-Exchange-CrossTenant-AuthSource: LO6P123MB6616.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 13:59:22.5919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wnl76/QIDobsjevB81gDs2owumF2zJtFf3Wmf8SVwPJ94Y6LWbLqyCPqyr3tgpFfsGufGb8wJA1kxFAubGBDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7921

On Thu, Oct 15, 2026 at 01:22:35PM +0200, Daniel Wagner wrote:
> On Thu, Sep 10, 2026 at 12:42:28PM -0400, Aaron Tomlin wrote:
> > Maintainer guidance requested
> > =============================
> > 
> > We would appreciate guidance from Frederic Weisbecker regarding preference
> > on this front:
> >         1.  Do you prefer keeping "managed_irq_strict" as an explicit
> >             opt-in (as implemented in this series) to preserve historical
> >             behaviour for existing users of "managed_irq"?
> > 
> >         2.  Or would you prefer upgrading the semantics of "managed_irq"
> >             directly in place without introducing a new parameter, on the
> >             grounds that the legacy post-allocation behaviour is already
> >             broken for modern multiqueue hardware?
> 
> During Plumbers we had several discussions on this series. This is what I
> remember we discussed and decided:
> 
>   - The current managed_irq behavior doesn't match the other flags of isolcpus.
> 
>   - Instead of introducing managed_irq_strict, it's better to change the
>     existing managed_irq to follow the strict interpretation.

Hi Daniel,

Indeed. This was the common consensus.

>   - The main existing user of the current managed_irq mapping is
>     RH with OpenShift. After discussing with Juri, it doesn't look like
>     it is a real blocker to change to the strict interpretation.

Excellent.

>   - If there are complaints about the managed irq behavior change, it's
>     better to introduce a different flag for this. Though there have been
>     many discussions and proposals on how to deal with isolation during the
>     conference, and the general mood was that the placement of resources
>     should be done during runtime. Thus it is likely that the old behaviour
>     is not necessary at all if runtime configuration is possible.
> 
> Hope this helps to move forward with this series,
> Daniel

That makes total sense, and I agree with the direction. I will prepare v17
with these updates:
    -   Upgrade "isolcpus=managed_irq" directly to enforce strict
        pre-allocation queue and interrupt isolation.

    -   Drop "managed_irq_strict"

    -   Update the documentation in kernel-parameters.txt accordingly.


Kind regards,
-- 
Aaron Tomlin
