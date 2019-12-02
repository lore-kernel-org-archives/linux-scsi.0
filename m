Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F828C432C0
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 22:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 704D320718
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 22:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575324020;
	bh=k8+SDxX9kGEptUcXG3gEO9LKgA6Uyu1kIkLdeQF0DT4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=nqWtvB/6xcA7dO7sdv9JniJA8jp0OXzaxi/RYYsta00V21faHvhWU9tqjuurIj394
	 Uy/nGXdaPCk6IzG03RraP755u8VvEo/buJOfXSlzDG7or9hz2r1oIiwyRPLdc9xSxw
	 Rb4ZpJrhDltGyoiZQATlFM6pnJ9YtYiZrfYt66bk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfLBWAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 17:00:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfLBWAU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Dec 2019 17:00:20 -0500
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.4+ merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575324019;
        bh=k8+SDxX9kGEptUcXG3gEO9LKgA6Uyu1kIkLdeQF0DT4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=RHi22AnyS1slPew+xX133jHz3HaKqx9OdpG6xGQ1Yf7zpWJXCypPsnqSLKsYAToqS
         JoSd3WFKdI1XdiogDoFIbqUhvaCzVXXifWiEKn04LOQ4ISvsuWpSOkpI0a7KBjwOM4
         LPCrkWBTtMVS+hNgvJ+WtIvOJaBPsqr9Yu68/ujE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1575137443.5563.18.camel@HansenPartnership.com>
References: <1575137443.5563.18.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1575137443.5563.18.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 65309ef6b258f5a7b57c1033a82ba2aba5c434cc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
Message-Id: <157532401952.14732.8852773500235286817.pr-tracker-bot@kernel.org>
Date:   Mon, 02 Dec 2019 22:00:19 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 30 Nov 2019 10:10:43 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef2cc88e2a205b8a11a19e78db63a70d3728cdf5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
