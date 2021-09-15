Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19775C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B8B60724
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhIOD4h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232517AbhIOD4g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 23:56:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6D70C61246
        for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2021 03:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631678118;
        bh=Pi3ynrv47Qw6/Z9RXB+yopfqR4H73pCRrZud0C/+218=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=P2e2b60KWdwAiWwz2XTMtH2GLg+zySWpubVM5m+s53Q2M8ax8iPhSk4+9bGYX5vSE
         EQy70vzlTyqhugUKDAPPaawCsQv9WUkNgBBS2ysxQ+10qLQ1fW0Cwxz4GXKZyvdJmR
         QG/9wKxyHdt0VJ5iBSPvgc+fghgvqvzT6WH/kbdBphOn8633+C66+m1EPRim/2ZV73
         0gGBMg5PPnJ1vVCFIuPuK3zBTG1UM52YFyv/a7NiP/WW9zrDGE7qinnBAm09L61EJz
         9A+PegndHRkn+bmvFLCP71+JW1CVmjQOLR3bEkHymTetRhCnlKdMXUlubotx75c/jF
         rq3IUrOX7XOiA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Wed, 15 Sep 2021 03:55:17 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jetlag0515@yahoo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-czNDxSoA9K@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

jeffro (jetlag0515@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jetlag0515@yahoo.com

--- Comment #11 from jeffro (jetlag0515@yahoo.com) ---
Also encountering this issue on Ubuntu 18.04 LTS as of last kernel update to
4.15.0.156-generic.  CD tray only ejects after resume from suspend, not on =
boot
(No disk in the drive).  Previous kernel (4.15.0.154-generic) does not exhi=
bit
this behavior.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
