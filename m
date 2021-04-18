Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C4AC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 00:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 863046120A
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 00:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhDRAXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Apr 2021 20:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235843AbhDRAXC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 17 Apr 2021 20:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 32AF36120A
        for <linux-scsi@vger.kernel.org>; Sun, 18 Apr 2021 00:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618705355;
        bh=p7ngd6bfT+5D4aYQrbVAAauY9+1B2XpqdvmLIrQRHtg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ba3t4YwA+oaj1kncDy0gcRrBJAUCXPAU+yI4CtY2LFgnPSCZ/F5eQM4UYz7tiujQC
         hKsP1eeo9NAxAh9Kcsg/rVtIsvACn6Sel/pFig01EccdYfou3klk8iaDGkrw84bj4o
         jlXzulHC6F6/fpkEjpWb+EEENUvyqCaMAs64IIPdO3j1bDQrPROLL8ReuNbODs5a9A
         pe2uC2bVZ9XvcdWpht/Oz8OR0k4sLoyFRDgVMAHiHGRKlQos3eglmd5k9FF+UPI161
         kGYCfAOU3VHBOtnO6547VTecxw7imQRIi1WMawOobLL/6UYWU9O5obA7ho3FInsM7T
         JtJ+SuYc568Gg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 204769] SCSI devices missing for disks attached to controller
Date:   Sun, 18 Apr 2021 00:22:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nathanial@marshy.com.au
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-204769-11613-622gerbw98@https.bugzilla.kernel.org/>
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

Nathanial (nathanial@marshy.com.au) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nathanial@marshy.com.au

--- Comment #3 from Nathanial (nathanial@marshy.com.au) ---
I am seeing the exact same issue.
No hardware changes, but updating beyond 5.2 breaks this.
I'll note that if you force the expose_physicals Parm to 1, the disks do st=
ill
become exposed as /dev/ah* and /dev/sd* even behind an array.
In protect mode( -1 ), sg* should be RO but is not exposed at all.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
