Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D79CC6FD1D
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 17:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCQRjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Mar 2023 13:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjCQRjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2023 13:39:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7E5BE;
        Fri, 17 Mar 2023 10:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EA6160AAD;
        Fri, 17 Mar 2023 17:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88A1AC4339B;
        Fri, 17 Mar 2023 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679074732;
        bh=2V4F1CyRZqIf+kESmVtK1KFtQOH0/dMcHiPUA1zTwYQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=kLs4uXxSc0fW+4x2Ue36WT8aAYlKzi9df4SQaGM13CdpTDib0j+rSL4nImS1QSXNo
         r8vHFjiR+KxGTf7K9XgJupRxP0QrBbBJ1TPWI0psPqhJtlINDRtd9Q9MnkaTBCMN+j
         q9eCNwJ1kYvI3ZOjn8XdmrJhzQlR4A6iUOvbNrwFw9XdyyV/iTHcCcA7uEoJCYzd8H
         djPhSHv6Yy897WuBxF1vVM1xUJlSXdaRb1rWSxebCDSfkbCZ42LHOgIh39VusGFstp
         cJXH3P9kjSsAJ8snefWqxmvCWeiOd7fpLNcFVXe4STt/ckqimHAM5RAYl969GZKsEa
         w1gjKkgY5CTTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76817C43161;
        Fri, 17 Mar 2023 17:38:52 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.3-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <38f463c2d76c3edceaebbfd777e086798eec525d.camel@HansenPartnership.com>
References: <38f463c2d76c3edceaebbfd777e086798eec525d.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <38f463c2d76c3edceaebbfd777e086798eec525d.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: c6001025d53ab56d7159cf313313c6b5bd250380
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7622976c8f4f233fac251263e08adee27969abcd
Message-Id: <167907473248.9394.6705023645713932924.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Mar 2023 17:38:52 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Thu, 16 Mar 2023 22:58:46 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7622976c8f4f233fac251263e08adee27969abcd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
