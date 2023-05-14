Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B68CC77B7F
	for <linux-scsi@archiver.kernel.org>; Sun, 14 May 2023 00:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjENAwa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 May 2023 20:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjENAw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 May 2023 20:52:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC891FCA;
        Sat, 13 May 2023 17:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C80861521;
        Sun, 14 May 2023 00:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6229C433D2;
        Sun, 14 May 2023 00:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684025547;
        bh=cN2hVIYAzF6Pg3x/6zbOnEmv435VnqMmnsdXUTMtHyE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=DSz9sHzF2VsR7PKlOrdLnU21WlVkGDSfKrCXLaGgQutZ1RKIKz8xnCMDxriJk6CIp
         2yyjviaYFL0lzjij/iAIp7TbIP/VcWJtFHmkqXe/B67c0p/4d+cxVF/CAcW9xpraYk
         XLGarbOkVGEDeCIXVnRzaab+9KqwC/Gu2Dill6Ql09QXhETd+w5/v6Ov5zh8dopC4G
         Wv1hG6kuF+LaBrcsSypSkQ1s8JDlotPI4vA80BQDtaPIsXftYKu1vnVcLn2f/FbwMG
         BTAxk6pejK4qfImGcRxCpSKrU2RW1vttG+LE3S7W5RBxYhTGGepxu3KzCgMsd4wnor
         gSaySXuCdloDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4434E450BA;
        Sun, 14 May 2023 00:52:27 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.4-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <8742c73168b7be3fb8dd841e57656bcbc4fa2e06.camel@HansenPartnership.com>
References: <8742c73168b7be3fb8dd841e57656bcbc4fa2e06.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <8742c73168b7be3fb8dd841e57656bcbc4fa2e06.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 1a7edd041f2d252f251523ba3f2eaead076a8f8d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 046206bad0f6a886e1f890c5fcb106d596971c95
Message-Id: <168402554766.23680.6927617106719367532.pr-tracker-bot@kernel.org>
Date:   Sun, 14 May 2023 00:52:27 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 13 May 2023 19:24:24 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/046206bad0f6a886e1f890c5fcb106d596971c95

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
