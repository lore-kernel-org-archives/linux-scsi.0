Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C78EC8742
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Sep 2023 17:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241042AbjIGRqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbjIGRqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2023 13:46:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AE21FFE
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 10:45:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69D0FC433AB
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694108706;
        bh=pjIhC8CcbrQl47oAyzhMm+OQeAO5yyBOINm86h4K1vE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YmaT35eS4zs+ds4S27mKxdXK+rQ/Do9JlI71+x3dtqfMm520/1IkjoAHMUZL/Jm8C
         hxujiMLblkVcIESBghPlG09SLbRlzLsd+BnpVIvztWgAbIhmrIC8sWEkFO9V9ec1A0
         FlBwkCzIHduHMSt8kDOMLw8siU7rUtRTMlB6lZd53cfl0B8eeFqMLwTqlozM0UOcqG
         UFuMhpPBJ+voTlG9Zondq6nrGHggggS+x2caSpClt2xLnAgr427T391cEcnRq2T+6v
         jpjBO+wDIEPCe9dxXXm+s7H0uwxMTfsbGIIrgc/N5QMhxiEe69QESrFu8kyKgTBt9K
         ixUjabzIC63/w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 56A89C53BD3; Thu,  7 Sep 2023 17:45:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Thu, 07 Sep 2023 17:45:05 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-MOw8JzWBSb@https.bugzilla.kernel.org/>
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

--- Comment #17 from Sagar (sagar.biradar@microchip.com) ---
(In reply to Maokaman from comment #15)
> I have the most recent firmware version:
>=20
> # arcconf getconfig 1 AD | grep 'Model'
>    Controller Model                           : Adaptec ASR81605Z
>=20
> # arcconf getversion 1
> Controllers found: 1
> Controller #1
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Firmware                               : 7.18-0 (33556)
> Staged Firmware                        : 7.18-0 (33556)
> BIOS                                   : 7.18-0 (33556)
> Driver                                 : 1.2-1 (50983)
> Boot Flash                             : 7.18-0 (33556)
> CPLD (Load version/ Flash version)     : 5/ 12
> SEEPROM (Load version/ Flash version)  : 1/ 1
>=20
>=20
> #regzbot ^introduced 9dc704dcc09eae7d21b5da0615eb2ed79278f63e

Hi Maokaman,
Could you please provide additional details on which specific kernel you are
seeing this issue on and the details of the server would also help us?

We tried with 6.4.9 kernel on a 81605 controller and we do not see this iss=
ue
on our setup.
We are trying to understand the environment=20

Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
