Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DB118C932;
	Thu, 27 Mar 2025 03:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743047995; cv=none; b=qDpC6CzyujHVW8mM5BblGGaPlQCkh2v/fk3o+At6lMzqUTNgMNSaP2EDOnrq/6ZA1DY1O4iz6HYWJHCGfEYlDW5Kj9mZ7wujB6Z3t9u2Hz2ZJdqbyKkU3kbck71h2RLC2QTS5yG9MxVEsuCM543IHjoQLuZMYpAAt1YfpRhUKi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743047995; c=relaxed/simple;
	bh=2snSLY0mD7LyKLMgKKtW5zTBCIxRtrzELpDJYRw2ENk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=l0cpix/9/YQGgnU06OSfsjBYD58lMF2am6VJk+akQq5//A5HXpZIBlSFXKGzZamqHSTtvC6aAp9CkQAmWFUZrn98NE0zoQHihJOv3rjb95sMnKXf/3r8Uo8I9/TzzHgJ8O1MW+6KeiaDq5yW7Wh0UNNYLqKj1cGTwAXyi5OaX6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nsSm7vQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nsSm7vQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A74C4CEDD;
	Thu, 27 Mar 2025 03:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743047995;
	bh=2snSLY0mD7LyKLMgKKtW5zTBCIxRtrzELpDJYRw2ENk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=nsSm7vQRuQaSESVKGOu8o2PP437PUEtWTVtVTPPlMW1Q9S/vG9+aX+f86EEXLN15N
	 tAk70NH9X7n66NSQvuDdIDDiEs2TWlWXnCIniZWCQ9gyrdizV1267lSVqs79OSwUwP
	 QArDaplOWT0Cdq+bdEY/4LCGNNm7vDYkbKF8PetRFpbboTsAqDPb/xofj1f5Mut6tn
	 pb6Kr3lUX9lujndaYuS81mDdlDjCTY1uY1vugLc5ADNOKYkMTTmJoIOoLo2UKLsIQ1
	 hnF4SfpXi0w1nwTyxCwHR3sPk7AZ5/Vig2yBmyc9Qw7PTTT8KU4gcae4DyPh4x8qcs
	 29nALj/hJdJgQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 4E44F380AAFE;
	Thu, 27 Mar 2025 04:00:33 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.14+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <e9a26bbadd5e1b7d263a88d70cde134200d2c57c.camel@HansenPartnership.com>
References: <e9a26bbadd5e1b7d263a88d70cde134200d2c57c.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <e9a26bbadd5e1b7d263a88d70cde134200d2c57c.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 8db816c6f176321e42254badd5c1a8df8bfcfdb4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e3fcbcc3b0eb9b96d2912cdac920f0ae8d1c8f2
Message-Id: <174304803195.1563585.16049097429711162018.pr-tracker-bot@kernel.org>
Date: Thu, 27 Mar 2025 04:00:31 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 26 Mar 2025 15:11:31 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e3fcbcc3b0eb9b96d2912cdac920f0ae8d1c8f2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
