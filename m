Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E283733ADA8;
	Tue,  5 May 2026 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778025412; cv=none; b=YvJifYNxg5JF6oWnHuIB9xwLj84nGniIVlwb72GagfDUUJP/UBSdgjRXtiSyKMPAnV9ySrh07nitG4whFbvGUBI/1/OMa2EhMdJqWh4ezcFNA2cuXj/RzVTtAHrTpZsRlit6wNZktzojNP2segfpEGgr1lgu69Foc4jJrbYlwbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778025412; c=relaxed/simple;
	bh=56jKVHJmJGI1mLRSDf/fxTRVXsmKxXYy/ifyUw4W6Es=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MKfV/Qf5L3DRVyfZjOFLFlazSM6Wwssmy6nakPZa2IjJWt7m9iXB6IBCDg0f5wy4iF67xm1Tik3r1M839JLhkwxsreXgiPykuj+oIKghslJqb0+ZqLkitu5mbl1HdNY6knraeQ1kjTyO6t4GmrX3JRAmeHSuXSJJVP/execlp1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EjmDE9H6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EjmDE9H6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D8BC2BCB4;
	Tue,  5 May 2026 23:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778025411;
	bh=56jKVHJmJGI1mLRSDf/fxTRVXsmKxXYy/ifyUw4W6Es=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EjmDE9H6OiEAaWUFdgjN/XJPU8bDaMIr/rBV+ZdjN/S4/xXKjFCX3BMO0GpqnNzF1
	 WA6hDFXZJQvGs2L5VJ9Dgomtn2qLnA5+H0jz2yqDC4rIc6kKvuo1Eui4Qr+rRepxml
	 44cHo5nkgVPVqF23eMiVi2rsl2NcctO8HpDMSt+0V9sqGJVsKXtv3tk2x+yFiNBr5i
	 l2XqXWpZPqND/r52ptYX2kwrP1JDTKMRBPlg78i+Ifhufl5+th0n51kuEwkaJ1/3ng
	 2stgkQGs/N9HrEOoy4zO9BprSc7Nh6jSQEfsHBMm6NsJWUIL2JwGjUYe08zNU33755
	 AFHCsnOvZKblQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02C8F39302FF;
	Tue,  5 May 2026 23:56:03 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.1-rc2+
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260505212349.5828-1-James.Bottomley@HansenPartnership.com>
References: <20260505212349.5828-1-James.Bottomley@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260505212349.5828-1-James.Bottomley@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git tags/scsi-fixes
X-PR-Tracked-Commit-Id: 98f69975d4c0434ca2e6e8cfa1d8d51647a20593
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 50fb0bcc9d7da23e0f0fd5359b4f9ceb0aa337d2
Message-Id: <177802536156.2314843.7946016528609430160.pr-tracker-bot@kernel.org>
Date: Tue, 05 May 2026 23:56:01 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Tue,  5 May 2026 17:23:49 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/50fb0bcc9d7da23e0f0fd5359b4f9ceb0aa337d2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
