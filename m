Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E63215198;
	Sat,  4 Oct 2025 02:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759545711; cv=none; b=Oa+tCOgJ+FdGHiUYfTQgClQMj2HiGtFFZF01Dm4I0nBpE3tboWyZwZebvbXLchUfXJUQ1rfBwPPgJoiZBgs2NoMlw0Of0uYqdYOIBRy+Y6+RkHx8gwXCz8TICY7hkUWuiwofBa2mTSqn2Gj6QqamgNqeEhLAQNL3jlu0RbZ6Ty0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759545711; c=relaxed/simple;
	bh=rW4DbMgJsL1c45MmwLMPHqr2Js6onuo3rdfr9WW/XkM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FZCnpympaRZTVBosSoj8Q4kc1EGnrqLYzQnrUbtWtOllzJ9S245Ow+EHTeqKmaiwr2RBSN/6wlbQ931zh4WqBD56X5ETux1/LO6iGJdJ4eJP4fWqmx+BMA+f2uFox1s2w06I5JXEG7Ngxu4padwA/bpT96S0+7i0CQQw3LIk/jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXDbO5ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXDbO5ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A1BC4CEF5;
	Sat,  4 Oct 2025 02:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759545711;
	bh=rW4DbMgJsL1c45MmwLMPHqr2Js6onuo3rdfr9WW/XkM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PXDbO5psg+P3fDmeFk+9X6CC31GAuOpSdag0gdDmd1rV78ynEqkbu/NkRNreyLoVY
	 /dhH63Dr/EBk+zQQ+rJjFdRL9BGUzeV8JDLpxf8lHq1S2fvvpD7HniN0B1hEHurJAw
	 gPgGm7SC3AxQ9JBJVOy1VuHSgbzB0ZReCQxpoDQMJI5NzTnXDV0Nc79m9dmVPpVxtA
	 fqnroTUxrvFwcbIlp+fhnhAXA5KuRTppzN8oOm6oAcRhu54Y4kWkjmli257bbK/Kbc
	 NPQvTEOLfAL56DejHSkm1DCukk4+FjOHyWwNlwDY8HAbsQfut7OOt/GSexOo1mD8V0
	 Jh8D1xxzGgAlw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE3B39D0C1A;
	Sat,  4 Oct 2025 02:41:43 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.17+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <0d6775da1dc393821eab88883670b937ef7d8242.camel@HansenPartnership.com>
References: <0d6775da1dc393821eab88883670b937ef7d8242.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <0d6775da1dc393821eab88883670b937ef7d8242.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: fb641516a6687801fddc25e889bee9ab46e133d7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 674b0ddb7586a192612442c3aed9cf523faeed7a
Message-Id: <175954570277.163446.7004748985443036427.pr-tracker-bot@kernel.org>
Date: Sat, 04 Oct 2025 02:41:42 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 02 Oct 2025 17:40:23 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/674b0ddb7586a192612442c3aed9cf523faeed7a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
