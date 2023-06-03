Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C14FC77B73
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Jun 2023 18:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjFCSNM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Jun 2023 14:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjFCSNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jun 2023 14:13:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1368C91;
        Sat,  3 Jun 2023 11:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A42AD61715;
        Sat,  3 Jun 2023 18:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12D42C433EF;
        Sat,  3 Jun 2023 18:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685815989;
        bh=BaLdbUDwszNFoR+RoJcfTMCqQGxzkVQRDhyLXhSmqdQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qJC1EV5Qaw9GYPBkTCjWYyzPfqmn2u50FDyKfTzi9flzfJwc6wcQgrJ8NV/f7kB8R
         hR+tB06ZfcLadbfJSuxhm1tX9ifeM9zfL5Csuk5gBfVPvXecYBCfFhQMq1rJx6tBjU
         0c8ZoOPAwBW4pQHRgGwep6rJm4UvMsHqho4uT2mNYpWspS7brsA2S3AoutZd4i/Epu
         RkA5zuO47MGWIJHKpOEhgHhRlUy/ExSytBnjfyUDr6auEPRhz94BLHk/kOh/NyNCTs
         aXDgHexyCBz+k+t8l4mxFtt4ce4pUR1kkjwV8xjvVEQUlDwnqIXibbLpNbN7K5J5SD
         bRfUeuZ8KIZEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2C39C395E0;
        Sat,  3 Jun 2023 18:13:08 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.4-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b4e84e8564b86822ec4dab6ba85995888df20991.camel@HansenPartnership.com>
References: <b4e84e8564b86822ec4dab6ba85995888df20991.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <b4e84e8564b86822ec4dab6ba85995888df20991.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 6d074ce231772c66e648a61f6bd2245e7129d1f5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e5282a7d8f6b604f2bb6a06457734b8cf1e2f8f2
Message-Id: <168581598898.28460.4174809796768994968.pr-tracker-bot@kernel.org>
Date:   Sat, 03 Jun 2023 18:13:08 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 03 Jun 2023 13:43:28 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e5282a7d8f6b604f2bb6a06457734b8cf1e2f8f2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
