Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711091362;
	Sat,  7 Jun 2025 05:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749273086; cv=none; b=gdTURVKihVvJ1kuPFvnP52g/5qduIeuW514Kb/nZe7sOCuQF9QJibcr7vcpdxS3jcVC0qKx2962HPjU9nr80wsf0VMOTT6rvMK5RGcDqA1b9JV2m4gLwgQ9JYY3mJ2SPlepu5JI0GaMJm3hDDowc7vEHZwG2BISOrZwsJmfS3gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749273086; c=relaxed/simple;
	bh=oagHtqgG00v7CpfKSWHen8+OHswPm3pmxNhewj1W4xI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ID9pl1eg9UIlZmFTMDZ1vYkZ3c/Np3G36s3oqE9/MndnrgBXPQX7TcoCz8RM9AxgFZnbI7EOSrMCHaxBzHTMkNBRUQQPtxkNR12I5T9IEz0vPwfklycbO5kRiBPboHcQIAgQXbKdW0SIktDkWszQikgT4MV9FFf1/XTy99oyZYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZD8TE94B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZD8TE94B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0751DC4CEE4;
	Sat,  7 Jun 2025 05:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749273086;
	bh=oagHtqgG00v7CpfKSWHen8+OHswPm3pmxNhewj1W4xI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZD8TE94BpPJg2fg0iIcNZjm0upfuNTma0pm+tc7bhxQ+FcuMxWpgt7efzbRyFyq4D
	 8pGZC4fBIsSJ4hs+isMoUbpLuj2grlBRPEGLOfrX3Wf5gp216r8wc85CCySFH1Eq5d
	 AT2SJv4YTDl5+pQFcdRJ/vjWl44NuNBMMHbwxL5M9pDkdBSJjEIuNWdN8x/z6Bn/wg
	 BoYw9wvfoeFssWlIHC6JwXO6YXJ46F7vmchX0fmHy5d1bi+Z3RamdWsZMUtYOfNVh3
	 vrkP1ejWT1W7idYP4kXiwE45CF4ibpB3ehqeBCpyw/yTgp5cayiGhd7jgiFuF0I2gm
	 EcX+oAt1NjZCA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADFE33806649;
	Sat,  7 Jun 2025 05:11:58 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for the 6.15+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <b71ba161ecc1e31fde20291f9734eeb56d746279.camel@HansenPartnership.com>
References: <b71ba161ecc1e31fde20291f9734eeb56d746279.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <b71ba161ecc1e31fde20291f9734eeb56d746279.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 7831003165d37ecb7b33843fcee05cada0359a82
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 949ea6f3f4c016852406bfdd3374e2ba5d4c30a9
Message-Id: <174927311737.4100571.16327985833015321773.pr-tracker-bot@kernel.org>
Date: Sat, 07 Jun 2025 05:11:57 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 06 Jun 2025 17:04:10 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/949ea6f3f4c016852406bfdd3374e2ba5d4c30a9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
