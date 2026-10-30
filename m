Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793383217;
	b=Nr9AoYvBSru/fwph8ly8t/nJvXqkv7xaqGs5AbXFSqNR8flXQBLXS0BEuDILzrgGNkgY
	 fnSme5TPnZn+wuLBhvPfsMyF1cfKJCxEhG5Va7s1PBU1TeFvTbFpSRvmGz/qGnwQkp1Lz
	 ZNAlSPbPVWMWTuQKkgclaX09ZEHxe31G9qph3Le2+w3ohDSydltYteLFrQxO0Dhyz2FFe
	 m6jC9tj3NGXzXEipeDJXtVrh/VR1MAvgcBvmr+EyJrFpyXNUckQO91kyHgK19KkqLauY7
	 y5xhLEp0k2ytJObDbgX5kTvNukdk6N1sr1uZ6V3dJNogI2l3e9OR7Zy1fW6+WTH0GZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793383217;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=yChfyjPOTiyLF+PWJt2DeFwEOCTz0znOq55Xo9tjt2w=;
	b=bHgBlAJC9z8xhzJlwOkb+ltVeB8fKU4PUDe9FU0Vl8O+EKUFg+3CK0d0JLOFiYgIri0Q
	 tspxh1tZQfs+SDilnev7EtTSXx16JGCGrVrY6dtbLJWBPwHWVK0p6dpgXeKjgA4Gcu/y7
	 gNtmjT2nWxAKcujwqBnHOjPrqftCTTKfjYHUhgcNNbcISGeiuvGdVzSb9sjdwgvjdA4U2
	 Ate0cd7UcY3Y/oKODhhJcNya2jDBEVCiArheAAo/jDCQzbaq14hTJu2j0/qi4z3i68Z0e
	 fkkhRpJnZhpAJgSYF9Ay2nPmLAVshvr9GF/OeFAxi0xAQ0Z8xWlvRfn7sehmrdSO7zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aXyWglpY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBFC606A33E;
	Fri, 30 Oct 2026 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aXyWglpY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199321F000C1;
	Fri, 30 Oct 2026 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793383217;
	bh=yChfyjPOTiyLF+PWJt2DeFwEOCTz0znOq55Xo9tjt2w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=aXyWglpY3r1D7cVdKI3EjLjnqyyc8Pm9gDFXpCiQ5In7sORCa68V16nQDQYGEwO2s
	 0Hys3FrZg7v7KoZE0SpRSwgSmXfQlRJ5o4zDbTyxBGr8HJgW5yQiZuhzUEBJHD8TaC
	 sryoVzADXwo+8ZGESrmkSQWCrIpKDhMAbTDf02M/G1lZtZt7+vye0OurqccWplgPC+
	 VMoZxttt0MF8xUEFoDMr9mK1MTBTU3BpXP96O08ux+r1qw7ePZFjYIGle5RfQW9OHI
	 FCtFUcZMbpphUj7VaeCZwnCkdamDR7HxVOn+r3xzt0IjS/Xp8cPcgKJiR+aeaaQz6H
	 8FIvrQYpoNv+Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 111A03800471;
	Fri, 30 Oct 2026 18:00:17 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI final updates for the 7.3+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <e7a21a9f0a604f3d3303e4f18c3dbc2e0b8ed263.camel@HansenPartnership.com>
References: <e7a21a9f0a604f3d3303e4f18c3dbc2e0b8ed263.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <e7a21a9f0a604f3d3303e4f18c3dbc2e0b8ed263.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-misc
X-PR-Tracked-Commit-Id: 3650bb41391b51d9dcf87b0480ecafeb1526252f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bd5c762ac0519a8c62141751c893cd25a1ad8940
Message-Id: <179338321592.1671436.14063101719479307975.pr-tracker-bot@kernel.org>
Date: Fri, 30 Oct 2026 18:00:15 +0000
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

The pull request you sent on Fri, 30 Oct 2026 10:54:28 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bd5c762ac0519a8c62141751c893cd25a1ad8940

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
