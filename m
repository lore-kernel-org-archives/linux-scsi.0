Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C814717DFE8;
	Sat, 31 Aug 2024 19:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725131635; cv=none; b=dusKhx85UVI0yAqEsUGXj9uPVkV7n+vJvk9kvB2NGLN/8Lg6R3lscVY+svNOycY09urVN32Z5bnO16idLlYzf8g8AWRhw/BesX5SGyRTyDqzVcAkB5UI/01sSda2wLI3zohNMZ0xUI9pz9cibxZjb3v+gm3FIuXLlz7hKOueTpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725131635; c=relaxed/simple;
	bh=U9Et15vL9YBt8K6o1a42pXtUwymGT4rkdiMUzncbqDQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mBuE5eFvurkbJp3gKotofuE+qDeCYCpU+nrPn+Uo4HK/vBgwIVCH42l4ZwICO3v0K5hs+0wr/NXmbnruhW54QTQ62nv0XlDOuofe/2qwBfnzX+49G9NjWnUepWQZH105Q81PUNoQscMrB63V1tMEXUY/wImerixHd3Kn65RPNgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1Nuoz8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1Nuoz8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1671C4CEC8;
	Sat, 31 Aug 2024 19:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725131635;
	bh=U9Et15vL9YBt8K6o1a42pXtUwymGT4rkdiMUzncbqDQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=h1Nuoz8GNMAtFeJK85VjeyzvacH3s+mdjDcr09UzAUbhXZHWOam3eHL37SSoSJkwp
	 oE3SWoDB+32Zg2ghkEWG1dx7B2r4WvKappushzt4QALAGVlcAbHiRohXXgO2NxFS8M
	 BloFzp9OVggtlZSZMANNgsJd98qmzCmLMX4sJUKXoRf8OJHIiXcB/YDOYemFz9Njss
	 PYdHU7fhb/nyvt+Qy1x0s/MFoSRQNigfSX8ixCHKIicHQf4wsF/984EM+urkcvFQiG
	 7esoNDHQ4S592qVx56bJzC+IED/9k2+M3MVg4U6e3bvyzVcCAQ7l03wx3PNwqqwTsu
	 EcRyBtFBiVsKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7145C3809A80;
	Sat, 31 Aug 2024 19:13:57 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.11-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <73531af7c46f3f39acc1246e84cc8fe99d932a02.camel@HansenPartnership.com>
References: <73531af7c46f3f39acc1246e84cc8fe99d932a02.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <73531af7c46f3f39acc1246e84cc8fe99d932a02.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 4f9eedfa27ae5806ed10906bcceee7bae49c8941
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 770b0ffe28b4f1a18a90e9093148b8a74bdfdd84
Message-Id: <172513163601.2915779.10751590460653052412.pr-tracker-bot@kernel.org>
Date: Sat, 31 Aug 2024 19:13:56 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 31 Aug 2024 12:15:54 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/770b0ffe28b4f1a18a90e9093148b8a74bdfdd84

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
