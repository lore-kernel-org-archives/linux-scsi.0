Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C045EC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 02:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E521206FA
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 02:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592706632;
	bh=hLfUqQI5lELd+NHz2VwHyg7BiFEXisb95E4wFsQyJ7Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=okNDXjFnCf0GDJxcS83HicruNNx7No2LLIB6W3JRqLIFhhYtMCPprBuAwQ9Mr6AOZ
	 74wa/kpPOVT514P5JjoLN1Q6tMTpBnLpykPQcJypIOmNev/chAiAV9+thAra1tEqt2
	 kcBEoMtqElnSw4f8IAEyJMW10z/ky4n8nCHuqEqU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgFUCa3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 22:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgFUCaZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 Jun 2020 22:30:25 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.8-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592706625;
        bh=hLfUqQI5lELd+NHz2VwHyg7BiFEXisb95E4wFsQyJ7Y=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=MdPLfWo6fkSil8dNIVqFy8n4/1EqOxDe24+cOVLYN3YxMfnqtyN8TC5evA2eDpRwW
         hPy8ISoKsSqTgk69ISXz6KIRBlHDV/Ih99/OqZu3ANNzno5SPLpNmcJH1s5YVxH0cl
         MbshkFvUE7YvNKuSBo2EYpMqk41A9TiowlLu4EWQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1592674936.3583.20.camel@HansenPartnership.com>
References: <1592674936.3583.20.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1592674936.3583.20.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: b8f1d1e05817f5e5f7517911b55ea13d2c0438a0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 64677779e8962c20b580b471790fe42367750599
Message-Id: <159270662559.3975.895454316141668110.pr-tracker-bot@kernel.org>
Date:   Sun, 21 Jun 2020 02:30:25 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 20 Jun 2020 10:42:16 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/64677779e8962c20b580b471790fe42367750599

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
