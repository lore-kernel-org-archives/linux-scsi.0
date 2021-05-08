Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2129FC433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  8 May 2021 17:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA60D610FA
	for <linux-scsi@archiver.kernel.org>; Sat,  8 May 2021 17:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhEHRrp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 May 2021 13:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHRro (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 8 May 2021 13:47:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C633D61415;
        Sat,  8 May 2021 17:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620496002;
        bh=fp3LsZZKgc/xgNnns3feGZY5xwxgBJQx3LZxIgaVA4c=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=udGeCy353tooa0zVv1HsLuI9mzSrRzo8rIHqGB5wgUdu8OBUS7dHsC1xrr3hk4MTS
         M0Tdd8JatYf0CEnClav61QHuzUtiboZGJiCS7o/djoZq0pSnZ0NOB98yHnOfj5/9KX
         D9lwfok9VuCr9gguA2RlL7dnzHtGnKY9pxg+Et+r2PQitTzIKi32OLe7fQl+yVfAXU
         Dg2JBsixEbTPrIWhEiDI/qWg3wBHi2DC0YP+H1L4XzwhWABEcXaMXGexXdqSX2YDfs
         teBNilbgfGMC/2xXeOavX8e+9iTyp05e52qhbYxLBaNLVvKy7ZGEY34aJxO2Yr/fty
         k7Tl7kzYM8/+A==
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.12+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <85c07f003e2fd2885cd69af41f64c5c4d66c7860.camel@HansenPartnership.com>
References: <85c07f003e2fd2885cd69af41f64c5c4d66c7860.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <85c07f003e2fd2885cd69af41f64c5c4d66c7860.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 35ffbb60bdad652d461aa8e97fa094faa9eb46ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 07db05638aa25ed66e6fc89b45f6773ef3e69396
Message-Id: <162049600278.344.3820658329832706327.pr-tracker-bot@kernel.org>
Date:   Sat, 08 May 2021 17:46:42 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 08 May 2021 09:11:43 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/07db05638aa25ed66e6fc89b45f6773ef3e69396

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
