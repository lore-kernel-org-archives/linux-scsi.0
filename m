Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D80C001E0
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Oct 2023 11:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjJULYA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Oct 2023 07:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjJULX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Oct 2023 07:23:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B01D66
        for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2023 04:23:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4F0DC433C8
        for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2023 11:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697887436;
        bh=BfW06H1R6Cti4cc5eec1yXAbvMXubpTKG5BPPOsOBCY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=uX9CIHAvoduwoA+o6hpUyeHXPRb4xYphffD5acAFnzu0dJcBw2FKv60iBVLD14JWq
         59CwGd1Xle6SPfQwgOBIf5SFhHHZsCzL7nl5zJ8VIcYeLQx8unSUP2ByTNuB4OwQOE
         skqMjR6lM2JcTfOZyY3+4a66WS4mdGwY6QZ81ceaVVlcNjKZykpMkoauchNZJ9nSVF
         dshX+yQ8PRlhYT0Ld+wFCF9qeKteucvXG94iD0MMq0da3Ks/PCaCo5Dulpc4ESzgo3
         7Z0plpOB+0QwKmu4a0R3HGs6NfxAZKqUk8dFHRJGgZhJmxZxFhG83IJ4ehn6LiWrV6
         slp+i5rLptVBg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A9E7BC53BCD; Sat, 21 Oct 2023 11:23:56 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 218030] Marvell 88SE6320 SAS controller (mvsas) cannot survive
 ACPI S3 or ACPI S4
Date:   Sat, 21 Oct 2023 11:23:56 +0000
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
X-Bugzilla-Changed-Fields: bug_severity
Message-ID: <bug-218030-11613-TTGYKayNGP@https.bugzilla.kernel.org/>
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

Nikolaos Barkas (nickosbarkas@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Severity|normal                      |high

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
