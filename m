Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260F6C25B47
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 10:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbjJYKXW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 06:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbjJYKXV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 06:23:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4DE116
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 03:23:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAF89C433CC
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 10:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698229399;
        bh=nLE3ftwJl52un29jf4FMjQe8VWCuWn7tcMw48uAnuTc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vPFFeiwz1viXahEqH4DaSI6CWJqfevaZ0ABLOFlXnk6LJp7/IWbqF/vmmdHvFAL88
         sjMyeoq+upr+NWQ7jjs/wPY+X99HXXeajElNMm7MXCzyihzuEY8rkO/4G+IX2Mjmlo
         FEhkBADyYA01587R4YZx1yl83E12aGr2zcIsxdOOR5lhQXDBnvzy/7TRjk9swbmpbG
         VFRdTP9AVRPzaH3AvNX209f31k3OjAoFaz7kdTOlcb01Z6fVXb+e6g4lGy9uQRvRfg
         tdXwHkeYY3iQ26oDX1EvIrRZ6LtZI4BoGUgqnWe3TdBhENMC1DscEQsEcsQu8ffGBj
         aBqah47NjrVeQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AB961C53BC6; Wed, 25 Oct 2023 10:23:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Wed, 25 Oct 2023 10:23:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: hare@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-1d3v2Wig0k@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #23 from Hannes Reinecke (hare@suse.de) ---
Can you try with the above patch?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
