Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EE740C03;
	Tue, 26 Nov 2024 02:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732589975; cv=none; b=r4V+9ZpL4XDPE1/15w1J8Mci4/iKn/AGNznQHH8CUMS656jpJRwDBF0VRlu5E3PwtCnlL70PaozndXqUxovBQLEfPsnLtyi0Fl/hsuOAaYrO9C9ZF7IS5yss3vVl3b1iaIMsdU+CQpQmqsE64AAfervmIqPpsRYH+/pM08DZq94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732589975; c=relaxed/simple;
	bh=jleEeeMzJKIhvYsBMvswtSS8uOR6Zr4K7scBnDQXdDc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=iibpBZ7TriAx0mbcWaeRnEt0H+W5CJnikd81UySkR3je3FmW8Z1b7MK5eoa8Jb6El8tj+diYrA2uU9C8MRDi0wNV++IJFrCX8tLoX7BKycKn+5nNVAEYq4ZxsqRsEvZ3ozvbtVSsRK6YZTaV35wDl5DjOTQgaFbbex6vAyw+nT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ld0bFNTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ld0bFNTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98F9C4CED7;
	Tue, 26 Nov 2024 02:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732589974;
	bh=jleEeeMzJKIhvYsBMvswtSS8uOR6Zr4K7scBnDQXdDc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ld0bFNTce7xSL9zgL+Xj5I5x78UgxCPChUlpCyTV2J8F5ADI86RZA0WbzaTvMztW9
	 Yc/9yBC5bEzwQ+SEjVCdiuDCpMavEL97/BjN15gn4MvzUI6zMGd6B+g8IcweKrGw56
	 ia562iv19iCzNATdMNB9fg3oGQEZEtdH7UmKDMHZp5Zcf4B98nodnOOpD8p9kYyoqN
	 sCBWENco/ukLfGyRMa5MMsZNQZUaVPLXIM51gqfERoIuoQDa3XoD4NTrwfF4gHHimc
	 O3DVizDyPDth+t99rgU1bnwGIw3b3hJ3tp9MdKcUgz3V9GlV5V5DqDNX46v4hqICTa
	 NaM2ccgAFMqhQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB03D3809A00;
	Tue, 26 Nov 2024 02:59:48 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.12+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <ce97f69d630945de4e5ac8e35be98d9720fc50ff.camel@HansenPartnership.com>
References: <ce97f69d630945de4e5ac8e35be98d9720fc50ff.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ce97f69d630945de4e5ac8e35be98d9720fc50ff.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 8e3b6345d113cc917e64b0349dc486b5d8f55e70
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0637a68b9c6c1dfffcc1fca003cb7cd3257c3c03
Message-Id: <173258998760.4123769.4634243086234444297.pr-tracker-bot@kernel.org>
Date: Tue, 26 Nov 2024 02:59:47 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 25 Nov 2024 09:29:42 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0637a68b9c6c1dfffcc1fca003cb7cd3257c3c03

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
