Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09749C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 18:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244155AbiBQSSU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 13:18:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244156AbiBQSST (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 13:18:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA78172264
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 10:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C90061A5C
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 18:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0AD0C340EB
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645121883;
        bh=ur5NQlUFVJbzgZ89PU7cXDzD44H/vnaHBFoMHiGUN+Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IQAVYwAZxio7oFGEJr3voC9WScERwFdLODo3sdhieRJ5nhpGjxaBr4ViQ7oI1d4yh
         2z2sVwCS5kFiu86/II1s9fpkdtu3hLEfskjLlLJgqHqI41/Nj10hq/0GifeQ/RNCcw
         bwbR+HH1kXQxyYw9C9AEH5OmA/KfZXwZ+4wDhx94msAdKrE+CVTL8Yu8ZX4wXAbvFt
         S9miEqW3X9dQkri+Qg03KjevORM4y/5WD2ZKJvD0+67jplAGi2T+ckTxdSbK6Q1unX
         reElXm7OGacyK1L/7y8ugREYioFcJTrnktsDHkM+gDnb2MXRK78/QGd53eR+6DdejM
         vk4AIxxDpgGtw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 96C63C05FE2; Thu, 17 Feb 2022 18:18:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 74341] WARNING: CPU: 4 PID: 3686 at fs/sysfs/group.c:216
 sysfs_remove_group
Date:   Thu, 17 Feb 2022 18:18:03 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: casteyde.christian@free.fr
X-Bugzilla-Status: CLOSED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status
Message-ID: <bug-74341-11613-RrLkEPXkkW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-74341-11613@https.bugzilla.kernel.org/>
References: <bug-74341-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D74341

Christian Casteyde (casteyde.christian@free.fr) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
