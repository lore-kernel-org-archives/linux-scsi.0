Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5B4C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 08:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AD0F61041
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 08:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhKPIMR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 03:12:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231754AbhKPIMQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Nov 2021 03:12:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 16D9463220
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 08:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637050160;
        bh=/XbzX0QRaImHtVcduDjNZ1Rap2XDQf7osgvIgVBPLxE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iBVNMkJPhuxqXCaGEnQBEGGrfD1vJkKNS3Lhf4WlmuhPCE0W8kVKiVbN/uXbp2ii3
         gSpvCNNFzQvDD8/1O7GT25/YLIYAznz3XUahdIfBy9gTA/lZSVWktadTASv3W7YSAK
         Ukh5/CLzd+nWXGvrvCup6NI0dUmvPhINyVhYUh/q7DE6HpdIjSfDN4jl/4ne1d7gdf
         9ZyuTf8YUynC+ufY8o+Ta8SCLCi2e/8T46AOMujd7rc+MmoCv2IYkuISinoUSwTkIB
         d7DmwyOpXsV0AJVgFzCwQw8sdwcGIOqGDQWz27rREJ9OVhrWaePTOj/tQvrf8P/65+
         yWeUw6vpgFtTw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Tue, 16 Nov 2021 08:09:19 +0000
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
Message-ID: <bug-214967-11613-zEYZX6l8yn@https.bugzilla.kernel.org/>
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

--- Comment #15 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Matthew Perkowski from comment #14)
> (In reply to Damien Le Moal from comment #13)
> > (In reply to Matthew Perkowski from comment #12)
> > > > > I will try rebuilding with the patches at my first opportunity and
> > report
> > > > > back.
> > > >=20
> > > > That would be great. Thanks.
> > >=20
> > > Looks like your hunch may have been right on. I applied your patches =
to a
> > > fresh copy of the 5.15.2 source (which was not working properly with =
my
> RR
> > > 2744 card via the mvsas driver in vanilla form), and the issue did not
> > arise
> > > when I booted into it.
> >=20
> > Great. Can I add your Tested-by tag ?
> > E.g.:
> >=20
> > Tested-by: Matthew Perkowski <mgperkow@gmail.com>
>=20
> Certainly. That is fine with me.

Could you test with the latest 5.16-rc1 kernel too please ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
