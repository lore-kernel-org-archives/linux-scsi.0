Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BEEC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Nov 2022 02:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiKLCUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 21:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbiKLCUU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 21:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E412F390
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2022 18:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C45B76216F
        for <linux-scsi@vger.kernel.org>; Sat, 12 Nov 2022 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33F73C4347C
        for <linux-scsi@vger.kernel.org>; Sat, 12 Nov 2022 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668219618;
        bh=sBOXgqcE07HwnTH4U9x5uoaaKbFIDZpV0FxCDTUoqaY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ENxa9S8IcRbZgqm3Luf07ApGcQRtubKDwmhBHF0ZnBDyRXacLLGzRRUKpFXfJvgXG
         c98AXeb0dez9mArxdx6qxRAH0uM77KOtdB8gFIvCdGKsYx0REdCIPltCrV5Tw8r0Zy
         iNGddpB8kDU5pD5A/iPdgCD01oyOHaD5HtEexTPeV5OxNdINWbNs1QLprG1rpp61Sx
         5JydTO3TTCwGmZ/j6QE7tZHJ2ilB1VreyppuhFTtali6OTbrFN7dI55sRd5xtzKNk3
         T24ifSMugczVXkyngQWo7deZL1LguMQvT6HeA/Jxwn8aeCvAIV+AnG1Rc5vm1ELBCR
         9d6XH5TNBoE4Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 11B9BC05FD2; Sat, 12 Nov 2022 02:20:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Sat, 12 Nov 2022 02:20:17 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: charlotte@extrahop.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215943-11613-F0sVZJmyhJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215943-11613@https.bugzilla.kernel.org/>
References: <bug-215943-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215943

--- Comment #10 from charlotte@extrahop.com ---
> is this a serious issue or only cosmetic one?

the original bug report is cosmetic. the linked patch set is not a function=
al
change, it fixes the cosmetic issue.

there might be other issues in this driver (which should go in another bug i
guess?). but if you're seeing the same backtraces then you're probably just
having the cosmetic issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
