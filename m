Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBB31F1506;
	Thu, 24 Apr 2025 20:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745525300; cv=none; b=cVuQCG90wbMBJyJ5xyTeaYCCuFipuOvMBS9tPYehRdTpPlX/8hfFqU/iLib39VipLHGmLi+SfQhag//xd7TZuQZq/Gw/xwe1Kcs31kX2oqdueui/6nMPvAWo3IXOEKHvaUp5v8HM4vMaCbE7l69md/+99Nd4CE+KaaeS8B2/gDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745525300; c=relaxed/simple;
	bh=F3xCUpL0ZTFZb19pbmsWjZpM3nvfQcP1w9Xz79H2OOs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=P59PpQbL4cfRn15X6NF3PkotEEf3sG/W2MUHholioPnqkJX2JKD7ckLwYZUvsoAG6vUu4xTZGoL8dBh5duqvNdbb1Vlv8wGnSXqOC5JXSVlzk4REqnYfiMTopySX8LFo0I8hV/tMMfF/8GtEwR+dUuRbrP4sUBaBrp4VKeIh1Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vQK97TxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vQK97TxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAD1C4CEE3;
	Thu, 24 Apr 2025 20:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745525299;
	bh=F3xCUpL0ZTFZb19pbmsWjZpM3nvfQcP1w9Xz79H2OOs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=vQK97TxOPXCFHTJJKj4U9I1vCwBhBhY2yPKRXTmDdU4Gq8oK3Xh8prclSzlR36nrY
	 S5Sm/NT+dd3G6fGH4hz0p5xxTZLflOIO1+DJ83XCbhPDp+zGk/yWfmv8TB6n1xy5e5
	 z9xyCKmmLF/69lVW+1oY+c0MbfBzU0aT6Uk2V6iEQPZO2m4NIqRAmTYAWyBMxhchdy
	 j1LXOKV4JCBODqi4uwpX335uRH/z3oFtn/O7BihiAyPQJtx0N5k9uqeB9euwA/J7pX
	 2giMLqluzX9cWPE+J0TtmYc6hxp32OMw/OIlnvJZQrO2JIX+69PznsfBCPWPwCKI6a
	 XzKHTzEpH32Ug==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE13E380CFD9;
	Thu, 24 Apr 2025 20:08:59 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.15-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <b574ba430d181f9fa53a6a7bd76e42911c50d899.camel@HansenPartnership.com>
References: <b574ba430d181f9fa53a6a7bd76e42911c50d899.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <b574ba430d181f9fa53a6a7bd76e42911c50d899.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: b0b7ee3b574a72283399b9232f6190be07f220c0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 02ddfb981de88a2c15621115dd7be2431252c568
Message-Id: <174552533820.3476198.12624986481727542420.pr-tracker-bot@kernel.org>
Date: Thu, 24 Apr 2025 20:08:58 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 24 Apr 2025 15:29:10 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/02ddfb981de88a2c15621115dd7be2431252c568

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
