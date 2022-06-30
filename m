Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C34C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 17:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbiF3RTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 13:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiF3RTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 13:19:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AC137026
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 10:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D245B82CC2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 17:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2D4CC34115
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 17:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656609556;
        bh=09gIhgG7XVPMlxF3lC1kB0xjrTNOLRI3g7mVWsfPX7I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kU0OTtW0p/uXxnLUGB8Ictu0gP62hk1TcTzTEP0BawVHdPRXb25Qpr1yj4e5dDkMP
         2FISBJoEWtsUBI4Or/WKFyMMpbMIrxOZ/uweBAYlNa1XeGRmehcgdQhg32E7h9xkNL
         vZObTxhW63+r3ZxwxCVAaMChuaIJZl8P4iOp2A9dmqqwDj8d0GSeFP+MjdlS/sp7XG
         77Gu/TcGWkKKNamcd1+LJnXgYibojYqKk8FFf/mnTT/LJP5MQgB+zgNXpcFLxs5nrA
         LjJDp8spJemM5Gc7U0bwNFwuhwgEjhKIU5azIlcU5H6AZJgMco5zxLFe/kZouJb0Eb
         5n+6G9Z4l41kg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DCB20C05FF5; Thu, 30 Jun 2022 17:19:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Thu, 30 Jun 2022 17:19:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cshorler@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215447-11613-f6D8ITMHe5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215447-11613@https.bugzilla.kernel.org/>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215447

--- Comment #10 from Chris Horler (cshorler@googlemail.com) ---
any update on this?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
