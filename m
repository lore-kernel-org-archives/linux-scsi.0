Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45FFC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 18:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B1B64DF2
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 18:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhBVSnv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 13:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231651AbhBVSmw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 13:42:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F6F664E5B;
        Mon, 22 Feb 2021 18:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614019026;
        bh=NlW1eHhlU5lts7g4nZnkrYhXeAo/Jq4qqDq4j/PwWII=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jRW6A8rbjUh9iksivuZKMDFPy0YxNzc0g5WlDCeSJJvI148r9b/j2YddHQ/AuXYxA
         w8WCDZuDLft5AD7R8sHsm/5XfExP4WwSoK10iS7AO6So8Bkxd7HS3vnmVEy+QIpsiD
         dLHNbUAm4gyKVZ2i23VpuQjz59TIodfe5qJXEN46PvKARRzpebcqCs2dRnz2CFrOkL
         btWfYusC9wo8F9RmW7gCltOwHFtnTQx4TTvLXBFjfQxU4KmhZGOR316f7OIXtM1RhE
         nZpk3RCTyZIighGHWP3/twmAW3YJ9tVonBOPDDxnAOqRpgOwq0wfeMVXVz7UN/hOcy
         kmlnMhPaJR9Rw==
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.11+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <7cb83383873d766c41d798948635be883ec5ed9b.camel@HansenPartnership.com>
References: <7cb83383873d766c41d798948635be883ec5ed9b.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <7cb83383873d766c41d798948635be883ec5ed9b.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: d2aacd36a8e00bc1813841b482e3933acb1ea0b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bdb39c9509e6d31943cb29dbb6ccd1b64013fb98
Message-Id: <161401902636.24925.4616218124229261423.pr-tracker-bot@kernel.org>
Date:   Mon, 22 Feb 2021 18:37:06 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 19 Feb 2021 12:43:50 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bdb39c9509e6d31943cb29dbb6ccd1b64013fb98

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
