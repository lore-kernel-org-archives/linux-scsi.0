Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2FBC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 23:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA762630EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 23:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhKPX6P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 18:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232090AbhKPX6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Nov 2021 18:58:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CD216320D
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 23:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637106914;
        bh=05NANW15jz/MoqljlQg8xkbjGpe94jclPxPIKutwKlY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fRUgp9SxKdZbSfoDWUQwViNu5dnmy5fgSvFVgeoHEXH6wWXzxagcXaZ5QnIXI/Cq0
         P8TX7fa4vwSDAEPCBClDEC9RshXQUQCDTIuqqXeuQ/z7Y9Ug5f2W+092Cr3u4/7zTv
         sSTU9fwCGobNbDamRjkZsFLmR0w0iODI6r/nyZAqUtSn1gXGH0gOODFtYryinj5FNK
         1O3w0kju2Ds41dvxiqE+CYmlI7MW0lcWTcGTMLU1tzy9Akco/hQXwNVtwtcwXAj3w3
         QbLla7zhqdkr54b9HWR5UDho6ByWNtSII+S+dPguHy45WItBAItVyAg/Vqaf4paGcg
         zuMVS980xx6Yg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Tue, 16 Nov 2021 23:55:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214967-11613-KIatwsJFCz@https.bugzilla.kernel.org/>
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

--- Comment #17 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Matthew Perkowski from comment #16)
> (In reply to Damien Le Moal from comment #15)
> > Could you test with the latest 5.16-rc1 kernel too please ?
>=20
> Built, patched, and tested with 5.16-rc1. mvsas detected all drives as
> expected. Scanned the kernel log after boot to check more in-depth as wel=
l.
> No unusual messages from the mvsas driver. Seems to be working exactly as=
 I
> would expect.

Great ! Thanks for testing.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
