Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED67CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA3E420773
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgGTKW0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 06:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgGTKW0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 06:22:26 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 208605] AACRAID frequent hos bus reset with intensive IO on
 large arrays
Date:   Mon, 20 Jul 2020 10:22:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: janpieter.sollie@edpnet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-208605-11613-cwF9m8LZdg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208605-11613@https.bugzilla.kernel.org/>
References: <bug-208605-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208605

--- Comment #4 from Janpieter Sollie (janpieter.sollie@edpnet.be) ---
Created attachment 290373
  --> https://bugzilla.kernel.org/attachment.cgi?id=290373&action=edit
modification to make Microsemi driver work with 5.7 kernel

I know this is bad practice, but at least it produces some results:
I tried the proprietary Microsemi driver (58012).  Of course it does not work
with recent kernels, but after modifying the code a bit, I made "something"
that works.
Patch in attachment.  Any idea why this one works but the open source variant
does not? When I take a look at the amount of abandoned / junk in the code of
Microsemi after modifying, I'd expect the opposite.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
