Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75832C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 15:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C24660F9E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 15:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhJNPJT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 11:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234076AbhJNPIR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 11:08:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 28C5460F9E
        for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2021 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634223972;
        bh=5v2R6eNAy55NcYVzJ9b1mbOZA2RIgHWk0I3fq/PNPGQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=D+HMTDP4nmI4jLTDdpVtxibNI8CPhawcSmHK1RfVC3iAYaLEL+VVHcHGPN8iBxDOy
         tljqNY8O/aGQKjcYSd/4U9B/0hCjs4+ks1v20obTtWEQuM+WdhTVrHIpgiHSXA31YU
         eyvoHZPoktoJMk9QV5uE0Fwd7FfJyenafcTkpVCecVrWWbTGGqQGFRGKU81zgsBd+7
         0YuwCGDlsKf9fuTnmsKEbt/7TV22oZXfJXNrdb9WFXEgQ/4a7RUbmnlpq+WeWkyjHe
         GgQWTg8aHVefTuF88Kc0M79P6yBr/UzJYAHP+C758JXGyJJp5JOzuf8XU5KV2PA4GG
         vrIzmFQAwd3pw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214711] Information leak from kernel to user space in
 scsi_ioctl.c
Date:   Thu, 14 Oct 2021 15:06:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bao00065@umn.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-214711-11613-TjRN61mTc4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214711-11613@https.bugzilla.kernel.org/>
References: <bug-214711-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214711

Andrew Bao (bao00065@umn.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Information leakage from    |Information leak from
                   |kernel to user space in     |kernel to user space in
                   |scsi_ioctl.c                |scsi_ioctl.c

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
