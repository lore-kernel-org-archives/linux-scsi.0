Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B6335B125;
	Wed, 14 Jan 2026 21:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768424982; cv=none; b=tevMn5O4/mi5VFfTGYrf5YDHo81EjbIn24kpHyAf/+ARSPmWk1xvINTGfqKumcXlCx8QvgHHrH8fzsEbPuuJ1miOkfzlNzkSscGukOrkAhfN6oWq3fqcsuCryIrljvNIrtmIag7uYZFJeQRX2xUvtg4NPfqbN+fof9UU5o/A0I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768424982; c=relaxed/simple;
	bh=ixAsdOPyWPX9Uyiy8uZCVCc/kgvs+zEazglccS06THA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=kBjbTQQxklXEYgWmEQ4wFB0iHR8KvekQlXvaw3OIYzBkYrhyddFi/BEjpvgG7WcY8EU5zeMj1ILOy7ozEYL84q1MZJOZrpzhacJDVHOkJHgmyJh+zZuXduqx90PzWcWRBdJqTOAvYgCkogtF8Thjc6HoIlN6anwVyPAP2fWKTLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mChNYX6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mChNYX6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D5BC4CEF7;
	Wed, 14 Jan 2026 21:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768424982;
	bh=ixAsdOPyWPX9Uyiy8uZCVCc/kgvs+zEazglccS06THA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mChNYX6OBOXG1YM/M9qcAe4fffmtWHRMbV2t+9vHvXjXoMWKW1RqxajuOSM3B1NYp
	 +gKiolkVgGSUWtiehDKNb3igb+pEfLHNXIoyJp0pzC3AQPMxLeVB43+Uuyyg0SPK0c
	 pem8yHvEOGnJL8lxsETwjkRefm+4eHT7e2xTUlxG/iP+4eG6vhhMKt+UgFWVHUgN2O
	 DhMQBljggFDVfXU7X81SvkdFhclwMtFToWnBThVR8uJbwHXovzu8a5JjrNi3d4tnBs
	 ytHn+yuNEihcK1D0lIXvY8WWhZR8aG1E0tNX40Uq7LMIRLpmBgNPCEHTA9+29xXFit
	 c3VBZF52mX3SA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3BC463809A31;
	Wed, 14 Jan 2026 21:06:16 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.19-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <0843ef58d4bfcd4caa5e99261aeb08de40db2779.camel@HansenPartnership.com>
References: <0843ef58d4bfcd4caa5e99261aeb08de40db2779.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <0843ef58d4bfcd4caa5e99261aeb08de40db2779.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 309a29b5965a0b2f36b3e245213eb43300a89ac2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 944aacb68baf7624ab8d277d0ebf07f025ca137c
Message-Id: <176842477478.3324996.12691486871638688702.pr-tracker-bot@kernel.org>
Date: Wed, 14 Jan 2026 21:06:14 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 14 Jan 2026 14:22:21 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/944aacb68baf7624ab8d277d0ebf07f025ca137c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
