Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69865C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 20:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244302AbiASUdG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 15:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244262AbiASUdG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 15:33:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DD1C061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 12:33:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9400E61739
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 20:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB157C340E6
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 20:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642624385;
        bh=7Kt0JIBD94UvaSaDB6W71Mbq5oH5jzlHgBJlJSg0XTQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DmVNcwo7td+v2oZNW6Y0vopcJxyXe05dxLqvT7mv+5tK4Gk30t5Qg8aLEwOkmpQ1D
         uGxqGYhlIZowfth9KdPWVR/2I0DnWBTSQYcxYXPrtiFVQBvyPGa3BFuW/455m8P8GU
         0feeTO0RVqL7pPleOYtkD6dmSBb0F0BODgVA3yHf+45cadghcu2aK3e6ORbRGbH+aE
         cZThiMxel3iERYWYlzyozYz5DX1+gsmNNvayzGdcBdjpWDB1s2+piwLB4K3ILB3+J0
         3R4+SndQod855k58G/3kBsGx4TLGG2GOSO3UhKH/lbTfvWC14hVsAochOOz6q5TbWQ
         npbUcNAgOUdkg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CF2F0CC13B3; Wed, 19 Jan 2022 20:33:04 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Wed, 19 Jan 2022 20:33:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richr410@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-215353-11613-5Yv8aWidqg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215353-11613@https.bugzilla.kernel.org/>
References: <bug-215353-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215353

Rich Reamer (richr410@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.4.126+                    |5.4.126+ & 5.13.x+

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
