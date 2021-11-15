Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972D5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 22:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB1F6321F
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 22:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348128AbhKOWyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 17:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241876AbhKOWhM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 17:37:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A0F0461BBD
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 22:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637015642;
        bh=mB4YXrjy+LreKjG1XkTs2WBmoca7k4QTL57BrLHkU/Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FKZF3RrnlQ4Za9tCjJPbZKE1ScsFB+j192su8UajpaFz1FqRzJ+SuWcGSu1GUudZm
         zjRSNcIQls8IFRHdYzSYjJsnH/IDGMRIcsm689hMPfP3TgFQzgzNzta0PvP4obkstr
         2hC78lD7wvFBqjEzWo1hF+i9IuiKn2QSjv+DRSdmJgDGxww0JlZxM4D2GdzlnFjOZe
         WCxeAi4aBY/kCylO4FDUFcvMCJvKhkY6HCjuzmjGGByueltncLDrW5VIOPv0hi6GiV
         aIs/92EIkJFTAfvkFVrqfKy/KREJuK6uEjHKmnIgLgw5df4ORWN1EprSGqUGEQeIfH
         p1CDv9xi9h0Ag==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Mon, 15 Nov 2021 22:34:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mgperkow@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214967-11613-zi3n4vnd7w@https.bugzilla.kernel.org/>
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

--- Comment #4 from Matthew Perkowski (mgperkow@gmail.com) ---
Bisection has identified commit 2360fa1812cd77e1de13d3cca789fbd23462b651 as=
 the
origin of the issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
