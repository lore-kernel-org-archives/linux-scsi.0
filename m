Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E133530F7E4;
	Fri, 22 Aug 2025 13:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755869802; cv=none; b=Ch01VsAf9usvSouGrdl6xAYv3Gsg4IniZN/21Z44sh0u9f4b9zdCTguTsAjJvBzP1D6qY6y//z4LVlSeRVGd7qbIeFEm00/+TT+8y7ukwROV0UucCGW0Pzw2PzrYNHIUstKy5GJ22UdGXxz+XNN5narvpHQn5lccPvhZAP8wTug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755869802; c=relaxed/simple;
	bh=oh8SopeOXSMcCmDZqTqvz2f7s5KClrXtHY8Gv9JUFh8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TcamhhkUx5vZBNY9wUSe0B3GDh21MzUUijTXKb6E9FIjdJrx2AdSWbh3s/IYbj5Mc5eGfZaMhHbfDbb+VTEHd0vP3nm6B9TOgx/jbtdl6GDbB2Jz6XSykTTFUUEEgLytppnFo0m+ZE4WasNfQlhUOc5bo/NpJMHwZoIi58D1spo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHpz/xYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHpz/xYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA846C4AF0B;
	Fri, 22 Aug 2025 13:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755869801;
	bh=oh8SopeOXSMcCmDZqTqvz2f7s5KClrXtHY8Gv9JUFh8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=CHpz/xYxMigxtJJtF5gGjuZCzwA/PMWd9iXnlzTAyff089y5L4EBVWpsnKarb9JML
	 go9MC08ukMWJ/WqzFSg2PhvhpVAhzgNeJatDx4KvEYxKK6r5s4WllYLBUc6CLmicP9
	 Q94CUCNTjI+mFjmT1DWRCL/bEZ23N18sYytUlVrK6Br1ECs3N0X/bMm9K3OvA0nQyX
	 2BUnkyMuy1wUvFI2/9HLP98tGiUsa8lEbzImoCxKxOlvSC/cMC+ttk5IfQc0SCJgGm
	 mvBlUrbY7L+iFE3V5/EqmryJTy/poaA4hDR16bjVjb+ee+rSJM9MopZzzZXgkKaudA
	 qTYTCUJ76S0VA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAFE6383BF6A;
	Fri, 22 Aug 2025 13:36:51 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <452558f823f5396a3c7a44c72cc0e0fb6b081a3b.camel@HansenPartnership.com>
References: <452558f823f5396a3c7a44c72cc0e0fb6b081a3b.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <452558f823f5396a3c7a44c72cc0e0fb6b081a3b.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 6300d5c5438724c0876828da2f6e2c1a661871fc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: edeee68c42747c9d9b237f06fbc4cd1a2348fefb
Message-Id: <175586981058.1831455.15728216335802047026.pr-tracker-bot@kernel.org>
Date: Fri, 22 Aug 2025 13:36:50 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 22 Aug 2025 11:17:41 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/edeee68c42747c9d9b237f06fbc4cd1a2348fefb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
