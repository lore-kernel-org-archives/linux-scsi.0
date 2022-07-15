Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603EBC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 18:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiGOSob (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 14:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGOSob (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 14:44:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F3F12750
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 11:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47A4CB82B4B
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 18:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 070E1C341D5
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657910668;
        bh=oxTOM9y9NhJuKToHE5gMxoA2dYJr6PWws0fpaKsL398=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EACJ51dBQlkgK/AwY5E99yxpuPyQU+DdW3jL8T21T43NO2woYFybLEKZ+KmDAOTll
         dIrOLpAKMIjj6Qk7Lcn7ObMcw9CXyTdMTHGJnh0J8nwJ3oXKLazqONjhFULc4p4rFO
         gKFrnRf5Z0AtXxwlI+6rvEA835VrCrQj7PG1oX/1UhsCzrKE7EURMdZrW3kFXuqlHC
         slOq8wdC6G5vIKBYnRbRkSvsI+SXycvXQXKWmYSB37kDMXPj1wTAluwBHHZ2qG5duT
         iYX6DX4T4N0+ktX8eFGx/XQ/nhd/zW7Ob+OoH1JmcCYJP1wqC1lvFegr4j5zWp421n
         bts5OCIZTVOLA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E98F4C05FD6; Fri, 15 Jul 2022 18:44:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Fri, 15 Jul 2022 18:44:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nilsdev@cocosmail.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215880-11613-ekhArT7YgV@https.bugzilla.kernel.org/>
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

Nils (nilsdev@cocosmail.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nilsdev@cocosmail.de

--- Comment #28 from Nils (nilsdev@cocosmail.de) ---
Possibly related:

https://bugzilla.kernel.org/show_bug.cgi?id=3D216087

"Only Toshiba MG08/MG09 SATA hard disks disappear after resume from S3 susp=
end
(reproducible) - AMD Ryzen 5 PRO 4650G"

on an X570 board (0x7901).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
