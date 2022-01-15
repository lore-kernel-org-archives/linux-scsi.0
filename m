Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1F7C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Jan 2022 11:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiAOLmr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Jan 2022 06:42:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44390 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiAOLmq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Jan 2022 06:42:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1033C60C4C
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 11:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71321C36AE3
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 11:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642246965;
        bh=eYS0te2LZf62Rg9AGFd2QMEHEC4gYDocomleuEyz5lM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rIf+Onf41cTVzq1/iJ2ceIAkXiFbUdRjH9J1amk6FsidzIFqzJHzyhPF2Qo6YfC5i
         JHG6fsuletXRSvqE+xXM4zPWTM4/ihFtTCAZXcrEfgfcOXZm2x/3S98nZCB0T4rmvF
         qfAUk4VMfiiBZuYFXLR2hgcdo1pL+hxlt9bL3gxaoKf0dWhHd4troglir3gJR6ljcn
         /eV+U2S/Vt3PLDHZExrBFOLirURX+J8Y/EXhk4NK2iddtmBjYqMgZ+JPi9jqgT9Hxr
         AbUpF+0LRIWII09ttsy6BzNitnNwQ3TWRysI46m7qidyh7iJPqDUqKULfsiaTnxlD9
         ivG0USEjfXSbw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 53647CC13A9; Sat, 15 Jan 2022 11:42:45 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Sat, 15 Jan 2022 11:42:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cshorler@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215447-11613-0W09B9Q7hY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215447-11613@https.bugzilla.kernel.org/>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215447

--- Comment #4 from Chris Horler (cshorler@googlemail.com) ---
self-ping my list-email

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
