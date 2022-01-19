Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4396C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 23:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344198AbiASXUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 18:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240369AbiASXUU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 18:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9BBC061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 15:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 390BCB81C20
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 23:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFE91C340E8
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 23:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642634417;
        bh=q7Bdzn7XSu+pw2/Y8mCbLgI8rDxF26Z2uEWtgYC5I6o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=a6IlVAcZvdzp40mJWuLW0XSTQnYQRUHnY9EqH9ASgZFkFSIMl8O+RwBegz4fgv+Q5
         N0lis5FZkComgN+lXRwNQk7G0Co5TAocbK2r7It7CeHdq5tWYob+T3FaZQXP+/R4qB
         9g5F/CS1dM2s3FGYlObcBLYhtBEbCPXhFIkqYxOXl6BR2UPHBmqJzaPqN0fNXyzQh4
         DzoMSNiP5TYdEGXwSLT9e0r1d7oweDqN6cP/KlJhwaDVbkGL6eR/NwV8PZaaMDPOsC
         Y36ngBeMYJMdowUX5nbAk6SyS9NauiZlVGlxYhFIQjTA+DONFMEcYKQSrk0QPCDo0g
         FtLjtfHWzyjEA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DDDE8CC13B3; Wed, 19 Jan 2022 23:20:16 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Wed, 19 Jan 2022 23:20:16 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215353-11613-H7H9PUFbai@https.bugzilla.kernel.org/>
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

--- Comment #7 from Rich Reamer (richr410@yahoo.com) ---
Yah, looks like 5.15.13, 5.10.90, 5.4.170, 4.19.224, 4.14.261 and likely ot=
her
current LT kernels have this fix. Now to test, prolly tomorrow; maybe tonig=
ht
excited about the fix!!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
