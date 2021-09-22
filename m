Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4232C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 18:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B42B76127A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 18:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbhIVS3X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 14:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236973AbhIVS3W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 14:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9107861350
        for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2021 18:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632335272;
        bh=qJoiU/Vs2AwJPxaFSCmOKzq+p/k8NRBTXsABlsQD8kg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rwQa7Vtllv1X/JM2Kc/Hn1E727HvjwDUXqcVkqAjXEtYqkEhH11Ke4BtAm/CcJ6DR
         22LjiO4aAtMmwlEO08WYz1HhhZcpjhhrBX/UMr0Ldi9YIScyAY/oQkuJh/CdtIHSfw
         N660spNZNDPnRmh2mVngeg0XgGWQdKzquIhGzLHD/bC8UVxI4h/ja4m/L0DXBl8BdO
         01e+waUjfzLENqXAkhB9LRJJDDCnaSoYmWfNMOueE+N+erMK86xV7pvILZpe1/AYVs
         OaSDQAgw1rr8e/dwW7Db/d09DSL99VbT76gz3sHx1Apo3vdwIMmJv9VZzmHpQMJ6Py
         yCuo2kO9BG84w==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Wed, 22 Sep 2021 18:27:51 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jetlag0515@yahoo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213759-11613-Z3NAq6EKll@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

--- Comment #12 from jeffro (jetlag0515@yahoo.com) ---
After today's Ubuntu 18.04 LTS kernel update to 4.15.0.158-generic the CD t=
ray
eject problem still persists.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
