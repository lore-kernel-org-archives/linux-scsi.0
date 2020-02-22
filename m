Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B96C35673
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 19:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A14520707
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 19:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582400730;
	bh=h38DsexsnPLyzlNsyAIRLwx5vcEcDMQ9BnyiEQEEr6g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=VP1/iKFJNhO7EEGqqL0EYfUsDJnQrTQNFJ1wuV+/wwD180YyzGD7UFunPiNRuwgKn
	 hufUjh32HdJdNuSOjT+oOmU0wMu500tVq2iFskCXguzPSY5CMZ4T9IeWRah8fI39zq
	 gQcpkS/NKfc0fAbK2p+XjMdzQxgmVQsXvefFj7uY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgBVTpP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Feb 2020 14:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgBVTpO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Feb 2020 14:45:14 -0500
Subject: Re: [GIT PULL] SCSI fixes for 5.6-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582400714;
        bh=h38DsexsnPLyzlNsyAIRLwx5vcEcDMQ9BnyiEQEEr6g=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=UMfehu7pUA8Ll2P0oMClAipkC6Rz6REVflVD/RGRyot4zsKgz6bzejC5Q4X3ZNX8Q
         aeiLcvv6M3x5HFaOUE6A/8EQuSMU0PJponErJvCASZcc9qZs7K9KbUySpZgpbCEHCn
         qIeIcK/k6eERCs05/zne/onRblpo4myJJEuG+Z4k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1582328069.3692.13.camel@HansenPartnership.com>
References: <1582328069.3692.13.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1582328069.3692.13.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 807b9515b7d044cf77df31f1af9d842a76ecd5cb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b98b809c0a1311239605e8d2ce1583191d3efd5b
Message-Id: <158240071437.14316.1008658180249121782.pr-tracker-bot@kernel.org>
Date:   Sat, 22 Feb 2020 19:45:14 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 21 Feb 2020 15:34:29 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b98b809c0a1311239605e8d2ce1583191d3efd5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
