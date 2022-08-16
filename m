Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5324C25B0E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 11:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbiHPLk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 07:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiHPLkY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 07:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874BE6DFBD
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 04:08:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B47A46108F
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 11:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EBD2C43148
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 11:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660648135;
        bh=0sCS3J0XelzA9gkld2U4smuENpqOpyvx2LOQ9/1yKHA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PYSw9tv9FUv+VGHT8yG5HlVF8Pr3PjNIkIolEXhJsVORtM3f7UK5XDzMCpyUoikmT
         NPPFF4ww2JaWBZqlR6gfDaecWOim/S3v64eDai5fllw8nirAxrTyUJgE3xJu2IJYOl
         4ut63/RWM17bMSW7sOf29vwMsp5XTFArd7EXJBH35fFOitlTCl0E9XXO2E/VwuTzmG
         y1AtnM/UtJ3WT9q80GWGrYlXK38TKyv1ReEs0qvCAIi2saDbeV84Vzd2WdXMT8rmCI
         be8qv5LWds0IyCdyO5fsPBgHJstBX7hT/BDUjzv/o+ZWUoydwiUGH36NPje5JQ2RL4
         J2MBPcNqxJ+LQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0F0FCC433E9; Tue, 16 Aug 2022 11:08:55 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Tue, 16 Aug 2022 11:08:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: gzhqyz@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215880-11613-p1BChVMLBG@https.bugzilla.kernel.org/>
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

gzhqyz@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |gzhqyz@gmail.com

--- Comment #31 from gzhqyz@gmail.com ---
Hi, on my laptop (500GB SATA HDD, Disk model: WDC WD5000LPVX-2), commit
88f1669019bd cause system hang after resume from suspend and reverting the
commit fixes my problem.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
