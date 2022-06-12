Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3539AC43334
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jun 2022 00:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiFLAdo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jun 2022 20:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbiFLAdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jun 2022 20:33:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CBB3DDF2;
        Sat, 11 Jun 2022 17:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9165EB80B73;
        Sun, 12 Jun 2022 00:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47B9EC3411C;
        Sun, 12 Jun 2022 00:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654994020;
        bh=buLTWx2Jh9iWTHCfilb1zuCO9rv7g/ztJ2zF9KV26Hw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Sc+aJv2j0PK3025YGnyjCsF7b2ZczdN5/ADvN/9s22lj1v95zS3SrHhwJ1gvMHbZS
         s/Zv49h6oH5boA84mWp/u1dfWWd2zSW9ZMvh1uonG4DB+6RR6jo5eefTgz22x6zXg+
         RFheFxJFQKDV2rrGtzeDQ6srepomz652H3vnf9NATkHRQwDpk+4oNlTtnHCpC/IDTg
         EnZKV61Vc+ZPCM7FPeUSZaUf5PtO6Iyys2GYTlG4/mDmzRlSVvsmgQkVY7lhnfu5cc
         oywwS0zdcuTPaxuYt377qWa6E92aoBfUgR4Ys1iBRSmSMLIoTcUGEL5PWOK1jb+P4M
         D0/HypsCemfTQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2F392E737F4;
        Sun, 12 Jun 2022 00:33:40 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 5.19-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <7373802fc26a9a41b2dd4f5c05f993f574365029.camel@HansenPartnership.com>
References: <7373802fc26a9a41b2dd4f5c05f993f574365029.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <7373802fc26a9a41b2dd4f5c05f993f574365029.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: ec1e8adcbdf661c57c395bca342945f4f815add7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cecb3540b89ef2b586d07c1bd69408e251791b76
Message-Id: <165499402018.23172.11406827094090410009.pr-tracker-bot@kernel.org>
Date:   Sun, 12 Jun 2022 00:33:40 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 11 Jun 2022 08:22:17 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cecb3540b89ef2b586d07c1bd69408e251791b76

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
