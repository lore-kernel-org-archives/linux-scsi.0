Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95118C2B9F4
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 20:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 702B160FF2
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 20:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFSULH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Jun 2021 16:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229887AbhFSULG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Jun 2021 16:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7A7F56113C
        for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2021 20:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624133335;
        bh=A/gvqJoj0CyKVEiQQCyRq6WC4IY5/FYKHAV6YiWfjFE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JiBl+RGlFtrVQe+5PSfKqK+/2ad8AP2Eu4n4/MVLHPsqpS0AHYqWQtgBBHQrdnZF3
         ZGPa95IXpy7FXAPQ4dyv5KVOLCoY797c1MCDf232o2JLWeUP9TkoZKD0Yk/XzrnPLR
         ymqW8Wkm3toSxP6JX9rTrwYfG+734wDxHRmo7cTXkiEZnbi5cu6W7nvqoojO4uG6Md
         xeWcq4gLSVhrBsd+CItxUHBM0zU2vjwmqtsTFXFokJnV7Ky1QhPbi7Fh99ixUhUxpN
         /xGbvITzW/OMuS1JVBhQq3KWAuSAt9cBL6BqWeIQLy5lIyoXW+9pCuY9VpXRyKGijp
         wYJoX+qr3c4wg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 204685] Sometimes Lenovo Yoga C630 WOS boot is delayed due to
 UFS initialization error
Date:   Sat, 19 Jun 2021 20:08:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: russianneuromancer@ya.ru
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: UNREPRODUCIBLE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-204685-11613-OrkcmnR8ST@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204685-11613@https.bugzilla.kernel.org/>
References: <bug-204685-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D204685

RussianNeuroMancer (russianneuromancer@ya.ru) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |UNREPRODUCIBLE

--- Comment #1 from RussianNeuroMancer (russianneuromancer@ya.ru) ---
Not reproducible anymore on 5.12 and 5.13 (although 5.11 still fail for me =
with
different UFS-related error this is no longer matter).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
