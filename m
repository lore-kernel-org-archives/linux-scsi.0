From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Mon, 20 Apr 2015 17:43:34 +0000
Message-ID: <bug-90601-11613-hF4LJuv8Ii@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56839 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbbDTRni (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 13:43:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3CDF92041F
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2015 17:43:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6032D20459
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2015 17:43:35 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #26 from Justin Keogh <kernel.org@v6y.net> ---
Created attachment 174581
  --> https://bugzilla.kernel.org/attachment.cgi?id=174581&action=edit
dmesg for the commit that git bisect landed on, with IOMMU disabled

-- 
You are receiving this mail because:
You are the assignee for the bug.
