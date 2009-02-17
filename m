From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12733] mpt fusion driver crashes with LSI22320SE installed and BIOS ACPI turned off
Date: Tue, 17 Feb 2009 15:40:24 -0800 (PST)
Message-ID: <20090217234024.35389108040@picon.linux-foundation.org>
References: <bug-12733-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbZBQXk4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 18:40:56 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1HNeO2w028559
	for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2009 15:40:25 -0800
In-Reply-To: <bug-12733-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12733





------- Comment #2 from mvolaski@aecom.yu.edu  2009-02-17 15:40 -------
With an LSI 8704ELP and LSI SAS3081E-R present and ACPI off, the board works
fine. Only the presence of an LSI 22320 causes a crash. 

I don't know about the interrupt number. When I receive the cards back, I can
can try to find out.

Our vendor has tested at least one other manufacturer's board with the LSI
22320 and it, too, shows the same crashing behavior when ACPI is turned off.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
