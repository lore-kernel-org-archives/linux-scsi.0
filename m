Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582DDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Oct 2022 00:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiJGAKy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 20:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiJGAKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 20:10:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2C2C2C80
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 17:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 549F8B821E3
        for <linux-scsi@vger.kernel.org>; Fri,  7 Oct 2022 00:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C1B0C4314A
        for <linux-scsi@vger.kernel.org>; Fri,  7 Oct 2022 00:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665101447;
        bh=6BECf4czkNnpKY02yZJKJZvUmNcQyKkGNSiDDJVIkF4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OGBJghE8XuUTuyIMD+Jkcdu52HTjXChXFOirlZbSlK19VHW8Rntlibw9ZBxlx+xNY
         DZ2Ub4GRVLEI0WaiLfmMxECBskZ+3Tplpg3zM9AgvOLV+wZKF1KzhkurZToc2EWsml
         Jvm1KSD043waOYG2t0OWm7pBhTs8KlsP/PwucKifDzon3xq54gAP/LXoMiZLGRvY01
         H1FO74SfmsMLFVSopPaUHucAS9iuQVYPdPTY4KMmbMxh8f21539atrD4SbHogwB8/A
         81NMHq9DeJyFfehsq3KhEPvi1J3jUP+09pILvCWGLCfJ87jNL232rlys2s/WscoQdt
         yuJN3izFSUgcg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EF875C433E7; Fri,  7 Oct 2022 00:10:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Fri, 07 Oct 2022 00:10:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-IuAZkS5cRM@https.bugzilla.kernel.org/>
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

--- Comment #42 from Bart Van Assche (bvanassche@acm.org) ---
Has it been considered to use device_link_add() to enforce the order in whi=
ch
devices are resumed?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
