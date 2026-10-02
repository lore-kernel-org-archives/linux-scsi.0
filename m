Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5AC317173;
	Fri,  2 Oct 2026 02:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790909995; cv=none; b=BUx6he1ldPewMqrU0sP+PPNOPJoE0VRIo0hDhfBgxkz7L8xcgEobTgg38m7yTL8q28lTM7mDalx8Kd68hK0vhyArhx6p3HekSTWjZjCXmQhwqPJ1oi5jMBZHtEsrhSAhhmyp7UgQc1wgkd+VnwubhkOyDdi8IinyQSrdN+fnEF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790909995; c=relaxed/simple;
	bh=CNlJh1zt6RBFDmX7JnDqGu1gAqdgqSx9f+wZSj5Ko9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYKjStqvbWDk9pzf+Ykrmjyo7/fJi2VY/DlRhORTtzvQi9qg00ZbLbBrfdvoJAufigsIoe+DZYjQq9Aexuu2jFt89GLlva4lAbwbnMA9Ehbr8+eNhIGd7AP9NMs4RImAi6txN69HwCQt8Z6gmpGGhzHnR8WRBcUUnQKQEMjgXQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7/lYlpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7/lYlpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE431F000FF;
	Fri,  2 Oct 2026 02:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790909994;
	bh=b36/hSATJ+CNgsxZHWieBzcEzJFLGew5hunDmQfVWpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N7/lYlpQ8dU3+Ev+T5aZ8sl7r7ixWokSS9yNFD4+ktFmirTXtboqRNTJA9W4K1Umk
	 TQZlEm3F1oPSNWchAY9ROUrCj8D9MQgovqrj6vNEZEtLkhZOqaSm13XCj9UpZxfFJx
	 4wXQOzqBFXasGN4fVbbMBfhYJwYNxlTJMsRb9VkIue0i/c80A6PpL3/3f3oIXSkOhY
	 0+eiRe1GU6VZIl/hWKRSZfr3kTX65G0Sv32iP1AJJo0v1fSWM7HDV2mfaLysJry0EQ
	 7CZwepiqGkzqX+RtSNnvbiCEJzXkl+VBGTwqUBjRu/TN1kU8RO9SWeWMkBx5ovdMiv
	 riDN4NJBzs4OA==
Date: Fri, 2 Oct 2026 02:59:52 +0000
From: Yixun Lan <dlan@kernel.org>
To: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20261002025952-GKB51329@kernel.org>
References: <20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org>
 <20260921-08-k3-ufs-support-v6-2-3479768a2299@kernel.org>
 <DLLQJDEA91FU.18Q1TSX09AUR3@linux.spacemit.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DLLQJDEA91FU.18Q1TSX09AUR3@linux.spacemit.com>

Hi Troy,

On 17:25 Tue 22 Sep     , Troy Mitchell wrote:
> On Mon Sep 21, 2026 at 8:36 PM +08, Yixun Lan wrote:
> > [...]
> >
> > +static int ufs_spacemit_link_startup_pre_change(struct ufs_hba *hba)
> > +{
> > +	u32 value, sys1clk_1us;
> > +	int err;
> > +
> > +	err = ufs_spacemit_mphy_init(hba);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	err = ufs_spacemit_uniprov1p6_init(hba);
> > +	if (err < 0)
> > +		return err;
> > +
> 
> Should this be `if (err)`? The call chain is:
> 
>   ufs_spacemit_uniprov1p6_init()
>     -> ufs_spacemit_dme_set()
>       -> ufshcd_dme_set()
>         -> ufshcd_dme_set_attr()
> 
> ufshcd_dme_set_attr() returns 0 on success and non-zero on failure,
the comment of ufshcd_dme_set_attr() says so,

> including positive UIC error codes. The current check misses those.
> 
but as I checked the code, there is no positive err code, so I don't
think it's necessary to change

> Also, ufshcd_link_startup() ignores the PRE_CHANGE return value in this
> series' base, so returning an error here alone will not abort startup.
> 
I think it's totally fine for it to ignore, as there are follow-up
checks, as I see, it's function of link_startup_notify() that returning
the error code

> > [...]
> >
> > +static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
> > +{
> > [...]
> > +	err = ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> > +	if (err < 0)
> > +		return err;
> The same `if (err)` check is needed here for positive DME errors.
> 
ditto
> > +
> > +	return ufs_spacemit_wait_mphy_pll_lock(hba);
> > +}
> > +
> > [...]
> >
> > +static int ufs_spacemit_init(struct ufs_hba *hba)
> > +{
> > [...]
> > +	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
> > +
> > +	return 0;
> > +}
> > +
> 

-- 
Yixun Lan (dlan)
