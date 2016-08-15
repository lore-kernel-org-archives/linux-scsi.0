From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153171] scsi host6: runtime PM trying to activate child device
 host6 but parent (2-2:1.0) is not active
Date: Mon, 15 Aug 2016 19:56:34 +0000
Message-ID: <bug-153171-11613-lKyamUYMwC@https.bugzilla.kernel.org/>
References: <bug-153171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43090 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbcHOT4n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2016 15:56:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3ADFD2035B
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2016 19:56:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 388CA20380
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2016 19:56:35 +0000 (UTC)
In-Reply-To: <bug-153171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153171

--- Comment #1 from Cristian Aravena Romero <caravena@gmail.com> ---
Created attachment 228941
  --> https://bugzilla.kernel.org/attachment.cgi?id=228941&action=edit
lspci -vvnn

-- 
You are receiving this mail because:
You are the assignee for the bug.
