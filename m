Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC959C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 03:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D20E961C4F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 03:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245681AbhKPDVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 22:21:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343603AbhKPDTa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 22:19:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6AC4061C4F
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 03:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637032593;
        bh=PKGI396IRu8B4ohUaVy+FjCrEJC3V5OwX3Cu+fzjEpo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mVwJV0kIH3h8MTyNx/+Io3kfd/PY7rzCMY9wHaM1R/o+igKRWKPjf3tZPFuXUmguG
         qM28HpGkIf1dsrfiQfiXfMeywo/yH2BT7+NgDURvnDeLH7DedIFGeZJX41YN48Fj3C
         9AFwZyHBTCRfJ6d0G9AbP3xv68OvKdOoQHy3KiFrM1ouo1pM0UN19FPcGM8Yi2H/Gx
         Fxu+AVCV1Am+/tAgwanNoqH+Qb3HAyz1EsK4RIRqUfOjFlRvWfHgcLWxRgVTOJ7rbf
         WiEnurQok0UmceCdGynaToPfYRllbIm5nYmGVU76VgQZgdwRiBGH73j8Ol/s72RJ4X
         OdY34sFOrT/sg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Tue, 16 Nov 2021 03:16:33 +0000
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
Message-ID: <bug-214967-11613-lx8n6cBWbo@https.bugzilla.kernel.org/>
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

--- Comment #14 from Matthew Perkowski (mgperkow@gmail.com) ---
(In reply to Damien Le Moal from comment #13)
> (In reply to Matthew Perkowski from comment #12)
> > > > I will try rebuilding with the patches at my first opportunity and
> report
> > > > back.
> > >=20
> > > That would be great. Thanks.
> >=20
> > Looks like your hunch may have been right on. I applied your patches to=
 a
> > fresh copy of the 5.15.2 source (which was not working properly with my=
 RR
> > 2744 card via the mvsas driver in vanilla form), and the issue did not
> arise
> > when I booted into it.
>=20
> Great. Can I add your Tested-by tag ?
> E.g.:
>=20
> Tested-by: Matthew Perkowski <mgperkow@gmail.com>

Certainly. That is fine with me.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
