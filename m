Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68ACEC8743
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Sep 2023 17:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243847AbjIGRm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245436AbjIGRmx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2023 13:42:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878801FCD
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 10:42:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 636C3C433C8
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 17:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694108495;
        bh=R1nGd7r3OQ1KmM6crFlw2t46s+61/JH6RukTrciydKk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jbc1aHfmiyUmxihzaMMVSif6BxwSxI5pTUNOFcq+c02uST0Cd0LtQbXXoMKxn/NRK
         bPb6AbbNiGr8/lJQOPQb9tk8D304DPySyEdeBM8zxAZY1Si7UpxdO3ocvbFGPHdomF
         aBsUg2+gbWR2LW9WeXWHxcnHXJU4x+PfbPc5H9F3pEz9y8/8apt1qtAw8FWt65w06p
         3eyMOY9O4FquAowzBCZ1WMtiODjXaijxmAMQQc7o83uZ9+S1Ms/FFpQIyftimfMX9t
         bhrZLRGD5sr0WhIVHgI4CYkwZMkXkZwG18Pczx096sbYQkIumma00zEOD5IvRq0KpL
         IVOzb5ycpF/Dg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4F87EC53BC6; Thu,  7 Sep 2023 17:41:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Thu, 07 Sep 2023 17:41:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-zr3S8esx7k@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

Sagar (sagar.biradar@microchip.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aacraid@adaptec.com,
                   |                            |sagar.biradar@microchip.com

--- Comment #16 from Sagar (sagar.biradar@microchip.com) ---
For the problems reported on Series-7 controllers :

At Microchip, we tried to duplicate this issue on 6.4.9 kernel with a 71605=
 and
7805 controllers with the latest FW from adaptec.com (Version 32118) and we=
 do
not see the issue.

Could you please mention what FW version is being used at your configuratio=
n?
The exact server model and the config details would also help us.
Also, could you please try with the latest FW from the website and confirm =
if
you continue to see this issue?

You can pick the latest FW version for the controller model can be download=
ed
at=20
https://storage.microsemi.com/en-us/support/series7/index.php

We look forward to hear your results.

Thanks=20
Sagar

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
