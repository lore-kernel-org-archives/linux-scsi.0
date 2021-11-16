Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE2CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 03:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D9F61ABD
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 03:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244814AbhKPDOs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 22:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343590AbhKPDOA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 22:14:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 932976320D
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 03:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637032263;
        bh=l4DufBJkYshI7QsQuzvC0CbOxoAHqqSudy1+BQ37CcA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aeDZxXr49AjfgEm6pviRYdZbSiMG+iKcP6fyIdvBunczMFPkT4clblfRiwFdeoxuI
         Ln5RrGlesAjGPdauK9uHGa3NTtE6BahdzZ++UznQesSsZrEKg6xDr7aSxvDK2D34rP
         Dtl8uxlzdHZFAT3tKCv9Cm0rjie0Ye9u0TDd+e+tCVnz08nPHK1XqoSrWcXcdaInF0
         XQ2xrf1cNO3JX9R/VmBEdK81JEh8l8xCEshh3+INpQmBmZ7GnHLA5ovH62VfWXH9Hd
         A1/3vTSRJ1CExRrGmlNgLGEStmgZYYr6RujWA4PpmVW0qT0tWlonrXPqhcTvebxYC3
         /Bx+OHFuVHAEQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Tue, 16 Nov 2021 03:11:03 +0000
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
Message-ID: <bug-214967-11613-Bhv46IHlAk@https.bugzilla.kernel.org/>
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

--- Comment #13 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Matthew Perkowski from comment #12)
> > > I will try rebuilding with the patches at my first opportunity and re=
port
> > > back.
> >=20
> > That would be great. Thanks.
>=20
> Looks like your hunch may have been right on. I applied your patches to a
> fresh copy of the 5.15.2 source (which was not working properly with my RR
> 2744 card via the mvsas driver in vanilla form), and the issue did not ar=
ise
> when I booted into it.

Great. Can I add your Tested-by tag ?
E.g.:

Tested-by: Matthew Perkowski <mgperkow@gmail.com>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
