Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9D452CCDE;
	Fri, 18 Sep 2026 21:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789765916; cv=none; b=jcSD70GFFg/opKcshCPmic3Fxr9aB5MP/ytMAyFzwZYU3vQ3Ho8wNq9ARpqn4krzfihSSbR/EZbqcQASNV+9aYPlA6ZB/vifRLI6E4LwMrEpWc/0jaMmft+Q+02Q8VGCo7ras6Jkoi2Mx7mnLfM3WOPkraDo6wcb52kiFwRJtJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789765916; c=relaxed/simple;
	bh=45cwotVTcP0wrzfFE9XPo0/yQ22NwSptuJO/Cw/lzFQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=UVfR1oV4JczENcos6E71lsVlkaxBGwZabQhk8LA8HiyuEkjvsrhOMiF9lm1x1CwiMQuSFDEMDAem9qtMkqbG9RRwMQ+Sl9XSNhzXdZwhDOYfyUTTuFuhv6IGNISbL63hAnpv6x8ElRA4CBbD5n9adGSFdnoshUNphsTT2449NJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvWmc1L6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvWmc1L6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179E61F000FF;
	Fri, 18 Sep 2026 21:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789765915;
	bh=dbTO0deC3tdKb29XgSRV4BCKqSfgDvklosumnboxh2U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=CvWmc1L6ObW8NIlpH3eKm1JPV8mlRg8sHSAg/iyk2T1S7hJePvo3QZEkSkBGVaiMp
	 2edvoX2T6b03yI1vuZB+0U1u4loVi9MBrD46/joxqPDABlPDHbaEA8Xgoq5vomWgSP
	 d3Q2qF69kkmjnhQKHRTIdUrSmYwhNd9aREeegXVkAPQCV9Z+Dro+33F5vfZQT28Npj
	 EdA5Csx+jN0aUtVmNbxuYJ18q9R6HeyBx/rdIYnx8wmFTs1kpqFj5tOwOhPCF5ViiC
	 3nmLtmCHNQ4qNlbA7CUrZG6/spK9IM7yyoGB+Sdm4KSnm1/rHwPINaO8x/VmKc+OFp
	 f5oq+yfdaSylg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A5138111DB;
	Fri, 18 Sep 2026 21:10:49 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc3+
From: pr-tracker-bot@kernel.org
In-Reply-To: <71da251528b9af2948fb5a4c8bcd045e65b3e42e.camel@HansenPartnership.com>
References: <71da251528b9af2948fb5a4c8bcd045e65b3e42e.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <71da251528b9af2948fb5a4c8bcd045e65b3e42e.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: 3d676e458fe0c566f5a62753dc696b6a862fc412
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 925724c0816e327b6d3a47388cec1203d108ebe7
Message-Id: <178976584794.1148872.10751309962173080523.pr-tracker-bot@kernel.org>
Date: Fri, 18 Sep 2026 21:10:47 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Sep 2026 15:26:23 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/925724c0816e327b6d3a47388cec1203d108ebe7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
