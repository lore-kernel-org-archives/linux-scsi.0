Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8077725B1D2;
	Sun, 14 Dec 2025 04:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765685711; cv=none; b=kJzqvC5/w5kmIRPI1wjlXdK7ebC8g5Msj6vPusCYyzYXU8NbBQUyD/wfNWsW3ju9yJuf0Vpc/uyCpHoUUuwGkcoEEGNmUHPTfsvOp+1zXrIENNfDkyxN5qvC6yXo8qxhFeXMXVCom1Ud4QMam+YeGe4lD7euH3bO2+Xu354EWes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765685711; c=relaxed/simple;
	bh=I5ymSp75Q7wgmSNGv0aCoX7VSsRxw70Oh5aZvr42WCw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=q9pEsE3dEdbfshYpnDEPMy0kOsoFLo65tZ1lAt19eqMKoqkABYx1ZCYdsSdvDd3sfZ4K/rCh7DVp+nEzRrPt+E9D0Zj4UtwPVyPpSdZIa/ABPqUsmndq9AOcs7DZgN2pWkfIO/I730S1BzfO7bD3oZcFkozPsQofneUGdYBRou0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sDtLaVbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sDtLaVbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05FFC19422;
	Sun, 14 Dec 2025 04:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765685710;
	bh=I5ymSp75Q7wgmSNGv0aCoX7VSsRxw70Oh5aZvr42WCw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sDtLaVbR++5n0Wl6aChpN6GGxpGxGqCAy0i6BZIFEmSmWxthPsNYRbrhokR1OCO8c
	 3UHniv5eyIHO5tvHYimHXk66BJQI6qxvMkXH/z3HtB/1TfsN5fWZABW+i5ZLAJUgM7
	 sj8ru22cKN6SWPgTukep7+D6k1GGz4ZRRWc7o7/Pff2KUNORZsAt30Fg4XEINdAnAL
	 oZ8+oIbc39gs1zcC5Zz4wt2WFqmAAU33s5ts+uMk4ZeKP0P4iE2I/Bhn7FzvfYH4oo
	 DYUXhYXC/q3yyNc3Yp+Fyo50ZuY92d5Sd038PJC2Caq/Lfa3TWvGtEiOlO3LuBXDjM
	 VgPk6NG8b6uQA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 097B8380A95F;
	Sun, 14 Dec 2025 04:12:04 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for the 6.18+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <e482ef9ce85d30aa038a80cf95bcbcf9f7b288c5.camel@HansenPartnership.com>
References: <e482ef9ce85d30aa038a80cf95bcbcf9f7b288c5.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <e482ef9ce85d30aa038a80cf95bcbcf9f7b288c5.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 946574434aa9cfe175c3e8234734a3822410ff53
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6a1636e06625ec0dd7f2b908ab39a8beea24bfd3
Message-Id: <176568552188.2699620.8179249817479710593.pr-tracker-bot@kernel.org>
Date: Sun, 14 Dec 2025 04:12:01 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 14 Dec 2025 10:29:26 +0900:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6a1636e06625ec0dd7f2b908ab39a8beea24bfd3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
