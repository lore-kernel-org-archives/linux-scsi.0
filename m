Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB50AC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Apr 2022 20:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbiDPUpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Apr 2022 16:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiDPUpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Apr 2022 16:45:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5ADBBF03D;
        Sat, 16 Apr 2022 13:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BCEC60FED;
        Sat, 16 Apr 2022 20:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA5F0C385A9;
        Sat, 16 Apr 2022 20:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650141777;
        bh=SGsEuW+QJiVoYo/YwITEbIz5a+BKHuij2pWyk7nT9o8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=W+FB1ozddhv8I2dpkrQ/xMGYs9uisMtaHrVrf7owaqSDhNqG3qetyO+E0Cn8djX8c
         +ZlMr85zaAJIk2qkIP/1q45lD/1iwSzFB7hgU7es8hw8TcoAqoFveHHjTIFuDIF4xM
         +y7tpnAD1OSey8SaDBnjb+2jL4kWMDEbJDfpJ+0wz7xEdqsyKpfKXCYVAB3x5jKyhZ
         OyYO6bK5J9XKuVmhbiqDxHIafCeYkDnQuNMzF8karaWq/Nlca6tRRb8IbH3HtWx2V1
         SUAWCkcZFpfv+CnqS7VvILUzcUg53zETSL8nSw7qcQXOwxp0uUYVrvb55qxXin9jLf
         PcHP8WD36xqew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92E60E8DD67;
        Sat, 16 Apr 2022 20:42:57 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 5.18-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <de511417b27da4a438e60af851d5bf2c4210a969.camel@HansenPartnership.com>
References: <de511417b27da4a438e60af851d5bf2c4210a969.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <de511417b27da4a438e60af851d5bf2c4210a969.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 70a3baeec4e89736be932a60d682d7ae27556f5c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 90ea17a9e27b5778ec517efb1ce0b81d36905654
Message-Id: <165014177759.10681.4916690426551865381.pr-tracker-bot@kernel.org>
Date:   Sat, 16 Apr 2022 20:42:57 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 16 Apr 2022 16:06:01 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/90ea17a9e27b5778ec517efb1ce0b81d36905654

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
