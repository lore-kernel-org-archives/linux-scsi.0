Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9837D486427;
	Mon, 12 Oct 2026 12:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791807474; cv=pass; b=p7bwAel4f56tTNWitUqoZGgjnE5hNj4Q+fdEpaKe2Ra8xdEZ4zMHBZV3U3n+a7yt7HZfG5tcNrPhzQvvaqNLvvi9jEITSvfpCvYjPr/BwAYHN43mUQfmhYqFBoR+wemi2zKhZsaQr9kcU9SBoYrZrm1NpC4KYdHBC9ejmkbfJ9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791807474; c=relaxed/simple;
	bh=tstwZcU0Dw+ukFEZjsuZ+eVU82pedwqD4wTjSoDjD+Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zw9fnR3z0Fm7VQ6M6i/2YPDmV8Njp56YZGuX0Nm0ZI2ha6L15CclATtzARCbBo0nVfx896QrP+qz5FhiuDnbf9LXnCSnjYwGZ3Opt/K3fjOs5WTSriihEPfzLJF2U5KMFbR+CMPwEgywV9KKJtyKC3CW2fYNUiyFHRZBDGG4BuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=AKV4cpjH; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=iabDJt0u; arc=pass smtp.client-ip=85.215.255.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="AKV4cpjH";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="iabDJt0u"
ARC-Seal: i=1; a=rsa-sha256; t=1791806745; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=DgLDJmv8l2VkZB0ZdoGZQ2cxu+N8CoFAvbXmAEGA7Zhg3Y4DIMNqajgcNYh9Ppqmmn
    3ymwx4YYGGdHcstM+uJ5t7JRpyL9AtfswCaRmJKnBCAiASF0tlnWREluc3WdLU9yVyp0
    iiUI67ZpZmuoihJFTk5Djt3GsdSLYLTDNtgt1qWR7AVORVRN3carRtY18+JYX6TOsFQa
    wUd+b38W6clU0U9Z/Q/E+G4CB5judaiLtvMhnFPsu+XZQU3fO38PJEFkCHJBm4onp3pP
    9/xTPVpVWLNAiinfGzeby32XNFYxlb5AhPBptS5rycM1CChj0MTCP74QvGOgUjzPozvs
    y+fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1791806745;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=tstwZcU0Dw+ukFEZjsuZ+eVU82pedwqD4wTjSoDjD+Y=;
    b=Toy/jR6HCMjoQRj6lijLXrtSSB4X/KnqDeHVIKjGqus/ofkwKB3fRfIIDmTYTqzDrq
    Sk7P0obuac5dCVSDk1NgeYgtsogjRwYCEOvxxnSm2leVZLDl3Hy9L0WSN4f5SsjtGOjH
    a8ODXK/1+39dfZoqTca+Ja7qWGjmayIWl4ChIZKAc1UhSfZHIc0z1vZRPhFdj/4n+b/z
    d9C+tPgiCEp27uAGEiHTRyKLHsm46jMARRNoWnQ/l33C1/utRXv7mF9FulhlvzrJsUTY
    BKTYA3MaZ2Y7AzswJ5QtcA42bCEhVrNRa3aJX5sxTtuLpUVQ9aUdyWfXHJBVSQODGxpv
    S8GA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791806745;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=tstwZcU0Dw+ukFEZjsuZ+eVU82pedwqD4wTjSoDjD+Y=;
    b=AKV4cpjHbQcDdCIUZ2B+Hh6lR8KVAFwEr1DRyVIISVFsoCTIhXYii7l5/YEJBg32cL
    SNISX6uL8b6I0csEZxFwau24pHaw4SEZfPtXzCwF5eJqw4hRsZ03YtGdoEledjAfIZzP
    FNWvKRrx3n1JLYWe3c27zQyX7MPEBx77XVTPqv8uh+NijZK8IjTGfw0ZGyqJ/etdAZ5M
    2mjYJkuJvaEXHEq6XhT4iJ84A/yGWasUQVKOHohx3jasb3fUFUPO7czozm3nLYt/cUAb
    iepdsFoNk1DkWWc0M49gGXx0AhZOTloEqF9rs5VnHz2YibCGQqYcgIbMI7AdE/ykuxsA
    kR7w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791806745;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=tstwZcU0Dw+ukFEZjsuZ+eVU82pedwqD4wTjSoDjD+Y=;
    b=iabDJt0umTVto3Az4m3wl1LeQYVeDnsuZMwwrc1WtiAxPAyYJV6DNKuGUqA0wvK1VE
    2hKdx09UKsnRb3uOIrAQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.108]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id z04e1c29CC5i6aw
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 12 Oct 2026 14:05:44 +0200 (CEST)
Message-ID: <b8d939225d06c95111395dbf83cc628245e6e907.camel@iokpp.de>
Subject: Re: [PATCH v2] scsi: ufs: docs: Describe how to test with QEMU
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Bart Van Assche <bvanassche@acm.org>, Alim Akhtar
 <alim.akhtar@samsung.com>,  Shuah Khan <skhan@linuxfoundation.org>, Randy
 Dunlap <rdunlap@infradead.org>, Jeuk Kim <jeuk20.kim@samsung.com>,
 linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Date: Mon, 12 Oct 2026 14:05:43 +0200
In-Reply-To: <20261012120059.1371653-1-stanleyjhu@google.com>
References: <20261012120059.1371653-1-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-10-12 at 20:00 +0800, Stanley Jhu wrote:
> +QEMU emulates a UFS host controller as a PCI device named "ufs" and
> +logical units named "ufs-lu". This can be used to test changes to the
> +UFS core and to ufshcd-pci without UFS hardware.
> +
> +The "ufs" and "ufs-lu" devices are available since QEMU 8.2, and the
> +"mcq" property since QEMU 9.1.

Thanks for v2. The 8.2 and 9.1 versions match the QEMU history.

Reviewed-by: Bean Huo <beanhuo@micron.com>

thanks,=20
Bean
