Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515FF311977;
	Sun, 31 May 2026 21:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780262041; cv=none; b=jb9j1BnA7oSIzKPEBOK086Tp9Q2mUCy0X8q/0RfMv87zQBl9EBteaG1DGM9JskaoYniEJc/eQgKCmzUsYkXVykqN/gMSR/dhhEv2hxYieIJNixCFGPE4BhBZYckI4FJZB9zYrqugm24awjIh+b/9glfX2Em1ejNWPCn7ppbiYTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780262041; c=relaxed/simple;
	bh=S3f1X7vJo/NrXjXJ97Gw5/5zZer2ASIZ9zwaXm9fuN0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PXKLu8xaD9e9xpQGlAxvUgu+htBORy282e+Z+K1AAq9peca4/oF9WLbkY2JoSxikLJbqnVISGeFLIyWcjHL5ahyi3/E5uFcg1RNLV0mBtz2kfmqbKOurmC+yHvclDXrpwGW3C3Rg2p5O9RRDvzlBX0wph0E1Ot2Vn5cTwOMK0Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYxXAwyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYxXAwyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386761F00893;
	Sun, 31 May 2026 21:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780262040;
	bh=OFp1fiY/2RfcQ1sfjdvBOpyTQ0e0IoEjfw69Vr35z2g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=HYxXAwyvcKHOJzhF7ieTlAlgh9B0FAN1gVKySTejokvXJflFBNaveVH/J8TvnC6Ir
	 UFRCRTxeBhZzaX5BuGQ2vhSRRMtMcToFXzhobOBOdkcYU5fB9Ycntuy5GRAln7HCAD
	 B3HbSAPHsgjnXUDyks2pMd1f31Y63bljX8QWfrcrWFbaeidhrPV48qyk0kZ2WOyJaE
	 dNcje4zRRQhdhBHVG26ArJuNx98BgKa8bKqDzB+/wnH33QDWZDO7pNAqoZn2M5TnFS
	 lhr3sgA2e8a/CwTv7Su2zENqyiCrap5XW3s5NQmF1Txi9dp6g9KLvuArNwaOjVU/Xr
	 SqJOJCKMnK9NQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1985939302F7;
	Sun, 31 May 2026 21:14:04 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.1-rc5+
From: pr-tracker-bot@kernel.org
In-Reply-To: <145613e24e565d8a539ee4d647d4766541fce526.camel@HansenPartnership.com>
References: <145613e24e565d8a539ee4d647d4766541fce526.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <145613e24e565d8a539ee4d647d4766541fce526.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git tags/scsi-fixes
X-PR-Tracked-Commit-Id: 85db7391310b1304d2dc8ae3b0b12105a9567147
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 13bd441bb98e9cc91f9fb4449415e0519a0de7a9
Message-Id: <178026204251.2979054.2545374446173226585.pr-tracker-bot@kernel.org>
Date: Sun, 31 May 2026 21:14:02 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 31 May 2026 11:33:58 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/13bd441bb98e9cc91f9fb4449415e0519a0de7a9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
