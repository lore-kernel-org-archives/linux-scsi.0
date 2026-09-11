Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11021120.outbound.protection.outlook.com [40.107.74.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CFF495527;
	Fri, 11 Sep 2026 15:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141657; cv=fail; b=tb8TO2cdutMkgRhCXs21Soe7wBz2T8gIxFXrsUhUwv7/yOsJEc1ijjW/9w5qFIzpcG4rVoQKVhcfgm32drr1deRHUmoyFXr8+7jnN4EfyTI/gvbMQHVVGL2brH31PAZsGfGj518hPT4IYq6VwY8f1/xrQKVtbz2Mh5qUDgK5qzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141657; c=relaxed/simple;
	bh=5GOo1JvOMt9So10r6xBCuyr/6xe14QpDINL+KScS4k4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H14vnD17pX8aeIa6q91NzX0ls7J+DIvpCv224vEjqNVGzLhpShiX6Ro2VjKbmLu08e7y+CQFy42FXg8T7lMBySoRwtQuuRNDp/FQJ6nKlxPl9INvdx0bmJn7FnNkNySn5N1AEcU0gsZPf999SD1B/uz1vvVC1NiwizyzBD0igGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valinux.co.jp; spf=pass smtp.mailfrom=valinux.co.jp; dkim=pass (1024-bit key) header.d=valinux.co.jp header.i=@valinux.co.jp header.b=i6MPAf8p; arc=fail smtp.client-ip=40.107.74.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=valinux.co.jp header.i=@valinux.co.jp header.b="i6MPAf8p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gmWgAYlJClExBs2VABMbBxl6xGmrWRR75+fbB1AW7fAIDr4FhXG76aaqnYCequCcWVBE1YbLnngk7oPugSNPzLKbSpFaRkoZo9Fj46j/LAzBGqekeYyMMyIHZNeeZAABvxXL7IkPxqygnAOWsPG9BNHrC4mexbKXosLfsbmcpVmXGCcLWdN+kJXMk5XCK/b6DvtT0rz07VhnSObRR47+BlKlwTcw3KICPLR+nfBSd6HW8zPSOKcGOrOvvkwQvDdk3OnRGKxcADIMOMFxe4VuFqDSWQc5HezQnJwFz13x/beGAXUuu3VnbsP9dHDgzO2oDeuN9QzkW9m3GvCuU8xqKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9+C9B1Uc7Y2hWTkWSMsKaJGqIWQ5j/XisEJdNG6GVY=;
 b=XWAlEF2E5PUbOyt6MtQ2LQKcGYYXcfxS8bKGls+ivq7kHAfcAdhsQbozQDNvxqPqyJLeEN3x23x6sHIelpcdUay9Sv0FBU3rfT06FktZcSuXCBeIiDdNOqRy/fyjO40Y5D9ygAZmhYmlCFZDauKOsz6tQpsQ9zlmrUUW/y6ZvqHLkJjglA1wod8R+Y8S/6jHTd/ErNMPRjLAkCPWqIDK4ZgxlGcCC6WXLRErGM4xUFtFHy8mFV7RmFHLTUNid8vYsTbXF0iQ3zMpmJsCb87UITUxHP/dGcM0tSsVavyB4nYGACS7qGf05kqLKbFKeqn8YrzkY9qDj8oaTD1jb0fpbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=valinux.co.jp; dmarc=pass action=none
 header.from=valinux.co.jp; dkim=pass header.d=valinux.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=valinux.co.jp;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9+C9B1Uc7Y2hWTkWSMsKaJGqIWQ5j/XisEJdNG6GVY=;
 b=i6MPAf8pGFLtXimyX/dbPL7cLR1J2PlTovdwvX2ENcWcDwMKocxg1558AGlUzgGhSkq7VmAVgl5GeCnktSTF4/jBSF21R4XQCpA8BZ1YE54aCq1Bj68Qw5kWVH0p3nP89pKeDsTg0nvLsHcCCVLkS0qQYBG1y4SgBuKdCzvFaRo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=valinux.co.jp;
Received: from TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM (2603:1096:405:38f::10)
 by OS7P286MB7116.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:42f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 15:47:31 +0000
Received: from TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 ([fe80::2305:327c:28ec:9b32]) by TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 ([fe80::2305:327c:28ec:9b32%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 15:47:31 +0000
Date: Sat, 12 Sep 2026 00:47:30 +0900
From: Koichiro Den <den@valinux.co.jp>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Marek Vasut <marek.vasut@mailbox.org>, linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Palash Kambar <palash.kambar@oss.qualcomm.com>, 
	Bart Van Assche <bvanassche@acm.org>, Shawn Lin <shawn.lin@rock-chips.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>, 
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: Re: [PATCH] arm64: dts: renesas: r8a779f0: Set UFS lane count
Message-ID: <icpudsh34smrdxe5w2olbdvdsmzsvtkl4vmxwbjrzrzkef72cr@ieg3r4ufvcko>
References: <20260911073058.253000-1-den@valinux.co.jp>
 <CAMuHMdVAFq4izexG=Sf2i9dZdMMNLnb85AVgBazAFMtTA2jwxg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVAFq4izexG=Sf2i9dZdMMNLnb85AVgBazAFMtTA2jwxg@mail.gmail.com>
X-ClientProxiedBy: TY4PR01CA0097.jpnprd01.prod.outlook.com
 (2603:1096:405:37d::10) To TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:38f::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY7P286MB7722:EE_|OS7P286MB7116:EE_
X-MS-Office365-Filtering-Correlation-Id: 20d8562a-28c8-4241-553e-08df101bfd9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|10070799003|4143699003|6133799003|10067099003|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	CX4xvIflkV5BA2ZK5/PoTNPZB9sduQmVGn3D0a7mKVZSHHfPwiF2GnVnTFH7+nivBUpHovxzHQo+tiUYT2w/g4r+Zj7jsLEBST8xEJG62NrfgAMir/+wboNwvjePfDbYjOIhaVGS/owZRAEebMX9SN+6ouwsgrlQ5gzv6BTSEyJLkNQEHAv9c10x4AUPgCcVPzV+Ze6G1FrjvY07+82hJUZm8be/rdHzMHvTXjzuVyWRDUzzoG4dkNRSaOwU3TlKFHl4C8GjvDiIt5idDqCbVcrCMNxN2K/Y+H0sbJvWq5w/PQUKtjTPHdZWroLxUr4d9LCA5e9Nk7YAH6TgUNzcf9y5N9W0mlMryywLFPzKggTW50f42af65g9NmtNwnPIri07Hz0PiKDmOZ+cBWngFYmbns33tcPhSBiWENSnfBQdkVJkYENg2YrD1IFrIwfL4nmUWfLmMez+mY+1LNIGOJDHdQIfuoyb7I/xu83VsbXptPamvQCN3BUlrveYMckPzY909VFTLDbwU1jjR5mSaB6VkGDw7XrmZqyh86fMjA386CJCWdWRruF4cyOar7K1/MHeFdmHWYmu/pnLUG97DqOkvMQ2qqaiZECZrlnOqT5ykNhXrkHldXkPCTJaoI8hy7BnpNvCG+11gLbhQoNE3Yn9fis2RSjiwwsNTXtE10lc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(10070799003)(4143699003)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cjvZrcxDP34P65aD19uiK37gpGOlEAalMp7tCda0pxiPG9ON+DNkpMC976Fl?=
 =?us-ascii?Q?iFOdWLayEf2lN1t/1Zpe2li4f0JLFHF+bkTtLlscmP52nVOxRzMx+eHhhzA2?=
 =?us-ascii?Q?AGoJ0xQk91V10K/l+FNTabIaUKcP1HCd3vDOdikk0PmRe34PfW+L2edLguo6?=
 =?us-ascii?Q?rkEHU1Yp4IMZZgE4QPJRqZ/v9y2vgmF+zUqSK4AJAKogNpH+W2H+uaqTVdtL?=
 =?us-ascii?Q?yXfFxue200JjCfz9MIUcdTeLjt3Mx9uajOQz9xaCCp9m5yZKMJjBzDWWAvDQ?=
 =?us-ascii?Q?rdOlrLOKRQZkJChHm32JXZpjOGf5+ik3mhoYL0PxDJ1wlFalXSubV1V+nGSC?=
 =?us-ascii?Q?wj0tF0+1neIemhdCUSVHi0Q4KEsREUC9sRIH/7QRibhpuspGK2EW69srJxql?=
 =?us-ascii?Q?+xpAJLrdhsWmbHWGFJtS/0CHgeL7LE1nNvaoaglF/BQtB+HJaU7uHxihvl6x?=
 =?us-ascii?Q?uxP2oPUAKFYSWkwJB9sQPYfj7u6S+bmqpqCT+SNueDt05EtrsE5krVeOUGwy?=
 =?us-ascii?Q?R3k1cwAb4etaLgBtJBwqOsZqtoHXw+XGfQ4VvDDnystdKTw1zYS4U4V+GSgr?=
 =?us-ascii?Q?EhoJDNpWYwFRVA2u8NAPxMUFj887NHtMHEUw7FXIxLsdEyu83ObzuDNl9abB?=
 =?us-ascii?Q?68WbbGEY1DHJvQqeWo4cTnkD4ve0uhUSs9HX4HrA6AuiPT6d3OXh0VHupTc+?=
 =?us-ascii?Q?u8sATDYne6dMBcrnv+oMphBpZqXQigs7xgdvP+cpAkakKBCZIxyYpkfHZ97o?=
 =?us-ascii?Q?hGUUeHZ/9ICB/Ok2v6vm+hJnYrIY76i4PfYbBsmeVDskOPfP/FclFOXHw6K+?=
 =?us-ascii?Q?GaJElQXR+/op3jqoUrsxzr3SEmOTGMUij3srrp2QpZcmA93J5HDbYgPe73T+?=
 =?us-ascii?Q?Zgnyr0PmlB2S89zWxnx19FwTMgmXUSuebfmbejFP//x6QoV9HijFbmDVn6dV?=
 =?us-ascii?Q?7Utt+jvG4x0aCBmUxtOrnIQYhJv7ZJ5wXyZ6ocWUN5Ya/V61/nHsQV24HqIh?=
 =?us-ascii?Q?smfPFS99h0WJcRxJpdr1ccO88guUKiCus004IgDVGR7oh11PAUsJ/QvI3WD4?=
 =?us-ascii?Q?3nlbcTGCwsfxPrkOlu8zQeDCiypcITBRUiGfGisnTuY0AOdi5EgEOmwG2pKc?=
 =?us-ascii?Q?TvjTTfkzIKKMen1oE0kpPwjbJADAOpNGmTzn0BVruk3nuM9Vgsek46mdYbWf?=
 =?us-ascii?Q?HIoVzbIvmWE/nf7qyauy7c2Art25s4nQRH4/YFT3gArZm1JJUSHE2XulUuql?=
 =?us-ascii?Q?ztfbocbabBEQCwOM3cC3ix/L0bZ3vvUbnvVmy+PxJcwTZ8w1Oz5f6VaW4QcZ?=
 =?us-ascii?Q?DHY/vaEc5N9fq4ho8PgIQhAd9ZCX6gL/9M0nJxBIAHTaToao3iVVQP44Yh/q?=
 =?us-ascii?Q?L4dWUYfvo1bEUR9DwC9aurphWLwfqqx8TScb/FUch7BMD2gfsw8Yiq38SbzJ?=
 =?us-ascii?Q?raVxEJZZEA+hwDd2IMWkW+1viTR1eEzk+dTrMQZdpbA1FYhOJ680IGAnqYQd?=
 =?us-ascii?Q?pW8FnQPGybWwy1MUpI2Ig2l2iDNbnHouU+9qieJEovRiWMcqzGGx57J5oSvU?=
 =?us-ascii?Q?HYXxa5rRHhhTxtEA7E1ZRdT6k4+3Weyri5MbVI7PPHfSImaua5rcYBgwFFO1?=
 =?us-ascii?Q?OpQZdmx5imOKGXcpS6KD3IocZvNVq/7PWtbzsczIi/PGLG8ucAc6TLaxyOeb?=
 =?us-ascii?Q?ID0c3ckDzCSTjVo928Wgn42JzHZCkXX7fzbI/fL1iww509vtvX4XCvTn5K76?=
 =?us-ascii?Q?HTOHDffeWZjHGlEZ67vb7ffeuCqMns+7ezJ4/M9ZwYJ3mFaStGcS?=
X-OriginatorOrg: valinux.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d8562a-28c8-4241-553e-08df101bfd9a
X-MS-Exchange-CrossTenant-AuthSource: TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 15:47:31.5690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 7a57bee8-f73d-4c5f-a4f7-d72c91c8c111
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOFRLHPv9WqKDtohIPSd7A5IlULI7Hd+1KlDEyzOaspWpvuBRtnOJwbmxaDx7Rq9bLiRG3XV/sCgDC6mEkqVIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7P286MB7116

On Fri, Sep 11, 2026 at 10:44:56AM +0200, Geert Uytterhoeven wrote:
> Hi Den-san,
> 
> CC ufs
> 
> Thanks for your patch!
> 
> On Fri, 11 Sept 2026 at 09:31, Koichiro Den <den@valinux.co.jp> wrote:
> > Since commit e72323f3b09f ("scsi: ufs: core: Configure only active lanes
> > during link"), the following error is observed on R-Car S4:
> >
> > ufshcd-renesas e6860000.ufs: Tx lane mismatch [config,reported] [2,1]
> > ufshcd-renesas e6860000.ufs: link startup failed -67
> > ufshcd-renesas e6860000.ufs: error -ENOLINK: Initialization failed with error -67
> > ufshcd-renesas e6860000.ufs: probe with driver ufshcd-renesas failed with error -67
> 
> This is very unfortunate...
> 
> > R-Car S4 has one UFS lane per direction, as described in section 152.1
> > of its hardware manual. Without lanes-per-direction, the UFS platform
> > driver defaults to two lanes.
> >
> > Previously, the core used PA_CONNECTEDRXDATALANES and
> > PA_CONNECTEDTXDATALANES to configure the link without checking them
> > against lanes-per-direction, so the missing property did not prevent
> > initialization.
> >
> > Explicitly set lanes-per-direction to 1, now that the validation is in
> > place.
> 
> Given this breaks backwards compatibility with existing DTBs, I think
> this new check should be relaxed iff the DT property "lanes-per-direction" is
> not present. Are any other platforms affected?

I don't know yet. I see some other platforms omit the property, for which I'm
not sure whether they report two connected lanes. I haven't seen any other
reports so far unless I'm missing something.

> Possible solutions I see are:
>   1. Skip the check completely, like commit 06a34d9c1f47b923 ("scsi:
>      ufs: core: Skip link param validation when lanes_per_direction is
>      unset") does for ufshcd-pci?
>   2. Correct hba->lanes_per_direction based on the actual values of
>      PA_CONNECTED[RT]XDATALANES?
> 
> Alternatively, ufshcd_init_lanes_per_dir() could override
> hba->lanes_per_direction to one if "lanes-per-direction" is missing
> and the device is compatible with renesas,r8a779f0-ufs.  Or perhaps
> hba->lanes_per_direction could be preset in ufs-renesas.c, and not
> overwritten by UFSHCD_DEFAULT_LANES_PER_DIRECTION when non-zero?

The binding has stated from the beginning that "If not specified, default is 2
lanes per direction". That is why I thought it made sense to explicitly specify
one lane in the DT. For compatibility with existing DTBs, handling the missing
property in ufs_renesas_init() sounds reasonable, in addition to this DT patch,
as you suggested.
I'm not very familiar with this area, though, so just my two cents. Sorry.

> 
> > Fixes: 5235d551779d ("arm64: dts: renesas: r8a779f0: Add UFS node")
> > Cc: stable@vger.kernel.org # 7.2+
> > Signed-off-by: Koichiro Den <den@valinux.co.jp>
> 
> > --- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
> > +++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
> > @@ -901,6 +901,7 @@ ufs: ufs@e6860000 {
> >                         clocks = <&cpg CPG_MOD 1514>, <&ufs30_clk>;
> >                         clock-names = "fck", "ref_clk";
> >                         freq-table-hz = <200000000 200000000>, <38400000 38400000>;
> > +                       lanes-per-direction = <1>;
> >                         power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
> >                         resets = <&cpg 1514>;
> >                         status = "disabled";
> >
> 
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Works fine on S4SK, so
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Will queue in renesas-fixes for v7.3.

Thanks for the review and testing!

Best regards,
Koichiro

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
