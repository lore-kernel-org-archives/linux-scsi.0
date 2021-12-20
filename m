Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBC3C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 19:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhLTTnX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 14:43:23 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50618 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhLTTnW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 14:43:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 80070CE125E
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 19:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9399C36AEB
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 19:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640029399;
        bh=RHchUYIhMChW0oOnhUGA4iQKTNmnd74OyJZlCFtE5jI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Wsd2L+oDZv/Wku6jGCYPpXh91Uc47b5/SXosWZu3c3UQXlVOx87FRhlXsDbK+FmZf
         Qac9XPUdFT7mWW4ihZ2t4Qcgdx86R6cj1t0rBN9bckBu7a59eEe5wZklvAsceRE4+W
         yzGh/u6cZS+z5atLelI95KSs78pt1heSKQrDfzPRYSHhEJT73OIv26vSkKMRSgU6NA
         3aCNcvB664CaHuvaeAf+evY6gDH/hVH61Ou46+lCYSfjm3t0O2bMxKvgTCVCetinQk
         9jULHRKqhNq0hYvhYHqcMEwXXYl+ZwrmLVBWNSJItZ4ihvFsdDD2xsuVLE39Vam2lF
         OkWoz38MBW7RQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 8EDCE61106; Mon, 20 Dec 2021 19:43:19 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Mon, 20 Dec 2021 19:43:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richr410@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215353-11613-ihyzGO800O@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215353-11613@https.bugzilla.kernel.org/>
References: <bug-215353-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215353

--- Comment #1 from Rich Reamer (richr410@yahoo.com) ---
Forgot to add other specs (if it helps) ...
Centos 7.9.2009 (though i dont think minor version matters)
LVM 2.02.187

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
