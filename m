Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CADC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Nov 2021 00:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3FCC6109E
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Nov 2021 00:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhKNA7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Nov 2021 19:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229988AbhKNA7H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 13 Nov 2021 19:59:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 183B861154
        for <linux-scsi@vger.kernel.org>; Sun, 14 Nov 2021 00:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636851374;
        bh=nJLHdYPQ68pC6pCmVclTcLpecO8MbcaFwe9uOuQH4qs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KE1am7pscP+NvwsNDw9TtpCQGdCpXEfRSxu2V9Uvdyw5EtWmhla8nvvbljl2x/ajW
         mffeYwt7FWE3sKu51lBHjsS9IlFOW0sSe+9MM6Zj8WJqzzxc7SsO/BmzPWYZ6g7vLe
         R1DMW+c19nGPvw2tTXnUKnlZA8w5kduoxWH0e4CFz3wWhRk2PrwAX7anOjMvlkAuBQ
         H3QW7X6gXVhVzM3IHXcXl5K5+7HioyNdPF0QjCQ1gksFAxiqvqspmnSrsFn6ajHmwS
         7b7GAMxqVC7s3ZNNhOHBmc594aKDrYmqFPkgpsPEsoRxCrF/udmt8/L2wdpENE3Spp
         Pgh8Lom6+gcpQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Sun, 14 Nov 2021 00:56:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214967-11613-E2mK0Y32hM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214967-11613@https.bugzilla.kernel.org/>
References: <bug-214967-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214967

--- Comment #3 from Matthew Perkowski (mgperkow@gmail.com) ---
Oh, that's an excellent point. I will try to do so as soon as I can and pro=
vide
further information.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
