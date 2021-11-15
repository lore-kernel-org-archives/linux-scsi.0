Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6E0C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B88FD63253
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355405AbhKOXlL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 18:41:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355087AbhKOXjA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 18:39:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BC42863214
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 23:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637019261;
        bh=ckSjRzFUgUX6m1/TtWmkPfMmG2FyUsH255wHIZmJbb0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SnjsaeikilG2+GLfghzQAJxglBTbncRk04GDJf9jqZ98UhhqVrguMeTEEzL+LH3n5
         ZwYpcq8BZdhiTGjjhAsBpWa4Ei4eN9aXqfy1clgu23jh5tYuuTQRgLMOxClPh5E1dG
         0/1p9KFPvoE7H+ueeBCyK91rd6yFrq7XSmBl6pUHeFIjY4JzcZENAze+ZyDxP4mtyV
         QAN/8JgchvQYEp6KAlEsTlnRyQyBkJFQ45vD37Q84QOtBa7Y205/yY4Ysnzz55mj0x
         QNnFSa9OFHuKqjKgKV+AkbiawPOj41WAJiGK2OfmtcJU9O/KHetp+0d1D4O1RjWgHH
         3XkTJR/+oGXiQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Mon, 15 Nov 2021 23:34:21 +0000
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
Message-ID: <bug-214967-11613-dTfZDoyhBF@https.bugzilla.kernel.org/>
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

--- Comment #7 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Matthew Perkowski from comment #1)
> I stumbled across this and gave it a try, and it fixed my immediate probl=
em:
>=20
> https://sourceforge.net/p/scst/mailman/scst-devel/thread/4FDDA78C.400@acm.
> org/
>=20
> However, it doesn't look like the mvsas driver has changed in some time, =
so
> I'm thinking the problem was caused by another change somewhere else in t=
he
> kernel, and adding that one line of code to mv_sas.c simply "band-aided" =
the
> immediate issue I was experiencing.

I am not familiar with the mv_sas driver & associated HBAs. Do these implem=
ent
SAT using libata on the host ? Or does the HBA firmware handle scsi command
translation ? Some quick grep in the driver code does not reveal much.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
