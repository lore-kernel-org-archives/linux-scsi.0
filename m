From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12730] USB memory stick moved to different device on error / may be due to problem with high concurrent load on two USB devices
Date: Thu, 12 Mar 2009 08:55:28 -0700 (PDT)
Message-ID: <20090312155528.D066A108042@picon.linux-foundation.org>
References: <bug-12730-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbZCLP4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Mar 2009 11:56:20 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2CFtSQK020594
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2009 08:55:49 -0700
In-Reply-To: <bug-12730-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12730





------- Comment #4 from stern@rowland.harvard.edu  2009-03-12 08:55 -------
A patch was accepted recently which just might have some effect on this
problem:

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-usb/usb-ehci-add-software-retry-for-transaction-errors.patch


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
