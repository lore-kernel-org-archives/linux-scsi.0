Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AB8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 18:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiDFSHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbiDFSGy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 14:06:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB30E10FAED
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 09:43:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F9C26174B
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 16:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88850C385A6
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 16:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649263394;
        bh=BmD1+qxma4zQmCY7oJFJnHh3oTxT8i7YVF2PrPWrSb8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qiUa00nXipNYOSZoUqKcYKVhm2/eklZOjJDqasM64b0+8sOj+aS3ZwwZKi0+rELXK
         RUnN9rnOfH5HsEdTOX6M8di0WITVctNFJyPOOdn2b32g8iF1WRmne8DrELkDVxdp+f
         lwfUi8TD651B+UdNAs9G1NjgnLLSd6GHCqFZzMSfcOXNcxx7GSROjKsxVISGYseO0l
         qtPBz7gS4gId4kKtHtgZyhWbjUmkdT503xJYHFsLpUuJz1jK7636MJEYxChk1OiSB8
         EcKn7XZoQSBvYaGMLPg4abI0g4zyPl37JATegOPd4eiACYp8wk/q8036AHYSxiCuwh
         ryagpfx+ClAfg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6F038C05FD4; Wed,  6 Apr 2022 16:43:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Wed, 06 Apr 2022 16:43:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jernej-bugzilla.kernel@ena.si
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-51zI98QyWs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215788-11613@https.bugzilla.kernel.org/>
References: <bug-215788-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215788

--- Comment #9 from Jernej Simon=C4=8Di=C4=8D (jernej-bugzilla.kernel@ena.s=
i) ---
Oh, and I forgot to mention, yes, no problems if I comment out that call (d=
id
that yesterday already with 5.17.1 kernel release as a test).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
