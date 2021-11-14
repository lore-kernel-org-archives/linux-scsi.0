Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FEEC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Nov 2021 00:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6E0761106
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Nov 2021 00:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhKNAWe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Nov 2021 19:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229988AbhKNAWd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 13 Nov 2021 19:22:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E493861154
        for <linux-scsi@vger.kernel.org>; Sun, 14 Nov 2021 00:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636849180;
        bh=8Ru02P17/U0Pl6mX9/LiyqX85mq4OlbAzBjw1MN906o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FASuVv+oyGSkf4rU9FYrybsQKyKNcUA5hA2g/IqfZhM+nn6CdgryvJB1WjX5Ld1el
         Hw8xQuCuaFJHej433EsHg1GS8WOfWfVZ+wMBR9QU69N9WOwhZS2K7v0SoPWXmSp9hf
         iS2QHRmur1O2KoOSHM8ghLSZlphiriAgMd6x+lOFGxy1+u7Iqq89lbG4F+M//I587l
         8UEaAt9+vZP/X9k2a/VvFxxlwJ7NQQytdVdPwiMU3EdlmYXvWJYFzc//Ggai/shN2D
         nkgkthMLfX0ysqFUworSIfmXTJIAHt97qxLylzkJGVLRVnsDNVDBkn0z/H+rr9BJVp
         MC+1iWFd2avfA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Sun, 14 Nov 2021 00:19:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214967-11613-p1UMEDWh1a@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214967-11613@https.bugzilla.kernel.org/>
References: <bug-214967-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214967

Bart Van Assche (bvanassche@acm.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org

--- Comment #2 from Bart Van Assche (bvanassche@acm.org) ---
It would help a lot if this issue would be bisected. See also
https://www.kernel.org/doc/html/latest/admin-guide/bug-bisect.html.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
