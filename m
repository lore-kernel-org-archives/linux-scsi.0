From: Alan Stern <stern@rowland.harvard.edu>
Subject: BUG in sd.c
Date: Wed, 4 Feb 2004 11:13:50 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0402041108310.6676-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5124 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263244AbUBDQNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2004 11:13:50 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Frank Pieczynski <pieczy@web.de>

The following Bugzilla entry:

http://bugme.osdl.org/show_bug.cgi?id=1986

reports a problem with a USB card reader.  The cause and resolution of
that problem are irrelevant to this list, but the manifestation of the
problem may have been that the device replied with Check Condition (and no
sense data) to every command.

At any rate, this caused an oops as a result of sd.c calling 
scsi_disk_get() after the device's reference count had gone to 0.  Can 
someone look at this and see if sd.c needs to be fixed?

Alan Stern


