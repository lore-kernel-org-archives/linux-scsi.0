Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD44C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Oct 2021 19:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09A5161AF7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Oct 2021 19:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhJBT7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Oct 2021 15:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhJBT7a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 Oct 2021 15:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A532161AF7;
        Sat,  2 Oct 2021 19:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633204664;
        bh=mGxaZWhrtgGTBc1B2xoQ/yrhdLUeZ19Bf+OBA0dk95c=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Q6bYKPQQLErDkTSceO+jnParsWR0ZZmcPrH8Wb9HOXDakQ1LtO7luFKP1trs2HRvw
         +K+mly7KQQVkFO2nH5skvDJQaXETFzK8co6gnFb7E2rGoGt88Twgebap46KQVxTPiJ
         pZMwsUI7LApTPIMfmX6gAnHehOHxMCMMmRtcVBN47pcWlQL3JpAGv5Pm3k62KQN/j3
         0ZIhz5Y1AyC+kuG5I4A6/p3QgL3zoPtNhtOgnmo4kLKeapIUk5dQker+WeaW9R++Ot
         ahtOxhCss5qW5SUJP7hIuqB5EcC6KqrUACaPEWVgvjTA/ijKRPdTRSItQVmZdlX6za
         oVyHgVbJ+Jm/Q==
Subject: Re: [GIT PULL] SCSI fixes for 5.15-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <e75a06121ea5b2934045c6c71943babba7f3f390.camel@HansenPartnership.com>
References: <e75a06121ea5b2934045c6c71943babba7f3f390.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <e75a06121ea5b2934045c6c71943babba7f3f390.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 79a7482249a7353bc86aff8127954d5febf02472
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9904468fb0b72a59a10753a86ce121fbdd2e9b3d
Message-Id: <163320466455.29445.11970975694880563452.pr-tracker-bot@kernel.org>
Date:   Sat, 02 Oct 2021 19:57:44 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 02 Oct 2021 12:07:34 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9904468fb0b72a59a10753a86ce121fbdd2e9b3d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
