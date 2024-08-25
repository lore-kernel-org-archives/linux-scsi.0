Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC311877;
	Sun, 25 Aug 2024 00:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724544822; cv=none; b=L+EK9KuaetHf8Oo2E04ml0RESDeJs7TkCg9f/gEpe8JDTgsGkIbfKfpTOybWkbJ0SBq8K58EVnNeoDPPAfJVAPiGQL9TyUtPvx4hTDru866q3pAHZY0DQjeS49Z2DzM21idm8cdeJKIal6B6uVv7S3I9mSXfpaJd6NepXANkNlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724544822; c=relaxed/simple;
	bh=yjitJj9TI/+s+Yri0Zf2whMB3g/XKNoNTFM1rG7/6jc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fLNJ2X1cdWSF1yZLLRoedRgE614TQA6n5z5iaNrBxxgeTdBbKhAhZBtbQJhxx4GIPhUJqBpg9IW74xMSRW8ojRx68qkPIj4OEO+9O4MrOco8gJf2XHv9I7MtXJQHWsBI6oXhLKIa/QX7MFrtlxXjRQJXGGbeejg0/F8rKSKtiHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PtMWr807; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PtMWr807"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA37C32781;
	Sun, 25 Aug 2024 00:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724544822;
	bh=yjitJj9TI/+s+Yri0Zf2whMB3g/XKNoNTFM1rG7/6jc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PtMWr8076SuUYlzIONkislt6Kwkj5cu7RerJKxxqWcaEHAl0GPayT1g27x8ylk6tB
	 uVv7az/zMXgyYvbzekGbaFbuI9S/FVlXIe9TiPN8LFGfqwIcERtQwDbmjnDDl+fSZo
	 Wx/DL87pHcn6CanDEAB7arrgOEjFOFCDm+0Yr+75cNL6qZH0PgDnzeSHZAMgcVLBOJ
	 uZtgojZpTz9NrL/Hw4Mfv7N2waLZiv/FSVbtwQnjyrltXiCkbpcN6mizq2R5/BZnSR
	 xd49i00/JFPVIW+3Eh8yIw/ISIohbz7Mztk631du+sJp4vtjjG7qzdtP6eWcIjfzr1
	 i7lBSypAg0bsQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E8B3823327;
	Sun, 25 Aug 2024 00:13:43 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.11-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <2e030c4ab1abd1a0d0b03bae6667be5ef0d9e817.camel@HansenPartnership.com>
References: <2e030c4ab1abd1a0d0b03bae6667be5ef0d9e817.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <2e030c4ab1abd1a0d0b03bae6667be5ef0d9e817.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: cbaac68987b8699397df29413b33bd51f5255255
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 891e811ad604805b2c706f85480e38961b706a70
Message-Id: <172454482178.3301129.1390880395746671047.pr-tracker-bot@kernel.org>
Date: Sun, 25 Aug 2024 00:13:41 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 24 Aug 2024 10:31:59 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/891e811ad604805b2c706f85480e38961b706a70

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
