Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F4C2E414;
	Mon, 27 Jan 2025 00:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737938091; cv=none; b=WvQOaGglYciQUremkmKrNtWj6Ptx2T7Ex4fqtORdpsTJfoELQ2c7k7NT4LAGmuu275z6eijLbWkz989vIUW1iprC6Vk4tkE/VoxI51n1x5wUdZnqrxjmW2ODWMK3sr5R0IULyOaJClQ3M7IbcU7tpyms0enP3KnNpCwrwxJT7RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737938091; c=relaxed/simple;
	bh=jtNCJSy1xd+0xQ4vMuIrO2Y609JRy/nijkPKvAaUUuY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pGCeNIkOj9aI1mxBwoYP3TqW56A0uJFuhllwOTifL9bBkxJqtOqEOXPLBI1cwTjXzUEAfPf0tL/azAIjj+2jN1ix+nopbNjoeGVeeUn/Zgy7uSraRpU6MLg56J0w6kv7rw9wiFfldOb1k12ydwseiKEQC3MglX65BEnYinLO1lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVxufeO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVxufeO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B627C4CEE4;
	Mon, 27 Jan 2025 00:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737938091;
	bh=jtNCJSy1xd+0xQ4vMuIrO2Y609JRy/nijkPKvAaUUuY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=iVxufeO2mpQmv/uW9iWHCyr30JSPknPgkmCZ9kZuWbhXeDEWs115xOinr3Zyrm8qL
	 nQYQpMGEtrV/9NYJm9bn1HYVxeBO/QLvyc1D6afH85fYhdJ71FCrPaWx9tgpbe9Rpt
	 WBCCj18lfcSsXjt6hQHm0b4tty+WdJnoAU4V/qEWriY/d4t27FkaiLLwUnIh98h3Ph
	 NEYSiay1DbuWbwmKPvuRBfCzCt2PLZkL8JV/jJHpgoT1f5TUwqhn21AuBmg7CKhaUN
	 zTSYBtLrTsnz0EcRkFQ/rd9eQNA7eTm0+QsYJRVi22eABMhYKRapIbj8YFVC7qXKEm
	 8roZjugtTMo9w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE13380AA79;
	Mon, 27 Jan 2025 00:35:17 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.12+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <383ace1bc4fc8acb1f14403218f0891bcbc21cdf.camel@kernel.org>
References: <383ace1bc4fc8acb1f14403218f0891bcbc21cdf.camel@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <383ace1bc4fc8acb1f14403218f0891bcbc21cdf.camel@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 7d6f88e76e28ac44ed003dcf80881ea6b202ec08
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 88e45067a30918ebb4942120892963e2311330af
Message-Id: <173793811655.2914332.2012331673131341889.pr-tracker-bot@kernel.org>
Date: Mon, 27 Jan 2025 00:35:16 +0000
To: James Bottomley <jejb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 26 Jan 2025 10:10:21 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/88e45067a30918ebb4942120892963e2311330af

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
