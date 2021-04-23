Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2142BC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 04:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000E96120F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 04:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240355AbhDWEmA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 00:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240314AbhDWEl7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 00:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0DBA6613BE
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 04:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619152884;
        bh=VoTrQ0Lr/tnGAIf3MMEb4zaRYXQDMoevlnPQZXfiB2w=;
        h=From:To:Subject:Date:From;
        b=DdJXERlyvGx2xuiaIIXJ825uaYOKgXG5/mDDWe6cEfaN2AnUpAHFKe4FHpeQD82BI
         4EKpCJWyldby4STQTql4FVHwwnT/96VvlK54DFC8hhi5gXP1/PY22BH4RcfMKEr/RC
         yocBpLhrs1CdaSPrabOrfvSsYrRVBF0iP4GDrH5hAs/LmfieWvgCuwXY7zcGrfW1+F
         5Y0VPcQM5Uw1UZAj6lAWpjGHhsqMp+Ug6nSHqCrh34UYnstKzIkKfE0dBZrY8BnfWt
         MDXkCE0rP/3R3WfNXg+Ar021zKiJkOD3YrJ5p6Z3F2dR+zd0IV4kJQ2mDdBtGzcjEb
         12dnAF39TGItQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212759] New: NVMeT crasdh
Date:   Fri, 23 Apr 2021 04:41:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: slavon.net@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-212759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212759

            Bug ID: 212759
           Summary: NVMeT crasdh
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.11.14 - 5.11.16
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: slavon.net@gmail.com
        Regression: No

Created attachment 296463
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D296463&action=3Dedit
crash1

two frash hosts
Melonox X-3 card
iser and nfs over rdma work or. But if i try use  nvmet - its halt

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
