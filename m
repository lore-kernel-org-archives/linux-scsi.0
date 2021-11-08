Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A26C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 14:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F853610F8
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 14:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238850AbhKHOLF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 09:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236232AbhKHOLC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Nov 2021 09:11:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9EA3A61179
        for <linux-scsi@vger.kernel.org>; Mon,  8 Nov 2021 14:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636380498;
        bh=0clGinoahwipFzuBP+OfPM5hDxLZRi7bNMsk+oB6aa4=;
        h=From:To:Subject:Date:From;
        b=UQT+cpOSHUsPM5Hse0t4+wkmpD98t+8at45x8kByC5Axr8Gw/6af65HpVvBIfyF6y
         4gHnML2R+ZNAvxsqCVsY3f9ELhjQ1LiLBIhB7Kyd+NciofEpUiwLElqubQjxkos6hm
         LwKTRgAk8vYUB2yhYWVzzIjB0zUjIMFlt/TK+okS83Wo7IQnY13ktzKeF5XAf7KKGx
         gbKENFdIqSc0Vy9XgdIBw+mG3yVG8L3d2Bjbi3YGkuk30BfPaNHY+tXxlt3f/Mb8V3
         obRl/PbTRT58UpMYzezMOzEOTGHoLZ7sVBrwHNh7XbaZLHMGsiYwvRyMQnRsgkC3NH
         OZadMG2ijVrOw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] New: mvsas not detecting some disks
Date:   Mon, 08 Nov 2021 14:08:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-214967-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214967

            Bug ID: 214967
           Summary: mvsas not detecting some disks
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.15.x
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: mgperkow@gmail.com
        Regression: No

Created attachment 299493
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D299493&action=3Dedit
Kernel log

mvsas module fails to IDENTIFY some disks on RocketRaid 2744. Started happe=
ning
with 5.15.0, continues with 5.15.1.

Excerpt from kernel log attached.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
