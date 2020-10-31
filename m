Return-Path: <SRS0=Icgp=EG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0239FC388F7
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 19:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCF4F206ED
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604174040;
	bh=wBA0F1ofFqxzWq9aCdciHv1Q0G9YBNVFuKp4SmeCtFQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=NEqxz0hqUtwHalFTFGmfkKqsWWPraCxosIOiPE8tdhjDfzNn1zdg8YpUPYZNIBO0t
	 +S/kE529f8BjDh6M7Uyb8p03eDmxUmsnbzqZyyjrwsAIFp+JdblQCjHuEaCwBG+hAB
	 UZexpHbESXsb+jdSTvt5HkOLFf3fkISzDNUfGUyA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgJaTxy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Oct 2020 15:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgJaTxy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 31 Oct 2020 15:53:54 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.10-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604174034;
        bh=wBA0F1ofFqxzWq9aCdciHv1Q0G9YBNVFuKp4SmeCtFQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=uOAJF73CRiWUKBAvoLKUrdOXsX7MCKQuNs39rIsXZcr4wRThPhvFPia4JtKM6kA57
         2c1qD7NgUxSLlZIxVgLUMAu9Ny/CdbG6/+N9zN3LPciAgI6MmOOz82AIDbtCV+BfvB
         8YKMC5s4dlp/1D9V7fHQ1WU3aQmdOgZ8+Afc/T6A=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <86563422e11735ab7ec6cf0edbd8a7863e46a96a.camel@HansenPartnership.com>
References: <86563422e11735ab7ec6cf0edbd8a7863e46a96a.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <86563422e11735ab7ec6cf0edbd8a7863e46a96a.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: fab09aaee80389a37d8ab49396afbb77fa86583a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 67ff377bc30cd4eb91f0454adb9dcb1f4de280f2
Message-Id: <160417403425.21727.4616291513332330790.pr-tracker-bot@kernel.org>
Date:   Sat, 31 Oct 2020 19:53:54 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 30 Oct 2020 10:28:38 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/67ff377bc30cd4eb91f0454adb9dcb1f4de280f2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
