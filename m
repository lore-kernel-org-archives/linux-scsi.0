Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2976C2B9F4
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 10:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76FBF601FD
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 10:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhFSKNI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Jun 2021 06:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhFSKNI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Jun 2021 06:13:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 64907611ED
        for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2021 10:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624097457;
        bh=wXgAspR/5EBib+GZxqgs4hmNFP+1he6WmVg6/rFTgj0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EJfTFBZbm6qQrBfXGUUyIPFuMa+R3BWrGTEhMur2hsmTRZjJm4G959Pz15r+cHXCN
         gbOo20W59nbWbzXJRAmE6CTfR33xVHUjWggnTWQglJ0UId51CTi1+GgE51PlH7PzgH
         Wv+RpcICiGXpIVTKopvC3Zrsn3eGXJzVbOabak8ocoBYbg8Fevp1d0mMoi7oJxLeju
         XZi5DBkvqhAZ/Q6uLFKslJb8MwgCCYFOH1Gn+WSZDIzORtIf1fRTNRYTPYwMfXOrkJ
         l6/j1AobzxiIHrmfRvzPO41e/weq+z6NNAhZv7uFdeQeqDnP25ColPf8HGU3j3f6ZI
         IWsF3eCbNwDrQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 201953] System freeze/hang during shutdown/restart (at " sd
 0:0:0:0:  [sda] Stopping disk")
Date:   Sat, 19 Jun 2021 10:10:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sivadasrajan007@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INSUFFICIENT_DATA
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-201953-11613-ZuNSlxOuy3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201953-11613@https.bugzilla.kernel.org/>
References: <bug-201953-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201953

das (sivadasrajan007@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INSUFFICIENT_DATA

--- Comment #2 from das (sivadasrajan007@gmail.com) ---
#I currently may have a solution for this problem.
  It works for me just fine.
##The solution
As i explained above this problem exist in my hp laptop.
Which happened to have an insyde H2O bios.  In the bios settings there is a
setting called **USB3.0 Configuration in Pre-OS** which is by default set to
**Auto**.
The key is to turn this to either **On** or **Off**.=20
###Steps (works for Insyde H20 bios)
 - Enter BIOS=20
 - Go to **System configuration**
 - change the setting **USB3.0 Configuration in Pre-OS** to either **On** or
**Off**
 - Save the settings and reboot.
I only have a sample size of one so i don't know if this will work for all
systems or all scenarios. I saw the same problem on reddit and suggested the
same fix. but the person who was facing the issue had no luck with this .So
your milage may vary.

Apparently the kernel doesn't like it to be set to **Auto**.
AFAICT this comes down more towards the vendor's implementation rather than=
 a
linux bug. So I conclude there is insufficient data to call it a linux bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
