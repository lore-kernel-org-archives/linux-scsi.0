Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21358C25B0E
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 11:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbiHOLDg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 07:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242549AbiHOLCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 07:02:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F69248C4
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 04:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 168A5B80DF0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 11:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE8D8C4314B
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 11:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660561370;
        bh=yiOH+D9DZdhskd/SqqJPiYIYUqrsDrKAAHHSarns9qc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fHH8Hg7G+pmCpUmmmW+El/Jkt3FUu7Opx1N2u7vE9u2vteZdQ4m/75TQpwIaTbDAp
         A4k+O9Mcf+mKRjSGyNZ0qZfXkzTU4hlKPkBD+uRecFbUAnQc5lHAgxo3DsQu99p73M
         1/WL4ao6wH7zcdEcCsYwqorNXYqtpCSza2qadFfHkmnuz2EDM6uocSJyWgHfxL00oE
         tj5kQHCnNkOOSv43QCh9NqFjAso+OYoZXdRdPI63n393IWZyf3WNfnwaJGTHjyFXfM
         KXg3tWIljxfI9mq6IDwRfpVP8bE59eMbWeMK7hag/nd4GlWNCuML2HIwqgGlQKo6FJ
         HyKyNSykIqxtw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BEAB2C433E9; Mon, 15 Aug 2022 11:02:50 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 15 Aug 2022 11:02:50 +0000
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
Message-ID: <bug-215880-11613-fVuebENsRg@https.bugzilla.kernel.org/>
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

--- Comment #29 from Nils (nilsdev@cocosmail.de) ---
(In reply to Bart Van Assche from comment #27)
> Thanks for testing! The patches from the sd-resume branch have been posted
> on the linux-scsi mailing list. See also
> https://lore.kernel.org/linux-scsi/20220628222131.14780-1-bvanassche@acm.=
org/
> T/#t

When will the changes be merged into mainline please?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
