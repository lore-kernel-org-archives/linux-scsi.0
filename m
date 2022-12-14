Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86ACC4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 18:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239299AbiLNSFw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 13:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239286AbiLNSF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 13:05:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E7828E39;
        Wed, 14 Dec 2022 10:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E17B61B66;
        Wed, 14 Dec 2022 18:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1127C433D2;
        Wed, 14 Dec 2022 18:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671041080;
        bh=6LDCGolDwZ8alpXMtS3bCYGOIj3nKnVNbso3r+MjeBI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=FkupPgeVv+OQffKEWVzvzwPjHq7bB8/BBH0VTknN4zkgIETDsk1YQcQWZT0++iZkn
         wjXtu3gov83ZlVu/s/6jGdu+W7/QADs7JEZ2CqraWrwSuvxlVILkwuUefuxKv1q9gl
         V7oHmAsT1pgnqd28cQPy8ZGJVHIrLb5Qu2qiNfkfSafVt5VEVdQoVqIUJGh7Zn1qH4
         usLl0dlNYvV0qG1Nq31YG4a4VBuMsQswPDnTVA0vyURr/+reebnTNsOfZeRk6JEyhx
         Y+Jo4IfAuezlMcRH17/avpM6rHveu3JRWfRO48Bw44CMwGE+VTM6IWQKZWG1LxtY1n
         pSyxb3d9vb/9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B00AFC41612;
        Wed, 14 Dec 2022 18:04:40 +0000 (UTC)
Subject: Re: [GIT PULL] first round of SCSI updates for the 6.1+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b2e824bbd1e40da64d2d01657f2f7a67b98919fb.camel@HansenPartnership.com>
References: <b2e824bbd1e40da64d2d01657f2f7a67b98919fb.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <b2e824bbd1e40da64d2d01657f2f7a67b98919fb.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 4e80eef45ad775a54fb06a66bf8267a154781ce5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aa5ad10f6cca6d42f3fef6cb862e03b220ea19a6
Message-Id: <167104108071.17244.15947057902300430122.pr-tracker-bot@kernel.org>
Date:   Wed, 14 Dec 2022 18:04:40 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Tue, 13 Dec 2022 15:45:55 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aa5ad10f6cca6d42f3fef6cb862e03b220ea19a6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
