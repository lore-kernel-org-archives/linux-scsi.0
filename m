Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B735A1BD9E2;
	Wed, 30 Oct 2024 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730313766; cv=none; b=Q0dqwvbBHSXarPXmMSZWqtOPYMhdRbGSjXF+S4imYX5KfYkiF7HFpPyHJHSVsiU/fIK6PKFCUXJ8QUxh6seqIWGHdjQh4wW4VMDSp9tMo012jD8X9wt6mLAQZW/OXjofTieNvtqSO+qFpeEn7QD3TZEJYlkURivvCdbcJZ+ll3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730313766; c=relaxed/simple;
	bh=bGVcw/sfpCroEAgkcGYhFNMz2qy28pH3vOQD5j5qYyc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BPsPk6LTblQxoajLFNzTprk+4oporXlcvl9QP0SK7bcFap/jk0UkxgqHQSNYAz/I3isTu4aCJXfjwaaB+AAVgSu4F/UJV8X0uUu/rL6vtGrzDXfXTn0T7RrueVcBaxOOn98by/5TMs5y6uhmXDGZDXMrEhOpKSvR9XIHv2r7Ums=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyE9eonW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyE9eonW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D308C4CECE;
	Wed, 30 Oct 2024 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730313766;
	bh=bGVcw/sfpCroEAgkcGYhFNMz2qy28pH3vOQD5j5qYyc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WyE9eonWKCWo1OJ44wPQ2a4wLx7BWTT4XDhaG0GSBeYrKjMf3KkL7d4Ql+jV1SGO9
	 YCsfEjpcfsjU4nSCNuZGxTGF0okmYGFKx7J4QrvWWd9g2jFDaaCyDUdvPqnrEartUn
	 HSw3GrWvoHHp/puwjpet2uY+wM6op+WwMMu6ayZSDrckNTcGB9T9isIY+9EmaDCiOR
	 oEVJsR3x20iZ8+8PHnjmu2x6g3Jk7S7a0JyWAdGCuLc/KCOFPjT9OwB0Z1aEHRxP4d
	 OL8Rxj0lBxSXfvVUj41uE4QXAMBHg9dcbbSnHBAb44Bt1Pg69HWZlIsTi/R7I9shSC
	 mJWbuaPVEhUKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34F90380AC22;
	Wed, 30 Oct 2024 18:42:55 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.12-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <c82f3c57c5febcefdc95cf4a0b8eff0cdf4689a1.camel@HansenPartnership.com>
References: <c82f3c57c5febcefdc95cf4a0b8eff0cdf4689a1.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <c82f3c57c5febcefdc95cf4a0b8eff0cdf4689a1.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: cb7e509c4e0197f63717fee54fb41c4990ba8d3a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4236f913808cebef1b9e078726a4e5d56064f7ad
Message-Id: <173031377391.1432070.7105234657928897279.pr-tracker-bot@kernel.org>
Date: Wed, 30 Oct 2024 18:42:53 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 30 Oct 2024 19:57:59 +0900:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4236f913808cebef1b9e078726a4e5d56064f7ad

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
