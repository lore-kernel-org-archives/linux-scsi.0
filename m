From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9422] Direct manipulation of PCI ROM in drivers/scsi/qla2xxx/qla_init.c
Date: Mon, 22 Sep 2008 14:10:52 -0700 (PDT)
Message-ID: <20080922211052.0D5D0108056@picon.linux-foundation.org>
References: <bug-9422-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbYIVVLW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2008 17:11:22 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8MLAqjt014645
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 14:10:53 -0700
In-Reply-To: <bug-9422-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9422





------- Comment #1 from andrew.vasquez@qlogic.com  2008-09-22 14:10 -------
Sure.  We can queue patches which use pci_disable_rom() for
the next merge window. 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
