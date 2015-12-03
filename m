From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108771] scsi: ses: kasan: ses_enclosure_data_process use after
 free on boot SAS2X28
Date: Thu, 03 Dec 2015 14:05:21 +0000
Message-ID: <bug-108771-11613-im7BfrfqaE@https.bugzilla.kernel.org/>
References: <bug-108771-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54210 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbbLCOF1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 09:05:27 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 594E520567
	for <linux-scsi@vger.kernel.org>; Thu,  3 Dec 2015 14:05:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B0E0A204D3
	for <linux-scsi@vger.kernel.org>; Thu,  3 Dec 2015 14:05:21 +0000 (UTC)
In-Reply-To: <bug-108771-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=108771

Pavel Tikhomirov <ptikhomirov@virtuozzo.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Other                       |SCSI
            Product|SCSI Drivers                |IO/Storage

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
