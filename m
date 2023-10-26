Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E310C25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 13:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbjJZNw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 09:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbjJZNw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 09:52:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18C41B8
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 06:52:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B9CCC433C7
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698328374;
        bh=jo1IdqK1Ca8YuA8Hya2astAUreeqVSnYaFIBnUiC0r4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pUavwuYOYM5QeAghZAlnXtf+isZ0M906zo+cJgcHCgx5ifrGKnxArdbVfiKobK+9z
         npCKCQs9tZF50iUP+uvuP+qFxqe7XfFCjs31yaIXD7M7NNyfDvYLKo4MdDGVNqd5IM
         Da8MrFhQ6A6G2h6LrmbOQcNkrh/5i/mRlPAeony6uJrK3hTQRR3p5adDrdzsFF8DtW
         U6GKUNx9KT9rQ/RBuoxyH1Dg0zl6bjL+16UCMRFap6XtDs/qnqt9UgPCtIKGJfNqkE
         xfItcekBhZ8gm666Z+2JKy3B0bEQhuHDOcHsrca48B3kJkJCzhVpgtcKh16zSeyUXi
         YCjL+/Kp9FTSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6A49EC53BCD; Thu, 26 Oct 2023 13:52:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 218030] Marvell 88SE6320 SAS controller (mvsas) cannot survive
 ACPI S3 or ACPI S4
Date:   Thu, 26 Oct 2023 13:52:54 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nickosbarkas@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218030-11613-pI9Znx3wMd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218030-11613@https.bugzilla.kernel.org/>
References: <bug-218030-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D218030

--- Comment #4 from Nikolaos Barkas (nickosbarkas@gmail.com) ---
Hello again,
6.6rc7 was unable to resume disks from s3 as expected.
Basically mvsas does not resume the attached devices at all.
The suspend/resume logic was never implemented and nothing happens on resum=
e.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
