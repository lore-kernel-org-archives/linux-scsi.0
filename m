Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487FBC3A5A5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 08:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D28B21743
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 08:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732736AbfIEIie convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 04:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730914AbfIEIie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Sep 2019 04:38:34 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 204769] SCSI devices missing for disks attached to controller
Date:   Thu, 05 Sep 2019 08:38:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: linux@lanrules.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-204769-11613-NLrblQwOih@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204769-11613@https.bugzilla.kernel.org/>
References: <bug-204769-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204769

--- Comment #2 from Johannes Jordan (linux@lanrules.de) ---
> The enclosure looks like its on another port correct ?
> 0:1:x:x
Funny enough, the enclosure is 0:3:0:0, and is properly exposed by both kernel
versions.

Btw., it seems like this is a duplicate of
https://bugzilla.kernel.org/show_bug.cgi?id=204173. Sorry I didn't spot it when
submitting, got confused by how Bugzilla orders search results.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
