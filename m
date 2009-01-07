From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12222] kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Wed,  7 Jan 2009 07:08:16 -0800 (PST)
Message-ID: <20090107150816.B6D45108040@picon.linux-foundation.org>
References: <bug-12222-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbZAGPJE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2009 10:09:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n07F8GDY003853
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jan 2009 07:08:18 -0800
In-Reply-To: <bug-12222-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12222


dwmw2@infradead.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|linux-scsi@vger.kernel.org  |dwmw2@infradead.org
             Status|NEW                         |ASSIGNED




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
