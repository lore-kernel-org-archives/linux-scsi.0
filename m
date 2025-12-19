Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C8B194C96;
	Fri, 19 Dec 2025 21:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766178737; cv=none; b=WBaA4BTmh0hUQgJ/7tvFRy+t9Dta9zAR+DIqFCxHL/NMmavMDuFcOxxaEA5HTVmieobmtqMcPwwC5yCMzqCKo/GkPOxwUasCrhgWAvGe5RpVYP/WNl4cVVuFtJTZShFHLrr4FtqStR10eWDZZPAOV9Zt7lZeHPKvNgRyAFV5Nxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766178737; c=relaxed/simple;
	bh=IiUbZyP5yaT6FmHbdxpDbkxvX0JenMyPi3Qa9YrULgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhYEMFahM3UmYMwhbhKpsAac8WPMnyRZJ7pBA5Y40E5CIK3IrQVIxq0Mu8EmYwCpMdC82YV8FeydC9mKpS0mj8vrbUL3+hjYfqWu/pgUIMvLhfsTzWC9b9xvSI6W6vmxdJsZmOQp93z9fJ1fIb/Sgqt9yX0QfeElVlboF3Kjk8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hLUnDZiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hLUnDZiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0271C4CEF1;
	Fri, 19 Dec 2025 21:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766178737;
	bh=IiUbZyP5yaT6FmHbdxpDbkxvX0JenMyPi3Qa9YrULgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hLUnDZiv675B+5Q2jSqIid9T21CvlvG3m3TxQY4eb0rrhVjkW66cAjGoXLXs+4TyK
	 ewX7LDrtBC/wR+AP6OxuRO3LWxbR8JtHbSRjpt+cCwD/D8VdrKdhUw5nhLcEV219G3
	 uUZfJlfkUMbJCvHQHLHU7k0gsPpYeZCnJ6M9zw2Q9GaR/H8n/nqIVQ5fDVKOvxNJ0y
	 A0JsKGhsgDCBUp+BwohEeI3n+AEmgx0L/KKoAMcTRKtiJ1a3C8k61lPps6WMI5WBgE
	 JUd+TMizJLGYKgrf6LV0Iw8zgyrfx3KuC6WNZK5kJi3vOOTmIaZsKOPWpbFEPZG5nA
	 jt9YjJdLk0qhw==
Date: Fri, 19 Dec 2025 15:12:14 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Zhaoming Luo <zhml@posteo.com>
Cc: linux-scsi@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	devicetree@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>, linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>,
	Conor Dooley <conor+dt@kernel.org>
Subject: Re: [PATCH v3] dt-bindings: ufs: Fix several grammar errors
Message-ID: <176617873434.3944803.4539768491338614991.robh@kernel.org>
References: <20251217-fix-minor-grammar-err-v3-1-9be220cdd56a@posteo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217-fix-minor-grammar-err-v3-1-9be220cdd56a@posteo.com>


On Wed, 17 Dec 2025 22:03:38 +0800, Zhaoming Luo wrote:
> Fix several grammar errors.
> 
> Signed-off-by: Zhaoming Luo <zhml@posteo.com>
> ---
> Changes in v3:
> - Further improvement on the grammar as suggested by Rob Herring.
>   See https://lore.kernel.org/linux-scsi/20251217010112.GA3464453-robh@kernel.org/
> - Link to v2: https://lore.kernel.org/r/20251213-fix-minor-grammar-err-v2-1-b32be57caa13@posteo.com
> 
> Changes in v2:
> - The subject prefixes match the subsystem as suggested in the
>   documentation.
> - The necessary To/Cc entries are included.
> - Link to v1: https://lore.kernel.org/linux-scsi/20251212131112.5516-1-zhml@posteo.com/
> ---
>  Documentation/devicetree/bindings/ufs/ufs-common.yaml | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

