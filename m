Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D25C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 06:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJCGkM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 02:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJCGkK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 02:40:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8369662E7
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2022 23:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7294860F5F
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 06:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2F73C433D6
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 06:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664779205;
        bh=CHd79w2ztyIuy2EVR7R4Ukeb6HhpXggmnre1jU8z7Uk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZKVEBytsDNupabmbg/QoAyZ3p1WZKBwjy6tuhqQ/ZtEPT7chSCIA4gHKN31uEHGc0
         5HR9Ug+V5SWcByDtcZOT3FksYM4JV+l6lsUqccbFsP53IrrJv6Td82KzqX0poHTrY/
         xQhwRPuZevraQVZVYd2BzjWEjeeV0cwqz6hkljhtLIcY3yUDP4Bzifu6nfJufFZf4W
         M5/bhdA7VG43lF2SJFQo9rpE0pYeEJflcfZ8yRobGTZJamgCoXK3WmqDrTG1q5Kvr/
         b/aFGmvSAnooiegB2PLrrlu2Fl/NuzNiSLDFg7mG6PKW6SL0+gshVJtGUtrqVhcU5H
         R5VAoZO0F7fbg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C17CCC433E4; Mon,  3 Oct 2022 06:40:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214311] megaraid_sas - no disks detected
Date:   Mon, 03 Oct 2022 06:40:05 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: jaikumar.sharma@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214311-11613-teutCbNOwL@https.bugzilla.kernel.org/>
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

--- Comment #4 from Sharma, Jaikumar (jaikumar.sharma@gmail.com) ---
Hi,

In fact this bug is blocker for us with respect to bug tracker
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D992304 , is there any
workaround available for this or an early fix is anticipated?=20

Regards,
Jaikumar

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
