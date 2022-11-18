Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDFCC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 00:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbiKRAm1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 19:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbiKRAm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 19:42:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D13774AAD
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 16:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23FF5B8225B
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 00:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA6C1C433D7
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 00:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668732142;
        bh=wu/f2n7/x//lSLkQns+p/yPNB6zTjhtoAfn62UQYYr8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=k8H2ThtURDZma35mOawtzyF6OsS78nlmiYlH6eRiWBcBO51GYoBGT9m/paQsCfHwy
         PFvmASwLVOc+7cYM6soIeLuN+m3c9suo9An+6vrsstdpX8apYBUMESzlKv5xXRaAPt
         xC1gZDyB2uGWJJ7idWXQC+AT/h2u2BdOwMU5JhRoMP1IVf4xbolcjoKzDwuW3kosNQ
         LIyvf//icRKpPNsSbV6cQ9Q+mxyAZPZKr/lYd5yiId14aV8VnmZahuA4rVQxv4kZHW
         1ljWYmClP06r4BdwZAH9LyBFwTddHU4aluqMi9/vyW3cKLAGECEvVpIxCGoyI7/FXX
         zuuhjPSueFFBA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B5942C433E6; Fri, 18 Nov 2022 00:42:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216696] Linux unusable upon plugging encrypted SanDisk Extreme
 55AE USB 3.0 SSD, causes xHCI controller crash and drops USB keyboard/mouse
Date:   Fri, 18 Nov 2022 00:42:22 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: mario.limonciello@amd.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216696-11613-oXVZd03w9C@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216696-11613@https.bugzilla.kernel.org/>
References: <bug-216696-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216696

--- Comment #3 from Mario Limonciello (AMD) (mario.limonciello@amd.com) ---
I don't think that proves it to be an AMD IOMMU bug.  It could be an ACPI I=
VRS
table (BIOS) issue or a driver bug.
Can we see the whole dmesg with iommu=3Dpt?  Besides keyboard and mouse, wh=
at
happens to the other USB device now?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
