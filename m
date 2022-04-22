Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1014EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 04:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352660AbiDVEaT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 00:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiDVEaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 00:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0D813F63
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 21:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9F5861D12
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 04:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FA8FC385A9
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 04:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650601643;
        bh=R2mPiWO0ZSwxi9J/XKKOdfb5gJbrRozzPrNV1lzdcaY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iaUoYvNrFxNtzsKlEJzMFL28SKvnz689P7FkCQAm30zdX7lsK5LsfQswi8SzAoqNZ
         rEX2qdEVgpTbF4f2/TX5tf16egth2Lwcp86423PtpPRSAuGWnlNVP1gvQXrerNrP6B
         4RnagByOdNGovSJBR6/X1DGg/yMF9EdYj5CU2VtXL9h8EOkN4R0UFfjF9zD4OW0tY5
         VU7KvqGkGP5XPFZiSrtsISDOU4vtjiF5HqfQCyHmsV2oVJ9HyVfC2VxDJyg/EUlnHA
         Cc1At0prja87yTga2Wlow75FHRxV0Io9JkmhA2+OucAxYlepK+5Ig1KQlCTUkD9YaK
         0Qv7TnNQShGcA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E8D56CC13AD; Fri, 22 Apr 2022 04:27:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215874] The wifi driver is not there. Not even the network
 driver.
Date:   Fri, 22 Apr 2022 04:27:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: Other
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: other_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status component resolution assigned_to
 product
Message-ID: <bug-215874-11613-wzhsu9Js6v@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215874-11613@https.bugzilla.kernel.org/>
References: <bug-215874-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215874

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
          Component|Other                       |Other
         Resolution|---                         |INVALID
           Assignee|scsi_drivers-other@kernel-b |other_other@kernel-bugs.osd
                   |ugs.osdl.org                |l.org
            Product|SCSI Drivers                |Other

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
