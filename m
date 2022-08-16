Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD43C25B0E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 15:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiHPPtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 11:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbiHPPsk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 11:48:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8165895C6
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 08:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F0DB81A84
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 15:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C0CAC43149
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660664700;
        bh=oIe+xdL3Usl4/FRQM1imTjiVN7r8zATAXMpm/yD7j0Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PHTanIJnLfrUQWx8rnUm27bAq2DSU+/zamuJECuSb9TF+QayVNQoPjTm6MrTv/IeA
         GkfdUQg/Zm0HWiSKJfhPhHSXH86piITrCrzXW8fwRvBOPH8ra0P7Ak2d5Xb27Hk023
         xEEFWaxVqi40NV8+Fttya+oPevut2J2Ov+SxlTVgjuso+Xz6BzP0cBwfrG4IcIpSlV
         L80JN6+y/Xbf4Ljc6dgKUryOL9SiFKRh12K5S/4LIwMY7QYsZ2GwZNWFGagcHOTRKF
         Y5kxJ2A/NylEXajU62L/VGhDqU3UEH+cER9sGVqEQyYFVXCsNcb+fndxBQ9eGZFPj/
         5+vkelP2f/NVQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4CEEAC433E6; Tue, 16 Aug 2022 15:45:00 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Tue, 16 Aug 2022 15:44:59 +0000
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
Message-ID: <bug-215880-11613-AbSmvjrSyF@https.bugzilla.kernel.org/>
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

--- Comment #32 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to gzhqyz from comment #31)
> Hi, on my laptop (500GB SATA HDD, Disk model: WDC WD5000LPVX-2), commit
> 88f1669019bd cause system hang after resume from suspend and reverting the
> commit fixes my problem.

Can you try kernel 6.0-rc1 ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
