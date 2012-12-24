From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51881] HighPoint RocketRAID 2720 fail to detect some SATA hdd
Date: Mon, 24 Dec 2012 07:22:12 +0000 (UTC)
Message-ID: <20121224072212.B93C811FF02@bugzilla.kernel.org>
References: <bug-51881-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58933 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab2LXHWZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Dec 2012 02:22:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CC565200E1
	for <linux-scsi@vger.kernel.org>; Mon, 24 Dec 2012 07:22:19 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 441B220150
	for <linux-scsi@vger.kernel.org>; Mon, 24 Dec 2012 07:22:14 +0000 (UTC)
In-Reply-To: <bug-51881-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=51881





--- Comment #4 from Shane Huang <shane.huang@amd.com>  2012-12-24 07:22:12 ---
Created an attachment (id=89551)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=89551)
libata: replace sata_settings with devslp_timing

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
