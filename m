Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0E1C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jun 2022 04:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiF0EJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 00:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiF0EJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 00:09:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C882BF8
        for <linux-scsi@vger.kernel.org>; Sun, 26 Jun 2022 21:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA301611F2
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 04:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46E85C341D1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 04:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656302947;
        bh=YALdEG7QlShkoJxxd/15AAVvYU4w5UJYhzYZY64KnJQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TcCO1gEuD65k2h4OuLOOJmh0xKatp3udQhgR6DkO39QD2JK2aI2SZUQP5wbJjsviX
         Wdo6J5cRW5TqPGBDIDjTeJMlxlD6PnA5qwYyDQ843Rd4OwANcW0WPiN+lUz9EXMHaU
         aoXvlyDY4mVueE4OeBrJn8LQWcGwMZI8yASG1UZ/hi8lyYQF2QBM0aYMvylOl497hW
         9N4XYLCDzNmblGUzQKhGEhB7uLXd3S0HXmgpb1DfC6PHimlOILkuinHCnB3PYP0NzP
         N2mtCJhVslhYTENVCyNTsZE80mmTnkVmdYeoam0aLfnp24z1SJDvl2/p3dbi3yZFNV
         G6pcwvewaA+Rg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 36F57C05FD2; Mon, 27 Jun 2022 04:09:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 27 Jun 2022 04:09:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rui.zhang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc component rep_platform assigned_to product
Message-ID: <bug-215880-11613-sE4jYCAb2b@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

Zhang Rui (rui.zhang@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rui.zhang@intel.com
          Component|Hibernation/Suspend         |Other
           Hardware|All                         |AMD
           Assignee|rjw@rjwysocki.net           |scsi_drivers-other@kernel-b
                   |                            |ugs.osdl.org
            Product|Power Management            |SCSI Drivers

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
