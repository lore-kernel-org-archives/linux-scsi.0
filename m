Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF16C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Dec 2021 03:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhL2DnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Dec 2021 22:43:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35432 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbhL2DnO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Dec 2021 22:43:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BC77B81744
        for <linux-scsi@vger.kernel.org>; Wed, 29 Dec 2021 03:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB6EAC36AED
        for <linux-scsi@vger.kernel.org>; Wed, 29 Dec 2021 03:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640749391;
        bh=pQh8TT7iAk4nA8/Cjj7N5hf6fBne5KQvJ+RX0ddPXyQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tvhL/qTvc6Mpdwiuw38NBENuSbePlXilt1kGCbfbA1INo3zjB5miHXMHc7m4rY0W0
         6MbFzDDfo6jvIgV0DHnBJDmdkceEuQYyr+mkoONYpc1HQlnKiOLRnQTS24o9L9+alo
         ewVwf6nTNc8FpEJ9HVZeb0gH5XakG7jD1lLqBj/QpjRmaM+z5LaV18YcrPesCrC2Id
         vO//1cMwDdM0wgWNhG/EKe5W4EzbP+XjoMV7P/LZYQ3vL8HKsLFxW8/+/OXreZDCop
         Mzp24mG8b8rq797qM69T0MUkoc4tN1si5Ao2gyRNHECs2UM17in6pBw1lElaqbWMAT
         4eaLUgQt/Bezg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B8FBCC05FCA; Wed, 29 Dec 2021 03:43:11 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 199887] Fibre login failure on older adapters
Date:   Wed, 29 Dec 2021 03:43:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: QLOGIC QLA2XXX
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: jmetal88@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-199887-11613-CSX4vdjKY8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199887-11613@https.bugzilla.kernel.org/>
References: <bug-199887-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199887

Michael Graham (jmetal88@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jmetal88@gmail.com

--- Comment #3 from Michael Graham (jmetal88@gmail.com) ---
I think I ran into this today, trying to set up an ISP2100 based controller=
 on
the server in my basement.  No error messages as far as I could tell, but on
the 5.X kernel I was using the adapter just would not communicate back any =
info
about the drives attached.  Tried out an old version of OpenSuse using kern=
el
4.4.104 and it worked with no special configuration on my part (I did try a
current version of OpenSuse first, in which it was also broken).  I'm fine
using an old version of Linux for how I'm using this server for the time be=
ing,
but it would be nice if there was a fix for newer kernels.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
