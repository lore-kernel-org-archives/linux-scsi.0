Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE486C4708E
	for <linux-scsi@archiver.kernel.org>; Sat, 29 May 2021 00:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B246F613F0
	for <linux-scsi@archiver.kernel.org>; Sat, 29 May 2021 00:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhE2Awi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 20:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhE2Awh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 May 2021 20:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE40F613F9;
        Sat, 29 May 2021 00:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622249462;
        bh=wiw9q3+IDlVsUDyQBfgSyA13jwm/K45CLwX4fNsw50o=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=CY7XdAj72/8VltAqX6ZuW70WZ0Tk/stQT7XGyWF7Un9+zY5S22IbK6w4HfTb7KbG6
         4AFZcSXMHUruMpuQCGhFshWh90Dkt3VPx8hRtDwhyhqOBQ9J+DAW8iktRJQYiIRRl9
         DhlIDKDQQCh6DfVQOdHxKGYWkLG3ipY7/E0dXTr98ZmCw6flBshaYDsNJexBmtJvmF
         GAgANZuWnWr2sJA3uhPs1PqXDrXj/HQ1FUcYfKZZ4eGxtbVrIPtOY0VuRoEdboaCSq
         UOUnntbp3AEfI7nNVv+53DXIa93/ZTvsTM+m0nSQL5SVzq1ufi/L+mnC9u2zvG4wpi
         5C1HUp0oPQM6Q==
Subject: Re: [GIT PULL] SCSI fixes for 5.13-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <153a81f4d08a49071194ce7d626a8fe8e71f17b5.camel@HansenPartnership.com>
References: <153a81f4d08a49071194ce7d626a8fe8e71f17b5.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <153a81f4d08a49071194ce7d626a8fe8e71f17b5.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 2ef7665dfd88830f15415ba007c7c9a46be7acd8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6799d4f2da496cab9b3fd26283a8ce3639b1a88d
Message-Id: <162224946194.17808.4451144014209633397.pr-tracker-bot@kernel.org>
Date:   Sat, 29 May 2021 00:51:01 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 28 May 2021 16:42:57 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6799d4f2da496cab9b3fd26283a8ce3639b1a88d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
