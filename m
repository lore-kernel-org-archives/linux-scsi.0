From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Sun, 19 Oct 2014 12:18:59 +0000
Message-ID: <bug-85151-11613-2VbBqlDU95@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41644 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbaJSMTC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Oct 2014 08:19:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 29629201FA
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2014 12:19:01 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 34704201ED
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2014 12:19:00 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #16 from linux-ide@crashplan.pro ---
Created attachment 154171
  --> https://bugzilla.kernel.org/attachment.cgi?id=154171&action=edit
dmesg after first pm80xx patch, having 2 expanders attached in parallel

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
