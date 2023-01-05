Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D56C3DA7D
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Jan 2023 14:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbjAEOAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Jan 2023 09:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbjAEN7m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2023 08:59:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BFF5005F
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2023 05:57:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2702E61A90
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2023 13:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86E9AC43396
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2023 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672927065;
        bh=0B7rM3Hv5fvzg7rV44a7rDb4v1kfAEq7RcQ/qXH4H/4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DkkEJTEcQROCh+lysROkyf3fEkxJ+SkW7QSmWThpYi7sOHUyEidqF/8tbvpXUdJUs
         tlLip1U4UNxQZGIJj4/DjcPqcpUZF4n1ogbFjap+sZTy6lcXO32F/TcGtJu3915o+g
         WIFg7diwV5azAl3UIY7DQwAC1r969MI3KrYtjVgwdnTZGmQtUEYWKiB4wSVpVyPHso
         iGrEaOp9W83WpjauhYM7bACk0BlnKFCbMktnnhu4kakXA3xrcSeer7p04PMbSzarsT
         blUJR592Eq9lN6KQEKAW603PHOKLDdrD/RyU3Y73sU4CaYaYfSCp4BomS2Dbkxihd1
         /FUi99lIL3XjA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 75D03C43142; Thu,  5 Jan 2023 13:57:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 204769] SCSI devices missing for disks attached to controller
Date:   Thu, 05 Jan 2023 13:57:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: duesterhus@woltlab.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-204769-11613-JhF33Apwm1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204769-11613@https.bugzilla.kernel.org/>
References: <bug-204769-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D204769

Tim D=C3=BCsterhus (duesterhus@woltlab.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |duesterhus@woltlab.com

--- Comment #4 from Tim D=C3=BCsterhus (duesterhus@woltlab.com) ---
I believe I've run into the same issue with my Debian Distro kernel (5.10.x)
and reported it in Debian's bug tracker at:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1027921.

This Kernel.org bug was linked in Debian's Tracker and this comment is inte=
nded
to provide the backlink.

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1027921#47 also suggest=
s that
https://github.com/torvalds/linux/commit/948e922fc44611ee2de0c89583ca958cb5=
307d36
might be the cause of this bug. I'm not personally qualified to tell.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
