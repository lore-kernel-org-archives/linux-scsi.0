Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B96C2B9F4
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 08:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76C96120A
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 08:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhFSI4F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Jun 2021 04:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhFSI4F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Jun 2021 04:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B52726120A
        for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2021 08:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624092834;
        bh=gpdirEqnOaUxZa19Mj5iTRiIs7/oX6vBBNnPpSOQi30=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kjC6zcvUB0BBrTlVe+7VFu4MSWZaQgtR1dlc19bahvJmK2X3DdZGDoIi7nCmK+Cm9
         6Zu0jwQGo/3pLLVNNJLBe8GsB6aPEbZNKR1zyHuIxwSYz1EHfUBQ8eI1qHKv25ZQX4
         ru2nBXkfyzut/nFwIzk4J56MLOwGW3iThNxIf1nwLDPPMt4qrdJbURSjK+yfSsMZi2
         J9jHbx2rA53mn4ECIEp7WoQJBmpOTEoHNtz/uT+6StO29TUNU9b4AzI5y0EubzS0QE
         ocdUScEBwAXBkNbzIuz8r3ojW/Jsjn6FUKmpfVnmEyzOiw1wX5KcXn+Ce3jkU/wph3
         atnPq+WRiiF5w==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 201953] System freeze/hang during shutdown/restart (at " sd
 0:0:0:0:  [sda] Stopping disk")
Date:   Sat, 19 Jun 2021 08:53:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: svv75@mail.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-201953-11613-IWiWEx1sOQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201953-11613@https.bugzilla.kernel.org/>
References: <bug-201953-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201953

Vladimir (svv75@mail.ru) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |svv75@mail.ru

--- Comment #1 from Vladimir (svv75@mail.ru) ---
I have the same problem. Shutdown gets stuck on "stopping disk". Kernel ver=
sion
4.19.80

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
