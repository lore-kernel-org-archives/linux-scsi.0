Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4F2168BD;
	Sat, 27 Dec 2025 03:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766807296; cv=none; b=JL1VI4MBreg6CBORwkDtLbD+HaitNNeCcJR+5G6RspO5TDsOUhJA7uzmP2Z/waMMGzLG9jPXg6TLuL0zBjSrBEeIrGGJUChuAENlxeMqag4jTaYs+Krw/G2RS8t9nGPt+a6IoKu6WqUcjIwd3UMqtAvS2fmusZ4cWph61rz5EsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766807296; c=relaxed/simple;
	bh=lts0BGZBY/5vLZys2pxLXWfaRAJNinfWYMHqn7Ypcjk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=UuWX9rJbBVwP9fHAStFtkFFlZJFUjH63gYp05QcvoPgaunnVG1Kmz+dgf2zamFn2MqOc5vbkXL7E09xM2AT2MYymKQF5xl0PdJ24sARL/bOePfSIesZz6Pbf6Ll2HLeoXoJ2wGbuiKPExtxKvaHpkl8igZ2xUl0ToXsKkndmZWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LK6HquHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LK6HquHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298F1C4CEF1;
	Sat, 27 Dec 2025 03:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766807296;
	bh=lts0BGZBY/5vLZys2pxLXWfaRAJNinfWYMHqn7Ypcjk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LK6HquHSBlWIbew3t1VUwquBzfzEZah/UN0Xs5kJCn3jEUK2E3mvaB7DuASWiH2PX
	 no8LmVm/bVJI/Y0qp9l73REs5xOgk3uIxnvuWHmTEnOJVjB7kDr0Yyo/QJycij6K48
	 DdyBClqiNDcQSCEt7uzltrbSzdwBLDZYZMT8TK1x2ExSdKdGpb291LU/cCOZK5J5Mb
	 I/wLBvHCuuQOh9Xb2njqeBuVLm0RKsF0wvcbvgLg/12YsXwddLvj4qvJ6GwolNymgn
	 g1IjaGoJB+5wjFnKu1gxz7/uQ753OQTYUnTio1kAQ6eXMaPzv7sCcKGxoOH4tnSjlz
	 hv/ldfoAA726g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 833393AAA6EF;
	Sat, 27 Dec 2025 03:45:01 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.19-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <858baf4dce984fc3ff5c20fb8f8c276957fd44d2.camel@HansenPartnership.com>
References: <858baf4dce984fc3ff5c20fb8f8c276957fd44d2.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <858baf4dce984fc3ff5c20fb8f8c276957fd44d2.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: c9f36f04a8a2725172cdf2b5e32363e4addcb14c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c53f467229a78287efa5b9f65bd22de64416660f
Message-Id: <176680710028.2053714.10764350547374232974.pr-tracker-bot@kernel.org>
Date: Sat, 27 Dec 2025 03:45:00 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Dec 2025 22:41:40 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c53f467229a78287efa5b9f65bd22de64416660f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
