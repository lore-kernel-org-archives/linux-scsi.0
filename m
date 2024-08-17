Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EFC84FAD;
	Sat, 17 Aug 2024 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723914746; cv=none; b=Uk+FQBDbXO1bddp+rzbPCWQH6XRv4rRt2HGWv/+qCUlYOLldGozDQKoDqIzKQ8ZkMN4s3B4bOoAZJUYCHrSuZaX7OsP/PjNAuiMzIAwzao+MAoZ251CBm9oJQmfX9OKCmDSsYsgn6MRbLpN58lHvs86akHuEu54sTf+zQjJii1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723914746; c=relaxed/simple;
	bh=s/nA8DLjFoEtL/5FRIs14j65v36acKpHyXLxZC56a/w=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Avc8TNkR/1jO3AFbI4HQFNwl7I8QXQSn6UnKPUFsTCYGAHpoLdu/Xw7zFbt2SM8iabthZdFAilIGAMkkELaBIwOZU+1x5LocTlZES1aui9H597/dQ4lPZAvj/8WD+y678jiH/1Tr7dOcGQTm4zAOTNmtKUPWoaglHdpxonUhqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCsOBz3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCsOBz3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12A3C116B1;
	Sat, 17 Aug 2024 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723914745;
	bh=s/nA8DLjFoEtL/5FRIs14j65v36acKpHyXLxZC56a/w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZCsOBz3kXliqm+HRazvc8zwcjsT7dDM8bSB3qmXVX8jIv3v1fmuoTAT8SBiHZIBCu
	 VHOMftShhlXVXqc7erhYiI8zBSP4xiEmR38y7yq9fQwWJ14QVZpnKTB2Klju/pPdUK
	 B7XyorAyExJJ9WMRS4NYRalANExdQdm02Mm5KO13Rzx1hH8suk74uA8h3Uz5YxSd32
	 su6iP2sjVppjcRykQTmQ1lRe//7+HLeUaKUHrEdF/hsmHYq6VBUY0GhwGbUowFSMbp
	 WwTa+Qih2wMUSow1jpL1tsvEm9s7ekLgNZR55JbkLiNbErGpUtA7CRWlhvrPbwA5RV
	 mpcueReAdVd+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70D9638231F8;
	Sat, 17 Aug 2024 17:12:26 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.11-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <47228494aa07492b9c00d463789049a0a492d033.camel@HansenPartnership.com>
References: <47228494aa07492b9c00d463789049a0a492d033.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <47228494aa07492b9c00d463789049a0a492d033.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 8c6b808c8c2a9de21503944bd6308979410fd812
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: df6cbc62cc9b3bcf593d13400dd58cd339a0f56d
Message-Id: <172391474509.3799179.10304402945988084680.pr-tracker-bot@kernel.org>
Date: Sat, 17 Aug 2024 17:12:25 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 17 Aug 2024 08:27:39 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/df6cbc62cc9b3bcf593d13400dd58cd339a0f56d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
