Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2363FC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 07:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbiDGHND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 03:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241643AbiDGHMo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 03:12:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734321116C
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 00:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B16A61DCB
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 07:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 446B8C385A8
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 07:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649315445;
        bh=oSVp2HeORHVX5IwH8AZZA8rmQRuE56vYDMGeF2ErcKM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WiL+IKyi2fhQomTjJ8mkFBlmx4UUPQn8JNoBJKaCQonQJ2EL/RxnJ0zsal9eviF41
         TQKKLO4kfmtC3NQAXeLGy/TQwitzlqvToXPhiZyrWVhkNpGZQKqCvmaCBER555k19f
         7LcP6kWwAS9ThmOfjEGVvI4QYmu568iEWxk2q5243SW3oFueWqF57VvWgLLKpg2FHi
         AvM4zKRncr1kTG+frrIxaD9Vn09SD03vK5oCv31t/K56bf11+n6VIxImaURYjha+Ga
         XM8+j8IM+qAWNEIp5aEkTJkg3ZgXmNm4fFXV+4qiMsaTu6C8gCEiW6i0AhOWK7vz1h
         tj1L2TDXGQUcg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0C6F1CAC6E2; Thu,  7 Apr 2022 07:10:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Thu, 07 Apr 2022 07:10:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jernej-bugzilla.kernel@ena.si
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-hW858ssuEw@https.bugzilla.kernel.org/>
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

--- Comment #12 from Jernej Simon=C4=8Di=C4=8D (jernej-bugzilla.kernel@ena.=
si) ---
Re firmware: both controllers are EOL by manufacturer and are running the l=
ast
released firmware (1.49 for ARC-1280ML, 1.51 for ARC-1212).

5.18/discovery seems to work fine (I can see the volume and partitions on i=
t).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
