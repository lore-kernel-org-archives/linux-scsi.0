From: Alan Stern <stern@rowland.harvard.edu>
Subject: INQUIRY timeout value
Date: Fri, 26 Sep 2008 10:17:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809261012490.2277-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60123 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752197AbYIZORw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 10:17:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: kernel@axion.demon.nl

Everyone:

The default timeout for SCSI INQUIRY commands is 5 seconds.  For some 
USB storage devices this isn't long enough.  See for example

	http://bugzilla.kernel.org/show_bug.cgi?id=11640#c6

and the following comments.  Testing shows that Windows XP uses a
timeout of 20 seconds for INQUIRY commands to USB devices.

Is it reasonable to raise the default timeout to 20 seconds?

If it isn't, could we add an LLD-specific timeout value?  Then the 
actual timeout used would be the max of scsi_inq_timeout and the 
LLD's value.

Alan Stern

