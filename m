Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE86C25B0E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 16:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbiHPQLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 12:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236483AbiHPQKs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 12:10:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A9624959
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 09:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26B5BB81A58
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 16:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8CC6C43148
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 16:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660666226;
        bh=GuaFkLfIirFDOeKFxx/8FJzS33UVUYRj2+4WUPvm7Yo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YkNJ8BdC8xiOVi6SYkHS2oGI0qmq+RckKUDcVbC5LDnjeKaxOqgR2m4glEfFPgiIZ
         T2x2rgbLQbk0ZTsPCwR2P4kDI7kT/QbApIxYjE1/dqvoyP+Dv+tQzNMCSac/9euCdq
         5r8sg2WiWVOpbQ7jsbABqi5uMoRzBDp6ZZdzNml4funT5Y0StgP2CJmZT6fPYBvAhF
         eapsOG/B7Qg9ScWCSqPSAe0gKUCSNL9Dj6xkzvFYdZu9NSarVDrQboNXCzJGz06iJB
         iUA108Aur4jVF6DpU1/bKsXleCQRj+l1M+SfeF3SLaRxIAEaPRYYyYuVSkjkLByr22
         vmv/NN1lIDgqQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C956FC433E9; Tue, 16 Aug 2022 16:10:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Tue, 16 Aug 2022 16:10:26 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-Sr54cY9dOr@https.bugzilla.kernel.org/>
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

--- Comment #33 from Nils (nilsdev@cocosmail.de) ---
(In reply to Bart Van Assche from comment #30)
> I think that commit 88f1669019bd ("scsi: sd: Rework asynchronous resume
> support") got merged in Linus' tree (kernel v6.0-rc1) about two days ago.

Great, thanks.  Looking forward to testing it once my distributor ships it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
