Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85346C07E95
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 22:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E6B661416
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 22:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhGBWkI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 18:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229847AbhGBWkI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Jul 2021 18:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4BEF8613DD;
        Fri,  2 Jul 2021 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625265455;
        bh=FxGp8BLLF23wyYPze/F4ar6AiPJPJ/mIwGIR/lhcCaE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=nJNRRTf+c9b3pMSaWwFoHYJnz2eUMwZhVs7qCPu7yYxff6txZrWfudENiaaxiI//l
         +VMuYAfT1i7YjG78Kc6Tn+IgeGSwPHkSL3h8+PnS/a7uOBNLXa+Hcm56oFirQxE9YB
         YEnlimWcNtkuWEv1U+oeQ1wPAM1fUzdPEQ6+kAf6H4+RkWumkfH5vazZoXL/eeuWfF
         qDhnZVUBsK84Ha4baSkSKNc+afKUOOqwjYeCcIzbp9nEPlRg/10IxMzKqQN3nOBV8J
         EEXR3JT0/xd+KUrnqb5/6mydxkjCiLmb6/zVMpIwCJyXpH+KGwuTZcnA/QejXPQzwH
         iTAh/XrPmzKyg==
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.13+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <e118d4b2fb924156f791564483336e7125276c47.camel@HansenPartnership.com>
References: <e118d4b2fb924156f791564483336e7125276c47.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <e118d4b2fb924156f791564483336e7125276c47.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 041761f4a4db662e38b4ae9d510b8beb24c7d4b6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bd31b9efbf549d9630bf2f269a3a56dcb29fcac1
Message-Id: <162526545516.21733.11922753738856768647.pr-tracker-bot@kernel.org>
Date:   Fri, 02 Jul 2021 22:37:35 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 02 Jul 2021 09:11:40 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bd31b9efbf549d9630bf2f269a3a56dcb29fcac1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
