Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B2B12B93;
	Sat, 14 Jun 2025 01:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749865036; cv=none; b=s7hnPhFmL4t9xApw4nzB5FZfkl0iT8XL6PHLwuk37ZfPaflINmO4B95UlhaLjisqc6e+fQTDbODfPILdZ/EmP2ahncWgLnBsRZ/cRoxPgK586Pydp2cWYkiH8BguWs/ppV84Yg3YevdRKPaHxf+0oN7Nqk6lFu1avX3asgrFwcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749865036; c=relaxed/simple;
	bh=6EwEnRke9gLENRuyoqmIT11ur53Hx7SDxJND/XwLejw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KqDkOgy8SuHL43tcqCtTHXA1fDrJHg4ZlQlifElzqyJx5ikJBg2/X/2qILVmm3CZfW1bGzQfFhri43G68wHoj01R7cVUNvl3ceOylNqniZYXvCybLZ/4S+GRZeoGFQpfxDIgoV8QGMPgDvWmiB2KmVzj3XBYI1rFVwSO1qpf+Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgZ2WC/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgZ2WC/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EB6C4CEE3;
	Sat, 14 Jun 2025 01:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749865036;
	bh=6EwEnRke9gLENRuyoqmIT11ur53Hx7SDxJND/XwLejw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cgZ2WC/awbgE//bfBuvofkeygUYF8FTvIVM9KiR3QPKHQx9EdHFDajvGhcFw9K/T+
	 1lwoktOlMjPXTLaTTP2xq0HXxI2lpYIYhmyxW8hsYQXmdOei94QD34XXORp4bo2nyu
	 7fdpe+ExfVqa4j6tgOIy0tcRciwTtMBL4Qg0V+P/p6v+jYtW1b1/dgxzAfokFAa3kC
	 YGorTRzgKzF9Z2Z5G6P0WWiEKLAf4zKmlkZ9mmNjFE7foxSW+WZUT5HuDtj7bWuWRb
	 Q2UQXhIynPpBL5rxCyR1beWfOJQe9VvEfkllV1spWOLZ5ErF7e5cAKyirr5uY7SyzT
	 pakGaaUg2n7Cg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB064380AAD0;
	Sat, 14 Jun 2025 01:37:46 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <f135ce6b4e1922d84027ffc743e78612eb6f28a6.camel@HansenPartnership.com>
References: <f135ce6b4e1922d84027ffc743e78612eb6f28a6.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <f135ce6b4e1922d84027ffc743e78612eb6f28a6.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 5c3ba81923e02adae354ec8afd006f93289b4a3c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4774cfe3543abb8ee98089f535e28ebfd45b975a
Message-Id: <174986506564.952904.15026683496928560847.pr-tracker-bot@kernel.org>
Date: Sat, 14 Jun 2025 01:37:45 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Jun 2025 16:58:09 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4774cfe3543abb8ee98089f535e28ebfd45b975a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
