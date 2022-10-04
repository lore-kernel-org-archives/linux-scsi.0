Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439C7C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 12:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJDMzK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 08:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJDMyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 08:54:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62E4642C
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 05:51:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB83FB81A55
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 12:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33873C4347C
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 12:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664887888;
        bh=MDxl1P/1TJyX/N6h9sW+72P1vbmVtpq/VbTVCLsfHIM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LvxowjpIL1EujNDs5mBQZ9Xru6ZBq6V9VfpKGHa33Q8k3yPlDpU7fevHhEnV7AcBf
         911xsCvassWJFQCrJm8MSLKHnKACRFciu8wqqOV/x3DF52/cBAKJqshTvba6g+keel
         2FpYmHZeqph+M4hIOykGkYP3z4msBvFf6eaUmNdW4HjJUQQTSURAZrWZuZKorYWc/r
         R1hsnL/YLDEFIdtoDyuU2QCPecGy7FKp7/ESeX611dyrW4JeI6ajaPEuRvh9Rj8B26
         lsOw2o/2C1A2dZxZMi1iZJ4PxX+hgMSPeewtHWW0WHCiJmrp+8v0d97UD52CgvINPL
         1cKKEHhb4MwQA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0CE94C433E9; Tue,  4 Oct 2022 12:51:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214311] megaraid_sas - no disks detected
Date:   Tue, 04 Oct 2022 12:51:27 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: jaikumar.sharma@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214311-11613-fUcy9mkVV1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214311-11613@https.bugzilla.kernel.org/>
References: <bug-214311-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214311

--- Comment #6 from Sharma, Jaikumar (jaikumar.sharma@gmail.com) ---
But surprisingly, Debian 10 has no issues in terms of disk detection and
installation of OS in headless mode but on Debian 11 it fails?
Debian 10 has 4.19.x kernel and Debian 11 has 5.10.x kernel (which is expos=
ing
this behavior)? Just out of curiosity, what leads to this failure?
So, 5.10 kernel interaction with same RAID controller firmware is suspiciou=
sly
broken?
More clarity on this would lead to issues detection and fixes.
Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
