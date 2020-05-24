Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F02C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 20:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 653FA206DD
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 20:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387848AbgEXU6A convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 16:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387641AbgEXU57 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 May 2020 16:57:59 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 207877] ASMedia drive (174c:55aa) hangs in ioctl
 CDROM_DRIVE_STATUS when mounting a DVD
Date:   Sun, 24 May 2020 20:57:59 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zfigura@codeweavers.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-207877-11613-rzn4xeuBrT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207877-11613@https.bugzilla.kernel.org/>
References: <bug-207877-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207877

--- Comment #2 from Zebediah Figura (zfigura@codeweavers.com) ---
Created attachment 289273
  --> https://bugzilla.kernel.org/attachment.cgi?id=289273&action=edit
dmesg including backtrace of hang, from 5.7-rc6

(In reply to Bart Van Assche from comment #1)
> This may have been fixed by commit 51a858817dcd ("scsi: sr: get rid of sr
> global mutex") + commit 72655c0ebd1d ("scsi: sr: Fix sr_block_release()").
> Both commits will be included in kernel v5.7 (not yet released). How about
> testing whether this has been fixed in kernel v5.7-rc6
> (https://git.kernel.org/torvalds/t/linux-5.7-rc6.tar.gz)?

Unfortunately, 5.7-rc6 doesn't fix the bug. It hangs on the same ioctl, with
what looks like the same stack trace.

-- 
You are receiving this mail because:
You are the assignee for the bug.
