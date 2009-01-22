From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11804] iscsi: LRO plus iSCSI causes panic
Date: Thu, 22 Jan 2009 12:24:46 -0800 (PST)
Message-ID: <20090122202446.780C4108040@picon.linux-foundation.org>
References: <bug-11804-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbZAVUYs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 15:24:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0MKOke8016097
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2009 12:24:47 -0800
In-Reply-To: <bug-11804-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11804





------- Comment #5 from jesse.brandeburg@intel.com  2009-01-22 12:24 -------
also may be able to reproduce using the skb text search functionality (the only
other caller of skb_seq_read)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
