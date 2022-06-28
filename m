Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EA1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 22:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiF1WaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiF1WaJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 18:30:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E18632066
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 15:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BEE9B81E1B
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 22:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD8BEC341D7
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656455405;
        bh=WrSb5+nCOIk1QWm2rK0VHqlSrH48P8ndt2+LdNpu+Bs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WJbqjChuPDzwcPm3/3kvn58c/L4J6Ykg7LuClKWqEN3fT7U2cpYTdDzMmeMx8wkvB
         wQWQNKmAVF7MEBpjlwJgF3BfClSv1XOXXDv0rSiN/u9Av4x3ML33Io0xs1dAbCJED7
         ZRpBFj5p5XXttax1aHaHVNhODETviynxITVc2L0NFSV77J1+XQqdLbqtpwJqI40y6U
         nqjsCOxj4RSnYBE1ZCsRy3dNPEtZDXko91UK9wTnoa3zrJ5KHzZJSwk/0S0KNvESYQ
         Ih0RbrsJlIHC5/eP8qRyZf87mUFvy9WmZ+/ejjjAxiRIWa9QYooRvDcosJ437Oz4or
         V2CZW5ku130Bg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id ABCD1CC13B5; Tue, 28 Jun 2022 22:30:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Tue, 28 Jun 2022 22:30:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-mPWAHkQy1a@https.bugzilla.kernel.org/>
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

--- Comment #27 from Bart Van Assche (bvanassche@acm.org) ---
Thanks for testing! The patches from the sd-resume branch have been posted =
on
the linux-scsi mailing list. See also
https://lore.kernel.org/linux-scsi/20220628222131.14780-1-bvanassche@acm.or=
g/T/#t

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
