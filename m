Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C4F524F;
	Fri,  5 Sep 2025 22:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757111651; cv=none; b=jwclaVsyrFBKmCEFZCQCh7cmW6RolBWPOuSCQ0h/4yAjcr9HxaDJXwlg3mSNTLLk/jXj4LaPFx3MWfR3e0yFsRNRRVZgZV2/B/ykfLRkXnD6y4Z9sM5IA+zmZpe1PjinS/zTS87tVFNy9Py0Q0Ubl+ShiAO5aX8u0J4Nw5nxMX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757111651; c=relaxed/simple;
	bh=vCpW1InwO8WiFbbZ8I8bMMczuH0/+ZOb0YGtmmi6NZM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HdeNoI4MnuZ59I38DTHCgtnd5iT6voaZUjzqR146b4gqHFzq2JRyHWwXABXVDAt0xibWFAVebemL5EsMj0MXvUUKWNp9lafVEcK36zLiRzFk1qesEUYPWLxpRRf9APGj+m5U+ZGvUj3I2U6TmLEMo0lsWota3Mh5ZV6flOHgPII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=psKpq4bC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="psKpq4bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879DEC4CEF1;
	Fri,  5 Sep 2025 22:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757111651;
	bh=vCpW1InwO8WiFbbZ8I8bMMczuH0/+ZOb0YGtmmi6NZM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=psKpq4bCesSM6+o4fAz3GG/8XC3Ku5Tz5CX069lX0dguIqmxCyhd3N1SxywjxZ7Hg
	 Q30mpe5Kk2+krM+NnijOrrVCdWXb3N54o0O+15NCnYtCB6SkHB1BIXYr598oTO1XWK
	 Vh3KGeHAuehp6jrg56l9esl0AEH/IMI7l6bmXsE4eRP89Fv5C2sopuU9AKcblEb+Mw
	 tAZC0/yHR9eiT8oJJIeWsUHvsYRgI9OganRoefk9yKdCX+USEtkRokpvx6GKwwAB1p
	 Fn2B7H6+B6lp778f3fur+pHxsfMZahlMoAaApHmw3IFLf47JNLP+umm0lrRJu7yDkc
	 XHbmQnOPo2mpA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33EE2383BF69;
	Fri,  5 Sep 2025 22:34:17 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.17-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <8bc12ae71082b754ffb51490b26e310077d0162d.camel@HansenPartnership.com>
References: <8bc12ae71082b754ffb51490b26e310077d0162d.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <8bc12ae71082b754ffb51490b26e310077d0162d.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 708e2371f77a9d3f2f1d54d1ec835d71b9d0dafe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3e45016f75e3efc2366e9060241d38e3fd03a8f
Message-Id: <175711165571.2706660.9891093180578940676.pr-tracker-bot@kernel.org>
Date: Fri, 05 Sep 2025 22:34:15 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 05 Sep 2025 16:03:06 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3e45016f75e3efc2366e9060241d38e3fd03a8f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
