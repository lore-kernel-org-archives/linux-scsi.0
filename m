Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B071DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 15:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9721060551
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 15:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhJNPJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 11:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233389AbhJNPIB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 11:08:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 61BE160F36
        for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2021 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634223956;
        bh=qEryh430czzTtEmrOwyMKxin/FOzD6WzXV+ZS64hB3I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OHUL2BmdbTs23BwPweKfpta44VP7KN26IwiUuK9Y6H+KXY8S8tMTbInGsZFQ7FkGc
         Rjyogsgaj2z+7jTjgfGCyTIoawkFupmYKZutfmby8f1ISUB5qozZKfjvezxVbTV0Iu
         xhdmgdTXDDMax+85s7ZMtKrsR/zrWBzzL2dQYyQXE8BF1M7ZnvyXIB7Q0avz0RSoVE
         DK6/ibqFnA4WWqkVH1Vjtl9cHCifPn3VqijwIdNvU5OYp3QzSgdr/cceWAEqcC9Zbd
         riarM8DZwRRIS9qzSZcRWzeoKPZLjD+UT0r26wycNkoCM6R8zBFEYSO+SITNYycsGl
         lRF6UoOeVJyrw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214711] Information leakage from kernel to user space in
 scsi_ioctl.c
Date:   Thu, 14 Oct 2021 15:05:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bao00065@umn.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-214711-11613-HHL5cnHwzT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214711-11613@https.bugzilla.kernel.org/>
References: <bug-214711-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214711

Andrew Bao (bao00065@umn.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Memory leakage from kernel  |Information leakage from
                   |to user space in            |kernel to user space in
                   |scsi_ioctl.c                |scsi_ioctl.c

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
