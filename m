From: Alan Stern <stern@rowland.harvard.edu>
Subject: Blacklist flags for SCSI target vs. SCSI LUN
Date: Mon, 20 Feb 2006 14:55:50 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602201445371.28136-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:22028 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S932666AbWBTTzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2006 14:55:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Pat:

If you look in the Linux source file include/scsi/scsi_devinfo.h, you'll
see a bunch of blacklist flags for coping with various sorts of device
behaviors.  In the past these flags have been stored per-LUN, but it's
obvious that some of them should apply to entire targets.  For example,
any flag that influences how LUN detection should be performed is like
this.

I'd like to straighten this out, but I don't know which items should be
per-target and which should be per-LUN.  For that matter, blacklist
entries are accessed based on Vendor and Product identification strings
from INQUIRY data -- and I don't even know whether different LUNs in the 
same target are allowed to supply different Vendor/Product strings.

Can you supply some insight?

Alan Stern

