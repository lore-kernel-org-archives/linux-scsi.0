Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53B6C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 16:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbiFBQrm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 12:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237255AbiFBQrk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 12:47:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBD311C36
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 09:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C26DAB82042
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 16:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F6CEC385A5
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 16:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654188456;
        bh=SDfnUUWAHwT7p+S9l+ptsKUFn3q0NGh9p3/XFaZESvs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AXqHhoOwd1kEsUQVcJtiPdZSDIeiQ3c4BkLa0h3JzjTwj8L/BoGni/bNEE4a6T9kD
         wUXRAI/zJpy/or5y49qyTDeiwlB1DQ429HDCpIbIn0khBn0t8gl2CbncYyJ225rqLL
         iSkIiJWd/KnQOJvt9sNyN0ijI9JwD/Oz9hpksuHSrBJjAboTrBqcqk89RpUMa3wiyr
         f+y/YOjPiFjMbNvY4ACDGE/2zFhy94xPoFU6IgptGJXvFFmflqlskJBJ8V3phhEZi0
         w85X9dLNBFuCKmIS4JiBuhoyFNpsVT9IIeubEFTAl9yUyCFd53TBOnA1qdoE0uKDU8
         nqM5Ms3fXF8zQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6A2C0CAC6E2; Thu,  2 Jun 2022 16:47:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216059] Scsi host number of Adaptec RAID controller changes
 upon a PCIe hotplug and re-insert
Date:   Thu, 02 Jun 2022 16:47:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjorn@helgaas.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc component assigned_to product
Message-ID: <bug-216059-11613-xKX7KIohMi@https.bugzilla.kernel.org/>
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

Bjorn Helgaas (bjorn@helgaas.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bjorn@helgaas.com
          Component|PCI                         |Other
           Assignee|drivers_pci@kernel-bugs.osd |scsi_drivers-other@kernel-b
                   |l.org                       |ugs.osdl.org
            Product|Drivers                     |SCSI Drivers

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
