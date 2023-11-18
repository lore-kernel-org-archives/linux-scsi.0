Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011A4C2BB3F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Nov 2023 22:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjKRWrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Nov 2023 17:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjKRWrW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Nov 2023 17:47:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEDE12B
        for <linux-scsi@vger.kernel.org>; Sat, 18 Nov 2023 14:47:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6AC7C433CA
        for <linux-scsi@vger.kernel.org>; Sat, 18 Nov 2023 22:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700347638;
        bh=VXfwr+E4y6iX6uwaZ5SvVTZa46SqHl/sc70dND7I43Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pMBr+0FhehQjFYrP1NLpI2Eq+R4fca0shVfRDOWlZYwLjESTXk4/txXjtQGXFgq/i
         /OTTANpjTN6o5U+YBAIxmPy5dNd4tR6qV6bK3zgSbHSHlrpEimI8YHVG7/vempbyqm
         PYL+uOVGyROVj5CsIhLOdtk4REq+Jn1toJ2pzqESULdimkwrfTApH/BaFgqP07enu1
         VMvs9+KDOB8CvtXqD7k9DE596onYUvjxDepSrdRxGkw0z56Y8ZWH/dKTRgkRmrF+WW
         gin5TkJxdc+GUfchl04ij2Z4kHQl48AnuGFnV3+uagywlVMeErb52s21G1hanPf6T2
         /h6PzUmksOFpg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9C1C0C53BD6; Sat, 18 Nov 2023 22:47:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Sat, 18 Nov 2023 22:47:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: leyyyyy@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-TbmsCSv9tC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #28 from Maxim (leyyyyy@gmail.com) ---
Just to be correct: name of controller was ASR-71685 (not ASR-72405).

openSUSE tested on ASR-71605, error happens for example on copying big amou=
nt
of data to disk with high speeds

if you run fsck.ext4 on ext4 file system with buggy kernel it will damage f=
ile
system and its data

using buggy kernel BTRFS scrub also says that checksums are wrong

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
