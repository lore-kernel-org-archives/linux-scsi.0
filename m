Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CBA9460;
	Sun,  8 Dec 2024 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733685510; cv=none; b=WjMmDQ4TbqyAnCD55UD94Yj2jIC8WALRzjmpBydHbSKUvgLUGl68ERO87/NLIuTlPCWcGi2HZIChO40m0Xx4DgeFibeV1nvKJmR60pHuKo7ChggKdhXdx26NRKeA/Djw1lelKs1i6PfTSvdW2E9o0I0bjdCVLe0nVfDnbEmlf8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733685510; c=relaxed/simple;
	bh=SUrMFoH5fyYnk0+AR5EFsZky1KMHXHRP8+xtp7wqBf4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ge4fy7ZNYWY1IL2LlN5gq/B/HQGL+w7VR23EQv8iopZdtBdpF0nbZPu8INrKzGtS0Gm/Hkp61MXsorQ0TkDTVqcdjXg1yOpLFtTgvR1MvjBJOdi+yejQ21oK9vfKszvCyu93WlFmvz37NuPbrdaRRW2iS3wPXHhseRizkOKbKlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QMrB3fJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QMrB3fJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CDBC4CED2;
	Sun,  8 Dec 2024 19:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733685510;
	bh=SUrMFoH5fyYnk0+AR5EFsZky1KMHXHRP8+xtp7wqBf4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QMrB3fJQzg6GT3NSjF4a6QYWo98oH76+AucDN0/oMhmJJTi6nU4r1SnI1MlkEnrqM
	 C+7kFci9uxPScUGlyXITWjG/GUyA98SZXHP/D5lPQSeoB7YE6aOsBHnW4sLSb2PV0S
	 IP+h2sorUfYRJ7HOxbkPnPQUxwjrE+6qYr+6DalKVXMR2D28twzEWlyncKljSSwnmF
	 ujR0XtMzaRotptusHjb91L3ULxvEDT2SL/OTN5dScS4YrUQNzBFO9kMooalVCW9rFL
	 pG6rrG8kP/DcOFKMjbioGYH0vDROl5nYBn90Xnn8f4ltQCR8yiaS3rYu43Mnvuolbh
	 F0quYWLXfUo4g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34033380A95D;
	Sun,  8 Dec 2024 19:18:47 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.13-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ebffd769d3f0dfc8877592c728f158190b057c30.camel@HansenPartnership.com>
References: <ebffd769d3f0dfc8877592c728f158190b057c30.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <ebffd769d3f0dfc8877592c728f158190b057c30.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 6918141d815acef056a0d10e966a027d869a922d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c94cd0248ced494e0bcf82b21380e8037c4dd26b
Message-Id: <173368552588.3322083.12521922668363070941.pr-tracker-bot@kernel.org>
Date: Sun, 08 Dec 2024 19:18:45 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 07 Dec 2024 14:01:20 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c94cd0248ced494e0bcf82b21380e8037c4dd26b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
