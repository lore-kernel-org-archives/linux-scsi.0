Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D118327FB2A;
	Wed, 25 Feb 2026 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772031148; cv=none; b=Bn+9Ie7SG8jStEk8xC9/qmFM9NEhSSkKqRCgHWo9aUVBPbjqHrA7UBZQWdvj1jyd2s0413MJWmbC0dondPdnZZZsJpofS6kqsybWRxDo3PbA+QjBcn6PcyxfWw/4NUe9KGuIl80zRMqkNRLF/FpfjHZ0iGwWsqaPnUW6Zd9a5jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772031148; c=relaxed/simple;
	bh=eaxgYMDu4b1CCqhGuli8mqFA6url1u1XPz3Kqvl771s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IofsTX2qh10+h5M2WUVDgJ8eOJ0/GmQi6kvZdvtER28zMT1SbJ9NpmJXftgyzqPw3N0RGF1KSjMlQJxY/R7WRgVO8VGm32ceNWCd8O+yK3Q5PaKg3z0CFYExNGiPkMsAw6jQdRMrcdNJmmO8m777nyfCJNuwU+chciM65X5KlYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KoAeoXkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KoAeoXkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3BEC2BC86;
	Wed, 25 Feb 2026 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772031148;
	bh=eaxgYMDu4b1CCqhGuli8mqFA6url1u1XPz3Kqvl771s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KoAeoXkhhl1bznc4VYkRWZlAg2ppjiWIUk0dnyKZ/zNxMFttbW7QyxEtB6pG5zQjx
	 kRRp3jq7uA9gplfRPwbQrmmtlzahdHgrT48RPrE5hr9qEsas/hD22oR8nBpFmdJIz9
	 nKF71nxtE2uzxbqki8A49/NOqHEKaD1UetwZWfwNEopBdyqg0SRSjMIfs1BlmAd72/
	 S1D/QAw/CU+JLfxhBZKU86lpGi2wPVQg1fPzvTlnR/ls1nbYymevb3TDDKOiQii4u/
	 +yj1cu91PsamtV8cHHpRoUJyc5VGvw0IdmN62fKfAcoiMma3V/oyST85F6eJ5Ymxe7
	 N1uGyXNaHKg+g==
Date: Wed, 25 Feb 2026 15:52:23 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: LSF/MM/BPF: 2026: (V)FS: First Round of Invites Sent
Message-ID: <20260225-aufeinander-kummervoll-1953a06beae9@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>

Hey everyone,

I sent out the first round of invites for the (V)FS track.
The first batch is also the largest batch. We will send out a set of
smaller invites later.

Note that the first batch includes everyone that indicated that they
would require a VISA.

Thanks!
Christian
