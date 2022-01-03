Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0EAC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 18:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbiACSFm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jan 2022 13:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiACSFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2022 13:05:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23D2C061761
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 10:05:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2C6661154
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 18:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48C3AC36AEF
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 18:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641233140;
        bh=YWSzzoyrm/1G6VTlbFwGTayQVK8UJuEbh1BEzCJVmVg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=au6Mm4c3nKC+ctASk33uL2M8qGFekH5ufPLcGPanNRxKTADIvU+bMzQ6+VTsfo+i1
         fq4tWQwtiMk4B4GsHVefs+XKIRAYGWTQvKG4tuYD5rY0wevyGGb8ugRJMqZKSZvQV2
         ATSZ0+cFPNFNz63A9ROpCxrvkO+rrJPSdKy+1SdK/fLCAA7T3jpV1ktSf20X+1X9H4
         qlEr6jrySSgJ8RVXX5lqMrwXylV3vuXYGOIFdbA4UPzUoJgmNCpTwc/1allWLZdojl
         2tSbl4n6VzzZ/HbXgGh58g8quKT0LvFzT3NIAzgkpNMGrRLo/UOk3ClhaU7FOLyi/a
         1lxJpKm1VWFFQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 39A24C04E57; Mon,  3 Jan 2022 18:05:40 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Mon, 03 Jan 2022 18:05:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cshorler@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-215447-11613-RhQakNYI57@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215447-11613@https.bugzilla.kernel.org/>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215447

--- Comment #3 from Chris Horler (cshorler@googlemail.com) ---
Created attachment 300219
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300219&action=3Dedit
add use_10_for_ms default to sr.c

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
