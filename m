Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED6E392828;
	Thu, 23 Apr 2026 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776971459; cv=none; b=gFkNl5g50X6JhbRL3pjqfRe8VQatZ70cGLEfwR8In/UADjgT+/sMs6hbegmJogAFlDv+rMpnPpx2GLllH7tR5wn0AN5xjyCjRzILjOqv2HKTQMuYN3su9mg+oawKPBvVHg9RWqPCvtCMQPUb8fdt1zFPRf6B3MTgkzCmNRQr6Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776971459; c=relaxed/simple;
	bh=Q15wjI4L+GDtPyPLOIpP5Jb7yon43H5DjAYWC32kJZo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=RoG+NpBYIl00kP6KvwdkblbgK+PRASRjO4NrRcV5I75ny/0XiWLtaCuhMXX9xt4OLap8quzDfOS/mRmdrMqT56xDqnEGKUpl7rWqEo4ULvS4itQoeOyN4mtLIilrzKdiTV+8CT9oXd3iJQmCsW0uT2lmXe7DzgjVyQcUCk6d1BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfdliwrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfdliwrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB18C2BCB4;
	Thu, 23 Apr 2026 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776971459;
	bh=Q15wjI4L+GDtPyPLOIpP5Jb7yon43H5DjAYWC32kJZo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TfdliwrPjAmrzu1lmi5tKcDFWeEQPyLVWK1A/F2VT89qrMIKnzdsE/yro/06H8K4u
	 /q5zNxdtZa3WRD8bB40PS/rBKhd+joEcXuSNVJ0nzgzvRaGgscVDegQ88arv65VVhF
	 usVMAfRd0ZiqQvR9HKeFyRHbdqmUUhVmKG7XHjRq8BIMUtPvRZ+LD+tNHomeGQXX1o
	 K8yfq2soowJsl4Q5elXzSj70grqjedeBPWLCp1Y5LTjjcR0eyG8jLRGlbVd4Vu23Nf
	 YJdHvATMSYoQvIH3I3qdggWwF810Vphgh9/O3hqP62RFyfvyOkoNrF+S3OT3Xuh5De
	 ySq22P/v0mLIw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9F223809A90;
	Thu, 23 Apr 2026 19:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] m68k: mvme147: Make me the maintainer
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177697142055.724716.5140307398411201203.git-patchwork-notify@kernel.org>
Date: Thu, 23 Apr 2026 19:10:20 +0000
References: <20260422132710.2855826-1-daniel@thingy.jp>
In-Reply-To: <20260422132710.2855826-1-daniel@thingy.jp>
To: Daniel Palmer <daniel@thingy.jp>
Cc: andrew+netdev@lunn.ch, geert@linux-m68k.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Apr 2026 22:27:10 +0900 you wrote:
> I'm actively using mainline + patches on this board as a bootloader
> for another VME board and as a terminal server using a multiport
> serial board in the same VME backplane. I even have mainline u-boot
> on real EPROMs.
> 
> Make me the maintainer of its ethernet, scsi and arch code so I get
> an email before one or more of them get deleted.
> 
> [...]

Here is the summary with links:
  - m68k: mvme147: Make me the maintainer
    https://git.kernel.org/netdev/net/c/7256eb3e0909

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


