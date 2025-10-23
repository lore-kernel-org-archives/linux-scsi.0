Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2045619994F;
	Thu, 23 Oct 2025 01:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761181827; cv=none; b=lOlRVwFjs2m3ewvrXqlmOH/ldRohL/SMYlPe4f/fZTXqgjNP36nzQm0OW297Bp2wox6SsGLrntIGjbaQ6MDSfRo4EIR4E7EkdYGUUpaRJymQG/LP5A8W4xjXqVLrVTGyHHGYQbAR2OgimLb5uvXFrhq2+mgvGROH0CPDwtap800=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761181827; c=relaxed/simple;
	bh=HX6QcBhLo9dCE8p5TPA2v6rqf7ON/azSd8dNqGQKjRo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=YpAVwwJSpybktlBJINJL1L1dWXy8pszssRpH5QI2ePIoTQ2kJjeAseM9fsvUOmzh1CUPhkWcb1JjvSOmzSmsiPwgypqFb3MmPxnlR1VXTuONV4ZNX2qFTFb/sDyc7TAgL+LGIg9gqq+Y6/QXl0/FYEBLK3eUvnK2n9SKNnQXR04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSO+qpYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSO+qpYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29F3C4CEE7;
	Thu, 23 Oct 2025 01:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761181827;
	bh=HX6QcBhLo9dCE8p5TPA2v6rqf7ON/azSd8dNqGQKjRo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lSO+qpYqycIKGCm8I5PESW12Ts04KUg80XVSLtGIo/ORCoFJW3fP7tX8yXtAE9iha
	 xaq0axapki7/YvvwdqKaMIvZY/hDbtrwErk0zABtVmig9sN9TK0DnO+gqLkKCW6zE2
	 lCTg3OJTNkkpwqVIz/8UGurpiaHTCrwanbFo6MNc8vnzYyMaxxol+H0nieT8QMLn69
	 e74sf0Zj2RD3bc+WpiHCrguvcGs7iF5pBtr0iT13jrLwajyQ4eYg8eufYPUQ6Zs6Oz
	 2y+I8NWz4U4T3RMuvKrUMYZJhmK4bTz5k+q11ebs56loHRIgcI+GQumcNuRu/OPO3V
	 2RzyxVw6B0JWg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAFF73809A00;
	Thu, 23 Oct 2025 01:10:08 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.18-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <892e8ced0cd493594ff29206d75977aeb20b875b.camel@HansenPartnership.com>
References: <892e8ced0cd493594ff29206d75977aeb20b875b.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <892e8ced0cd493594ff29206d75977aeb20b875b.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 48277906603528a1fd1946bf0f141b2fd4f84e46
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 43e9ad0c55a369ecc84a4788d06a8a6bfa634f1c
Message-Id: <176118180758.2361762.9039537935526709309.pr-tracker-bot@kernel.org>
Date: Thu, 23 Oct 2025 01:10:07 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 22 Oct 2025 14:10:57 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/43e9ad0c55a369ecc84a4788d06a8a6bfa634f1c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
