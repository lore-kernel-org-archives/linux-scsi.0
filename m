Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B15922A7E9;
	Fri, 13 Feb 2026 01:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770945524; cv=none; b=JKrqolelDIdTyKfsbdCat7589Gj0BYPXZdlAO1P4i8XxQczNWdYUqplr4g485QO453fbpTa8ZctHOr6Pd56hVKkj+9jDQXnJWgf+Tnck4HUsJsWC5MVlz+hhVwJmIiCsel9xtRASDysyjlVhz493qXW7Yk0tRmwa51ia1VMR180=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770945524; c=relaxed/simple;
	bh=sxktNOCSpF0Uk8bN1IsXyrkIF8p7xGYHcEH+LIk+yug=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=U1Z0WuhgbrHV8LvDERFAwHmjPwyjX5TfuNjM7Djr3GC1bEjXh+OU1k1eOcHA0BuMbjfayfoCN1DNXAA4BMuLZQ3Dzq8nS81lQ4kTgEk4MQQC88Q9WgeLOLhrNNsp3X/D5vh25DGsmFXUk1TQYEkdIYa7kUK9FvycqbhvSEfFZpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DdsWQGGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DdsWQGGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D722EC4CEF7;
	Fri, 13 Feb 2026 01:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770945523;
	bh=sxktNOCSpF0Uk8bN1IsXyrkIF8p7xGYHcEH+LIk+yug=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DdsWQGGOuoz9a4eTMLXsAfPikrhGKCusNWZ9lnzbtsUpMu/+hadJFg6NWUPKGnfeL
	 pcEb7rq2QZ0/B9qYokXlOgkb3XtkNk+NTX212TMYbRoV7gygKdHN4lc+ipWOvOVTOc
	 rIPQBeg0gTgJIWtfO4+rCdCek14/aByGeVk2LjT341c0Pb1IHwMPayY5ASwelBPC0N
	 IKAcOsWnzyreJwAEtPgkKrKVpgIVVW5aAUG2s6nkOaietMLr8hIydplHox8+XnSLOq
	 27+uBfROgsHELBtVhvVx4DNGgKKIWO3Ty/hFZ6k2MdmOBU9YKoMCsNkwbX63rPI+uX
	 hQ+w2/KcTZCqg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 480DD393108D;
	Fri, 13 Feb 2026 01:18:39 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.19+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <3a45b4e6edc8d66c33202c98d8b85a67678938bb.camel@HansenPartnership.com>
References: <3a45b4e6edc8d66c33202c98d8b85a67678938bb.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <3a45b4e6edc8d66c33202c98d8b85a67678938bb.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 1982257570b84dc33753d536dd969fd357a014e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d4a379a52c3c2dc44366c4f6722c063a7d0de179
Message-Id: <177094551790.1792804.2304477175794875562.pr-tracker-bot@kernel.org>
Date: Fri, 13 Feb 2026 01:18:37 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 12 Feb 2026 11:34:50 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d4a379a52c3c2dc44366c4f6722c063a7d0de179

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
