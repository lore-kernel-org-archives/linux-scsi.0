Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17B1C25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 10:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjJZKlV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 06:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjJZKlU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 06:41:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE3119D
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 03:41:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C875BC433C7
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 10:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698316877;
        bh=2Oi5xxNLp9dg5m0npB/97MC4TJh/+W/HHe2PYE9LC0k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IBNstkf72aa9xC7ynLhD+Hd/wyDGK0nY6Tx6XdLmQLrspl8wi7Fb7AfO0otrdCC7P
         Us1nCHis3ZeoX26ysry1QM3zgEBk2wW3OnyoHbjRV3U5nLG41tJBG2VQNAivKIxeef
         ABEyzKsGsf68e1F8md7lrygzBwyinSUdKhSoya5nUGkx5fivvB5XuociJmSkB5yrny
         M+IlPRwBZG3hzhSE3Ho3H6iGwRKyyUVctswAycR6aWsibRwHa0BOUelmo+fZsNuFts
         QiPg9AG//i87Yumw9iCqWzKQp5aLyAWfBxssAzwHIaFIJHPV7PgW1KCl1xrScn6Kcw
         zZ4PFkjysoxAg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A6ED0C53BD0; Thu, 26 Oct 2023 10:41:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 218030] Marvell 88SE6320 SAS controller (mvsas) cannot survive
 ACPI S3 or ACPI S4
Date:   Thu, 26 Oct 2023 10:41:17 +0000
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
Message-ID: <bug-218030-11613-y9PbzYMPCj@https.bugzilla.kernel.org/>
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

--- Comment #3 from Nikolaos Barkas (nickosbarkas@gmail.com) ---
Guys,=20
kernel 6.1.57 suspend/resume works on pm80xx with ata/scsi disks.
It should work on mvsas controllers too.

Regards,
Nikos

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
