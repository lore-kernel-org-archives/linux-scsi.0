Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795476777;
	b=B7jPr5G203fp6EngGAN3BVlLZc7XCueY4aeX9HX4YCKTW0KcfKx/xO3MmPffl3SHAahn
	 54RGPQSP4E7CqSscDpCy4rYedF3i5T7WFn9Cmckrg6a2KE/6641eKvAXsBtaw8pUBk4tA
	 NH76iA3nj/DH9Nc6/Fj/YSzCCVYvE+LB85Gf866A7yUHGdo86upjr01mQioG72XXsUEZq
	 LTKkmAFv3hckAyCQdQ1EMZuL5G2gqehruOktohF4OlARhe+e6OE1vQ8dX6sw1rWY9nBeF
	 UKpAxfg/geMMRAISWFSeohBHDuxJLAfjhGQj8vMr8HD3GI97z90IxJFSExKq9KuYCzg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795476777;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=802wGgTxL2BIh8nOcoiI7tpdgM6GQQCOpaJq5fEymOY=;
	b=sHFcfLdYV88jqLDDYVw5jHQXGO83FYj/B4FRs+uPF3eqQLC98t8W6B4Y1oTG+H/hOGpc
	 T8BVRgy+I6dVChy1QW8NEjy6xwZKEv0LNaulYryrrlY7cIiYoVmCYsHN3g0ohh0WyeQqU
	 pPK7RLKy8YTOkz4W4by3l5xNuYqA3Ve36fnIUPuqcuqPJROC3Vi9JaPA22xNuPdNChCEV
	 yiOUuZK/C8IraT19nkko/eSNNH2D5w2glGzc/TP/xe6PP1BmYsVdKCw2l1kEjlFTIzfrR
	 esoXWd6TwCclivY1SnZ2R9LwJ332XM70tUaZasIkeUvs6V5MblxzWV2MwS0qy58vl4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CBHapCTG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A930606A321
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 23:32:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A930606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CBHapCTG
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6ba2a448540so25752a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 15:32:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795476775; cv=none;
        d=google.com; s=arc-20260327;
        b=n5ZMrdUc8QVEE/3rwnBAzkJovVvrfgcIPprsrDUSeqmBAp7vlaAn8icMgwzyctsNaD
         UON07ks3JIQ910e2R1RmgS+eZBKNQLCY4CQ8Gly4E/Tl6uj7pIDxFMB1zrOlNxlPbN5c
         T08F9P/0XzzA4rJHjuPiUx+kItCvsqTSAEubfvxz3MqhZWWWzOCgpRuGNSnPpSuJ1E/o
         58j9AFtPNoMmw++MRzKrey3IeqrTD3vZ43ScXSG+unF4bAyA4aFAF4WIJpJwVAusWjXn
         oR2L0141r9vHkgBobxPNxZAJ0a4RrDP0LemUeVRlxqy5ZPwlrjP4JkjoQX8mioVJGjFu
         GmvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=802wGgTxL2BIh8nOcoiI7tpdgM6GQQCOpaJq5fEymOY=;
        fh=dGeMvAZAO9JgetkLOhFia3pOcEwVFJl6uP815dRljn8=;
        b=RD6gYrxJnDfFtEkdFEIt/CaHx/YNqIIhlOQHjHUdfLdGuAP7VlAgjRRN3oThrMzvtR
         2vvvHEgJVIzzDlxFK1jCJgUewAqUpuzWnESCMak+gLgdkhZFUWA1ZSTddw3we4IkZsIa
         aY6FQmTNWwcZxqcejihNEf/RNY06t/ooXwyi4v5nKG3XdDncuOrnM/EQkmDbgOBzUyFG
         51Gf+2PnS++iyDUyF5TvJtfqT63J0evcLNkjB7cXV4D0+R1mJsFPyprw8G/dhA6GVJA7
         gRYzRf7Y0PsWxk3VguZrGTSyISKqBT0mhT5cqQV0YsN7d7DQh8RbyDX0xcHCykwNOAF9
         qGqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795476775; x=1796081575; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=802wGgTxL2BIh8nOcoiI7tpdgM6GQQCOpaJq5fEymOY=;
        b=CBHapCTG2hX3533WtKNnFa8FMkGnpuTJ22q43wLteW2fcuRI/dJrp81dblwjFwHfCi
         NEbWfrcyFntI9xrPwhac1SMAe0cQJosjIrcEvwsWeLuaRSctds/0OpeKSvacWr3PXtEb
         uQc2RuDX5dIkJ8EgIVqmJ/z+rQx2L2CyCzWfHsDjuZy1h1zZClhaVNOS596hvUZ1/PXF
         kbzcEh8IWpftxsChdVr3yb0gjN+nTUCAjx9kCpMcmlvnA2t51TZi76e57zOWxfM73kkG
         DRq895f8Q0mpu1TcahnzupaWoOu6nKVOOpESOfleDYkAQpab7YytpDiTcVHKHbfJPS21
         CiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795476775; x=1796081575;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=802wGgTxL2BIh8nOcoiI7tpdgM6GQQCOpaJq5fEymOY=;
        b=Go8fywTUfgstBGXPgUnJX2HZkBNMCQQg3++NMeJvZWkqwr1aV2ZfNjYm0sJ9ljO3Uu
         Mumxc8zy6H0Z13xGPSikAqwzIyjBcA/rSoFBnwVfDdMRYoFJySg+kcySMTcJxRSFfxxu
         pdHwwILCEzB2JrD1GeBMayQoYNu5ipllA6dypOTLpCX9P+44pR19B7vpRpsfqTp4ckE4
         Aucrzzak1cUgKvrbVl/nWYVI0JgUQSP6ejqV7b/73YdVmPFs6/9UcD8PDy6muqwylIDP
         4Aw+KGLGXTC5ATbylWtEo0xqJ7bLARHoDUVsoySisDMgYuEa6r0BQu4ytfnCrnR55mtE
         ENRw==
X-Forwarded-Encrypted: i=1; AL+hErGXGYA5o/JUtG5CHwsvyFOiyNNE1QYAh2WHjtPdbS12bpkQNg3LCxF+5IbveJXcDpaDhCRAnKp9tt3t@vger.kernel.org
X-Gm-Message-State: APuU4Z9IESKoBpThkTewu43Hu/HnLVY5p2pev+8KtMHsu7C/y73iFYo7
	M+vGR5y+v+DDS3wFhaZ0aobjLkkCxr+WUZwjoHBsXO45Axva7iqEw2on6tLG41Cgh78mquIC143
	AnmCVmw5PRe/Q59ODp4R14ynqJ7azgH7vgHRn3ut/
X-Gm-Gg: AZFdTZdLgotPJv4QjJnsWIezOzIwN5dW+F6MZ483rjU9kzDGwkRW34TJhxYJTPDm8Gj
	cr87tPrPorhcqQyKJwZk0kYdyAt3jTjcxg/iVWaLo5nk6PIezIiKOzJVZhcl4zToZzRui5c+wuQ
	r4UCIyabRtQknrZSJNS/dAcXWhwJIX9S5L9q392X5V/CdeqJ1Cg0bnT9uer8sHUQi1gKC1lY1dh
	SLL/va+1nxp+qZfRcuSW4Yv0JO8UZdHcx6mfbvepXPxrW1ho94JoeRrtCS1JplVI6rY3jexRLPn
	MllIC0ei31+Q/gwy1UTzhQKxrJ74gU3e+X6Gdab7WNBaNGlfOLSBQkA4mCMwxjaPlh2/O6OADjo
	ELgt4xcQURR9GygVQZqYONo0Yr/YabLUcxLzkaHtYW0vL4gSxC+azjrZlgm2LTD3jj/Jo9hA=
X-Received: by 2002:a05:6402:22ed:b0:6b5:76b2:5e18 with SMTP id
 4fb4d7f45d1cf-6ba65a9f076mr182571a12.2.1795476774480; Mon, 23 Nov 2026
 15:32:54 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117004729.635562-1-chullee@google.com> <f63d7506b930b710d9a31f082b97a0e43e75dd50.camel@mediatek.com>
In-Reply-To: <f63d7506b930b710d9a31f082b97a0e43e75dd50.camel@mediatek.com>
From: Daniel Lee <chullee@google.com>
Date: Mon, 23 Nov 2026 15:32:42 -0800
X-Gm-Features: Aa3M54pn56r9mXNCvyoeX_4soS_y6FexQolLXrCQ0zk6fXKqY8UPUUoF3DopNSc
Message-ID: <CALBjLoAtLCcQJ2TQD4uuTJR-eiD1Dqr+Q2oV1+8K4pnOKRuOvw@mail.gmail.com>
Subject: Re: [PATCH v4] ufs: sysfs: Add WB partial flush mode support
To: Peter Wang <peter.wang@mediatek.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	alim.akhtar@samsung.com, avri.altman@sandisk.com, bvanassche@acm.org, 
	tanghuan@vivo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Peter,

ufshcd_is_wb_attrs() determines whether a query request sets INDEX via
ufshcd_wb_get_query_index(hba) or leaves it as 0.

Per JESD220G Table 14.28, 0x42, 0x43, and 0x44 (along with 0x3F) are
Type "D" (device-level) attributes and must use INDEX =3D 0, even in
LU-dedicated WB mode. Only 0x1C-0x1F, 0x40-0x41, and 0x45-0x46 are
"A/LU/0 or D" (Note 15) and use ufshcd_wb_get_query_index(hba).

This was updated in v4 per Bart's review [1].

[1] https://lore.kernel.org/linux-scsi/9d58cbf3-e0cc-41b8-8958-df8abd505524=
@acm.org/

Thanks,
Daniel


On Thu, Nov 19, 2026 at 1:59=E2=80=AFAM Peter Wang <peter.wang@mediatek.com=
> wrote:
>
> On Mon, 2026-11-16 at 17:47 -0700, Daniel Lee wrote:
> > @@ -1672,8 +1753,29 @@ static DEVICE_ATTR_RW(max_number_of_rtt);
> >
> >  static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
> >  {
> > -     return idn >=3D QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
> > -             idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
> > +     return (idn >=3D QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
> > +             idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE) ||
> > +            idn =3D=3D QUERY_ATTR_IDN_MAX_FIFO_SIZE_WB_PFM ||
> > +            idn =3D=3D QUERY_ATTR_IDN_CURRENT_FIFO_SIZE_WB_PFM ||
> > +            idn =3D=3D QUERY_ATTR_IDN_PINNED_WB_SIZE ||
> > +            idn =3D=3D QUERY_ATTR_IDN_NON_PINNED_WB_MIN_SIZE;
> > +}
>
> Hi Daniel,
>
> May I know why the ones below are not included?
> QUERY_ATTR_IDN_PINNED_WB_CURRENT_SIZE =3D 0x42
> QUERY_ATTR_IDN_PINNED_WB_AVAIL_PERC =3D 0x43
> QUERY_ATTR_IDN_PINNED_WB_CUMULATIVE_WS =3D 0x44
>
> Thanks
> Peter
>
