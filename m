Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D6DC4727C
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 20:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3795720679
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 20:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgI2UAa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgI2UAa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 16:00:30 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date:   Tue, 29 Sep 2020 20:00:29 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sun.nagarajan@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-209177-11613-WK3porW5m4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209177-11613@https.bugzilla.kernel.org/>
References: <bug-209177-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209177

--- Comment #2 from sun.nagarajan@gmail.com ---
Created attachment 292719
  --> https://bugzilla.kernel.org/attachment.cgi?id=292719&action=edit
Full dmesg with kernel 5.8.12 (dated 20200729)

-- 
You are receiving this mail because:
You are on the CC list for the bug.
