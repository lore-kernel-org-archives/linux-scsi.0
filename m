Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300091DE2DC;
	Wed, 25 Jun 2025 18:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750875797; cv=none; b=ksOaj/WjltqyMJLM5PuWrCWu8zMUWTY8kZtg4c+eJ1IeT8D6c3vWDSUYIX/eFkQe4ME45E03LI+Ryk6yXOSqfdfxZnsV+kBsuPpsmuc7GDuAkS47ySy+HN70tXhwCvjn3pAQGM/yaetEy/E0+E5ld6tLrzuOeIQSGVmDLUSHkjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750875797; c=relaxed/simple;
	bh=CyIac0W5anWNbgsUtFE9uiJruP/cBl6CiCkFm0VOzqU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mgg4aQ5v2nH9HvRfp3wDlsPACUNKIPmKckhRkTVcnbIkYeaLesQPmT2cJxtAPvqz7slE7IhvJLFFF1EA1IuhfTlk3FzI24xotOToMDNCqcoYiAhN5ZXQnZbu14E80CgvbKq56a1oWG5Zcw4fWvjZccLBzOKCNVV0miC6chMF0zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HkVzZjXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HkVzZjXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8533C4CEEA;
	Wed, 25 Jun 2025 18:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750875796;
	bh=CyIac0W5anWNbgsUtFE9uiJruP/cBl6CiCkFm0VOzqU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HkVzZjXrsFWpus+UO5s5y9OuChjHeQGccwuDR1RhfPqZqzm9rzPOcBzAO4AmAK305
	 TbEnzwlrGuoMNDtTYzD1vzFbSynscinlXpftugVwxvkoEDDRuxTOVioHamoQsa91l6
	 cMbIZ0M6252GyJXoW1w0Fe4ZIfzdr7ywFd/rz7dyRYL5BMP5hizFmHynOqSdp4IumH
	 rgfxt/vMIY0guE2nL18hpQmzVCdgCb5ybhQR2kVQU7O9gCBBs+L5xOuJ/A7aEt4zBk
	 uIYgP4PxZxl2JL9Qhjpyj/yYy7XuqZsnMPwODHPj52wNv1uSUChM0fZpMRPgxch53i
	 usNQ19thi3sYw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 711B83A40FCB;
	Wed, 25 Jun 2025 18:23:44 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.16-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <7cb3d174e7b985ea2001de5561c87f23f99aea78.camel@HansenPartnership.com>
References: <7cb3d174e7b985ea2001de5561c87f23f99aea78.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <7cb3d174e7b985ea2001de5561c87f23f99aea78.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 85d6fbc47c3087c5d048e6734926b0c36af34fe9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 92ca6c498a5e6e2083b520b82d318e7e525f3e7c
Message-Id: <175087582313.574995.11938635128330801171.pr-tracker-bot@kernel.org>
Date: Wed, 25 Jun 2025 18:23:43 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 25 Jun 2025 09:06:41 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/92ca6c498a5e6e2083b520b82d318e7e525f3e7c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
