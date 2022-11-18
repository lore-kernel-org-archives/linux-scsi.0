Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986C8C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 01:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbiKRBCF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 20:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240767AbiKRBBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 20:01:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1274BF46
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 17:01:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66008622D2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 01:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB654C433B5
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 01:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668733311;
        bh=xpwyyiKrrlZYGoLKTi9vhOpis1ekFBsV9zxi15v5xII=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=u8crlXJMARhmsbZK1svXQfuHvo+0AwIjLQRfcjsJ887K0kAFHtMe93je5gqQbF6Ew
         NA9oyXJ3uQGUqyBR/CVBGurK73lFWYhJHImDkRJOK6DEUSUA0U4ljPYrlevBPoJ9tq
         sgH3cIVonDKgMXpGKpA2ul4Zclb6OtSuaG3vU01Vh9BThV/0nB+OQ/vCYzGxVAnDwJ
         7a8duIx6T4dJzfhOy6DTtZMm+vRw69voYH4YPYnEbHNQ1hySw+XgFPEVK6YASVkcLV
         D5XbGApJZw+bn+ORj5GMRghA0cGjqdOcxA2U378duTy+ITgg2R3gYesJFG3lrf1d1y
         c+SldKsWYyOfg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BD2C8C433E9; Fri, 18 Nov 2022 01:01:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216696] Linux unusable upon plugging encrypted SanDisk Extreme
 55AE USB 3.0 SSD, causes xHCI controller crash and drops USB keyboard/mouse
Date:   Fri, 18 Nov 2022 01:01:51 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kylek389@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216696-11613-SCOnMpgay0@https.bugzilla.kernel.org/>
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

--- Comment #5 from Kamil Kaminski (kylek389@gmail.com) ---
Created attachment 303203
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303203&action=3Dedit
dmesg B550 mobo

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
