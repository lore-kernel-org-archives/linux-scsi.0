From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Tue, 14 Oct 2014 16:33:28 +0000
Message-ID: <bug-85151-11613-9DNEgTjxwP@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35025 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbaJNQde (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2014 12:33:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BF00E20154
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2014 16:33:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D429E201EF
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2014 16:33:32 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #14 from Tommy Apel <tommyapeldk@gmail.com> ---
This problem is seen on 3.14.21 aswell with expander discovery failure running
Adaptec firmware 1.2.0 Build 10624

I applied the patch stated above and it fixed the problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
