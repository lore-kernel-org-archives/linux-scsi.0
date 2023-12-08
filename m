Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970A23A26E
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 20:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+ZCzDxq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A73AC433C7;
	Fri,  8 Dec 2023 20:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702068324;
	bh=K+OWFJryI4pDti8SH/NpnPQEFZ3Y62Vzeopq9So2HrU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=J+ZCzDxqInladyzdchUQLH4SW85FzzO6YP3WQf6YfsgSDdSdS21CaPJhixFbOLhu4
	 k3TxdXSSO69Qub7wKoC+Q8zRDzt67kA+3tX6Uj/ej46bYsWLHaPBMxvg1xALxy8XRd
	 lAXU6xxrrlvdNx+W9qX60oyV3BjRkD1lzvxgVsYmsfsKhZ5FDM/pKz6XQw2oqPJEOY
	 /EMN9WeDEn8D4tV1YrUfIZl3ud6rG7V0PFm5biHDpUPTgCa322Bj303UZjjupSzaoo
	 f20tL3x9b65nJsjgc4YRbNzcERvrhE1eKBAU74tSu07cANFeV+D/OsZGXocktLRIPI
	 zQjFNYH8B9IaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57FC2C04DD9;
	Fri,  8 Dec 2023 20:45:24 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.7-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <04e6cd5c53b77f7cf01df448525709f1eb7b7712.camel@HansenPartnership.com>
References: <04e6cd5c53b77f7cf01df448525709f1eb7b7712.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <04e6cd5c53b77f7cf01df448525709f1eb7b7712.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 235f2b548d7f4ac5931d834f05d3f7f5166a2e72
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f2e8a57ee9036c7d5443382b6c3c09b51a92ec7e
Message-Id: <170206832435.6831.10264763598499219064.pr-tracker-bot@kernel.org>
Date: Fri, 08 Dec 2023 20:45:24 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 08 Dec 2023 13:44:22 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f2e8a57ee9036c7d5443382b6c3c09b51a92ec7e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
