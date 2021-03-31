Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8A8C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 12:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE7861585
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 12:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbhCaMhz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235447AbhCaMhy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 08:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DBC7861585
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617194273;
        bh=gPnFCCV0XjqPR0d3uxjwdYROIrcNJheb2xgKmq9jsbY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SczjTEyshZmd5M314kwhhSNZkyBKRuuor8RN6HSsCfEys0ALfTMWwSKim5YnZPu+B
         qrZ1B3Mt8fKRbPABe4lvJ2aUE5B/roVhcYNFPMlrWoDqbK/ijgzufVqqGrKrluSPLj
         8ZnpRnpMSvzQg1uyD5HGIwL+PhHOHFNwhA+3gE6l7EgrLxs6xy/IFUtjfVHRbL0FqA
         dQL7xSnreY4ogvyCQ5J+3400n7uMp48cDkE4/jGhgCorwwVTCswrrvsBbjJ96Ee5Zr
         bDplpypBN01dvSb4pq/HXEO8oRIxB8XIevqoVAdkTO3nNJD/OpfbbXQpjgfp+fqJEk
         pbL+TRJX8+9Ug==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 211227] [BISECTED][REGRESSION] Linux 5.10.7 breaks s3 resume on
 opal encrypted ssd
Date:   Wed, 31 Mar 2021 12:37:53 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chriscjsus@yahoo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-211227-11613-WBmD6csaeB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211227-11613@https.bugzilla.kernel.org/>
References: <bug-211227-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211227

chriscjsus@yahoo.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #5 from chriscjsus@yahoo.com ---
Fixed in 5.10.20 and 5.11.3.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
