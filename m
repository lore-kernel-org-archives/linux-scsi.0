Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6A19FA96;
	Fri, 14 Jun 2024 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391141; cv=none; b=goRQyDzQZiu/CnmrYa9IiZ2xQABb3ZuFmBYmfqEx6yfx5nVmnEgqrkAdHcV9HlWasX9S+EBb95sw6//UwKAesX+o0VrEpj8gZK7cPWfn0JnxKvmnbHF0gM0tBlt6kCXNuHSy2143Wog+JFIXG/8C06D4xPzKvO3ICoDerdnC9DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391141; c=relaxed/simple;
	bh=MaGRpDWeExLB1Y2jcL8xfXNaIrHxQ/D79xtzSlR7eOU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VFzwx22mHdHVhs11cf4Hp52q+dFAknZEp4HZ9XcYNaG//tkx3NMuwwZN4AjjulMg6j2ZQqFF1D/giFqyTsc3PEcuzxsvf+Zge3eymkZV1dQAQ8RHr0NoXhruUe6e14pK/du6AqlyK6yokD/xxxG1FD3qh91D6JRMPBdEvq5pfqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t7Y6GJCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t7Y6GJCd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A708EC4AF1A;
	Fri, 14 Jun 2024 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718391140;
	bh=MaGRpDWeExLB1Y2jcL8xfXNaIrHxQ/D79xtzSlR7eOU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=t7Y6GJCd9tLpA/64UZt+Gpjd0uns6jrrOGDT8hpDiJaiY0bMs8GqGNRn4wdwLgBXI
	 7Il7k0AGV95KLH2Bv56/3q3HdXwGca5jkxVWHptOk/KWodBNToNcZsyFpKAMYzspCj
	 XLX+oik70AVBt/i3+GcpxZwW6CMCT9Soe0Z5aHyWNVBJqN9Md6lB/LPjItq40lFrsy
	 XbIAonu1tsCfqnM/PqEmiQnUwfLnj6sqW9NneJww1lVGUF+UtDOIrr5Evd5avUYAWs
	 03tGG6TsbK4DVolRfL/LMUhYW4agZNqDVtT660aQEkjDRge3bFJXfyEnul39r/zl8B
	 /Alemhj5JR/BA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 942FCC4332D;
	Fri, 14 Jun 2024 18:52:20 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <a04853cd4be2533dc0fb724a788fb3cce0f535ba.camel@HansenPartnership.com>
References: <a04853cd4be2533dc0fb724a788fb3cce0f535ba.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <a04853cd4be2533dc0fb724a788fb3cce0f535ba.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 90e6f08915ec6efe46570420412a65050ec826b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b320c8601d787b8b8df07335d9cd713d6679e2c
Message-Id: <171839114060.28657.3322795197393482971.pr-tracker-bot@kernel.org>
Date: Fri, 14 Jun 2024 18:52:20 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Jun 2024 08:25:42 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b320c8601d787b8b8df07335d9cd713d6679e2c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
