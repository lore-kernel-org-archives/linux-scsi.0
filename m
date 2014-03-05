From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Wed, 05 Mar 2014 15:56:21 +0000
Message-ID: <bug-71231-11613-SC2d6dwSub@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36693 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700AbaCEP4Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 10:56:24 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5BA892020F
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2014 15:56:23 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DDB5520256
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2014 15:56:21 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #7 from Alex <alexandernaumann@gmx.de> ---
ea461abf61753b4b79e625a7c20650105b990f21 is the first bad commit
commit ea461abf61753b4b79e625a7c20650105b990f21
Author: Gavin Shan <shangw@linux.vnet.ibm.com>
Date:   Wed Jun 5 15:34:02 2013 +0800

    powerpc/eeh: Fix fetching bus for single-dev-PE

    While running Linux as guest on top of phyp, we possiblly have
    PE that includes single PCI device. However, we didn't return
    its PCI bus correctly and it leads to failure on recovery from
    EEH errors for single-dev-PE. The patch fixes the issue.

    Cc: <stable@vger.kernel.org> # v3.7+
    Cc: Steve Best <sbest@us.ibm.com>
    Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

:040000 040000 8af694ef3a1cc027bef45c99ec9a5592a501e31d
6b6f5b9268e71c63a46385d273656b2419645502 M    arch

-- 
You are receiving this mail because:
You are the assignee for the bug.
