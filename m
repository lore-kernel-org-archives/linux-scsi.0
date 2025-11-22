Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1126E27FD78;
	Sat, 22 Nov 2025 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763836232; cv=none; b=GTHS+Zejea+eRP8mbaOX6iYHNdV9RZABlEA77XpS/LnLUz0fSSasU71vJ+EL7pjg2CO3UwDc+KtPTqnJgikPmu0tIPEdral5JmCf3U9yQ/i3LVpmHFEsK8vuPpcZ5yeiCxPyqeSwk32JwfQxxq6eqQu95O1aJWKfUoxcG9uiQsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763836232; c=relaxed/simple;
	bh=JVsXWpfnLst9cBP0l8j2m0CbGlxfxtOeMpBRh/3m2mA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MUag2IMj287LsFpSWqlyCXkC7okcEWmnKq4RGEQQ4QsuEjWdYesC9tYd7XwuU5w05mXHT/afKPa4g6ZnCnVkZGP5cpv3AfEId/xjfMib7XwjSp1njGEEkYBjWkMUiZHBabybTWA/8/XXbLqJykZgh9jLmseNDoVP26azAB+gk7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4xBGHOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4xBGHOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3142C4CEF5;
	Sat, 22 Nov 2025 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763836231;
	bh=JVsXWpfnLst9cBP0l8j2m0CbGlxfxtOeMpBRh/3m2mA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=S4xBGHOIDyt8A9TN8c2P0UkwcxR/wAh5AOgOqzVCQ9/hB1CJj4yJJ0k9v8sLIuYoS
	 RsrCsvRsAn+MfUcqq5j4QbmXN6FmiJ1ySOWsWS1JmKVgLXlykA0x1UGl+1bBagPYbp
	 rWqZImG6BS8NSwsaaB6vponBPwJTHn5bU266NbA1sGisz+g5B6jMVKVZbw6h0szOd9
	 dunNiPvVdzl2XRj7pTmxejaJQ4V2Yb6HHwfSjrgBS0ZrToehzxQOgbAez2eKcpzcJk
	 nfNlHg1HFjD1KYTEnEP95Mf1Ul+3gvnHBxCE+Sb2V93Xo/roc6JulkLsobQPm5Xy3L
	 izvKwYF1TJGFQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0AB3A82577;
	Sat, 22 Nov 2025 18:29:56 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.18-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <841bb0e5d8de38fae77adce2d3df4c80dc6ef3dc.camel@HansenPartnership.com>
References: <841bb0e5d8de38fae77adce2d3df4c80dc6ef3dc.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <841bb0e5d8de38fae77adce2d3df4c80dc6ef3dc.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 90449f2d1e1f020835cba5417234636937dd657e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7e29f077609413f94f70d4da4d7602a59abad991
Message-Id: <176383619562.2850055.9848586671106675681.pr-tracker-bot@kernel.org>
Date: Sat, 22 Nov 2025 18:29:55 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 22 Nov 2025 10:40:56 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7e29f077609413f94f70d4da4d7602a59abad991

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
