Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA28027F4C9;
	Fri, 16 May 2025 18:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747421789; cv=none; b=iaMTIiCeZOhkaIRCpmZQLwgKxnOq8HiG/NGk4OhaImbRH2QxdGEC8euBfGjleO0Edk+QKPVxNAOIfn8nJcXh0TEdlqz75Ec9bHzEBCKGX3K4xLRYWIIJGQNN9wp5lJ+D9udmpHN1wGb+BvJQE5O580wruAXiqIJQoVO2VivvEQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747421789; c=relaxed/simple;
	bh=6xXesMgic4TwWGYJlcjuwCPaMlInmQbCk1Hsg0FUIn8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Hq8u1o9nQ/9wbQmFp4t13KpT2qy6bVXdRPqoiD7naZdXFAbqfVU73Wr5FupFPFgvTuaiP22iWWE1zskiZCV1XgPB/1DSkMcnStHnhKIh1kmmDzEE17DH0yULmUFEHRnvtXc2vckgVXoSDM5VbrWgpAvBP5L3GV1ED+jHm9BnNtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEjtFYGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEjtFYGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE72C4CEE4;
	Fri, 16 May 2025 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747421789;
	bh=6xXesMgic4TwWGYJlcjuwCPaMlInmQbCk1Hsg0FUIn8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IEjtFYGd6spXC5hAY5SgNbJ9CWHz/XfX+8/L3VSNrL6QyxBahktJQGy+ooj+pPy91
	 iECnYzLn9/RHw9eVHMyRSNf3NN2YYUMWSIiATNQPw6uxgmKYjbCevy4bjENWBqne7F
	 Ou74cgzqhJ9CfwA9yYEWjJxBYEyC2acZTaa534rXRRG2A2NETP8uLdB4zC+9z/pSyW
	 xJm9Yn5kAPrng89JFsQGh8EpDwK3miS5I61WPjrYl1YM8qklCy2ZWboiT1vsBJrvzx
	 H+Dnw+KgeRtBzEb3sroX2tLm5jeMzcNo91oYLxTBvsRfxNp9sjEOJZ4Q43nrmBxT86
	 A0QuDl8qfIP7w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F6E3806659;
	Fri, 16 May 2025 18:57:07 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.15-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <b8b3d1f69f4d54a73137ef0b1f46ff0a8c16b29b.camel@HansenPartnership.com>
References: <b8b3d1f69f4d54a73137ef0b1f46ff0a8c16b29b.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <b8b3d1f69f4d54a73137ef0b1f46ff0a8c16b29b.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: e8007fad5457ea547ca63bb011fdb03213571c7e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 83a896549f9209ffaabf220e3778f14d5ba92e3d
Message-Id: <174742182608.4031545.3124161002075622097.pr-tracker-bot@kernel.org>
Date: Fri, 16 May 2025 18:57:06 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 16 May 2025 11:32:51 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/83a896549f9209ffaabf220e3778f14d5ba92e3d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
