Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E7722257E;
	Sat, 11 Oct 2025 19:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760209700; cv=none; b=sYoxfYrGUspdRJ3ul1v0RXWpOUG42Reyikiv5jINfz+tmul2ab9l7RnMtXy0CXExFF8alwM2/LYB+9ai0TvAxrYpRV9KlB697Fmh3fXD3fTmMvvlSvn+yrra4W+912CiXng/2Gc6vOuJaakU8hrE2XSF9LCyY7qiaKIxNdS18yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760209700; c=relaxed/simple;
	bh=0vujgX36UxfLfERaOpT2R3xFRtt7bzR70bYb5QqZaiM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZBUu7JZYJ40cf5LE0Y8S+Co39pEWXdnJKTToTv7jys8/iC2hyQAiqywaXZQCIvXpRozfyFDHqQoJKWoxhSueyvRSTePKWD2QJuaI+I36I5lVpsB8SXrg5b3i7LyDdfC+VM89VheJ377El3040kOnUIjBYGnyxvxyxm/EqXjE7r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JX8Nj6DB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JX8Nj6DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C4BC4CEF4;
	Sat, 11 Oct 2025 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760209700;
	bh=0vujgX36UxfLfERaOpT2R3xFRtt7bzR70bYb5QqZaiM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JX8Nj6DBaOE0GPiH1uXD/GnzMr0ZVtGUaR0dKutJOYKIJE0UPtm7YuhEAqEzDvreQ
	 thorYCFoaScJ7ha49Bi/ckWgRjVvqWGzl5TsGzRBScnP2Dqed7+YPW+ulQmz2CmvYs
	 mjjR1tpHSffzRu1Caj7uNry/IUE277db4HbxiYVGyAwJYAgvtP8YKy8CVW0r15Wo3f
	 0uFusd/zMpYIA72LdOx4oV5rAYbfebBUtz0JlQ1EqxZVFbkx7Uc1EHS8StE4qOEb9T
	 oC87MxJOm7vwvQoOS/mP/8aU5WfQg4fivMs0Kl3mPgnqL0zsSGNpIaXzzRSucNUI7L
	 plELzEDtaIg+Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 346003809A18;
	Sat, 11 Oct 2025 19:08:08 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for the 6.17+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <6e77e31acee95ebcba03c54dc1b34173cbaf831e.camel@HansenPartnership.com>
References: <6e77e31acee95ebcba03c54dc1b34173cbaf831e.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <6e77e31acee95ebcba03c54dc1b34173cbaf831e.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 558ae4579810fa0fef011944230c65a6f3087f85
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2a6edd867b155cb5c391a32a66ce7e5d2cdcb531
Message-Id: <176020968685.1431021.1408962729467958681.pr-tracker-bot@kernel.org>
Date: Sat, 11 Oct 2025 19:08:06 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 11 Oct 2025 10:47:02 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2a6edd867b155cb5c391a32a66ce7e5d2cdcb531

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
