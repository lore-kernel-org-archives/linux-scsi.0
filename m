Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A847C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 12:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E992361ABA
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 12:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbhKPMcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 07:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236271AbhKPMcE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Nov 2021 07:32:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id ADD2961284
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 12:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637065747;
        bh=+VJZlvDypNOTCKdMCZ4IbhV8Itdq24hT+0P+Hw51opg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=e+jH98s2/5tO6LZpMMKWhI3mZL0M7Q2SEraf1zMWWdNUr5ekhEhhll1Bz2i74c6Kz
         RQ5kjlzg5xFNmvl0QEMqLruEZhdM3oW/HQhVIzybcaYmCsIQzJPEYd42XeBhMcnL2P
         5nxaZd0eG6AU+s08bHQcweancJtX0FJm9eq8NKGSUY+CSldJreCE+jSePcJEx4IX89
         hHaLY5X5CKgTGHSmOo1nFz7cyR3r3J2kcv/Sij4JAD4awPC044dZqWsO7SKi+saIec
         d84nzk9FMAWa5xkxTniankAQKbBQOxgYFSns+yHG2+qAFIbl/hhI4Q8r/P9V6tiptS
         +SYulcSN6k2Sg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Tue, 16 Nov 2021 12:29:07 +0000
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
Message-ID: <bug-214967-11613-Rf6eDK3C4n@https.bugzilla.kernel.org/>
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

--- Comment #16 from Matthew Perkowski (mgperkow@gmail.com) ---
(In reply to Damien Le Moal from comment #15)
> Could you test with the latest 5.16-rc1 kernel too please ?

Built, patched, and tested with 5.16-rc1. mvsas detected all drives as
expected. Scanned the kernel log after boot to check more in-depth as well.=
 No
unusual messages from the mvsas driver. Seems to be working exactly as I wo=
uld
expect.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
