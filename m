From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10486] kernel 2.6.24  4G FC arrays don't work properly with qla2xxx driver
Date: Mon, 21 Apr 2008 18:35:27 -0700 (PDT)
Message-ID: <20080422013527.2EA1E10805F@picon.linux-foundation.org>
References: <bug-10486-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097AbYDVBg1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 21:36:27 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3M1ZRO8010908
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2008 18:35:28 -0700
In-Reply-To: <bug-10486-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10486





------- Comment #7 from andrew.vasquez@qlogic.com  2008-04-21 18:35 -------
Ok, so in the interim can you provide some datapoints from the 
FC transport tree:

  $ cat /sys/class/fc_host/host*/*
  $ cat /sys/class/fc_remote_ports/rport-*

At least then we could take a look and see if there's some issue
on the FC side (a small glimpse at least).

BTW:  are there any other 'failure' messages in your logs during
driver load time?  Can you provide the logs without error-logging
enabled?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
