Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9DE374E4C;
	Sat, 18 Jul 2026 20:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784406765; cv=none; b=BN5VbPpoQ2vXgULhIHk0XToZ/gkvArHYCKTVx7VYjTZI+qogNpX4sRs4QBdkJTyI0cuiV6uCnfxNs2AyMaMc+KB4Bz1UopIIMBDRdCwl9hfm90638chJVS37yi0udsg5vgsUG7D/P+YC39OJ3mcdBcizoevF+SlNWRu6obteHHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784406765; c=relaxed/simple;
	bh=21JQofHRZwHA5+ooJv1IRQDNessUEAFxsZK4gb+VPFQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=kOt5mA/9eRIr94eCCEyREthSMYdJMlaxNF38sLsJa+wmhs6PKSqs3XVZKZipOK32Qvvon6wwEXSq7tyjXDwj8MTtTjy0dLvEra5ACSTgtC9XYYtXQ9QFi/bMCYXHQvmMDlaP77trNw/bCXM+DrfwnsLTbgRFinpfmuqrWdptd8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Is3J/75e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Is3J/75e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE981F00A3A;
	Sat, 18 Jul 2026 20:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784406764;
	bh=O2lLg6We3T3tnkVbgBDF9QEKsMn0Oq7GRisxsU8DYYE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Is3J/75eZcFIk3k8x1uTxja4zhV0524cGZ7fPs7bnCUJaQKIs3FMOkc/nE0XZiN2t
	 W4ewAZ5zwzl3Yj44uQswpaMpTElE8aLiduNoNFz7UKDr7gjV0ngiKQUfii8CSiksnt
	 XRTuliX6EMWgesoIFADcUfZL1DKukeh5K9HfXlrqJQ5VP4slW0GHgRzFbRUhi0D4D7
	 ylLrJX3Ljm/lgn5UHkZhonBbOOcqa8Syq0BnZ9PSfRuwGrlBz8VqeyIWrU24phRruB
	 TKdEXmnNUWaCvF+MT1Vkr7XaQfrXHEb264sP5wt1OPqpMqKtvq3AtMtZNDe7Qz4DFE
	 MEHn4O1r5Ma/w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5692A3811979;
	Sat, 18 Jul 2026 20:32:17 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.2-rc3+
From: pr-tracker-bot@kernel.org
In-Reply-To: <910bf36b4027bfa4ea7cd0e01a97de2d4f082300.camel@HansenPartnership.com>
References: <910bf36b4027bfa4ea7cd0e01a97de2d4f082300.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <910bf36b4027bfa4ea7cd0e01a97de2d4f082300.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: e166bafc483e927150cb9b5f286c9191ea0df84e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f2ec6312bf711369561bdcb22f8a63c0b118c479
Message-Id: <178440673600.2573970.7366960588417671892.pr-tracker-bot@kernel.org>
Date: Sat, 18 Jul 2026 20:32:16 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 18 Jul 2026 15:26:31 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f2ec6312bf711369561bdcb22f8a63c0b118c479

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
