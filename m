Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CC3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 20:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357226AbiASUG5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 15:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiASUG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 15:06:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E838C061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 12:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C59161706
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 20:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F81AC340E5
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642622815;
        bh=DhMIFHfnrMXhWao0+UiHka8POPSzLIFAIYKyi+B37qw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IRSJBhDOJ183XlLBQELGzozHMXSfU94/hBoBbTZnfLy7nT++87iv03A8GuEwJOwJ6
         eC0Sj5QyqZS+MBc9Mau6QrbBd42ETMJyMKA0asyDYR1GPbyoALzncktDtqhXo/SBXr
         DOjLUAvJpJLJky2Wl4xg3HVQ2fGA5FkZkBSzkLj9KJhwAO4OQ/Pw7nPEEu5jLBUxff
         JuBqUtX/YKjM2eOkjZENPPtV7g0QiqK3f1c2sx6mQ5ePDV3WN/zm3IVFgCj/0kRrl0
         JClllvlgbK+yut+k9NqjxCg0ZSarJ29RReYXuN81UUlVfFHlfefDn+dN2YmiquJmUG
         Pn+W/kTFzxArg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7F637CC13B0; Wed, 19 Jan 2022 20:06:55 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Wed, 19 Jan 2022 20:06:55 +0000
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
Message-ID: <bug-215353-11613-RqfRS2EOOE@https.bugzilla.kernel.org/>
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

--- Comment #2 from Rich Reamer (richr410@yahoo.com) ---
Update: Testing with Kernel 5.13.x (specifically 5.13.13) - Still fails to
Pickup LVM partitions on /dev/sda (which is detected) in VMWare.

VM Container Specs: attached in screen print
Where boot stops loading: attached in screen print

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
