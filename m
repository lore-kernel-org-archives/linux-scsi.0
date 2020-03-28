Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673C9C43331
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 16:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3962F206F6
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585413916;
	bh=tqdp2wKhFV4knnpcP0aT3RoHSlH9cDcNmpdI3uugVJ8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=cWPxyi1DxLbwukV2tXmbiY1S0FU3S4kYsaWiWZzVPoLmCw+/ybfviIsPaieH0yDeG
	 UuKB5ps0sZfP1VbfHg0n99BGevzOBrRXmlQOyvw50dEUqFg5mCYpf8YA55wXbsCD15
	 7ND3FcXpeRr3r2IL/uXzMHnLSb/W01L1TdRCxgs4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgC1QpL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 12:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbgC1QpI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 28 Mar 2020 12:45:08 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.6-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585413908;
        bh=tqdp2wKhFV4knnpcP0aT3RoHSlH9cDcNmpdI3uugVJ8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=WYypd4GcssSnK7bQByMec6LFgUxftINIvf6CPM9KSVh+w5eCCWVTm3kZcxpuafbzf
         ej7n3FMIQFkCgq7AmU515KuT1yvKtfwKjasMxQ3D0ygIjZf9I6kvtgIk0yfpH699w/
         WIM0lhb25KxTbQRLWjPTlkAlxoDWajP4UjSA0Cac=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1585409145.15200.3.camel@HansenPartnership.com>
References: <1585409145.15200.3.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1585409145.15200.3.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: ea697a8bf5a4161e59806fab14f6e4a46dc7dcb0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 83fd69c93340177dcd66fd26ce6441fb581c1dbf
Message-Id: <158541390804.15046.4391656669881129761.pr-tracker-bot@kernel.org>
Date:   Sat, 28 Mar 2020 16:45:08 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 28 Mar 2020 08:25:45 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/83fd69c93340177dcd66fd26ce6441fb581c1dbf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
