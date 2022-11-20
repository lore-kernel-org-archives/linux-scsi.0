Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADC6C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Nov 2022 00:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiKTAJt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Nov 2022 19:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiKTAJr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Nov 2022 19:09:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D083A12AF1;
        Sat, 19 Nov 2022 16:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8341FB80AAF;
        Sun, 20 Nov 2022 00:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45B4FC433C1;
        Sun, 20 Nov 2022 00:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668902984;
        bh=wEY5QmZllUoh8oYz2Okd5Ilfw9trI6cEN4b5niSJA+A=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dywNfTDS1upGrBExe1RAFmGfwB95DqjuE6UAnR+Z0/TqCtrfJ6luFRACh0NEc2bX5
         Wx7N6Y81PR/PyH0Gg1BdrwLSWdMVtHoc4rNPVvBy4r71pIpNM7HHPzhxcaTE43EmzK
         WYjS2kdmoW/TISauhAYYl+rd8lpsIHfHfZOZVrYIG0fV1MRarm2A6QdXJWJGzTM2OX
         Q4J6nfWRHxzGiI9pApfMjyujIyWhWO5vWFQgXDU+JT9A7Q107pEon8Bge3ukFbAHKK
         JzvtJ1EkGK3VWDSHjwdHW4m9ELSGy/KZEas+phFqK8vQ87XjB9KDzkIgbelHAHJdF9
         ryZtunCN9dPsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34832C395F6;
        Sun, 20 Nov 2022 00:09:44 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.0-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1034ecdfe7c4c07a45b5b59f21c3be2a7c0c1642.camel@HansenPartnership.com>
References: <1034ecdfe7c4c07a45b5b59f21c3be2a7c0c1642.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <1034ecdfe7c4c07a45b5b59f21c3be2a7c0c1642.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: f014165faa7b953b81dcbf18835936e5f8d01f2a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 77c51ba552a1c4f73228766e43ae37c4101b3758
Message-Id: <166890298420.9575.6621059630033636848.pr-tracker-bot@kernel.org>
Date:   Sun, 20 Nov 2022 00:09:44 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 19 Nov 2022 17:47:02 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/77c51ba552a1c4f73228766e43ae37c4101b3758

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
