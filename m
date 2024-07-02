Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB59747F;
	Tue,  2 Jul 2024 06:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719900167; cv=none; b=mI0vk9l9VS/rVT4Fn6rBTz8Y7kK/o4RX2JkSwVmJkN7CBXySZAYiw/Oygv0AriOGM7erd9BuUG0zJu1RLu9CcXnE+Jka6njxzCQ5Urs+zJW4vdCHlahAbGxT54CgUi9yTa90BHy7BnI5IZoDFUOUvkD4H0KLZemjn1nz+NfBV+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719900167; c=relaxed/simple;
	bh=72XmuVkNycJ2t1SqzWWZzLzDmPcmg7GvS5A85XqlRg0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VFVRxZAIboAFZ1cgSJcFCiLofvWQSs7uQ9DX+25tuor2FZoypHllqwAUr/9Aw/p/tiLZGGVoyWyauOqgo/YrmEABgI6DdLYCdxycgjvluKyLmSTAhXTsKSMNWDOKH0KT80D+awxGdJY4TAQlkcoyhpGW8DgylCANJnUqD24sNak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1wXnrxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1wXnrxq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5C66C116B1;
	Tue,  2 Jul 2024 06:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719900166;
	bh=72XmuVkNycJ2t1SqzWWZzLzDmPcmg7GvS5A85XqlRg0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=l1wXnrxq+WWyvuL5a6v03V97njepbw5SvwF4NTAXPxReLnFVXOVTKab7gB1LiBAyL
	 eZPYD9NTldwOQKqf1TKLYtyJoZNunKTUiZlIgLMVdL89ZvfLedZ4s2pJLbsT03tkS6
	 5SnNuhitBIxWDOf9SWKk3V06UUMVATD71ttcX2WFjoMVW7ASrCxVcn+xrmEVjC7+Sb
	 rGeaGmCwTQsxe5y4z+TMbtsvXajq/XdXCt40vw/jmhpmyyLdPD7AeGjB3taykGPfwA
	 9LkaOif1SMCgVBFo1n5fPQoPIU8PtOvfh6gwfekQYk44NsWshcyH5kZm3DZYI1XMxq
	 aRczfp740CJeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD5A8C433A2;
	Tue,  2 Jul 2024 06:02:46 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <912f0f5fe2c02157edb47b1e9c730d1dbc563c55.camel@HansenPartnership.com>
References: <912f0f5fe2c02157edb47b1e9c730d1dbc563c55.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <912f0f5fe2c02157edb47b1e9c730d1dbc563c55.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: ab2068a6fb84751836a84c26ca72b3beb349619d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1dfe225e9af5bd3399a1dbc6a4df6a6041ff9c23
Message-Id: <171990016683.15679.7090758159449378329.pr-tracker-bot@kernel.org>
Date: Tue, 02 Jul 2024 06:02:46 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 01 Jul 2024 22:26:43 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1dfe225e9af5bd3399a1dbc6a4df6a6041ff9c23

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
