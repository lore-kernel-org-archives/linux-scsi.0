Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ABA25392C;
	Thu, 17 Apr 2025 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744909585; cv=none; b=NnQY25+3H5V7pbk56jbdv4/xHVstc13sML4SgideQ7Mcdab/q+V0QAnIKCP3BLEFk6jiBAuayjboT5v+cOJPeBP46Utn0Ndm4pflf1wU1EXx78z3Rt6hcZkQM5j+Tc4FQCQi8C7Ux5Z75nBkcprpOL+RG810gjLL0SbFdXSXk5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744909585; c=relaxed/simple;
	bh=Y1VPpydycF9Hzn8kUuhw0Q7gLz3yv5GIuX6M4zNHYVY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CVx5/+1VYZkytf5mQ5jFPDePY2IMruYQ8hs3BDV4yw1Z2xgzV+8R/MmlxeY9gMj78pFyxy+maEooBuGXdBMXB44oZqZNfhsAHOZ1yWqUJFqfx7ivGSbF/6YsAPgcdqh1UP5qTdMuCVaBdXjnYvt7kdvOo1rNY4TmBHcWCjoGZc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDfQ15OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDfQ15OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1D8C4CEE4;
	Thu, 17 Apr 2025 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744909584;
	bh=Y1VPpydycF9Hzn8kUuhw0Q7gLz3yv5GIuX6M4zNHYVY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lDfQ15OTF+7pzb8swJtKorhfEk7eXWyZ8Mo2QNLKTecMlL7AmvB2WhPYSOQBA5HJY
	 YOX9cImyMN294VLqmoajEIrDLQSlYFndEoiaREaxoG5YqCEukq9wq1U/roHgVym1u+
	 ncCepSaF0cNvTPM7K6C8lKw+BhXtuMOZb3GmS44bJFhScXUDZ7IA5GT6/0In7NEY9S
	 Kqxd1MMDwdf+22gjnhvVb0riU1Qmky1ym5QG5iX/nhjfeaBsJKoDV0ophZkJvkDgtb
	 dVcJfE6FBd7IsSAG8EDIu+PkpiMQSw5Ae5UJj5/ItBFGZVTrxbW3AIYaB9h6jlZegc
	 qy+HPQmppGGXQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C2C380664C;
	Thu, 17 Apr 2025 17:07:04 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.15-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <e4bb2944a14703eb4fe88374b9bd60f4fb6997d4.camel@HansenPartnership.com>
References: <e4bb2944a14703eb4fe88374b9bd60f4fb6997d4.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <e4bb2944a14703eb4fe88374b9bd60f4fb6997d4.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: a1af6f1a1433348c93f0b3a7a64f20a0a898ef78
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7adf8b1afc14832de099f9e178f08f91dc0dd6d0
Message-Id: <174490962281.4147514.4302270976906121069.pr-tracker-bot@kernel.org>
Date: Thu, 17 Apr 2025 17:07:02 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 17 Apr 2025 10:40:46 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7adf8b1afc14832de099f9e178f08f91dc0dd6d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
