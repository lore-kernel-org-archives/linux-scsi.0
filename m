Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47061CCA47D
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 17:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbiFBRJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 13:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236798AbiFBRJR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 13:09:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B082464BD6
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 10:09:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A273B82051
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 17:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1488C3411C
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654189753;
        bh=ECZWxcLosJjf5ayG4p5y2iK3S7H4ELtIppinKVWXw2M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AtnKH3RCZLZvXXUNjkOF9PtG1YZhfdMzU/C6QkNtma5yOUupR9SwnieOl4HTPPapW
         239wzb2A3g1Gtmf20wBLBuO91SjQGvj9rBMQ3Ohyd5mivYxIMeyqSzlZX3BkGVzwq3
         WZIdPUkysYXBYunFKzLMsa39Juy+hV6A/cQlyMq7m/JU1psJsacRRdKOlwywRj2QWB
         swnexShhWopJDKnVCK+s9+DpPlfmSPNrl6xpLfZzUKktWB+YdSvZtjToQRVZydjiJZ
         X0b4UxqCgcOGhvCCEXDmns0RRpMQSjm7iqMvzq35NYqV2NnLLrJaSMMwBkwYKdmFU5
         YWsbisq/0uQHQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D00D1C05FD5; Thu,  2 Jun 2022 17:09:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216059] Scsi host number of Adaptec RAID controller changes
 upon a PCIe hotplug and re-insert
Date:   Thu, 02 Jun 2022 17:09:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216059-11613-OMUJcm0Iyg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216059-11613@https.bugzilla.kernel.org/>
References: <bug-216059-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216059

Sagar (sagar.biradar@microchip.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #2 from Sagar (sagar.biradar@microchip.com) ---
This issue can be ignored. I have filed another BZ instead. . .

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
