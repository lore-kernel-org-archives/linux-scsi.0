Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6573D3DDDA1;
	Fri, 21 Aug 2026 19:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787339498; cv=none; b=u08Ua4Ibez0mzcQjJHJO89jr9Sh6G48PdeAiiSiLKw9uNrswpsAD2vuKZihBLUwwK4EJPsLBiNs1W8Bt8b0epx1kYUobV9w6E5dA42qsLKzi2p6qg71XZ0AwkKYHZrzcZQglh5iclQ62Y/yEBrZxkEVo6elel/ZzTPr2KCpya5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787339498; c=relaxed/simple;
	bh=oNYtk2ryzbBtIzwf3H4ak5BayNyAjg+TyJinI3UbIps=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=IPz6Bj7yfp8IfkNwOedcRwiKQMD3EwegIR1xjSdTPL7zEb2UD88v+8UaqoCHBW4MmDrN+2M3j7vsW+KdqKVUCQnwnJuNssHT/xuo3PoQ6F5ywQGmLpNR+bsI4Mi5kHY0QuRyK/He2GJiKhPZPNAjA9JEasrwnxNTWxUearY/Fnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7jB105u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7jB105u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3988E1F01803;
	Fri, 21 Aug 2026 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787339477;
	bh=SoYNcaVqdkYxtOL7KRxhHlIyl2lOXS+EbAbds6BIp3Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=b7jB105uNdC5fcsJUYRi9oqcbZMGocFdfBr4q1AdgF9PJ/+eP8umetRu0hTohSYN6
	 Ssvcpqqp3bHiGr/O/TbxhLb62/0K9ZCa7yR4tjcxhjLqbyhfVme4u2R5IDYqQymjRS
	 Pw02jkWtSPLOZKQf5gwewsKNAwAQNXgsdZtXWfhJE/lFI/OJ1pM4r5tqh/2G5Kgr5E
	 d+6viyua+ulIksTJT/uklzxXo6EuorxPEVrgobKEfcvyzNHtlNWioIW+xpOsvSAAhr
	 +tERzQ1V6I+F8s1O3NT27TPdLbrWew8erHd/PXJVdqwFGdcrrBTNaiHFC+JIj/Ose/
	 dFrJogw8ZbG/g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 009C4380CEC2;
	Fri, 21 Aug 2026 19:10:28 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 7.2+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <1cec13635d688db8d8185fd4df8a8df621d60a75.camel@HansenPartnership.com>
References: <1cec13635d688db8d8185fd4df8a8df621d60a75.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <1cec13635d688db8d8185fd4df8a8df621d60a75.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-misc
X-PR-Tracked-Commit-Id: 376a3960e5efe85ff765abfb5b5b7e4655ad6aed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 35748ddd3b2c91555bd86b8cf88edc90e7317e57
Message-Id: <178733942664.1438271.16412568242181002942.pr-tracker-bot@kernel.org>
Date: Fri, 21 Aug 2026 19:10:26 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 21 Aug 2026 09:03:55 +0100:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/35748ddd3b2c91555bd86b8cf88edc90e7317e57

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
