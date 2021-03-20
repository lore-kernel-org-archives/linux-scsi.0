Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16EEFC433C1
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 18:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC1AF61944
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 18:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhCTSGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 14:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhCTSGZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 Mar 2021 14:06:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F40161944;
        Sat, 20 Mar 2021 18:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616263585;
        bh=VkpKXK3pi6O79Mj26B+jxmkQNW1Q7aYAIuqrB1jhEag=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KYmWf6BkXjAeWXxmUgR8kxrl1DG8+wlKVdHMkYllz57rMdKqBQW2ZvEVuyg0GWz/G
         nLGXjykdWxx+GcoOFgOYxSJbAtuxvZkhsnwiKFYNgDytmLHti272pOoQOJAVn4Vg0F
         wgnRSpB8Zu73CbmkCkDsVbtc8nO1IQ7o0iU2fdOwe45pjul8DZythNIFP4c+UG3ITZ
         EkI2JyFt+4ZKyuIvExnZTEeXzIA3Ik6y2ioaullwpB3PnQc61IIwoMD2COjp6rqPOe
         QxqkN/avSJe2xhhn5kYB8y4tWdHjZH7VvI7FpWpC0pA/5Q3QJiqMnOsVAEJ13RgeHB
         y5wk3P/tlL6PQ==
Subject: Re: [GIT PULL] SCSI fixes for 5.12-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <04bf2656fe347fa20b3d6599c18322426720b084.camel@HansenPartnership.com>
References: <04bf2656fe347fa20b3d6599c18322426720b084.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <04bf2656fe347fa20b3d6599c18322426720b084.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: a50bd64616907ed126ffbdbaa06c5ce708c4a404
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: af97713dff9f877922af35f0796e1d76b8a4be00
Message-Id: <161626358516.25184.6388468735282244373.pr-tracker-bot@kernel.org>
Date:   Sat, 20 Mar 2021 18:06:25 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 20 Mar 2021 09:48:46 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/af97713dff9f877922af35f0796e1d76b8a4be00

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
