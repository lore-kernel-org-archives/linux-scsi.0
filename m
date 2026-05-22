Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA033932C0;
	Fri, 22 May 2026 23:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779493451; cv=none; b=BeM2jzsvuu2JHSnf10DOP6VN/ejZUJ4XOjPLHuZ5tVaAOoZFPe9EobEQCxGnQC5c/HPDlC6ONAaS4oez9mYoVKZxfRbheb03dabEbUPE4dtOBuJvBsUMTDqnoylemKgCm13RXvhQO9MR5KGTAZjWPdALrGGtbfbdUiSZyiI/yFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779493451; c=relaxed/simple;
	bh=vGEAxHuHVUHw9+BA2zeuuU6z71HUCVvphtkh9Uha2cY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pVQD+oaUlfatfZyAbqdIsibsV48e1LedVM0H/7XB+kGrDipWLv2h82lHY8/1R8SqvQ1J7fEwMgI/QFlMCeRgAVHlBiOXFSXSeyE/jL80CckAXvlSqQIi48QFmRVDpaqk2S2jpN1G3uCSfvj3lPvHqK92bAgU4m/zC941ifee8jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCo13I90; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCo13I90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8EC1F000E9;
	Fri, 22 May 2026 23:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779493450;
	bh=glExyv9euYCtPSk3GAT9SPoN9H7/h5IQ5cgGoBRWrQg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=hCo13I90V4duy9XLzxOGORwYwSZhc6t9t2dD8NG40D7rKYSTiWIgUh/g3EJJiA6T3
	 NbND5cP3op5qdBI5MgZTqq4w/n3rnW0BY5ELRb8IBs91hDjvT2lkChXJ/QUDoa/e0S
	 EgfAEbChTNK/PW0NsPMznDk5Fbz8OcdidDgx5LHnHpwuB7rve9cIrAmpIz4rcYCx7h
	 7tgqOqGIo/ZnK5GSZ1QJdkXsqKP0bvmfnWM5oggCvdGZhl9/xvSLtPCsivaKa76ACf
	 YdLhzmnPtIOZUtDQ1cKPxbMDlb9Un/9tFolq0BGvprr87PMQi/UV3h9xjedUyU2A2p
	 rjE2LxHVsWktA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19802393100F;
	Fri, 22 May 2026 23:44:20 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.1-rc4+
From: pr-tracker-bot@kernel.org
In-Reply-To: <5deb7db224144ca4019321d6a9b59d60b5b0fca7.camel@HansenPartnership.com>
References: <5deb7db224144ca4019321d6a9b59d60b5b0fca7.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <5deb7db224144ca4019321d6a9b59d60b5b0fca7.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git tags/scsi-fixes
X-PR-Tracked-Commit-Id: b71cb088b2e3427924a470fc43e7aedb8a40d2e3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0e6582a51610ee1efb1a3acae96d2960490b6f4b
Message-Id: <177949345870.1408813.11429724143573065912.pr-tracker-bot@kernel.org>
Date: Fri, 22 May 2026 23:44:18 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 22 May 2026 12:56:14 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0e6582a51610ee1efb1a3acae96d2960490b6f4b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
