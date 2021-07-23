Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDCEC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 15:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B66460E0C
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 15:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbhGWPLA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 11:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235470AbhGWPK7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 11:10:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6D7E160EB5
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jul 2021 15:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627055492;
        bh=OLhDU7mosj0NCVJ4GpA6WIF1VsiI3Nab6d+ORygoURM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=b/+0aLaMTNFDgFFhx7LCL+wGejGvPjvZzKnp7kVpuS/zRQyftQVi+SZPSI2oeJx6l
         xQHTDsudFuIwP8/XFJhps8lOY+6rmxpOo7DH8qxgp1sSfleTghq4SoE0McByS/brMC
         ktWaRRD42pl7KVBwa1bQCpMut5VjUxqpJyu1qjQksfFKqHgavrGuDu7EakmCH/Qc1S
         PvDZ3K4dOPcLnaNKUdB+q6Zoi1tjRESqzrxWLCCdRl0BUexHngC4GE08k7GH+3fw4k
         p9gZex+0hAbZ+aOD1uj+DFcsVu+kkdVM89i8X+KYTZerUvF+5X8ACdelQniHAz8CuR
         LzertwpfvGjNQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Fri, 23 Jul 2021 15:51:31 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: trlyons@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-D5NeamPnq5@https.bugzilla.kernel.org/>
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

Todd Lyons (trlyons@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |trlyons@gmail.com

--- Comment #4 from Todd Lyons (trlyons@gmail.com) ---
Glad to see this isn't just me with the DVD-ROM tray snapping out on wake. I
first noticed it with 5.13.2. Hope to see this squashed soon. Thank you.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
