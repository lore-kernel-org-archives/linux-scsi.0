Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5FAC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Oct 2022 00:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiJGAPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 20:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiJGAPw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 20:15:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EC93AE7F
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 17:15:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9861261B7A
        for <linux-scsi@vger.kernel.org>; Fri,  7 Oct 2022 00:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C83FC43148
        for <linux-scsi@vger.kernel.org>; Fri,  7 Oct 2022 00:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665101750;
        bh=wUp+om+SJcqvJ7R6eOC4xC+g1t3JkArOY1RZzURKE5M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vF1j9T6FAxx723/urgfZUMSbKmtvNRCOIhqdWiY/TpZ4rgeBvOTqZyvtUw1JSE6dP
         3UNDjrSSY5GDjl5dKFjEyHdyrlH9Cw965L+hkLXh3BfhilVSYTf39VgiUPTvtKbfdf
         bkG72UKbgGK5wGKtAmGMP7p++PfYHjadJWW2yzHoFg8I78hKISBNCQym9Wwx7Tfo9q
         irzwCa78teIx3nXz+6Gwcd5pGSJLg7naMGlR81M9f41bW+F+tIzRJY+mnbrfScof9F
         99KNeEDPRm/1w5daGI1mE9Ko45za0h+6uvW2a3ucWLCoBXOpoEQV8IJY/jiO6bpvRt
         ZuIG/ECUJLx6A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F1B63C433E9; Fri,  7 Oct 2022 00:15:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Fri, 07 Oct 2022 00:15:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@opensource.wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-6gNV0RQEcK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

--- Comment #43 from damien.lemoal@opensource.wdc.com ---
On 10/7/22 09:10, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215880
>=20
> --- Comment #42 from Bart Van Assche (bvanassche@acm.org) ---
> Has it been considered to use device_link_add() to enforce the order in w=
hich
> devices are resumed?
>=20

I am not very familiar with that API level and pm code in general. So I
cannot say. Will need to look into it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
