Return-Path: <SRS0=Owrj=3T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A4CC35240
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 04:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68D322467B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 04:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580357711;
	bh=ndCkhEiCn0iS0/W/A/xMf3x2f4FLVZFCVDXGd/Ij6YA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=ss86CHQ2s87GKPRxZcozPlhOJ6RLRlAWIaMHNUA5JGzlv2QDlze1y0Iivuvylzba3
	 G/+maNlL6Lv2OJn5/0jdmLr0OQwAGzivesIot/DNNgDIDXl7Aq9n+KaduhqqfSEfMV
	 nsmkq/GXBet9VtOeTKKICpoWe3JEV02KhTMEt//o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgA3EPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 23:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbgA3EPK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jan 2020 23:15:10 -0500
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.5+ merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580357709;
        bh=ndCkhEiCn0iS0/W/A/xMf3x2f4FLVZFCVDXGd/Ij6YA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=v7Ld1c7Uc+cehM+lwiYsdHUsc/YkoiCXMH/NWISu26w6RAKLXU+Y/E+jVHU0+KVXq
         2pLCbVA1Wsxez4wbxFgUtJOsV6hdi2oZ03f7EKkkh556dc3FOf4wOHwOTPwhqTtriX
         6MB/QSCw48ZUyK02anUXCA3YuKAG/swOsGWfeyvQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1580322984.7790.36.camel@HansenPartnership.com>
References: <1580322984.7790.36.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1580322984.7790.36.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 11e673206f217ce6604b7b0269e3cfc65171c380
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 33c84e89abe4a92ab699c33029bd54269d574782
Message-Id: <158035770966.9636.11321551506356671767.pr-tracker-bot@kernel.org>
Date:   Thu, 30 Jan 2020 04:15:09 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Wed, 29 Jan 2020 10:36:24 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/33c84e89abe4a92ab699c33029bd54269d574782

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
