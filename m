Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189B1ECAAA3
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 21:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244200AbiHYV4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 17:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244409AbiHYVzt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 17:55:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F364F15A3E
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 14:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 936E861B30
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04603C433B5
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661464547;
        bh=gSIGxP93dcgCzD3r3YTqMxGkylW9uKHA9vcdWec3bRY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JeNwBjVPy7KWGCUypFlxmte6b3wbsRRZUHhS1k5y6YiFmhNa3edtHROvwu8VjhJcU
         HTFj03Nr/QzUbHMc+NSr4BuQPoMopLDuefOE2kCrnVeChvlvBnAw4hUjdRcUlGDfyB
         nhDy0vWpCgiycoEy/W9MaWrAhb4oW3NK0XxrnKE0xy06YForM7cN8XJxawSYmAxl1C
         YT4YfmFmm3E0WB6qzU+1+wvZdAF2FNU84sHBR1uvks+bdjBZNLBZ46vMimBFJym3Pb
         3DA9LsaB0gFBY2iQf56wBaZBEGiTzfnvxEX1+CFGQvNdxUr3mq9/8sQPVmTfh9htsj
         tH+FBdSyKoCUQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E84F4C0422E; Thu, 25 Aug 2022 21:55:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216413] [BISECT INCLUDED] scsi/sd Rework asynchronous resume
 support breaks S2idle and S3 on several systems
Date:   Thu, 25 Aug 2022 21:55:46 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: bvanassche@acm.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216413-11613-0dgrrBKzfw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216413-11613@https.bugzilla.kernel.org/>
References: <bug-216413-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216413

--- Comment #7 from Bart Van Assche (bvanassche@acm.org) ---
On 8/25/22 14:46, bugzilla-daemon@kernel.org wrote:
> When will this make it upstream? In 6.0.0-rc3 hopefully?

I'm not sure. This depends on the SCSI maintainer.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
