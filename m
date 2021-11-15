Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C3FC4321E
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1B1D61AA7
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353177AbhKOXSt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 18:18:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351327AbhKOXQJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 18:16:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 75C8F615E3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 23:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637017993;
        bh=aycSzC2NXwelcjhUkjKNpJkQh+rtIFgo8LsHAEi9aOU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UBiaP1mM0rD9JG4NKSJKE0splszNTRbKq2n0jsu+DbJxhdCLhY7uf+OKvmSEd2Inj
         +kzcuTvN+wNvV53vkh6XkA2JfFklvbysOu+2jz2ttUieVvuoUhzq7VBMqjhZ1w5dvv
         odxhGwGwM0fHvYlzdVvMBtfZniF+8lmbcK/1wJaRpanhTiqJTA4Xv/ZLyX4mL0plbv
         chTqLpQRuHGlM+cQIEOA0ue3/dPKNWyn8nI6FZwwZLSBuZllrOHM9kzkJcrM8Ydu85
         KCh5IZ3F0Sfe1U+QBn/bokDpAZfh6S3dfQdwIwdc1qzlb512DwGrhNSmYteDqocF8F
         iiNTJeZ9WHsvw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Mon, 15 Nov 2021 23:13:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214967-11613-8gQ1mvhDE9@https.bugzilla.kernel.org/>
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

--- Comment #5 from Bart Van Assche (bvanassche@acm.org) ---
On 11/15/21 2:34 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D214967
>=20
> --- Comment #4 from Matthew Perkowski (mgperkow@gmail.com) ---
> Bisection has identified commit 2360fa1812cd77e1de13d3cca789fbd23462b651 =
as
> the
> origin of the issue.

This commit: 2360fa1812cd ("libata: cleanup NCQ priority handling")?

Damien, can you take a look?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
