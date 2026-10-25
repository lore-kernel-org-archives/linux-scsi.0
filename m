Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792889189;
	b=qdpBfzVJ/tGEFQGNrK6XsTeKJRp19GVPJAj6Sa6wHfS5FyMxSwzc3eF0LIj9yYnYKOnR
	 IJ3dHkiTiIsQCbd2821o26m+SIbnUPyJN9iwt/0W6+4pIq7643X0zCBzFHopsu0TY0uMX
	 Exbl6Su6hj4xxMRgcaOjqBrdKNfHzIv+lo+qO6KhNb7+5oYP4nQBxK0/AZMoTSWHse7HD
	 rTwMfxu2ANbi6R33ET1qj17secmPzfXmybX8mcRtXslFSgecqLOqplEIDCyfJDrQ4Jv8J
	 nuWgpsfL+hRnE8jemVjt8qZLdKtGfAKD/gvVzwyskeWXrIJH70qK/6aA9f+q9f7nTgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792889189;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=lCgupTnG88FYF+bWl2JXFtr+dCaJV8aLojTy6cYxVMo=;
	b=p753nugNTdSzLAUEptCi+szlY/gENkJEtUcpwVvcKylqg9Z65YuU4HtuMOlBkS1ITiFn
	 R/MBifj/fnjUWZPvLDThHjkUJgGsCmKluiWKNqJSwz/rhfPeY5ssTF6gYZnLliB96yxid
	 BcKk4T0hI401l9CcBqtdkGjHz3/lVu0zszlQ8CCgoqJaGLuKlxgrAmBUctJmniS0J4A9E
	 N6j08aAOZliosX1oMTd23W6rCmXv3/MHYt9mvtMzSV/4fF4DvGjxvCmLQ7tS7b0lSxPot
	 ynpqmxWqhlySud5AYtthEiO1qVayZeWqS+uNqVH3sRnJwguP2IQQO3LoWKW+K/vkL3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSLZ5Ezy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE93606A31A;
	Sun, 25 Oct 2026 00:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSLZ5Ezy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C982E1F01825;
	Sun, 25 Oct 2026 00:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792889188;
	bh=lCgupTnG88FYF+bWl2JXFtr+dCaJV8aLojTy6cYxVMo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=YSLZ5EzyP2Bv8c76wVNedVft2LA/hTyitKagfEefrqcAQdixXaaN4jT8s/Rsb+OTj
	 pUj6wsrHWi0i5oGjN79RizyC5zDCr4eT9U+ZMfR/AIFArh43ojJKYZT0mVYK6ne7cV
	 es57fdPpFMwo1dfYkXRVm4v/G6nUnEJ1QPZnKfVm86UXkhuhwhlsdbsczNvFVBOBG4
	 2Ivq7iOPAmGW4fHL/dpts804H5dlGjdI0fuYk1hfB2Npl53bfiT8FHh9DU5V6H5ENq
	 KX+GTpA845gQ8A9avLNSrR7xKzCs7PO/ZsJHpIJvG24wQITzJ/onFrF3ez/Or+YI8D
	 +FZJxXJWHvhPQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BE8AD391B1B3;
	Sun, 25 Oct 2026 00:46:28 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 7.3+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <80d0631c1c5dbb4c62dd26ad813f595e41d855a0.camel@HansenPartnership.com>
References: <80d0631c1c5dbb4c62dd26ad813f595e41d855a0.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <80d0631c1c5dbb4c62dd26ad813f595e41d855a0.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-misc
X-PR-Tracked-Commit-Id: 2f4880c22e838d54eae9ab153b0f8dce60531bf1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6fba331225f5040e93d0947d1027e9712238291f
Message-Id: <179288918731.1847209.619262748091601876.pr-tracker-bot@kernel.org>
Date: Sun, 25 Oct 2026 00:46:27 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sat, 24 Oct 2026 11:09:08 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6fba331225f5040e93d0947d1027e9712238291f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
