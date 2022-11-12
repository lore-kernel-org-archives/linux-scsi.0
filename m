Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD73C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Nov 2022 17:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbiKLRmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Nov 2022 12:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiKLRml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2022 12:42:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A47711A3A;
        Sat, 12 Nov 2022 09:42:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3425A60D38;
        Sat, 12 Nov 2022 17:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97A94C433C1;
        Sat, 12 Nov 2022 17:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668274959;
        bh=LoGoU/mN3+jE+RZnBTtTnhNpqkXse6sXyM9vcyeG/VI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Vg5xGRvPH0xQdnhj3wf4bR3g+wf6x5JNeKeVE30Bv/hxULdsG9yi0iAbsRN35n5Vj
         r2oZvVRygqoI62k4WSuPE563Qa0z0uASANvAzeeGHFZZTvMBC1N4jS2v4LHZcCfh7J
         7sAIMvgtYBIMCW8kkDPlwWa7MzQHzVEchbs1u+MxGm24fSSnwQdOqXBsZG1C61QV8d
         WGAPQyc42FgEEt3T5T2yRvKt+JtT+gUS74HV7/RM1S+d1fjlafcLlw0q3d1pp6D5P9
         YWQ1wlucvwRWJihsHCS9+g7Gh07lykmdVF7VfWlsLZ8vjSOT4wBAAs3GcqzEDJMUAC
         +YqtedZaSbLZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81B85E270C6;
        Sat, 12 Nov 2022 17:42:39 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.0-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <d70b92ce5eb5b50b1a0975e8b3b21b9f48809ad8.camel@HansenPartnership.com>
References: <d70b92ce5eb5b50b1a0975e8b3b21b9f48809ad8.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <d70b92ce5eb5b50b1a0975e8b3b21b9f48809ad8.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: ecb8c2580d37dbb641451049376d80c8afaa387f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fef7fd48922d11b22620e19f9c9101647bfe943d
Message-Id: <166827495952.17539.355793184683159519.pr-tracker-bot@kernel.org>
Date:   Sat, 12 Nov 2022 17:42:39 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 12 Nov 2022 10:02:40 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fef7fd48922d11b22620e19f9c9101647bfe943d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
