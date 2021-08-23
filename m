Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2274FC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 16:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07780613D5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 16:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhHWQIt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 12:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhHWQIs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 12:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1AC28613D5
        for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2021 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629734886;
        bh=lZZaFF/QNCMlquB4dflXt/T25idgpaKMDR0Mg1d2raA=;
        h=From:To:Subject:Date:From;
        b=PvxfAeFDodt8tHP7akkK0wUx/OmboWOZll1zGOPbxM5+6P4eOs6NKqI1NDZ6t+6lS
         PgU6s98taZpyy5wI6MGPg7evQWn6xNfY1a5bqCOZgBQx9leT33R51XaS/UxthTzJEc
         8ehgyrV4wden/7VhWtd/pRGFuZmNN/5JlGSC4RI5xC8ol71vw/XFWJhk3GU//k3AxX
         1Zu0Z1DUJ7ZRFzqq9/cOW/zAC8Unzj0am3YfZN+cQwIbWIk9dqdB9UqR+Mj8+IK0tn
         p5Ue4zIdzD5eiK66qwB9eozv0h6P5klVrv9P95ArUylh+iofBenpEn14y2gvdmPeV+
         TXNEKvcTkikBQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214147] New: ISCSI broken in last release
Date:   Mon, 23 Aug 2021 16:08:05 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-214147-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214147

            Bug ID: 214147
           Summary: ISCSI broken in last release
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.13.12
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: slavon.net@gmail.com
        Regression: Yes

Created attachment 298441
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D298441&action=3Dedit
dmesg log

After some time iscsi go to broke and help only reboot

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
