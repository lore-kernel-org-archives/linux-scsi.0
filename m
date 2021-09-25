Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EABBC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 23:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 719296108E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 23:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhIYXWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 19:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhIYXWY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 19:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C0026108C;
        Sat, 25 Sep 2021 23:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632612049;
        bh=47NnYeZFjmSkQxOSxLb5cLKg+taEPG7aQKpVNpTrT0c=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=M4Zi5Yu8jjGtCcWw8jvcTtu+ysO9IQ+ET5B+DlFCn9mcYqAiwnjkWRAUR1mXAPSdl
         jvBESnw8uMatKGzMXedLrx22Htv+IrWV2hYtWWgP8Y8v9/9mirq1INRFvsZVWDnhHT
         hJnRXjUmv2LKThUUkoA+QvAtsKr+xZkXn7jE40PIneMTp5PPdbdgbXLsxsJoAcVRsX
         fNpdIlcoepzYJPKf+Mzd7X8OdpJGk3tTuM8TB1q5RZuXMnPk/Hq7r1w34TJAes7AGx
         13vHkURv7g1idDf0bZAsIhzDKhyE6TpKIiKyDNyi2Wh4GN5SnZ9SguwzPzXQrSs3Rg
         G4nueFuVd9fuQ==
Subject: Re: [GIT PULL] SCSI fixes for 5.15-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <790cc5690c18cf5216bc01662cd528004402081b.camel@HansenPartnership.com>
References: <790cc5690c18cf5216bc01662cd528004402081b.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <790cc5690c18cf5216bc01662cd528004402081b.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: fbdac19e642899455b4e64c63aafe2325df7aafa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bb19237bf6eb760802bf28d9274e1af1ef1b84e2
Message-Id: <163261204904.10172.11273672700654579290.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Sep 2021 23:20:49 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 25 Sep 2021 15:00:16 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bb19237bf6eb760802bf28d9274e1af1ef1b84e2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
