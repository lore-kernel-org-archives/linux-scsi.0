Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD094C6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 23:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjC3XYw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Mar 2023 19:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbjC3XYs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2023 19:24:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1361731;
        Thu, 30 Mar 2023 16:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50103B82A8C;
        Thu, 30 Mar 2023 23:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F32D0C433EF;
        Thu, 30 Mar 2023 23:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680218685;
        bh=xhoF1SPQEfJJvN0uoAUt0XwQcwHzfa3zZhVschzDLoo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=NefhqJKZtAGwYACyGOlU4oRAUESuuskpGcN4Cfx3JSlwqhpIqWjTsRnQ9aP3dnF3z
         s2Qw7YOganh6YMr6KiYE+siFRvdTCfHLaVUghEE0K6MH8TeCxMWwI563mDAyGgXo8R
         3g2m+JmuYGbXEzOXlghBxNHJRoBXiEKlXVar5He6jrRNUZcXYDD7e165O/yLKapJ48
         QgEXZqpAiLR+rmzsNGKiNhAmQgbXPzFSkr8UgIEXfsT5Qo/xHOqTqWHIoQxx53c4xl
         cj1Kxan4WqkXSBEs3acBpH3ntjoI+E9tMLkfK48HFWhR8Ixq4qS0BdG9iofvoAKza5
         qQ2RWO86+UROw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E10F1E49FA7;
        Thu, 30 Mar 2023 23:24:44 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.3-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <99b73ddcbca9be5d0295242edffd11def69c1db7.camel@HansenPartnership.com>
References: <99b73ddcbca9be5d0295242edffd11def69c1db7.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <99b73ddcbca9be5d0295242edffd11def69c1db7.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: d684a7a26f7d2c7122a4581ac966ed64e88fb29c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 10f76dc3abb4d8fbc2cee7a63fda22e8b08628b2
Message-Id: <168021868490.13292.11978039788600420009.pr-tracker-bot@kernel.org>
Date:   Thu, 30 Mar 2023 23:24:44 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Thu, 30 Mar 2023 18:41:04 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/10f76dc3abb4d8fbc2cee7a63fda22e8b08628b2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
