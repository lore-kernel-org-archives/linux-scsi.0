Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42ECC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 13:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD42207C3
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 13:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgFINsf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 09:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbgFINse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Jun 2020 09:48:34 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 208045] ARM ubuntu 18.04 as the iscsi server, using initiator
 login, the kernel crashes
Date:   Tue, 09 Jun 2020 13:48:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: bstroesser@ts.fujitsu.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-208045-11613-bO8mJ93RU1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208045-11613@https.bugzilla.kernel.org/>
References: <bug-208045-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208045

Bodo Stroesser (bstroesser@ts.fujitsu.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bstroesser@ts.fujitsu.com

--- Comment #2 from Bodo Stroesser (bstroesser@ts.fujitsu.com) ---
Maybe I can help.


I already sent two patches to linux-scsi and target-devel, which I think fix
possible crashes on ARM. Patch1 already was queued by Martin K. Petersen in his
for-next branch. The second was sent as "PATCH RFC" and there is no comment
yet.


Based on these two patches I prepared a third patch that might fix the
described crash. I'm going to attach all three patches here.

Please test with all three patches applied. I think they should work with
kernel 4.19 also.

Regards,
Bodo

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
