Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083092;
	b=gUs8fWAt+o1L+Z4D49B0wx7imRg5p+IRX6VCApRrEGnCt4nF1edQyemUE06YsqmoWEEk
	 YC9sexr1i/HXSEkuqMKxr6jc3kE0zuIJI5lvKTylbICgyp2G/08OmhB/SbHrcWedParsu
	 DGWboS0DptI3i+dIbkzaIr5iMtBHETG3yODU6fU3GYgy3e60WEMEVnrIzBNZoIQz6kuYj
	 P29MP4NPBd6fSq4IGf42SZ4UOXEgyLBwIHn2aFh/nIQVvQH7zXzoShznxQ45lN62GebF9
	 8WNRfrfNvGWqtrpFYko+7XJuPIiuAlZMcdr3e1kWB/tgc9dhWca7Y9VADBxXdw2I+Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083092;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=0zuI3S/n418ws9iDQmtJUrxRVrrGSrwLVldwJslo05Q=;
	b=V72LiOQpOyopLxs8rIqhQkVFy6Q7oOIO7EQYVCmQuvDvzGtKLMzujpz26K0yEVYZdY1f
	 /6/8nNoJVuVnleRXPEHEEe9li1VclEJbbjwLIyFGUyu2KQdR0DZHWhsF0yv4vaT0nz6xL
	 TQnuUEuDV0KYXG/v89OQ3YBaF1/q0eKsrQevPQ92YXAkECeTTY0xCBvjJHTuECvKuUC+d
	 Mdzia5ZUcPizcv76s4IVr6w1P7lwJ5whmuvbCuGWwXH+ZKI0zKhbcZLQDg0KqzXQr5j9y
	 6LrRJDo980xdjn4Uy3CoLvTPGDNAnZ0iVplVo3kpqFshdIsYQrUnszXRZi0FA+Qf3XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MonteB66;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CC5606D807;
	Sat,  7 Nov 2026 20:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MonteB66
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319381F008A7;
	Sat,  7 Nov 2026 20:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083092;
	bh=0zuI3S/n418ws9iDQmtJUrxRVrrGSrwLVldwJslo05Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=MonteB66VZb/JAczLKjyoClNr4KIDTKzkEhTftQtXucg0KZLFTrN63lZzaqKMA5v1
	 mwN35btIRlWv42URgNWw8GnreUu0N7V31WLmQkosAgdb7JP7vOb9t1LZAYINQ2ZPPh
	 awb6n2Q/GOPNEEvBPzEKRfTcdfaHPKR4hD+v5h335WrnRmMwC/2DGalhdluqcDwC9N
	 r08bjcR75+D2CxMMh4/GyzqDgxEg5yJKpUgWG2q/qa2o/nh59CnLPwQf/wnRqhqzHK
	 /P1Gwei/jDuWYVrQg5Ztt4UWXVhKuBXolTxiQIoQIrK0eM5D7d9ftpZm9tj40FigUo
	 /RAFTgrakkBqg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 21282380821F;
	Sat,  7 Nov 2026 20:24:52 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.4-rc1+
From: pr-tracker-bot@kernel.org
In-Reply-To: <49923933505639f8c35894464a0a8c57773d4877.camel@HansenPartnership.com>
References: <49923933505639f8c35894464a0a8c57773d4877.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <49923933505639f8c35894464a0a8c57773d4877.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: ca14cc05808f9c0115c38bec53573bf93e030435
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a41e364995bbcfa627418a70fe913c35b7510728
Message-Id: <179408309076.1325067.11085477369061529747.pr-tracker-bot@kernel.org>
Date: Sat, 07 Nov 2026 20:24:50 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sat, 07 Nov 2026 11:50:41 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a41e364995bbcfa627418a70fe913c35b7510728

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
