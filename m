Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6886F241100;
	Sat,  8 Feb 2025 21:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739051994; cv=none; b=NTWYrJvmDV1vSp61aCuPkljCVOzOAhkO9lReRT+u0mtuEQRxBrV54/sLs6fLpqk08cWr4EEvKbJqpLDfyeRFjXddLfMm9RRyrH1QOvBj0whQO2l3dlYUHXR4bx0DuVhYqwtZQ8QONG9FP9Qo5h3uK3Ah1mFJsDpjUhMvuuREWSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739051994; c=relaxed/simple;
	bh=RQCmYl4f87dO+OY/HCvK68sf4okDPgKkRLiTNMmiyZc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GOIWJISm8bFymZn/XYlVgke0t2eirI2bHJv3g5T2UFngaXvecFQiNVicoe4QzyWpLHxOtj9nvNGojD3j2VddTzPtdoEmV7kV+Wk+rCoCPu6uQucZE5wGijuQ6oh9fn6Pm6GOav/PqcrQko0nwbuSpz6lCoi5JxBN+8g323cblZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oukq83vz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oukq83vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46635C4CED6;
	Sat,  8 Feb 2025 21:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739051994;
	bh=RQCmYl4f87dO+OY/HCvK68sf4okDPgKkRLiTNMmiyZc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Oukq83vzCIvXjJO5y3C4cRwuw26kTnEt9ypes79IAUYLzWMF0oPZKS080pkqtAVyJ
	 7xhFjS7jKptyj9fZRCtlgQjZQlhERfTPbxWn8ilyoA5tTurvS89Si4cOTv8GqGGPKK
	 s9mq/2oDfErhj+XB/2MmYJikFO1LM2XZK+pacSx/98HBjePsKyGF2pbBQxktnXHMPx
	 h4W8ZTgTgfLh4uWJf1MrboCzNRZGuSGeSJzcSZUdnXnpHZ0d9/4QTgWRjiCjdcXW76
	 +fFUfUSDyVQlhrG6ztqQ/GVznZ5is+a51AZ6/ns/6mGouGwTBu+rEg4mS3RjYZC+f8
	 kzngRGHyCXpWA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE002380AAF5;
	Sat,  8 Feb 2025 22:00:23 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.14-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <fa30513f6dbeb074de75d33b2270dcc60c1f8faa.camel@HansenPartnership.com>
References: <fa30513f6dbeb074de75d33b2270dcc60c1f8faa.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <fa30513f6dbeb074de75d33b2270dcc60c1f8faa.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 5233e3235dec3065ccc632729675575dbe3c6b8a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 493f3f38da21cf61b25254f7a3dc817179b497c8
Message-Id: <173905202240.2669229.3335363051326487603.pr-tracker-bot@kernel.org>
Date: Sat, 08 Feb 2025 22:00:22 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 08 Feb 2025 14:23:51 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/493f3f38da21cf61b25254f7a3dc817179b497c8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
