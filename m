Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D9BEE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 08:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbjIKIT7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 04:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjIKIT5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 04:19:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368F112B
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 01:19:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 984B2C43397
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 08:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694420392;
        bh=HFkERxst0xES4mQ2PiKbJWmKE9t4fq96S8YsywSlSYA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JMa/sK/YeE3ReLwEZYVlLx8TFOSqE3DanwimMfdcrPCcNwqyHIc3kfKM2APssDJ6j
         BT+QexNnWqkixIB4Az6CCxhIE6Q1WAIjeVzl+aOmq7EY0wnoL+vwM/MQkJEtCYH0B1
         ArcFjsw5Dl5tDQFW7Z+gEqMWUpvVEo3u4l6ASFmdY2hOBdgK/mqBR736Gygeyg2+Ck
         NAnUrQMD4ganwxsOHL+aJm2FlXPWD8FVrUDpA93CgRtyIveSX4OPOY/rTCyUdMs7Ji
         fZSN1/tmOTRFzEVe+zjQiJsPX9A8x6pIpVF/c9SvX56gmHsrN9y9Cp+UpCeblzPAhb
         C3bVPeqQCCd0g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 86BC3C53BCD; Mon, 11 Sep 2023 08:19:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Mon, 11 Sep 2023 08:19:52 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215943-11613-JlVE94dGE4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215943-11613@https.bugzilla.kernel.org/>
References: <bug-215943-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215943

--- Comment #12 from Roland Kletzing (devzero@web.de) ---
that's an array-out-of-bounds issue, yes. but it doesn't look that it's rel=
ated
to megaraid issue, reported in this ticket.=20

guess you googled for array-out-of-bounds and found this one.

ubsan is generic infrastructure for improving code/kernel quality:

https://www.kernel.org/doc/html/v4.19/dev-tools/ubsan.html

so, please post bugreport with proper assignment/subsystem

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
