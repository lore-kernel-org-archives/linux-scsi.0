From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/5] SCSI scanning and removal fixes
Date: Tue, 26 Jul 2005 10:08:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0507260958060.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:8093 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261786AbVGZOIy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 10:08:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

The following series of patches is meant to go on top of the first 
three patches submitted by Mike Anderson back in June.  They address 
numerous errors and omissions in the scanning and device/target removal 
pathways.  Overall they are essentially the same as the changes I proposed 
last month, but reworked to fit into the framework Mike has created and 
broken up into smaller, simpler pieces.

The issues they cover include: missing checks for error returns,
neglecting to acquire the scan_mutex in a scanning pathway, adding private
entry points for situations where a caller already owns the scan_mutex,
badly out-of-date kerneldoc, and safe traversal of the device list during
removal.

Alan Stern

