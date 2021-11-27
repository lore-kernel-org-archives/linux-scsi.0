Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720BEC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 19:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239671AbhK0Twf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 14:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbhK0Tud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 14:50:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0ECC061574;
        Sat, 27 Nov 2021 11:47:19 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15060B80936;
        Sat, 27 Nov 2021 19:47:17 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id A0E4160174;
        Sat, 27 Nov 2021 19:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638042435;
        bh=i/hUkuUd5W/6Mdtj9LCJ/EVBa0j7WQYyzULjC3OLsDM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ISVpzA4s74YMAEeeVAWgrbR4gJ9oHZ8r+7jQBK7FVar7UHte90BZYjAQIsT4/S8V8
         OAAQn54Sb0Ywi2h3pcHrMnjVlZe1UEsNrz+s+4qbpt9L97LX+TZEpGF2RIpQLi1tGR
         MtzEYUvOXIwjLwE40QSazXUiNk3/xWgmNDbaFaIYHTBwWNOClhkGKA6qDis+9BUIuq
         6jMQ45qgTsVLZwFYLF8wo9+C6XGqGUbESjrwcOI6LTpSXknBJhCc+vmUct9Wh2QqOG
         fR6ciydW4jOEh2ZQLOViEFgDCpCOjU+tl7S+9HcMajz2ZhMsa9J7SeU2riONZ6idBt
         ntwwwNH1fKQ3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88A3E608AF;
        Sat, 27 Nov 2021 19:47:15 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 5.16-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <88066061f5f16e91cdfe2a5794b0a8b533909787.camel@HansenPartnership.com>
References: <88066061f5f16e91cdfe2a5794b0a8b533909787.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <88066061f5f16e91cdfe2a5794b0a8b533909787.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 2d62253eb1b60f4ce8b39125eee282739b519297
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9e9fbe44bef986fffb514656e5842c341528c8d4
Message-Id: <163804243549.4525.3591852979552995850.pr-tracker-bot@kernel.org>
Date:   Sat, 27 Nov 2021 19:47:15 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 27 Nov 2021 09:11:20 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9e9fbe44bef986fffb514656e5842c341528c8d4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
