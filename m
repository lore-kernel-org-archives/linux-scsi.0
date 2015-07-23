From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101841] iommu memory handling cause mmblock devices stop
 working
Date: Thu, 23 Jul 2015 09:31:35 +0000
Message-ID: <bug-101841-11613-Rhi8efiJTC@https.bugzilla.kernel.org/>
References: <bug-101841-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbbGWJbj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jul 2015 05:31:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4FC2820774
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2015 09:31:38 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C929A20776
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2015 09:31:35 +0000 (UTC)
In-Reply-To: <bug-101841-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101841

--- Comment #1 from Ivan <dront78@gmail.com> ---
intel_iommu=off does not help, but switched to 3.14.48 lts and successfully
tranfered all the data without any error

-- 
You are receiving this mail because:
You are the assignee for the bug.
