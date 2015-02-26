From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Thu, 26 Feb 2015 05:44:47 +0000
Message-ID: <bug-90601-11613-q1jChMQq1l@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37716 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbbBZFov (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2015 00:44:51 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D0B2320389
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2015 05:44:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2B8092037F
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2015 05:44:48 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #13 from kashyap <kashyap.desai@avagotech.com> ---
My old email id is not working now, so I have to update my email id to new
avagotech domain. Sorry for delay in response.

Does this mean issue does not happen with 3.16.1 
but only happens with 3.17.1 (onwards) ? This is good data point.

Can you share whole dmesg logs for both 3.16.1 and 3.17.1 ?

Also are you using intel_iommu=on in your config ? Can you boot without
enabling Intel IOMMU? 

New logs with ""CONFIG_DMA_API_DEBUG" does not help much. You may have to post
complete logs. We may have some interesting data before crash.

Thanks, Kashyap

-- 
You are receiving this mail because:
You are the assignee for the bug.
