Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AACC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE9664E67
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355762AbhCDAda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1388045AbhCCUfL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Mar 2021 15:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 495CB64F09
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 20:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614803671;
        bh=ESTdII5QMK9KiJE227qzet6edyrckTWoy8AHFhW+isw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mJyxb3uLhMXcApCPRIl1L0I+pWs6iAIv7TUEWl5Yzj5G4wpIzgmxKaUZMVElsux9T
         8DHhG4bNzzEI0GY2kk2F8YmQ1fQQsSh1abJhCDQvSD3bLuBEk2RBzpmS5Lqyvg9hOh
         szWkX1toKmRHtDMeNKWdPCBL5oRRUJm59sH5Vitz7g8ygiXtKyRWkvZTwjBM8eHldP
         rkfZcgeuTc9YN2W690pmmEr1EpJt3Ak2E2KVESWYD3XL3sjn1f+qQ5gmGlulab4Twp
         SoKZuAgMO9384xRpsaPSgHHypgSnrgM2i3PIAm5/gISS3mgeGSn5soOz1XyjknnpPV
         uF7x56RrUUNvw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212007] wrong timeout calculation in scsi device_handler
 (scsi_dh_emc.c and scsi_dh_rdac.c)
Date:   Wed, 03 Mar 2021 20:34:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-212007-11613-upgWiFn8gP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212007-11613@https.bugzilla.kernel.org/>
References: <bug-212007-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212007

Bart Van Assche (bvanassche@acm.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org

--- Comment #1 from Bart Van Assche (bvanassche@acm.org) ---
Please prepare a patch and post it on the linux-scsi mailing list.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
