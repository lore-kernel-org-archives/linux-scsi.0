Return-Path: <SRS0=Nn94=DV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813CDC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 23:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E225208D5
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 23:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602716536;
	bh=qw5LOB62yAoiTpmkPlyzV3T+DtR6nRxzuVlUJjeSPgo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=bAkrHm313WJldSeK5tZKhHUdG6FOuNMhrkY6g3p1NX8V7URo84TfCNe4mtKAmgV7F
	 JsFB6ZjatKL1Lu+BOhrYQJ1f+uMi9gADl7daznS5XID10pS6wxF6lNy17UnNvr8rRR
	 M1wVq+hzFjesrO/FeIQiMHOU6d1Q2r+eMkaonThc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbgJNXCP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Oct 2020 19:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbgJNXCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Oct 2020 19:02:13 -0400
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.8+ merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602716533;
        bh=qw5LOB62yAoiTpmkPlyzV3T+DtR6nRxzuVlUJjeSPgo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=rv7sa+RUSMXlgqZw0HHtUN2L0AjRj1u6T9lMPKX8UAMsVIvDokT7BIDBJjqRTEb8I
         qx1QzEvl/9HMoVdwRfZovkqigOxOEeMK9WDBol28w3vISRlb7f2If0nfMTOLeVtWYK
         nq0YT9b0avCmrRbVabBCq8WlkmYbSEota4n4DOLw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <fdee2336d2a7eada3749e07c3cc6ea682f8200b3.camel@HansenPartnership.com>
References: <fdee2336d2a7eada3749e07c3cc6ea682f8200b3.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <fdee2336d2a7eada3749e07c3cc6ea682f8200b3.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 69f4ec1edb136d2d2511d1ef96f94ef0aeecefdf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 55e0500eb5c0440a3d43074edbd8db3e95851b66
Message-Id: <160271653300.18101.17267488925167217207.pr-tracker-bot@kernel.org>
Date:   Wed, 14 Oct 2020 23:02:13 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Tue, 13 Oct 2020 15:53:46 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/55e0500eb5c0440a3d43074edbd8db3e95851b66

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
