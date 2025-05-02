Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09462376;
	Fri,  2 May 2025 19:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746215835; cv=none; b=PtbhVH4o01YyFTOWZb/PXMVdKc88NYz+b5isRQzEXzPHmhhlTSbE7uRt/7AtHYEU5Fgp9q84Ggwg2EWylh9VQ013hyEcPay3KGuQBfSvEtRjdQX9N9toopiSXtX4uCaaJD4V8153dpwZzAm45VMvrHPbKSneS8HunFzPLU7YhVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746215835; c=relaxed/simple;
	bh=OSJPq71QxGhy9JhTDMDpYvSKPnh4oq30RXiA3QAUmDM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=b3qiqrBntBOtZfXyTC5l6iDuiBFN1SkYG2ZXqg8B1lnAoWtaWHsohOrb0wgUHPM9DRwNtpFK4kdAvDRDkYO0SNGXIrKA6y9jnr8WZvlsK5qhg3zQWN+A86GM+PBbtxWtMVdA7jWSvhWrudLMi80ZqeANEZITe33J9EGzVszxm/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tBdr0kGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tBdr0kGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89725C4CEE4;
	Fri,  2 May 2025 19:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746215834;
	bh=OSJPq71QxGhy9JhTDMDpYvSKPnh4oq30RXiA3QAUmDM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tBdr0kGqdC7zBGIE3GpkQJ1lv4ava7Su1nWPWeMwFI0ZW4j9VcaPTGyYE5d7p6UUj
	 9x7eHz7pnjJXZ3vQei9wtXb6PbWM/AWwZTxAe4NsfiCU/IRyVy+Ur9hfF8SLmIbUFW
	 ZaH0jLR0dtu+cFdd2N7lCZCkPu/NQTemPf9xUE7CrxSZtSQwDUr06i2YfcaTXon+8b
	 Varc1q/olPnz4N2wTtn7fKMV8+VuG9poExMXUsr/IBKVQyN0g3HI0Eb9rPJ8Thkw30
	 tpL90dc0OuPNF8v00orvW0s+sgnqjJ0LZt+ApLS3GrtnEu4SfDhg9Yt5srC+jvBD8T
	 J4XNi7dcczWRw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB145380DBE9;
	Fri,  2 May 2025 19:57:54 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.15-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <ee7c8d8f36e562711091ac1ed02b7d3b5d995eed.camel@HansenPartnership.com>
References: <ee7c8d8f36e562711091ac1ed02b7d3b5d995eed.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <ee7c8d8f36e562711091ac1ed02b7d3b5d995eed.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 0e9693b97a0eee1df7bae33aec207c975fbcbdb8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 00b827f0cffa50abb6773ad4c34f4cd909dae1c8
Message-Id: <174621587353.3715549.13383307227519158526.pr-tracker-bot@kernel.org>
Date: Fri, 02 May 2025 19:57:53 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 02 May 2025 14:11:26 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/00b827f0cffa50abb6773ad4c34f4cd909dae1c8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
