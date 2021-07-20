Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC2ADC07E9B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 05:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF34B6113C
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 05:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbhGTEoO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 00:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238098AbhGTEoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 00:44:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1643261164
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jul 2021 05:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626758692;
        bh=WwlfGEVNhNCyZHREx8SzkM7XkMFbnyctXcx946r8/Aw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=k2Hz9w4ad9h8EgRGTdnczZdhDeLNmEF08lA7DxbvAz8ftUb/vL1OxPz3iRADfkuFH
         i50za+bUKigWCisyGbjhuljUM/NbX0iTnLp+6LV78LRTh1zi6KvUdb80KBjF9w2P5O
         oPdtbEDc6xQK/3EBJb3I/2ozBGLAtZw1mi+ecTGWs3npWRh+Y4HwCrhVmWdSn7lhNt
         7cNT4Ap+hp9tXC3UOWfCyGyMFtB/eSixat7cASTwcs46lDN4qdWsTfcXxD2wK2cX9Q
         LySN90/0gIYguiC7TQeIDzKMCIoJohc+CqorfNPkm2lORhU3Wn3HO2JTtBVf6Xmdfn
         Y59VsPtDzHJ2w==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Tue, 20 Jul 2021 05:24:51 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213759-11613-GKC8Gp8a2X@https.bugzilla.kernel.org/>
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

--- Comment #3 from limanyi@uniontech.com (limanyi@uniontech.com) ---
Seeing this problem on Linux 5.14-rc2, CD tray (which is empty and untouche=
d)
is ejected on resume from hibernation.I'm looking for the root cause of the
problem.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
