Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04415C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Mar 2022 02:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357938AbiCYCsl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Mar 2022 22:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357858AbiCYCsj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2022 22:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84172BD7FB;
        Thu, 24 Mar 2022 19:47:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3518FB81D87;
        Fri, 25 Mar 2022 02:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB455C340EC;
        Fri, 25 Mar 2022 02:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648176424;
        bh=v6I8LKNs4Kzsl1iPIjxtvjiP2esmi1kTT1OtF9gAxRs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Ah3vA0Vk9cFns/NYWFBNmD9w74IuWILmyCQpiFx2DVQPkr4e8MRZfM7aJaBttRaMk
         edXcm5lu5slhbdCHrKCRFKnG8OE6zyLhtpxcRSihueSDQbcH48OPModEfjAYbDbeqJ
         IRdILxFqkxCmdYkf/tIsfd3VW/FDJLH5X169w1X+0+jMGPyrT6OOw3bG35ZxwfNbWP
         G7u72KHF65D7sEOHariKNCr+MLF3UwROQL7aXqCuoJ/TMlutQe6MZX1zBVTDBOmskt
         4BQGhD/G8R9z6SuDW0nqTdmEj8iCAHslIo9XplgPHzuwrT6sAEqgd1kXoY7c+Q4Q/F
         hBC5/czwSongA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D731DE6D44B;
        Fri, 25 Mar 2022 02:47:03 +0000 (UTC)
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.15+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <29544a7c36504c42ca7e1fd9e6a29d68a47f6811.camel@HansenPartnership.com>
References: <29544a7c36504c42ca7e1fd9e6a29d68a47f6811.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <29544a7c36504c42ca7e1fd9e6a29d68a47f6811.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 66daf3e6b9936328cb28eaaa29dddfe96343cc85
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6f2689a7662809ff39f2b24e452d11569c21ea2f
Message-Id: <164817642387.17034.13874819766630585150.pr-tracker-bot@kernel.org>
Date:   Fri, 25 Mar 2022 02:47:03 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Thu, 24 Mar 2022 15:24:23 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6f2689a7662809ff39f2b24e452d11569c21ea2f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
