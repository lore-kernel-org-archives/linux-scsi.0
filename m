Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82200C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Aug 2021 05:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BA6C613AD
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Aug 2021 05:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhHYFeu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Aug 2021 01:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhHYFeu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Aug 2021 01:34:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D206613B1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Aug 2021 05:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629869645;
        bh=EVOo558wvoybHGPqrqqCOlbxSK0Ftg5AtT7jh4mGfv8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kzQUNEPU86Pn+A2MkOlsNSrviENsaVjnQROEnlSYt/xq4aPwqUglaIvirAFif8lid
         V4JC/epWIpGNKyPb1iXubb2EvQx/ILos6xVXmHHuDHX6bPvv3xGcfZj+HjSgcTHAZg
         lrBS3DvBTB1qUZQzzdaR6kZDVdlbKNYde4egoodyjhekIvM6fdSaDawcfHkbtle9Da
         xW0NB9wUK1qhQ5hA1Jr3E1yNkTamKXftmWJ0M5b1xBNLB43Suu8MiX268AUYMEGv6R
         fu1VdAy6TAw97IuKmPZbdyPRT/dRX8tMNTmYTm3ykEjGF6Lfa1J0SM2o9RXk7oC3Se
         CWHD8Wd+rj6DA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Wed, 25 Aug 2021 05:34:04 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: almaza24map@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-2FpXSHlvf3@https.bugzilla.kernel.org/>
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

Jerick Fischer (almaza24map@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |almaza24map@gmail.com

--- Comment #9 from Jerick Fischer (almaza24map@gmail.com) ---
Is there a solution to this already? I hope this will be solved soon.=20


RJ | https://www.sanantoniotruckingpros.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
