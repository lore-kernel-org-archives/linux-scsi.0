Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5144DC12002
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 22:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 321C461380
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 22:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhGPWly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 18:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230227AbhGPWlx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jul 2021 18:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55129613E8
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jul 2021 22:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626475138;
        bh=HIjP7ybXFANv5CUWxJ30Yqp0dwihsEOSJ/VCkB97/TM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Z8ylo15A5k0deDXxPIEtIJP8imsBm3BC5RMIn7NK6ZvUpAQtgBQnRTfbD4uce/+ph
         I0NnhUsE1KmVyVJ6eRtG6YQeZF2yNZLO6PNZg6/ikK6U9fcvo6zIGnC9M0gVaHEPbk
         8zHGZh7nDA0qw0amlZ4Cm8Rnma1V3DBRuHDUq8oudYuYtX1fdwc8qo3ZvK9bx+0DLc
         dN80E6TuMfSUIMRgWH+TS89gvSdril3jwJPB2eHUs0s1GEDWedIaEZDZWXyUmjpomg
         u0lG0lx5W8M4asLbKGawTZMQlGvVBS+V7hSyBMzuJgifygB0ZBXDNVk36zN4uWqume
         5r8z1Gb00uMZg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Fri, 16 Jul 2021 22:38:58 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: computerpro_58@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc cf_regression
Message-ID: <bug-213759-11613-D1yRbjuWYl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

computerpro_58@hotmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux-scsi@vger.kernel.org
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
