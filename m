Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1ECC2D0E4
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 08:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44899223FB
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 08:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgKOIWM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 03:22:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgKOIWM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Nov 2020 03:22:12 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 210203] linux boot sometimes hang around scsi_try_target_reset
 for a system with SSD/SATA 1.92T *10
Date:   Sun, 15 Nov 2020 08:22:11 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wangyugui@e16-tech.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210203-11613-TsJrzEDIdd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210203-11613@https.bugzilla.kernel.org/>
References: <bug-210203-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210203

--- Comment #2 from wangyugui@e16-tech.com (wangyugui@e16-tech.com) ---
or maybe some problem of megaraid_sas.ko?

This is a Dell PERCH730P(Broadcom / LSI MegaRAID SAS-3 3108 )with the lastest
firmware from Dell.

# modinfo megaraid_sas
filename:      
/lib/modules/5.4.76-1.2.el7.x86_64/kernel/drivers/scsi/megaraid/megaraid_sas.ko.xz
description:    Broadcom MegaRAID SAS Driver
author:         megaraidlinux.pdl@broadcom.com
version:        07.710.50.00-rc1

-- 
You are receiving this mail because:
You are the assignee for the bug.
