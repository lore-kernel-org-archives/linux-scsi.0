Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38C2ECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 15:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJaPNd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiJaPNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 11:13:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10D638A
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 08:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DFDF6126B
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFCF1C4347C
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667229209;
        bh=pyUOIZdyeZKZNDxh+P9PJJEb71y4OybURhSzF6Pcy88=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LAXU/fS/agPUGFv3yTgdXOb8WyeumcsX6PZj5cG4QiM8E+kljQV0XNkLDWuR1Eo13
         ztqwtqC58M9ZLY1BMoqFgbkpP6cjyEpqT4YFnuUL1B8TPgEBgchGBmVEZO5YDDPet3
         zRupEG5NG4Ci+MCk6F2n4CxTJO3HGj3GUGjdTVokLC+h4aVSndFiGrTkUhdzZAYWUr
         r1itDRVORscZ48Xqbirbbgg/7u0RqoZbIBOdQtlyE80FRpcRxK2nL/td/Nkmf8YkcH
         a/DJqEETxijPMwIu0M3gA76QooNMJGzGzfOx0NEiZIB1FyZGr1sHEv8GWOhw+E0LjL
         gxDzEEZXcJaTA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A8FB1C433EA; Mon, 31 Oct 2022 15:13:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214311] megaraid_sas - no disks detected
Date:   Mon, 31 Oct 2022 15:13:29 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: rollopack@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214311-11613-ga1BCOEf88@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214311-11613@https.bugzilla.kernel.org/>
References: <bug-214311-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214311

--- Comment #8 from Gabriel Rolland (rollopack@gmail.com) ---
(In reply to Gabriel Rolland from comment #7)
> Same problem with the Dell PowerEdge T140 with LSI MegaRAID SAS-3 3008=20
> [Fury] (rev 02) and linux-image-5.10.0-19-amd64 (NO UEFI)
>=20
> No problem booting with the old 4.19.0-22-amd64 kernel


The problem is still present with linux-image-5.19.11 :-(

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
