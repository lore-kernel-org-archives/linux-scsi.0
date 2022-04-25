Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128F2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 14:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbiDYOUu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 10:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiDYOUt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 10:20:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417B31EEF4
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 07:17:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1306B81815
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 14:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7699C385AB
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650896263;
        bh=ROezhycw6AmsVAZye8YV/E6EIpkIyXqXQlyIMhXEpG4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mRALL7U/YzJkuyIAFKgxqtl16h6uW76unCgoQNfScMYALRuCsiDBhtU3XPBjsKQtI
         m9CiZiN3p/4OBPyRilgONRqddPPe8ETGxjgdmahpbvnQFyR92+5WOXJtU5bMiGcLuX
         UvuWyHHBdTTbShn8QJDgD1T/eOWFqVRv6Xoi4ZUq4ls5zoCVzkoQg+SvchUf4UF1E8
         Ss5BGgZ3SIJwNHldPHoKH3ka4ine7nmnC3ImugKpenC7nIdfmqB8ViTku9CKlvECbd
         gUNbDnM8u9oMH7gG1Yv3iOkdMCfQ8gNJpUO9+8q6Qs08KfIm4T3HoBRnnPjwBDgmw1
         ULHGroze3pGUQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 91268CAC6E2; Mon, 25 Apr 2022 14:17:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Mon, 25 Apr 2022 14:17:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: christophotron@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-bzIzyOAfVC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215788-11613@https.bugzilla.kernel.org/>
References: <bug-215788-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215788

--- Comment #17 from Chris Rodrigues (christophotron@gmail.com) ---
Damien, thanks but I already decided Tumbleweed wasn't for me and I install=
ed
the stable version Leap 15.3 with the 5.3 kernel and all is well.  So I won=
't
be able to test the 5.18 patch.

Also, I will mention that the "device not ready" errors were completely
unrelated to arcmsr.  They're still happening and cause slower boot time, b=
ut
that's a separate issue with my system I still haven't figured out.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
