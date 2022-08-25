Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BDDECAAA2
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 21:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244056AbiHYVt1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 17:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244075AbiHYVtF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 17:49:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FC3B56DC
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 14:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 013BA61B9D
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F81CC433C1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 21:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661464008;
        bh=bRVbOx1rbGO0yyZCuylHvXjjca9S0YaFYT2ivAdROUE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ETsDZOTeoKmhD9p7oQOpNA8nCEm51zWaZI3+jFKPW47cyIoc25K2iQFBnYFHICZWr
         ggU0TQb7GlSXs4ZtLwmoC6WuHNHBOdiLQc8gVVSWTAZ+0XOPXb7rNemMOG/615XBEI
         rdmAaX5Yfm9IJJTS+NLKQ/qJJ2ZgdpIPaB+Y3N708sQFVTJdqGmcGkciuxSFeJut0E
         8CGx0M/x9AnRedBF84BoMFPFI7sj+PzkpFqc+oNCCZtL6LHJPsOe++xeK2lnSWOpTu
         xmUSKgUHQTyjdt0x715IkzreemM8vq7h/AkuIOnANGMG851uDhMDNkqTliSqxI5etY
         Y9vWoUxITWzAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 44B28C433E9; Thu, 25 Aug 2022 21:46:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216413] [BISECT INCLUDED] scsi/sd Rework asynchronous resume
 support breaks S2idle and S3 on several systems
Date:   Thu, 25 Aug 2022 21:46:48 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: todd.e.brandt@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: bvanassche@acm.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216413-11613-73qATrZACh@https.bugzilla.kernel.org/>
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

--- Comment #6 from Todd Brandt (todd.e.brandt@intel.com) ---
(In reply to Bart Van Assche from comment #1)
> A revert for that patch has been posted:
> https://lore.kernel.org/linux-scsi/20220816172638.538734-1-bvanassche@acm.
> org/

When will this make it upstream? In 6.0.0-rc3 hopefully?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
