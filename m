Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EDAC432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 22:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D55E60720
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 22:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhH1Wky (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Aug 2021 18:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231981AbhH1Wky (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 28 Aug 2021 18:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3BCBF60EBD
        for <linux-scsi@vger.kernel.org>; Sat, 28 Aug 2021 22:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630190403;
        bh=c9UZ+rHQUcwVwD90WFFjmTHfdqFd17Ko31FP6F6jtQ4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NVlx/X8syUyiYnyTFQ/T5iy0ANnnlr2gL2DLrR7/TvVY06M34kjU7PaMDMP8r4XL9
         yD62bVLGy2+A8XJYRYDIwloXdAn17GMlGk56ubbs1U7ikjfIyhet9o3fR9k7XdO6jV
         EfIEVcxTDp+MRI6iiP/2v9vLxgyo7b6ijnP258mWxgrHs9OYMuzlzwpdaurjBXjvtK
         lBIk9mxPGJe2s8/8gpWyaa38Nu7DhsKiLOH7loKvSBB+Y2QyD/0EUBpB/cI9IgrgT+
         DNzvNlSsAQdWHcRN6a7dR+sN/W1ZhxRJyG6GKHbgDRXvvac2NIC4v8JQz4ezyONP0K
         Yglr512Ry/Clw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Sat, 28 Aug 2021 22:40:02 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: computerpro_58@hotmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-213759-11613-VVNBuaM9RO@https.bugzilla.kernel.org/>
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

computerpro_58@hotmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #10 from computerpro_58@hotmail.com ---
Can confirm the patch in #7 fixes the issue (in trunk, backported as well).
Thanks for the great work @limanyi, issue resolved.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
