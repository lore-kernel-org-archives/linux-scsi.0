Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CD2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 20:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA05561154
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 20:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhJMVBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhJMVBR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 17:01:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E29461154
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 20:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634158754;
        bh=KIs+3ws58pqTEW+4O6HBQE5xYXIuBkBmTm9m4E81lxQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IKWDPZ1lGADPhQwxe3V36il1mRtY7FBEnMsSvOnWh0bUVofsJkW7dOlQPpQYvT4kw
         xbeH7nTdHcPtq/1Y3ScPXzqPTMS2vaIvv0NHeX6NHQ930pOk75hvmhva3GTnjUvv0v
         eQcBRZiTaLkvET2SW7vgKFm9V/UqF4A0RpNwCHeRSTBPP+vjwPl8m7mQ86mKXhEL7Z
         xnIF1UNi7+cJjBN5ACgL/MZ/73CgxHQeU7+f1+wOLxq597HUaFIt3gvnzW47mTarMl
         qnhmgeW0/1sTGmUnPlT5KJyEKizDCRO4hJ1qHRljNctkIyNqSDP5UolP27ixaYTy32
         lY/3FTuJSL4ig==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214711] Memory leakage from kernel to user space in
 scsi_ioctl.c
Date:   Wed, 13 Oct 2021 20:59:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bao00065@umn.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-214711-11613-Vs48jdvpLR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214711-11613@https.bugzilla.kernel.org/>
References: <bug-214711-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214711

Andrew Bao (bao00065@umn.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Memory leakage from kernel  |Memory leakage from kernel
                   |to user space               |to user space in
                   |                            |scsi_ioctl.c

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
