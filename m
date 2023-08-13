Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA26C001DB
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Aug 2023 17:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjHMRIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Aug 2023 13:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjHMRIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Aug 2023 13:08:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C02EE6A;
        Sun, 13 Aug 2023 10:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D640E60BEF;
        Sun, 13 Aug 2023 17:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49732C433C7;
        Sun, 13 Aug 2023 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691946498;
        bh=vqzRzGsD+4lAuXPcijag3Op+Qq4bwE8BJXX+RMXxy/I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qErN6LItMhUD3aoJJdII/0dIBujdofMtFHCblin5xUc8+uu10GTawIWurRmZ/OqYk
         8vPJmlZukCYPO8Vey800eZdD7spo4cIjvFxZWxgGWQEzYP1WWZKVH+pRFpw4ftjM9Z
         reQdjYxpMPeMC6LMRlzXUnDmeGG0WlZ63X9ZOQ4tEznyJ1EIyJHvbqBLs+1uQhBjqx
         JY3KBP1NCo9tmVnIkGDzrRAyMnns9pH3rP+aFlB9QGHT/z0RtfsaY6XuOnhHUNSBuG
         WjoiD6xyDL4XkYzVOC73Ma34ZhYe12TaGVwtEzaGMnoBqXMcvuzQdimcuycrcWVMqE
         LD2m3gEM/eLbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36A80C39562;
        Sun, 13 Aug 2023 17:08:18 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.5-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <4987ff9fa2467bc036759afac47b95c77a415963.camel@HansenPartnership.com>
References: <4987ff9fa2467bc036759afac47b95c77a415963.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <4987ff9fa2467bc036759afac47b95c77a415963.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: ef222f551e7c4e2008fc442ffc9edcd1a7fd8f63
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7308e92756d5891d58e7bcae01a516514583921d
Message-Id: <169194649821.27578.9594304586335451768.pr-tracker-bot@kernel.org>
Date:   Sun, 13 Aug 2023 17:08:18 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 12 Aug 2023 07:45:11 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7308e92756d5891d58e7bcae01a516514583921d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
