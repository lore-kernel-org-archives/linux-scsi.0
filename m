Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6885DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 20:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357221AbiASUIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 15:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiASUIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 15:08:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728A3C061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 12:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FFE061718
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 20:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74591C340E8
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 20:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642622880;
        bh=2Chbb0DmRgw4WJbawqvYhfzrXJYNQ4AU2rr2qGq3ytI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fCkFW+HuQLMoaGVnLnKnwQLtHGPvX+UK5mDedAaJ5EvzRKmTfn3MExF6qvRWbgUTE
         ZTJfuPHA/V7O+0hb8mqbSetOidQL1w9AtfHZSofWMxOc1JEAXa86NM6nP88pfH2QuJ
         kuTid76ETvKBJ9Wrx4erdsA1ygshKddsknDVhbbRAajPgVuON4qvQuyx77aKVfWT8P
         84BUBraYNl5uZIIl9I/PYyMQP2ScqPFkhl+nw2XbudUvLHhxkbFbu4yEJgI8U/DwRQ
         Rz8w+fD++p2dIg/UOwzLqt+8DKLvachxOUL1ijFI6VvDpQep2HQnDrSNHJXvknSOQx
         qUn3JxjjkiCjw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5BD60CC13A7; Wed, 19 Jan 2022 20:08:00 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Wed, 19 Jan 2022 20:07:59 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-215353-11613-BxapdZfgf6@https.bugzilla.kernel.org/>
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

--- Comment #4 from Rich Reamer (richr410@yahoo.com) ---
Created attachment 300290
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300290&action=3Dedit
boot failure

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
