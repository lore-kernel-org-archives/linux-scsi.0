Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6785319DF5F;
	Thu, 19 Sep 2024 09:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726738821; cv=none; b=QXEKT7h0TV2SfCLXDF5kdpcKfGN6eCZ/kjWf50mGz1VpeTMfcLnY3vNb8RYcJ0shNt4mH1fRfOsjb5Vt8AlO66xbdLSbz3j/VieojbjtUg8jAiDL6se7KjCr72U6zVBaZRA14uo+BRX9zHKjClJj7ZG/WkrTfCUD09Gkxx/Ng0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726738821; c=relaxed/simple;
	bh=kSQOTvMzCvsQpN3i14D/pitO7vfFpeYBoBzTnYCdv1o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=EzXJm4bJaUiKragyGJ1mmNf+MCF0+UctWywraJmQkm4lfDjtQeDgkPRFnvSQCAJ5vp5RxHsUDT3YYq3tPCxcHsrfvt1pvXoKE5R43sdhKTJfgSGutxvsK3vWjTDbm4XwL1faKpdYvbrdNnGsMH1Mqoi01lvzoOwWzf8W9CX/XzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pVHPphmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pVHPphmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42309C4CECD;
	Thu, 19 Sep 2024 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726738821;
	bh=kSQOTvMzCvsQpN3i14D/pitO7vfFpeYBoBzTnYCdv1o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pVHPphmKJDXrd2sdSw7HMQxX09dzQAsTEd42hcp30szufAHkajNIT2EIIrzav85gz
	 lZ4qKbucXtmBj7D4VxTivf8zR82T+lnfhHMmw004ay0uVFhSMD5RvQjSNb6avUpgV6
	 ZpZ5SbW1LAVQFuCAUKkR6vaxL4A5S71YePTneFMq6kZoaJ3VCHnnvQrHmAQheN44ip
	 SZ2Vx12fwzkwF4kwOU2ap8yMOpaJqit87nbOLeSQw+K4uCz0y70P2ZJQIl5Pcf6nWI
	 tUJOQrJEc1/OUQ/8LhXZmg5LtldT+ODzhfpu02kzQioxj/n9vCB8D5QFpbk1TPVPsT
	 lbul8miZw5nHg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5D4003809A81;
	Thu, 19 Sep 2024 09:40:24 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.11+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <99f009993832aed11f0f05c669eb25d7678a9a19.camel@HansenPartnership.com>
References: <99f009993832aed11f0f05c669eb25d7678a9a19.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <99f009993832aed11f0f05c669eb25d7678a9a19.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: cff06a799dbe81f3a697ae7c805eaf88d30c2308
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a1d1eb2f57501b2e7e2076ce89b3f3a666ddbfdd
Message-Id: <172673882323.1462306.15604445574720103672.pr-tracker-bot@kernel.org>
Date: Thu, 19 Sep 2024 09:40:23 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 19 Sep 2024 10:18:28 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a1d1eb2f57501b2e7e2076ce89b3f3a666ddbfdd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
