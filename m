Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAAC364931;
	Tue, 21 Apr 2026 16:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776788747; cv=none; b=ByACw5OTnJc+rx5CGu6zJYjRPGc39PQ4QfVkrECN6IvYgLJAW578mzPDJi0SpF6c4uQuFEWJPDE+NP7AOIAXajzJs+qZNO6wL/KkSliYChrHCXpwSGkLAF36ZoxWIRZ06DcnqFag7YtnC2bpcTv7GmjbBySDaBNCcbxuJbN+Erc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776788747; c=relaxed/simple;
	bh=4ZY0/xDh8KLy0tRilZiUzu6c6zCfdfaJqfl5fsGl+Sg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BwqOmgFYYsYSRL1MPaQJuWS3rkCW7miKluEIFABlvkfrERv0n3q9EelY0X9s9T+AWpiWemIFGuqC78QBxjNfTY1F+JcyWTn3yjMHRNTc6bcRTW3fTg6Ny6vxZm/cwtSYRGnNfAOTQYHWcjr1fig9g1DMj+42r/2uYrQxEq1qBV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sb+OHF/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sb+OHF/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C67C2BCB0;
	Tue, 21 Apr 2026 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776788747;
	bh=4ZY0/xDh8KLy0tRilZiUzu6c6zCfdfaJqfl5fsGl+Sg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sb+OHF/Z0P6AHqSZjCc+VeaJkK1/Cua9Dn9HrejiwgCOUW7/mkMWNMMUyErdqgt/M
	 oidFgAySt8CrB3T6duQEJuAQmDPIefiOSyVoa0EpGEyzcdnpoA9NoO2YR9Ni3oBCLq
	 AE3uv6oUr5C99abtGN74MLgBJnEE9C2uCvRrtmtswJJqj4/APf63TAk/XSWb5PVu/d
	 Zw7UYV6iSvTXnYJRMw986rfsHZmCzXN7kT7n/I/98TmcZX+0tdmvpS32Kx7GszB25n
	 lMsGgySXeGxzb2X9RtEHOdtSGUSNkf8fmSWbJJad1dploI1Ea9KvD3kJhC9Ap7mua3
	 VXBapoo2zQ6gA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FE2F39301AE;
	Tue, 21 Apr 2026 16:25:12 +0000 (UTC)
Subject: Re: [GIT PULL v2] SCSI updates for the 7.0+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260421151345.9937-1-James.Bottomley@HansenPartnership.com>
References: <20260421151345.9937-1-James.Bottomley@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260421151345.9937-1-James.Bottomley@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 070ec6f691411f27e7a743841bdfb0bf604fbce2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a85d6ff99411eb21536a750ad02205e8a97894c6
Message-Id: <177678871070.2896080.1414872484261315034.pr-tracker-bot@kernel.org>
Date: Tue, 21 Apr 2026 16:25:10 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 21 Apr 2026 11:13:43 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a85d6ff99411eb21536a750ad02205e8a97894c6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
