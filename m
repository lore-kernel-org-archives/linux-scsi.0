Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9273DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiACAmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:42:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56482 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiACAmp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:42:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BE9D60FA0
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 00:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63BC0C36AF1
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 00:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641170564;
        bh=sNlFc+y9PEuO/2V7MIMBAqNk/3BS1dd8Fed4YWYE1E0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=o9MxGRDEn+pkPUrmVxfKTexIjYjhtNNxQ83C7hfApSvp0i67o/lxmHEX/mxPG+5sq
         wNF9NlYoDqMqR/0bkEN5fFtFeXV7QxP4fpQEjJT8R1eQ0DCD9BpK/l1heTLpJ1d6Hu
         iNXxu9RWQ2DxB/BPMPy8ZAeo1c3Lil8hyAkrDXUlht1AiCWbBRYbzI9RvPC9VmqMuv
         dYlLgykS/dHX3cC51e+jJ/vwLq7D53xFchPMfgO2TQzum7ykrRqZnqIp+PObi5m0Jx
         /VQqBRkgC9spbr6sUlxJ4vzF7zq40Xnx1h4ZcA2PwGo/3NYLyGtEB40jUVKAa2qASi
         xxE7mh4bKUrJw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4AF81C04E57; Mon,  3 Jan 2022 00:42:44 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date:   Mon, 03 Jan 2022 00:42:43 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mason@blisses.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209177-11613-WcnehAumAT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209177-11613@https.bugzilla.kernel.org/>
References: <bug-209177-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D209177

Mason Loring Bliss (mason@blisses.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mason@blisses.org

--- Comment #6 from Mason Loring Bliss (mason@blisses.org) ---
I need to verify whether there's a Debian bug for it yet or not, but I=20
noticed the bug when upgrading from Debian Buster to Bullseye, running
5.10.84:

    5.10.0-10-amd64 #1 SMP Debian 5.10.84-1 (2021-12-08) x86_64 GNU/Linux

I can confirm that setting "mpt3sas.max_queue_depth=3D10000" worked there,=
=20
albeit with some unusual and potentially cosmetic errors I'll transcribe=20
later, once I get them in textual form.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
