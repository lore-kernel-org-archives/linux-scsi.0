Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB52C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 00:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiKRAke (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 19:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiKRAkd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 19:40:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFED74AAA
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 16:40:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48228622CD
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 00:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FCE8C433B5
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 00:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668732031;
        bh=PwCcGnroz4/mmgqO/hb+2LyITv0TMImEMAsHfXRn7uc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sucJMQk8wxl5WDA4F4OyBJ9MDv5FAezFzFQ4o+wNzX93/Y2coM8r1TQFnsYtZGkA/
         RQam6JYlnzTbSJ3hnJNSoJ2VBw1V0Hg/Tc89GghWxy3EJ0o+K0B14qwlVwgkJqoAGu
         6SWRgm2TDJBe2khroaR/U8XnSa7PlrBuQViImwqs5R8tMTQGK52RuHAtcq5fhdbcRl
         Bkd7BkoEVpSxVKm2ko8R3/GeFm2beWkIEnXWuvVzUfjLUSowGrRNcEUaUnwlMDttc7
         LWUixsaSQqoIrz5U78CY6iLl7aJUX5fNbKjkpJhbHxRuBRlmGoYgD8TwjtymviBvgO
         DQoey2Y4goJfA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8927EC433E9; Fri, 18 Nov 2022 00:40:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216696] Linux unusable upon plugging encrypted SanDisk Extreme
 55AE USB 3.0 SSD, causes xHCI controller crash and drops USB keyboard/mouse
Date:   Fri, 18 Nov 2022 00:40:31 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kylek389@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216696-11613-1zCaiKZwiV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216696-11613@https.bugzilla.kernel.org/>
References: <bug-216696-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216696

--- Comment #2 from Kamil Kaminski (kylek389@gmail.com) ---
Hi Mario, it did not cross my mind it could be AMD IOMMU related, adding
iommu=3Dpt to kernel boot line did in fact make things better! My USB keybo=
ard
and mouse are now surviving.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
