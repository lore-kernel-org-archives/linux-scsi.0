From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Mon, 20 Jan 2014 18:39:38 +0000
Message-ID: <bug-60644-11613-p9NPHbIQ0u@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52838 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaATSjl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jan 2014 13:39:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5FC1C20170
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2014 18:39:40 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8A4652015D
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2014 18:39:39 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #45 from Jeff Johnson <jeff.johnson@aeoncomputing.com> ---
I ran more detailed tests this weekend.

ASPM & MSI disabled = stable machine under zfs load

ASPM disabled / MSI enabled = stable machine under zfs load

ASPM enabled / MSI disabled = unstable, lost an HBA under zfs load


Hardware:
Supermicro X8DTH-iF, BIOS 2.1b (current)
2x Xeon X5670, 48GB DDR3 1333Mhz Reg/ECC
3x LSI 9207-8i, phase 18 firmware
36x Seagate ST32000444SS

It appears to be ASPM and vulnerability to issue may vary by chipset. I know
other motherboards mentioned in this thread have a different chipset. I have
other systems in the field with similar components but with a C206 chipset
based motherboard and these issues are not occurring.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
