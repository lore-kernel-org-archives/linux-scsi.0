From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 95101] scsi/mpt2sas: setpci reset results in kernel oops
Date: Thu, 02 Apr 2015 05:58:32 +0000
Message-ID: <bug-95101-11613-qqWgiduLlT@https.bugzilla.kernel.org/>
References: <bug-95101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39852 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbbDBF6h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2015 01:58:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C95E42038D
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2015 05:58:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 30C8920351
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2015 05:58:33 +0000 (UTC)
In-Reply-To: <bug-95101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=95101

--- Comment #2 from Nagarajkumar N <nagarajkumar.narayanan@seagate.com> ---
Created attachment 172971
  --> https://bugzilla.kernel.org/attachment.cgi?id=172971&action=edit
mpt2sas pci resource removal synchronization patch

The attached patch need to applied on latest linux main git branch on
scsi/mpt2sas
The patch provides syncrhonization between cli, brm status show and pci
resource removal path through mutex lock and spinlock protection on linked list
of controllers (multiple warpdrive cards are used) on controller resource
removal and addition

-- 
You are receiving this mail because:
You are on the CC list for the bug.
