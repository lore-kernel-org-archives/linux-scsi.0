Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E63C07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 03:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 881D760FE7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 03:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345019AbhGTDST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Jul 2021 23:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343827AbhGTDSS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jul 2021 23:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B4CBA6100C
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jul 2021 03:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626753537;
        bh=BlQYcGphJyD0SRmUBARLvW6q2ZwqJJ57bj/XBArIwrM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=k5VM4v5uyrsPLdh2vgM1t7K2jwFMPkmD6Q/xtwfEtKBeWn1CCTIqEswAhIpQTVNzw
         SF/24nBTDQtiXxHTG6gxc/eNCfx+q152f4aVPjy40HarMueA/RCt0R9MNCPikwEalV
         GSdKFD+q1n2hWWTS317odaVbpa/iv5OcJ190sePeLnK8n/qnldMMQiVTA7EFzORN83
         EjU96bZZJUmlmGl1RasvyBktLWQkvoVyhAvBPmlQZIoiSZsn8L3obaYr8R8Ey/Sa2M
         sVoSphFCp9j6UXJW/qz5wJ4iRs6re8wM47IEPXX51QP1d+e6CCRXNCfUYj2qE7A3J1
         F5k+fdGX/GANQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Tue, 20 Jul 2021 03:58:57 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: limanyi@uniontech.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-UbNpnIfbOH@https.bugzilla.kernel.org/>
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

limanyi (limanyi@uniontech.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |limanyi@uniontech.com

--- Comment #2 from limanyi (limanyi@uniontech.com) ---
I'm the author of this patch:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
h=3Dv5.14-rc2&id=3D7dd753ca59d6c8cc09aa1ed24f7657524803c7f3

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
