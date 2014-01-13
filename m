From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Mon, 13 Jan 2014 19:41:17 +0000
Message-ID: <bug-60644-11613-ZyWlFDR1Es@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41935 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbaAMTlU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jan 2014 14:41:20 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 155A62017A
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2014 19:41:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0C1792015E
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2014 19:41:18 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #40 from Tommy Apel <tommyapeldk@gmail.com> ---
Hello all,

I've actually been playing around with this a bit more and found out that the
PERR and SERR might only hide problem for a while, sustained load over longer
periods (4-5 hours) will still unfold in a crash, I have re-enabled the PERR
and SERR and I'm running with ASPM enabled aswell, but the change that made it
all go away was that to switch encoding on the PCIe to use "Above 4G", now the
thing I noted was aswell that I had changed from using a PCIe2.0 SAS HBA to a
PCIe3.0 SAS HBA and the problem manifested it self only with the latter, anoter
thing to note is that I have mixed PCIe2 and PCIe3 devices with a PCIe3 capable
cpu.

/Tommy

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
