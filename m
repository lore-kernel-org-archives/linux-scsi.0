Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7134BC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 13:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7872078D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 13:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgFINx3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 09:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgFINx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Jun 2020 09:53:27 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 208045] ARM ubuntu 18.04 as the iscsi server, using initiator
 login, the kernel crashes
Date:   Tue, 09 Jun 2020 13:53:26 +0000
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
X-Bugzilla-Changed-Fields: attachments.isobsolete attachments.created
Message-ID: <bug-208045-11613-1jVQmNSFEc@https.bugzilla.kernel.org/>
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
 Attachment #289577|0                           |1
        is obsolete|                            |

--- Comment #6 from Bodo Stroesser (bstroesser@ts.fujitsu.com) ---
Created attachment 289581
  --> https://bugzilla.kernel.org/attachment.cgi?id=289581&action=edit
Patch 2/3, correctly marked as patch

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
