Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF412BF3F3;
	Thu,  3 Jul 2025 22:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751580702; cv=none; b=aSSE024vL2l4wdwaDH5Gg3Zk84zn22E2H8Ev40mZOnV/x5XMaM1CAal2I3uoZ9ScNKtv3vP+gr2RQOa9gYL57APzbLYUpfT6XfKdUtyUZ8MlfqAW5EzCf3M5E7KHnHRU8BwrOoJGOR/NS9wGlw3RrG8Fjpp37RGeCnxjn1dF+7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751580702; c=relaxed/simple;
	bh=c8htg4L/9jVP16pxXaw8ylzDcodxe5fAJn6RtFiMVAs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=owtS6usIEqdza94JhgstUupQOqcqviEhMMKATe3kohiHxkwTRCrNeO9y+HbFHpFaNN3W8DC25RaYIVmelKsDNGvILo9Qo6tYsVgr/81m72tNIyaatG3LdpkEHkdV3X8F2UiSr0oE8g828W/beogQypxV+BVG7uMANP2/EBCtaY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TQnMAktc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TQnMAktc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D47AC4CEE3;
	Thu,  3 Jul 2025 22:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751580702;
	bh=c8htg4L/9jVP16pxXaw8ylzDcodxe5fAJn6RtFiMVAs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TQnMAktcVRWOZi50mX0rwMndy8DbHBSzFWkDsrtC0+PlJghD4zrYnbo4J+iec0KnT
	 hbkaXDfyTYw4/t4A2skE/wPZBHrV5NI1+PBRZ0RPPJxdUMyy9HP7q8QH1Hv1o1/3Sv
	 6C8DByRsDtcMRoVBMKw/gKT442VafjUCqkvjMFnx0DKjmFgRbepLx6Ackaswa/wI5H
	 zmctPWZ6IMZX/s7c6o0ebACPGMwWklUEK1j/1jv6bvHsUKrYGc0B4D7hoRAcnuJ1Xb
	 gLh1QF2uZgfCo0NF9Zjf0MnV/B7taInwc90Jfr/V00gG6Z0EjghW6EUrs4OcrIjCpA
	 RtEV7NyemKkOA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB1EB383BA01;
	Thu,  3 Jul 2025 22:12:07 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.16-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <3c9c43da7745198e1a8084dc0aabeca317fd9311.camel@HansenPartnership.com>
References: <3c9c43da7745198e1a8084dc0aabeca317fd9311.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <3c9c43da7745198e1a8084dc0aabeca317fd9311.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 021f243627ead17eb6500170256d3d9be787dad8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 025c1970da725b07701464990f747fe1c2bd797f
Message-Id: <175158072652.1631256.14421990011809547902.pr-tracker-bot@kernel.org>
Date: Thu, 03 Jul 2025 22:12:06 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 03 Jul 2025 14:42:16 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/025c1970da725b07701464990f747fe1c2bd797f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
