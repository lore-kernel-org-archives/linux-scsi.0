Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED39C77B73
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 07:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243001AbjD0HgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 03:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjD0HgL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 03:36:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8879E7
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 00:36:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E5F06325E
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 07:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD7D4C433D2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 07:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682580968;
        bh=f/QXRZtn5DkYLHvdOsoi4yDtrH8Jc/l3yxjpclkaaB0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pNLrj10qo/jeQ3AJjWUSwVt4DKWzMy+0/gKAC2TWChJmAVU381XxADcRKxlU43lE3
         Ep5hdvKoHLttW1H6JrI5GRcWL1fJ5n6IG5m+vb1xxmwxRAzRvtf68f9VY0BNUpoSgt
         KQnkM+P9Ngc1WwCwyAqst9CqOdH8OHku8BoUAte10l6BZkdBZnx0a+jp0nUN+QoBBQ
         14RQPka7dj0JC/RbJ2WwT2KqMq3u8YPn5mxaTN8/UQpBGG1Sio3JWNHBxxsZ4bnODv
         sqURNYDqeccUfCjcotzzRZJFUYhnyh/KCdSi8nLjrapMFgturFPd/gmhK6PvUlYKre
         yCFRQE22NBQSA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AC2E8C43143; Thu, 27 Apr 2023 07:36:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 200801] hpsa 3.4.20-0 driver not loading with HP P420i card
Date:   Thu, 27 Apr 2023 07:36:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: enhancement
X-Bugzilla-Who: toshaan@vantosh.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-200801-11613-S99grJB7Tg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200801-11613@https.bugzilla.kernel.org/>
References: <bug-200801-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D200801

Toshaan Bharvani (toshaan@vantosh.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
