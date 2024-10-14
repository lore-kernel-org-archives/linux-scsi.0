Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61974231C98;
	Mon, 14 Oct 2024 02:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728873556; cv=none; b=AOlGwQFmp8NEHRd2QjfKcp4Ltt/Kj21P2aE3VrlBwAi9GpoOa4Clrynrgdt4mZgc/fsSPxiahnaXVPXO1uSl/Yad7O6kFPm+RSHVmPJIHloazGa23DDGTdtDysEZZpXSEep0wrxKSF3KvE5XwS8hCmQbcGZcGe4Oh7Zinvnzgw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728873556; c=relaxed/simple;
	bh=2zgIKtYHy3eWfWs6gdLR4RArVjmZ1NbnYcTl0diSuLc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CLwGZXg9EXs0yfXKlrkSb/Gy1SYP7JV9yFZaP7vIUxBu31kD8V5QZLomWCSCt8dq50kzu3m8keK/z4JdHLzjpRj3MR+J1kF86OUgs9W212d3LWwf6oUJ4BDokW0hIZ7MnsJ9qMV66RIrAHAuM314MGpJvpPzZbHkYlC0JgxKYHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcaiqGin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcaiqGin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E59C4CEC5;
	Mon, 14 Oct 2024 02:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728873556;
	bh=2zgIKtYHy3eWfWs6gdLR4RArVjmZ1NbnYcTl0diSuLc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lcaiqGin5iSbqVkilPIbvt7NCKTW4lt+AxL+9d3CjTxpUEZ0ea8k1+Ygw7aK+WFXq
	 H16jjJh+vty+229l4jta3Fza+xjoZZc9Zj/qo4Dq8T2LdZP6Z03RwgL77D5arRGw2u
	 gPRCwnC7Yip1fcgvpaVB9mnF4iXoSqnIuk5QVUv8J6xrOsdE732OC4Y1wTyDPPPsSx
	 ra85RzeL5dCK9op3yJ+2SfRW2grJnYOwqyj5b3gmtFlhQCzeDgCK4Ktlp+unJS4/df
	 W3z7Urpo4zmLBy34dBOh3LQDgXCB70H66MbFpv7YrfsMOny/FHS7qC+cKKDk3ryazO
	 50BaEr2hRsYsg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71AF638363CB;
	Mon, 14 Oct 2024 02:39:22 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.12-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <edf88708320d05c4b2f654a06a7fdbba9f9a868c.camel@HansenPartnership.com>
References: <edf88708320d05c4b2f654a06a7fdbba9f9a868c.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <edf88708320d05c4b2f654a06a7fdbba9f9a868c.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: d539a871ae47a1f27a609a62e06093fa69d7ce99
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7234e2ea0edd00bfb6bb2159e55878c19885ce68
Message-Id: <172887356099.3903120.8940751306665937010.pr-tracker-bot@kernel.org>
Date: Mon, 14 Oct 2024 02:39:20 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 11 Oct 2024 23:27:01 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7234e2ea0edd00bfb6bb2159e55878c19885ce68

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
