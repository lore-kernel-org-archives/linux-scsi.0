Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2F413FE2;
	Sat, 20 Jan 2024 17:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705773249; cv=none; b=OePLLP1GUeBJOGN2Ib/p1TgH/8TKdKut6ZUt0pmMZ0cqpyQGoQS08iFGK10Us4nmZIzb/cNb6f/O66PVtNVXO8v/YEPl5HvgYxlwlVdiMz0rcZKom3GPF+EUsGhxpaI+AdeF+RtvNp1zdREbFzs3HIdB+r6pLpMub2RdrRBWh28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705773249; c=relaxed/simple;
	bh=ozBgcYdZ49mlsG3K/d80OJsB+C3pib00L97RPoXK7WM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tYNgRMjmk9/DdoQOPlU2tFGrEyqPMh3jG1k/q4EmZtU4PsElhkQM4NAvhxWwFRF6jEwCbAXU2njPql/6J+0LiahHs3JAMA2al04Ys4NtEY2kGtBKrrMr40OKEKhbQKnq9Rs6dDECD9l68hCbtJZg5un3W36gxOXL+LKA3R2jO9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QeyW1EPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QeyW1EPc"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72023C433F1;
	Sat, 20 Jan 2024 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705773249;
	bh=ozBgcYdZ49mlsG3K/d80OJsB+C3pib00L97RPoXK7WM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QeyW1EPcSOJ9XpcIW+MUOG3PdW3Q98vkdXSjjrWTCOC1Pd7ec6Vu1y36GDvNB8y19
	 6CZIFNirsGITiT7hPvVKRn/ydldpR6sINeB+JN+7xDvD085NeUwPlDBPNIergwOqUQ
	 5ehAVsi6mdIOnD75YYwIm2PEwpLlCeEMSGgQ3KodpfuJLQ37DVPbKGfuEhdmzSLTNI
	 HZDq67cGiBvWJr2tYIYZDI/tl33EJFSDfnhMib+YzSmNQL/iuvx4ZtCuS3oOUXfY62
	 HLAQTo+Z3CwNFmLfgey12ksyMyYek/vlaHT+C8gErKHtnjNc4eDDmYG3ON1+R2Fsl6
	 6gRnpsjlhtiFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61572D8C970;
	Sat, 20 Jan 2024 17:54:09 +0000 (UTC)
Subject: Re: [GIT PULL] final round of SCSI updates for the 6.7+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <d2ce7bc75cadd3d39858c02f7f6f0b4286e6319b.camel@HansenPartnership.com>
References: <d2ce7bc75cadd3d39858c02f7f6f0b4286e6319b.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <d2ce7bc75cadd3d39858c02f7f6f0b4286e6319b.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 83ab68168a3d990d5ff39ab030ad5754cbbccb25
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c25b24fa72c734f8cd6c31a13548013263b26286
Message-Id: <170577324938.9549.12467606490503722746.pr-tracker-bot@kernel.org>
Date: Sat, 20 Jan 2024 17:54:09 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 20 Jan 2024 10:26:03 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c25b24fa72c734f8cd6c31a13548013263b26286

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
