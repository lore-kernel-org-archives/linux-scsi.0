Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9742481ACD;
	Fri,  9 Oct 2026 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557656; cv=none; b=pkMeNc7zZZS9EzkLrNZ0RIK8Y8ULOkV6qkeilQV5VIbMEKNCsvvewVnR52tHk4vb+xHu/rhRL9IAZO9Lo0VX9utlHnbKl4Wdms7LacDn0PY0+fjAxexZRD6gXdsnrf+mRDORP9WdhKvtmjds1SgHMflZmoW3PyrLwlwrDESJuFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557656; c=relaxed/simple;
	bh=pKnr66K5LkeHYaqIKoZ5+IB0TdHqx8L3nfB3f83cFqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtUp95H6ZQmTdRX3pbUqeuHEtbTwA8CIWr+WPUTr8pIJAj8be79NU3XaKY/rU+B3/kKKpUfbB5hI5lMxnhOqgm4gIB8ZlOjHMoy6yrCWGZ+lWDC7rvxEy4hPNnRyNkM+Hfb2lbUozRO1xFv+877D6JphZBlwUEZoDF/bWVk+QB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZbZizl7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZbZizl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B653E1F000FF;
	Fri,  9 Oct 2026 14:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791557655;
	bh=K8fYdYBN96GvkG2/zkMD0kHG+t7VNzh9golPxEFheh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RZbZizl7zY+GxNqpQQLALtHGPwzlG7soJlwQVGcVXxevvTgEFLKR774AJ1BFEDoQ+
	 fyrSQohcMHqkQjKISaB4esbX6HXIX5bPgQ4/gA2gUCzoGkCeK3tuLJKZNn4XORqHvS
	 yr5qUa+52bFKMutHIC5sbRww1HTiREUEVUiSfjqJxEad5egbodoJb24lWbYUgKH3O2
	 XFprSy9dP9Jj1uPIzkL5o2gEz38W1JPX5ecGTlUNGiOYHB2ALuvAlbX1p/TDVB6aYp
	 3fiuNRcwylnt8c13Co5onvCMi56lvE2GQBGhfDP9j6QRniRmRcXleSrskOuuFKD89j
	 lTCzfVAWvdchA==
Date: Fri, 9 Oct 2026 16:54:11 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Phil Pemberton <philpem@philpem.me.uk>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v8 0/6] libata-scsi: multi-LUN ATAPI device support
Message-ID: <askAE1FcZJ3jFiWl@ryzen>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
 <apVF22SjDzqkzEkm@ryzen>
 <0a7bba64-c0fb-43c7-bcaa-d806f2377afd@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a7bba64-c0fb-43c7-bcaa-d806f2377afd@philpem.me.uk>

Hello Phil,

On Tue, Oct 06, 2026 at 05:12:38PM +0100, Phil Pemberton wrote:
> On 31/08/2026 10:14, Niklas Cassel wrote:
> 
> Thanks for the comments - sorry for the delay on my part. I saw the
> automated Sashiko reviews but was pulled away onto something else.
> 
> Would it help if I responded to the Sashiko emails individually, or is
> responding on the next patch covering note enough?

Simply sending a new series is fine, like you already did.

It will unfortunately most likely miss 7.4, since we will need acks
from the SCSI maintainers on the SCSI parts, and I saw that you got
some additional (non-preexisting issue) from Sashiko.

But my recommendation is still to respin sooner rather than later,
such that we can get it merged any not miss (another) release cycle.


Kind regards,
Niklas
