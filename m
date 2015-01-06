From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Tue, 06 Jan 2015 15:30:33 +0000
Message-ID: <bug-90601-11613-N6ID53BGHa@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56462 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbbAFPai (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2015 10:30:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 58ACB201FB
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2015 15:30:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 667F72021F
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2015 15:30:34 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #6 from merlin@liao.homelinux.org ---
Created attachment 162651
  --> https://bugzilla.kernel.org/attachment.cgi?id=162651&action=edit
backtrace with CONFIG_DMA_API_DEBUG enabled

-- 
You are receiving this mail because:
You are the assignee for the bug.
