Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FA4148FF7;
	Fri, 19 Jul 2024 18:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721412554; cv=none; b=oFtCrLeGxkcQWtUdnM/CuFgCKBangylXq/dyfXBTbrRc0NtbXdVkx9sh8Xyw5kNKD0eWzZyLXYtR46t0GMzCLtFIdivHES3JjgMsyG+ue+dLP/AISLbgkcLk84pNXSTYzU4IoTGxQN6Yw+gxsstjfDBBH9n3uH1Y6VLksQdt5mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721412554; c=relaxed/simple;
	bh=HfV8leutjs7C2tb/xVldLSub0FkfTg6WR9psEpNXW9Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cJEXmnSpcXbK+Y2h4fd8Nlq3rPvMWhw/Mb/6KWzuZPyM6THtGUqqqap1xSIKrXqKEQM3vCm6v064F8amEOOfQGlvRkzu2oeZrPOqcWlrWi2HnjKqn/+xnhFtXO4DYZtRQEMV/flh/A0zCOs8Y1fGMtM49PueWf+GAzdlOKphtFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjJNpu51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjJNpu51"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB731C32782;
	Fri, 19 Jul 2024 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721412553;
	bh=HfV8leutjs7C2tb/xVldLSub0FkfTg6WR9psEpNXW9Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VjJNpu51x8tbKYKHCw9OXUHrNgiZd4eXk1zXetymbpLTHw3d4hQjdD87fXWJCY+b8
	 FJ4jbRGshUIZ+85xFR8vpb0hN3LbZCLiN2YCtbp4KOZmD04uZV2Me5gLXATyiEeGpk
	 JhGK838vIqJGBVvAVmG4JVe9ACx3ToLfZh2YyVoZWDo9LiwTJGjZ10Rk/2ztISPwMa
	 vuW9fxLfUQSCu8r8mFOm4csEqixpjgcQj+j+mOC84IgKD+50JwtHK05ct2I/qJvL0V
	 n5ihENa2xIGHuN9WHCjXVqpk8mXnRDL4YZFaAF5WdaHTj03UHdLTwRlKXdHgie6mRb
	 x2Nqe8KlMn8tw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2A62C43335;
	Fri, 19 Jul 2024 18:09:13 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.10+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <553d4e0924cc47e41ca799c19c666761c5de6023.camel@HansenPartnership.com>
References: <553d4e0924cc47e41ca799c19c666761c5de6023.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <553d4e0924cc47e41ca799c19c666761c5de6023.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 23cef42d17413d099f44ea42b622fbf23b04646f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4305ca0087dd99c3c3e0e2ac8a228b7e53a21c78
Message-Id: <172141255385.2862.12765122382132071952.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jul 2024 18:09:13 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Jul 2024 17:00:47 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4305ca0087dd99c3c3e0e2ac8a228b7e53a21c78

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
