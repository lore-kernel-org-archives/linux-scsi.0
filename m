Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0801FAC25;
	Tue, 14 Jan 2025 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736879160; cv=none; b=PShMznLOxnRyG3Q6QNmVcC7DpmKngmzLP2mbODFXTlv+rWW0ENEbhnLhkwzWESI4psXXPlgHL9iDu+czyKR/Dh2bOs9r3JXYYwfbvYJQ+Ua8GZSR8ED2t0mxgDIuzLkS4wdRCSiWmqGGYnHPcIekyqvD8oS0fDRr248g1GB4yAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736879160; c=relaxed/simple;
	bh=xns3yTLpdikG48t6bHRnCz8RltbvSorjyXl8s4knTNw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZR7AVW4W4ueImJZXE3ofgCqEzwRvCp9ShUu0EGet/3cPNH09N+xaxpTVW09dKuhz3w7QIuQUQ4wGo5Jg9Yiq3GAE8uUpRF68c6nrKErINJnQO13upRSiWW5+hUaUOE7aEJVvh7f18gy5/DSh3WiKAJUU7wKGFy1w5/a+68U6PWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qzSCsSEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qzSCsSEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F4DC4CEE0;
	Tue, 14 Jan 2025 18:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736879160;
	bh=xns3yTLpdikG48t6bHRnCz8RltbvSorjyXl8s4knTNw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qzSCsSEbVfaBJy33WAJR7QU/w1FVC0LqdquuHs9JG8UTwjxtqSHG/M4yFD6KXjszT
	 5Bf6YcyAa4qnRblZdnRxRyBifolhjpd8WIYjUM31PZcMIcdK6xKmSmZEKwcDM9TbJ4
	 y71BtfT+lrKP03zF5ovQftdq8N5u/Q80qQnD/g4qw2tY0VcuZOhyYWmAMBWAWRTJ3D
	 XC+Oc5GqVJP8DKOLb8TWgnM7E6+zXDLqzkB0B/OkkLzTGL0IFOnQIeVuuFa/wSceSJ
	 27jfQWlGtIeg7WihEkB/Da+i7edflP20u1MGaV7NYjoocRlARRBANjI+pdDm92W6gr
	 aQGK4arMdhClw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71069380AA5F;
	Tue, 14 Jan 2025 18:26:24 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.13-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <0adab7ba6c378fc1c610e367e6e952db7b27baa6.camel@HansenPartnership.com>
References: <0adab7ba6c378fc1c610e367e6e952db7b27baa6.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <0adab7ba6c378fc1c610e367e6e952db7b27baa6.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 63ca02221cc5aa0731fe2b0cc28158aaa4b84982
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c3812b15000cc5b7b17c7238f8b12f6a22df0b1d
Message-Id: <173687918298.92072.10087573697959127443.pr-tracker-bot@kernel.org>
Date: Tue, 14 Jan 2025 18:26:22 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 14 Jan 2025 13:05:55 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c3812b15000cc5b7b17c7238f8b12f6a22df0b1d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
