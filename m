Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC32C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Oct 2021 21:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023996023D
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Oct 2021 21:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhJPVcr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 17:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230062AbhJPVcr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 17:32:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 64C176023D
        for <linux-scsi@vger.kernel.org>; Sat, 16 Oct 2021 21:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634419838;
        bh=sJb1s/S6gFjaZBOAJ9VqFQhtLQ6sIySf4FBxDdHe02A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=q3lcKGPeXDLwa+s9m82vw1Ebaqs0et3y76/o/Ri3g4qtE9lljXnwGCVLDQEN1d7Db
         RUnXGIo8a1JGFXsj1HUbXl93UTSPJVt/c3ABjBz9YowNOFFvWW2Gx2hp9trgLFmt3v
         72pSXkLHHnTbrY2vddpCNE9LOAphorh/KGuV+b47bK9krvd/cO8DrdZsOAWSgbVfTw
         qWe1uWzdp9dNC9CDaGqtZBWow5TrkcMc5BRuOp6icVDWgIAcLR0vW3feDMCTWwABX4
         rSxvud4uF9j2ZBgPFpHev+EZ0doYfh7xHNGVtOOf1RNAferZ9z+lpFr12g8Ly8UDBA
         ZHPm4U83YNVkw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214711] Information leak from kernel to user space in
 scsi_ioctl.c
Date:   Sat, 16 Oct 2021 21:30:38 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214711-11613-vFaezyfslx@https.bugzilla.kernel.org/>
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

--- Comment #5 from Andrew Bao (bao00065@umn.edu) ---
Thank you

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
