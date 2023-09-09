Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26245EE14C3
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Sep 2023 19:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242760AbjIITJx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Sep 2023 15:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbjIITJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Sep 2023 15:09:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B052E1A8;
        Sat,  9 Sep 2023 12:09:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57E17C433C7;
        Sat,  9 Sep 2023 19:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694286586;
        bh=nAsGVx32mqfYa1CG8elemlFNk3pd6vI3NNZ+Pb7sdeI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=m2U3x+14jXKg79zC3FMosVtz3QgVinKeagMgJDnRVvy4UXEMMhDc0FYSQ+GFo5M3C
         U4ovMYH1evjlWL7rMLyihGWU4aOwUoozfCMHMHiXsNKbjNc5LvSyKbCX4saZwuaODr
         joVWxLi9KaofSK2YLPmX0VhUKV7fVlQTSnyFR67nDE2AODWr7lVm1mjF9sSZB/Squ/
         Wz+F7q3lPghl6CTGH+CVLGe+WPw39gBVf+9yxaNxfahVPEgiRmEHwn+rX/qWaIqpYm
         lyCIlxlVllG5Z3Et3rULxK5W/xZYx7pj9+Oqb4cyDfuucUwpWqI6bRgBCXE11PTLI/
         xMpIREkFFyAGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43884E22AFC;
        Sat,  9 Sep 2023 19:09:46 +0000 (UTC)
Subject: Re: [GIT PULL] final round of SCSI updates for the 6.5+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <285d43b9cbe7bc2b9aaa8537345f14aeec93c982.camel@HansenPartnership.com>
References: <285d43b9cbe7bc2b9aaa8537345f14aeec93c982.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <285d43b9cbe7bc2b9aaa8537345f14aeec93c982.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 9f6fec65661381e301ae0f9ee8b4c12b0214a579
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2a5a4326e58339a26cd1510259e7310b8c0980ff
Message-Id: <169428658626.22338.9113772074168776903.pr-tracker-bot@kernel.org>
Date:   Sat, 09 Sep 2023 19:09:46 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 09 Sep 2023 10:47:26 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2a5a4326e58339a26cd1510259e7310b8c0980ff

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
