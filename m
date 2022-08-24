Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304AEC3F6B0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Aug 2022 20:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbiHXU0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Aug 2022 16:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240367AbiHXU0N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2022 16:26:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945A54D248
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2022 13:26:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DBD2B826AB
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2022 20:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 236EAC433B5
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2022 20:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661372770;
        bh=X056kOpWC/1rh9IapfKxtSovCXfR3bD94ONZ8puC9io=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=j4yGhauJejCaQrzsVQxeeIguYra0B/gGhQBd+qhqvK36iNabCc7PLBAAiYwT9eK42
         3v8Nhdbc2XvGkNsiq965nKhrIg9RB64c2OOln6hOUj4xDXUmUALJdJaDbQDsr1oOO+
         Oxa4T35m4C44HokzOy/hZi2zcb0MHCcC1O55XZ3XLbyzebllGWBKNvSIfRDKv55pZ9
         KVBiHaYPTaoUUtCGTTNreFAI/bn/rONhWxzGBwqjjPYZKt5Dgjx2ubUO7rmquJDdqN
         lgHukrzWOTc2sAkNl6a+oEPhcL07QKaF2DnXNUmqtgmpYfp+rIzG1tlqIwKxpP9jZL
         teJlvrfakhRUg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 07451C433E4; Wed, 24 Aug 2022 20:26:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Wed, 24 Aug 2022 20:26:09 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: gustavo@embeddedor.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215943-11613-ESPBwwtqAZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215943-11613@https.bugzilla.kernel.org/>
References: <bug-215943-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215943

--- Comment #8 from Gustavo A. R. Silva (gustavo@embeddedor.com) ---

(In reply to Gustavo A. R. Silva from comment #7)
> V3 and, hopefully, the final one. :)=20
>=20
> https://lore.kernel.org/linux-hardening/cover.1660592640.git.
> gustavoars@kernel.org/

JFYI this patch series has been taken by the scsi/megaraid/ maintainers:

https://lore.kernel.org/linux-hardening/yq1k06z8vaw.fsf@ca-mkp.ca.oracle.co=
m/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
