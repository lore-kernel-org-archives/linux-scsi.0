Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9D031618B;
	Sun,  2 Aug 2026 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785693164; cv=none; b=eDiPeZhhI3ACed3fAi7zibVCAVDVJ4P0pT9g3u9W8e89+ER6x8FIzENm++Hx49IwLiYJ19frzDkJVWoGuMJ4yipEQ4m2qvPoVGyDD0z7a6/9yYe4E5vT515EMVL59nD6bd6FT1htJVxP5/UzBrmA92S7DxhraFfe1OUDe1iHgr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785693164; c=relaxed/simple;
	bh=phTI7z8RTOh1WXTD2RDTT3MP6pOIfXWGCLPXn51cHIU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=kd2ahI5Yf4UdeqJVAXugeIWqx/3sD2XH9b4M4dL6au5DoxPKTKLBPcvr4kNJWlSTsJiEdkHmJdZwJM86P2x+rDtpl55Qw2gZFDyRm5bVF6PTkxlJ8J+GmSOoyeZiFtUteeFuB0NvwoA0j5tRT6AiLvB5ZzL3pSO9O17OqycVf/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/sIw+Jn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/sIw+Jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364951F000E9;
	Sun,  2 Aug 2026 17:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785693162;
	bh=BNMUHntwVTSMm5hFuT2ax92d9xO3CbmNaAHm81nYfFs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=L/sIw+JnZrG8uVBMC1Mfmb7nGa/MsuqhdiM4COAFjcXIhWGBJJB7o/GsRhzSvbvbZ
	 Wl6cIVV1kYBXd2w0EYBYOB/ukp6gUojyEsiDKOimL+ZKb+3MnJeulYdCyP0uS2DY06
	 +TtwaW2fw8wpPG/DHO3nHkhl6r6k+G3L+i6AGwNq1dzc2lLsy5RiYstaSSXGkVR9rw
	 sBG0Ffoc6rUzse8VdpowHLmhBkqdnqiHOaHg62TI8Nkc8LRUX6EHpYUaOlWRy5hhXm
	 8WIAw3TDGoDU6Fo2siSGxIM6r7xtxfJpG1T5GK2wDiy0oYOyb/QxIRsKPbh+PF4gKn
	 KA8cW9YBQ63fg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1985C3809A33;
	Sun,  2 Aug 2026 17:52:05 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.2-rc5+
From: pr-tracker-bot@kernel.org
In-Reply-To: <62fc8f5dd0e1e9ac6d512e84173d33e4676adc35.camel@HansenPartnership.com>
References: <62fc8f5dd0e1e9ac6d512e84173d33e4676adc35.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <62fc8f5dd0e1e9ac6d512e84173d33e4676adc35.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: 0279fd451a9971c0d5b959fc59f3e11b55e1694e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a84c804215062d17c14141988ff3c69af961b49d
Message-Id: <178569312366.1445093.4201931286338524656.pr-tracker-bot@kernel.org>
Date: Sun, 02 Aug 2026 17:52:03 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 02 Aug 2026 08:51:38 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a84c804215062d17c14141988ff3c69af961b49d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
